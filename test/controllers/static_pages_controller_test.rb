require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  #setupは同じ物を減らそうとする物。
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end
  
   test "should get root" do
    get root_path
    assert_response :success
  end

  test "should get home" do
    get root_path
    #assert_selectは特定の中に存在するかの有無を確認
    #今回ならtitleにHome | Ruby on Rails Tutorial Sample Appがあるか
    assert_response :success
    assert_select "title", "#{@base_title}"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end
  
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end
  
end


