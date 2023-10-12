#include <stdlib.h>
#include <stdio.h>

#include "history.h"
#include "util.h"

char *token_start(char *str)
{
    while (spacechar(*(str))){
        str++;
    }
    return str;
}
char *token_terminator(char *token)
{
    while (validchar(*(token))){
        token++;
    }
    return token;
}
int count_tokens(char *str)
{
    int count = 0;
    char *token = token_start(str);
    while (!zerochar(*token))
    {
        count++;
        token = token_terminator(token);
        token = token_start(token);
    }
    return count;
}
char **tokenize(char *str)
{
    char **tokens = malloc(sizeof(char *) * (count_tokens(str) + 1));
    char *token = token_start(str);
    int i = 0;
    while (!zerochar(*token))
    {
        char *term = token_terminator(token);
        *(tokens + i) = strcopy(token, term - token);
        token = token_start(term);
        i++;
    }
    *(tokens + i) = strcopy("\0", 1);
    return tokens;
}
void print_tokens(char **tokens)
{
    while (!zerochar(**tokens))
    {
        printf("%s\n", *tokens);
        tokens++;
    }
}
void free_tokens(char **tokens)
{
    while (!zerochar(**tokens))
    {
        free(*tokens);
        tokens++;
    }
}