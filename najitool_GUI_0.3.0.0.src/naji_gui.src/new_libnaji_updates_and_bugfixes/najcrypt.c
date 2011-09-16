
void weakrypt(const char *password, char *namein, char *nameout)
{
int a;
int pwdlen;

najin(namein);
najout(nameout);

			pwdlen = strlen(password);

			while (1)
			{
			a = getc(naji_input);

			if (a == EOF)
			break;

			if (*password == '\0')
			password -= pwdlen;

			a ^= *password;

			password++;

			fputc(a, naji_output);
            }

najinclose();
najoutclose();
}
