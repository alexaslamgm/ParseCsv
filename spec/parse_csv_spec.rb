require_relative '../app/parse_csv' # assuming your script is in the same directory

RSpec.describe 'generate_product_report' do
  context 'when the CSV file exists and is correctly formatted' do
    it 'generates a valid JSON report' do
      expect { generate_product_report('spec/csv_files/valid_products.csv') }.to output(/JSON report generated successfully/).to_stdout
      expect(File.exist?('product_report.json')).to be true
    end
  end

  context 'when the CSV file does not exist' do
    it 'prints an error message' do
      expect { generate_product_report('spec/csv_files/non_existent.csv') }.to output(/Error: The CSV file does not exist/).to_stdout
    end
  end

  context 'when the CSV file is incorrectly formatted' do
    it 'prints an error message' do
      expect { generate_product_report('spec/csv_files/invalid_format.csv') }.to output(/Error: The CSV file is not formatted correctly/).to_stdout
    end
  end

  context 'when an unexpected error occurs' do
    it 'prints an error message' do
      allow(CSV).to receive(:foreach).and_raise(StandardError, 'An unexpected error')
      expect { generate_product_report('spec/csv_files/valid_products.csv') }.to output(/An unexpected error occurred: An unexpected error/).to_stdout
    end
  end

  after(:each) do
    File.delete('product_report.json') if File.exist?('product_report.json')
  end
end
