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
    size = { 1280, 1024};

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
        surface.Gradient(keys, sizeof(keys) / sizeof(ColorKey), 1, vertical, 1, 0, 1280-3, 1024 - 3);
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

