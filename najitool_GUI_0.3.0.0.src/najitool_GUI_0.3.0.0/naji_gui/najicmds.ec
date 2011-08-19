#include "naji_gui.eh"
#include "naji_uni.eh"
#ifdef ECERE_STATIC
import static "ecere"
#else
import "ecere"
#endif


FILE *naji_input;
FILE *naji_input2;

FILE *naji_output;
FILE *naji_output2;

FILE *naji_edit;

extern char najitool_language[1000];

unsigned char ascii_to_ebcdic_array[256] = {
          0,  1,  2,  3, 55, 45, 46, 47, 22,  5, 37, 11, 12, 13, 14, 15,
         16, 17, 18, 19, 60, 61, 50, 38, 24, 25, 63, 39, 28, 29, 30, 31,
         64, 79,127,123, 91,108, 80,125, 77, 93, 92, 78,107, 96, 75, 97,
        240,241,242,243,244,245,246,247,248,249,122, 94, 76,126,110,111,
        124,193,194,195,196,197,198,199,200,201,209,210,211,212,213,214,
        215,216,217,226,227,228,229,230,231,232,233, 74,224, 90, 95,109,
        121,129,130,131,132,133,134,135,136,137,145,146,147,148,149,150,
        151,152,153,162,163,164,165,166,167,168,169,192,106,208,161,  7,
         32, 33, 34, 35, 36, 21,  6, 23, 40, 41, 42, 43, 44,  9, 10, 27,
         48, 49, 26, 51, 52, 53, 54,  8, 56, 57, 58, 59,  4, 20, 62,225,
         65, 66, 67, 68, 69, 70, 71, 72, 73, 81, 82, 83, 84, 85, 86, 87,
         88, 89, 98, 99,100,101,102,103,104,105,112,113,114,115,116,117,
        118,119,120,128,138,139,140,141,142,143,144,154,155,156,157,158,
        159,160,170,171,172,173,174,175,176,177,178,179,180,181,182,183,
        184,185,186,187,188,189,190,191,202,203,204,205,206,207,218,219,
        220,221,222,223,234,235,236,237,238,239,250,251,252,253,254,255
};

unsigned char ebcdic_to_ascii_array[256] = {
          0,  1,  2,  3,156,  9,134,127,151,141,142, 11, 12, 13, 14, 15,
         16, 17, 18, 19,157,133,  8,135, 24, 25,146,143, 28, 29, 30, 31,
        128,129,130,131,132, 10, 23, 27,136,137,138,139,140,  5,  6,  7,
        144,145, 22,147,148,149,150,  4,152,153,154,155, 20, 21,158, 26,
         32,160,161,162,163,164,165,166,167,168, 91, 46, 60, 40, 43, 33,
         38,169,170,171,172,173,174,175,176,177, 93, 36, 42, 41, 59, 94,
         45, 47,178,179,180,181,182,183,184,185,124, 44, 37, 95, 62, 63,
        186,187,188,189,190,191,192,193,194, 96, 58, 35, 64, 39, 61, 34,
        195, 97, 98, 99,100,101,102,103,104,105,196,197,198,199,200,201,
        202,106,107,108,109,110,111,112,113,114,203,204,205,206,207,208,
        209,126,115,116,117,118,119,120,121,122,210,211,212,213,214,215,
        216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,
        123, 65, 66, 67, 68, 69, 70, 71, 72, 73,232,233,234,235,236,237,
        125, 74, 75, 76, 77, 78, 79, 80, 81, 82,238,239,240,241,242,243,
         92,159, 83, 84, 85, 86, 87, 88, 89, 90,244,245,246,247,248,249,
         48, 49, 50, 51, 52, 53, 54, 55, 56, 57,250,251,252,253,254,255
};



const char * najitool_valid_categories[NAJITOOL_MAX_CATEGORIES] = {  
"Programming",
"Compression",
"Encryption",
"Date/Time",
"Generate",
"Convert",
"Filter",
"Format",
"Status",
"Images",
"Audio",
"Games",
"Edit",
"Misc",
"Web",
"All"
}; 

const char * najitool_valid_categories_turkish[NAJITOOL_MAX_CATEGORIES] = {  
"Programlama",
"Kompresyon",
"Sifreleme",
"Tarih/Saat",
"Olusturma",
"Donusme",
"Filtreleme",
"Duzenleme",
"Durum",
"Resimler",
"Sesler",
"Oyunlar",
"Deyistirme",
"Cesitli",
"HTML",
"Tum"
}; 





const char * najitool_valid_programming[NAJITOOL_MAX_PROGRAMMING] = {  
"bin2c",
"dumpoffs",
"file2bin",
"file2dec",
"file2hex",
"hmaker",
"hmakerf",
"makarray",
"mkpatch",
"patch",
"printftx",
"qpatch"
};

const char * najitool_valid_compression[NAJITOOL_MAX_COMPRESSION] = {
"najirle",
"unajirle"
};

const char * najitool_valid_encryption[NAJITOOL_MAX_ENCRYPTION] = {  
"najcrypt",
"qcrypt"
};

const char * najitool_valid_date_time[NAJITOOL_MAX_DATE_TIME] = {  
"ay",
"ayinkaci",
"bugun",
"datetime",
"dayofmon",
"month",
"year",
"yil",
"saat",
"saatarih",
"systemdt",
"telltime",
"today"
};


const char * najitool_valid_generate[NAJITOOL_MAX_GENERATE] = {  
"8bit256",
"addim",
"allfiles",
"allbmp16",
"asctable",
"charfile",
"engnum",
"genhelp",
"genlic",
"htmlhelp",
"lcvfiles",
"rcvfiles",
"rndbfile",
"rndtfile",
"strfile",
"turnum"
};

const char * najitool_valid_convert[NAJITOOL_MAX_CONVERT] = {  
"asc2ebc", 
"bin2hexi",
"dos2unix",
"ebc2asc",
"f2lower",
"f2upper",
"tabspace",
"unix2dos",
"uudecode",
"uuencode"
};
   
const char * najitool_valid_filter[NAJITOOL_MAX_FILTER] = {
"bin2text",
"bremline",
"chchar",
"chchars",
"chstr",
"copyoffs",
"cpfroml",
"cptiline",
"eremline",
"filechop",
"filejoin",
"flipcopy",
"linesnip",
"mergline",
"n2ch",
"n2str",
"onlalnum",
"onlalpha",
"onlcntrl",
"onldigit",
"onlgraph",
"onllower",
"onlprint",
"onlpunct",
"onlspace",
"onlupper",
"onlxdigt",
"onlycat",
"onlychar",
"putlines",
"remline",
"skipcat",
"skipchar",
"skipstr",
"skpalnum",
"skpalpha",
"skpcntrl",
"skpdigit",
"skpgraph",
"skplower",
"skpprint",
"skppunct",
"skpspace",
"skpupper",
"skpxdigt"
};

const char * najitool_valid_format[NAJITOOL_MAX_FORMAT] = {  
"blanka",
"charaftr",
"charbefr",
"charwrap", 
"filbreed", 
"freverse",
"fswpcase",
"lensortl",
"lensorts",
"numlines",
"putlines",
"rbcafter",
"rbcbefor",
"repchar",
"repcharp",
"revlines",
"rrrchars",
"rstrach",
"rstrbch",
"rtcafter",
"rtcbefor",
"strachar",
"strbchar",
"strbline",
"streline",
"swapfeb",
"unblanka",
"wordline",
"wordwrap"
};
 
const char * najitool_valid_status[NAJITOOL_MAX_STATUS] = {  
"cat_head",
"cat_tail",
"cat_text",
"catrandl",
"ccompare",
"cfind",
"cfindi",
"coffset",
"compare",
"find",
"findi",
"hexicat",
"kitten",
"najisum",
"repcat",
"repcatpp",
"revcat",
"rndbsout",
"rndtsout",
"showline",
"wrdcount"
}; 

const char * najitool_valid_images[NAJITOOL_MAX_IMAGES] = {  
"naji_bmp",
"allbmp16",
};

const char * najitool_valid_audio[NAJITOOL_MAX_AUDIO] = {  
"mp3split",
"mp3taged",
"mp3tagnf"
};

const char * najitool_valid_games[NAJITOOL_MAX_GAMES] = {  
"mathgame",
"ttt"
};

const char * najitool_valid_edit[NAJITOOL_MAX_EDIT] = {  
"fillfile",
"randkill",
"rndffill",
"zerokill"
};
      
const char * najitool_valid_misc[NAJITOOL_MAX_MISC] = {  
"arab2eng",
"bigascif",
"bigascii",
"calc",
"charsort",
"copyfile",
"credits",
"database",
"eng2arab",
"ftothe",
"gdivide",
"gigabyte",
"gminus",
"gplus",
"gtimes",
"help",
"lcharvar",
"leetfile",
"leetstr", 
"length",
"license",
"rcharvar",
"tothe",
"vowelwrd"
};

const char * najitool_valid_web[NAJITOOL_MAX_WEB] = {  
"downlist",
"e2ahtml",
"getlinks",
"hilist",
"html_db",
"html2txt",
"htmlfast",
"htmlhelp",
"rmunihtm",
"txt2html",
"unihtml"
};

const char * najitool_valid_commands[NAJITOOL_MAX_COMMANDS] = {
"8bit256",
"addim",
"allfiles",
"allbmp16",
"arab2eng",
"asc2ebc",
"asctable",
"ay",
"ayinkaci",
"bigascif",
"bigascii",
"bin2c",
"bin2hexi",
"bin2text",
"blanka",
"bremline",
"bugun",
"calc",
"cat_head",
"cat_tail",
"cat_text",
"catrandl",
"ccompare",
"cfind",
"cfindi",
"charaftr",
"charbefr",
"charfile",
"charsort",
"charwrap",
"chchar",
"chchars",
"chstr",
"coffset",
"compare",
"copyfile",
"copyoffs",
"copyself",
"cpfroml",
"cptiline",
"credits",
"database",
"datetime",
"dayofmon",
"dos2unix",
"downlist",
"dumpoffs",
"e2ahtml",
"ebc2asc",
"eng2arab",
"engnum",
"eremline",
"f2lower",
"f2upper",
"filbreed",
"file2bin",
"file2dec",
"file2hex",
"filechop",
"filejoin",
"fillfile",
"find",
"findi",
"flipcopy",
"freverse",
"fswpcase",
"ftothe",
"genhelp",
"genlic",
"getlinks",
"gdivide",
"gigabyte",
"gminus",
"gplus",
"gtimes",
"help",
"hexicat",
"hilist",
"hmaker",
"hmakerf",
"html_db",
"html2txt",
"htmlfast",
"htmlhelp",
"kitten",
"lcharvar",
"lcvfiles",
"leetfile",
"leetstr",
"length",
"lensortl",
"lensorts",
"license",
"linesnip",
"makarray",
"mathgame",
"mergline",
"mkpatch",
"month",
"mp3split",
"mp3taged",
"mp3tagnf",
"n2ch",
"n2str",
"najcrypt",
"naji_bmp",
"najirle",
"najisum",
"numlines",
"onlalnum",
"onlalpha",
"onlcntrl",
"onldigit",
"onlgraph",
"onllower",
"onlprint",
"onlpunct",
"onlspace",
"onlupper",
"onlxdigt",
"onlycat",
"onlychar",
"patch",
"printftx",
"putlines",
"qcrypt",
"qpatch",
"randkill",
"rbcafter",
"rbcbefor",
"rcharvar",
"rcvfiles",
"remline",
"repcat",
"repcatpp",
"repchar",
"repcharp",
"revcat",
"revlines",
"rmunihtm",
"rndbfile",
"rndbsout",
"rndffill",
"rndtfile",
"rndtsout",
"rrrchars",
"rstrach",
"rstrbch",
"rtcafter",
"rtcbefor",
"saat",
"saatarih",
"showline",
"skipcat",
"skipchar",
"skipstr",
"skpalnum",
"skpalpha",
"skpcntrl",
"skpdigit",
"skpgraph",
"skplower",
"skpprint",
"skppunct",
"skpspace",
"skpupper",
"skpxdigt",
"strachar",
"strbchar",
"strbline",
"streline",
"strfile",
"swapfeb",
"systemdt",
"tabspace",
"telltime",
"today",
"tothe",
"ttt",
"turnum",
"txt2html",
"unihtml",
"unajirle",
"unblanka",
"unix2dos",
"uudecode",
"uuencode",
"vowelwrd",
"wordline",
"wordwrap",
"wrdcount",
"year",
"yil",
"zerokill"
}; 



void rand_init(void) { srand(time(NULL)); }



char swap_char_var;
#define swap_char(a, b)  swap_char_var=a;   a=b;  b=swap_char_var;







int swrdcoun(const char *string)
{
int i=0;
int x=1;
int c=0;

        for (i=0; string[i] != '\0'; ++i)
        if ( (string[i] > 32) && (string[i] < 127) )
        {
                if (x)
                {
                ++c;
                x=0;
                }
        }
        else x=1;

return c;
}

void sreverse(char *str)
{
int i;
int len=strlen(str);
char *strbackup=newchar(len);
exitnull(strbackup);

strcpy(strbackup, str);

   for (i=0; i<len; i++)
   str[i] = '\0';

   for (i=0; i<len; i++)
   str[len-i-1] = strbackup[i];

}




void sflpcase(char *str)
{
int i;
int len=strlen(str);

     for (i=0; i<len; i++)
     {
     if (str[i] == 'A') { str[i] = 'a'; continue; }
     if (str[i] == 'B') { str[i] = 'b'; continue; }
     if (str[i] == 'C') { str[i] = 'c'; continue; }
     if (str[i] == 'D') { str[i] = 'd'; continue; }
     if (str[i] == 'E') { str[i] = 'e'; continue; }
     if (str[i] == 'F') { str[i] = 'f'; continue; }
     if (str[i] == 'G') { str[i] = 'g'; continue; }
     if (str[i] == 'H') { str[i] = 'h'; continue; }
     if (str[i] == 'I') { str[i] = 'i'; continue; }
     if (str[i] == 'J') { str[i] = 'j'; continue; }
     if (str[i] == 'K') { str[i] = 'k'; continue; }
     if (str[i] == 'L') { str[i] = 'l'; continue; }
     if (str[i] == 'M') { str[i] = 'm'; continue; }
     if (str[i] == 'N') { str[i] = 'n'; continue; }
     if (str[i] == 'O') { str[i] = 'o'; continue; }
     if (str[i] == 'P') { str[i] = 'p'; continue; }
     if (str[i] == 'Q') { str[i] = 'q'; continue; }
     if (str[i] == 'R') { str[i] = 'r'; continue; }
     if (str[i] == 'S') { str[i] = 's'; continue; }
     if (str[i] == 'T') { str[i] = 't'; continue; }
     if (str[i] == 'U') { str[i] = 'u'; continue; }
     if (str[i] == 'V') { str[i] = 'v'; continue; }
     if (str[i] == 'W') { str[i] = 'w'; continue; }
     if (str[i] == 'X') { str[i] = 'x'; continue; }
     if (str[i] == 'Y') { str[i] = 'y'; continue; }
     if (str[i] == 'Z') { str[i] = 'z'; continue; }

     if (str[i] == 'a') { str[i] = 'A'; continue; }
     if (str[i] == 'b') { str[i] = 'B'; continue; }
     if (str[i] == 'c') { str[i] = 'C'; continue; }
     if (str[i] == 'd') { str[i] = 'D'; continue; }
     if (str[i] == 'e') { str[i] = 'E'; continue; }
     if (str[i] == 'f') { str[i] = 'F'; continue; }
     if (str[i] == 'g') { str[i] = 'G'; continue; }
     if (str[i] == 'h') { str[i] = 'H'; continue; }
     if (str[i] == 'i') { str[i] = 'I'; continue; }
     if (str[i] == 'j') { str[i] = 'J'; continue; }
     if (str[i] == 'k') { str[i] = 'K'; continue; }
     if (str[i] == 'l') { str[i] = 'L'; continue; }
     if (str[i] == 'm') { str[i] = 'M'; continue; }
     if (str[i] == 'n') { str[i] = 'N'; continue; }
     if (str[i] == 'o') { str[i] = 'O'; continue; }
     if (str[i] == 'p') { str[i] = 'P'; continue; }
     if (str[i] == 'q') { str[i] = 'Q'; continue; }
     if (str[i] == 'r') { str[i] = 'R'; continue; }
     if (str[i] == 's') { str[i] = 'S'; continue; }
     if (str[i] == 't') { str[i] = 'T'; continue; }
     if (str[i] == 'u') { str[i] = 'U'; continue; }
     if (str[i] == 'v') { str[i] = 'V'; continue; }
     if (str[i] == 'w') { str[i] = 'W'; continue; }
     if (str[i] == 'x') { str[i] = 'X'; continue; }
     if (str[i] == 'y') { str[i] = 'Y'; continue; }
     if (str[i] == 'z') { str[i] = 'Z'; continue; }
     }

}


void stoupper(char *str)
{
int i;
int len=strlen(str);

     for (i=0; i<len; i++)
     {
     if (str[i] == 'a') { str[i] = 'A'; continue; }
     if (str[i] == 'b') { str[i] = 'B'; continue; }
     if (str[i] == 'c') { str[i] = 'C'; continue; }
     if (str[i] == 'd') { str[i] = 'D'; continue; }
     if (str[i] == 'e') { str[i] = 'E'; continue; }
     if (str[i] == 'f') { str[i] = 'F'; continue; }
     if (str[i] == 'g') { str[i] = 'G'; continue; }
     if (str[i] == 'h') { str[i] = 'H'; continue; }
     if (str[i] == 'i') { str[i] = 'I'; continue; }
     if (str[i] == 'j') { str[i] = 'J'; continue; }
     if (str[i] == 'k') { str[i] = 'K'; continue; }
     if (str[i] == 'l') { str[i] = 'L'; continue; }
     if (str[i] == 'm') { str[i] = 'M'; continue; }
     if (str[i] == 'n') { str[i] = 'N'; continue; }
     if (str[i] == 'o') { str[i] = 'O'; continue; }
     if (str[i] == 'p') { str[i] = 'P'; continue; }
     if (str[i] == 'q') { str[i] = 'Q'; continue; }
     if (str[i] == 'r') { str[i] = 'R'; continue; }
     if (str[i] == 's') { str[i] = 'S'; continue; }
     if (str[i] == 't') { str[i] = 'T'; continue; }
     if (str[i] == 'u') { str[i] = 'U'; continue; }
     if (str[i] == 'v') { str[i] = 'V'; continue; }
     if (str[i] == 'w') { str[i] = 'W'; continue; }
     if (str[i] == 'x') { str[i] = 'X'; continue; }
     if (str[i] == 'y') { str[i] = 'Y'; continue; }
     if (str[i] == 'z') { str[i] = 'Z'; continue; }
     }

}

void stolower(char *str)
{
int i;
int len=strlen(str);

     for (i=0; i<len; i++)
     {
     if (str[i] == 'A') { str[i] = 'a'; continue; }
     if (str[i] == 'B') { str[i] = 'b'; continue; }
     if (str[i] == 'C') { str[i] = 'c'; continue; }
     if (str[i] == 'D') { str[i] = 'd'; continue; }
     if (str[i] == 'E') { str[i] = 'e'; continue; }
     if (str[i] == 'F') { str[i] = 'f'; continue; }
     if (str[i] == 'G') { str[i] = 'g'; continue; }
     if (str[i] == 'H') { str[i] = 'h'; continue; }
     if (str[i] == 'I') { str[i] = 'i'; continue; }
     if (str[i] == 'J') { str[i] = 'j'; continue; }
     if (str[i] == 'K') { str[i] = 'k'; continue; }
     if (str[i] == 'L') { str[i] = 'l'; continue; }
     if (str[i] == 'M') { str[i] = 'm'; continue; }
     if (str[i] == 'N') { str[i] = 'n'; continue; }
     if (str[i] == 'O') { str[i] = 'o'; continue; }
     if (str[i] == 'P') { str[i] = 'p'; continue; }
     if (str[i] == 'Q') { str[i] = 'q'; continue; }
     if (str[i] == 'R') { str[i] = 'r'; continue; }
     if (str[i] == 'S') { str[i] = 's'; continue; }
     if (str[i] == 'T') { str[i] = 't'; continue; }
     if (str[i] == 'U') { str[i] = 'u'; continue; }
     if (str[i] == 'V') { str[i] = 'v'; continue; }
     if (str[i] == 'W') { str[i] = 'w'; continue; }
     if (str[i] == 'X') { str[i] = 'x'; continue; }
     if (str[i] == 'Y') { str[i] = 'y'; continue; }
     if (str[i] == 'Z') { str[i] = 'z'; continue; }
     }

}


void str_move_left(char * s, int n)
{
int i;

        for (i=0; i<n-1; i++)
        s[i] = s[i+1];

}

void touppersn(char *str, int n)
{
int i;

        for (i=0; i<n; i++)
        str[i] = (char) toupper(str[i]);
}

void touppers(char *str)
{
int n;
int i;

    n = strlen (str);

    for (i=0; i<n; i++)
    str[i] = (char) toupper(str[i]);
}


void tolowersn(char *str, int n)
{
int i;

        for (i=0; i<n; i++)
        str[i] = (char) tolower(str[i]);
}

void tolowers(char *str)
{
int n;
int i;

    n = strlen (str);

    for (i=0; i<n; i++)
    str[i] = (char) tolower(str[i]);
}





char * chstr_line(char *line, char *str, char *newstr)
{
int i;
int j;
int x;
int n;
int oldsize;
char * aux;

	n = strlen(line);

    oldsize = sizeof(char) * n+1;

	aux = (char*) malloc(oldsize);

    x = 0;

	for (i=0; i<n; i++)
    {
		for (j=0; str[j] == line[i] && str[j] != '\0'; j++)
        i++;

		if (str[j] != '\0')
        {
			/* "str" didn't match */
            i -= j;
			aux[x++] = line[i];
		}

        else
        {
			i--;

			if (strlen(newstr) > strlen(str))
            {
				/* need more memory */
                oldsize += (strlen(newstr) - strlen(str)) * sizeof(char) +1;
				aux = (char*) realloc(aux, oldsize);
			}

			for (j=0; newstr[j] != '\0'; j++)
            aux[x++] = newstr[j];

		}
	}

aux[x] = '\0';
return aux;
}



void chstr(char *namein, char *nameout, char *str, char *newstr)
{
long pos;
int i;
int c;
char *aux;
char *line;

    najin(namein);
    najout(nameout);

    pos = ftell(naji_input);
    c = fgetc(naji_input);
    if (c == '\n')
    fprintf(naji_output, "\n");

	/* line by line */
	while (c != EOF)
    {
		for (i=0; c != EOF && c != '\n' && c != '\0'; i++)
        c = fgetc(naji_input);

		if (i > 0)
        {
            line = (char*) malloc(sizeof(char)*i+1);

			/* go back and save the chars now */
            fseek(naji_input, pos, SEEK_SET);
            fgets(line, i+1, naji_input);

            aux = chstr_line(line, str, newstr);
            fprintf(naji_output, "%s", aux);
			free(aux);
			free(line);
		}
		
        c = fgetc(naji_input);

		if (c =='\n')
        fprintf(naji_output, "\n");

        ungetc(c, naji_input);

        pos = ftell(naji_input);
        c = fgetc(naji_input);

	}

najinclose();
najoutclose();
}




/* returns a line without "str" naji_input it */
char * skipstr_line(char *line, char *str)
{
int i;
int j;
int x;
int n;

char * aux;

	n = strlen(line);

	aux = (char*) malloc(sizeof(char)*n+1);

    x = 0;

	for (i=0; i<n; i++)
    {
		for (j=0; str[j] == line[i] && str[j] != '\0'; j++)
        i++;

		if (str[j] != '\0')
        {
        /* "str" didn't match */
        i-=j;

        aux[x++] = line[i];
		}

        else i--;

	}

aux[x] = '\0';
return aux;
}







void skipstr(char *namein, char *nameout, char *str)
{
long pos;

int i;
int c;

char *aux;
char *line;


    najin(namein);
    najout(nameout);

    pos = ftell(naji_input);
    c = fgetc(naji_input);

    if (c == '\n')
    fprintf(naji_output, "\n");

	/* line by line (it's this or a limited buffer) */
	while (c != EOF)
    {
		for (i=0; c != EOF && c != '\n' && c != '\0'; i++)
        c = fgetc(naji_input);

		if (i > 0)
        {
            line = (char*) malloc(sizeof(char)*i+1);

			/* go back and save the chars now */
            fseek(naji_input, pos, SEEK_SET);
            fgets(line, i+1, naji_input);

            aux = skipstr_line(line, str);
            fprintf(naji_output, "%s", aux);
			free(aux);
			free(line);
		}
		
        c = fgetc(naji_input);

        if (c == '\n')
        fprintf(naji_output, "\n");

        ungetc(c, naji_input);

        pos = ftell(naji_input);
        c = fgetc(naji_input);

	}

najinclose();
najoutclose();
}




/* This function adds a character 'c' to a buffer line_buf in the end. 
Before adding a character it checks for the length of the buffer and
if required allocates more memory for the buffer. 

This functions returns the new buffer pointer to the calling fuction.
*/

char *addtolinebuf(char c, char *line_buf,
int cur_pos, int *cur_size, int block_size)
{
char *swap_buf = NULL;

	if (cur_pos == *cur_size -1)
	{
		/* Buffer exceeded its limits. Reallocate */

        /* Save the current content of the buffer in the swap buffer first */
		swap_buf = (char *) calloc (*cur_size, sizeof (char));
		if (swap_buf == NULL)
		{
			fprintf(stderr, "\n\nError, cannot allocate memory");
			perror(" "); fprintf(stderr, "\n\n");
            return NULL;
		}
        memcpy(swap_buf, line_buf, *cur_size * sizeof (char));

		/* Free the existing allocated memory for the line buffer */
        free(line_buf);

		/* Allocate fresh memory and increase it by BLOCK_SIZE this time */
		line_buf = (char *) calloc ((*cur_size + block_size), sizeof (char));
		if (line_buf == NULL)
		{
			fprintf(stderr, "\n\nError, cannot allocate memory");
			perror(" "); fprintf(stderr, "\n\n");
            return NULL;
		}

		/* Copy old buffer from swap buffer to the line buffer */
        memcpy(line_buf, swap_buf, *cur_size * sizeof(char));

		/* Free the swap buffer */
        free(swap_buf);

		/* Set the current size. */
        *cur_size += block_size;
	}

	/* Add the new character at the end of the buffer */
    line_buf[cur_pos] = c;

    /* printf("\n added [%c] at [%d]", line_buf[cur_pos], cur_pos); */

return line_buf;
}



int isequal(char *str, char *tempbuf, int len, int start_pos)
{
int i;

    for (i=start_pos; i < (start_pos + len); i++)
	{
        if (str[i % len] != tempbuf[i % len])
        break;
	}

    if (i == (start_pos + len))
    return 1;
    
return 0;
}
















void najin(char *namein)
{
//long filesize = 0;
char error[4096];


    naji_input = fopen(namein, "rb");

    if (naji_input == NULL)
    {
    
    
    if (!strcmp(najitool_language, "English"))
    {
    sprintf(error, "Error, cannot open input file:\n%s\n%s", namein, strerror(errno));
    MessageBox {text = "Error", contents = error}.Modal();
    }
    
    else if (!strcmp(najitool_language, "Turkish"))
    {
    sprintf(error, "Hata, okunan dosya acilmadi:\n%s\n%s", namein, strerror(errno));
    MessageBox {text = "Hata", contents = error}.Modal();
    }

    exit(2);


    }





 /*   filesize = najinsize();


    if (filesize == 0)
    {
    fprintf(stderr, "\n\nError, empty file.\n\n");
    exit(1);
    }

*/
}

 void najin2(char *namein2)
{
long filesize = 0;
char error[4096];


    naji_input2 = fopen(namein2, "rb");

    if (naji_input2 == NULL)
    {
    
    if (!strcmp(najitool_language, "English"))
    {
    sprintf(error, "Error, cannot open input file 2:\n%s\n%s", namein2, strerror(errno));
    MessageBox {text = "Error", contents = error}.Modal();
    }
    
    else if (!strcmp(najitool_language, "Turkish"))
    {
    sprintf(error, "Hata, okunan dosya 2 acilmadi:\n%s\n%s", namein2, strerror(errno));
    MessageBox {text = "Hata", contents = error}.Modal();
    }

    exit(2);
    }


 /*   filesize = najinsize();


    if (filesize == 0)
    {
    fprintf(stderr, "\n\nError, empty file.\n\n");
    exit(1);
    }

*/
}                                      


void najout(char *nameout)
{
char error[4096];

naji_output = fopen(nameout, "rb");


    if (naji_output != NULL)
    {

    if (!strcmp(najitool_language, "English"))
    {
    sprintf(error, "Error, output file already exists:\n%s", nameout);
    MessageBox {text = "Error", contents = error}.Modal();
    }
    
    else if (!strcmp(najitool_language, "Turkish"))
    {
    sprintf(error, "Hata, bu dosya adi kulanilmis, baska dosya adi secin:\n%s", nameout);
    MessageBox {text = "Hata", contents = error}.Modal();
    }



    exit(3);
    }

    naji_output = fopen(nameout, "wb");
    if (naji_output == NULL)
    {

    if (!strcmp(najitool_language, "English"))
    {
    sprintf(error, "Error, cannot open output file:\n%s\n%s", nameout, strerror(errno));
    MessageBox {text = "Error", contents = error}.Modal();
    }
    
    else if (!strcmp(najitool_language, "Turkish"))
    {
    sprintf(error, "Hata, yazilan dosya acilmadi:\n%s\n%s", nameout, strerror(errno));
    MessageBox {text = "Hata", contents = error}.Modal();
    }

 
    exit(4);
    }

}



   void najout2(char *nameout2)
{
char error[4096];

naji_output2 = fopen(nameout2, "rb");


    if (naji_output2 != NULL)
    {
 
    if (!strcmp(najitool_language, "English"))
    {
    sprintf(error, "Error, output file already exists:\n%s", nameout2);
    MessageBox {text = "Error", contents = error}.Modal();
    }
    
    if (!strcmp(najitool_language, "Turkish"))
    {
    sprintf(error, "Hata, bu dosya adi kulanilmis, baska dosya adi secin:\n%s", nameout2);
    MessageBox {text = "Hata", contents = error}.Modal();
    }
    
    
    exit(3);
    }

    naji_output = fopen(nameout2, "wb");
    if (naji_output2 == NULL)
    {
 
    if (!strcmp(najitool_language, "English"))
    {
    sprintf(error, "Error, cannot open output file 2:\n%s\n%s", nameout2, strerror(errno));
    MessageBox {text = "Error", contents = error}.Modal();
    }
    
    else if (!strcmp(najitool_language, "Turkish"))
    {
    sprintf(error, "Hata, yazilan dosya 2 acilmadi:\n%s\n%s", nameout2, strerror(errno));
    MessageBox {text = "Hata", contents = error}.Modal();
    }


    exit(4);
    }

}


   void najed(char *named)
{
char error[4096];


naji_edit = fopen(named, "r+b");

        if (naji_edit == NULL)
        {


  if (!strcmp(najitool_language, "English"))
    {
        sprintf(error, "Error, cannot open file to edit: %s\n%s", named, strerror(errno));
        MessageBox {text = "Error", contents = error}.Modal();
    }
    
    else if (!strcmp(najitool_language, "Turkish"))
    {
    sprintf(error, "Hata, deyismek icin dosya acilmadi:\n%s\n%s", named, strerror(errno));
    MessageBox {text = "Hata", contents = error}.Modal();
    }
  

       exit(6);
        }

}

   void najinclose(void)   { fclose(naji_input);   }

   void najin2close(void)  { fclose(naji_input2);  }

   void najoutclose(void)  { fclose(naji_output);  }

   void najout2close(void) { fclose(naji_output2); }

   void najedclose(void)   { fclose(naji_edit);    }



long naji_filesize(FILE *file)
{
long savepos=0;
long size=0;

savepos = ftell(file);

fseek(file, 0 , SEEK_END);
size = ftell(file);

fseek(file, savepos, SEEK_SET);

return size;
}



long najinsize(void)    { return naji_filesize(naji_input);   }
long najin2size(void)   { return naji_filesize(naji_input2);  }
long najoutsize(void)   { return naji_filesize(naji_output);  }
long najout2size(void)  { return naji_filesize(naji_output2); }
long najedsize(void)    { return naji_filesize(naji_edit);    }




   void _8bit256(char *nameout, unsigned long rep)
{
int i;
int ii;

najout(nameout);

    for (ii=0; ii<=rep; ii++)
    for (i=0; i<=255; i++)
    fputc(i, naji_output);

najoutclose();
}

   void naji_addim(unsigned long start, unsigned long end, unsigned long addby)
{
int i;

for (i=start; i<=end; i+=addby)
fprintf(naji_output, "% 4i", i);

fprintf(naji_output, "\r\n");
}

   void addim(int max_times, char *outname)
{
int i;


najout(outname);

for (i=1; i<=max_times; i++)
naji_addim(i, (max_times * i), i);

najoutclose();

}



















   void copyfile(char *namein, char *nameout)
{
int a=0;

najin(namein);
najout(nameout);


    while(1)
    {
    a = fgetc(naji_input);
    if (a == EOF) break;
    fputc(a, naji_output);
    }



najinclose();
najoutclose();
}




int naji_e2a_unicode(int a)
{
        if (a == 'A') return UCODE_AR_ALIF;
        if (a == 'a') return UCODE_AR_FATHA;
        if (a == 'b') return UCODE_AR_BEH;
        if (a == 'c') return UCODE_AR_AIN;
        if (a == 'd') return UCODE_AR_DAL;
        if (a == 'e') return UCODE_AR_FATHA;
        if (a == 'f') return UCODE_AR_FEH;
        if (a == 'g') return UCODE_AR_GHAIN;
        if (a == 'h') return UCODE_AR_HEH;
        if (a == 'i') return UCODE_AR_KASRA;
        if (a == 'j') return UCODE_AR_JEEM;
        if (a == 'k') return UCODE_AR_KAF;
        if (a == 'l') return UCODE_AR_LAM;
        if (a == 'm') return UCODE_AR_MEEM;
        if (a == 'n') return UCODE_AR_NOON;
        if (a == 'o') return UCODE_AR_DAMMA;
        if (a == 'p') return UCODE_AR_BEH;
        if (a == 'q') return UCODE_AR_QAF;
        if (a == 'r') return UCODE_AR_REH;
        if (a == 's') return UCODE_AR_SEEN;
        if (a == 't') return UCODE_AR_TEH;
        if (a == 'u') return UCODE_AR_DAMMA;
        if (a == 'v') return UCODE_AR_THEH;
        if (a == 'w') return UCODE_AR_WAW;
        if (a == 'x') return UCODE_AR_HAH;
        if (a == 'y') return UCODE_AR_YEH;
        if (a == 'z') return UCODE_AR_THAL;
        if (a == 'K') return UCODE_AR_KHAH;
        if (a == 'D') return UCODE_AR_DAD;
        if (a == 'S') return UCODE_AR_SAD;
        if (a == '$') return UCODE_AR_SHEEN;
        if (a == 'T') return UCODE_AR_TAH;
        if (a == 'U') return UCODE_AR_WAW;
        if (a == 'V') return UCODE_AR_ZAIN;
        if (a == '\'') return UCODE_AR_HAMZA;
        if (a == 'W') return UCODE_AR_WAW_WITH_HAMZA_ABOVE;
        if (a == 'I') return UCODE_AR_ALIF_WITH_HAMZA_BELOW;
        if (a == 'Y') return UCODE_AR_ALIF_MAKSURA;
        if (a == 'Z') return UCODE_AR_ZAH;
        if (a == 'H') return UCODE_AR_TEH_MARBUTA;
        if (a == 'E') return UCODE_AR_ALIF_WITH_HAMZA_ABOVE;
        if (a == '@') return UCODE_AR_ALIF_WITH_MADDA_ABOVE;
        if (a == '~') return UCODE_AR_SHADDA;
        if (a == 'N') return UCODE_AR_FATHATAN;
        if (a == '=') return UCODE_AR_KASRATAN;
        if (a == '%') return UCODE_AR_DAMMATAN;
        if (a == '^') return UCODE_AR_SUKUN;
        if (a == '?') return UCODE_AR_QUESTION_MARK;
        if (a == ',') return UCODE_AR_COMMA;
        if (a == ';') return UCODE_AR_SEMICOLON;

return a; /* returns what it got if it couldn't convert it */
}

int naji_e2a(int a)
{
        if (a == 'A') return 199;
        if (a == 'a') return 243;
        if (a == 'b') return 200;
        if (a == 'c') return 218;
        if (a == 'd') return 207;
        if (a == 'e') return 243;
        if (a == 'f') return 221;
        if (a == 'g') return 219;
        if (a == 'h') return 229;
        if (a == 'i') return 246;
        if (a == 'j') return 204;
        if (a == 'k') return 223;
        if (a == 'l') return 225;
        if (a == 'm') return 227;
        if (a == 'n') return 228;
        if (a == 'o') return 245;
        if (a == 'p') return 200;
        if (a == 'q') return 222;
        if (a == 'r') return 209;
        if (a == 's') return 211;
        if (a == 't') return 202;
        if (a == 'u') return 245;
        if (a == 'v') return 203;
        if (a == 'w') return 230;
        if (a == 'x') return 205;
        if (a == 'y') return 237;
        if (a == 'z') return 210;
        if (a == 'K') return 206;
        if (a == 'D') return 214;
        if (a == 'S') return 213;
        if (a == '$') return 212;
        if (a == 'T') return 216;
        if (a == 'U') return 230;
        if (a == 'V') return 208;
        if (a == '\'') return 193;
        if (a == 'W') return 196;
        if (a == 'I') return 197;
        if (a == 'Y') return 236;
        if (a == 'Z') return 217;
        if (a == 'H') return 201;
        if (a == 'E') return 195;
        if (a == '@') return 194;
        if (a == '~') return 248;
        if (a == 'N') return 240;
        if (a == '=') return 242;
        if (a == '%') return 241;
        if (a == '^') return 250;
        if (a == '?') return 191;
        if (a == ',') return 161;
        if (a == ';') return 186;
return a; /* returns what it got if it couldn't convert it */
}

int naji_a2e(int a)
{
        if (a == 243) return 'a';
        if (a == 246) return 'i';
        if (a == 245) return 'u';
        if (a == 248) return '~';
        if (a == 240) return 'N';
        if (a == 242) return '=';
        if (a == 241) return '%';
        if (a == 250) return '^';
        if (a == 199) return 'A';
        if (a == 200) return 'b';
        if (a == 202) return 't';
        if (a == 203) return 'v';
        if (a == 204) return 'j';
        if (a == 205) return 'x';
        if (a == 206) return 'K';
        if (a == 207) return 'd';
        if (a == 208) return 'V';
        if (a == 209) return 'r';
        if (a == 210) return 'z';
        if (a == 211) return 's';
        if (a == 212) return '$';
        if (a == 213) return 'S';
        if (a == 214) return 'D';
        if (a == 216) return 'T';
        if (a == 218) return 'c';
        if (a == 219) return 'g';
        if (a == 221) return 'f';
        if (a == 222) return 'q';
        if (a == 223) return 'k';
        if (a == 225) return 'l';
        if (a == 227) return 'm';
        if (a == 228) return 'n';
        if (a == 229) return 'h';
        if (a == 230) return 'w';
        if (a == 237) return 'y';
        if (a == 193) return '\'';
        if (a == 196) return 'W';
        if (a == 197) return 'I';
        if (a == 236) return 'Y';
        if (a == 217) return 'Z';
        if (a == 201) return 'H';
        if (a == 195) return 'E';
        if (a == 194) return '@';
        if (a == 191) return '?';
        if (a == 161) return ',';
        if (a == 186) return ';';

return a; /* returns what it got if it couldn't convert it */
}

void eng2arab(char *namein, char *nameout)
{
int letter;

najin(namein);
najout(nameout);

        while(1)
        {
        letter = fgetc(naji_input);
        
        if (letter == EOF)
        break;

        letter = naji_e2a(letter);
        fputc(letter, naji_output);
        }

najinclose();
najoutclose();
}

void arab2eng(char *namein, char *nameout)
{
int letter;

najin(namein);
najout(nameout);

        while(1)
        {
        letter = fgetc(naji_input);
        
        if (letter == EOF)
        break;

        letter = naji_a2e(letter);
        fputc(letter, naji_output);
        }

najinclose();
najoutclose();
}




void e2ahtml(char *namein, char *nameout)
{
int letter;

najin(namein);
najout(nameout);

        while(1)
        {
        letter = fgetc(naji_input);
        
        if (letter == EOF)
        break;

        letter = naji_e2a_unicode(letter);
        
        if (letter == '\n')
        fprintf(naji_output, "\n<br>");
        else
        fprintf(naji_output, "&#%i;", letter);
        }

najinclose();
najoutclose();
}




void elite_char_fprint(char a, FILE *out)
{
char b = a;

naji_tolower(b);


  if (b == 'a') { fprintf(out, "4"); return; }
  if (b == 'b') { fprintf(out, "8"); return; }
  if (b == 'e') { fprintf(out, "3"); return; }
  if (b == 'i') { fprintf(out, "1"); return; }
  if (b == 'o') { fprintf(out, "0"); return; }
  if (b == 's') { fprintf(out, "5"); return; }
  if (b == 't') { fprintf(out, "7"); return; }
  if (b == 'd') { fprintf(out, "|>");     return; }
  if (b == 'c') { fprintf(out, "<");      return; }
  if (b == 'k') { fprintf(out, "|<");     return; }
  if (b == 'm') { fprintf(out, "/\\/\\"); return; }
  if (b == 'v') { fprintf(out, "\\/");    return; }
  if (b == 'w') { fprintf(out, "\\/\\/"); return; }
  if (b == 'h') { fprintf(out, "|-|");    return; }
  if (b == 'n') { fprintf(out, "|\\|");   return; }
  if (b == 'x') { fprintf(out, "><");     return; }
  if (b == 'u') { fprintf(out, "|_|");    return; }
  if (b == 'l') { fprintf(out, "|_");     return; }
  if (b == 'j') { fprintf(out, "_|");     return; }

fprintf(out, "%c", a);
}



void leetfile(char *namein, char *nameout)
{
int a;

najin(namein);
najout(nameout);

     while(1)
     {
     a = fgetc(naji_input);

     if (a == EOF)
     break;

     elite_char_fprint((char)a, naji_output);
     }

najinclose();
najoutclose();
}






unsigned char ascii_to_ebcdic_char(const unsigned char a)
{
return ascii_to_ebcdic_array[a];
}

unsigned char ebcdic_to_ascii_char(const unsigned char a)
{
return ebcdic_to_ascii_array[a];
}


void asc2ebc(char *namein, char *nameout)
{
int a=0;

najin(namein);
najout(nameout);

    while(1)
    {
    a = fgetc(naji_input);
    if (a == EOF) break;
    fputc(ascii_to_ebcdic_char((byte)a), naji_output);
    }

najinclose();
najoutclose();
}


void ebc2asc(char *namein, char *nameout)
{
int a=0;

najin(namein);
najout(nameout);

    while(1)
    {
    a = fgetc(naji_input);
    if (a == EOF) break;
    fputc(ebcdic_to_ascii_char((byte)a), naji_output);
    }

najinclose();
najoutclose();
}


void dos2unix(char *namein, char *nameout)
{
int a=0;

najin(namein);
najout(nameout);

    while(1)
    {
    a = fgetc(naji_input);
    if (a == EOF) break;
    
    if (a != '\r')
    fputc(a, naji_output);
    }

najinclose();
najoutclose();
}

void unix2dos(char *namein, char *nameout)
{
int a;

najin(namein);
najout(nameout);

    while(1)
    {
    a = fgetc(naji_input);
    if (a == EOF) break;

    if (a != '\n')
    fputc(a, naji_output);
    
    if (a == '\n')
    {
    fputc('\r', naji_output);
    fputc('\n', naji_output);
    }
    
    }

najinclose();
najoutclose();
}

void rndbfile(char *nameout, unsigned long int size)
{
unsigned long int i=0;

najout(nameout);

rand_init();
for (i=0; i<size; i++)
fputc((rand() % 255), naji_output);

najoutclose();
}

void rndtfile(char *nameout, unsigned long int size)
{
unsigned long int i=0;

najout(nameout);

rand_init();
for (i=0; i<size; i++)
fputc(((rand() % 95)+' '), naji_output);

najoutclose();
}

void charfile(char *nameout, unsigned long int size, int c)
{
unsigned long int i=0;

najout(nameout);

for (i=0; i<size; i++)
fputc(c, naji_output);

najoutclose();
}


void strfile(char *nameout, unsigned long int howmany, char *string)
{
unsigned long int i=0;

najout(nameout);

 for (i=0; i<howmany; i++)
 fprintf(naji_output, "%s", string);

najoutclose();
}








void fprint_16_bit_bin(FILE *out, int num)
{
int print;
int i;

        for (i=0; i<16; i++)
        {

        print = num & 0x8000 ? '1' : '0';

        fputc(print, out);

        num <<= 1;

        }

}


void fprint_8_bit_bin(FILE *out, char num)
{
char print;
int i;

        for (i=0; i<8; i++)
        {

        print = num & 0x8000 ? '1' : '0';

        fputc(print, out);

        num <<= 1;

        }

}






void asctable(char *nameout)
{
int i;

najout(nameout);


    for (i=' '; i<='~'; i++)
    {
    fprintf(naji_output, "%i\t0x%02X\t%c\t", i, i, i);
    fprint_8_bit_bin(naji_output, (char) i);
    fprintf(naji_output, "\r\n");
    }

najoutclose();
}

void f2lower(char *namein, char *nameout)
{
int a;
int i;

najin(namein);
najout(nameout);


    while(1)
    {

    a = fgetc(naji_input);

    if (a == EOF)
    break;


       for (i=0; i<26; i++)
       {

          if (a == ('A' + i) )
          {
          a += 32;
          break;
          }

       }


     fputc(a, naji_output);

    }





najinclose();
najoutclose();
}


void f2upper(char *namein, char *nameout)
{
int a;
int i;

najin(namein);
najout(nameout);


    while(1)
    {

    a = fgetc(naji_input);

    if (a == EOF)
    break;


       for (i=0; i<26; i++)
       {

          if (a == ('a' + i) )
          {
          a -= 32;
          break;
          }

       }


     fputc(a, naji_output);

    }





najinclose();
najoutclose();
}


#define UUENC(c)  ( ((c) & 077) + ' ' )
#define UUDEC(c)  (char) ( ((c) - ' ') & 077)


void uuencode(char *namein, char *nameout)
{
char buffer[100];
int i;
int a;
int b;
int x1;
int x2;
int x3;
int x4;
int reached_eof = NAJI_FALSE;


      najin(namein);
      najout(nameout);

      while (1) 
      {


      for (i=0; i<45; i++)
      {
      b = fgetc(naji_input);

      if (b == EOF)
      {
      a = i;
      reached_eof = NAJI_TRUE;
      break;
      }

      buffer[i] = (char) b;
      }

      if (reached_eof == NAJI_FALSE)
      a = 45;


      fputc(UUENC(a), naji_output);

      for (i=0; i<a; i+=3)
      {
      x1 = buffer[i] >> 2;

      x2 = ( (buffer[0+i] << 4) & 060) | ( (buffer[1+i] >> 4) & 017);
      x3 = ( (buffer[1+i] << 2) & 074) | ( (buffer[2+i] >> 6) & 03);

      x4 = buffer[2+i] & 077;

      fputc(UUENC(x1), naji_output);
      fputc(UUENC(x2), naji_output);
      fputc(UUENC(x3), naji_output);
      fputc(UUENC(x4), naji_output);
      }

      putc('\n', naji_output);

      if (a <= 0)
      break;
      }

najinclose();
najoutclose();
}



void uudecode(char *namein, char *nameout)
{
int i;
char a;
char b;
char c;
char d;

      najin(namein);
      najout(nameout);

      while ((i = fgetc(naji_input)) != EOF && ((i = UUDEC(i)) != 0))
      {

        while (i > 0)
        {
        a = UUDEC(fgetc(naji_input));
        b = UUDEC(fgetc(naji_input));
        c = UUDEC(fgetc(naji_input));
        d = UUDEC(fgetc(naji_input));

        if (i-- > 0) fputc((a<<2) | (b>>4), naji_output);
        if (i-- > 0) fputc((b<<4) | (c>>2), naji_output);
        if (i-- > 0) fputc((c<<6) | d, naji_output);
        }

        i = fgetc(naji_input);

      }

najinclose();
najoutclose();
}


void bin2hexi(char *namein, char *nameout)
{
int a;
int b;
int counter = 0; 
unsigned long offset = 0;


najin(namein);
najout(nameout);


	while (1)
	{

		a = fgetc(naji_input);

		if (a == EOF)
		{
		fputc('\r', naji_output);
		fputc('\n', naji_output);
		break;
		}

	
		if (counter == 0 || counter == 16)
		{

			if (offset == 0xFFFFFFF0)
			{
			fprintf(naji_output, "OFFLIMIT:  ");
			}

			else
			{
			fprintf(naji_output, "%08X:  ", offset);
			}

		}


		b = fgetc(naji_input);

		if (b == EOF)
		{
			fprintf(naji_output, "%02X", a);
			break;
		}

		else
		{
			fseek(naji_input, -1, SEEK_CUR);
		}


		if (counter != 15)
			fprintf(naji_output, "%02X ", a);
		else
			fprintf(naji_output, "%02X", a);
		

		if (counter == 3  ||
        	    counter == 7  ||
	            counter == 11
		)

		fputc(' ', naji_output);


		counter++;


		if (counter == 16)
		{



			if (offset != 0xFFFFFFF0)
			offset += 16;

	      fputc('\r', naji_output);
         fputc('\n', naji_output);


			counter = 0;


		}





	}



najinclose();
najoutclose();
}

void tabspace(int spaces, char *namein, char *nameout)
{
int a;
int i;

najin(namein);
najout(nameout);

    while(1)
    {
    a = fgetc(naji_input);
    if (a == EOF) break;

    if (a != '\t')
    fputc(a, naji_output);
    
    if (a == '\t')
    {
    for (i=0; i<spaces; i++)
    fputc(' ', naji_output);
    }
    
    }

najinclose();
najoutclose();
}


/* ---------- */
/* najascii.c */
/* ---------- */

    /* naji ASCII functions, such as very big text    */
   /* my ASCII Art Letter's written from scratch     */
  /* a reminder: this is all absolutely free and    */
 /* public domain, so have some fun.               */

/* if you want to contribute your own letters */
/* e-mail me: naji@users.sourceforge.net      */

/* this  .c  file is a part */
/* of libnaji version 0.6.2 */

/* libnaji is based on   */
/* the original najitool */

/* both najitool and libnaji */
/* are public domain and are */
/* made by the same author   */
/* please read license.txt   */

/* made by NECDET COKYAZICI  */



/* todo:
make functions like

  int naji_ascii_number
 long naji_ascii_number
double naji_ascii_number

and naji_ascii_string
also make one that does turkish and arabic in ascii art
just use the naji_1 naji_2 naji_3

use >> to shift the bits
for naji_ascii_number, also do naji_ascii_hexi
*/

void naji_(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "           ");
if (a == 1) fprintf(stream, "           ");
if (a == 2) fprintf(stream, "           ");
if (a == 3) fprintf(stream, "           ");
if (a == 4) fprintf(stream, "           ");
if (a == 5) fprintf(stream, "           ");
}

void naji_a(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "    ____    ");
if (a == 1) fprintf(stream, "   / __ \\   ");
if (a == 2) fprintf(stream, "  | |  | |  ");
if (a == 3) fprintf(stream, "  | |__| |  ");
if (a == 4) fprintf(stream, "  |  __  |  ");
if (a == 5) fprintf(stream, "  |_|  |_|  ");
}

void naji_b(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   _____   ");
if (a == 1) fprintf(stream, "  |  _  |  ");
if (a == 2) fprintf(stream, "  | |_| /  ");
if (a == 3) fprintf(stream, "  |  _  \\  ");
if (a == 4) fprintf(stream, "  | |_| |  ");
if (a == 5) fprintf(stream, "  |_____|  ");
}

void naji_c(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   _____   ");
if (a == 1) fprintf(stream, "  |  ___|  ");
if (a == 2) fprintf(stream, "  | |      ");
if (a == 3) fprintf(stream, "  | |      ");
if (a == 4) fprintf(stream, "  | |___   ");
if (a == 5) fprintf(stream, "  |_____|  ");
}

void naji_d(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   ____     ");
if (a == 1) fprintf(stream, "  |     \\   ");
if (a == 2) fprintf(stream, "  | |~\\  |  ");
if (a == 3) fprintf(stream, "  | |  | |  ");
if (a == 4) fprintf(stream, "  | |_/  |  ");
if (a == 5) fprintf(stream, "  |_____/   ");
return;
}

void naji_e(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   _____   ");
if (a == 1) fprintf(stream, "  |  ___|  ");
if (a == 2) fprintf(stream, "  | |___   ");
if (a == 3) fprintf(stream, "  |  ___|  ");
if (a == 4) fprintf(stream, "  | |___   ");
if (a == 5) fprintf(stream, "  |_____|  ");
}

void naji_f(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   _____   ");
if (a == 1) fprintf(stream, "  |   __|  ");
if (a == 2) fprintf(stream, "  |  |__   ");
if (a == 3) fprintf(stream, "  |   __|  ");
if (a == 4) fprintf(stream, "  |  |     ");
if (a == 5) fprintf(stream, "  |__|     ");
}

void naji_g(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   ______   ");
if (a == 1) fprintf(stream, "  /  __  \\  ");
if (a == 2) fprintf(stream, "  | |  |_|  ");
if (a == 3) fprintf(stream, "  | |  __   ");
if (a == 4) fprintf(stream, "  | |__\\ |  ");
if (a == 5) fprintf(stream, "  |_____/   ");
}

void naji_h(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   _    _   ");
if (a == 1) fprintf(stream, "  | |  | |  ");
if (a == 2) fprintf(stream, "  | |__| |  ");
if (a == 3) fprintf(stream, "  |  __  |  ");
if (a == 4) fprintf(stream, "  | |  | |  ");
if (a == 5) fprintf(stream, "  |_|  |_|  ");
}

void naji_i(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "     __     ");
if (a == 1) fprintf(stream, "    |  |    ");
if (a == 2) fprintf(stream, "    |  |    ");
if (a == 3) fprintf(stream, "    |  |    ");
if (a == 4) fprintf(stream, "    |  |    ");
if (a == 5) fprintf(stream, "    |__|    ");
}

void naji_j(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "       __   ");
if (a == 1) fprintf(stream, "      |  |  ");
if (a == 2) fprintf(stream, "      |  |  ");
if (a == 3) fprintf(stream, "  ___ |  |  ");
if (a == 4) fprintf(stream, "  | |_|  |  ");
if (a == 5) fprintf(stream, "  \\______|  ");
}

void naji_k(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   __  ___  ");
if (a == 1) fprintf(stream, "  |  |/  /  "); 
if (a == 2) fprintf(stream, "  |    _/   ");
if (a == 3) fprintf(stream, "  |   /__   ");
if (a == 4) fprintf(stream, "  |   _  \\  ");
if (a == 5) fprintf(stream, "  |__| \\__\\ ");
}

void naji_l(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "    __       ");
if (a == 1) fprintf(stream, "   |  |      ");
if (a == 2) fprintf(stream, "   |  |      ");
if (a == 3) fprintf(stream, "   |  |      ");
if (a == 4) fprintf(stream, "   |  |___   ");
if (a == 5) fprintf(stream, "   |______|  ");
}

void naji_m(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "  _      _  ");
if (a == 1) fprintf(stream, " | \\    / | ");
if (a == 2) fprintf(stream, " |  \\__/  | ");
if (a == 3) fprintf(stream, " |        | ");
if (a == 4) fprintf(stream, " |  /\\/\\  | ");
if (a == 5) fprintf(stream, " |_|    |_| ");
}

void naji_n(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   _    _   ");
if (a == 1) fprintf(stream, "  | \\  | |  ");
if (a == 2) fprintf(stream, "  |  \\_| |  ");
if (a == 3) fprintf(stream, "  |      |  ");
if (a == 4) fprintf(stream, "  | |\\   |  ");
if (a == 5) fprintf(stream, "  |_| \\__|  ");
}

void naji_o(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   ______   ");
if (a == 1) fprintf(stream, "  |      |  ");
if (a == 2) fprintf(stream, "  | |~~| |  ");
if (a == 3) fprintf(stream, "  | |  | |  ");
if (a == 4) fprintf(stream, "  | |__| |  ");
if (a == 5) fprintf(stream, "  |______|  ");
}

void naji_p(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   ______   ");
if (a == 1) fprintf(stream, "  |      |  ");
if (a == 2) fprintf(stream, "  | |~~| |  ");
if (a == 3) fprintf(stream, "  | ~~~~ |  ");
if (a == 4) fprintf(stream, "  | |~~~~   ");
if (a == 5) fprintf(stream, "  |_|       ");
}

void naji_q(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   ______   ");
if (a == 1) fprintf(stream, "  |      |  ");
if (a == 2) fprintf(stream, "  | |~~| |  ");
if (a == 3) fprintf(stream, "  | | _| |  ");
if (a == 4) fprintf(stream, "  | |_\\ \\|  ");
if (a == 5) fprintf(stream, "  |____\\_\\  ");
}

void naji_r(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   ______   ");
if (a == 1) fprintf(stream, "  |      |  ");
if (a == 2) fprintf(stream, "  | |~~| |  ");
if (a == 3) fprintf(stream, "  | ~~~~ |  ");
if (a == 4) fprintf(stream, "  | |~\\ \\~  ");
if (a == 5) fprintf(stream, "  |_|  \\_\\  ");
}

void naji_s(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "    _____   ");
if (a == 1) fprintf(stream, "   /  __ \\  ");
if (a == 2) fprintf(stream, "   \\  \\ \\/  ");
if (a == 3) fprintf(stream, " /\\ \\  \\    ");
if (a == 4) fprintf(stream, " \\ \\_\\  \\   ");
if (a == 5) fprintf(stream, "  \\_____/   ");
}

void naji_t(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   ______   ");
if (a == 1) fprintf(stream, "  |_    _|  ");
if (a == 2) fprintf(stream, "    |  |    ");
if (a == 3) fprintf(stream, "    |  |    ");
if (a == 4) fprintf(stream, "    |  |    ");
if (a == 5) fprintf(stream, "    |__|    ");
}

void naji_u(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   _    _   ");
if (a == 1) fprintf(stream, "  | |  | |  ");
if (a == 2) fprintf(stream, "  | |  | |  ");
if (a == 3) fprintf(stream, "  | |  | |  ");
if (a == 4) fprintf(stream, "  | |__| |  ");
if (a == 5) fprintf(stream, "  |______|  ");
}

void naji_v(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   _     _  ");
if (a == 1) fprintf(stream, "  | |   | | ");
if (a == 2) fprintf(stream, "  | |   | | ");
if (a == 3) fprintf(stream, "  \\ \\   / / ");
if (a == 4) fprintf(stream, "   \\ \\_/ /  ");
if (a == 5) fprintf(stream, "    \\___/   ");
}

void naji_w(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "  _      _  ");
if (a == 1) fprintf(stream, " | |    | | ");
if (a == 2) fprintf(stream, " | |    | | ");
if (a == 3) fprintf(stream, " | | /\\ | | ");
if (a == 4) fprintf(stream, " | \\/  \\/ | ");
if (a == 5) fprintf(stream, "  \\__/\\__/  ");
}

void naji_x(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   __   __  ");
if (a == 1) fprintf(stream, "   \\ \\_/ /  ");
if (a == 2) fprintf(stream, "    \\   /   ");
if (a == 3) fprintf(stream, "     | |    ");
if (a == 4) fprintf(stream, "    / _ \\   ");
if (a == 5) fprintf(stream, "   /_/ \\_\\  ");
}

void naji_y(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   __   __  ");
if (a == 1) fprintf(stream, "   \\ \\_/ /  ");
if (a == 2) fprintf(stream, "    \\   /   ");
if (a == 3) fprintf(stream, "     | |    ");
if (a == 4) fprintf(stream, "     | |    ");
if (a == 5) fprintf(stream, "     |_|    ");
}

void naji_z(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "    _____   ");
if (a == 1) fprintf(stream, "   |___  |  ");
if (a == 2) fprintf(stream, "      / /   ");
if (a == 3) fprintf(stream, "     / /    ");
if (a == 4) fprintf(stream, "    / /__   ");
if (a == 5) fprintf(stream, "   /_____|  ");
}

void naji_1(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "    /~~|    ");
if (a == 1) fprintf(stream, "  /_   |    ");
if (a == 2) fprintf(stream, "    |  |    ");
if (a == 3) fprintf(stream, "    |  |    ");
if (a == 4) fprintf(stream, "   _|  |_   ");
if (a == 5) fprintf(stream, "  |______|  ");
}

void naji_2(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   _____    ");
if (a == 1) fprintf(stream, "  /     \\   ");
if (a == 2) fprintf(stream, " |_/~\\   \\  ");
if (a == 3) fprintf(stream, "     /  /   ");
if (a == 4) fprintf(stream, "   /  /___  ");
if (a == 5) fprintf(stream, "  |_______| ");
}

void naji_3(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   ______   ");
if (a == 1) fprintf(stream, "  |___   \\  ");
if (a == 2) fprintf(stream, "    __|  /  ");
if (a == 3) fprintf(stream, "   <__  <   ");
if (a == 4) fprintf(stream, "   ___|  \\  ");
if (a == 5) fprintf(stream, "  |______/  ");
}

void naji_4(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "     /~~|   ");
if (a == 1) fprintf(stream, "    /   |   ");
if (a == 2) fprintf(stream, "   / /| |   ");
if (a == 3) fprintf(stream, "  / /_| |_  ");
if (a == 4) fprintf(stream, " /____   _| ");
if (a == 5) fprintf(stream, "      |_|   ");
}

void naji_5(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   ______   ");
if (a == 1) fprintf(stream, "  |  ____|  ");
if (a == 2) fprintf(stream, "  | |____   ");
if (a == 3) fprintf(stream, "  |____  |  ");
if (a == 4) fprintf(stream, "   ____| |  ");
if (a == 5) fprintf(stream, "  |______|  ");
}

void naji_6(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "    _____   ");
if (a == 1) fprintf(stream, "   / ____|  ");
if (a == 2) fprintf(stream, "  | |____   ");
if (a == 3) fprintf(stream, "  |  __  |  ");
if (a == 4) fprintf(stream, "  | |__| |  ");
if (a == 5) fprintf(stream, "   \\____/   ");
}

void naji_7(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   ______   ");
if (a == 1) fprintf(stream, "  |___   |  ");
if (a == 2) fprintf(stream, "     /  /   ");
if (a == 3) fprintf(stream, "    /  /    ");
if (a == 4) fprintf(stream, "   /  /     ");
if (a == 5) fprintf(stream, "  /__/      ");
}

void naji_8(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "    _____   ");
if (a == 1) fprintf(stream, "   / ___ \\  ");
if (a == 2) fprintf(stream, "  | |__| |  ");
if (a == 3) fprintf(stream, "   > __ <   ");
if (a == 4) fprintf(stream, "  | |__| |  ");
if (a == 5) fprintf(stream, "   \\____/   ");
}

void naji_9(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "    _____   ");
if (a == 1) fprintf(stream, "   / ___ \\  ");
if (a == 2) fprintf(stream, "  | |__| |  ");
if (a == 3) fprintf(stream, "   \\ __  |  ");
if (a == 4) fprintf(stream, "   ____| |  ");
if (a == 5) fprintf(stream, "   \\____/   ");
}

void naji_0(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "    _____   ");
if (a == 1) fprintf(stream, "   / ___ \\  ");
if (a == 2) fprintf(stream, "  | |  | |  ");
if (a == 3) fprintf(stream, "  | |  | |  ");
if (a == 4) fprintf(stream, "  | |__| |  ");
if (a == 5) fprintf(stream, "   \\____/   ");
}

void naji_ascii_coma(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "            ");
if (a == 1) fprintf(stream, "            ");
if (a == 2) fprintf(stream, "            ");
if (a == 3) fprintf(stream, "     ___    ");
if (a == 4) fprintf(stream, "    |   |   ");
if (a == 5) fprintf(stream, "   /___/    ");
}

void naji_ascii_aposopen(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "    ___     ");
if (a == 1) fprintf(stream, "   |   |    ");
if (a == 2) fprintf(stream, "    \\___\\   ");
if (a == 3) fprintf(stream, "            ");
if (a == 4) fprintf(stream, "            ");
if (a == 5) fprintf(stream, "            ");
}

void naji_ascii_aposclose(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "     ___    ");
if (a == 1) fprintf(stream, "    |   |   ");
if (a == 2) fprintf(stream, "   /___/    ");
if (a == 3) fprintf(stream, "            ");
if (a == 4) fprintf(stream, "            ");
if (a == 5) fprintf(stream, "            ");
}

void naji_ascii_period(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "            ");
if (a == 1) fprintf(stream, "            ");
if (a == 2) fprintf(stream, "            ");
if (a == 3) fprintf(stream, "    ____    ");
if (a == 4) fprintf(stream, "   |    |   ");
if (a == 5) fprintf(stream, "   |____|   ");
}

void naji_ascii_colon(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "    ____    ");
if (a == 1) fprintf(stream, "   |    |   ");
if (a == 2) fprintf(stream, "   |____|   ");
if (a == 3) fprintf(stream, "    ____    ");
if (a == 4) fprintf(stream, "   |    |   ");
if (a == 5) fprintf(stream, "   |____|   ");
}

void naji_ascii_semicolon(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "     ___    ");
if (a == 1) fprintf(stream, "    |   |   ");
if (a == 2) fprintf(stream, "    |___|   ");
if (a == 3) fprintf(stream, "     ___    ");
if (a == 4) fprintf(stream, "    |   |   ");
if (a == 5) fprintf(stream, "   /___/    ");
}

void naji_ascii_lessthan(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "     /~/    ");
if (a == 1) fprintf(stream, "    / /     ");
if (a == 2) fprintf(stream, "   / /      ");
if (a == 3) fprintf(stream, "   \\ \\      ");
if (a == 4) fprintf(stream, "    \\ \\     ");
if (a == 5) fprintf(stream, "     \\_\\    ");
}

void naji_ascii_morethan(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "    \\~\\     ");
if (a == 1) fprintf(stream, "     \\ \\    ");
if (a == 2) fprintf(stream, "      \\ \\   ");
if (a == 3) fprintf(stream, "      / /   ");
if (a == 4) fprintf(stream, "     / /    ");
if (a == 5) fprintf(stream, "    /_/     ");
}
void naji_ascii_paranopen(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "     /~/    ");
if (a == 1) fprintf(stream, "    / /     ");
if (a == 2) fprintf(stream, "   | |      ");
if (a == 3) fprintf(stream, "   | |      ");
if (a == 4) fprintf(stream, "    \\ \\     ");
if (a == 5) fprintf(stream, "     \\_\\    ");
}

void naji_ascii_paranclose(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "    \\~\\     ");
if (a == 1) fprintf(stream, "     \\ \\    ");
if (a == 2) fprintf(stream, "      | |   ");
if (a == 3) fprintf(stream, "      | |   ");
if (a == 4) fprintf(stream, "     / /    ");
if (a == 5) fprintf(stream, "    /_/     ");
}

void naji_ascii_underscore(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "            ");
if (a == 1) fprintf(stream, "            ");
if (a == 2) fprintf(stream, "            ");
if (a == 3) fprintf(stream, "            ");
if (a == 4) fprintf(stream, " __________ ");
if (a == 5) fprintf(stream, "|__________|");
}

void naji_ascii_exclaimark(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "    ___     ");
if (a == 1) fprintf(stream, "   |   |    ");
if (a == 2) fprintf(stream, "   |   |    ");
if (a == 3) fprintf(stream, "   |___|    ");
if (a == 4) fprintf(stream, "    ___     ");
if (a == 5) fprintf(stream, "   |___|    ");
}

void naji_ascii_pipe(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   |~~~|    ");
if (a == 1) fprintf(stream, "   |   |    ");
if (a == 2) fprintf(stream, "   |   |    ");
if (a == 3) fprintf(stream, "   |   |    ");
if (a == 4) fprintf(stream, "   |   |    ");
if (a == 5) fprintf(stream, "   |___|    ");
}

void naji_ascii_numsign(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "   ##  ##   ");
if (a == 1) fprintf(stream, " ########## ");
if (a == 2) fprintf(stream, "   ##  ##   ");
if (a == 3) fprintf(stream, "   ##  ##   ");
if (a == 4) fprintf(stream, " ########## ");
if (a == 5) fprintf(stream, "   ##  ##   ");
}

void naji_ascii_fslash(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "      /~~/  ");
if (a == 1) fprintf(stream, "     /  /   ");
if (a == 2) fprintf(stream, "    /  /    ");
if (a == 3) fprintf(stream, "   /  /     ");
if (a == 4) fprintf(stream, "  /  /      ");
if (a == 5) fprintf(stream, " /__/       ");
}

void naji_ascii_bslash(int a, FILE *stream)
{
if (a == 0) fprintf(stream, "  \\~~\\      ");
if (a == 1) fprintf(stream, "   \\  \\     ");
if (a == 2) fprintf(stream, "    \\  \\    ");
if (a == 3) fprintf(stream, "     \\  \\   ");
if (a == 4) fprintf(stream, "      \\  \\  ");
if (a == 5) fprintf(stream, "       \\__\\ ");
}




void naji_ascii(char *string, int i, int a, FILE *stream)
{
/* small and big letter is the same for now */
/* i might do different styles in later versions */

    if (string[i] == ' ') { naji_(a, stream); return; }
    if (string[i] == 'a') { naji_a(a, stream); return; }
    if (string[i] == 'b') { naji_b(a, stream); return; }
    if (string[i] == 'c') { naji_c(a, stream); return; }
    if (string[i] == 'd') { naji_d(a, stream); return; }
    if (string[i] == 'e') { naji_e(a, stream); return; }
    if (string[i] == 'f') { naji_f(a, stream); return; }
    if (string[i] == 'g') { naji_g(a, stream); return; }
    if (string[i] == 'h') { naji_h(a, stream); return; }
    if (string[i] == 'i') { naji_i(a, stream); return; }
    if (string[i] == 'j') { naji_j(a, stream); return; }
    if (string[i] == 'k') { naji_k(a, stream); return; }
    if (string[i] == 'l') { naji_l(a, stream); return; }
    if (string[i] == 'm') { naji_m(a, stream); return; }
    if (string[i] == 'n') { naji_n(a, stream); return; }
    if (string[i] == 'o') { naji_o(a, stream); return; }
    if (string[i] == 'p') { naji_p(a, stream); return; }
    if (string[i] == 'q') { naji_q(a, stream); return; }
    if (string[i] == 'r') { naji_r(a, stream); return; }
    if (string[i] == 's') { naji_s(a, stream); return; }
    if (string[i] == 't') { naji_t(a, stream); return; }
    if (string[i] == 'u') { naji_u(a, stream); return; }
    if (string[i] == 'v') { naji_v(a, stream); return; }
    if (string[i] == 'w') { naji_w(a, stream); return; }
    if (string[i] == 'x') { naji_x(a, stream); return; }
    if (string[i] == 'y') { naji_y(a, stream); return; }
    if (string[i] == 'z') { naji_z(a, stream); return; }

    if (string[i] == 'A') { naji_a(a, stream); return; }
    if (string[i] == 'B') { naji_b(a, stream); return; }
    if (string[i] == 'C') { naji_c(a, stream); return; }
    if (string[i] == 'D') { naji_d(a, stream); return; }
    if (string[i] == 'E') { naji_e(a, stream); return; }
    if (string[i] == 'F') { naji_f(a, stream); return; }
    if (string[i] == 'G') { naji_g(a, stream); return; }
    if (string[i] == 'H') { naji_h(a, stream); return; }
    if (string[i] == 'I') { naji_i(a, stream); return; }
    if (string[i] == 'J') { naji_j(a, stream); return; }
    if (string[i] == 'K') { naji_k(a, stream); return; }
    if (string[i] == 'L') { naji_l(a, stream); return; }
    if (string[i] == 'M') { naji_m(a, stream); return; }
    if (string[i] == 'N') { naji_n(a, stream); return; }
    if (string[i] == 'O') { naji_o(a, stream); return; }
    if (string[i] == 'P') { naji_p(a, stream); return; }
    if (string[i] == 'Q') { naji_q(a, stream); return; }
    if (string[i] == 'R') { naji_r(a, stream); return; }
    if (string[i] == 'S') { naji_s(a, stream); return; }
    if (string[i] == 'T') { naji_t(a, stream); return; }
    if (string[i] == 'U') { naji_u(a, stream); return; }
    if (string[i] == 'V') { naji_v(a, stream); return; }
    if (string[i] == 'W') { naji_w(a, stream); return; }
    if (string[i] == 'X') { naji_x(a, stream); return; }
    if (string[i] == 'Y') { naji_y(a, stream); return; }
    if (string[i] == 'Z') { naji_z(a, stream); return; }

    if (string[i] == '1') { naji_1(a, stream); return; }
    if (string[i] == '2') { naji_2(a, stream); return; }
    if (string[i] == '3') { naji_3(a, stream); return; }
    if (string[i] == '4') { naji_4(a, stream); return; }
    if (string[i] == '5') { naji_5(a, stream); return; }
    if (string[i] == '6') { naji_6(a, stream); return; }
    if (string[i] == '7') { naji_7(a, stream); return; }
    if (string[i] == '8') { naji_8(a, stream); return; }
    if (string[i] == '9') { naji_9(a, stream); return; }
    if (string[i] == '0') { naji_0(a, stream); return; }

    if (string[i] == ',')  { naji_ascii_coma(a, stream); return; }
    if (string[i] == '`')  { naji_ascii_aposopen(a, stream); return; }
    if (string[i] == '\'') { naji_ascii_aposclose(a, stream); return; }
    if (string[i] == '.')  { naji_ascii_period(a, stream); return; }
    if (string[i] == ':')  { naji_ascii_colon(a, stream); return; }
    if (string[i] == ';')  { naji_ascii_semicolon(a, stream); return; }
    if (string[i] == '<')  { naji_ascii_lessthan(a, stream); return; }
    if (string[i] == '>')  { naji_ascii_morethan(a, stream); return; }
    if (string[i] == '(')  { naji_ascii_paranopen(a, stream); return; }
    if (string[i] == ')')  { naji_ascii_paranclose(a, stream); return; }
    if (string[i] == '_')  { naji_ascii_underscore(a, stream); return; }
    if (string[i] == '!')  { naji_ascii_exclaimark(a, stream); return; }
    if (string[i] == '|')  { naji_ascii_pipe(a, stream); return; }
    if (string[i] == '#')  { naji_ascii_numsign(a, stream); return; }
    if (string[i] == '/')  { naji_ascii_fslash(a, stream); return; }
    if (string[i] == '\\') { naji_ascii_bslash(a, stream); return; }

}


void _bigascif(char *string, FILE *stream)
{
int a=0;
int i=0;
int l=0;


l = strlen(string);

    for (a=0; a<6; a++)
    {
        for (i=0; i<l; i++)
        naji_ascii(string, i, a, stream);

        fprintf(stream, "\r\n");
    }


return;
}


void bigascif(char *string, char *nameout)
{
najout(nameout);
_bigascif(string, naji_output);
najoutclose();
}

void bin2c(char *namein, char *nameout, char *array_name)
{
int a;
int i=0;
int end=15;
int fsize_var=0;
int fsize_max=0;

najin(namein);
najout(nameout);

fsize_max = najinsize();
fsize_var = fsize_max;

fprintf(naji_output, "\r\n/*  converted with naji_gui (najitool GUI):  */\r\n");
fprintf(naji_output, "/*  please  keep  these  comments  here  so  others  can  use  */\r\n");
fprintf(naji_output, "/*  najitool the completely free tool for doing this as well.  */\r\n");
fprintf(naji_output, "/*  you can get najitool here: http://najitool.sf.net/         */\r\n\r\n");

    fprintf(naji_output,"unsigned char %s[%i] = \r\n{\r\n", array_name, fsize_max);

    while(1)
    {
    a = fgetc(naji_input);

    if (fsize_var == 1) break;

    if (i == end) { fprintf(naji_output, "\r\n"); i=0; }

    fprintf(naji_output, "0x%02X,", a);
    i++;
    
    fsize_var--;
    }

fprintf(naji_output, "\r\n0x%02X", a);
fprintf(naji_output, "};\r\n\r\n");

najinclose();
najoutclose();
}

void bin2text(char *namein, char *nameout)
{
int a=0;

najin(namein);
najout(nameout);

        while(1)
        {
        a = fgetc(naji_input);
        if (a == EOF) break;

    if ( ( (a > 31) && (a < 127) ) ||
         ( (a == '\n') ) ||
         ( (a == '\r') ) ||
         ( (a == '\t') )
        )
    
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}

void blanka(char *namein, char *nameout)
{
int a;
int i;

najin(namein);
najout(nameout);

	while(1)
	{
	a = fgetc(naji_input);

	if (a == EOF)
	break;

	for (i=0; i<=a; i++)
	fputc(' ', naji_output);

	fputc('\n', naji_output);
	}

najinclose();
najoutclose();
}


void unblanka(char *namein, char *nameout)
{
int a;
int i=0;


najin(namein);
najout(nameout);


	while(1)
	{
	a = fgetc(naji_input);

	if (a == EOF)
	break;

	if (a == ' ')
	i++;

		if ((a == '\n') && (i != 0))
		{
		fputc((i-1), naji_output);
		i = 0;
		}

	}


najinclose();
najoutclose();
}


void bremline(char *str, char *namein, char *nameout)
{
char *tempbuf = NULL;

int len;
int a = 0;
int i = 0;
int cnt = 0;
int pos = 0;

    len = strlen(str);

    tempbuf = (char *) calloc(len + 1, sizeof (char));

    if (tempbuf == NULL)
	{
		fprintf(stderr, "\n\nError, cannot allocate memory");
		perror(" "); fprintf(stderr, "\n\n");
        exit(2);
	}

	najin(namein);
	najout(nameout);

	while (1)
	{

        a = fgetc(naji_input);

		if (a == EOF)
		{
            for (i=0; i<cnt ; i++)
            fputc(tempbuf[i], naji_output);

			fputc('\n', naji_output);
			break;
		}

		if (a == '\n')
		{
			/* Print the temp buffer */
            for (i=0; i<cnt; i++)
            fputc(tempbuf[i], naji_output);
			
			fputc('\n', naji_output);

			pos = 0;
			cnt = 0;

			continue;
		}

        tempbuf[pos % len] = (char)a;
        pos++;
        cnt++;

		if (cnt == len)
		{

            if (!isequal(str, tempbuf, len, pos % len))
			{

                for (i=0; i<cnt; i++)
                fputc(tempbuf[i], naji_output);

				/* Print remaing line */
				while (1)
				{
                    a = fgetc(naji_input);

					if (a == EOF || a == '\n')
                    break;

                    fputc(a, naji_output);
				}

                fputc('\n', naji_output);
			}


    		else
			{

				/* Skip this line */
				while (1)
				{

                    a = fgetc(naji_input);

                    if (a == EOF || a == '\n')
                    break;


                }


			}


			pos = 0;
			cnt = 0;

		}



	}


najinclose();
najoutclose();
}


void charaftr(char *namein, char *nameout, char ch)
{
int a;

najin(namein);
najout(nameout);

    while(1)
    {
    a = fgetc(naji_input);
    
    if (a == EOF)
    break;
    
    fputc(a, naji_output);
    fputc(ch, naji_output);
    }

najinclose();
najoutclose();
}


void charbefr(char *namein, char *nameout, char ch)
{
int a;

najin(namein);
najout(nameout);

    while(1)
    {
    a = fgetc(naji_input);

    if (a == EOF)
    break;

    fputc(ch, naji_output);
    fputc(a, naji_output);
    }

najinclose();
najoutclose();
}


void charwrap(int w, char *namein, char *nameout)
{
int a;
int b;

najin(namein);
najout(nameout);


       b=0;

       while(1)
       {

       a = fgetc(naji_input);
       if (a == EOF)
       break;

       b++;

       if (b == w || a == '\n')
       {
       fputc('\n', naji_output);
       b=0;
       }

       fputc(a, naji_output);

       }




najinclose();
najoutclose();
}

void chchar(char *namein, char *nameout, char original, char changed)
{
char a;

najin(namein);
najout(nameout);


    while(1)
    {
    a = (char) fgetc(naji_input);
    if (a == EOF)
    break;

    if (a == original)
    a = changed;

    fputc(a, naji_output);
    }

najinclose();
najoutclose();
}


void file2dec(char *namein, char *nameout)
{
int a;


 najin(namein);
 najout(nameout);

  while(1)
  {
  a = fgetc(naji_input);

  if (a == EOF)
  break;

  fprintf(naji_output, "%i\n", a);
  }

 najinclose();
 najoutclose();

}


void file2hex(char *namein, char *nameout)
{
int a;


 najin(namein);
 najout(nameout);

  while(1)
  {
  a = fgetc(naji_input);

  if (a == EOF)
  break;

  fprintf(naji_output, "%02X\n", a);
  }

 najinclose();
 najoutclose();

}


void file2bin(char *namein, char *nameout)
{
char a;

 najin(namein);
 najout(nameout);

  while(1)
  {
  a = (char) fgetc(naji_input);

  if (a == EOF)
  break;

  fprint_8_bit_bin(naji_output, a);
  fputc('\n', naji_output);
  }

 najinclose();
 najoutclose();
}


void cpfroml(unsigned long line, char *namein, char *nameout)
{
int a;
unsigned long cnt = 0;

    if (line <= 0)
    return;

    line -= 1;

najin(namein);
najout(nameout);

	while (cnt != line)
	{
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        if (a == '\n')
        cnt++;
  	}
	
	if (cnt == line)
	{

	a = fgetc(naji_input);

	if (a == EOF)
	{
	najinclose();
	najoutclose();
	return;
	}

	if (a != '\r')
	fputc(a, naji_output);

            while (1)
            {
                a = fgetc(naji_input);

                if (a == EOF)
                break;

		fputc(a, naji_output);
            }

	}


najinclose();
najoutclose();
}


void cptiline(unsigned long line, char *namein, char *nameout)
{
int a;
unsigned long cnt = 0;

    if (line <= 0)
    return;

najin(namein);
najout(nameout);

	while (1)
	{
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        if (a == '\n')
        cnt++;

		if (cnt == line)
		{
		a = fgetc(naji_input);

			if (a == EOF)
			break;

			if (a == '\r')
			fputc(a, naji_output);

			break;
		}

	fputc(a, naji_output);

  	}
	



najinclose();
najoutclose();
}

void downlist(char *namein, char *nameout)
{
char buffer[1050];
int i;

najin(namein);
najout(nameout);


fprintf(naji_output, 
"<html>\n\n<head> <title> %s - generated with najitool </title> </head>\n\n<body>\n\n\n\n\n",
 nameout);


   while(1)
   {
   fgets(buffer, 1024, naji_input);

   if (feof(naji_input))
   break;

           for (i=0; buffer[i] != 0; i++)
           {

                if (buffer[i] == '\n')
                {
                buffer[i] = '\0';
                break;
                }

                if (buffer[i] == '\r')
                {
                buffer[i] = '\0';
                break;
                }
           }

   fprintf(naji_output, "<a href=\"%s\">%s</a><p>\n", buffer, buffer);
   }


fprintf(naji_output,
"\n\n\n\n<p>\n\n<hr> This HTML page was generated with <b> najitool </b> <br>\n");

fprintf(naji_output, "From a plain text file with a list of files to download <br>\n");

fprintf(naji_output,
"You can get <b> najitool </b> the completely free tool at: <br>\n");

fprintf(naji_output,
"<b> <a href=\"http://najitool.sf.net/\"> http://najitool.sf.net/ </a> </b>\n\n<hr>\n\n<p>\n\n");

fprintf(naji_output, "\n\n\n</body>\n\n</html>\n\n");


najinclose();
najoutclose();
}


void filbreed(char *namein, char *namein2, char *nameout)
{
int a;
int b;

  najin(namein);
  najin2(namein2);
  najout(nameout);


   while(1)
   {

   a = fgetc(naji_input);
   b = fgetc(naji_input2);


   if (a == EOF)
   break;

   if (b == EOF)
   break;

   fputc(a, naji_output);
   fputc(b, naji_output);

   }


  najinclose();
  najin2close();
  najoutclose();
}

void filechop(long copytil, char *namein, char *nameout, char *nameout2)
{
long i;
long fsize;

int a;

najin(namein);
najout(nameout);
najout2(nameout2);

    for (i=0; i<copytil; i++)
    {
    a = fgetc(naji_input);
    fputc(a, naji_output);
    }

    fsize = naji_filesize(naji_input);

    for (i=copytil; i<fsize; i++)
    {
    a = fgetc(naji_input);
    fputc(a, naji_output2);
    }

najinclose();
najoutclose();
najout2close();
}

void filejoin(char *namein, char *namein2, char *nameout)
{
int a=0;

najin(namein);
najin2(namein2);
najout(nameout);

    while (1)
    {
    a = fgetc(naji_input);
    
    if (a == EOF)
    break;
    
    fputc(a, naji_output);
    }

    while (1)
    {
    a = fgetc(naji_input2);
    
    if (a == EOF)
    break;

    fputc(a, naji_output);
    }

najinclose();
najin2close();
najoutclose();
}

void fillfile(char *named, char c)
{
long size=0;
long i=0;

najed(named);

        size = najedsize();

        fseek(naji_edit, 0, SEEK_SET);

        for (i=0; i<size; i++)
        fputc(c, naji_edit);

najedclose();
}


void flipcopy(char *namein, char *nameout)
{
int a=0;

najin(namein);
najout(nameout);

    while(1)
    {
    a = fgetc(naji_input);
    
    if (a == EOF)
    break;
    
    fputc((~a), naji_output);
    }

najinclose();
najoutclose();
}

             

void wordwrap(char *namein, char *nameout)
{
int i;
int a;
int b;

najin(namein);
najout(nameout);


       b=0;

       while (1)
       {

       a = fgetc(naji_input);
       if (a == EOF)
       break;

       b++;

       if (a == '\n') b=0;


       for (i=0; i<14; i++)
       if ( (b == 65+i) &&

            (  a == ' ' ||
               a == '-' ||
               a == '+' ||
               a == '_' ||
               a == '/' ||
               a == '\\'

             )
          )

       {
       fputc('\n', naji_output);
       b=0;
       break;
       }

       fputc(a, naji_output);

       }




najinclose();
najoutclose();
}


void numlines(char *namein, char *nameout)
{
int a;
unsigned long line = 1;


najin(namein);
najout(nameout);


fprintf(naji_output, "%lu ", line);


   while (1)
   {

   a = fgetc(naji_input);

   if (a == EOF)
   break;

   if (a == '\n')
   {
   line++;
   fprintf(naji_output, "\n%lu ", line);
   }
   else
   fputc(a, naji_output);

   }


najinclose();
najoutclose();
}






void rbcafter(char *namein, char *nameout)
{
int a;

rand_init();

najin(namein);
najout(nameout);

    while (1)
    {
    a = fgetc(naji_input);
    
    if (a == EOF)
    break;
    
    fputc(a, naji_output);
    fputc(rand() % 255, naji_output);
    }

najinclose();
najoutclose();
}


void rbcbefor(char *namein, char *nameout)
{
int a;

rand_init();

najin(namein);
najout(nameout);

    while (1)
    {
    a = fgetc(naji_input);

    if (a == EOF)
    break;

    fputc(rand() % 255, naji_output);
    fputc(a, naji_output);
    }

najinclose();
najoutclose();
}




void rtcafter(char *namein, char *nameout)
{
int a;

rand_init();

najin(namein);
najout(nameout);

    while (1)
    {
    a = fgetc(naji_input);
    
    if (a == EOF)
    break;
    
    fputc(a, naji_output);
    fputc( ( (rand() % 95)+' ' ), naji_output);
    }

najinclose();
najoutclose();
}


void rtcbefor(char *namein, char *nameout)
{
int a;

rand_init();

najin(namein);
najout(nameout);

    while (1)
    {
    a = fgetc(naji_input);

    if (a == EOF)
    break;

    fputc( ( (rand() % 95)+' ' ), naji_output);
    fputc(a, naji_output);
    }

najinclose();
najoutclose();
}



void strbline(char *namein, char *nameout, char *str)
{
char buffer[4096];
   
najin(namein);
najout(nameout);


   *buffer = '\0';

   while(fgets(buffer, sizeof(buffer), naji_input))
   {
   fprintf(naji_output, "%s%s", str, buffer);
   *buffer = '\0';
   }


najinclose();
najoutclose();
}


void streline(char *namein, char *nameout, char *str)
{
char buffer[4096];
char lastchar=0;
   
najin(namein);
najout(nameout);


   *buffer = '\0';

   while(fgets(buffer, sizeof(buffer), naji_input))
   {
   lastchar = buffer[strlen(buffer)-1];
   buffer[strlen(buffer)-1] ='\0';

   fprintf(naji_output, "%s%s%c",  buffer, str, lastchar);
   *buffer = '\0';
   }


najinclose();
najoutclose();
}


void swapfeb(char *namein, char *namein2, char *nameout)
{
int a;
int b;

  najin(namein);
  najin2(namein2);
  najout(nameout);


   while(1)
   {

   a = fgetc(naji_input);
   fgetc(naji_input2);
   b = fgetc(naji_input2);
   fgetc(naji_input);


   if (a == EOF)
   break;

   if (b == EOF)
   break;

   fputc(a, naji_output);
   fputc(b, naji_output);

   }


  najinclose();
  najin2close();
  najoutclose();
}





void wordline(char *namein, char *nameout)
{
int a;

najin(namein);
najout(nameout);


    while (1)
    {
    a = fgetc(naji_input);

    if (a == EOF)
    break;

    if (a == ' ')
    a = '\n';

    fputc(a, naji_output);
    }


najinclose();
najoutclose();
}




void remline(char *str, char *namein, char *nameout)
{
long pos;
int i;
int c;
char *line;


        najin(namein);
        najout(nameout);

        pos = ftell(naji_input);
        c = fgetc(naji_input);
        
        /* line by line */
        while (c != EOF)
        {
        
            for (i=0; (c != EOF) && (c != '\n') && (c != '\0'); i++)
            c = fgetc(naji_input);

            if (i > 0)
            {
            line = (char*) malloc (sizeof(char)*i+1);

            fseek(naji_input, pos, SEEK_SET);
            fgets(line, (i+1), naji_input);

            if (strstr(line, str) == NULL)
            fprintf(naji_output, "%s\n", line);
        
            free(line);
            }
                
            pos = ftell(naji_input);
            c = fgetc(naji_input);
        }



najinclose();
najoutclose();
}



void skpalnum(char *namein, char *nameout)
{
int skip = NAJI_FALSE;
int a=0;


najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        skip = NAJI_FALSE;

        if (isalnum(a))
        skip = NAJI_TRUE;

        if (skip == NAJI_FALSE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void skpalpha(char *namein, char *nameout)
{
int skip = NAJI_FALSE;
int a=0;


najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        skip = NAJI_FALSE;

        if (isalpha(a))
        skip = NAJI_TRUE;

        if (skip == NAJI_FALSE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void skpcntrl(char *namein, char *nameout)
{
int skip = NAJI_FALSE;
int a=0;


najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        skip = NAJI_FALSE;

        if (iscntrl(a))
        skip = NAJI_TRUE;

        if (skip == NAJI_FALSE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void skpdigit(char *namein, char *nameout)
{
int skip = NAJI_FALSE;
int a=0;


najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        skip = NAJI_FALSE;

        if (isdigit(a))
        skip = NAJI_TRUE;

        if (skip == NAJI_FALSE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void skpgraph(char *namein, char *nameout)
{
int skip = NAJI_FALSE;
int a=0;


najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        skip = NAJI_FALSE;

        if (isgraph(a))
        skip = NAJI_TRUE;

        if (skip == NAJI_FALSE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void skplower(char *namein, char *nameout)
{
int skip = NAJI_FALSE;
int a=0;


najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        skip = NAJI_FALSE;

        if (islower(a))
        skip = NAJI_TRUE;

        if (skip == NAJI_FALSE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void skpprint(char *namein, char *nameout)
{
int skip = NAJI_FALSE;
int a=0;


najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        skip = NAJI_FALSE;

        if (isprint(a))
        skip = NAJI_TRUE;

        if (skip == NAJI_FALSE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void skppunct(char *namein, char *nameout)
{
int skip = NAJI_FALSE;
int a=0;


najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        skip = NAJI_FALSE;

        if (ispunct(a))
        skip = NAJI_TRUE;

        if (skip == NAJI_FALSE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void skpspace(char *namein, char *nameout)
{
int skip = NAJI_FALSE;
int a=0;


najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        skip = NAJI_FALSE;

        if (isspace(a))
        skip = NAJI_TRUE;

        if (skip == NAJI_FALSE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void skpupper(char *namein, char *nameout)
{
int skip = NAJI_FALSE;
int a=0;


najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        skip = NAJI_FALSE;

        if (isupper(a))
        skip = NAJI_TRUE;

        if (skip == NAJI_FALSE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void skpxdigt(char *namein, char *nameout)
{
int skip = NAJI_FALSE;
int a=0;


najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        skip = NAJI_FALSE;

        if (isxdigit(a))
        skip = NAJI_TRUE;

        if (skip == NAJI_FALSE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void onlalnum(char *namein, char *nameout)
{
int show = NAJI_TRUE;
int a=0;

najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        show = NAJI_FALSE;

        if (isalnum(a))
        show = NAJI_TRUE;

        if (show == NAJI_TRUE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void onlalpha(char *namein, char *nameout)
{
int show = NAJI_TRUE;
int a=0;

najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        show = NAJI_FALSE;

        if (isalpha(a))
        show = NAJI_TRUE;

        if (show == NAJI_TRUE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void onlcntrl(char *namein, char *nameout)
{
int show = NAJI_TRUE;
int a=0;

najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        show = NAJI_FALSE;

        if (iscntrl(a))
        show = NAJI_TRUE;

        if (show == NAJI_TRUE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void onldigit(char *namein, char *nameout)
{
int show = NAJI_TRUE;
int a=0;

najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        show = NAJI_FALSE;

        if (isdigit(a))
        show = NAJI_TRUE;

        if (show == NAJI_TRUE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void onlgraph(char *namein, char *nameout)
{
int show = NAJI_TRUE;
int a=0;

najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        show = NAJI_FALSE;

        if (isgraph(a))
        show = NAJI_TRUE;

        if (show == NAJI_TRUE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void onllower(char *namein, char *nameout)
{
int show = NAJI_TRUE;
int a=0;

najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        show = NAJI_FALSE;

        if (islower(a))
        show = NAJI_TRUE;

        if (show == NAJI_TRUE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void onlprint(char *namein, char *nameout)
{
int show = NAJI_TRUE;
int a=0;

najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        show = NAJI_FALSE;

        if (isprint(a))
        show = NAJI_TRUE;

        if (show == NAJI_TRUE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void onlpunct(char *namein, char *nameout)
{
int show = NAJI_TRUE;
int a=0;

najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        show = NAJI_FALSE;

        if (ispunct(a))
        show = NAJI_TRUE;

        if (show == NAJI_TRUE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void onlspace(char *namein, char *nameout)
{
int show = NAJI_TRUE;
int a=0;

najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        show = NAJI_FALSE;

        if (isspace(a))
        show = NAJI_TRUE;

        if (show == NAJI_TRUE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void onlupper(char *namein, char *nameout)
{
int show = NAJI_TRUE;
int a=0;

najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        show = NAJI_FALSE;

        if (isupper(a))
        show = NAJI_TRUE;

        if (show == NAJI_TRUE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}


void onlxdigt(char *namein, char *nameout)
{
int show = NAJI_TRUE;
int a=0;

najin(namein);
najout(nameout);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        show = NAJI_FALSE;

        if (isxdigit(a))
        show = NAJI_TRUE;

        if (show == NAJI_TRUE)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}




void ftothe(char *namein, char *nameout)
{
int a;

int i;
long l;

najin(namein);
najout(nameout);

l = najinsize();
  
       for (i=0; i<(l-1); i++)
       {

       a = fgetc(naji_input);

       fprintf(naji_output, "%c to the", a);

       if (i == (l-1))
       break;

       fputc(' ', naji_output);
       }

       a = fgetc(naji_input);
       fputc(a, naji_output);

najinclose();
najoutclose();
}


void strachar(char *str, char *namein, char *nameout)
{
int a;

najin(namein);
najout(nameout);

    while(1)
    {
    a = fgetc(naji_input);

    if (a == EOF)
    break;

    fputc(a, naji_output);

    fprintf(naji_output, str);
    }

najinclose();
najoutclose();
}


void strbchar(char *str, char *namein, char *nameout)
{
int a;

najin(namein);
najout(nameout);

    while(1)
    {
    a = fgetc(naji_input);

    if (a == EOF)
    break;

    fprintf(naji_output, str);

    fputc(a, naji_output);
    }

najinclose();
najoutclose();
}


void rstrach(int len, char *namein, char *nameout)
{
int a;
int i;


najin(namein);
najout(nameout);

    while(1)
    {
    a = fgetc(naji_input);

    if (a == EOF)
    break;

    fputc(a, naji_output);

    for (i=0; i<len; i++)
    fputc(((rand() % 95)+' '), naji_output);
    }

najinclose();
najoutclose();
}


void rstrbch(int len, char *namein, char *nameout)
{
int a;
int i;


najin(namein);
najout(nameout);

    while(1)
    {
    a = fgetc(naji_input);

    if (a == EOF)
    break;

    for (i=0; i<len; i++)
    fputc(((rand() % 95)+' '), naji_output);

    fputc(a, naji_output);
    }

najinclose();
najoutclose();
}





void rndffill(char *named)
{
long size=0;
long i=0;

najed(named);

        size = najedsize();

        rand_init();

        fseek(naji_edit, 0, SEEK_SET);

        for (i=0; i<size; i++)
        fputc(rand() % 255, naji_edit);

najedclose();
}


int zerokill(char *name)
{
fillfile(name, '\0');
return remove(name);
}


int randkill(char *name)
{
rndffill(name);
return remove(name);
}


void najirle(char *namein, char *nameout)
{
int i;
int a;
int b;
unsigned char repeats=0;


najin(namein);
najout(nameout);

	while (1)
	{

	repeats=0;

	a = fgetc(naji_input);

	if (a == EOF)
	break;

		while (1)
		{
		b = fgetc(naji_input);

		if (b == EOF)
		break;

			if (a != b)
			{
			fseek(naji_input, -1, SEEK_CUR);
			break;
			}
		
		repeats++;

		if (repeats == 255)
		break;	
		}


		if (a == 255)
		{

			for (i=0; i<=repeats; i++)
			{
			fputc(255, naji_output);
			fputc(255, naji_output);
			}

		}
		else
		{

			if (repeats > 2)
			fprintf(naji_output, "%c%c%c", 255, a, repeats);

			else
			{
			for (i=0; i<=repeats; i++)
			fputc(a, naji_output);
			}


		}



	}



najinclose();
najoutclose();
}



void unajirle(char *namein, char *nameout)
{
int a;
int b;
int i=0;


najin(namein);
najout(nameout);


        while (1)
        {

		a = fgetc(naji_input);

		if (a == EOF)
		break;

		if (a != 255)
		{
		fputc(a, naji_output);
		}
		else
		{

		b = fgetc(naji_input);

			if (b == EOF)
			{
			fputc(a, naji_output);
			break;
			}

			if (b == 255)
			{
			fputc(255, naji_output);
			}
			else
			{
			a = b;

			b = fgetc(naji_input);

			 	if (b == EOF)
				{
				fputc(a, naji_output);
				break;
				}
				else
				{
				for (i=0; i<=b; i++)
				fputc(a, naji_output);
				}

			}




		}




        }

najinclose();
najoutclose();
}

void fswpcase(char *namein, char *nameout)
{
int a;
int i;

najin(namein);
najout(nameout);


    while(1)
    {

    a = fgetc(naji_input);

    if (a == EOF)
    break;


       for (i=0; i<26; i++)
       {

          if (a == ('a' + i) )
          {
          a -= 32;
          break;
          }

          if (a == ('A' + i) )
          {
          a += 32;
          break;
          }

       }


     fputc(a, naji_output);

    }





najinclose();
najoutclose();
}

void naji_genlic(char *nameout)
{
najout(nameout);
fprintf(naji_output, "\nTHIS PROGRAM IS NON-COPYRIGHTED PUBLIC DOMAIN AND DISTRIBUTED IN THE\n");
fprintf(naji_output, "HOPE THAT IT WILL BE USEFUL BUT THERE IS NO WARRANTY FOR THE PROGRAM,\n");
fprintf(naji_output, "THE PROGRAM IS PROVIDED \"AS IS\" WITHOUT WARRANTY OF ANY KIND, EITHER\n");
fprintf(naji_output, "EXPRESSED  OR  IMPLIED, INCLUDING, BUT  NOT  LIMITED TO, THE IMPLIED\n");
fprintf(naji_output, "WARRANTIES  OF  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.\n");
fprintf(naji_output, "THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM  IS\n");
fprintf(naji_output, "WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF\n");
fprintf(naji_output, "ALL NECESSARY SERVICING, REPAIR OR CORRECTION.\n\n");
najoutclose();
}

void mergline(char *namein, char *namein2, char *nameout, char *beforeline, char *afterline)
{
int a;

najin(namein);
najin2(namein2);
najout(nameout);

        while (1)
        {


        fprintf(naji_output, "%s ", beforeline);



        while (1)
        {
        a = fgetc(naji_input);

        if (a == '\n') break;
        if (a == EOF) break;


        fputc(a, naji_output);
        }



        fputc(' ', naji_output);


        while (1)
        {
        a = fgetc(naji_input2);

        if (a == '\n') break;
        if (a == EOF) break;
        fputc(a, naji_output);
        }



        fprintf(naji_output, " %s", afterline);

        fputc('\n', naji_output);


        if (a == EOF) break;

        }

najinclose();
najin2close();
najoutclose();
}


void putlines(char *namein, char *nameout, char *beforeline, char *afterline)
{
int a;

najin(namein);
najout(nameout);

        while (1)
        {

        fprintf(naji_output, "%s ", beforeline);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == '\n') break;
        if (a == EOF) break;


        fputc(a, naji_output);
        }


        fprintf(naji_output, " %s", afterline);

        fputc('\n', naji_output);

        if (a == EOF) break;

        }

najinclose();
najoutclose();
}





void linesnip(int bytes, char *namein, char *nameout)
{
int i;
int a;

najin(namein);
najout(nameout);


   while(1)
   {

    a = fgetc(naji_input);

    if (a == '\n')
    {

      fputc(a, naji_output);
 
      for (i=0; i<bytes; i++)
      {
      a = fgetc(naji_input);

        if (a == EOF)
        {
        najinclose();
        najoutclose();
        return;
        }

      }


    }
    else if (a == EOF) break;
    else fputc(a, naji_output);
   }


najinclose();
najoutclose();
}

int wrdcount(char *namein)
{
int x=1;
int c=0;

int a;

najin(namein);

    while (1)
    {
    
        a = fgetc(naji_input);
        if (a == EOF)
        {
        najinclose();
        return c;
        }

        if ( (a > 32) && (a < 127) )
        {
            if (x)
            {
            ++c;
            x=0;
            }
        }
        else x=1;
    }

najinclose();
return c;
}





void onlychar(char *namein, char *nameout, char *toshow)
{
int show = NAJI_TRUE;
int a=0;
int i=0;
int l=0;


najin(namein);
najout(nameout);

    l = strlen(toshow);

        while (1)
        {
        a = fgetc(naji_input);
        if (a == EOF) break;

        show = NAJI_FALSE;

        for (i=0; i<l; i++)
        if (a == toshow[i])
        show = NAJI_TRUE;

        if (show == NAJI_TRUE)
        fputc(a, naji_output);

        }
najinclose();
najoutclose();
}



void repchar(char *namein, char *nameout, unsigned int repeat)
{
int a=0;
unsigned int i=0;

najin(namein);
najout(nameout);

repeat++;

        while (1)
        {
        a = fgetc(naji_input);
        if (a == EOF) break;

        for (i=0; i<repeat; i++)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}




void repcharp(char *namein, char *nameout, unsigned int start)
{
int a=0;
unsigned int i=0;

najin(namein);
najout(nameout);

start++;

        while (1)
        {
        a = fgetc(naji_input);
        if (a == EOF) break;

        for (i=0; i<start; i++)
        fputc(a, naji_output);

        start++;
        }

najinclose();
najoutclose();
}


void rrrchars(char *namein, char *nameout, int start, int end)
{
int a;
int i=0;

rndinit();

najin(namein);
najout(nameout);

        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF)
        break;

        for (i=0; i<rndrange(start, end); i++)
        fputc(a, naji_output);
        }

najinclose();
najoutclose();
}



void skipchar(char *namein, char *nameout, char *toskip)
{
int skip = NAJI_FALSE;
int a=0;
int i=0;
int l=0;


najin(namein);
najout(nameout);

    l = strlen(toskip);

        while (1)
        {
        a = fgetc(naji_input);
        if (a == EOF) break;
        skip = NAJI_FALSE;

        for (i=0; i<l; i++)
        if (a == toskip[i])
        skip = NAJI_TRUE;

        if (skip == NAJI_FALSE)
        fputc(a, naji_output);
        }
najinclose();
najoutclose();
}






/* reverses the file, note: this is usually not needed for */
/* right to left languages like arabic, its stored the same way as */
/* normal ascii but the software just displays it differently */
/* you might want to use this function for your own graphics or */
/* or encryption format */
void freverse(char *namein, char *nameout)
{
int a=0;
long pos;

najin(namein);
najout(nameout);

    pos = najinsize();

    while (1)
    {
    pos--;
    if (pos < 0) break;

    fseek(naji_input, pos, SEEK_SET);

    a = fgetc(naji_input);
    fputc(a, naji_output);
    }

najinclose();
najoutclose();
}




/* reverses every line in a file */
/* note: this has a bug which i should fix later */
/* the last line doesn't get reversed propally */
void revlines(char *namein, char *nameout)
{
char buffer[1000];

najin(namein);
najout(nameout);

  while (!feof(naji_input))
  {
  fgets(buffer, 990, naji_input);
  sreverse(buffer);
  fputs(buffer, naji_output);
  }

najinclose();
najoutclose();
}






void n2ch(char ch, char *namein, char *nameout)
{
int a;

najin(namein);
najout(nameout);

    while (1)
    {
    a = fgetc(naji_input);
    if (a == EOF) break;

    if (a != '\n' && a != '\r')
    fputc(a, naji_output);
    
    if (a == '\n')
    fputc(ch, naji_output);
    
    }

najinclose();
najoutclose();
}


void n2str(char *str, char *namein, char *nameout)
{
int a;

najin(namein);
najout(nameout);

    while (1)
    {
    a = fgetc(naji_input);
    if (a == EOF) break;

    if (a != '\n' && a != '\r')
    fputc(a, naji_output);
    
    if (a == '\n')
    fputs(str, naji_output);
    
    }

najinclose();
najoutclose();
}




double meters=0;
double yards=0;
double feet=0;
double inches=0;
double cm=0;
double mm=0;
double km=0;
double miles=0;






double miles_to_mm(double miles)
{
double mm=0;

mm = miles * 1609344;

return mm;
}



double mm_to_miles(double mm){

if (mm == 0)
miles = 0;

else
miles = mm / 1609344;

return miles;
}







double miles_to_cm(double miles){

cm = miles * 160934.4;

return cm;
}



double cm_to_miles(double cm){

if (cm == 0)
miles = 0;

else
miles = cm / 160934.4;

return miles;
}







double miles_to_inches(double miles){

inches = miles * 63360;

return inches;
}




double inches_to_miles(double inches){

if (inches == 0)
miles = 0;

else
miles = inches / 63360;

return miles;
}








double miles_to_feet(double miles){

feet = miles * 5280;

return feet;
}



double feet_to_miles(double feet){

if (feet == 0)
miles = 0;

else
miles = feet / 5280;

return miles;
}








double miles_to_yards(double miles){

yards = miles * 1760;

return yards;
}



double yards_to_miles(double yards){

if (yards == 0)
miles = 0;

else
miles = yards / 1760;

return miles;
}









double miles_to_meters(double miles){

meters = miles * 1609.344;

return meters;
}



double meters_to_miles(double meters){

if (meters == 0)
miles = 0;

else
miles = meters / 1609.344;

return miles;
}








double miles_to_km(double miles){

km = miles * 1.609344;

return km;
}



double km_to_miles(double km){

if (km == 0)
miles = 0;

else
miles = km / 1.609344;

return miles;
}






double km_to_yards(double km){

yards = km * 1093.613298;

return yards;
}




double yards_to_km(double yards){

if (yards == 0)
km = 0;

else
km = yards / 1093.613298;

return km;
}







double km_to_feet(double km){

feet = km * 3280.839895;

return feet;
}




double feet_to_km(double feet){

if (feet == 0)
km = 0;

else
km = feet / 3280.839895;

return km;
}







double km_to_inches(double km){

inches = km * 39370.07874;

return inches;
}



double inches_to_km(double inches){

if (inches == 0)
km = 0;

else
km = inches / 39370.07874;

return km;
}






double km_to_meters(double km){

meters = km * 1000;

return meters;
}



double meters_to_km(double meters){

if (meters == 0)
km = 0;

else
km = meters / 1000;

return km;
}






double km_to_cm(double km){

cm = km * 100000;

return cm;
}



double cm_to_km(double cm){

if (cm == 0)
km = 0;

else
km = cm / 100000;

return km;
}



double km_to_mm(double km){

mm = km * 1000000;

return mm;
}



double mm_to_km(double mm){

if (mm == 0)
km = 0;

else
km = mm / 1000000;

return km;
}




double yards_to_meters(double yards){

meters = yards * 0.9144;

return meters;
}


double meters_to_yards(double meters){

if (meters == 0)
yards = 0;

else
yards = meters / 0.9144;

return yards;
}





double yards_to_feet(double yards){

feet = yards * 3;

return feet;
}



double feet_to_yards(double feet){

if (feet == 0)
yards = 0;

else
yards = feet / 3;

return yards;
}






double yards_to_inches(double yards){

inches = yards * 36;

return inches;
}



double inches_to_yards(double inches){

if (inches == 0)
yards = 0;

else
yards = inches / 36;

return yards;
}





double yards_to_cm(double yards){

cm = yards * 91.44;

return cm;
}



double cm_to_yards(double cm){

if (cm == 0)
yards = 0;

else
yards = cm / 91.44;

return yards;
}






double yards_to_mm(double yards){

mm = yards * 914.4;

return mm;
}



double mm_to_yards(double mm){

if (mm == 0)
yards = 0;

else
yards = mm / 914.4;

return yards;
}





double meters_to_mm(double meters){

mm = meters * 1000;

return mm;
}



double mm_to_meters(double mm){

if (mm == 0)
meters = 0;

else
meters = mm / 1000;

return meters;
}



double feet_to_mm(double feet){

mm = feet * 304.8;

return mm;
}




double mm_to_feet(double mm){

if (mm == 0)
feet = 0;

else
feet = mm / 304.8;

return feet;
}





double inches_to_mm(double inches){

mm = inches * 25.4;

return mm;
}



double mm_to_inches(double mm){

if (mm == 0)
inches = 0;

else
inches = mm / 25.4;

return inches;
}



double cm_to_mm(double cm){

mm = cm * 10;

return mm;
}


double mm_to_cm(double mm){

if (mm == 0)
cm = 0;

else
cm = mm / 10;

return cm;
}







double inches_to_meters(double inches){

if (inches == 0)
meters = 0;

else
meters = inches / 39.370079;

return meters;
}



double meters_to_inches(double meters){

inches = meters * 39.370079;

return inches;
}



double feet_to_meters(double feet){

if (feet == 0)
meters = 0;

else
meters = feet / 3.28084;

return meters;
}


double meters_to_feet(double meters){

feet = meters * 3.28084;

return feet;
}





double meters_to_cm(double meters){

cm = meters * 100;

return cm;
}


double cm_to_meters(double cm){

if (cm == 0)
meters = 0;

else
meters = cm / 100;

return meters;
}





double feet_to_inches(double feet){

inches = feet * 12;

return inches;
}


double inches_to_feet(double inches){

if (inches == 0)
feet = 0;

else
feet = inches / 12;

return feet;
}






double feet_to_cm(double feet){

cm = feet * 30.48;

return cm;
}



double cm_to_feet(double cm){

if (cm == 0)
feet = 0;

else
feet = cm / 30.48;

return feet;
}







double inches_to_cm(double inches){

cm = inches * 2.54;

return cm;
}



double cm_to_inches(double cm){

if (cm == 0)
inches = 0;

else
inches = cm / 2.54;

return inches;
}



void getlinks(char *namein, char *nameout)
{
char temp[12];
int i;

najin(namein);
najout(nameout);

	temp[11] = '\0';

        for (i=0; i<10; i++)
        temp[i] = (char) fgetc(naji_input);

        while ((temp[10] = (char) fgetc(naji_input)) != EOF)
        {
        touppersn(temp, 7);

		if (!strcmp (temp, "<A HREF=\"ht") ||
		    !strcmp (temp, "<A HREF=\"ft") ||
		    !strcmp (temp, "<A HREF=\"ma"))
                    {
			fputc(temp[9], naji_output);
			fputc(temp[10], naji_output);

                        str_move_left(temp, 11);

                        while ( (temp[10] = (char) fgetc(naji_input)) != '\"')
                        {
				fputc(temp[10], naji_output);
                                str_move_left(temp, 11);
			}

			fputc('\n', naji_output);

		}

                str_move_left(temp, 11);

	}


najinclose();
najoutclose();
}


/*
Give it a start and end range, and it returns you the total of all the
numbers from start to end added up, for example, if you give a range
1 to 100, the total of all the numbers from 1 to 100 added up is 5050.
*/

int rngtotal(int start, int end)
{
int a=0;
int b=0;

 for (a=start; a<=end; a++)
 b+=a;

return b;
}



void htmlfast(char *namein, char *nameout)
{
int a;

najin(namein);
najout(nameout);


fprintf(naji_output,
"<html><head><title>%s - converted with najitool</title></head><body><pre>",
nameout);

    while (1)
    {
    a = fgetc(naji_input);
    if (a == EOF) break;

    if ( (a != '<') && (a != '>') )
    fputc(a, naji_output);

    if (a == '<')
    fprintf(naji_output, "&lt;");

    if (a == '>')
    fprintf(naji_output, "&gt;");
    }



fprintf(naji_output, "<p> <hr> This HTML page was converted with <b> najitool. </b> <br> ");
fprintf(naji_output, "From plain text to HTML with all the formating preserved. <br>");


fprintf(naji_output,
"You can get <b> najitool </b> the completely free tool at: <br> ");

fprintf(naji_output,
"<b> <a href=\"http://najitool.sf.net/\"> http://najitool.sf.net/ </a> </b> <hr> <p>");

fprintf(naji_output, "</pre> </body> </html>");

najinclose();
najoutclose();
}


/* todo: make it convert http, https, and ftp links */
/* into clicable <a href=""> </a> links */

/* note: <li> means bullet point */

void txt2html(char *namein, char *nameout)
{
int a;
int i;
int numof_tabs=4;


najin(namein);
najout(nameout);


fprintf(naji_output, 
"<html> <head> <title>%s - converted with najitool </title> </head> <body>",
 nameout);

    while(1)
    {
    a = fgetc(naji_input);
    if (a == EOF) break;

    if ( (a != '\n') && (a != '<') && (a != '>') && (a != '\t') )
    fputc(a, naji_output);
    
    if (a == '\n')
    fprintf(naji_output, "<br>\n");
    
    if (a == '<')
    fprintf(naji_output, "&lt;");

    if (a == '>')
    fprintf(naji_output, "&gt;");

    if (a == '\t')
    {
    for (i=0; i<numof_tabs; i++)
    fprintf(naji_output, "&nbsp;");
    }


    }

fprintf(naji_output,
"<p> <hr> This HTML page was converted with <b> najitool </b> from plain text to HTML. <br>");


fprintf(naji_output,
"You can get <b> najitool </b> the completely free tool at: <br> ");

fprintf(naji_output,
"<b> <a href=\"http://najitool.sf.net/\"> http://najitool.sf.net/ </a> </b> <hr> <p>");

fprintf(naji_output, "</body> </html>");

najinclose();
najoutclose();
}



void html2txt(char *namein, char *nameout)
{
int a;

najin(namein);
najout(nameout);


    while(1)
    {

    a = fgetc(naji_input);
    if (a == EOF) break;

    if (a == '<')
    {

      while (1)
      {

      a = fgetc(naji_input);
      if (a == EOF) break;

        if (a == 'p' || a == 'P')
        {

         a = fgetc(naji_input);
         if (a == EOF) break;

           if (a == '>')
           {
           fputc('\n', naji_output);
           fputc('\n', naji_output);
           break;
           }

           else
           {
           ungetc(a, naji_input);
           }

        }
        else


        if (a == 'b' || a == 'B')
        {

        a = fgetc(naji_input);
        if (a == EOF) break;


         if (a == 'r' || a == 'R')
         {
         a = fgetc(naji_input);
         if (a == EOF) break;


           if (a == '>')
           {
           fputc('\n', naji_output);
           break;
           }

           else
           {
           ungetc(a, naji_input);
           }


         }



        }
   

      if (a == '>') break;
      }

    }



    else if (a == '\n')
    {

      while (1)
      {

      a = fgetc(naji_input);
      if (a == EOF) break;

      if (a == '\n') continue;

      else
      {
      fputc(' ', naji_output);
      ungetc(a, naji_input);
      break;
      }

    }


    }




    else if (a == ' ')
    {

      while (1)
      {

      a = fgetc(naji_input);
      if (a == EOF) break;

      if (a == ' ') continue;

      else
      {
      fputc(' ', naji_output);
      ungetc(a, naji_input);
      break;
      }

    }


    }


    else
    if
    (a != '<'  &&
     a != '>'  &&
     a != '\n' &&
     a != '\r' &&
     a != ' ')
    fputc(a, naji_output);


    }



  


najinclose();
najoutclose();
}


void hilist(char *namein, char *nameout)
{
char buffer[1050];
int i;

najin(namein);
najout(nameout);


fprintf(naji_output, 
"<html>\n\n<head> <title> %s - generated with najitool </title> </head>\n\n<body>\n\n\n\n\n",
 nameout);


   while(1)
   {
   fgets(buffer, 1024, naji_input);

   if (feof(naji_input))
   break;

           for (i=0; buffer[i] != 0; i++)
           {

                if (buffer[i] == '\n')
                {
                buffer[i] = '\0';
                break;
                }

                if (buffer[i] == '\r')
                {
                buffer[i] = '\0';
                break;
                }
           }

   fprintf(naji_output, "<img src=\"%s\"><p>\n", buffer);
   }


fprintf(naji_output,
"\n\n\n\n<p>\n\n<hr> This HTML page was generated with <b> najitool </b> <br>\n");

fprintf(naji_output, "From a plain text file with a list of image names <br>\n");

fprintf(naji_output,
"You can get <b> najitool </b> the completely free tool at: <br>\n");

fprintf(naji_output,
"<b> <a href=\"http://najitool.sf.net/\"> http://najitool.sf.net/ </a> </b>\n\n<hr>\n\n<p>\n\n");

fprintf(naji_output, "\n\n\n</body>\n\n</html>\n\n");


najinclose();
najoutclose();
}




void hmakerf(char *namein, char *nameout)
{
char buffer[402];

najin(namein);
najout(nameout);

    while (1)
    {

    fgets(buffer, 400, naji_input); 

    if (feof(naji_input))
    break;

    if (!strncmp("int", buffer, 3))       fprintf(naji_output, buffer);

    if (!strncmp("FILE", buffer, 4))      fprintf(naji_output, buffer);
    if (!strncmp("void", buffer, 4))      fprintf(naji_output, buffer);
    if (!strncmp("char", buffer, 4))      fprintf(naji_output, buffer);
    if (!strncmp("long", buffer, 4))      fprintf(naji_output, buffer);
    if (!strncmp("uint", buffer, 4))      fprintf(naji_output, buffer);
    if (!strncmp("UINT", buffer, 4))      fprintf(naji_output, buffer);
    if (!strncmp("auto", buffer, 4))      fprintf(naji_output, buffer);

    if (!strncmp("uchar", buffer, 5))     fprintf(naji_output, buffer);
    if (!strncmp("ulong", buffer, 5))     fprintf(naji_output, buffer);
    if (!strncmp("UCHAR", buffer, 5))     fprintf(naji_output, buffer);
    if (!strncmp("ULONG", buffer, 5))     fprintf(naji_output, buffer);
    if (!strncmp("short", buffer, 5))     fprintf(naji_output, buffer);
    if (!strncmp("float", buffer, 5))     fprintf(naji_output, buffer);
    if (!strncmp("class", buffer, 5))     fprintf(naji_output, buffer);
    if (!strncmp("union", buffer, 5))     fprintf(naji_output, buffer);
    if (!strncmp("const", buffer, 5))     fprintf(naji_output, buffer);

    if (!strncmp("double", buffer, 6))    fprintf(naji_output, buffer);
    if (!strncmp("struct", buffer, 6))    fprintf(naji_output, buffer);
    if (!strncmp("signed", buffer, 6))    fprintf(naji_output, buffer);
    if (!strncmp("static", buffer, 6))    fprintf(naji_output, buffer);
    if (!strncmp("extern", buffer, 6))    fprintf(naji_output, buffer);
    if (!strncmp("size_t", buffer, 6))    fprintf(naji_output, buffer);
    if (!strncmp("time_t", buffer, 6))    fprintf(naji_output, buffer);

    if (!strncmp("wchar_t", buffer, 7))   fprintf(naji_output, buffer);
    if (!strncmp("typedef", buffer, 7))   fprintf(naji_output, buffer);

    if (!strncmp("unsigned", buffer, 8))  fprintf(naji_output, buffer);
    if (!strncmp("register", buffer, 8))  fprintf(naji_output, buffer);
    if (!strncmp("volatile", buffer, 8))  fprintf(naji_output, buffer);
    if (!strncmp("#include", buffer, 8))  fprintf(naji_output, buffer);
    }

najinclose();
najoutclose();
}


void makarray(char *namein, char *nameout, char *namevar)
{
/* Don't worry, the memory taken up by variables in functions
 * are freed when the function ends, in case you didn't know.
 */
   char buffer[1050];

int i;

najin(namein);
najout(nameout);


 fprintf(naji_output, "char *%s[] = {\n", namevar);

   while(1)
   {
   fgets(buffer, 1024, naji_input);

   if (feof(naji_input))
   break;

           for (i=0; buffer[i] != 0; i++)
           {

                if (buffer[i] == '\n')
                {
                buffer[i] = '\0';
                break;
                }

                if (buffer[i] == '\r')
                {
                buffer[i] = '\0';
                break;
                }
           }

   fprintf(naji_output, "\"%s\",\n", buffer);
   }

   najinclose();
   najoutclose();

   najed(nameout);
   fseek(naji_edit, -2, SEEK_END);
   fprintf(naji_edit, "\n};\n");
   najedclose();

}









void printftx(char *namein, char *nameout)
{
char buffer[1050];

int i;

najin(namein);
najout(nameout);



   while(1)
   {
   fgets(buffer, 1024, naji_input);

   if (feof(naji_input))
   break;

           for (i=0; buffer[i] != 0; i++)
           {

                if (buffer[i] == '\n')
                {
                buffer[i] = '\0';
                break;
                }

                if (buffer[i] == '\r')
                {
                buffer[i] = '\0';
                break;
                }
           }

   fprintf(naji_output, "printf(\"");



       for (i=0; buffer[i] != 0; i++)
       {

           if (buffer[i] == '\"')
           {
           fputc('\\', naji_output);
           fputc('\"', naji_output);
           }

           else if (buffer[i] == '\\')
           {
           fputc('\\', naji_output);
           fputc('\\', naji_output);
           }

       else
       fputc(buffer[i], naji_output);
       }

   fprintf(naji_output, "\\n\");\n");
   }


   najinclose();
   najoutclose();
}


/* bblensorts    */
/* bblensortl    */
/* readforsort   */
/* writesorted   */
/* lensort_basis */

/* Made by MANUEL LE BOETTE */



/*
        Sort lines by length.

        - Scan input file to count the lines.
        - Allocate (12 * lines) bytes of memory.
        - Re-scan input file to store line lengths and positions.
        - Sort by length (either shortest or longest first).
        - Copy input file to output file using line refs.

        * NOTE: Can process both UNIX and Windows text files.

*/



void bblensorts(FILE * sourcefile, FILE * destfile,
struct najiline *plines, struct najiline *plineend)
{

struct najiline *pline, buffer;
int sortflag;

  do
  {

    pline = plines;
    sortflag = 0;

    while (pline < plineend)
    {
      if ((pline->len) > ((pline + 1)->len))
      {
        buffer = *pline;
        *pline = *(pline + 1);
        *(pline + 1) = buffer;
        sortflag = 1;
      }

      pline++;
    }

  } while (sortflag != 0);


}



void bblensortl(FILE * sourcefile, FILE * destfile,
struct najiline *plines, struct najiline *plineend)
{
struct najiline *pline, buffer;
int sortflag;

  do
  {


    pline = plines;
    sortflag = 0;


    while (pline < plineend)
    {

      if ((pline->len) < ((pline + 1)->len))
      {
        buffer = *pline;
        *pline = *(pline + 1);
        *(pline + 1) = buffer;
        sortflag = 1;
      }
      pline++;

    }



  } while (sortflag != 0);


}




int readforsort(FILE * sourcefile, FILE * destfile,
struct najiline **pplines, struct najiline **pplineend, char *lastchar)
{
struct najiline line, *pline, *plines;
char current;
char previous = ' ';
int linecharnb = 0;
int linenb = 0;
int lflong = 1;

long filecharnb = 0;

  while ((current = (char) fgetc(sourcefile)) != EOF)
  {

    linecharnb++;
    filecharnb++;

    if (current == '\n')
    {
      if (previous == '\r')
      lflong = 2;

      linenb++;
      linecharnb = 0;
    }

    previous = current;
  }

  if (linecharnb > 0)
  {
    *lastchar = '0';
    linenb++;
  }

  else *lastchar = '\n';

  if (filecharnb > 0)
  linenb++;

  plines = malloc(sizeof(line) * linenb);

  if (pline == NULL)
  {

    fprintf(stderr, "Error allocating %d bytes of memory.",
    sizeof(line) * linenb);

    return -1;
  }

  rewind(sourcefile);
  pline = plines - 1;
  linecharnb = 0;
  filecharnb = 0;

  while ((current = (char) fgetc(sourcefile)) != EOF)
  {
    linecharnb++;

    if (current == '\n')
    {
      pline++;
      pline->len = linecharnb - lflong;
      pline->pos = filecharnb;
      filecharnb += (long) linecharnb;
      linecharnb = 0;
    }

  }

  if (linecharnb > 0)
  {
    pline++;
    pline->len = linecharnb;
    pline->pos = filecharnb;
  }


*pplineend = pline;
*pplines = plines;

return lflong;
}



void writesorted(FILE *sourcefile, FILE *destfile, struct najiline *plines,
struct najiline *plineend, int lflong, char lastchar)
{
struct najiline *pline;
char current;
int i;
char cr = '\r';
char lf = '\n';

  pline = plines;

  for (pline = plines; pline <= plineend; pline++)
  {

    fseek(sourcefile, pline->pos, SEEK_SET);


    for (i=0; i < pline->len; i++)
    {
      fread(&current, 1, 1, sourcefile);
      fwrite(&current, 1, 1, destfile);
    }


    if ((pline < plineend) || (lastchar == '\n'))
    {
      if (lflong == 2)
      fwrite(&cr, 1, 1, destfile);

      fwrite(&lf, 1, 1, destfile);
    }


  }

fclose(sourcefile);
fclose(destfile);
}



void lensort_basis(char whichone, char *namein, char *nameout)
{
struct najiline *plines, *plineend;
int lflong;
char lastchar;

  najin(namein);
  najout(nameout);

  lflong =
  readforsort(naji_input, naji_output, &plines, &plineend, &lastchar);

  if (whichone == 's')
  bblensorts(naji_input, naji_output, plines, plineend);

  else
  bblensortl(naji_input, naji_output, plines, plineend);

  writesorted(naji_input, naji_output, plines, plineend, lflong, lastchar);

free(plines);
}



void lensorts(char *namein, char *nameout)
{
lensort_basis('s', namein, nameout);
}


void lensortl(char *namein, char *nameout)
{
lensort_basis('l', namein, nameout);
}



FILE *naji_bmp_out;

#define naji_bmp_size (640 * 480)

void naji_bmpheader(void)
{
int a=0;
int i=0;

/* BM header */
fputc('B', naji_bmp_out);
fputc('M', naji_bmp_out);

/* file size */
a = ((640 * 480) + 54);

fputc(a, naji_bmp_out);
fputc(a >> 8, naji_bmp_out);
fputc(a >> 16, naji_bmp_out);
fputc(a >> 24, naji_bmp_out);

/* other things; which are ok to set to zero */
for (i=0; i<4; i++)
fputc(0, naji_bmp_out);

/* write the offset for the actual bmp data */
fputc(54, naji_bmp_out);
fputc(0,naji_bmp_out);
fputc(0,naji_bmp_out);
fputc(0,naji_bmp_out);

/* bmp file info header */
fputc(40,naji_bmp_out);
fputc(0,naji_bmp_out);
fputc(0,naji_bmp_out);
fputc(0,naji_bmp_out);


fputc(0x80,naji_bmp_out);
fputc(0x2,naji_bmp_out);
fputc(0,naji_bmp_out);
fputc(0,naji_bmp_out);


fputc(0xe0,naji_bmp_out);
fputc(0x1,naji_bmp_out);
fputc(0,naji_bmp_out);
fputc(0,naji_bmp_out);

fputc(1,naji_bmp_out);
fputc(0,naji_bmp_out);

fputc(8,naji_bmp_out);

/* other things; which are ok to set to zero */
for (i=0; i<=25; i++)
fputc(0,naji_bmp_out);

return;
}


void bmpout(char *nameout)
{
char bmpout_buffer[4082];


        naji_bmp_out = fopen(nameout, "wb");

        if (naji_bmp_out == NULL)
        {
        
        sprintf(bmpout_buffer, "Error making file %s", nameout);
        msgbox("najitool GUI naji_bmp error", bmpout_buffer);
        exit(1);
        }

        naji_bmpheader();

}

void bmpoutclose(void)
{
fclose(naji_bmp_out);
}


void naji_bmp(char *folder_path)
{
int a;
int b;
int c;

int i;
int x;


char filename[4082];


        srand(time(NULL));

        sprintf(filename, "%s/rndpixel.bmp", folder_path);
        bmpout(filename);
        for (i=0; i<=3000000; i++)
        {
        a = rand() % 255;
        fputc(a, naji_bmp_out);
        }
        bmpoutclose();

        sprintf(filename, "%s/matches.bmp", folder_path);
	     bmpout(filename);
        for (a=0; a<1000; a++)
        for (b=0; b<1000; b++)
        fputc(a+b, naji_bmp_out);
        bmpoutclose();

        sprintf(filename, "%s/lightnin.bmp", folder_path);
	     bmpout(filename);
        for (a=0; a<150; a++)
        for (b=0; b<150; b++)
        for (c=0; c<150; c++)
        fputc(a+b-c, naji_bmp_out);
        bmpoutclose();

        sprintf(filename, "%s/marble.bmp", folder_path);
	     bmpout(filename);
        for (a=0; a<150; a++)
        for (b=0; b<130; b++)
        for (c=0; c<120; c++)
        fputc(a-b+c, naji_bmp_out);
        bmpoutclose();

        sprintf(filename, "%s/metal.bmp", folder_path);
	     bmpout(filename);
        for (a=0; a<150; a++)
        for (b=0; b<130; b++)
        for (c=0; c<120; c++)
        fputc(a+b+c, naji_bmp_out);
        bmpoutclose();

        sprintf(filename, "%s/roads.bmp", folder_path);
	     bmpout(filename);
        for (a=0; a<50; a++)
        for (b=0; b<110; b++)
        for (c=0; c<112; c++)
        fputc(a-b+c, naji_bmp_out);
        bmpoutclose();

        sprintf(filename, "%s/rinoskin.bmp", folder_path);
	     bmpout(filename);
        for (a=1; a<100; a++)
        for (b=1; b<100; b++)
        for (c=1; c<100; c++)
        {
        fputc(a*b+c, naji_bmp_out);
        }
        bmpoutclose();


        sprintf(filename, "%s/waves.bmp", folder_path);
	     bmpout(filename);
        for (a=10; a<100; a++)
        for (b=10; b<100; b++)
        for (c=10; c<100; c++)
        {
        fputc(cos(a)+b+c*PI, naji_bmp_out);
        }
        bmpoutclose();


        sprintf(filename, "%s/waves2.bmp", folder_path);
	     bmpout(filename);
        for (a=10; a<100; a++)
        for (b=10; b<100; b++)
        for (c=10; c<100; c++)
        {
        fputc(tan(a)+b+c*PI, naji_bmp_out);
        }
        bmpoutclose();


        sprintf(filename, "%s/zigzag.bmp", folder_path);
	     bmpout(filename);
        for (a=10; a<100; a++)
        for (b=10; b<100; b++)
        for (c=10; c<100; c++)
        {
        fputc(cos(a)+b-c*PI, naji_bmp_out);
        }
        bmpoutclose();





        sprintf(filename, "%s/rustneed.bmp", folder_path);
	     bmpout(filename);
        c=0;
        for (a=0; a<50000; a++)
        {
        for (b=0; b<8; b++)
        fputc(c, naji_bmp_out);

        c++;
        }
        bmpoutclose();



        sprintf(filename, "%s/needle2.bmp", folder_path);
	     bmpout(filename);
        c=0;
        for (a=0; a<50000; a++)
        {
        for (b=0; b<=8; b++)
        fputc(c, naji_bmp_out);

        c++;
        }
        bmpoutclose();


        sprintf(filename, "%s/needle.bmp", folder_path);
	     bmpout(filename);
        c=0;
        for (a=0; a<60000; a++)
        {
        for (b=0; b<6; b++)
        fputc(c, naji_bmp_out);

        c++;
        }
        bmpoutclose();


        sprintf(filename, "%s/nice1.bmp", folder_path);
	     bmpout(filename);
        b=0;
        for (x=0; x<=200; x++)
        for (a=255; a>=0; a--)
        {

        fputc(b, naji_bmp_out);

        for (i=0; i<8; i++)
        fputc(a, naji_bmp_out);

        b++;
        }
        bmpoutclose();




        sprintf(filename, "%s/nice2.bmp", folder_path);
	     bmpout(filename);
        b=0;
        for (x=0; x<=200; x++)
        for (a=255; a>=0; a--)
        {

        fputc(b, naji_bmp_out);
        fputc(b, naji_bmp_out);

        for (i=0; i<7; i++)
        fputc(a, naji_bmp_out);

        b++;
        }
        bmpoutclose();



        sprintf(filename, "%s/nice3.bmp", folder_path);
	     bmpout(filename);
        b=0;
        for (x=0; x<=200; x++)
        for (a=255; a>=0; a--)
        {

        fputc(a, naji_bmp_out);

        fputc(b, naji_bmp_out);

        for (i=0; i<7; i++)
        fputc(a, naji_bmp_out);

        b++;
        }
        bmpoutclose();




        sprintf(filename, "%s/nice4.bmp", folder_path);
	     bmpout(filename);
        b=0;
        for (x=0; x<=200; x++)
        for (a=255; a>=0; a--)
        {

        fputc(a, naji_bmp_out);

        fputc(b, naji_bmp_out);

        for (i=0; i<4; i++)
        fputc(a, naji_bmp_out);

        fputc(b, naji_bmp_out);

        fputc(a, naji_bmp_out);
        fputc(a, naji_bmp_out);

        b++;
        }
        bmpoutclose();



        sprintf(filename, "%s/nice5.bmp", folder_path);
	     bmpout(filename);
        b=0;
        for (x=0; x<=200; x++)
        for (a=255; a>=0; a--)
        {

        fputc(a, naji_bmp_out);

        fputc(b, naji_bmp_out);

        fputc(a, naji_bmp_out);
        fputc(a, naji_bmp_out);

        fputc(b, naji_bmp_out);

        fputc(a, naji_bmp_out);

        fputc(b, naji_bmp_out);

        fputc(a, naji_bmp_out);
        fputc(a, naji_bmp_out);


        b++;
        }
        bmpoutclose();



        sprintf(filename, "%s/blueblak.bmp", folder_path);
        bmpout(filename);
        b=255;
        for (x=0; x<=200; x++)
        for (a=0; a<=255; a++)
        {


        for (i=0; i<7; i++)
        fputc(a, naji_bmp_out);

        fputc(b, naji_bmp_out);

        b--;
        }
        bmpoutclose();


        sprintf(filename, "%s/pinkwite.bmp", folder_path);
	     bmpout(filename);
        b=0;
        for (x=0; x<=200; x++)
        for (a=255; a>=0; a--)
        {

        fputc(b, naji_bmp_out);

        for (i=0; i<7; i++)
        fputc(a, naji_bmp_out);

        b++;
        }
        bmpoutclose();


        sprintf(filename, "%s/cyanblak.bmp", folder_path);
        bmpout(filename);
        b=255;
        for (x=0; x<=200; x++)
        for (a=0; a<=255; a++)
        {


        fputc(b, naji_bmp_out);

        for (i=0; i<6; i++)
        fputc(a, naji_bmp_out);

        fputc(b, naji_bmp_out);

        b--;
        }
        bmpoutclose();



        sprintf(filename, "%s/erfquake.bmp", folder_path);
	     bmpout(filename);
        c=0;
        for (a=0; a<120000; a++)
        {
        for (b=0; b<3; b++)
        fputc(c, naji_bmp_out);

        c++;
        }
        bmpoutclose();


        sprintf(filename, "%s/carpet1.bmp", folder_path);
        bmpout(filename);
        for (a=0; a<5000; a++)
        {
        fputc(0,  naji_bmp_out);
        fputc(75, naji_bmp_out);
        fputc(0,  naji_bmp_out);
        fputc(75, naji_bmp_out);
        fputc(0,  naji_bmp_out);
        fputc(37, naji_bmp_out);
        fputc(0,  naji_bmp_out);
        fputc(150,naji_bmp_out);
        fputc(0,  naji_bmp_out);
        fputc(18, naji_bmp_out);
        fputc(0,  naji_bmp_out);
        fputc(44, naji_bmp_out);
        fputc(0,  naji_bmp_out);
        fputc(9,  naji_bmp_out);
        fputc(0,  naji_bmp_out);
        fputc(88, naji_bmp_out);
        fputc(0,  naji_bmp_out);
        fputc(4,  naji_bmp_out);
        fputc(0,  naji_bmp_out);
        fputc(176,naji_bmp_out);
        fputc(0,  naji_bmp_out);
        fputc(2,  naji_bmp_out);
        fputc(0,  naji_bmp_out);
        fputc(96, naji_bmp_out);
        fputc(0,  naji_bmp_out);
        fputc(1,  naji_bmp_out);
        fputc(0,  naji_bmp_out);
        fputc(192,naji_bmp_out);
        fputc(0,  naji_bmp_out);
        fputc(0,  naji_bmp_out);
        fputc(0,  naji_bmp_out);
        fputc(128,naji_bmp_out);

        for (i=0; i<96; i++)
        fputc(0,  naji_bmp_out);

        }
        bmpoutclose();

        sprintf(filename, "%s/pipes.bmp", folder_path);
	     bmpout(filename);
        for (i=0; i<=3000000; i++)
        {
        fputc(i, naji_bmp_out);
        }
        bmpoutclose();



        sprintf(filename, "%s/diagpipe.bmp", folder_path);
        bmpout(filename);
        for (i=0; i<=255; i++)
        {


        for (a=0; a<=255; a++)
        for (b=0; b<=255; b++)
        fputc(a+b, naji_bmp_out);
        }
        bmpoutclose();


        sprintf(filename, "%s/coolgren.bmp", folder_path);
	     bmpout(filename);
        for (i=0; i<=1500000; i++)
        {
        fputc(i, naji_bmp_out);
        fputc(0, naji_bmp_out);
        }
        bmpoutclose();

        sprintf(filename, "%s/lines1.bmp", folder_path);
	     bmpout(filename);
        for (i=0; i<=1500000; i++)
        {
        fputc(i, naji_bmp_out);

        for (a=0; a<=3; a++)
        fputc(a, naji_bmp_out);

        }
        bmpoutclose();



        sprintf(filename, "%s/rainbow.bmp", folder_path);
	     bmpout(filename);
        for (i=0; i<=150000; i++)
        {


	     for (a=0; a<=255; a++)
	     fputc(((a*a)*PI), naji_bmp_out);

        }
        bmpoutclose();



        sprintf(filename, "%s/fuzypipe.bmp", folder_path);
	     bmpout(filename);
        for (i=0; i<=150000; i++)
        {


        for (a=0; a<=255; a++)
	     fputc((a*PI), naji_bmp_out);

        }
        bmpoutclose();



        sprintf(filename, "%s/rdpplpnk.bmp", folder_path);
	     bmpout(filename);
	     for (i=0; i<20; i++)
	     {

        for (a=0; a<=255; a++)
	     for (b=0; b<=255; b++)
	     {
	     fputc(((a*a)*PI), naji_bmp_out);
	     fputc(((b*b)*PI), naji_bmp_out);
	     }

	} 

   bmpoutclose();


}

void qcrypt(char *namein, char *nameout)
{
int i=0;
int c;

najin(namein);
najout(nameout);

    while ( (c = getc(naji_input)) != EOF )
    putc((char) (((char) c) ^ (128 | (i++ & 127))), naji_output);

najinclose();
najoutclose();
}


void charsort(char *namein, char *nameout)
{
unsigned long charsort_buf[256];

int i=0;
int a=0;
int b=0;

        for (a=0; a<256; a++)
        charsort_buf[a] = 0;

   najin(namein);
	najout(nameout);


        while (!(feof(naji_input)))
        {
        i = fgetc(naji_input);
        charsort_buf[i]++;
        }
	
	
	
        
        for (a=0; a<256; a++)
	for (b=0; b<charsort_buf[a]; b++)
        fputc(a, naji_output);


najinclose();
najoutclose();
}


void lcvfiles(char *namein, char *output_folder)
{
long cvlen;
char *cva;
char *cvb;

int x;
int y;
int z;

int a;

long i=0;
char buffer[2048];
char namein2[4096];

long filecount=0;



        najin(namein);
 
 GetLastDirectory(namein, namein2);

        cvlen = najinsize();

        cva = newchar(cvlen);
        cvb = newchar(cvlen);
        exitnull(cva);
        exitnull(cvb);

        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF) break;

        cva[i] = (char)a;
        i++;
        }

        najinclose();


        for (x=0; x<cvlen; x++)
        cvb[x] = (char)x;
  
        cvb[cvlen] = (char)cvlen;





	sprintf(buffer, "%s/lcv%u-%s", output_folder, filecount, namein2);
	najout(buffer);
	filecount++;




        for (z=0; z<cvlen; z++)
        fputc(cva[z], naji_output);

	najoutclose();

        x=1;

        while (x < cvlen)
        {
        cvb[x]--;
        y=0;

                while (y < x)
                {
                swap_char(cva[x], cva[y]);
                y++;
                x--;
                }

                sprintf(buffer, "%s/lcv%u-%s", output_folder, filecount, namein2);
                najout(buffer);
                filecount++;


	        for (z=0; z<cvlen; z++)
	        fputc(cva[z], naji_output);

                najoutclose();

	        x=1;

                while (cvb[x] == 0)
                {
                cvb[x]=(char)x;
                x++;
                }

        }



}

void rcvfiles(char *namein, char *output_folder)
{
int a;
int c;
int x;
int y;
int z;
long cvlen;
char *cva;
char *cvb;



long i=0;
char buffer[2048];
char namein2[4096];

long filecount=0;   


        najin(namein);

 GetLastDirectory(namein, namein2);

        cvlen = najinsize();

        c = cvlen-1;

        cva = newchar(cvlen);
        cvb = newchar(cvlen);
        exitnull(cva);
        exitnull(cvb);


        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF) break;

        cva[i] = (char)a;
        i++;
        }

        najinclose();     


	sprintf(buffer, "%s/rcv%u-%s", output_folder, filecount, namein2);
	najout(buffer);
	filecount++;

        for(x=0; x<cvlen; x++)
        cvb[x]=(char)cvlen-(char)x;

        for (z=0; z<cvlen; z++)
        fputc(cva[z], naji_output);

	najoutclose();


        x=c;

        while (x > 0)
        {
        cvb[x]--;
        x--;
        y=c;

                while (y > x)
                {
                swap_char(cva[x], cva[y]);
                y--;
                x++;
                }

                sprintf(buffer, "%s/rcv%u-%s", output_folder, filecount, namein2);
                najout(buffer);
                filecount++;      


	        for (z=0; z<cvlen; z++)
	        fputc(cva[z], naji_output);

	        najoutclose();


	        x=c;

                while (cvb[x] == 0)
                {
                cvb[x] = (char)cvlen-(char)x;
                x--;
                }

        }

}






unsigned char allbmp16_header_array[118] =
{
0x42,0x4D,0xF6,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x76,0x00,0x00,0x00,0x28,
0x00,0x00,0x00,0x10,0x00,0x00,0x00,0x10,0x00,0x00,0x00,0x01,0x00,0x04,0x00,
0x00,0x00,0x00,0x00,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x80,0x00,0x00,0x80,0x00,0x00,0x00,0x80,0x80,0x00,0x80,0x00,0x00,0x00,0x80,
0x00,0x80,0x00,0x80,0x80,0x00,0x00,0x80,0x80,0x80,0x00,0xC0,0xC0,0xC0,0x00,
0x00,0x00,0xFF,0x00,0x00,0xFF,0x00,0x00,0x00,0xFF,0xFF,0x00,0xFF,0x00,0x00,
0x00,0xFF,0x00,0xFF,0x00,0xFF,0xFF,0x00,0x00,0xFF,0xFF,0xFF,0x00};


#define allbmp16_write_header()\
for (i=0; i<118; i++)\
fputc(allbmp16_header_array[i], naji_output);\




void allbmp16(char *output_folder)
{
int i;
int ii;
unsigned char *buffer;

int x=0;
FILE *naji_output_a;
char filename[100];
char allbmp16_err_buf[4096];

int size = 128;

    buffer = (unsigned char *) malloc( (size) * ( sizeof(unsigned char) ) );

    if (buffer == NULL)
    {
    sprintf(allbmp16_err_buf, "Error, could not allocate %i bytes of memory.", size);
    msgbox("najitool GUI allbmp16 error", allbmp16_err_buf);
    exit(9);
    }

    for (i=0; i<=size; i++)
    buffer[i] = (unsigned char) 0;

    while (*buffer <= 0)
    {

        for (i=0; i<=255; i++)
        {
        buffer[size] = (unsigned char) i;

        sprintf(filename, "%s/%i.bmp", output_folder, x);
        naji_output_a = fopen(filename, "wb");
        if (naji_output_a == NULL)
        {
        sprintf(allbmp16_err_buf, "Error opening file %s : ", filename, strerror(errno));
        msgbox("najitool GUI allbmp16 error", allbmp16_err_buf);
        exit(1);
        }


        for (ii=0; ii<118; ii++)
        fputc(allbmp16_header_array[ii], naji_output_a);


        for (ii=1; ii<=size; ii++)
        fputc(buffer[ii], naji_output_a);

        fclose(naji_output_a);
//        printf("Written file: %s\n", filename);
        x++;
        }

        if (buffer[size] >= 255)
        {
        buffer[size] = (unsigned char) 0;
        buffer[size-1]++;
        }

                for (i = (size-1); i >= 0; i--)
                {
                        if (buffer[i] >= 255)
                        {
                        buffer[i] = (unsigned char) 0;
                        buffer[i-1]++;
                        }
                }

        } /* end of while loop */

return;
}



unsigned char hex2bin(unsigned char l, unsigned char r)
{
unsigned char result = 0;



	switch (l)
	{
        case '0': result += 0;   break;
        case '1': result += 16;  break;
        case '2': result += 32;  break;
        case '3': result += 48;  break;
        case '4': result += 64;  break;
        case '5': result += 80;  break;
        case '6': result += 96;  break;
        case '7': result += 112; break;
        case '8': result += 128; break;
        case '9': result += 144; break;

        case 'A': result += 160; break;
        case 'B': result += 176; break;
        case 'C': result += 192; break;
        case 'D': result += 208; break;
        case 'E': result += 224; break;
        case 'F': result += 240; break;

        case 'a': result += 160; break;
        case 'b': result += 176; break;
        case 'c': result += 192; break;
        case 'd': result += 208; break;
        case 'e': result += 224; break;
        case 'f': result += 240; break;


	}

	switch (r)
	{
        case '0': result += 0; break;
        case '1': result += 1; break;
        case '2': result += 2; break;
        case '3': result += 3; break;
        case '4': result += 4; break;
        case '5': result += 5; break;
        case '6': result += 6; break;
        case '7': result += 7; break;
        case '8': result += 8; break;
        case '9': result += 9; break;

        case 'A': result += 10; break;
        case 'B': result += 11; break;
        case 'C': result += 12; break;
        case 'D': result += 13; break;
        case 'E': result += 14; break;
        case 'F': result += 15; break;

        case 'a': result += 10; break;
        case 'b': result += 11; break;
        case 'c': result += 12; break;
        case 'd': result += 13; break;
        case 'e': result += 14; break;
        case 'f': result += 15; break;
	}



return result;
}
