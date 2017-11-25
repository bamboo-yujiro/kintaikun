require 'rails_helper'

describe Attendance, type: :model do
  describe 'get_by_specified_month' do
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
    it { #attendance01
      expect(subject.first.start_in_breaks).to be_empty
    }
    it { #attendance02
      expect(subject[1].start_in_breaks.size).to eq(1)
      expect(subject[1].end_in_breaks.size).to eq(1)
    }
    it { #attendance03
      expect(subject[2].start_out_of_offices.size).to eq(1)
      expect(subject[2].end_out_of_offices.size).to eq(1)
    }
    it { #attendance04
      expect(subject[3].start_in_breaks.size).to eq(1)
      expect(subject[3].end_in_breaks.size).to eq(1)
      expect(subject[3].start_out_of_offices.size).to eq(1)
      expect(subject[3].end_out_of_offices.size).to eq(1)
    }
  end

end
