require 'rails_helper'

describe Attendance, type: :model do #メソッド単位で書いていきます

  describe 'get_by_specified_month メソッド' do
    let!(:attendance01) { create(:normal) }
    let!(:attendance02) {
      a = create(:normal)
      a.start_in_breaks.create(time: '12:00')
      a.end_in_breaks.create(time: '14:00')
      a
    }
    let!(:attendance03) {
      a = create(:normal)
      a.start_out_of_offices.create(time: '12:00')
      a.end_out_of_offices.create(time: '14:00')
      a
    }
    let!(:attendance04) {
      a = create(:normal)
      a.start_in_breaks.create(time: '12:00')
      a.end_in_breaks.create(time: '14:00')
      a.start_out_of_offices.create(time: '12:00')
      a.end_out_of_offices.create(time: '14:00')
      a
    }
    subject { Attendance.get_by_specified_month(user_id: 1, date_range: '2017-11-01'..'2017-11-30') }
    example 'letで作成したオブジェクトを全て含んでいるか' do
      [attendance01,attendance02,attendance03,attendance04].each do |a|
        expect(subject).to include a
      end
    end
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
    let!(:today_attendance) { create(:today) }
    subject { Attendance.today(1) }
    it { is_expected.to eq today_attendance } #attendance05
  end

  describe 'save_today メソッド' do
    subject { Attendance.save_today(1) }
    it { is_expected.to eq Attendance.where(user_id: 1, date: Date.today).first }
  end

  describe 'sum_break_sec メソッド' do
    context 'start,endで1つずつのデータで合計2時間（7200秒）' do
      subject {
        a = create(:normal)
        a.start_in_breaks.create(time: '12:00')
        a.end_in_breaks.create(time: '14:00')
        a.sum_break_sec
      }
      it { is_expected.to eq 7200.0 }
    end
    context 'start,endで3つずつのデータで合計3時間30分（12600秒）' do
      subject {
        a = create(:normal)
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
        a = create(:normal)
        a.start_out_of_offices.create(time: '12:00')
        a.end_out_of_offices.create(time: '14:00')
        a.sum_out_office_sec
      }
      it { is_expected.to eq 7200.0 }
    end
    context 'start,endで3つずつのデータで合計3時間30分（12600秒）' do
      subject {
        a = create(:normal)
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
    ja = ['入力待ち','勤務中','休憩中','外出中','退勤']
    en = ['empty','working','in_break','out_of_office','clock_out']
    [ja,en].each_with_index do |lang,index|
      str = index == 0 ? 'ja' : 'en'
      lang.each_with_index do |val, index2|
        context "status #{val} (#{str})" do
          subject { create(:normal, status: index2).status_text } if index == 0
          subject { create(:normal, status: index2).status_text(:en) } if index == 1
          it { is_expected.to eq val }
        end
      end
    end
  end

  describe 'is_status_avairable メソッド' do
    btn1 = Constants::Attendance::STATUS_CHANGE_BTN[0]#出社ボタン
    btn2 = Constants::Attendance::STATUS_CHANGE_BTN[3]#戻るボタン
    context 'status0 (入力待ち)からの出社ボタン押下' do
      subject { create(:normal, status: 0).is_status_avairable(btn1) }
      it { is_expected.to eq true }
    end
    context 'status1 (勤務中)からの出社ボタン押下' do
      subject { create(:normal, status: 1).is_status_avairable(btn1) }
      it { is_expected.to eq false }
    end
    context 'status1 (休憩中)からの戻りボタン押下' do
      subject { create(:normal, status: 3).is_status_avairable(btn2) }
      it { is_expected.to eq true }
    end
    #これでメソッドのラインカバレッジ的にはOK。後は定数に依存するのでスキップ
  end

  describe 'change_status メソッド' do #input は is_status_avairable メソッドと同じ
    btn1 = Constants::Attendance::STATUS_CHANGE_BTN[0]#出社ボタン
    btn2 = Constants::Attendance::STATUS_CHANGE_BTN[3]#戻るボタン
    context 'status0 (入力待ち)からの出社ボタン押下' do
      subject { create(:normal, status: 0).change_status(btn1) }
      it { is_expected.to eq true }
    end
    context 'status1 (勤務中)からの出社ボタン押下' do
      example 'RuntimeError' do
        expect{ create(:normal, status: 1).change_status(btn1) }.to raise_error(RuntimeError)
      end
    end
    context 'status1 (休憩中)からの戻りボタン押下' do
      subject { create(:normal, status: 3).change_status(btn2) }
      it { is_expected.to eq true }
    end
    #これでメソッドのラインカバレッジ的にはOK。後は定数に依存するのでスキップ
  end

end
