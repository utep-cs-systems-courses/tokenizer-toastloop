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
    while (*token != '\0')
    {
        count++;
        token = token_terminator(token);
        token = token_start(token);
    }
    return count;
}
char **tokenize(char *str)
{
    int numTokens = count_tokens(str);
    char **tokens = malloc(sizeof(char *) * (numTokens + 1));
    char *token = token_start(str);
    int i = 0;
    while (*token != 0)
    {
        char *term = token_terminator(token);
        int len = term - token;
        tokens[i] = strcopy(token, len);
        token = token_start(term);
        i++;
    }
    tokens[i] = 0;
    return tokens;
}
void print_tokens(char **tokens)
{
    int i = 0;
    while (tokens[i] != 0)
    {
        printf("%s\n", tokens[i]);
        i++;
    }
}
void free_tokens(char **tokens)
{
    int i = 0;
    while (tokens[i] != 0)
    {
        free(tokens[i]);
        i++;
    }
    free(tokens);
}