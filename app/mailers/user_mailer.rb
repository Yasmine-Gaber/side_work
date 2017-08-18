class UserMailer < ActionMailer::Base
  default :from => MAILER_SENDER
  # layout 'email'
  helper :application

  def article_approved(user_id, article_id)
    @user = User.find user_id
    @article = Article.find article_id
    I18n.with_locale(:ar) do
      mail(:to => "#{@user.name} <#{@user.email}>",
        :subject => "تكليف بمتابعة مقال (#{@article.title})")
    end
  end
  
  def testemail(user_name, user_email, text_str)
    @user_name = user_name
    @text_str = text_str
    I18n.with_locale(:ar) do
      mail(:to => "#{@user_name} <#{user_email}>",
        :subject => "تم اختيارك لمتابعة مقال")
    end
  end

  def article_editor_selected(user_name, user_email, row, article_hash, header_row)
    @user_name = user_name
    @h_hash = article_hash
    @row = row
    @header_row = header_row
    I18n.with_locale(:ar) do
      mail(:to => "#{@user_name} <#{user_email}>",
        :subject => "تم اختيارك لمتابعة مقال")
    end
  end

  def article_published(user_name, user_email, row, article_hash, header_row)
    @user_name = user_name
    @h_hash = article_hash
    @row = row
    @header_row = header_row
    I18n.with_locale(:ar) do
      mail(:to => "#{@user_name} <#{user_email}>",
        :subject => "تم نشر مقال جديد")
    end
  end

  def article_published_to_reporter(user_name, user_email, row, article_hash, header_row)
    @user_name = user_name
    @h_hash = article_hash
    @row = row
    @header_row = header_row
    I18n.with_locale(:ar) do
      mail(:to => "#{@user_name} <#{user_email}>",
        :subject => "تم نشر مقالك الجديد")
    end
  end

  def article_overdue(user_name, user_email, row, article_hash, header_row)
    @user_name = user_name
    @h_hash = article_hash
    @row = row
    @header_row = header_row
    I18n.with_locale(:ar) do
      mail(:to => "#{@user_name} <#{user_email}>",
        :subject => "مقال لم ينشر في موعده")
    end
  end
  
  def article_near(user_name, user_email, row, article_hash, header_row, period)
    @period = (period == "one_day") ? "24 ساعة" : "3 ساعات"
    @user_name = user_name
    @h_hash = article_hash
    @row = row
    @header_row = header_row
    I18n.with_locale(:ar) do
      mail(:to => "#{@user_name} <#{user_email}>",
        :subject => "مقال يلزم تسليمه في خلال #{@period}")
    end
  end

  def article_submitted(user_id, article_id)
    @user = User.find user_id
    @article = Article.find article_id
    I18n.with_locale(:ar) do
      mail(:to => "#{@user.name} <#{@user.email}>",
        :subject => "استلام مقترح (#{@article.title})")
    end
  end

  def anonymous_article_submitted(user_email, article_title)
    @user_email = user_email
    @article_title = article_title
    I18n.with_locale(:ar) do
      mail(:to => "#{user_email} <#{user_email}>",
        :subject => "تم استلام اقتراحك")
    end
  end

  def anonymous_article_submision_notification(user_email, reporter_email, options={})
    @user_email = user_email
    @reporter_email = reporter_email
    @options = options
    I18n.with_locale(:ar) do
      mail(:to => "#{user_email} <#{user_email}>",
        :subject => "تم استلام اقتراح من مجهول")
    end
  end

  def article_updated(user_id, article_id)
    @user = User.find user_id
    @article = Article.find article_id
    I18n.with_locale(:ar) do
      mail(:to => "#{@user.name} <#{@user.email}>",
        :subject => "استلام مقالك (#{@article.title})")
    end
  end

  def article_updated_for_manager(user_id, article_id)
    @user = User.find user_id
    @article = Article.find article_id
    I18n.with_locale(:ar) do
      mail(:to => "#{@user.name} <#{@user.email}>",
        :subject => "التفضل بمراجعة المقال المستلم من  (#{@article.title})")
    end
  end
  
  def article_approved_to_reporter(user_id, article_id)
    @user = User.find user_id
    @article = Article.find article_id
    I18n.with_locale(:ar) do
      mail(:to => "#{@user.name} <#{@user.email}>",
        :subject => "قبول المقترح (#{@article.title})")
    end
  end

  def article_approved_with_comments(user_id, article_id)
    @user = User.find user_id
    @article = Article.find article_id
    I18n.with_locale(:ar) do
      mail(:to => "#{@user.name} <#{@user.email}>",
        :subject => "استفسار حول المقترح (#{@article.title})")
    end
  end

  def article_notify_with_reply_comments(user_id, article_id)
    @user = User.find user_id
    @article = Article.find article_id
    I18n.with_locale(:ar) do
      mail(:to => "#{@user.name} <#{@user.email}>",
        :subject => "قام الكاتب #{@article.user.name} بالإجابة على الاستفسارات حول المقال: (#{@article.title})")
    end
  end

  def article_rejected_to_reporter(user_id, article_id)
    @user = User.find user_id
    @article = Article.find article_id
    I18n.with_locale(:ar) do
      mail(:to => "#{@user.name} <#{@user.email}>",
        :subject => "رفض المقترح (#{@article.title})")
    end
  end
end
