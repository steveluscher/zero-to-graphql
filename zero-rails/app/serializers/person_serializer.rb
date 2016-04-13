class PersonSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :username, :friends
  def id
    object.id.to_s
  end
  def friends
    object.friend_ids.map do |id|
      Rails.application.routes.url_helpers.person_path(id)
    end
  end
end
