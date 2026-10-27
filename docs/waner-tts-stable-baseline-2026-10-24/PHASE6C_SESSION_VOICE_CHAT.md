# Phase 6C — Session-scoped Waner Voice Chat

**Freeze date:** 2026-10-27  
**Implementation status:** Plugin V1 installed and runtime-loaded. Final safety gates PASS.

## Goal

Provide a conversation-scoped Waner voice mode without enabling OpenClaw global auto-TTS.

Commands:

```text
/voice-chat on
/voice-chat off
/voice-chat status
```

The mode is keyed by OpenClaw's stable `sessionKey`. It does not use `/tts on` or `/tts chat on`.

## Runtime design

```text
current session
→ /voice-chat on
→ ~/.openclaw/state/waner-voice-chat.json
→ before_prompt_build
→ append voice-chat context only for that session
→ model answers normally
→ built-in tts tool
→ [[waner-emotion:<emotion>]]
→ waner_voice_router_v1.py
→ waner_provider_v3.py
→ GPT-SoVITS
```

Global OpenClaw TTS remains:

```text
enabled=false
auto=off
provider=tts-local-cli
configured=true
```

## Plugin

Installed plugin id:

```text
waner-voice-chat
```

Version:

```text
1.0.0
```

Installed path:

```text
~/.openclaw/extensions/waner-voice-chat/
```

Runtime inspection confirmed:

```text
status=loaded
enabled=true
activated=true
commands=["voice-chat"]
hookCount=2
typedHooks:
  before_prompt_build priority=50
  session_end priority=10
diagnostics=[]
allowPromptInjection=true
```

## Session-state contract

State file:

```text
~/.openclaw/state/waner-voice-chat.json
```

Schema:

```json
{
  "version": 1,
  "sessions": {}
}
```

Safety behavior:

- no `sessionKey` → refuse to enable;
- unreadable/corrupt state → fail closed, voice-chat OFF;
- plugin failure does not change global auto-TTS;
- session reset/new/delete clears stored ON state for that session;
- ordinary text chat remains available if voice synthesis fails.

## Final validated safety state

V3.1:

```text
consecutive_failures=0
circuit_open=false
draining=false
open_for_seconds=0
drain_for_seconds=0
last_error=""
```

OpenClaw:

```text
transport=gateway
enabled=false
auto=off
provider=tts-local-cli
configured=true
```

Voice-chat state file:

```json
{
  "version": 1,
  "sessions": {}
}
```

This proves the final safety state and that no session remained enabled at freeze time.

## Artifact checksums

Bundle:

```text
waner_voice_chat_v1_bundle.zip
SHA-256: e5ed79811dc6a37d0bfe7003b35fcb62fffd96c3f34bf38aff9740dcf6d2c96a
```

Plugin files:

```text
index.js
SHA-256: 01c38a2e27207f72f4bcf789dc97cb6113af1522a504d6e115f55e4c6fc6665b

openclaw.plugin.json
SHA-256: 429bbb069ee5933463c6dc42bcf89af3194e6ff3b2ff0e9fe06977c418b26b1e

package.json
SHA-256: fedbcae4250736c05295adebceb98bdda37248ad34fad304a8c543176c1dc877

install_waner_voice_chat_v1.sh
SHA-256: ad5ccc9b89450718368e7f08c6b4a33a9141b41113529192ede2022622d46783

rollback_waner_voice_chat_v1.sh
SHA-256: 5b0b68c9f2103b3c51b7b78a7391f6c2afaa404224bf641dea94c738f277b9cf
```

## Rollback

The install created a pre-change OpenClaw config backup before enabling the plugin. Rollback restores that backup, disables the plugin directory by renaming it, and restarts the OpenClaw gateway.

## Boundary

This Phase 6C archive records the installed/runtime-loaded plugin and final safety gates. Behavioral listening quality and emotion correctness remain observational acceptance items unless captured in explicit test evidence.
