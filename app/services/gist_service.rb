class GistService
  def initialize(gist, client = default_client)
    @gist = gist
    @client = client
  end

  def call
    @client.gist(@gist)
  end

  private

  def default_client
    Octokit::Client.new(access_token: ENV['GIST_TOKEN'])
  end
end
