#ifndef najinew
#define najinew(Type, HowMany) (Type *) malloc(HowMany * sizeof(Type));
#endif

#ifndef newchar
#define newchar(amount)  najinew(char, amount);
#endif

#ifndef newshort
#define newshort(amount) najinew(short, amount);
#endif

#ifndef newint
#define newint(amount)   najinew(int, amount);
#endif

#ifndef newlong
#define newlong(amount)  najinew(long, amount);
#endif

#ifndef newuchar
#define newuchar(amount) najinew(UCHAR, amount);
#endif

#ifndef newshort
#define newshort(amount) najinew(USHORT, amount);
#endif

#ifndef newuint
#define newuint(amount)  najinew(UINT, amount);
#endif

#ifndef newulong
#define newulong(amount) najinew(ULONG, amount);
#endif

#ifndef newfloat
#define newfloat(amount)  najinew(FLOAT, amount);
#endif

#ifndef newdouble
#define newdouble(amount) najinew(DOUBLE amount);
#endif
