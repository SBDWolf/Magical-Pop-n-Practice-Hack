@include

; registers
VMADDL = $2116
VMDATAL = $2118

; rom
every_frame_hijack = $008fce
every_frame_hijack_fix = $00b776
game_over_hijack = $04ccef
bank2_boss_final_hit_hijack = $0189c2

free_space = $3ff0e0
bank0_free_space = $00ec30 ; not 100% sure this is free space...

; ram
!current_scene = $0480
!current_lives = $0516
!final_boss_health = $051c

; new ram
!timer_current_minutes = $7ef000
!timer_current_seconds = $7ef002
!timer_current_frames = $7ef004
!timer_previous_minutes = $7ef006
!timer_previous_seconds = $7ef008
!timer_previous_frames = $7ef00a
!timer_level_minutes = $7ef00c
!timer_level_seconds = $7ef00e
!timer_level_frames = $7ef010
!previous_scene = $7ef012
!final_hit_message = $7ef014
