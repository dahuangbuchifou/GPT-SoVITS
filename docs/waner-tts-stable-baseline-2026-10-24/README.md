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


## Phase 6A / 6B update — 2026-10-26

Conversational voice and dynamic emotion routing are now validated and frozen.

- [Phase 6A / 6B authority note](PHASE6A6B_CONVERSATIONAL_VOICE.md)
- [Voice / emotion workspace policy](VOICE_EMOTION_POLICY.md)
- [Waner emotion router V1](waner_voice_router_v1.py)

Validated safety state remains `auto=off`, with the built-in `tts` tool explicitly added to the existing `coding` tool profile through `alsoAllow`.


## Phase 6C update — 2026-10-27

Session-scoped continuous Waner voice-chat has been implemented and safety-gated.

- [Phase 6C session voice-chat baseline](PHASE6C_SESSION_VOICE_CHAT.md)
- [Voice-chat plugin installation / rollback note](VOICE_CHAT_PLUGIN_INSTALLATION.md)

The design keeps OpenClaw global TTS `auto=off` and scopes voice-chat state by stable `sessionKey`.
