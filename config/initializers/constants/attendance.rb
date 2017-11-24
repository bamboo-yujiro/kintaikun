module Constants

  module Attendance

    STATUS = [
      {
        en: 'empty',
        ja: '入力待ち'
      },
      {
        en: 'working',
        ja: '勤務中'
      },
      {
        en: 'in_break',
        ja: '休憩中'
      },
      {
        en: 'out_of_office',
        ja: '外出中'
      },
      {
        en: 'clock_out',
        ja: '退勤'
      }
    ]

    STATUS_CHANGE_BTN = [
      {
        text: '出社',
        identifier: 'arrival',
        to_status: 1,
        from_status: 0,#遷移可能なステータス（0 : 入力待ち状態からの遷移のみ可能）
      },
      {
        text: '休憩',
        identifier: 'break',
        to_status: 2,
        from_status: 1,
      },
      {
        text: '外出',
        identifier: 'go_out',
        to_status: 3,
        from_status: 1,
      },
      {
        text: '戻り',
        identifier: 'back',
        to_status: 1,
        from_status: [2,3],
      },
      {
        text: '退勤',
        identifier: 'clock_out',
        to_status: 4,
        from_status: 1,
      }
    ]

  end

end
