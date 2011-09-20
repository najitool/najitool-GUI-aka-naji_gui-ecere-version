
void sp2ce2sp(char c, char *namein, char *nameout)
{
    int a;

    najin(namein);
    najout(nameout);

    while (1)
    {
        a = fgetc(naji_input);

        if (a == EOF)
            break;

        if (a == ' ')
            fputc(c, naji_output);

        else if (a == '\n')
            fputc('\n', naji_output);

        else if (a == '\r')
            fputc('\r', naji_output);

        else
            fputc(' ', naji_output);
    }


    najinclose();
    najoutclose();
}

void sp2re2sp(char *namein, char *nameout)
{
    int a;

    najin(namein);
    najout(nameout);

    rndinit();

    while (1)
    {
        a = fgetc(naji_input);

        if (a == EOF)
            break;

        if (a == ' ')
            fputc( ( (rand() % 94) + '!'), naji_output);

        else if (a == '\n')
            fputc('\n', naji_output);

        else if (a == '\r')
            fputc('\r', naji_output);

        else
            fputc(' ', naji_output);
    }


    najinclose();
    najoutclose();
}
