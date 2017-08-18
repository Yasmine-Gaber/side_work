class NewsArticle < Article
  default_scope { where(article_type_id: ArticleType.where(key: "news").first.try(:id)) }
end
