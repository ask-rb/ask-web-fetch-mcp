## [0.1.0] — 2026-08-04

### Added

- Initial release: MCP (Model Context Protocol) server over stdio exposing
  `Ask::Tools::WebFetch` as the `ask_web_fetch` tool.
- Exposes the full backend chain (local pure-Ruby fetch with automatic Jina
  Reader fallback) to any MCP client (ZCode, Claude Code, etc.).
