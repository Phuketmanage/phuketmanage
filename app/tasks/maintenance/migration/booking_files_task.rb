# frozen_string_literal: true

require 'open-uri'

module Maintenance
  module Migration
    class BookingFilesTask < MaintenanceTasks::Task
      def collection
        # Finds all BookingFile where active storage file attachment isn't attached
        # and url is present (just for safety)
        BookingFile.where.missing(:data_attachment).where.not(url: nil)
      end

      def process(file)
        # Get the file URL
        url = URI.parse("https:#{S3_HOST}#{file.url}")

        # Download the old file
        old_file = URI.open(url)

        # Attach the file to the BookingFile
        file.data.attach(io: old_file, filename: file.name)
      end
    end
  end
end
