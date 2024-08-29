send_final_hit_message:
    ; the purpose of this is to send a one-time "message" that marks the finishing blow to the final boss has been dealt
    ; the timer can then read this message and discard it once read
    ; this is to ultimately allow the timer to update only once when dealing the finising blow to the final boss

    ; don't run this if not on final boss
    lda !current_scene : cmp #$00c3 : bne +
    lda #$0001
    sta !final_hit_message
    ; restore hijacked instructions
+   lda #$0002
    sta $20
    rtl 