class Sly::Person < Sly::Object
  attr_accessor :id, :first_name, :last_name, :email, :created_at, :last_login

  def full_name
    if(!@first_name)
      return "Nobody"
    end

    name = @first_name

    if(@last_name)
      name << " #{@last_name}"
    end

    name
  end
end