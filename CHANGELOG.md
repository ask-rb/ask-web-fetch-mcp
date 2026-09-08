## [0.6.8] — 2026-09-09

### Changed

- Depends on `ask-web-fetch >= 0.7.6` for error hints, structured error
  classes with HTTP status, 404 content extraction, agent-native content
  negotiation, and Turnstile false-positive fix.

## [0.6.0] — 2026-08-12

### Changed

- **The server owns its tool shell.** `ask_web_fetch` is now a
  duck-typed tool (`Ask::WebFetch::MCP::Tool` — `name` /
  `description` / `params_schema` / `call`) wrapping the library entry
  `Ask::WebFetch.fetch`, instead of a renamed `Ask::Tools::WebFetch`.
  The MCP adapter's contract is duck-typed by design, so the server
  gains nothing from the ask-tools machinery — and the ask-tools /
  ask-core / ask-schema dependency chain is gone from the server
  process entirely. `ask-web-fetch` floor raised to `>= 0.7.1` (the
  module-level API with the failure collapse and parked-domain
  detection on every backend).
- **Cleaner error framing.** A failed call now surfaces as
  `Error: Ask::WebFetch::ParkedDomainError: ...` — the class is still
  named, without the tool layer's double wrap. Terminal verdicts
  (parked, empty, dead 4xx) are never retried by clients; transient
  failures raise the base `Error`.
- **The native agent tool stays available for non-MCP consumers.**
  `Ask::Tools::WebFetch` lives in ask-web-fetch as an optional
  integration (registered when ask-tools is present) for agent
  frameworks that resolve tools by name.

## [0.5.0] — 2026-08-12

### Changed

- `ask-web-fetch` floor raised to `>= 0.6.1`. The server exposes the tool
  unchanged, but `ask_web_fetch` now answers with the full current stack:
  the pooled-httpx transport (no more hangs on multi-host crawls), real
  network-idle waits in CDP-attached mode, JS-app-shell detection that
  fails client-rendered pages through to a rendering backend, parked-domain
  detection on every backend (GoDaddy/Namecheap registrar ads are rejected,
  never returned as content), and warm-and-retry challenge handling.
- **Failure verdicts are now classed.** When every backend fails, the tool
  raises the most definitive class — `ParkedDomainError` beats
  `EmptyContentError` beats a deterministic `FetchError` (every backend
  failed dead), and any transient failure in the mix keeps the retryable
  base `Error`. A client calling `ask_web_fetch` on a parked domain gets
  an error naming `ParkedDomainError` instead of a generic failure, so it
  stops retrying the unretryable. The message still lists every backend
  and what it said.

## [0.4.1] — 2026-08-11

### Changed

- `ask-web-fetch` floor raised to `>= 0.5.1` for the NoiseFilter:
  decorative symbol streams (animated page backgrounds, dividers) are
  stripped from every backend's markdown, and Jina/Crawl4AI now run the
  same `Markdown.clean` as the converting backends. The server exposes
  the tool unchanged; `ask_web_fetch` output is free of symbol-stream
  noise on all backends.

## [0.4.0] — 2026-08-10

### Changed

- `ask-web-fetch` floor raised to `>= 0.5` for the pooled httpx transport
  (keep-alive connections reused across tool calls in a long-lived server
  process) and raw outlinks + license signals on every backend's page
  result. The server exposes the tool unchanged; `ask_web_fetch` calls
  answer faster after the first one per host.

## [0.3.0] — 2026-08-08

### Changed

- `ask-web-fetch` floor raised to `>= 0.4` for the content-pruning pipeline
  and the Browser backend. The server exposes the tool unchanged; set
  `ASK_WEB_FETCH_CDP_URL` (e.g. `http://127.0.0.1:9222`) in the server's
  environment to fetch Cloudflare-gated pages through an already-running
  Chrome, and `ASK_WEB_FETCH_CHROME_PATH`/`ASK_WEB_FETCH_PROFILE` to tune
  the launched-browser mode.

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
