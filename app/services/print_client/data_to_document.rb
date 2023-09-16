# frozen_string_literal: true

module PrintClient
  # Печать одной этикетки через DataToDocumentApi
  class DataToDocument < BasePrintClient
    def single_print!(point, template_name)
      HttpService.new.report!(template_name,
                              { template_params: PrintClient::DataToDocumentClient::PointSerializer.new(point).as_json })
    end

    def multiple_print!(points, template_name)
      points_array = points.each.with_object([]) do |point, result|
        result << PrintClient::DataToDocumentClient::PointSerializer.new(point).as_json
      end
      HttpService.new.report!(template_name,
                              { template_params: { targets: points_array } })
    end
  end
end
