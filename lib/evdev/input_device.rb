module Evdev
  class InputDevice
    class DeviceError < RuntimeError; end
    class CouldNotOpenDeviceError < DeviceError; end
    class CouldNotGrabDeviceError < DeviceError; end

    def initialize(path, options = {})
      options = {}.merge(options)

      open_device(path)
      @flags = (
        Evdev::FFI::ReadFlag[:normal] | Evdev::FFI::ReadFlag[:force_blocking]
      )
      @grabbed = false
    end

    def has_pending_events?
      Evdev::FFI.has_events_pending(@device) > 0
    end
    alias :events_pending? :has_pending_events?

    def handle_events(&block)
      return_codes = [0, 1, -Errno::EAGAIN::Errno]
      event = Evdev::FFI::InputEvent.new
      while return_codes.include?(code = Evdev::FFI.next_event(@device, @flags, event))
        block.call(event)
        event = Evdev::FFI::InputEvent.new
      end
    end
    alias :each_event :handle_events

    def next_event(&block)
      event = Evdev::FFI::InputEvent.new
      return_codes = [0, 1, -Errno::EAGAIN::Errno]
      return_codes.include?(code = Evdev::FFI.next_event(@device, @flags, event))

      case code
      when 0
        event
      else
        nil
      end
    end

    def record_events(limit)
      limit.times.map { next_event { |event| event } }
    end

    def grab
      raise CouldNotGrabDeviceError if 0 != Evdev::FFI.grab(@device, Evdev::FFI::GrabMode[:grab])
      @grabbed = true
    end

    def ungrab
      raise CouldNotGrabDeviceError if 0 != Evdev::FFI.grab(@device, Evdev::FFI::GrabMode[:ungrab])
      @grabbed = false
    end

    def grabbed?
      @grabbed
    end

    def name
      Evdev::FFI.get_name(@device)
    end

    def physical_position
      Evdev::FFI.get_phys(@device)
    end

    def bustype
      Evdev::FFI.get_id_bustype(@device).to_s(16)
    end

    def vendor
      Evdev::FFI.get_id_vendor(@device).to_s(16)
    end

    def product
      Evdev::FFI.get_id_product(@device).to_s(16)
    end

    def driver_version(type = :readable)
      version = Evdev::FFI.get_driver_version(@device)
      case type
      when :readable
        "%d.%d.%d" % [version >> 16, (version >> 8) & 0xff, version & 0xff]
      when :raw
        version
      else
        raise ArgumentError, "Valid driver_version types are: [:readable, :raw], type: #{type} is not valid."
      end
    end

    def repeat_rate
      # TODO: implement
      #Evdev::FFI.get_repeat
    end

    private
    def open_device(path)
      begin
        path = path.to_s
      rescue TypeError
        raise CouldNotOpenDeviceError, "Device path needs to be coerable to String"
      end

      @descriptor = IO.sysopen(path, Fcntl::O_RDONLY)# | Fcntl::O_NONBLOCK)
      @device = Evdev::FFI.new

      raise CouldNotOpenDeviceError if Evdev::FFI.set_fd(@device, @descriptor) < 0
    end
  end
end
