module ApplicationHelper

  def self.to_json(obj, cols)
    result = Hash.new
    cols.each do |col|
      key = col[:name].to_sym
      if col.key?(:get_value)
        result[key] = col[:get_value].call(obj)
      else
        result[key] = obj[key]
      end
      if col.key?(:get_label)
        result[key.to_s + '_label'] = col[:get_label].call(obj)
      end
    end
    result
  end

end
