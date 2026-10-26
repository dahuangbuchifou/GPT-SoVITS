# Workspace Voice / Emotion Policy Snippet

This is the sanitized policy logic used for Phase 6A/6B. It contains no secrets.

## Voice reply policy

- OpenClaw automatic TTS must remain disabled (`auto=off`).
- Ordinary chat replies remain text-only.
- When the user explicitly asks for a voice/audio reply:
  1. understand the request and formulate the actual assistant answer;
  2. call the built-in `tts` tool using the assistant answer as `text`;
  3. do not read the user's question verbatim unless explicitly asked;
  4. do not emit `[[tts:...]]` directives;
  5. do not enable `/tts on`, `/tts chat on`, or global auto-TTS.

## Dynamic emotion routing

When calling the built-in `tts` tool, prepend exactly one internal routing tag to the tool's `text`:

```text
[[waner-emotion:ordinary]]
[[waner-emotion:soft]]
[[waner-emotion:happy]]
[[waner-emotion:calm]]
[[waner-emotion:anxiety]]
```

Selection:

- ordinary: default, technical/work/neutral;
- soft: comfort, care, gentle tone;
- happy: success, congratulations, positive news;
- calm: calm explanation, guidance, de-escalation;
- anxiety: only when the user explicitly asks for anxious/nervous role-play.

Priority:

1. explicit user emotion request;
2. otherwise infer from the assistant answer's semantics;
3. if unclear, use ordinary.

Do not expose the internal emotion tag in the visible text reply.
