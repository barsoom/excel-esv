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

  it "returns the last value of a formula cell" do
    output = ESV.parse(excel_file_with_formula)
    expect(output).to eq [
      [ "one", "two" ],
    ]

    expect(output[0].class).to eq Array
  end

  it "returns the last value of a formula cell" do
    output = ESV.parse(excel_file_with_formula)
    expect(output).to eq [
      [ "one", "two" ],
    ]

    expect(output[0].class).to eq Array
  end

  it "returns the URL of a link cell" do
    output = ESV.parse(excel_file_with_link("https://example.com"))
    expect(output).to eq [
      [ "one", "https://example.com" ],
    ]

    expect(output[0][1].class).to eq String
  end

  private

  def excel_file_with_two_worksheets
    excel_file do |sheet, book|
      book.create_worksheet
    end
  end

  def excel_file_with_formatting(data)
    excel_file do |sheet|
      sheet.row(0).replace(data)
      sheet.row(0).default_format = Spreadsheet::Format.new(color: :blue)
    end
  end

  def excel_file_with_formula
    excel_file do |sheet|
      formula = Spreadsheet::Formula.new
      formula.value = "two"
      sheet.row(0).replace([ "one", formula ])
    end
  end

  def excel_file_with_link(url)
    excel_file do |sheet|
      link = Spreadsheet::Link.new(url)
      sheet.row(0).replace([ "one", link ])
    end
  end

  def excel_file(&block)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet

    block.call(sheet, book)

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
