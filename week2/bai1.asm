.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
    FindData WIN32_FIND_DATA <> ; C?u tr�c ?? l?u th�ng tin file
    SearchHandle dd ?           ; Handle t�m ki?m
    FilePattern db "*.*",0      ; Pattern t�m ki?m (??i t�n t? SearchPath)
    
    MSG1    db "Files and directories in current directory:",13,10,0
    MSG2    db " <DIR>",13,10,0
    CRLF    db 13,10,0

.code
start:
    ; Hi?n th? th�ng b�o
    invoke StdOut, addr MSG1
    
    ; B?t ??u t�m file ??u ti�n
    invoke FindFirstFile, addr FilePattern, addr FindData
    mov SearchHandle, eax
    
    cmp eax, INVALID_HANDLE_VALUE
    je Exit_Prog    ; N?u kh�ng t�m th?y file n�o
    
Scan_Loop:
    ; Hi?n th? t�n file
    invoke StdOut, addr FindData.cFileName
    
    ; Ki?m tra n?u l� th? m?c
    mov eax, FindData.dwFileAttributes
    and eax, FILE_ATTRIBUTE_DIRECTORY
    jz Not_Dir
    
    ; Hi?n th? <DIR> n?u l� th? m?c
    invoke StdOut, addr MSG2
    jmp Continue_Search
    
Not_Dir:
    ; N?u l� file th??ng th� ch? xu?ng d�ng
    invoke StdOut, addr CRLF
    
Continue_Search:
    ; T�m file ti?p theo
    invoke FindNextFile, SearchHandle, addr FindData
    test eax, eax
    jnz Scan_Loop    ; N?u c�n file th� ti?p t?c
    
    ; ?�ng handle t�m ki?m
    invoke FindClose, SearchHandle
    
Exit_Prog:
    invoke ExitProcess, 0

end start