module Evdev
  module FFI
    class InputId < ::FFI::Struct
      layout(
        :bustype, :uint16,
        :vendor,  :uint16,
        :product, :uint16,
        :version, :uint16
      )
    end
  end
end
