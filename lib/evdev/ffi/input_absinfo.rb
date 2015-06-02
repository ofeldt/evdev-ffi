module Evdev
  module FFI
    class InputAbsinfo < ::FFI::Struct
      layout(
        :value,      :int32,
        :minimum,    :int32,
        :maximum,    :int32,
        :fuzz,       :int32,
        :flat,       :int32,
        :resolution, :int32
      )
    end
  end
end
