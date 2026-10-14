# Parsec on Haswell

## Verified decoder configuration

On 2026-10-13 the running Parsec process loaded Intel `i965_drv_video.so`, FFmpeg compatibility `libavcodec.so.58`, and opened `/dev/dri/renderD128`. The most recent decoder-selection log said `FFMPEG 4 Hardware`.

The recorded client preferences were:

```ini
client_decoder_index = 0
client_decoder_h265 = false
client_decoder_10bit = false
client_decoder_444 = false
```

Index 0 corresponds to the working hardware decoder in this installation; enumeration is version-specific. Prefer selecting **Hardware** in Settings → Client. H.264 matches this Haswell GPU; H.265, 10-bit, and 4:4:4 options remain off. No decoder configuration change was needed in this check.

The existing launcher targets i965 for Parsec and retains private compatibility library paths. Do not copy the private launcher, account data, full configuration, or session logs into a public repository.

See the existing [Fedora error -17 repair guide](https://github.com/vitaliebumbu/parsec-error-17-fedora-macbook-fix) for the earlier compatibility repair. Package names there reflect the earlier FFmpeg setup; this workstation now uses full RPM Fusion FFmpeg and still retains compat-ffmpeg4. Do not blindly reinstall conflicting codec packages.

## Remaining stream diagnostics

Historical logs contain repeated `Decoder failure` messages despite hardware decoding being selected. Successful hardware initialization alone does not establish uninterrupted streaming. Inspect current overlay codec, decoder, decode time, queue warnings, and network latency before changing settings.

For a test, use one remote display at 1920x1080 and 30 fps where the host offers these controls, compare against the original stream, and revert if readability or responsiveness suffers. This is a test recommendation, not a setting applied here. Parsec's earlier CPU percentage is cumulative process activity and does not by itself prove software decoding.

References: [Linux client settings](https://support.parsec.app/hc/en-us/articles/32381494397332-Parsec-App-for-Linux), [stream diagnostics](https://support.parsec.app/hc/en-us/articles/32381603663636-Stream-Overlay-Stats-and-Logging).

A 15-second observation found no new decoder-failure messages. Saved metrics were approximately 87 minutes old, so their latency values were not treated as current stream measurements. This short quiet interval does not rule out intermittent failures.
