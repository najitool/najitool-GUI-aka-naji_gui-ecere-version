#include "naji_gui.eh"

char mp3info_buffer[10480];

/*      MP3 Code bellow      */
/*     Written by ARKAINO    */
/*  formally known as YEHRCL */

/**********************************************************

  TODO
  ----

  - Seconds range checking.

  - Show MP3 specific information (bit rate, etc).
    Actually, already supported but not shown to the user.

  - VBR support.

  - ID3v2 tag editing.

***********************************************************/

#define TRUE 1
#define FALSE 0
#define BUFSIZE 2000
#define LITTLE_END(x) ( ((x & 0xff000000) >> 24) |   \
                         ((x & 0x00ff0000) >> 8)  |  \
                         ((x & 0x0000ff00) << 8)  |  \
                         ((x & 0x000000ff) << 24) )

/* this is for suppressing the last bit on each byte */
#define LITTLE_MESS(x) ( ((x & 0x0000007f) | ((x & 0x00000100) >> 1)) | \
			 (((x & 0x00007f00) | ((x & 0x00010000) >> 1)) >> 1) | \
			 (((x & 0x007f0000) | ((x & 0x01000000) >> 1)) >> 2) | \
			 ((x & 0x7f000000) >> 3) )

enum fileperms {READ_ONLY, READ_WRITE};

#define GET_MPEG(x) (x & 0x08)
#define GET_LAYER(x) (x & 0x06)
#define GET_PROT(x) (x & 0x01)
#define GET_BRATE(x) (x & 0xf0)
#define GET_FREQ(x) (x & 0x0c)
#define GET_PADD(x) (x & 0x02)

enum ids
{
    MPEG1=0, PADDING, PROTECTED, LAYER3,
    BRATE32, BRATE40, BRATE48, BRATE56,
    BRATE64, BRATE80, BRATE96, BRATE112,
    BRATE128, BRATE160, BRATE192, BRATE224,
    BRATE256, BRATE320, FREQ44, FREQ48, FREQ32,
    BAD, BLANK
};

/* not all fields are needed, but we declare them for further use */
struct frame_header
{
    enum ids id, layer, protected,
    bitrate, padding, frequency;
    int size;

};

/* for printing the user the file attributes, etc */
struct idtable
{
    char string[16];
    unsigned int value;

};

extern struct idtable idindex[22];

struct id3v1
{
    char title[31], artist[31], album[31],
    year[5], comment[30];
    int track;

};

struct id3v2
{
    char * title, *artist, *album, *year, *track, *comment;
    int size;

};

extern char genres [127][18];

enum id3version {ID3V1, ID3V2, BADVERSION};

struct fileinfo
{
    FILE * fd;
    struct id3v1 tag;
    struct id3v2 tag2;
    struct frame_header header;
    enum id3version tagver;
};

/*
 * Calculates the frame size from buffer and stores the header data.
 * Returns the frame size in bytes, FALSE otherwise.
 * TODO: CRC support??
 */
int mp3header (char const * buffer, size_t count, struct frame_header * header);

/*
 * Checks for ID3v1 data in fd and writes it to tag.
 * Returns FALSE in case an id3v1 tag isn't found, TRUE otherwise.
 */
int mp3id3v1 (FILE * fd, struct id3v1 * tag);

/*
 * Checks for ID3v2 data in fd and writes it to tag.
 * Returns FALSE in case an id3v2 tag isn't found, TRUE otherwise.
 */
int mp3id3v2 (FILE * fd, struct id3v2 * tag);

/*
 * Looks for id3v1 in fd and updates it according to args.
 * Returns TRUE if succeeded, FALSE otherwise.
 */
int mp3editv1 (FILE * fd, char*const* args, int const numarg);

/*
 * Prints the name's mp3 file info.
 */
char * mp3info (char *name);

/*
 * Splits name's file from start to end and writes that part to output.
 */
void mp3split (char const * name, char const * output,
               unsigned int const start, unsigned int const end);

/*
 * Updates the mp3 tag info of name's file.
 */
void mp3editag (char const * name, char* const* args, int const numarg);

struct idtable idindex[22];

static void mp3strings ();

static void getid3v2 (char const * buffer,
                      int const size, struct id3v2 * tag);

static int frameoffset (char * arg);

struct fileinfo mp3file;

static void mp3getinfo ();
static void mp3open (char const * name, enum fileperms rw);
static void mp3close();

int mp3header (char const * buffer, size_t count, struct frame_header * header)
{

    int i, sync, attr;

    /* first of all */
    mp3strings();

    header->id = BAD;
    header->layer = BAD;
    header->protected = BAD;
    header->bitrate = BAD;
    header->frequency = BAD;
    header->padding = 0;

    sync = FALSE;
    for (i=0; count > 1 && sync == FALSE; i++, count--)
        /* sync + mpeg 1 + layer 3 */
        if ( (buffer[i] & 0xff) == 0xff && (buffer[i+1] & 0xfa) == 0xfa )
            sync = TRUE;

    header->size = i;

    if (sync == TRUE)
    {
        attr = GET_MPEG(buffer[i]);
        switch (attr)
        {
        case 8:
            header->id = MPEG1;
            break;
        }

        attr = GET_LAYER(buffer[i]);
        switch (attr)
        {
        case 2:
            header->layer = LAYER3;
            break;
        }

        attr = GET_PROT(buffer[i++]);
        switch (attr)
        {
        case 0:
            header->protected = PROTECTED;
            break;
        default:
            header->protected = BLANK;
            break;
        }

        attr = GET_BRATE(buffer[i]);
        switch (attr)
        {
        case 16:
            header->bitrate = BRATE32;
            break;
        case 32:
            header->bitrate = BRATE40;
            break;
        case 48:
            header->bitrate = BRATE48;
            break;
        case 64:
            header->bitrate = BRATE56;
            break;
        case 80:
            header->bitrate = BRATE64;
            break;
        case 96:
            header->bitrate = BRATE80;
            break;
        case 112:
            header->bitrate = BRATE96;
            break;
        case 128:
            header->bitrate = BRATE112;
            break;
        case 144:
            header->bitrate = BRATE128;
            break;
        case 160:
            header->bitrate = BRATE160;
            break;
        case 176:
            header->bitrate = BRATE192;
            break;
        case 192:
            header->bitrate = BRATE224;
            break;
        case 208:
            header->bitrate = BRATE256;
            break;
        case 224:
            header->bitrate = BRATE320;
            break;
        }

        attr = GET_FREQ(buffer[i]);
        switch (attr)
        {
        case 0:
            header->frequency = FREQ44;
            break;
        case 4:
            header->frequency = FREQ48;
            break;
        case 8:
            header->frequency = FREQ32;
            break;
        }

        attr = GET_PADD(buffer[i]);
        switch (attr)
        {
        case 2:
            header->padding = 1;
            break;
        }

    }
    else
        return FALSE;

    /* NOTE: for layer II and III only */
    if (idindex[header->frequency].value != 0)
        return ((int)(144 * idindex[header->bitrate].value)/
                idindex[header->frequency].value + (header->padding ? 1 : 0));
    else
        return FALSE;
}

/*
 * Initiates the ID string table for each mp3 attribute.
 */
static void mp3strings ()
{

    strcpy (idindex[MPEG1].string, "MPEG Version 1");
    idindex[MPEG1].value = 0;

    strcpy (idindex[PROTECTED].string, "CRC Protected");
    idindex[PROTECTED].value = 0;

    strcpy (idindex[LAYER3].string, "LAYER III");
    idindex[LAYER3].value = 0;

    strcpy (idindex[BRATE32].string, "32 kbps");
    idindex[BRATE32].value = 32000;

    strcpy (idindex[BRATE40].string, "40 kbps");
    idindex[BRATE40].value = 40000;

    strcpy (idindex[BRATE48].string, "48 kbps");
    idindex[BRATE48].value = 48000;

    strcpy (idindex[BRATE56].string, "56 kbps");
    idindex[BRATE56].value = 56000;

    strcpy (idindex[BRATE64].string, "64 kbps");
    idindex[BRATE64].value = 64000;

    strcpy (idindex[BRATE80].string, "80 kbps");
    idindex[BRATE80].value = 80000;

    strcpy (idindex[BRATE96].string, "96 kbps");
    idindex[BRATE96].value = 96000;

    strcpy (idindex[BRATE112].string, "112 kbps");
    idindex[BRATE112].value = 112000;

    strcpy (idindex[BRATE128].string, "128 kbps");
    idindex[BRATE128].value = 128000;

    strcpy (idindex[BRATE160].string, "160 kbps");
    idindex[BRATE160].value = 160000;

    strcpy (idindex[BRATE192].string, "192 kbps");
    idindex[BRATE192].value = 192000;

    strcpy (idindex[BRATE224].string, "224 kbps");
    idindex[BRATE224].value = 224000;

    strcpy (idindex[BRATE256].string, "256 kbps");
    idindex[BRATE256].value = 256000;

    strcpy (idindex[BRATE320].string, "320 kbps");
    idindex[BRATE320].value = 320000;

    strcpy (idindex[FREQ44].string, "44,1 KHz");
    idindex[FREQ44].value = 44100;

    strcpy (idindex[FREQ48].string, "48 KHz");
    idindex[FREQ48].value = 48000;

    strcpy (idindex[FREQ32].string, "32 KHz");
    idindex[FREQ32].value = 32000;

    strcpy (idindex[BAD].string, "Not recognized");
    idindex[BAD].value = 0;

    strcpy (idindex[BLANK].string, "");
    idindex[BLANK].value = 0;

}

int mp3id3v1 (FILE * fd, struct id3v1 * tag)
{

    char buf[128];

    memset (tag->title, 0, 31);
    memset (tag->artist, 0, 31);
    memset (tag->album, 0, 31);
    memset (tag->year, 0, 5);
    memset (tag->comment, 0, 30);
    tag->track = 0;

    fseek(fd, -128, SEEK_END);
    fread(&buf, sizeof(char), 128, fd);

    if (buf[0] == 'T' && buf[1] == 'A' && buf[2] == 'G')
    {
        memcpy (tag->title, &buf[3], 30*sizeof(char));
        memcpy (tag->artist, &buf[33], 30*sizeof(char));
        memcpy (tag->album, &buf[63], 30*sizeof(char));
        memcpy (tag->year, &buf[93], 4*sizeof(char));
        memcpy (tag->comment, &buf[97], 29*sizeof(char));
        tag->track = (int) buf[126];
        return TRUE;
    }
    else
        return FALSE;

}

int mp3id3v2 (FILE * fd, struct id3v2 * tag)
{

    int id3size;
    char * buf;
    char id3[3];

    memset (id3, 0, 3);

    rewind(fd);
    fread (id3, sizeof(char), 3, fd);

    if (feof(fd))
        return FALSE;

    if (id3[0] == 'I' && id3[1] == 'D' && id3[2] == '3')
    {
        fseek (fd, 3, SEEK_CUR);
        fread (&id3size, sizeof(int), 1, fd);

        id3size = LITTLE_END (id3size);
        id3size = LITTLE_MESS (id3size);

        buf = (char*) malloc (id3size);
        fread (buf, sizeof(char), id3size, fd);

        tag->size = id3size;
        /* now we get the text frames */
        getid3v2 (buf, id3size, tag);

        free(buf);
        return TRUE;

    }

    return FALSE;

}

/* TODO: ID3v2 editing support */

/* TODO: cleaning */
int mp3editv1 (FILE * fd, char*const* data, int const numarg)
{

    int i, offset, track, j, len;
    char buf[128], frame[30];

    fseek(fd, -128, SEEK_END);
    fread(&buf, sizeof(char), 128, fd);

    if (buf[0] == 'T' && buf[1] == 'A' && buf[2] == 'G')
    {
        for (i=0; i<numarg; i+=2)
        {
            offset = frameoffset(data[i]);
            if (!offset)
                return FALSE;

            strncpy (frame, data[i+1], 30);
            len = strlen(frame);
            if (len < 30)
                for (j=len; j<30;j++)
                    frame[j] = '\0';

            fseek(fd, offset-128, SEEK_END);
            if (!strcmp(data[i], "year"))
                fwrite (frame, sizeof(char), 4,fd);
            else if (!strcmp(data[i], "track"))
            {
                track = atoi(data[i+1]);
                fwrite (&track, sizeof(char), 1,fd);
            }
            else if (!strcmp(data[i], "comment"))
                fwrite (frame, sizeof(char), 29,fd);
            else
                fwrite (frame, sizeof(char), 30,fd);
        }
        return TRUE;
    }
    else
        return FALSE;

}

/*
 * Checks if arg is a valid ID3v1 frame.
 * Returns its frame offset if valid, FALSE otherwise.
 */
static int frameoffset (char * arg)
{

    if (!strcmp(arg, "comment"))
        return 97;
    else if (!strcmp(arg, "title"))
        return 3;
    else if (!strcmp(arg, "artist"))
        return 33;
    else if (!strcmp(arg, "year"))
        return 93;
    else if (!strcmp(arg, "track"))
        return 126;
    else if (!strcmp(arg, "album"))
        return 63;

    return FALSE;

}

/*
 * Reads the id3v2 frame headers within buffer and saves the data we need in tag.
 */
static void getid3v2 ( char const * buffer,  int const size, struct id3v2 * tag)
{

    int i, framesize;

    tag->title = NULL;
    tag->artist = NULL;
    tag->track = NULL;
    tag->album = NULL;
    tag->comment = NULL;
    tag->year = NULL;

    i=0;
    while (i<size)
    {

        if (buffer[i] == 'T' && buffer[i+1] == 'I' &&
                buffer[i+2] == 'T' && buffer[i+3] == '2')
        {
            framesize =  ((int) buffer[i+4]) << 24;
            framesize = (((int) buffer[i+5]) << 16) | framesize;
            framesize = (((int) buffer[i+6]) << 8) | framesize;
            framesize = ((int) buffer[i+7]) | framesize;

            /* skip the frame header's flags and encoding byte */
            i+=11;

            tag->title = (char*) malloc(framesize);
            memcpy (tag->title, &buffer[i], framesize);

            tag->title[framesize-1] = '\0';
            i = i+framesize-1;

        }
        else if (buffer[i] == 'T' && buffer[i+1] == 'A' &&
                 buffer[i+2] == 'L' && buffer[i+3] == 'B')
        {
            framesize =  ((int) buffer[i+4]) << 24;
            framesize = (((int) buffer[i+5]) << 16) | framesize;
            framesize = (((int) buffer[i+6]) << 8) | framesize;
            framesize = ((int) buffer[i+7]) | framesize;

            /* skip the frame header's flags */
            i+=11;

            tag->album = (char*) malloc(framesize);
            memcpy (tag->album, &buffer[i], framesize);

            tag->album[framesize-1] = '\0';
            i = i+framesize-1;

        }
        else if (buffer[i] == 'T' && buffer[i+1] == 'P' &&
                 buffer[i+2] == 'E' && buffer[i+3] == '1')
        {
            framesize =  ((int) buffer[i+4]) << 24;
            framesize = (((int) buffer[i+5]) << 16) | framesize;
            framesize = (((int) buffer[i+6]) << 8) | framesize;
            framesize = ((int) buffer[i+7]) | framesize;

            /* skip the frame header's flags */
            i+=11;

            tag->artist = (char*) malloc(framesize);
            memcpy (tag->artist, &buffer[i], framesize);

            tag->artist[framesize-1] = '\0';
            i= i+framesize-1;

        }
        else if (buffer[i] == 'C' && buffer[i+1] == 'O' &&
                 buffer[i+2] == 'M' && buffer[i+3] == 'M')
        {
            framesize =  ((int) buffer[i+4]) << 24;
            framesize = (((int) buffer[i+5]) << 16) | framesize;
            framesize = (((int) buffer[i+6]) << 8) | framesize;
            framesize = ((int) buffer[i+7]) | framesize;

            /* skip the frame header's flags */
            i+=11;

            /* skip the language */
            i+=3;

            /* say good bye to short content description */
            while (buffer[i++] != '\0');

            framesize-=4;

            tag->comment = (char*) malloc(framesize);
            memcpy (tag->comment, &buffer[i], framesize-1);

            tag->comment[framesize-1] = '\0';
            i =i+framesize-1;

        }
        else if (buffer[i] == 'T' && buffer[i+1] == 'Y' &&
                 buffer[i+2] == 'E' && buffer[i+3] == 'R')
        {
            framesize =  ((int) buffer[i+4]) << 24;
            framesize = (((int) buffer[i+5]) << 16) | framesize;
            framesize = (((int) buffer[i+6]) << 8) | framesize;
            framesize = ((int) buffer[i+7]) | framesize;

            /* skip the frame header's flags */
            i+=11;

            tag->year = (char*) malloc(framesize);
            memcpy (tag->year, &buffer[i], framesize);
            tag->year[framesize-1] = '\0';
            i= i+framesize-1;

        }
        else if (buffer[i] == 'T' && buffer[i+1] == 'R' &&
                 buffer[i+2] == 'C' && buffer[i+3] == 'K')
        {
            framesize =  ((int) buffer[i+4]) << 24;
            framesize = (((int) buffer[i+5]) << 16) | framesize;
            framesize = (((int) buffer[i+6]) << 8) | framesize;
            framesize = ((int) buffer[i+7]) | framesize;

            /* skip the frame header's flags */
            i+=11;

            tag->track = (char*) malloc(framesize);
            memcpy (tag->track, &buffer[i], framesize);

            tag->track[framesize-1] = '\0';
            i = i+framesize-1;

        }
        else
            i++;

    }

}

/* TODO: cleaning */
char * mp3info (char * name)
{

    mp3open(name, READ_ONLY);

    mp3getinfo(name);

    if (mp3file.tagver == ID3V1)
        sprintf(mp3info_buffer, "Artist: %s\n Title: %s\n Album: %s\n Track: %d\n Year: %s\n Comment: %s\n",\
                mp3file.tag.artist, mp3file.tag.title, mp3file.tag.album, mp3file.tag.track,\
                mp3file.tag.year, mp3file.tag.comment);
    else if (mp3file.tagver == ID3V2)
    {
        sprintf(mp3info_buffer, "Artist: %s\n Title: %s\n Album: %s\n Track: %s\n Year: %s\n Comment: %s\n",\
                mp3file.tag2.artist, mp3file.tag2.title, mp3file.tag2.album, mp3file.tag2.track,\
                mp3file.tag2.year, mp3file.tag2.comment);
        free(mp3file.tag2.artist);
        free(mp3file.tag2.album);
        free(mp3file.tag2.track);
        free(mp3file.tag2.year);
        free(mp3file.tag2.title);
        free(mp3file.tag2.comment);
    }
    else
        sprintf(mp3info_buffer, "ERROR: No tag data found!\n");

    mp3close();

    return mp3info_buffer;
}

/* NOTE: it JUST works (we don't even have an index file) */

void mp3split (char const * name,  char const * output,
               unsigned int const start, unsigned int const end)
{

    FILE * fd;
    char frame[BUFSIZE], *tag;
    unsigned int i;
    int fsize;

    mp3open(name, READ_ONLY);
    /* we need the id3 version */
    mp3getinfo(name);

    fd = fopen (output, "wb");
    rewind(mp3file.fd);

    if (mp3file.tagver == ID3V2)
    {
        tag = (char*) malloc (sizeof(char)*mp3file.tag2.size+10);
        fread (tag, sizeof(char), mp3file.tag2.size+10, mp3file.fd);
        fwrite (tag, sizeof(char), mp3file.tag2.size+10, fd);
        free(tag);
        fread(frame, sizeof(char), BUFSIZE, mp3file.fd);
        fsize = mp3header(frame, BUFSIZE, &mp3file.header);
        fseek(mp3file.fd, mp3file.tag2.size+10, SEEK_SET );
        for (i=0; i<start*38; i++)
        {
            fread (frame, sizeof(char), fsize, mp3file.fd);

        }
        for (; i<end*38; i++)
        {
            fwrite(frame, sizeof(char),fsize, fd);
            fread(frame, sizeof(char), fsize, mp3file.fd);
        }
    }
    else
    {
        fread(frame, sizeof(char), BUFSIZE, mp3file.fd);
        fsize = mp3header(frame, BUFSIZE, &mp3file.header);
        rewind(mp3file.fd);
        for (i=0; i<start*38; i++)
        {
            fread (frame, sizeof(char), fsize, mp3file.fd);
        }
        for (; i<end*38; i++)
        {
            fwrite(frame, sizeof(char),fsize, fd);
            fread(frame, sizeof(char), fsize, mp3file.fd);
        }
    }

    fclose(fd);
    mp3close();

}

void mp3editag (char const * name, char* const * args, int const numarg)
{
    char mp3taged_error_buffer[4096];

    int changed;

    mp3open(name, READ_WRITE);

    mp3getinfo();

    changed=FALSE;
    if (mp3file.tagver == ID3V1)
        changed = mp3editv1(mp3file.fd, args, numarg);
    else if (mp3file.tagver == ID3V2)
        /*mp3editv2*/

        if (!changed)
        {
            sprintf (mp3taged_error_buffer, "%s: one or more tags couldn't be changed.\n", name);

            msgbox("najitool GUI mp3taged error", mp3taged_error_buffer);
        }

    mp3close();
    return;

}

/*
 * Gets the name's mp3 file tag info.
 * Returns id3version of name.
 */
static void mp3getinfo()
{

    if (!mp3id3v2(mp3file.fd, &mp3file.tag2))
    {
        if (!mp3id3v1 (mp3file.fd,&mp3file.tag))
        {
            mp3file.tagver = BADVERSION;
            return;
        }

        mp3file.tagver = ID3V1;
        return;
    }

    mp3file.tagver = ID3V2;
    return;

}

/*
 * Opens file named name for reading/writing .
 */
static void mp3open (char const* name, enum fileperms rw)
{
    char mp3open_buffer[2048];

    if (rw == READ_WRITE)
        mp3file.fd = fopen (name, "rb+");
    else
        mp3file.fd = fopen (name, "rb");

    if (mp3file.fd == NULL)
    {
        sprintf(mp3open_buffer, "mp3open: %s: %s", name, strerror(errno));
        msgbox("najitool GUI mp3open error", mp3open_buffer);

        exit(EXIT_FAILURE);
    }

}

/*
 * Closes the file descriptor.
 */
static void mp3close()
{
    fclose (mp3file.fd);

}
