#ifdef ECERE_STATIC
import static "ecere"
#else
import "ecere"
#endif
import "najicmds"
import "najihelp"
#include "naji_gui.eh"
import "najicomm"
import "naji_ttt"
import "najicalc"
#include "naji_gui.eh"











class FlagCollection
{
   Array<BitmapResource> flags { };
   public property Window window { set { for(b : flags) { b.window = value; } } };
   
   FlagCollection()
   {
      najitool_languages c;
      
      flags.size = najitool_languages::TR+1;
      
      for(c = EN; c <= TR; c++)
      {
         char tmp[10];
         char * s = ((char *(*)())(void *)class(najitool_languages).base._vTbl[4])(class(najitool_languages), &c, tmp, null, null);
         char fn[MAX_LOCATION];
         
         
         if (c == EN)
         {
         sprintf(fn, ":english_flag.pcx", s);
         strlwr(fn);
         flags[c] = { fn };
         incref flags[c];
         }
         if (c == TR)
         {
         sprintf(fn, ":turkish_flag.pcx", s);
         strlwr(fn);
         flags[c] = { fn };
         incref flags[c];
         }

      
      }      
   }
   ~FlagCollection() { flags.Free(); }
}
                                        

enum najitool_languages
{
   EN, TR;

   char * OnGetString(char * tempString, void * fieldData, bool * needClass)
   {
      
      return languages_string_array[this];
   }

   void OnDisplay(Surface surface, int x, int y, int width, FlagCollection flagCollection, Alignment alignment, DataDisplayFlags flags)
   {
      Bitmap icon = (flagCollection) ? flagCollection.flags[this].bitmap : null;
      int w = 8 + (icon ? icon.width : 20);
      if(icon)
         surface.Blit(icon, x,y+2,0,0, icon.width, icon.height);
      class::OnDisplay(surface, x + w, y, width - w, null, alignment, flags);
   }
};

                            




String languages_string_array[najitool_languages] = { "English", "Turkish" };

char *days[7] = { "Sunday", "Monday", "Tuseday", "Wednesday", "Thursday", "Friday", "Saturday" };
char *months[12] = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" };
char *gunler[7] = { "Pazar", "Pazartesi", "Sali", "Carsamba", "Persembe", "Cuma", "Cumartesi" };
char *aylar[12] = { "Ocak", "Subat", "Mart", "Nisan", "Mayis", "Haziran", "Temmuz", "Agustos", "Eylul", "Ekim", "Kasim", "Aralik" };
static FileFilter file_filters[] = { { "All files", null } };
unsigned long find_matches = 0;    




FILE *naji_db_file;
     

char naji_db_error_buffer[4096];
char naji_db_filepath_buffer[MAX_LOCATION];
char splitter_input_file_path[MAX_LOCATION];
char splitter_output_folder_path[MAX_LOCATION];
char splitter_a_split_file_path[MAX_LOCATION];
char splitter_size_measurement[100];
char splitter_join_output_file_path[MAX_LOCATION];
char splitter_join_buffer[4096];
char najitool_language[1000];

bool naji_db_file_selected = false;       
bool naji_db_html_selected = false;
bool naji_db_omit_no_item_selected  = false;
bool naji_db_add_text_to_empty_item = false;
int naji_db_a;

inline void swap_char(char a, char b)
{
char swap_char_var;

   swap_char_var=a;
   a=b;
   b=swap_char_var;
}


inline void swap_int(int a, int b)
{
int swap_int_var;

   swap_int_var=a;
   a=b;
   b=swap_int_var;
}

inline void swap_ulong(unsigned long a, unsigned long b)
{
unsigned long swap_ulong_var;

   swap_ulong_var=a;
   a=b;
   b=swap_ulong_var;
}

FileDialog input_file_1_dialog { filters = file_filters, sizeFilters = sizeof(file_filters); text = "Select Input File..." }; 
FileDialog input_file_2_dialog { filters = file_filters, sizeFilters = sizeof(file_filters); text = "Select Input File 2..." }; 
FileDialog input_folder_dialog { text = "Select Input Folder/Directory..."}; 
FileDialog output_file_1_dialog { filters = file_filters, sizeFilters = sizeof(file_filters); text = "Specify Output File..."}; 
FileDialog output_file_2_dialog { filters = file_filters, sizeFilters = sizeof(file_filters); text = "Specify Output File 2..."}; 
FileDialog output_folder_dialog { text = "Select Output Folder/Directory..." }; 
FileDialog naji_db_append_file_dialog { filters = file_filters, sizeFilters = sizeof(file_filters); text = "Select file to append database entries to or type a new name..."}; 
FileDialog patch_load_file_dialog { text = "Select file to load...", sizeFilters = 8, filters = file_filters };
FileDialog patch_save_as_hex_dialog { filters = file_filters, sizeFilters = sizeof(file_filters); text = "Save As Hexadecimal file..."};
FileDialog patch_save_as_dialog { filters = file_filters, sizeFilters = sizeof(file_filters); text = "Save As..."};

   DataRow category_row;
   DataRow language_row;
   DataRow command_row;
   DataRow splitter_row;











FileDialog add_file_dialog { filters = file_filters, sizeFilters = sizeof(file_filters); text = "Select File to Add..." }; 
FileDialog add_folder_dialog { text = "Select Folder/Directory to Add..."}; 
FileDialog output_folder_dialog { text = "Select Output Folder/Directory..." }; 




                                                                                                                        












void notbatch(void)
{

      MessageBox { text = "najitool GUI 0.3.0.0 Error", contents = 

      "\nSorry, this command is not available in batch mode.\n"
      }.Modal(); 

}



           

void najitool_gui_credits()
{

      MessageBox { text = "najitool GUI 0.3.0.0 Credits - in order of joining the project", contents = 
      "\n"
      "NECDET COKYAZICI - England, London - cokyazici@yahoo.co.uk\n"
      "Main author, programmer, planner, designer, tester, debugger,\n"
      "maintainer, project manager and founder. Wrote everything that\n"
      "someone else didn't write.\n"
      "\n"
      "SELCUK OZDOGAN - Turkey, Istanbul - selcuk198@yahoo.com\n"
      "Programmer. Wrote charbefr, charaftr.\n"
      "\n"
      "POLIKARP - Poland - polikarp@users.sourceforge.net\n"
      "Programmer. Wrote strbline, streline, chchar.\n"
      "\n"
      "SAMUEL CHANG - Australia - badp1ayer@hotmail.com\n"
      "Programmer. Wrote ttt, the fun Tic-Tac-Toe game with clever AI.\n"
      "\n"
      "ARKAINO (YEHRCL) - Argentina - arkaino@gmail.com\n"
      "Programmer. Wrote getlinks, find_basis,\n"
      "findi_line, chstr, skipstr, naji_mp3.c\n"
      "\n"
      "SACHIN MANE - America, Arizona - sachin.mane@gmail.com\n"
      "Programmer. Wrote cat_tail, cat_head, showline, bremline, eremline.\n"
      "\n"
      "MANUEL LE BOETTE - France - askoan@yahoo.fr\n"
      "Programmer. Wrote lensorts, lensortl.\n"
      "\n"
      "JEROME JACOVELLA-ST-LOUIS - Canada, Quebec - jerstlouis@gmail.com\n"
      "Programmer. Gave help, tips, advice, and bug fixes for the\n"
      "Ecere SDK version of najitool GUI written in the eC language.\n"
      
       }.Modal();


}


void msgbox(char *the_text, char *the_contents)
{
MessageBox { text = the_text, contents = the_contents }.Modal();
}


DialogResult msgboxyesno(char *the_text, char *the_contents)
{
return MessageBox { type = yesNo, text = the_text, contents = the_contents}.Modal();
}



class LicenseTab : Tab
{
   // opacity = 0;
   font = { "Courier New", 8 };
   EditBox editBox
   {
      this,
      multiLine = true;
      hasHorzScroll = true;
      hasVertScroll = true;
      borderStyle = deep;
      anchor = { 10, 10, 10, 10 };
      readOnly = true;
      noCaret = true;
   };
   property char * sourceFile
   {
      set
      {
         File f = FileOpen(value, read);
         if(f)
         {
            editBox.Load(f);
            delete f;
         }
      }
   }
}

class licenses_form : Window
{
   text = "License Agreements";
   background = activeBorder;
   hasClose = true;
   borderStyle = sizable;
   size = { 700, 400 };
   nativeDecorations = true;

   TabControl tabControl
   {
      this,
      opacity = 0,
      anchor = { 10, 60, 10, 40 };
   };
   Label label1
   {
      this, anchor = { top = 16 }, font = { "Tahoma", 10, true };
      text = "This program is based on these free open source software components.";
   };
   Label label2
   {
      this, anchor = { top = 32 }, font = { "Tahoma", 10, true };
      text = "By using it you agree to the terms and conditions of their individual licenses.";
   };

   LicenseTab naji_guiTab
   {
      text = "najitool";
      sourceFile = ":res/licenses/naji.LICENSE";
      tabControl = tabControl;
   };


   LicenseTab ecere_sdk_tab
   {
      text = "Ecere SDK";
      sourceFile = ":res/licenses/ecere.LICENSE";
      tabControl = tabControl;
   };

   LicenseTab jpeg_tab
   {
      text = "jpeg";
      sourceFile = ":res/licenses/jpeg.LICENSE";
      tabControl = tabControl;
   };
  

   LicenseTab libungif_tab
   {
      text = "libungif";
      sourceFile = ":res/licenses/libungif.LICENSE";
      tabControl = tabControl;
   };
   

   LicenseTab libpng_tab
   {
      text = "libpng";
      sourceFile = ":res/licenses/png.LICENSE";
      tabControl = tabControl;
   };
   LicenseTab zlib_tab
   {
      text = "zlib";
      sourceFile = ":res/licenses/zlib.LICENSE";
      tabControl = tabControl;
   };
   
   LicenseTab tango_icons_tab
   {
      text = "Tango Icons";
      sourceFile = ":res/licenses/tango.LICENSE";
      tabControl = tabControl;
   };

   LicenseTab freetype_tab
   {
      text = "Freetype";
      sourceFile = ":res/licenses/freetype.LICENSE";
      tabControl = tabControl;
   };



   Button ok
   {
      this;
      text = "OK";
      anchor = { bottom = 10 };
      size = { 80, 22 };
      isDefault = true;
      NotifyClicked = ButtonCloseDialog;
   };
}



void najitool_gui_license(void)
{
/*

      MessageBox { text = "najitool GUI 0.3.0.0 License", contents = 

      "\nTHIS PROGRAM IS NON-COPYRIGHTED PUBLIC DOMAIN AND DISTRIBUTED IN THE\n"
      "HOPE THAT IT WILL BE USEFUL BUT THERE IS NO WARRANTY FOR THE PROGRAM,\n"
      "THE PROGRAM IS PROVIDED \"AS IS\" WITHOUT WARRANTY OF ANY KIND, EITHER\n"
      "EXPRESSED  OR  IMPLIED, INCLUDING, BUT  NOT  LIMITED TO, THE IMPLIED\n"
      "WARRANTIES  OF  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.\n"
      "THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM  IS\n"
      "WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF\n"
      "ALL NECESSARY SERVICING, REPAIR OR CORRECTION.\n\n"
      }.Modal(); 

*/

licenses_form lform {};

lform.Create();

}
