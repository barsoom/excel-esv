module ESV
  MIME_TYPE = "application/vnd.ms-excel"
  CONTENT_TYPE = "#{MIME_TYPE}; charset=utf-8"

  module RailsController
    private

    def send_excel(data, filename: nil)
      send_data(
        data,
        type: ESV::CONTENT_TYPE,
        disposition: "attachment",
        filename: filename,
      )
    end
  end
end
