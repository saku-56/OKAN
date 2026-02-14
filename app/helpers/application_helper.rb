module ApplicationHelper
  # フラッシュメッセージの背景色
  def flash_background_color(type)
    case type.to_sym
    when :notice, :success then "bg-green-200 text-green-800"
    when :alert, :alert then "bg-red-300 text-red-800"
    else "bg-blue-200 text-blue-800"
    end
  end

  # 入力フォーム
  def form_field_class(object, field_name)
    base_class = "border rounded px-3 py-2 w-full"
    if object.errors[field_name].any?
      "#{base_class} border-red-500 border-2 bg-red-50"
    else
      "#{base_class} border-gray-300"
    end
  end
end
