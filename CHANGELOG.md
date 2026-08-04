## [0.2.0] — 2026-08-04

### Added

- Subprocess integration test suite (`test/server_test.rb`) driving the
  server end-to-end with `Ask::MCP::Client` over a real stdio subprocess,
  using a stub backend so no network is involved: stateless negotiation,
  tool listing, tool calls, `max_chars` truncation, and unknown-tool errors.
- The server now reports its own gem version in the MCP `serverInfo`
  handshake (via `ask-mcp >= 0.4.3`), instead of ask-mcp's version.

### Changed

- `ask-mcp` floor raised to `>= 0.4.3` for the serverInfo version
  passthrough.

## [0.1.0] — 2026-08-04

### Added

- Initial release: MCP (Model Context Protocol) server over stdio exposing
  `Ask::Tools::WebFetch` as the `ask_web_fetch` tool.
- Exposes the full backend chain (local pure-Ruby fetch with automatic Jina
  Reader fallback) to any MCP client (ZCode, Claude Code, etc.).
