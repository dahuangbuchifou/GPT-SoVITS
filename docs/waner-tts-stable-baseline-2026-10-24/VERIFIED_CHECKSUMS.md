# Verified production checksums

These hashes identify the production artifacts that were validated during Phase 5E/5F. Public templates in this repository are intentionally sanitized and therefore are not byte-identical to production-local files.

```text
START_WANER_REVERSE_TUNNEL_V1.ps1
SHA-256: 8fdb22c09eb5042ced1888eea4fa01ad8e11b85e69069d006d043475807c1b02

waner_provider_v3.py
SHA-256: 9ef8b5ed62f78576d45f89ff5c35cb2192638268f2335f8a9442c9a95f54be1d

waner-tts.env (pre Reverse-SSH migration backup)
SHA-256: bfcb7eb69aa702b45fa862c262577c1b943b2ce7885dd1bb3c5ed1fd191ea8f4
```

The real bearer token, SSH private key, production ECS endpoint, and production environment file are intentionally excluded from this public repository.


Phase 6B production emotion router:

```text
waner_voice_router_v1.py
SHA-256: 1e483a436f73a769e6445c9e80f75004a34e0097465a3a876b837694e8368a84
```
