# frozen_string_literal: true

require_relative 'test_helper'

# Functional tests for the ask-web-fetch-mcp server, driven end-to-end with
# Ask::MCP::Client over a real stdio subprocess. A stub backend replaces the
# network-dependent chain, so no network is involved.
class ServerTest < Minitest::Test
  def setup
    @script = File.expand_path('support/test_server.rb', __dir__)
  end

  def teardown
    @client&.stop
  rescue StandardError
    nil
  end

  def spawn_client
    transport = Ask::MCP::Transport::Stdio.new(
      'ruby', [@script],
      env: { 'BUNDLE_GEMFILE' => File.expand_path('../Gemfile', __dir__) }
    )
    @client = Ask::MCP::Client.new(transport, timeout: 5)
    @client.start
  end

  def test_negotiates_stateless_protocol
    spawn_client

    assert_predicate @client, :initialized?
    assert_equal '2026-07-28', @client.instance_variable_get(:@protocol_version),
                 'server should negotiate the stateless protocol via server/discover'
    assert @client.instance_variable_get(:@stateless),
           'a 2026-07-28 server must be used without the initialize handshake'
  end

  def test_lists_ask_web_fetch_tool
    spawn_client
    tools = @client.tools

    assert tools.key?('ask_web_fetch'), "expected ask_web_fetch tool, got #{tools.keys.inspect}"
    props = tools['ask_web_fetch'].input_schema[:properties]

    assert props.key?('url') || props.key?(:url), 'tool must declare a url parameter'
  end

  def test_calls_tool_and_returns_markdown
    spawn_client
    result = @client.call_tool('ask_web_fetch', { url: 'https://example.com' })
    text = result.is_a?(Array) ? result.first[:text] : result.dig(:content, 0, :text)

    assert_includes text, '# Stub Page'
    assert_includes text, 'Source: https://example.com'
    assert_includes text, 'Stub content'
  end

  def test_calls_tool_with_max_chars_truncation
    spawn_client
    result = @client.call_tool('ask_web_fetch', { url: 'https://example.com', max_chars: 60 })
    text = result.is_a?(Array) ? result.first[:text] : result.dig(:content, 0, :text)

    assert_includes text, '…(truncated)'
    assert_operator text.length, :<=, 160
  end

  def test_unknown_tool_returns_error_result
    spawn_client
    result = @client.call_tool('no_such_tool', {})
    text = result.is_a?(Array) ? result.first[:text] : result.dig(:content, 0, :text)

    assert_match(/Tool not found/, text)
  end
end
