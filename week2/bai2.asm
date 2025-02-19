.386
.model flat, stdcall
option casemap:none

; Include th? vi?n Windows
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
    MsgCaption db "Thông báo", 0
    MsgText    db "Xin chào!", 0

.code
start:
    push MB_OK
    push offset MsgCaption
    push offset MsgText
    push 0
    call MessageBoxA
    
    push 0
    call ExitProcess

end start