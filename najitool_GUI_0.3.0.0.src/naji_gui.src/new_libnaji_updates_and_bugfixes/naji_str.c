
void sreverse(char *str)
{
unsigned long i;

char *strbackup = NULL;
int len;
int has_new_line = NAJI_FALSE;


	len = strlen(str);
	
	if (len <= 1)
	return;

	for (i=0; str[i] != '\0'; i++)
	{
		if (str[i] == '\n')
		{
		str[i] = '\0';
		has_new_line = NAJI_TRUE;
		}
	}

    strbackup = newchar(len+2);
	exitnull(strbackup);

	strcpy(strbackup, str);

	len = strlen(str);   

 
	for (i=0; i<len; i++)
	str[len-i-1] = strbackup[i];
	
	if (has_new_line == NAJI_TRUE)
	{
	str[len]   = '\n';
	str[len+1] = '\0';
	}
	else
	str[len] = '\0';
	
free(strbackup);
strbackup = NULL;
}
