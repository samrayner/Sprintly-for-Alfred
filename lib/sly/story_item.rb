class Sly::StoryItem < Sly::Item
  attr_accessor :who, :what, :why

  def title=(value)
    parse_title(value)
  end

  def title
    prefixes = {
      who: "As a",
      what: "I want",
      why: "so that"
    }

    prefixes[:who] << "n" if self.who && ["a","e","i","o"].member?(self.who[0,1])

    "#{prefixes[:who]} #{self.who}, #{prefixes[:what]} #{self.what} #{prefixes[:why]} #{self.why}"
  end

  def slug
    str_to_slug(self.what)
  end

  private

  def parse_title(title)
    #default values
    @who = "__"
    @what = "__"
    @why = "__"

    captures = {
      "who" => "as an?|aa",
      "what" => " i want| iw",
      "why" => " so that| st"
    }

    regex_str = '^\s*'

    captures.each do |key,val|
      prefix = '(?:'+val+')\s+'
      if title.match(Regexp.new(prefix, true))
        regex_str << prefix+'(?<'+key+'>.+)'
      end
    end

    regex = Regexp.new(regex_str, true)

    matches = title.match(regex)

    if matches
      matches.names.each do |name|
        value = matches[name].strip
        value.sub!(/,$/, "") if name == "who"
        self.send(name+"=", value) unless value == self.send(name)
      end
    end
  end
end
