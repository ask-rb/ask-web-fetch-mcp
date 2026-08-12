# frozen_string_literal: true

require 'ask/web_fetch'

module Ask
  module WebFetch
    module MCP
      # The ask_web_fetch tool, duck-typed for Ask::MCP's ToolServer
      # adapter (name / description / params_schema / call). The tool
      # framing lives with its consumer — this server — not in the
      # library: the capability is Ask::WebFetch.fetch, this is the
      # agent-facing shell around it.
      class Tool
        def name
          'ask_web_fetch'
        end

        def description
          'Fetch a URL and return its content as clean markdown for LLM consumption. ' \
          'Use this to read web pages, articles, and documentation.'
        end

        def params_schema
          {
            'type' => 'object',
            'properties' => {
              'url' => { 'type' => 'string', 'description' => 'The URL to fetch' },
              'max_chars' => { 'type' => 'integer', 'description' => 'Maximum number of characters to return (default 20000)' }
            },
            'required' => ['url']
          }
        end

        # Returns the fetched markdown (a String is a success for the
        # adapter) or raises. The terminal verdicts — ParkedDomainError,
        # EmptyContentError, FetchError — reach the client as their class,
        # so it never retries the unretryable; transient failures raise
        # the base Error.
        def call(args)
          url = args['url'].to_s
          raise ArgumentError, 'missing required parameter: url' if url.empty?

          max_chars = args['max_chars']
          Ask::WebFetch.fetch(url, max_chars: max_chars || Ask::WebFetch::DEFAULT_MAX_CHARS)
        end
      end
    end
  end
end
