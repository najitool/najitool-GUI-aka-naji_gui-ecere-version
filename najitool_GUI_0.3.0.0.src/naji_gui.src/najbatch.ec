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

class tab_batch : Tab
{
    text = "Batch";
    font = { "Verdana", 8.25f, bold = true };
    size = { 1280, 1024 };
    background = { r = 110, g = 161, b = 180 };

    char add_file_path[MAX_LOCATION];
    char add_folder_path[MAX_LOCATION];
    char output_folder_path[MAX_LOCATION];
    char processing_output_file_path[4096];
    char naji_buffer[4096];
    char parameter_1_string[4096];
    char parameter_2_string[4096];
    char najitool_command[4096];
    char najitool_category[4096];
    int batchfilenumber;
    int batchfilemaxitems;
    char tempbuffer[MAX_LOCATION];
    char temp_path[MAX_LOCATION];
    char temp_filename[MAX_LOCATION];
    char temp_filename_no_extension[MAX_LOCATION];
    char temp_extension[MAX_LOCATION];
    char newfileprefix[4096];
    char newfilesuffix[4096];
    char newfileextrax[4096];
    char temp_edit_delete[MAX_LOCATION+4096];
    int temp_len;
    temp_len = 0;

    najitool_languages lang;
    batchfilenumber=0;
    batchfilemaxitems=0;

    DataRow row;

    void addfilestolistbox(char * path, ListBox listbox)
    {
        FileListing listing { path };

        while (listing.Find())
        {
            if (listing.stats.attribs.isDirectory)
                addfilestolistbox(listing.path, listbox);

            else
            {
                listbox.AddString(listing.path);

                batchfilemaxitems++;
            }
        }

    }

    EditBox new_files_extra_extension_edit_box { this, text = "new_files_extra_extension_edit_box", size = { 94, 19 }, position = { 896, 400 } };
    Label help_label { this, text = "Help/Output:", size = { 89, 16 }, position = { 288, 680 } };
    Label najitool_homepage_label
    {
        this, text = "http://najitool.sf.net/", foreground = blue, font = { "Verdana", 8.25f, bold = true, underline = true }, position = { 16, 8 }, cursor = ((GuiApplication)__thisModule).GetCursor(hand);

        bool OnLeftButtonDown(int x, int y, Modifiers mods)
        {

            ShellOpen("http://najitool.sf.net/");

            return Label::OnLeftButtonDown(x, y, mods);
        }
    };
    Label command_label { this, text = "Command:", position = { 8, 264 } };
    Label category_label { this, text = "Category:", position = { 8, 216 } };
    Button credits_button
    {
        this, text = "Credits", size = { 75, 25 }, position = { 832, 672 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            najitool_gui_credits();
            return true;
        }
    };
    Button license_button
    {
        this, text = "License", size = { 75, 25 }, position = { 744, 672 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            najitool_gui_license();

            return true;
        }
    };
    Button close_button
    {
        this, text = "Close", size = { 75, 25 }, position = { 920, 672 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            exit(0);
            return true;
        }
    };
    Button add_file_button
    {
        this, text = "Add File:", size = { 106, 20 }, position = { 288, 328 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            if (add_file_dialog.Modal() == ok)
            {
                strcpy(add_file_path, add_file_dialog.filePath);

                if ((FileExists(add_file_path).isDirectory == false) && (FileExists(add_file_path).isFile == true))
                {
                    add_file_edit_box.contents = add_file_dialog.filePath;

                    if (!strcmp(najitool_language, "English"))
                        sprintf(tempbuffer, "%i files in list.", batchfilemaxitems+1);

                    else if (!strcmp(najitool_language, "Turkish"))
                        sprintf(tempbuffer, "%i dosyalar listede.", batchfilemaxitems+1);

                    msgbox(tempbuffer, tempbuffer);

                    najbatch_list_box.AddString(add_file_edit_box.contents);

                    batchfilemaxitems++;
                }
            }
            return true;
        }
    };
    ListBox najbatch_list_box
    {
        this, text = "najbatch_list_box", size = { 702, 314 }, position = { 288, 8 }, dontHideScroll = true, hasHorzScroll = true, hasVertScroll = true, resizable = true, firstField.width = MAX_LOCATION + MAX_LOCATION / 2;

        bool NotifySelect(ListBox listBox, DataRow row, Modifiers mods)
        {

            return true;
        }
    };
    Button add_folder_button
    {
        this, text = "Add Folder:", size = { 106, 20 }, position = { 288, 352 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            add_folder_dialog.type=selectDir;

            if (add_folder_dialog.Modal() == ok)
            {
                strcpy(add_folder_path, add_folder_dialog.filePath);
                add_folder_edit_box.contents = add_folder_dialog.filePath;

                addfilestolistbox(add_folder_path, najbatch_list_box);

                if (!strcmp(najitool_language, "English"))
                    sprintf(tempbuffer, "%i files in list.", batchfilemaxitems+1);

                else if (!strcmp(najitool_language, "Turkish"))
                    sprintf(tempbuffer, "%i dosyalar listede.", batchfilemaxitems+1);

                msgbox(tempbuffer, tempbuffer);
            }
            return true;
        }
    };
    Button output_folder_radio
    {
        this, text = "Output Folder:", size = { 119, 15 }, position = { 464, 376 }, isRadio = true;

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
    EditBox add_file_edit_box
    {
        this, text = "add_file_edit_box", size = { 598, 19 }, position = { 392, 328 }, readOnly = true, maxNumLines = 1;

        bool NotifyModified(EditBox editBox)
        {
            strcpy(add_file_path, add_file_edit_box.contents);

            return true;
        }
    };
    EditBox add_folder_edit_box
    {
        this, text = "add_folder_edit_box", size = { 598, 19 }, position = { 392, 352 }, readOnly = true, maxNumLines = 1;

        bool NotifyModified(EditBox editBox)
        {

            strcpy(add_folder_path, add_folder_edit_box.contents);

            return true;
        }
    };
    EditBox output_folder_edit_box
    {
        this, text = "output_folder_edit_box", size = { 238, 19 }, position = { 592, 376 }, maxNumLines = 1;

        bool NotifyModified(EditBox editBox)
        {
            strcpy(output_folder_path, output_folder_edit_box.contents);
            return true;
        }
    };
    Button remake_folder_tree_check_box { this, text = "Remake Folder Tree", background = white, position = { 840, 376 }, isCheckbox = true };
    EditBox new_files_prefix_edit_box { this, text = "new_files_prefix_edit_box", size = { 94, 19 }, position = { 400, 400 } };
    Label new_files_prefix_label { this, text = "New Files Prefix:", position = { 288, 400 } };
    EditBox new_files_suffix_edit_box { this, text = "new_files_suffix_edit_box", size = { 94, 19 }, position = { 616, 400 } };
    Label new_files_extra_extension_label { this, text = "New Files Extra Extension:", position = { 720, 400 } };
    Label new_files_suffix_label { this, text = "New Files Suffix:", position = { 504, 400 } };
    Button same_folder_as_files_radio { this, text = "Same Folder As Files", size = { 167, 15 }, position = { 288, 376 }, isRadio = true };
    EditBox parameter_1_edit_box
    {
        this, text = "parameter_1_edit_box", size = { 350, 19 }, position = { 288, 448 }, maxNumLines = 1;

        bool NotifyModified(EditBox editBox)
        {

            strcpy(parameter_1_string, parameter_1_edit_box.contents);

            return true;
        }
    };
    EditBox parameter_2_edit_box
    {
        this, text = "parameter_2_edit_box", size = { 350, 19 }, position = { 640, 448 }, maxNumLines = 1;

        bool NotifyModified(EditBox editBox)
        {

            strcpy(parameter_2_string, parameter_2_edit_box.contents);

            return true;
        }
    };
    Label parameter_2_label
    {
        this, text = "Parameter 2:", position = { 640, 424 };

        bool NotifyActivate(Window window, bool active, Window previous)
        {

            return true;
        }
    };
    Label parameter_1_label
    {
        this, text = "Parameter 1:", position = { 288, 432 };

        bool NotifyActivate(Window window, bool active, Window previous)
        {

            return true;
        }
    };

    bool OnCreate(void)
    {
        int i;

        same_folder_as_files_radio.checked=true;
        output_folder_radio.checked=false;

        new_files_extra_extension_edit_box.contents = ".naji";

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
    }
    EditBox help_edit_box
    {
        this, text = "help_edit_box", font = { "Courier New", 8 }, size = { 702, 198 }, position = { 288, 472 }, hasHorzScroll = true, true, true, true, true, readOnly = true, true, noCaret = true
                                         };
    Button process_button
    {
        this, text = "Process", size = { 80, 25 }, position = { 648, 672 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            if (!strcmp(najitool_command, "(none)"))
            {

                if (!strcmp(najitool_language, "English"))
                    MessageBox { text = "najitool GUI", contents = "Please select a command." }.Modal();

                else if (!strcmp(najitool_language, "Turkish"))
                    MessageBox { text = "najitool GUI", contents = "Lutfen bir komut secin." }.Modal();

                return true;
            }

            strcpy(newfileprefix, new_files_prefix_edit_box.contents);
            strcpy(newfilesuffix, new_files_suffix_edit_box.contents);
            strcpy(newfileextrax, new_files_extra_extension_edit_box.contents);

            row = najbatch_list_box.firstRow;

            if (row == null)
            {

                if (!strcmp(najitool_language, "English"))
                    MessageBox { text = "najitool GUI", contents = "Please add files and/or folders to process." }.Modal();

                else if (!strcmp(najitool_language, "Turkish"))
                    MessageBox { text = "najitool GUI", contents = "Lutfen dosyalar veya klasorler secin islem icin." }.Modal();

                return true;
            }

            for (; row; row = row.next)
            {

                if (same_folder_as_files_radio.checked == true)
                {

                    strcpy(tempbuffer, row.string);

                    StripLastDirectory(tempbuffer, temp_path);

                    strcpy(tempbuffer, row.string);
                    GetLastDirectory(tempbuffer, temp_filename);

                    strcpy(tempbuffer, temp_filename);

                    strcpy(temp_filename_no_extension, tempbuffer);
                    StripExtension(temp_filename_no_extension);

                    GetExtension(temp_filename, temp_extension);
                }

                else if (output_folder_radio.checked == true)
                {

                    if (!strcmp(output_folder_edit_box.contents, ""))
                    {
                        msgbox("najitool GUI batch mode error:", "Please select an \"Output Folder\" or select \"Same Folder As Files\".");
                        return true;
                    }

                    strcpy(temp_path, output_folder_edit_box.contents);

                    strcpy(tempbuffer, row.string);
                    GetLastDirectory(tempbuffer, temp_filename);

                    strcpy(tempbuffer, temp_filename);

                    strcpy(temp_filename_no_extension, tempbuffer);
                    StripExtension(temp_filename_no_extension);

                    GetExtension(temp_filename, temp_extension);
                }

                if (!strcmp(newfileprefix, "") &&
                        !strcmp(newfilesuffix, "") &&
                        !strcmp(newfileextrax, ""))
                {
                    msgbox("najitool GUI batch mode error:",
                           "Error, new files must contain either a prefix, suffix, or extra extension.");
                    return true;
                }

                memset(processing_output_file_path, '\0', 4096);

                if (strcmp(newfileprefix, "") &&
                        strcmp(newfilesuffix, "") &&
                        strcmp(newfileextrax, ""))
                {
                    strcat(processing_output_file_path, temp_path);
                    strcat(processing_output_file_path, DIR_SEPS);
                    strcat(processing_output_file_path, newfileprefix);
                    strcat(processing_output_file_path, temp_filename_no_extension);
                    strcat(processing_output_file_path, newfilesuffix);
                    strcat(processing_output_file_path, ".");
                    strcat(processing_output_file_path, temp_extension);
                    strcat(processing_output_file_path, newfileextrax);
                }

                if (!strcmp(newfileprefix, "") &&
                        strcmp(newfilesuffix, "") &&
                        strcmp(newfileextrax, ""))
                {
                    strcat(processing_output_file_path, temp_path);
                    strcat(processing_output_file_path, DIR_SEPS);
                    strcat(processing_output_file_path, temp_filename_no_extension);
                    strcat(processing_output_file_path, newfilesuffix);
                    strcat(processing_output_file_path, ".");
                    strcat(processing_output_file_path, temp_extension);
                    strcat(processing_output_file_path, newfileextrax);
                }

                if (strcmp(newfileprefix, "") &&
                        !strcmp(newfilesuffix, "") &&
                        strcmp(newfileextrax, ""))
                {
                    strcat(processing_output_file_path, temp_path);
                    strcat(processing_output_file_path, DIR_SEPS);
                    strcat(processing_output_file_path, newfileprefix);
                    strcat(processing_output_file_path, temp_filename_no_extension);
                    strcat(processing_output_file_path, ".");
                    strcat(processing_output_file_path, temp_extension);
                    strcat(processing_output_file_path, newfileextrax);
                }

                if (!strcmp(newfileprefix, "") &&
                        !strcmp(newfilesuffix, "") &&
                        strcmp(newfileextrax, ""))
                {
                    strcat(processing_output_file_path, temp_path);
                    strcat(processing_output_file_path, DIR_SEPS);
                    strcat(processing_output_file_path, temp_filename_no_extension);
                    strcat(processing_output_file_path, ".");
                    strcat(processing_output_file_path, temp_extension);
                    strcat(processing_output_file_path, newfileextrax);
                }

                if (strcmp(newfileprefix, "") &&
                        strcmp(newfilesuffix, "") &&
                        !strcmp(newfileextrax, ""))
                {
                    strcat(processing_output_file_path, temp_path);
                    strcat(processing_output_file_path, DIR_SEPS);
                    strcat(processing_output_file_path, newfileprefix);
                    strcat(processing_output_file_path, temp_filename_no_extension);
                    strcat(processing_output_file_path, newfilesuffix);
                    strcat(processing_output_file_path, ".");
                    strcat(processing_output_file_path, temp_extension);
                }

                if (!strcmp(newfileprefix, "") &&
                        strcmp(newfilesuffix, "") &&
                        !strcmp(newfileextrax, ""))
                {
                    strcat(processing_output_file_path, temp_path);
                    strcat(processing_output_file_path, DIR_SEPS);
                    strcat(processing_output_file_path, temp_filename_no_extension);
                    strcat(processing_output_file_path, newfilesuffix);
                    strcat(processing_output_file_path, ".");
                    strcat(processing_output_file_path, temp_extension);
                }

                if (strcmp(newfileprefix, "") &&
                        !strcmp(newfilesuffix, "") &&
                        !strcmp(newfileextrax, ""))
                {
                    strcat(processing_output_file_path, temp_path);
                    strcat(processing_output_file_path, DIR_SEPS);
                    strcat(processing_output_file_path, newfileprefix);
                    strcat(processing_output_file_path, temp_filename_no_extension);
                    strcat(processing_output_file_path, ".");
                    strcat(processing_output_file_path, temp_extension);
                }

                //msgbox(processing_output_file_path, processing_output_file_path);
                //help_edit_box.AddS(processing_output_file_path);

                else if (! strcmp(najitool_command, "8bit256") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "addim") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "allfiles") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "allbmp16") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "arab2eng") )
                    arab2eng(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "asc2ebc") )
                    asc2ebc(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "asctable") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "ay") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "ayinkaci") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "bigascif") )
                {
                    notbatch();
                    return true;
                }
                else if (! strcmp(najitool_command, "bigascii") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "bin2c") )
                    bin2c(row.string, processing_output_file_path, parameter_1_string);

                else if (! strcmp(najitool_command, "bin2hexi") )
                    bin2hexi(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "bin2text") )
                    bin2text(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "blanka") )
                    blanka(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "bremline") )
                    bremline(parameter_1_string, row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "bugun") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "calc") )
                {
                    najicalc naji_calc {};
                    naji_calc.Modal();
                    return true;
                }

                else if (! strcmp(najitool_command, "cat_head") )
                    cat_head(row.string, atoi(parameter_1_string));

                else if (! strcmp(najitool_command, "cat_tail") )
                    cat_tail(row.string, atoi(parameter_1_string));

                else if (! strcmp(najitool_command, "cat_text") )
                    cat_text(row.string);

                else if (! strcmp(najitool_command, "catrandl") )
                    catrandl(row.string);

                else if (! strcmp(najitool_command, "ccompare") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "cfind") )
                    cfind(row.string, parameter_1_string);

                else if (! strcmp(najitool_command, "cfindi") )
                    cfindi(row.string, parameter_1_string);

                else if (! strcmp(najitool_command, "charaftr") )
                    charaftr(row.string, processing_output_file_path, parameter_1_string[0]);

                else if (! strcmp(najitool_command, "charbefr") )
                    charbefr(row.string, processing_output_file_path, parameter_1_string[0]);

                else if (! strcmp(najitool_command, "charfile") )
                    charfile(processing_output_file_path, atoi(parameter_2_string), parameter_1_string[0]);

                else if (! strcmp(najitool_command, "charsort") )
                    charsort(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "charwrap") )
                    charwrap(atoi(parameter_1_string), row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "chchar") )
                    chchar(row.string, processing_output_file_path, parameter_1_string[0], parameter_2_string[0]);

                else if (! strcmp(najitool_command, "chchars") )
                    chchars(row.string, processing_output_file_path, parameter_1_string, parameter_2_string);

                else if (! strcmp(najitool_command, "chstr") )
                    chstr(row.string, processing_output_file_path, parameter_1_string, parameter_2_string);

                else if (! strcmp(najitool_command, "coffset") )
                    coffset(row.string, atoi(parameter_1_string), atoi(parameter_2_string));

                else if (! strcmp(najitool_command, "compare") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "copyfile") )
                    copyfile(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "copyoffs") )
                    copyoffs(row.string, atoi(parameter_1_string), atoi(parameter_2_string), processing_output_file_path);

                else if (! strcmp(najitool_command, "copyself") )
                {
                    notbatch();
                }

                else if (! strcmp(najitool_command, "cpfroml") )
                    cpfroml(atol(parameter_1_string), row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "cptiline") )
                    cptiline(atol(parameter_1_string), row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "credits") )
                {
                    najitool_gui_credits();
                    return true;
                }

                else if (! strcmp(najitool_command, "database") )
                {
                    tabdatabase.SelectTab();
                    return true;
                }

                else if (! strcmp(najitool_command, "datetime") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "dayofmon") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "dos2unix") )
                    dos2unix(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "downlist") )
                    downlist(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "dumpoffs") )
                    dumpoffs(row.string, atoi(parameter_1_string), atoi(parameter_2_string));

                else if (! strcmp(najitool_command, "e2ahtml") )
                    e2ahtml(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "ebc2asc") )
                    ebc2asc(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "eng2arab") )
                    eng2arab(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "engnum") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "eremline") )
                    eremline(parameter_1_string, row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "f2lower") )
                    f2lower(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "f2upper") )
                    f2upper(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "filebreed") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "file2bin") )
                    file2bin(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "file2dec") )
                    file2dec(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "file2hex") )
                    file2hex(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "file2oct") )
                    file2oct(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "filechop") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "filejoin") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "fillfile") )
                {
                    sprintf(temp_edit_delete, "Are you sure you want to continue? this will overwrite ALL the characters in the file:\n%s\n\nWith the character %c and the old data WILL NOT be recoverable.\n", row.string, parameter_1_string[0]);

                    if (msgboxyesno("najitool GUI fillfile confirmation", temp_edit_delete) == yes)
                    {
                        fillfile(row.string, parameter_1_string[0]);
                    }

                }

                else if (! strcmp(najitool_command, "find") )
                    find(row.string, parameter_1_string);

                else if (! strcmp(najitool_command, "findi") )
                    findi(row.string, parameter_1_string);

                else if (! strcmp(najitool_command, "flipcopy") )
                    flipcopy(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "freverse") )
                    freverse(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "fswpcase") )
                    fswpcase(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "ftothe") )
                    ftothe(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "genhelp") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "genlic") )
                    naji_genlic(processing_output_file_path);

                else if (! strcmp(najitool_command, "getlinks") )
                    getlinks(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "gdivide") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "gigabyte") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "gminus") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "gplus") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "gtimes") )
                {
                    notbatch();
                    return true;
                }

                // help

                else if (! strcmp(najitool_command, "hexicat") )
                    hexicat(row.string);

                else if (! strcmp(najitool_command, "hilist") )
                    hilist(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "hmaker") )
                    hmaker(row.string);

                else if (! strcmp(najitool_command, "hmakerf") )
                    hmakerf(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "html_db") )
                {
                    naji_db_html_selected = true;
                    tabdatabase.SelectTab();
                    return true;
                }

                else if (! strcmp(najitool_command, "html2txt") )
                    html2txt(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "htmlfast") )
                    htmlfast(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "htmlhelp") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "kitten") )
                    kitten(row.string);

                else if (! strcmp(najitool_command, "lcharvar") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "lcvfiles") )
                    lcvfiles(row.string, output_folder_path);

                else if (! strcmp(najitool_command, "leetfile") )
                    leetfile(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "leetstr") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "length") )
                {
                    tablength.SelectTab();
                    return true;
                }

                else if (! strcmp(najitool_command, "lensortl") )
                    lensortl(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "lensorts") )
                    lensorts(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "license") )
                {
                    najitool_gui_license();
                    return true;
                }

                else if (! strcmp(najitool_command, "linesnip") )
                    linesnip(atoi(parameter_1_string), row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "makarray") )
                    makarray(row.string, processing_output_file_path, parameter_1_string);

                else if (! strcmp(najitool_command, "mathgame") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "maxxnewl") )
                    maxxnewl(row.string, processing_output_file_path, atoi(parameter_1_string));

                else if (! strcmp(najitool_command, "mergline") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "mkpatch") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "month") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "mp3split") )
                    mp3split(row.string, processing_output_file_path, atoi(parameter_1_string), atoi(parameter_2_string));

                else if (! strcmp(najitool_command, "mp3taged") )
                {

                    if (!strcmp(najitool_language, "English"))
                        msgbox("najitool GUI mp3taged information", "Sorry the mp3 tag editor is not implemented in this version because it has bugs which need to be fixed first.");
                    else if (!strcmp(najitool_language, "Turkish"))
                        msgbox("najitool GUI mp3taged bilgi", "Maalesef mp3 tag editoru bu verisyon icinde uygulanmadi cunku oncelikle duzeltilmesi gereken hatalar var.");

                    return true;
                }

                else if (! strcmp(najitool_command, "mp3tagnf") )
                {
                    mp3info_gui(row.string);
                }

                else if (! strcmp(najitool_command, "n2ch") )
                    n2ch(parameter_1_string[0], row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "n2str") )
                    n2str(parameter_1_string, row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "najcrypt") )
                {
                    tabcrypt.SelectTab();
                    return true;
                }

                else if (! strcmp(najitool_command, "naji_bmp") )
                    naji_bmp(output_folder_path);

                else if (! strcmp(najitool_command, "najirle") )
                    najirle(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "najisum") )
                    najisum(row.string);

                else if (! strcmp(najitool_command, "numlines") )
                    numlines(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "onlalnum") )
                    onlalnum(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "onlalpha") )
                    onlalpha(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "onlcntrl") )
                    onlcntrl(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "onldigit") )
                    onldigit(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "onlgraph") )
                    onlgraph(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "onllower") )
                    onllower(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "onlprint") )
                    onlprint(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "onlpunct") )
                    onlpunct(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "onlspace") )
                    onlspace(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "onlupper") )
                    onlupper(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "onlxdigt") )
                    onlxdigt(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "onlycat") )
                    onlycat(row.string, parameter_1_string);

                else if (! strcmp(najitool_command, "onlychar") )
                    onlychar(row.string, processing_output_file_path, parameter_1_string);

                else if (! strcmp(najitool_command, "patch") )
                {
                    tabpatch.SelectTab();
                    return true;
                }

                else if (! strcmp(najitool_command, "printftx") )
                    printftx(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "putlines") )
                    putlines(row.string, processing_output_file_path, parameter_1_string, parameter_2_string);

                else if (! strcmp(najitool_command, "qcrypt") )
                    qcrypt(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "qpatch") )
                    qpatch(processing_output_file_path, row.string);

                else if (! strcmp(najitool_command, "randkill") )
                {
                    sprintf(temp_edit_delete, "Are you sure you want to unrecoverabley delete the file:\n%s", row.string);

                    if (msgboxyesno("najitool GUI randkill confirmation", temp_edit_delete) == yes)
                    {
                        randkill(row.string);
                    }
                }

                else if (! strcmp(najitool_command, "rbcafter") )
                    rbcafter(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "rbcbefor") )
                    rbcbefor(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "rcharvar") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "rcvfiles") )
                    rcvfiles(row.string, output_folder_path);

                else if (! strcmp(najitool_command, "remline") )
                    remline(parameter_1_string, row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "repcat") )
                    repcat(row.string, atoi(parameter_1_string));

                else if (! strcmp(najitool_command, "repcatpp") )
                    repcatpp(row.string, atoi(parameter_1_string));

                else if (! strcmp(najitool_command, "repchar") )
                    repchar(row.string, processing_output_file_path, atoi(parameter_1_string));

                else if (! strcmp(najitool_command, "repcharp") )
                    repcharp(row.string, processing_output_file_path, atoi(parameter_1_string));

                else if (! strcmp(najitool_command, "revcat") )
                    revcat(row.string);

                else if (! strcmp(najitool_command, "revlines") )
                    revlines(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "rmunihtm") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "rndbfile") )
                    rndbfile(row.string, atol(parameter_1_string));

                else if (! strcmp(najitool_command, "rndbsout") )
                    rndbsout(atol(parameter_1_string));

                else if (! strcmp(najitool_command, "rndffill") )
                {

                    sprintf(temp_edit_delete, "Are you sure you want to continue? this will overwrite ALL the characters in the file:\n%s\n\nWith random characters and the old data WILL NOT be recoverable.\n", row.string);

                    if (msgboxyesno("najitool GUI fillfile confirmation", temp_edit_delete) == yes)
                    {
                        rndffill(row.string);
                    }

                }

                else if (! strcmp(najitool_command, "rndtfile") )
                    rndtfile(row.string, atol(parameter_1_string));

                else if (! strcmp(najitool_command, "rndtsout") )
                    rndtsout(atol(parameter_1_string));

                else if (! strcmp(najitool_command, "rrrchars") )
                    rrrchars(row.string, processing_output_file_path, atoi(parameter_1_string), atoi(parameter_2_string));

                else if (! strcmp(najitool_command, "rstrach") )
                    rstrach(atoi(parameter_1_string), row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "rstrbch") )
                    rstrbch(atoi(parameter_1_string), row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "rtcafter") )
                    rtcafter(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "rtcbefor") )
                    rtcbefor(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "saat") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "saatarih") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "showline") )
                    showline(row.string, atoi(parameter_1_string));

                else if (! strcmp(najitool_command, "skipcat") )
                    skipcat(row.string, parameter_1_string);

                else if (! strcmp(najitool_command, "skipchar") )
                    skipchar(row.string, processing_output_file_path, parameter_1_string);

                else if (! strcmp(najitool_command, "skipstr") )
                    skipstr(row.string, processing_output_file_path, parameter_1_string);

                else if (! strcmp(najitool_command, "skpalnum") )
                    skpalnum(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "skpalpha") )
                    skpalpha(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "skpcntrl") )
                    skpcntrl(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "skpdigit") )
                    skpdigit(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "skpgraph") )
                    skpgraph(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "skplower") )
                    skplower(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "skpprint") )
                    skpprint(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "skppunct") )
                    skppunct(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "skpspace") )
                    skpspace(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "skpupper") )
                    skpupper(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "skpxdigt") )
                    skpxdigt(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "strachar") )
                    strachar(parameter_1_string, row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "strbchar") )
                    strbchar(parameter_1_string, row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "strbline") )
                    strbline(row.string, processing_output_file_path, parameter_1_string);

                else if (! strcmp(najitool_command, "streline") )
                    streline(row.string, processing_output_file_path, parameter_1_string);

                else if (! strcmp(najitool_command, "strfile") )
                    strfile(processing_output_file_path, atoi(parameter_1_string), parameter_2_string);

                else if (! strcmp(najitool_command, "swapfeb") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "systemdt") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "tabspace") )
                    tabspace(atoi(parameter_1_string), row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "telltime") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "today") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "tothe") )
                {
                    tothe(parameter_1_string);
                    return true;
                }

                else if (! strcmp(najitool_command, "ttt") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "turnum") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "txt2html") )
                    txt2html(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "unihtml") )
                    naji_gen_unicode_html_pages(output_folder_path);

                else if (! strcmp(najitool_command, "unajirle") )
                    unajirle(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "unblanka") )
                    unblanka(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "unix2dos") )
                    unix2dos(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "uudecode") )
                    uudecode(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "uuencode") )
                    uuencode(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "vowelwrd") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "wordline") )
                    wordline(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "wordwrap") )
                    wordwrap(row.string, processing_output_file_path);

                else if (! strcmp(najitool_command, "wrdcount") )
                    help_edit_box.Printf("\n%s: %u", temp_filename, wrdcount(row.string));

                else if (! strcmp(najitool_command, "year") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "yil") )
                {
                    notbatch();
                    return true;
                }

                else if (! strcmp(najitool_command, "zerokill") )
                {

                    sprintf(temp_edit_delete, "Are you sure you want to unrecoverabley delete the file:\n%s", row.string);

                    if (msgboxyesno("najitool GUI zerokill confirmation", temp_edit_delete) == yes)
                    {
                        zerokill(row.string);
                    }

                }

            }

            if (!strcmp(najitool_language, "English"))
                MessageBox { text = "najitool GUI", contents = "Batch mode processing complete." }.Modal();

            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI", contents = "Toplu yontem islem tamamlandi." }.Modal();

            return true;
        }

    };
    DropBox category_drop_box
    {
        this, text = "category_drop_box", size = { 184, 24 }, position = { 8, 232 };

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
    Label language_label { this, text = "Language:", position = { 8, 168 } };
    FlagCollection flags { this };
    SavingDataBox language_drop_box
    {
        this, text = "language_drop_box", size = { 184, 24 }, position = { 8, 184 }, data = &lang, type = class(najitool_languages), fieldData = flags;;;

        bool NotifyChanged(bool closingDropDown)
        {
            int i;
            strcpy(najitool_language, languages_string_array[lang]);

            if (! strcmp(najitool_language, "Turkish") )
            {

                add_file_dialog.text  = "Eklencek Olan Dosyayi Sec...";
                add_folder_dialog.text  = "Eklencek Olan Klasoru Sec...";

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

                add_file_button.text="Dosya Ekle:";
                add_folder_button.text="Klasor Ekle:";

                output_folder_radio.text="Yazilan Klasor:";
                same_folder_as_files_radio.text="Dosyalarin Oldu Klasor";
                remake_folder_tree_check_box.text = "AltdizinleriYenidenYap";
                new_files_prefix_label.text = "YeniDosyaOnek:";
                new_files_suffix_label.text = "YeniDosyaSonek:";

                new_files_extra_extension_label.text = "Yeni Dosya Ek Uzantisi:";

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

                add_file_dialog.text  = "Select File to Add...";
                add_folder_dialog.text  = "Select Folder/Directory to Add...";
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

                add_file_button.text="Add File:";
                add_folder_button.text="Add Folder:";
                output_folder_radio.text="Output Folder:";
                same_folder_as_files_radio.text="Same Folder As Files";

                new_files_prefix_label.text = "New Files Prefix:";
                new_files_suffix_label.text = "New Files Suffix:";

                new_files_extra_extension_label.text = "New Files Extra Extension:";

                remake_folder_tree_check_box.text = "Remake Folder Tree";

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
        this, text = "cmd_drop_box", size = { 184, 24 }, position = { 8, 280 };

        bool NotifyHighlight(DropBox dropBox, DataRow row, Modifiers mods)
        {
            if (row)
            {

                int i;

                strcpy(najitool_command, row.string);

                for (i=0; i<NAJITOOL_MAX_COMMANDS; i++)
                    if (! strcmp(najitool_command, najitool_valid_commands[i]) )
                    {
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
                MessageBox { text = "najitool GUI cat_tail error:", contents = "Error, cannot allocate memory." }.Modal();

            else if (!strcmp(najitool_language, "Turkish"))
                MessageBox { text = "najitool GUI cat_tail hata:", contents = "Hata, hafiza ayirilmadi." }.Modal();

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
                    MessageBox { text = "najitool GUI qpatch error:", contents = "Offset inside patch file cannot be greater than filesize." }.Modal();

                else if (!strcmp(najitool_language, "Turkish"))
                    MessageBox { text = "najitool GUI qpatch hata:", contents = "Patch dosya icindeki ofset dosya boyutundan daha fazla olamaz." }.Modal();

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
                    MessageBox { text = "najitool GUI qpatch error:", contents = "Value inside patch file cannot be greater than 255." }.Modal();

                else if (!strcmp(najitool_language, "Turkish"))
                    MessageBox { text = "najitool GUI qpatch hata:", contents = "Patch dosya icindeki deger 255 den fazla olamaz." }.Modal();

                break;
            }

            if (value < 0)
            {

                if (!strcmp(najitool_language, "English"))
                    MessageBox { text = "najitool GUI qpatch error:", contents = "Value inside patch file cannot be less than 0." }.Modal();

                else if (!strcmp(najitool_language, "Turkish"))
                    MessageBox { text = "najitool GUI qpatch hata:", contents = "Patch dosya icindeki deger 0 dan daha az olamaz." }.Modal();

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

