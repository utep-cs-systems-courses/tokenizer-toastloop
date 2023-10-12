#include <stdlib.h>
#include <stdio.h>

#include "tokenizer.h"
#include "history.h"
#include "list.h"
#include "util.h"

int main(int argc, char **argv)
{
    ((void)argc, (void)argv);
    char *line = malloc(sizeof(char) * 1000);
    List *history = init_history();

    while (1)
    {
        fputs(">>> ", stdout);
        fgets(line, 1000, stdin);
        if(strcmp(line, "\n") == 0)
        {
            break;
        }
        if(line[strlen(line) - 1] == '\n')
        {
            line[strlen(line) - 1] = '\0';
        }
        if(*line == '!')
        {
            char *str = get_history(history, chartoint(line + 1));
            if(str != 0)
            {
                printf("%i: %s\n", chartoint(line + 1), str);
            }
            else
            {
                printf("History does not contain an entry for %i\n", chartoint(line + 1));
            }
        }
        else if(strcmp(line, "history") == 0)
        {
            print_history(history);
        }
        else if(strcmp(line, "exit") == 0)
        {
            break;
        }
        else
        {
            add_history(history, line);
            char **tokens = tokenize(line);
            print_tokens(tokens);
            free_tokens(tokens);
        }
    }
    free_history(history);
    return 0;
}

