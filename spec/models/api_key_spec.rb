require 'spec_helper'

describe APIKey do
  describe 'callbacks' do
    describe '#generate_key' do
      it 'generates key' do
        allow(APIKey::Generator).to receive(:generate).and_return('key')

        api_key = create :api_key

        expect(api_key.key).to eql('key')
      end

      context 'when key already exists' do
        it 'tries to generate another one in a loop' do
          allow(APIKey::Generator).to receive(:generate).and_return('key')

          create :api_key

          allow(APIKey::Generator).to receive(:generate).and_return('key', 'another key')

          api_key = create :api_key

          expect(api_key.key).to eql('another key')
        end
      end
    end
  end
end
