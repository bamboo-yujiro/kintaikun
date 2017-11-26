require 'rails_helper'

describe Attendance, type: :model do #メソッド単位で書いていきます

  describe 'get_by_specified_month メソッド' do
    let!(:attendance01) {
      Attendance.create(user_id: 1, date: '2017-11-05')
    }
    let!(:attendance02) {
      a = Attendance.create(user_id: 1, date: '2017-11-05')
      a.start_in_breaks.create(time: '12:00')
      a.end_in_breaks.create(time: '14:00')
    }
    let!(:attendance03) {
      a = Attendance.create(user_id: 1, date: '2017-11-05')
      a.start_out_of_offices.create(time: '12:00')
      a.end_out_of_offices.create(time: '14:00')
    }
    let!(:attendance04) {
      a = Attendance.create(user_id: 1, date: '2017-11-05')
      a.start_in_breaks.create(time: '12:00')
      a.end_in_breaks.create(time: '14:00')
      a.start_out_of_offices.create(time: '12:00')
      a.end_out_of_offices.create(time: '14:00')
    }
    subject { Attendance.get_by_specified_month(user_id: 1, date_range: '2017-11-01'..'2017-11-30') }
    it { is_expected.to include attendance01 } #attendance01
    context '子モデル(start_in_breaks)が空っぽの場合' do
      it { #attendance01
        expect(subject.first.start_in_breaks).to be_empty
      }
    end
    context '子モデル(start_in_breaks, end_in_breaks)に一つずつデータを挿入した場合' do
      it { #attendance02
        expect(subject[1].start_in_breaks.size).to eq(1)
        expect(subject[1].end_in_breaks.size).to eq(1)
      }
    end
    context '子モデル(start_out_of_offices, end_out_of_offices)に一つずつデータを挿入した場合' do
      it { #attendance03
        expect(subject[2].start_out_of_offices.size).to eq(1)
        expect(subject[2].end_out_of_offices.size).to eq(1)
      }
    end
    context '子モデル(start_in_breaks, end_in_breaks, start_out_of_offices, end_out_of_offices)に一つずつデータを挿入した場合' do
      it { #attendance04
        expect(subject[3].start_in_breaks.size).to eq(1)
        expect(subject[3].end_in_breaks.size).to eq(1)
        expect(subject[3].start_out_of_offices.size).to eq(1)
        expect(subject[3].end_out_of_offices.size).to eq(1)
      }
    end
  end

  describe 'today メソッド' do
    let!(:today_attendance) { Attendance.create(user_id: 99, date: Date.today) }
    subject { Attendance.today(99) }
    it { is_expected.to eq today_attendance } #attendance05
  end

  describe 'save_today メソッド' do
    subject { Attendance.save_today(98) }
    it { is_expected.to eq Attendance.where(user_id: 98, date: Date.today).first }
  end

  describe 'sum_break_sec メソッド' do
    context 'start,endで1つずつのデータで合計2時間（7200秒）' do
      subject {
        a = Attendance.create(user_id: 1, date: '2017-11-05')
        a.start_in_breaks.create(time: '12:00')
        a.end_in_breaks.create(time: '14:00')
        a.sum_break_sec
      }
      it { is_expected.to eq 7200.0 }
    end
    context 'start,endで3つずつのデータで合計3時間30分（12600秒）' do
      subject {
        a = Attendance.create(user_id: 1, date: '2017-11-05')
        a.start_in_breaks.create(time: '12:00')
        a.end_in_breaks.create(time: '14:00')
        a.start_in_breaks.create(time: '15:00')
        a.end_in_breaks.create(time: '15:30')
        a.start_in_breaks.create(time: '17:00')
        a.end_in_breaks.create(time: '18:00')
        a.sum_break_sec
      }
      it { is_expected.to eq 12600.0 }
    end
  end

  describe 'sum_out_office_sec メソッド' do
    context 'start,endで1つずつのデータで合計2時間（7200秒）' do
      subject {
        a = Attendance.create(user_id: 1, date: '2017-11-05')
        a.start_out_of_offices.create(time: '12:00')
        a.end_out_of_offices.create(time: '14:00')
        a.sum_out_office_sec
      }
      it { is_expected.to eq 7200.0 }
    end
    context 'start,endで3つずつのデータで合計3時間30分（12600秒）' do
      subject {
        a = Attendance.create(user_id: 1, date: '2017-11-05')
        a.start_out_of_offices.create(time: '12:00')
        a.end_out_of_offices.create(time: '14:00')
        a.start_out_of_offices.create(time: '15:00')
        a.end_out_of_offices.create(time: '15:30')
        a.start_out_of_offices.create(time: '17:00')
        a.end_out_of_offices.create(time: '18:00')
        a.sum_out_office_sec
      }
      it { is_expected.to eq 12600.0 }
    end
  end

  describe 'status_text メソッド' do
    context 'status 0 (ja)' do
      subject { Attendance.create(user_id: 1, date: '2017-11-05', status: 0).status_text }
      it { is_expected.to eq '入力待ち' }
    end
    context 'status 1 (ja)' do
      subject { Attendance.create(user_id: 1, date: '2017-11-05', status: 1).status_text }
      it { is_expected.to eq '勤務中' }
    end
    context 'status 2 (ja)' do
      subject { Attendance.create(user_id: 1, date: '2017-11-05', status: 2).status_text }
      it { is_expected.to eq '休憩中' }
    end
    context 'status 3 (ja)' do
      subject { Attendance.create(user_id: 1, date: '2017-11-05', status: 3).status_text }
      it { is_expected.to eq '外出中' }
    end
    context 'status 4 (ja)' do
      subject { Attendance.create(user_id: 1, date: '2017-11-05', status: 4).status_text }
      it { is_expected.to eq '退勤' }
    end
    context 'status 0 (en)' do
      subject { Attendance.create(user_id: 1, date: '2017-11-05', status: 0).status_text(:en) }
      it { is_expected.to eq 'empty' }
    end
    context 'status 1 (en)' do
      subject { Attendance.create(user_id: 1, date: '2017-11-05', status: 1).status_text(:en) }
      it { is_expected.to eq 'working' }
    end
    context 'status 2 (en)' do
      subject { Attendance.create(user_id: 1, date: '2017-11-05', status: 2).status_text(:en) }
      it { is_expected.to eq 'in_break' }
    end
    context 'status 3 (en)' do
      subject { Attendance.create(user_id: 1, date: '2017-11-05', status: 3).status_text(:en) }
      it { is_expected.to eq 'out_of_office' }
    end
    context 'status 4 (en)' do
      subject { Attendance.create(user_id: 1, date: '2017-11-05', status: 4).status_text(:en) }
      it { is_expected.to eq 'clock_out' }
    end
  end

  describe 'is_status_avairable メソッド' do
    btn1 = Constants::Attendance::STATUS_CHANGE_BTN[0]#出社ボタン
    btn2 = Constants::Attendance::STATUS_CHANGE_BTN[3]#戻るボタン
    context 'status0 (入力待ち)からの出社ボタン押下' do
      subject { Attendance.create(user_id: 1, date: '2017-11-05', status: 0).is_status_avairable(btn1) }
      it { is_expected.to eq true }
    end
    context 'status1 (勤務中)からの出社ボタン押下' do
      subject { Attendance.create(user_id: 1, date: '2017-11-05', status: 1).is_status_avairable(btn1) }
      it { is_expected.to eq false }
    end
    context 'status1 (休憩中)からの戻りボタン押下' do
      subject { Attendance.create(user_id: 3, date: '2017-11-05', status: 3).is_status_avairable(btn2) }
      it { is_expected.to eq true }
    end
    #これでメソッドのラインカバレッジ的にはOK。後は定数に依存するのでスキップ
  end

  describe 'change_status メソッド' do #input は is_status_avairable メソッドと同じ
    btn1 = Constants::Attendance::STATUS_CHANGE_BTN[0]#出社ボタン
    btn2 = Constants::Attendance::STATUS_CHANGE_BTN[3]#戻るボタン
    context 'status0 (入力待ち)からの出社ボタン押下' do
      subject { Attendance.create(user_id: 1, date: '2017-11-05', status: 0).change_status(btn1) }
      it { is_expected.to eq true }
    end
    context 'status1 (勤務中)からの出社ボタン押下' do
      example 'RuntimeError' do
        expect{ Attendance.create(user_id: 1, date: '2017-11-05', status: 1).change_status(btn1) }.to raise_error(RuntimeError)
      end
    end
    context 'status1 (休憩中)からの戻りボタン押下' do
      subject { Attendance.create(user_id: 3, date: '2017-11-05', status: 3).change_status(btn2) }
      it { is_expected.to eq true }
    end
    #これでメソッドのラインカバレッジ的にはOK。後は定数に依存するのでスキップ
  end

end
