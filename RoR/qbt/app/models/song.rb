class Song < ActiveRecord::Base
  has_many :tasks
end
