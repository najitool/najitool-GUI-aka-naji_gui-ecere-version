void wordlist(short a, short b, unsigned int size, char *nameout)
{
int i;
int c;
short *buffer;
/* unsigned long long int possible_combinations; */ /* long long Not ANSI C */
unsigned long int possible_combinations; 


buffer = malloc(size * sizeof (short) );


if (buffer == NULL)
{
fprintf(stderr, "\nlibnaji: Error allocating memory for function wordlist()\n");
exit(1);
}


possible_combinations = pow(abs(a - b)+1, size);

/* fprintf(stderr, "\n%llu\n", possible_combinations); */ /* %llu Not ANSI C */


fprintf(stderr,"\nThis will make a text file with %lu possible combinations\nof characters from %c to %c one line after another.\n", possible_combinations, a, b);
fprintf(stderr, "Are you sure you want to continue?\npress y or Y then enter or return to continue or any other key to exit.\n");


	if (toupper(fgetc(stdin)) != 'Y')
	exit(0);

	najout(nameout);

	for (i=0; i<size; i++)
	buffer[i] = a;

	buffer[i] = '\0';

	while (1)
	{
	c=0;

	for (i=0; i<size; i++)
	fputc(buffer[i], naji_output);

	fputc('\n', naji_output);

	buffer[0]++;

		for (i=0; i<size; i++)
		{

			if (buffer[i] > b)
			{
			buffer[i] = a;

         		c++;


			if (i <size-1)
			buffer[i+1]++;
			}

		}

	if (c == size)
	break;
	}



free(buffer);
buffer = NULL;
}


void listlowr(unsigned int size, char *nameout)
{
wordlist('a', 'z', size, nameout);
}

void listuppr(unsigned int size, char *nameout)
{
wordlist('A', 'Z', size, nameout);
}

void listdigt(unsigned int size, char *nameout)
{
wordlist('0', '9', size, nameout);
}

void listprnt(unsigned int size, char *nameout)
{
wordlist(33, 126, size, nameout);
}
