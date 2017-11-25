module Services
  module AttendanceSheet

    def self.start_html
      <<-EOS
        <table>
          <thead>
            <tr>
              <th>日付</th>
              <th>曜日</th>
              <th>出社時刻</th>
              <th>退社時刻</th>
              <th>労働時間</th>
              <th>休憩時間</th>
              <th>外出時間</th>
            </tr>
          </thead>
          <tbody>
      EOS
    end

    def self.make_sheet(year, month, attendances_array)
      html = start_html
      # 該当月の末日
      end_days_array = Date::leap_year_judge(year) ? Date::LEAP_YEAR_END_DAYS_ARRAY : Date::END_DAYS_ARRAY
      # 曜日
      current_day = Date::calc_day(year,month)
      total_work_sec = 0; total_break_sec = 0; total_outoffice_sec = 0
      (1..end_days_array[month]).each do |date|
        patted_date = '%02d' % date
        day_str = Date::DAY_STR_ARRAY[current_day][:ja]
        date_obj = Date.custom_date_parse("#{year}-#{month}-#{patted_date}")
        date_str = "#{month}月#{patted_date}日"
        html << <<-EOS
          <tr>
        EOS
        if attendances_array.first && date_obj == attendances_array.first.date
          if attendances_array.first.status_text(:en) == 'clock_out'#退勤済み
            arrival_time = attendances_array.first.arrival_time.strftime("%H:%M")
            leaving_time = attendances_array.first.leaving_time.strftime("%H:%M")
            difference_sec = attendances_array.first.leaving_time - attendances_array.first.arrival_time
            total_work_sec += difference_sec
            working_time = Time.at(difference_sec).utc.strftime('%H:%M')
            sum_break_sec = attendances_array.first.sum_break_sec
            total_break_sec += sum_break_sec
            sum_break_time = Time.at(sum_break_sec).utc.strftime('%H:%M')
            sum_out_office_sec = attendances_array.first.sum_out_office_sec
            total_outoffice_sec += sum_out_office_sec
            sum_out_office_time = Time.at(sum_out_office_sec).utc.strftime('%H:%M')
          else
            arrival_time = attendances_array.first.arrival_time.strftime("%H:%M") if attendances_array.first.arrival_time
            leaving_time = attendances_array.first.leaving_time.strftime("%H:%M") if attendances_array.first.leaving_time
            working_time = ''
            sum_break_time = ''
            sum_out_office_time = ''
          end
          html << <<-EOS
            <td>#{date_str}</td>
            <td>#{day_str}</td>
            <td>#{arrival_time}</td>
            <td>#{leaving_time}</td>
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
      ## 総累計時間の計算
      total_work_time = Time.convert_seconds_time(total_work_sec)
      total_break_time = Time.convert_seconds_time(total_break_sec)
      total_outoffice_time = Time.convert_seconds_time(total_outoffice_sec)
      html << <<-EOS
        </tbody>
        <tfoot>
          <tr>
            <th colspan="4"></th>
            <th>労働時間</th>
            <th>休憩時間</th>
            <th>外出時間</th>
          </tr>
          <tr>
            <td colspan="4"></th>
            <td>#{total_work_time}</th>
            <td>#{total_break_time}</th>
            <td>#{total_outoffice_time}</th>
          </tr>
        </tfoot>
      </table>
      EOS
    end

  end

end
