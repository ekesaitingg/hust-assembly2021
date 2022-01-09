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
	CDQ	                ;用CDQ命令将EAX符号位复制到EDX所有位上，防止被除数扩展时数值错误
	idiv ecx
	mov [esi+18],ax
	inc di
	add esi,20
	cmp di,m
	js CAL_LOOP
	ret
CHOICE4 endp

CHOICE5 proc
	mov edx,offset GA1
	mov ebx,offset LIST
	mov cx,0
LIST_LOOP:
	mov [ebx],edx                                  ;建立查找表，方便排序时换位置
	add edx,20
	add ebx,4
	inc cx
	cmp cx,m
	jne LIST_LOOP

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
