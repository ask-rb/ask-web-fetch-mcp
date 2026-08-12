# frozen_string_literal: true

require_relative 'lib/ask/web_fetch/mcp/version'

Gem::Specification.new do |spec|
  spec.name = 'ask-web-fetch-mcp'
  spec.version = Ask::WebFetch::MCP::VERSION
  spec.authors = ['Kaka Ruto']
  spec.email = ['kaka@myrrlabs.com']

  spec.summary = 'MCP server for web fetch'
  spec.description = <<~DESC
    A minimal MCP (Model Context Protocol) server that exposes ask_web_fetch
    as a callable tool over stdio. Designed for use with clients that support MCP
    (ZCode, Claude Code, etc.), it fetches a URL and returns clean markdown through
    the ask-web-fetch backend chain — fast pure-Ruby httpx fetch first, a real
    Chrome (launched or CDP-attached) for JS-rendered and challenge-gated pages,
    with Jina Reader and self-hosted Crawl4AI in between. Terminal failures
    (parked domains, empty pages, dead 4xx) surface as their deterministic error
    class, so clients never retry the unretryable. The tool shell (name, schema,
    call) lives here, wrapping the Ask::WebFetch library.
  DESC

  spec.homepage = 'https://github.com/ask-rb/ask-web-fetch-mcp'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/master/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.bindir = 'bin'
  spec.executables = ['ask-web-fetch-mcp']
  spec.require_paths = ['lib']

  # ask-mcp >= 0.4.3: the 0.4 line adds the stateless 2026-07-28 protocol
  # (server/discover negotiation, per-request _meta, MRTR); 0.4.3 adds the
  # serverInfo version passthrough so this server can advertise its own gem
  # version.
  spec.add_dependency 'ask-mcp', '>= 0.4.3'
  # 0.7.1: the module-level library API (Ask::WebFetch.fetch with the
  # failure collapse — ParkedDomainError > EmptyContentError > deterministic
  # FetchError, transient stays retryable — the parked-domain detector on
  # every backend, JS-shell completeness signal, warm-and-retry, and the
  # network-idle wait). This server owns the ask_web_fetch tool shell
  # (duck-typed for the MCP adapter); the library's native Ask::Tools
  # tool, when wanted, is an optional integration in ask-web-fetch itself.
  spec.add_dependency 'ask-web-fetch', '>= 0.7.1'

  spec.add_development_dependency 'minitest', '~> 5.25'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'webmock', '~> 3.26'
end
