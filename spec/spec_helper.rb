load "sprintly_details.rb"
require_relative '../lib/sly'

def capture_stdout(&block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end

def obj_attr_match(obj1, obj2)
  obj1.instance_variables.each do |var|
    if(obj2.instance_variable_get(var) != obj1.instance_variable_get(var))
      return false
    end
  end

  true
end