#include <stdio.h>
#include "pstring.h"

char pstrlen(Pstring* pstr) {
    return pstr->len;
}

Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar) {
    char len  = pstrlen(pstr);
    for (char i = 0; i < len; i++) {
        if (pstr->str[i] == oldChar)
            pstr->str[i] = newChar;
    }
    return pstr;
}

Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j) {
    char dstlen = pstrlen(dst);
    char srclen = pstrlen(src);
    //i -= '0';
    //j -= '0';
    if (i < 0 || j < 0 || i >= dstlen || j >= dstlen) {
        printf("Invalid input!\n");
        return NULL;
    }
    else if (i < 0 || j < 0 || i >= srclen || j >= srclen) {
        printf("Invalid input!\n");
        return NULL;
    }
    else if (j < i) {
        printf("Invalid input!\n");
        return NULL;
    }
    else {
        do {
            dst->str[i] = src->str[i];
            i++;
        } while (i <= j); 
        return dst;
    }
}

Pstring* swapCase(Pstring* pstr) {
    char len  = pstrlen(pstr);
    for (char i = 0; i < len; i++) {
        if (64 < pstr->str[i] && pstr->str[i] < 91)
            pstr->str[i] += 32;
        else if (96 < pstr->str[i] && pstr->str[i] < 123)
            pstr->str[i] -= 32;
    }
    return pstr;
}

int pstrijcmp(Pstring* pstr1, Pstring* pstr2, char i, char j) {
    char strlen1 = pstrlen(pstr1);
    char strlen2 = pstrlen(pstr2);
    //i -= '0';
    //j -= '0';
    if (i < 0 || j < 0 || i >= strlen1 || j >= strlen1) {
        printf("Invalid input!\n");
        return -2;
    }
    else if (i < 0 || j < 0 || i >= strlen2 || j >= strlen2) {
        printf("Invalid input!\n");
        return -2;
    }
    else if (j < i) {
        printf("Invalid input!\n");
        return -2;
    }
    else {
        int str1sum = 0;
        int str2sum = 0;
        do {
            str1sum += pstr1->str[i];
            str2sum += pstr2->str[i];
            i++;
        } while (i <= j);
        if (str1sum > str2sum)
            return 1;
        if (str1sum == str2sum)
            return 0;
        if (str1sum < str2sum)
            return -1;
    }
}

//void main() {
//    return;
//}
