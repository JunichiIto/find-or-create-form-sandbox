class User < ActiveRecord::Base
  belongs_to :group
  attr_accessor :group_name
  validates :name, presence: true

  before_save :find_or_create_group
  def find_or_create_group
    if group_name.present?
      self.group = Group.find_or_create_by!(name: group_name)
    end
  end
end
