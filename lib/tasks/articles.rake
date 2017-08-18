namespace :articles do
  desc "Notify line manager when article overdue"
  task publish_date_overdue: :environment do
    puts "Loading articles ..."
    already_notified_over_due_ids = MessageLog.where(log_type: "article_overdue").pluck(:article_id).uniq

    articles = Article.where.not(id: already_notified_over_due_ids).where("publish_date < ?", Time.now)
    articles.find_each do |article|
      begin
        article.notify_line_manager_when_publish_date_overdue
      rescue Exception => e
        puts "article: #{article.id}, has an error"
      end
    end
    puts "Done."
  end

  desc "Notify editor when article one day away"
  task publish_date_near_one_day: :environment do
    puts "Loading articles ..."
    already_notified_near_ids = MessageLog.where(log_type: "article_near_one_day").pluck(:article_id).uniq

    articles = Article.where.not(id: already_notified_near_ids).where(deadline: Time.now..(Time.now + 1.day))
    articles.find_each do |article|
      begin
        article.notify_line_manager_when_publish_date_near("one_day")
      rescue Exception => e
        puts "article: #{article.id}, has an error"
      end
    end
    puts "Done."
  end

  desc "Notify editor when article three hours away"
  task publish_date_near_three_hours: :environment do
    puts "Loading articles ..."
    already_notified_near_ids = MessageLog.where(log_type: "article_near_three_hours").pluck(:article_id).uniq

    articles = Article.where.not(id: already_notified_near_ids).where(deadline: Time.now..(Time.now + 3.hour))
    articles.find_each do |article|
      begin
        article.notify_line_manager_when_publish_date_near("three_hours")
      rescue Exception => e
        puts "article: #{article.id}, has an error"
      end
    end
    puts "Done."
  end

  desc "Update data from sheet"
  task update_data_from_sheet: :environment do
    puts "Loading sheet ..."
    session = GoogleDrive::Session.from_config("client_secret.json")
    ws = session.spreadsheet_by_key("19eDIldQXXuFPEz3770sxkYOxEPYP8-5P7nrNLa3L4a0").worksheets[0]
    (3..ws.num_rows).each do |row|
      print "."
      s = DateTime.parse(ws[row,1])
      article = Article.where(:created_at => ((s-1.minute)..(s+1.minute)), title: ws[row,4]).first
      begin
        if article.present?
          old_line_manager_id = article.line_manager_id
          old_editor_id = article.editor_id
          article.line_manager = LineManager.where(email: ws[row, 2]).first
          article.editor = Editor.where(email: ws[row, 11]).first || Editor.where(name: ws[row, 10]).first
          status = Status.where(name: ws[row, 3]).first
          if status && article.status != "rejected" && status.key == "rejected"
            article.approval_status = Article.approval_statuses["rejected"] 
            article.notify_reporter_on_rejection
          end
          article.status = status
          article.start_date = ws[row, 5]
          article.deadline = ws[row, 6]
          article.publish_date = "#{ws[row, 7]} #{ws[row, 8]}"
          article.assignment = Assignment.where(name: ws[row, 15]).first 
          article.drive_link = ws[row, 16]
          article.article_country = Assignment.where(name: ws[row, 17]).first 
          article.interest = Assignment.where(name: ws[row, 18]).first
          article.cms_link = ws[row, 20]
          article.notes = ws[row, 21]
          article.skip_save_to_sheet = true
          article.save
          if article.line_manager_id != old_line_manager_id && article.editor_id != old_editor_id
            article.approval_status = Article.approval_statuses["approved"]
            article.start_date = Date.today if article.start_date.blank?
            article.status = Status.where(key: "assigned").first
            article.notify_on_approval
            article.skip_save_to_sheet = true
            article.save
          end
        end
      rescue Exception => e
        puts "row: #{row}, article: #{article.try(:id)}, has an error"
      end
    end
    puts "Done."
  end

  desc "Reset data in sheet"
  task reset_data_in_sheet: :environment do
    puts "Loading articles ..."
    session = GoogleDrive::Session.from_config("client_secret.json")
    ws = session.spreadsheet_by_key("19eDIldQXXuFPEz3770sxkYOxEPYP8-5P7nrNLa3L4a0").worksheets[0]
    total_rows = ws.num_rows
    if total_rows > 500
      sheet_rows = (3..total_rows).to_a
      removed_rows_count = (total_rows-2) - 100
      puts "Extra rows to remove, total rows: #{total_rows-2}, rows to be removed: #{removed_rows_count} .."
      (3..total_rows).each do |row|
        (1..22).each do |col|
          ws[row, col] = ""
        end
      end
      puts "Cleared current sheet .."
      ws.save
      puts "Writting new articles .."
      Article.where(sheet_row: sheet_rows).each do |article|
        print "."
        if article.sheet_row <= (removed_rows_count +2)
          article.update_column(:sheet_row, nil) 
        else 
          article.update_attribute(:sheet_row, article.sheet_row - removed_rows_count) 
        end
      end
      puts " "
    else
      puts "No rows to remove .."
    end
    
    puts "Done."
  end

  desc "Set team_id instead of team"
  task set_team_id: :environment do
    puts "Loading articles ..."
    
    Article.all.find_each do |article|
      begin
        article.update_column(:team_id, Team.where(name: article.team).first.try(:id))
      rescue Exception => e
        puts "article: #{article.id}, has an error"
      end
    end
    puts "Done."
  end  
end
