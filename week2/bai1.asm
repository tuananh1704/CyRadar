.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
    FindData WIN32_FIND_DATA <> ; Cau truc de luu thông tin file
    SearchHandle dd ?           ; Handle tìm kiem
    FilePattern db "*.*",0      ; Pattern tìm kiem 
    
    MSG1    db "Files and directories in current directory:",13,10,0
    MSG2    db " <DIR>",13,10,0
    CRLF    db 13,10,0

.code
start:
    ; Hien thi thông báo
    invoke StdOut, addr MSG1
    
    ; Bat dau tìm file dau tiên
    invoke FindFirstFile, addr FilePattern, addr FindData
    mov SearchHandle, eax
    
    cmp eax, INVALID_HANDLE_VALUE
    je Exit_Prog    ; neu không tim thay file nao
    
Scan_Loop:
    ; Hien thi ten file
    invoke StdOut, addr FindData.cFileName
    
    ; Kiem tra neu là thu muc
    mov eax, FindData.dwFileAttributes
    and eax, FILE_ATTRIBUTE_DIRECTORY
    jz Not_Dir
    
    ; Hien thi <DIR> neu là thu muc
    invoke StdOut, addr MSG2
    jmp Continue_Search
    
Not_Dir:
    ; Neu la file thuong thì chi xuong dong
    invoke StdOut, addr CRLF
    
Continue_Search:
    ; Tìm file tiep theo
    invoke FindNextFile, SearchHandle, addr FindData
    test eax, eax
    jnz Scan_Loop    ; Neu còn file thì tiep tuc
   
    invoke FindClose, SearchHandle
    
Exit_Prog:
    invoke ExitProcess, 0

end start