require "fiddle/import"

module TinyWindows
  module WindowProc
    extend Fiddle::Importer
    dlload "user32.dll"

    def self.shorten(str)
      str.split(/\0/, 2).first
    end

    WNDPROC = bind("int wndproc(uintptr_t, unsigned int, uintptr_t, intptr_t)") do |hwnd, msg, wparam, lparam|
      name = '\0' * 256
      if User32::GetClassName(hwnd, name, name.bytesize) != 0
        name = WindowProc.shorten(name)
        if /\ATinyWindows:([\w:]+)\z/ =~ name
          myclass = Object.const_get($1)
          if myclass.respond_to?(:get_instance)
            mywindow = myclass.get_instance(hwnd)
          end
        end
      end
      unless mywindow
        User32.DefWindowProc(hwnd, msg, wparam, lparam)
      end

      case msg
      when User32::WM_PAINT
        return 0 if mywindow.on_paint
      when User32::WM_DESTROY
        return 0 if mywindow.on_destroy
      end
      User32.DefWindowProc(hwnd, msg, wparam, lparam)
    end
  end

  class Window
    @registered = false
    @@instances = {}

    def self.register_class(opts = {})
      return if @registered
      wndclass = User32::WndClassEx.malloc
      wndclass.cbSize = wndclass.to_ptr.size
      wndclass.style = 0
      wndclass.lpfnWndProc = WindowProc::WNDPROC.ptr
      wndclass.cbClsExtra = 0
      wndclass.cbWndExtra = 0
      wndclass.hInstance = 0
      wndclass.hIcon = opts[:icon] || 0
      wndclass.hCursor = opts[:cursor] || 0
      wndclass.hbrBackground = opts[:background] || 0
      wndclass.lpszMenuName = opts[:menu] || nil
      wndclass.lpszClassName = "TinyWindows:#{self.name}"
      wndclass.hIconSm = opts[:iconsm] || 0
      User32.RegisterClassEx(wndclass)
      @registered = true
    end

    def self.get_instance(hwnd)
      @@instances[hwnd]
    end

    def self.create_window(title, exstyle: 0, style: User32::WS_OVERLAPPEDWINDOW, x: 0, y: 0, width: 0, height: 0, show: User32::SW_NORMAL, **opts)
      register_class(opts)

      hwnd = User32.CreateWindowEx(exstyle, "TinyWindows:#{self.name}", title, style, x, y, width, height, nil, nil, nil, nil)
      User32.ShowWindow(hwnd, show) if show

      self.new(hwnd)
    end

    attr_reader :hwnd

    def self.const_missing(id)
      TinyWindows.const_get(id)
    end

    def method_missing(id, *args)
      if User32.respond_to?(id)
        User32.__send__(id, hwnd, *args)
      else
        super
      end
    end

    def initialize(hwnd)
      @hwnd = hwnd
      @@instances[hwnd] = self
    end

    def rect
      r = User32::RECT.malloc
      GetWindowRect(r)
      r
    end

    def client_rect
      r = User32::RECT.malloc
      GetClientRect(r)
      r
    end

    def x
      rect.left
    end

    def y
      rect.top
    end

    def width
      r = rect
      r.right - r.left
    end

    def height
      r = rect
      r.bottom - r.top
    end

    def client_width
      r = client_rect
      r.right - r.left
    end

    def client_height
      r = client_rect
      r.bottom - r.top
    end

    def x=(v)
      User32.MoveWindow(hwnd, v.to_i, y, width, height, 0)
    end

    def y=(v)
      User32.MoveWindow(hwnd, x, v.to_i, width, height, 0)
    end

    def width=(v)
      User32.MoveWindow(hwnd, x, y, v.to_i, height, 0)
    end

    def height=(v)
      User32.MoveWindow(hwnd, x, y, width, v.to_i, 0)
    end

    def on_paint
    end

    def on_destroy
    end
  end

  class Edit < Window
    def self.create_window(title, parent, exstyle: 0, style: User32::WS_CHILD | User32::WS_VISIBLE, x: 0, y: 0, width: 0, height: 0)
      hwnd = User32.CreateWindowEx(exstyle, "EDIT", title, style, x, y, width, height, parent, nil, nil, nil)
      self.new(hwnd)
    end
  end
end
