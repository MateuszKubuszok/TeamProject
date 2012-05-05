class ProjectFacts < ActiveWarehouse::Fact
  establish_connection "#{Rails.env}_warehouse"
end