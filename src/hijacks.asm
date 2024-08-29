@include

; print timer frames after it's done computing the timer for the current frame
org every_frame_hijack
    jmp bank0_free_space

org bank0_free_space
    jsl run_timer
    ; restore hijacked instruction
    jmp $8d70

org bank2_boss_final_hit_hijack
    jsl send_final_hit_message
    nop 