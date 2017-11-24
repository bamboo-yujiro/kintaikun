class Date
  #（後で参照しやすいように0月の0日を設定）
  END_DAYS_ARRAY = [0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  LEAP_YEAR_END_DAYS_ARRAY = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  DAY_STR_ARRAY = [
    {en: 'sunday', ja: '日'},
    {en: 'monday', ja: '月'},
    {en: 'tuesday', ja: '火'},
    {en: 'wednesday', ja: '水'},
    {en: 'thursday', ja: '木'},
    {en: 'friday', ja: '金'},
    {en: 'saturday', ja: '土'}
  ]

  def self.get_date_str_with_format(date, format="%Y/%m/%d")
    date.strftime(format)
  end

  # 年の月の1日の曜日を計算
  def self.calc_day(year, month, d = 1)
    # 1月, 2月は前年の13月, 14月として計算
    if month == 1 || month == 2
      month += 12
      year  -= 1
    end
    # ツェラーの公式用の数を求める
    h = year / 100
    y = year % 100
    m = month
    # 曜日計算
    day = (y + (y / 4) + (h / 4) - (2 * h) + ((13 * (m + 1)) / 5) + d) % 7
    # ツェラーの公式の曜日だと扱いにくいから日曜を0にする
    # 土曜は6
    day -= 1
    day += 7 if day < 0
    day
  end

  #うるう年かどうかの判定メソッド
  def self.leap_year_judge(year)
    case
    when (year % 400).zero?
      true
    when (year % 100).zero?
      false
    when (year % 4).zero?
      true
    else
      false
    end
  end

  # 指定された年、月の 始まりと終わりの日を返す
  def self.get_start_end_day(year: nil, month: nil)
    start_date = ::Date::new(year,month, 1)
    end_date = start_date >> 1
    end_date = end_date - 1
    {
      start_day: start_date,
      end_day: end_date
    }
  end

  # 文字列を date オブジェクトに変換
  def self.custom_date_parse(str)
    date = nil
    if str && !str.empty? #railsなら、if str.present? を使う
      begin
        date = ::Date.parse(str)
      # parseで処理しきれない場合
      rescue ArgumentError #TODO
        formats = ['%Y:%m:%d %H:%M:%S'] # 他の形式が必要になったら、この配列に追加
        formats.each do |format|
          begin
            date = ::DateTime.strptime(str, format)
            break
          rescue ArgumentError
          end
        end
      end
    end
    date
  end

  def self.get_date_str_with_format(date, format="%Y/%m/%d")
    date.strftime(format)
  end

end
