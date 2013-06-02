require "tiny_windows/kernel32"
require "tiny_windows/user32"
require "tiny_windows/gdi32"
require "tiny_windows/window"

module TinyWindows
  def self.do_loop(&blk)
    msg = User32::MSG.malloc
    until User32.GetMessage(msg, 0, 0, 0) == 0
      if !blk || !blk.call(msg)
        User32.TranslateMessage(msg)
        User32.DispatchMessage(msg)
      end
    end
  end
end
