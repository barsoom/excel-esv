require "esv/version"
require "esv/generator"
require "esv/rails_controller"
require "spreadsheet"

module ESV
  def self.generate
    generator = Generator.new
    yield(generator)
    generator.render
  end

  def self.generate_file(path, &block)
    File.open(path, "wb") do |file|
      file.write generate(&block)
    end
  end

  def self.parse(data)
    fake_file = StringIO.new(data)
    book = Spreadsheet.open(fake_file)

    # We could support multiple worksheets, but let's not until we actually need it.
    # Until then, we prefer raising to silently ignoring worksheets.
    worksheet_count = book.worksheets.length
    raise "Expected 1 worksheet, found #{worksheet_count}." if worksheet_count > 1

    book.worksheet(0).to_a.map(&:to_a)
  end

  def self.parse_file(path)
    parse File.read(path)
  end
end
