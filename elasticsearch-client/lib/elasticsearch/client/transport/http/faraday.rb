module Elasticsearch
  module Client
    module Transport
      module HTTP
        class Faraday
          include Base

          def perform_request(method, path, params={}, body=nil)
            super do |connection, url|
              connection.connection.run_request \
                method.downcase.to_sym,
                url,
                ( body ? serializer.dump(body) : nil ),
                {'Content-Type' => 'application/json'}
            end
          end

          def __build_connections
            Connections::Collection.new \
              :connections => hosts.map { |host|
                host[:protocol] ||= DEFAULT_PROTOCOL
                host[:port]     ||= DEFAULT_PORT
                url               = "#{host[:protocol]}://#{host[:host]}:#{host[:port]}"

                Connections::Connection.new \
                  :host => host,
                  :connection => ::Faraday::Connection.new( :url => url, &@block )
              },
              :selector_class => options[:selector_class],
              :selector => options[:selector]
          end

          def host_unreachable_exceptions
            [::Faraday::Error::ConnectionFailed, ::Faraday::Error::TimeoutError]
          end
        end
      end
    end
  end
end