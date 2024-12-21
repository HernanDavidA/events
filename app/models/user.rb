class User < ApplicationRecord
  has_many :events



  private
  def is_normal_user?
    self.permission_level == 0
  end
  def is_admin?
    self.permission_level == 1
  end
end
