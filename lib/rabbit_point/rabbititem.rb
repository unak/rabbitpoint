require "tiny_windows"

class RabbitPoint::RabbitItem < TinyWindows::Window
  def self.create_window(title, opts = {})
    # need more better method...
    hbmp = User32.LoadImage(0, title, 0, 0, 0, 0x00000010)
    bitmap = GDI32::BITMAP.malloc
    GDI32.GetObject(hbmp, bitmap.class.size, bitmap)
    bmWidth = bitmap.bmWidth
    bmHeight = bitmap.bmHeight
    GDI32.DeleteObject(hbmp)

    opts = opts.dup
    opts[:scale] ||= 1
    opts[:width] = bmWidth * opts[:scale]
    opts[:height] = bmHeight * opts[:scale]
    opts.delete(:scale)
    opts[:style] = User32::WS_POPUP unless opts[:style]
    opts[:exstyle] = (opts[:exstyle] || (User32::WS_EX_TOPMOST | User32::WS_EX_TOOLWINDOW)) | User32::WS_EX_LAYERED

    window = super(title, opts)
    User32.SetLayeredWindowAttributes(window.hwnd, 0xFFFFFFFF, 0, User32::LWA_COLORKEY)

    window
  end

  def on_paint
    ps = User32::PAINTSTRUCT.malloc
    hdc = BeginPaint(ps)

    title = '\0' * 256
    GetWindowText(title, title.size)
    hbmp = User32.LoadImage(0, title, 0, 0, 0, 0x00000010)
    bitmap = GDI32::BITMAP.malloc
    GDI32.GetObject(hbmp, bitmap.class.size, bitmap)
    hcompatibledc = GDI32.CreateCompatibleDC(hdc)
    hold = GDI32.SelectObject(hcompatibledc, hbmp)
    GDI32.StretchBlt(hdc, 0, 0, width, height, hcompatibledc, 0, 0, bitmap.bmWidth, bitmap.bmHeight, GDI32::SRCCOPY | GDI32::CAPTUREBLT)

    if respond_to?(:additional_draw)
      additional_draw(hdc)
    end

    GDI32.SelectObject(hcompatibledc, hold)
    GDI32.DeleteDC(hcompatibledc)
    GDI32.DeleteObject(hbmp)

    EndPaint(ps)
    true
  end

  def on_destroy
    User32.PostQuitMessage(0)
    true
  end
end
