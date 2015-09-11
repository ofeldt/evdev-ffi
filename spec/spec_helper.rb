require_relative "../lib/evdev/ffi.rb"
require "pry"

if ENV["EVDEV_DEVICE_PATH"].nil? || !File.exist?(ENV["EVDEV_DEVICE_PATH"])
  puts "Please set EVDEV_DEVICE_PATH with a proper path to an EvDev capable (input) device"
  exit false
end
