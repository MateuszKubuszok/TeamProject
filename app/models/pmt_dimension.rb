class PmtDimension < ActiveWarehouse::Dimension
  establish_connection "#{Rails.env}_warehouse"

  define_hierarchy :pmt, [ :project, :milestone, :ticket ]
end