# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatisticalTableCell do
  describe '.of' do
    let(:table) do
      create(:statistical_table, table_name: 'R',
                                 rows: { 'Pocet1' => { 'C' => '12', 'T' => '3' }, 'Pocet2' => { 'C' => '5' } })
    end

    it 'finds the cell of a table by the names of its column and row' do
      expect(described_class.of(table, 'T', 'Pocet1').value).to eq('3')
      expect(described_class.of(table, 'C', 'Pocet2').value).to eq('5')
    end

    it 'finds the cell by its column and row' do
      column = table.columns.by_name('C').first
      row = table.rows.by_name('Pocet1').first

      expect(described_class.of(table, column, row).value).to eq('12')
    end

    it 'is nil for a cell the table does not have' do
      expect(described_class.of(table, 'T', 'Pocet2')).to be_nil
      expect(described_class.of(create(:statistical_table, table_name: 'R'), 'C', 'Pocet1')).to be_nil
    end
  end
end
