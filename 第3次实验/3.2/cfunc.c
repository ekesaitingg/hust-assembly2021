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
	printf("�������û����� ");
	scanf("%s", user_name);
	if (strcmp(user_name, "WANGJIASHUN")) {
		printf("�û�������\n");
		return ERROR;
	}
	printf("���������룺   ");
	scanf("%s", password);
	if (strcmp(password, "U201914983")) {
		printf("�������");
		return ERROR;
	}
	printf("��½�ɹ�!\n");
	return OK;
}

void main_menu_print(void)
{
	system("pause");
	system("cls");
	printf("                                   ����˵�\n");
	printf("1.������Ʒ  2.����  3.����  4.����������  5.�������ʴӸߵ�����ʾ��Ʒ��Ϣ  6.�������Ʒ\n");
	printf("%s",STR6);
	return;
}

void new_item(void)
{
	if (m == N) {
		printf("��Ʒ���Ѵ����ޣ��޷��������\n");
		return;
	}
	printf("������������Ʒ��Ϣ��\n");
	scanf("%s %hd %hd %hd %hd", GAN[m - 5].GOODSNAME, &GAN[m - 5].BUYPRICE, &GAN[m - 5].SELLPRICE, &GAN[m - 5].BUYNUM, &GAN[m - 5].SELLNUM);
	m++;
	printf("%s",STR13);
	return;
}