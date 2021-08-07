segment .data
_player_data:
	level dd 1
	player_power dd 2
	player_mana dd 13

segment .bss
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

	mov eax, SYS_WRITE  ; Вызов функции write
	mov ebx, STDOUT  ; Потом вывода
	mov ecx, start_combat_message ; Указатель на строку
	mov edx, start_combat_message_len  ; Кол-во символов в строке
	int 80h

	mov eax, SYS_WRITE  ; Вызов функции write
	mov ebx, STDOUT  ; Потом вывода
	mov ecx, level_message ; Указатель на строку
	mov edx, level_message_len  ; Кол-во символов в строке
	int 80h

	mov eax, [level]
	call _number_to_string

_choise_class:
	; TODO: реализовать классы

_combat:
	_print_values:
		mov eax, [player_mana]
		inc eax
		mov [player_mana], eax

		mov eax, SYS_WRITE  ; Вызов функции write
		mov ebx, STDOUT  ; Потом вывода
		mov ecx, new_line_message ; Указатель на строку
		mov edx, new_line_message_len  ; Кол-во символов в строке
		int 80h

		mov eax, SYS_WRITE  ; Вызов функции write
		mov ebx, STDOUT  ; Потом вывода
		mov ecx, start_combat_message ; Указатель на строку
		mov edx, start_combat_message_len  ; Кол-во символов в строке
		int 80h

		mov eax, SYS_WRITE  ; Вызов функции write
		mov ebx, STDOUT  ; Потом вывода
		mov ecx, player_health_message ; Указатель на строку
		mov edx, player_health_message_len  ; Кол-во символов в строке
		int 80h
		
		mov eax, [player_health_value]
		call _number_to_string

		mov eax, SYS_WRITE  ; Вызов функции write
		mov ebx, STDOUT  ; Потом вывода
		mov ecx, player_mana_message ; Указатель на строку
		mov edx, player_mana_message_len  ; Кол-во символов в строке
		int 80h

		mov eax, [player_mana]
		call _number_to_string

		mov eax, SYS_WRITE  ; Вызов функции write
		mov ebx, STDOUT  ; Потом вывода
		mov ecx, boss_health_message ; Указатель на строку
		mov edx, boss_health_message_len  ; Кол-во символов в строке
		int 80h

		mov eax, [boss_health_value]
		call _number_to_string
	
	_fight:
		mov eax, SYS_WRITE
		mov ebx, STDOUT
		mov ecx, choise_message
		mov edx, choise_message_len
		int 80h

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
		mov eax, SYS_WRITE  ; Вызов функции write
		mov ebx, STDOUT  ; Потом вывода
		mov ecx, player_damage_message ; Указатель на строку
		mov edx, player_damage_message_len  ; Кол-во символов в строке
		int 80h

		mov eax, [boss_power]
		call _number_to_string

		mov al, [player_health_value]
		cmp al, [boss_power]
		jbe _lose
		sub al, [boss_power]
		mov byte [player_health_value], al

		mov eax, SYS_WRITE  ; Вызов функции write
		mov ebx, STDOUT  ; Потом вывода
		mov ecx, boss_damage_message ; Указатель на строку
		mov edx, boss_damage_message_len  ; Кол-во символов в строке
		int 80h

		mov eax, [player_power]
		call _number_to_string

		mov al, [boss_health_value]
		cmp al, [player_power]
		jbe _win
		sub al, [player_power]
		mov byte [boss_health_value], al

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

		mov eax, SYS_WRITE  ; Вызов функции write
		mov ebx, STDOUT  ; Потом вывода
		mov ecx, player_heal_message ; Указатель на строку
		mov edx, player_heal_message_len  ; Кол-во символов в строке
		int 80h

		mov eax, [player_power]
		add eax, [player_power]
		call _number_to_string

		jmp _print_values

_number_to_string:
	_start_convert:
		sub esp, 12      ; создаём буфер под строку на 10 цифр
		mov edi, esp       ; (по числу 10-ичных разрядов в 32-битном числе) 
		add edi, 11          ; + знак (для чисел со знаком)
		mov byte [edi], 0  ; + /0 на конце, чтобы обозначить конец строки 

							;mov eax, [player_health_value]  ; value - исходное число

	_convert:
		mov ecx, 10

	_loop_begin:
		sub edi, 1   ; запись идёт с конца, поэтому указатель сдвигается к началу
		xor edx, edx
		div ecx         ; делим value на 10, в остатке получаем младший разряд
		add edx, '0'    ; конвертируем его в цифру
		mov byte [edi], dl  ; записываем цифру в буфер
		cmp eax, 0      ; проверяем все ли разряды вычислены
		ja _loop_begin     ; для беззнаковых - ja

	_done:
		; строка готова , указатель на неё в edi
		; в этом месте должен быть вывод на экран
		mov eax, SYS_WRITE  ; Вызов функции write
		mov ebx, STDOUT  ; Потом вывода
		mov ecx, edi ; Указатель на строку
		
		mov edx, 3  ; Кол-во символов в строке
		int 80h

		mov eax, SYS_WRITE  ; Вызов функции write
		mov ebx, STDOUT  ; Потом вывода
		mov ecx, new_line_message ; Указатель на строку
		mov edx, new_line_message_len  ; Кол-во символов в строке
		int 80h

		; потом удаляем буфер, когда он уже не нужен
		add esp, 12
		ret

_lose:
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, lose_message
	mov edx, lose_message_len
	int 80h

	jmp _end

_win:
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, win_message
	mov edx, win_message_len
	int 80h

	mov eax, [level]
	inc eax,
	mov [level], eax

	jmp _start

_end:
    mov eax, SYS_EXIT
    int 80h
