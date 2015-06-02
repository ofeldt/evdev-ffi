module Evdev
  module FFI
    class InputEvent < ::FFI::Struct
      layout(
        :time, TimeVal.by_value,
        :type, :uint16,
        :code, :uint16,
        :value, :int32
      )
    end
  end
end
