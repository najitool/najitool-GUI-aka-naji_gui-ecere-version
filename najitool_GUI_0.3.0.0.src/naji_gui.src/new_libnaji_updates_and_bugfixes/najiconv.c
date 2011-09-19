
void revlines(char *namein, char *nameout)
{
    unsigned long int longest_line;
    char *buffer = NULL;

    longest_line = longl(namein);

    buffer = (char *) malloc(longest_line * sizeof (char) + 2);
    exitnull(buffer);

    najin(namein);
    najout(nameout);

    longest_line++;

    while (1)
    {
        if (feof(naji_input))
            break;


        najifgets(buffer, longest_line, naji_input);

        sreverse(buffer);

        fprintf(naji_output, "%s", buffer);
    }

    free(buffer);
    buffer = NULL;

    najinclose();
    najoutclose();
}





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
