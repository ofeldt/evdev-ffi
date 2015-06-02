module Evdev
  module FFI
    class EvDev < ::FFI::Struct
      EV_MAX = 0x1F
      EV_CNT = EV_MAX + 1

      INPUT_PROP_MAX = 0x1F
      INPUT_PROP_CNT = INPUT_PROP_MAX + 1

      KEY_MAX = 0x2FF
      KEY_CNT = KEY_MAX + 1

      REL_MAX = 0x0F
      REL_CNT = REL_MAX + 1

      ABS_MAX = 0x3F
      ABS_CNT = ABS_MAX + 1

      LED_MAX = 0x0F
      LED_CNT = LED_MAX + 1

      MSC_MAX = 0x07
      MSC_CNT = MSC_MAX + 1

      SW_MAX = 0x0F
      SW_CNT = SW_MAX + 1

      REP_MAX = 0x01
      REP_CNT = REP_MAX + 1

      FF_MAX = 0x7F
      FF_CNT = FF_MAX + 1

      SND_MAX = 0x07
      SND_CNT = SND_MAX + 1

      layout(
        :fd, :int,
        :initialized, :bool,
        :name, :string,
        :phys, :string,
        :uniq, :string,
        :ids, FFI::InputId.by_value,
        :driver_version, :int,

        :bits, [:ulong, NLONGS[EV_CNT]],
        :props, [:ulong, NLONGS[INPUT_PROP_CNT]],
        :key_bits, [:ulong, NLONGS[KEY_CNT]],
        :rel_bits, [:ulong, NLONGS[REL_CNT]],
        :abs_bits, [:ulong, NLONGS[ABS_CNT]],
        :led_bits, [:ulong, NLONGS[LED_CNT]],
        :msc_bits, [:ulong, NLONGS[MSC_CNT]],
        :sw_bits, [:ulong, NLONGS[SW_CNT]],
        :rep_bits, [:ulong, NLONGS[REP_CNT]], # convenience, always 1
        :ff_bits, [:ulong, NLONGS[FF_CNT]],
        :snd_bits, [:ulong, NLONGS[SND_CNT]],
        :key_values, [:ulong, NLONGS[KEY_CNT]],
        :led_values, [:ulong, NLONGS[LED_CNT]],
        :sw_values, [:ulong, NLONGS[SW_CNT]],

        :abs_info, [FFI::InputAbsinfo.by_value, ABS_CNT],
        :mt_slot_vals, :pointer,  # int pointer [num_slots * ABS_MT_CNT]
        :num_slots, :int, #*< valid slots in mt_slot_vals
        :current_slot, :int,
        :rep_values, [:int, REP_CNT],

        :sync_state, SyncState,
        :grabbed, GrabMode,

        :queue, FFI::InputEvent.ptr,
        :queue_size, :size_t, #*< size of queue in elements
        :queue_next, :size_t, #*< next event index
        :queue_nsync, :size_t, #*< number of sync events

        :last_event_time, FFI::TimeVal.by_value,
        # weirdo struct goes here
        :mt_sync, FFI::MtSync.by_value,

        :log, FFI::LogData.by_value
      )
    end
  end
end
