class User < ApplicationRecord
  mailkick_user
  validates_uniqueness_of :email
end
