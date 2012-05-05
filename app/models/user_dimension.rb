class UserDimension < ActiveWarehouse::Dimension
  establish_connection "#{Rails.env}_warehouse"
end