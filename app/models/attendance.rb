class Attendance < ApplicationRecord
  has_many :start_in_breaks
  has_many :end_in_breaks
  has_many :start_out_of_offices
  has_many :end_out_of_offices

  def self.get_by_specified_month(user_id:,date_range:) #重いのでバッチでオブジェクト作ってキャッシュさせる前提
    has_many_model_array = self.reflect_on_all_associations(:has_many).map { |s| s.name }
    self.includes(has_many_model_array).references(has_many_model_array).where(user_id: user_id).where(date: date_range)
  end

  def self.today(user_id)
    self.where(user_id: user_id, date: Date.today).first
  end

  def self.save_today(user_id)
    self.where(user_id: user_id, date: Date.today).first
  end

  def sum_break_time(format="%H:%M")
    sec = start_in_breaks.zip(end_in_breaks).reduce(0) do |accumulator, s|
      accumulator += s[1].time - s[0].time
    end
    Time.at(sec).utc.strftime(format)
  end

  def sum_out_office_time(format="%H:%M")
    sec = start_out_of_offices.zip(end_out_of_offices).reduce(0) do |accumulator, s|
      accumulator += s[1].time - s[0].time
    end
    Time.at(sec).utc.strftime(format)
  end

  def status_text(type=:ja)
    Constants::Attendance::STATUS[status][type]
  end

end
