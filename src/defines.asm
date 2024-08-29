@include

; rom
every_frame_hijack = $008fce
every_frame_hijack_fix = $00b776
game_over_hijack = $04ccef

free_space = $3ff0e0
bank0_free_space = $00ec30 ; not 100% sure this is free space...

; ram
!current_scene = $0480
!current_lives = $0516

; new ram
!timer_current_minutes = $7ef000
!timer_current_seconds = $7ef001
!timer_current_frames = $7ef002
!timer_previous_minutes = $7ef003
!timer_previous_seconds = $7ef004
!timer_previous_frames = $7ef005
!timer_level_minutes = $7ef006
!timer_level_seconds = $7ef007
!timer_level_frames = $7ef008
!previous_scene = $7ef009
