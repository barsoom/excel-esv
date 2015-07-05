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
end
