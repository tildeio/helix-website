module DemosHelper
  def github_link(text, path)
    link_to text, "https://github.com/tildeio/helix-website/blob/master/#{path}"
  end
end
