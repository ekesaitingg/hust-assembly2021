#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#define OK 1
#define ERROR 0
#define N 30
typedef struct goods {
	unsigned char GOODSNAME[10];
	short BUYPRICE, SELLPRICE, BUYNUM, SELLNUM, RATE;
} GOODS;
extern char STR6[20], STR13[10],chartype[3];
extern GOODS GAN[25];
short m = 5;

int login(void)
{
	char a[10];
	*(int*)a = 123;
	char user_name[20];
	char password[20];
	printf("请输入用户名： ");
	scanf("%s", user_name);
	if (strcmp(user_name, "WANGJIASHUN")) {
		printf("用户名错误！\n");
		return ERROR;
	}
	printf("请输入密码：   ");
	scanf("%s", password);
	if (strcmp(password, "U201914983")) {
		printf("密码错误");
		return ERROR;
	}
	printf("登陆成功!\n");
	return OK;
}

void main_menu_print(void)
{
	system("pause");
	system("cls");
	printf("                                   程序菜单\n");
	printf("1.查找商品  2.出货  3.补货  4.计算利润率  5.按利润率从高到低显示商品信息  6.添加新商品\n");
	printf("%s",STR6);
	return;
}

void new_item(void)
{
	if (m == N) {
		printf("商品数已达上限，无法继续添加\n");
		return;
	}
	printf("请输入新增商品信息：\n");
	scanf("%s %hd %hd %hd %hd", GAN[m - 5].GOODSNAME, &GAN[m - 5].BUYPRICE, &GAN[m - 5].SELLPRICE, &GAN[m - 5].BUYNUM, &GAN[m - 5].SELLNUM);
	m++;
	printf("%s",STR13);
	return;
}