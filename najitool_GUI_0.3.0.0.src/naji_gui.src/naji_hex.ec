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
import "naji_len"
import "najijoin"
import "naji_db"
#include "naji_gui.eh"
                         

class HexEditorTop : Window
{
    size = { 1280, 24 };
    disabled = true;

    Label hex_top_label { this, text = "Offset:           0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F     0 1 2 3 4 5 6 7 8 9 A B C D E F" , position = { 316, 2}};
}

class HexEditor : Window
{
    size = { 1280, 1024 };

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
    size = { 1280, 1024 };

    HexEditorTop najihexTop { this, anchor = { 0, 0, 0, 0 } };
    HexEditor najihex { this, anchor = { 0, 0, 0, 0 }, position = { 0, 24}};
}
