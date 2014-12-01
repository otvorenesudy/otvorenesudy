require 'spec_helper'

describe ApiKey do
  describe 'callbacks' do
    describe '#generate_key' do
      it 'generates key' do
        allow(ApiKey::Generator).to receive(:generate).and_return('value')

        api_key = create :api_key

        expect(api_key.value).to eql('value')
      end

      context 'when key already exists' do
        it 'tries to generate another one in a loop' do
          allow(ApiKey::Generator).to receive(:generate).and_return('value')

          create :api_key

          allow(ApiKey::Generator).to receive(:generate).and_return('value', 'another value')

          api_key = create :api_key

          expect(api_key.value).to eql('another value')
        end
      end
    end
  end
end
