# frozen_string_literal: true

# The court system's servers are faked with WebMock; so are their names in DNS, which DecreeDocument resolves to make
# sure it connects to a public address. The address is the server's own: DecreeDocument refuses the ranges reserved
# for documentation, and WebMock keeps any request from reaching it.
COURT_SYSTEM_ADDRESSES = { 'obcan.justice.sk' => '195.80.182.175' }.freeze

RSpec.configure do |config|
  config.before do
    allow(Resolv).to receive(:getaddresses).and_call_original

    COURT_SYSTEM_ADDRESSES.each do |host, address|
      allow(Resolv).to receive(:getaddresses).with(host).and_return([address])
    end
  end
end
