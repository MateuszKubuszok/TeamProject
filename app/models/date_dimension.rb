class DateDimension < ActiveWarehouse::Dimension
  establish_connection "#{Rails.env}_warehouse"

  set_order :sql_date_stamp  
  define_hierarchy :calendar_year, [:calendar_year, :calendar_month_name, :calendar_week, :day_of_week]
  define_hierarchy :day_of_week,   [:day_of_week]
end