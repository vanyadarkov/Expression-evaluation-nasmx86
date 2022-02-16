#include <stdio.h>
#include <stdlib.h>
#define MAX_LINE 100001

int expression(char *p, int *i);
int term(char *p, int *i);
int factor(char *p, int *i);

int main()
{
    char s[MAX_LINE];
    char *p;
    int i = 0;  
    scanf("%s", s);
    p = s;
    printf("%d\n", expression(p, &i));
    return 0;
}

// int expression1(char *p, int *i)
// {
// 	int result = term1(p, i);
//     char c;
//     c = *(p + *i);
// 	while(c == '+' || c == '-')
// 	{
//         c = *(p + *i);
//         *i = *i + 1;
// 		if(c == '+')
//         {
//             result += term1(p, i);
//         }
// 		else if(c == '-')
//         {
//             result -= term1(p, i);
//         }
//         c = *(p + *i);  
// 	}
// 	return result;
// }

// int term1(char *p, int *i)
// {
// 	int result = factor1(p, i);
//     char c;
//     c = *(p + *i);
// 	while(c == '*' || c == '/')
// 	{
//         c = *(p + *i);
//         *i = *i + 1;
// 		if(c == '*')
//         {
//             result *= factor1(p, i);
//         }
// 		if(c == '/')
//         {
//             result /= factor1(p, i);
//         }
//         c = *(p + *i); 
// 	}
// 	return result;
// }

// int factor1(char *p, int *i)
// {
// 	int result = 0;
//     char c = *(p + *i);
// 	if(c == '(')
// 	{
//         *i = *i + 1;
// 		result += expression1(p, i);
//         *i = *i + 1;
// 	}
// 	else while(c >= 48 && c <= 57)
// 	{
// 		result = result * 10 + c - '0';
//         *i = *i + 1;
//         c = *(p + *i);
// 	}
// 	return result;
// }