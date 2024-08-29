@include

; org every_frame_hijack_fix
;     rtl

;remove game overs
org game_over_hijack
    nop #9
    bra $0c ; 04cd06