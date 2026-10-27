# Waner Voice Chat V1 — Installation/rollback note

Plugin root:

```text
~/.openclaw/extensions/waner-voice-chat
```

OpenClaw config entry:

```json
{
  "plugins": {
    "entries": {
      "waner-voice-chat": {
        "enabled": true,
        "hooks": {
          "allowPromptInjection": true
        }
      }
    }
  }
}
```

If `plugins.allow` already exists, add `waner-voice-chat` to that existing allowlist.

Do not create or modify global TTS auto settings. The plugin depends on the existing explicit `tts` tool permission and the existing Waner emotion router.

Rollback principle:

1. restore the pre-install `openclaw.json` backup;
2. rename/remove `~/.openclaw/extensions/waner-voice-chat`;
3. restart `openclaw-gateway.service`;
4. verify `openclaw infer tts status --json` still reports `auto=off`.
