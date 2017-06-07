FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password "secretPassword"
    password_confirmation "secretPassword"
  end

  factory :gram do
    message "hello"
    picture { fixture_file_upload "#{Rails.root}/spec/fixtures/picture.jpeg", 'image/jpeg' }
    association :user
  end

end