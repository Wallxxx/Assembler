SYS_WRITE equ 4
STDOUT equ 1

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

		call _print_new_line_message

		; потом удаляем буфер, когда он уже не нужен
		add esp, 12
		ret
