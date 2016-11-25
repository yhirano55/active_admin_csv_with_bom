require "csv"
require "ostruct"
require "active_support/core_ext/module/delegation"

module ActiveAdminCsvWithBom
  class Builder
    attr_reader :collection

    delegate :byte_order_mark, :encoding, :encoding_options,
             :col_sep, :row_sep, :force_quotes, to: :config

    def initialize(collection)
      @collection = collection
    end

    def build
      "".tap do |csv|
        csv << byte_order_mark
        csv << build_header

        collection.each do |record|
          csv << build_row(record)
        end
      end
    end

    private

    def build_header
      CSV.generate_line(column_names.map { |name| encode(resource_class.human_attribute_name(name)) }, options)
    end

    def build_row(record)
      CSV.generate_line(column_names.map { |name| encode(record.send(name)) }, options)
    end

    def resource_class
      @_resource_class ||= collection[0].class
    end

    def column_names
      @_column_names ||= resource_class.column_names
    rescue NoMethodError => _e
      raise NotImplementedError, "you must implement #{resource_class}.column_names"
    end

    def encode(value)
      value.to_s.encode(encoding, encoding_options)
    end

    def options
      @_options ||= { col_sep: col_sep, row_sep: row_sep, force_quotes: force_quotes }
    end

    def config
      @_config ||= OpenStruct.new(::ActiveAdminCsvWithBom.csv_options)
    end
  end
end
