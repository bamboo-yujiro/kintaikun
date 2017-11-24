class AttendancesController < ApplicationController

  def index
    # 当日のレコードがあるかどうか
    a = Attendance.today(@current_user.id)
    a = Attendance.save_today(@current_user.id) if !a
    redirect_to action: :edit, id: a.id
  end

  def edit
    @attendance = Attendance.find(params[:id])
  end

  def update#TODO status 遷移の検証
    @attendance = Attendance.find(params[:id])
    status_change_btn = Constants::Attendance::STATUS_CHANGE_BTN[params[:change_status_btn_key].to_i]
    @attendance.change_status(status_change_btn)
    redirect_to action: :edit, id: @attendance.id
  end

  def sheet
    ## ユーザーはログインしてるユーザーID、Dateはgetパラメータから分岐する
    year = 2017
    month = 11
    date_range = '2017-11-01'..'2017-11-30'
    attendances_array = Attendance.get_by_specified_month(user_id:@current_user.id, date_range:date_range).to_a
    @html = Services::AttendanceSheet::make_sheet(year,month,attendances_array)
  end

end
