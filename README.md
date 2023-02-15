# ESV

Ruby library/gem for Excel parsing and generation with the ease of CSV.

Exporting CSVs because Excel generation is too complex? No more! CSVs can also be difficult to open correctly, e.g. in Excel on Mac.

ESV will read and generate XLS files. There is currently no XLSX support, but Pull Requests are welcome.

By design, ESV only reads and writes simple values like integers, floats, strings and dates/datetimes. When parsing a spreadsheet with formulas, you will get their last value, if known.


## Usage

### Generate data

``` ruby
require "esv"

data = ESV.generate do |esv|
  esv << [ "Name", "Dogs", "Cats" ]
  esv << [ "Victor", 1, 4 ]
end

File.write("/tmp/test.xls", data)
```

### Generate file

``` ruby
require "esv"

ESV.generate_file("/tmp/test.xls") do |esv|
  esv << [ "Name", "Dogs", "Cats" ]
  esv << [ "Victor", 1, 4 ]
end
```

### Parse data

``` ruby
require "esv"

data = File.read("/tmp/test.xls")
output = ESV.parse(data)
# => [ [ "Name", "Dogs", … ], … ]
```

This assumes a file with a single worksheet and will raise otherwise.

`.parse` supports the `header_converters:` keyword argument, which takes the same arguments as `CSV.parse` does:

- a Symbol name for a registered header converter
- a Proc which takes the value and returns the converted value
- an Array of Symbol names for registered header converters

``` ruby
require "esv"

data = File.read("/tmp/test.xls")
output = ESV.parse(data, header_converters: :symbol)
# => [ [ :name, :dogs, … ], … ]
```

Registering a new converter:

``` ruby
ESV::HEADER_CONVERTERS[:upcase] = ->(value) { value.upcase }
```

### Parse file

``` ruby
require "esv"

output = ESV.parse_file("/tmp/test.xls")
# => [ [ "Name", "Dogs", … ], … ]
```

This assumes a file with a single worksheet and will raise otherwise.

Also supports `header_converters:`.

### Generate in Ruby on Rails

In `config/initializers/mime_types.rb`:

``` ruby
Mime::Type.register ESV::MIME_TYPE, "xls"
```

As a model or whatever you prefer:

``` ruby
class MyExcelDocument
  def self.generate(name)
    ESV.generate { |esv| esv << [ "Hello #{name}" ] }
  end
end
```

Controller:

``` ruby
class MyController < ApplicationController
  include ESV::RailsController  # for send_excel

  def show
    data = MyExcelDocument.generate("Rails")
    send_excel(data)
    # or: send_excel(data, filename: "myfilename.xls")
  end

  def another_example
    respond_to do |format|
      format.html { … }
      format.xls { send_excel(…) }
    end
  end
end
```


## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'excel-esv'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install excel-esv


## Credits and license

By Henrik Nyh for Auctionet.com under the MIT license.

Using [a lot of code](https://github.com/livingsocial/excelinator/blob/master/lib/excelinator/xls.rb) from LivingSocial's [Excelinator](https://github.com/livingsocial/excelinator), also under the MIT license.

This library is a thin wrapper around [Spreadsheet](https://github.com/zdavatz/spreadsheet) which does the heavy lifting.
