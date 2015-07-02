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
