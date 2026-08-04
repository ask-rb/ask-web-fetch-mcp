# ask-web-fetch-mcp

[![Gem Version](https://badge.fury.io/rb/ask-web-fetch-mcp.svg)](https://badge.fury.io/rb/ask-web-fetch-mcp)

A minimal MCP (Model Context Protocol) server that exposes
`Ask::Tools::WebFetch` as a callable tool over stdio. Designed for use with
clients that support MCP (ZCode, Claude Code, etc.), it fetches a URL and
returns clean markdown for LLM consumption — via the local pure-Ruby backend
by default, with an automatic Jina Reader fallback for JS-rendered or blocked
pages.

## Installation

```ruby
gem "ask-web-fetch-mcp"
```

## Usage

Run the server:

```sh
ask-web-fetch-mcp
```

The server listens for JSON-RPC messages on stdin and writes responses to
stdout — the standard MCP stdio transport. Register it as an MCP server in
your client configuration:

```json
{
  "mcp": {
    "servers": {
      "ask-web-fetch-mcp": {
        "type": "stdio",
        "command": "ask-web-fetch-mcp",
        "args": []
      }
    }
  }
}
```

The exposed tool is named `ask_web_fetch` (the `ask_` prefix avoids
collisions with client-side tools of the same name, matching
`ask-web-search-mcp`). It accepts a `url` argument and an optional
`max_chars`, and returns the page content as markdown:

```
{"jsonrpc":"2.0","id":1,"method":"tools/call",
 "params":{"name":"ask_web_fetch","arguments":{"url":"https://www.ruby-lang.org/en/"}}}
```

## Configuration

The `ask-web-fetch` backend chain applies unchanged. Optional environment
variables:

- `JINA_API_KEY` — enables the Jina fallback with higher rate limits
- `DEBUG=1` — ask-mcp debug logging on stderr

## Full documentation

The full ask-rb documentation lives at https://ask-rb.github.io/ask-docs.
[Core: Web Fetch](https://ask-rb.github.io/ask-docs/core/web-fetch) covers
ask-web-fetch in depth. API reference: https://ask-rb.github.io/ask-docs/reference/api.

## Development

```
bundle install
bundle exec rake test
```

## License

MIT
