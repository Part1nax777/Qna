class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URI::regexp(%w(http https)), message: 'is invalid' }

  def url_gist_link?
    url.match?(/gist.github.com\/.+\/.+/)
  end

  def gist_title
    gist.files.to_hash.first[1][:filename]
  end

  def gist_body
    gist.files.to_hash.first[1][:content]
  end

  private

  def gist
    gist_url = url.split('/').last
    GistService.new(gist_url).call
  end
end
