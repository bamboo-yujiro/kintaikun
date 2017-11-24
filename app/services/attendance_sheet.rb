module Services
  module AttendanceSheet

    def self.start_html
      <<-EOS
        <table>
          <thead>
            <tr>
              <td>日付</td>
              <td>曜日</td>
              <td>出社時刻</td>
              <td>退社時刻</td>
              <td>労働時間</td>
              <td>休憩時間</td>
              <td>外出時間</td>
            </tr>
          </thead>
          <tbody>
      EOS
    end

    def self.end_html(html)
      html << <<-EOS
          </tbody>
        </table>
      EOS
    end

    def self.make_sheet(year, month, attendances_array)
      html = start_html
      # 該当月の末日
      end_days_array = Date::leap_year_judge(year) ? Date::LEAP_YEAR_END_DAYS_ARRAY : Date::END_DAYS_ARRAY
      # 曜日
      current_day = Date::calc_day(year,month)
      (1..end_days_array[month]).each do |date|
        patted_date = '%02d' % date
        day_str = Date::DAY_STR_ARRAY[current_day][:ja]
        date_obj = Date.custom_date_parse("#{year}-#{month}-#{patted_date}")
        date_str = "#{month}月#{patted_date}日"
        html << <<-EOS
          <tr>
        EOS
        if attendances_array.first && date_obj == attendances_array.first.date
          difference_sec = attendances_array.first.leaving_time - attendances_array.first.arrival_time
          working_time = Time.at(difference_sec).utc.strftime('%H:%M')
          sum_break_time = attendances_array.first.sum_break_time
          sum_out_office_time = attendances_array.first.sum_out_office_time
          html << <<-EOS
            <td>#{date_str}</td>
            <td>#{day_str}</td>
            <td>#{attendances_array.first.arrival_time.strftime("%H:%M")}</td>
            <td>#{attendances_array.first.leaving_time.strftime("%H:%M")}</td>
            <td>#{working_time}</td>
            <td>#{sum_break_time}</td>
            <td>#{sum_out_office_time}</td>
          EOS
          attendances_array.shift
        else
          html << <<-EOS
            <td>#{date_str}</td>
            <td>#{day_str}</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
          EOS
        end
        html << <<-EOS
          </tr>
        EOS
        current_day += 1
        current_day = 0 if current_day > 6
      end
      ## TODO 総累計時間の計算
      end_html(html)
    end

  end

end
