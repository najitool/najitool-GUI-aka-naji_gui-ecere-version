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
import "najcrypt"
#include "naji_gui.eh"       

class tab_crypt : Tab
{
    text = "Crypt";
    background = { r = 110, g = 161, b = 180 };
    font = { "Verdana", 8.25f, bold = true };
    size = { 1280, 1024 };

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
        surface.Gradient(keys, sizeof(keys) / sizeof(ColorKey), 1, vertical, 1, 0, 1280-3, 1024 - 3);
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

