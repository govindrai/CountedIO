module DateHelper
  def generate_week_label(date1,date2)
    "#{(date1).strftime("%F")} - #{date2.strftime("%F")}"
  end

  def generate_month_label(date)
    date.strftime("%B")
  end

  def get_weekday(date)
    date.strftime('%A')
  end

  def get_days_in_month(date)
    date.end_of_month.day
  end

  def today_PST
    Time.now.beginning_of_day.in_time_zone("Pacific Time (US & Canada)")
  end

  def tomorrow_PST
    Time.now.beginning_of_day.in_time_zone("Pacific Time (US & Canada)") + 1.days
  end
end