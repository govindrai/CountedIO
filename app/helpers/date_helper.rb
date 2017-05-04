module DateHelper
  def generate_week_label(date, direction="none")
    if direction.include?('forward')
      date1 =  @date + 7
      date2 =  date1 + 7
    else
      date1 = @date - 7
      date2 = @date
    end
    "#{(date1).strftime("%F")} - #{date2.strftime("%F")}"
  end

  def generate_month_label(date, direction="none")
    if direction.include?('forward')
      date =  @date + 1.months
    elsif direction.include?('back')
      date = @date - 1.months
    end
    date.strftime("%B")
  end

  def generate_day_label(date, direction="none")
    if direction.include?('forward')
      @date += 1
    elsif direction.include?('back')
      @date -= 1
    end
    date.strftime("%F")
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

  def date_to_PST(date)
    [date.beginning_of_day.in_time_zone("Pacific Time (US & Canada)"), date.beginning_of_day.in_time_zone("Pacific Time (US & Canada)") + 1.days]
  end
end