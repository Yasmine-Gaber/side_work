class Article < ActiveRecord::Base
	belongs_to :line_manager
	belongs_to :editor
	belongs_to :user
	belongs_to :assignment
  belongs_to :publisher
  belongs_to :designer
  belongs_to :interest
  belongs_to :status
  belongs_to :article_country
  belongs_to :incident_country, class_name: "Country"
  belongs_to :article_type
  belongs_to :team
  has_many :message_logs
  has_and_belongs_to_many :personas
  validates :user_id, presence: true

  enum approval_status: {approved: 3, inquired: 2, rejected: 1, pending: 0}
  MATERIALS_LIST = ["فيديو", "صور", "فيديو وصور"]
  EXECUTION_METHOD_LIST = ["مادة قائمة على التعددات", "فيتشر ستوري", "تقرير خبري", "آخر"]
  ALLOWED_ATTRIBUTES = [
                :title,
              :original_link,
              :interest_id,
              :article_type_id]
  attr_accessor :skip_save_to_sheet
  
  scope :created_between, lambda {|s, e| where(created_at: s.to_date.beginning_of_day..e.to_date.end_of_day)}
  scope :created_daily, -> {where(created_at: Date.today.beginning_of_day..Date.today.end_of_day)}
  scope :created_weekly, -> {where(created_at: Date.today.at_beginning_of_week(start_day= :sunday)..Date.today.at_end_of_week(start_day= :sunday))}
  scope :created_monthly, -> {where(created_at: Date.today.beginning_of_month..Date.today.end_of_month)}
  scope :created_daily_by_interest, lambda {|i| where(interest_id: i, created_at: Date.today.beginning_of_day..Date.today.end_of_day)}
  scope :created_weekly_by_interest, lambda {|i| where(interest_id: i, created_at: Date.today.at_beginning_of_week(start_day= :sunday)..Date.today.at_end_of_week(start_day= :sunday))}
  scope :created_monthly_by_interest, lambda {|i| where(interest_id: i, created_at: Date.today.beginning_of_month..Date.today.end_of_month)}
  scope :created_daily_by_article_country, lambda {|ac| where(article_country_id: ac, created_at: Date.today.beginning_of_day..Date.today.end_of_day)}
  scope :created_weekly_by_article_country, lambda {|ac| where(article_country_id: ac, created_at: Date.today.at_beginning_of_week(start_day= :sunday)..Date.today.at_end_of_week(start_day= :sunday))}
  scope :created_monthly_by_article_country, lambda {|ac| where(article_country_id: ac, created_at: Date.today.beginning_of_month..Date.today.end_of_month)}
  scope :translation, -> {where(team_id: Team.where(name: "مراسلون").first.try(:id))}
  scope :report, -> {where(team_id: Team.where(name: "ترجمة").first.try(:id))}
  scope :approved, -> {where("approval_status = 3")}
  scope :inquired, -> {where("approval_status = 2")}
  scope :rejected, -> {where("approval_status = 1")}
  scope :pending, -> {where("approval_status = 0")}
  scope :all_states, -> {where("approval_status in (0, 1, 2, 3)")}

  before_create :generate_token
  before_save :notify_on_status_change
  before_save :calculate_progress_bar
  before_save :calculate_sections_progress_bar
  after_save :save_to_sheet, unless: Proc.new { |article| article.skip_save_to_sheet }

  def reporter_id
    self.user_id
  end
  
  def reporter
    self.user
  end

  def calculate_progress_bar
    if self.start_date.present? && self.deadline.present?
      total_period = (self.deadline.to_date - self.start_date.to_date).to_i
      passed_period = (Date.today - self.start_date.to_date).to_i
      self.progress_bar = (passed_period.to_f / total_period) * 100
    end
  end

  def calculate_sections_progress_bar
    if self.interest.present?
      daily_percentage = (Article.created_daily_by_interest(self.interest_id).count.to_f / self.interest.daily_target) * 100
      weekly_percentage = (Article.created_weekly_by_interest(self.interest_id).count.to_f / self.interest.weekly_target) * 100
      monthly_percentage = (Article.created_monthly_by_interest(self.interest_id).count.to_f / self.interest.monthly_target) * 100
      self.sections_progress_bar = "Daily: #{daily_percentage.round(0)}%, Weekly: #{weekly_percentage.round(0)}%, Monthly: #{monthly_percentage.round(0)}%" 
    end
  end

  def save_to_sheet
    unless ["rejected"].include? self.approval_status
      session = GoogleDrive::Session.from_config("client_secret.json")
      ws = session.spreadsheet_by_key(SPREADSHEET_KEY).worksheets[0]

      row_id = self.sheet_row || (ws.num_rows + 1)
      self.update_column(:sheet_row, row_id) if self.sheet_row.blank?
      # T.Stump 
      # L.M. eMail  
      # Status  
      # Title 
      # Start Date  
      # Deadline  
      # Delivery Time 
      # Progress Bar  
      # Editor  
      # eMail 
      # eMai Sent 
      # Reporters 
      # From  
      # Assignment  
      # Drive 
      # Country 
      # Interest 
      # Sections Progress Bar 
      # CMS Link  
      # Notes           


      # T.Stamp Line Manager  Status  Title Start Date  Deadline  Publish Date  Publish Time  
      # Progress Bar  Editor  eMail eMai Sent Reporters From  Assignment  Drive Country 
      # Interests Sections Progress Bar CMS Link  Notes
      ws[sheet_row, 1] = self.id
      ws[sheet_row, 2] = self.created_at
      ws[sheet_row, 3] = self.article_type.try(:name)
      ws[sheet_row, 4] = self.team.try(:name)
      ws[sheet_row, 5] = self.title
      ws[sheet_row, 6] = self.details
      ws[sheet_row, 7] = self.personas.pluck(:name).join(", ")
      ws[sheet_row, 8] = self.article_country.try(:name)
      ws[sheet_row, 9] = self.processing_point_of_view
      ws[sheet_row, 10] = self.resources
      ws[sheet_row, 11] = self.resources_links
      ws[sheet_row, 12] = self.materials
      ws[sheet_row, 13] = self.why_publish
      ws[sheet_row, 14] = self.interest.try(:title)
      ws[sheet_row, 15] = self.editor.try(:email)
      ws[sheet_row, 16] = self.user.try(:email)
      ws[sheet_row, 17] = self.assignment.try(:name)
      ws[sheet_row, 18] = self.line_manager.try(:email)
      ws[sheet_row, 19] = self.publisher.try(:email)
      ws[sheet_row, 20] = self.deadline ? I18n.l(self.deadline.to_date, format: :default) : ""
      ws[sheet_row, 21] = self.deadline ? I18n.l(self.deadline, format: :time_only) : ""
      ws[sheet_row, 22] = self.publish_date ? I18n.l(self.publish_date.to_date, format: :default) : ""
      ws[sheet_row, 23] = self.publish_date ? I18n.l(self.publish_date, format: :time_only) : ""
      ws[sheet_row, 24] = self.drive_link
      ws[sheet_row, 25] = self.cms_link
      ws[sheet_row, 26] = self.original_words_count
      ws[sheet_row, 27] = self.reporter_desk_notes
      ws[sheet_row, 28] = self.trans_desk_notes
      ws[sheet_row, 29] = self.reporter_notes
      ws[sheet_row, 30] = self.manager_notes
      ws[sheet_row, 31] = self.article_token
      ws[sheet_row, 32] = self.publish_flag
      ws[sheet_row, 33] = self.status.try(:name)
      ws[sheet_row, 34] = self.designer.try(:email)
      ws[sheet_row, 35] = self.progress_bar ? "#{self.progress_bar} %" : "0%"
      ws[sheet_row, 36] = self.sections_progress_bar
      messages = []
      self.message_logs.each do |m|
        messages << "At #{m.created_at} #{m.description}"
      end
      ws[sheet_row, 37] = messages.join(", ")
      ws.save
    end
  end

  def notify_on_status_change
    if self.status_id.present? && self.status_id_changed? && self.status.key == "published"
      UserMailer.article_published(self.line_manager_id, self.id).deliver_now
      MessageLog.create(log_type: "article_published", description: "Line manager #{self.line_manager.name} is notified by article publishing", article_id: self.id)
      UserMailer.article_published_to_reporter(self.user_id, self.id).deliver_now
      MessageLog.create(log_type: "article_published", description: "Reporter #{self.user.name} is notified by article publishing", article_id: self.id)
    end
  end

  def notify_line_manager_when_publish_date_overdue
    if self.line_manager_id.present?
      UserMailer.article_overdue(self.line_manager_id, self.id).deliver_now
      MessageLog.create(log_type: "article_overdue", description: "Line manager #{self.line_manager.name} is notified by article's publish date overdue", article_id: self.id)
    end
  end

  def notify_line_manager_when_publish_date_near(period)
    if self.editor_id.present?
      UserMailer.article_near(self.editor_id, self.id, period).deliver_now
      MessageLog.create(log_type: "article_near_#{period}", description: "Editor #{self.editor.name} is notified by article deadline #{period} away", article_id: self.id)
    end
  end

  def notify_on_approval
    UserMailer.article_approved(self.line_manager_id, self.id).deliver_now if self.line_manager_id.present?
    MessageLog.create(log_type: "article_approved", description: "Line manager #{self.line_manager.name} is notified by article approval", article_id: self.id) if self.line_manager_id.present?
    UserMailer.article_approved(self.editor_id, self.id).deliver_now if self.editor_id.present?
    MessageLog.create(log_type: "article_approved", description: "Editor #{self.editor.name} is notified by article approval", article_id: self.id) if self.editor_id.present?
    UserMailer.article_approved_to_reporter(self.user_id, self.id).deliver_now
    MessageLog.create(log_type: "article_approved", description: "Reporter #{self.user.name} is notified by article approval", article_id: self.id)
  end

  def notify_reporter_on_comments_reply
    if self.line_manager_id.present?
      UserMailer.article_notify_with_reply_comments(self.line_manager_id, self.id).deliver_now 
      MessageLog.create(log_type: "reporter_reply_on_inquiry", description: "Line manager #{self.line_manager.name} is notified by reporter's reply on inquiry", article_id: self.id)
    end
    if self.editor_id.present?
      UserMailer.article_notify_with_reply_comments(self.editor_id, self.id).deliver_now 
      MessageLog.create(log_type: "reporter_reply_on_inquiry", description: "Editor #{self.editor.name} is notified by reporter's reply on inquiry", article_id: self.id)
    end
  end

  def notify_on_approval_with_comments
    if self.editor_id
      UserMailer.article_approved_with_comments(self.editor_id, self.id).deliver_now
      MessageLog.create(log_type: "article_inquired", description: "Editor #{self.editor.name} is notified by article approval with inquiry", article_id: self.id)
    end
    UserMailer.article_approved_with_comments(self.user_id, self.id).deliver_now
    MessageLog.create(log_type: "article_inquired", description: "Reporter #{self.user.name} is notified by article approval with inquiry", article_id: self.id)
  end

  def notify_reporter_on_submission
    UserMailer.article_submitted(self.user_id, self.id).deliver_now
  end

  def notify_on_updates
    UserMailer.article_updated(self.user_id, self.id).deliver_now
    MessageLog.create(log_type: "article_received", description: "Reporter #{self.user.name} is notified by article receiving", article_id: self.id)
    if self.line_manager_id
      UserMailer.article_updated_for_manager(self.line_manager_id, self.id).deliver_now
      MessageLog.create(log_type: "article_received", description: "Line Manager #{self.line_manager.name} is notified by article receiving", article_id: self.id)
    end
    if self.editor_id
      UserMailer.article_updated_for_manager(self.editor_id, self.id).deliver_now
      MessageLog.create(log_type: "article_received", description: "Editor #{self.editor.name} is notified by article receiving", article_id: self.id)
    end
  end

  def notify_reporter_on_rejection
    UserMailer.article_rejected_to_reporter(self.user_id, self.id).deliver_now
    MessageLog.create(log_type: "article_rejected", description: "Reporter #{self.user.name} is notified by article rejection", article_id: self.id)
  end

  #######
  private
  #######
  def generate_token
    self.article_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      token = "#{I18n.l(Time.now, format: :token, locale: :en)}-#{random_token}"
      break token unless Article.exists?(article_token: token)
    end
  end
end
