.686P
.model flat, stdcall
 ExitProcess PROTO STDCALL :DWORD

 printf proto c:ptr sbyte,:vararg
 scanf proto c:ptr sbyte,:vararg
 strcmp proto :dword,:dword
 search proto
 CHOICE1 PROTO
 CHOICE2 PROTO
 CHOICE3 PROTO
 CHOICE4 PROTO
 CHOICE5 PROTO

 includelib  kernel32.lib
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib

 public lpfmt,numtype,chartype,num,STR8,STR9,STR10,STR11,STR12,STR13,STR14,STR15,TMP,GA1,GA2,GA3,GA4,GA5,GAN,LIST,IGA,m
 GOODS  STRUCT
    GOODSNAME  db 10 DUP(0)
    BUYPRICE   DW  0
    SELLPRICE  DW  0
    BUYNUM     DW  0
    SELLNUM    DW  0
    RATE       DW  0
GOODS  ENDS



 .data
BNAME  DB 'WANGJIASHUN',0
INAME   DB 20 DUP(0)
BPASS  DB 'U201914983',0
IPASS   DB 20 DUP(0)
N  EQU  30
m dw 5
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
IGA  DB  10 DUP(0)
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
	jz C1
	cmp choice,2
	jz C2
	cmp choice,3
	jz C3
	cmp choice,4
	jz C4
	cmp choice,5
	jz C5
	invoke printf,offset STR15
	jmp MAIN_MENU
C1:
	call CHOICE1
	jmp MAIN_MENU
C2:
	call CHOICE2
	jmp MAIN_MENU
C3:
	call CHOICE3
	jmp MAIN_MENU
C4:
	call CHOICE4
	jmp MAIN_MENU
C5:
	call CHOICE5
	jmp MAIN_MENU
INPUT_ERROR1:
	invoke printf,offset STR3
	jmp PROGRAM_EXIT
INPUT_ERROR2:
	invoke printf,offset STR4
	jmp PROGRAM_EXIT
PROGRAM_EXIT:
	invoke ExitProcess,0
main endp
end