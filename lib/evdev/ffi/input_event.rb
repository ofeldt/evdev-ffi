module Evdev
  module FFI
    class InputEvent < ::FFI::Struct
      layout(
        :time, TimeVal.by_value,
        :type, :uint16,
        :code, :uint16,
        :value, :int32
      )

      def time
        self[:time]
      end

      def type
        self[:type]
      end

      def code
        self[:code]
      end

      def value
        self[:value]
      end
    end
  end
end
