
void mjoin(char *namein_original_filename, char *nameout_joined_output_file)
{
int a;
unsigned long peice;
char mjoin_filename_buffer[4096];

peice = 0;
najout(nameout_joined_output_file);


while (1)
{


sprintf(mjoin_filename_buffer, "%s.%lu", namein_original_filename, peice);
najin(mjoin_filename_buffer);


	while (1)
	{
	a = fgetc(naji_input);

	if (a == EOF)
	break;

	fputc(a, naji_output);
	}


najinclose();

peice++;
}


}


void bytsplit(char *namein, unsigned long peice_size)
{
int a;
char bytsplit_filename_buffer[4096];
unsigned long size_reached;
unsigned long peice;


size_reached = 0;
peice = 0;

najin(namein);



while (1)
{


sprintf(bytsplit_filename_buffer, "%s.%lu", namein, peice);
najout(bytsplit_filename_buffer);


	while (1)
	{


	a = fgetc(naji_input);

	if (a == EOF)
	break;

	fputc(a, naji_output);

	size_reached++;

	if (size_reached == peice_size)
	break;


	}


najoutclose();

if (a == EOF)
break;

peice++;
size_reached = 0;
}



}




void kbsplit(char *namein, unsigned long peice_size)
{
int a;
unsigned long i;
unsigned long size_reached;
unsigned long peice;
char kbsplit_filename_buffer[4096];


size_reached = 0;
peice = 0;

najin(namein);


while (1)
{


sprintf(kbsplit_filename_buffer, "%s.%lu", namein, peice);
najout(kbsplit_filename_buffer);


	while (1)
	{

	for (i=0; i<1024; i++)
	{

	a = fgetc(naji_input);

	if (a == EOF)
	break;

	fputc(a, naji_output);

	}
	
	if (a == EOF)
	break;

	size_reached++;

	if (size_reached == peice_size)
	break;


	}


najoutclose();

if (a == EOF)
break;

peice++;
size_reached = 0;
}



}




void mbsplit(char *namein, unsigned long peice_size)
{
int a;
unsigned long i;
unsigned long size_reached;
unsigned long peice;
char mbsplit_filename_buffer[4096];

size_reached = 0;
peice = 0;

najin(namein);

while (1)
{


sprintf(mbsplit_filename_buffer, "%s.%lu", namein, peice);
najout(mbsplit_filename_buffer);


	while (1)
	{

	for (i=0; i<1048576; i++)
	{

	a = fgetc(naji_input);

	if (a == EOF)
	break;

	fputc(a, naji_output);

	}
	
	if (a == EOF)
	break;

	size_reached++;

	if (size_reached == peice_size)
	break;


	}


najoutclose();

if (a == EOF)
break;

peice++;
size_reached = 0;
}



}




void gbsplit(char *namein, unsigned long peice_size)
{
int a;
unsigned long i;
unsigned long size_reached;
unsigned long peice;
char gbsplit_filename_buffer[4096];

size_reached = 0;
peice = 0;

najin(namein);

while (1)
{
sprintf(gbsplit_filename_buffer, "%s.%lu", namein, peice);
najout(gbsplit_filename_buffer);


	while (1)
	{

	for (i=0; i<1073741824; i++)
	{

	a = fgetc(naji_input);

	if (a == EOF)
	break;

	fputc(a, naji_output);

	}
	
	if (a == EOF)
	break;

	size_reached++;

	if (size_reached == peice_size)
	break;


	}


najoutclose();

if (a == EOF)
break;

peice++;
size_reached = 0;
}



}
