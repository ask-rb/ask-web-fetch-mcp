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
