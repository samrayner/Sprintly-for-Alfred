class Sly::Person < Sly::Object
  attr_accessor :id, :first_name, :last_name, :email, :created_at, :last_login

  def initialize(attributes={})
    #defaults
    @id = 0
    @first_name = "No"
    @last_name = "one"
    @email = @created_at = @last_login = ""

    self.attr_from_hash!(attributes)
  end

  def full_name
    if(@first_name.empty?)
      return "Nobody"
    end

    name = @first_name

    if(!@last_name.empty?)
      name << " #{@last_name}"
    end

    name
  end
end