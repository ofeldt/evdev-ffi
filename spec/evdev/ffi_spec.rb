# coding: UTF-8
require_relative "../spec_helper"

describe Evdev::FFI do

  #let(:device) { "/dev/input/by-id/usb-Gamtec._Ltd_SmartJoy_PLUS_Adapter-event-joystick" }
  let(:device) { ENV["EVDEV_DEVICE_PATH"] }

  context "#libevdev_new" do
    it "should not raise any errors upon initialization" do
      expect(->{ Evdev::FFI.new }).not_to raise_error
    end
  end

  context "#libevdev_set_fd" do
    it "should not raise any errors on setting a valid file descriptor" do
      descriptor = IO.sysopen(device, Fcntl::O_RDONLY)# | Fcntl::O_NONBLOCK)
      device = Evdev::FFI.new

      expect(Evdev::FFI.set_fd(device, descriptor)).to_not be < 0
    end
  end

  context "#libevdev_grab" do
    it "should grab a grabbale device" do
      descriptor = IO.sysopen(device, Fcntl::O_RDONLY)
      device = Evdev::FFI.new
      Evdev::FFI.set_fd(device, descriptor)

      expect(Evdev::FFI.grab(device, Evdev::FFI::GrabMode[:grab])).to be == 0
      Evdev::FFI.grab(device, Evdev::FFI::GrabMode[:ungrab])
    end

    it "should return -16 if a device is already grabbed device" do
      descriptor = IO.sysopen(device, Fcntl::O_RDONLY)
      other_device = Evdev::FFI.new
      device = Evdev::FFI.new
      Evdev::FFI.set_fd(other_device, descriptor)
      expect(Evdev::FFI.grab(other_device, Evdev::FFI::GrabMode[:grab])).to be == 0

      Evdev::FFI.set_fd(device, descriptor)
      expect(Evdev::FFI.grab(device, Evdev::FFI::GrabMode[:grab])).to be == -16
    end

    it "should ungrab a grabbed device" do
      descriptor = IO.sysopen(device, Fcntl::O_RDONLY)
      device = Evdev::FFI.new
      Evdev::FFI.set_fd(device, descriptor)
      Evdev::FFI.grab(device, Evdev::FFI::GrabMode[:grab])

      expect(Evdev::FFI.grab(device, Evdev::FFI::GrabMode[:ungrab])).to be == 0
    end
  end

  context "#libevdev_new_from_fd" do
    it "should initialize a new event device" do
      #TODO find out why this one is bugged
    end
  end

end
