class HolidaySearch
  def self.service
    NagerService.new.holiday_url
  end

  def self.holiday(num)
    holiday = service.map do |little_holiday|
      Holiday.new(little_holiday)
    end
    holiday.first(num)
  end

end