FactoryGirl.define do

  factory :normal, class: Attendance do
    user_id 1
    date '2017-11-05'
  end

  factory :today, class: Attendance do
    user_id 1
    date Date.today
    status 1
  end

end
