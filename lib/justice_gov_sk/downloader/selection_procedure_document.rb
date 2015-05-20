module JusticeGovSk
  class Downloader
    class SelectionProcedureDocument < JusticeGovSk::Downloader
      def storage
        @storage ||= JusticeGovSk::Storage::SelectionProcedureDocument.instance
      end

      def predownload(request)
        uri  = Core::Request.uri request
        path = uri_to_path uri

        return uri, path, nil
      end
    end
  end
end
