#ifndef _UTIL_
#define _UTIL_

/* The `strcmp(char *a, char *b)` function is used to compare two strings `a` and `b`. 
It returns an integer value that indicates the relationship between the two strings. 
The return value is 0 if the strings are equal, a negative value if `a` is less than `b`, 
and a positive value if `a` is greater than `b`. */
int strcmp(const char *a, const char *b);

/* The `strcopy` function is used to copy a string `str` to a new string of length `len`.
It takes two arguments - a pointer to the original string `str` and the length of the 
new string `len`. The function returns a pointer to the new string. */
char* strcopy(char *str, short len);

#ifdef _WIN32
/* The `strlen` function is used to calculate the length of a string. It takes a pointer 
to a constant character array (`const char *str`) as its argument and returns the length 
of the string as a `long long unsigned int` value. */
long long unsigned int strlen(const char *);
#else
/* The `strlen` function is used to calculate the length of a string. It takes a pointer 
to a constant character array (`const char *str`) as its argument and returns the length 
of the string as a `long unsigned int` value. */
unsigned long strlen(const char *str);
#endif

/* The `int zerochar(char c);` function is used to check if a character `c` is a zero 
character. It returns an integer value - 1 if the character is a zero character, 
and 0 if it is not. */
int zerochar(char c);

/* The `spacechar(char c);` function is used to check if a character `c` is a space 
character. It returns an integer value - 1 if the character is a space, and 0 if it is not. */
int spacechar(char c);

/* The `validchar(char c)` function is used to check if a character `c` is a valid character. 
It returns an integer value - 1 if the character is valid, and 0 if it is not. The definition 
and implementation of this function are not provided in the code snippet. */
int validchar(char c);

/* The `chartoint(char *str)` function is used to convert a string `str` containing a single 
character into an integer value. It takes a pointer to the string as its argument and returns 
the corresponding integer value. */
int chartoint(char *str);

/* The `charcmp` function is used to compare two characters `a` and `b`. It returns an integer 
value that indicates the relationship between the two characters. The return value is 0 if the 
characters are equal, a negative value if `a` is less than `b`, and a positive value if `a` is 
greater than `b`. */
int charcmp(char a, char b);

#endif