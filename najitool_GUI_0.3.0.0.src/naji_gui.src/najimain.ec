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
import "najiform"
#include "naji_gui.eh"

class bump : Window
{
    borderStyle = fixed;
    hasClose = true;
    size = { 640, 400 };

    Picture picture
    {
        this;
    };

    bool OnCreate(void)
    {
        picture.image = {".najiout.bmp"};
        return true;
    }

}

File najimainfile;

class tab_main : Tab
{
    text = "Main";
    background = { r = 110, g = 161, b = 180 };
    font = { "Verdana", 8.25f, bold = true };
    size = { 1111, 900 };

    int ey;
    char input_file_1_path[MAX_LOCATION];
    char input_file_2_path[MAX_LOCATION];
    char input_folder_path[MAX_LOCATION];
    char output_file_1_path[MAX_LOCATION];
    char output_file_2_path[MAX_LOCATION];
    char output_folder_path[MAX_LOCATION];
    char copyself_path[MAX_LOCATION];
    char naji_buffer[4096];
    char parameter_1_string[4096];
    char parameter_2_string[4096];
    char najitool_command[4096];
    char najitool_category[4096];
    char temp_edit_delete[4096+4096];
    char msgbox_buffer[4096];
    time_t time_value;
    struct tm *date_time;
    najitool_languages lang;
    Bitmap najitempbmp;

    /* Begin: System Date/Time Functions */

    void get_datetime()
    {
        time(&time_value);
        date_time = localtime(&time_value);
    }

    void systemdt()
    {
        get_datetime();
        sprintf(naji_buffer, "Current System Date and Time: %s", asctime(date_time));
        help_edit_box.contents=naji_buffer;
    }
    /* End: System Date/Time Functions */

    /* Begin: English Date/Time Functions */

    void telltime()
    {
        get_datetime();
        sprintf(naji_buffer, "%02i:%02i:%02i", date_time->tm_hour, date_time->tm_min, date_time->tm_sec);
        help_edit_box.contents = naji_buffer;
    }

    char * s_today()
    {
        int i;
        get_datetime();
        for (i=0; i<=6; i++) if (date_time->tm_wday == i) return (days[i]);
        return ("(DAY ERROR)");
    }

    char * s_month()
    {
        int i;
        get_datetime();
        for (i=0; i<=11; i++) if (date_time->tm_mon == i) return (months[i]);
        return ("(MONTH ERROR)");
    }

    void today()
    {
        help_edit_box.contents = s_today();
    }

    void dayofmon()
    {
        get_datetime();
        sprintf(naji_buffer, "%i", date_time->tm_mday);
        help_edit_box.contents = naji_buffer;
    }

    void  month()
    {
        help_edit_box.contents = s_month();
    }

    void year()
    {
        get_datetime();
        sprintf(naji_buffer, "%i", ( (1900) + (date_time->tm_year) ) );
        help_edit_box.contents =  naji_buffer;
    }

    void datetime(void)
    {
        char telltime_buf[100];
        char today_buf[100];
        char dayofmon_buf[100];
        char month_buf[100];
        char year_buf[100];
        int i;
        get_datetime();
        sprintf(telltime_buf, "%02i:%02i:%02i", date_time->tm_hour, date_time->tm_min, date_time->tm_sec);
        sprintf(today_buf, s_today());
        sprintf(dayofmon_buf, "%i", date_time->tm_mday);
        sprintf(month_buf, s_month());
        sprintf(year_buf, "%i", ( (1900) + (date_time->tm_year) ) );
        sprintf(naji_buffer, "%s %s %s %s %s", telltime_buf, today_buf, dayofmon_buf, month_buf, year_buf);
        help_edit_box.contents = naji_buffer;
    }
    /* End: English Date/Time Functions */

    /* Begin: Turkish Date/Time Functions */

    void saat()
    {
        get_datetime();
        sprintf(naji_buffer, "%02i:%02i:%02i", date_time->tm_hour, date_time->tm_min, date_time->tm_sec);
        help_edit_box.contents = naji_buffer;
    }

    char * s_bugun()
    {
        int i;
        get_datetime();
        for (i=0; i<=6; i++) if (date_time->tm_wday == i) return (gunler[i]);
        return ("(GUN HATA)");
    }

    char * s_ay()
    {
        int i;
        get_datetime();
        for (i=0; i<=11; i++) if (date_time->tm_mon == i) return (aylar[i]);
        return ("(AY HATA)");
    }

    void bugun()
    {
        help_edit_box.contents = s_bugun();
    }

    void ay()
    {
        help_edit_box.contents = s_ay();
    }

    void ayinkaci()
    {
        get_datetime();
        sprintf(naji_buffer, "%i", date_time->tm_mday);
        help_edit_box.contents = naji_buffer;
    }

    void yil()
    {
        get_datetime();
        sprintf(naji_buffer, "%i", ( (1900) + (date_time->tm_year) ) );
        help_edit_box.contents =  naji_buffer;
    }

    void saatarih(void)
    {
        char telltime_buf[100];
        char today_buf[100];
        char dayofmon_buf[100];
        char month_buf[100];
        char year_buf[100];
        int i;
        get_datetime();
        sprintf(telltime_buf, "%02i:%02i:%02i", date_time->tm_hour, date_time->tm_min, date_time->tm_sec);
        sprintf(today_buf, s_bugun());
        sprintf(dayofmon_buf, "%i", date_time->tm_mday);
        sprintf(month_buf, s_ay());
        sprintf(year_buf, "%i", ( (1900) + (date_time->tm_year) ) );
        sprintf(naji_buffer, "%s %s %s %s %s", telltime_buf, today_buf, dayofmon_buf, month_buf, year_buf);
        help_edit_box.contents = naji_buffer;
    }

    Button wav_of_bytes_button
    {
        this, text = "WAV Sound of Byte Pattern", font = { "Verdana", 6.85f, bold = true }, size = { 182, 21 }, position = { 8, 400 };

    };
    Button bmp_of_bytes_button
    {
        this, text = "BMP Image of Byte Pattern", font = { "Verdana", 6.85f, bold = true }, size = { 182, 21 }, position = { 8, 376 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            bump bumper {};
            bumper.Modal();

            return true;
        }
    };

    /* End: Turkish Date/Time Functions */
    ProgressBar najitool_main_progress_bar { this, text = "najitool_main_progress_bar", size = { 388, 24 }, position = { 432, 816 } };
    Label help_label { this, text = "Help/Text Output:", size = { 129, 16 }, position = { 200, 344 } };
    Label hex_output_label { this, text = "Hexadecimal Output:", size = { 144, 13 }, position = { 200, 464 } };
    Label decimal_output_label { this, text = "Decimal Output:", size = { 112, 13 }, position = { 200, 584 } };
    Label octal_output_label { this, text = "Octal Output:", size = { 96, 13 }, position = { 200, 688 } };
    Label binary_Output_label { this, text = "Binary Output:", size = { 104, 13 }, position = { 200, 792 } };
    EditBox hex_output_edit_box { this, size = { 702, 114 }, position = { 352, 368 }, hasHorzScroll = true, true, true, true, true, readOnly = true, true, noCaret = true };
    EditBox decimal_output_edit_box { this, size = { 702, 114 }, position = { 352, 488 }, hasHorzScroll = true, true, true, true, true, readOnly = true, true, noCaret = true };
    EditBox octal_output_edit_box { this, size = { 702, 96 }, position = { 352, 608 }, hasHorzScroll = true, true, true, true, true, readOnly = true, true, noCaret = true };
    EditBox binary_output_edit_box { this, size = { 702, 96 }, position = { 352, 712 }, hasHorzScroll = true, true, true, true, true, readOnly = true, true, noCaret = true };
    Button pause_button { this, text = "Pause", size = { 75, 25 }, position = { 824, 816 } };
    Button stop_button { this, text = "Stop", size = { 75, 25 }, position = { 904, 816 } };
    Label najitool_homepage_label
    {
        this, text = "http://najitool.sf.net/", foreground = blue, font = { "Verdana", 8.25f, bold = true, underline = true }, position = { 16, 8 }, cursor = ((GuiApplication)__thisModule).GetCursor(hand);

        bool OnLeftButtonDown(int x, int y, Modifiers mods)
        {

            ShellOpen("http://najitool.sf.net/");

            return Label::OnLeftButtonDown(x, y, mods);
        }
    };
    Label command_label { this, text = "Command:", position = { 8, 320 } };
    Label category_label { this, text = "Category:", position = { 8, 272 } };
    Button credits_button
    {
        this, text = "Credits", size = { 75, 25 }, position = { 120, 184 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            najitool_gui_credits();
            return true;
        }
    };
    Button license_button
    {
        this, text = "License", size = { 75, 25 }, position = { 8, 184 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            najitool_gui_license();

            return true;
        }
    };
    Button close_button
    {
        this, text = "Close", size = { 75, 25 }, position = { 984, 816 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            exit(0);
            return true;
        }
    };
    Button input_file_1_button
    {
        this, text = "Input File 1:", size = { 130, 20 }, position = { 200, 16 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            if (input_file_1_dialog.Modal() == ok)
            {
                strcpy(input_file_1_path, input_file_1_dialog.filePath);
                input_file_1_edit_box.contents = input_file_1_dialog.filePath;
            }

            return true;
        }
    };
    Button input_file_2_button
    {
        this, text = "Input File 2:", size = { 130, 20 }, position = { 200, 40 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            if (input_file_2_dialog.Modal() == ok)
            {
                strcpy(input_file_2_path, input_file_2_dialog.filePath);
                input_file_2_edit_box.contents = input_file_2_dialog.filePath;
            }
            return true;
        }
    };
    Button input_folder_button
    {
        this, text = "Input Folder:", size = { 130, 20 }, position = { 200, 64 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            input_folder_dialog.type=selectDir;

            if (input_folder_dialog.Modal() == ok)
            {
                strcpy(input_folder_path, input_folder_dialog.filePath);
                input_folder_edit_box.contents = input_folder_dialog.filePath;
            }

            return true;
        }
    };
    Button output_file_1_button
    {
        this, text = "Output File 1:", size = { 130, 20 }, position = { 200, 88 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            output_file_1_dialog.type=save;

            if (output_file_1_dialog.Modal() == ok)
            {
                strcpy(output_file_1_path, output_file_1_dialog.filePath);
                output_file_1_edit_box.contents = output_file_1_dialog.filePath;
            }
            return true;
        }
    };
    Button output_file_2_button
    {
        this, text = "Output File 2:", size = { 130, 20 }, position = { 200, 112 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            output_file_2_dialog.type=save;

            if (output_file_2_dialog.Modal() == ok)
            {
                strcpy(output_file_2_path, output_file_2_dialog.filePath);
                output_file_2_edit_box.contents = output_file_2_dialog.filePath;
            }

            return true;
        }
    };
    Button output_folder_button
    {
        this, text = "Output Folder:", size = { 130, 20 }, position = { 200, 136 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            output_folder_dialog.type=selectDir;

            if (output_folder_dialog.Modal() == ok)
            {
                strcpy(output_folder_path, output_folder_dialog.filePath);
                output_folder_edit_box.contents = output_folder_dialog.filePath;
            }

            return true;
        }
    };
    EditBox input_file_1_edit_box
    {
        this, text = "input_file_1_edit_box", size = { 702, 19 }, position = { 352, 16 };

        bool NotifyModified(EditBox editBox)
        {
            strcpy(input_file_1_path, input_file_1_edit_box.contents);

            return true;
        }
    };
    EditBox input_file_2_edit_box
    {
        this, text = "input_file_2_edit_box", size = { 702, 19 }, position = { 352, 40 };

        bool NotifyModified(EditBox editBox)
        {
            strcpy(input_file_2_path, input_file_2_edit_box.contents);

            return true;
        }
    };
    EditBox input_folder_edit_box
    {
        this, text = "input_folder_edit_box", size = { 702, 19 }, position = { 352, 64 };

        bool NotifyModified(EditBox editBox)
        {

            strcpy(input_folder_path, input_folder_edit_box.contents);

            return true;
        }
    };
    EditBox output_file_1_edit_box
    {
        this, text = "output_file_1_edit_box", size = { 702, 19 }, position = { 352, 88 };

        bool NotifyModified(EditBox editBox)
        {

            strcpy(output_file_1_path, output_file_1_edit_box.contents);

            return true;
        }
    };
    EditBox output_file_2_edit_box
    {
        this, text = "output_file_2_edit_box", size = { 702, 19 }, position = { 352, 112 };

        bool NotifyModified(EditBox editBox)
        {

            strcpy(output_file_2_path, output_file_2_edit_box.contents);

            return true;
        }
    };
    EditBox output_folder_edit_box
    {
        this, text = "output_folder_edit_box", size = { 702, 19 }, position = { 352, 136 };

        bool NotifyModified(EditBox editBox)
        {
            strcpy(output_folder_path, output_folder_edit_box.contents);
            return true;
        }
    };
    EditBox parameter_1_edit_box
    {
        this, text = "parameter_1_edit_box", size = { 702, 19 }, position = { 352, 160 };

        bool NotifyModified(EditBox editBox)
        {

            strcpy(parameter_1_string, parameter_1_edit_box.contents);

            return true;
        }
    };
    EditBox parameter_2_edit_box
    {
        this, text = "parameter_2_edit_box", size = { 702, 19 }, position = { 352, 184 };

        bool NotifyModified(EditBox editBox)
        {

            strcpy(parameter_2_string, parameter_2_edit_box.contents);

            return true;
        }
    };
    Label parameter_2_label
    {
        this, text = "Parameter 2:", position = { 224, 184 };

        bool NotifyActivate(Window window, bool active, Window previous)
        {

            return true;
        }
    };
    Label parameter_1_label
    {
        this, text = "Parameter 1:", position = { 224, 160 };

        bool NotifyActivate(Window window, bool active, Window previous)
        {

            return true;
        }
    };

    bool OnCreate(void)
    {
        int i;


        if (!strcmp(najitool_language, ""))
            strcpy(najitool_language, "English");

        category_drop_box.Clear();

        strcpy(najitool_command, "(none)");
        strcpy(najitool_category, "All");

        if (!strcmp(najitool_language, "English"))
        {
            for (i=0; i<NAJITOOL_MAX_CATEGORIES; i++)
                category_row = category_drop_box.AddString(najitool_valid_categories[i]);

            category_drop_box.currentRow = category_row;
        }

        else if (!strcmp(najitool_language, "Turkish"))
        {
            for (i=0; i<NAJITOOL_MAX_CATEGORIES; i++)
                category_row = category_drop_box.AddString(najitool_valid_categories_turkish[i]);

            category_drop_box.currentRow = category_row;
        }

        help_edit_box.contents =
            "Please select a category then a command and enter the required information in the\n"
            "boxes then click the process button. Once you select a command, help for the\n"
            "command will be displayed here.";

        cmd_drop_box.Clear();

        for (i=0; i<NAJITOOL_MAX_COMMANDS; i++)
            cmd_drop_box.AddString(najitool_valid_commands[i]);

        category_drop_box.disabled=false;
        cmd_drop_box.disabled=false;

        return true;
    };
    EditBox help_edit_box
    {
        this, text = "help_edit_box", font = { "Courier New", 8 }, size = { 702, 154 }, position = { 352, 208 }, hasHorzScroll = true, true, true, true, true, readOnly = true, true, noCaret = true;

        bool NotifyModified(EditBox editBox)
        {

            return true;
        }
    };
    Button process_button
    {
        this, text = "Process", size = { 75, 25 }, position = { 352, 816 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            if (!strcmp(najitool_command, "(none)"))
            {
                if (!strcmp(najitool_language, "English"))
                    msgbox("najitool GUI", "Please select a command.");

                else if (!strcmp(najitool_language, "Turkish"))
                    msgbox("najitool GUI", "Lutfen bir komut secin.");

                return true;
            }

            else if (!strcmp(najitool_command, "8bit256"))
                _8bit256(output_file_1_path, atoi(parameter_1_string));

            else if (!strcmp(najitool_command, "addim"))
                addim(atoi(parameter_1_string), output_file_1_path);

            else if (!strcmp(najitool_command, "allfiles"))
                allfiles(atoi(parameter_1_string), output_folder_path);

            else if (!strcmp(najitool_command, "allbmp16"))
                allbmp16(output_folder_path);

            else if (!strcmp(najitool_command, "arab2eng"))
                arab2eng(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "asc2ebc"))
                asc2ebc(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "asctable"))
                asctable(output_file_1_path);

            else if (!strcmp(najitool_command, "ay"))
                ay();

            else if (!strcmp(najitool_command, "ayinkaci"))
                ayinkaci();

            else if (!strcmp(najitool_command, "bigascif"))
                bigascif(parameter_1_string, output_file_1_path);

            else if (!strcmp(najitool_command, "bigascii"))
                bigascii(parameter_1_string);

            else if (!strcmp(najitool_command, "bin2c"))
                bin2c(input_file_1_path, output_file_1_path, parameter_1_string);

            else if (!strcmp(najitool_command, "bin2hexi"))
                bin2hexi(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "bin2text"))
                bin2text(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "blanka"))
                blanka(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "bremline"))
                bremline(parameter_1_string, input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "bugun"))
                bugun();

            else if (!strcmp(najitool_command, "calc"))
            {
                najicalc naji_calc {};
                naji_calc.Modal();
                return true;
            }

            else if (!strcmp(najitool_command, "cat_head"))
                cat_head(input_file_1_path, atoi(parameter_1_string));

            else if (!strcmp(najitool_command, "cat_tail"))
                cat_tail(input_file_1_path, atoi(parameter_1_string));

            else if (!strcmp(najitool_command, "cat_text"))
                cat_text(input_file_1_path);

            else if (!strcmp(najitool_command, "catrandl"))
                catrandl(input_file_1_path);

            else if (!strcmp(najitool_command, "ccompare"))
                ccompare(input_file_1_path, input_file_2_path);

            else if (!strcmp(najitool_command, "cfind"))
                cfind(input_file_1_path, parameter_1_string);

            else if (!strcmp(najitool_command, "cfindi"))
                cfindi(input_file_1_path, parameter_1_string);

            else if (!strcmp(najitool_command, "charaftr"))
                charaftr(input_file_1_path, output_file_1_path, parameter_1_string[0]);

            else if (!strcmp(najitool_command, "charbefr"))
                charbefr(input_file_1_path, output_file_1_path, parameter_1_string[0]);

            else if (!strcmp(najitool_command, "charfile"))
                charfile(output_file_1_path, atoi(parameter_2_string), parameter_1_string[0]);

            else if (!strcmp(najitool_command, "charsort"))
                charsort(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "charwrap"))
                charwrap(atoi(parameter_1_string), input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "chchar"))
                chchar(input_file_1_path, output_file_1_path, parameter_1_string[0], parameter_2_string[0]);

            else if (!strcmp(najitool_command, "chchars"))
                chchars(input_file_1_path, output_file_1_path, parameter_1_string, parameter_2_string);

            else if (!strcmp(najitool_command, "chstr"))
                chstr(input_file_1_path, output_file_1_path, parameter_1_string, parameter_2_string);

            else if (!strcmp(najitool_command, "coffset"))
                coffset(input_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string));

            else if (!strcmp(najitool_command, "compare"))
                compare(input_file_1_path, input_file_2_path);

            else if (!strcmp(najitool_command, "copyfile"))
                copyfile(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "copyoffs"))
                copyoffs(input_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string), output_file_1_path);

            else if (!strcmp(najitool_command, "copyself"))
            {
                LocateModule(null, copyself_path);
                copyfile(copyself_path, output_file_1_path);
            }

            else if (!strcmp(najitool_command, "cpfroml"))
                cpfroml(atol(parameter_1_string), input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "cptiline"))
                cptiline(atol(parameter_1_string), input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "credits"))
                najitool_gui_credits();

            else if (!strcmp(najitool_command, "database"))
                tabdatabase.SelectTab();

            else if (!strcmp(najitool_command, "datetime"))
                datetime();

            else if (!strcmp(najitool_command, "dayofmon"))
                dayofmon();

            else if (!strcmp(najitool_command, "dos2unix"))
                dos2unix(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "downlist"))
                downlist(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "dumpoffs"))
                dumpoffs(input_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string));

            else if (!strcmp(najitool_command, "e2ahtml"))
                e2ahtml(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "ebc2asc"))
                ebc2asc(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "eng2arab"))
                eng2arab(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "engnum"))
                engnum(output_file_1_path);

            else if (!strcmp(najitool_command, "eremline"))
                eremline(parameter_1_string, input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "f2lower"))
                f2lower(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "f2upper"))
                f2upper(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "filebreed"))
                filbreed(input_file_1_path, input_file_2_path, output_file_1_path);

            else if (!strcmp(najitool_command, "file2bin"))
                file2bin(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "file2dec"))
                file2dec(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "file2hex"))
                file2hex(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "file2oct"))
                file2oct(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "filechop"))
                filechop(atoi(parameter_1_string), input_file_1_path, output_file_1_path, output_file_2_path);

            else if (!strcmp(najitool_command, "filejoin"))
                filejoin(input_file_1_path, input_file_2_path, output_file_1_path);

            else if (!strcmp(najitool_command, "fillfile"))
            {
                sprintf(temp_edit_delete, "Are you sure you want to continue? this will overwrite ALL the characters in the file:\n%s\n\nWith the character %c and the old data WILL NOT be recoverable.\n", output_file_1_path, parameter_1_string[0]);

                if (msgboxyesno("najitool GUI fillfile confirmation", temp_edit_delete) == yes)
                    fillfile(output_file_1_path, parameter_1_string[0]);

            }

            else if (!strcmp(najitool_command, "find"))
                find(input_file_1_path, parameter_1_string);

            else if (!strcmp(najitool_command, "findi"))
                findi(input_file_1_path, parameter_1_string);

            else if (!strcmp(najitool_command, "flipcopy"))
                flipcopy(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "freverse"))
                freverse(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "fswpcase"))
                fswpcase(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "ftothe"))
                ftothe(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "genhelp"))
                najitool_gui_genhelp(output_file_1_path);

            else if (!strcmp(najitool_command, "genlic"))
                naji_genlic(output_file_1_path);

            else if (!strcmp(najitool_command, "getlinks"))
                getlinks(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "gdivide"))
                gdivide(output_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string));

            else if (!strcmp(najitool_command, "gigabyte"))
                gigabyte(atoi(parameter_1_string));

            else if (!strcmp(najitool_command, "gminus"))
                gminus(output_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string));

            else if (!strcmp(najitool_command, "gplus"))
                gplus(output_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string));

            else if (!strcmp(najitool_command, "gtimes"))
                gminus(output_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string));

            // help

            else if (!strcmp(najitool_command, "hexicat"))
                hexicat(input_file_1_path);

            else if (!strcmp(najitool_command, "hilist"))
                hilist(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "hmaker"))
                hmaker(input_file_1_path);

            else if (!strcmp(najitool_command, "hmakerf"))
                hmakerf(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "html_db"))
            {
                naji_db_html_selected = true;
                tabdatabase.SelectTab();
            }

            else if (!strcmp(najitool_command, "html2txt"))
                html2txt(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "htmlfast"))
                htmlfast(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "htmlhelp"))
                najitool_gui_generate_htmlhelp(output_file_1_path);

            else if (!strcmp(najitool_command, "kitten"))
                kitten(input_file_1_path);

            else if (!strcmp(najitool_command, "lcharvar"))
                lcharvar(parameter_1_string);

            else if (!strcmp(najitool_command, "lcvfiles"))
                lcvfiles(input_file_1_path, output_folder_path);

            else if (!strcmp(najitool_command, "leetfile"))
                leetfile(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "leetstr"))
                leetstr(parameter_1_string);

            else if (!strcmp(najitool_command, "length"))
                tablength.SelectTab();

            else if (!strcmp(najitool_command, "lensortl"))
                lensortl(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "lensorts"))
                lensorts(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "license"))
                najitool_gui_license();

            else if (!strcmp(najitool_command, "linesnip"))
                linesnip(atoi(parameter_1_string), input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "makarray"))
                makarray(input_file_1_path, output_file_1_path, parameter_1_string);

            else if (!strcmp(najitool_command, "mathgame"))
                tabmathgame.SelectTab();

            else if (!strcmp(najitool_command, "maxxnewl"))
                maxxnewl(input_file_1_path, output_file_1_path, atoi(parameter_1_string));

            else if (!strcmp(najitool_command, "mergline"))
                mergline(input_file_1_path, input_file_2_path, output_file_1_path, parameter_1_string, parameter_2_string);

            else if (!strcmp(najitool_command, "mkpatch"))
                mkpatch(input_file_1_path, input_file_2_path, output_file_1_path);

            else if (!strcmp(najitool_command, "month"))
                month();

            else if (!strcmp(najitool_command, "mp3split"))
                mp3split(input_file_1_path, output_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string));

            else if (!strcmp(najitool_command, "mp3taged"))
            {
                if (!strcmp(najitool_language, "English"))
                    msgbox("najitool GUI mp3taged information", "Sorry the mp3 tag editor is not implemented in this version because it has bugs which need to be fixed first.");

                else if (!strcmp(najitool_language, "Turkish"))
                    msgbox("najitool GUI mp3taged bilgi", "Maalesef mp3 tag editoru bu verisyon icinde uygulanmadi cunku oncelikle duzeltilmesi gereken hatalar var.");
            }

            else if (!strcmp(najitool_command, "mp3tagnf"))
                mp3info_gui(input_file_1_path);

            else if (!strcmp(najitool_command, "n2ch"))
                n2ch(parameter_1_string[0], input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "n2str"))
                n2str(parameter_1_string, input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "najcrypt"))
                tabcrypt.SelectTab();

            else if (!strcmp(najitool_command, "naji_bmp"))
                naji_bmp(output_folder_path);

            else if (!strcmp(najitool_command, "najirle"))
                najirle(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "najisum"))
                najisum(input_file_1_path);

            else if (!strcmp(najitool_command, "numlines"))
                numlines(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "onlalnum"))
                onlalnum(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "onlalpha"))
                onlalpha(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "onlcntrl"))
                onlcntrl(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "onldigit"))
                onldigit(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "onlgraph"))
                onlgraph(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "onllower"))
                onllower(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "onlprint"))
                onlprint(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "onlpunct"))
                onlpunct(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "onlspace"))
                onlspace(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "onlupper"))
                onlupper(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "onlxdigt"))
                onlxdigt(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "onlycat"))
                onlycat(input_file_1_path, parameter_1_string);

            else if (!strcmp(najitool_command, "onlychar"))
                onlychar(input_file_1_path, output_file_1_path, parameter_1_string);

            else if (!strcmp(najitool_command, "patch"))
                tabpatch.SelectTab();

            else if (!strcmp(najitool_command, "printftx"))
                printftx(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "putlines"))
                putlines(input_file_1_path, output_file_1_path, parameter_1_string, parameter_2_string);

            else if (!strcmp(najitool_command, "qcrypt"))
                qcrypt(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "qpatch"))
                qpatch(output_file_1_path, input_file_1_path);

            else if (!strcmp(najitool_command, "randkill"))
            {
                sprintf(temp_edit_delete, "Are you sure you want to unrecoverabley delete the file:\n%s", output_file_1_path);

                if (msgboxyesno("najitool GUI randkill confirmation", temp_edit_delete) == yes)
                {
                    randkill(output_file_1_path);
                }
            }

            else if (!strcmp(najitool_command, "rbcafter"))
                rbcafter(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "rbcbefor"))
                rbcbefor(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "rcharvar"))
                rcharvar(parameter_1_string);

            else if (!strcmp(najitool_command, "rcvfiles"))
                rcvfiles(input_file_1_path, output_folder_path);

            else if (!strcmp(najitool_command, "remline"))
                remline(parameter_1_string, input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "repcat"))
                repcat(input_file_1_path, atoi(parameter_1_string));

            else if (!strcmp(najitool_command, "repcatpp"))
                repcatpp(input_file_1_path, atoi(parameter_1_string));

            else if (!strcmp(najitool_command, "repchar"))
                repchar(input_file_1_path, output_file_1_path, atoi(parameter_1_string));

            else if (!strcmp(najitool_command, "repcharp"))
                repcharp(input_file_1_path, output_file_1_path, atoi(parameter_1_string));

            else if (!strcmp(najitool_command, "revcat"))
                revcat(input_file_1_path);

            else if (!strcmp(najitool_command, "revlines"))
                revlines(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "rmunihtm"))
                naji_del_gen_unicode_html_pages(output_folder_path);

            else if (!strcmp(najitool_command, "rndbfile"))
                rndbfile(input_file_1_path, atol(parameter_1_string));

            else if (!strcmp(najitool_command, "rndbsout"))
                rndbsout(atol(parameter_1_string));

            else if (!strcmp(najitool_command, "rndffill"))
            {
                sprintf(temp_edit_delete, "Are you sure you want to continue? this will overwrite ALL the characters in the file:\n%s\n\nWith random characters and the old data WILL NOT be recoverable.\n", output_file_1_path);

                if (msgboxyesno("najitool GUI rndffill confirmation", temp_edit_delete) == yes)
                    rndffill(output_file_1_path);

            }

            else if (!strcmp(najitool_command, "rndtfile"))
                rndtfile(input_file_1_path, atol(parameter_1_string));

            else if (!strcmp(najitool_command, "rndtsout"))
                rndtsout(atol(parameter_1_string));

            else if (!strcmp(najitool_command, "rrrchars"))
                rrrchars(input_file_1_path, output_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string));

            else if (!strcmp(najitool_command, "rstrach"))
                rstrach(atoi(parameter_1_string), input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "rstrbch"))
                rstrbch(atoi(parameter_1_string), input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "rtcafter"))
                rtcafter(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "rtcbefor"))
                rtcbefor(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "saat"))
                saat();

            else if (!strcmp(najitool_command, "saatarih"))
                saatarih();

            else if (!strcmp(najitool_command, "showline"))
                showline(input_file_1_path, atoi(parameter_1_string));

            else if (!strcmp(najitool_command, "skipcat"))
                skipcat(input_file_1_path, parameter_1_string);

            else if (!strcmp(najitool_command, "skipchar"))
                skipchar(input_file_1_path, output_file_1_path, parameter_1_string);

            else if (!strcmp(najitool_command, "skipstr"))
                skipstr(input_file_1_path, output_file_1_path, parameter_1_string);

            else if (!strcmp(najitool_command, "skpalnum"))
                skpalnum(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "skpalpha"))
                skpalpha(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "skpcntrl"))
                skpcntrl(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "skpdigit"))
                skpdigit(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "skpgraph"))
                skpgraph(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "skplower"))
                skplower(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "skpprint"))
                skpprint(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "skppunct"))
                skppunct(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "skpspace"))
                skpspace(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "skpupper"))
                skpupper(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "skpxdigt"))
                skpxdigt(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "strachar"))
                strachar(parameter_1_string, input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "strbchar"))
                strbchar(parameter_1_string, input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "strbline"))
                strbline(input_file_1_path, output_file_1_path, parameter_1_string);

            else if (!strcmp(najitool_command, "streline"))
                streline(input_file_1_path, output_file_1_path, parameter_1_string);

            else if (!strcmp(najitool_command, "strfile"))
                strfile(output_file_1_path, atoi(parameter_1_string), parameter_2_string);

            else if (!strcmp(najitool_command, "swapfeb"))
                swapfeb(input_file_1_path, input_file_2_path, output_file_1_path);

            else if (!strcmp(najitool_command, "systemdt"))
                systemdt();

            else if (!strcmp(najitool_command, "tabspace"))
                tabspace(atoi(parameter_1_string), input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "telltime"))
                telltime();

            else if (!strcmp(najitool_command, "today"))
                today();

            else if (!strcmp(najitool_command, "tothe"))
                tothe(parameter_1_string);

            else if (!strcmp(najitool_command, "ttt"))
            {
                ttt ttt_game {};
                ttt_game.Modal();
                return true;
            }

            else if (!strcmp(najitool_command, "turnum"))
                turnum(output_file_1_path);

            else if (!strcmp(najitool_command, "txt2html"))
                txt2html(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "unihtml"))
                naji_gen_unicode_html_pages(output_folder_path);

            else if (!strcmp(najitool_command, "unajirle"))
                unajirle(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "unblanka"))
                unblanka(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "unix2dos"))
                unix2dos(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "uudecode"))
                uudecode(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "uuencode"))
                uuencode(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "vowelwrd"))
            {
                help_edit_box.Clear();
                vowelwrd(parameter_1_string);
            }

            else if (!strcmp(najitool_command, "wordline"))
                wordline(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "wordwrap"))
                wordwrap(input_file_1_path, output_file_1_path);

            else if (!strcmp(najitool_command, "wrdcount"))
            {
                help_edit_box.Clear();
                help_edit_box.Printf("%u", wrdcount(input_file_1_path));
            }

            else if (!strcmp(najitool_command, "year"))
                year();

            else if (!strcmp(najitool_command, "yil"))
                yil();

            else if (!strcmp(najitool_command, "zerokill"))
            {
                sprintf(temp_edit_delete, "Are you sure you want to unrecoverabley delete the file:\n%s", output_file_1_path);

                if (msgboxyesno("najitool GUI zerokill confirmation", temp_edit_delete) == yes)
                    zerokill(output_file_1_path);

            }

            remove(".najiout.hex");
            remove(".najiout.dec");
            remove(".najiout.oct");
            remove(".najiout.bin");
            remove(".najiout.bmp");

            file2hex(output_file_1_path, ".najiout.hex");
            file2dec(output_file_1_path, ".najiout.dec");
            file2oct(output_file_1_path, ".najiout.oct");
            file2bin(output_file_1_path, ".najiout.bin");
            file2bmp(output_file_1_path, ".najiout.bmp");

            najimainfile = FileOpen(".najiout.hex", read);
            if (najimainfile != null)
                hex_output_edit_box.Load(najimainfile);
            delete najimainfile;

            najimainfile = FileOpen(".najiout.dec", read);
            if (najimainfile != null)
                decimal_output_edit_box.Load(najimainfile);
            delete najimainfile;

            najimainfile = FileOpen(".najiout.oct", read);
            if (najimainfile != null)
                octal_output_edit_box.Load(najimainfile);
            delete najimainfile;

            najimainfile = FileOpen(".najiout.bin", read);
            if (najimainfile != null)
                binary_output_edit_box.Load(najimainfile);
            delete najimainfile;

            if (!strcmp(najitool_language, "English"))
                sprintf(msgbox_buffer, "%s", "Processing complete.");

            else if (!strcmp(najitool_language, "Turkish"))
                sprintf(msgbox_buffer, "%s", "Islem tamamlandi.");

            msgbox("najitool GUI", msgbox_buffer);

            return true;
        } // end of notify clicked
    } // end of process button
    DropBox category_drop_box
    {
        this, text = "category_drop_box", size = { 184, 24 }, position = { 8, 288 };

        bool NotifySelect(DropBox dropBox, DataRow row, Modifiers mods)
        {

            if (row)
            {

                strcpy(najitool_category, row.string);

                if (! strcmp(najitool_category, "All") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_COMMANDS; i++)
                        cmd_drop_box.AddString(najitool_valid_commands[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Games") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_GAMES; i++)
                        cmd_drop_box.AddString(najitool_valid_games[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Programming") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_PROGRAMMING; i++)
                        cmd_drop_box.AddString(najitool_valid_programming[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Date/Time") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_DATE_TIME; i++)
                        cmd_drop_box.AddString(najitool_valid_date_time[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Encryption") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_ENCRYPTION; i++)
                        cmd_drop_box.AddString(najitool_valid_encryption[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Generate") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_GENERATE; i++)
                        cmd_drop_box.AddString(najitool_valid_generate[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Filter") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_FILTER; i++)
                        cmd_drop_box.AddString(najitool_valid_filter[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Format") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_FORMAT; i++)
                        cmd_drop_box.AddString(najitool_valid_format[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Status") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_STATUS; i++)
                        cmd_drop_box.AddString(najitool_valid_status[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Convert") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_CONVERT; i++)
                        cmd_drop_box.AddString(najitool_valid_convert[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Images") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_IMAGES; i++)
                        cmd_drop_box.AddString(najitool_valid_images[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Edit") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_EDIT; i++)
                        cmd_drop_box.AddString(najitool_valid_edit[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Web") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_WEB; i++)
                        cmd_drop_box.AddString(najitool_valid_web[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Audio") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_AUDIO; i++)
                        cmd_drop_box.AddString(najitool_valid_audio[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Misc") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_MISC; i++)
                        cmd_drop_box.AddString(najitool_valid_misc[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Compression") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_COMPRESSION; i++)
                        cmd_drop_box.AddString(najitool_valid_compression[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Tum") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_COMMANDS; i++)
                        cmd_drop_box.AddString(najitool_valid_commands[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Oyunlar") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_GAMES; i++)
                        cmd_drop_box.AddString(najitool_valid_games[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Programlama") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_PROGRAMMING; i++)
                        cmd_drop_box.AddString(najitool_valid_programming[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Tarih/Saat") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_DATE_TIME; i++)
                        cmd_drop_box.AddString(najitool_valid_date_time[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Sifreleme") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_ENCRYPTION; i++)
                        cmd_drop_box.AddString(najitool_valid_encryption[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Olusturma") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_GENERATE; i++)
                        cmd_drop_box.AddString(najitool_valid_generate[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Filtreleme") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_FILTER; i++)
                        cmd_drop_box.AddString(najitool_valid_filter[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Duzenleme") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_FORMAT; i++)
                        cmd_drop_box.AddString(najitool_valid_format[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Durum") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_STATUS; i++)
                        cmd_drop_box.AddString(najitool_valid_status[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Donusme") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_CONVERT; i++)
                        cmd_drop_box.AddString(najitool_valid_convert[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Resimler") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_IMAGES; i++)
                        cmd_drop_box.AddString(najitool_valid_images[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Deyistirme") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_EDIT; i++)
                        cmd_drop_box.AddString(najitool_valid_edit[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "HTML") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_WEB; i++)
                        cmd_drop_box.AddString(najitool_valid_web[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Sesler") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_AUDIO; i++)
                        cmd_drop_box.AddString(najitool_valid_audio[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Cesitli") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_MISC; i++)
                        cmd_drop_box.AddString(najitool_valid_misc[i]);

                    return true;
                }

                if (! strcmp(najitool_category, "Kompresyon") )
                {
                    int i;

                    cmd_drop_box.Clear();

                    for (i=0; i<NAJITOOL_MAX_COMPRESSION; i++)
                        cmd_drop_box.AddString(najitool_valid_compression[i]);

                    return true;
                }

            }

            return true;
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
    Label language_label { this, text = "Language:", position = { 8, 224 } };
    FlagCollection flags { this };
    SavingDataBox language_drop_box
    {
        this, text = "language_drop_box", size = { 184, 24 }, position = { 8, 240 }, data = &lang, type = class(najitool_languages), fieldData = flags;;;

        bool NotifyChanged(bool closingDropDown)
        {
            int i;
            strcpy(najitool_language, languages_string_array[lang]);

            if (! strcmp(najitool_language, "Turkish") )
            {

                input_file_1_dialog.text  = "Okunan Dosya Sec...";
                input_file_2_dialog.text  = "Okunan Dosya 2 Sec...";
                input_folder_dialog.text  = "Okunan Klasor Sec...";
                output_file_1_dialog.text = "Yazilan Dosyayi Belirt...";
                output_file_2_dialog.text = "Yazilan Dosya 2 yi Belirt...";
                output_folder_dialog.text = "Yazilan Klasor Sec...";
                naji_db_append_file_dialog.text = "Bir dosya secin veritabani kayitlari eklenmesi icin veya yeni dosya isim yaz...";
                patch_load_file_dialog.text = "Bir dosya sec acmak icin...";
                patch_save_as_hex_dialog.text = "Farkli Kaydet Onaltilik Dosya olarak...";
                patch_save_as_dialog.text = "Farkli Kaydet...";

                tabmain.text="Bas";
                tabcrypt.text="Sifrele";
                tablength.text="Uzunluk";
                tabsplit.text="Bolmek";
                tabdatabase.text="Veritabani";
                tabmathgame.text="MataOyun";
                tabpatch.text="Yama";

                help_label.text = "Bilgi:";
                language_label.text = "Dil:";
                category_label.text = "Kategori:";
                command_label.text = "Komut:";
                parameter_1_label.text = "Parametre 1:";
                parameter_2_label.text = "Parametre 2:";

                process_button.text = "Isle";
                credits_button.text = "Krediler";
                license_button.text = "Lisans";
                close_button.text = "Kapat";

                input_file_1_button.text="Okunan Dosya 1:";
                input_file_2_button.text="Okunan Dosya 2:";
                input_folder_button.text="Okunan Klasor:";

                output_file_1_button.text="Yazilan Dosya 1:";
                output_file_2_button.text="Yazilan Dosya 2:";
                output_folder_button.text="Yazilan Klasor:";

                help_edit_box.contents =
                    "Lutfen bir kategori secin sonra bir komut secin ve gereken bilgileri\n"
                    "kutularin icine verin sonra isle duymesine tiklayin. Komut sectikden sonra,\n"
                    "komut icin yardim burda gosterilcek.";

                category_drop_box.Clear();

                for (i=0; i<NAJITOOL_MAX_CATEGORIES; i++)
                    category_row = category_drop_box.AddString(najitool_valid_categories_turkish[i]);

                category_drop_box.currentRow = category_row;

                return true;
            }

            if (! strcmp(najitool_language, "English") )
            {

                input_file_1_dialog.text  = "Select Input File...";
                input_file_2_dialog.text  = "Select Input File 2...";
                input_folder_dialog.text  = "Select Input Folder/Directory...";
                output_file_1_dialog.text = "Specify Output File...";
                output_file_2_dialog.text = "Specify Output File 2...";
                output_folder_dialog.text = "Select Output Folder/Directory...";
                naji_db_append_file_dialog.text = "Select file to append database entries to or type a new name...";

                patch_load_file_dialog.text = "Select file to load...";
                patch_save_as_hex_dialog.text = "Save As Hexadecimal file...";
                patch_save_as_dialog.text = "Save As...";

                tabmain.text="Main";
                tabcrypt.text="Crypt";
                tablength.text="Length";
                tabsplit.text="Split";
                tabdatabase.text="Database";
                tabmathgame.text="MathGM";
                tabpatch.text="Patch";

                help_label.text = "Help/Output:";
                language_label.text = "Language:";
                category_label.text = "Category:";
                command_label.text = "Command:";
                parameter_1_label.text = "Parameter 1:";
                parameter_2_label.text = "Parameter 2:";

                process_button.text = "Process";
                credits_button.text = "Credits";
                license_button.text = "License";
                close_button.text = "Close";

                input_file_1_button.text="Input File 1:";
                input_file_2_button.text="Input File 2:";
                input_folder_button.text="Input Folder:";

                output_file_1_button.text="Output File 1:";
                output_file_2_button.text="Output File 2:";
                output_folder_button.text="Output Folder:";

                help_edit_box.contents =
                    "Please select a category then a command and enter the required information in the\n"
                    "boxes then click the process button. Once you select a command, help for the\n"
                    "command will be displayed here.";

                category_drop_box.Clear();

                for (i=0; i<NAJITOOL_MAX_CATEGORIES; i++)
                    category_row = category_drop_box.AddString(najitool_valid_categories[i]);

                category_drop_box.currentRow = category_row;

                return true;
            }

            return true;
        }
    };
    DropBox cmd_drop_box
    {
        this, text = "cmd_drop_box", size = { 184, 24 }, position = { 8, 336 };

        bool NotifyHighlight(DropBox dropBox, DataRow row, Modifiers mods)
        {
            if (row)
            {

                int i;

                strcpy(najitool_command, row.string);

                for (i=0; i<NAJITOOL_MAX_COMMANDS; i++)
                    if (! strcmp(najitool_command, najitool_valid_commands[i]) )
                    {
                        input_file_1_edit_box.disabled=helpitems[i].input_file_1_edit_box_disabled;
                        input_file_1_button.disabled=helpitems[i].input_file_1_button_disabled;

                        input_file_2_edit_box.disabled=helpitems[i].input_file_2_edit_box_disabled;
                        input_file_2_button.disabled=helpitems[i].input_file_2_button_disabled;

                        input_folder_edit_box.disabled=helpitems[i].input_folder_edit_box_disabled;
                        input_folder_button.disabled=helpitems[i].input_folder_button_disabled;

                        output_file_1_edit_box.disabled=helpitems[i].output_file_1_edit_box_disabled;
                        output_file_1_button.disabled=helpitems[i].output_file_1_button_disabled;

                        output_file_2_edit_box.disabled=helpitems[i].output_file_2_edit_box_disabled;
                        output_file_2_button.disabled=helpitems[i].output_file_2_button_disabled;

                        output_folder_edit_box.disabled=helpitems[i].output_folder_edit_box_disabled;
                        output_folder_button.disabled=helpitems[i].output_folder_button_disabled;

                        parameter_1_label.disabled=helpitems[i].parameter_1_label_disabled;
                        parameter_1_edit_box.disabled=helpitems[i].parameter_1_edit_box_disabled;

                        parameter_2_label.disabled=helpitems[i].parameter_2_label_disabled;
                        parameter_2_edit_box.disabled=helpitems[i].parameter_2_edit_box_disabled;

                        if (! strcmp(najitool_language, "English") )
                        {
                            help_edit_box.Clear();
                            help_edit_box.Printf("%s:\n%s", helpitems[i].cmd, helpitems[i].help_en);

                            parameter_1_label.text = helpitems[i].param_1_en;
                            parameter_2_label.text = helpitems[i].param_2_en;

                        }
                        else if (! strcmp(najitool_language, "Turkish") )
                        {
                            help_edit_box.Clear();
                            help_edit_box.Printf("%s:\n%s", helpitems[i].cmd, helpitems[i].help_tr);

                            parameter_1_label.text = helpitems[i].param_1_tr;
                            parameter_2_label.text = helpitems[i].param_2_tr;

                        }

                        return true;
                    }

            }

            return true;
        }
    };

    void bigascii_naji_(int a)
    {
        if (a == 0) help_edit_box.Printf("           ");
        if (a == 1) help_edit_box.Printf("           ");
        if (a == 2) help_edit_box.Printf("           ");
        if (a == 3) help_edit_box.Printf("           ");
        if (a == 4) help_edit_box.Printf("           ");
        if (a == 5) help_edit_box.Printf("           ");
    }

    void bigascii_naji_a(int a)
    {
        if (a == 0) help_edit_box.Printf("    ____    ");
        if (a == 1) help_edit_box.Printf("   / __ \\   ");
        if (a == 2) help_edit_box.Printf("  | |  | |  ");
        if (a == 3) help_edit_box.Printf("  | |__| |  ");
        if (a == 4) help_edit_box.Printf("  |  __  |  ");
        if (a == 5) help_edit_box.Printf("  |_|  |_|  ");
    }

    void bigascii_naji_b(int a)
    {
        if (a == 0) help_edit_box.Printf("   _____   ");
        if (a == 1) help_edit_box.Printf("  |  _  |  ");
        if (a == 2) help_edit_box.Printf("  | |_| /  ");
        if (a == 3) help_edit_box.Printf("  |  _  \\  ");
        if (a == 4) help_edit_box.Printf("  | |_| |  ");
        if (a == 5) help_edit_box.Printf("  |_____|  ");
    }

    void bigascii_naji_c(int a)
    {
        if (a == 0) help_edit_box.Printf("   _____   ");
        if (a == 1) help_edit_box.Printf("  |  ___|  ");
        if (a == 2) help_edit_box.Printf("  | |      ");
        if (a == 3) help_edit_box.Printf("  | |      ");
        if (a == 4) help_edit_box.Printf("  | |___   ");
        if (a == 5) help_edit_box.Printf("  |_____|  ");
    }

    void bigascii_naji_d(int a)
    {
        if (a == 0) help_edit_box.Printf("   ____     ");
        if (a == 1) help_edit_box.Printf("  |     \\   ");
        if (a == 2) help_edit_box.Printf("  | |~\\  |  ");
        if (a == 3) help_edit_box.Printf("  | |  | |  ");
        if (a == 4) help_edit_box.Printf("  | |_/  |  ");
        if (a == 5) help_edit_box.Printf("  |_____/   ");
        return;
    }

    void bigascii_naji_e(int a)
    {
        if (a == 0) help_edit_box.Printf("   _____   ");
        if (a == 1) help_edit_box.Printf("  |  ___|  ");
        if (a == 2) help_edit_box.Printf("  | |___   ");
        if (a == 3) help_edit_box.Printf("  |  ___|  ");
        if (a == 4) help_edit_box.Printf("  | |___   ");
        if (a == 5) help_edit_box.Printf("  |_____|  ");
    }

    void bigascii_naji_f(int a)
    {
        if (a == 0) help_edit_box.Printf("   _____   ");
        if (a == 1) help_edit_box.Printf("  |   __|  ");
        if (a == 2) help_edit_box.Printf("  |  |__   ");
        if (a == 3) help_edit_box.Printf("  |   __|  ");
        if (a == 4) help_edit_box.Printf("  |  |     ");
        if (a == 5) help_edit_box.Printf("  |__|     ");
    }

    void bigascii_naji_g(int a)
    {
        if (a == 0) help_edit_box.Printf("   ______   ");
        if (a == 1) help_edit_box.Printf("  /  __  \\  ");
        if (a == 2) help_edit_box.Printf("  | |  |_|  ");
        if (a == 3) help_edit_box.Printf("  | |  __   ");
        if (a == 4) help_edit_box.Printf("  | |__\\ |  ");
        if (a == 5) help_edit_box.Printf("  |_____/   ");
    }

    void bigascii_naji_h(int a)
    {
        if (a == 0) help_edit_box.Printf("   _    _   ");
        if (a == 1) help_edit_box.Printf("  | |  | |  ");
        if (a == 2) help_edit_box.Printf("  | |__| |  ");
        if (a == 3) help_edit_box.Printf("  |  __  |  ");
        if (a == 4) help_edit_box.Printf("  | |  | |  ");
        if (a == 5) help_edit_box.Printf("  |_|  |_|  ");
    }

    void bigascii_naji_i(int a)
    {
        if (a == 0) help_edit_box.Printf("     __     ");
        if (a == 1) help_edit_box.Printf("    |  |    ");
        if (a == 2) help_edit_box.Printf("    |  |    ");
        if (a == 3) help_edit_box.Printf("    |  |    ");
        if (a == 4) help_edit_box.Printf("    |  |    ");
        if (a == 5) help_edit_box.Printf("    |__|    ");
    }

    void bigascii_naji_j(int a)
    {
        if (a == 0) help_edit_box.Printf("       __   ");
        if (a == 1) help_edit_box.Printf("      |  |  ");
        if (a == 2) help_edit_box.Printf("      |  |  ");
        if (a == 3) help_edit_box.Printf("  ___ |  |  ");
        if (a == 4) help_edit_box.Printf("  | |_|  |  ");
        if (a == 5) help_edit_box.Printf("  \\______|  ");
    }

    void bigascii_naji_k(int a)
    {
        if (a == 0) help_edit_box.Printf("   __  ___  ");
        if (a == 1) help_edit_box.Printf("  |  |/  /  ");
        if (a == 2) help_edit_box.Printf("  |    _/   ");
        if (a == 3) help_edit_box.Printf("  |   /__   ");
        if (a == 4) help_edit_box.Printf("  |   _  \\  ");
        if (a == 5) help_edit_box.Printf("  |__| \\__\\ ");
    }

    void bigascii_naji_l(int a)
    {
        if (a == 0) help_edit_box.Printf("    __       ");
        if (a == 1) help_edit_box.Printf("   |  |      ");
        if (a == 2) help_edit_box.Printf("   |  |      ");
        if (a == 3) help_edit_box.Printf("   |  |      ");
        if (a == 4) help_edit_box.Printf("   |  |___   ");
        if (a == 5) help_edit_box.Printf("   |______|  ");
    }

    void bigascii_naji_m(int a)
    {
        if (a == 0) help_edit_box.Printf("  _      _  ");
        if (a == 1) help_edit_box.Printf(" | \\    / | ");
        if (a == 2) help_edit_box.Printf(" |  \\__/  | ");
        if (a == 3) help_edit_box.Printf(" |        | ");
        if (a == 4) help_edit_box.Printf(" |  /\\/\\  | ");
        if (a == 5) help_edit_box.Printf(" |_|    |_| ");
    }

    void bigascii_naji_n(int a)
    {
        if (a == 0) help_edit_box.Printf("   _    _   ");
        if (a == 1) help_edit_box.Printf("  | \\  | |  ");
        if (a == 2) help_edit_box.Printf("  |  \\_| |  ");
        if (a == 3) help_edit_box.Printf("  |      |  ");
        if (a == 4) help_edit_box.Printf("  | |\\   |  ");
        if (a == 5) help_edit_box.Printf("  |_| \\__|  ");
    }

    void bigascii_naji_o(int a)
    {
        if (a == 0) help_edit_box.Printf("   ______   ");
        if (a == 1) help_edit_box.Printf("  |      |  ");
        if (a == 2) help_edit_box.Printf("  | |~~| |  ");
        if (a == 3) help_edit_box.Printf("  | |  | |  ");
        if (a == 4) help_edit_box.Printf("  | |__| |  ");
        if (a == 5) help_edit_box.Printf("  |______|  ");
    }

    void bigascii_naji_p(int a)
    {
        if (a == 0) help_edit_box.Printf("   ______   ");
        if (a == 1) help_edit_box.Printf("  |      |  ");
        if (a == 2) help_edit_box.Printf("  | |~~| |  ");
        if (a == 3) help_edit_box.Printf("  | ~~~~ |  ");
        if (a == 4) help_edit_box.Printf("  | |~~~~   ");
        if (a == 5) help_edit_box.Printf("  |_|       ");
    }

    void bigascii_naji_q(int a)
    {
        if (a == 0) help_edit_box.Printf("   ______   ");
        if (a == 1) help_edit_box.Printf("  |      |  ");
        if (a == 2) help_edit_box.Printf("  | |~~| |  ");
        if (a == 3) help_edit_box.Printf("  | | _| |  ");
        if (a == 4) help_edit_box.Printf("  | |_\\ \\|  ");
        if (a == 5) help_edit_box.Printf("  |____\\_\\  ");
    }

    void bigascii_naji_r(int a)
    {
        if (a == 0) help_edit_box.Printf("   ______   ");
        if (a == 1) help_edit_box.Printf("  |      |  ");
        if (a == 2) help_edit_box.Printf("  | |~~| |  ");
        if (a == 3) help_edit_box.Printf("  | ~~~~ |  ");
        if (a == 4) help_edit_box.Printf("  | |~\\ \\~  ");
        if (a == 5) help_edit_box.Printf("  |_|  \\_\\  ");
    }

    void bigascii_naji_s(int a)
    {
        if (a == 0) help_edit_box.Printf("    _____   ");
        if (a == 1) help_edit_box.Printf("   /  __ \\  ");
        if (a == 2) help_edit_box.Printf("   \\  \\ \\/  ");
        if (a == 3) help_edit_box.Printf(" /\\ \\  \\    ");
        if (a == 4) help_edit_box.Printf(" \\ \\_\\  \\   ");
        if (a == 5) help_edit_box.Printf("  \\_____/   ");
    }

    void bigascii_naji_t(int a)
    {
        if (a == 0) help_edit_box.Printf("   ______   ");
        if (a == 1) help_edit_box.Printf("  |_    _|  ");
        if (a == 2) help_edit_box.Printf("    |  |    ");
        if (a == 3) help_edit_box.Printf("    |  |    ");
        if (a == 4) help_edit_box.Printf("    |  |    ");
        if (a == 5) help_edit_box.Printf("    |__|    ");
    }

    void bigascii_naji_u(int a)
    {
        if (a == 0) help_edit_box.Printf("   _    _   ");
        if (a == 1) help_edit_box.Printf("  | |  | |  ");
        if (a == 2) help_edit_box.Printf("  | |  | |  ");
        if (a == 3) help_edit_box.Printf("  | |  | |  ");
        if (a == 4) help_edit_box.Printf("  | |__| |  ");
        if (a == 5) help_edit_box.Printf("  |______|  ");
    }

    void bigascii_naji_v(int a)
    {
        if (a == 0) help_edit_box.Printf("   _     _  ");
        if (a == 1) help_edit_box.Printf("  | |   | | ");
        if (a == 2) help_edit_box.Printf("  | |   | | ");
        if (a == 3) help_edit_box.Printf("  \\ \\   / / ");
        if (a == 4) help_edit_box.Printf("   \\ \\_/ /  ");
        if (a == 5) help_edit_box.Printf("    \\___/   ");
    }

    void bigascii_naji_w(int a)
    {
        if (a == 0) help_edit_box.Printf("  _      _  ");
        if (a == 1) help_edit_box.Printf(" | |    | | ");
        if (a == 2) help_edit_box.Printf(" | |    | | ");
        if (a == 3) help_edit_box.Printf(" | | /\\ | | ");
        if (a == 4) help_edit_box.Printf(" | \\/  \\/ | ");
        if (a == 5) help_edit_box.Printf("  \\__/\\__/  ");
    }

    void bigascii_naji_x(int a)
    {
        if (a == 0) help_edit_box.Printf("   __   __  ");
        if (a == 1) help_edit_box.Printf("   \\ \\_/ /  ");
        if (a == 2) help_edit_box.Printf("    \\   /   ");
        if (a == 3) help_edit_box.Printf("     | |    ");
        if (a == 4) help_edit_box.Printf("    / _ \\   ");
        if (a == 5) help_edit_box.Printf("   /_/ \\_\\  ");
    }

    void bigascii_naji_y(int a)
    {
        if (a == 0) help_edit_box.Printf("   __   __  ");
        if (a == 1) help_edit_box.Printf("   \\ \\_/ /  ");
        if (a == 2) help_edit_box.Printf("    \\   /   ");
        if (a == 3) help_edit_box.Printf("     | |    ");
        if (a == 4) help_edit_box.Printf("     | |    ");
        if (a == 5) help_edit_box.Printf("     |_|    ");
    }

    void bigascii_naji_z(int a)
    {
        if (a == 0) help_edit_box.Printf("    _____   ");
        if (a == 1) help_edit_box.Printf("   |___  |  ");
        if (a == 2) help_edit_box.Printf("      / /   ");
        if (a == 3) help_edit_box.Printf("     / /    ");
        if (a == 4) help_edit_box.Printf("    / /__   ");
        if (a == 5) help_edit_box.Printf("   /_____|  ");
    }

    void bigascii_naji_1(int a)
    {
        if (a == 0) help_edit_box.Printf("    /~~|    ");
        if (a == 1) help_edit_box.Printf("  /_   |    ");
        if (a == 2) help_edit_box.Printf("    |  |    ");
        if (a == 3) help_edit_box.Printf("    |  |    ");
        if (a == 4) help_edit_box.Printf("   _|  |_   ");
        if (a == 5) help_edit_box.Printf("  |______|  ");
    }

    void bigascii_naji_2(int a)
    {
        if (a == 0) help_edit_box.Printf("   _____    ");
        if (a == 1) help_edit_box.Printf("  /     \\   ");
        if (a == 2) help_edit_box.Printf(" |_/~\\   \\  ");
        if (a == 3) help_edit_box.Printf("     /  /   ");
        if (a == 4) help_edit_box.Printf("   /  /___  ");
        if (a == 5) help_edit_box.Printf("  |_______| ");
    }

    void bigascii_naji_3(int a)
    {
        if (a == 0) help_edit_box.Printf("   ______   ");
        if (a == 1) help_edit_box.Printf("  |___   \\  ");
        if (a == 2) help_edit_box.Printf("    __|  /  ");
        if (a == 3) help_edit_box.Printf("   <__  <   ");
        if (a == 4) help_edit_box.Printf("   ___|  \\  ");
        if (a == 5) help_edit_box.Printf("  |______/  ");
    }

    void bigascii_naji_4(int a)
    {
        if (a == 0) help_edit_box.Printf("     /~~|   ");
        if (a == 1) help_edit_box.Printf("    /   |   ");
        if (a == 2) help_edit_box.Printf("   / /| |   ");
        if (a == 3) help_edit_box.Printf("  / /_| |_  ");
        if (a == 4) help_edit_box.Printf(" /____   _| ");
        if (a == 5) help_edit_box.Printf("      |_|   ");
    }

    void bigascii_naji_5(int a)
    {
        if (a == 0) help_edit_box.Printf("   ______   ");
        if (a == 1) help_edit_box.Printf("  |  ____|  ");
        if (a == 2) help_edit_box.Printf("  | |____   ");
        if (a == 3) help_edit_box.Printf("  |____  |  ");
        if (a == 4) help_edit_box.Printf("   ____| |  ");
        if (a == 5) help_edit_box.Printf("  |______|  ");
    }

    void bigascii_naji_6(int a)
    {
        if (a == 0) help_edit_box.Printf("    _____   ");
        if (a == 1) help_edit_box.Printf("   / ____|  ");
        if (a == 2) help_edit_box.Printf("  | |____   ");
        if (a == 3) help_edit_box.Printf("  |  __  |  ");
        if (a == 4) help_edit_box.Printf("  | |__| |  ");
        if (a == 5) help_edit_box.Printf("   \\____/   ");
    }

    void bigascii_naji_7(int a)
    {
        if (a == 0) help_edit_box.Printf("   ______   ");
        if (a == 1) help_edit_box.Printf("  |___   |  ");
        if (a == 2) help_edit_box.Printf("     /  /   ");
        if (a == 3) help_edit_box.Printf("    /  /    ");
        if (a == 4) help_edit_box.Printf("   /  /     ");
        if (a == 5) help_edit_box.Printf("  /__/      ");
    }

    void bigascii_naji_8(int a)
    {
        if (a == 0) help_edit_box.Printf("    _____   ");
        if (a == 1) help_edit_box.Printf("   / ___ \\  ");
        if (a == 2) help_edit_box.Printf("  | |__| |  ");
        if (a == 3) help_edit_box.Printf("   > __ <   ");
        if (a == 4) help_edit_box.Printf("  | |__| |  ");
        if (a == 5) help_edit_box.Printf("   \\____/   ");
    }

    void bigascii_naji_9(int a)
    {
        if (a == 0) help_edit_box.Printf("    _____   ");
        if (a == 1) help_edit_box.Printf("   / ___ \\  ");
        if (a == 2) help_edit_box.Printf("  | |__| |  ");
        if (a == 3) help_edit_box.Printf("   \\ __  |  ");
        if (a == 4) help_edit_box.Printf("   ____| |  ");
        if (a == 5) help_edit_box.Printf("   \\____/   ");
    }

    void bigascii_naji_0(int a)
    {
        if (a == 0) help_edit_box.Printf("    _____   ");
        if (a == 1) help_edit_box.Printf("   / ___ \\  ");
        if (a == 2) help_edit_box.Printf("  | |  | |  ");
        if (a == 3) help_edit_box.Printf("  | |  | |  ");
        if (a == 4) help_edit_box.Printf("  | |__| |  ");
        if (a == 5) help_edit_box.Printf("   \\____/   ");
    }

    void bigascii_naji_ascii_coma(int a)
    {
        if (a == 0) help_edit_box.Printf("            ");
        if (a == 1) help_edit_box.Printf("            ");
        if (a == 2) help_edit_box.Printf("            ");
        if (a == 3) help_edit_box.Printf("     ___    ");
        if (a == 4) help_edit_box.Printf("    |   |   ");
        if (a == 5) help_edit_box.Printf("   /___/    ");
    }

    void bigascii_naji_ascii_aposopen(int a)
    {
        if (a == 0) help_edit_box.Printf("    ___     ");
        if (a == 1) help_edit_box.Printf("   |   |    ");
        if (a == 2) help_edit_box.Printf("    \\___\\   ");
        if (a == 3) help_edit_box.Printf("            ");
        if (a == 4) help_edit_box.Printf("            ");
        if (a == 5) help_edit_box.Printf("            ");
    }

    void bigascii_naji_ascii_aposclose(int a)
    {
        if (a == 0) help_edit_box.Printf("     ___    ");
        if (a == 1) help_edit_box.Printf("    |   |   ");
        if (a == 2) help_edit_box.Printf("   /___/    ");
        if (a == 3) help_edit_box.Printf("            ");
        if (a == 4) help_edit_box.Printf("            ");
        if (a == 5) help_edit_box.Printf("            ");
    }

    void bigascii_naji_ascii_period(int a)
    {
        if (a == 0) help_edit_box.Printf("            ");
        if (a == 1) help_edit_box.Printf("            ");
        if (a == 2) help_edit_box.Printf("            ");
        if (a == 3) help_edit_box.Printf("    ____    ");
        if (a == 4) help_edit_box.Printf("   |    |   ");
        if (a == 5) help_edit_box.Printf("   |____|   ");
    }

    void bigascii_naji_ascii_colon(int a)
    {
        if (a == 0) help_edit_box.Printf("    ____    ");
        if (a == 1) help_edit_box.Printf("   |    |   ");
        if (a == 2) help_edit_box.Printf("   |____|   ");
        if (a == 3) help_edit_box.Printf("    ____    ");
        if (a == 4) help_edit_box.Printf("   |    |   ");
        if (a == 5) help_edit_box.Printf("   |____|   ");
    }

    void bigascii_naji_ascii_semicolon(int a)
    {
        if (a == 0) help_edit_box.Printf("     ___    ");
        if (a == 1) help_edit_box.Printf("    |   |   ");
        if (a == 2) help_edit_box.Printf("    |___|   ");
        if (a == 3) help_edit_box.Printf("     ___    ");
        if (a == 4) help_edit_box.Printf("    |   |   ");
        if (a == 5) help_edit_box.Printf("   /___/    ");
    }

    void bigascii_naji_ascii_lessthan(int a)
    {
        if (a == 0) help_edit_box.Printf("     /~/    ");
        if (a == 1) help_edit_box.Printf("    / /     ");
        if (a == 2) help_edit_box.Printf("   / /      ");
        if (a == 3) help_edit_box.Printf("   \\ \\      ");
        if (a == 4) help_edit_box.Printf("    \\ \\     ");
        if (a == 5) help_edit_box.Printf("     \\_\\    ");
    }

    void bigascii_naji_ascii_morethan(int a)
    {
        if (a == 0) help_edit_box.Printf("    \\~\\     ");
        if (a == 1) help_edit_box.Printf("     \\ \\    ");
        if (a == 2) help_edit_box.Printf("      \\ \\   ");
        if (a == 3) help_edit_box.Printf("      / /   ");
        if (a == 4) help_edit_box.Printf("     / /    ");
        if (a == 5) help_edit_box.Printf("    /_/     ");
    }

    void bigascii_naji_ascii_paranopen(int a)
    {
        if (a == 0) help_edit_box.Printf("     /~/    ");
        if (a == 1) help_edit_box.Printf("    / /     ");
        if (a == 2) help_edit_box.Printf("   | |      ");
        if (a == 3) help_edit_box.Printf("   | |      ");
        if (a == 4) help_edit_box.Printf("    \\ \\     ");
        if (a == 5) help_edit_box.Printf("     \\_\\    ");
    }

    void bigascii_naji_ascii_paranclose(int a)
    {
        if (a == 0) help_edit_box.Printf("    \\~\\     ");
        if (a == 1) help_edit_box.Printf("     \\ \\    ");
        if (a == 2) help_edit_box.Printf("      | |   ");
        if (a == 3) help_edit_box.Printf("      | |   ");
        if (a == 4) help_edit_box.Printf("     / /    ");
        if (a == 5) help_edit_box.Printf("    /_/     ");
    }

    void bigascii_naji_ascii_underscore(int a)
    {
        if (a == 0) help_edit_box.Printf("            ");
        if (a == 1) help_edit_box.Printf("            ");
        if (a == 2) help_edit_box.Printf("            ");
        if (a == 3) help_edit_box.Printf("            ");
        if (a == 4) help_edit_box.Printf(" __________ ");
        if (a == 5) help_edit_box.Printf("|__________|");
    }

    void bigascii_naji_ascii_exclaimark(int a)
    {
        if (a == 0) help_edit_box.Printf("    ___     ");
        if (a == 1) help_edit_box.Printf("   |   |    ");
        if (a == 2) help_edit_box.Printf("   |   |    ");
        if (a == 3) help_edit_box.Printf("   |___|    ");
        if (a == 4) help_edit_box.Printf("    ___     ");
        if (a == 5) help_edit_box.Printf("   |___|    ");
    }

    void bigascii_naji_ascii_pipe(int a)
    {
        if (a == 0) help_edit_box.Printf("   |~~~|    ");
        if (a == 1) help_edit_box.Printf("   |   |    ");
        if (a == 2) help_edit_box.Printf("   |   |    ");
        if (a == 3) help_edit_box.Printf("   |   |    ");
        if (a == 4) help_edit_box.Printf("   |   |    ");
        if (a == 5) help_edit_box.Printf("   |___|    ");
    }

    void bigascii_naji_ascii_numsign(int a)
    {
        if (a == 0) help_edit_box.Printf("   ##  ##   ");
        if (a == 1) help_edit_box.Printf(" ########## ");
        if (a == 2) help_edit_box.Printf("   ##  ##   ");
        if (a == 3) help_edit_box.Printf("   ##  ##   ");
        if (a == 4) help_edit_box.Printf(" ########## ");
        if (a == 5) help_edit_box.Printf("   ##  ##   ");
    }

    void bigascii_naji_ascii_fslash(int a)
    {
        if (a == 0) help_edit_box.Printf("      /~~/  ");
        if (a == 1) help_edit_box.Printf("     /  /   ");
        if (a == 2) help_edit_box.Printf("    /  /    ");
        if (a == 3) help_edit_box.Printf("   /  /     ");
        if (a == 4) help_edit_box.Printf("  /  /      ");
        if (a == 5) help_edit_box.Printf(" /__/       ");
    }

    void bigascii_naji_ascii_bslash(int a)
    {
        if (a == 0) help_edit_box.Printf("  \\~~\\      ");
        if (a == 1) help_edit_box.Printf("   \\  \\     ");
        if (a == 2) help_edit_box.Printf("    \\  \\    ");
        if (a == 3) help_edit_box.Printf("     \\  \\   ");
        if (a == 4) help_edit_box.Printf("      \\  \\  ");
        if (a == 5) help_edit_box.Printf("       \\__\\ ");
    }

    void bigascii_naji_ascii(char *string, int i, int a)
    {
        /* small and big letter is the same for now */
        /* i might do different styles in later versions */

        if (string[i] == ' ')
        {
            bigascii_naji_(a);
        }
        if (string[i] == 'a')
        {
            bigascii_naji_a(a);
        }
        if (string[i] == 'b')
        {
            bigascii_naji_b(a);
        }
        if (string[i] == 'c')
        {
            bigascii_naji_c(a);
        }
        if (string[i] == 'd')
        {
            bigascii_naji_d(a);
        }
        if (string[i] == 'e')
        {
            bigascii_naji_e(a);
        }
        if (string[i] == 'f')
        {
            bigascii_naji_f(a);
        }
        if (string[i] == 'g')
        {
            bigascii_naji_g(a);
        }
        if (string[i] == 'h')
        {
            bigascii_naji_h(a);
        }
        if (string[i] == 'i')
        {
            bigascii_naji_i(a);
        }
        if (string[i] == 'j')
        {
            bigascii_naji_j(a);
        }
        if (string[i] == 'k')
        {
            bigascii_naji_k(a);
        }
        if (string[i] == 'l')
        {
            bigascii_naji_l(a);
        }
        if (string[i] == 'm')
        {
            bigascii_naji_m(a);
        }
        if (string[i] == 'n')
        {
            bigascii_naji_n(a);
        }
        if (string[i] == 'o')
        {
            bigascii_naji_o(a);
        }
        if (string[i] == 'p')
        {
            bigascii_naji_p(a);
        }
        if (string[i] == 'q')
        {
            bigascii_naji_q(a);
        }
        if (string[i] == 'r')
        {
            bigascii_naji_r(a);
        }
        if (string[i] == 's')
        {
            bigascii_naji_s(a);
        }
        if (string[i] == 't')
        {
            bigascii_naji_t(a);
        }
        if (string[i] == 'u')
        {
            bigascii_naji_u(a);
        }
        if (string[i] == 'v')
        {
            bigascii_naji_v(a);
        }
        if (string[i] == 'w')
        {
            bigascii_naji_w(a);
        }
        if (string[i] == 'x')
        {
            bigascii_naji_x(a);
        }
        if (string[i] == 'y')
        {
            bigascii_naji_y(a);
        }
        if (string[i] == 'z')
        {
            bigascii_naji_z(a);
        }

        if (string[i] == 'A')
        {
            bigascii_naji_a(a);
        }
        if (string[i] == 'B')
        {
            bigascii_naji_b(a);
        }
        if (string[i] == 'C')
        {
            bigascii_naji_c(a);
        }
        if (string[i] == 'D')
        {
            bigascii_naji_d(a);
        }
        if (string[i] == 'E')
        {
            bigascii_naji_e(a);
        }
        if (string[i] == 'F')
        {
            bigascii_naji_f(a);
        }
        if (string[i] == 'G')
        {
            bigascii_naji_g(a);
        }
        if (string[i] == 'H')
        {
            bigascii_naji_h(a);
        }
        if (string[i] == 'I')
        {
            bigascii_naji_i(a);
        }
        if (string[i] == 'J')
        {
            bigascii_naji_j(a);
        }
        if (string[i] == 'K')
        {
            bigascii_naji_k(a);
        }
        if (string[i] == 'L')
        {
            bigascii_naji_l(a);
        }
        if (string[i] == 'M')
        {
            bigascii_naji_m(a);
        }
        if (string[i] == 'N')
        {
            bigascii_naji_n(a);
        }
        if (string[i] == 'O')
        {
            bigascii_naji_o(a);
        }
        if (string[i] == 'P')
        {
            bigascii_naji_p(a);
        }
        if (string[i] == 'Q')
        {
            bigascii_naji_q(a);
        }
        if (string[i] == 'R')
        {
            bigascii_naji_r(a);
        }
        if (string[i] == 'S')
        {
            bigascii_naji_s(a);
        }
        if (string[i] == 'T')
        {
            bigascii_naji_t(a);
        }
        if (string[i] == 'U')
        {
            bigascii_naji_u(a);
        }
        if (string[i] == 'V')
        {
            bigascii_naji_v(a);
        }
        if (string[i] == 'W')
        {
            bigascii_naji_w(a);
        }
        if (string[i] == 'X')
        {
            bigascii_naji_x(a);
        }
        if (string[i] == 'Y')
        {
            bigascii_naji_y(a);
        }
        if (string[i] == 'Z')
        {
            bigascii_naji_z(a);
        }

        if (string[i] == '1')
        {
            bigascii_naji_1(a);
        }
        if (string[i] == '2')
        {
            bigascii_naji_2(a);
        }
        if (string[i] == '3')
        {
            bigascii_naji_3(a);
        }
        if (string[i] == '4')
        {
            bigascii_naji_4(a);
        }
        if (string[i] == '5')
        {
            bigascii_naji_5(a);
        }
        if (string[i] == '6')
        {
            bigascii_naji_6(a);
        }
        if (string[i] == '7')
        {
            bigascii_naji_7(a);
        }
        if (string[i] == '8')
        {
            bigascii_naji_8(a);
        }
        if (string[i] == '9')
        {
            bigascii_naji_9(a);
        }
        if (string[i] == '0')
        {
            bigascii_naji_0(a);
        }

        if (string[i] == ',')
        {
            bigascii_naji_ascii_coma(a);
        }
        if (string[i] == '`')
        {
            bigascii_naji_ascii_aposopen(a);
        }
        if (string[i] == '\'')
        {
            bigascii_naji_ascii_aposclose(a);
        }
        if (string[i] == '.')
        {
            bigascii_naji_ascii_period(a);
        }
        if (string[i] == ':')
        {
            bigascii_naji_ascii_colon(a);
        }
        if (string[i] == ';')
        {
            bigascii_naji_ascii_semicolon(a);
        }
        if (string[i] == '<')
        {
            bigascii_naji_ascii_lessthan(a);
        }
        if (string[i] == '>')
        {
            bigascii_naji_ascii_morethan(a);
        }
        if (string[i] == '(')
        {
            bigascii_naji_ascii_paranopen(a);
        }
        if (string[i] == ')')
        {
            bigascii_naji_ascii_paranclose(a);
        }
        if (string[i] == '_')
        {
            bigascii_naji_ascii_underscore(a);
        }
        if (string[i] == '!')
        {
            bigascii_naji_ascii_exclaimark(a);
        }
        if (string[i] == '|')
        {
            bigascii_naji_ascii_pipe(a);
        }
        if (string[i] == '#')
        {
            bigascii_naji_ascii_numsign(a);
        }
        if (string[i] == '/')
        {
            bigascii_naji_ascii_fslash(a);
        }
        if (string[i] == '\\')
        {
            bigascii_naji_ascii_bslash(a);
        }

    }

    void bigascii(char *string)
    {
        int a=0;
        int i=0;
        int l=0;

        help_edit_box.Clear();

        l = strlen(string);

        for (a=0; a<6; a++)
        {
            for (i=0; i<l; i++)
                bigascii_naji_ascii(string, i, a);

            help_edit_box.Printf("\n");
        }

        return;
    }

    void cat_head(char *namein, int n_lines)
    {
        int a;
        int cnt=0;

        if (n_lines <= 0)
            return;

        najin(namein);
        help_edit_box.Clear();
        help_edit_box.Printf("\n");

        while (cnt < n_lines)
        {

            a = fgetc(naji_input);

            if (a == EOF)
                break;

            if (a == '\n')
            {
                cnt++;
                help_edit_box.AddCh(a);
            }

            else if (cnt <= n_lines)
                help_edit_box.AddCh(a);

        }

        najinclose();
    }

    void cat_tail(char *namein, int n_lines)
    {
        int a;
        int i=0;

        long *fpos = NULL;

        help_edit_box.Clear();

        if (n_lines <= 0)
            return;

        fpos = (long *) malloc(sizeof (long) * n_lines);

        if (fpos == NULL)
        {

            if (!strcmp(najitool_language, "English"))
                msgbox("najitool GUI cat_tail error:", "Error, cannot allocate memory.");

            else if (!strcmp(najitool_language, "Turkish"))
                msgbox("najitool GUI cat_tail hata:", "Hata, hafiza ayirilmadi.");

            exit(2);
        }

        najin(namein);

        fpos[i % n_lines] = 0;
        i++;

        while (1)
        {

            a = fgetc (naji_input);
            if (a == EOF) break;

            if (a == '\n')
            {
                fpos[i % n_lines] = ftell (naji_input);
                i++;
            }

        }

        if (i < n_lines)
            fseek(naji_input, 0, SEEK_SET);

        else fseek(naji_input, fpos[i % n_lines], SEEK_SET);

        while (1)
        {
            a = fgetc(naji_input);

            if (a == EOF)
                break;

            help_edit_box.AddCh(a);
        }

        free(fpos);
        najinclose();
    }

    void repcat(char *namein, unsigned int repeat)
    {
        int a=0;
        unsigned int i=0;

        help_edit_box.Clear();
        najin(namein);

        repeat++;

        while (1)
        {
            a = fgetc(naji_input);

            if (a == EOF)
                break;

            for (i=0; i<repeat; i++)
                help_edit_box.AddCh(a);
        }

        najinclose();
    }

    void repcatpp(char *namein, unsigned int start)
    {
        int a=0;
        unsigned int i=0;

        help_edit_box.Clear();
        najin(namein);

        start++;

        while (1)
        {
            a = fgetc(naji_input);

            if (a == EOF)
                break;

            for (i=0; i<start; i++)
                help_edit_box.AddCh(a);

            start++;
        }

        najinclose();
    }

    void skipcat(char *namein, char *toskip)
    {
        int skip = NAJI_FALSE;
        int a=0;
        int i=0;
        int l=0;

        help_edit_box.Clear();

        l = strlen(toskip);

        najin(namein);

        while (1)
        {
            a = fgetc(naji_input);
            if (a == EOF) break;
            skip = NAJI_FALSE;

            for (i=0; i<l; i++)
                if (a == toskip[i])
                    skip = NAJI_TRUE;

            if (skip == NAJI_FALSE)
                help_edit_box.AddCh(a);
        }

        najinclose();
    }

    void onlycat(char *namein, char *toshow)
    {
        int show = NAJI_TRUE;
        int a=0;
        int i=0;
        int l=0;

        help_edit_box.Clear();
        najin(namein);

        l = strlen(toshow);

        while (1)
        {
            a = fgetc(naji_input);
            if (a == EOF) break;

            show = NAJI_FALSE;

            for (i=0; i<l; i++)
                if (a == toshow[i])
                    show = NAJI_TRUE;

            if (show == NAJI_TRUE)
                help_edit_box.AddCh(a);
        }

        najinclose();
    }

    void rndbsout(unsigned long int size)
    {
        unsigned long int i=0;

        help_edit_box.Clear();
        srand(time(NULL));
        for (i=0; i<size; i++)
            help_edit_box.AddCh((rand() % 255));
    }

    void rndtsout(unsigned long int size)
    {
        unsigned long int i=0;
        help_edit_box.Clear();
        srand(time(NULL));
        for (i=0; i<size; i++)
            help_edit_box.AddCh((rand() % 95)+' ');
    }

    void hexicat(char *namein)
    {
        int counter = 0;
        int hexbuf[20];

        unsigned long offset = 0;

        int a;
        int i;

        help_edit_box.Clear();
        najin(namein);

        while (1)
        {

            a = fgetc(naji_input);

            if (a == EOF)
            {

                if (counter == 1)
                    help_edit_box.Printf("                                                 ");

                if (counter == 2)
                    help_edit_box.Printf("                                              ");

                if (counter == 3)
                    help_edit_box.Printf("                                           ");

                if (counter == 4)
                    help_edit_box.Printf("                                       ");

                if (counter == 5)
                    help_edit_box.Printf("                                    ");

                if (counter == 6)
                    help_edit_box.Printf("                                 ");

                if (counter == 7)
                    help_edit_box.Printf("                              ");

                if (counter == 8)
                    help_edit_box.Printf("                          ");

                if (counter == 9)
                    help_edit_box.Printf("                       ");

                if (counter == 10)
                    help_edit_box.Printf("                    ");

                if (counter == 11)
                    help_edit_box.Printf("                 ");

                if (counter == 12)
                    help_edit_box.Printf("             ");

                if (counter == 13)
                    help_edit_box.Printf("          ");

                if (counter == 14)
                    help_edit_box.Printf("       ");

                if (counter == 15)
                    help_edit_box.Printf("    ");

                for (i=0; i<counter; i++)
                {
                    if ((hexbuf[i] >= 32) && (hexbuf[i] <= 126))
                        help_edit_box.AddCh(hexbuf[i]);

                    else
                        help_edit_box.AddCh('.');
                }

                help_edit_box.AddCh('\n');

                break;

            }

            if (counter == 0 || counter == 16)
            {

                if (offset == 0xFFFFFFF0)
                {
                    help_edit_box.Printf("OFFLIMIT:  ");
                }

                else
                {
                    help_edit_box.Printf("%08X:  ", offset);
                }

            }

            hexbuf[counter]=a;

            help_edit_box.Printf("%02X ", a);

            if (counter == 3  ||
                    counter == 7  ||
                    counter == 11 ||
                    counter == 15
               )

                help_edit_box.AddCh(' ');

            counter++;

            if (counter == 16)
            {

                if (offset != 0xFFFFFFF0)
                    offset += 16;

                for (i=0; i<16; i++)
                {
                    if ((hexbuf[i] >= 32) && (hexbuf[i] <= 126))
                        help_edit_box.AddCh(hexbuf[i]);

                    else
                        help_edit_box.AddCh('.');

                }

                help_edit_box.AddCh('\n');

                counter = 0;

            }

        }

        najinclose();
    }

    void revcat(char *namein)
    {
        int a=0;
        long pos;

        help_edit_box.Clear();
        najin(namein);

        pos = najinsize();

        while (1)
        {
            pos--;
            if (pos < 0) break;

            fseek(naji_input, pos, SEEK_SET);

            a = fgetc(naji_input);
            help_edit_box.AddCh(a);
        }

        najinclose();
    }

    void gigabyte(unsigned long i)
    {
        unsigned long gb2bytes = 1073741824;
        unsigned long gb2kb    = 1048576;
        unsigned long gb2mb    = 1024;
        unsigned long gb2gb    = 1;

        help_edit_box.Clear();

        if ( (i >= 1UL) && (i <= 4294967295UL) ) /* variable overflow prevention */
            help_edit_box.Printf("GB    : %lu\n", ( (gb2gb)    * (i) ) );
        else printf("gigabyte calculation error\n");

        if ( (i >= 1UL) && (i <= 4194303) ) /* variable overflow prevention */
            help_edit_box.Printf("MB    : %lu\n", ( (gb2mb)    * (i) ) );

        if ( (i >= 1UL) && (i <= 4095) ) /* variable overflow prevention */
            help_edit_box.Printf("KB    : %lu\n", ( (gb2kb)    * (i) ) );

        if ( (i >= 1UL) && (i <= 3) ) /* variable overflow prevention */
            help_edit_box.Printf("Bytes : %lu\n", ( (gb2bytes) * (i) ) );

    }

    void qpatch(char *named, char *patch_file)
    {
        char *end;
        char buffer[200];
        char converted_buffer[200];

        int value = 0;
        unsigned long offset = 0;

        unsigned long bytes_patched = 0;

        long filesize = 0;

        int i;

        najin(patch_file);
        najed(named);

        filesize = najedsize();

        while (1)
        {

            /* gets offset */

            if ( fgets(buffer, 100, naji_input) == NULL )
                break;

            for (i=0; i<100; i++)
                if ( ! (buffer[i] < '0' && buffer[i] > '9') )
                    converted_buffer[i] = buffer[i];

            offset = strtoul(converted_buffer, &end, 0);

            if (offset > filesize)
            {

                if (!strcmp(najitool_language, "English"))
                    msgbox("najitool GUI qpatch error:", "Offset inside patch file cannot be greater than filesize.");

                else if (!strcmp(najitool_language, "Turkish"))
                    msgbox("najitool GUI qpatch hata:", "Patch dosya icindeki ofset dosya boyutundan daha fazla olamaz.");

                break;
            }

            /* gets value */

            if ( fgets(buffer, 100, naji_input) == NULL )
                break;

            for (i=0; i<100; i++)
                if ( ! (buffer[i] < '0' && buffer[i] > '9') )
                    converted_buffer[i] = buffer[i];

            value = atoi(converted_buffer);

            if (value > 255)
            {

                if (!strcmp(najitool_language, "English"))
                    msgbox("najitool GUI qpatch error:", "Value inside patch file cannot be greater than 255.");

                else if (!strcmp(najitool_language, "Turkish"))
                    msgbox("najitool GUI qpatch hata:", "Patch dosya icindeki deger 255 den fazla olamaz.");

                break;
            }

            if (value < 0)
            {

                if (!strcmp(najitool_language, "English"))
                    msgbox("najitool GUI qpatch error:", "Value inside patch file cannot be less than 0.");

                else if (!strcmp(najitool_language, "Turkish"))
                    msgbox("najitool GUI qpatch hata:", "Patch dosya icindeki deger 0 dan daha az olamaz.");

                break;
            }

            /* seek to offset */
            fseek(naji_edit, offset, SEEK_SET);

            /* write value */
            fputc(value, naji_edit);
            bytes_patched++;
        }

        if (!strcmp(najitool_language, "English"))
            help_edit_box.Printf("Successfully patched %lu bytes of data.\n", bytes_patched);

        else if (!strcmp(najitool_language, "Turkish"))
            help_edit_box.Printf("%lu bayt veri basarili patchlandi.\n", bytes_patched);

        if (bytes_patched > filesize)
        {

            if (!strcmp(najitool_language, "English"))
            {
                MessageBox { text = "najitool GUI qpatch warning",
                             contents =
                                 "WARNING: The amount of bytes patched were more than the filesize.\n"
                                 "This means certain location(s) were patched more than once,\n"
                                 "because they were specified in the patch file more than once.\n"
                                 "There is a minor bug in the patch file, it is recommended that you\n"
                                 "delete the duplicate patcher instructions in the patch file before\n"
                                 "you release it.\n"
                           }.Modal();
            }

            else if (!strcmp(najitool_language, "Turkish"))
            {
                MessageBox { text = "najitool GUI qpatch uyari",
                             contents =
                                 "UYARI: patched bayt miktari dosya boyutundan daha fazla.\n"
                                 "Bu demek, belirli yer(ler) bir kez den fazla  patchlandi,\n"
                                 "cunku patch dosya da bir kez dan fazla belirlendiler.\n"
                                 "Patch dosyasinda kucuk bir hata var, patch dosyayi\n"
                                 "yayinlamadan once patch dosya'nin tekrarlanan\n"
                                 "patch talimatlari silmek onerilir.\n"
                           }.Modal();
            }

        }

        najinclose();
        najedclose();
    }

    void mkpatch(char *original, char *patched, char *patchfile)
    {
        int a;
        int b;

        unsigned long offset = 0;
        unsigned long bytes  = 0;

        long insize = 0;
        long in2size = 0;

        najin(original);
        najin2(patched);
        najout(patchfile);

        insize = najinsize();
        in2size = najin2size();

        if (insize != in2size)
        {

            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI mkpatch error:", contents = "Error, original file and patched file must be the same size for the patch to be made." }.Modal();
            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI mkpatch hata:", contents = "Hata, orijinal dosya ve patchlenmis dosya ayni boyutu da olmasi lazim patch olusturulmasi icin." }.Modal();

            return;
        }

        offset--;

        while (1)
        {

            a = fgetc(naji_input);
            b = fgetc(naji_input2);

            if (a == EOF)
                break;

            offset++;

            if (a != b)
            {
                fprintf(naji_output, "%lu\n", offset);
                fprintf(naji_output, "%lu\n", (unsigned long)b);
                bytes++;
            }

        }

        help_edit_box.Printf("Patch file %s successfully made which patches %lu bytes.\n", patchfile, bytes);

        najinclose();
        najin2close();
        najoutclose();
    }

    void kitten(char *namein)
    {
        int a=0;

        help_edit_box.Clear();
        najin(namein);

        while (1)
        {
            a = fgetc(naji_input);
            if (a == EOF) break;
            help_edit_box.AddCh(a);
        }

        najinclose();
    }

    void cat_text(char *namein)
    {
        int a=0;

        najin(namein);

        while (1)
        {
            a = fgetc(naji_input);
            if (a == EOF) break;
            if ( ( (a > 31) && (a < 127) ) ||
                    ( (a == '\n') ) ||
                    ( (a == '\r') ) ||
                    ( (a == '\t') )
               )

                help_edit_box.AddCh(a);
        }

        najinclose();
    }

    void showline(char *namein, unsigned long line)
    {
        int a;
        unsigned long cnt = 0;

        help_edit_box.Clear();

        if (line <= 0)
            return;

        line -= 1;

        najin(namein);

        while (cnt != line)
        {
            a = fgetc(naji_input);
            if (a == EOF)
                break;

            if (a == '\n')
                cnt++;
        }

        if (cnt == line)
        {
            while (1)
            {
                a = fgetc (naji_input);

                if (a == EOF || a == '\n')
                    break;

                help_edit_box.AddCh(a);
            }

        }

        najinclose();
    }

    void catrandl(char *namein)
    {
        int a;
        unsigned long number_of_lines = 0;
        unsigned long random_line = 0;

        rndinit();

        najin(namein);

        while (1)
        {
            a = fgetc(naji_input);

            if (a == EOF)
                break;

            if (a == '\n')
                number_of_lines++;
        }

        najinclose();

        random_line = rand() % number_of_lines;
        random_line++;

        showline(namein, random_line);

    }

    void compfile(char *namein, char *namein2, bool cont_on_diff)
    {
        int a;
        int b;

        int a_line=1;
        int b_line=1;

        int a_offset=0;
        int b_offset=0;

        help_edit_box.Clear();

        najin(namein);
        najin2(namein2);

        while (1)
        {

            a = fgetc(naji_input);
            b = fgetc(naji_input2);

            if (a == EOF)
            {
                help_edit_box.Printf("\n\nEnd of File (EOF) on first input file: %s\n", namein);
                help_edit_box.Printf("on offset: %i\n", a_offset);
                return;
            }

            if (b == EOF)
            {
                help_edit_box.Printf("\n\nEnd of File (EOF) on second input file: %s\n", namein2);
                help_edit_box.Printf("on offset: %i\n", b_offset);
                return;
            }

            a_offset++;
            b_offset++;

            if (a == '\n') a_line++;
            if (b == '\n') b_line++;

            if (a != b)
            {
                help_edit_box.Printf("\n\nFiles %s and %s differ at offset %i.\n",
                                     namein, namein2, a_offset);
                help_edit_box.Printf("%s line %i\n", namein, a_line);
                help_edit_box.Printf("%s line %i\n\n", namein2, b_line);

                if (cont_on_diff == false)
                    return;

            }

        }

    }

    void compare(char *namein, char *namein2)
    {
        compfile(namein, namein2, false);
        najinclose();
        najin2close();
    }

    /* continuous compare, does not stop comparing when files differ */

    void ccompare(char *namein, char *namein2)
    {
        compfile(namein, namein2, true);
        najinclose();
        najin2close();
    }

    int ::findi_line(const char *line, const char *str)
    {
        char *straux;
        char *lineaux;

        lineaux = (char*) malloc(sizeof(char) * (strlen(line) + 1));
        straux  = (char*) malloc(sizeof(char) * (strlen(str)  + 1));

        strcpy(straux, str);
        strcpy(lineaux, line);

        touppers(straux);
        touppers(lineaux);

        if (strstr(lineaux, straux) == NULL)
            return 0;

        find_matches++;
        return 1;
    }

    int ::find_line(const char *line, const char *str)
    {

        if (strstr(line, str) == NULL)
            return 0;

        find_matches++;
        return 1;
    }

    void find_basis(char *namein, char *str, bool sensitive, bool show_matches)
    {
        long pos;
        int i;
        int c;
        int found;
        char *line;
        int (*fl_ptr)(const char *line, const char *str);

        find_matches = 0;

        if (sensitive == true)
            fl_ptr = find_line;

        else if (sensitive == false)
            fl_ptr = findi_line;

        help_edit_box.Clear();

        najin(namein);

        pos = ftell(naji_input);
        c = fgetc(naji_input);

        /* line by line */
        while (c != EOF)
        {

            for (i=0; (c != EOF) && (c != '\n') && (c != '\0'); i++)
                c = fgetc(naji_input);

            if (i > 0)
            {
                line = (char*) malloc (sizeof(char)*i+1);

                /* go back and save the chars now */
                fseek(naji_input, pos, SEEK_SET);
                fgets(line, (i+1), naji_input);

                found = fl_ptr(line, str);

                if (found)
                    help_edit_box.Printf("%s\n", line);

                free(line);
            }

            pos = ftell(naji_input);
            c = fgetc(naji_input);
        }

        if (show_matches == true)
            help_edit_box.Printf("\n\n%lu lines containing the string \"%s\"\n\n", find_matches, str);

        najinclose();
    }

    void find(char *namein, char *str)
    {
        find_basis(namein, str, true, false);
    }

    void findi(char *namein, char *str)
    {
        find_basis(namein, str, false, false);
    }

    void cfind(char *namein, char *str)
    {
        find_basis(namein, str, true, true);
    }

    void cfindi(char *namein, char *str)
    {
        find_basis(namein, str, false, true);
    }

    void chchars(char *namein, char *nameout, char *original_chars, char *changed_chars)
    {
        int a;
        int i;

        int len_original_chars;
        int len_changed_chars;

        len_original_chars = strlen(original_chars);
        len_changed_chars  = strlen(changed_chars);

        if (len_original_chars != len_changed_chars)
        {
            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI chchars error:", contents = "Error, both strings need to be the same length." }.Modal();

            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI chchars hata:", contents = "Hata, her iki dizelerin uzunluklari aynı olmasi lazim." }.Modal();

            exit(1);
        }

        najin(namein);
        najout(nameout);

        while (1)
        {

            a = fgetc(naji_input);

            if (a == EOF)
                break;

            for (i=0; i<len_original_chars; i++)
            {

                if (a == original_chars[i])
                {
                    a = changed_chars[i];
                    break;
                }

            }

            fputc(a, naji_output);

        }

        najinclose();
        najoutclose();
    }

    void coffset(char *namein, long startpos, long endpos)
    {
        long filesize=0;
        long i;

        help_edit_box.Clear();

        najin(namein);

        filesize=najinsize();

        if (startpos > endpos)
        {
            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI coffset error:", contents = "Error, start position cannot be greater than end position." }.Modal();
            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI coffset hata:", contents = "Hata, baslangic pozisyon bitis pozisyon dan daha fazla olamaz." }.Modal();

            exit(15);
        }

        if (startpos > filesize)
        {

            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI coffset error:", contents = "Error, start position is greater than the file size." }.Modal();
            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI coffset hata:", contents = "Hata, baslangic pozisyon dosya boyutun dan daha fazla." }.Modal();

            exit(16);
        }

        if (endpos > filesize)
        {
            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI coffset error:", contents = "Error, end position is greater than the file size." }.Modal();
            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI coffset hata:", contents = "Hata, bitis pozisyon dosya boyutun dan daha fazla." }.Modal();

            exit(17);
        }

        fseek(naji_input, startpos, SEEK_SET);

        for (i=startpos; i<endpos; i++)
            help_edit_box.AddCh(fgetc(naji_input));

        najinclose();
    }

    void copyoffs(char *namein, long startpos, long endpos, char *nameout)
    {
        long filesize=0;
        long i;

        najin(namein);
        najout(nameout);

        filesize=najinsize();

        if (startpos > endpos)
        {
            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI copyoffs error:", contents = "Error, start position cannot be greater than end position." }.Modal();
            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI copyoffs hata:", contents = "Hata, baslangic pozisyon bitis pozisyon dan daha fazla olamaz." }.Modal();

            exit(15);
        }

        if (startpos > filesize)
        {

            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI copyoffs error:", contents = "Error, start position is greater than the file size." }.Modal();
            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI copyoffs hata:", contents = "Hata, baslangic pozisyon dosya boyutun dan daha fazla." }.Modal();

            exit(16);
        }

        if (endpos > filesize)
        {

            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI copyoffs error:", contents = "Error, end position is greater than the file size." }.Modal();
            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI copyoffs hata:", contents = "Hata, bitis pozisyon dosya boyutun dan daha fazla." }.Modal();

            exit(17);
        }

        fseek(naji_input, startpos, SEEK_SET);

        for (i=startpos; i<endpos; i++)
            fputc(fgetc(naji_input), naji_output);

        najinclose();
        najoutclose();
    }

    void dumpoffs(char *namein, long startpos, long endpos)
    {
        long filesize=0;
        long i;

        help_edit_box.Clear();

        najin(namein);

        filesize=najinsize();

        if (startpos > endpos)
        {
            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI dumpoffs error:", contents = "Error, start position cannot be greater than end position." }.Modal();
            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI dumpoffs hata:", contents = "Hata, baslangic pozisyon bitis pozisyon dan daha fazla olamaz." }.Modal();

            exit(15);
        }

        if (startpos > filesize)
        {

            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI dumpoffs error:", contents = "Error, start position is greater than the file size." }.Modal();
            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI dumpoffs hata:", contents = "Hata, baslangic pozisyon dosya boyutun dan daha fazla." }.Modal();

            exit(16);
        }

        if (endpos > filesize)
        {
            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI dumpoffs error:", contents = "Error, end position is greater than the file size." }.Modal();
            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI dumpoffs hata:", contents = "Hata, bitis pozisyon dosya boyutun dan daha fazla." }.Modal();

            exit(17);
        }

        fseek(naji_input, startpos, SEEK_SET);

        for (i=startpos; i<endpos; i++)
            help_edit_box.Printf("%02X ", fgetc(naji_input));

        najinclose();
    }

    void engnum(char *nameout)
    {
        char *units[10] =
        {
            "zero",
            "one",
            "two",
            "three",
            "four",
            "five",
            "six",
            "seven",
            "eight",
            "nine",
        };

        char *teens[10] =
        {
            "ten",
            "eleven",
            "twelve",
            "thirteen",
            "fourteen",
            "fifteen",
            "sixteen",
            "seventeen",
            "eighteen",
            "nineteen",
        };

        char *tens[8] =
        {
            "twenty",
            "thirty",
            "fourty",
            "fifty",
            "sixty",
            "seventy",
            "eighty",
            "ninety"
        };

        int i=0;
        int tens_pos=0;
        int hundreds_pos=0;
        int thousands_pos=0;

        najout(nameout);

        /***/
        for (i=1; i<10; i++)
            fprintf(naji_output, "%s\n", units[i]);

        for (i=0; i<10; i++)
            fprintf(naji_output, "%s\n", teens[i]);

        for (tens_pos=0; tens_pos<8; tens_pos++)
        {

            fprintf(naji_output, "%s\n", tens[tens_pos]);

            for (i=1; i<10; i++)
                fprintf(naji_output, "%s %s\n", tens[tens_pos], units[i]);
        }
        /***/

        /***/

        for (hundreds_pos=1; hundreds_pos<10; hundreds_pos++)
        {

            fprintf(naji_output, "%s hundred\n", units[hundreds_pos]);

            for (i=1; i<10; i++)
                fprintf(naji_output, "%s hundred and %s\n", units[hundreds_pos], units[i]);

            for (i=0; i<10; i++)
                fprintf(naji_output, "%s hundred and %s\n", units[hundreds_pos], teens[i]);

            for (tens_pos=0; tens_pos<8; tens_pos++)
            {

                printf("%s hundred and %s\n", units[hundreds_pos], tens[tens_pos]);

                for (i=1; i<10; i++)
                    fprintf(naji_output, "%s hundred and %s %s\n",
                            units[hundreds_pos], tens[tens_pos], units[i]);
            }

        }

        /***/

        /***/

        for (thousands_pos=1; thousands_pos<10; thousands_pos++)
        {

            fprintf(naji_output, "%s thousand\n", units[thousands_pos]);

            for (i=1; i<10; i++)
                fprintf(naji_output, "%s thousand and %s\n", units[thousands_pos], units[i]);

            for (i=0; i<10; i++)
                fprintf(naji_output, "%s thousand and %s\n", units[thousands_pos], teens[i]);

            for (tens_pos=0; tens_pos<8; tens_pos++)
            {

                fprintf(naji_output, "%s thousand and %s\n", units[thousands_pos], tens[tens_pos]);

                for (i=1; i<10; i++)
                    fprintf(naji_output, "%s thousand and %s %s\n",
                            units[thousands_pos], tens[tens_pos], units[i]);
            }

            for (hundreds_pos=1; hundreds_pos<10; hundreds_pos++)
            {

                fprintf(naji_output, "%s thousand %s hundred\n",
                        units[thousands_pos], units[hundreds_pos]);

                for (i=1; i<10; i++)
                    fprintf(naji_output, "%s thousand %s hundred and %s\n",
                            units[thousands_pos], units[hundreds_pos], units[i]);

                for (i=0; i<10; i++)
                    fprintf(naji_output, "%s thousand %s hundred and %s\n",
                            units[thousands_pos], units[hundreds_pos], teens[i]);

                for (tens_pos=0; tens_pos<8; tens_pos++)
                {

                    fprintf(naji_output, "%s thousand %s hundred and %s\n",
                            units[thousands_pos], units[hundreds_pos], tens[tens_pos]);

                    for (i=1; i<10; i++)
                        fprintf(naji_output, "%s thousand %s hundred and %s %s\n",
                                units[thousands_pos], units[hundreds_pos], tens[tens_pos], units[i]);
                }

            }

        }

        /***/

        najoutclose();
    }

    void turnum(char *nameout)
    {
        char *units[10] =
        {
            "sifir",
            "bir",
            "iki",
            "uc",
            "dort",
            "bes",
            "alti",
            "yedi",
            "sekiz",
            "dokuz",
        };

        char *teens[10] =
        {
            "on",
            "on bir",
            "on iki",
            "on uc",
            "on dort",
            "on bes",
            "on alti",
            "on yedi",
            "on sekiz",
            "on dokuz",
        };

        char *tens[8] =
        {
            "yirmi",
            "otuz",
            "kirk",
            "eli",
            "altmis",
            "yetmis",
            "seksen",
            "doksan"
        };

        int i=0;
        int tens_pos=0;
        int hundreds_pos=0;
        int thousands_pos=0;

        najout(nameout);

        /***/
        for (i=1; i<10; i++)
            fprintf(naji_output, "%s\n", units[i]);

        for (i=0; i<10; i++)
            fprintf(naji_output, "%s\n", teens[i]);

        for (tens_pos=0; tens_pos<8; tens_pos++)
        {

            fprintf(naji_output, "%s\n", tens[tens_pos]);

            for (i=1; i<10; i++)
                fprintf(naji_output, "%s %s\n", tens[tens_pos], units[i]);
        }
        /***/

        /***/

        fprintf(naji_output, "yuz\n");

        for (i=1; i<10; i++)
            fprintf(naji_output, "yuz %s\n", units[i]);

        for (i=0; i<10; i++)
            fprintf(naji_output, "yuz %s\n", teens[i]);

        for (tens_pos=0; tens_pos<8; tens_pos++)
        {

            fprintf(naji_output, "yuz %s\n", tens[tens_pos]);

            for (i=1; i<10; i++)
                fprintf(naji_output, "yuz %s %s\n",
                        tens[tens_pos], units[i]);
        }

        for (hundreds_pos=2; hundreds_pos<10; hundreds_pos++)
        {

            fprintf(naji_output, "%s yuz\n", units[hundreds_pos]);

            for (i=1; i<10; i++)
                fprintf(naji_output, "%s yuz %s\n", units[hundreds_pos], units[i]);

            for (i=0; i<10; i++)
                fprintf(naji_output, "%s yuz %s\n", units[hundreds_pos], teens[i]);

            for (tens_pos=0; tens_pos<8; tens_pos++)
            {

                fprintf(naji_output, "%s yuz %s\n", units[hundreds_pos], tens[tens_pos]);

                for (i=1; i<10; i++)
                    fprintf(naji_output, "%s yuz %s %s\n",
                            units[hundreds_pos], tens[tens_pos], units[i]);
            }

        }

        /***/

        /***/

        fprintf(naji_output, "bin\n");

        for (i=1; i<10; i++)
            fprintf(naji_output, "bin %s\n", units[i]);

        for (i=0; i<10; i++)
            fprintf(naji_output, "bin %s\n", teens[i]);

        for (tens_pos=0; tens_pos<8; tens_pos++)
        {

            fprintf(naji_output, "bin %s\n", tens[tens_pos]);

            for (i=1; i<10; i++)
                fprintf(naji_output, "bin %s %s\n",
                        tens[tens_pos], units[i]);
        }

        fprintf(naji_output, "bin yuz\n");

        for (i=1; i<10; i++)
            fprintf(naji_output, "bin yuz %s\n", units[i]);

        for (i=0; i<10; i++)
            fprintf(naji_output, "bin yuz %s\n", teens[i]);

        for (tens_pos=0; tens_pos<8; tens_pos++)
        {

            fprintf(naji_output, "bin yuz %s\n", tens[tens_pos]);

            for (i=1; i<10; i++)
                fprintf(naji_output, "bin yuz %s %s\n",
                        tens[tens_pos], units[i]);
        }

        for (hundreds_pos=2; hundreds_pos<10; hundreds_pos++)
        {

            fprintf(naji_output, "bin %s yuz\n",
                    units[hundreds_pos]);

            for (i=1; i<10; i++)
                fprintf(naji_output, "bin %s yuz %s\n",
                        units[hundreds_pos], units[i]);

            for (i=0; i<10; i++)
                fprintf(naji_output, "bin %s yuz %s\n",
                        units[hundreds_pos], teens[i]);

            for (tens_pos=0; tens_pos<8; tens_pos++)
            {

                fprintf(naji_output, "bin %s yuz %s\n",
                        units[hundreds_pos], tens[tens_pos]);

                for (i=1; i<10; i++)
                    fprintf(naji_output, "bin %s yuz %s %s\n",
                            units[hundreds_pos], tens[tens_pos], units[i]);
            }

        }

        /***/

        /***/

        for (thousands_pos=2; thousands_pos<10; thousands_pos++)
        {

            fprintf(naji_output, "%s bin\n", units[thousands_pos]);

            for (i=1; i<10; i++)
                fprintf(naji_output, "%s bin %s\n", units[thousands_pos], units[i]);

            for (i=0; i<10; i++)
                fprintf(naji_output, "%s bin %s\n", units[thousands_pos], teens[i]);

            for (tens_pos=0; tens_pos<8; tens_pos++)
            {

                fprintf(naji_output, "%s bin %s\n", units[thousands_pos], tens[tens_pos]);

                for (i=1; i<10; i++)
                    fprintf(naji_output, "%s bin %s %s\n",
                            units[thousands_pos], tens[tens_pos], units[i]);
            }

            fprintf(naji_output, "%s bin yuz\n", units[thousands_pos]);

            for (i=1; i<10; i++)
                fprintf(naji_output, "%s bin yuz %s\n",
                        units[thousands_pos], units[i]);

            for (i=0; i<10; i++)
                fprintf(naji_output, "%s bin yuz %s\n",
                        units[thousands_pos], teens[i]);

            for (tens_pos=0; tens_pos<8; tens_pos++)
            {

                fprintf(naji_output, "%s bin yuz %s\n",
                        units[thousands_pos], tens[tens_pos]);

                for (i=1; i<10; i++)
                    fprintf(naji_output, "%s bin yuz %s %s\n",
                            units[thousands_pos], tens[tens_pos], units[i]);
            }

            for (hundreds_pos=2; hundreds_pos<10; hundreds_pos++)
            {

                fprintf(naji_output, "%s bin %s yuz\n",
                        units[thousands_pos], units[hundreds_pos]);

                for (i=1; i<10; i++)
                    fprintf(naji_output, "%s bin %s yuz %s\n",
                            units[thousands_pos], units[hundreds_pos], units[i]);

                for (i=0; i<10; i++)
                    fprintf(naji_output, "%s bin %s yuz %s\n",
                            units[thousands_pos], units[hundreds_pos], teens[i]);

                for (tens_pos=0; tens_pos<8; tens_pos++)
                {

                    fprintf(naji_output, "%s bin %s yuz %s\n",
                            units[thousands_pos], units[hundreds_pos], tens[tens_pos]);

                    for (i=1; i<10; i++)
                        fprintf(naji_output, "%s bin %s yuz %s %s\n",
                                units[thousands_pos], units[hundreds_pos], tens[tens_pos], units[i]);
                }

            }

        }

        /***/

        najoutclose();

    }

    void bremline(char *str, char *namein, char *nameout)
    {
        char *tempbuf = NULL;

        int len;
        int a = 0;
        int i = 0;
        int cnt = 0;
        int pos = 0;

        len = strlen(str);

        tempbuf = (char *) calloc(len + 1, sizeof (char));

        if (tempbuf == NULL)
        {

            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI bremline error:", contents = "Error, cannot allocate memory." }.Modal();
            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI bremline hata:", contents = "Hata, hafiza ayirilmadi." }.Modal();

            exit(2);
        }

        najin(namein);
        najout(nameout);

        while (1)
        {

            a = fgetc(naji_input);

            if (a == EOF)
            {
                for (i=0; i<cnt ; i++)
                    fputc(tempbuf[i], naji_output);

                fputc('\n', naji_output);
                break;
            }

            if (a == '\n')
            {
                /* Print the temp buffer */
                for (i=0; i<cnt; i++)
                    fputc(tempbuf[i], naji_output);

                fputc('\n', naji_output);

                pos = 0;
                cnt = 0;

                continue;
            }

            tempbuf[pos % len] = (char) a;
            pos++;
            cnt++;

            if (cnt == len)
            {

                if (!isequal(str, tempbuf, len, pos % len))
                {

                    for (i=0; i<cnt; i++)
                        fputc(tempbuf[i], naji_output);

                    /* Print remaing line */
                    while (1)
                    {
                        a = fgetc(naji_input);

                        if (a == EOF || a == '\n')
                            break;

                        fputc(a, naji_output);
                    }

                    fputc('\n', naji_output);
                }

                else
                {

                    /* Skip this line */
                    while (1)
                    {

                        a = fgetc(naji_input);

                        if (a == EOF || a == '\n')
                            break;

                    }

                }

                pos = 0;
                cnt = 0;

            }

        }

        najinclose();
        najoutclose();
    }

    /*
       Memory will be allocated for the line buffer as a block size of 100.
       The number 100 is taken because normally the line size is 80 characters.
       In best case scenario this function will not have to reallocate memory
       for the line. In other cases this function keeps on increasing
       the buffer size by BLOCK_SIZE as and when required.
    */

    void eremline(char *str, char *namein, char *nameout)
    {
        const int BLOCK_SIZE = 100;
        char *line_buf = NULL;

        int cur_buf_size = 0;

        int a;
        int x;
        int i = 0;
        int j = 0;
        int len = 0;
        int buf_len;

        len = strlen(str);

        /*
           Allocate a block of memory for the line buffer.
           This buffer can grow as and when required.
        */

        line_buf = (char *) calloc(BLOCK_SIZE, sizeof(char));

        if (line_buf == NULL)
        {

            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI eremline error:", contents = "Error, cannot allocate memory." }.Modal();
            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI eremline hata:", contents = "Hata, hafiza ayirilmadi." }.Modal();

            exit(2);
        }

        cur_buf_size = BLOCK_SIZE;

        najin(namein);
        najout(nameout);

        while (1)
        {
            a = fgetc(naji_input);

            if (a == '\r')
                a = fgetc(naji_input);

            if (a == '\n' || a == EOF)
            {
                line_buf =
                    addtolinebuf('\0', line_buf, i, &cur_buf_size, BLOCK_SIZE);

                if (line_buf == NULL)
                    break;

                if (strlen(line_buf) < len)
                {
                    fputs(line_buf, naji_output);

                    if (a != EOF)
                        fputc('\n', naji_output);
                }

                else
                {
                    buf_len = strlen(line_buf);

                    j = 0;

                    for (x = (buf_len - len); x < buf_len; x++)
                    {
                        if (line_buf[x] != str[j])
                            break;

                        j++;
                    }

                    if (x == buf_len) { }

                    else
                    {
                        fputs(line_buf, naji_output);

                        if (a != EOF)
                            fputc('\n', naji_output);
                    }
                }

                line_buf[0] = '\0';

                i = 0;

                if (a == EOF)
                    break;

                else continue;
            }

            else
            {
                line_buf =
                    addtolinebuf((char)a, line_buf, i, &cur_buf_size, BLOCK_SIZE);

                if (line_buf == NULL)
                    break;

                i++;
            }
        }

        free(line_buf);
        najinclose();
        najoutclose();
    }

    void remline(char *str, char *namein, char *nameout)
    {
        long pos;
        int i;
        int c;
        char *line;

        najin(namein);
        najout(nameout);

        pos = ftell(naji_input);
        c = fgetc(naji_input);

        /* line by line */
        while (c != EOF)
        {

            for (i=0; (c != EOF) && (c != '\n') && (c != '\0'); i++)
                c = fgetc(naji_input);

            if (i > 0)
            {
                line = (char*) malloc (sizeof(char)*i+1);

                fseek(naji_input, pos, SEEK_SET);
                fgets(line, (i+1), naji_input);

                if (strstr(line, str) == NULL)
                    fprintf(naji_output, "%s\n", line);

                free(line);
            }

            pos = ftell(naji_input);
            c = fgetc(naji_input);
        }

        najinclose();
        najoutclose();
    }

    void najisum(char *namein)
    {
        unsigned long int najisum[256];
        unsigned long int chksum=0;
        unsigned long int filesize=0;
        unsigned long int i=0;

        int a=0;
        int b=0;

        help_edit_box.Clear();

        for (a=0; a<256; a++)
            najisum[a] = 0;

        najin(namein);

        help_edit_box.Printf("Looking at file...\n\n\n");

        while (!(feof(naji_input)))
        {
            i = fgetc(naji_input);
            najisum[i]++;
            chksum = (chksum + (i + 1) );
            filesize++;
        }

        for (a=0; a<256; a++)
        {
            if ((a > 33) && (a < 127))
                help_edit_box.Printf("%c ", a);

            help_edit_box.Printf("%03d: %lu\n", a, najisum[a]);
        }

        help_edit_box.Printf("\n\n\n");

        for (a=0; a<256; a++)
        {
            if ((a > 33) && (a < 127) && (najisum[a] != 0))
                help_edit_box.Printf("%c ", a);

            if (najisum[a] != 0)
                help_edit_box.Printf("%03d: %lu\n", a, najisum[a]);
        }

        help_edit_box.Printf("\n\nnaji checksum (najisum) is the above and the following: ");
        help_edit_box.Printf("%lu:%lu...\n\n", chksum, filesize);
        help_edit_box.Printf("Later versions of najisum should allow you to\n");
        help_edit_box.Printf("recreate the file with the checksum.\n");

        /* todo: make the bbb checksum do a cleverer minus and/or plus system,
           for example instead of -1 -2 -3 -4 -5 it should do -1_5  */

        najinclose();

        help_edit_box.Printf("\n\n\n");
        help_edit_box.Printf("<najisum>\n");
        b=0;

        for (a=0; a<256; a++)
        {

            if (najisum[a] != 0)
            {
                help_edit_box.Printf("%d*%lu + ", a, najisum[a]);
                b++;

                if (b == 8)
                {
                    help_edit_box.Printf("\n");

                    b=0;
                }

            }

        }

        help_edit_box.Printf("=\n%lu:%lu\n", chksum, filesize);

        help_edit_box.Printf("</najisum>\n");
        help_edit_box.Printf("\n\n\n");
    }

    void najitool_gui_genhelp(char *nameout)
    {
        int i;

        najout(nameout);

        if (! strcmp(najitool_language, "English") )
        {

            fprintf(naji_output, "\n\n");

            fprintf(naji_output, "  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n");
            fprintf(naji_output, "  najitool 0.3.0.0 Help Document\n");
            fprintf(naji_output, "  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n\n");

            fprintf(naji_output, "      http://najitool.sf.net/\n\n");

            fprintf(naji_output, "    Written by NECDET COKYAZICI\n\n\n");

            fprintf(naji_output, "-----------------------------------------------------------------------------");

            fprintf(naji_output, "\n%i TOTAL NUMBER OF NAJITOOL COMMANDS:\n", NAJITOOL_MAX_COMMANDS);

            fprintf(naji_output, "-----------------------------------------------------------------------------");

            for (i=0; i<NAJITOOL_MAX_COMMANDS; i++)
            {

                fprintf(naji_output, "\n\n");
                fprintf(naji_output, "COMMAND: %s\n\n",      helpitems[i].cmd);
                fprintf(naji_output, "DESCRIPTION:\n%s\n\n", helpitems[i].help_en);

                fprintf(naji_output, "-----------------------------------------------------------------------------");

            }

        }

        else if (! strcmp(najitool_language, "Turkish") )
        {

            fprintf(naji_output, "\n\n");

            fprintf(naji_output, "  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n");
            fprintf(naji_output, "  najitool GUI 0.3.0.0 Yardim Belge\n");
            fprintf(naji_output, "  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n\n");

            fprintf(naji_output, "      http://najitool.sf.net/\n\n");

            fprintf(naji_output, "    Belge Yazan NECDET COKYAZICI\n\n\n");

            fprintf(naji_output, "-----------------------------------------------------------------------------");

            fprintf(naji_output, "\nTOPLAM KOMUTLAR SAYISI %i:\n", NAJITOOL_MAX_COMMANDS);

            fprintf(naji_output, "-----------------------------------------------------------------------------");

            for (i=0; i<NAJITOOL_MAX_COMMANDS; i++)
            {

                fprintf(naji_output, "\n\n");
                fprintf(naji_output, "KOMUT: %s\n\n",      helpitems[i].cmd);
                fprintf(naji_output, "TANIM:\n%s\n\n", helpitems[i].help_tr);

                fprintf(naji_output, "-----------------------------------------------------------------------------");

            }

        }

        najoutclose();

    }

    void najitool_gui_generate_htmlhelp(char *nameout)
    {
        int i;
        int j;

        najout(nameout);

        if (! strcmp(najitool_language, "English") )
        {

            fprintf(naji_output, "<html>\n\n");

            fprintf(naji_output, "<head> <title>najitool GUI 0.3.0.0 Help Document</title> </head>\n\n");

            fprintf(naji_output, "<body>\n\n");

            fprintf(naji_output, "\n\n");

            fprintf(naji_output, "<center>\n\n");

            fprintf(naji_output, "<h2>najitool GUI 0.3.0.0 Help Document</h2><p>\n\n");

            fprintf(naji_output, "<a href=\"http://najitool.sf.net/\">http://najitool.sf.net/</a><p>\n\n");

            fprintf(naji_output, "<b>Written by NECDET COKYAZICI</b><br><p>\n\n\n");

            fprintf(naji_output, "</center>\n\n");

            fprintf(naji_output, "\n<hr>\n");

            fprintf(naji_output, "<b>%i TOTAL NUMBER OF NAJITOOL COMMANDS:</b><br>\n", NAJITOOL_MAX_COMMANDS);

            fprintf(naji_output, "\n<hr>\n");

            for (i=0; i<NAJITOOL_MAX_COMMANDS; i++)
            {

                fprintf(naji_output, "\n\n<p>");

                fprintf(naji_output, "<b>COMMAND:</b> %s\n\n<p>",        helpitems[i].cmd);

                fprintf(naji_output, "<b>DESCRIPTION:</b><br>\n");

                for (j=0; helpitems[i].help_en[j] != '\0'; j++)
                {

                    if (helpitems[i].help_en[j] == '\n')
                        fprintf(naji_output, "\n<br>");

                    else if (helpitems[i].help_en[j] == '<')
                        fprintf(naji_output, "&lt;");

                    else if (helpitems[i].help_en[j] == '>')
                        fprintf(naji_output, "&gt;");

                    else fputc(helpitems[i].help_en[j], naji_output);
                }

                fprintf(naji_output, "\n\n<p>");

                fprintf(naji_output, "\n<hr>\n");

            }

            fprintf(naji_output, "\n\n</body>\n\n");

            fprintf(naji_output, "</html>\n\n");

        }

        else if (! strcmp(najitool_language, "Turkish") )
        {

            fprintf(naji_output, "<html>\n\n");

            fprintf(naji_output, "<head> <title>najitool GUI 0.3.0.0 Yardim Belge</title> </head>\n\n");

            fprintf(naji_output, "<body>\n\n");

            fprintf(naji_output, "\n\n");

            fprintf(naji_output, "<center>\n\n");

            fprintf(naji_output, "<h2>najitool GUI 0.3.0.0 Yardim Belge</h2><p>\n\n");

            fprintf(naji_output, "<a href=\"http://najitool.sf.net/\">http://najitool.sf.net/</a><p>\n\n");

            fprintf(naji_output, "<b>Belge Yazan NECDET COKYAZICI</b><br><p>\n\n\n");

            fprintf(naji_output, "</center>\n\n");

            fprintf(naji_output, "\n<hr>\n");

            fprintf(naji_output, "<b>TOPLAM KOMUTLAR SAYISI %i:</b><br>\n", NAJITOOL_MAX_COMMANDS);

            fprintf(naji_output, "\n<hr>\n");

            for (i=0; i<NAJITOOL_MAX_COMMANDS; i++)
            {

                fprintf(naji_output, "\n\n<p>");

                fprintf(naji_output, "<b>KOMUT:</b> %s\n\n<p>",        helpitems[i].cmd);

                fprintf(naji_output, "<b>TANIM:</b><br>\n");

                for (j=0; helpitems[i].help_tr[j] != '\0'; j++)
                {

                    if (helpitems[i].help_tr[j] == '\n')
                        fprintf(naji_output, "\n<br>");

                    else if (helpitems[i].help_tr[j] == '<')
                        fprintf(naji_output, "&lt;");

                    else if (helpitems[i].help_tr[j] == '>')
                        fprintf(naji_output, "&gt;");

                    else fputc(helpitems[i].help_tr[j], naji_output);
                }

                fprintf(naji_output, "\n\n<p>");

                fprintf(naji_output, "\n<hr>\n");

            }

            fprintf(naji_output, "\n\n</body>\n\n");

            fprintf(naji_output, "</html>\n\n");

        }

        najoutclose();

    }

    void gplus(char *nameout, int start, int end)
    {
        int x;
        int y;

        if (start > end)

        {

            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI gplus error",
                             contents =  "ERROR: start value cannot be greater than end value."
                           }.Modal();

            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI gplus hata",
                             contents =  "HATA: baslangic degeri bitis degerin den daha fazla olamaz."
                           }.Modal();

            return;
        }

        najout(nameout);

        for (x=start; x<=end; x++)
            for (y=start; y<=end; y++)
                fprintf(naji_output, "%d + %d = %d\n", x, y, (x + y));

        najoutclose();
    }

    void gminus(char *nameout, int start, int end)
    {
        int x;
        int y;

        if (start > end)
        {
            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI gminus error",
                             contents =  "ERROR: start value cannot be greater than end value."
                           }.Modal();

            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI gminus hata",
                             contents =  "HATA: baslangic degeri bitis degerin den daha fazla olamaz."
                           }.Modal();

            return;
        }

        najout(nameout);

        for (x=start; x<=end; x++)
            for (y=start; y<=end; y++)
                fprintf(naji_output, "%d - %d = %d\n", x, y, (x - y));

        najoutclose();

    }

    void gtimes(char *nameout, int start, int end)
    {
        int x;
        int y;

        if (start > end)
        {

            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI gtimes error",
                             contents =  "ERROR: start value cannot be greater than end value."
                           }.Modal();

            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI gtimes hata",
                             contents =  "HATA: baslangic degeri bitis degerin den daha fazla olamaz."
                           }.Modal();

            return;
        }

        najout(nameout);

        for (x=start; x<=end; x++)
            for (y=start; y<=end; y++)
                fprintf(naji_output, "%d x %d = %d\n", x, y, (x * y));

        najoutclose();

    }

    void gdivide(char *nameout, float start, float end)
    {
        float x;
        float y;

        if ( (start == 0) ||  (end == 0) )
        {
            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI gdivide error", contents =  "ERROR: cannot divide by zero." }.Modal();
            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI gdivide hata", contents =  "HATA: sifir ile bolunmez." }.Modal();

            return;
        }

        if (start > end)
        {

            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI gdivide error",
                             contents =  "ERROR: start value cannot be greater than end value."
                           }.Modal();

            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI gdivide hata",
                             contents =  "HATA: baslangic degeri bitis degerin den daha fazla olamaz."
                           }.Modal();

            return;
        }

        najout(nameout);

        for (x=start; x<=end; x++)
            for (y=start; y<=end; y++)
                fprintf(naji_output, "%f / %f = %f\n", x, y, (x / y));

        najoutclose();
    }

    void hmaker(char *namein)
    {
        char buffer[402];

        help_edit_box.Clear();

        najin(namein);

        while (1)
        {

            fgets(buffer, 400, naji_input);

            if (feof(naji_input))
                break;

            if (!strncmp("int", buffer, 3))       help_edit_box.Printf(buffer);

            if (!strncmp("FILE", buffer, 4))      help_edit_box.Printf(buffer);
            if (!strncmp("void", buffer, 4))      help_edit_box.Printf(buffer);
            if (!strncmp("char", buffer, 4))      help_edit_box.Printf(buffer);
            if (!strncmp("long", buffer, 4))      help_edit_box.Printf(buffer);
            if (!strncmp("uint", buffer, 4))      help_edit_box.Printf(buffer);
            if (!strncmp("UINT", buffer, 4))      help_edit_box.Printf(buffer);
            if (!strncmp("auto", buffer, 4))      help_edit_box.Printf(buffer);

            if (!strncmp("uchar", buffer, 5))     help_edit_box.Printf(buffer);
            if (!strncmp("ulong", buffer, 5))     help_edit_box.Printf(buffer);
            if (!strncmp("UCHAR", buffer, 5))     help_edit_box.Printf(buffer);
            if (!strncmp("ULONG", buffer, 5))     help_edit_box.Printf(buffer);
            if (!strncmp("short", buffer, 5))     help_edit_box.Printf(buffer);
            if (!strncmp("float", buffer, 5))     help_edit_box.Printf(buffer);
            if (!strncmp("class", buffer, 5))     help_edit_box.Printf(buffer);
            if (!strncmp("union", buffer, 5))     help_edit_box.Printf(buffer);
            if (!strncmp("const", buffer, 5))     help_edit_box.Printf(buffer);

            if (!strncmp("double", buffer, 6))    help_edit_box.Printf(buffer);
            if (!strncmp("struct", buffer, 6))    help_edit_box.Printf(buffer);
            if (!strncmp("signed", buffer, 6))    help_edit_box.Printf(buffer);
            if (!strncmp("static", buffer, 6))    help_edit_box.Printf(buffer);
            if (!strncmp("extern", buffer, 6))    help_edit_box.Printf(buffer);
            if (!strncmp("size_t", buffer, 6))    help_edit_box.Printf(buffer);
            if (!strncmp("time_t", buffer, 6))    help_edit_box.Printf(buffer);

            if (!strncmp("wchar_t", buffer, 7))   help_edit_box.Printf(buffer);
            if (!strncmp("typedef", buffer, 7))   help_edit_box.Printf(buffer);

            if (!strncmp("unsigned", buffer, 8))  help_edit_box.Printf(buffer);
            if (!strncmp("register", buffer, 8))  help_edit_box.Printf(buffer);
            if (!strncmp("volatile", buffer, 8))  help_edit_box.Printf(buffer);
            if (!strncmp("#include", buffer, 8))  help_edit_box.Printf(buffer);
        }

        najinclose();
    }

    void rcharvar(char *str)
    {
        int c;
        int x;
        int y;
        int z;
        int cvlen;
        char *cva;
        char *cvb;

        help_edit_box.Clear();

        cvlen = strlen(str);

        c = cvlen-1;

        cva = newchar(cvlen);
        cvb = newchar(cvlen);
        exitnull(cva);
        exitnull(cvb);

        strcpy(cva, str);

        for (x=0; x<cvlen; x++)
            cvb[x]=(char)cvlen-(char)x;

        for (z=0; z<cvlen; z++)
            help_edit_box.AddCh(cva[z]);

        help_edit_box.AddCh('\n');

        x=c;

        while (x > 0)
        {
            cvb[x]--;
            x--;
            y=c;

            while (y > x)
            {
                swap_char(cva[x], cva[y]);
                y--;
                x++;
            }

            for (z=0; z<cvlen; z++)
                help_edit_box.AddCh(cva[z]);

            help_edit_box.AddCh('\n');

            x=c;

            while (cvb[x] == 0)
            {
                cvb[x] = (char) cvlen-(char)x;
                x--;
            }
        }
    }

    void lcharvar(char *str)
    {
        int x;
        int y;
        int z;
        int cvlen;
        char *cva;
        char *cvb;

        help_edit_box.Clear();

        cvlen = strlen(str);

        cva = newchar(cvlen);
        cvb = newchar(cvlen);
        exitnull(cva);
        exitnull(cvb);

        strcpy(cva, str);

        for (x=0; x<cvlen; x++)
            cvb[x] = (char)x;

        cvb[cvlen] = (char)cvlen;

        for (z=0; z<cvlen; z++)
            help_edit_box.AddCh(cva[z]);

        help_edit_box.AddCh('\n');

        x=1;

        while (x < cvlen)
        {
            cvb[x]--;
            y=0;

            while (y < x)
            {
                swap_char(cva[x], cva[y]);
                y++;
                x--;
            }

            for (z=0; z<cvlen; z++)
                help_edit_box.AddCh(cva[z]);

            help_edit_box.AddCh('\n');

            x=1;

            while (cvb[x] == 0)
            {
                cvb[x]=(char)x;
                x++;
            }

        }

    }

    void elite_char_print(char a)
    {
        char b = a;

        naji_tolower(b);

        if (b == 'a')
        {
            help_edit_box.Printf("4");
            return;
        }
        if (b == 'b')
        {
            help_edit_box.Printf("8");
            return;
        }
        if (b == 'e')
        {
            help_edit_box.Printf("3");
            return;
        }
        if (b == 'i')
        {
            help_edit_box.Printf("1");
            return;
        }
        if (b == 'o')
        {
            help_edit_box.Printf("0");
            return;
        }
        if (b == 's')
        {
            help_edit_box.Printf("5");
            return;
        }
        if (b == 't')
        {
            help_edit_box.Printf("7");
            return;
        }
        if (b == 'd')
        {
            help_edit_box.Printf("|>");
            return;
        }
        if (b == 'c')
        {
            help_edit_box.Printf("<");
            return;
        }
        if (b == 'k')
        {
            help_edit_box.Printf("|<");
            return;
        }
        if (b == 'm')
        {
            help_edit_box.Printf("/\\/\\");
            return;
        }
        if (b == 'v')
        {
            help_edit_box.Printf("\\/");
            return;
        }
        if (b == 'w')
        {
            help_edit_box.Printf("\\/\\/");
            return;
        }
        if (b == 'h')
        {
            help_edit_box.Printf("|-|");
            return;
        }
        if (b == 'n')
        {
            help_edit_box.Printf("|\\|");
            return;
        }
        if (b == 'x')
        {
            help_edit_box.Printf("><");
            return;
        }
        if (b == 'u')
        {
            help_edit_box.Printf("|_|");
            return;
        }
        if (b == 'l')
        {
            help_edit_box.Printf("|_");
            return;
        }
        if (b == 'j')
        {
            help_edit_box.Printf("_|");
            return;
        }

        help_edit_box.AddCh(a);
    }

    void leetstr(char *string)
    {
        int i;

        help_edit_box.Clear();

        for (i=0; string[i] != 0; i++)
            elite_char_print(string[i]);

    }

    void mp3info_gui(char *namein)
    {
        help_edit_box.Clear();
        help_edit_box.Printf("%s", mp3info(namein));
    }

    char fnamebuf[100];

    void naji_unicode_html_header(int n)
    {
        int i;

        fprintf(naji_output,"<html><head><title>Unicode Symbols Page %i - generated with najitool, courtesy of NECDET COKYAZICI</title></head><body>", n);
        fprintf(naji_output,"<hr>Courtesy of NECDET COKYAZICI, the programmer of najitool<br>");
        fprintf(naji_output,"<p> These HTML pages with every possible Unicode letter/symbol <br> were generated with <b> najitool </b> ");
        fprintf(naji_output," with the command: <p> <i> najitool unihtml </i> <p>");

        fprintf(naji_output,"You can get <b> najitool </b> the completely free tool at: <br> ");
        fprintf(naji_output,"<b> <a href=\"http://najitool.sf.net/\"> http://najitool.sf.net/ </a></b><hr><p>");

        fprintf(naji_output,"<p>The numbers near the Unicode letter/symbol <br>");
        fprintf(naji_output, "are here for you to use in your HTML pages. <br>");

        fprintf(naji_output,"Just open your HTML page with a normal text editor, <br>");
        fprintf(naji_output,"like vi or notepad, and put &#38;&#35;unicode number here&#59 <br>");
        fprintf(naji_output," for example &#38;&#35;1586&#59 which appears as &#1587; an Arabic letter. <p><hr>");

        fprintf(naji_output, "Generated Pages: ");

        for (i=1; i<=61; i++)
        {
            if (i == 10) fprintf(naji_output, "<br>");
            if (i == 30) fprintf(naji_output, "<br>");
            if (i == 50) fprintf(naji_output, "<br>");
            fprintf(naji_output, "<a href=\"ucode%02i.htm\">%i</a> ", i, i);
        }

        fprintf(naji_output, "<p><hr>");

    }

    void naji_unicode_html_end(void)
    {
        int i;

        fprintf(naji_output, "<p><hr>");

        fprintf(naji_output, "Generated Pages: ");

        for (i=1; i<=61; i++)
        {
            if (i == 10) fprintf(naji_output, "<br>");
            if (i == 30) fprintf(naji_output, "<br>");
            if (i == 50) fprintf(naji_output, "<br>");
            fprintf(naji_output, "<a href=\"ucode%02i.htm\">%i</a> ", i, i);
        }

        fprintf(naji_output, "<p><hr>");
        fprintf(naji_output, "</body></html>");

    }

    /* mass deleter of the files it generates */
    /* please be careful when using it and */
    /* please dont abuse this system */

    void naji_del_gen_unicode_html_pages(char *output_folder)
    {
        int i;
        int delete_errors=0;

        for (i=1; i<=99; i++)
        {

            sprintf(fnamebuf, "%s/ucode%02i.htm", i, output_folder);

            if (remove(fnamebuf) < 0)
            {
                help_edit_box.Printf("Error deleting file %s: %s", fnamebuf, strerror(errno));
                delete_errors++;
            }
            else
                help_edit_box.Printf("Deleted file %s\n", fnamebuf);

        }

        exit(delete_errors);
    }

    void naji_gen_unicode_html_pages(char *output_folder)
    {
        int i = 0;
        int unicode_max = 0xFFFF;  /* max is 65535 - 0xFFFF */
        int unicode_min = 0;
        int unicode_last = 60000;

        int addby=1000;

        int x = unicode_min;
        int y = addby;

        int n = 1;

        /* todo: arab2uni */

        while (1)
        {

            if (y > unicode_last) break;

            sprintf(fnamebuf, "%s/ucode%02i.htm", n, output_folder);
            najout(fnamebuf);

            naji_unicode_html_header(n);

            for (i=x; i<y; i++)
                fprintf(naji_output, "&#%i; %i<p>", i, i);

            naji_unicode_html_end();
            najoutclose();
            n++;

            x+=addby;

            y+=addby;
        }

        sprintf(fnamebuf, "%s/ucode%02i.htm", n, output_folder);
        najout(fnamebuf);

        naji_unicode_html_header(n);

        for (i=x; i<=unicode_max; i++)
            fprintf(naji_output, "&#%i; %i<p>", i, i);

        naji_unicode_html_end();
        najoutclose();

    }

    /* puts vowels inbetween every letter of a word except the first and last letter */

    void vowelwrd(char *str)
    {

        int len = 0;
        int i = 0;

        len = strlen(str);

        for (i=0; i<len-1; i++)
        {
            help_edit_box.Printf("%c", str[i]);
            help_edit_box.Printf("a");
        }
        help_edit_box.Printf("%c\n", str[len-1]);

        for (i=0; i<len-1; i++)
        {
            help_edit_box.Printf("%c", str[i]);
            help_edit_box.Printf("e");
        }
        help_edit_box.Printf("%c\n", str[len-1]);

        for (i=0; i<len-1; i++)
        {
            help_edit_box.Printf("%c", str[i]);
            help_edit_box.Printf("i");
        }
        help_edit_box.Printf("%c\n", str[len-1]);

        for (i=0; i<len-1; i++)
        {
            help_edit_box.Printf("%c", str[i]);
            help_edit_box.Printf("o");
        }
        help_edit_box.Printf("%c\n", str[len-1]);

        for (i=0; i<len-1; i++)
        {
            help_edit_box.Printf("%c", str[i]);
            help_edit_box.Printf("u");
        }
        help_edit_box.Printf("%c\n", str[len-1]);

    }

    void tothe(char *str)
    {
        int i;
        int l;

        help_edit_box.Clear();

        l = strlen(str);

        for (i=0; i<(l-1); i++)
        {
            help_edit_box.Printf("%c to the", str[i]);

            if (i == (l-1) )
                break;

            help_edit_box.AddCh(' ');

        }

        help_edit_box.AddCh(str[l-1]);

    }
}
