FactoryGirl.define do

  factory :user, class: User do
    name 'SampleUser'
    email 'hoge@hoge.com'
    password '12345678'
  end

end
