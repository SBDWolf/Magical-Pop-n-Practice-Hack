@include
run_timer:
    sep #$28 ; set decimal mode and 8 bit mode on A



    ; if we've changed rooms, transfer the timer's value to the previous room's time, add it to the level timer, then reset the timer
+   lda !current_scene : cmp !previous_scene : bne .transfer_room_time
    jmp .update_timer

    .transfer_room_time:
        lda !timer_current_frames : sta !timer_previous_frames
        clc : adc !timer_level_frames : cmp #$60 : bcc +
        pha : lda !timer_current_seconds : clc : adc #$01 : sta !timer_current_seconds : pla : sec : sbc #$60
+       sta !timer_level_frames

        lda !timer_current_seconds : sta !timer_previous_seconds
        clc : adc !timer_level_seconds : cmp #$60 : bcc +
        pha : lda !timer_current_minutes : clc : adc #$01 : sta !timer_current_minutes : pla : sec : sbc #$60
+       sta !timer_level_seconds

        lda !timer_current_minutes : sta !timer_previous_minutes
        
        clc : adc !timer_level_minutes : sta !timer_level_minutes : cmp #$10 : bcc +
        lda #$09 : sta !timer_level_minutes : lda #$59 : sta !timer_level_seconds : sta !timer_level_frames

+       lda #$00 : sta !timer_current_minutes : sta !timer_current_seconds : sta !timer_current_frames
        rep #$28 : jsr .print_previous_room_time : sep #$28

        bra .done

    .update_timer
        ; increment frame count by 1, rollover at 60
        lda !timer_current_frames : clc : adc #$01 : sta !timer_current_frames
        cmp #$60 : bcc .done
        lda #$00 : sta !timer_current_frames

        lda !timer_current_seconds : clc : adc #$01 : sta !timer_current_seconds
        cmp #$60 : bcc .done
        lda #$00 : sta !timer_current_seconds

        lda !timer_current_minutes : clc : adc #$01 : sta !timer_current_minutes
        cmp #$10 : bcc .done

        ; minutes count is 10, stop updating the timer
        lda #$09 : sta !timer_current_minutes
        lda #$59
        sta !timer_current_seconds : sta !timer_current_frames

    .done
        lda !current_scene : sta !previous_scene

        rep #$28 ; clear decimal mode and 8-bit mode on A

        rtl  

    .print_previous_room_time
    ;TODO
        rts