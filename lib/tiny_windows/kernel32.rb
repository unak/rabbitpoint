require "fiddle/import"

module TinyWindows
  module Kernel32
    extend Fiddle::Importer
    dlload "kernel32"
    extern "unsigned long GetLastError()", :stdcall
  end
end
