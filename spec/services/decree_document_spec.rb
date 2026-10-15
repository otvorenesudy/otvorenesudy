# frozen_string_literal: true

require 'rails_helper'

# Which addresses a decree's document may come from. A document address or a redirect must not reach the server's own
# services or any network that isn't the public internet; the request spec covers the rest of fetching.
RSpec.describe DecreeDocument do
  describe '.fetch' do
    it 'fetches a document from a public IPv4 address' do
      stub_request(:get, 'http://8.8.8.8/1.pdf').to_return(status: 200, body: '%PDF')

      expect(described_class.fetch('http://8.8.8.8/1.pdf')).to eq('%PDF')
    end

    it 'fetches a document from a public IPv6 address' do
      stub_request(:get, 'http://[2a00:1450:4001::1]/1.pdf').to_return(status: 200, body: '%PDF')

      expect(described_class.fetch('http://[2a00:1450:4001::1]/1.pdf')).to eq('%PDF')
    end

    {
      'this network' => %w[0.0.0.0 0.1.2.3 [::]],
      'private networks' => %w[10.0.0.1 172.16.0.1 192.168.0.1 [fc00::1] [fd12:3456::1]],
      'shared address space (carrier-grade NAT)' => %w[100.64.0.1 100.127.255.254],
      'loopback' => %w[127.0.0.1 127.1.2.3 [::1]],
      'link-local' => %w[169.254.169.254 [fe80::1]],
      'protocol assignments' => %w[192.0.0.1 [2001::1] [2001:20::1]],
      'documentation' => %w[192.0.2.1 198.51.100.1 203.0.113.1 [2001:db8::1] [3fff::1]],
      '6to4 relays' => %w[192.88.99.1 [2002:a00:1::1]],
      'benchmarking' => %w[198.18.0.1 198.19.255.254],
      'multicast' => %w[224.0.0.1 239.255.255.250 [ff02::1]],
      'reserved and broadcast' => %w[240.0.0.1 255.255.255.255],
      'IPv4 inside IPv6' => %w[[::ffff:10.0.0.1] [::ffff:8.8.8.8] [64:ff9b::a00:1] [64:ff9b:1::1]],
      'discard' => %w[[100::1]]
    }.each do |range, addresses|
      it "refuses #{range}: #{addresses.join(', ')}" do
        addresses.each do |address|
          expect { described_class.fetch("http://#{address}/1.pdf") }
            .to raise_error(described_class::Unavailable, /an address that isn't public/)
        end
      end
    end
  end
end
