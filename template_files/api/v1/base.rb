module API
  module V1
    class Base < API::Base

      include ::API::Helpers::V1::ApplicationHelpers

      version 'v1'

      add_swagger_documentation(
        base_path: "/api",
        hide_format: true,
        hide_documentation_path: true,
        api_version: 'v1'
      )

    end
  end
end