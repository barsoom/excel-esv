class ESV::Generator
  # The spreadsheet gem otherwise formats date and time cells as "DD.MM.YYYY".
  # Excel reads that case-insensitively, but Numbers.app only recognises the "MM", so it renders e.g. "DD.06.YYYY". Lowercase "dd" and "yyyy" work in both.
  # "hh" is confirmed to render as 24-hour time in Numbers.app.
  DATE_FORMAT = "yyyy-MM-dd"
  DATE_TIME_FORMAT = "yyyy-MM-dd hh:mm:ss"

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
      format_dates_and_times(row, data_row)
    end

    content = ""
    fake_file = StringIO.new(content)
    book.write(fake_file)
    content
  end

  private

  def format_dates_and_times(row, data_row)
    data_row.each_with_index do |value, index|
      format =
        case value
        # DateTime is a Date, so it has to be matched first.
        # Rails' `ActiveSupport::TimeWithZone` is matched by `when Time` since ActiveSupport patches `Time.===`.
        when DateTime, Time then date_time_format
        when Date then date_format
        end

      row.set_format(index, format) if format
    end
  end

  def date_format = @date_format ||= Spreadsheet::Format.new(number_format: DATE_FORMAT)
  def date_time_format = @date_time_format ||= Spreadsheet::Format.new(number_format: DATE_TIME_FORMAT)
end
