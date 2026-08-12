# frozen_string_literal: true

require 'ask/mcp'
require 'ask/web_fetch'
require_relative 'mcp/tool'
require_relative 'mcp/version'

module Ask
  module WebFetch
    # MCP (Model Context Protocol) server for ask-web-fetch.
    module MCP
      # Builds the tool exposed over MCP. The tool framing lives here —
      # ask-web-fetch is a library (Ask::WebFetch.fetch); this server
      # owns the agent-facing shell, named "ask_web_fetch" to avoid
      # collisions with client-side tools of the same name
      # (ask-web-search-mcp follows the same convention).
      def self.tool
        Tool.new
      end

      # Start the MCP server over stdio, exposing the ask_web_fetch tool.
      #
      #   $ ask-web-fetch-mcp
      #
      # The server listens for JSON-RPC messages on stdin and writes
      # responses to stdout — the standard MCP stdio transport. Register
      # this executable as an MCP server in your client configuration,
      # setting ASK_WEB_FETCH_CDP_URL in the server's env to route
      # Cloudflare-gated pages through an already-running Chrome:
      #
      #   "mcp": {
      #     "servers": {
      #       "ask-web-fetch-mcp": {
      #         "type": "stdio",
      #         "command": "ask-web-fetch-mcp",
      #         "args": [],
      #         "env": { "ASK_WEB_FETCH_CDP_URL": "http://127.0.0.1:9222" }
      #       }
      #     }
      #   }
      def self.start
        Ask::MCP::Server.start_stdio(
          name: 'ask-web-fetch-mcp',
          version: VERSION,
          tools: [tool],
          capabilities: { tools: {} },
          debug: ENV['DEBUG'] == '1'
        )
      end
    end
  end
end
