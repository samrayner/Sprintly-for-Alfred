class Sly::StoryItem < Sly::Item
  attr_accessor :who, :what, :why

  def title=(value)
    @title = value
    self.parse_title
  end

  def parse_title
    #default values
    @who = "user"
    @what = @title
    @why = "undefined"

    regex = /^\s*(?:as a|aa)\s+(?<who>.+)\s+(?:i want|iw)\s+(?<what>.+)\s+(?:so that|st)\s+(?<why>.+)/i

    matches = @title.match(regex)
    
    if(matches)
      matches.names.each do |name|
        self.send(name.to_s+"=", matches[name])
      end
    end
  end
end