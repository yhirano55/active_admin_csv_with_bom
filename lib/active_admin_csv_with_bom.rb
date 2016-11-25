require "active_admin"
require "active_admin_csv_with_bom/builder"
require "active_admin_csv_with_bom/engine"

module ActiveAdminCsvWithBom
  # NOTE: For resource of **NOT** Active Record
  def self.build(collection)
    Builder.new(collection).build
  end

  def self.csv_options
    @_csv_options ||= {
      byte_order_mark:  "\xFF\xFE".force_encoding("UTF-16LE").freeze,
      encoding:         "UTF-16LE",
      encoding_options: "UTF-8",
      col_sep:          "\t",
      row_sep:          "\r\n",
      force_quotes:     true
    }
  end
end

ActiveAdmin::Application.inheritable_setting(:csv_options, ActiveAdminCsvWithBom.csv_options)
