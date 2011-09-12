

void allfiles_genfile(char *filename, short file_contents[], unsigned long int filesize)
{
	unsigned long int i;
	char buffer[4096];


	/* NOTE: This will make the filenames start with a dot,
        	 because on Windows/DOS systems you can't use
	         CON, NUL, AUX, PRN, as filenames */

	sprintf(buffer, ".%s", filename);


	najout(buffer);
	
	for (i=0; i<filesize; i++)
	fputc(file_contents[i], naji_output);

	najoutclose();

	printf("Made file :%s:\n", buffer);

}




#define MAX_FILENAME_LENGTH 257

char afgfn_buffer[MAX_FILENAME_LENGTH];

unsigned long int afgfn_i    = 0;
unsigned long int afgfn_c    = 0;
unsigned long int afgfn_size = 1;

void allfiles_genfilename(short a, short b, short filecontents[], unsigned long int filesize)
{


	afgfn_c=0;

	allfiles_genfile(afgfn_buffer, filecontents, filesize);

	afgfn_buffer[0]++;

	/* skips characters   \ / : * ? " < > |   which cannot be used in DOS/Windows filenames */
	/* also skips lowercase letters, since Windows filenames are case insensitive */

	if (afgfn_buffer[0] == '\"')
	afgfn_buffer[0]++;
 
	else if (afgfn_buffer[0] == '*')
	afgfn_buffer[0]++;

	else if (afgfn_buffer[0] == '.')
	afgfn_buffer[0]+=2;

	else if (afgfn_buffer[0] == ':')
	afgfn_buffer[0]++;

	else if (afgfn_buffer[0] == '<')
	afgfn_buffer[0]++;

	else if (afgfn_buffer[0] == '>')
	afgfn_buffer[0]+=2;

	else if (afgfn_buffer[0] == '\\')
	afgfn_buffer[0]++;
   
	else if (islower(afgfn_buffer[0]))
	afgfn_buffer[0]='{';

	else if (afgfn_buffer[0] == '|')
	afgfn_buffer[0]++;

	for (afgfn_i=0; afgfn_i<afgfn_size; afgfn_i++)
	{

			if (afgfn_buffer[afgfn_i] > b)
			{
			afgfn_buffer[afgfn_i] = a;
			afgfn_c++;

				if (afgfn_i <afgfn_size-1)
				{
				afgfn_buffer[afgfn_i+1]++;

				/* skips characters   \ / : * ? " < > |   which cannot be used in DOS/Windows filenames */
				/* also skips lowercase letters, since Windows filenames are case insensitive */

				if (afgfn_buffer[afgfn_i+1] == '\"')
				afgfn_buffer[afgfn_i+1]++;

				else if (afgfn_buffer[afgfn_i+1] == '*')
				afgfn_buffer[afgfn_i+1]++;
				
				else if (afgfn_buffer[afgfn_i+1] == '.')
				afgfn_buffer[afgfn_i+1]+=2;

				else if (afgfn_buffer[afgfn_i+1] == ':')
				afgfn_buffer[afgfn_i+1]++;
				
				else if (afgfn_buffer[afgfn_i+1] == '<')
				afgfn_buffer[afgfn_i+1]++;

				else if (afgfn_buffer[afgfn_i+1] == '>')
				afgfn_buffer[afgfn_i+1]+=2;

				else if (afgfn_buffer[afgfn_i+1] == '\\')
				afgfn_buffer[afgfn_i+1]++;

				else if (islower(afgfn_buffer[afgfn_i+1]))
				afgfn_buffer[afgfn_i+1]='{';

				else if (afgfn_buffer[afgfn_i+1] == '|')
				afgfn_buffer[afgfn_i+1]++;
				}

			}

	}


	if (afgfn_c == afgfn_size)
	{
	for (afgfn_i=0; afgfn_i<afgfn_size+1; afgfn_i++)
	afgfn_buffer[afgfn_i] = '!';

	afgfn_buffer[afgfn_i] = '\0';
	afgfn_size++;
	}


}




void allfiles_main(short a, short b, short *buffer, unsigned long int size)
{
	unsigned long int i;
	unsigned long int c;
	unsigned long int possible_combinations;


	for (afgfn_i=0; afgfn_i<afgfn_size; afgfn_i++)
	afgfn_buffer[afgfn_i] = '!';

	afgfn_buffer[afgfn_i] = '\0';



	possible_combinations = pow(abs(a - b)+1, size);

	printf(
"\nThis will make %lu files (if you see a zero it cannot be displayed on the\n"
"'unsigned long int' type on this system) i.e. it will make 256^%lu files.\n"
"all the files will use up (256^%lu)*%lu bytes.\n\n"
"Are you sure you want to continue?\n"
"Press y or Y then enter or return to continue,\n"
"or any other key then enter or return to exit.\n", possible_combinations, size, size, size);

	if (toupper(fgetc(stdin)) != 'Y')
	exit(0);

	for (i=0; i<size; i++)
	buffer[i] = a;

	buffer[i] = '\0';

	while (1)
	{

		c=0;

		allfiles_genfilename('!', '~', buffer, size);

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

}




/* WARNING: be very careful with this */
/* function, it makes a lot of files  */

/* you give it the size in bytes of every  */
/* possible byte combination that you want */


void allfiles(unsigned long int size)
{
	short *buffer;
	
	buffer = malloc(size * sizeof(short) );

	if (buffer == NULL)
	{
	fprintf(stderr, "libnaji: Error allocating memory in function allfiles()\n");
	exit(9);
	}

	allfiles_main(0, 255, buffer, size);

	free(buffer);

	buffer = NULL; 
}
