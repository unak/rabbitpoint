require "fiddle/import"

module TinyWindows
  module User32
    extend Fiddle::Importer
    dlload "user32"
    extern "uintptr_t BeginPaint(uintptr_t, void *)", :stdcall
    extern "uintptr_t CreateWindowEx(unsigned long, char *, char *, unsigned long, int, int, int, int, void *, void *, void *, void *)", :stdcall
    extern "intptr_t DefWindowProc(uintptr_t, unsigned int, uintptr_t, intptr_t)", :stdcall
    extern "intptr_t DispatchMessage(void *)", :stdcall
    extern "int DrawText(uintptr_t, void *, int, void *, unsigned int)", :stdcall
    extern "int EndPaint(uintptr_t, void *)", :stdcall
    extern "int EnumDisplayMonitors(uintptr_t, void *, void *, intptr_t)", :stdcall
    extern "int GetClassName(uintptr_t, void *, int)", :stdcall
    extern "int GetClientRect(uintptr_t, void *)", :stdcall
    extern "int GetMessage(void *, uintptr_t, unsigned int, unsigned int)", :stdcall
    extern "int GetWindowRect(uintptr_t, void *)", :stdcall
    extern "int GetWindowText(uintptr_t, void *, int)", :stdcall
    extern "int InvalidateRect(uintptr_t, void *, int)", :stdcall
    extern "uintptr_t LoadImage(uintptr_t, void *, unsigned int, int, int, unsigned int)", :stdcall
    extern "int MoveWindow(uintptr_t, int, int, int, int, int)", :stdcall
    extern "void PostQuitMessage(int)", :stdcall
    extern "intptr_t SendMessage(uintptr_t, unsigned int, uintptr_t, intptr_t)", :stdcall
    extern "int UpdateWindow(uintptr_t)", :stdcall
    extern "unsigned short RegisterClassEx(void *)", :stdcall
    extern "int SetLayeredWindowAttributes(uintptr_t, unsigned long, unsigned char, unsigned long)", :stdcall
    extern "uintptr_t SetTimer(uintptr_t, uintptr_t, unsigned int, void *)", :stdcall
    extern "int SetWindowText(uintptr_t, void *)", :stdcall
    extern "int ShowWindow(uintptr_t, int)", :stdcall
    extern "int TranslateMessage(void *)", :stdcall

    WS_OVERLAPPED = 0x00000000
    WS_POPUP = 0x80000000
    WS_CHILD = 0x40000000
    WS_VISIBLE = 0x10000000
    WS_BORDER = 0x00800000
    WS_DLGFRAME = 0x00400000
    WS_VSCROLL = 0x00200000
    WS_CAPTION = WS_BORDER | WS_DLGFRAME
    WS_SYSMENU = 0x00080000
    WS_THICKFRAME = 0x00040000
    WS_MINIMIZEBOX = 0x00020000
    WS_MAXIMIZEBOX = 0x00010000
    WS_OVERLAPPEDWINDOW = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX

    WS_EX_TOPMOST = 0x00000008
    WS_EX_TRANSPARENT = 0x00000020
    WS_EX_TOOLWINDOW = 0x00000080
    WS_EX_LAYERED = 0x00080000

    ES_MULTILINE = 0x0004
    ES_AUTOVSCROLL = 0x0040
    ES_READONLY = 0x0800

    WM_DESTROY = 0x0002
    WM_PAINT = 0x000F
    WM_KEYDOWN = 0x0100
    WM_KEYUP = 0x0101
    WM_TIMER = 0x0113

    SW_HIDE = 0
    SW_SHOWNORMAL = 1
    SW_NORMAL = 1
    SW_SHOWMINIMIZED = 2
    SW_SHOWMAXIMIZED = 3
    SW_MAXIMIZE = 3
    SW_SHOWNOACTIVATE = 4
    SW_SHOW = 5
    SW_MINIMIZE = 6
    SW_SHOWMINNOACTIVE = 7
    SW_SHOWNA = 8
    SW_RESTORE = 9
    SW_SHOWDEFAULT = 10
    SW_FORCEMINIMIZE = 11

    LWA_COLORKEY = 0x00000001

    COLOR_WINDOW = 5

    WndClassEx = struct [
      "unsigned int cbSize",
      "unsigned int style",
      "void *lpfnWndProc",
      "int cbClsExtra",
      "int cbWndExtra",
      "uintptr_t hInstance",
      "uintptr_t hIcon",
      "uintptr_t hCursor",
      "uintptr_t hbrBackground",
      "char *lpszMenuName",
      "char *lpszClassName",
      "uintptr_t hIconSm",
    ]

    MSG = struct [
      "uintptr_t hwnd",
      "unsigned int message",
      "uintptr_t wParam",
      "intptr_t lParam",
      "unsigned long time",
      "long ptx",
      "long pty",
    ]

    PAINTSTRUCT = struct [
      "uintptr_t hdc",
      "int fErase",
      "long left",
      "long top",
      "long right",
      "long bottom",
      "int fRestore",
      "int fIncUpdate",
      "unsigned char rgbReserved[32]",
    ]

    RECT = struct [
      "int left",
      "int top",
      "int right",
      "int bottom",
    ]

    DT_TOP = 0x00000000
    DT_CENTER = 0x00000001
    DT_VCENTER = 0x00000004
  end
end
