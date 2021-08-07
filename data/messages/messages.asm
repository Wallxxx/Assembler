SYS_EXIT equ 1
SYS_WRITE equ 4
SYS_READ equ 3
SYS_FORK equ 2
STDIN equ 0
STDOUT equ 1

segment .data
_messages:
	clear db `\x1B[2J\x1B[H`, 0
	clear_len equ $ - clear

	new_line_message db 0xA, 0xD
	new_line_message_len equ $ - new_line_message

	boss_health_message db 'Здоровье босса: ', 0
	boss_health_message_len equ $ - boss_health_message

	player_health_message db 'Ваше здоровье: ', 0
	player_health_message_len equ $ - player_health_message

	choise_message db 'Выдерите действие: ', 0xA, 0xD, '1) Атаковать', 0xA, 0xD, '2) Лечиться (3 ед. маны)', 0xA, 0xD
	choise_message_len equ $ - choise_message

	lose_message db 'Вы проиграли :(', 0xA, 0xD
	lose_message_len equ $ - lose_message

	win_message db 'Вы победили! :)', 0xA, 0xD
	win_message_len equ $ - win_message

	start_combat_message db '------------------------', 0xA, 0xD
	start_combat_message_len equ $ - start_combat_message

	level_message db 'Ваш уровень: ', 0
	level_message_len equ $ - level_message

	boss_damage_message db 'Изменение здоровья босса: -', 0
	boss_damage_message_len equ $ - boss_damage_message
	
	player_damage_message db 'Изменение вашего здоровья: -', 0
	player_damage_message_len equ $ - player_damage_message

	player_heal_message db 'Изменение вашего здоровья: +', 0
	player_heal_message_len equ $ - player_heal_message

	player_mana_message db 'У вас маны: ', 0
	player_mana_message_len equ $ - player_mana_message

_print32:
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	int 80h
	ret
	
_printd:
	call _print32
	ret
	
_clear:
	mov ecx, clear
	mov edx, clear_len
	call _printd
	ret
	
_print_new_line_message:
	mov ecx, new_line_message
	mov edx, new_line_message_len
	call _printd
	ret
	
_print_boss_health_message:
	mov ecx, boss_health_message
	mov edx, boss_health_message_len
	call _printd
	ret
	
_print_player_health_message:
	mov ecx, player_health_message
	mov edx, player_health_message_len
	call _printd
	ret
	
_print_choise_message:
	mov ecx, choise_message
	mov edx, choise_message_len
	call _printd
	ret
	
_print_lose_message:
	mov ecx, lose_message
	mov edx, lose_message_len
	call _printd
	ret
	
_print_win_message:
	mov ecx, win_message
	mov edx, win_message_len
	call _printd
	ret
	
_print_start_combat_message:
	mov ecx, start_combat_message
	mov edx, start_combat_message_len
	call _printd
	ret
	
_print_level_message:
	mov ecx, level_message
	mov edx, level_message_len
	call _printd
	ret
	
_print_boss_damage_message:
	mov ecx, boss_damage_message
	mov edx, boss_damage_message_len
	call _printd
	ret
	
_print_player_damage_message:
	mov ecx, player_damage_message
	mov edx, player_damage_message_len
	call _printd
	ret
	
_print_player_heal_message:
	mov ecx, player_heal_message
	mov edx, player_heal_message_len
	call _printd
	ret
	
_print_player_mana_message:
	mov ecx, player_mana_message
	mov edx, player_mana_message_len
	call _printd
	ret

