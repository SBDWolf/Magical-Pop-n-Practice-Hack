@include
run_timer:
    sep #$08 ; set decimal mode


    ; don't run the timer if on company logo, title screen, or game over screen
    lda !current_scene : cmp #$004c : bcc + : cmp #$004f : bcs +
    jmp .done
    
    ; also rooms 201 and above are reserved for pre-level cards, cutscenes, etc.
    ; so if we're in any of these rooms, don't run the timer    
+   cmp #$00c9 : bcc + 
    jmp .done
    ;lda #$0000 : sta !timer_level_minutes : sta !timer_level_seconds : sta !timer_current_frames : sta !timer_current_minutes : sta !timer_current_seconds : sta !timer_current_frames

    ; if on the final boss's phase 2 room, trigger a room transfer upon the boss's health reaching 0
+   cmp #$00c3 : bne +
    lda !final_hit_message : beq +
    lda #$0000 : sta !final_hit_message
    bra .transfer_room_time

    ; if we've changed rooms, transfer the timer's value to the previous room's time, add it to the level timer, then reset the timer
+   lda !current_scene : cmp !previous_scene : bne .transfer_room_time
    jmp .update_timer

    .transfer_room_time:
        lda !timer_current_frames : sta !timer_previous_frames
        clc : adc !timer_level_frames : cmp #$0060 : bcc +
        pha : lda !timer_level_seconds : clc : adc #$0001 : sta !timer_level_seconds : pla : sec : sbc #$0060
+       sta !timer_level_frames

        lda !timer_current_seconds : sta !timer_previous_seconds
        clc : adc !timer_level_seconds : cmp #$0060 : bcc +
        pha : lda !timer_level_minutes : clc : adc #$0001 : sta !timer_level_minutes : pla : sec : sbc #$0060
+       sta !timer_level_seconds

        lda !timer_current_minutes : sta !timer_previous_minutes
        
        clc : adc !timer_level_minutes : sta !timer_level_minutes : cmp #$0010 : bcc +
        lda #$0009 : sta !timer_level_minutes : lda #$0059 : sta !timer_level_seconds : sta !timer_level_frames

+       lda #$0000 : sta !timer_current_minutes : sta !timer_current_seconds : sta !timer_current_frames
        rep #$08 : jsr print_previous_room_time : sep #$08

        ; if in any of the starting scenes for a level, also reset the level timer
        lda !current_scene
        cmp #$0000 : beq .reset_level_timer
        cmp #$0021 : beq .reset_level_timer
        cmp #$002d : beq .reset_level_timer
        cmp #$004f : beq .reset_level_timer
        cmp #$0071 : beq .reset_level_timer
        cmp #$0093 : beq .reset_level_timer

        bra .done

    .reset_level_timer:
        lda #$0000 : sta !timer_level_minutes : lda #$0000 : sta !timer_level_seconds : lda #$0000 : sta !timer_level_frames
        bra .done


    .update_timer
        ; increment frame count by 1, rollover at 60
        lda !timer_current_frames : clc : adc #$0001 : sta !timer_current_frames
        cmp #$0060 : bcc .done
        lda #$0000 : sta !timer_current_frames

        lda !timer_current_seconds : clc : adc #$0001 : sta !timer_current_seconds
        cmp #$0060 : bcc .done
        lda #$0000 : sta !timer_current_seconds

        lda !timer_current_minutes : clc : adc #$0001 : sta !timer_current_minutes
        cmp #$0010 : bcc .done

        ; minutes count is 10, stop updating the timer
        lda #$0009 : sta !timer_current_minutes
        lda #$0059
        sta !timer_current_seconds : sta !timer_current_frames

    .done
        lda !current_scene : sta !previous_scene

        rep #$08 ; clear decimal mode

        rtl  

print_previous_room_time:
    lda #$5cd8 : sta VMADDL
    lda !timer_previous_minutes : clc : adc #$2030 : sta VMDATAL
    lda #$0000 : sta VMDATAL
    lda !timer_previous_seconds : lsr #4 : clc : adc #$2030 : sta VMDATAL
    lda !timer_previous_seconds : and #$000f : clc : adc #$2030 : sta VMDATAL
    lda #$0000 : sta VMDATAL
    lda !timer_previous_frames : lsr #4 : clc : adc #$2030 : sta VMDATAL
    lda !timer_previous_frames : and #$000f : clc : adc #$2030 : sta VMDATAL

    lda #$5cf8 : sta VMADDL
    lda !timer_level_minutes : clc : adc #$2030 : sta VMDATAL
    lda #$0000 : sta VMDATAL
    lda !timer_level_seconds : lsr #4 : clc : adc #$2030 : sta VMDATAL
    lda !timer_level_seconds : and #$000f : clc : adc #$2030 : sta VMDATAL
    lda #$0000 : sta VMDATAL
    lda !timer_level_frames : lsr #4 : clc : adc #$2030 : sta VMDATAL
    lda !timer_level_frames : and #$000f : clc : adc #$2030 : sta VMDATAL

    rts