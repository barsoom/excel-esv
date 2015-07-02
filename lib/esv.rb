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

  def self.parse(data)
    fake_file = StringIO.new(data)
    book = Spreadsheet.open(fake_file)
    book.worksheet(0).to_a
  end
end
