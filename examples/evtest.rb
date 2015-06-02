# coding: UTF-8

# This program simulates parts of the actual 'evtest' program via Evdev::FFI
require "evdev/ffi"

device = Evdev::InputDevice.new(ARGV.first)

device.handle_events do |event|
  print "Event: "
  print "time #{event[:time][:tv_sec]}.#{event[:time][:tv_usec].to_s.rjust(6, "0")}, "
  case event[:type]
  when 4
    print "type #{event[:type]} (#{Evdev::FFI.event_type_get_name(event[:type])}), "
    print "code #{event[:code]} (#{Evdev::FFI.event_code_get_name(event[:type], event[:code])}), "
    print "value #{event[:value].to_s(16)}"
  when 3, 1
    print "type #{event[:type]} (#{Evdev::FFI.event_type_get_name(event[:type])}), "
    print "code #{event[:code]} (#{Evdev::FFI.event_code_get_name(event[:type], event[:code])}), "
    print "value #{event[:value]}"
  when 0
    print "-------------- #{Evdev::FFI.event_type_get_name(event[:type])} ------------"
  else
  end
  puts
end
