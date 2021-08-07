%include "data/messages/messages.asm"
%include "data/messages/number_to_string.asm"

segment .data

_boss_data:
	boss_name_1 db 'Босс 1', 0
	boss_name_1_len equ $ - boss_name_1
	boss_name_1_level equ 1

	boss_name_2 db 'Босс 2', 0
	boss_name_2_len equ $ - boss_name_2
	boss_name_2_level equ 2

	boss_name_3 db 'Босс 3', 0
	boss_name_3_len equ $ - boss_name_3
	boss_name_3_level equ 3

	boss_name_4 db 'Босс 4', 0
	boss_name_4_len equ $ - boss_name_4
	boss_name_4_level equ 4

	boss_name_5 db 'Босс 5', 0
	boss_name_5_len equ $ - boss_name_5
	boss_name_5_level equ 5

	boss_name_6 db 'Босс 6', 0
	boss_name_6_len equ $ - boss_name_6
	boss_name_6_level equ 6

_player_data:
	level dd 1
	player_power dd 2
	player_mana dd 13

_boss:
	boss_power dd 1

segment .bss
	boss_health_value resb 4   ; TODO: увеличить максимально возможное кол-во здоровья
	player_health_value resb 4 ; TODO: увеличить максимально возможное кол-во здоровья

	choise resb 4
	player_class resb 4

segment .text
	global _start

_settings:
	mov bx, [level]
	mov ax, [level]
	mul bx ; Результат в eax (bx * ax = eax)
	add eax, 11
	add eax, [level]
	mov [player_health_value], eax

	mov bx, [level]
	mov ax, [level]
	mul bx ; Результат в eax (bx * ax = eax)
	add eax, 13
	add eax, [level]
	mov [boss_health_value], eax

	mov eax, 0
	add eax, [player_power]
	add eax, [level]
	mov [player_power], eax

	mov eax, 0
	add eax, [boss_power]
	add eax, [level]
	inc eax
	mov [boss_power], eax

	mov bx, [level]
	mov ax, [level]
	mul bx ; Результат в eax (bx * ax = eax)
	add eax, [player_mana]
	mov [player_mana], eax  ; TODO: уменьшить кол-во увеличения маны с каждым уровнем
	ret

_start:	
	 
	call _settings

	call _clear
	call _print_start_combat_message

	call _print_level_message

	mov eax, [level]
	call _number_to_string

_choise_class:
	; TODO: реализовать классы

_combat:
	_print_values:
		mov eax, [player_mana]
		inc eax
		mov [player_mana], eax

		call _print_new_line_message

		call _print_start_combat_message

		call _print_player_health_message
		
		mov eax, [player_health_value]
		call _number_to_string

		call _print_player_mana_message

		mov eax, [player_mana]
		call _number_to_string

		call _print_boss_health_message

		mov eax, [boss_health_value]
		call _number_to_string
	
	_fight:
		call _print_choise_message

	_bad_choise:
		mov eax, SYS_READ
		mov ebx, SYS_FORK
		mov ecx, choise
		mov edx, 1
		int 80h

		mov eax, [choise]
		cmp eax, '1'
		je _damage
		cmp eax, '2'
		je _heal
		jmp _bad_choise

	_damage:
		call _print_player_damage_message

		mov eax, [boss_power]
		call _number_to_string

		mov al, [player_health_value]
		cmp al, [boss_power]
		jbe _lose
		sub al, [boss_power]
		mov byte [player_health_value], al

		call _print_boss_damage_message

		mov eax, [player_power]
		call _number_to_string

		mov al, [boss_health_value]
		cmp al, [player_power]
		jbe _win
		sub al, [player_power]
		mov byte [boss_health_value], al

		call _clear
		jmp _print_values

	_heal:
		mov al, [player_mana]
		cmp al, 3   ; TODO: увеличить стоимость исцеления с каждый уровнем
		jbe _bad_choise

		sub al, 3
		mov [player_mana], al
		mov al, [player_health_value]
		cmp al, [boss_power]
		jbe _lose
		sub al, [boss_power]
		add al, [player_power]
		add al, [player_power]
		mov byte [player_health_value], al

		call _print_player_heal_message

		mov eax, [player_power]
		add eax, [player_power]
		call _number_to_string

		call _clear
		jmp _print_values

_lose:
	call _print_lose_message

	jmp _end

_win:
	call _print_win_message

	mov eax, [level]
	inc eax,
	mov [level], eax

	jmp _start

_end:
    mov eax, SYS_EXIT
    int 80h
