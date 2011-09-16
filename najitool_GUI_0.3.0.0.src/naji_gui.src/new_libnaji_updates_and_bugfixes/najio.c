
/* you might want to make your own najin and najout functions */
/* depending on what you need, for example it will probably   */
/* be better to change these functions for your GUI programs  */

void najin(char *namein)
{
int a;

    naji_input = fopen(namein, "rb");

    if (naji_input == NULL)
    {
    fprintf(stderr, "\n\nError, cannot open input file: %s", namein);
    perror(" "); fprintf(stderr, "\n\n");
    exit(2);
    }

	
	a = fgetc(naji_input);
	
	if (a == EOF)
    {
    fprintf(stderr, "\n\nError, empty file.\n\n");
    exit(1);
    }
	else
	{
		najinclose();
		
		naji_input = fopen(namein, "rb");

		if (naji_input == NULL)
		{
		fprintf(stderr, "\n\nError, cannot open input file: %s", namein);
		perror(" "); fprintf(stderr, "\n\n");
		exit(2);
		}
	
	}

	
	
	
}


void najintext(char *namein)
{
int a;

    naji_input = fopen(namein, "rt");

    if (naji_input == NULL)
    {
    fprintf(stderr, "\n\nError, cannot open input file: %s", namein);
    perror(" "); fprintf(stderr, "\n\n");
    exit(2);
    }

	
	a = fgetc(naji_input);
	if (a == EOF)
    {
    fprintf(stderr, "\n\nError, empty file.\n\n");
    exit(1);
    }
	else
	{
		najinclose();
		
		naji_input = fopen(namein, "rb");

		if (naji_input == NULL)
		{
		fprintf(stderr, "\n\nError, cannot open input file: %s", namein);
		perror(" "); fprintf(stderr, "\n\n");
		exit(2);
		}
	
	}

	
	
	
}



void najin2(char *namein2)
{
int a;

    naji_input2 = fopen(namein2, "rb");

    if (naji_input2 == NULL)
    {
    fprintf(stderr, "\n\nError, cannot open second input file: %s", namein2);
    perror(" "); fprintf(stderr, "\n\n");
    exit(2);
    }

	
	a = fgetc(naji_input2);
	if (a == EOF)
    {
    fprintf(stderr, "\n\nError, empty file.\n\n");
    exit(1);
    }
	else
	{
		najinclose();
		
		naji_input2 = fopen(namein2, "rb");

		if (naji_input2 == NULL)
		{
		fprintf(stderr, "\n\nError, cannot open second input file: %s", namein2);
		perror(" "); fprintf(stderr, "\n\n");
		exit(2);
		}
	
	}

	
	
	
}





/* finds the longest line in a text file and returns the result */

unsigned long longl(char *namein)
{
int a;

unsigned long length = 0;
unsigned long longest = 0;

najin(namein);

	while (1)
	{
	
		a = getc(naji_input);

		if (a == EOF)
		break;

		if (a == '\n')
		{
			if (length > longest)
			longest = length;
		
		length=0;
		}
		else length++;

	}

najinclose();

return longest;
}


void longline(char *namein)
{
printf("\n\nLongest line is: %lu\n\n", longl(namein));
}


/* counts how many lines there are in a text file and returns the result */

unsigned long howl(char *namein)
{
int a;

unsigned long lines = 0;

najin(namein);

	while (1)
	{
	
		a = getc(naji_input);

		if (a == EOF)
		break;

		if (a == '\n')
		lines++;

	}

najinclose();

return lines;
}


void howline(char *namein)
{
printf("\n\nTotal number of lines is: %lu\n\n", howl(namein));
}


char **naji_lines_alloc(unsigned long howmany, unsigned long howlong)
{
char **buffer = NULL;
unsigned long i;

	buffer = (char **) malloc(howmany * sizeof(char *));

	exitnull(buffer);

	for (i=0; i<howmany; i++)
	{
	buffer[i] = (char *) malloc(howlong * sizeof(char) + 3);
	exitnull(buffer[i]);
	}

return buffer;
}


void naji_lines_free(char **buffer, unsigned long howmany)
{
unsigned long i;

	for (i=0; i<howmany; i++)
	free(buffer[i]);

	free(buffer);
	
	buffer = NULL;
}


void naji_lines_load(char *namein, char **buffer, unsigned long howmany, unsigned long howlong)
{
int a;
unsigned long i = 0;
unsigned long c = 0;

	najintext(namein);

	while (1)
	{
		a = fgetc(naji_input);
	
		if (a == EOF)
		{
		buffer[i][c] = '\0';
		break;
		}

		else if (a == '\n')
		{
		buffer[i][c] = '\n';
		c++;
		
		buffer[i][c] = '\0';
		c++;
		
		i++;
	    
		c = 0;
		
		if (i >= howmany)
		break;
		}
	
		else if (a == '\r')
		;

		else
		{
		buffer[i][c] = a;
		c++;
		
		if (c == howlong)
		{
		buffer[i][c] = '\0';
		break;
		}
		
		
		}
	
	}
	

	najinclose();

}


void naji_lines_backwards_print(char **buffer, unsigned long howmany)
{
signed long backwards_howmany = 0;
signed long backwards_i = 0;

	backwards_howmany = (signed long) howmany;

	backwards_howmany--;

	if (strlen(buffer[backwards_howmany]) > 0)
	if (strchr(buffer[backwards_howmany], '\n') == NULL)
	{
	printf("%s\n", buffer[backwards_howmany]);
	backwards_howmany--;
	}
  
	for (backwards_i = backwards_howmany; backwards_i >= 0; backwards_i--)
	printf("%s", buffer[backwards_i]);

}


void naji_lines_print(char **buffer, unsigned long howmany)
{
unsigned long i;

	for (i=0; i<howmany; i++)
	printf("%s", buffer[i]);

}


void lineback(char *namein)
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

	naji_lines_backwards_print(buffer, howmany);

	naji_lines_free(buffer, howmany);
}



int return_random(int max)
{
int random_number;
int limit;

	limit = RAND_MAX - RAND_MAX % max;
	do random_number = rand(); while (random_number >= limit);

return random_number % max;
}


void shuffle_int_array(int *array, int size)
{
int a;
int b;
int c;

  size--;
  
  srand(time(NULL));
  
  for (a=size; a>0; a--)
  {
    b = return_random(a + 1);
    c = array[b];
    array[b] = array[a];
    array[a] = c;
  }

}


void naji_lines_random_print(char **buffer, int howmany)
{
unsigned long i = 0; 
int *vektor = NULL;

vektor = (int *) malloc(howmany * sizeof (int));
exitnull(vektor)

for (i=0; i<howmany; i++)
vektor[i] = i;

shuffle_int_array(vektor, howmany);

for (i=0; i<howmany; i++)
printf("%s", buffer[vektor[i]]);

free(vektor);
vektor = NULL;
}


void rndlines(char *namein)
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

	naji_lines_random_print(buffer, howmany);

	naji_lines_free(buffer, howmany);
}


void najifgets(char *buf, int size, FILE *input)
{
int a;
int i=0;

    while(1)
    {
    
        a = fgetc(naji_input);

        if (a == EOF)
		{
		buf[i] = '\0';
		return;
		}
		
		if (i == size)
        {
		buf[i+1] = '\0';
		return;
		}

        if (a == '\n')
        {
		buf[i]   = '\n';
		buf[i+1] = '\0';
        return;
        }
        else
		{
        buf[i] = a;
		buf[i+1] = '\0';
        }
		
		i++;
    
    }

}
