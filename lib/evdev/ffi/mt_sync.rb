module Evdev
  module FFI
    class MtSync < ::FFI::Struct
      layout(
        :mt_state, MtSyncState.ptr,
        :mt_state_sz, :size_t, # in bytes
        :slot_update, :pointer, # ulong pointer
        :slot_update_sz, :size_t, # in bytes
        :tracking_id_changes, :pointer, # ulong pointer
        :tracking_id_changes_sz, :size_t # in bytes
      )
    end
  end
end
