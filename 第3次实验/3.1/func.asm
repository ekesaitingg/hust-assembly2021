.686P
.model flat, stdcall
 ExitProcess PROTO STDCALL :DWORD
 printf proto c:ptr sbyte,:vararg
 scanf proto c:ptr sbyte,:vararg
 strcmp proto :dword,:dword
 search proto
 GOODS  STRUCT
    GOODSNAME  db 10 DUP(0)
    BUYPRICE   DW  0
    SELLPRICE  DW  0
    BUYNUM     DW  0
    SELLNUM    DW  0
    RATE       DW  0
GOODS  ENDS

 extern lpfmt:sbyte,numtype:sbyte,chartype:sbyte,STR8:sbyte,STR9:sbyte,STR10:sbyte,STR11:sbyte,STR12:sbyte,STR13:sbyte,STR14:sbyte,STR15:sbyte
 extern TMP:sbyte,GA1:GOODS,GA2:GOODS,GA3:GOODS,GA4:GOODS,GA5:GOODS,GAN:GOODS,LIST:dword,IGA:sbyte,num:word,m:word
 .data
	N EQU 30
 .code
CHOICE1 proc
	invoke printf,offset STR10
	invoke scanf,offset lpfmt,offset IGA
	call search
	cmp eax,0
	jz SEARCH_ERROR
	invoke printf,offset STR8,eax,word ptr [eax+10],word ptr[eax+12],WORD PTR [EAX+14],WORD PTR [EAX+16],WORD PTR[EAX+18]  ;方括号前需添加word ptr
	jmp CHOICE1_END
SEARCH_ERROR:
	invoke printf,offset STR9
	jmp CHOICE1_END
CHOICE1_END:
	ret
CHOICE1 endp

CHOICE2 proc
	invoke printf,offset STR10
	invoke scanf,offset lpfmt,offset IGA
	call search
	cmp eax,0
	jz SEARCH_ERROR
	mov esi,eax
	invoke printf,offset STR11
	invoke scanf,offset numtype,offset num
	mov bx,[esi+16]
	add bx,num
	cmp [esi+14],bx
	jns OK1
	invoke printf,offset STR12
	jmp CHOICE2_END
OK1:
	mov [esi+16], bx
	invoke printf,offset STR13
	jmp CHOICE2_END
SEARCH_ERROR:
	invoke printf,offset STR9
	jmp CHOICE2_END
CHOICE2_END:
	ret
CHOICE2 endp

CHOICE3 proc
	invoke printf,offset STR10
	invoke scanf,offset lpfmt,offset IGA
	call search
	cmp eax,0
	jz SEARCH_ERROR
	mov esi,eax
	invoke printf,offset STR14
	invoke scanf,offset numtype,offset num
	mov bx,[esi+14]
	add bx,num
	mov [esi+14],bx
	invoke printf,offset STR13
CHOICE3_END:
	ret
SEARCH_ERROR:
	invoke printf,offset STR9
	jmp CHOICE3_END
CHOICE3 endp

CHOICE4 proc
	mov esi,offset GA1
CAL_LOOP:
	movsx eax,word ptr [esi+12]
	movsx ebx,word ptr [esi+16]
	imul eax,ebx
	movsx ecx,word ptr [esi+10]
	movsx edx,word ptr [esi+14]
	imul ecx,edx
	sub eax,ecx
	imul eax,100
	CDQ	                ;用CDQ命令将EAX符号位复制到EDX所有位上，防止被除数扩展时数值错误
	idiv ecx
	mov [esi+18],ax
	add esi,20
	cmp esi,offset GA1+580
	js CAL_LOOP
	invoke printf,offset STR13
	ret
CHOICE4 endp

CHOICE5 proc
	mov eax,0
CMP_LOOP1:
	mov ecx,LIST
	mov ebx,0
	add eax,1
	cmp ax,m
	jns CMP_END
CMP_LOOP2:
	mov ecx,LIST[ebx*4]
	mov dx,[ecx+18]
	add ebx,1
	cmp bx,m
	je CMP_LOOP1
	mov esi,LIST[ebx*4]
	cmp dx,[esi+18]
	js CMP_SWAP
	jmp CMP_LOOP2
CMP_SWAP:
	mov esi,LIST[ebx*4]
	mov LIST[ebx*4],ecx
	mov LIST[ebx*4-4],esi
	JMP CMP_LOOP2
CMP_END:
	mov esi,0
PRINT_LOOP:
	cmp si,m
	jns CHOICE5_END
	mov ecx,LIST[4*esi]
	invoke printf,offset STR8,ecx,word ptr[ecx+10],word ptr[ecx+12],word ptr [ecx+14],word ptr [ecx+16],word ptr [ecx+18]
	add esi,1
	jmp PRINT_LOOP

CHOICE5_END:
	ret
CHOICE5 endp

search proc 
	mov esi,offset GA1
SEARCH_LOOP:
	invoke strcmp,offset IGA,esi
	cmp eax,0
	jz SEARCH_SUCCESS
	cmp esi,OFFSET GA1+580
	jns SEARCH_FAIL
	add esi,20
	jmp SEARCH_LOOP
SEARCH_SUCCESS:
	mov eax,esi
	ret
SEARCH_FAIL:
	mov eax,0
	ret
search endp

strcmp proc x:dword,y:dword
	push ebp
	mov ebp,esp
	push esi
	push edi
	push edx
	mov edi,x
	mov esi,y
strcmp_start:
	mov dl,[edi]
	cmp dl,[esi]
	ja strcmp_large
	jb strcmp_little
	cmp dl,0
	je strcmp_equ
	inc esi
	inc edi
	jmp strcmp_start
strcmp_large:
	mov eax,1
	jmp strcmp_exit
strcmp_little:
	mov eax,-1
	jmp strcmp_exit
strcmp_equ:
	mov eax,0
strcmp_exit:
	pop edx
	pop edi
	pop esi
	pop ebp
	ret
strcmp endp
end