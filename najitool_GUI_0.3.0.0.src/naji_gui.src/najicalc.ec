#ifdef ECERE_STATIC
import static "ecere"
#else
import "ecere"
#endif

#include <string.h>

bool najicalc_point_a_selected = false;
bool najicalc_point_b_selected = false;
bool najicalc_function_selected = false;
char najicalc_function = 'n';
double najicalc_a = 0;
double najicalc_b = 0;
double najicalc_result = 0;

class najicalc : Window
{
    text = "najitool Calculator";
    background = activeBorder;
    borderStyle = fixed;
    hasMinimize = true;
    hasClose = true;
    font = { "Courier New", 13 };
    size = { 184, 328 };
    anchor = { horz = -259, vert = -86 };

    Button najicalc_button_clear
    {
        this, text = "Clear", clientSize = { 158, 30 }, position = { 8, 264 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            najicalc_function_selected = false;
            najicalc_function = 'n';
            najicalc_a = 0;
            najicalc_b = 0;
            najicalc_result = 0;
            najicalc_edit_box_a.Clear();
            najicalc_edit_box_b.Clear();
            najicalc_edit_box_result.Clear();
            najicalc_label_function.text = "Function:";
            najicalc_point_a_selected = false;
            najicalc_point_b_selected = false;

            return true;
        }
    };
    Button najicalc_button_positive_negative { this, text = "±", clientSize = { 30, 30 }, position = { 136, 136 } };
    Button najicalc_button_sqrt
    {
        this, text = "√", clientSize = { 30, 30 }, position = { 136, 168 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            if (najicalc_function_selected == true)
            {
                najicalc_edit_box_b.Clear();
                najicalc_function_selected = false;
            }

            najicalc_label_function.text = "Function: √";
            najicalc_a = atof(najicalc_edit_box_a.contents);
            najicalc_result = sqrt(najicalc_a);
            najicalc_edit_box_result.Clear();
            najicalc_edit_box_result.Printf("%f", najicalc_result);

            return true;
        }
    };
    Button najicalc_button_equals
    {
        this, text = "=", clientSize = { 30, 62 }, position = { 136, 200 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            if (najicalc_function_selected == true)
            {

                najicalc_a = atof(najicalc_edit_box_a.contents);
                najicalc_b = atof(najicalc_edit_box_b.contents);

                if (najicalc_function == '+')
                {
                    najicalc_result = najicalc_a + najicalc_b;
                    najicalc_edit_box_result.Clear();
                    najicalc_edit_box_result.Printf("%f", najicalc_result);
                    return true;
                }

                if (najicalc_function == '-')
                {
                    najicalc_result = najicalc_a - najicalc_b;
                    najicalc_edit_box_result.Clear();
                    najicalc_edit_box_result.Printf("%f", najicalc_result);
                    return true;
                }

                if (najicalc_function == '*')
                {
                    najicalc_result = najicalc_a * najicalc_b;
                    najicalc_edit_box_result.Clear();
                    najicalc_edit_box_result.Printf("%f", najicalc_result);
                    return true;
                }

                if (najicalc_function == '/')
                {
                    najicalc_result = najicalc_a / najicalc_b;
                    najicalc_edit_box_result.Clear();
                    najicalc_edit_box_result.Printf("%f", najicalc_result);
                    return true;
                }

            }

            return true;
        }
    };
    Button najicalc_button_divide
    {
        this, text = "/", clientSize = { 30, 30 }, position = { 104, 136 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            najicalc_function_selected = true;
            najicalc_function = '/';
            najicalc_label_function.text = "Function: /";
            return true;
        }
    };
    Button najicalc_button_multiply
    {
        this, text = "*", clientSize = { 30, 30 }, position = { 104, 168 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            najicalc_function_selected = true;
            najicalc_function = '*';
            najicalc_label_function.text = "Function: *";

            return true;
        }
    };
    Button najicalc_button_minus
    {
        this, text = "-", clientSize = { 30, 30 }, position = { 104, 200 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            najicalc_function_selected = true;
            najicalc_function = '-';
            najicalc_label_function.text = "Function: -";

            return true;
        }
    };
    Button najicalc_button_add
    {
        this, text = "+", clientSize = { 30, 30 }, position = { 104, 232 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            najicalc_function_selected = true;
            najicalc_function = '+';
            najicalc_label_function.text = "Function: +";

            return true;
        }
    };
    Label najicalc_label_function { this, text = "Function:", position = { 8, 40 } };
    EditBox najicalc_edit_box_result { this, text = "najicalc_edit_box_result", size = { 150, 26 }, position = { 8, 104 } };
    EditBox najicalc_edit_box_a { this, text = "najicalc_edit_box_a", size = { 150, 26 }, position = { 8, 8 } };
    EditBox najicalc_edit_box_b { this, text = "najicalc_edit_box_b", size = { 150, 26 }, position = { 8, 72 } };
    Button najicalc_button_point
    {
        this, text = ".", clientSize = { 30, 30 }, position = { 72, 232 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            if (najicalc_function_selected == false)
            {

                if (najicalc_point_a_selected == false)
                {
                    najicalc_edit_box_a.Printf(".");
                    najicalc_point_a_selected = true;
                }

            }
            else
            {

                if (najicalc_point_b_selected == false)
                {
                    najicalc_edit_box_b.Printf(".");
                    najicalc_point_b_selected = true;
                }

            }

            return true;
        }

    };
    Button najicalc_button_0
    {
        this, text = "0", clientSize = { 62, 30 }, position = { 8, 232 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {

            if (najicalc_function_selected == false)
                najicalc_edit_box_a.Printf("0");
            else
                najicalc_edit_box_b.Printf("0");

            return true;
        }
    };
    Button najicalc_button_1
    {
        this, text = "1", clientSize = { 30, 30 }, position = { 8, 200 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            if (najicalc_function_selected == false)
                najicalc_edit_box_a.Printf("1");
            else
                najicalc_edit_box_b.Printf("1");

            return true;
        }
    };
    Button najicalc_button_2
    {
        this, text = "2", clientSize = { 30, 30 }, position = { 40, 200 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            if (najicalc_function_selected == false)
                najicalc_edit_box_a.Printf("2");
            else
                najicalc_edit_box_b.Printf("2");
            return true;
        }
    };
    Button najicalc_button_3
    {
        this, text = "3", clientSize = { 30, 30 }, position = { 72, 200 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            if (najicalc_function_selected == false)
                najicalc_edit_box_a.Printf("3");
            else
                najicalc_edit_box_b.Printf("3");
            return true;
        }
    };
    Button najicalc_button_4
    {
        this, text = "4", clientSize = { 30, 30 }, position = { 8, 168 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            if (najicalc_function_selected == false)
                najicalc_edit_box_a.Printf("4");
            else
                najicalc_edit_box_b.Printf("4");
            return true;
        }
    };
    Button najicalc_button_5
    {
        this, text = "5", clientSize = { 30, 30 }, position = { 40, 168 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            if (najicalc_function_selected == false)
                najicalc_edit_box_a.Printf("5");
            else
                najicalc_edit_box_b.Printf("5");
            return true;
        }
    };
    Button najicalc_button_6
    {
        this, text = "6", clientSize = { 30, 30 }, position = { 72, 168 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            if (najicalc_function_selected == false)
                najicalc_edit_box_a.Printf("6");
            else
                najicalc_edit_box_b.Printf("6");
        }
    };
    Button najicalc_button_7
    {
        this, text = "7", clientSize = { 30, 30 }, position = { 8, 136 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            if (najicalc_function_selected == false)
                najicalc_edit_box_a.Printf("7");
            else
                najicalc_edit_box_b.Printf("7");
            return true;
        }
    };
    Button najicalc_button_8
    {
        this, text = "8", clientSize = { 30, 30 }, position = { 40, 136 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            if (najicalc_function_selected == false)
                najicalc_edit_box_a.Printf("8");
            else
                najicalc_edit_box_b.Printf("8");
            return true;
        }
    };
    Button najicalc_button_9
    {
        this, text = "9", clientSize = { 30, 30 }, position = { 72, 136 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            if (najicalc_function_selected == false)
                najicalc_edit_box_a.Printf("9");
            else
                najicalc_edit_box_b.Printf("9");
            return true;
        }
    };

    bool OnCreate(void)
    {

        return true;
    }
}

