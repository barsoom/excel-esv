class ESV::Generator
  def initialize
    @data_rows = []
  end

  def <<(row)
    @data_rows << row
  end

  def render
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet

    @data_rows.each_with_index do |data_row, index|
      row = sheet.row(index)
      row.push(*data_row)
    end

    content = ""
    fake_file = StringIO.new(content)
    book.write(fake_file)
    content
  end
end
