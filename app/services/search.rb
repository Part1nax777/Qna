class Services::Search
  SCOPES = ['answer', 'question', 'comment', 'user'].freeze

  def call(params)
    @params = params
    search
  end

  private

  def search
    search_scope = []
    SCOPES.each do |scope|
      search_scope.push(make_klass(scope)) if @params[scope] == '1'
    end

    ThinkingSphinx.search query_string, classes: search_scope
  end

  def query_string
    ThinkingSphinx::Query.escape(@params['query']) if @params['query']
  end

  def make_klass(scope)
    scope.classify.constantize
  end
end
