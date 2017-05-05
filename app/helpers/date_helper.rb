module DateHelper

  def generate_day_label(date, direction="none")
    if date == 'Today'
      date = DateTime.now
    else
      date = date ? DateTime.parse(date) : DateTime.now
    end
    if direction.include?('forward')
      date += 1.days
    elsif direction.include?('back')
      date -= 1.days
    end
    date.strftime("%F")
  end

  def generate_week_label(date, direction="none")
    date = date ? DateTime.parse(date) : DateTime.now
    if direction.include?('forward')
      date1 =  date + 7
      date2 =  date1 + 7
    else
      date1 = date - 7
      date2 = date
    end
    "#{(date1).strftime("%F")} - #{date2.strftime("%F")}"
  end

  def generate_month_label(date, direction="none")
    date = date ? DateTime.parse(date) : DateTime.now.beginning_of_month
    if direction.include?('forward')
      date += 1.months
    elsif direction.include?('back')
      date -= 1.months
    end
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

  def date_to_PST(date)
    [date.beginning_of_day.in_time_zone("Pacific Time (US & Canada)"), date.beginning_of_day.in_time_zone("Pacific Time (US & Canada)") + 1.days]
  end
end