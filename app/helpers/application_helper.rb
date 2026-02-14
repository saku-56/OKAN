module ApplicationHelper
  # フラッシュメッセージの背景色
  def flash_background_color(type)
    case type.to_sym
    when :notice, :success then "bg-green-200 text-green-800"
    when :alert, :alert then "bg-red-300 text-red-800"
    else "bg-blue-200 text-blue-800"
    end
  end
end
