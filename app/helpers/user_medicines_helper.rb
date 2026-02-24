module UserMedicinesHelper
  def stock_card_classes(stock)
    if stock <= 0
      "border-red-500 bg-red-50 hover:bg-red-100"
    elsif stock <= 10
      "border-yellow-500 bg-yellow-50 hover:bg-yellow-100"
    else
      "border bg-white hover:bg-gray-50"
    end
  end

  def stock_status_badge(stock)
    if stock <= 0
      content_tag(:span, "在庫切れ", class: "px-2 py-1 text-xs font-bold text-white bg-red-500 rounded")
    elsif stock <= 10
      content_tag(:span, "残少", class: "px-2 py-1 text-xs font-bold text-gray-800 bg-yellow-400 rounded")
    end
  end
end
