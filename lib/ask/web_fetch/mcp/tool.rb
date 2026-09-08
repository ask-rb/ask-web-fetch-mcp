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
        # adapter). On failure, returns a formatted error string with the
        # error class, message, and hint — so the agent gets our gem's
        # diagnostics instead of ZCode's generic timeout.
        def call(args)
          extra = args.keys.map(&:to_s) - params_schema['properties'].keys
          unless extra.empty?
            raise ArgumentError,
              "unknown parameter(s): #{extra.join(', ')} — ask_web_fetch expects: #{params_schema['properties'].keys.join(', ')}"
          end

          url = args['url'].to_s
          raise ArgumentError, 'missing required parameter: url' if url.empty?

          max_chars = args['max_chars']
          Ask::WebFetch.fetch(url, max_chars: max_chars || Ask::WebFetch::DEFAULT_MAX_CHARS)
        rescue Ask::WebFetch::Error => e
          format_error(e)
        end

        private

        def format_error(e)
          parts = ["Error: #{e.class.name.split('::').last}: #{e.message}"]
          parts << "Hint: #{e.hint}" if e.respond_to?(:hint) && e.hint
          parts.join("\n")
        end
      end
    end
  end
end
