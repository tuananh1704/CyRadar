.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
    FindData WIN32_FIND_DATA <> ; Cau truc de luu th�ng tin file
    SearchHandle dd ?           ; Handle t�m kiem
    FilePattern db "*.*",0      ; Pattern t�m kiem 
    
    MSG1    db "Files and directories in current directory:",13,10,0
    MSG2    db " <DIR>",13,10,0
    CRLF    db 13,10,0

.code
start:
    ; Hien thi th�ng b�o
    invoke StdOut, addr MSG1
    
    ; Bat dau t�m file dau ti�n
    invoke FindFirstFile, addr FilePattern, addr FindData
    mov SearchHandle, eax
    
    cmp eax, INVALID_HANDLE_VALUE
    je Exit_Prog    ; neu kh�ng tim thay file nao
    
Scan_Loop:
    ; Hien thi ten file
    invoke StdOut, addr FindData.cFileName
    
    ; Kiem tra neu l� thu muc
    mov eax, FindData.dwFileAttributes
    and eax, FILE_ATTRIBUTE_DIRECTORY
    jz Not_Dir
    
    ; Hien thi <DIR> neu l� thu muc
    invoke StdOut, addr MSG2
    jmp Continue_Search
    
Not_Dir:
    ; Neu la file thuong th� chi xuong dong
    invoke StdOut, addr CRLF
    
Continue_Search:
    ; T�m file tiep theo
    invoke FindNextFile, SearchHandle, addr FindData
    test eax, eax
    jnz Scan_Loop    ; Neu c�n file th� tiep tuc
   
    invoke FindClose, SearchHandle
    
Exit_Prog:
    invoke ExitProcess, 0

end start