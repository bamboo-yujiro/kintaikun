class AttendancesController < ApplicationController

  def index
    ## ユーザーはログインしてるユーザーID、Dateはgetパラメータから分岐する
    user_id = 7
    year = 2017
    month = 11
    date_range = '2017-11-01'..'2017-11-30'
    attendances_array = Attendance.get_by_specified_month(user_id:user_id,date_range:date_range).to_a
    @html = Services::AttendanceSheet::make_sheet(year,month,attendances_array)
  end

end
