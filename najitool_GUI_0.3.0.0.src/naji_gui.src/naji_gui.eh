#ifndef __NAJITOOL__NAJI_GUI_EH__NAJI__
#define __NAJITOOL__NAJI_GUI_EH__NAJI__

#define uint _uint
#include <math.h>
#include <time.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#undef uint

#define NAJI_FALSE 0
#define NAJI_TRUE  1

#define naji_tolower(a) if ( ( (a) >= 'A') && ( (a) <= 'Z') ) a += 32;
#define naji_toupper(a) if ( ( (a) >= 'a') && ( (a) <= 'z') ) a -= 32;

#define rndinit() srand(time(NULL))

#define rndrange(start, end) ( rand() % ( (end) + (start) ) )

#ifndef najinew
#define najinew(Type, HowMany) (Type *) malloc(HowMany * sizeof(Type));
#endif

#ifndef newchar
#define newchar(amount) najinew(char, amount);
#endif

#ifndef newshort
#define newshort(amount) najinew(short, amount);
#endif

#ifndef newint
#define newint(amount) najinew(int, amount);
#endif

#ifndef newlong
#define newlong(amount) najinew(long, amount);
#endif

#ifndef newuchar
#define newuchar(amount) najinew(UCHAR, amount);
#endif

#ifndef newshort
#define newshort(amount) najinew(USHORT, amount);
#endif

#ifndef newuint
#define newuint(amount) najinew(UINT, amount);
#endif

#ifndef newulong
#define newulong(amount) najinew(ULONG, amount);
#endif

#ifndef newfloat
#define newfloat(amount) najinew(FLOAT, amount);
#endif

#ifndef newdouble
#define newdouble(amount) najinew(DOUBLE amount);
#endif

#define exitnull(item) \
if ( ( (item) == NULL ) ) \
{\
MessageBox { text = "najitool GUI error:", contents = "NULL pointer error."}.Modal(); exit(8);\
}

struct najiline
{
    int  len;
    long pos;
};

void msgbox(char *the_text, char *the_contents);

extern void mp3split (char const * name, char const * output,
                          unsigned int const start, unsigned int const end);

extern char * mp3info (char *name);

#define NAJITOOL_MAX_PROGRAMMING 12
#define NAJITOOL_MAX_COMPRESSION 2
#define NAJITOOL_MAX_ENCRYPTION 2
#define NAJITOOL_MAX_DATE_TIME 13
#define NAJITOOL_MAX_GENERATE 16
#define NAJITOOL_MAX_CONVERT 10
#define NAJITOOL_MAX_FILTER 45
#define NAJITOOL_MAX_FORMAT 30
#define NAJITOOL_MAX_STATUS 21
#define NAJITOOL_MAX_IMAGES 2
#define NAJITOOL_MAX_AUDIO 3
#define NAJITOOL_MAX_GAMES 2
#define NAJITOOL_MAX_EDIT 4
#define NAJITOOL_MAX_MISC 24
#define NAJITOOL_MAX_WEB 11
#define NAJITOOL_MAX_COMMANDS 195
#define NAJITOOL_MAX_CATEGORIES 16

#define naji_max(a,b) ( ( (a) > (b) ) ? (a):(b) )
#define naji_min(a,b) ( ( (a) < (b) ) ? (a):(b) )

#ifndef PI
#define PI 3.14159265358979323846
#endif

#endif /* __NAJITOOL__NAJI_GUI_EH__NAJI__ */
