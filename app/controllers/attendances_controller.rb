class AttendancesController < ApplicationController

  before_action :redirect_if_not_login

  def redirect_if_not_login
    redirect_to login_users_url, notice: 'ログインしてください。' if !@current_user
  end

  def index#この形でいいか保留 TODO
    a = Attendance.today(@current_user.id)
    a = Attendance.save_today(@current_user.id) if !a
    redirect_to action: :edit, id: a.id
  end

  def edit
    @attendance = Attendance.find(params[:id])
  end

  def update
    @attendance = Attendance.find(params[:id])
    status_change_btn = Constants::Attendance::STATUS_CHANGE_BTN[params[:change_status_btn_key].to_i]
    @attendance.change_status(status_change_btn)
    redirect_to action: :edit, id: @attendance.id
  end

  def sheet
    yearmonth_str = params[:month] || Date.today.strftime('%Y-%m')
    year, month, date_range = Date::get_year_month_daterange(yearmonth_str)
    attendances_array = Attendance.get_by_specified_month(user_id:@current_user.id, date_range:date_range).to_a
    @html = Services::AttendanceSheet::make_sheet(year,month,attendances_array)
  end

end
