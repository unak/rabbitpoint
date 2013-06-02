require "tiny_windows"

class RabbitPoint::NoteWindow < TinyWindows::Window
  def self.create_window(**opts)
    window = super("NOTE", opts)

    window.edit = TinyWindows::Edit.create_window("", window.hwnd, x: 0, y: 0, width: window.client_width, height: window.client_height, style: User32::WS_CHILD | User32::WS_VISIBLE | User32::WS_VSCROLL | User32::ES_MULTILINE | User32::ES_READONLY)

    window
  end

  attr_accessor(:note)
  attr_accessor(:edit)

  #def on_destroy
  #  p SendMessage(User32::WM_KEYDOWN, 'Q'.ord, 0)
  #  true
  #end

  def get_note_from(slide)
    shapes = slide.NotesPage.Shapes
    texts = []
    shapes.each do |e|
      texts << e.TextFrame.TextRange.Text unless e.TextFrame.HasText == 0
    end
    texts.join("\r\n//").gsub(/\r\n?/, "\r\n")
  end

  def show_note_of(slide)
    @note = get_note_from(slide)
    @edit.SetWindowText(@note + "\0")
  end
end
