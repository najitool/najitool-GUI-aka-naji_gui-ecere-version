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
import "naji_mgm"
import "naji_hex"
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
    size = { 1111, 900};
    tabCycle = true;

    icon = { ":res/naji_gui.png" };

    void OnRedraw(Surface surface)
    {
        ColorKey keys[2] = { {0x6EA1B4, 0.0f}, { white, 1.0f } };
        surface.Gradient(keys, sizeof(keys) / sizeof(ColorKey), 1, vertical, 1, 0, 1280-3, 33 - 3);
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

/*
class naji_gui : GuiApplication
{
    driver = "OpenGL";
}
*/