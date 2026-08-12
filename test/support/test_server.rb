#!/usr/bin/env ruby
# frozen_string_literal: true

# Spawned as a subprocess by the integration tests. A stub backend replaces
# the network-dependent chain so tests are deterministic and never touch the
# network.

require 'bundler/setup'
$LOAD_PATH.unshift File.expand_path('../../lib', __dir__)
require 'ask/web_fetch/mcp'

class StubFetchBackend < Ask::WebFetch::Backend
  def fetch(url)
    { title: 'Stub Page', content: "Stub content for #{url}. " * 8 }
  end
end

Ask::WebFetch.backends = [StubFetchBackend]
Ask::WebFetch::MCP.start
