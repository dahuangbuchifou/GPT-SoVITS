# Phase 6A / 6B — Conversational Voice + Dynamic Emotion

**Freeze date:** 2026-10-26  
**Status:** Phase 6A CLOSED; Phase 6B CLOSED

## 1. Phase 6A — AI answer → Waner voice

Goal: the user asks a question, OpenClaw/LLM generates its own answer, then the built-in `tts` tool speaks the assistant answer through the existing Waner/GPT-SoVITS path.

Validated flow:

```text
User question
→ OpenClaw / LLM answer
→ built-in tts tool
→ tts-local-cli
→ V3.1
→ Reverse SSH
→ Waner Gateway
→ GPT-SoVITS
→ Waner voice
```

Key configuration finding:

```json
{
  "tools": {
    "profile": "coding",
    "alsoAllow": ["tts"]
  }
}
```

Reason: in OpenClaw 2026.5.20 / e510042, `tts` is a core media tool but is not included in the `coding` profile. Adding only `tts` through `alsoAllow` preserves the existing tool profile and avoids broadening to `full`.

Safety state remains:

```text
enabled=false
auto=off
provider=tts-local-cli
configured=true
```

Workspace voice policy:

- explicit voice/audio request → first formulate the assistant answer;
- call built-in `tts` with the assistant answer text;
- do not read the user's question verbatim unless asked;
- do not emit legacy `[[tts:...]]` directives;
- do not enable `/tts on`, `/tts chat on`, or global auto-TTS;
- ordinary requests remain text-only.

## 2. Phase 6B — Dynamic emotion routing

Production emotion router:

```text
~/.openclaw/skills/gpt_sovits_tts_v3/waner_voice_router_v1.py
```

SHA-256:

```text
1e483a436f73a769e6445c9e80f75004a34e0097465a3a876b837694e8368a84
```

Router contract:

```text
[[waner-emotion:soft]]answer text
→ emotion=soft
→ strip internal tag
→ waner_provider_v3.py --emotion soft
```

No tag:

```text
→ ordinary
```

Invalid tag:

```text
→ strip tag
→ ordinary
```

Supported model-facing emotions:

- `ordinary`
- `soft`
- `happy`
- `calm`
- `anxiety`

Compatibility values remain accepted by the router:

- `ordinary1`
- `ordinary2`
- `daily`

Gateway presets verified:

```text
anxiety
calm
happy
ordinary1
ordinary2
soft
ordinary -> ordinary1
```

Emotion selection policy:

- ordinary: technical, work, neutral explanation;
- soft: comfort, care, gentle/soft request;
- happy: congratulations, success, positive news;
- calm: calming explanation, guidance, de-escalation;
- anxiety: only for explicitly requested anxious/nervous role-play.

Important rule:

```text
user anxiety != Waner anxiety
```

When the user is anxious or distressed, normally choose `soft` or `calm`.

## 3. OpenClaw local-cli path after Phase 6B

Before:

```text
tts-local-cli
→ waner_provider_v3.py
→ --emotion ordinary
```

After:

```text
tts-local-cli
→ waner_voice_router_v1.py
→ parse internal emotion tag
→ waner_provider_v3.py --emotion <resolved>
```

V3.1, Reverse SSH, Waner Gateway, GPT-SoVITS and Edge fallback remain unchanged.

## 4. Validation evidence

Validated:

- ordinary parse → ordinary
- soft parse → soft
- happy parse → happy
- invalid tag → ordinary
- Router soft request → provider=waner, emotion=soft
- OpenClaw explicit soft voice request → provider=waner, emotion=soft
- audible soft-vs-ordinary difference confirmed
- ordinary and soft A/B both succeeded through Waner at ~2.1 s in direct provider test
- V3 final state:
  - consecutive_failures=0
  - circuit_open=false
  - draining=false
  - last_error=""
- OpenClaw final state:
  - enabled=false
  - auto=off
  - provider=tts-local-cli
  - configured=true

## 5. Non-negotiable safety rules

- Keep OpenClaw native auto-TTS off.
- Do not use `/tts on` as a conversation mode.
- Do not remove V3.1 fallback/circuit logic.
- Do not expose 9880 or ECS 19890 publicly.
- Do not commit real bearer tokens, SSH private keys, or production ECS endpoint.
- Emotion tags are internal routing metadata and must never be spoken to the user.
