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
    size = { 1280, 1024 };

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
        surface.Gradient(keys, sizeof(keys) / sizeof(ColorKey), 1, vertical, 1, 0, 1280-3, 1024 - 3);
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
                splitter_bytsplit(splitter_input_file_edit_box.contents, atoi(splitter_size_edit_box.contents), splitter_output_folder_edit_box.contents);

                if (!strcmp(najitool_language, "English"))
                    msgbox("najitool GUI File Splitter", "File splitting complete.");
                else if (!strcmp(najitool_language, "Turkish"))
                    msgbox("najitool GUI Dosya Bolucu", "Dosya bolunmesi tamamlandi.");
            }

            else if (!strcmp(splitter_size_measurement, "kb"))
            {
                splitter_kbsplit(splitter_input_file_edit_box.contents, atoi(splitter_size_edit_box.contents), splitter_output_folder_edit_box.contents);
                if (!strcmp(najitool_language, "English"))
                    msgbox("najitool GUI File Splitter", "File splitting complete.");
                else if (!strcmp(najitool_language, "Turkish"))
                    msgbox("najitool GUI Dosya Bolucu", "Dosya bolunmesi tamamlandi.");
            }

            else if (!strcmp(splitter_size_measurement, "mb"))
            {
                splitter_mbsplit(splitter_input_file_edit_box.contents, atoi(splitter_size_edit_box.contents), splitter_output_folder_edit_box.contents);
                if (!strcmp(najitool_language, "English"))
                    msgbox("najitool GUI File Splitter", "File splitting complete.");
                else if (!strcmp(najitool_language, "Turkish"))
                    msgbox("najitool GUI Dosya Bolucu", "Dosya bolunmesi tamamlandi.");
            }

            else if (!strcmp(splitter_size_measurement, "gb"))
            {
                splitter_gbsplit(splitter_input_file_edit_box.contents, atoi(splitter_size_edit_box.contents), splitter_output_folder_edit_box.contents);
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
            splitter_mjoin(splitter_a_split_file_path, splitter_join_output_file_path);

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

    void splitter_bytsplit(char *namein, unsigned long peice_size, char *output_folder)
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

    void splitter_kbsplit(char *namein, unsigned long peice_size, char *output_folder)
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

    void splitter_mbsplit(char *namein, unsigned long peice_size, char *output_folder)
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

    void splitter_gbsplit(char *namein, unsigned long peice_size, char *output_folder)
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

    void splitter_mjoin(char *namein_original_filename, char *nameout_joined_output_file)
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
