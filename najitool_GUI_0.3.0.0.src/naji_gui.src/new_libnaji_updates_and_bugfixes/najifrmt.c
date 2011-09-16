

void istrael(char *str, int pos, char *namein, char *nameout)
{
int a;
int b;
int isdos = NAJI_FALSE;
int i = 0;

najin(namein);
najout(nameout);


if (pos == 0)
{

	while (1)
	{
	a = fgetc(naji_input);
	if (a == EOF)
	break;

	if (a == '\r')
	{
	isdos = NAJI_TRUE;
	break;
	}

	}

	najinclose();
	najin(namein);

	a = fgetc(naji_input);

	if (a != EOF)
	{

		if (a == '\n')
		{
		if (isdos == NAJI_TRUE)
		fprintf(naji_output, "%s\n\r", str);
	
		else 
		fprintf(naji_output, "%s\n", str);
		}

	}
	else
	{
	najinclose();
	najoutclose();
	return;
	}


	b = fgetc(naji_input);

	if (b != EOF)
	{

		if (b == '\n')
		{
		if (isdos == NAJI_TRUE)
		fprintf(naji_output, "%s\n\r", str);
	
		else 
		fprintf(naji_output, "%s\n", str);
		}

	}
	else
	{
	najinclose();
	najoutclose();
	return;
	}

najinclose();
najin(namein);
}


  while (1)
  {
  a = fgetc(naji_input);

  if (a == EOF)
  break;
  
  fputc(a, naji_output);

  i++;

  if (a == '\n')
  i=0;
   
  if (i == pos)
  fputs(str, naji_output);
  }

najinclose();
najoutclose();
}


void istreml(char *str, char *namein, char *nameout)
{
int a;
int b;
int isdos = NAJI_FALSE;

najin(namein);
najout(nameout);


while (1)
{
a = fgetc(naji_input);
if (a == EOF)
break;

if (a == '\r')
{
isdos = NAJI_TRUE;
break;
}

}

najinclose();
najin(namein);

a = fgetc(naji_input);

if (a != EOF)
{

if (a == '\n')
{
	if (isdos == NAJI_TRUE)
	fprintf(naji_output, "\n\r%s\n\r", str);
	
	else 
	fprintf(naji_output, "\n%s\n", str);
}

}
else
{
najinclose();
najoutclose();
return;
}


b = fgetc(naji_input);

if (b != EOF)
{

if (b == '\n')
{
	if (isdos == NAJI_TRUE)
	fprintf(naji_output, "\n\r%s\n\r", str);
	
	else 
	fprintf(naji_output, "\n%s\n", str);
}

}
else
{
najinclose();
najoutclose();
return;
}

najinclose();
najin(namein);


	while (1)
	{
	a = fgetc(naji_input);

	if (a == EOF)
	break;
  
		if (a == '\n')
		{
			b = fgetc(naji_input);

			if (b == '\r')
			fprintf(naji_output, "\n\r%s\n\r", str);

			else if (b == '\n')
			fprintf(naji_output, "\n%s\n", str);
 
			else if (b == EOF)
			{
			fputc(a, naji_output);

				if (isdos == NAJI_TRUE)
				fprintf(naji_output, "\n\r%s\n\r", str);
	
				else 
				fprintf(naji_output, "\n%s\n", str);

			break;
			}
 
			else
			{
			fputc(a, naji_output);
			fputc(b, naji_output);
			}

		}
		
		else
		fputc(a, naji_output);

  }





najinclose();
najoutclose();
}


void addline(char *namein, char *nameout, char *text_to_add, unsigned long line_number)
{
int a;
unsigned long i=0;

najin(namein);
najout(nameout);



    if (line_number == 1)
	{
	fprintf(naji_output, "%s\n", text_to_add);
	
		while (1)
		{
				a = fgetc(naji_input);

				if (a == EOF)
				break;
	
				fputc(a, naji_output);
		}

		
		if (a == EOF)
		{
			najinclose();
			najoutclose();
			return;
		}
	
	}
	
	
	line_number--;

	while (1)
	{
		a = fgetc(naji_input);
	
		if (a == EOF)
		{
		if (i == (line_number - 2))
		fprintf(naji_output, "%s\n", text_to_add);
		
		break;
		}
	
		fputc(a, naji_output);

		if (a == '\n')
		i++;

		if (i == line_number)
		{
			fprintf(naji_output, "%s\n", text_to_add);
			break;
		}
	
	
	}

		if (a == EOF)
		{
			najinclose();
			najoutclose();
			return;
		}
	
		while (1)
		{
			a = fgetc(naji_input);

				if (a == EOF)
				break;
	
				fputc(a, naji_output);
		}

najinclose();
najoutclose();
}



void removel(char *namein, char *nameout, unsigned long line_number)
{
int a;
unsigned long i=0;
int has_nl = NAJI_FALSE;

najin(namein);
najout(nameout);

	if (line_number == 1)
	{
	
		while (1)
		{
			a = fgetc(naji_input);

				if (a == EOF)
				break;
					
				else if (a == '\n')
				has_nl = NAJI_TRUE;
				
				else
				{
			
					if (has_nl == NAJI_TRUE)
					{
							while (1)
							{
								a = fgetc(naji_input);

								if (a == EOF)
								break;
							
								else
								fputc(a, naji_output);
							}

					}
			
				}
	

		}

	najinclose();
	najoutclose();
	return;
	}

	line_number--;

	while (1)
	{
		a = fgetc(naji_input);
		
		if (a == EOF)
		break;

		if (a == '\n')
		i++;

		if (i != line_number)
		fputc(a, naji_output);

		else
		{
		
			while (1)
			{
			a = fgetc(naji_input);
			
			if ( (a == '\r') || (a == '\n')  || (a == EOF) )
			break;
			}
			
		if ( (a == '\r') || (a == '\n')  || (a == EOF) )
		break;
		}
	}

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

najinclose();
najoutclose();
}

void spyramid(char *str)
{
unsigned long i=0;
unsigned long x=0;
unsigned long len = 0;

len = strlen(str);

	for (x=0; x<len; x++)
	{
		for (i=0; i<x; i++)
		{
		fputc(str[i], stdout);
		}
	
		fputc('\n', stdout);
	}

	for (x=0; x<len; x++)
	{
		for (i=0; i<len-x; i++)
		{
		fputc(str[i], stdout);
		}

		fputc('\n', stdout);
	}

}



void replacel(char *namein, char *nameout, char *str, unsigned long line_number)
{
int a;
unsigned long i=0;
int has_nl = NAJI_FALSE;
int isdos = NAJI_FALSE;

najin(namein);
najout(nameout);


	if (line_number == 1)
	{
	
		while (1)
		{
			a = fgetc(naji_input);

				if (a == EOF)
				{
					if (has_nl == NAJI_FALSE)
					fprintf(naji_output, "%s", str);
				
				break;
				}
		
			
				else if (a == '\n')
				{
					fprintf(naji_output, "\n%s\n", str);
					has_nl = NAJI_TRUE;
				}
				
				else
				{
			
					if (has_nl == NAJI_TRUE)
					{
							while (1)
							{
								a = fgetc(naji_input);

								if (a == EOF)
								break;
							
								else
								fputc(a, naji_output);
							}

					}
			
				}
	

		}

	najinclose();
	najoutclose();
	return;
	}

	line_number--;
	

	while (1)
	{
		a = fgetc(naji_input);
		
		if (a == EOF)
		break;

		if (a == '\n')
		i++;

		if (i != line_number)
		fputc(a, naji_output);


		else
		{
		
			while (1)
			{
			a = fgetc(naji_input);
			
			if (a == '\r')
			{
			isdos = NAJI_TRUE;
			break;
			}
			
			if ((a == '\n')  || (a == EOF) )
			break;
			}
			
		if ( (a == '\r') || (a == '\n')  || (a == EOF) )
		break;
		}

	}

	
	if (a == EOF)
	{
	if (isdos == NAJI_TRUE)
	fprintf(naji_output, "\n\r%s", str);
	else
	fprintf(naji_output, "\n%s", str);
	
	najinclose();
	najoutclose();
	return;
	}
	
			
	if (a != '\r')
	{
	fprintf(naji_output, "\n%s\n", str);
	}
	
	else if (a == '\n')
	{
	fprintf(naji_output, "\n\r%s\n\r", str);
	}

	while (1)
	{
		a = fgetc(naji_input);

		if (a == EOF)
		break;
	
		fputc(a, naji_output);
	}

	
		
	
najinclose();
najoutclose();
}
