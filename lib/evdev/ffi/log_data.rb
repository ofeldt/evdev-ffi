module Evdev
  module FFI
    class LogData < ::FFI::Struct
      layout(
        :priority, LogPriority,
        :global_handler, LogFuncT,
        :device_handler, DeviceLogFuncT
      )
    end
  end
end
