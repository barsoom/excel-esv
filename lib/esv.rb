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

  # You can register your own header converters in this Hash.
  #
  # @see https://rubyapi.org/3.2/o/csv#class-CSV-label-Custom+Header+Converters
  HEADER_CONVERTERS = {
    downcase: ->(value) { value.downcase },
    # Details:
    #
    #  Strips leading and trailing whitespace.
    #  Downcases the header.
    #  Replaces embedded spaces with underscores.
    #  Removes non-word characters.
    #  Makes the string into a Symbol.
    symbol: ->(value) {
      value.strip.downcase.tr(" ", "_").gsub(/W+/, "").to_sym
    },
  }

  # @param data [Object] Spreadsheet data to be parsed.
  # @param header_converters [nil, Array<Symbol>, Symbol, Proc]
  # @return [Array<Array>] a list of rows
  def self.parse(data, header_converters: nil)
    fake_file = StringIO.new(data)
    book = Spreadsheet.open(fake_file)

    # We could support multiple worksheets, but let's not until we actually need it.
    # Until then, we prefer raising to silently ignoring worksheets.
    worksheet_count = book.worksheets.length
    raise "Expected 1 worksheet, found #{worksheet_count}." if worksheet_count > 1

    is_first_row = true
    book.worksheet(0).to_a.map(&:to_a).map { |row|
      row.each_with_index.map { |cell, index|
        value =
          case cell
          when Spreadsheet::Formula then cell.value
          when Spreadsheet::Link then cell.href
          else cell
          end

        if header_converters && is_first_row
          case header_converters
          when Proc then
            value = header_converters.call(value)
          when Symbol then
            value = HEADER_CONVERTERS[header_converters].call(value)
          when Enumerable then
            # Apply the converters in order.
            header_converters.each { |name|
              value = HEADER_CONVERTERS.fetch(name).call(value)
            }
          else
            raise "Unsupported kind of header_converters #{header_converters.inspect}"
          end
          value
        else
          value
        end
      }.tap {
        is_first_row = false
      }
    }
  end

  def self.parse_file(path, header_converters: nil)
    parse(File.read(path), header_converters: header_converters)
  end
end
