class Services::Search
  def call(params)
    search_scope = ['answer', 'question', 'comment', 'user']
                   .select { |scope| params[scope] == '1' }
                   .map { |selected_scope| selected_scope.classify.constantize }

    query = ThinkingSphinx::Query.escape(params['query']) if params['query']
    ThinkingSphinx.search query, classes: search_scope
  end
end

