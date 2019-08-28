require 'rails_helper'

RSpec.shared_examples 'sphinxable' do |resource|

  it 'should ThinkingSphinx::Search' do
    expect(resource.search).to be_kind_of(ThinkingSphinx::Search)
  end
end
