ActiveAdmin.register_page "Dashboard News" do

  menu parent: "لوحة التحكم", :priority => 2, :label => "فريق الأخبار"

  content :title => proc{ I18n.t("active_admin.dashboard_news") } do
    render(partial: 'admin/statistics/diagram_scripts')
    columns do
      column do
        x_axis = []
        data_series = []
        news_list = []
        total_list = []
        ((Date.today-1.month)..Date.today).each do |day|
          x_axis << day.to_s
          news_list << NewsArticle.approved.created_between(day, day).size
          total_list << Article.approved.created_between(day, day).size
        end
        data_series = [
          {name: "كل الفرق", data: total_list},
          {name: "فريق الآخبار", data: news_list}
        ]
        render(partial: 'admin/statistics/admin_line_chart', locals: {chart_title: "الانتاج الكلي للفرق", div_id: "articles_team", x_axis: x_axis, data_series: data_series})
      end
    end
    columns do
      column do
        panel 'تقسيم المقالات بالوضع' do
          data_series = []
          data_series << {name: "موافقة", y: NewsArticle.approved.size}
          data_series << {name: "استفسار", y: NewsArticle.inquired.size}
          data_series << {name: "رُفض", y: NewsArticle.rejected.size}
          data_series << {name: "معلق", y: NewsArticle.pending.size}
          render(partial: 'admin/statistics/admin_pie_chart', locals: {chart_title: "تقسيم المقالات بالوضع", div_id: "articles_approval_status", data_series: data_series})
        end
      end
      column do
        panel 'تقسيم المقالات بالحالة' do
          data_series = []
          data_series << {name: "نُشر", y: NewsArticle.where(status_id: Status.where(key: "published").first.try(:id)).size}
          data_series << {name: "لم ينشر", y: NewsArticle.where(status_id: Status.where(key: "not_published").first.try(:id)).size}
          data_series << {name: "تم التكليف", y: NewsArticle.where(status_id: Status.where(key: "received").first.try(:id)).size}
          data_series << {name: "تم الإستلام", y: NewsArticle.where(status_id: Status.where(key: "assigned").first.try(:id)).size}
          data_series << {name: "تم الرفض", y: NewsArticle.where(status_id: Status.where(key: "rejected").first.try(:id)).size}
          data_series << {name: "غير محدد", y: NewsArticle.where(status_id: nil).size}
          render(partial: 'admin/statistics/admin_pie_chart', locals: {chart_title: "تقسيم المقالات بالحالة", div_id: "articles_status", data_series: data_series})
        end
      end
    end

    columns do
      column do
        panel 'تقسيم المقالات المقترحة بالتصنيف' do
          x_axis = []
          data_series = []
          daily_counts = []
          weekly_counts = []
          monthly_counts = []
          Interest.all.each do |interest|
            x_axis << interest.title
            daily_counts << NewsArticle.created_daily_by_interest(interest.id).size
            weekly_counts << NewsArticle.created_weekly_by_interest(interest.id).size
            monthly_counts << NewsArticle.created_monthly_by_interest(interest.id).size
          end
          data_series = [
            {name: 'الإنتاج اليومي', data: daily_counts},
            {name: 'الإنتاج الإسبوعي', data: weekly_counts},
            {name: 'الإنتاج الشهري', data: monthly_counts}]
          render(partial: 'admin/statistics/admin_column_chart', locals: {chart_title: "تقسيم المقالات المقترحة بالتصنيف", div_id: "sugg_articles_interest", x_axis: x_axis, data_series: data_series})
        end
      end      
      column do
        panel 'تقسيم المقالات المقبولة بالتصنيف' do
          x_axis = []
          data_series = []
          daily_counts = []
          daily_targets = []
          weekly_counts = []
          weekly_targets = []
          monthly_counts = []
          monthly_targets = []
          approved_articles = NewsArticle.approved
          Interest.all.each do |interest|
            x_axis << interest.title
            daily_counts << approved_articles.created_daily_by_interest(interest.id).size
            daily_targets << interest.daily_target
            weekly_counts << approved_articles.created_weekly_by_interest(interest.id).size
            weekly_targets << interest.weekly_target
            monthly_counts << approved_articles.created_monthly_by_interest(interest.id).size
            monthly_targets << interest.monthly_target
          end

          data_series = [
            {name: 'الهدف اليومي', data: daily_targets, pointPadding: 0.35, pointPlacement: -0.2}, 
            {name: 'الإنتاج اليومي', data: daily_counts, pointPadding: 0.45, pointPlacement: -0.2}, 
            {name: 'الهدف الإسبوعي', data: weekly_targets, pointPadding: 0.35, pointPlacement: 0.0}, 
            {name: 'الإنتاج الإسبوعي', data: weekly_counts, pointPadding: 0.45, pointPlacement: 0.0}, 
            {name: 'الهدف الشهري', data: monthly_targets, pointPadding: 0.35, pointPlacement: 0.2}, 
            {name: 'الإنتاج الشهري', data: monthly_counts, pointPadding: 0.45, pointPlacement: 0.2}]
          render(partial: 'admin/statistics/admin_column_placement', locals: {chart_title: "تقسيم المقالات المقبولة بالتصنيف", div_id: "approved_articles_interest", x_axis: x_axis, data_series: data_series})
        end
      end
    end
    
    columns do
      column do
        panel 'تقسيم المقالات المقبولة بالبرسونا' do
          x_axis = []
          data_series = []
          daily_counts = []
          daily_targets = []
          weekly_counts = []
          weekly_targets = []
          monthly_counts = []
          monthly_targets = []
          Persona.all.each do |persona|
            x_axis << persona.name
            daily_counts << persona.articles.approved.created_daily.size
            daily_targets << persona.daily_target
            weekly_counts << persona.articles.approved.created_weekly.size
            weekly_targets << persona.weekly_target
            monthly_counts << persona.articles.approved.created_monthly.size
            monthly_targets << persona.monthly_target
          end
          data_series = [
            {name: 'الهدف اليومي', data: daily_targets, pointPadding: 0.35, pointPlacement: -0.2}, 
            {name: 'الإنتاج اليومي', data: daily_counts, pointPadding: 0.45, pointPlacement: -0.2},
            {name: 'الهدف الإسبوعي', data: weekly_targets, pointPadding: 0.35, pointPlacement: 0.0}, 
            {name: 'الإنتاج الإسبوعي', data: weekly_counts, pointPadding: 0.45, pointPlacement: 0.0}, 
            {name: 'الهدف الشهري', data: monthly_targets, pointPadding: 0.35, pointPlacement: 0.2}, 
            {name: 'الإنتاج الشهري', data: monthly_counts, pointPadding: 0.45, pointPlacement: 0.2}]
          render(partial: 'admin/statistics/admin_column_placement', locals: {chart_title: "تقسيم المقالات المقبولة بالبرسونا", div_id: "articles_persona", x_axis: x_axis, data_series: data_series})
        end
      end      
      column do
        panel 'تقسيم المقالات المقبولة بالمنطقة الجغرافية' do
          x_axis = []
          data_series = []
          daily_counts = []
          daily_targets = []
          weekly_counts = []
          weekly_targets = []
          monthly_counts = []
          monthly_targets = []
          approved_articles = NewsArticle.approved
          ArticleCountry.all.each do |ac|
            x_axis << ac.name
            daily_counts << approved_articles.created_daily_by_article_country(ac.id).size
            daily_targets << ac.daily_target
            weekly_counts << approved_articles.created_weekly_by_article_country(ac.id).size
            weekly_targets << ac.weekly_target
            monthly_counts << approved_articles.created_monthly_by_article_country(ac.id).size
            monthly_targets << ac.monthly_target
          end

          data_series = [
            {name: 'الهدف اليومي', data: daily_targets, pointPadding: 0.35, pointPlacement: -0.2}, 
            {name: 'الإنتاج اليومي', data: daily_counts, pointPadding: 0.45, pointPlacement: -0.2}, 
            {name: 'الهدف الإسبوعي', data: weekly_targets, pointPadding: 0.35, pointPlacement: 0.0}, 
            {name: 'الإنتاج الإسبوعي', data: weekly_counts, pointPadding: 0.45, pointPlacement: 0.0}, 
            {name: 'الهدف الشهري', data: monthly_targets, pointPadding: 0.35, pointPlacement: 0.2}, 
            {name: 'الإنتاج الشهري', data: monthly_counts, pointPadding: 0.45, pointPlacement: 0.2}]
          render(partial: 'admin/statistics/admin_column_placement', locals: {chart_title: "تقسيم المقالات المقبولة بالمنطقة الجغرافية", div_id: "approved_articles_ac", x_axis: x_axis, data_series: data_series})
        end
      end
    end

    columns do
      column do
        panel 'احدث المراسلين' do
          table_for Reporter.order('id desc').limit(10) do 
            column('الإسم') { |reporter| reporter.name } 
            column('البريد الإلكتروني') { |reporter| reporter.email }
            column('الجنسية') { |reporter| reporter.country.try(:name_ar) }
            column('عدد المقالات') { |reporter| NewsArticle.where(user_id: reporter.id).size }
          end
        end
      end
    end
    # columns do
    #   column do
    #     panel 'Recent Instructors' do
    #       table_for User.instructors.order('id desc').limit(10) do
    #         column('Date') { |user| user.created_at.to_s(:db) } 
    #         column('Name') { |user| link_to user.name, admin_user_path(user) }
    #       end
    #     end
    #   end
    #   column do
    #     panel 'Recent Moderators' do
    #       table_for User.moderators.order('id desc').limit(10) do
    #         column('Date') { |user| user.created_at.to_s(:db) } 
    #         column('Name') { |user| link_to user.name, admin_user_path(user) }
    #       end
    #     end
    #   end
    #   column do
    #     panel 'Recent Students' do
    #       table_for User.students.order('id desc').limit(10) do
    #         column('Date') { |user| user.created_at.to_s(:db) } 
    #         column('Name') { |user| link_to user.name, admin_user_path(user) }
    #       end
    #     end
    #   end
    # end
    
  end
end
