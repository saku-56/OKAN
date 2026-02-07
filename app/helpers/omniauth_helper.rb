module OmniauthHelper
  def provider_name(provider)
    case provider.to_s
    when "google_oauth2"
      "Google"
    when "line"
      "LINE"
    end
  end
end
