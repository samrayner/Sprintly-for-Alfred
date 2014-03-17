class Sly::Person < Sly::Object
  attr_accessor :id, :first_name, :last_name, :email, :created_at, :last_login

  def full_name
    return "Nobody" unless self.first_name

    name = self.first_name.dup
    name << " #{self.last_name}" if self.last_name

    name
  end

  def alfred_result
    Sly::WorkflowUtils.item("##{self.id}", self.full_name, self.email)
  end
end
