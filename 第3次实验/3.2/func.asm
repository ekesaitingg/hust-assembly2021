.686P
.model flat, stdcall
 ExitProcess proto stdcall :dword
 printf proto c:ptr sbyte,:vararg
 scanf proto c:ptr sbyte,:vararg
 search proto
 strcmp proto :dword,:dword
 mymul macro x,y
	movsx eax,x
	movsx ebx,y
	imul eax,ebx
endm


 GOODS  STRUCT
    GOODSNAME  db 10 DUP(0)
    BUYPRICE   DW  0
    SELLPRICE  DW  0
    BUYNUM     DW  0
    SELLNUM    DW  0
    RATE       DW  0
GOODS  ENDS
 extern lpfmt:byte,numtype:byte,chartype:byte,STR8:byte,STR9:byte,STR10:byte,STR11:byte,STR12:byte,STR13:byte,STR14:byte,STR15:byte
 extern GA1:GOODS,GA2:GOODS,GA3:GOODS,GA4:GOODS,GA5:GOODS,GAN:GOODS,LIST:dword,IGA:byte,num:word,m:word
 .data
	N EQU 30
 .code

CHOICE1 proc
	invoke printf,offset STR10
	invoke scanf,offset lpfmt,offset IGA
	call search
	cmp eax,0
	jz SEARCH_ERROR
	invoke printf,offset STR8,eax,word ptr [eax+10],word ptr[eax+12],WORD PTR [EAX+14],WORD PTR [EAX+16],WORD PTR[EAX+18]  ;������ǰ�����word ptr
	jmp SEARCH_END
SEARCH_ERROR:
	invoke printf,offset STR9
	jmp SEARCH_END
SEARCH_END:
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
	jmp CHOICE3_END
SEARCH_ERROR:
	invoke printf,offset STR9
	jmp CHOICE3_END
CHOICE3_END:
	ret
CHOICE3	endp

CHOICE4 proc
	mov esi,offset GA1
	mov di,0
CAL_LOOP:
    mymul word ptr [esi+12],word ptr [esi+16]
	movsx ecx,word ptr [esi+10]
	movsx edx,word ptr [esi+14]
	imul ecx,edx
	sub eax,ecx
	imul eax,100
	CDQ	                ;��CDQ���EAX����λ���Ƶ�EDX����λ�ϣ���ֹ��������չʱ��ֵ����
	idiv ecx
	mov [esi+18],ax
	inc di
	add esi,20
	cmp di,m
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
	mov di,0
SEARCH_LOOP:
	invoke strcmp,offset IGA,esi
	cmp eax,0
	jz SEARCH_SUCCESS
	inc di
	cmp di,m
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
	ret
strcmp endp
end
