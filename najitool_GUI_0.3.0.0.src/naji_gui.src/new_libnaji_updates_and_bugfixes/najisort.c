
char swap_char_var;
#define swap_char(a, b)  swap_char_var=a;   a=b;  b=swap_char_var;

int swap_int_var;
#define swap_int(a, b)  swap_int_var=a;   a=b;  b=swap_int_var;


int cvlen;
char *cva;
char *cvb;





void rcharvar(char *str)
{
int c;
int x;
int y;
int z;


        cvlen = strlen(str);

        c = cvlen-1;

        cva = newchar(cvlen);
        cvb = newchar(cvlen);
        exitnull(cva);
        exitnull(cvb);

        strcpy(cva, str);


        for(x=0; x<cvlen; x++)
        cvb[x]=cvlen-x;

        for (z=0; z<cvlen; z++)
        fputc(cva[z], stdout);

        fputc('\n', stdout);


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

        for (z=0; z<cvlen; z++)
        fputc(cva[z], stdout);

        fputc('\n', stdout);


        x=c;

                while (cvb[x] == 0)
                {
                cvb[x] = cvlen-x;
                x--;
                }
        }
}


void lcharvar(char *str)
{
int x;
int y;
int z;



        cvlen = strlen(str);

        cva = newchar(cvlen);
        cvb = newchar(cvlen);
        exitnull(cva);
        exitnull(cvb);

        strcpy(cva, str);


        for (x=0; x<cvlen; x++)
        cvb[x] = x;
  
        cvb[cvlen] = cvlen;


        for (z=0; z<cvlen; z++)
        fputc(cva[z], stdout);

        fputc('\n', stdout);


        x=1;

        while (x < cvlen)
        {
        cvb[x]--;
        y=0;

                while (y < x)
                {
                swap_char(cva[x], cva[y])
                y++;
                x--;
                }

        for (z=0; z<cvlen; z++)
        fputc(cva[z], stdout);

        fputc('\n', stdout);

        x=1;

                while (cvb[x] == 0)
                {
                cvb[x]=x;
                x++;
                }

        }

}




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
struct najiline line;
struct najiline *pline = NULL;
struct najiline *plines = NULL;
char current;
char previous = ' ';
int linecharnb = 0;
int linenb = 0;
int lflong = 1;

long filecharnb = 0;

  while ((current = fgetc(sourcefile)) != EOF)
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

  if (plines == NULL)
  {

    fprintf(stderr, "Error allocating %d bytes of memory.",
    sizeof(line) * linenb);

    return -1;
  }

  rewind(sourcefile);
  pline = plines - 1;
  linecharnb = 0;
  filecharnb = 0;

  while ((current = fgetc(sourcefile)) != EOF)
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



void lcvfiles(char *namein)
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

long filecount=0;



        najin(namein);
 
        cvlen = najinsize();

        cva = newchar(cvlen);
        cvb = newchar(cvlen);
        exitnull(cva);
        exitnull(cvb);

        while (1)
        {
        a = fgetc(naji_input);

        if (a == EOF) break;

        cva[i] = a;
        i++;
        }

        najinclose();


        for (x=0; x<cvlen; x++)
        cvb[x] = x;
  
        cvb[cvlen] = cvlen;





	sprintf(buffer, "lcv%lu-%s", filecount, namein);
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
                swap_char(cva[x], cva[y])
                y++;
                x--;
                }

                sprintf(buffer, "lcv%lu-%s", filecount, namein);
                najout(buffer);
                filecount++;


	        for (z=0; z<cvlen; z++)
	        fputc(cva[z], naji_output);

                najoutclose();

	        x=1;

                while (cvb[x] == 0)
                {
                cvb[x]=x;
                x++;
                }

        }



}



void rcvfiles(char *namein)
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

long filecount=0;   


        najin(namein);
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

        cva[i] = a;
        i++;
        }

        najinclose();     


	sprintf(buffer, "rcv%lu-%s", filecount, namein);
	najout(buffer);
	filecount++;

        for(x=0; x<cvlen; x++)
        cvb[x]=cvlen-x;

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

                sprintf(buffer, "rcv%lu-%s", filecount, namein);
                najout(buffer);
                filecount++;      


	        for (z=0; z<cvlen; z++)
	        fputc(cva[z], naji_output);

	        najoutclose();


	        x=c;

                while (cvb[x] == 0)
                {
                cvb[x] = cvlen-x;
                x--;
                }

        }

}






/* function pointer declaration */
void (*sort_print_global_function_pointer)(char **buffer, unsigned long howmany);


int sortcomp(const void *a, const void *b)
{
const char **va = (void *) a;
const char **vb = (void *) b;
return strcmp(*va, *vb);
}


void sort_basis(char *namein)
{
char **buffer = NULL;
unsigned long howmany;
unsigned long howlong;

	howmany = howl(namein);
	howlong = longl(namein);
	
	howlong += 3;
	howmany ++;
	
	buffer = naji_lines_alloc(howmany, howlong);

	naji_lines_load(namein, buffer, howmany, howlong);

	qsort( (void*) buffer, howmany, sizeof(buffer[0]), sortcomp);

	(*sort_print_global_function_pointer)(buffer, howmany);

	naji_lines_free(buffer, howmany);
}


void sort(char *namein)
{
(sort_print_global_function_pointer) = naji_lines_print;
sort_basis(namein);
}


void sortlast(char *namein)
{
(sort_print_global_function_pointer) = naji_lines_backwards_print;
sort_basis(namein);
}

