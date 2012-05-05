class CreateDateDimension < ActiveRecord::Migration
  def change
    fields = {
      date:                           :string,
      full_date_description:          :text,
      day_of_week:                    :string,
      day_number_in_calendar_month:   :integer,
      day_number_in_calendar_year:    :integer,
      day_number_in_fiscal_month:     :integer,
      day_number_in_fiscal_year:      :integer,
      calendar_week:                  :string,
      calendar_week_number_in_year:   :integer,
      calendar_month_name:            :string,
      calendar_month_number_in_year:  :integer,
      calendar_year_month:            :string,
      calendar_quarter:               :string,
      calendar_year_quarter:          :string,
      calendar_year:                  :string,
      fiscal_week:                    :string,
      fiscal_week_number_in_year:     :integer,
      fiscal_year_month:              :string,
      fiscal_quarter:                 :string,
      fiscal_year_quarter:            :string,
      fiscal_year:                    :string,
      holiday_indicator:              :string,
      weekday_indicator:              :string,
      selling_season:                 :string,
      major_event:                    :string,
      sql_date_stamp:                 :date
    }

    create_table :date_dimension do |t|
      fields.each { |name, type| t.column name, type }
    end

    fields.each { |name, type| add_index :date_dimension, name unless type == :text }
  end
end