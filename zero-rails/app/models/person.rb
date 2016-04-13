class Person < ApplicationRecord
  has_and_belongs_to_many :friends,
    class_name: 'Person',
    join_table: :friendships,
    foreign_key: :person_id,
    association_foreign_key: :friend_id
end
