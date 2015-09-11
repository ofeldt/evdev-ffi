require 'fcntl'

require "ffi"

module Evdev
  module FFI
    extend ::FFI::Library
    ffi_lib 'libevdev'

    NLONGS = ->(number) { number * [0].pack("L*").bytesize }

    SyncState = enum [:sync_none, :sync_needed, :sync_in_progress]
    GrabMode = enum [:grab, 3, :ungrab, 4]
    LogPriority = enum [:error, 10, :info, 20, :debug, 30]
    ReadFlag = enum [:sync, 1, :normal, 2, :force_sync, 4, :force_blocking, 8]

    # TODO: implement these
    LogFuncT = callback [:int, :pointer, :string, :int, :string, :string, :pointer], :void
    DeviceLogFuncT = callback [:pointer, :int, :pointer, :string, :int, :string, :string, :pointer], :void

    # TODO: implement these
   # LogFuncT = ::FFI::Function.new(
   #   :void,
   #   [
   #     :int, #LogPriority,
   #     :pointer, #*data
   #     :string,
   #     :int,
   #     :string,
   #     :string,
   #     :pointer #va_list
   #   ]
   # ) do

   # end

   # LbevdevDeviceLogFuncT = ::FFI::Function.new(
   #   :void,
   #   [
   #     :pointer,
   #     :int, #LogPriority,
   #     :pointer, #*data
   #     :string,
   #     :int,
   #     :string,
   #     :string,
   #     :pointer #va_list
   #   ]
   # ) do

   # end

    require "evdev/ffi/version"
    require "evdev/ffi/time_val"
    require "evdev/ffi/input_event"
    require "evdev/ffi/input_absinfo"
    require "evdev/ffi/input_id"
    require "evdev/ffi/log_data"
    require "evdev/ffi/mt_sync_state"
    require "evdev/ffi/mt_sync"
    require "evdev/ffi/evdev"

    # Initialization and setup
    attach_function :libevdev_new,                  [], EvDev.ptr
    attach_function :libevdev_new_from_fd,          [:int, EvDev.by_ref], :int # not working?!
    attach_function :libevdev_free,                 [EvDev.ptr], :void
    attach_function :libevdev_grab,                 [EvDev.ptr, GrabMode], :int
    attach_function :libevdev_set_fd,               [EvDev.ptr, :int], :int
    attach_function :libevdev_change_fd,            [EvDev.ptr, :int], :int
    attach_function :libevdev_get_fd,               [EvDev.ptr], :int

    # Querying device capabilities
    attach_function :libevdev_get_name,             [EvDev.ptr], :string
    attach_function :libevdev_get_phys,             [EvDev.ptr], :string
    attach_function :libevdev_get_uniq,             [EvDev.ptr], :string
    attach_function :libevdev_get_id_product,       [EvDev.ptr], :int
    attach_function :libevdev_get_id_vendor,        [EvDev.ptr], :int
    attach_function :libevdev_get_id_bustype,       [EvDev.ptr], :int
    attach_function :libevdev_get_id_version,       [EvDev.ptr], :int
    attach_function :libevdev_get_driver_version,   [EvDev.ptr], :int
    attach_function :libevdev_has_property,         [EvDev.ptr, :uint], :int
    attach_function :libevdev_has_event_type,       [EvDev.ptr, :uint], :int
    attach_function :libevdev_has_event_code,       [EvDev.ptr, :uint, :uint], :int
    attach_function :libevdev_get_abs_minimum,      [EvDev.ptr, :uint], :int
    attach_function :libevdev_get_abs_maximum,      [EvDev.ptr, :uint], :int
    attach_function :libevdev_get_abs_fuzz,         [EvDev.ptr, :uint], :int
    attach_function :libevdev_get_abs_flat,         [EvDev.ptr, :uint], :int
    attach_function :libevdev_get_abs_resolution,   [EvDev.ptr, :uint], :int
    attach_function :libevdev_get_abs_info,         [EvDev.ptr, :uint], InputAbsinfo.ptr
    attach_function :libevdev_get_event_value,      [EvDev.ptr, :uint, :uint], :int
    attach_function :libevdev_fetch_event_value,    [EvDev.ptr, :uint, :uint, :pointer], :int
    attach_function :libevdev_get_repeat,           [EvDev.ptr, :pointer, :pointer], :int

    # Multi-touch related functions
    # TODO: attach those

    # Modifying the appearance or capabilities of the device
    # TODO: attach those

    # Miscellaneous helper functions
    attach_function :libevdev_event_is_type,        [InputEvent.ptr, :uint], :int
    attach_function :libevdev_event_is_code,        [InputEvent.ptr, :uint, :uint], :int
    attach_function :libevdev_event_type_get_name,  [:uint], :string
    attach_function :libevdev_event_code_get_name,  [:uint, :uint], :string
    attach_function :libevdev_property_get_name,    [:uint], :string
    attach_function :libevdev_event_type_get_max,   [:uint], :int
    attach_function :libevdev_event_type_from_name, [:string], :int
    attach_function :libevdev_event_code_from_name, [:uint, :string], :int
    attach_function :libevdev_property_from_name,   [:string], :int
    # not attached on purpose as we always pass null-terminated strings via FFI
    #attach_function :libevdev_event_type_from_name_n, [:string, :size_t], :int
    #attach_function :libevdev_event_code_from_name_n, [:uint, :string, :size_t], :int
    #attach_function :libevdev_property_from_name_n, [:string, :size_t], :int

    # Event handling
    attach_function :libevdev_next_event,           [EvDev.ptr, ReadFlag, InputEvent.by_ref], :int, blocking: true
    attach_function :libevdev_has_event_pending,    [EvDev.ptr], :int

    # uinput device creation
    # TODO: attach those

    # define shorthand aliases by omitting libevdev_ from method_definitions
    methods.each do |method|
      if match = method.to_s.match(/^libevdev_(?<method_name>\w+)/)
        self.method(:alias_method).call(match[:method_name], method)
        self.method(:module_function).call(match[:method_name])
      end
    end
  end
end

require "evdev/input_device"
