require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  setup do
    @article = articles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create article" do
    assert_difference('Article.count') do
      post :create, article: { assignment_id: @article.assignment_id, cms_link: @article.cms_link, deadline: @article.deadline, drive_link: @article.drive_link, editor_id: @article.editor_id, interest_id: @article.interest_id, line_manager_id: @article.line_manager_id, notes: @article.notes, progress_bar: @article.progress_bar, publish_date: @article.publish_date, user_id: @article.user_id, sections_progress_bar: @article.sections_progress_bar, start_date: @article.start_date, status: @article.status, title: @article.title }
    end

    assert_redirected_to article_path(assigns(:article))
  end

  test "should show article" do
    get :show, id: @article
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @article
    assert_response :success
  end

  test "should update article" do
    patch :update, id: @article, article: { assignment_id: @article.assignment_id, cms_link: @article.cms_link, deadline: @article.deadline, drive_link: @article.drive_link, editor_id: @article.editor_id, interest_id: @article.interest_id, line_manager_id: @article.line_manager_id, notes: @article.notes, progress_bar: @article.progress_bar, publish_date: @article.publish_date, user_id: @article.user_id, sections_progress_bar: @article.sections_progress_bar, start_date: @article.start_date, status: @article.status, title: @article.title }
    assert_redirected_to article_path(assigns(:article))
  end

  test "should destroy article" do
    assert_difference('Article.count', -1) do
      delete :destroy, id: @article
    end

    assert_redirected_to articles_path
  end
end
