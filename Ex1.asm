.386
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\user32.lib
.data
    prompt1 db "Nhap so nhi phan thu nhat (max 32 bit): ", 0
    prompt2 db "Nhap so nhi phan thu hai (max 32 bit): ", 0
    result_msg db "Ket qua cong nhi phan: ", 0
    error_msg db "Chi duoc nhap so 0 va 1!", 0
    buffer db 33 dup(0)    
    result db 33 dup(0)    
.code

; Ham kiem tra input chi chua 0 va 1
ValidateBinaryInput PROC
    push esi
    push ecx

CheckLoop:
    mov al, [esi]
    cmp al, 0       ; Ket thuc chuoi
    je ValidInput
    cmp al, '0'     ; Nho hon '0'
    jb InvalidInput
    cmp al, '1'     ; Lon hon '1'
    ja InvalidInput
    inc esi
    jmp CheckLoop

InvalidInput:
    ; Hien thi loi
    invoke StdOut, addr error_msg
    mov eax, 0      ; Danh dau input khong hop le
    jmp Finish

ValidInput:
    mov eax, 1      ; Danh dau input hop le

Finish:
    pop ecx
    pop esi
    ret
ValidateBinaryInput ENDP

; Ham chuyen nhi phan sang thap phan
BinaryToDecimal PROC
    push ebx
    push ecx
    push edx
    xor eax, eax    
    xor ecx, ecx    

BinaryConvertLoop:
    movzx edx, byte ptr [esi + ecx]
    cmp edx, 0      
    je DoneConvert
    shl eax, 1      
    sub edx, '0'    
    or eax, edx     
    inc ecx
    jmp BinaryConvertLoop

DoneConvert:
    pop edx
    pop ecx
    pop ebx
    ret
BinaryToDecimal ENDP

; Ham chuyen thap phan sang nhi phan
DecimalToBinary PROC
    push ebx
    push ecx
    push edx
    mov ecx, 31     
    mov ebx, eax    

BinaryConvertLoop:
    mov byte ptr [edi + ecx], '0'  
    test ebx, 1
    jz SkipSet
    mov byte ptr [edi + ecx], '1'

SkipSet:
    shr ebx, 1      
    dec ecx
    cmp ecx, -1
    jne BinaryConvertLoop
    mov byte ptr [edi + 32], 0  

    pop edx
    pop ecx
    pop ebx
    ret
DecimalToBinary ENDP

start:
    ; Nhap so thu nhat
    invoke StdOut, addr prompt1
    invoke StdIn, addr buffer, 32

    ; Kiem tra input
    mov esi, offset buffer
    call ValidateBinaryInput
    cmp eax, 0
    je Exit

    ; Chuyen so 1 sang thap phan
    call BinaryToDecimal
    mov ebx, eax    

    ; Xoa buffer
    invoke RtlZeroMemory, addr buffer, 32

    ; Nhap so thu hai
    invoke StdOut, addr prompt2
    invoke StdIn, addr buffer, 32

    ; Kiem tra input
    mov esi, offset buffer
    call ValidateBinaryInput
    cmp eax, 0
    je Exit

    ; Chuyen so 2 sang thap phan
    call BinaryToDecimal

    ; Cong hai so
    add ebx, eax

    ; Chuyen ket qua sang nhi phan
    mov eax, ebx
    mov edi, offset result
    call DecimalToBinary

    ; Hien thi ket qua
    invoke StdOut, addr result_msg
    invoke StdOut, addr result

Exit:
    ; Thoat chuong trinh
    invoke ExitProcess, 0
end start
