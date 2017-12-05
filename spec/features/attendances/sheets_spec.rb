require 'rails_helper'

feature 'attendances/sheet' do
  given(:user) {create(:user)}
  context '#index' do
    scenario "" do
    end
  end

  context '#sheet' do
    before do
      login(user)
    end
    scenario "当月の1日の文字列が含まれているか" do
      visit sheet_attendances_path
      check_str = "#{Date.today.month}月01日"
      expect(page.body).to have_content(check_str)
    end
    scenario "特定月の1日の文字列が含まれているか" do
      visit sheet_attendances_path(month: '2017-11')
      check_str = "11月01日"
      expect(page.body).to have_content(check_str)
    end
  end
end
