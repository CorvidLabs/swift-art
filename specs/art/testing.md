---
spec: art.spec.md
---

## Testing

- `fledge lanes run verify` builds every locally available product and runs all 255 tests across 36 suites.
- macOS verifies `Art`, `ArtTerminal`, and conditional `ArtUI`; Ubuntu preserves independent Swift 6 coverage for cross-platform products.
- `specsync check --strict --require-coverage 100 --force` verifies every parsed export plus 49/49 files and 6,846/6,846 source LOC.
- `specsync agents status` verifies Claude, Cursor, Codex, and Gemini project integrations.
- `fledge trust doctor` and `fledge trust verify` exercise lifecycle, contract, blocking risk, progressive provenance, and the native lane.
- Hosted Trust, macOS, Ubuntu, and CodeQL checks must pass on the exact final commit before promotion or merge; DocC Pages remains an independent main-branch publication workflow.
