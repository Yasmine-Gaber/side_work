ActiveAdmin.register Article, as: "TranslateArticle" do
  menu parent: 'الفرق', priority: 13
  actions :all, except: [:destroy]
  
  permit_params :title, :user, :user_id, :team_id, :team, :publish_flag, :article_type, :article_type_id, :line_manager_id, :status_id, :interest_id, :start_date, :deadline, :publish_date, :editor_id, :assignment_id, :drive_link, :cms_link, :notes, :approval_comments, :article_country_id, :original_words_count, :details, :publisher, :publisher_id, :designer, :designer_id, :reporter_desk_notes, :trans_desk_notes, :reporter_notes, :manager_notes, persona_ids: []

  scope proc{ "كل المواضيع" }, :all_states, default: true
  scope proc{ "مقبول" }, :approved
  scope proc{ "استفسار" }, :inquired
  scope proc{ "اقتراح" }, :pending
  scope proc{ "مرفوض" }, :rejected

  batch_action :approve, form: -> { {line_manager_id: LineManager.pluck(:name, :id), editor_id: Editor.pluck(:name, :id)} } do |ids, inputs|
    articles = Article.where(id: ids)
    articles.update_all(approval_status: Article.approval_statuses["approved"], start_date: Date.today, status_id: Status.where(key: "assigned").first.id, line_manager_id: inputs[:line_manager_id].to_i, editor_id: inputs[:editor_id].to_i)
    articles.each do |article|
      article.notify_on_approval
    end
    redirect_to collection_path, notice: "تم قبول المقالات المختارة"
  end

  batch_action :approve_with_comments, form: -> { {line_manager_id: LineManager.pluck(:name, :id), editor_id: Editor.pluck(:name, :id), approval_comments: :textarea} } do |ids, inputs|
    articles = Article.where(id: ids)
    articles.update_all(approval_status: Article.approval_statuses["inquired"], status_id: Status.where(key: "assigned").first.id, line_manager_id: inputs[:line_manager_id].to_i, editor_id: inputs[:editor_id].to_i, approval_comments: inputs[:approval_comments])
    articles.each do |article|
      article.notify_on_approval_with_comments
    end
    redirect_to collection_path, notice: "تم ارسال التعليقات الخاصة بالمقالات المختارة الي المراسل"
  end

  batch_action :reject, confirm: "هل أنت متأكد من رفض المقالات المختارة؟" do |ids|
    articles = Article.where(id: ids)
    articles.update_all(approval_status: Article.approval_statuses["rejected"], status_id: Status.where(key: "rejected").first.id)
    articles.each do |article|
      article.notify_reporter_on_rejection
    end
    redirect_to collection_path, notice: "تم رفض المقالات المختارة"
  end

  batch_action :assign_lm, form: -> { {line_manager_id: LineManager.pluck(:name, :id)} } do |ids, inputs|
    Article.where(id: ids).update_all(line_manager_id: inputs[:line_manager_id].to_i)
    redirect_to collection_path, notice: "تم تعيين المدير #{LineManager.find(inputs[:line_manager_id].to_i).name} للمقالات المختارة"
  end

  batch_action :assign_editor, form: -> { {editor_id: Editor.pluck(:name, :id)} } do |ids, inputs|
    Article.where(id: ids).update_all(editor_id: inputs[:editor_id].to_i)
    redirect_to collection_path, notice: "تم تعيين المحرر #{Editor.find(inputs[:editor_id].to_i).name} للمقالات المختارة"
  end

  batch_action :change_status, form: -> { {status_id: Status.pluck(:name, :id)} } do |ids, inputs|
    Article.where(id: ids).where.not(line_manager_id: nil).update_all(status_id: inputs[:status_id])
    not_updated_articles = Article.where(id: ids).where(line_manager_id: nil).pluck(:id)
    redirect_to collection_path, notice: "تم تغيير حالة المقالات المختارة الي #{Status.find(inputs[:status_id]).name} #{(["، ما عدا المقالات ذات الرقم ", not_updated_articles.join("، ")].join(" ")) if not_updated_articles.present?}"
  end
  
  controller do
    def scoped_collection
      Article.where(team_id: Team.where(name: "ترجمة").first.try(:id))
    end

    def approve
      @article = Article.find(params[:id])
      render layout: false
    end

    def approve_with_comments
      @article = Article.find(params[:id])
      render layout: false
    end

    def approve_update
      @article = Article.find(params[:id])
      @article.approval_status = Article.approval_statuses["approved"]
      @article.start_date = Date.today
      @article.status = Status.where(key: "assigned").first
      @article.update(permitted_params[:article])
      @article.notify_on_approval
      render 'quick_response', layout: false
    end

    def approve_with_comments_update
      @article = Article.find(params[:id])
      @article.approval_status = Article.approval_statuses["inquired"]
      @article.update(permitted_params[:article])
      @article.notify_on_approval_with_comments
      render 'quick_response', layout: false
    end

    def reject
      @article = Article.find(params[:id])
      @article.approval_status = Article.approval_statuses["rejected"]
      @article.status = Status.where(key: "rejected").first
      @article.save
      @article.notify_reporter_on_rejection
      render 'quick_response', layout: false
    end


    def modal_cancel
      @article = Article.find(params[:id])
      render 'quick_response', layout: false
    end
  end

  index do
    selectable_column
    column :id
    column :created_at
    column :article_type
    column :team
    column :status
    column :title
    column :details
    # column :personas do |article|
    #   article.personas.map{|p| link_to(p.name, admin_persona_path(p))}.join(" , ").html_safe
    # end
    # column :article_country
    # column :interest
    column :line_manager
    column :editor
    column :assignment
    # column :publisher
    # column :designer
    column :deadline
    # column :publish_date
    # column :drive_link
    # column :cms_link
    # column :original_words_count
    # column :reporter_desk_notes
    # column :trans_desk_notes
    # column :reporter_notes
    # column :manager_notes
    # column :publish_flag
    column :article_token

    actions defaults: true do |article|
      if article.approval_status == "pending" || article.approval_status == "inquired"
        links = ''.html_safe
        links += link_to I18n.t("active_admin.batch_actions.labels.approve"), approve_admin_article_path(article), title: "", class: 'fancybox member_link', data: { 'fancybox-type' => 'ajax' }
        links += link_to I18n.t("active_admin.batch_actions.labels.reject"), reject_admin_article_path(article), remote: true, title: "", class: 'member_link'
        (links += link_to(I18n.t("active_admin.batch_actions.labels.approve_with_comments"), approve_with_comments_admin_article_path(article), title: "", class: 'fancybox member_link', data: { 'fancybox-type' => 'ajax' })) unless article.approval_status == "approved_with_comments"
      end
      links
    end
  end

  form do |f|
    f.inputs do
      f.input :user, as: :select2
      f.input :article_type
      f.input :team
      f.input :status
      f.input :title
      f.input :details, input_html: {rows: 5}
      f.input :personas , as: :check_boxes
      f.input :article_country
      f.input :interest
      f.input :editor, as: :select2
      f.input :assignment, as: :select2
      f.input :line_manager, as: :select2
      f.input :publisher, as: :select2
      f.input :designer, as: :select2
      f.input :deadline, as: :date_time_picker
      f.input :publish_date, as: :date_time_picker
      f.input :drive_link
      f.input :cms_link
      f.input :original_words_count
      f.input :reporter_desk_notes, input_html: {rows: 5}
      f.input :trans_desk_notes, input_html: {rows: 5}
      f.input :reporter_notes, input_html: {rows: 5}
      f.input :manager_notes, input_html: {rows: 5}
      f.input :publish_flag
    end
    f.actions
  end

  show do |article|
    attributes_table do
      row :id
      row :article_type
      row :team
      row :status
      row :created_at
      row :title
      row :details
      row :personas do
        article.personas.map{|p| link_to(p.name, admin_persona_path(p))}.join(" , ").html_safe
      end
      row :interest_id
      row :article_country
      row :editor
      row :assignment
      row :line_manager
      row :publisher
      row :designer
      row :deadline
      row :publish_date
      row :drive_link
      row :cms_link
      row :original_words_count
      row :reporter_desk_notes
      row :trans_desk_notes
      row :reporter_notes
      row :manager_notes
      row :article_token
      row :publish_flag do
        article.publish_flag ? status_tag( "نعم", :yes ) : status_tag( "لا" )
      end
      
      panel "Logs" do
        table_for article.message_logs.order('created_at ASC') do
          column :created_at
          column :description
        end
      end
    end
    active_admin_comments
  end
end
