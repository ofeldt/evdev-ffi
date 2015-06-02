module Evdev
  module FFI
    class MtSyncState < ::FFI::Struct
      layout(
        :code, :int,
        :val, [:int, 0]
      )
    end
  end
end
