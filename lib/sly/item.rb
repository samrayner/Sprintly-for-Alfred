class Sly::Item < Sly::Object
  attr_accessor :status, :product, :description, :tags, :last_modified
  attr_accessor :number, :archived, :title, :short_url, :created_at
  attr_accessor :created_by, :score, :assigned_to, :type, :progress
  attr_accessor :parent, :index

  def initialize(attributes={})
    super(attributes)
    @score = @score.upcase if @score
    @tags = [] unless @tags

    if @parent
      @parent = Sly::Item.new_typed(@parent)
      @index = "#{@parent.number}.#{@number}"
    else
      @index = @number.to_s
    end
  end

  def self.types
    ["story", "task", "defect", "test"]
  end

  def self.defaults
    {
      status: "backlog",
      type: "task",
      title: "Preview",
      score: "~",
      tags: [],
      assigned_to: ""
    }
  end

  def self.scores
    {
      s:  "small",
      m:  "medium",
      l:  "large",
      xl: "extra-large"
    }
  end

  def self.creation_regex
    /^
      (?<type>story|task|defect|test)
      (?:\s+(?<score>s|m|l|xl))?
      (?:\s+(?<title>[^\#\@]+))?
      (?<tags>(?:\s+\#[^\#\@]*\s*)+\s*)?
      (?:\@(?<assigned_to>[\w]*))?
    $/ix
  end

  def self.new_typed(attributes={})
    type = self.hash_value(attributes, :type)

    if type
      Sly::const_get("#{type.capitalize}Item").new(attributes)
    else
      self.new(attributes)
    end
  end

  def self.hash_value(hash, key)
    value = nil

    if hash[key]
      value = hash[key]
    elsif hash[key.to_s]
      value = hash[key.to_s]
    end

    value
  end

  def ==(item)
    return false unless item
    self.number == item.number
  end
  alias_method :eql?, :==

  def title
    #prefix with arrow for sub-items
    "#{[0x21B3].pack('U')+' ' if self.parent}"+@title
  end

  def slug
    str_to_slug(self.title)
  end

  def alfred_result
    subtitle = "Assigned to #{self.assigned_to.full_name}  "

    self.tags.each { |tag| subtitle << " #"+tag }

    icon = "images/#{self.type}-#{self.score}.png".downcase
    Sly::WorkflowUtils.item("#"+self.number.to_s, self.title, subtitle, icon)
  end

  def git_branch
    type = (self.type == "story") ? "feature" : self.type
    slug = self.slug

    if(slug.length > 50)
      truncate_to = self.slug.index("-", 40)
      slug = self.slug[0,truncate_to]
    end

    "git checkout -b #{type}/#{self.number}-#{slug}"
  end

  def to_flat_hash
    hash = self.to_hash(true)
    hash[:tags] = hash[:tags].join(",") if hash[:tags].is_a?(Array)
    hash
  end

  protected

  def str_to_slug(str)
    str.strip.downcase.gsub(/(&|&amp;)/, ' and ').gsub(/[\s\/\\]/, '-').gsub(/[^\w-]/, '').gsub(/[-]{2,}/, '-').gsub(/^-|-$/, '')
  end
end
