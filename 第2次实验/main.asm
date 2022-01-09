.686P
.model flat, stdcall
 ExitProcess PROTO STDCALL :DWORD

 printf proto c:ptr sbyte,:vararg
 scanf proto c:ptr sbyte,:vararg
 strcmp proto c:ptr sbyte,:vararg
 search proto

 includelib  kernel32.lib
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
 include winTimer.asm

GOODS  STRUCT
    GOODSNAME  db 10 DUP(0)
    BUYPRICE   DW  0
    SELLPRICE  DW  0
    BUYNUM     DW  0
    SELLNUM    DW  0
    RATE       DW  0
GOODS  ENDS


	

 .DATA
BNAME  DB 'WANGJIASHUN',0
INAME   DB 20 DUP(0)
BPASS  DB 'U201914983',0
IPASS   DB 20 DUP(0)
N  EQU  30
choice  DW ?
num DW ?
lpfmt DB '%s',0
numtype DB '%hd',0
chartype DB '%c',0

STR1 DB '�û���: ',0
STR2 DB '����: ',0
STR3 DB '�û���������',0
STR4 DB '�������',0
STR5 DB '��¼�ɹ�',0AH,0
STR6 DB '��ѡ��Ҫִ�еĲ���',0AH,0
STR7 DB '1.������Ʒ  2.����  3.����  4.����������  5.�������ʴӸߵ�����ʾ��Ʒ��Ϣ',0AH,0
STR8 DB '��Ʒ���ƣ�%s  �����ۣ�%hd  ���ۼۣ�%hd  ����������%hd  ����������%hd  �����ʣ�%hd%%',0AH,0
STR9 DB 'δ�ҵ�Ŀ����Ʒ',0AH,0
STR10 DB '��������Ʒ��: ',0
STR11 DB '�����������: ',0
STR12 DB '����ʧ�ܣ�������ӦС��ʣ������',0AH,0
STR13 DB '�����ɹ�',0AH,0
STR14 DB '�����벹����: ',0
STR15 DB '�������',0AH,0

TMP  DB 'TempValue',0

GA1 GOODS <'PEN',15,20,70,25,?>
GA2 GOODS <'PENCIL',2,3,100,20,?>
GA3 GOODS <'BOOK',30,40,25,5,?>
GA4 GOODS <'RULER',3,4,200,150,?>
GA5 GOODS <'ERASER',15,20,30,30,?>
GAN GOODS N-5 DUP(<'TempValue',15,20,30,0,?>)
LIST DD N DUP(?)
IGA  DB  'TempValue',0
.stack 200
.code

main proc c
	mov eax,offset GA1
	mov ebx,offset LIST
LIST_LOOP:
	mov [ebx],eax
	add eax,20
	add ebx,4
	cmp eax,offset GA1+580
	js LIST_LOOP
;	invoke printf,offset STR1
;	invoke scanf,offset lpfmt,offset INAME
;	invoke strcmp,offset BNAME,offset INAME
;	cmp eax,0
;	jnz INPUT_ERROR1
;	invoke printf,offset STR2
;	invoke scanf,offset lpfmt,offset IPASS
;	invoke strcmp,offset BPASS,offset IPASS
;	cmp eax,0
;	jnz INPUT_ERROR2
;	invoke printf,offset STR5
MAIN_MENU:

	invoke printf,offset STR6
	invoke printf,offset STR7                 ;�˺�����������˵�����
	invoke scanf,offset numtype,offset choice      ;numtypeӦ��choice��ƥ�䣨�˴�Ϊ%hd���������������벻���Ĵ���
	cmp choice,1
	jz CHOICE1
	cmp choice,2
	jz CHOICE2
	cmp choice,3
	jz CHOICE3
	cmp choice,4
	jz CHOICE4
	cmp choice,5
	jz CHOICE5
	invoke printf,offset STR15
	jmp MAIN_MENU

CHOICE1:
	invoke printf,offset STR10
	invoke scanf,offset lpfmt,offset IGA
	call search
	cmp eax,0
	jz SEARCH_ERROR
	invoke printf,offset STR8,eax,word ptr [eax+10],word ptr[eax+12],WORD PTR [EAX+14],WORD PTR [EAX+16],WORD PTR[EAX+18]  ;������ǰ�����word ptr
	jmp MAIN_MENU
SEARCH_ERROR:
	invoke printf,offset STR9
	jmp MAIN_MENU

CHOICE2:
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
	jmp MAIN_MENU
OK1:
	mov [esi+16], bx
	invoke printf,offset STR13
	jmp MAIN_MENU

CHOICE3:
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
	jmp MAIN_MENU

CHOICE4:
	mov edi,0
	invoke winTimer,0
CHOICE4_LOOP:
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
	CDQ	                ;��CDQ���EAX����λ���Ƶ�EDX����λ�ϣ���ֹ��������չʱ��ֵ����
	idiv ecx
	mov [esi+18],ax
	add esi,20
	cmp esi,offset GA1+580
	js CAL_LOOP
	;invoke printf,offset STR13
	jmp CHOICE5

CHOICE5:
	mov eax,0
	mov ebp,N-1
CMP_LOOP1:
	mov ebx,0
	inc eax
;	add eax,1
	cmp eax,N+1
	jns CMP_END
CMP_LOOP2:
	mov ecx,LIST[ebx*4]
	mov dx,[ecx+18]
;	add ebx,1        ;��Ϊincָ��
	inc ebx
	dec ebp
	cmp ebx,ebp
;	cmp ebx,N-1       ;��Ϊ��׼��ð�����򷨣�ѭ��������n^2��Ϊn(n-1)
	jns CMP_LOOP1
	mov esi,LIST[ebx*4]
	cmp dx,[esi+18]
	js  CMP_SWAP	
	jmp CMP_LOOP2
CMP_SWAP:
	mov esi,LIST[ebx*4]
	mov LIST[ebx*4],ecx
	mov LIST[ebx*4-4],esi
	JMP CMP_LOOP2
CMP_END:
	;mov esi,0
PRINT_LOOP:
	;cmp esi,N-1
	;jz MAIN_MENU
	;mov ecx,LIST[4*esi]
	;invoke strcmp,offset TMP,ecx
	;cmp eax,0
	;jz MAIN_MENU
	;invoke printf,offset STR8,ecx,word ptr[ecx+10],word ptr[ecx+12],word ptr [ecx+14],word ptr [ecx+16],word ptr [ecx+18]
	;add esi,1
	;jmp PRINT_LOOP
	inc edi
	cmp edi,10000000
	jns TIMER_END
	jmp CHOICE4_LOOP
TIMER_END:
	invoke printf,offset STR13
	invoke winTimer,1
	jmp MAIN_MENU

INPUT_ERROR1:
	invoke printf,offset STR3
	jmp PROGRAM_EXIT
INPUT_ERROR2:
	invoke printf,offset STR4
	jmp PROGRAM_EXIT
PROGRAM_EXIT:
	invoke ExitProcess,0t
main endp


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
end


