class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end

ActionController::Renderers.add :json do |json, options|
  unless json.kind_of?(String)
    json = json.as_json(options) if json.respond_to?(:as_json)
    json = JSON.pretty_generate(json, options)
  end
  self.content_type ||= Mime::JSON
  json
end
