


unsigned char allbmp16_header_array[118] =
{
0x42,0x4D,0xF6,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x76,0x00,0x00,0x00,0x28,
0x00,0x00,0x00,0x10,0x00,0x00,0x00,0x10,0x00,0x00,0x00,0x01,0x00,0x04,0x00,
0x00,0x00,0x00,0x00,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x80,0x00,0x00,0x80,0x00,0x00,0x00,0x80,0x80,0x00,0x80,0x00,0x00,0x00,0x80,
0x00,0x80,0x00,0x80,0x80,0x00,0x00,0x80,0x80,0x80,0x00,0xC0,0xC0,0xC0,0x00,
0x00,0x00,0xFF,0x00,0x00,0xFF,0x00,0x00,0x00,0xFF,0xFF,0x00,0xFF,0x00,0x00,
0x00,0xFF,0x00,0xFF,0x00,0xFF,0xFF,0x00,0x00,0xFF,0xFF,0xFF,0x00
};















void allbmp16_genfile(char *filename, short file_contents[], unsigned long int filesize)
{
	unsigned long int i;
	char buffer[4096];



	/* NOTE: This will make the filenames start with a dot,
        	 because on Windows/DOS systems you can't use
	         CON, NUL, AUX, PRN, as filenames */

	sprintf(buffer, ".%s.bmp", filename);


	najout(buffer);


	for (i=0; i<118; i++)
	fputc(allbmp16_header_array[i], naji_output);

	for (i=0; i<filesize; i++)
	fputc(file_contents[i], naji_output);

	najoutclose();

	printf("Made file :%s:\n", buffer);

}




#define ALLBMP16_MAX_FILENAME_LENGTH 257

char allbmp16gfn_buffer[ALLBMP16_MAX_FILENAME_LENGTH];

unsigned long int allbmp16gfn_i    = 0;
unsigned long int allbmp16gfn_c    = 0;
unsigned long int allbmp16gfn_size = 1;

void allbmp16_genfilename(short a, short b, short filecontents[], unsigned long int filesize)
{


	allbmp16gfn_c=0;

	allbmp16_genfile(allbmp16gfn_buffer, filecontents, filesize);

	allbmp16gfn_buffer[0]++;

	/* skips characters   \ / : * ? " < > |   which cannot be used in DOS/Windows filenames */
	/* also skips lowercase letters, since Windows filenames are case insensitive */

	if (allbmp16gfn_buffer[0] == '\"')
	allbmp16gfn_buffer[0]++;
 
	else if (allbmp16gfn_buffer[0] == '*')
	allbmp16gfn_buffer[0]++;

	else if (allbmp16gfn_buffer[0] == '.')
	allbmp16gfn_buffer[0]+=2;

	else if (allbmp16gfn_buffer[0] == ':')
	allbmp16gfn_buffer[0]++;

	else if (allbmp16gfn_buffer[0] == '<')
	allbmp16gfn_buffer[0]++;

	else if (allbmp16gfn_buffer[0] == '>')
	allbmp16gfn_buffer[0]+=2;

	else if (allbmp16gfn_buffer[0] == '\\')
	allbmp16gfn_buffer[0]++;
   
	else if (islower(allbmp16gfn_buffer[0]))
	allbmp16gfn_buffer[0]='{';

	else if (allbmp16gfn_buffer[0] == '|')
	allbmp16gfn_buffer[0]++;

	for (allbmp16gfn_i=0; allbmp16gfn_i<allbmp16gfn_size; allbmp16gfn_i++)
	{

			if (allbmp16gfn_buffer[allbmp16gfn_i] > b)
			{
			allbmp16gfn_buffer[allbmp16gfn_i] = a;
			allbmp16gfn_c++;

				if (allbmp16gfn_i <allbmp16gfn_size-1)
				{
				allbmp16gfn_buffer[allbmp16gfn_i+1]++;

				/* skips characters   \ / : * ? " < > |   which cannot be used in DOS/Windows filenames */
				/* also skips lowercase letters, since Windows filenames are case insensitive */

				if (allbmp16gfn_buffer[allbmp16gfn_i+1] == '\"')
				allbmp16gfn_buffer[allbmp16gfn_i+1]++;

				else if (allbmp16gfn_buffer[allbmp16gfn_i+1] == '*')
				allbmp16gfn_buffer[allbmp16gfn_i+1]++;
				
				else if (allbmp16gfn_buffer[allbmp16gfn_i+1] == '.')
				allbmp16gfn_buffer[allbmp16gfn_i+1]+=2;

				else if (allbmp16gfn_buffer[allbmp16gfn_i+1] == ':')
				allbmp16gfn_buffer[allbmp16gfn_i+1]++;
				
				else if (allbmp16gfn_buffer[allbmp16gfn_i+1] == '<')
				allbmp16gfn_buffer[allbmp16gfn_i+1]++;

				else if (allbmp16gfn_buffer[allbmp16gfn_i+1] == '>')
				allbmp16gfn_buffer[allbmp16gfn_i+1]+=2;

				else if (allbmp16gfn_buffer[allbmp16gfn_i+1] == '\\')
				allbmp16gfn_buffer[allbmp16gfn_i+1]++;

				else if (islower(allbmp16gfn_buffer[allbmp16gfn_i+1]))
				allbmp16gfn_buffer[allbmp16gfn_i+1]='{';

				else if (allbmp16gfn_buffer[allbmp16gfn_i+1] == '|')
				allbmp16gfn_buffer[allbmp16gfn_i+1]++;
				}

			}

	}


	if (allbmp16gfn_c == allbmp16gfn_size)
	{
	for (allbmp16gfn_i=0; allbmp16gfn_i<allbmp16gfn_size+1; allbmp16gfn_i++)
	allbmp16gfn_buffer[allbmp16gfn_i] = '!';

	allbmp16gfn_buffer[allbmp16gfn_i] = '\0';
	allbmp16gfn_size++;
	}


}




void allbmp16_main(short a, short b, short *buffer, unsigned long int size)
{
	unsigned long int i;
	unsigned long int c;
/*	unsigned long int possible_combinations; */


	for (allbmp16gfn_i=0; allbmp16gfn_i<allbmp16gfn_size; allbmp16gfn_i++)
	allbmp16gfn_buffer[allbmp16gfn_i] = '!';

	allbmp16gfn_buffer[allbmp16gfn_i] = '\0';


/*
	possible_combinations = pow(abs(a - b)+1, size);

	printf (
		"\nThis will make %lu .BMP files are you sure you want to continue?\n"
		"press y or Y then enter or return to continue or any other key to exit.\n", possible_combinations
		);

*/

	printf(
	"\n"
	"This will make the following number of .BMP files:\n"
	"17976931348623159077293051907890247336179769789423065727343008115773267580550096"
	"31327084773224075360211201138798713933576587897688144166224928474306394741243777"
	"67893424865485276302219601246094119453082952085005768838150682342462881473913110"
	"540827237163350510684586298239947245938479716304835356329624224137216\n"
	"\n");

	printf(
	"Each .BMP file will have a 118 byte header and a 128 bytes of\n"
	"16 width, 16 height, and 16 color pixel contents.\n"
	"\n"
	"Each .BMP file will be 246 bytes in size.\n"
	"\n"
	"The total amount of bytes used for all .BMP files will be:\n"
	"\n");

	printf(
	"44223251117612971330140907693410008447002233681980741689263799964802238248153236"
	"93064628542131225386119554801444836276598406228312834648913324046793731063459693"
	"09017825169093779703460219065391533854584062129114191341850678562458688425826251"
	"93043500342184225628408229367027022500866010210989497657087559137755136 bytes.\n"
	"\n"
	"Are you sure you want to continue?\n"
	"Press y or Y then enter or return to continue,\n"
	"or any other key then enter or return to exit.\n"
	);


	if (toupper(fgetc(stdin)) != 'Y')
	exit(0);

	for (i=0; i<size; i++)
	buffer[i] = a;

	buffer[i] = '\0';

	while (1)
	{

		c=0;

		allbmp16_genfilename('!', '~', buffer, size);

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






void allbmp16(void)
{
	short *buffer;
	
	buffer = malloc(128 * sizeof(short) );

	if (buffer == NULL)
	{
	fprintf(stderr, "Error allocating memory.\n");
	exit(1);
	}

	allbmp16_main(0, 255, buffer, 128);

	free(buffer);

	buffer = NULL; 
}
