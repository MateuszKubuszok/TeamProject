class BugDimension < ActiveWarehouse::Dimension
  establish_connection "#{Rails.env}_warehouse"
end