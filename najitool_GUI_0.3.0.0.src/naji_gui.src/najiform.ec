#ifdef ECERE_STATIC
import static "ecere"
#else
import "ecere"
#endif
import "najicomm"
import "najicmds"
import "naji_ttt"
import "najicalc"
import "najihelp"
import "najimain"
import "najbatch"
#include "naji_gui.eh"

TabControl tabcontrol_naji_gui
{
    nativeDecorations = true;
    text = "najitool GUI 0.3.0.0 Made By NECDET COKYAZICI And Contributors, Public Domain 2003-2011";
    background = { r = 110, g = 161, b = 180 };
    borderStyle = fixedBevel;
    hasMinimize = true;
    hasClose = true;
    font = { "Verdana", 8.25f, bold = true };
    size = { 1024, 768 };
    tabCycle = true;

    icon = { ":res/naji_gui.png" };

    void OnRedraw(Surface surface)
    {
        ColorKey keys[2] = { {0x6EA1B4, 0.0f}, { white, 1.0f } };
        surface.Gradient(keys, sizeof(keys) / sizeof(ColorKey), 1, vertical, 1, 0, 1024-3, 33 - 3);
    }

};

tab_main tabmain { tabControl = tabcontrol_naji_gui };
tab_batch tabbatch { tabControl = tabcontrol_naji_gui };
tab_crypt tabcrypt { tabControl = tabcontrol_naji_gui };
tab_length tablength { tabControl = tabcontrol_naji_gui };
tab_split tabsplit { tabControl = tabcontrol_naji_gui };
tab_database tabdatabase { tabControl = tabcontrol_naji_gui };
tab_mathgame tabmathgame { tabControl = tabcontrol_naji_gui };
tab_patch tabpatch { tabControl = tabcontrol_naji_gui };

class tab_crypt : Tab
{
    text = "Crypt";
    background = { r = 110, g = 161, b = 180 };
    font = { "Verdana", 8.25f, bold = true };
    size = { 1024, 768 };

    char najcrypt_input_file_path[MAX_LOCATION];
    char najcrypt_output_file_path[MAX_LOCATION];

#define MIN_PASS_LENGTH 5
    char letter;
    char *naji_data;
    char password[256];
    char najcrypt_error_buffer[4069];
    int strength;
    int pwd_len;
    long ifilesize;

    Label najitool_homepage_label
    {
        this, text = "http://najitool.sf.net/", foreground = blue, font = { "Verdana", 8.25f, bold = true, underline = true }, position = { 16, 8 }, cursor = ((GuiApplication)__thisModule).GetCursor(hand);

        bool OnLeftButtonDown(int x, int y, Modifiers mods)
        {

            ShellOpen("http://najitool.sf.net/");

            return Label::OnLeftButtonDown(x, y, mods);
        }
    };
    BitmapResource najitool_logo_bitmap { ":res/najitool.pcx", window = this };

    void OnRedraw(Surface surface)
    {
        ColorKey keys[2] = { {0x6EA1B4, 0.0f}, { white, 1.0f } };
        surface.Gradient(keys, sizeof(keys) / sizeof(ColorKey), 1, vertical, 1, 0, 1024-3, 768 - 3);
        surface.Blit(najitool_logo_bitmap.bitmap, 8, 24, 0,0, najitool_logo_bitmap.bitmap.width, najitool_logo_bitmap.bitmap.height);
        Update(null);
    }

    Button najcrypt_encrypt_button
    {
        this, text = "Encrypt", position = { 432, 384 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            naji_enc(najcrypt_input_file_path, najcrypt_output_file_path);
            return true;
        }
    };
    Button najcrypt_decrypt_button
    {
        this, text = "Decrypt", position = { 504, 384 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            naji_dec(najcrypt_input_file_path, najcrypt_output_file_path);
            return true;
        }
    };
    Button najcrypt_128_bit_radio
    {
        this, text = "128 Bit", position = { 632, 192 }, isRadio = true;

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            strength=16;

            only_supported();
            return true;
        }
    };
    Button najcrypt_256_bit_radio
    {
        this, text = "256 Bit", position = { 632, 216 }, isRadio = true;

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            strength=32;

            only_supported();

            return true;
        }
    };
    Button najcrypt_512_bit_radio
    {
        this, text = "512 Bit", position = { 632, 240 }, isRadio = true;

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            strength=64;

            only_supported();

            return true;
        }
    };
    Button najcrypt_1024_bit_radio
    {
        this, text = "1024 Bit", position = { 632, 264 }, isRadio = true;

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            strength=128;
            return true;
        }

        bool NotifyPushed(Button button, int x, int y, Modifiers mods)
        {

            najcrypt_1024_bit_radio.bitmap = { "<:ecere>elements/optionBoxSelectedDown.png", transparent = true };
            najcrypt_2048_bit_radio.bitmap = { "<:ecere>elements/optionBoxUp.png", transparent = true };

            return true;
        }
    };
    Button najcrypt_2048_bit_radio
    {
        this, text = "2048 Bit", position = { 632, 288 }, isRadio = true;

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            strength=256;
            return true;
        }

        bool NotifyPushed(Button button, int x, int y, Modifiers mods)
        {

            najcrypt_2048_bit_radio.bitmap = { "<:ecere>elements/optionBoxSelectedDown.png", transparent = true };
            najcrypt_1024_bit_radio.bitmap = { "<:ecere>elements/optionBoxUp.png", transparent = true };

            return true;
        }
    };
    Label najcrypt_encryption_strength_label
    {
        this, text = "Choose encryption strength:", position = { 584, 112 };

    };
    Button najcrypt_input_file_button
    {
        this, text = "Input File:", size = { 111, 21 }, position = { 344, 24 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            if (input_file_1_dialog.Modal() == ok)
            {
                strcpy(najcrypt_input_file_path, input_file_1_dialog.filePath);
                najcrypt_input_file_edit_box.contents = input_file_1_dialog.filePath;
            }

            return true;
        }
    };
    Button najcrypt_output_file_button
    {
        this, text = "Output File:", size = { 111, 21 }, position = { 344, 48 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            output_file_1_dialog.type=save;

            if (output_file_1_dialog.Modal() == ok)
            {
                strcpy(najcrypt_output_file_path, output_file_1_dialog.filePath);
                najcrypt_output_file_edit_box.contents = output_file_1_dialog.filePath;
            }

            return true;
        }
    };
    EditBox najcrypt_input_file_edit_box
    {
        this, text = "najcrypt_input_file_edit_box", size = { 494, 19 }, position = { 456, 24 };

        bool NotifyModified(EditBox editBox)
        {
            strcpy(najcrypt_input_file_path, najcrypt_input_file_edit_box.contents);
            return true;
        }
    };
    EditBox najcrypt_output_file_edit_box
    {
        this, text = "najcrypt_output_file_edit_box", size = { 494, 19 }, position = { 456, 48 };

        bool NotifyModified(EditBox editBox)
        {
            strcpy(najcrypt_output_file_path, najcrypt_output_file_edit_box.contents);
            return true;
        }
    };
    Label najcrypt_password_label { this, text = "Password:", position = { 360, 344 } };
    EditBox najcrypt_password_edit_box { this, text = "najcrypt_password_edit_box", size = { 518, 19 }, position = { 432, 344 } };

    bool OnCreate(void)
    {

        if (!strcmp(najitool_language, "English"))
        {

            najcrypt_encrypt_button.text = "Encrypt";
            najcrypt_decrypt_button.text = "Decrypt";
            najcrypt_password_label.text = "Password:";
            najcrypt_input_file_button.text = "Input File:";
            najcrypt_output_file_button.text = "Output File:";
            najcrypt_encryption_strength_label.text = "Choose encryption strength:";

        }

        else if (!strcmp(najitool_language, "Turkish"))
        {

            najcrypt_encrypt_button.text = "Sifrele";
            najcrypt_decrypt_button.text = "Coz";
            najcrypt_password_label.text = "Sifre:";
            najcrypt_input_file_button.text = "Okunan Dosya:";
            najcrypt_output_file_button.text = "Yazilan Dosya:";
            najcrypt_encryption_strength_label.text = "Sifreleme gucu sec:";
        }

        rndinit();

        strength=128;
        pwd_len=0;

        ifilesize=0;

        return true;
    }

    void endnaji(int error_level)
    {
        wipe_pwd();
        exit(error_level);
    }

    int get_password(void)
    {
        strcpy(password, najcrypt_password_edit_box.contents);
        pwd_len = strlen(password);

        if (pwd_len < MIN_PASS_LENGTH)
        {

            if (!strcmp(najitool_language, "English"))
            {
                sprintf(najcrypt_error_buffer, "Password must be at least %d characters in length. Please choose a longer password.", MIN_PASS_LENGTH);
                msgbox("najitool GUI najcrypt error", najcrypt_error_buffer);
            }
            else if (!strcmp(najitool_language, "Turkish"))
            {
                sprintf(najcrypt_error_buffer, "Sifre en azindan %d karakter uzunlukta olmasi lazim. Lutfen daha uzun bir sifre secin.", MIN_PASS_LENGTH);
                msgbox("najitool GUI najcrypt hata", najcrypt_error_buffer);
            }

            return 0;
        }

    }

    void wipe_pwd(void)
    {
        int i=0;
        for (i=0; i<pwd_len; i++)
            password[i] = (char) rand() % (char) 255;
        najcrypt_password_edit_box.Clear();
    }

    int check_ps(void)
    {
        int a=0;

        for (a=0; a<pwd_len; a++)
            if (password[a] > strength)
            {

                if (!strcmp(najitool_language, "English"))
                {
                    sprintf(najcrypt_error_buffer, "The digit %d in the password contains a character with a value larger than %d.\n"
                            "This is currently unsupported in this version on %d Bit encryption mode. Please choose a different password.\n", a, strength, (strength * 8));

                    msgbox("najitool GUI najcrypt error", najcrypt_error_buffer);
                }

                else if (!strcmp(najitool_language, "Turkish"))
                {
                    sprintf(najcrypt_error_buffer,

                            "Sifre rakam %d da %d dan daha buyuk bir degere sahip bir karakter ideriyor.\n"
                            "Bu su anda %d Bit sifreleme modunda bu versiyon da desteklenmiyor. Farkli bir sifre secin.\n", a, strength, (strength * 8));

                    msgbox("najitool GUI najcrypt hata", najcrypt_error_buffer);
                }

                return 0;
            }

    }

    void naji_enc(char *namein, char *nameout)
    {
        int a=0;
        int i=0;

        if (strength == 16)
        {
            only_supported();
            return;
        }

        if (strength == 32)
        {
            only_supported();
            return;
        }

        if (strength == 64)
        {
            only_supported();
            return;
        }

        if (get_password() == 0)
            return;

        if (check_ps() == 0)
            return;

        najin(namein);
        najout(nameout);

        naji_data = (char *) malloc( sizeof(char *) * strength);

        ifilesize = najinsize();

        while (ifilesize != 0)
        {
            ifilesize--;

            letter = (char) fgetc(naji_input);

            a++;

            if (a > pwd_len) a=0;

            for (i=0; i<strength; i++)
                naji_data[i] = (char) rand() % (char) 255;

            naji_data[(unsigned char)password[a]] = ~letter;

            for (i=0; i<strength; i++)
                fputc(naji_data[i], naji_output);
        }

        wipe_pwd();

        najinclose();
        najoutclose();

        if (!strcmp(najitool_language, "English"))
            msgbox("najitool GUI najcrypt", "Encryption Complete.");

        else if (!strcmp(najitool_language, "Turkish"))
            msgbox("najitool GUI najcrypt", "Sifreleme Tamamlandi.");

    }

    void naji_dec(char *namein, char *nameout)
    {
        int a=0;
        int i=0;

        if (strength == 16)
        {
            only_supported();
            return;
        }

        if (strength == 32)
        {
            only_supported();
            return;
        }

        if (strength == 64)
        {
            only_supported();
            return;
        }

        if (get_password() == 0)
            return;

        if (check_ps() == 0)
            return;

        najin(namein);
        najout(nameout);

        naji_data = (char *) malloc( sizeof(char *) * strength);

        while (1)
        {
            a++;

            if (a > pwd_len) a=0;

            for (i=0; i<strength; i++)
                naji_data[i] = (char) fgetc(naji_input);

            naji_data[strength] = '\0';

            if (feof(naji_input))
                break;

            letter = ~naji_data[(unsigned char)password[a]];

            fputc(letter, naji_output);
        }

        najinclose();
        najoutclose();
        wipe_pwd();

        if (!strcmp(najitool_language, "English"))
            msgbox("najitool GUI najcrypt", "Decryption Complete.");

        else if (!strcmp(najitool_language, "Turkish"))
            msgbox("najitool GUI najcrypt", "Desifreleme Tamamlandi.");

    }

    void only_supported(void)
    {

        if (!strcmp(najitool_language, "English"))
            msgbox("najitool GUI najcrypt error", "Sorry, only 1024 Bit and 2048 Bit encryption is available in this version.");
        else if (!strcmp(najitool_language, "Turkish"))
            msgbox("najitool GUI najcrypt hata", "Maalesef, sadece 1024 Bit ve 2048 Bit sifreleme var bu versyonda.");

    }
}

static String length_string_array[8] =
{
    "cm",
    "feet",
    "inches",
    "km",
    "meters",
    "miles",
    "mm",
    "yards"
};

class tab_length : Tab
{
    text = "Length";
    background = { r = 110, g = 161, b = 180 };
    font = { "Verdana", 8.25f, bold = true };
    size = { 1024, 768 };

    int i;
    char length_from_buffer[100];
    char length_to_buffer[100];
    DataRow length_from_row;
    DataRow length_to_row;

    Label najitool_homepage_label
    {
        this, text = "http://najitool.sf.net/", foreground = blue, font = { "Verdana", 8.25f, bold = true, underline = true }, position = { 16, 8 }, cursor = ((GuiApplication)__thisModule).GetCursor(hand);

        bool OnLeftButtonDown(int x, int y, Modifiers mods)
        {

            ShellOpen("http://najitool.sf.net/");

            return Label::OnLeftButtonDown(x, y, mods);
        }
    };
    BitmapResource najitool_logo_bitmap { ":res/najitool.pcx", window = this };

    void OnRedraw(Surface surface)
    {
        ColorKey keys[2] = { {0x6EA1B4, 0.0f}, { white, 1.0f } };
        surface.Gradient(keys, sizeof(keys) / sizeof(ColorKey), 1, vertical, 1, 0, 1024-3, 768 - 3);
        surface.Blit(najitool_logo_bitmap.bitmap, 8, 24, 0,0, najitool_logo_bitmap.bitmap.width, najitool_logo_bitmap.bitmap.height);
        Update(null);
    }
    Label length_input_label { this, text = "Input:", position = { 224, 248 } };
    Label length_output_label { this, text = "Output:", position = { 416, 248 } };
    EditBox length_output_edit_box { this, text = "length_output_edit_box", size = { 158, 19 }, position = { 408, 264 }, readOnly = true, noCaret = true };
    DropBox length_to_drop_box
    {
        this, text = "length_to_drop_box", size = { 160, 24 }, position = { 408, 208 };

        bool NotifySelect(DropBox dropBox, DataRow row, Modifiers mods)
        {

            if (row)
            {

                strcpy(length_to_buffer, row.string);

            }

            return true;
        }
    };
    Label length_to_label { this, text = "To:", position = { 408, 184 } };
    EditBox length_input_edit_box
    {
        this, text = "length_input_edit_box", size = { 150, 19 }, position = { 224, 264 };

        void NotifyUpdate(EditBox editBox)
        {

            length_output_edit_box.Clear();
            length_output_edit_box.Printf("%s to %s", length_from_buffer, length_to_buffer);

            if (!strcmp("meters", length_from_buffer))
                if (!strcmp("mm", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", meters_to_mm( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("inches", length_from_buffer))

                if (!strcmp("km", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", inches_to_km( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("inches", length_from_buffer))

                if (!strcmp("cm", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", inches_to_cm( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("mm", length_from_buffer))

                if (!strcmp("meters", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", mm_to_meters( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("km", length_from_buffer))

                if (!strcmp("feet", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", km_to_feet( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("cm", length_from_buffer))

                if (!strcmp("inches", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", cm_to_inches( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("yards", length_from_buffer))

                if (!strcmp("mm", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", yards_to_mm( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("feet", length_from_buffer))

                if (!strcmp("km", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", feet_to_km( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("feet", length_from_buffer))

                if (!strcmp("cm", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", feet_to_cm( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("mm", length_from_buffer))

                if (!strcmp("yards", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", mm_to_yards( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("km", length_from_buffer))

                if (!strcmp("yards", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", km_to_yards( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("cm", length_from_buffer))

                if (!strcmp("feet", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", cm_to_feet( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("yards", length_from_buffer))

                if (!strcmp("cm", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", yards_to_cm( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("yards", length_from_buffer))

                if (!strcmp("km", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", yards_to_km( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("feet", length_from_buffer))

                if (!strcmp("inches", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", feet_to_inches( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("cm", length_from_buffer))

                if (!strcmp("yards", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", cm_to_yards( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("miles", length_from_buffer))

                if (!strcmp("km", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", miles_to_km( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("inches", length_from_buffer))

                if (!strcmp("feet", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", inches_to_feet( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("yards", length_from_buffer))

                if (!strcmp("inches", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", yards_to_inches( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("km", length_from_buffer))

                if (!strcmp("miles", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", km_to_miles( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("meters", length_from_buffer))

                if (!strcmp("cm", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", meters_to_cm( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("inches", length_from_buffer))

                if (!strcmp("yards", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", inches_to_yards( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("miles", length_from_buffer))

                if (!strcmp("meters", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", miles_to_meters( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("cm", length_from_buffer))

                if (!strcmp("meters", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", cm_to_meters( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("yards", length_from_buffer))

                if (!strcmp("feet", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", yards_to_feet( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("meters", length_from_buffer))

                if (!strcmp("miles", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", meters_to_miles( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("meters", length_from_buffer))

                if (!strcmp("feet", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", meters_to_feet( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("feet", length_from_buffer))

                if (!strcmp("yards", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", feet_to_yards( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("miles", length_from_buffer))

                if (!strcmp("yards", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", miles_to_yards( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("feet", length_from_buffer))

                if (!strcmp("meters", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", feet_to_meters( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("yards", length_from_buffer))

                if (!strcmp("meters", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", yards_to_meters( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("yards", length_from_buffer))

                if (!strcmp("miles", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", yards_to_miles( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("meters", length_from_buffer))

                if (!strcmp("inches", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", meters_to_inches( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("meters", length_from_buffer))

                if (!strcmp("yards", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", meters_to_yards( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("miles", length_from_buffer))

                if (!strcmp("feet", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", miles_to_feet( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("inches", length_from_buffer))

                if (!strcmp("meters", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", inches_to_meters( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("km", length_from_buffer))

                if (!strcmp("mm", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", km_to_mm( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("feet", length_from_buffer))

                if (!strcmp("miles", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", feet_to_miles( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("cm", length_from_buffer))

                if (!strcmp("mm", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", cm_to_mm( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("mm", length_from_buffer))

                if (!strcmp("km", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", mm_to_km( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("miles", length_from_buffer))

                if (!strcmp("inches", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", miles_to_inches( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("mm", length_from_buffer))

                if (!strcmp("cm", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", mm_to_cm( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("km", length_from_buffer))

                if (!strcmp("cm", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", km_to_cm( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("inches", length_from_buffer))

                if (!strcmp("miles", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", inches_to_miles( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("inches", length_from_buffer))

                if (!strcmp("mm", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", inches_to_mm( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("cm", length_from_buffer))

                if (!strcmp("km", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", cm_to_km( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("miles", length_from_buffer))

                if (!strcmp("cm", length_to_buffer))

                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", miles_to_cm( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("mm", length_from_buffer))

                if (!strcmp("inches", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", mm_to_inches( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("km", length_from_buffer))

                if (!strcmp("meters", length_to_buffer))

                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", km_to_meters( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("cm", length_from_buffer))

                if (!strcmp("miles", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", cm_to_miles( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("feet", length_from_buffer))

                if (!strcmp("mm", length_to_buffer))

                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", feet_to_mm( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("meters", length_from_buffer))

                if (!strcmp("km", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", meters_to_km( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("miles", length_from_buffer))

                if (!strcmp("mm", length_to_buffer))

                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", miles_to_mm( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("mm", length_from_buffer))

                if (!strcmp("feet", length_to_buffer))

                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", mm_to_feet( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("km", length_from_buffer))

                if (!strcmp("inches", length_to_buffer))

                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", km_to_inches( atof(length_input_edit_box.contents) ) );
                }

            if (!strcmp("mm", length_from_buffer))

                if (!strcmp("miles", length_to_buffer))
                {
                    length_output_edit_box.Clear();
                    length_output_edit_box.Printf("%f", mm_to_miles( atof(length_input_edit_box.contents) ) );
                }

        }
    };
    Label length_from_label { this, text = "From:", position = { 224, 184 } };
    DropBox length_from_drop_box
    {
        this, text = "length_from_drop_box", size = { 144, 24 }, position = { 224, 208 };

        bool NotifySelect(DropBox dropBox, DataRow row, Modifiers mods)
        {

            if (row)
            {

                strcpy(length_from_buffer, row.string);

            }

            return true;
        }
    };

    bool OnCreate(void)
    {

        if (!strcmp(najitool_language, "English"))
        {

            length_from_label.text = "From:";
            length_to_label.text = "To:";
            length_input_label.text = "Input:";
            length_output_label.text = "Output:";

        }

        if (!strcmp(najitool_language, "Turkish"))
        {

            length_from_label.text = "Bundan:";
            length_to_label.text = "Suna:";
            length_input_label.text = "Sunu Cevir:";
            length_output_label.text = "Sonuc:";

        }

        length_from_drop_box.Clear();

        for (i=0; i<8; i++)
            length_from_row = length_from_drop_box.AddString(length_string_array[i]);

        length_to_drop_box.Clear();

        for (i=0; i<8; i++)
            length_to_row = length_to_drop_box.AddString(length_string_array[i]);

        return true;
    }
}

static String splitter_sizes_string_array[4] =
{
    "bytes",
    "kb",
    "mb",
    "gb",
};

class tab_split : Tab
{
    text = "Split";
    background = { r = 110, g = 161, b = 180 };
    font = { "Verdana", 8.25f, bold = true };
    size = { 1024, 768 };

    int i;
    DataRow splitter_sizes_drop_box_row;

    Label najitool_homepage_label
    {
        this, text = "http://najitool.sf.net/", foreground = blue, font = { "Verdana", 8.25f, bold = true, underline = true }, position = { 16, 8 }, cursor = ((GuiApplication)__thisModule).GetCursor(hand);

        bool OnLeftButtonDown(int x, int y, Modifiers mods)
        {

            ShellOpen("http://najitool.sf.net/");

            return Label::OnLeftButtonDown(x, y, mods);
        }
    };
    BitmapResource najitool_logo_bitmap { ":res/najitool.pcx", window = this };

    void OnRedraw(Surface surface)
    {
        ColorKey keys[2] = { {0x6EA1B4, 0.0f}, { white, 1.0f } };
        surface.Gradient(keys, sizeof(keys) / sizeof(ColorKey), 1, vertical, 1, 0, 1024-3, 768 - 3);
        surface.Blit(najitool_logo_bitmap.bitmap, 8, 24, 0,0, najitool_logo_bitmap.bitmap.width, najitool_logo_bitmap.bitmap.height);
        Update(null);
    }
    Button splitter_select_a_split_file_button
    {
        this, text = "Select one of the split files, (.0, .1, .2, .3, etc) they will all be joined automatically", position = { 216, 392 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            if (input_file_1_dialog.Modal() == ok)
            {
                strcpy(splitter_a_split_file_path, input_file_1_dialog.filePath);
                splitter_a_split_file_edit_box.contents = input_file_1_dialog.filePath;
            }

            return true;
        }
    };
    EditBox splitter_a_split_file_edit_box { this, text = "splitter_a_split_file_edit_box", size = { 542, 19 }, position = { 216, 416 }, readOnly = true };
    Button splitter_input_file_button
    {
        this, text = "Input file:", size = { 108, 21 }, position = { 216, 176 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            if (input_file_1_dialog.Modal() == ok)
            {
                strcpy(splitter_input_file_path, input_file_1_dialog.filePath);
                splitter_input_file_edit_box.contents = input_file_1_dialog.filePath;
            }

            return true;
        }
    };
    Label splitter_split_label { this, text = "Split", font = { "Verdana", 16, bold = true }, position = { 216, 104 } };
    Label splitter_join_label { this, text = "Join", font = { "Verdana", 16, bold = true }, position = { 216, 352 } };
    Button splitter_split_button
    {
        this, text = "Split", position = { 216, 280 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            if (atoi(splitter_size_edit_box.contents) == 0)
            {

                if (!strcmp(najitool_language, "English"))
                    msgbox("najitool File Splitter error", "Cannot split files into 0 size pieces..");
                else if (!strcmp(najitool_language, "Turkish"))
                    msgbox("najitool Dosya Bolucu Hata", "0 boyut parcali dosya bolunmez.");

                return true;
            }

            if (!strcmp(splitter_size_measurement, "bytes"))
            {
                bytsplit(splitter_input_file_edit_box.contents, atoi(splitter_size_edit_box.contents), splitter_output_folder_edit_box.contents);

                if (!strcmp(najitool_language, "English"))
                    msgbox("najitool GUI File Splitter", "File splitting complete.");
                else if (!strcmp(najitool_language, "Turkish"))
                    msgbox("najitool GUI Dosya Bolucu", "Dosya bolunmesi tamamlandi.");
            }

            else if (!strcmp(splitter_size_measurement, "kb"))
            {
                kbsplit(splitter_input_file_edit_box.contents, atoi(splitter_size_edit_box.contents), splitter_output_folder_edit_box.contents);
                if (!strcmp(najitool_language, "English"))
                    msgbox("najitool GUI File Splitter", "File splitting complete.");
                else if (!strcmp(najitool_language, "Turkish"))
                    msgbox("najitool GUI Dosya Bolucu", "Dosya bolunmesi tamamlandi.");
            }

            else if (!strcmp(splitter_size_measurement, "mb"))
            {
                mbsplit(splitter_input_file_edit_box.contents, atoi(splitter_size_edit_box.contents), splitter_output_folder_edit_box.contents);
                if (!strcmp(najitool_language, "English"))
                    msgbox("najitool GUI File Splitter", "File splitting complete.");
                else if (!strcmp(najitool_language, "Turkish"))
                    msgbox("najitool GUI Dosya Bolucu", "Dosya bolunmesi tamamlandi.");
            }

            else if (!strcmp(splitter_size_measurement, "gb"))
            {
                gbsplit(splitter_input_file_edit_box.contents, atoi(splitter_size_edit_box.contents), splitter_output_folder_edit_box.contents);
                if (!strcmp(najitool_language, "English"))
                    msgbox("najitool GUI File Splitter", "File splitting complete.");
                else if (!strcmp(najitool_language, "Turkish"))
                    msgbox("najitool GUI Dosya Bolucu", "Dosya bolunmesi tamamlandi.");
            }

            return true;
        }
    };
    Button splitter_join_button
    {
        this, text = "Join", position = { 216, 488 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            StripExtension(splitter_a_split_file_path);
            mjoin(splitter_a_split_file_path, splitter_join_output_file_path);

            return true;
        }
    };
    EditBox splitter_join_output_file_edit_box
    {
        this, text = "splitter_join_output_file_edit_box", size = { 446, 19 }, position = { 312, 448 };

        bool NotifyModified(EditBox editBox)
        {
            strcpy(splitter_join_output_file_path, splitter_join_output_file_edit_box.contents);
            return true;
        }
    };
    Button splitter_output_file_button
    {
        this, text = "Output File:", position = { 216, 448 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            output_file_1_dialog.type=save;

            if (output_file_1_dialog.Modal() == ok)
            {
                strcpy(splitter_join_output_file_path, output_file_1_dialog.filePath);
                splitter_join_output_file_edit_box.contents = output_file_1_dialog.filePath;
            }

            return true;
        }
    };
    EditBox splitter_input_file_edit_box
    {
        this, text = "splitter_input_file_edit_box", size = { 382, 19 }, position = { 376, 176 };

        bool NotifyModified(EditBox editBox)
        {
            strcpy(splitter_input_file_path, splitter_input_file_edit_box.contents);
            return true;
        }
    };
    Button splitter_output_folder_button
    {
        this, text = "Output Folder:", position = { 216, 240 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            output_folder_dialog.type=selectDir;

            if (output_folder_dialog.Modal() == ok)
            {
                strcpy(splitter_output_folder_path, output_folder_dialog.filePath);
                splitter_output_folder_edit_box.contents = output_folder_dialog.filePath;
            }

            return true;
        }
    };
    EditBox splitter_output_folder_edit_box
    {
        this, text = "splitter_output_folder_edit_box", size = { 382, 19 }, position = { 376, 240 };

        bool NotifyModified(EditBox editBox)
        {
            strcpy(splitter_output_folder_path, splitter_output_folder_edit_box.contents);

            return true;
        }
    };
    EditBox splitter_size_edit_box
    {
        this, text = "splitter_size_edit_box", size = { 294, 19 }, position = { 376, 208 };

        bool NotifyModified(EditBox editBox)
        {

            return true;
        }
    };
    DropBox splitter_sizes_drop_box
    {
        this, text = "splitter_sizes_drop_box", size = { 80, 24 }, position = { 680, 208 };

        bool NotifySelect(DropBox dropBox, DataRow row, Modifiers mods)
        {
            if (row)
            {

                strcpy(splitter_size_measurement, row.string);

            }

            return true;
        }
    };
    Label splitter_sizeof_peices_label { this, text = "Size of file pieces:", position = { 216, 208 } };

    bool OnCreate(void)
    {
        if (!strcmp(najitool_language, "English"))
        {

            splitter_split_label.text="Split";
            splitter_input_file_button.text="Input file:";
            splitter_sizeof_peices_label.text = "Size of file pieces:";
            splitter_split_button.text="Split";

            splitter_join_label.text="Join";
            splitter_select_a_split_file_button.text="Select one of the split files, (.0, .1, .2, .3, etc) they will all be joined automatically";
            splitter_output_folder_button.text="Output Folder:";
            splitter_join_button.text="Join";
        }
        if (!strcmp(najitool_language, "Turkish"))
        {

            splitter_split_label.text="Dosya Bol";
            splitter_input_file_button.text="Okunan Dosya:";
            splitter_sizeof_peices_label.text = "Dosya Parcalar boyutu:";
            splitter_split_button.text="Split";

            splitter_join_label.text="Birlestir";
            splitter_select_a_split_file_button.text="Herhangi bolulen dosya sec, (.0, .1, .2, .3, vb) hepsi otomatik olarak birlestirilcek";
            splitter_output_folder_button.text="Yazilan Klasor:";
            splitter_join_button.text="Birlestir";
        }

        splitter_sizes_drop_box.Clear();

        for (i=0; i<4; i++)
            splitter_sizes_drop_box_row = splitter_sizes_drop_box.AddString(splitter_sizes_string_array[i]);

        splitter_sizes_drop_box.currentRow = splitter_sizes_drop_box_row;

        sprintf(splitter_size_measurement, "gb");

        return true;
    }

    void bytsplit(char *namein, unsigned long peice_size, char *output_folder)
    {
        int a;

        unsigned long size_reached;
        unsigned long peice;
        char bytsplit_filename_buffer[4096];
        char namein2[4096];

        size_reached = 0;
        peice = 0;

        najin(namein);

        GetLastDirectory(namein, namein2);

        while (1)
        {

            sprintf(bytsplit_filename_buffer, "%s/%s.%u", output_folder, namein2, peice);
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

    void kbsplit(char *namein, unsigned long peice_size, char *output_folder)
    {
        int a;
        unsigned long i;

        unsigned long size_reached;
        unsigned long peice;
        char kbsplit_filename_buffer[4096];
        char namein2[4096];

        size_reached = 0;
        peice = 0;

        najin(namein);

        GetLastDirectory(namein, namein2);

        while (1)
        {

            sprintf(kbsplit_filename_buffer, "%s/%s.%u", output_folder, namein2, peice);
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

    void mbsplit(char *namein, unsigned long peice_size, char *output_folder)
    {
        int a;
        unsigned long i;

        unsigned long size_reached;
        unsigned long peice;
        char mbsplit_filename_buffer[4096];
        char namein2[4096];

        size_reached = 0;
        peice = 0;

        najin(namein);
        GetLastDirectory(namein, namein2);

        while (1)
        {

            sprintf(mbsplit_filename_buffer, "%s/%s.%u", output_folder, namein2, peice);
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

    void gbsplit(char *namein, unsigned long peice_size, char *output_folder)
    {
        int a;
        unsigned long i;

        unsigned long size_reached;
        unsigned long peice;

        char gbsplit_filename_buffer[4096];
        char namein2[4096];

        size_reached = 0;
        peice = 0;

        najin(namein);
        GetLastDirectory(namein, namein2);

        while (1)
        {
            sprintf(gbsplit_filename_buffer, "%s/%s.%u", output_folder, namein2, peice);
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

    void mjoin(char *namein_original_filename, char *nameout_joined_output_file)
    {
        int a;

        unsigned long peice;
        char mjoin_filename_buffer[4096];

        peice = 0;

        najout(nameout_joined_output_file);

        while (1)
        {

            sprintf(mjoin_filename_buffer, "%s.%u", namein_original_filename, peice);
            naji_input = fopen(mjoin_filename_buffer, "rb");

            if (naji_input == NULL)
                break;

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

        if (!strcmp(najitool_language, "English"))
            msgbox("najitool GUI File Joiner", "File joining complete.");
        else if (!strcmp(najitool_language, "Turkish"))
            msgbox("najitool GUI Dosya Birlestirici", "Dosya birlesmesi tamamlandi.");

    }
}

class tab_database : Tab
{
    text = "Database";
    background = { r = 110, g = 161, b = 180 };
    font = { "Verdana", 8.25f, bold = true };
    size = { 1024, 768 };
    position = { 8, 16 };

    void OnRedraw(Surface surface)
    {
        ColorKey keys[2] = { {0x6EA1B4, 0.0f}, { white, 1.0f } };
        surface.Gradient(keys, sizeof(keys) / sizeof(ColorKey), 1, vertical, 1, 0, 1024-3, 768 - 3);
        Update(null);
    }

    Button clear_all_entry_items_button
    {
        this, text = "Clear All Entry Items", position = { 8, 680 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            title_edit_box.Clear();
            full_name_edit_box.Clear();
            gender_edit_box.Clear();
            date_of_birth_edit_box.Clear();
            marital_status_edit_box.Clear();
            naji_db_height_edit_box.Clear();
            naji_db_weight_edit_box.Clear();
            naji_db_build_edit_box.Clear();
            hair_color_edit_box.Clear();
            eye_color_edit_box.Clear();
            favourite_food_edit_box.Clear();
            favourite_drink_edit_box.Clear();
            home_number_edit_box.Clear();
            work_number_edit_box.Clear();
            fax_number_edit_box.Clear();
            cell_number_edit_box.Clear();
            home_address_edit_box.Clear();
            work_address_edit_box.Clear();
            occupation_edit_box.Clear();
            naji_db_email_edit_box.Clear();
            naji_db_website_edit_box.Clear();
            mothers_full_name_edit_box.Clear();
            mothers_dob_edit_box.Clear();
            fathers_full_name_edit_box.Clear();
            fathers_dob_edit_box.Clear();
            number_of_sisters_edit_box.Clear();
            number_of_brothers_edit_box.Clear();
            number_of_children_edit_box.Clear();

            return true;
        }
    };
    Label title_label { this, text = "Title:", position = { 8, 16 } };
    Label full_name_label { this, text = "Full name:", position = { 8, 40 } };
    Label gender_label { this, text = "Gender:", position = { 8, 64 } };
    Label date_of_birth_label { this, text = "Date of birth:", position = { 8, 88 } };
    Label marital_status_label { this, text = "Marital status:", position = { 8, 112 } };
    Label naji_db_height_label { this, text = "Height:", position = { 8, 136 } };
    Label naji_db_weight_label { this, text = "Weight:", size = { 54, 13 }, position = { 8, 160 } };
    Label naji_db_build_label { this, text = "Build:", position = { 8, 184 } };
    Label hair_color_label { this, text = "Hair color:", position = { 8, 208 } };
    Label eye_color_label { this, text = "Eye color:", position = { 8, 232 } };
    Label favourite_food_label { this, text = "Favourite food:", position = { 8, 256 } };
    Label favourite_drink_label { this, text = "Favourite drink:", position = { 8, 280 } };
    Label home_number_label { this, text = "Home number:", position = { 8, 304 } };
    Label work_number_label { this, text = "Work number:", position = { 8, 328 } };
    Label occupation_label { this, text = "Occupation", position = { 8, 448 } };
    Label fax_number_label { this, text = "Fax number:", position = { 8, 352 } };
    Label cell_number_label { this, text = "Cell number:", position = { 8, 376 } };
    Label home_address_label { this, text = "Home address:", position = { 8, 400 } };
    Label work_address_label { this, text = "Work address:", position = { 8, 424 } };
    Label naji_db_email_label { this, text = "e-mail:", position = { 8, 472 } };
    Label naji_db_website_label { this, text = "Website:", position = { 8, 496 } };
    Label mothers_full_name_label { this, text = "Mother's full name:", position = { 8, 520 } };
    Label mothers_dob_label { this, text = "Mother's date of birth:", position = { 8, 544 } };
    Label fathers_full_name_label { this, text = "Father's full name:", position = { 8, 568 } };
    Label fathers_dob_label { this, text = "Father's date of birth:", position = { 8, 592 } };
    Label number_of_sisters_label { this, text = "Number of sisters:", position = { 8, 616 } };
    Label number_of_brothers_label { this, text = "Number of brothers:", position = { 8, 640 } };
    Label number_of_children_label { this, text = "Number of children:", position = { 8, 664 } };
    EditBox title_edit_box { this, size = { 246, 19 }, position = { 160, 8 } };
    EditBox full_name_edit_box { this, size = { 246, 19 }, position = { 160, 32 } };
    EditBox gender_edit_box { this, size = { 246, 19 }, position = { 160, 56 } };
    EditBox date_of_birth_edit_box { this, size = { 246, 19 }, position = { 160, 80 } };
    EditBox marital_status_edit_box { this, size = { 246, 19 }, position = { 160, 104 } };
    EditBox naji_db_height_edit_box { this, size = { 246, 19 }, position = { 160, 128 } };
    EditBox naji_db_weight_edit_box { this, size = { 246, 19 }, position = { 160, 152 } };
    EditBox naji_db_build_edit_box { this, size = { 246, 19 }, position = { 160, 176 } };
    EditBox hair_color_edit_box { this, size = { 246, 19 }, position = { 160, 200 } };
    EditBox eye_color_edit_box { this, size = { 246, 19 }, position = { 160, 224 } }
    EditBox favourite_food_edit_box { this, size = { 246, 19 }, position = { 160, 248 } };
    EditBox favourite_drink_edit_box { this, size = { 246, 19 }, position = { 160, 272 } };
    EditBox home_number_edit_box { this, size = { 246, 19 }, position = { 160, 296 } };
    EditBox work_number_edit_box { this, size = { 246, 19 }, position = { 160, 320 } };
    EditBox fax_number_edit_box { this, size = { 246, 19 }, position = { 160, 344 } };
    EditBox cell_number_edit_box { this, size = { 246, 19 }, position = { 160, 368 } };
    EditBox home_address_edit_box { this, size = { 246, 19 }, position = { 160, 392 } };
    EditBox work_address_edit_box { this, size = { 246, 19 }, position = { 160, 416 } };
    EditBox occupation_edit_box { this, size = { 246, 19 }, position = { 160, 440 } };
    EditBox naji_db_email_edit_box { this, size = { 246, 19 }, position = { 160, 464 } };
    EditBox naji_db_website_edit_box { this, size = { 246, 19 }, position = { 160, 488 } };
    EditBox mothers_full_name_edit_box { this, size = { 246, 19 }, position = { 160, 512 } };
    EditBox mothers_dob_edit_box { this, size = { 246, 19 }, position = { 160, 536 } };
    EditBox fathers_full_name_edit_box { this, size = { 246, 19 }, position = { 160, 560 } };
    EditBox fathers_dob_edit_box { this, size = { 246, 19 }, position = { 160, 584 } };
    EditBox number_of_sisters_edit_box { this, size = { 246, 19 }, position = { 160, 608 } };
    EditBox number_of_brothers_edit_box { this, size = { 246, 19 }, position = { 160, 632 } };
    EditBox number_of_children_edit_box { this, size = { 246, 19 }, position = { 160, 656 } };
    Button add_entry_button
    {
        this, text = "Add Entry", position = { 416, 664 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            if (naji_db_file_selected == true)
            {

                view_database_edit_box.Clear();

                if (naji_db_html_selected == true)
                {

                    if (!strcmp(najitool_language, "English"))
                    {

                        fprintf(naji_db_file, "\n<hr>\n");
                        add_entry_item_html("Title:", title_edit_box.contents);
                        add_entry_item_html("Full name:", full_name_edit_box.contents);
                        add_entry_item_html("Gender:", gender_edit_box.contents);
                        add_entry_item_html("Date of birth:", date_of_birth_edit_box.contents);
                        add_entry_item_html("Marital status:", marital_status_edit_box.contents);
                        add_entry_item_html("Height:", naji_db_height_edit_box.contents);
                        add_entry_item_html("Weight:", naji_db_weight_edit_box.contents);
                        add_entry_item_html("Build:", naji_db_build_edit_box.contents);
                        add_entry_item_html("Hair color:", hair_color_edit_box.contents);
                        add_entry_item_html("Eye color:", eye_color_edit_box.contents);
                        add_entry_item_html("Favourite food:", favourite_food_edit_box.contents);
                        add_entry_item_html("Favourite drink:", favourite_drink_edit_box.contents);
                        add_entry_item_html("Home number:", home_number_edit_box.contents);
                        add_entry_item_html("Work number:", work_number_edit_box.contents);
                        add_entry_item_html("Fax number:", fax_number_edit_box.contents);
                        add_entry_item_html("Cell number:", cell_number_edit_box.contents);
                        add_entry_item_html("Home address:", home_address_edit_box.contents);
                        add_entry_item_html("Work address:", work_address_edit_box.contents);
                        add_entry_item_html("Occupation:", occupation_edit_box.contents);
                        add_entry_item_html_email("e-mail:", naji_db_email_edit_box.contents);
                        add_entry_item_html_link("Website:", naji_db_website_edit_box.contents);
                        add_entry_item_html("Mother's full name:", mothers_full_name_edit_box.contents);
                        add_entry_item_html("Mother's date of birth:", mothers_dob_edit_box.contents);
                        add_entry_item_html("Father's full name:", fathers_full_name_edit_box.contents);
                        add_entry_item_html("Father's date of birth:", fathers_dob_edit_box.contents);
                        add_entry_item_html("Number of sisters:", number_of_sisters_edit_box.contents);
                        add_entry_item_html("Number of brothers:", number_of_brothers_edit_box.contents);
                        add_entry_item_html("Number of children:", number_of_children_edit_box.contents);
                    }
                    if (!strcmp(najitool_language, "Turkish"))
                    {
                        fprintf(naji_db_file, "\n<hr>\n");
                        add_entry_item_html("Unvan:", title_edit_box.contents);
                        add_entry_item_html("Tum Isim:", full_name_edit_box.contents);
                        add_entry_item_html("Cinsiyet:", gender_edit_box.contents);
                        add_entry_item_html("Dogum Tarih:", date_of_birth_edit_box.contents);
                        add_entry_item_html("Evlilik Durumu:", marital_status_edit_box.contents);
                        add_entry_item_html("Boy:", naji_db_height_edit_box.contents);
                        add_entry_item_html("Kilo:", naji_db_weight_edit_box.contents);
                        add_entry_item_html("Yapi:", naji_db_build_edit_box.contents);
                        add_entry_item_html("Sac Renk:", hair_color_edit_box.contents);
                        add_entry_item_html("Goz Renk:", eye_color_edit_box.contents);
                        add_entry_item_html("En Sevdigi Yemek:", favourite_food_edit_box.contents);
                        add_entry_item_html("En Sevdigi Icicek:", favourite_drink_edit_box.contents);
                        add_entry_item_html("Ev Telefon:", home_number_edit_box.contents);
                        add_entry_item_html("Is Telefon:", work_number_edit_box.contents);
                        add_entry_item_html("Faks Numara:", fax_number_edit_box.contents);
                        add_entry_item_html("Cep Telefon:", cell_number_edit_box.contents);
                        add_entry_item_html("Ev Adres:", home_address_edit_box.contents);
                        add_entry_item_html("Is Adres:", work_address_edit_box.contents);
                        add_entry_item_html("Meslek:", occupation_edit_box.contents);
                        add_entry_item_html_email("E-Posta Adres:", naji_db_email_edit_box.contents);
                        add_entry_item_html_link("Vebsite:", naji_db_website_edit_box.contents);
                        add_entry_item_html("Tum Ana Ismi:", mothers_full_name_edit_box.contents);
                        add_entry_item_html("Ana Dogum Tahri:", mothers_dob_edit_box.contents);
                        add_entry_item_html("Tum Baba Ismi:", fathers_full_name_edit_box.contents);
                        add_entry_item_html("Baba Dogum Tarih:", fathers_dob_edit_box.contents);
                        add_entry_item_html("Kac Abla/Kiz Kardes:", number_of_sisters_edit_box.contents);
                        add_entry_item_html("Kac Abi/Erkek Kardes:", number_of_brothers_edit_box.contents);
                        add_entry_item_html("Cocuk Sayisi:", number_of_children_edit_box.contents);
                    }

                }

                else
                {

                    if (!strcmp(najitool_language, "English"))
                    {

                        fprintf(naji_db_file, "Title: %s\n", title_edit_box.contents);
                        fprintf(naji_db_file, "Full name: %s\n", full_name_edit_box.contents);
                        fprintf(naji_db_file, "Gender: %s\n", gender_edit_box.contents);
                        fprintf(naji_db_file, "Date of birth: %s\n", date_of_birth_edit_box.contents);
                        fprintf(naji_db_file, "Marital status: %s\n", marital_status_edit_box.contents);
                        fprintf(naji_db_file, "Height: %s\n", naji_db_height_edit_box.contents);
                        fprintf(naji_db_file, "Weight: %s\n", naji_db_weight_edit_box.contents);
                        fprintf(naji_db_file, "Build: %s\n", naji_db_build_edit_box.contents);
                        fprintf(naji_db_file, "Hair color: %s\n", hair_color_edit_box.contents);
                        fprintf(naji_db_file, "Eye color: %s\n", eye_color_edit_box.contents);
                        fprintf(naji_db_file, "Favourite food: %s\n", favourite_food_edit_box.contents);
                        fprintf(naji_db_file, "Favourite drink: %s\n", favourite_drink_edit_box.contents);
                        fprintf(naji_db_file, "Home number: %s\n", home_number_edit_box.contents);
                        fprintf(naji_db_file, "Work number: %s\n", work_number_edit_box.contents);
                        fprintf(naji_db_file, "Fax number: %s\n", fax_number_edit_box.contents);
                        fprintf(naji_db_file, "Cell number: %s\n", cell_number_edit_box.contents);
                        fprintf(naji_db_file, "Home address: %s\n", home_address_edit_box.contents);
                        fprintf(naji_db_file, "Work address: %s\n", work_address_edit_box.contents);
                        fprintf(naji_db_file, "Occupation: %s\n", occupation_edit_box.contents);
                        fprintf(naji_db_file, "e-mail: %s\n", naji_db_email_edit_box.contents);
                        fprintf(naji_db_file, "Website: %s\n", naji_db_website_edit_box.contents);
                        fprintf(naji_db_file, "Mother's full name: %s\n", mothers_full_name_edit_box.contents);
                        fprintf(naji_db_file, "Mother's date of birth: %s\n", mothers_dob_edit_box.contents);
                        fprintf(naji_db_file, "Father's full name: %s\n", fathers_full_name_edit_box.contents);
                        fprintf(naji_db_file, "Father's date of birth: %s\n", fathers_dob_edit_box.contents);
                        fprintf(naji_db_file, "Number of sisters: %s\n", number_of_sisters_edit_box.contents);
                        fprintf(naji_db_file, "Number of brothers: %s\n", number_of_brothers_edit_box.contents);
                        fprintf(naji_db_file, "Number of children: %s\n\n", number_of_children_edit_box.contents);
                    }

                    if (!strcmp(najitool_language, "Turkish"))
                    {

                        fprintf(naji_db_file, "Unvan: %s\n", title_edit_box.contents);
                        fprintf(naji_db_file, "Tum Isim: %s\n", full_name_edit_box.contents);
                        fprintf(naji_db_file, "Cinsiyet: %s\n", gender_edit_box.contents);
                        fprintf(naji_db_file, "Dogum Tarih: %s\n", date_of_birth_edit_box.contents);
                        fprintf(naji_db_file, "Evlilik Durumu: %s\n", marital_status_edit_box.contents);
                        fprintf(naji_db_file, "Boy: %s\n", naji_db_height_edit_box.contents);
                        fprintf(naji_db_file, "Kilo: %s\n", naji_db_weight_edit_box.contents);
                        fprintf(naji_db_file, "Yapi: %s\n", naji_db_build_edit_box.contents);
                        fprintf(naji_db_file, "Sac Renk: %s\n", hair_color_edit_box.contents);
                        fprintf(naji_db_file, "Goz Renk: %s\n", eye_color_edit_box.contents);
                        fprintf(naji_db_file, "En Sevdigi Yemek: %s\n", favourite_food_edit_box.contents);
                        fprintf(naji_db_file, "En Sevdigi Icicek: %s\n", favourite_drink_edit_box.contents);
                        fprintf(naji_db_file, "Ev Telefon: %s\n", home_number_edit_box.contents);
                        fprintf(naji_db_file, "Is Telefon: %s\n", work_number_edit_box.contents);
                        fprintf(naji_db_file, "Faks Numara: %s\n", fax_number_edit_box.contents);
                        fprintf(naji_db_file, "Cep Telefon: %s\n", cell_number_edit_box.contents);
                        fprintf(naji_db_file, "Ev Adres: %s\n", home_address_edit_box.contents);
                        fprintf(naji_db_file, "Is Adres: %s\n", work_address_edit_box.contents);
                        fprintf(naji_db_file, "Meslek: %s\n", occupation_edit_box.contents);
                        fprintf(naji_db_file, "E-Posta Adres: %s\n", naji_db_email_edit_box.contents);
                        fprintf(naji_db_file, "Vebsite: %s\n", naji_db_website_edit_box.contents);
                        fprintf(naji_db_file, "Tum Ana Ismi: %s\n", mothers_full_name_edit_box.contents);
                        fprintf(naji_db_file, "Ana Dogum Tarih: %s\n", mothers_dob_edit_box.contents);
                        fprintf(naji_db_file, "Tum Baba Ismi: %s\n", fathers_full_name_edit_box.contents);
                        fprintf(naji_db_file, "Baba Dogum Tarih: %s\n", fathers_dob_edit_box.contents);
                        fprintf(naji_db_file, "Kac Abla/Kiz Kardes: %s\n", number_of_sisters_edit_box.contents);
                        fprintf(naji_db_file, "Kac Abi/Erkek Kardes: %s\n", number_of_brothers_edit_box.contents);
                        fprintf(naji_db_file, "Cocuk Sayisi: %s\n\n", number_of_children_edit_box.contents);
                    }

                }

                fseek (naji_db_file , 0, SEEK_SET);

                while (1)
                {

                    naji_db_a = fgetc(naji_db_file);

                    if (naji_db_a == EOF)
                        break;

                    view_database_edit_box.AddCh(naji_db_a);
                }

            }
            else
            {

                if (!strcmp(najitool_language, "English"))
                    MessageBox { text = "najitool GUI database error:", contents = "Please select a file to create or to append the database entries to." }.Modal();
                else if (!strcmp(najitool_language, "Turkish"))
                    MessageBox { text = "najitool GUI veritabani hata:", contents = "Lutfen bir dosya secin olusturmak icin veya bir dosya secin veritabani kayitlari eklenmesi icin." }.Modal();

            }

            return true;
        }
    };
    Button add_entry_omits_empty_items_button
    {
        this, text = "Add Entry, Omits Empty Items", position = { 496, 664 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            if (naji_db_file_selected == true)
            {

                view_database_edit_box.Clear();

                if (naji_db_html_selected == true)
                {

                    if (!strcmp(najitool_language, "English"))
                    {

                        fprintf(naji_db_file, "\n<hr>\n");
                        if (strcmp(title_edit_box.contents, "")) add_entry_item_html("Title:", title_edit_box.contents);
                        if (strcmp(full_name_edit_box.contents, "")) add_entry_item_html("Full name:", full_name_edit_box.contents);
                        if (strcmp(gender_edit_box.contents, "")) add_entry_item_html("Gender:", gender_edit_box.contents);
                        if (strcmp(date_of_birth_edit_box.contents, "")) add_entry_item_html("Date of birth:", date_of_birth_edit_box.contents);
                        if (strcmp(marital_status_edit_box.contents, "")) add_entry_item_html("Marital status:", marital_status_edit_box.contents);
                        if (strcmp(naji_db_height_edit_box.contents, "")) add_entry_item_html("Height:", naji_db_height_edit_box.contents);
                        if (strcmp(naji_db_weight_edit_box.contents, "")) add_entry_item_html("Weight:", naji_db_weight_edit_box.contents);
                        if (strcmp(naji_db_build_edit_box.contents, "")) add_entry_item_html("Build:", naji_db_build_edit_box.contents);
                        if (strcmp(hair_color_edit_box.contents, "")) add_entry_item_html("Hair color:", hair_color_edit_box.contents);
                        if (strcmp(eye_color_edit_box.contents, "")) add_entry_item_html("Eye color:", eye_color_edit_box.contents);
                        if (strcmp(favourite_food_edit_box.contents, "")) add_entry_item_html("Favourite food:", favourite_food_edit_box.contents);
                        if (strcmp(favourite_drink_edit_box.contents, "")) add_entry_item_html("Favourite drink:", favourite_drink_edit_box.contents);
                        if (strcmp(home_number_edit_box.contents, "")) add_entry_item_html("Home number:", home_number_edit_box.contents);
                        if (strcmp(work_number_edit_box.contents, "")) add_entry_item_html("Work number:", work_number_edit_box.contents);
                        if (strcmp(fax_number_edit_box.contents, "")) add_entry_item_html("Fax number:", fax_number_edit_box.contents);
                        if (strcmp(cell_number_edit_box.contents, "")) add_entry_item_html("Cell number:", cell_number_edit_box.contents);
                        if (strcmp(home_address_edit_box.contents, "")) add_entry_item_html("Home address:", home_address_edit_box.contents);
                        if (strcmp(work_address_edit_box.contents, "")) add_entry_item_html("Work address:", work_address_edit_box.contents);
                        if (strcmp(occupation_edit_box.contents, "")) add_entry_item_html("Occupation:", occupation_edit_box.contents);
                        if (strcmp(naji_db_email_edit_box.contents, "")) add_entry_item_html_email("e-mail:", naji_db_email_edit_box.contents);
                        if (strcmp(naji_db_website_edit_box.contents, "")) add_entry_item_html_link("Website:", naji_db_website_edit_box.contents);
                        if (strcmp(mothers_full_name_edit_box.contents, "")) add_entry_item_html("Mother's full name:", mothers_full_name_edit_box.contents);
                        if (strcmp(mothers_dob_edit_box.contents, "")) add_entry_item_html("Mother's date of birth:", mothers_dob_edit_box.contents);
                        if (strcmp(fathers_full_name_edit_box.contents, "")) add_entry_item_html("Father's full name:", fathers_full_name_edit_box.contents);
                        if (strcmp(fathers_dob_edit_box.contents, "")) add_entry_item_html("Father's date of birth:", fathers_dob_edit_box.contents);
                        if (strcmp(number_of_sisters_edit_box.contents, "")) add_entry_item_html("Number of sisters:", number_of_sisters_edit_box.contents);
                        if (strcmp(number_of_brothers_edit_box.contents, "")) add_entry_item_html("Number of brothers:", number_of_brothers_edit_box.contents);
                        if (strcmp(number_of_children_edit_box.contents, "")) add_entry_item_html("Number of children:", number_of_children_edit_box.contents);
                    }

                    if (strcmp(najitool_language, "Turkish"))
                    {

                        fprintf(naji_db_file, "\n<hr>\n");
                        if (strcmp(title_edit_box.contents, "")) add_entry_item_html("Unvan:", title_edit_box.contents);
                        if (strcmp(full_name_edit_box.contents, "")) add_entry_item_html("Tum Isim:", full_name_edit_box.contents);
                        if (strcmp(gender_edit_box.contents, "")) add_entry_item_html("Cinsiyet:", gender_edit_box.contents);
                        if (strcmp(date_of_birth_edit_box.contents, "")) add_entry_item_html("Dogum Tarih:", date_of_birth_edit_box.contents);
                        if (strcmp(marital_status_edit_box.contents, "")) add_entry_item_html("Evlilik Durumu:", marital_status_edit_box.contents);
                        if (strcmp(naji_db_height_edit_box.contents, "")) add_entry_item_html("Boy:", naji_db_height_edit_box.contents);
                        if (strcmp(naji_db_weight_edit_box.contents, "")) add_entry_item_html("Kilo:", naji_db_weight_edit_box.contents);
                        if (strcmp(naji_db_build_edit_box.contents, "")) add_entry_item_html("Yapi:", naji_db_build_edit_box.contents);
                        if (strcmp(hair_color_edit_box.contents, "")) add_entry_item_html("Sac Renk:", hair_color_edit_box.contents);
                        if (strcmp(eye_color_edit_box.contents, "")) add_entry_item_html("Goz Renk:", eye_color_edit_box.contents);
                        if (strcmp(favourite_food_edit_box.contents, "")) add_entry_item_html("En Sevdigi Yemek:", favourite_food_edit_box.contents);
                        if (strcmp(favourite_drink_edit_box.contents, "")) add_entry_item_html("En Sevdigi Icicek:", favourite_drink_edit_box.contents);
                        if (strcmp(home_number_edit_box.contents, "")) add_entry_item_html("Ev Telefon:", home_number_edit_box.contents);
                        if (strcmp(work_number_edit_box.contents, "")) add_entry_item_html("Is Telefon:", work_number_edit_box.contents);
                        if (strcmp(fax_number_edit_box.contents, "")) add_entry_item_html("Faks Numara:", fax_number_edit_box.contents);
                        if (strcmp(cell_number_edit_box.contents, "")) add_entry_item_html("Cep Telefon:", cell_number_edit_box.contents);
                        if (strcmp(home_address_edit_box.contents, "")) add_entry_item_html("Ev Adres:", home_address_edit_box.contents);
                        if (strcmp(work_address_edit_box.contents, "")) add_entry_item_html("Is Adres:", work_address_edit_box.contents);
                        if (strcmp(occupation_edit_box.contents, "")) add_entry_item_html("Meslek:", occupation_edit_box.contents);
                        if (strcmp(naji_db_email_edit_box.contents, "")) add_entry_item_html_email("E-Posta Adres:", naji_db_email_edit_box.contents);
                        if (strcmp(naji_db_website_edit_box.contents, "")) add_entry_item_html_link("Vebsite:", naji_db_website_edit_box.contents);
                        if (strcmp(mothers_full_name_edit_box.contents, "")) add_entry_item_html("Tum Ana Ismi:", mothers_full_name_edit_box.contents);
                        if (strcmp(mothers_dob_edit_box.contents, "")) add_entry_item_html("Ana Dogum Tarih:", mothers_dob_edit_box.contents);
                        if (strcmp(fathers_full_name_edit_box.contents, "")) add_entry_item_html("Tum Baba Ismi:", fathers_full_name_edit_box.contents);
                        if (strcmp(fathers_dob_edit_box.contents, "")) add_entry_item_html("Baba Dogum Tarih:", fathers_dob_edit_box.contents);
                        if (strcmp(number_of_sisters_edit_box.contents, "")) add_entry_item_html("Kac Abla/Kiz Kardes:", number_of_sisters_edit_box.contents);
                        if (strcmp(number_of_brothers_edit_box.contents, "")) add_entry_item_html("Kac Abi/Erkek Kardes:", number_of_brothers_edit_box.contents);
                        if (strcmp(number_of_children_edit_box.contents, "")) add_entry_item_html("Cocuk Sayisi:", number_of_children_edit_box.contents);

                    }

                }
                else
                {

                    if (!strcmp(najitool_language, "English"))
                    {

                        if (strcmp(title_edit_box.contents, "")) fprintf(naji_db_file, "Title: %s\n", title_edit_box.contents);
                        if (strcmp(full_name_edit_box.contents, "")) fprintf(naji_db_file, "Full name: %s\n", full_name_edit_box.contents);
                        if (strcmp(gender_edit_box.contents, "")) fprintf(naji_db_file, "Gender: %s\n", gender_edit_box.contents);
                        if (strcmp(date_of_birth_edit_box.contents, "")) fprintf(naji_db_file, "Date of birth: %s\n", date_of_birth_edit_box.contents);
                        if (strcmp(marital_status_edit_box.contents, "")) fprintf(naji_db_file, "Marital status: %s\n", marital_status_edit_box.contents);
                        if (strcmp(naji_db_height_edit_box.contents, "")) fprintf(naji_db_file, "Height: %s\n", naji_db_height_edit_box.contents);
                        if (strcmp(naji_db_weight_edit_box.contents, "")) fprintf(naji_db_file, "Weight: %s\n", naji_db_weight_edit_box.contents);
                        if (strcmp(naji_db_build_edit_box.contents, "")) fprintf(naji_db_file, "Build: %s\n", naji_db_build_edit_box.contents);
                        if (strcmp(hair_color_edit_box.contents, "")) fprintf(naji_db_file, "Hair color: %s\n", hair_color_edit_box.contents);
                        if (strcmp(eye_color_edit_box.contents, "")) fprintf(naji_db_file, "Eye color: %s\n", eye_color_edit_box.contents);
                        if (strcmp(favourite_food_edit_box.contents, "")) fprintf(naji_db_file, "Favourite food: %s\n", favourite_food_edit_box.contents);
                        if (strcmp(favourite_drink_edit_box.contents, "")) fprintf(naji_db_file, "Favourite drink: %s\n", favourite_drink_edit_box.contents);
                        if (strcmp(home_number_edit_box.contents, "")) fprintf(naji_db_file, "Home number: %s\n", home_number_edit_box.contents);
                        if (strcmp(work_number_edit_box.contents, "")) fprintf(naji_db_file, "Work number: %s\n", work_number_edit_box.contents);
                        if (strcmp(fax_number_edit_box.contents, "")) fprintf(naji_db_file, "Fax number: %s\n", fax_number_edit_box.contents);
                        if (strcmp(cell_number_edit_box.contents, "")) fprintf(naji_db_file, "Cell number: %s\n", cell_number_edit_box.contents);
                        if (strcmp(home_address_edit_box.contents, "")) fprintf(naji_db_file, "Home address: %s\n", home_address_edit_box.contents);
                        if (strcmp(work_address_edit_box.contents, "")) fprintf(naji_db_file, "Work address: %s\n", work_address_edit_box.contents);
                        if (strcmp(occupation_edit_box.contents, "")) fprintf(naji_db_file, "Occupation: %s\n", occupation_edit_box.contents);
                        if (strcmp(naji_db_email_edit_box.contents, "")) fprintf(naji_db_file, "e-mail: %s\n", naji_db_email_edit_box.contents);
                        if (strcmp(naji_db_website_edit_box.contents, "")) fprintf(naji_db_file, "Website: %s\n", naji_db_website_edit_box.contents);
                        if (strcmp(mothers_full_name_edit_box.contents, "")) fprintf(naji_db_file, "Mother's full name: %s\n", mothers_full_name_edit_box.contents);
                        if (strcmp(mothers_dob_edit_box.contents, "")) fprintf(naji_db_file, "Mother's date of birth: %s\n", mothers_dob_edit_box.contents);
                        if (strcmp(fathers_full_name_edit_box.contents, "")) fprintf(naji_db_file, "Father's full name: %s\n", fathers_full_name_edit_box.contents);
                        if (strcmp(fathers_dob_edit_box.contents, "")) fprintf(naji_db_file, "Father's date of birth: %s\n", fathers_dob_edit_box.contents);
                        if (strcmp(number_of_sisters_edit_box.contents, "")) fprintf(naji_db_file, "Number of sisters: %s\n", number_of_sisters_edit_box.contents);
                        if (strcmp(number_of_brothers_edit_box.contents, "")) fprintf(naji_db_file, "Number of brothers: %s\n", number_of_brothers_edit_box.contents);
                        if (strcmp(number_of_children_edit_box.contents, "")) fprintf(naji_db_file, "Number of children: %s\n", number_of_children_edit_box.contents);
                        fprintf(naji_db_file, "\n");

                    }

                    if (!strcmp(najitool_language, "Turkish"))
                    {

                        if (strcmp(title_edit_box.contents, "")) fprintf(naji_db_file, "Unvan: %s\n", title_edit_box.contents);
                        if (strcmp(full_name_edit_box.contents, "")) fprintf(naji_db_file, "Tum Isim: %s\n", full_name_edit_box.contents);
                        if (strcmp(gender_edit_box.contents, "")) fprintf(naji_db_file, "Cinsiyet: %s\n", gender_edit_box.contents);
                        if (strcmp(date_of_birth_edit_box.contents, "")) fprintf(naji_db_file, "Dogum Tarih: %s\n", date_of_birth_edit_box.contents);
                        if (strcmp(marital_status_edit_box.contents, "")) fprintf(naji_db_file, "Evlilik Durumu: %s\n", marital_status_edit_box.contents);
                        if (strcmp(naji_db_height_edit_box.contents, "")) fprintf(naji_db_file, "Boy: %s\n", naji_db_height_edit_box.contents);
                        if (strcmp(naji_db_weight_edit_box.contents, "")) fprintf(naji_db_file, "Kilo: %s\n", naji_db_weight_edit_box.contents);
                        if (strcmp(naji_db_build_edit_box.contents, "")) fprintf(naji_db_file, "Yapi: %s\n", naji_db_build_edit_box.contents);
                        if (strcmp(hair_color_edit_box.contents, "")) fprintf(naji_db_file, "Sac Renk: %s\n", hair_color_edit_box.contents);
                        if (strcmp(eye_color_edit_box.contents, "")) fprintf(naji_db_file, "Goz Renk: %s\n", eye_color_edit_box.contents);
                        if (strcmp(favourite_food_edit_box.contents, "")) fprintf(naji_db_file, "En Sevdigi Yemek: %s\n", favourite_food_edit_box.contents);
                        if (strcmp(favourite_drink_edit_box.contents, "")) fprintf(naji_db_file, "En Sevdigi Icicek: %s\n", favourite_drink_edit_box.contents);
                        if (strcmp(home_number_edit_box.contents, "")) fprintf(naji_db_file, "Ev Telefon: %s\n", home_number_edit_box.contents);
                        if (strcmp(work_number_edit_box.contents, "")) fprintf(naji_db_file, "Is Telefon: %s\n", work_number_edit_box.contents);
                        if (strcmp(fax_number_edit_box.contents, "")) fprintf(naji_db_file, "Faks Numara: %s\n", fax_number_edit_box.contents);
                        if (strcmp(cell_number_edit_box.contents, "")) fprintf(naji_db_file, "Cep Numara: %s\n", cell_number_edit_box.contents);
                        if (strcmp(home_address_edit_box.contents, "")) fprintf(naji_db_file, "Ev Adres: %s\n", home_address_edit_box.contents);
                        if (strcmp(work_address_edit_box.contents, "")) fprintf(naji_db_file, "Is Adres: %s\n", work_address_edit_box.contents);
                        if (strcmp(occupation_edit_box.contents, "")) fprintf(naji_db_file, "Meslek: %s\n", occupation_edit_box.contents);
                        if (strcmp(naji_db_email_edit_box.contents, "")) fprintf(naji_db_file, "E-Posta Adres: %s\n", naji_db_email_edit_box.contents);
                        if (strcmp(naji_db_website_edit_box.contents, "")) fprintf(naji_db_file, "Vebsite: %s\n", naji_db_website_edit_box.contents);
                        if (strcmp(mothers_full_name_edit_box.contents, "")) fprintf(naji_db_file, "Tum Ana Ismi: %s\n", mothers_full_name_edit_box.contents);
                        if (strcmp(mothers_dob_edit_box.contents, "")) fprintf(naji_db_file, "Ana Dogum Tarih: %s\n", mothers_dob_edit_box.contents);
                        if (strcmp(fathers_full_name_edit_box.contents, "")) fprintf(naji_db_file, "Tum Baba Ismi: %s\n", fathers_full_name_edit_box.contents);
                        if (strcmp(fathers_dob_edit_box.contents, "")) fprintf(naji_db_file, "Baba Dogum Tarih: %s\n", fathers_dob_edit_box.contents);
                        if (strcmp(number_of_sisters_edit_box.contents, "")) fprintf(naji_db_file, "Kac Abla/Kiz Kardes: %s\n", number_of_sisters_edit_box.contents);
                        if (strcmp(number_of_brothers_edit_box.contents, "")) fprintf(naji_db_file, "Kac Abi/Erkek Kardes: %s\n", number_of_brothers_edit_box.contents);
                        if (strcmp(number_of_children_edit_box.contents, "")) fprintf(naji_db_file, "Cocuk Sayisi: %s\n", number_of_children_edit_box.contents);

                    }

                }

                fseek (naji_db_file , 0, SEEK_SET);

                while (1)
                {

                    naji_db_a = fgetc(naji_db_file);

                    if (naji_db_a == EOF)
                        break;

                    view_database_edit_box.AddCh(naji_db_a);
                }

            }
            else
            {

                if (!strcmp(najitool_language, "English"))
                    MessageBox { text = "najitool GUI database error:", contents = "Please select a file to create or to append the database entries to." }.Modal();
                else if (!strcmp(najitool_language, "Turkish"))
                    MessageBox { text = "najitool GUI veritabani hata:", contents = "Lutfen bir dosya secin olusturmak icin veya bir dosya secin veritabani kayitlari eklenmesi icin." }.Modal();

            }

            return true;
        }
    };
    Button add_entry_fill_blanks_with_button
    {
        this, text = "Add Entry, Fill Blanks With:", position = { 704, 664 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            if (naji_db_file_selected == true)
            {

                view_database_edit_box.Clear();

                if (naji_db_html_selected == true)
                {

                    if (!strcmp(najitool_language, "English"))
                    {

                        fprintf(naji_db_file, "\n<hr>\n");
                        if (strcmp(title_edit_box.contents, "")) add_entry_item_html("Title:", title_edit_box.contents);
                        else add_entry_item_html("Title:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(full_name_edit_box.contents, "")) add_entry_item_html("Full name:", full_name_edit_box.contents);
                        else add_entry_item_html("Full name:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(gender_edit_box.contents, "")) add_entry_item_html("Gender:", gender_edit_box.contents);
                        else add_entry_item_html("Gender:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(date_of_birth_edit_box.contents, "")) add_entry_item_html("Date of birth:", date_of_birth_edit_box.contents);
                        else add_entry_item_html("Date of birth:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(marital_status_edit_box.contents, "")) add_entry_item_html("Marital status:", marital_status_edit_box.contents);
                        else add_entry_item_html("Marital status:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_height_edit_box.contents, "")) add_entry_item_html("Height:", naji_db_height_edit_box.contents);
                        else add_entry_item_html("Height:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_weight_edit_box.contents, "")) add_entry_item_html("Weight:", naji_db_weight_edit_box.contents);
                        else add_entry_item_html("Weight:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_build_edit_box.contents, "")) add_entry_item_html("Build:", naji_db_build_edit_box.contents);
                        else add_entry_item_html("Build:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(hair_color_edit_box.contents, "")) add_entry_item_html("Hair color:", hair_color_edit_box.contents);
                        else add_entry_item_html("Hair color:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(eye_color_edit_box.contents, "")) add_entry_item_html("Eye color:", eye_color_edit_box.contents);
                        else add_entry_item_html("Eye color:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(favourite_food_edit_box.contents, "")) add_entry_item_html("Favourite food:", favourite_food_edit_box.contents);
                        else add_entry_item_html("Favourite food:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(favourite_drink_edit_box.contents, "")) add_entry_item_html("Favourite drink:", favourite_drink_edit_box.contents);
                        else add_entry_item_html("Favourite drink:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(home_number_edit_box.contents, "")) add_entry_item_html("Home number:", home_number_edit_box.contents);
                        else add_entry_item_html("Home number:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(work_number_edit_box.contents, "")) add_entry_item_html("Work number:", work_number_edit_box.contents);
                        else add_entry_item_html("Work number:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(fax_number_edit_box.contents, "")) add_entry_item_html("Fax number:", fax_number_edit_box.contents);
                        else add_entry_item_html("Fax number:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(cell_number_edit_box.contents, "")) add_entry_item_html("Cell number:", cell_number_edit_box.contents);
                        else add_entry_item_html("Cell number:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(home_address_edit_box.contents, "")) add_entry_item_html("Home address:", home_address_edit_box.contents);
                        else add_entry_item_html("Home address:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(work_address_edit_box.contents, "")) add_entry_item_html("Work address:", work_address_edit_box.contents);
                        else add_entry_item_html("Work address:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(occupation_edit_box.contents, "")) add_entry_item_html("Occupation:", occupation_edit_box.contents);
                        else add_entry_item_html("Occupation:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_email_edit_box.contents, "")) add_entry_item_html_email("e-mail:", naji_db_email_edit_box.contents);
                        else add_entry_item_html_email("e-mail:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_website_edit_box.contents, "")) add_entry_item_html_link("Website:", naji_db_website_edit_box.contents);
                        else add_entry_item_html_link("Website:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(mothers_full_name_edit_box.contents, "")) add_entry_item_html("Mother's full name:", mothers_full_name_edit_box.contents);
                        else add_entry_item_html("Mother's full name:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(mothers_dob_edit_box.contents, "")) add_entry_item_html("Mother's date of birth:", mothers_dob_edit_box.contents);
                        else add_entry_item_html("Mother's date of birth:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(fathers_full_name_edit_box.contents, "")) add_entry_item_html("Father's full name:", fathers_full_name_edit_box.contents);
                        else add_entry_item_html("Father's full name:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(fathers_dob_edit_box.contents, "")) add_entry_item_html("Father's date of birth:", fathers_dob_edit_box.contents);
                        else add_entry_item_html("Father's date of birth:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(number_of_sisters_edit_box.contents, "")) add_entry_item_html("Number of sisters:", number_of_sisters_edit_box.contents);
                        else add_entry_item_html("Number of sisters:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(number_of_brothers_edit_box.contents, "")) add_entry_item_html("Number of brothers:", number_of_brothers_edit_box.contents);
                        else add_entry_item_html("Number of brothers:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(number_of_children_edit_box.contents, "")) add_entry_item_html("Number of children:", number_of_children_edit_box.contents);
                        else add_entry_item_html("Number of children:", add_entry_fill_blanks_with_edit_box.contents);

                    }

                    if (!strcmp(najitool_language, "Turkish"))
                    {

                        fprintf(naji_db_file, "\n<hr>\n");
                        if (strcmp(title_edit_box.contents, "")) add_entry_item_html("Unvan:", title_edit_box.contents);
                        else add_entry_item_html("Unvan:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(full_name_edit_box.contents, "")) add_entry_item_html("Tum Isim:", full_name_edit_box.contents);
                        else add_entry_item_html("Tum Isim:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(gender_edit_box.contents, "")) add_entry_item_html("Cinsiyet:", gender_edit_box.contents);
                        else add_entry_item_html("Cinsiyet:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(date_of_birth_edit_box.contents, "")) add_entry_item_html("Dogum Tarih:", date_of_birth_edit_box.contents);
                        else add_entry_item_html("Dogum Tarih:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(marital_status_edit_box.contents, "")) add_entry_item_html("Evlilik Durumu:", marital_status_edit_box.contents);
                        else add_entry_item_html("Evlilik Durumu:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_height_edit_box.contents, "")) add_entry_item_html("Boy:", naji_db_height_edit_box.contents);
                        else add_entry_item_html("Boy:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_weight_edit_box.contents, "")) add_entry_item_html("Kilo:", naji_db_weight_edit_box.contents);
                        else add_entry_item_html("Kilo:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_build_edit_box.contents, "")) add_entry_item_html("Yapi:", naji_db_build_edit_box.contents);
                        else add_entry_item_html("Yapi:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(hair_color_edit_box.contents, "")) add_entry_item_html("Sac Renk:", hair_color_edit_box.contents);
                        else add_entry_item_html("Sac Renk:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(eye_color_edit_box.contents, "")) add_entry_item_html("Goz Renk:", eye_color_edit_box.contents);
                        else add_entry_item_html("Goz Renk:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(favourite_food_edit_box.contents, "")) add_entry_item_html("En Sevdigi Yemek:", favourite_food_edit_box.contents);
                        else add_entry_item_html("En Sevdigi Yemek:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(favourite_drink_edit_box.contents, "")) add_entry_item_html("En Sevdigi Icicek:", favourite_drink_edit_box.contents);
                        else add_entry_item_html("En Sevdigi Icicek:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(home_number_edit_box.contents, "")) add_entry_item_html("Ev Telefon:", home_number_edit_box.contents);
                        else add_entry_item_html("Ev Telefon:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(work_number_edit_box.contents, "")) add_entry_item_html("Is Telefon:", work_number_edit_box.contents);
                        else add_entry_item_html("Is Telefon:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(fax_number_edit_box.contents, "")) add_entry_item_html("Faks Numara:", fax_number_edit_box.contents);
                        else add_entry_item_html("Faks Numara:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(cell_number_edit_box.contents, "")) add_entry_item_html("Cep Telefon:", cell_number_edit_box.contents);
                        else add_entry_item_html("Cep Telefon:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(home_address_edit_box.contents, "")) add_entry_item_html("Ev Adres:", home_address_edit_box.contents);
                        else add_entry_item_html("Ev Adres:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(work_address_edit_box.contents, "")) add_entry_item_html("Is Adres:", work_address_edit_box.contents);
                        else add_entry_item_html("Is Adres:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(occupation_edit_box.contents, "")) add_entry_item_html("Meslek:", occupation_edit_box.contents);
                        else add_entry_item_html("Meslek:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_email_edit_box.contents, "")) add_entry_item_html_email("E-Posta Adres:", naji_db_email_edit_box.contents);
                        else add_entry_item_html_email("E-Posta Adres:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_website_edit_box.contents, "")) add_entry_item_html_link("Vebsite:", naji_db_website_edit_box.contents);
                        else add_entry_item_html_link("Vebsite:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(mothers_full_name_edit_box.contents, "")) add_entry_item_html("Tum Ana Ismi:", mothers_full_name_edit_box.contents);
                        else add_entry_item_html("Tum Ana Ismi:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(mothers_dob_edit_box.contents, "")) add_entry_item_html("Ana Dogum Tarih:", mothers_dob_edit_box.contents);
                        else add_entry_item_html("Ana Dogum Tarih:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(fathers_full_name_edit_box.contents, "")) add_entry_item_html("Tum Baba Ismi:", fathers_full_name_edit_box.contents);
                        else add_entry_item_html("Tum Baba Ismi:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(fathers_dob_edit_box.contents, "")) add_entry_item_html("Baba Dogum Tarih:", fathers_dob_edit_box.contents);
                        else add_entry_item_html("Baba Dogum Tarih:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(number_of_sisters_edit_box.contents, "")) add_entry_item_html("Kac Abla/Kiz Kardes:", number_of_sisters_edit_box.contents);
                        else add_entry_item_html("Kac Abla/Kiz Kardes:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(number_of_brothers_edit_box.contents, "")) add_entry_item_html("Kac Abi/Erkek Kardes:", number_of_brothers_edit_box.contents);
                        else add_entry_item_html("Kac Abi/Erkek Kardes:", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(number_of_children_edit_box.contents, "")) add_entry_item_html("Number of children:", number_of_children_edit_box.contents);
                        else add_entry_item_html("Cocuk Sayisi:", add_entry_fill_blanks_with_edit_box.contents);

                    }

                }

                else
                {

                    if (!strcmp(najitool_language, "English"))
                    {

                        if (strcmp(title_edit_box.contents, "")) fprintf(naji_db_file, "Title: %s\n", title_edit_box.contents);
                        else fprintf(naji_db_file, "Title: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(full_name_edit_box.contents, "")) fprintf(naji_db_file, "Full name: %s\n", full_name_edit_box.contents);
                        else fprintf(naji_db_file, "Full name: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(gender_edit_box.contents, "")) fprintf(naji_db_file, "Gender: %s\n", gender_edit_box.contents);
                        else fprintf(naji_db_file, "Gender: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(date_of_birth_edit_box.contents, "")) fprintf(naji_db_file, "Date of birth: %s\n", date_of_birth_edit_box.contents);
                        else fprintf(naji_db_file, "Date of birth: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(marital_status_edit_box.contents, "")) fprintf(naji_db_file, "Marital status: %s\n", marital_status_edit_box.contents);
                        else fprintf(naji_db_file, "Marital status: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_height_edit_box.contents, "")) fprintf(naji_db_file, "Height: %s\n", naji_db_height_edit_box.contents);
                        else fprintf(naji_db_file, "Height: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_weight_edit_box.contents, "")) fprintf(naji_db_file, "Weight: %s\n", naji_db_weight_edit_box.contents);
                        else fprintf(naji_db_file, "Weight: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_build_edit_box.contents, "")) fprintf(naji_db_file, "Build: %s\n", naji_db_build_edit_box.contents);
                        else fprintf(naji_db_file, "Build: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(hair_color_edit_box.contents, "")) fprintf(naji_db_file, "Hair color: %s\n", hair_color_edit_box.contents);
                        else fprintf(naji_db_file, "Hair color: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(eye_color_edit_box.contents, "")) fprintf(naji_db_file, "Eye color: %s\n", eye_color_edit_box.contents);
                        else fprintf(naji_db_file, "Eye color: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(favourite_food_edit_box.contents, "")) fprintf(naji_db_file, "Favourite food: %s\n", favourite_food_edit_box.contents);
                        else fprintf(naji_db_file, "Favourite food: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(favourite_drink_edit_box.contents, "")) fprintf(naji_db_file, "Favourite drink: %s\n", favourite_drink_edit_box.contents);
                        else fprintf(naji_db_file, "Favourite drink: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(home_number_edit_box.contents, "")) fprintf(naji_db_file, "Home number: %s\n", home_number_edit_box.contents);
                        else fprintf(naji_db_file, "Home number: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(work_number_edit_box.contents, "")) fprintf(naji_db_file, "Work number: %s\n", work_number_edit_box.contents);
                        else fprintf(naji_db_file, "Work number: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(fax_number_edit_box.contents, "")) fprintf(naji_db_file, "Fax number: %s\n", fax_number_edit_box.contents);
                        else fprintf(naji_db_file, "Fax number: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(cell_number_edit_box.contents, "")) fprintf(naji_db_file, "Cell number: %s\n", cell_number_edit_box.contents);
                        else fprintf(naji_db_file, "Cell number: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(home_address_edit_box.contents, "")) fprintf(naji_db_file, "Home address: %s\n", home_address_edit_box.contents);
                        else fprintf(naji_db_file, "Home address: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(work_address_edit_box.contents, "")) fprintf(naji_db_file, "Work address: %s\n", work_address_edit_box.contents);
                        else fprintf(naji_db_file, "Work address: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(occupation_edit_box.contents, "")) fprintf(naji_db_file, "Occupation: %s\n", occupation_edit_box.contents);
                        else fprintf(naji_db_file, "Occupation: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_email_edit_box.contents, "")) fprintf(naji_db_file, "e-mail: %s\n", naji_db_email_edit_box.contents);
                        else fprintf(naji_db_file, "e-mail: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_website_edit_box.contents, "")) fprintf(naji_db_file, "Website: %s\n", naji_db_website_edit_box.contents);
                        else fprintf(naji_db_file, "Website: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(mothers_full_name_edit_box.contents, "")) fprintf(naji_db_file, "Mother's full name: %s\n", mothers_full_name_edit_box.contents);
                        else fprintf(naji_db_file, "Mother's full name: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(mothers_dob_edit_box.contents, "")) fprintf(naji_db_file, "Mother's date of birth: %s\n", mothers_dob_edit_box.contents);
                        else fprintf(naji_db_file, "Mother's date of birth: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(fathers_full_name_edit_box.contents, "")) fprintf(naji_db_file, "Father's full name: %s\n", fathers_full_name_edit_box.contents);
                        else fprintf(naji_db_file, "Father's full name: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(fathers_dob_edit_box.contents, "")) fprintf(naji_db_file, "Father's date of birth: %s\n", fathers_dob_edit_box.contents);
                        else fprintf(naji_db_file, "Father's date of birth: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(number_of_sisters_edit_box.contents, "")) fprintf(naji_db_file, "Number of sisters: %s\n", number_of_sisters_edit_box.contents);
                        else fprintf(naji_db_file, "Number of sisters: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(number_of_brothers_edit_box.contents, "")) fprintf(naji_db_file, "Number of brothers: %s\n", number_of_brothers_edit_box.contents);
                        else fprintf(naji_db_file, "Number of brothers: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(number_of_children_edit_box.contents, "")) fprintf(naji_db_file, "Number of children: %s\n", number_of_children_edit_box.contents);
                        else fprintf(naji_db_file, "Number of children: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        fprintf(naji_db_file, "\n");

                    }

                    if (!strcmp(najitool_language, "Turkish"))
                    {

                        if (strcmp(title_edit_box.contents, "")) fprintf(naji_db_file, "Unvan: %s\n", title_edit_box.contents);
                        else fprintf(naji_db_file, "Unvan: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(full_name_edit_box.contents, "")) fprintf(naji_db_file, "Tum Isim: %s\n", full_name_edit_box.contents);
                        else fprintf(naji_db_file, "Tum Isim: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(gender_edit_box.contents, "")) fprintf(naji_db_file, "Cinsiyet: %s\n", gender_edit_box.contents);
                        else fprintf(naji_db_file, "Cinsiyet: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(date_of_birth_edit_box.contents, "")) fprintf(naji_db_file, "Dogum Tarih: %s\n", date_of_birth_edit_box.contents);
                        else fprintf(naji_db_file, "Dogum Tarih: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(marital_status_edit_box.contents, "")) fprintf(naji_db_file, "Evlilik Durumu: %s\n", marital_status_edit_box.contents);
                        else fprintf(naji_db_file, "Evlilik Durumu: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_height_edit_box.contents, "")) fprintf(naji_db_file, "Boy: %s\n", naji_db_height_edit_box.contents);
                        else fprintf(naji_db_file, "Boy: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_weight_edit_box.contents, "")) fprintf(naji_db_file, "Kilo: %s\n", naji_db_weight_edit_box.contents);
                        else fprintf(naji_db_file, "Kilo: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_build_edit_box.contents, "")) fprintf(naji_db_file, "Yapi: %s\n", naji_db_build_edit_box.contents);
                        else fprintf(naji_db_file, "Yapi: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(hair_color_edit_box.contents, "")) fprintf(naji_db_file, "Sac Renk: %s\n", hair_color_edit_box.contents);
                        else fprintf(naji_db_file, "Sac Renk: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(eye_color_edit_box.contents, "")) fprintf(naji_db_file, "Goz Renk: %s\n", eye_color_edit_box.contents);
                        else fprintf(naji_db_file, "Goz Renk: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(favourite_food_edit_box.contents, "")) fprintf(naji_db_file, "En Sevdigi Yemek: %s\n", favourite_food_edit_box.contents);
                        else fprintf(naji_db_file, "En Sevdigi Yemek: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(favourite_drink_edit_box.contents, "")) fprintf(naji_db_file, "En Sevdigi Icicek: %s\n", favourite_drink_edit_box.contents);
                        else fprintf(naji_db_file, "En Sevdigi Icicek: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(home_number_edit_box.contents, "")) fprintf(naji_db_file, "Ev Telefon: %s\n", home_number_edit_box.contents);
                        else fprintf(naji_db_file, "Ev Telefon: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(work_number_edit_box.contents, "")) fprintf(naji_db_file, "Is Telefon: %s\n", work_number_edit_box.contents);
                        else fprintf(naji_db_file, "Is Telefon: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(fax_number_edit_box.contents, "")) fprintf(naji_db_file, "Faks Numara: %s\n", fax_number_edit_box.contents);
                        else fprintf(naji_db_file, "Faks Numara: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(cell_number_edit_box.contents, "")) fprintf(naji_db_file, "Cep Telefon: %s\n", cell_number_edit_box.contents);
                        else fprintf(naji_db_file, "Cep Telefon: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(home_address_edit_box.contents, "")) fprintf(naji_db_file, "Ev Adres: %s\n", home_address_edit_box.contents);
                        else fprintf(naji_db_file, "Ev Adres: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(work_address_edit_box.contents, "")) fprintf(naji_db_file, "Is Adres: %s\n", work_address_edit_box.contents);
                        else fprintf(naji_db_file, "Is Adres: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(occupation_edit_box.contents, "")) fprintf(naji_db_file, "Meslek: %s\n", occupation_edit_box.contents);
                        else fprintf(naji_db_file, "Meslek: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_email_edit_box.contents, "")) fprintf(naji_db_file, "E-Posta Adres: %s\n", naji_db_email_edit_box.contents);
                        else fprintf(naji_db_file, "E-Posta Adres: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(naji_db_website_edit_box.contents, "")) fprintf(naji_db_file, "Vebsite: %s\n", naji_db_website_edit_box.contents);
                        else fprintf(naji_db_file, "Vebsite: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(mothers_full_name_edit_box.contents, "")) fprintf(naji_db_file, "Tum Ana Ismi: %s\n", mothers_full_name_edit_box.contents);
                        else fprintf(naji_db_file, "Tum Ana Ismi: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(mothers_dob_edit_box.contents, "")) fprintf(naji_db_file, "Ana Dogum Tarih: %s\n", mothers_dob_edit_box.contents);
                        else fprintf(naji_db_file, "Ana Dogum Tarih: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(fathers_full_name_edit_box.contents, "")) fprintf(naji_db_file, "Tum Baba Ismi: %s\n", fathers_full_name_edit_box.contents);
                        else fprintf(naji_db_file, "Tum Baba Ismi: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(fathers_dob_edit_box.contents, "")) fprintf(naji_db_file, "Baba Dogum Tarih: %s\n", fathers_dob_edit_box.contents);
                        else fprintf(naji_db_file, "Baba Dogum Tarih: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(number_of_sisters_edit_box.contents, "")) fprintf(naji_db_file, "Kac Abla/Kiz Kardes: %s\n", number_of_sisters_edit_box.contents);
                        else fprintf(naji_db_file, "Kac Abla/Kiz Kardes: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(number_of_brothers_edit_box.contents, "")) fprintf(naji_db_file, "Kac Abi/Erkek Kardes: %s\n", number_of_brothers_edit_box.contents);
                        else fprintf(naji_db_file, "Kac Abi/Erkek Kardes: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        if (strcmp(number_of_children_edit_box.contents, "")) fprintf(naji_db_file, "Number of children: %s\n", number_of_children_edit_box.contents);
                        else fprintf(naji_db_file, "Cocuk Sayisi: %s\n", add_entry_fill_blanks_with_edit_box.contents);

                        fprintf(naji_db_file, "\n");

                    }

                }

                fseek (naji_db_file , 0, SEEK_SET);

                while (1)
                {

                    naji_db_a = fgetc(naji_db_file);

                    if (naji_db_a == EOF)
                        break;

                    view_database_edit_box.AddCh(naji_db_a);
                }

            }
            else
            {
                if (!strcmp(najitool_language, "English"))
                    MessageBox { text = "najitool GUI database error:", contents = "Please select a file to create or to append the database entries to." }.Modal();
                else if (!strcmp(najitool_language, "Turkish"))
                    MessageBox { text = "najitool GUI veritabani hata:", contents = "Lutfen bir dosya secin olusturmak icin veya bir dosya secin veritabani kayitlari eklenmesi icin." }.Modal();
            }

            return true;
        }
    };
    Button file_to_append_entries_to_button
    {
        this, text = "File to append entries to:", size = { 176, 21 }, position = { 416, 16 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            naji_db_append_file_dialog.type=save;

            if (naji_db_append_file_dialog.Modal() == ok)
            {
                strcpy(naji_db_filepath_buffer, naji_db_append_file_dialog.filePath);
                file_to_append_naji_db_edit_box.contents = naji_db_append_file_dialog.filePath;

                naji_db_file = fopen(naji_db_filepath_buffer, "ab+");
                if (naji_db_file == NULL)
                {

                    if (!strcmp(najitool_language, "English"))
                    {
                        sprintf(naji_db_error_buffer, "Error opening file %s please select another file to append database entries to or type a new name.", naji_db_filepath_buffer);
                        MessageBox { text = "najitool GUI database error:", contents = naji_db_error_buffer }.Modal();
                    }
                    else if (!strcmp(najitool_language, "Turkish"))
                    {

                        sprintf(naji_db_error_buffer, "%s dosyasi acilirken hata oldu, veritabani kayitlari eklemek icin baska dosya secin veya yeni bir dosya ad yazin.", naji_db_filepath_buffer);
                        MessageBox { text = "najitool GUI veritabani hata:", contents = naji_db_error_buffer }.Modal();
                    }

                    file_to_append_naji_db_edit_box.Clear();
                    naji_db_file_selected = false;
                }
                else
                {

                    naji_db_file_selected = true;

                    while (1)
                    {

                        naji_db_a = fgetc(naji_db_file);

                        if (naji_db_a == EOF)
                            break;

                        view_database_edit_box.AddCh(naji_db_a);

                    }

                }

            }
            return true;
        }
    };
    EditBox file_to_append_naji_db_edit_box { this, text = "file_to_append_naji_db", size = { 246, 19 }, position = { 752, 16 }, readOnly = true };
    Button database_text_radio_button
    {
        this, text = "Text", position = { 600, 16 }, isRadio = true, bitmap = { "<:ecere>elements/optionBoxDown.png", transparent = true };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            naji_db_html_selected = false;

            return true;
        }

        bool NotifyPushed(Button button, int x, int y, Modifiers mods)
        {

            database_text_radio_button.bitmap = { "<:ecere>elements/optionBoxSelectedDown.png", transparent = true };
            database_html_radio_button.bitmap = { "<:ecere>elements/optionBoxUp.png", transparent = true };

            return true;
        }
    };
    Button database_html_radio_button
    {
        this, text = "HTML", position = { 680, 16 }, isRadio = true, bitmap = { "<:ecere>elements/optionBoxDown.png", transparent = true };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            naji_db_html_selected = true;
            return true;
        }

        bool NotifyPushed(Button button, int x, int y, Modifiers mods)
        {
            database_text_radio_button.bitmap = { "<:ecere>elements/optionBoxUp.png", transparent = true };
            database_html_radio_button.bitmap = { "<:ecere>elements/optionBoxSelectedDown.png", transparent = true };

            return true;
        }
    };
    EditBox view_database_edit_box { this, text = "view_database", size = { 578, 610 }, position = { 416, 48 }, hasHorzScroll = true, true, true, readOnly = true, true };

    bool OnCreate(void)
    {

        if (!strcmp(najitool_language, "English"))
        {

            clear_all_entry_items_button.text="Clear All Entry Items";
            add_entry_button.text="Add Entry";
            add_entry_omits_empty_items_button.text="Add Entry, Omits Empty Items";
            add_entry_fill_blanks_with_button.text="Add Entry, Fill Blanks With:";
            file_to_append_entries_to_button.text="File to append entries to:";
            database_text_radio_button.text="Text";
            database_html_radio_button.text="HTML";

            title_label.text = "Title:";
            full_name_label.text = "Full name:";
            gender_label.text = "Gender:";
            date_of_birth_label.text = "Date of birth:";
            marital_status_label.text = "Marital status:";
            naji_db_height_label.text = "Height:";
            naji_db_weight_label.text = "Weight:";
            naji_db_build_label.text = "Build:";
            hair_color_label.text = "Hair color:";
            eye_color_label.text = "Eye color:";
            favourite_food_label.text = "Favourite food:";
            favourite_drink_label.text = "Favourite drink:";
            home_number_label.text = "Home number:";
            work_number_label.text = "Work number:";
            occupation_label.text = "Occupation";
            fax_number_label.text = "Fax number:";
            cell_number_label.text = "Cell number:";
            home_address_label.text = "Home address:";
            work_address_label.text = "Work address:";
            naji_db_email_label.text = "e-mail:";
            naji_db_website_label.text = "Website:";
            mothers_full_name_label.text = "Mother's full name:";
            mothers_dob_label.text = "Mother's date of birth:";
            fathers_full_name_label.text = "Father's full name:";
            fathers_dob_label.text = "Father's date of birth:";
            number_of_sisters_label.text = "Number of sisters:";
            number_of_brothers_label.text = "Number of brothers:";
            number_of_children_label.text = "Number of children:";

        }

        if (!strcmp(najitool_language, "Turkish"))
        {

            clear_all_entry_items_button.text="Butun Kutulari Bosalt";
            add_entry_button.text="Kayit Yap";
            add_entry_omits_empty_items_button.text="Kayit Yap, Bos Kutu Haric";
            add_entry_fill_blanks_with_button.text="Kayit Yap, Koy Bos Kutlara:";
            file_to_append_entries_to_button.text="Kayitlar Eklenen Dosya:";
            database_text_radio_button.text="Metin";
            database_html_radio_button.text="HTML";

            title_label.text = "Unvan:";
            full_name_label.text = "Tum Isim:";
            gender_label.text = "Cinsiyet:";
            date_of_birth_label.text = "Dogum Tarih:";
            marital_status_label.text = "Evlilik Durumu:";
            naji_db_height_label.text = "Boy:";
            naji_db_weight_label.text = "Kilo:";
            naji_db_build_label.text = "Yapi:";
            hair_color_label.text = "Sac Renk:";
            eye_color_label.text = "Goz Renk:";
            favourite_food_label.text = "En Sevdigi Yemek:";
            favourite_drink_label.text = "En Sevdigi Icicek:";
            home_number_label.text = "Ev Telefon:";
            work_number_label.text = "Is Telefon:";
            occupation_label.text = "Meslek";
            fax_number_label.text = "Faks Numara:";
            cell_number_label.text = "Cep Telefon:";
            home_address_label.text = "Ev Adres:";
            work_address_label.text = "Is Adres:";
            naji_db_email_label.text = "E-Posta Adres:";
            naji_db_website_label.text = "Vebsite:";
            mothers_full_name_label.text = "Tum Ana Ismi:";
            mothers_dob_label.text = "Ana Dogum Tarih:";
            fathers_full_name_label.text = "Tum Baba Isim:";
            fathers_dob_label.text = "Baba Dogum Tarih:";
            number_of_sisters_label.text = "Kac Abla/Kiz Kardes:";
            number_of_brothers_label.text = "Kac Abi/Erkek Kardes:";
            number_of_children_label.text = "Cocuk Sayisi:";

        }

        if (naji_db_html_selected == false)
        {
            database_text_radio_button.checked=true;
            database_html_radio_button.checked=false;

            database_text_radio_button.bitmap = { "<:ecere>elements/optionBoxSelectedDown.png", transparent = true };
            database_html_radio_button.bitmap = { "<:ecere>elements/optionBoxUp.png", transparent = true };

        }
        else
        {
            database_text_radio_button.checked=false;
            database_html_radio_button.checked=true;

            database_text_radio_button.bitmap = { "<:ecere>elements/optionBoxUp.png", transparent = true };
            database_html_radio_button.bitmap = { "<:ecere>elements/optionBoxSelectedDown.png", transparent = true };

        }

        return true;
    }

    void add_entry_item_html(char *entry_item, char *details)
    {

        fprintf(naji_db_file, "<b>%s</b>%s<br>\n", entry_item, details);
        fflush(naji_db_file);
        return;
    }

    void add_entry_item_html_email(char *entry_item, char *details)
    {

        fprintf(naji_db_file, "<b>%s</b><a href=\"mailto:%s\">%s</a></br>\n",
                entry_item, details, details);
        fflush(naji_db_file);
        return;
    }

    void add_entry_item_html_link(char *entry_item, char *details)
    {

        fprintf(naji_db_file, "<b>%s</b><a href=\"%s\">%s</a><br>\n",
                entry_item, details, details);
        fflush(naji_db_file);
        return;
    }
    EditBox add_entry_fill_blanks_with_edit_box
    {
        this, text = "add_entry_fill_blanks_with_edit_box", size = { 102, 19 }, position = { 896, 664 };

        bool NotifyModified(EditBox editBox)
        {

            return true;
        }
    };
}

class tab_mathgame : Tab
{
    text = "MathGM";
    background = { r = 110, g = 161, b = 180 };
    font = { "Verdana", 8.25f, bold = true };
    size = { 1024, 768 };

    int mathgame_op;
    int mathgame_lvalue;
    int mathgame_rvalue;
    int answer;
    int mathgame_points;
    char mathgame_lvalue_string[4082];
    char mathgame_rvalue_string[4082];
    char mathgame_points_string[4082];
    bool mathgame_started;
    mathgame_started = false;

    void OnRedraw(Surface surface)
    {
        ColorKey keys[2] = { {0x6EA1B4, 0.0f}, { white, 1.0f } };
        surface.Gradient(keys, sizeof(keys) / sizeof(ColorKey), 1, vertical, 1, 0, 1024-3, 768 - 3);
        Update(null);
    }

    EditBox mathgame_users_answer_edit_box
    {
        this, text = "mathgame_users_answer_edit_box", size = { 214, 19 }, position = { 384, 352 };

        bool NotifyKeyDown(EditBox editBox, Key key, unichar ch)
        {
            if (key == enter || key == keyPadEnter)
                mathgame_user_answers();

            return true;
        }

    };
    EditBox mathgame_right_answers_edit_box { this, text = "mathgame_right_answers_edit_box", size = { 286, 595 }, position = { 712, 80 }, hasHorzScroll = true, true, true, readOnly = true, true };
    Label mathgame_right_answers_label { this, text = "Right Answers:", position = { 800, 40 } };
    Label mathgame_wrong_answers_label { this, text = "Wrong Answers:", position = { 88, 40 } };
    Label mathgame_points_label { this, text = "0 Points", font = { "Verdana", 20, bold = true }, position = { 432, 648 } };
    EditBox mathgame_wrong_answers_edit_box { this, text = "mathgame_wrong_answers_edit_box", size = { 286, 603 }, position = { 8, 72 }, hasHorzScroll = true, true, true, readOnly = true, true };
    Button mathgame_answer_button
    {
        this, text = "Answer", size = { 220, 21 }, position = { 384, 376 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            mathgame_user_answers();

            return true;
        }
    };
    Label mathgame_whatis_label { this, text = "What is", font = { "Verdana", 13, bold = true }, position = { 448, 224 } };
    Label mathgame_lvalue_label { this, text = "lvalue", font = { "Verdana", 13, bold = true }, position = { 384, 264 } };
    Label mathgame_operator_label { this, text = "op", font = { "Verdana", 16, bold = true }, position = { 480, 264 } };
    Label mathgame_rvalue_label { this, text = "rvalue", font = { "Verdana", 13, bold = true }, position = { 560, 264 } };
    Label mathgame_get_right_label { this, text = "Get the answers right to score points.", position = { 368, 112 } };
    Label mathgame_get_wrong_label { this, text = "Get the answers wrong to lose points.", position = { 368, 136 } };
    Label mathgame_welcome_label { this, text = "Welcome to MathGame", font = { "Verdana", 20, bold = true }, position = { 328, 64 } };

    bool OnCreate(void)
    {
        if (!strcmp(najitool_language, "English"))
        {

            mathgame_welcome_label.text = "Welcome to MathGame";
            mathgame_answer_button.text = "Answer";
            mathgame_right_answers_label.text = "Right Answers:";
            mathgame_wrong_answers_label.text = "Wrong Answers:";
            mathgame_points_label.text = "0 Points";
            mathgame_whatis_label.text="What is";
            mathgame_get_right_label.text = "Get the answers right to score points.";
            mathgame_get_wrong_label.text = "Get the answers wrong to lose points.";

        }

        if (!strcmp(najitool_language, "Turkish"))
        {

            mathgame_welcome_label.text = "MataOyun'a Hosgeldiniz";
            mathgame_answer_button.text = "Cevapla";
            mathgame_right_answers_label.text = "Dogru Cevaplar:";
            mathgame_wrong_answers_label.text = "Yanlis Cevaplar:";
            mathgame_points_label.text = "0 Puan";
            mathgame_whatis_label.text="Su Nedir";
            mathgame_get_right_label.text = "Dogru cevapla puan kazanmak icin.";
            mathgame_get_wrong_label.text = "Yanlis cevapla puan kaybetmek icin.";

        }

        rndinit();
        mathgame_points=0;

        mathgame_wrong_answers_edit_box.Clear();
        mathgame_right_answers_edit_box.Clear();
        mathgame_users_answer_edit_box.Clear();

        if (mathgame_started == false)
        {
            mathgame();
            mathgame_started = true;
        }

        return true;
    }

    void mathgame(void)
    {

        mathgame_op = rndrange(0, 3);

        if (mathgame_op == 0)
        {
            mathgame_operator_label.text="+";
            mathgame_lvalue = rndrange(0, 1000);
            mathgame_rvalue = rndrange(0, 1000);
        }

        else if (mathgame_op == 1)
        {
            mathgame_operator_label.text="-";
            mathgame_lvalue = rndrange(0, 1000);
            mathgame_rvalue = rndrange(0, 1000);

            if (mathgame_rvalue > mathgame_lvalue)
                swap_ulong(mathgame_rvalue, mathgame_lvalue);
        }

        else if (mathgame_op == 2)
        {
            mathgame_operator_label.text="*";
            mathgame_lvalue = rndrange(0, 12);
            mathgame_rvalue = rndrange(0, 12);
        }

        else if (mathgame_op == 3)
        {
            mathgame_operator_label.text="/";
            mathgame_lvalue = rndrange(1, 10);
            mathgame_rvalue = rndrange(1, 10);
        }

        sprintf(mathgame_lvalue_string, "%i", mathgame_lvalue);
        sprintf(mathgame_rvalue_string, "%i", mathgame_rvalue);

        mathgame_lvalue_label.text = mathgame_lvalue_string;
        mathgame_rvalue_label.text = mathgame_rvalue_string;

    }

    void mathgame_user_answers(void)
    {

        answer = atoi(mathgame_users_answer_edit_box.contents);

        if (!strcmp(najitool_language, "English"))
        {

            if (mathgame_op == 0)
            {
                if (answer == (mathgame_lvalue + mathgame_rvalue))
                {
                    mathgame_right_answers_edit_box.Printf("Right answer: %i + %i == %i\n", mathgame_lvalue, mathgame_rvalue, (mathgame_lvalue + mathgame_rvalue));
                    mathgame_points++;
                }

                else
                {
                    mathgame_wrong_answers_edit_box.Printf("Wrong answer: %i + %i != %i\nCorrect answer is: %i + %i == %i\n\n", mathgame_lvalue, mathgame_rvalue, answer, mathgame_lvalue, mathgame_rvalue, (mathgame_lvalue + mathgame_rvalue));
                    mathgame_points--;
                }
            }

            if (mathgame_op == 1)
            {
                if (answer == (mathgame_lvalue - mathgame_rvalue))
                {
                    mathgame_right_answers_edit_box.Printf("Right answer: %i - %i == %i\n", mathgame_lvalue, mathgame_rvalue, (mathgame_lvalue - mathgame_rvalue));
                    mathgame_points++;
                }
                else
                {
                    mathgame_wrong_answers_edit_box.Printf("Wrong answer: %i - %i != %i\nCorrect answer is: %i - %i == %i\n\n", mathgame_lvalue, mathgame_rvalue, answer, mathgame_lvalue, mathgame_rvalue, (mathgame_lvalue - mathgame_rvalue));
                    mathgame_points--;
                }

            }

            if (mathgame_op == 2)
            {
                if (answer == (mathgame_lvalue * mathgame_rvalue))
                {
                    mathgame_right_answers_edit_box.Printf("Right answer: %i * %i == %i\n", mathgame_lvalue, mathgame_rvalue, (mathgame_lvalue * mathgame_rvalue));
                    mathgame_points++;
                }
                else
                {
                    mathgame_wrong_answers_edit_box.Printf("Wrong answer: %i * %i != %i\nCorrect answer is: %i * %i == %i\n\n", mathgame_lvalue, mathgame_rvalue, answer, mathgame_lvalue, mathgame_rvalue, (mathgame_lvalue * mathgame_rvalue));
                    mathgame_points--;
                }
            }

            if (mathgame_op == 3)
            {
                if (answer == (mathgame_lvalue / mathgame_rvalue))
                {
                    mathgame_right_answers_edit_box.Printf("Right answer: %i / %i == %i\n", mathgame_lvalue, mathgame_rvalue, (mathgame_lvalue / mathgame_rvalue));
                    mathgame_points++;
                }
                else
                {
                    mathgame_wrong_answers_edit_box.Printf("Wrong answer: %i / %i != %i\nCorrect answer is: %i / %i == %i\n\n", mathgame_lvalue, mathgame_rvalue, answer, mathgame_lvalue, mathgame_rvalue, (mathgame_lvalue / mathgame_rvalue));
                    mathgame_points--;
                }
            }

            sprintf(mathgame_points_string, "%i Points", mathgame_points);

        }

        if (!strcmp(najitool_language, "Turkish"))
        {

            if (mathgame_op == 0)
            {
                if (answer == (mathgame_lvalue + mathgame_rvalue))
                {
                    mathgame_right_answers_edit_box.Printf("Dogru cevap: %i + %i == %i\n", mathgame_lvalue, mathgame_rvalue, (mathgame_lvalue + mathgame_rvalue));
                    mathgame_points++;
                }

                else
                {
                    mathgame_wrong_answers_edit_box.Printf("Yanlis cevap: %i + %i != %i\nDogru cevap sudur: %i + %i == %i\n\n", mathgame_lvalue, mathgame_rvalue, answer, mathgame_lvalue, mathgame_rvalue, (mathgame_lvalue + mathgame_rvalue));
                    mathgame_points--;
                }
            }

            if (mathgame_op == 1)
            {
                if (answer == (mathgame_lvalue - mathgame_rvalue))
                {
                    mathgame_right_answers_edit_box.Printf("Dogru cevap: %i - %i == %i\n", mathgame_lvalue, mathgame_rvalue, (mathgame_lvalue - mathgame_rvalue));
                    mathgame_points++;
                }
                else
                {
                    mathgame_wrong_answers_edit_box.Printf("Yanlis cevap: %i - %i != %i\nDogru cevap sudur: %i - %i == %i\n\n", mathgame_lvalue, mathgame_rvalue, answer, mathgame_lvalue, mathgame_rvalue, (mathgame_lvalue - mathgame_rvalue));
                    mathgame_points--;
                }

            }

            if (mathgame_op == 2)
            {
                if (answer == (mathgame_lvalue * mathgame_rvalue))
                {
                    mathgame_right_answers_edit_box.Printf("Dogru cevap: %i * %i == %i\n", mathgame_lvalue, mathgame_rvalue, (mathgame_lvalue * mathgame_rvalue));
                    mathgame_points++;
                }
                else
                {
                    mathgame_wrong_answers_edit_box.Printf("Yanlis cevap: %i * %i != %i\nDogru cevap sudur: %i * %i == %i\n\n", mathgame_lvalue, mathgame_rvalue, answer, mathgame_lvalue, mathgame_rvalue, (mathgame_lvalue * mathgame_rvalue));
                    mathgame_points--;
                }
            }

            if (mathgame_op == 3)
            {
                if (answer == (mathgame_lvalue / mathgame_rvalue))
                {
                    mathgame_right_answers_edit_box.Printf("Dogru cevapr: %i / %i == %i\n", mathgame_lvalue, mathgame_rvalue, (mathgame_lvalue / mathgame_rvalue));
                    mathgame_points++;
                }
                else
                {
                    mathgame_wrong_answers_edit_box.Printf("Yanlis cevap: %i / %i != %i\nDogru cevap sudur: %i / %i == %i\n\n", mathgame_lvalue, mathgame_rvalue, answer, mathgame_lvalue, mathgame_rvalue, (mathgame_lvalue / mathgame_rvalue));
                    mathgame_points--;
                }
            }

            sprintf(mathgame_points_string, "%i Puan", mathgame_points);
        }

        mathgame_points_label.text=mathgame_points_string;
        mathgame();

        mathgame_users_answer_edit_box.Clear();

    }
}

class HexEditorTop : Window
{
    size = { 1024, 24 };
    disabled = true;

    Label hex_top_label { this, text = "Offset:           0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F     0 1 2 3 4 5 6 7 8 9 A B C D E F" , position = { 316, 2}};
}

class HexEditor : Window
{
    size = { 1024, 768 };

    char patch_load_file_path[MAX_LOCATION];
    byte a;
    unsigned long long i;
    unsigned long long ii;
    unsigned long long buffer_size;
    unsigned long long offset;
    int left_double;
    int right_double;
    uint patch_load_file_size;
    uint x;
    uint y;
    uint xx;
    uint yy;
    uint xxx;
    uint yyy;
    byte * read_buffer;
    uint scroll_pos;

    BufferedFile patch_load_file;
    File patch_save_as_hex_file;

    left_double = 0;
    right_double = 0;
    i=0;
    buffer_size=0;
    x = 340;
    y = 24;
    ii=0;
    a = 0;
    scroll_pos = 0;
    offset = 0;

    Button scroll_down
    {
        this, text = "Scroll Down", size = { 104, 21 }, position = { 8, 184 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            scroll_pos-=1;

            if (scroll_pos < 0)
                scroll_pos = 0;

            Scroll(0, scroll_pos);
            Update(null);

            return true;
        }
    };
    Button scroll_up
    {
        this, text = "Scroll Up", size = { 104, 21 }, position = { 8, 152 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            if (scroll_pos > 0)
                scroll_pos+=1;

            Scroll(0, scroll_pos);
            Update(null);

            return true;
        }
    };

    void OnRedraw(Surface surface)
    {

        i=0;

        for (offset=0, yy=scroll_pos; ;yy++, offset++)
        {

            for (xx=0; xx<16; xx++)
            {

                if (i >= buffer_size)
                    break;

                surface.WriteTextf((x-24), ((y)+(yy)*(12)-24), "%08X ", (offset * 16));

                surface.WriteTextf(  ( (x) + (xx) * (24)  + 60 ), ((y)+(yy)*(12)-24), "%02X ", read_buffer[i]);
                i++;

                if ( ( (read_buffer[i] >= ' ') && (read_buffer[i] <= '~') ) )
                    surface.WriteTextf( ( ( (x) + (xx) * (12)) + 455), ((y)+(yy)*(12)-24), "%c", read_buffer[i]);

                else
                    surface.WriteTextf( ( ( (x) + (xx) * (12)) + 455), ((y)+(yy)*(12)-24), ".");

                SetCaret(400+xxx, ((y+yyy)-24), 12);
            }

            if (i >= buffer_size)
                return;

        }

    }
    Button save_button { this, text = "Save", size = { 106, 21 }, position = { 8, 56 } };
    Button save_as_button { this, text = "Save As...", size = { 106, 21 }, position = { 8, 88 } };
    Button save_as_hex_button { this, text = "Save As Hex...", size = { 106, 21 }, position = { 8, 120 } };
    EditBox patch_load_file_edit_box { this, text = "patch_load_file_edit_box", size = { 104, 19 }, position = { 8, 24 }, readOnly = true, noCaret = true };
    Button patch_load_file_button
    {
        this, text = "Load File...", font = { "Verdana", 8.25f, bold = true }, clientSize = { 104, 21 }, position = { 8 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            i=0;
            buffer_size=0;
            x = 340;
            y = 24;
            ii=0;

            a = 0;

            SetCaret(400, 0, 12);

            patch_load_file_dialog.type=open;

            if (patch_load_file_dialog.Modal() == ok)
            {
                strcpy(patch_load_file_path, patch_load_file_dialog.filePath);
                patch_load_file_edit_box.contents = patch_load_file_dialog.filePath;
                patch_load_file = FileOpenBuffered(patch_load_file_path, read);

                patch_load_file_size =  patch_load_file.GetSize();

                read_buffer = new byte[patch_load_file_size];

                for (ii=0; ii<patch_load_file_size; ii++)
                {
                    patch_load_file.Get(a);

                    if (patch_load_file.eof == true)
                        break;

                    read_buffer[buffer_size] = a;

                    buffer_size++;
                }

                patch_load_file.Close();
            }
            return true;
        }
    };

    bool OnCreate(void)
    {

        if (!strcmp(najitool_language, "English"))
        {
            save_button.text="Save";
            save_as_button.text="Save As...";
            save_as_hex_button.text="Save As Hex...";
            patch_load_file_button.text="Load File...";
        }

        else if (!strcmp(najitool_language, "Turkish"))
        {
            save_button.text="Kaydet";
            save_as_button.text="Farkli Kaydet...";
            save_as_hex_button.text="Onalti Kaydet...";
            patch_load_file_button.text="Dosya Ac...";
        }

        return true;
    }

    bool OnKeyHit(Key key, unichar ch)
    {

        if (key == left)
        {

            if (xxx >= 8)
            {

                if (left_double == 2)
                {
                    xxx-=16;
                    left_double = 0;
                    right_double = 1;
                }
                else
                {
                    xxx-=8;
                }

                SetCaret(400+xxx, ((y+yyy)-24), 12);
                left_double++;
            }

            else
            {
                xxx = 368;
                SetCaret(400+xxx, ((y+yyy)-24), 12);

                left_double = 1;
                right_double = 0;
            }

        }

        if (key == right)
        {
            if (xxx < 368)
            {

                if (right_double == 2)
                {
                    xxx+=16;
                    left_double = 1;
                    right_double = 0;
                }
                else
                {
                    xxx+=8;
                }
                SetCaret(400+xxx, ((y+yyy)-24), 12);
                right_double++;
            }

            else
            {
                xxx = 0;
                SetCaret(400+xxx, ((y+yyy)-24), 12);
                left_double = 0;
                right_double = 1;
            }

        }

        if (yyy >= 12)
        {

            if (key == up)
            {
                yyy-=12;
                SetCaret(400+xxx, ((y+yyy)-24), 12);
            }

        }

        if (key == down)
        {
            yyy+=12;
            SetCaret(400+xxx, ((y+yyy)-24), 12);
        }

        return false;
    }

}

class tab_patch : Tab
{
    text = "HexEdit";
    background = { r = 110, g = 161, b = 180 };
    font = { "Verdana", 8.25f, bold = true };
    size = { 1024, 768 };

    HexEditorTop najihexTop { this, anchor = { 0, 0, 0, 0 } };
    HexEditor najihex { this, anchor = { 0, 0, 0, 0 }, position = { 0, 24}};
}

class naji_gui : GuiApplication
{
    driver = "OpenGL";
}
