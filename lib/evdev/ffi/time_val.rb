module Evdev
  module FFI
    class TimeVal < ::FFI::Struct
      layout(
        :tv_sec, :time_t,
        :tv_usec, :suseconds_t
      )
    end
  end
end
