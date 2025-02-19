.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
    FindData WIN32_FIND_DATA <> ; C?u trúc ?? l?u thông tin file
    SearchHandle dd ?           ; Handle tìm ki?m
    FilePattern db "*.*",0      ; Pattern tìm ki?m (??i tên t? SearchPath)
    
    MSG1    db "Files and directories in current directory:",13,10,0
    MSG2    db " <DIR>",13,10,0
    CRLF    db 13,10,0

.code
start:
    ; Hi?n th? thông báo
    invoke StdOut, addr MSG1
    
    ; B?t ??u tìm file ??u tiên
    invoke FindFirstFile, addr FilePattern, addr FindData
    mov SearchHandle, eax
    
    cmp eax, INVALID_HANDLE_VALUE
    je Exit_Prog    ; N?u không tìm th?y file nào
    
Scan_Loop:
    ; Hi?n th? tên file
    invoke StdOut, addr FindData.cFileName
    
    ; Ki?m tra n?u là th? m?c
    mov eax, FindData.dwFileAttributes
    and eax, FILE_ATTRIBUTE_DIRECTORY
    jz Not_Dir
    
    ; Hi?n th? <DIR> n?u là th? m?c
    invoke StdOut, addr MSG2
    jmp Continue_Search
    
Not_Dir:
    ; N?u là file th??ng thì ch? xu?ng dòng
    invoke StdOut, addr CRLF
    
Continue_Search:
    ; Tìm file ti?p theo
    invoke FindNextFile, SearchHandle, addr FindData
    test eax, eax
    jnz Scan_Loop    ; N?u còn file thì ti?p t?c
    
    ; ?óng handle tìm ki?m
    invoke FindClose, SearchHandle
    
Exit_Prog:
    invoke ExitProcess, 0

end start