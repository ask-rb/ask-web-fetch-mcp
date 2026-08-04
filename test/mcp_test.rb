# frozen_string_literal: true

require_relative 'test_helper'

describe Ask::WebFetch::MCP do
  it 'exposes the web fetch tool under the ask_web_fetch name' do
    tool = Ask::WebFetch::MCP.tool

    _(tool.name).must_equal 'ask_web_fetch'
    _(tool).must_be_kind_of Ask::Tools::WebFetch
  end

  it 'satisfies the duck-typed MCP tool contract' do
    tool = Ask::WebFetch::MCP.tool

    _(tool.description).wont_be :empty?
    _(tool.params_schema['required']).must_include 'url'
    %i[name description params_schema call].each do |m|
      _(tool).must_respond_to m
    end
  end

  describe 'tool call' do
    before do
      WebMock.disable_net_connect!
    end

    after do
      WebMock.reset!
    end

    it 'returns clean markdown for a fetched page' do
      body = '<html><head><title>MCP Page</title></head><body><article>' \
             "<p>#{'Content served through the MCP server. ' * 6}</p></article></body></html>"
      stub_request(:get, 'https://example.com')
        .to_return(status: 200, headers: { 'Content-Type' => 'text/html' }, body: body)

      result = Ask::WebFetch::MCP.tool.call('url' => 'https://example.com')

      _(result).must_be_kind_of Ask::Result
      _(result.ok?).must_equal true
      _(result.output).must_include '# MCP Page'
      _(result.output).must_include 'Source: https://example.com'
    end

    it 'falls back to the jina backend when local finds no content' do
      stub_request(:get, 'https://example.com')
        .to_return(status: 200, headers: { 'Content-Type' => 'text/html' },
                   body: '<html><body><div id="app"><script>render()</script></div></body></html>')
      stub_request(:get, 'https://r.jina.ai/https://example.com')
        .to_return(status: 200, body: 'Jina rendered content for the MCP server. ' * 5)

      result = Ask::WebFetch::MCP.tool.call('url' => 'https://example.com')

      _(result.ok?).must_equal true
      _(result.output).must_include 'Jina rendered content'
    end
  end
end
