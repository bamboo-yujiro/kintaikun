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

  def is_status_avairable(status_change_btn)#現在のステータスから渡ってきたステータスに遷移可能なのか
    return status_change_btn[:from_status].include?(status) if status_change_btn[:from_status].is_a?(Array)
    status_change_btn[:from_status] == status
  end

  def change_status(status_change_btn)
    raise '不正操作' if !is_status_avairable(status_change_btn)#遷移不可能なステータス
    if status_change_btn[:identifier] == 'break'
      start_in_breaks.create(time: Time.now)
    elsif status_change_btn[:identifier] == 'go_out'
      start_out_of_offices.create(time: Time.now)
    elsif status_change_btn[:identifier] == 'back'
      end_in_breaks.create(time: Time.now) if status_text(:en) == 'in_break'
      end_out_of_offices.create(time: Time.now) if status_text(:en) == 'out_of_office'
    end
    update(status: status_change_btn[:to_status])
  end

end
