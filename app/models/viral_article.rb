class ViralArticle < Article
  default_scope { where(article_type_id: ArticleType.where(key: "viral").first.try(:id)) }
end
