---
name: british-english
description: House spelling convention for prose and code — British English everywhere, including code identifiers (Initialise not Initialize; colour, behaviour, serialise). Use whenever writing or reviewing prose, documentation, comments, or naming identifiers.
---

# British English

Use British English spelling everywhere — prose, documentation, comments, and code identifiers alike.

- Identifiers follow the same rule: `Initialise`, not `Initialize`; `Serialiser`, not `Serializer`.
- Common cases: `-ise`/`-isation` not `-ize`/`-ization` (serialise, initialisation); `-our` not `-or` (colour, behaviour); `-re` not `-er` (centre, metre); `licence` (noun) / `license` (verb); `catalogue`; `cancelled`.
- Exception: match the spelling a third party has already fixed. Standard-library and third-party API names stay as written (`encoding/json`'s `Marshaler`, an `initialize` in a vendored SDK) — you implement the name that exists, you do not re-spell it.