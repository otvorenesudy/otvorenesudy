# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NameNormalizer do
  describe '.court_name' do
    {
      'KS v BA' => 'Krajský súd Bratislava',
      'KS v Trenčíne' => 'Krajský súd Trenčín',
      'Kraj. súd v Nitre' => 'Krajský súd Nitra',
      'OS B. Bystrica' => 'Okresný súd Banská Bystrica',
      'Okresný súd Bratislava 3' => 'Mestský súd Bratislava III',
      'Okresný súd Košice 1' => 'Mestský súd Košice',
      'Okresný súd Nové Mesto n/V' => 'Okresný súd Nové Mesto nad Váhom',
      'Okresný súd Vranov n.T.' => 'Okresný súd Vranov nad Topľou',
      'Okresný súd Košice - okolie' => 'Okresný súd Košice okolie',
      'NS SR' => 'Najvyšší súd Slovenskej republiky',
      'ŠTS v Pezinku' => 'Špecializovaný trestný súd',
      'Ústavný súd SR' => 'Ústavný súd Slovenskej republiky',
      'okresný súd PREŠOV' => 'Okresný súd Prešov'
    }.each do |value, name|
      it "turns #{value.inspect} into #{name.inspect}" do
        expect(described_class.court_name(value)).to eq(name)
      end
    end
  end

  describe '.person_name' do
    {
      'JUDr. NOVÁK Ján, PhD.' => 'JUDr. Ján Novák, PhD.',
      'JUDr. JUDr. Ján Novák' => 'JUDr. Ján Novák',
      'Ing. Ján Novák, CSc., PhD.' => 'Ing. Ján Novák, CSc. PhD.',
      'JUDr. Mária KOVÁČOVÁ-HORVÁTHOVÁ' => 'JUDr. Mária Kováčová - Horváthová',
      'Peter K. Novák' => 'Peter Novák',
      'Ján Novák ml.' => 'Ján Novák ml.',
      'Mgr. Eva Nováková rod. Malá' => 'Mgr. Eva Nováková rod. Malá',
      'JUDr. Peter Novák, hovorca KS v Trenčíne' => 'JUDr. Peter Novák, hovorca krajského súdu v Trenčíne',
      'hovorca KS Trnava' => 'Hovorca krajského súdu v Trnave'
    }.each do |value, name|
      it "turns #{value.inspect} into #{name.inspect}" do
        expect(described_class.person_name(value)).to eq(name)
      end
    end

    it 'puts the last name first when reversed' do
      expect(described_class.person_name('JUDr. Ján Novák', reverse: true)).to eq('JUDr. Novák Ján')
      expect(described_class.person_name('Ján Peter Novák', reverse: true)).to eq('Novák Ján Peter')
    end
  end

  describe '.partition_person_name' do
    it 'splits a name into its titles, names and additions, the uppercase name last' do
      expect(described_class.partition_person_name(' JUDr. NOVÁK Ján Peter ml., PhD. ')).to eq(
        unprocessed: 'JUDr. NOVÁK Ján Peter ml., PhD.',
        value: 'JUDr. Ján Peter Novák ml., PhD.',
        prefix: 'JUDr.',
        first: 'Ján',
        middle: 'Peter',
        last: 'Novák',
        suffix: 'PhD.',
        addition: 'ml.',
        flags: [:relative],
        role: nil
      )
    end

    it 'keeps the birth name last' do
      parts = described_class.partition_person_name('Mgr. Eva Nováková rod. Malá')

      expect(parts).to include(first: 'Eva', last: 'Malá', flags: [:born])
    end

    it 'gives a lone name as the last name' do
      expect(described_class.partition_person_name('Novák')).to include(first: nil, middle: nil, last: 'Novák')
    end

    it "names a regional court's spokesperson by the role" do
      parts = described_class.partition_person_name('JUDr. Peter Novák, hovorca KS v Trenčíne')

      expect(parts).to include(
        value: 'JUDr. Peter Novák, hovorca krajského súdu v Trenčíne',
        last: 'Novák',
        flags: [:representative],
        role: 'Hovorca krajského súdu v Trenčíne'
      )
    end
  end
end
