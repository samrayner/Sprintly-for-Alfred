require 'rexml/document'

class Sly::WorkflowUtils
  def self.array_to_xml(array)
    raise "Argument must be an Array" unless array.kind_of? Array

    doc = REXML::Document.new
    root = doc.add_element("items")
    for entry in array
      item = root.add_element("item")
      entry.each do |key, value|
        if key == :uid or key == :arg
          item.attributes[key.to_s] = value.to_s
        else
          element = item.add_element(key.to_s)
          element.text = value ? value.to_s : ""
        end
      end
    end

    doc.to_s
  end

  def self.item(uid, arg, title, subtitle, icon="icon.png", valid=true)
    return {
      uid:uid, 
      arg:arg,
      title:title,
      subtitle:subtitle,
      icon:icon,
      valid:valid
    }
  end

  def self.results_feed(items)
    feed_items = []
    
    items.each do |item|
      feed_items << item.alfred_result
    end

    self.array_to_xml(feed_items)
  end
end