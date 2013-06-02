class RabbitPoint; end
require "rabbit_point/flag"
require "rabbit_point/note_window"
require "rabbit_point/rabbititem"
require "rabbit_point/util"

require "tiny_windows"
require "win32ole"

class RabbitPoint
  def self.run(ppt, **opt)
    begin
      obj = self.new(ppt, **opt)
      obj.run
    ensure
      obj.teardown if obj
    end
  end

  def initialize(ppt, minutes: 30, frequency_sec: 10, margin_sec: 0)
    @ppt = ppt
    @minutes = minutes
    @freq_sec = frequency_sec
    @margin_sec = margin_sec
  end

  # http://msdn.microsoft.com/en-us/library/office/bb265987%28v=office.12%29.aspx

  def run
    @powerpoint = WIN32OLE.new('PowerPoint.Application')
    @presentation = @powerpoint.Presentations.Open(File.expand_path(@ppt).gsub(%r(/), '\\'))
    @view = @presentation.SlideShowSettings.Run().View

    display_rect = EnumMonitor.get_display_rect
    x_offset = 20
    y_offset = -20

    show_start_flag(display_rect, 4, y_offset)
    show_goal_flag(display_rect, 4, y_offset)
    show_kame(display_rect, x_offset, y_offset)
    show_usagi(display_rect, x_offset, y_offset)

    show_note_window
    @note_window.show_note_of(@view.Slide)
    @kame.SetTimer(0, @freq_sec * 1000, nil)

    seconds = @minutes * 60 - @margin_sec
    usagi_step = (display_rect.right - display_rect.left - x_offset * 2 - @usagi.width.to_f) / pages
    kame_step = (display_rect.right - display_rect.left - x_offset * 2 - @kame.width).to_f / (seconds.to_f / @freq_sec)

    # main loop
    TinyWindows.do_loop do |msg|
      case msg.message
      when TinyWindows::User32::WM_KEYDOWN
        case msg.wParam
        when 0x25 # VK_LEFT
          if current_page > 1
            @view.Previous
            show_current_page(display_rect, usagi_step)
          end
        when 0x26 # VK_UP
          @view.First
          show_current_page(display_rect, usagi_step)
        when 0x27 # VK_RIGHT
          if current_page < pages
            @view.Next
            show_current_page(display_rect, usagi_step)
          end
        when 0x28 # VK_BOTTOM
          @view.Last
          show_current_page(display_rect, usagi_step)
        when 'Q'.ord
          return
        end
        true
      when TinyWindows::User32::WM_KEYUP
        true
      when TinyWindows::User32::WM_TIMER
        if msg.hwnd == @kame.hwnd
          if @kame.x < display_rect.right - x_offset - @kame.width - kame_step
            @kame.x += kame_step
          end
          true
        else
          false
        end
      else
        false
      end
    end
  end

  def teardown
    if @presentation
      @presentation.Close
      @presentation = nil
    end
    if @powerpoint
      @powerpoint.Quit
      @powerpoint = nil
    end
  end

  def pages
    @pages ||= @presentation.Slides.Count
  end

  def current_page
    @view.CurrentShowPosition
  end

  def show_note_window
    @note_window = NoteWindow.create_window(width: 800, height: 600)
    @note_window.ShowWindow(TinyWindows::User32::SW_NORMAL)
  end

  def show_start_flag(display_rect, x_offset, y_offset)
    @start = Flag.create_window("img/start-flag.bmp", show: nil)
    @start.x = display_rect.left + x_offset
    @start.y = display_rect.bottom - @start.height + y_offset
    @start.number = 1
    @start.ShowWindow(TinyWindows::User32::SW_NORMAL)
  end

  def show_goal_flag(display_rect, x_offset, y_offset)
    @goal = Flag.create_window("img/goal-flag.bmp", show: nil)
    @goal.x = display_rect.right - @goal.width - 4
    @goal.y = display_rect.bottom - @goal.height + y_offset
    @goal.number = pages
    @goal.ShowWindow(TinyWindows::User32::SW_NORMAL)
  end

  def show_kame(display_rect, x_offset, y_offset)
    @kame = RabbitItem.create_window("img/mini-kame-taro.bmp", show: nil, scale: 0.5)
    @kame.x = display_rect.left + x_offset
    @kame.y = display_rect.bottom - @kame.height + y_offset
    @kame.ShowWindow(TinyWindows::User32::SW_NORMAL)
  end

  def show_usagi(display_rect, x_offset, y_offset)
    @usagi = RabbitItem.create_window("img/mini-usa-taro.bmp", show: nil, scale: 0.5)
    @usagi.x = display_rect.left + x_offset
    @usagi.y = display_rect.bottom - @usagi.height + y_offset
    @usagi.ShowWindow(TinyWindows::User32::SW_NORMAL)
  end

  def show_current_page(display_rect, usagi_step)
    sleep 0.1 while current_page <= 0
    @usagi.x = display_rect.left + (current_page - 1) * usagi_step
    @start.number = current_page
    @note_window.show_note_of(@view.Slide)
  end
end
