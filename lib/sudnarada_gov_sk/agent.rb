module SudnaradaGovSk
  class Agent
    include Core::Agent

    def uri_to_path(uri)
      SudnaradaGovSk::URL.url_to_path(uri, :html)
    end
  end
end
