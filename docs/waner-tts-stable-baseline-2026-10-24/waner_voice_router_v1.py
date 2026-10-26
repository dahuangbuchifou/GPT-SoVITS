#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

RELEASE_ID = "WANER_VOICE_ROUTER_V1"

CANONICAL_EMOTIONS = {"ordinary", "soft", "happy", "calm", "anxiety"}
COMPAT_EMOTIONS = {"ordinary1", "ordinary2", "daily"}
ALL_ACCEPTED = CANONICAL_EMOTIONS | COMPAT_EMOTIONS
ALIASES = {"daily": "ordinary"}

LEADING_TAG_RE = re.compile(
    r"^\s*\[\[waner-emotion:([A-Za-z0-9_-]+)\]\]\s*",
    re.IGNORECASE,
)
LEADING_ANY_WANER_TAG_RE = re.compile(
    r"^\s*\[\[waner-emotion:[^\]\r\n]*\]\]\s*",
    re.IGNORECASE,
)


def resolve_emotion_and_text(raw_text: str) -> tuple[str, str, str]:
    text = raw_text or ""
    match = LEADING_TAG_RE.match(text)

    if match:
        requested = match.group(1).strip().lower()
        clean = text[match.end():].strip()

        if requested in ALL_ACCEPTED:
            resolved = ALIASES.get(requested, requested)
            if not clean:
                raise ValueError("EMPTY_TEXT_AFTER_EMOTION_TAG")
            return resolved, clean, "explicit_tag"

        clean = LEADING_ANY_WANER_TAG_RE.sub("", text, count=1).strip()
        if not clean:
            raise ValueError("EMPTY_TEXT_AFTER_INVALID_EMOTION_TAG")
        return "ordinary", clean, f"invalid_tag:{requested}"

    clean = text.strip()
    if not clean:
        raise ValueError("EMPTY_TEXT")
    return "ordinary", clean, "default"


def parse_args() -> argparse.Namespace:
    here = Path(__file__).resolve().parent
    parser = argparse.ArgumentParser(
        description="Waner emotion router for OpenClaw tts-local-cli"
    )
    parser.add_argument("--text", required=True)
    parser.add_argument("--output")
    parser.add_argument("--env-file")
    parser.add_argument(
        "--provider-path",
        default=str(here / "waner_provider_v3.py"),
    )
    parser.add_argument(
        "--provider-timeout",
        type=float,
        default=45.0,
        help="Outer safety timeout; V3.1 has its own hard deadline.",
    )
    parser.add_argument("--dry-run", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    try:
        emotion, clean_text, reason = resolve_emotion_and_text(args.text)
    except ValueError as exc:
        print(f"{RELEASE_ID}=FAIL REASON={exc}", file=sys.stderr)
        return 2

    if args.dry_run:
        print(
            json.dumps(
                {
                    "release_id": RELEASE_ID,
                    "emotion": emotion,
                    "reason": reason,
                    "text": clean_text,
                },
                ensure_ascii=False,
            )
        )
        return 0

    if not args.output:
        print(f"{RELEASE_ID}=FAIL REASON=missing_output", file=sys.stderr)
        return 2

    provider = Path(args.provider_path).expanduser().resolve()
    if not provider.is_file():
        print(
            f"{RELEASE_ID}=FAIL REASON=provider_not_found PATH={provider}",
            file=sys.stderr,
        )
        return 3

    cmd = [
        sys.executable,
        str(provider),
        "--text",
        clean_text,
        "--emotion",
        emotion,
        "--output",
        args.output,
    ]

    if args.env_file:
        cmd.extend(["--env-file", args.env_file])

    try:
        completed = subprocess.run(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            timeout=args.provider_timeout,
            check=False,
        )
    except subprocess.TimeoutExpired:
        print(
            f"{RELEASE_ID}=FAIL REASON=provider_outer_timeout "
            f"EMOTION={emotion} TIMEOUT={args.provider_timeout:.1f}s",
            file=sys.stderr,
        )
        return 124

    if completed.stdout:
        sys.stdout.write(completed.stdout)
    if completed.stderr:
        sys.stderr.write(completed.stderr)

    if completed.returncode != 0:
        print(
            f"{RELEASE_ID}=FAIL REASON=provider_rc "
            f"EMOTION={emotion} RC={completed.returncode}",
            file=sys.stderr,
        )
        return completed.returncode

    print(
        f"{RELEASE_ID}=PASS EMOTION={emotion} REASON={reason}",
        file=sys.stderr,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
