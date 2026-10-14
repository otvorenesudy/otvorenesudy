# frozen_string_literal: true

# The court system's servers are faked with WebMock; so are their names in DNS, which DecreeDocument resolves to make
# sure it connects to a public address. 203.0.113.0/24 is reserved for documentation.
COURT_SYSTEM_ADDRESSES = { 'obcan.justice.sk' => '203.0.113.10' }.freeze

RSpec.configure do |config|
  config.before do
    allow(Resolv).to receive(:getaddresses).and_call_original

    COURT_SYSTEM_ADDRESSES.each do |host, address|
      allow(Resolv).to receive(:getaddresses).with(host).and_return([address])
    end
  end
end
