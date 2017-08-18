namespace :processing do
  desc "Update data from sheet"
  task process_all: :environment do
    total_t_start = Time.now
    puts ">>> Start script at #{total_t_start} ..."
    # key_Y = "1xHAuMBjbjYZc4QWUro4NK9_qcc8tBzEi4jhAf1p259M"
    # key_R = "1O8BnzYDBGd-ucld1YmwNDi9Pvro8_XGMyQiHjJv6mZM"
    # key_test = "1Y4DAA6Mi5Yxdhq2BSn02OD9F2Kz7t1tQI9U-z44kmlg"
    key_test = "1F3iTHznzltmf2CO3SYL_6oAFUqDhr_RPgLTlf3ZzMAU"
    # [key_R, key_Y]
    [key_test].each do |sheet_key|
      sheet_t_start = Time.now
      puts ">>> Load sheet #{sheet_key} at #{sheet_t_start} ..."
      session = GoogleDrive::Session.from_config("config.json")
      sheets = session.spreadsheet_by_key(sheet_key).worksheets
      sheet = nil
      dataSheet = nil
      sheets.each do |s|
        sheet = s if s.title == "Articles"
        dataSheet = s if s.title == "Tables"
      end
      settingsData = dataSheet.rows
      startRowIndx = settingsData[13][0].to_i
      if settingsData[1][0] == "ON"
        articles = sheet.rows
        h_hash = {}
        header_row = sheet.rows[0]
        titles_header = sheet.rows[1]
        h_hash[:statusColKey] = header_row.index("0")
        h_hash[:progressBarColKey] = header_row.index("1")
        h_hash[:titleColKey] = header_row.index("2")
        h_hash[:timestampColKey] = header_row.index("3")
        h_hash[:deadlineColKey] = header_row.index("4")
        h_hash[:deliveryTimeColKey] = header_row.index("5")
        h_hash[:startDateColKey] = header_row.index("6")
        h_hash[:teamColKey] = header_row.index("7")
        h_hash[:lmColKey] = header_row.index("8")
        h_hash[:translationSourceColKey] = header_row.index("9")
        h_hash[:reporterColKey] = header_row.index("10")
        h_hash[:countryColKey] = header_row.index("11")
        h_hash[:editorColKey] = header_row.index("12")
        h_hash[:driveColKey] = header_row.index("13")
        h_hash[:cmsLinkColKey] = header_row.index("14")
        h_hash[:regionColKey] = header_row.index("15")
        h_hash[:sectionColKey] = header_row.index("16")
        h_hash[:newsEditorColKey] = header_row.index("17")
        h_hash[:publishDateColKey] = header_row.index("18")
        h_hash[:publishTimeColKey] = header_row.index("19")
        h_hash[:notesColKey] = header_row.index("20")
        h_hash[:lmNotifiedPublishColKey] = header_row.index("21")
        h_hash[:lmNotifiedColKey] = header_row.index("22")
        h_hash[:editorNotifiedDayColKey] = header_row.index("23")
        h_hash[:editorNotifiedHoursColKey] = header_row.index("24")
        h_hash[:editorNotifiedColKey] = header_row.index("25")
        h_hash[:updateProgressColKey] = header_row.index("26")
        h_hash[:publishColKey] = header_row.index("27")

        (startRowIndx..articles.length-1).each do |i|
          row = articles[i];
          # emailLMOnPublish
          # begin
          # if row[h_hash[:lmNotifiedPublishColKey]] == "" && row[h_hash[:statusColKey]] == "نُشر"
          #   puts "IN emailLMOnPublish .. i: #{i}"
          #   toEmail = getEmail(row[h_hash[:lmColKey]], 1, settingsData)
          #   if toEmail != ""
          #     UserMailer.article_published(row[h_hash[:lmColKey]], toEmail, row, h_hash, titles_header).deliver!
          #     sheet[i+1, h_hash[:lmNotifiedPublishColKey]+1] = toEmail
          #   end
          #   toEmail = getEmail(row[h_hash[:reporterColKey]], 7, settingsData)
          #   if toEmail != ""
          #     UserMailer.article_published_to_reporter(row[h_hash[:reporterColKey]], toEmail, row, h_hash, titles_header).deliver!
          #   end
          # end
          # rescue Exception => e
          #   puts "#{Time.now} - ERROR IN emailLMOnPublish .. i: #{i}"
          #   puts e.backtrace
          # end
        
          # emailLMOnOverdue
          begin
          if (row[h_hash[:lmNotifiedColKey]] == "") && row[h_hash[:deadlineColKey]] != ""
            diff = diffDateFromNowInHours(row[h_hash[:deadlineColKey]], row[h_hash[:deliveryTimeColKey]])
            if row[h_hash[:statusColKey]] != "نُشر" && row[h_hash[:statusColKey]] != "مرفوض" && diff < 0 && row[h_hash[:publishColKey]] == ""
              puts "IN emailLMOnOverdue .. i: #{i}"
              toEmail = getEmail(row[h_hash[:lmColKey]], 1, settingsData)
              if toEmail != ""
                UserMailer.article_overdue(row[h_hash[:lmColKey]], toEmail, row, h_hash, titles_header).deliver!
                sheet[i+1, h_hash[:lmNotifiedColKey]+1] = toEmail
              end
            end
          end
          rescue Exception => e
            puts "#{Time.now} - ERROR IN emailLMOnOverdue .. i: #{i}"
            puts e.backtrace
          end

          # emailEditorOnSelection
          begin
          if row[h_hash[:editorNotifiedColKey]] == "" && row[h_hash[:newsEditorColKey]] != "" && row[h_hash[:statusColKey]] != "نُشر" && row[h_hash[:statusColKey]] != "مرفوض"
            puts "IN emailEditorOnSelection .. i: #{i}"
            toEmail = getEmail(row[h_hash[:newsEditorColKey]], 3, settingsData)
            if toEmail != ""
              # TODO send email
              UserMailer.article_editor_selected(row[h_hash[:editorNotifiedColKey]], toEmail, row, h_hash, titles_header).deliver!
              sheet[i+1, h_hash[:editorNotifiedColKey]+1] = toEmail
            end
          end
          rescue Exception => e
            puts "#{Time.now} - ERROR IN emailEditorOnSelection .. i: #{i}"
            puts e.backtrace
          end

          # emailEditorOnDeadlineDayAway
          begin
          if row[h_hash[:editorNotifiedDayColKey]] == "" && row[h_hash[:deadlineColKey]] != "" && row[h_hash[:statusColKey]] != "نُشر" && row[h_hash[:statusColKey]] != "مرفوض"
            diff = diffDateFromNowInHours(row[h_hash[:deadlineColKey]], row[h_hash[:deliveryTimeColKey]])
            if diff < 24
              puts "IN emailEditorOnDeadlineDayAway .. i: #{i}"
              toEmail = getEmail(row[h_hash[:newsEditorColKey]], 3, settingsData)
              if toEmail != ""
                UserMailer.article_near(row[h_hash[:newsEditorColKey]], toEmail, row, h_hash, titles_header, "one_day").deliver!
                sheet[i+1, h_hash[:editorNotifiedDayColKey]+1] = toEmail
              end
            end
          end
          rescue Exception => e
            puts "#{Time.now} - ERROR IN emailEditorOnDeadlineDayAway .. i: #{i}"
            puts e.backtrace
          end

          # emailEditorOnDeadlineThreeHoursAway
          begin
          if row[h_hash[:editorNotifiedHoursColKey]] == "" && row[h_hash[:deadlineColKey]] != "" && row[h_hash[:statusColKey]] != "نُشر" && row[h_hash[:statusColKey]] != "مرفوض"
            diff = diffDateFromNowInHours(row[h_hash[:deadlineColKey]], row[h_hash[:deliveryTimeColKey]])
            if diff < 3 
              puts "IN emailEditorOnDeadlineThreeHoursAway .. i: #{i}"
              toEmail = getEmail(row[h_hash[:newsEditorColKey]], 3, settingsData)
              if toEmail != ""
                UserMailer.article_near(row[h_hash[:newsEditorColKey]], toEmail, row, h_hash, titles_header, "three_hours").deliver!
                sheet[i+1, h_hash[:editorNotifiedHoursColKey]+1] = toEmail
              end
            end
          end
          rescue Exception => e
            puts "#{Time.now} - ERROR IN emailEditorOnDeadlineThreeHoursAway .. i: #{i}"
            puts e.backtrace
          end

          # updateProgressPar
          begin
          if row[h_hash[:deadlineColKey]] != ""
            diff = diffDateFromNowInHours(row[h_hash[:deadlineColKey]], row[h_hash[:deliveryTimeColKey]])
            if row[h_hash[:statusColKey]] != "نُشر" && row[h_hash[:statusColKey]] != "مرفوض" # diff > 0 && 
              puts "IN updateProgressPar .. i: #{i}"
              sheet[i+1, h_hash[:progressBarColKey]+1] = diff < 0 ? (-1) : diff.round(0)
            end
          else
            diff = diffDateFromNowInHours(Date.today.to_s, "")
            if row[h_hash[:statusColKey]] != "نُشر" && row[h_hash[:statusColKey]] != "مرفوض" # diff > 0 && 
              puts "IN updateProgressPar .. i: #{i}"
              sheet[i+1, h_hash[:progressBarColKey]+1] = diff < 0 ? (-1) : diff.round(0)
            end
          end
          rescue Exception => e
            puts "#{Time.now} - ERROR IN updateProgressPar .. i: #{i}"
            puts e.backtrace
          end
        end
        sheet.save
      end
      puts ">>> Done sheet #{sheet_key} started at: #{sheet_t_start}, ended at: #{Time.now}"
      puts "----"*20  
    end
    puts ">>> Done script started at: #{total_t_start}, ended at: #{Time.now}"
    puts "===="*20
  end

  def diffDateFromNowInHours(row_date, row_time)
    delivery_time = row_time.blank? ? "6:00 PM" : row_time
    begin
      date1 = DateTime.strptime("#{row_date} #{delivery_time} +3", '%Y-%m-%d %H:%M %p %z')  
    rescue Exception => e
      date1 = DateTime.strptime("#{Date.today.to_s} 6:00 PM +3", '%Y-%m-%d %H:%M %p %z')  
    end
    ((Time.now.utc.in_time_zone(3) - date1)/1.hour)*-1
  end

  def getEmail(name, columnIndex, settingsData)
    email = ""
    (1..(settingsData[columnIndex+2][0].to_i)).each do |i|
      if settingsData[i][columnIndex] == name
        email = settingsData[i][columnIndex+1];
      end
    end
    email
  end

end
