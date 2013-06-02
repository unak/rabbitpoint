require_relative "rabbititem"

class RabbitPoint::Flag < RabbitPoint::RabbitItem
  attr_reader :number

  def number=(n)
    @number = n
    User32::InvalidateRect(hwnd, nil, 0)
    User32::UpdateWindow(hwnd)
  end

  def additional_draw(hdc)
    if number
      str = number.to_s
      GDI32.SetBkMode(hdc, GDI32::TRANSPARENT)
      GDI32.TextOut(hdc, 10, 14, str, str.size)
    end
  end
end
