# AssemblyProject

This repo documents an implementation of P-String and realated functions in Assembly language as part of Computer Structure course I took at Bar-Ilan university.

## Background

P-String is a way to save string as an array of chars where the first byte represents the length of the string:
```javascript
typedef struct {
    char size;
    char string[255];
} Pstring;
```
In this repo I've implemented a P-String smilar to those in string.h library, but using assembly language.

## P-String in the Stack

The pstring "hello" will be stored in the stack as:

![image](https://user-images.githubusercontent.com/72878018/120895024-db47c180-c623-11eb-88ef-fb26716913c6.png)


## Files

1. run_main.s -- program's entry.
2. pstring.s -- implementations of library functions.
3. func_select.s -- implementation of a function that call other functions.

## Program's Structure

run_main() gets two strings and two lengths from the user, build two pstrings and send them to run_func() in func_select.s. run_func uses a jump-table (switch-case) to determine what function from pstring.s to use.

## Jump-Table / Switch-Case Options:

- 50 / 60 -- pstrlen -- prints the length of the pstring (return the first byte).
- 52 -- replaceChar -- replace a specific char in the p-string.
- 53 -- pstrijcpy -- copy sub-string between index i to index j to another pstring.
- 54 -- swapCase -- change case of English characters.
- 55 -- pstrijcmp -- compare strings from index i to index j.

## Notes

- The code is heavily commented.
- IDE: Visual Studio Code.
- Useful document in resources directory: **CS107 Handy one-page of x64-86**.
