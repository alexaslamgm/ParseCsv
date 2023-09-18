require 'csv'
require 'json'

# Function to read CSV and generate JSON report
def generate_product_report(csv_file)
  begin
    products = []

    CSV.foreach(csv_file, headers: true) do |row|
      unless row.headers == ['Product ID', 'Product Name', 'Description', 'Price', 'Availability']
        raise CSV::MalformedCSVError.new 'The CSV file is not formatted correctly.',11
      end
      product = {
        'Product ID' => row['Product ID'],
        'Product Name' => row['Product Name'],
        'Description' => row['Description'],
        'Price' => row['Price'].to_f,
        'Availability' => row['Availability'] == 'true'
      }
      products << product
    end

    report = { 'Products' => products }

    File.open('product_report.json', 'w') do |file|
      file.write(JSON.pretty_generate(report))
    end

    puts 'JSON report generated successfully.'

  rescue CSV::MalformedCSVError
    puts 'Error: The CSV file is not formatted correctly.'
  rescue Errno::ENOENT
    puts 'Error: The CSV file does not exist.'
  rescue StandardError => e
    puts "An unexpected error occurred: #{e.message}"
  end
end

if ARGV.empty?
  puts "Usage: ruby parse_csv.rb <filename>"
  exit(1) # Exit with an error code
else
  filename = ARGV[0]
  generate_product_report(filename)
end
