require "fiddle/import"

module TinyWindows
  module GDI32
    extend Fiddle::Importer
    dlload "gdi32"
    extern "int BitBlt(uintptr_t, int, int, int, int, uintptr_t, int, int, unsigned long)", :stdcall
    extern "uintptr_t CreateCompatibleDC(uintptr_t)", :stdcall
    extern "uintptr_t CreateDC(void *, void *, void *, void *)", :stdcall
    extern "int DeleteDC(uintptr_t)", :stdcall
    extern "int DeleteObject(uintptr_t)", :stdcall
    extern "int GdiTransparentBlt(uintptr_t, int, int, int, int, uintptr_t, int, int, int, int, unsigned int)", :stdcall
    extern "int GetObject(uintptr_t, int, void *)", :stdcall
    extern "uintptr_t SelectObject(uintptr_t, uintptr_t)", :stdcall
    extern "int SetBkMode(uintptr_t, int)", :stdcall
    extern "int StretchBlt(uintptr_t, int, int, int, int, uintptr_t, int, int, int, int, unsigned int)", :stdcall
    extern "int TextOut(uintptr_t, int, int, void *, int)", :stdcall

    SRCCOPY = 0x00CC0020
    CAPTUREBLT = 0x40000000

    TRANSPARENT = 1
    OPAQUE = 2

    BITMAP = struct([
      "long bmType",
      "long bmWidth",
      "long bmHeight",
      "long bmWidthBytes",
      "unsigned short bmPlanes",
      "unsigned short bmBitsPixel",
      "void *bmBits"
    ])
  end
end
