module ApplicationHelper
  # フラッシュメッセージの背景色
  def flash_background_color(type)
    case type.to_sym
    when :notice then "bg-green-200 text-green-800"
    when :alert then "bg-red-300 text-red-800"
    else "bg-blue-200 text-blue-800"
    end
  end

  # 入力フォーム(エラー箇所のフォームは赤になる)
  def form_field_class(object, field_name)
    base_class = "input input-bordered w-full"
    if object.errors[field_name].any?
      "#{base_class} input-error bg-red-100"
    else
      "#{base_class} bg-white"
    end
  end

  # date用の入力フォーム
  def date_form_field_class(object, field_name)
    base_class = "border rounded px-3 py-2"
    if object.errors[field_name].any?
      "#{base_class} border-red-500 border-2 bg-red-50"
    else
      "#{base_class} border-gray-300"
    end
  end

  # 戻るボタン
  def back_link(fallback_path = root_path, text: "戻る")
    button_tag(
      type: "button",
      onclick: "if (document.referrer)
                  { history.back(); }
                else
                  { window.location.href ='#{fallback_path}'; }",
      class: "text-gray-800 hover:text-red-500 items-center gap-2 transition-colors duration-200 bg-transparent border-0 cursor-pointer",
    ) do
      content_tag(:i, "", class: "fa-solid fa-arrow-left fa-sm") +
      content_tag(:span, text)
    end
  end
end
