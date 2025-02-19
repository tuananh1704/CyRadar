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
    prompt1 db "Nhap so thu nhat: ", 0
    prompt2 db "Nhap so thu hai: ", 0
    result_msg db "Ket qua cong: ", 0
    buffer db 12 dup(0)
    result db 12 dup(0)

.code
; Ham chuyen chuoi sang so nguyen (co dau)
StringToInteger PROC
    push ebx
    push ecx
    push edx
    
    xor eax, eax    ; Ket qua
    xor ecx, ecx    ; Bien dem
    mov ebx, 10     ; Co so 10
    mov edx, 1      ; Dau so
    
    ; Kiem tra dau am
    cmp byte ptr [esi], '-'
    jne ConvertLoop
    
    mov edx, -1     ; Danh dau so am
    inc esi         ; Bo qua dau '-'
    
ConvertLoop:
    movzx ebx, byte ptr [esi + ecx]
    cmp ebx, 0      ; Ket thuc chuoi
    je DoneConvert
    
    sub ebx, '0'    ; Chuyen ky tu sang so
    imul eax, 10    ; Nhan voi 10
    add eax, ebx    ; Cong so moi
    
    inc ecx
    jmp ConvertLoop
    
DoneConvert:
    imul eax, edx   ; Ap dung dau
    
    pop edx
    pop ecx
    pop ebx
    ret
StringToInteger ENDP

; Ham chuyen so nguyen sang chuoi
IntegerToString PROC
    push ebx
    push ecx
    push edx
    
    mov ebx, 10     ; Co so 10
    mov edi, offset result
    
    ; Xu ly so 0
    cmp eax, 0
    jne CheckSign
    mov byte ptr [edi], '0'
    mov byte ptr [edi + 1], 0
    jmp Finish

CheckSign:
    ; Xu ly so am
    mov ecx, 0
    test eax, eax
    jns Positive
    
    mov byte ptr [edi], '-'
    inc edi
    neg eax
    mov ecx, 1
    
Positive:
    ; Chuyen doi so
    xor esi, esi    ; Bien dem chu so
    
ConvertLoop:
    xor edx, edx
    div ebx
    add edx, '0'
    push edx
    inc esi
    test eax, eax
    jnz ConvertLoop
    
ReverseLoop:
    pop edx
    mov [edi], dl
    inc edi
    dec esi
    jnz ReverseLoop
    
    ; Null terminator
    mov byte ptr [edi], 0
    
Finish:
    pop edx
    pop ecx
    pop ebx
    ret
IntegerToString ENDP

start:
    ; Nhap so thu nhat
    invoke StdOut, addr prompt1
    invoke StdIn, addr buffer, 11
    
    ; Chuyen so 1 sang so nguyen
    mov esi, offset buffer
    call StringToInteger
    mov ebx, eax    ; Luu so thu nhat
    
    ; Xoa buffer
    invoke RtlZeroMemory, addr buffer, 12
    
    ; Nhap so thu hai
    invoke StdOut, addr prompt2
    invoke StdIn, addr buffer, 11
    
    ; Chuyen so 2 sang so nguyen
    mov esi, offset buffer
    call StringToInteger
    
    ; Cong hai so
    add ebx, eax
    
    ; Chuyen ket qua sang chuoi
    mov eax, ebx
    call IntegerToString
    
    ; Hien thi ket qua
    invoke StdOut, addr result_msg
    invoke StdOut, addr result
    
    ; Thoat chuong trinh
    invoke ExitProcess, 0

end start
