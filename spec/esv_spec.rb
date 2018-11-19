require "esv"

describe ESV, ".generate and .parse" do
  it "works" do
    data = ESV.generate do |esv|
      esv << [ "Dogs", "Cats" ]
      esv << [ 1, 2 ]
    end

    output = ESV.parse(data)

    expect(output).to eq [
      [ "Dogs", "Cats" ],
      [ 1, 2 ],
    ]
  end
end

describe ESV, ".parse" do
  it "raises if there's more than one worksheet" do
    expect {
      ESV.parse(excel_file_with_two_worksheets)
    }.to raise_error(/Expected 1 worksheet, found 2/)
  end

  it "ignores formatting, always returning a plain array of data" do
    output = ESV.parse(excel_file_with_formatting([1, 2]))
    expect(output).to eq [
      [ 1, 2 ],
    ]

    expect(output[0].class).to eq Array
  end

  private

  def excel_file_with_two_worksheets
    book = Spreadsheet::Workbook.new
    book.create_worksheet
    book.create_worksheet

    data = ""
    fake_file = StringIO.new(data)
    book.write(fake_file)
    data
  end

  def excel_file_with_formatting(data)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.row(0).replace(data)
    sheet.row(0).default_format = Spreadsheet::Format.new(color: :blue)

    data = ""
    fake_file = StringIO.new(data)
    book.write(fake_file)
    data
  end
end

describe ESV, ".generate_file and .parse_file" do
  before do
    @file = Tempfile.new("esv")
  end

  it "works" do
    path = @file.path

    ESV.generate_file(path) do |esv|
      esv << [ "Dogs", "Cats" ]
      esv << [ 1, 2 ]
    end

    output = ESV.parse_file(path)

    expect(output).to eq [
      [ "Dogs", "Cats" ],
      [ 1, 2 ],
    ]
  end

  after do
    @file.close
    @file.unlink
  end
end
