# Waner TTS Stable Baseline — 2026-10-24

Validated GPT-SoVITS × OpenClaw production baseline.

- Phase 5E: OpenClaw on-demand TTS integration — CLOSED
- Phase 5F: Reverse SSH production path and automatic recovery — CLOSED
- Full Windows reboot recovery — PASS
- Normal chat remains text-only (`auto=off`)
- Explicit `/tts audio <text>` uses Waner GPT-SoVITS; failures fall back to Edge TTS

## Production path

```text
OpenClaw
→ tts-local-cli
→ waner_provider_v3.py
→ ECS 127.0.0.1:19890
→ Reverse SSH Tunnel
→ Windows 127.0.0.1:9890
→ GPT-SoVITS 127.0.0.1:9880
```

Cloudflare Tunnel remains for public testing / backup, not the production OpenClaw TTS path.

## Archive contents

- `SOP.md` — authority SOP / handover
- `START_WANER_REVERSE_TUNNEL_V1.template.ps1` — sanitized public supervisor template
- `waner-tts.env.example` — environment template without secrets
- `openclaw-tts-config.example.json` — sanitized OpenClaw config example
- `SHA256SUMS.txt` — checksum manifest

## Security

This repository is public. Never commit bearer tokens, SSH private keys, or the real ECS public IP.
