#include <stdlib.h>
#include <stdio.h>

int strcmp(const char *a, const char *b)
{
    while(*a && * b)
    {
        int diff = *a++ - *b++;
        if(diff)
        {
            return diff;
        }
    }
    if(!*a && !*b)
    {
        return 0;
    }
    return (*a) ? 1 : -1;
}

#ifdef _WIN32
long long unsigned int strlen(const char *str)
{
    long long unsigned int len = 0;
    while (str[len] != '\0') {
        len++;
    }
    return len;
}
#else
unsigned long strlen(const char *str)
{
    unsigned long len = 0;
    while (str[len] != '\0') {
        len++;
    }
    return len;
}
#endif

char* strcopy(char *str, short len)
{
    char *out = malloc((len + 1) * sizeof(char));
    for(int i = 0; i < len; i++){
        * (out + i) = * (str + i);
    }
    * (out + len) = '\0';
    return out;
}
int zerochar(char c)
{
    return c == '\0';
}
int spacechar(char c)
{
    return (c == ' ' || c == '\t') && !zerochar(c);
}
int validchar(char c)
{
    return !spacechar(c) && !zerochar(c);
}
int chartoint(char *str)
{
    int num = 0;
    while (*str != '\0')
    {
        num = num * 10 + (*str - '0');
        str++;
    }
    return num;
}
int charcmp(char a, char b)
{
    return a - b;
}
int arraylen(char **arr)
{
    int len = 0;
    while (!zerochar(**arr))
    {
        len++;
        arr++;
    }
    return len;
}