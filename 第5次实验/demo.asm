.686p
.model   flat,stdcall
option   casemap:none

WinMain  proto :DWORD,:DWORD,:DWORD,:DWORD
WndProc  proto :DWORD,:DWORD,:DWORD,:DWORD
Display  proto :DWORD
CHOICE4 proto
CHOICE5 proto
numchange proto :dword

include      menuID.INC
include      windows.inc
include      user32.inc
include      kernel32.inc
include      gdi32.inc
include      shell32.inc

includelib   user32.lib
includelib   kernel32.lib
includelib   gdi32.lib
includelib   shell32.lib

public lpfmt,numtype,chartype,num,STR6,STR8,STR9,STR10,STR11,STR12,STR13,STR14,STR15,GA1,GA2,GA3,GA4,GA5,GAN,LIST,IGA,m,RATELIST

student	     struct
	     myname   db  10 dup(0)
	     chinese  db  0
	     math     db  0
	     english  db  0
	     average  db  0
	     grade    db  0
student      ends
GOODS  STRUCT
    GOODSNAME  db 10 DUP(0)
    BUYPRICE   DW  0
    SELLPRICE  DW  0
    BUYNUM     DW  0
    SELLNUM    DW  0
    RATE       DW  0
GOODS  ENDS

.data
m            dw       5
ClassName    db       'TryWinClass',0
AppName      db       '关于',0
MenuName     db       'MyMenu',0
DlgName	     db       'MyDialog',0
AboutMsg     db       '王家顺',0AH,'U201914983',0
hInstance    dd       0
CommandLine  dd       0
buf	     student  <>
	     student  <'Jin',96,98,100,98,'A'>
	     student  3 dup(<>)
msg1         db  'Goodsname',0
msg2         db  'Buyprice',0
msg3         db  'Sellprice',0
msg4         db  'Buynum',0
msg5         db  'Sellnum',0
msg6         db  'Rate(%)',0
msg_name     db       'name',0
msg_chinese  db       'chinese',0
msg_math     db       'math',0
msg_english  db       'english',0
msg_average  db       'average',0
msg_grade    db       'grade',0
chinese	     db       2,0,0,0, '96'
math	     db       2,0,0,0, '98'
english	     db       3,0,0,0, '100'
average	     db       2,0,0,0, '98'
menuItem     db       0  ;当前菜单状态, 1=处于list, 0=Clear

BNAME   DB 'WANGJIASHUN',0
INAME   DB 20 DUP(0)
BPASS   DB 'U201914983',0
IPASS   DB 20 DUP(0)
N  EQU  30

choice  DW ?
num DW ?
lpfmt DB '%s',0
numtype DB '%hd',0
chartype DB '%c',0

STR1 DB  '请输入用户名: ',0
STR2 DB  '密码: ',0
STR3 DB  '用户名不存在',0
STR4 DB  '密码错误',0
STR5 DB  '登录成功',0AH,0
STR6 DB  '请选择要执行的操作:',0
STR8 DB  '商品名称：%s  进货价：%hd  销售价：%hd  进货数量：%hd  已售数量：%hd  利润率：%hd%%',0AH,0
STR9 DB  '未找到目标商品',0AH,0
STR10 DB '请输入商品名: ',0
STR11 DB '请输入出货量: ',0
STR12 DB '操作失败，出货量应小于剩余数量',0AH,0
STR13 DB '操作成功',0AH,0
STR14 DB '请输入补货量: ',0
STR15 DB '输入错误',0AH,0

GA1 GOODS <'PEN       ',15,20,70,25,?>
GA2 GOODS <'PENCIL    ',2,3,100,20,?>
GA3 GOODS <'BOOK      ',30,40,25,5,?>
GA4 GOODS <'RULER     ',3,4,200,150,?>
GA5 GOODS <'ERASER    ',15,20,30,30,?>
GAN GOODS N-5 DUP(<'TempValue',15,20,30,0,?>)
RATELIST DB 25 DUP(32)
LIST DD N  DUP(?)
IGA  DB 10 DUP(0)

.code
Start:	     invoke GetModuleHandle,NULL
	     mov    hInstance,eax
	     invoke GetCommandLine
	     mov    CommandLine,eax
	     invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
	     invoke ExitProcess,eax
	     ;;
WinMain  proc   hInst:DWORD,hPrevInst:DWORD,CmdLine:DWORD,CmdShow:DWORD
	     LOCAL  wc:WNDCLASSEX
	     LOCAL  msg:MSG
	     LOCAL  hWnd:HWND
         invoke RtlZeroMemory,addr wc,sizeof wc
	     mov    wc.cbSize,SIZEOF WNDCLASSEX
	     mov    wc.style, CS_HREDRAW or CS_VREDRAW
	     mov    wc.lpfnWndProc, offset WndProc
	     mov    wc.cbClsExtra,NULL
	     mov    wc.cbWndExtra,NULL
	     push   hInst
	     pop    wc.hInstance
	     mov    wc.hbrBackground,COLOR_WINDOW+1
	     mov    wc.lpszMenuName, offset MenuName
	     mov    wc.lpszClassName,offset ClassName
	     invoke LoadIcon,NULL,IDI_APPLICATION
	     mov    wc.hIcon,eax
	     mov    wc.hIconSm,0
	     invoke LoadCursor,NULL,IDC_ARROW
	     mov    wc.hCursor,eax
	     invoke RegisterClassEx, addr wc
	     INVOKE CreateWindowEx,NULL,addr ClassName,addr AppName,\
                    WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
                    CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,\
                    hInst,NULL
	     mov    hWnd,eax
	     INVOKE ShowWindow,hWnd,SW_SHOWNORMAL
	     INVOKE UpdateWindow,hWnd
	     ;;
MsgLoop:     INVOKE GetMessage,addr msg,NULL,0,0
             cmp    EAX,0
             je     ExitLoop
             INVOKE TranslateMessage,addr msg
             INVOKE DispatchMessage,addr msg
	     jmp    MsgLoop 
ExitLoop:    mov    eax,msg.wParam
	     ret
WinMain      endp

WndProc      proc   hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	     LOCAL  hdc:HDC
	     LOCAL  ps:PAINTSTRUCT
     .IF     uMsg == WM_DESTROY
	     invoke PostQuitMessage,NULL
     .ELSEIF uMsg == WM_KEYDOWN
	    .IF     wParam == VK_F1
             ;;your code
	    .ENDIF
     .ELSEIF uMsg == WM_COMMAND
	    .IF     wParam == IDM_FILE_EXIT
		    invoke SendMessage,hWnd,WM_CLOSE,0,0
	    .ELSEIF wParam == IDM_HELP_ABOUT
		    invoke MessageBox,hWnd,addr AboutMsg,addr AppName,0
		.ELSEIF wParam == IDM_ACTION_COMP
			call CHOICE4
			mov menuItem, 0
		    invoke InvalidateRect,hWnd,0,1  ;擦除整个客户区
		    invoke UpdateWindow, hWnd
		.ELSEIF wParam == IDM_ACTION_SORT
			call CHOICE5
			mov menuItem, 1
		    invoke InvalidateRect,hWnd,0,1  ;擦除整个客户区
		    invoke UpdateWindow, hWnd
	    .ENDIF
     .ELSEIF uMsg == WM_PAINT
             invoke BeginPaint,hWnd, addr ps
             mov hdc,eax
	     .IF menuItem == 1
		 invoke Display,hdc
	     .ENDIF
	     invoke EndPaint,hWnd,addr ps
     .ELSE
             invoke DefWindowProc,hWnd,uMsg,wParam,lParam
             ret
     .ENDIF
  	     xor    eax,eax
	     ret
WndProc      endp

numchange proc p:dword  ;p为某一种商品的地址
	mov ecx,24
LIST_CLEAR:

	mov RATELIST[ecx],32
	dec ecx
	cmp ecx,0
	jns LIST_CLEAR
	mov esi,p
	add esi,10
	mov edi,offset RATELIST
	mov ecx,0     ;循环次数
nextnum:
	cmp ecx,5
	jz exit_process
	mov ax,word ptr[esi]
 	cmp ax,0
	jns POSITIVE
	mov byte ptr[edi],2DH
	imul ax,-1
POSITIVE:
	mov ebx,4 
POS_LOOP:
	cwd
	push esi
	mov si,10
	idiv si
	pop esi
	add dl,30H
	mov [edi+ebx],dl
	dec ebx
	cmp ax,0
	jnz POS_LOOP
	add esi,2
	inc ecx
	add edi,5
	jmp nextnum
exit_process:
	ret	
numchange endp
	

Display      proc   hdc:HDC
             XX     equ  10
             YY     equ  10
	         XX_GAP equ  100               
	         YY_GAP equ  30
             invoke TextOut,hdc,XX+0*XX_GAP,YY+0*YY_GAP,offset msg1,9
             invoke TextOut,hdc,XX+1*XX_GAP,YY+0*YY_GAP,offset msg2,8
             invoke TextOut,hdc,XX+2*XX_GAP,YY+0*YY_GAP,offset msg3,9
             invoke TextOut,hdc,XX+3*XX_GAP,YY+0*YY_GAP,offset msg4,6
             invoke TextOut,hdc,XX+4*XX_GAP,YY+0*YY_GAP,offset msg5,7
             invoke TextOut,hdc,XX+5*XX_GAP,YY+0*YY_GAP,offset msg6,7
             ;;
			 mov esi,0
DISPLAY_LOOP:
			 push esi
			 invoke numchange,LIST[4*esi]
			 pop esi
			 mov ebx,esi
			 add ebx,1
			 imul ebx,YY_GAP
			 add ebx,YY
			 invoke TextOut,hdc,XX+0*XX_GAP,ebx,LIST[4*esi],10
			 invoke TextOut,hdc,XX+1*XX_GAP,ebx,offset RATELIST,5
			 invoke TextOut,hdc,XX+2*XX_GAP,ebx,offset RATELIST+5,5
			 invoke TextOut,hdc,XX+3*XX_GAP,ebx,offset RATELIST+10,5
			 invoke TextOut,hdc,XX+4*XX_GAP,ebx,offset RATELIST+15,5
			 invoke TextOut,hdc,XX+5*XX_GAP,ebx,offset RATELIST+20,5
			 add esi,1
			 cmp esi,5
			 jnz DISPLAY_LOOP
             ret
Display      endp

             end  Start
