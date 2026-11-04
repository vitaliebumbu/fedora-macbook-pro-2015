#!/usr/bin/env python3
"""Extract Apple's charger chime from a macOS IPSW.

The Apple Silicon "attach chime" is stored in the restore image as
Firmware/embeddedaudioresources/image4/<board>-attach-chime.im4p inside an
IM4P/DER container.  IPSWs are tens of gigabytes, so this range-requests only
the ZIP central directory and that one member.

Board keys are Apple board IDs: j293 (MacBook Pro 13-inch M1), j313 (MacBook
Air M1), j314c/j316c (MacBook Pro 14/16-inch M1 Pro/Max), j413/j493 (MacBook
Air M2), j614c (MacBook Pro 14-inch M3).  The 2-channel boards store the chime
at 24 kHz (Air) or 48 kHz (13-inch Pro); the 6-speaker 14/16-inch boards store
a 6-channel 24 kHz mix of the same 1.88 s sound.  That 48 kHz stereo member is
used here.

Apple's audio is not redistributed by this repository; run this script (or let
install.sh run it) to build the WAV locally.  Requires only the Python
standard library plus network access to Apple's CDN.
"""
from __future__ import annotations

import argparse
import array
import io
import struct
import sys
import urllib.request
import wave

DEFAULT_IPSW = (
    "https://updates.cdn-apple.com/2026FallFCS/"
    "c9671975-52db-4fb5-9af2-00217169ba8d/"
    "UniversalMac_27.2_26B123_Restore.ipsw"
)
BLOCK = 1 << 20


class HttpRangeFile(io.RawIOBase):
    """Minimal seekable read-only file over HTTP range requests."""

    def __init__(self, url: str) -> None:
        req = urllib.request.Request(url, method="HEAD")
        with urllib.request.urlopen(req, timeout=60) as r:
            self.size = int(r.headers["Content-Length"])
        self.url = url
        self.pos = 0
        self._start = 0
        self._buf = b""

    def readable(self) -> bool:
        return True

    def seekable(self) -> bool:
        return True

    def tell(self) -> int:
        return self.pos

    def seek(self, off: int, whence: int = 0) -> int:
        if whence == 0:
            self.pos = off
        elif whence == 1:
            self.pos += off
        else:
            self.pos = self.size + off
        return self.pos

    def _fetch(self, start: int, end: int) -> bytes:
        req = urllib.request.Request(
            self.url, headers={"Range": f"bytes={start}-{end - 1}"}
        )
        with urllib.request.urlopen(req, timeout=120) as r:
            return r.read()

    def read(self, n: int = -1) -> bytes:
        if n is None or n < 0:
            n = self.size - self.pos
        if n <= 0 or self.pos >= self.size:
            return b""
        end = min(self.size, self.pos + n)
        if not (self._start <= self.pos and end <= self._start + len(self._buf)):
            self._start = self.pos
            self._buf = self._fetch(self.pos, min(self.size, self.pos + max(BLOCK, n)))
        off = self.pos - self._start
        data = self._buf[off : off + (end - self.pos)]
        self.pos += len(data)
        return data

    def readinto(self, b) -> int:
        data = self.read(len(b))
        b[: len(data)] = data
        return len(data)


def der_element(buf: bytes, i: int) -> tuple[int, int, int]:
    tag = buf[i]
    i += 1
    length = buf[i]
    i += 1
    if length & 0x80:
        n = length & 0x7F
        length = int.from_bytes(buf[i : i + n], "big")
        i += n
    return tag, length, i


def im4p_payload(blob: bytes) -> bytes:
    """Return the OCTET STRING payload of an IM4P envelope."""
    tag, length, body = der_element(blob, 0)
    if tag != 0x30:
        raise ValueError("not a DER SEQUENCE")
    end = body + length
    while body < end:
        tag, length, data = der_element(blob, body)
        if tag == 0x04:  # OCTET STRING
            return blob[data : data + length]
        body = data + length
    raise ValueError("no payload found")


def apply_gain(pcm: bytes, gain_db: float) -> bytes:
    if gain_db == 0:
        return pcm
    factor = 10.0 ** (gain_db / 20.0)
    samples = array.array("h")
    samples.frombytes(pcm)
    for i, value in enumerate(samples):
        scaled = int(value * factor)
        samples[i] = max(-32768, min(32767, scaled))
    return samples.tobytes()


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--ipsw", default=DEFAULT_IPSW)
    ap.add_argument("--device", default="j293")
    ap.add_argument("--rate", type=int, default=48000)
    ap.add_argument("--channels", type=int, default=2)
    ap.add_argument(
        "--gain-db",
        type=float,
        default=25.5,
        help="peak normalisation applied to the samples (default 25.5 dB, "
        "about -3 dBFS); use 0 to keep Apple's stored level",
    )
    ap.add_argument("--list", action="store_true", help="list chime members and exit")
    ap.add_argument("-o", "--out", default="connect_power.wav")
    args = ap.parse_args()

    import zipfile

    f = HttpRangeFile(args.ipsw)
    print(f"IPSW: {f.size / 1e9:.1f} GB", file=sys.stderr)
    z = zipfile.ZipFile(f)

    names = [n for n in z.namelist() if n.endswith("-attach-chime.im4p")]
    if args.list:
        for n in names:
            print(z.getinfo(n).file_size, n)
        return 0

    want = f"{args.device}-attach-chime.im4p"
    match = next((n for n in names if n.endswith("/" + want)), None)
    if match is None:
        print(f"device {args.device!r} not found; try --list", file=sys.stderr)
        return 1

    print(f"member: {match}", file=sys.stderr)
    payload = im4p_payload(z.read(match))
    magic, length = struct.unpack("<II", payload[:8])
    if magic != 0x1001 or length != len(payload) - 8:
        print(f"warning: unexpected header {magic:#x}/{length}", file=sys.stderr)
    pcm = apply_gain(payload[8:], args.gain_db)

    with wave.open(args.out, "wb") as w:
        w.setnchannels(args.channels)
        w.setsampwidth(2)
        w.setframerate(args.rate)
        w.writeframes(pcm)

    print(
        f"wrote {args.out}: {len(pcm) // (2 * args.channels) / args.rate:.3f}s, "
        f"{args.channels} ch, {args.rate} Hz, gain {args.gain_db:+.1f} dB",
        file=sys.stderr,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
