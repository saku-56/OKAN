module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice, :success then "bg-green-200 text-green-800"
    when :alert, :alert then "bg-red-200 text-red-800"
    else "bg-blue-200 text-blue-800"
    end
  end
end
