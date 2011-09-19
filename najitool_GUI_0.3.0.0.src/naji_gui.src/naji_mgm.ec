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

class tab_mathgame : Tab
{
    text = "MathGM";
    background = { r = 110, g = 161, b = 180 };
    font = { "Verdana", 8.25f, bold = true };
    size = { 1280, 1024 };
    anchor = { horz = 37, vert = 182 };

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
        surface.Gradient(keys, sizeof(keys) / sizeof(ColorKey), 1, vertical, 1, 0, 1280-3, 1024 - 3);
        Update(null);
    }

    EditBox mathgame_users_answer_edit_box
    {
        this, text = "mathgame_users_answer_edit_box", size = { 214, 19 }, position = { 432, 336 };

        bool NotifyKeyDown(EditBox editBox, Key key, unichar ch)
        {
            if (key == enter || key == keyPadEnter)
                mathgame_user_answers();

            return true;
        }
    };
    EditBox mathgame_right_answers_edit_box { this, text = "mathgame_right_answers_edit_box", size = { 286, 739 }, position = { 792, 80 }, hasHorzScroll = true, true, true, readOnly = true, true };
    Label mathgame_right_answers_label { this, text = "Right Answers:", position = { 800, 40 } };
    Label mathgame_wrong_answers_label { this, text = "Wrong Answers:", position = { 88, 40 } };
    Label mathgame_points_label { this, text = "0 Points", font = { "Verdana", 20, bold = true }, position = { 432, 648 } };
    EditBox mathgame_wrong_answers_edit_box { this, text = "mathgame_wrong_answers_edit_box", size = { 286, 739 }, position = { 16, 80 }, hasHorzScroll = true, true, true, readOnly = true, true };
    Button mathgame_answer_button
    {
        this, text = "Answer", size = { 215, 25 }, position = { 432, 360 };

        bool NotifyClicked(Button button, int x, int y, Modifiers mods)
        {
            mathgame_user_answers();

            return true;
        }
    };
    Label mathgame_whatis_label { this, text = "What is", font = { "Verdana", 13, bold = true }, position = { 504, 224 } };
    Label mathgame_lvalue_label { this, text = "lvalue", font = { "Verdana", 13, bold = true }, position = { 416, 264 } };
    Label mathgame_operator_label { this, text = "op", font = { "Verdana", 16, bold = true }, position = { 528, 264 } };
    Label mathgame_rvalue_label { this, text = "rvalue", font = { "Verdana", 13, bold = true }, position = { 624, 264 } };
    Label mathgame_get_right_label { this, text = "Get the answers right to score points.", position = { 432, 112 } };
    Label mathgame_get_wrong_label { this, text = "Get the answers wrong to lose points.", position = { 432, 136 } };
    Label mathgame_welcome_label { this, text = "Welcome to MathGame", font = { "Verdana", 20, bold = true }, position = { 376, 64 } };

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
