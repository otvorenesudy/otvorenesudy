# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Legislation do
  let(:legislation) do
    build(
      :legislation,
      type: 'zákona',
      number: 300,
      year: 2005,
      name: 'Trestný zákon',
      paragraph: '212',
      section: '2',
      letter: 'a'
    )
  end

  describe '#external_url' do
    it 'links the paragraph, section and letter of the law on zakonypreludi.sk' do
      expect(legislation.external_url).to eq('http://www.zakonypreludi.sk/zz/2005-300#p212-2-a')
    end

    it 'links the law alone when no paragraph is cited' do
      legislation.assign_attributes(paragraph: nil, section: nil, letter: nil)

      expect(legislation.external_url).to eq('http://www.zakonypreludi.sk/zz/2005-300')
    end

    it 'searches zakonypreludi.sk for a law without a year and number' do
      legislation.assign_attributes(year: nil, number: nil, value: 'Zákon o súdoch')

      expect(legislation.external_url).to eq('http://www.zakonypreludi.sk/main/search.aspx?text=Z%C3%A1kon+o+s%C3%BAdoch')
    end
  end

  describe '#value' do
    it 'cites the law in another pattern, capitalized' do
      expect(legislation.value('%t %u/%y %p %s %l')).to eq('Zákon 300/2005 § 212 ods. 2 písm. a)')
    end

    it 'composes the citation when none is stored, leaving out what is missing' do
      legislation.assign_attributes(value: nil, paragraph: nil, section: nil, letter: nil)

      expect(legislation.value).to eq('Zákon 300/2005 Trestný zákon')
    end
  end
end
