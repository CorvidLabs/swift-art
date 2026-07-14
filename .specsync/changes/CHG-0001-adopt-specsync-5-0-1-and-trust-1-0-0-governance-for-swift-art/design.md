---
change: CHG-0001-adopt-specsync-5-0-1-and-trust-1-0-0-governance-for-swift-art
artifact: design
---

# Design

One active canonical `art` companion covers every shipped source file because the three products form a single package contract: `ArtTerminal` re-exports and adapts `Art`, and `ArtUI` conditionally re-exports and renders it. Eleven stable requirements divide the contract into auditable behavior families while the public API table records every parser-visible export.

The committed SpecSync policy treats source, tests, package metadata, workflows, governance configuration, and canonical companions as meaningful. Coverage is blocking at 100%. Trust uses the immutable 1.0.0 action, full history, blocking risk, progressive provenance, and the Fledge native build/test lane. Atlas stays off because DocC Pages remains independently managed.
