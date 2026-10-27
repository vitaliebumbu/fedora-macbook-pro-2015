# Parsec fullscreen and aspect ratio

On2026-10-26 verified Parsec already fullscreen, with black bars inside the streamed image. Saved explicit `client_windowed=0` in the existing local config.json settings object after a private backup. Restart required for file configuration; active session was not disconnected. H.264 decoder choices retained.

A16:10 host resolution such as1920x1200 is needed to match the MacBook panel proportions without stretching. Host must support the chosen resolution. No host resolution change was verified: native input automation was unsuccessful. The local Xwayland canvas reported4608x2880 while physical panel is2880x1800, so automatic client-resolution requests should be checked rather than assumed to match panel resolution. Stored metrics were stale and do not establish current stream size. Screenshots/private profiles excluded.

[Parsec advanced settings](https://support.parsec.app/hc/en-us/articles/32381443626516-All-Advanced-Configuration-Options) documents client_windowed and restart requirements. Resolution fields server_resolution_x/y belong on the Windows host, not the Linux client.
