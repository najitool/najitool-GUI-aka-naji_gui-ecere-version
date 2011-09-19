/* ----------- */
/* najascii.ec */
/* ----------- */

/* naji ASCII functions, such as very big text    */
/* my ASCII Art Letter's written from scratch     */
/* a reminder: this is all absolutely free and    */
/* public domain, so have some fun.               */

/* if you want to contribute your own letters  */
/* please message my sourceforge username naji */

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

use atoi for naji_ascii_number, and also byte2hex to do naji_ascii_hexi
*/

#ifdef ECERE_STATIC
import static "ecere"
#else
import "ecere"
#endif
import "najicomm"
import "najicmds"
import "naji_ttt"
import "najicalc"
import "najihelp"
import "najiform"
#include "naji_gui.eh"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char * naji_[6] = 
{
"            ",
"            ",
"            ",
"            ",
"            ",
"            ",
};


char * naji_a[6] = 
{
"    ____    ",
"   / __ \\   ",
"  | |  | |  ",
"  | |__| |  ",
"  |  __  |  ",
"  |_|  |_|  ",
};

char * naji_b[6] = 
{
"   _____   ",
"  |  _  |  ",
"  | |_| /  ",
"  |  _  \\  ",
"  | |_| |  ",
"  |_____|  ",
};

char * naji_c[6] = 
{
"   _____   ",
"  |  ___|  ",
"  | |      ",
"  | |      ",
"  | |___   ",
"  |_____|  ",
};

char * naji_d[6] = 
{
"   ____     ",
"  |     \\   ",
"  | |~\\  |  ",
"  | |  | |  ",
"  | |_/  |  ",
"  |_____/   ",
};

char * naji_e[6] = 
{
"   _____   ",
"  |  ___|  ",
"  | |___   ",
"  |  ___|  ",
"  | |___   ",
"  |_____|  ",
};

char * naji_f[6] = 
{
"   _____   ",
"  |   __|  ",
"  |  |__   ",
"  |   __|  ",
"  |  |     ",
"  |__|     ",
};

char * naji_g[6] = 
{
"   ______   ",
"  /  __  \\  ",
"  | |  |_|  ",
"  | |  __   ",
"  | |__\\ |  ",
"  |_____/   ",
};

char * naji_h[6] = 
{
"   _    _   ",
"  | |  | |  ",
"  | |__| |  ",
"  |  __  |  ",
"  | |  | |  ",
"  |_|  |_|  ",
};

char * naji_i[6] = 
{
"     __     ",
"    |  |    ",
"    |  |    ",
"    |  |    ",
"    |  |    ",
"    |__|    ",
};

char * naji_j[6] = 
{
"       __   ",
"      |  |  ",
"      |  |  ",
"  ___ |  |  ",
"  | |_|  |  ",
"  \\______|  ",
};

char * naji_k[6] = 
{
"   __  ___  ",
"  |  |/  /  ",
"  |    _/   ",
"  |   /__   ",
"  |   _  \\  ",
"  |__| \\__\\ ",
};

char * naji_l[6] = 
{
"    __       ",
"   |  |      ",
"   |  |      ",
"   |  |      ",
"   |  |___   ",
"   |______|  ",
};

char * naji_m[6] = 
{
"  _      _  ",
" | \\    / | ",
" |  \\__/  | ",
" |        | ",
" |  /\\/\\  | ",
" |_|    |_| ",
};

char * naji_n[6] = 
{
"   _    _   ",
"  | \\  | |  ",
"  |  \\_| |  ",
"  |      |  ",
"  | |\\   |  ",
"  |_| \\__|  ",
};

char * naji_o[6] = 
{
"   ______   ",
"  |      |  ",
"  | |~~| |  ",
"  | |  | |  ",
"  | |__| |  ",
"  |______|  ",
};

char * naji_p[6] = 
{
"   ______   ",
"  |      |  ",
"  | |~~| |  ",
"  | ~~~~ |  ",
"  | |~~~~   ",
"  |_|       ",
};

char * naji_q[6] = 
{
"   ______   ",
"  |      |  ",
"  | |~~| |  ",
"  | | _| |  ",
"  | |_\\ \\|  ",
"  |____\\_\\  ",
};

char * naji_r[6] = 
{
"   ______   ",
"  |      |  ",
"  | |~~| |  ",
"  | ~~~~ |  ",
"  | |~\\ \\~  ",
"  |_|  \\_\\  ",
};

char * naji_s[6] = 
{
"    _____   ",
"   /  __ \\  ",
"   \\  \\ \\/  ",
" /\\ \\  \\    ",
" \\ \\_\\  \\   ",
"  \\_____/   ",
};

char * naji_t[6] = 
{
"   ______   ",
"  |_    _|  ",
"    |  |    ",
"    |  |    ",
"    |  |    ",
"    |__|    ",
};

char * naji_u[6] = 
{
"   _    _   ",
"  | |  | |  ",
"  | |  | |  ",
"  | |  | |  ",
"  | |__| |  ",
"  |______|  ",
};

char * naji_v[6] = 
{
"   _     _  ",
"  | |   | | ",
"  | |   | | ",
"  \\ \\   / / ",
"   \\ \\_/ /  ",
"    \\___/   ",
};

char * naji_w[6] = 
{
"  _      _  ",
" | |    | | ",
" | |    | | ",
" | | /\\ | | ",
" | \\/  \\/ | ",
"  \\__/\\__/  ",
};

char * naji_x[6] = 
{
"   __   __  ",
"   \\ \\_/ /  ",
"    \\   /   ",
"     | |    ",
"    / _ \\   ",
"   /_/ \\_\\  ",
};

char * naji_y[6] = 
{
"   __   __  ",
"   \\ \\_/ /  ",
"    \\   /   ",
"     | |    ",
"     | |    ",
"     |_|    ",
};

char * naji_z[6] = 
{
"    _____   ",
"   |___  |  ",
"      / /   ",
"     / /    ",
"    / /__   ",
"   /_____|  ",
};

char * naji_1[6] = 
{
"    /~~|    ",
"  /_   |    ",
"    |  |    ",
"    |  |    ",
"   _|  |_   ",
"  |______|  ",
};

char * naji_2[6] = 
{
"   _____    ",
"  /     \\   ",
" |_/~\\   \\  ",
"     /  /   ",
"   /  /___  ",
"  |_______| ",
};

char * naji_3[6] = 
{
"   ______   ",
"  |___   \\  ",
"    __|  /  ",
"   <__  <   ",
"   ___|  \\  ",
"  |______/  ",
};

char * naji_4[6] = 
{
"     /~~|   ",
"    /   |   ",
"   / /| |   ",
"  / /_| |_  ",
" /____   _| ",
"      |_|   ",
};

char * naji_5[6] = 
{
"   ______   ",
"  |  ____|  ",
"  | |____   ",
"  |____  |  ",
"   ____| |  ",
"  |______|  ",
};

char * naji_6[6] = 
{
"    _____   ",
"   / ____|  ",
"  | |____   ",
"  |  __  |  ",
"  | |__| |  ",
"   \\____/   ",
};

char * naji_7[6] = 
{
"   ______   ",
"  |___   |  ",
"     /  /   ",
"    /  /    ",
"   /  /     ",
"  /__/      ",
};

char * naji_8[6] = 
{
"    _____   ",
"   / ___ \\  ",
"  | |__| |  ",
"   > __ <   ",
"  | |__| |  ",
"   \\____/   ",
};

char * naji_9[6] = 
{
"    _____   ",
"   / ___ \\  ",
"  | |__| |  ",
"   \\ __  |  ",
"   ____| |  ",
"   \\____/   ",
};

char * naji_0[6] = 
{
"    _____   ",
"   / ___ \\  ",
"  | |  | |  ",
"  | |  | |  ",
"  | |__| |  ",
"   \\____/   ",
};

char * naji_ascii_coma[6] = 
{
"            ",
"            ",
"            ",
"     ___    ",
"    |   |   ",
"   /___/    ",
};

char * naji_ascii_aposopen[6] = 
{
"    ___     ",
"   |   |    ",
"    \\___\\   ",
"            ",
"            ",
"            ",
};

char * naji_ascii_aposclose[6] = 
{
"     ___    ",
"    |   |   ",
"   /___/    ",
"            ",
"            ",
"            ",
};

char * naji_ascii_period[6] = 
{
"            ",
"            ",
"            ",
"    ____    ",
"   |    |   ",
"   |____|   ",
};

char * naji_ascii_colon[6] = 
{
"    ____    ",
"   |    |   ",
"   |____|   ",
"    ____    ",
"   |    |   ",
"   |____|   ",
};

char * naji_ascii_semicolon[6] = 
{
"     ___    ",
"    |   |   ",
"    |___|   ",
"     ___    ",
"    |   |   ",
"   /___/    ",
};

char * naji_ascii_lessthan[6] = 
{
"     /~/    ",
"    / /     ",
"   / /      ",
"   \\ \\      ",
"    \\ \\     ",
"     \\_\\    ",
};

char * naji_ascii_morethan[6] = 
{
"    \\~\\     ",
"     \\ \\    ",
"      \\ \\   ",
"      / /   ",
"     / /    ",
"    /_/     ",
};
char * naji_ascii_paranopen[6] = 
{
"     /~/    ",
"    / /     ",
"   | |      ",
"   | |      ",
"    \\ \\     ",
"     \\_\\    ",
};

char * naji_ascii_paranclose[6] = 
{
"    \\~\\     ",
"     \\ \\    ",
"      | |   ",
"      | |   ",
"     / /    ",
"    /_/     ",
};

char * naji_ascii_underscore[6] = 
{
"            ",
"            ",
"            ",
"            ",
" __________ ",
"|__________|",
};

char * naji_ascii_exclaimark[6] = 
{
"    ___     ",
"   |   |    ",
"   |   |    ",
"   |___|    ",
"    ___     ",
"   |___|    ",
};

char * naji_ascii_pipe[6] = 
{
"   |~~~|    ",
"   |   |    ",
"   |   |    ",
"   |   |    ",
"   |   |    ",
"   |___|    ",
};

char * naji_ascii_numsign[6] = 
{
"   ##  ##   ",
" ########## ",
"   ##  ##   ",
"   ##  ##   ",
" ########## ",
"   ##  ##   ",
};

char * naji_ascii_fslash[6] = 
{
"      /~~/  ",
"     /  /   ",
"    /  /    ",
"   /  /     ",
"  /  /      ",
" /__/       ",
};

char * naji_ascii_bslash[6] = 
{
"  \\~~\\      ",
"   \\  \\     ",
"    \\  \\    ",
"     \\  \\   ",
"      \\  \\  ",
"       \\__\\ ",
};







void nascif(char *character[], int how_many_lines, int line, FILE *stream)
{
int i;
    
    for (i=0; i<how_many_lines; i++)
    if (line == i)
    fprintf(stream, character[line]);
}




/* lowercase and uppercase letter are the same for now */
/* i might do different cases and fonts in later versions */

void naji_ascif(char *string, int i, int a, FILE *stream)
{

    if (string[i] == ' ')

	nascif(naji_, 6, a, stream);
       
    
    else if (string[i] == 'a')
    
        nascif(naji_a, 6, a, stream);
        
    
    else if (string[i] == 'b')
    
        nascif(naji_b, 6, a, stream);
        
    
    else if (string[i] == 'c')
    
        nascif(naji_c, 6, a, stream);
        
    
    else if (string[i] == 'd')
    
        nascif(naji_d, 6, a, stream);
        
    
    else if (string[i] == 'e')
    
        nascif(naji_e, 6, a, stream);
        
    
    else if (string[i] == 'f')
    
        nascif(naji_f, 6, a, stream);
        
    
    else if (string[i] == 'g')
    
        nascif(naji_g, 6, a, stream);
        
    
    else if (string[i] == 'h')
    
        nascif(naji_h, 6, a, stream);
        
    
    else if (string[i] == 'i')
    
        nascif(naji_i, 6, a, stream);
        
    
    else if (string[i] == 'j')
    
        nascif(naji_j, 6, a, stream);
        
    
    else if (string[i] == 'k')
    
        nascif(naji_k, 6, a, stream);
        
    
    else if (string[i] == 'l')
    
        nascif(naji_l, 6, a, stream);
        
    
    else if (string[i] == 'm')
    
        nascif(naji_m, 6, a, stream);
        
    
    else if (string[i] == 'n')
    
        nascif(naji_n, 6, a, stream);
        
    
    else if (string[i] == 'o')
    
        nascif(naji_o, 6, a, stream);
        
    
    else if (string[i] == 'p')
    
        nascif(naji_p, 6, a, stream);
        
    
    else if (string[i] == 'q')
    
        nascif(naji_q, 6, a, stream);
        
    
    else if (string[i] == 'r')
    
        nascif(naji_r, 6, a, stream);
        
    
    else if (string[i] == 's')
    
        nascif(naji_s, 6, a, stream);
        
    
    else if (string[i] == 't')
    
        nascif(naji_t, 6, a, stream);
        
    
    else if (string[i] == 'u')
    
        nascif(naji_u, 6, a, stream);
        
    
    else if (string[i] == 'v')
    
        nascif(naji_v, 6, a, stream);
        
    
    else if (string[i] == 'w')
    
        nascif(naji_w, 6, a, stream);
        
    
    else if (string[i] == 'x')
    
        nascif(naji_x, 6, a, stream);
        
    
    else if (string[i] == 'y')
    
        nascif(naji_y, 6, a, stream);
        
    
    else if (string[i] == 'z')
    
        nascif(naji_z, 6, a, stream);
        
    

    else if (string[i] == 'A')
    
        nascif(naji_a, 6, a, stream);
        
    
    else if (string[i] == 'B')
    
        nascif(naji_b, 6, a, stream);
        
    
    else if (string[i] == 'C')
    
        nascif(naji_c, 6, a, stream);
        
    
    else if (string[i] == 'D')
    
        nascif(naji_d, 6, a, stream);
        
    
    else if (string[i] == 'E')
    
        nascif(naji_e, 6, a, stream);
        
    
    else if (string[i] == 'F')
    
        nascif(naji_f, 6, a, stream);
        
    
    else if (string[i] == 'G')
    
        nascif(naji_g, 6, a, stream);
        
    
    else if (string[i] == 'H')
    
        nascif(naji_h, 6, a, stream);
        
    
    else if (string[i] == 'I')
    
        nascif(naji_i, 6, a, stream);
        
    
    else if (string[i] == 'J')
    
        nascif(naji_j, 6, a, stream);
        
    
    else if (string[i] == 'K')
    
        nascif(naji_k, 6, a, stream);
        
    
    else if (string[i] == 'L')
    
        nascif(naji_l, 6, a, stream);
        
    
    else if (string[i] == 'M')
    
        nascif(naji_m, 6, a, stream);
        
    
    else if (string[i] == 'N')
    
        nascif(naji_n, 6, a, stream);
        
    
    else if (string[i] == 'O')
    
        nascif(naji_o, 6, a, stream);
        
    
    else if (string[i] == 'P')
    
        nascif(naji_p, 6, a, stream);
        
    
    else if (string[i] == 'Q')
    
        nascif(naji_q, 6, a, stream);
        
    
    else if (string[i] == 'R')
    
        nascif(naji_r, 6, a, stream);
        
    
    else if (string[i] == 'S')
    
        nascif(naji_s, 6, a, stream);
        
    
    else if (string[i] == 'T')
    
        nascif(naji_t, 6, a, stream);
        
    
    else if (string[i] == 'U')
    
        nascif(naji_u, 6, a, stream);
        
    
    else if (string[i] == 'V')
    
        nascif(naji_v, 6, a, stream);
        
    
    else if (string[i] == 'W')
    
        nascif(naji_w, 6, a, stream);
        
    
    else if (string[i] == 'X')
    
        nascif(naji_x, 6, a, stream);
        
    
    else if (string[i] == 'Y')
    
        nascif(naji_y, 6, a, stream);
        
    
    else if (string[i] == 'Z')
    
        nascif(naji_z, 6, a, stream);
        
    

    else if (string[i] == '1')
    
        nascif(naji_1, 6, a, stream);
        
    
    else if (string[i] == '2')
    
        nascif(naji_2, 6, a, stream);
        
    
    else if (string[i] == '3')
    
        nascif(naji_3, 6, a, stream);
        
    
    else if (string[i] == '4')
    
        nascif(naji_4, 6, a, stream);
        
    
    else if (string[i] == '5')
    
        nascif(naji_5, 6, a, stream);
        
    
    else if (string[i] == '6')
    
        nascif(naji_6, 6, a, stream);
        
    
    else if (string[i] == '7')
    
        nascif(naji_7, 6, a, stream);
        
    
    else if (string[i] == '8')
    
        nascif(naji_8, 6, a, stream);
        
    
    else if (string[i] == '9')
    
        nascif(naji_9, 6, a, stream);
        
    
    else if (string[i] == '0')
    
        nascif(naji_0, 6, a, stream);
        
    

    else if (string[i] == ',')
    
        nascif(naji_ascii_coma, 6, a, stream);
        
    
    else if (string[i] == '`')
    
        nascif(naji_ascii_aposopen, 6, a, stream);
        
    
    else if (string[i] == '\'')
    
        nascif(naji_ascii_aposclose, 6, a, stream);
        
    
    else if (string[i] == '.')
    
        nascif(naji_ascii_period, 6, a, stream);
        
    
    else if (string[i] == ':')
    
        nascif(naji_ascii_colon, 6, a, stream);
        
    
    else if (string[i] == ';')
    
        nascif(naji_ascii_semicolon, 6, a, stream);
        
    
    else if (string[i] == '<')
    
        nascif(naji_ascii_lessthan, 6, a, stream);
        
    
    else if (string[i] == '>')
    
        nascif(naji_ascii_morethan, 6, a, stream);
        
    
    else if (string[i] == '(')
    
        nascif(naji_ascii_paranopen, 6, a, stream);
        
    
    else if (string[i] == ')')
    
        nascif(naji_ascii_paranclose, 6, a, stream);
        
    
    else if (string[i] == '_')
    
        nascif(naji_ascii_underscore, 6, a, stream);
        
    
    else if (string[i] == '!')
    
        nascif(naji_ascii_exclaimark, 6, a, stream);
        
    
    else if (string[i] == '|')
    
        nascif(naji_ascii_pipe, 6, a, stream);
        
    
    else if (string[i] == '#')
    
        nascif(naji_ascii_numsign, 6, a, stream);
        
    
    else if (string[i] == '/')
    
        nascif(naji_ascii_fslash, 6, a, stream);
        
    
    else if (string[i] == '\\')
    
        nascif(naji_ascii_bslash, 6, a, stream);
        
    

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
            naji_ascif(string, i, a, stream);

        fprintf(stream, "\r\n");
    }


}

void bigascif(char *string, char *nameout)
{
    najout(nameout);
    _bigascif(string, naji_output);
    najoutclose();
}
