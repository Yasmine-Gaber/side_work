class ArticlesController < InheritedResources::Base
  before_filter :load_reporter_by_email, only: [:create]
  before_filter :load_article, only: [:edit, :submit_comments]
  before_filter :set_locale

  def report
    @article = Article.new(team: Team.where(name: "مراسلون").first)
  end

  def translation
    @article = Article.new(team: Team.where(name: "ترجمة").first)
  end

  def create
    @article = Article.new(article_params)
    if @user.present? && @article.save
      @article.notify_reporter_on_submission
      redirect_to note_article_path(token: @article.article_token)
    else
      if @user.present? && !@article.valid?
        params[:article][:user_id] = @user.email
        render action: (@article.team.try(:name) == "مراسلون" ? "report" : "translation")
      elsif params[:article][:user_id].present? && !@article.valid?
        render action: (@article.team.try(:name) == "مراسلون" ? "report" : "translation")
      elsif !params[:article][:user_id].present? && !@article.valid?
        render action: (@article.team.try(:name) == "مراسلون" ? "report" : "translation")
      else
        UserMailer.anonymous_article_submitted(params[:article][:user_id], @article.title).deliver_now
        options = @article.attributes.reject{|k,v| !(Article::ALLOWED_ATTRIBUTES.include?(k.to_sym))}
        UserMailer.anonymous_article_submision_notification(ANONY_MAILER_RECEIVER, params[:article][:user_id], options).deliver_now
        redirect_to note_article_path(title: @article.title)
      end
    end
  end

  def update
    @article = Article.find params[:id]
    if params[:article][:approval_comments_reply].present?
      if @article.update_attributes(article_params)
        @article.notify_reporter_on_comments_reply
        redirect_to note_article_path(token: @article.article_token)
      else
        render action: 'submit_comments'
      end
    else
      @article.status = Status.where(key: "received").first
      if @article.update_attributes(article_params)
        @article.notify_on_updates
        redirect_to note_article_path(token: @article.article_token)
      else
        render action: 'edit'
      end
    end
  end

  def note
    @article = Article.where(article_token: params[:token]).first
    @article_title = params[:title]
  end

  private
    def load_reporter_by_email
      @user = User.where(type: "Reporter", email: params[:article][:user_id]).first
      params[:article][:user_id] = @user.id if @user.present?
    end

    def load_article
      @article = Article.where(article_token: params[:article_token]).first
    end

    def article_params
      params.require(:article).permit(:team_id, :user_id, :interest_id, :article_type_id,
        :title, :original_link,
        :suggested_idea, :incident_date, :incident_country_id, :processing_point_of_view,
        :why_publish, :resources, :resources_links, :execution_method, :materials, :deadline,
        :drive_link, :final_title, :translated_words_count, :original_words_count, :approval_comments_reply)
    end

    def set_locale
      I18n.locale = :ar
    end
end

