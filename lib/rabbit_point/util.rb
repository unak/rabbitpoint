require "tiny_windows"

# get the last display's rect
module RabbitPoint::EnumMonitor
  extend Fiddle::Importer
  dlload "user32.dll"
  CALLBACK = bind("int proc(uintptr_t, uintptr_t, void *, intptr_t)") do |hmon, hdc, rect, data|
    rect = TinyWindows::User32::RECT.new(rect)
    display_rect = TinyWindows::User32::RECT.new(data)
    display_rect.left = rect.left
    display_rect.top = rect.top
    display_rect.right = rect.right
    display_rect.bottom = rect.bottom
    return 1
  end

  def self.get_display_rect
    display_rect = TinyWindows::User32::RECT.malloc
    TinyWindows::User32.EnumDisplayMonitors(0, nil, self::CALLBACK, display_rect.to_i)
    display_rect
  end
end
