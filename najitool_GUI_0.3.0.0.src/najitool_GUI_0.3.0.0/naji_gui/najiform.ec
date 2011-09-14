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
#include "naji_gui.eh"


static String languages_string_array[najitool_languages] = { "English", "Turkish" };
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

char swap_char_var;
#define swap_char(a, b)  swap_char_var=a;   a=b;  b=swap_char_var;

int swap_int_var;
#define swap_int(a, b)  swap_int_var=a;   a=b;  b=swap_int_var;   

unsigned long swap_ulong_var;
#define swap_ulong(a, b)  swap_ulong_var=a;   a=b;  b=swap_ulong_var;

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



TabControl tabcontrol_naji_gui
{
nativeDecorations = true;
text = "najitool GUI 0.3.0.0 Made By NECDET COKYAZICI And Contributors, Public Domain 2003-2011";
background = { r = 110, g = 161, b = 180 };
borderStyle = fixedBevel;
hasMinimize = true;
hasClose = true;
font = { "Verdana", 8.25f, bold = true };
size = { 1024, 768 };
tabCycle = true;   

icon = { ":naji_gui.png" };

};

tab_main tabmain { tabControl = tabcontrol_naji_gui };
tab_batch tabbatch { tabControl = tabcontrol_naji_gui };
tab_crypt tabcrypt { tabControl = tabcontrol_naji_gui };
tab_length tablength { tabControl = tabcontrol_naji_gui };
tab_split tabsplit { tabControl = tabcontrol_naji_gui };
tab_database tabdatabase { tabControl = tabcontrol_naji_gui };
tab_mathgame tabmathgame { tabControl = tabcontrol_naji_gui };
tab_patch tabpatch { tabControl = tabcontrol_naji_gui };
tab_hex tabhex { tabControl = tabcontrol_naji_gui };

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class tab_main : Tab
{
   text = "Main";
   background = { r = 110, g = 161, b = 180 };
   font = { "Verdana", 8.25f, bold = true };
   size = { 1024, 768 };

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
   time_t time_value;
   struct tm *date_time;
   najitool_languages lang;
   




/* Begin: System Date/Time Functions */

   void get_datetime() { time(&time_value); date_time = localtime(&time_value); }

   void systemdt() { get_datetime(); sprintf(naji_buffer, "Current System Date and Time: %s", asctime(date_time)); help_edit_box.contents=naji_buffer;}
/* End: System Date/Time Functions */

/* Begin: English Date/Time Functions */

   void telltime() {get_datetime(); sprintf(naji_buffer, "%02i:%02i:%02i", date_time->tm_hour, date_time->tm_min, date_time->tm_sec); help_edit_box.contents = naji_buffer;}

   char * s_today() {int i; get_datetime(); for (i=0; i<=6; i++) if (date_time->tm_wday == i) return (days[i]); return ("(DAY ERROR)");}

   char * s_month() {int i; get_datetime(); for (i=0; i<=11; i++) if (date_time->tm_mon == i) return (months[i]); return ("(MONTH ERROR)");}

   void today() {help_edit_box.contents = s_today();}

   void dayofmon() {get_datetime(); sprintf(naji_buffer, "%i", date_time->tm_mday); help_edit_box.contents = naji_buffer;}

   void  month() {help_edit_box.contents = s_month();}

   void year() {get_datetime(); sprintf(naji_buffer, "%i", ( (1900) + (date_time->tm_year) ) ); help_edit_box.contents =  naji_buffer;}

   void datetime(void) { char telltime_buf[100]; char today_buf[100]; char dayofmon_buf[100]; char month_buf[100]; char year_buf[100]; int i; get_datetime();
sprintf(telltime_buf, "%02i:%02i:%02i", date_time->tm_hour, date_time->tm_min, date_time->tm_sec); sprintf(today_buf, s_today());
sprintf(dayofmon_buf, "%i", date_time->tm_mday); sprintf(month_buf, s_month()); sprintf(year_buf, "%i", ( (1900) + (date_time->tm_year) ) );
sprintf(naji_buffer, "%s %s %s %s %s", telltime_buf, today_buf, dayofmon_buf, month_buf, year_buf); help_edit_box.contents = naji_buffer; }
/* End: English Date/Time Functions */


/* Begin: Turkish Date/Time Functions */

   void saat() {get_datetime(); sprintf(naji_buffer, "%02i:%02i:%02i", date_time->tm_hour, date_time->tm_min, date_time->tm_sec); help_edit_box.contents = naji_buffer; }

   char * s_bugun() { int i; get_datetime(); for (i=0; i<=6; i++) if (date_time->tm_wday == i) return (gunler[i]); return ("(GUN HATA)"); }

   char * s_ay() { int i; get_datetime(); for (i=0; i<=11; i++) if (date_time->tm_mon == i) return (aylar[i]); return ("(AY HATA)");}

   void bugun() { help_edit_box.contents = s_bugun();}

   void ay() { help_edit_box.contents = s_ay(); }

   void ayinkaci() {get_datetime(); sprintf(naji_buffer, "%i", date_time->tm_mday); help_edit_box.contents = naji_buffer; }

   void yil() {get_datetime(); sprintf(naji_buffer, "%i", ( (1900) + (date_time->tm_year) ) ); help_edit_box.contents =  naji_buffer;}

   void saatarih(void) {char telltime_buf[100]; char today_buf[100]; char dayofmon_buf[100]; char month_buf[100]; char year_buf[100]; int i; get_datetime();
sprintf(telltime_buf, "%02i:%02i:%02i", date_time->tm_hour, date_time->tm_min, date_time->tm_sec); sprintf(today_buf, s_bugun());
sprintf(dayofmon_buf, "%i", date_time->tm_mday); sprintf(month_buf, s_ay()); sprintf(year_buf, "%i", ( (1900) + (date_time->tm_year) ) );
sprintf(naji_buffer, "%s %s %s %s %s", telltime_buf, today_buf, dayofmon_buf, month_buf, year_buf); help_edit_box.contents = naji_buffer;   }
/* End: Turkish Date/Time Functions */


   Label help_label { this, text = "Help/Output:", size = { 89, 16 }, position = { 616, 296 } };
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
   Button input_file_1_button
   {
      this, text = "Input File 1:", size = { 130, 20 }, position = { 288, 16 };

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
      this, text = "Input File 2:", size = { 130, 20 }, position = { 288, 40 };

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
      this, text = "Input Folder:", size = { 130, 20 }, position = { 288, 64 };

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
      this, text = "Output File 1:", size = { 130, 20 }, position = { 288, 88 };

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
      this, text = "Output File 2:", size = { 130, 20 }, position = { 288, 112 };

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
      this, text = "Output Folder:", size = { 130, 20 }, position = { 288, 136 };

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
      this, text = "input_file_1_edit_box", size = { 294, 19 }, position = { 416, 16 };

      bool NotifyModified(EditBox editBox)
      {
         strcpy(input_file_1_path, input_file_1_edit_box.contents);
    
         return true;
      }
   };
   EditBox input_file_2_edit_box
   {
      this, text = "input_file_2_edit_box", size = { 294, 19 }, position = { 416, 40 };

      bool NotifyModified(EditBox editBox)
      {
         strcpy(input_file_2_path, input_file_2_edit_box.contents);


         return true;
      }
   };
   EditBox input_folder_edit_box 
   {
      this, text = "input_folder_edit_box", size = { 294, 19 }, position = { 416, 64 };

      bool NotifyModified(EditBox editBox)
      {

         strcpy(input_folder_path, input_folder_edit_box.contents);

         return true;
      }
   };
   EditBox output_file_1_edit_box
   {
      this, text = "output_file_1_edit_box", size = { 294, 19 }, position = { 416, 88 };

      bool NotifyModified(EditBox editBox)
      {

         strcpy(output_file_1_path, output_file_1_edit_box.contents);


         return true;
      }
   };
   EditBox output_file_2_edit_box
   {
      this, text = "output_file_2_edit_box", size = { 294, 19 }, position = { 416, 112 };

      bool NotifyModified(EditBox editBox)
      {

         strcpy(output_file_2_path, output_file_2_edit_box.contents);

         return true;
      }
   };
   EditBox output_folder_edit_box 
   {
      this, text = "output_folder_edit_box", size = { 294, 19 }, position = { 416, 136 };

      bool NotifyModified(EditBox editBox)
      {
         strcpy(output_folder_path, output_folder_edit_box.contents);
         return true;
      }
   };
   EditBox parameter_1_edit_box
   {
      this, text = "parameter_1_edit_box", size = { 294, 19 }, position = { 416, 160 };

      bool NotifyModified(EditBox editBox)
      {

         strcpy(parameter_1_string, parameter_1_edit_box.contents);

         return true;
      }
   };
   EditBox parameter_2_edit_box
   {
      this, text = "parameter_2_edit_box", size = { 294, 19 }, position = { 416, 184 };

      bool NotifyModified(EditBox editBox)
      {

         strcpy(parameter_2_string, parameter_2_edit_box.contents);

         return true;
      }
   };
   Label parameter_2_label
   {
      this, text = "Parameter 2:", position = { 320, 192 };

      bool NotifyActivate(Window window, bool active, Window previous)
      {

         return true;
      }
   };
   Label parameter_1_label
   {
      this, text = "Parameter 1:", position = { 320, 168 };

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
   }
   EditBox help_edit_box 
   {
      this, text = "help_edit_box", font = { "Courier New", 8 }, size = { 702, 326 }, position = { 288, 328 }, hasHorzScroll = true, true, true, true, true, readOnly = true, true, noCaret = true
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

   if (! strcmp(najitool_command, "8bit256") )
   _8bit256(output_file_1_path, atoi(parameter_1_string));
 
   if (! strcmp(najitool_command, "addim") )
   addim(atoi(parameter_1_string), output_file_1_path);

   if (! strcmp(najitool_command, "allfiles") )
   allfiles(atoi(parameter_1_string), output_folder_path);
 
   if (! strcmp(najitool_command, "allbmp16") )
   allbmp16(output_folder_path);

   if (! strcmp(najitool_command, "arab2eng") )
   arab2eng(input_file_1_path, output_file_1_path);
 
   if (! strcmp(najitool_command, "asc2ebc") )
   asc2ebc(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "asctable") )
   asctable(output_file_1_path);

   if (! strcmp(najitool_command, "ay") )
   {
   ay();
   return true;
   }
 
   if (! strcmp(najitool_command, "ayinkaci") )
   {
   ayinkaci(); 
   return true;
   }

   if (! strcmp(najitool_command, "bigascif") )
   bigascif(parameter_1_string, output_file_1_path);

   if (! strcmp(najitool_command, "bigascii") )
   {
   bigascii(parameter_1_string);
   return true;
   }

   if (! strcmp(najitool_command, "bin2c") )
   bin2c(input_file_1_path, output_file_1_path, parameter_1_string);

   if (! strcmp(najitool_command, "bin2hexi") )
   bin2hexi(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "bin2text") )
   bin2text(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "blanka") )
   blanka(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "bremline") )
   bremline(parameter_1_string, input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "bugun") )
   {
   bugun();
   return true;
   }
 
   if (! strcmp(najitool_command, "calc") )
   {
   najicalc naji_calc {};
   naji_calc.Modal();
   return true;
   }

   if (! strcmp(najitool_command, "cat_head") )
   {
   cat_head(input_file_1_path, atoi(parameter_1_string));
   return true;
   }

   if (! strcmp(najitool_command, "cat_tail") )
   {
   cat_tail(input_file_1_path, atoi(parameter_1_string));
   return true;
   }

   if (! strcmp(najitool_command, "cat_text") )
   {
   cat_text(input_file_1_path);
   return true;
   }

   if (! strcmp(najitool_command, "catrandl") )
   {
   catrandl(input_file_1_path);
   return true;
   }
 
   if (! strcmp(najitool_command, "ccompare") )
   {
   ccompare(input_file_1_path, input_file_2_path);
   return true;
   }
 
   if (! strcmp(najitool_command, "cfind") )
   {
   cfind(input_file_1_path, parameter_1_string);
   return true;
   }

   if (! strcmp(najitool_command, "cfindi") )
   {
   cfindi(input_file_1_path, parameter_1_string);
   return true;
   }
 
   if (! strcmp(najitool_command, "charaftr") )
   charaftr(input_file_1_path, output_file_1_path, parameter_1_string[0]);

   if (! strcmp(najitool_command, "charbefr") )
   charbefr(input_file_1_path, output_file_1_path, parameter_1_string[0]);

   if (! strcmp(najitool_command, "charfile") )
   charfile(output_file_1_path, atoi(parameter_2_string), parameter_1_string[0]);
   
   if (! strcmp(najitool_command, "charsort") )
   charsort(input_file_1_path, output_file_1_path);
   
   if (! strcmp(najitool_command, "charwrap") )
   charwrap(atoi(parameter_1_string), input_file_1_path, output_file_1_path);
       
   if (! strcmp(najitool_command, "chchar") )
   chchar(input_file_1_path, output_file_1_path, parameter_1_string[0], parameter_2_string[0]);

   if (! strcmp(najitool_command, "chchars") )
   chchars(input_file_1_path, output_file_1_path, parameter_1_string, parameter_2_string);

   if (! strcmp(najitool_command, "chstr") )
   chstr(input_file_1_path, output_file_1_path, parameter_1_string, parameter_2_string);

   if (! strcmp(najitool_command, "coffset") )
   {
   coffset(input_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string));
   return true;
   }

   if (! strcmp(najitool_command, "compare") )
   {
   compare(input_file_1_path, input_file_2_path);
   return true;
   }

   if (! strcmp(najitool_command, "copyfile") )
   copyfile(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "copyoffs") )
   copyoffs(input_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string), output_file_1_path);

   if (! strcmp(najitool_command, "copyself") )
   {
   LocateModule(null, copyself_path);
   //StripLastDirectory(path, path);
   copyfile(copyself_path, output_file_1_path);
   }

   if (! strcmp(najitool_command, "cpfroml") )
   cpfroml(atol(parameter_1_string), input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "cptiline") )  
   cptiline(atol(parameter_1_string), input_file_1_path, output_file_1_path); 


   if (! strcmp(najitool_command, "credits") )
   {
   najitool_gui_credits();
   return true;
   }
   
   if (! strcmp(najitool_command, "database") )
   {
   tabdatabase.SelectTab();
   return true;
   }

   if (! strcmp(najitool_command, "datetime") )
   {
   datetime();
   return true;
   }
 
   if (! strcmp(najitool_command, "dayofmon") )
   {
   dayofmon(); 
   return true;
   }

   if (! strcmp(najitool_command, "dos2unix") )
   dos2unix(input_file_1_path, output_file_1_path);
 
   if (! strcmp(najitool_command, "downlist") )
   downlist(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "dumpoffs") )
   {
   dumpoffs(input_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string));
   return true;
   }
   
   if (! strcmp(najitool_command, "e2ahtml") )
   e2ahtml(input_file_1_path, output_file_1_path);
   
   if (! strcmp(najitool_command, "ebc2asc") )
   ebc2asc(input_file_1_path, output_file_1_path);
   
   if (! strcmp(najitool_command, "eng2arab") )
   eng2arab(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "engnum") )
   engnum(output_file_1_path);
 
   if (! strcmp(najitool_command, "eremline") )  
   eremline(parameter_1_string, input_file_1_path, output_file_1_path); 
 
   if (! strcmp(najitool_command, "f2lower") )
   f2lower(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "f2upper") )
   f2upper(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "filebreed") )
   filbreed(input_file_1_path, input_file_2_path, output_file_1_path);

   if (! strcmp(najitool_command, "file2bin") )
   file2bin(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "file2dec") )
   file2dec(input_file_1_path, output_file_1_path);
   
   if (! strcmp(najitool_command, "file2hex") )
   file2hex(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "filechop") )
   filechop(atoi(parameter_1_string), input_file_1_path, output_file_1_path, output_file_2_path);
   
   if (! strcmp(najitool_command, "filejoin") )
   filejoin(input_file_1_path, input_file_2_path, output_file_1_path);
   
   if (! strcmp(najitool_command, "fillfile") )
   fillfile(output_file_1_path, parameter_1_string[0]);
   
   if (! strcmp(najitool_command, "find") )
   {
   find(input_file_1_path, parameter_1_string);
   return true;
   }

   if (! strcmp(najitool_command, "findi") )
   {
   findi(input_file_1_path, parameter_1_string);
   return true;
   }
  
   if (! strcmp(najitool_command, "flipcopy") )
   flipcopy(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "freverse") )
   freverse(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "fswpcase") )
   fswpcase(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "ftothe") )
   ftothe(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "genhelp") )
   najitool_gui_genhelp(output_file_1_path);
   
   if (! strcmp(najitool_command, "genlic") )
   naji_genlic(output_file_1_path);

   if (! strcmp(najitool_command, "getlinks") )
   getlinks(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "gdivide") )
   gdivide(output_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string));

   if (! strcmp(najitool_command, "gigabyte") )
   {
   gigabyte(atoi(parameter_1_string));
   return true;
   }

   if (! strcmp(najitool_command, "gminus") )
   gminus(output_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string));

   if (! strcmp(najitool_command, "gplus") )
   gplus(output_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string));
   
   if (! strcmp(najitool_command, "gtimes") )
   gminus(output_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string));

   // help

   if (! strcmp(najitool_command, "hexicat") )
   hexicat(input_file_1_path);

   if (! strcmp(najitool_command, "hilist") )
   hilist(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "hmaker") )
   hmaker(input_file_1_path);

   if (! strcmp(najitool_command, "hmakerf") )
   hmakerf(input_file_1_path, output_file_1_path);
   
   if (! strcmp(najitool_command, "html_db") )
   {
   naji_db_html_selected = true;
   tabdatabase.SelectTab();
   return true;
   }

   if (! strcmp(najitool_command, "html2txt") )
   html2txt(input_file_1_path, output_file_1_path);
  
   if (! strcmp(najitool_command, "htmlfast") )
   htmlfast(input_file_1_path, output_file_1_path);
   
   if (! strcmp(najitool_command, "htmlhelp") )
   najitool_gui_generate_htmlhelp(output_file_1_path);
   
   if (! strcmp(najitool_command, "kitten") )
   {
   kitten(input_file_1_path);
   return true;
   }
        
   if (! strcmp(najitool_command, "lcharvar") )
   {
   lcharvar(parameter_1_string);
   return true;
   }

   if (! strcmp(najitool_command, "lcvfiles") )
   lcvfiles(input_file_1_path, output_folder_path);
   
   if (! strcmp(najitool_command, "leetfile") )
   leetfile(input_file_1_path, output_file_1_path);
   
   if (! strcmp(najitool_command, "leetstr") )
   {
   leetstr(parameter_1_string);
   return true;
   }
   
   if (! strcmp(najitool_command, "length") )
   {
   tablength.SelectTab();
   return true;
   }

   if (! strcmp(najitool_command, "lensortl") )
   lensortl(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "lensorts") )
   lensorts(input_file_1_path, output_file_1_path);
   
   if (! strcmp(najitool_command, "license") )
   {
   najitool_gui_license();
   return true;
   }

   if (! strcmp(najitool_command, "linesnip") )
   linesnip(atoi(parameter_1_string), input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "makarray") )
   makarray(input_file_1_path, output_file_1_path, parameter_1_string);


   if (! strcmp(najitool_command, "mathgame") )
   {
   tabmathgame.SelectTab();
   return true;
   }

   if (! strcmp(najitool_command, "mergline") )
   mergline(input_file_1_path, input_file_2_path, output_file_1_path, parameter_1_string, parameter_2_string);

   if (! strcmp(najitool_command, "mkpatch") )
   mkpatch(input_file_1_path, input_file_2_path, output_file_1_path);

   if (! strcmp(najitool_command, "month") )
   {
   month();
   return true;
   }

   if (! strcmp(najitool_command, "mp3split") )
   mp3split(input_file_1_path, output_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string));

   if (! strcmp(najitool_command, "mp3taged") )
   {
   
   if (!strcmp(najitool_language, "English"))
   msgbox("najitool GUI mp3taged information", "Sorry the mp3 tag editor is not implemented in this version because it has bugs which need to be fixed first.");
   else if (!strcmp(najitool_language, "Turkish"))
   msgbox("najitool GUI mp3taged bilgi", "Maalesef mp3 tag editoru bu verisyon icinde uygulanmadi cunku oncelikle duzeltilmesi gereken hatalar var.");
   
   
   return true;
   }

   if (! strcmp(najitool_command, "mp3tagnf") )
   {
   mp3info_gui(input_file_1_path);
   return true;
   }

   if (! strcmp(najitool_command, "n2ch") )
   n2ch(parameter_1_string[0], input_file_1_path, output_file_1_path);


   if (! strcmp(najitool_command, "n2str") )
   n2str(parameter_1_string, input_file_1_path, output_file_1_path);


   if (! strcmp(najitool_command, "najcrypt") )
   {
   tabcrypt.SelectTab();
   return true;
   }

   if (! strcmp(najitool_command, "naji_bmp") )
   naji_bmp(output_folder_path);
   
   if (! strcmp(najitool_command, "najirle") )
   najirle(input_file_1_path, output_file_1_path);
   
   if (! strcmp(najitool_command, "najisum") )
   najisum(input_file_1_path);
   
   if (! strcmp(najitool_command, "numlines") )
   numlines(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "onlalnum") )
   onlalnum(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "onlalpha") )
   onlalpha(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "onlcntrl") )
   onlcntrl(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "onldigit") )
   onldigit(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "onlgraph") )
   onlgraph(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "onllower") )
   onllower(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "onlprint") )
   onlprint(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "onlpunct") )
   onlpunct(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "onlspace") )
   onlspace(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "onlupper") )
   onlupper(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "onlxdigt") )
   onlxdigt(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "onlycat") )
   onlycat(input_file_1_path, parameter_1_string);
  
   if (! strcmp(najitool_command, "onlychar") )
   onlychar(input_file_1_path, output_file_1_path, parameter_1_string);

   if (! strcmp(najitool_command, "patch") )
   {
   tabpatch.SelectTab();
   return true;
   }

   if (! strcmp(najitool_command, "printftx") )
   printftx(input_file_1_path, output_file_1_path);
   
   if (! strcmp(najitool_command, "putlines") )
   putlines(input_file_1_path, output_file_1_path, parameter_1_string, parameter_2_string);

   if (! strcmp(najitool_command, "qcrypt") )
   qcrypt(input_file_1_path, output_file_1_path);
   
   if (! strcmp(najitool_command, "qpatch") )
   qpatch(output_file_1_path, input_file_1_path);

   if (! strcmp(najitool_command, "randkill") )
   randkill(output_file_1_path);

   if (! strcmp(najitool_command, "rbcafter") )
   rbcafter(input_file_1_path, output_file_1_path);
   
   if (! strcmp(najitool_command, "rbcbefor") )
   rbcbefor(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "rcharvar") )
   {
   rcharvar(parameter_1_string);
   return true;
   }
 
   if (! strcmp(najitool_command, "rcvfiles") )
   rcvfiles(input_file_1_path, output_folder_path);

   if (! strcmp(najitool_command, "remline") )
   remline(parameter_1_string, input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "repcat") )
   repcat(input_file_1_path, atoi(parameter_1_string));

   if (! strcmp(najitool_command, "repcatpp") )
   repcatpp(input_file_1_path, atoi(parameter_1_string));

   if (! strcmp(najitool_command, "repchar") )
   repchar(input_file_1_path, output_file_1_path, atoi(parameter_1_string));

   if (! strcmp(najitool_command, "repcharp") )
   repcharp(input_file_1_path, output_file_1_path, atoi(parameter_1_string));

   if (! strcmp(najitool_command, "revcat") )
   revcat(input_file_1_path);
  
   if (! strcmp(najitool_command, "revlines") )
   revlines(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "rmunihtm") )
   naji_del_gen_unicode_html_pages(output_folder_path);

   if (! strcmp(najitool_command, "rndbfile") )
   rndbfile(input_file_1_path, atol(parameter_1_string));

   if (! strcmp(najitool_command, "rndbsout") )
   {
   rndbsout(atol(parameter_1_string));
   return true;
   }

   if (! strcmp(najitool_command, "rndffill") )
   rndffill(output_file_1_path);

   if (! strcmp(najitool_command, "rndtfile") )
   rndtfile(input_file_1_path, atol(parameter_1_string));

   if (! strcmp(najitool_command, "rndtsout") )
   {
   rndtsout(atol(parameter_1_string));
   return true;
   }

   if (! strcmp(najitool_command, "rrrchars") )
   rrrchars(input_file_1_path, output_file_1_path, atoi(parameter_1_string), atoi(parameter_2_string));

   if (! strcmp(najitool_command, "rstrach") )
   rstrach(atoi(parameter_1_string), input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "rstrbch") )
   rstrbch(atoi(parameter_1_string), input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "rtcafter") )
   rtcafter(input_file_1_path, output_file_1_path);
   
   if (! strcmp(najitool_command, "rtcbefor") )
   rtcbefor(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "saat") )
   {
   saat();
   return true;
   }

   if (! strcmp(najitool_command, "saatarih") )
   {
   saatarih();
   return true;
   }
          
   if (! strcmp(najitool_command, "showline") )
   {
   showline(input_file_1_path, atoi(parameter_1_string));
   return true;
   }
 

   if (! strcmp(najitool_command, "skipcat") )
   {
   skipcat(input_file_1_path, parameter_1_string);
   return true;
   }
  
   if (! strcmp(najitool_command, "skipchar") )
   skipchar(input_file_1_path, output_file_1_path, parameter_1_string);

   if (! strcmp(najitool_command, "skipstr") )
   skipstr(input_file_1_path, output_file_1_path, parameter_1_string);
 
   if (! strcmp(najitool_command, "skpalnum") )
   skpalnum(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "skpalpha") )
   skpalpha(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "skpcntrl") )
   skpcntrl(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "skpdigit") )
   skpdigit(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "skpgraph") )
   skpgraph(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "skplower") )
   skplower(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "skpprint") )
   skpprint(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "skppunct") )
   skppunct(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "skpspace") )
   skpspace(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "skpupper") )
   skpupper(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "skpxdigt") )
   skpxdigt(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "strachar") )
   strachar(parameter_1_string, input_file_1_path, output_file_1_path);
   
   if (! strcmp(najitool_command, "strbchar") )
   strbchar(parameter_1_string, input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "strbline") )
   strbline(input_file_1_path, output_file_1_path, parameter_1_string);

   if (! strcmp(najitool_command, "streline") )
   streline(input_file_1_path, output_file_1_path, parameter_1_string);

   if (! strcmp(najitool_command, "strfile") )
   strfile(output_file_1_path, atoi(parameter_1_string), parameter_2_string);

   if (! strcmp(najitool_command, "swapfeb") )
   swapfeb(input_file_1_path, input_file_2_path, output_file_1_path);

   if (! strcmp(najitool_command, "systemdt") )
   {
   systemdt();
   return true;
   }

   if (! strcmp(najitool_command, "tabspace") )
   tabspace(atoi(parameter_1_string), input_file_1_path, output_file_1_path);
   
   
   if (! strcmp(najitool_command, "telltime") )
   {
   telltime();
   return true;
   }

   if (! strcmp(najitool_command, "today") )
   {
   today();
   return true;
   }
            
   if (! strcmp(najitool_command, "tothe") )
   {
   tothe(parameter_1_string);
   return true;
   }

   if (! strcmp(najitool_command, "ttt") )
   {
   ttt ttt_game {};
   ttt_game.Modal();
   return true;
   }  

   if (! strcmp(najitool_command, "turnum") )
   {
   turnum(output_file_1_path);
   return true;
   }

   if (! strcmp(najitool_command, "txt2html") )
   txt2html(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "unihtml") )
   naji_gen_unicode_html_pages(output_folder_path);

   if (! strcmp(najitool_command, "unajirle") )
   unajirle(input_file_1_path, output_file_1_path);
  
   if (! strcmp(najitool_command, "unblanka") )
   unblanka(input_file_1_path, output_file_1_path);  
 
   if (! strcmp(najitool_command, "unix2dos") )
   unix2dos(input_file_1_path, output_file_1_path);      
 
   if (! strcmp(najitool_command, "uudecode") )
   uudecode(input_file_1_path, output_file_1_path);
 
   if (! strcmp(najitool_command, "uuencode") )
   uuencode(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "vowelwrd") )
   {
   help_edit_box.Clear();
   vowelwrd(parameter_1_string);
   return true;
   }

   if (! strcmp(najitool_command, "wordline") )
   wordline(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "wordwrap") )
   wordwrap(input_file_1_path, output_file_1_path);

   if (! strcmp(najitool_command, "wrdcount") )
   {
   help_edit_box.Clear();
   help_edit_box.Printf("%u", wrdcount(input_file_1_path));
   return true;
   }
 
   if (! strcmp(najitool_command, "year") )
   {
   year();
   return true;
   }
 
   if (! strcmp(najitool_command, "yil") )
   {
   yil();
   return true;
   }

   if (! strcmp(najitool_command, "zerokill") )
   zerokill(output_file_1_path);





   if (!strcmp(najitool_language, "English"))
   MessageBox { text = "najitool GUI", contents = "Processing complete." }.Modal();
   
   else if (!strcmp(najitool_language, "Turkish"))
   MessageBox { text = "najitool GUI", contents = "Islem tamamlandi." }.Modal();

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
   BitmapResource najitool_logo_bitmap { ":najitool.pcx", window = this };

   void OnRedraw(Surface surface)
   {
   surface.Blit(najitool_logo_bitmap.bitmap, 8, 24, 0,0, najitool_logo_bitmap.bitmap.width, najitool_logo_bitmap.bitmap.height);
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

    if (string[i] == ' ') { bigascii_naji_(a); }
    if (string[i] == 'a') { bigascii_naji_a(a); }
    if (string[i] == 'b') { bigascii_naji_b(a); }
    if (string[i] == 'c') { bigascii_naji_c(a); }
    if (string[i] == 'd') { bigascii_naji_d(a); }
    if (string[i] == 'e') { bigascii_naji_e(a); }
    if (string[i] == 'f') { bigascii_naji_f(a); }
    if (string[i] == 'g') { bigascii_naji_g(a); }
    if (string[i] == 'h') { bigascii_naji_h(a); }
    if (string[i] == 'i') { bigascii_naji_i(a); }
    if (string[i] == 'j') { bigascii_naji_j(a); }
    if (string[i] == 'k') { bigascii_naji_k(a); }
    if (string[i] == 'l') { bigascii_naji_l(a); }
    if (string[i] == 'm') { bigascii_naji_m(a); }
    if (string[i] == 'n') { bigascii_naji_n(a); }
    if (string[i] == 'o') { bigascii_naji_o(a); }
    if (string[i] == 'p') { bigascii_naji_p(a); }
    if (string[i] == 'q') { bigascii_naji_q(a); }
    if (string[i] == 'r') { bigascii_naji_r(a); }
    if (string[i] == 's') { bigascii_naji_s(a); }
    if (string[i] == 't') { bigascii_naji_t(a); }
    if (string[i] == 'u') { bigascii_naji_u(a); }
    if (string[i] == 'v') { bigascii_naji_v(a); }
    if (string[i] == 'w') { bigascii_naji_w(a); }
    if (string[i] == 'x') { bigascii_naji_x(a); }
    if (string[i] == 'y') { bigascii_naji_y(a); }
    if (string[i] == 'z') { bigascii_naji_z(a); }

    if (string[i] == 'A') { bigascii_naji_a(a); }
    if (string[i] == 'B') { bigascii_naji_b(a); }
    if (string[i] == 'C') { bigascii_naji_c(a); }
    if (string[i] == 'D') { bigascii_naji_d(a); }
    if (string[i] == 'E') { bigascii_naji_e(a); }
    if (string[i] == 'F') { bigascii_naji_f(a); }
    if (string[i] == 'G') { bigascii_naji_g(a); }
    if (string[i] == 'H') { bigascii_naji_h(a); }
    if (string[i] == 'I') { bigascii_naji_i(a); }
    if (string[i] == 'J') { bigascii_naji_j(a); }
    if (string[i] == 'K') { bigascii_naji_k(a); }
    if (string[i] == 'L') { bigascii_naji_l(a); }
    if (string[i] == 'M') { bigascii_naji_m(a); }
    if (string[i] == 'N') { bigascii_naji_n(a); }
    if (string[i] == 'O') { bigascii_naji_o(a); }
    if (string[i] == 'P') { bigascii_naji_p(a); }
    if (string[i] == 'Q') { bigascii_naji_q(a); }
    if (string[i] == 'R') { bigascii_naji_r(a); }
    if (string[i] == 'S') { bigascii_naji_s(a); }
    if (string[i] == 'T') { bigascii_naji_t(a); }
    if (string[i] == 'U') { bigascii_naji_u(a); }
    if (string[i] == 'V') { bigascii_naji_v(a); }
    if (string[i] == 'W') { bigascii_naji_w(a); }
    if (string[i] == 'X') { bigascii_naji_x(a); }
    if (string[i] == 'Y') { bigascii_naji_y(a); }
    if (string[i] == 'Z') { bigascii_naji_z(a); }

    if (string[i] == '1') { bigascii_naji_1(a); }
    if (string[i] == '2') { bigascii_naji_2(a); }
    if (string[i] == '3') { bigascii_naji_3(a); }
    if (string[i] == '4') { bigascii_naji_4(a); }
    if (string[i] == '5') { bigascii_naji_5(a); }
    if (string[i] == '6') { bigascii_naji_6(a); }
    if (string[i] == '7') { bigascii_naji_7(a); }
    if (string[i] == '8') { bigascii_naji_8(a); }
    if (string[i] == '9') { bigascii_naji_9(a); }
    if (string[i] == '0') { bigascii_naji_0(a); }

    if (string[i] == ',')  { bigascii_naji_ascii_coma(a); }
    if (string[i] == '`')  { bigascii_naji_ascii_aposopen(a); }
    if (string[i] == '\'') { bigascii_naji_ascii_aposclose(a); }
    if (string[i] == '.')  { bigascii_naji_ascii_period(a); }
    if (string[i] == ':')  { bigascii_naji_ascii_colon(a); }
    if (string[i] == ';')  { bigascii_naji_ascii_semicolon(a); }
    if (string[i] == '<')  { bigascii_naji_ascii_lessthan(a); }
    if (string[i] == '>')  { bigascii_naji_ascii_morethan(a); }
    if (string[i] == '(')  { bigascii_naji_ascii_paranopen(a); }
    if (string[i] == ')')  { bigascii_naji_ascii_paranclose(a); }
    if (string[i] == '_')  { bigascii_naji_ascii_underscore(a); }
    if (string[i] == '!')  { bigascii_naji_ascii_exclaimark(a); }
    if (string[i] == '|')  { bigascii_naji_ascii_pipe(a); }
    if (string[i] == '#')  { bigascii_naji_ascii_numsign(a); }
    if (string[i] == '/')  { bigascii_naji_ascii_fslash(a); }
    if (string[i] == '\\') { bigascii_naji_ascii_bslash(a); }

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

    while(1)
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

    while(1)
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


     while(1)
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
char *units[10] = {
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

char *teens[10] = {
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

char *tens[8] = {
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
char *units[10] = {
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

char *teens[10] = {
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

char *tens[8] = {
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
             contents =  "ERROR: start value cannot be greater than end value." }.Modal();

       else if (!strcmp(najitool_language, "Turkish"))
   MessageBox { text = "najitool GUI gplus hata",
             contents =  "HATA: baslangic degeri bitis degerin den daha fazla olamaz." }.Modal();
 

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
             contents =  "ERROR: start value cannot be greater than end value." }.Modal();

       else if (!strcmp(najitool_language, "Turkish"))
   MessageBox { text = "najitool GUI gminus hata",
             contents =  "HATA: baslangic degeri bitis degerin den daha fazla olamaz." }.Modal();


  
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
             contents =  "ERROR: start value cannot be greater than end value." }.Modal();

       else if (!strcmp(najitool_language, "Turkish"))
   MessageBox { text = "najitool GUI gtimes hata",
             contents =  "HATA: baslangic degeri bitis degerin den daha fazla olamaz." }.Modal();



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
             contents =  "ERROR: start value cannot be greater than end value." }.Modal();

       else if (!strcmp(najitool_language, "Turkish"))
   MessageBox { text = "najitool GUI gdivide hata",
             contents =  "HATA: baslangic degeri bitis degerin den daha fazla olamaz." }.Modal();


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


        for(x=0; x<cvlen; x++)
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
                swap_char(cva[x], cva[y])
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

  if (b == 'a') { help_edit_box.Printf("4"); return; }
  if (b == 'b') { help_edit_box.Printf("8"); return; }
  if (b == 'e') { help_edit_box.Printf("3"); return; }
  if (b == 'i') { help_edit_box.Printf("1"); return; }
  if (b == 'o') { help_edit_box.Printf("0"); return; }
  if (b == 's') { help_edit_box.Printf("5"); return; }
  if (b == 't') { help_edit_box.Printf("7"); return; }
  if (b == 'd') { help_edit_box.Printf("|>");     return; }
  if (b == 'c') { help_edit_box.Printf("<");      return; }
  if (b == 'k') { help_edit_box.Printf("|<");     return; }
  if (b == 'm') { help_edit_box.Printf("/\\/\\"); return; }
  if (b == 'v') { help_edit_box.Printf("\\/");    return; }
  if (b == 'w') { help_edit_box.Printf("\\/\\/"); return; }
  if (b == 'h') { help_edit_box.Printf("|-|");    return; }
  if (b == 'n') { help_edit_box.Printf("|\\|");   return; }
  if (b == 'x') { help_edit_box.Printf("><");     return; }
  if (b == 'u') { help_edit_box.Printf("|_|");    return; }
  if (b == 'l') { help_edit_box.Printf("|_");     return; }
  if (b == 'j') { help_edit_box.Printf("_|");     return; }


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


        if(remove(fnamebuf) < 0)
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

    while(1)
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
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////












class tab_crypt : Tab
{
   text = "Crypt";
   background = { r = 110, g = 161, b = 180 };
   font = { "Verdana", 8.25f, bold = true };
   size = { 1024, 768 };

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
   BitmapResource najitool_logo_bitmap { ":najitool.pcx", window = this };

   void OnRedraw(Surface surface)
   {
   surface.Blit(najitool_logo_bitmap.bitmap, 8, 24, 0,0, najitool_logo_bitmap.bitmap.width, najitool_logo_bitmap.bitmap.height);
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

        while(1)
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








static String length_string_array[8] = {
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
   size = { 1024, 768 };

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
   BitmapResource najitool_logo_bitmap { ":najitool.pcx", window = this };

   void OnRedraw(Surface surface)
   {
   surface.Blit(najitool_logo_bitmap.bitmap, 8, 24, 0,0, najitool_logo_bitmap.bitmap.width, najitool_logo_bitmap.bitmap.height);
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





static String splitter_sizes_string_array[4] = {
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
   size = { 1024, 768 };

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
   BitmapResource najitool_logo_bitmap { ":najitool.pcx", window = this };

   void OnRedraw(Surface surface)
   {
   surface.Blit(najitool_logo_bitmap.bitmap, 8, 24, 0,0, najitool_logo_bitmap.bitmap.width, najitool_logo_bitmap.bitmap.height);
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

         if(atoi(splitter_size_edit_box.contents) == 0)
         {
         
         if (!strcmp(najitool_language, "English"))
         msgbox("najitool File Splitter error", "Cannot split files into 0 size pieces..");
         else if (!strcmp(najitool_language, "Turkish"))
         msgbox("najitool Dosya Bolucu Hata", "0 boyut parcali dosya bolunmez.");
         
         return true;
         }

         if (!strcmp(splitter_size_measurement, "bytes"))
         {
         bytsplit(splitter_input_file_edit_box.contents, atoi(splitter_size_edit_box.contents), splitter_output_folder_edit_box.contents);

         if (!strcmp(najitool_language, "English"))
         msgbox("najitool GUI File Splitter", "File splitting complete.");
         else if (!strcmp(najitool_language, "Turkish"))
         msgbox("najitool GUI Dosya Bolucu", "Dosya bolunmesi tamamlandi.");
         }

         else if (!strcmp(splitter_size_measurement, "kb"))
         {
         kbsplit(splitter_input_file_edit_box.contents, atoi(splitter_size_edit_box.contents), splitter_output_folder_edit_box.contents);
         if (!strcmp(najitool_language, "English"))
         msgbox("najitool GUI File Splitter", "File splitting complete.");
         else if (!strcmp(najitool_language, "Turkish"))
         msgbox("najitool GUI Dosya Bolucu", "Dosya bolunmesi tamamlandi.");
         }

         else if (!strcmp(splitter_size_measurement, "mb"))
         {
         mbsplit(splitter_input_file_edit_box.contents, atoi(splitter_size_edit_box.contents), splitter_output_folder_edit_box.contents);
         if (!strcmp(najitool_language, "English"))
         msgbox("najitool GUI File Splitter", "File splitting complete.");
         else if (!strcmp(najitool_language, "Turkish"))
         msgbox("najitool GUI Dosya Bolucu", "Dosya bolunmesi tamamlandi.");
         }

         else if (!strcmp(splitter_size_measurement, "gb"))
         {
         gbsplit(splitter_input_file_edit_box.contents, atoi(splitter_size_edit_box.contents), splitter_output_folder_edit_box.contents);
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
            mjoin(splitter_a_split_file_path, splitter_join_output_file_path);

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

   void bytsplit(char *namein, unsigned long peice_size, char *output_folder)
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

   void kbsplit(char *namein, unsigned long peice_size, char *output_folder)
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

   void mbsplit(char *namein, unsigned long peice_size, char *output_folder)
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

   void gbsplit(char *namein, unsigned long peice_size, char *output_folder)
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

   void mjoin(char *namein_original_filename, char *nameout_joined_output_file)
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

class tab_database : Tab
{
   text = "Database";
   background = { r = 110, g = 161, b = 180 };
   font = { "Verdana", 8.25f, bold = true };
   size = { 1024, 768 };
   position = { 8, 16 };

   Button clear_all_entry_items_button 
   {      
      this, text = "Clear All Entry Items", position = { 8, 680 };

      bool NotifyClicked(Button button, int x, int y, Modifiers mods)
      {
title_edit_box.Clear();
full_name_edit_box.Clear();
gender_edit_box.Clear();
date_of_birth_edit_box.Clear();
marital_status_edit_box.Clear();
naji_db_height_edit_box.Clear();
naji_db_weight_edit_box.Clear();
naji_db_build_edit_box.Clear();
hair_color_edit_box.Clear();
eye_color_edit_box.Clear();
favourite_food_edit_box.Clear();
favourite_drink_edit_box.Clear();
home_number_edit_box.Clear();
work_number_edit_box.Clear();
fax_number_edit_box.Clear();
cell_number_edit_box.Clear();
home_address_edit_box.Clear();
work_address_edit_box.Clear();
occupation_edit_box.Clear();
naji_db_email_edit_box.Clear();
naji_db_website_edit_box.Clear();
mothers_full_name_edit_box.Clear();
mothers_dob_edit_box.Clear();
fathers_full_name_edit_box.Clear();
fathers_dob_edit_box.Clear();
number_of_sisters_edit_box.Clear();
number_of_brothers_edit_box.Clear();
number_of_children_edit_box.Clear();

         return true;
      }
   };
   Label title_label { this, text = "Title:", position = { 8, 16 } };
   Label full_name_label { this, text = "Full name:", position = { 8, 40 } };
   Label gender_label { this, text = "Gender:", position = { 8, 64 } };
   Label date_of_birth_label { this, text = "Date of birth:", position = { 8, 88 } };
   Label marital_status_label { this, text = "Marital status:", position = { 8, 112 } };
   Label naji_db_height_label { this, text = "Height:", position = { 8, 136 } };
   Label naji_db_weight_label { this, text = "Weight:", size = { 54, 13 }, position = { 8, 160 } };
   Label naji_db_build_label { this, text = "Build:", position = { 8, 184 } };
   Label hair_color_label { this, text = "Hair color:", position = { 8, 208 } };
   Label eye_color_label { this, text = "Eye color:", position = { 8, 232 } };
   Label favourite_food_label { this, text = "Favourite food:", position = { 8, 256 } };
   Label favourite_drink_label { this, text = "Favourite drink:", position = { 8, 280 } };
   Label home_number_label { this, text = "Home number:", position = { 8, 304 } };
   Label work_number_label { this, text = "Work number:", position = { 8, 328 } };
   Label occupation_label { this, text = "Occupation", position = { 8, 448 } };
   Label fax_number_label { this, text = "Fax number:", position = { 8, 352 } };
   Label cell_number_label { this, text = "Cell number:", position = { 8, 376 } };
   Label home_address_label { this, text = "Home address:", position = { 8, 400 } };
   Label work_address_label { this, text = "Work address:", position = { 8, 424 } };
   Label naji_db_email_label { this, text = "e-mail:", position = { 8, 472 } };
   Label naji_db_website_label { this, text = "Website:", position = { 8, 496 } };
   Label mothers_full_name_label { this, text = "Mother's full name:", position = { 8, 520 } };
   Label mothers_dob_label { this, text = "Mother's date of birth:", position = { 8, 544 } };
   Label fathers_full_name_label { this, text = "Father's full name:", position = { 8, 568 } };
   Label fathers_dob_label { this, text = "Father's date of birth:", position = { 8, 592 } };
   Label number_of_sisters_label { this, text = "Number of sisters:", position = { 8, 616 } };
   Label number_of_brothers_label { this, text = "Number of brothers:", position = { 8, 640 } };
   Label number_of_children_label { this, text = "Number of children:", position = { 8, 664 } };
   EditBox title_edit_box { this, size = { 246, 19 }, position = { 160, 8 } };
   EditBox full_name_edit_box { this, size = { 246, 19 }, position = { 160, 32 } };
   EditBox gender_edit_box { this, size = { 246, 19 }, position = { 160, 56 } };
   EditBox date_of_birth_edit_box { this, size = { 246, 19 }, position = { 160, 80 } };
   EditBox marital_status_edit_box { this, size = { 246, 19 }, position = { 160, 104 } };
   EditBox naji_db_height_edit_box { this, size = { 246, 19 }, position = { 160, 128 } };
   EditBox naji_db_weight_edit_box { this, size = { 246, 19 }, position = { 160, 152 } };
   EditBox naji_db_build_edit_box { this, size = { 246, 19 }, position = { 160, 176 } };
   EditBox hair_color_edit_box { this, size = { 246, 19 }, position = { 160, 200 } };
   EditBox eye_color_edit_box { this, size = { 246, 19 }, position = { 160, 224 } }
   EditBox favourite_food_edit_box { this, size = { 246, 19 }, position = { 160, 248 } };
   EditBox favourite_drink_edit_box { this, size = { 246, 19 }, position = { 160, 272 } };
   EditBox home_number_edit_box { this, size = { 246, 19 }, position = { 160, 296 } };
   EditBox work_number_edit_box { this, size = { 246, 19 }, position = { 160, 320 } };
   EditBox fax_number_edit_box { this, size = { 246, 19 }, position = { 160, 344 } };
   EditBox cell_number_edit_box { this, size = { 246, 19 }, position = { 160, 368 } };
   EditBox home_address_edit_box { this, size = { 246, 19 }, position = { 160, 392 } };
   EditBox work_address_edit_box { this, size = { 246, 19 }, position = { 160, 416 } };
   EditBox occupation_edit_box { this, size = { 246, 19 }, position = { 160, 440 } };
   EditBox naji_db_email_edit_box { this, size = { 246, 19 }, position = { 160, 464 } };
   EditBox naji_db_website_edit_box { this, size = { 246, 19 }, position = { 160, 488 } };
   EditBox mothers_full_name_edit_box { this, size = { 246, 19 }, position = { 160, 512 } };
   EditBox mothers_dob_edit_box { this, size = { 246, 19 }, position = { 160, 536 } };
   EditBox fathers_full_name_edit_box { this, size = { 246, 19 }, position = { 160, 560 } };
   EditBox fathers_dob_edit_box { this, size = { 246, 19 }, position = { 160, 584 } };
   EditBox number_of_sisters_edit_box { this, size = { 246, 19 }, position = { 160, 608 } };
   EditBox number_of_brothers_edit_box { this, size = { 246, 19 }, position = { 160, 632 } };
   EditBox number_of_children_edit_box { this, size = { 246, 19 }, position = { 160, 656 } };
   Button add_entry_button 
   {
      this, text = "Add Entry", position = { 416, 664 };

      bool NotifyClicked(Button button, int x, int y, Modifiers mods)
      {
         if (naji_db_file_selected == true)
         {

         view_database_edit_box.Clear();
         
     
      if (naji_db_html_selected == true)
      {
      
      if (!strcmp(najitool_language, "English"))
      {
      
      fprintf(naji_db_file, "\n<hr>\n");
      add_entry_item_html("Title:", title_edit_box.contents);
      add_entry_item_html("Full name:", full_name_edit_box.contents);
      add_entry_item_html("Gender:", gender_edit_box.contents);
      add_entry_item_html("Date of birth:", date_of_birth_edit_box.contents);
      add_entry_item_html("Marital status:", marital_status_edit_box.contents);
      add_entry_item_html("Height:", naji_db_height_edit_box.contents);
      add_entry_item_html("Weight:", naji_db_weight_edit_box.contents);
      add_entry_item_html("Build:", naji_db_build_edit_box.contents);
      add_entry_item_html("Hair color:", hair_color_edit_box.contents);
      add_entry_item_html("Eye color:", eye_color_edit_box.contents);
      add_entry_item_html("Favourite food:", favourite_food_edit_box.contents);
      add_entry_item_html("Favourite drink:", favourite_drink_edit_box.contents);
      add_entry_item_html("Home number:", home_number_edit_box.contents);
      add_entry_item_html("Work number:", work_number_edit_box.contents);
      add_entry_item_html("Fax number:", fax_number_edit_box.contents);
      add_entry_item_html("Cell number:", cell_number_edit_box.contents);
      add_entry_item_html("Home address:", home_address_edit_box.contents);
      add_entry_item_html("Work address:", work_address_edit_box.contents);
      add_entry_item_html("Occupation:", occupation_edit_box.contents);
      add_entry_item_html_email("e-mail:", naji_db_email_edit_box.contents);
      add_entry_item_html_link("Website:", naji_db_website_edit_box.contents);
      add_entry_item_html("Mother's full name:", mothers_full_name_edit_box.contents);
      add_entry_item_html("Mother's date of birth:", mothers_dob_edit_box.contents);
      add_entry_item_html("Father's full name:", fathers_full_name_edit_box.contents);
      add_entry_item_html("Father's date of birth:", fathers_dob_edit_box.contents);
      add_entry_item_html("Number of sisters:", number_of_sisters_edit_box.contents);
      add_entry_item_html("Number of brothers:", number_of_brothers_edit_box.contents);
      add_entry_item_html("Number of children:", number_of_children_edit_box.contents);   
      }
      if (!strcmp(najitool_language, "Turkish"))
      {
      fprintf(naji_db_file, "\n<hr>\n");
      add_entry_item_html("Unvan:", title_edit_box.contents);
      add_entry_item_html("Tum Isim:", full_name_edit_box.contents);
      add_entry_item_html("Cinsiyet:", gender_edit_box.contents);
      add_entry_item_html("Dogum Tarih:", date_of_birth_edit_box.contents);
      add_entry_item_html("Evlilik Durumu:", marital_status_edit_box.contents);
      add_entry_item_html("Boy:", naji_db_height_edit_box.contents);
      add_entry_item_html("Kilo:", naji_db_weight_edit_box.contents);
      add_entry_item_html("Yapi:", naji_db_build_edit_box.contents);
      add_entry_item_html("Sac Renk:", hair_color_edit_box.contents);
      add_entry_item_html("Goz Renk:", eye_color_edit_box.contents);
      add_entry_item_html("En Sevdigi Yemek:", favourite_food_edit_box.contents);
      add_entry_item_html("En Sevdigi Icicek:", favourite_drink_edit_box.contents);
      add_entry_item_html("Ev Telefon:", home_number_edit_box.contents);
      add_entry_item_html("Is Telefon:", work_number_edit_box.contents);
      add_entry_item_html("Faks Numara:", fax_number_edit_box.contents);
      add_entry_item_html("Cep Telefon:", cell_number_edit_box.contents);
      add_entry_item_html("Ev Adres:", home_address_edit_box.contents);
      add_entry_item_html("Is Adres:", work_address_edit_box.contents);
      add_entry_item_html("Meslek:", occupation_edit_box.contents);
      add_entry_item_html_email("E-Posta Adres:", naji_db_email_edit_box.contents);
      add_entry_item_html_link("Vebsite:", naji_db_website_edit_box.contents);
      add_entry_item_html("Tum Ana Ismi:", mothers_full_name_edit_box.contents);
      add_entry_item_html("Ana Dogum Tahri:", mothers_dob_edit_box.contents);
      add_entry_item_html("Tum Baba Ismi:", fathers_full_name_edit_box.contents);
      add_entry_item_html("Baba Dogum Tarih:", fathers_dob_edit_box.contents);
      add_entry_item_html("Kac Abla/Kiz Kardes:", number_of_sisters_edit_box.contents);
      add_entry_item_html("Kac Abi/Erkek Kardes:", number_of_brothers_edit_box.contents);
      add_entry_item_html("Cocuk Sayisi:", number_of_children_edit_box.contents);   
      }
      
      
      }

      else
      {   
  
      if (!strcmp(najitool_language, "English"))
      {
  
      fprintf(naji_db_file, "Title: %s\n", title_edit_box.contents);
      fprintf(naji_db_file, "Full name: %s\n", full_name_edit_box.contents);
      fprintf(naji_db_file, "Gender: %s\n", gender_edit_box.contents);
      fprintf(naji_db_file, "Date of birth: %s\n", date_of_birth_edit_box.contents);
      fprintf(naji_db_file, "Marital status: %s\n", marital_status_edit_box.contents);
      fprintf(naji_db_file, "Height: %s\n", naji_db_height_edit_box.contents);
      fprintf(naji_db_file, "Weight: %s\n", naji_db_weight_edit_box.contents);
      fprintf(naji_db_file, "Build: %s\n", naji_db_build_edit_box.contents);
      fprintf(naji_db_file, "Hair color: %s\n", hair_color_edit_box.contents);
      fprintf(naji_db_file, "Eye color: %s\n", eye_color_edit_box.contents);
      fprintf(naji_db_file, "Favourite food: %s\n", favourite_food_edit_box.contents);
      fprintf(naji_db_file, "Favourite drink: %s\n", favourite_drink_edit_box.contents);
      fprintf(naji_db_file, "Home number: %s\n", home_number_edit_box.contents);
      fprintf(naji_db_file, "Work number: %s\n", work_number_edit_box.contents);
      fprintf(naji_db_file, "Fax number: %s\n", fax_number_edit_box.contents);
      fprintf(naji_db_file, "Cell number: %s\n", cell_number_edit_box.contents);
      fprintf(naji_db_file, "Home address: %s\n", home_address_edit_box.contents);
      fprintf(naji_db_file, "Work address: %s\n", work_address_edit_box.contents);
      fprintf(naji_db_file, "Occupation: %s\n", occupation_edit_box.contents);
      fprintf(naji_db_file, "e-mail: %s\n", naji_db_email_edit_box.contents);
      fprintf(naji_db_file, "Website: %s\n", naji_db_website_edit_box.contents);
      fprintf(naji_db_file, "Mother's full name: %s\n", mothers_full_name_edit_box.contents);
      fprintf(naji_db_file, "Mother's date of birth: %s\n", mothers_dob_edit_box.contents);
      fprintf(naji_db_file, "Father's full name: %s\n", fathers_full_name_edit_box.contents);
      fprintf(naji_db_file, "Father's date of birth: %s\n", fathers_dob_edit_box.contents);
      fprintf(naji_db_file, "Number of sisters: %s\n", number_of_sisters_edit_box.contents);
      fprintf(naji_db_file, "Number of brothers: %s\n", number_of_brothers_edit_box.contents);
      fprintf(naji_db_file, "Number of children: %s\n\n", number_of_children_edit_box.contents);
      }
      
      
  
      if (!strcmp(najitool_language, "Turkish"))
      {
  
      fprintf(naji_db_file, "Unvan: %s\n", title_edit_box.contents);
      fprintf(naji_db_file, "Tum Isim: %s\n", full_name_edit_box.contents);
      fprintf(naji_db_file, "Cinsiyet: %s\n", gender_edit_box.contents);
      fprintf(naji_db_file, "Dogum Tarih: %s\n", date_of_birth_edit_box.contents);
      fprintf(naji_db_file, "Evlilik Durumu: %s\n", marital_status_edit_box.contents);
      fprintf(naji_db_file, "Boy: %s\n", naji_db_height_edit_box.contents);
      fprintf(naji_db_file, "Kilo: %s\n", naji_db_weight_edit_box.contents);
      fprintf(naji_db_file, "Yapi: %s\n", naji_db_build_edit_box.contents);
      fprintf(naji_db_file, "Sac Renk: %s\n", hair_color_edit_box.contents);
      fprintf(naji_db_file, "Goz Renk: %s\n", eye_color_edit_box.contents);
      fprintf(naji_db_file, "En Sevdigi Yemek: %s\n", favourite_food_edit_box.contents);
      fprintf(naji_db_file, "En Sevdigi Icicek: %s\n", favourite_drink_edit_box.contents);
      fprintf(naji_db_file, "Ev Telefon: %s\n", home_number_edit_box.contents);
      fprintf(naji_db_file, "Is Telefon: %s\n", work_number_edit_box.contents);
      fprintf(naji_db_file, "Faks Numara: %s\n", fax_number_edit_box.contents);
      fprintf(naji_db_file, "Cep Telefon: %s\n", cell_number_edit_box.contents);
      fprintf(naji_db_file, "Ev Adres: %s\n", home_address_edit_box.contents);
      fprintf(naji_db_file, "Is Adres: %s\n", work_address_edit_box.contents);
      fprintf(naji_db_file, "Meslek: %s\n", occupation_edit_box.contents);
      fprintf(naji_db_file, "E-Posta Adres: %s\n", naji_db_email_edit_box.contents);
      fprintf(naji_db_file, "Vebsite: %s\n", naji_db_website_edit_box.contents);
      fprintf(naji_db_file, "Tum Ana Ismi: %s\n", mothers_full_name_edit_box.contents);
      fprintf(naji_db_file, "Ana Dogum Tarih: %s\n", mothers_dob_edit_box.contents);
      fprintf(naji_db_file, "Tum Baba Ismi: %s\n", fathers_full_name_edit_box.contents);
      fprintf(naji_db_file, "Baba Dogum Tarih: %s\n", fathers_dob_edit_box.contents);
      fprintf(naji_db_file, "Kac Abla/Kiz Kardes: %s\n", number_of_sisters_edit_box.contents);
      fprintf(naji_db_file, "Kac Abi/Erkek Kardes: %s\n", number_of_brothers_edit_box.contents);
      fprintf(naji_db_file, "Cocuk Sayisi: %s\n\n", number_of_children_edit_box.contents);
      }
      
      
      }   
          
   
   
          fseek (naji_db_file , 0, SEEK_SET);

          while (1)
            {

         
            naji_db_a = fgetc(naji_db_file);

            if (naji_db_a == EOF)
            break;


            view_database_edit_box.AddCh(naji_db_a);
            }
     
         
         
         
         }
         else
         {
         
         
         if (!strcmp(najitool_language, "English"))
         MessageBox { text = "najitool GUI database error:", contents = "Please select a file to create or to append the database entries to." }.Modal();
         else if (!strcmp(najitool_language, "Turkish"))
         MessageBox { text = "najitool GUI veritabani hata:", contents = "Lutfen bir dosya secin olusturmak icin veya bir dosya secin veritabani kayitlari eklenmesi icin." }.Modal();
         
         
         
         }
    










         return true;
      }
   };
   Button add_entry_omits_empty_items_button 
   {      
      this, text = "Add Entry, Omits Empty Items", position = { 496, 664 };

      bool NotifyClicked(Button button, int x, int y, Modifiers mods)
      {


         if (naji_db_file_selected == true)
         {

         view_database_edit_box.Clear();
         
     
      if (naji_db_html_selected == true)
      {
      
      if (!strcmp(najitool_language, "English"))
      {
      
      
      fprintf(naji_db_file, "\n<hr>\n");
      if (strcmp(title_edit_box.contents, "")) add_entry_item_html("Title:", title_edit_box.contents);
      if (strcmp(full_name_edit_box.contents, "")) add_entry_item_html("Full name:", full_name_edit_box.contents);
      if (strcmp(gender_edit_box.contents, "")) add_entry_item_html("Gender:", gender_edit_box.contents);
      if (strcmp(date_of_birth_edit_box.contents, "")) add_entry_item_html("Date of birth:", date_of_birth_edit_box.contents);
      if (strcmp(marital_status_edit_box.contents, "")) add_entry_item_html("Marital status:", marital_status_edit_box.contents);
      if (strcmp(naji_db_height_edit_box.contents, "")) add_entry_item_html("Height:", naji_db_height_edit_box.contents);
      if (strcmp(naji_db_weight_edit_box.contents, "")) add_entry_item_html("Weight:", naji_db_weight_edit_box.contents);
      if (strcmp(naji_db_build_edit_box.contents, "")) add_entry_item_html("Build:", naji_db_build_edit_box.contents);
      if (strcmp(hair_color_edit_box.contents, "")) add_entry_item_html("Hair color:", hair_color_edit_box.contents);
      if (strcmp(eye_color_edit_box.contents, "")) add_entry_item_html("Eye color:", eye_color_edit_box.contents);
      if (strcmp(favourite_food_edit_box.contents, "")) add_entry_item_html("Favourite food:", favourite_food_edit_box.contents);
      if (strcmp(favourite_drink_edit_box.contents, "")) add_entry_item_html("Favourite drink:", favourite_drink_edit_box.contents);
      if (strcmp(home_number_edit_box.contents, "")) add_entry_item_html("Home number:", home_number_edit_box.contents);
      if (strcmp(work_number_edit_box.contents, "")) add_entry_item_html("Work number:", work_number_edit_box.contents);
      if (strcmp(fax_number_edit_box.contents, "")) add_entry_item_html("Fax number:", fax_number_edit_box.contents);
      if (strcmp(cell_number_edit_box.contents, "")) add_entry_item_html("Cell number:", cell_number_edit_box.contents);
      if (strcmp(home_address_edit_box.contents, "")) add_entry_item_html("Home address:", home_address_edit_box.contents);
      if (strcmp(work_address_edit_box.contents, "")) add_entry_item_html("Work address:", work_address_edit_box.contents);
      if (strcmp(occupation_edit_box.contents, "")) add_entry_item_html("Occupation:", occupation_edit_box.contents);
      if (strcmp(naji_db_email_edit_box.contents, "")) add_entry_item_html_email("e-mail:", naji_db_email_edit_box.contents);
      if (strcmp(naji_db_website_edit_box.contents, "")) add_entry_item_html_link("Website:", naji_db_website_edit_box.contents);
      if (strcmp(mothers_full_name_edit_box.contents, "")) add_entry_item_html("Mother's full name:", mothers_full_name_edit_box.contents);
      if (strcmp(mothers_dob_edit_box.contents, "")) add_entry_item_html("Mother's date of birth:", mothers_dob_edit_box.contents);
      if (strcmp(fathers_full_name_edit_box.contents, "")) add_entry_item_html("Father's full name:", fathers_full_name_edit_box.contents);
      if (strcmp(fathers_dob_edit_box.contents, "")) add_entry_item_html("Father's date of birth:", fathers_dob_edit_box.contents);
      if (strcmp(number_of_sisters_edit_box.contents, "")) add_entry_item_html("Number of sisters:", number_of_sisters_edit_box.contents);
      if (strcmp(number_of_brothers_edit_box.contents, "")) add_entry_item_html("Number of brothers:", number_of_brothers_edit_box.contents);
      if (strcmp(number_of_children_edit_box.contents, "")) add_entry_item_html("Number of children:", number_of_children_edit_box.contents);
      }
    
      if (strcmp(najitool_language, "Turkish"))
      {

      fprintf(naji_db_file, "\n<hr>\n");
      if (strcmp(title_edit_box.contents, "")) add_entry_item_html("Unvan:", title_edit_box.contents);
      if (strcmp(full_name_edit_box.contents, "")) add_entry_item_html("Tum Isim:", full_name_edit_box.contents);
      if (strcmp(gender_edit_box.contents, "")) add_entry_item_html("Cinsiyet:", gender_edit_box.contents);
      if (strcmp(date_of_birth_edit_box.contents, "")) add_entry_item_html("Dogum Tarih:", date_of_birth_edit_box.contents);
      if (strcmp(marital_status_edit_box.contents, "")) add_entry_item_html("Evlilik Durumu:", marital_status_edit_box.contents);
      if (strcmp(naji_db_height_edit_box.contents, "")) add_entry_item_html("Boy:", naji_db_height_edit_box.contents);
      if (strcmp(naji_db_weight_edit_box.contents, "")) add_entry_item_html("Kilo:", naji_db_weight_edit_box.contents);
      if (strcmp(naji_db_build_edit_box.contents, "")) add_entry_item_html("Yapi:", naji_db_build_edit_box.contents);
      if (strcmp(hair_color_edit_box.contents, "")) add_entry_item_html("Sac Renk:", hair_color_edit_box.contents);
      if (strcmp(eye_color_edit_box.contents, "")) add_entry_item_html("Goz Renk:", eye_color_edit_box.contents);
      if (strcmp(favourite_food_edit_box.contents, "")) add_entry_item_html("En Sevdigi Yemek:", favourite_food_edit_box.contents);
      if (strcmp(favourite_drink_edit_box.contents, "")) add_entry_item_html("En Sevdigi Icicek:", favourite_drink_edit_box.contents);
      if (strcmp(home_number_edit_box.contents, "")) add_entry_item_html("Ev Telefon:", home_number_edit_box.contents);
      if (strcmp(work_number_edit_box.contents, "")) add_entry_item_html("Is Telefon:", work_number_edit_box.contents);
      if (strcmp(fax_number_edit_box.contents, "")) add_entry_item_html("Faks Numara:", fax_number_edit_box.contents);
      if (strcmp(cell_number_edit_box.contents, "")) add_entry_item_html("Cep Telefon:", cell_number_edit_box.contents);
      if (strcmp(home_address_edit_box.contents, "")) add_entry_item_html("Ev Adres:", home_address_edit_box.contents);
      if (strcmp(work_address_edit_box.contents, "")) add_entry_item_html("Is Adres:", work_address_edit_box.contents);
      if (strcmp(occupation_edit_box.contents, "")) add_entry_item_html("Meslek:", occupation_edit_box.contents);
      if (strcmp(naji_db_email_edit_box.contents, "")) add_entry_item_html_email("E-Posta Adres:", naji_db_email_edit_box.contents);
      if (strcmp(naji_db_website_edit_box.contents, "")) add_entry_item_html_link("Vebsite:", naji_db_website_edit_box.contents);
      if (strcmp(mothers_full_name_edit_box.contents, "")) add_entry_item_html("Tum Ana Ismi:", mothers_full_name_edit_box.contents);
      if (strcmp(mothers_dob_edit_box.contents, "")) add_entry_item_html("Ana Dogum Tarih:", mothers_dob_edit_box.contents);
      if (strcmp(fathers_full_name_edit_box.contents, "")) add_entry_item_html("Tum Baba Ismi:", fathers_full_name_edit_box.contents);
      if (strcmp(fathers_dob_edit_box.contents, "")) add_entry_item_html("Baba Dogum Tarih:", fathers_dob_edit_box.contents);
      if (strcmp(number_of_sisters_edit_box.contents, "")) add_entry_item_html("Kac Abla/Kiz Kardes:", number_of_sisters_edit_box.contents);
      if (strcmp(number_of_brothers_edit_box.contents, "")) add_entry_item_html("Kac Abi/Erkek Kardes:", number_of_brothers_edit_box.contents);
      if (strcmp(number_of_children_edit_box.contents, "")) add_entry_item_html("Cocuk Sayisi:", number_of_children_edit_box.contents);


      }

    
    
    
    
      }
      else
      {   
      
      if (!strcmp(najitool_language, "English"))
      {
      
      
      if (strcmp(title_edit_box.contents, "")) fprintf(naji_db_file, "Title: %s\n", title_edit_box.contents);
      if (strcmp(full_name_edit_box.contents, "")) fprintf(naji_db_file, "Full name: %s\n", full_name_edit_box.contents);
      if (strcmp(gender_edit_box.contents, "")) fprintf(naji_db_file, "Gender: %s\n", gender_edit_box.contents);
      if (strcmp(date_of_birth_edit_box.contents, "")) fprintf(naji_db_file, "Date of birth: %s\n", date_of_birth_edit_box.contents);
      if (strcmp(marital_status_edit_box.contents, "")) fprintf(naji_db_file, "Marital status: %s\n", marital_status_edit_box.contents);
      if (strcmp(naji_db_height_edit_box.contents, "")) fprintf(naji_db_file, "Height: %s\n", naji_db_height_edit_box.contents);
      if (strcmp(naji_db_weight_edit_box.contents, "")) fprintf(naji_db_file, "Weight: %s\n", naji_db_weight_edit_box.contents);
      if (strcmp(naji_db_build_edit_box.contents, "")) fprintf(naji_db_file, "Build: %s\n", naji_db_build_edit_box.contents);
      if (strcmp(hair_color_edit_box.contents, "")) fprintf(naji_db_file, "Hair color: %s\n", hair_color_edit_box.contents);
      if (strcmp(eye_color_edit_box.contents, "")) fprintf(naji_db_file, "Eye color: %s\n", eye_color_edit_box.contents);
      if (strcmp(favourite_food_edit_box.contents, "")) fprintf(naji_db_file, "Favourite food: %s\n", favourite_food_edit_box.contents);
      if (strcmp(favourite_drink_edit_box.contents, "")) fprintf(naji_db_file, "Favourite drink: %s\n", favourite_drink_edit_box.contents);
      if (strcmp(home_number_edit_box.contents, "")) fprintf(naji_db_file, "Home number: %s\n", home_number_edit_box.contents);
      if (strcmp(work_number_edit_box.contents, "")) fprintf(naji_db_file, "Work number: %s\n", work_number_edit_box.contents);
      if (strcmp(fax_number_edit_box.contents, "")) fprintf(naji_db_file, "Fax number: %s\n", fax_number_edit_box.contents);
      if (strcmp(cell_number_edit_box.contents, "")) fprintf(naji_db_file, "Cell number: %s\n", cell_number_edit_box.contents);
      if (strcmp(home_address_edit_box.contents, "")) fprintf(naji_db_file, "Home address: %s\n", home_address_edit_box.contents);
      if (strcmp(work_address_edit_box.contents, "")) fprintf(naji_db_file, "Work address: %s\n", work_address_edit_box.contents);
      if (strcmp(occupation_edit_box.contents, "")) fprintf(naji_db_file, "Occupation: %s\n", occupation_edit_box.contents);
      if (strcmp(naji_db_email_edit_box.contents, "")) fprintf(naji_db_file, "e-mail: %s\n", naji_db_email_edit_box.contents);
      if (strcmp(naji_db_website_edit_box.contents, "")) fprintf(naji_db_file, "Website: %s\n", naji_db_website_edit_box.contents);
      if (strcmp(mothers_full_name_edit_box.contents, "")) fprintf(naji_db_file, "Mother's full name: %s\n", mothers_full_name_edit_box.contents);
      if (strcmp(mothers_dob_edit_box.contents, "")) fprintf(naji_db_file, "Mother's date of birth: %s\n", mothers_dob_edit_box.contents);
      if (strcmp(fathers_full_name_edit_box.contents, "")) fprintf(naji_db_file, "Father's full name: %s\n", fathers_full_name_edit_box.contents);
      if (strcmp(fathers_dob_edit_box.contents, "")) fprintf(naji_db_file, "Father's date of birth: %s\n", fathers_dob_edit_box.contents);
      if (strcmp(number_of_sisters_edit_box.contents, "")) fprintf(naji_db_file, "Number of sisters: %s\n", number_of_sisters_edit_box.contents);
      if (strcmp(number_of_brothers_edit_box.contents, "")) fprintf(naji_db_file, "Number of brothers: %s\n", number_of_brothers_edit_box.contents);
      if (strcmp(number_of_children_edit_box.contents, "")) fprintf(naji_db_file, "Number of children: %s\n", number_of_children_edit_box.contents);
      fprintf(naji_db_file, "\n");
      
      }
      
      if (!strcmp(najitool_language, "Turkish"))
      {

      if (strcmp(title_edit_box.contents, "")) fprintf(naji_db_file, "Unvan: %s\n", title_edit_box.contents);
      if (strcmp(full_name_edit_box.contents, "")) fprintf(naji_db_file, "Tum Isim: %s\n", full_name_edit_box.contents);
      if (strcmp(gender_edit_box.contents, "")) fprintf(naji_db_file, "Cinsiyet: %s\n", gender_edit_box.contents);
      if (strcmp(date_of_birth_edit_box.contents, "")) fprintf(naji_db_file, "Dogum Tarih: %s\n", date_of_birth_edit_box.contents);
      if (strcmp(marital_status_edit_box.contents, "")) fprintf(naji_db_file, "Evlilik Durumu: %s\n", marital_status_edit_box.contents);
      if (strcmp(naji_db_height_edit_box.contents, "")) fprintf(naji_db_file, "Boy: %s\n", naji_db_height_edit_box.contents);
      if (strcmp(naji_db_weight_edit_box.contents, "")) fprintf(naji_db_file, "Kilo: %s\n", naji_db_weight_edit_box.contents);
      if (strcmp(naji_db_build_edit_box.contents, "")) fprintf(naji_db_file, "Yapi: %s\n", naji_db_build_edit_box.contents);
      if (strcmp(hair_color_edit_box.contents, "")) fprintf(naji_db_file, "Sac Renk: %s\n", hair_color_edit_box.contents);
      if (strcmp(eye_color_edit_box.contents, "")) fprintf(naji_db_file, "Goz Renk: %s\n", eye_color_edit_box.contents);
      if (strcmp(favourite_food_edit_box.contents, "")) fprintf(naji_db_file, "En Sevdigi Yemek: %s\n", favourite_food_edit_box.contents);
      if (strcmp(favourite_drink_edit_box.contents, "")) fprintf(naji_db_file, "En Sevdigi Icicek: %s\n", favourite_drink_edit_box.contents);
      if (strcmp(home_number_edit_box.contents, "")) fprintf(naji_db_file, "Ev Telefon: %s\n", home_number_edit_box.contents);
      if (strcmp(work_number_edit_box.contents, "")) fprintf(naji_db_file, "Is Telefon: %s\n", work_number_edit_box.contents);
      if (strcmp(fax_number_edit_box.contents, "")) fprintf(naji_db_file, "Faks Numara: %s\n", fax_number_edit_box.contents);
      if (strcmp(cell_number_edit_box.contents, "")) fprintf(naji_db_file, "Cep Numara: %s\n", cell_number_edit_box.contents);
      if (strcmp(home_address_edit_box.contents, "")) fprintf(naji_db_file, "Ev Adres: %s\n", home_address_edit_box.contents);
      if (strcmp(work_address_edit_box.contents, "")) fprintf(naji_db_file, "Is Adres: %s\n", work_address_edit_box.contents);
      if (strcmp(occupation_edit_box.contents, "")) fprintf(naji_db_file, "Meslek: %s\n", occupation_edit_box.contents);
      if (strcmp(naji_db_email_edit_box.contents, "")) fprintf(naji_db_file, "E-Posta Adres: %s\n", naji_db_email_edit_box.contents);
      if (strcmp(naji_db_website_edit_box.contents, "")) fprintf(naji_db_file, "Vebsite: %s\n", naji_db_website_edit_box.contents);
      if (strcmp(mothers_full_name_edit_box.contents, "")) fprintf(naji_db_file, "Tum Ana Ismi: %s\n", mothers_full_name_edit_box.contents);
      if (strcmp(mothers_dob_edit_box.contents, "")) fprintf(naji_db_file, "Ana Dogum Tarih: %s\n", mothers_dob_edit_box.contents);
      if (strcmp(fathers_full_name_edit_box.contents, "")) fprintf(naji_db_file, "Tum Baba Ismi: %s\n", fathers_full_name_edit_box.contents);
      if (strcmp(fathers_dob_edit_box.contents, "")) fprintf(naji_db_file, "Baba Dogum Tarih: %s\n", fathers_dob_edit_box.contents);
      if (strcmp(number_of_sisters_edit_box.contents, "")) fprintf(naji_db_file, "Kac Abla/Kiz Kardes: %s\n", number_of_sisters_edit_box.contents);
      if (strcmp(number_of_brothers_edit_box.contents, "")) fprintf(naji_db_file, "Kac Abi/Erkek Kardes: %s\n", number_of_brothers_edit_box.contents);
      if (strcmp(number_of_children_edit_box.contents, "")) fprintf(naji_db_file, "Cocuk Sayisi: %s\n", number_of_children_edit_box.contents);







      }








      }   
          
   
   
          fseek (naji_db_file , 0, SEEK_SET);

          while (1)
            {

         
            naji_db_a = fgetc(naji_db_file);

            if (naji_db_a == EOF)
            break;


            view_database_edit_box.AddCh(naji_db_a);
            }
     
         
         
         
         }
         else
         {
    
         if (!strcmp(najitool_language, "English"))
         MessageBox { text = "najitool GUI database error:", contents = "Please select a file to create or to append the database entries to." }.Modal();
         else if (!strcmp(najitool_language, "Turkish"))
         MessageBox { text = "najitool GUI veritabani hata:", contents = "Lutfen bir dosya secin olusturmak icin veya bir dosya secin veritabani kayitlari eklenmesi icin." }.Modal();
         
         }
    







         return true;
      }
   };
   Button add_entry_fill_blanks_with_button 
   {      
      this, text = "Add Entry, Fill Blanks With:", position = { 704, 664 };

      bool NotifyClicked(Button button, int x, int y, Modifiers mods)
      {








         if (naji_db_file_selected == true)
         {

         view_database_edit_box.Clear();
         
     
      if (naji_db_html_selected == true)
      {
      
      if (!strcmp(najitool_language, "English"))
      {
      
      
      fprintf(naji_db_file, "\n<hr>\n");
      if (strcmp(title_edit_box.contents, "")) add_entry_item_html("Title:", title_edit_box.contents);
      else add_entry_item_html("Title:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(full_name_edit_box.contents, "")) add_entry_item_html("Full name:", full_name_edit_box.contents);
      else add_entry_item_html("Full name:", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(gender_edit_box.contents, "")) add_entry_item_html("Gender:", gender_edit_box.contents);
      else add_entry_item_html("Gender:", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(date_of_birth_edit_box.contents, "")) add_entry_item_html("Date of birth:", date_of_birth_edit_box.contents);
      else add_entry_item_html("Date of birth:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(marital_status_edit_box.contents, "")) add_entry_item_html("Marital status:", marital_status_edit_box.contents);
      else add_entry_item_html("Marital status:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(naji_db_height_edit_box.contents, "")) add_entry_item_html("Height:", naji_db_height_edit_box.contents);
      else add_entry_item_html("Height:", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(naji_db_weight_edit_box.contents, "")) add_entry_item_html("Weight:", naji_db_weight_edit_box.contents);
      else add_entry_item_html("Weight:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(naji_db_build_edit_box.contents, "")) add_entry_item_html("Build:", naji_db_build_edit_box.contents);
      else add_entry_item_html("Build:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(hair_color_edit_box.contents, "")) add_entry_item_html("Hair color:", hair_color_edit_box.contents);
      else add_entry_item_html("Hair color:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(eye_color_edit_box.contents, "")) add_entry_item_html("Eye color:", eye_color_edit_box.contents);
      else add_entry_item_html("Eye color:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(favourite_food_edit_box.contents, "")) add_entry_item_html("Favourite food:", favourite_food_edit_box.contents);
      else add_entry_item_html("Favourite food:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(favourite_drink_edit_box.contents, "")) add_entry_item_html("Favourite drink:", favourite_drink_edit_box.contents);
      else add_entry_item_html("Favourite drink:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(home_number_edit_box.contents, "")) add_entry_item_html("Home number:", home_number_edit_box.contents);
      else add_entry_item_html("Home number:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(work_number_edit_box.contents, "")) add_entry_item_html("Work number:", work_number_edit_box.contents);
      else add_entry_item_html("Work number:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(fax_number_edit_box.contents, "")) add_entry_item_html("Fax number:", fax_number_edit_box.contents);
      else add_entry_item_html("Fax number:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(cell_number_edit_box.contents, "")) add_entry_item_html("Cell number:", cell_number_edit_box.contents);
      else add_entry_item_html("Cell number:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(home_address_edit_box.contents, "")) add_entry_item_html("Home address:", home_address_edit_box.contents);
      else add_entry_item_html("Home address:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(work_address_edit_box.contents, "")) add_entry_item_html("Work address:", work_address_edit_box.contents);
      else add_entry_item_html("Work address:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(occupation_edit_box.contents, "")) add_entry_item_html("Occupation:", occupation_edit_box.contents);
      else add_entry_item_html("Occupation:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(naji_db_email_edit_box.contents, "")) add_entry_item_html_email("e-mail:", naji_db_email_edit_box.contents);
      else add_entry_item_html_email("e-mail:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(naji_db_website_edit_box.contents, "")) add_entry_item_html_link("Website:", naji_db_website_edit_box.contents);
      else add_entry_item_html_link("Website:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(mothers_full_name_edit_box.contents, "")) add_entry_item_html("Mother's full name:", mothers_full_name_edit_box.contents);
      else add_entry_item_html("Mother's full name:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(mothers_dob_edit_box.contents, "")) add_entry_item_html("Mother's date of birth:", mothers_dob_edit_box.contents);
      else add_entry_item_html("Mother's date of birth:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(fathers_full_name_edit_box.contents, "")) add_entry_item_html("Father's full name:", fathers_full_name_edit_box.contents);
      else add_entry_item_html("Father's full name:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(fathers_dob_edit_box.contents, "")) add_entry_item_html("Father's date of birth:", fathers_dob_edit_box.contents);
      else add_entry_item_html("Father's date of birth:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(number_of_sisters_edit_box.contents, "")) add_entry_item_html("Number of sisters:", number_of_sisters_edit_box.contents);
      else add_entry_item_html("Number of sisters:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(number_of_brothers_edit_box.contents, "")) add_entry_item_html("Number of brothers:", number_of_brothers_edit_box.contents);
      else add_entry_item_html("Number of brothers:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(number_of_children_edit_box.contents, "")) add_entry_item_html("Number of children:", number_of_children_edit_box.contents);
      else add_entry_item_html("Number of children:", add_entry_fill_blanks_with_edit_box.contents);
      
      }
      





      if (!strcmp(najitool_language, "Turkish"))
      {
      
      
      fprintf(naji_db_file, "\n<hr>\n");
      if (strcmp(title_edit_box.contents, "")) add_entry_item_html("Unvan:", title_edit_box.contents);
      else add_entry_item_html("Unvan:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(full_name_edit_box.contents, "")) add_entry_item_html("Tum Isim:", full_name_edit_box.contents);
      else add_entry_item_html("Tum Isim:", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(gender_edit_box.contents, "")) add_entry_item_html("Cinsiyet:", gender_edit_box.contents);
      else add_entry_item_html("Cinsiyet:", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(date_of_birth_edit_box.contents, "")) add_entry_item_html("Dogum Tarih:", date_of_birth_edit_box.contents);
      else add_entry_item_html("Dogum Tarih:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(marital_status_edit_box.contents, "")) add_entry_item_html("Evlilik Durumu:", marital_status_edit_box.contents);
      else add_entry_item_html("Evlilik Durumu:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(naji_db_height_edit_box.contents, "")) add_entry_item_html("Boy:", naji_db_height_edit_box.contents);
      else add_entry_item_html("Boy:", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(naji_db_weight_edit_box.contents, "")) add_entry_item_html("Kilo:", naji_db_weight_edit_box.contents);
      else add_entry_item_html("Kilo:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(naji_db_build_edit_box.contents, "")) add_entry_item_html("Yapi:", naji_db_build_edit_box.contents);
      else add_entry_item_html("Yapi:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(hair_color_edit_box.contents, "")) add_entry_item_html("Sac Renk:", hair_color_edit_box.contents);
      else add_entry_item_html("Sac Renk:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(eye_color_edit_box.contents, "")) add_entry_item_html("Goz Renk:", eye_color_edit_box.contents);
      else add_entry_item_html("Goz Renk:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(favourite_food_edit_box.contents, "")) add_entry_item_html("En Sevdigi Yemek:", favourite_food_edit_box.contents);
      else add_entry_item_html("En Sevdigi Yemek:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(favourite_drink_edit_box.contents, "")) add_entry_item_html("En Sevdigi Icicek:", favourite_drink_edit_box.contents);
      else add_entry_item_html("En Sevdigi Icicek:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(home_number_edit_box.contents, "")) add_entry_item_html("Ev Telefon:", home_number_edit_box.contents);
      else add_entry_item_html("Ev Telefon:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(work_number_edit_box.contents, "")) add_entry_item_html("Is Telefon:", work_number_edit_box.contents);
      else add_entry_item_html("Is Telefon:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(fax_number_edit_box.contents, "")) add_entry_item_html("Faks Numara:", fax_number_edit_box.contents);
      else add_entry_item_html("Faks Numara:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(cell_number_edit_box.contents, "")) add_entry_item_html("Cep Telefon:", cell_number_edit_box.contents);
      else add_entry_item_html("Cep Telefon:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(home_address_edit_box.contents, "")) add_entry_item_html("Ev Adres:", home_address_edit_box.contents);
      else add_entry_item_html("Ev Adres:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(work_address_edit_box.contents, "")) add_entry_item_html("Is Adres:", work_address_edit_box.contents);
      else add_entry_item_html("Is Adres:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(occupation_edit_box.contents, "")) add_entry_item_html("Meslek:", occupation_edit_box.contents);
      else add_entry_item_html("Meslek:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(naji_db_email_edit_box.contents, "")) add_entry_item_html_email("E-Posta Adres:", naji_db_email_edit_box.contents);
      else add_entry_item_html_email("E-Posta Adres:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(naji_db_website_edit_box.contents, "")) add_entry_item_html_link("Vebsite:", naji_db_website_edit_box.contents);
      else add_entry_item_html_link("Vebsite:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(mothers_full_name_edit_box.contents, "")) add_entry_item_html("Tum Ana Ismi:", mothers_full_name_edit_box.contents);
      else add_entry_item_html("Tum Ana Ismi:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(mothers_dob_edit_box.contents, "")) add_entry_item_html("Ana Dogum Tarih:", mothers_dob_edit_box.contents);
      else add_entry_item_html("Ana Dogum Tarih:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(fathers_full_name_edit_box.contents, "")) add_entry_item_html("Tum Baba Ismi:", fathers_full_name_edit_box.contents);
      else add_entry_item_html("Tum Baba Ismi:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(fathers_dob_edit_box.contents, "")) add_entry_item_html("Baba Dogum Tarih:", fathers_dob_edit_box.contents);
      else add_entry_item_html("Baba Dogum Tarih:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(number_of_sisters_edit_box.contents, "")) add_entry_item_html("Kac Abla/Kiz Kardes:", number_of_sisters_edit_box.contents);
      else add_entry_item_html("Kac Abla/Kiz Kardes:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(number_of_brothers_edit_box.contents, "")) add_entry_item_html("Kac Abi/Erkek Kardes:", number_of_brothers_edit_box.contents);
      else add_entry_item_html("Kac Abi/Erkek Kardes:", add_entry_fill_blanks_with_edit_box.contents);
      
      if (strcmp(number_of_children_edit_box.contents, "")) add_entry_item_html("Number of children:", number_of_children_edit_box.contents);
      else add_entry_item_html("Cocuk Sayisi:", add_entry_fill_blanks_with_edit_box.contents);
      
      }










      }
      

      
      else
      {   
      
      if (!strcmp(najitool_language, "English"))
      {
      
      
      if (strcmp(title_edit_box.contents, "")) fprintf(naji_db_file, "Title: %s\n", title_edit_box.contents);
      else fprintf(naji_db_file, "Title: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(full_name_edit_box.contents, "")) fprintf(naji_db_file, "Full name: %s\n", full_name_edit_box.contents);
      else fprintf(naji_db_file, "Full name: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(gender_edit_box.contents, "")) fprintf(naji_db_file, "Gender: %s\n", gender_edit_box.contents);
      else fprintf(naji_db_file, "Gender: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(date_of_birth_edit_box.contents, "")) fprintf(naji_db_file, "Date of birth: %s\n", date_of_birth_edit_box.contents);
      else fprintf(naji_db_file, "Date of birth: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(marital_status_edit_box.contents, "")) fprintf(naji_db_file, "Marital status: %s\n", marital_status_edit_box.contents);
      else fprintf(naji_db_file, "Marital status: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(naji_db_height_edit_box.contents, "")) fprintf(naji_db_file, "Height: %s\n", naji_db_height_edit_box.contents);
      else fprintf(naji_db_file, "Height: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(naji_db_weight_edit_box.contents, "")) fprintf(naji_db_file, "Weight: %s\n", naji_db_weight_edit_box.contents);
      else fprintf(naji_db_file, "Weight: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(naji_db_build_edit_box.contents, "")) fprintf(naji_db_file, "Build: %s\n", naji_db_build_edit_box.contents);
      else fprintf(naji_db_file, "Build: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(hair_color_edit_box.contents, "")) fprintf(naji_db_file, "Hair color: %s\n", hair_color_edit_box.contents);
      else fprintf(naji_db_file, "Hair color: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(eye_color_edit_box.contents, "")) fprintf(naji_db_file, "Eye color: %s\n", eye_color_edit_box.contents);
      else fprintf(naji_db_file, "Eye color: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(favourite_food_edit_box.contents, "")) fprintf(naji_db_file, "Favourite food: %s\n", favourite_food_edit_box.contents);
      else fprintf(naji_db_file, "Favourite food: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(favourite_drink_edit_box.contents, "")) fprintf(naji_db_file, "Favourite drink: %s\n", favourite_drink_edit_box.contents);
      else fprintf(naji_db_file, "Favourite drink: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(home_number_edit_box.contents, "")) fprintf(naji_db_file, "Home number: %s\n", home_number_edit_box.contents);
      else fprintf(naji_db_file, "Home number: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(work_number_edit_box.contents, "")) fprintf(naji_db_file, "Work number: %s\n", work_number_edit_box.contents);
      else fprintf(naji_db_file, "Work number: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(fax_number_edit_box.contents, "")) fprintf(naji_db_file, "Fax number: %s\n", fax_number_edit_box.contents);
      else fprintf(naji_db_file, "Fax number: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(cell_number_edit_box.contents, "")) fprintf(naji_db_file, "Cell number: %s\n", cell_number_edit_box.contents);
      else fprintf(naji_db_file, "Cell number: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(home_address_edit_box.contents, "")) fprintf(naji_db_file, "Home address: %s\n", home_address_edit_box.contents);
      else fprintf(naji_db_file, "Home address: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(work_address_edit_box.contents, "")) fprintf(naji_db_file, "Work address: %s\n", work_address_edit_box.contents);
      else fprintf(naji_db_file, "Work address: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(occupation_edit_box.contents, "")) fprintf(naji_db_file, "Occupation: %s\n", occupation_edit_box.contents);
      else fprintf(naji_db_file, "Occupation: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(naji_db_email_edit_box.contents, "")) fprintf(naji_db_file, "e-mail: %s\n", naji_db_email_edit_box.contents);
      else fprintf(naji_db_file, "e-mail: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(naji_db_website_edit_box.contents, "")) fprintf(naji_db_file, "Website: %s\n", naji_db_website_edit_box.contents);
      else fprintf(naji_db_file, "Website: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(mothers_full_name_edit_box.contents, "")) fprintf(naji_db_file, "Mother's full name: %s\n", mothers_full_name_edit_box.contents);
      else fprintf(naji_db_file, "Mother's full name: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(mothers_dob_edit_box.contents, "")) fprintf(naji_db_file, "Mother's date of birth: %s\n", mothers_dob_edit_box.contents);
      else fprintf(naji_db_file, "Mother's date of birth: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(fathers_full_name_edit_box.contents, "")) fprintf(naji_db_file, "Father's full name: %s\n", fathers_full_name_edit_box.contents);
      else fprintf(naji_db_file, "Father's full name: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(fathers_dob_edit_box.contents, "")) fprintf(naji_db_file, "Father's date of birth: %s\n", fathers_dob_edit_box.contents);
      else fprintf(naji_db_file, "Father's date of birth: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(number_of_sisters_edit_box.contents, "")) fprintf(naji_db_file, "Number of sisters: %s\n", number_of_sisters_edit_box.contents);
      else fprintf(naji_db_file, "Number of sisters: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(number_of_brothers_edit_box.contents, "")) fprintf(naji_db_file, "Number of brothers: %s\n", number_of_brothers_edit_box.contents);
      else fprintf(naji_db_file, "Number of brothers: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(number_of_children_edit_box.contents, "")) fprintf(naji_db_file, "Number of children: %s\n", number_of_children_edit_box.contents);
      else fprintf(naji_db_file, "Number of children: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      fprintf(naji_db_file, "\n");
      
      
      }

      

      if (!strcmp(najitool_language, "Turkish"))
      {
      
      
      if (strcmp(title_edit_box.contents, "")) fprintf(naji_db_file, "Unvan: %s\n", title_edit_box.contents);
      else fprintf(naji_db_file, "Unvan: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(full_name_edit_box.contents, "")) fprintf(naji_db_file, "Tum Isim: %s\n", full_name_edit_box.contents);
      else fprintf(naji_db_file, "Tum Isim: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(gender_edit_box.contents, "")) fprintf(naji_db_file, "Cinsiyet: %s\n", gender_edit_box.contents);
      else fprintf(naji_db_file, "Cinsiyet: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(date_of_birth_edit_box.contents, "")) fprintf(naji_db_file, "Dogum Tarih: %s\n", date_of_birth_edit_box.contents);
      else fprintf(naji_db_file, "Dogum Tarih: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(marital_status_edit_box.contents, "")) fprintf(naji_db_file, "Evlilik Durumu: %s\n", marital_status_edit_box.contents);
      else fprintf(naji_db_file, "Evlilik Durumu: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(naji_db_height_edit_box.contents, "")) fprintf(naji_db_file, "Boy: %s\n", naji_db_height_edit_box.contents);
      else fprintf(naji_db_file, "Boy: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(naji_db_weight_edit_box.contents, "")) fprintf(naji_db_file, "Kilo: %s\n", naji_db_weight_edit_box.contents);
      else fprintf(naji_db_file, "Kilo: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(naji_db_build_edit_box.contents, "")) fprintf(naji_db_file, "Yapi: %s\n", naji_db_build_edit_box.contents);
      else fprintf(naji_db_file, "Yapi: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(hair_color_edit_box.contents, "")) fprintf(naji_db_file, "Sac Renk: %s\n", hair_color_edit_box.contents);
      else fprintf(naji_db_file, "Sac Renk: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(eye_color_edit_box.contents, "")) fprintf(naji_db_file, "Goz Renk: %s\n", eye_color_edit_box.contents);
      else fprintf(naji_db_file, "Goz Renk: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(favourite_food_edit_box.contents, "")) fprintf(naji_db_file, "En Sevdigi Yemek: %s\n", favourite_food_edit_box.contents);
      else fprintf(naji_db_file, "En Sevdigi Yemek: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(favourite_drink_edit_box.contents, "")) fprintf(naji_db_file, "En Sevdigi Icicek: %s\n", favourite_drink_edit_box.contents);
      else fprintf(naji_db_file, "En Sevdigi Icicek: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(home_number_edit_box.contents, "")) fprintf(naji_db_file, "Ev Telefon: %s\n", home_number_edit_box.contents);
      else fprintf(naji_db_file, "Ev Telefon: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(work_number_edit_box.contents, "")) fprintf(naji_db_file, "Is Telefon: %s\n", work_number_edit_box.contents);
      else fprintf(naji_db_file, "Is Telefon: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(fax_number_edit_box.contents, "")) fprintf(naji_db_file, "Faks Numara: %s\n", fax_number_edit_box.contents);
      else fprintf(naji_db_file, "Faks Numara: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(cell_number_edit_box.contents, "")) fprintf(naji_db_file, "Cep Telefon: %s\n", cell_number_edit_box.contents);
      else fprintf(naji_db_file, "Cep Telefon: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(home_address_edit_box.contents, "")) fprintf(naji_db_file, "Ev Adres: %s\n", home_address_edit_box.contents);
      else fprintf(naji_db_file, "Ev Adres: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(work_address_edit_box.contents, "")) fprintf(naji_db_file, "Is Adres: %s\n", work_address_edit_box.contents);
      else fprintf(naji_db_file, "Is Adres: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(occupation_edit_box.contents, "")) fprintf(naji_db_file, "Meslek: %s\n", occupation_edit_box.contents);
      else fprintf(naji_db_file, "Meslek: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(naji_db_email_edit_box.contents, "")) fprintf(naji_db_file, "E-Posta Adres: %s\n", naji_db_email_edit_box.contents);
      else fprintf(naji_db_file, "E-Posta Adres: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(naji_db_website_edit_box.contents, "")) fprintf(naji_db_file, "Vebsite: %s\n", naji_db_website_edit_box.contents);
      else fprintf(naji_db_file, "Vebsite: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(mothers_full_name_edit_box.contents, "")) fprintf(naji_db_file, "Tum Ana Ismi: %s\n", mothers_full_name_edit_box.contents);
      else fprintf(naji_db_file, "Tum Ana Ismi: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(mothers_dob_edit_box.contents, "")) fprintf(naji_db_file, "Ana Dogum Tarih: %s\n", mothers_dob_edit_box.contents);
      else fprintf(naji_db_file, "Ana Dogum Tarih: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(fathers_full_name_edit_box.contents, "")) fprintf(naji_db_file, "Tum Baba Ismi: %s\n", fathers_full_name_edit_box.contents);
      else fprintf(naji_db_file, "Tum Baba Ismi: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(fathers_dob_edit_box.contents, "")) fprintf(naji_db_file, "Baba Dogum Tarih: %s\n", fathers_dob_edit_box.contents);
      else fprintf(naji_db_file, "Baba Dogum Tarih: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(number_of_sisters_edit_box.contents, "")) fprintf(naji_db_file, "Kac Abla/Kiz Kardes: %s\n", number_of_sisters_edit_box.contents);
      else fprintf(naji_db_file, "Kac Abla/Kiz Kardes: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(number_of_brothers_edit_box.contents, "")) fprintf(naji_db_file, "Kac Abi/Erkek Kardes: %s\n", number_of_brothers_edit_box.contents);
      else fprintf(naji_db_file, "Kac Abi/Erkek Kardes: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      if (strcmp(number_of_children_edit_box.contents, "")) fprintf(naji_db_file, "Number of children: %s\n", number_of_children_edit_box.contents);
      else fprintf(naji_db_file, "Cocuk Sayisi: %s\n", add_entry_fill_blanks_with_edit_box.contents);

      fprintf(naji_db_file, "\n");
      
      
      }
      
      
      
      }   
          
   
   
          fseek (naji_db_file , 0, SEEK_SET);

          while (1)
            {

         
            naji_db_a = fgetc(naji_db_file);

            if (naji_db_a == EOF)
            break;


            view_database_edit_box.AddCh(naji_db_a);
            }
     
         
         
         
         }
         else
         {
         if (!strcmp(najitool_language, "English"))
         MessageBox { text = "najitool GUI database error:", contents = "Please select a file to create or to append the database entries to." }.Modal();
         else if (!strcmp(najitool_language, "Turkish"))
         MessageBox { text = "najitool GUI veritabani hata:", contents = "Lutfen bir dosya secin olusturmak icin veya bir dosya secin veritabani kayitlari eklenmesi icin." }.Modal();
         }
    




















         return true;
      }
   };
   Button file_to_append_entries_to_button 
   {
      this, text = "File to append entries to:", size = { 176, 21 }, position = { 416, 16 };

      bool NotifyClicked(Button button, int x, int y, Modifiers mods)
      {

         naji_db_append_file_dialog.type=save; 
         
         if (naji_db_append_file_dialog.Modal() == ok)
         {
         strcpy(naji_db_filepath_buffer, naji_db_append_file_dialog.filePath);
         file_to_append_naji_db_edit_box.contents = naji_db_append_file_dialog.filePath;
 
         naji_db_file = fopen(naji_db_filepath_buffer, "ab+");
         if (naji_db_file == NULL)
         {
         
         if (!strcmp(najitool_language, "English"))
         {                  
         sprintf(naji_db_error_buffer, "Error opening file %s please select another file to append database entries to or type a new name.", naji_db_filepath_buffer);
         MessageBox { text = "najitool GUI database error:", contents = naji_db_error_buffer }.Modal();
         }
         else if (!strcmp(najitool_language, "Turkish"))
         {
         
         sprintf(naji_db_error_buffer, "%s dosyasi acilirken hata oldu, veritabani kayitlari eklemek icin baska dosya secin veya yeni bir dosya ad yazin.", naji_db_filepath_buffer);
         MessageBox { text = "najitool GUI veritabani hata:", contents = naji_db_error_buffer }.Modal();
         }
         
         
         
         file_to_append_naji_db_edit_box.Clear();
         naji_db_file_selected = false;       
         }
         else
         {
         
            naji_db_file_selected = true; 

            while (1)
            {

            naji_db_a = fgetc(naji_db_file);

            if (naji_db_a == EOF)
            break;

            view_database_edit_box.AddCh(naji_db_a);
         
            }


         }
              
         }
         return true;
      }
   };
   EditBox file_to_append_naji_db_edit_box { this, text = "file_to_append_naji_db", size = { 246, 19 }, position = { 752, 16 }, readOnly = true };
   Button database_text_radio_button 
   {
      this, text = "Text", position = { 600, 16 }, isRadio = true, bitmap = { "<:ecere>elements/optionBoxDown.png", transparent = true };

      bool NotifyClicked(Button button, int x, int y, Modifiers mods)
      {
         naji_db_html_selected = false;

         return true;
      }

      bool NotifyPushed(Button button, int x, int y, Modifiers mods)
      {

      database_text_radio_button.bitmap = { "<:ecere>elements/optionBoxSelectedDown.png", transparent = true };
      database_html_radio_button.bitmap = { "<:ecere>elements/optionBoxUp.png", transparent = true };

         return true;
      }
   };
   Button database_html_radio_button 
   {
      this, text = "HTML", position = { 680, 16 }, isRadio = true, bitmap = { "<:ecere>elements/optionBoxDown.png", transparent = true };

      bool NotifyClicked(Button button, int x, int y, Modifiers mods)
      {
         naji_db_html_selected = true;
         return true;
      }

      bool NotifyPushed(Button button, int x, int y, Modifiers mods)
      {
      database_text_radio_button.bitmap = { "<:ecere>elements/optionBoxUp.png", transparent = true };
      database_html_radio_button.bitmap = { "<:ecere>elements/optionBoxSelectedDown.png", transparent = true };
         
         return true;
      }
   };
   EditBox view_database_edit_box { this, text = "view_database", size = { 578, 610 }, position = { 416, 48 }, hasHorzScroll = true, true, true, readOnly = true, true };

   bool OnCreate(void)
   {
   

if (!strcmp(najitool_language, "English"))
{




clear_all_entry_items_button.text="Clear All Entry Items";
add_entry_button.text="Add Entry";
add_entry_omits_empty_items_button.text="Add Entry, Omits Empty Items";
add_entry_fill_blanks_with_button.text="Add Entry, Fill Blanks With:";
file_to_append_entries_to_button.text="File to append entries to:";
database_text_radio_button.text="Text";
database_html_radio_button.text="HTML";



    title_label.text = "Title:";
    full_name_label.text = "Full name:";
    gender_label.text = "Gender:";
    date_of_birth_label.text = "Date of birth:";
    marital_status_label.text = "Marital status:";
    naji_db_height_label.text = "Height:";
    naji_db_weight_label.text = "Weight:";
    naji_db_build_label.text = "Build:";
    hair_color_label.text = "Hair color:";
    eye_color_label.text = "Eye color:";
    favourite_food_label.text = "Favourite food:";
    favourite_drink_label.text = "Favourite drink:";
    home_number_label.text = "Home number:";
    work_number_label.text = "Work number:";
    occupation_label.text = "Occupation";
    fax_number_label.text = "Fax number:";
    cell_number_label.text = "Cell number:";
    home_address_label.text = "Home address:";
    work_address_label.text = "Work address:";
    naji_db_email_label.text = "e-mail:";
    naji_db_website_label.text = "Website:";
    mothers_full_name_label.text = "Mother's full name:";
    mothers_dob_label.text = "Mother's date of birth:";
    fathers_full_name_label.text = "Father's full name:";
    fathers_dob_label.text = "Father's date of birth:";
    number_of_sisters_label.text = "Number of sisters:";
    number_of_brothers_label.text = "Number of brothers:";
    number_of_children_label.text = "Number of children:";

}

if (!strcmp(najitool_language, "Turkish"))
{




clear_all_entry_items_button.text="Butun Kutulari Bosalt";
add_entry_button.text="Kayit Yap";
add_entry_omits_empty_items_button.text="Kayit Yap, Bos Kutu Haric";
add_entry_fill_blanks_with_button.text="Kayit Yap, Koy Bos Kutlara:";
file_to_append_entries_to_button.text="Kayitlar Eklenen Dosya:";
database_text_radio_button.text="Metin";
database_html_radio_button.text="HTML";
      


    title_label.text = "Unvan:";
    full_name_label.text = "Tum Isim:";
    gender_label.text = "Cinsiyet:";
    date_of_birth_label.text = "Dogum Tarih:";
    marital_status_label.text = "Evlilik Durumu:";
    naji_db_height_label.text = "Boy:";
    naji_db_weight_label.text = "Kilo:";
    naji_db_build_label.text = "Yapi:";
    hair_color_label.text = "Sac Renk:";
    eye_color_label.text = "Goz Renk:";
    favourite_food_label.text = "En Sevdigi Yemek:";
    favourite_drink_label.text = "En Sevdigi Icicek:";
    home_number_label.text = "Ev Telefon:";
    work_number_label.text = "Is Telefon:";
    occupation_label.text = "Meslek";
    fax_number_label.text = "Faks Numara:";
    cell_number_label.text = "Cep Telefon:";
    home_address_label.text = "Ev Adres:";
    work_address_label.text = "Is Adres:";
    naji_db_email_label.text = "E-Posta Adres:";
    naji_db_website_label.text = "Vebsite:";
    mothers_full_name_label.text = "Tum Ana Ismi:";
    mothers_dob_label.text = "Ana Dogum Tarih:";
    fathers_full_name_label.text = "Tum Baba Isim:";
    fathers_dob_label.text = "Baba Dogum Tarih:";
    number_of_sisters_label.text = "Kac Abla/Kiz Kardes:";
    number_of_brothers_label.text = "Kac Abi/Erkek Kardes:";
    number_of_children_label.text = "Cocuk Sayisi:";

}







      if (naji_db_html_selected == false)
      {
      database_text_radio_button.checked=true;
      database_html_radio_button.checked=false;

      database_text_radio_button.bitmap = { "<:ecere>elements/optionBoxSelectedDown.png", transparent = true };
      database_html_radio_button.bitmap = { "<:ecere>elements/optionBoxUp.png", transparent = true };

      }
      else
      {
      database_text_radio_button.checked=false;
      database_html_radio_button.checked=true;

      database_text_radio_button.bitmap = { "<:ecere>elements/optionBoxUp.png", transparent = true };
      database_html_radio_button.bitmap = { "<:ecere>elements/optionBoxSelectedDown.png", transparent = true };

      }
      


      return true;
   }

   void add_entry_item_html(char *entry_item, char *details)
{
    
    fprintf(naji_db_file, "<b>%s</b>%s<br>\n", entry_item, details);
    fflush(naji_db_file);
return;
}

   void add_entry_item_html_email(char *entry_item, char *details)
{
    
    fprintf(naji_db_file, "<b>%s</b><a href=\"mailto:%s\">%s</a></br>\n",
    entry_item, details, details);
    fflush(naji_db_file);
return;
}

   void add_entry_item_html_link(char *entry_item, char *details)
{
  
    fprintf(naji_db_file, "<b>%s</b><a href=\"%s\">%s</a><br>\n",
    entry_item, details, details);
    fflush(naji_db_file);
return;
}
   EditBox add_entry_fill_blanks_with_edit_box 
   {      
      this, text = "add_entry_fill_blanks_with_edit_box", size = { 102, 19 }, position = { 896, 664 };

      bool NotifyModified(EditBox editBox)
      {

         return true;
      }
   };
} 
                             
class tab_mathgame : Tab
{
   text = "MathGM";
   background = { r = 110, g = 161, b = 180 };
   font = { "Verdana", 8.25f, bold = true };
   size = { 1024, 768 };

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

   EditBox mathgame_users_answer_edit_box
   {
      this, text = "mathgame_users_answer_edit_box", size = { 214, 19 }, position = { 384, 352 };

      bool NotifyKeyDown(EditBox editBox, Key key, unichar ch)
      {
            if (key == enter || key == keyPadEnter)
            mathgame_user_answers();
       
         return true;
      }


   };
   EditBox mathgame_right_answers_edit_box { this, text = "mathgame_right_answers_edit_box", size = { 286, 595 }, position = { 712, 80 }, hasHorzScroll = true, true, true, readOnly = true, true };
   Label mathgame_right_answers_label { this, text = "Right Answers:", position = { 800, 40 } };
   Label mathgame_wrong_answers_label { this, text = "Wrong Answers:", position = { 88, 40 } };
   Label mathgame_points_label { this, text = "0 Points", font = { "Verdana", 20, bold = true }, position = { 432, 648 } };
   EditBox mathgame_wrong_answers_edit_box { this, text = "mathgame_wrong_answers_edit_box", size = { 286, 603 }, position = { 8, 72 }, hasHorzScroll = true, true, true, readOnly = true, true };
   Button mathgame_answer_button 
   {
      this, text = "Answer", size = { 220, 21 }, position = { 384, 376 };

      bool NotifyClicked(Button button, int x, int y, Modifiers mods)
      {
         mathgame_user_answers();

         return true;
      }
   };
   Label mathgame_whatis_label { this, text = "What is", font = { "Verdana", 13, bold = true }, position = { 448, 224 } };
   Label mathgame_lvalue_label { this, text = "lvalue", font = { "Verdana", 13, bold = true }, position = { 384, 264 } };
   Label mathgame_operator_label { this, text = "op", font = { "Verdana", 16, bold = true }, position = { 480, 264 } };
   Label mathgame_rvalue_label { this, text = "rvalue", font = { "Verdana", 13, bold = true }, position = { 560, 264 } };
   Label mathgame_get_right_label { this, text = "Get the answers right to score points.", position = { 368, 112 } };
   Label mathgame_get_wrong_label { this, text = "Get the answers wrong to lose points.", position = { 368, 136 } };
   Label mathgame_welcome_label { this, text = "Welcome to MathGame", font = { "Verdana", 20, bold = true }, position = { 328, 64 } };

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










unsigned char patch_hex_left;
unsigned char patch_hex_right;


inline void byte2hex(register unsigned char a)
{
register unsigned char tmpbyte;

tmpbyte = (a & 0xF0) >> 4;
patch_hex_left = (tmpbyte > 9) ? (tmpbyte - 10 + 'a') : (tmpbyte + '0');

tmpbyte = a & 0x0F;
patch_hex_right = (tmpbyte > 9) ? (tmpbyte - 10 + 'a') : (tmpbyte + '0');

}



   BufferedFile patch_load_file;
   File patch_save_as_hex_file;







class tab_patch : Tab
{
   text = "Patch";
   background = { r = 110, g = 161, b = 180 };
   font = { "Verdana", 8.25f, bold = true };
   size = { 1024, 768 };

   int i;
   char a;
   char b;
   int counter;
   char patch_load_file_path[MAX_LOCATION];
   char patch_save_as_hex_path[MAX_LOCATION];
   char patch_save_as_path[MAX_LOCATION];
   char *patch_loaded_hex_contents;
   unsigned long offset;
   int patch_loaded_hex_edit_box_size;
   int patch_loaded_edit_box_size;
   int text_wrap;
   text_wrap = 0;
   counter = 0;
   offset = 0;
   i=0;

   Label najitool_homepage_label
   {
      this, text = "http://najitool.sf.net/", foreground = blue, font = { "Verdana", 8.25f, bold = true, underline = true }, position = { 16, 8 }, cursor = ((GuiApplication)__thisModule).GetCursor(hand);;

      bool OnLeftButtonDown(int x, int y, Modifiers mods)
      {
      
        ShellOpen("http://najitool.sf.net/");
      
         return Label::OnLeftButtonDown(x, y, mods);
      }
   };
   BitmapResource najitool_logo_bitmap { ":najitool.pcx", window = this };

   void OnRedraw(Surface surface)
   {
   surface.Blit(najitool_logo_bitmap.bitmap, 8, 24, 0,0, najitool_logo_bitmap.bitmap.width, najitool_logo_bitmap.bitmap.height);
   
 //     surface.WriteText(10,10, "hello", 5);  
   
   }
   Button patch_save_as_button
   {
      this, text = "Save As:", size = { 104, 21 }, position = { 480, 632 };

      bool NotifyClicked(Button button, int x, int y, Modifiers mods)
      {

         patch_save_as_dialog.type=save;
         
         if (patch_save_as_dialog.Modal() == ok)
         {
         strcpy(patch_save_as_path, patch_save_as_dialog.filePath);
         patch_save_as_edit_box.contents = patch_save_as_dialog.filePath;
         

         najout(patch_save_as_path);
         

         i=0;

        patch_loaded_hex_contents = patch_loaded_hex_edit_box.multiLineContents;

         while(1)
         {
            
            
            a = patch_loaded_hex_contents[i];

            if (a == '\0')
            break;

            i++;

            if (!isxdigit(a))
            continue;
         
            else
            {
                  while (1)
                  {


                  b = patch_loaded_hex_contents[i];

                  if (b == '\0')
                  break;

                  i++;


        
                  if (!isxdigit(b))
                  continue;
                  else break;
                  }
         }
         
         fputc(hex2bin(a, b), naji_output);

         }
         najoutclose();
         
        delete patch_loaded_hex_contents;


         }

         return true;
      }
   };
   EditBox patch_text_edit_box { this, text = "patch_text_edit_box", size = { 142, 555 }, position = { 864, 24 }, hasVertScroll = true, true, readOnly = true, true, noCaret = true };
   EditBox patch_load_file_edit_box { this, text = "patch_load_file_edit_box", size = { 422, 19 }, position = { 584, 584 }, readOnly = true, noCaret = true };
   
   EditBox patch_loaded_hex_edit_box 
   {
      this, text = "patch_loaded_edit_box", font = { "Courier New", 8 }, size = { 382, 555 }, position = { 480, 24 }, hasVertScroll = true, true, dontScrollHorz = true, false, false, multiLine = true, true, maxLineSize = 50;

      bool NotifyModified(EditBox editBox)
      {

         return true;
      }
   };
   Button patch_load_file_button
   {
      this, text = "Load File:", font = { "Verdana", 8.25f, bold = true }, clientSize = { 104, 21 }, position = { 480, 584 };

      bool NotifyClicked(Button button, int x, int y, Modifiers mods)
      {

         patch_loaded_hex_edit_box.Clear();
         patch_text_edit_box.Clear();
         patch_save_as_edit_box.Clear();
         patch_save_as_hex_edit_box.Clear();
         patch_load_file_edit_box.Clear();

         
         if (patch_load_file_dialog.Modal() == ok)
         {
                
         strcpy(patch_load_file_path, patch_load_file_dialog.filePath);
         
         patch_load_file_edit_box.contents = patch_load_file_path;
         
         patch_load_file = FileOpenBuffered(patch_load_file_path, read);



         while (1)
         {

         patch_load_file.Get(a);
		   
         //a = fgetc(naji_input);
         
         //if (a == EOF)
         
         if (patch_load_file.eof == true)
         break;
          

         text_wrap++;

         
         if (isalnum(a) || ispunct(a) || a == ' ')
         patch_text_edit_box.AddCh(a);
         else
         patch_text_edit_box.AddCh('.');
         

      if (text_wrap == 16)
      {
		patch_text_edit_box.AddCh('\r');
		patch_text_edit_box.AddCh('\n');
      text_wrap = 0;
      
      }



         }

         delete patch_load_file;
         patch_load_file = FileOpenBuffered(patch_load_file_path, read);

   

	while (1)
	{

        patch_load_file.Get(a);
		   
      //a = fgetc(naji_input);
         
      //if (a == EOF)
         
      if (patch_load_file.eof == true)
      {
		patch_loaded_hex_edit_box.AddCh('\r');
		patch_loaded_hex_edit_box.AddCh('\n');
		break;
		}

      patch_load_file.Get(b);
		
		//b = fgetc(naji_input);

		if (patch_load_file.eof == true)
      //if (b == EOF)
		{
			
         byte2hex(a);
         patch_loaded_hex_edit_box.AddCh(patch_hex_left);
         patch_loaded_hex_edit_box.AddCh(patch_hex_right);

			break;
		}

		else
		{

      patch_load_file.Seek(-1, current);
			//fseek(naji_input, -1, SEEK_CUR);
		}


		if (counter != 15)
			{
         
         byte2hex(a);
         patch_loaded_hex_edit_box.AddCh(patch_hex_left);
         patch_loaded_hex_edit_box.AddCh(patch_hex_right);
         patch_loaded_hex_edit_box.AddCh(' ');
		
         }
      else
      {

         byte2hex(a);
         patch_loaded_hex_edit_box.AddCh(patch_hex_left);
         patch_loaded_hex_edit_box.AddCh(patch_hex_right);
		 }

		if (counter == 3  ||
        	    counter == 7  ||
	            counter == 11
		)

		patch_loaded_hex_edit_box.AddCh(' ');


		counter++;


		if (counter == 16)
		{



			if (offset != 0xFFFFFFF0)
			offset += 16;

	      patch_loaded_hex_edit_box.AddCh('\r');
         patch_loaded_hex_edit_box.AddCh('\n');


			counter = 0;


		}


   


	}
      
       //patch_loaded_hex_edit_box.Update(null);

         delete patch_load_file;

         }
                    
         return true;
      }
   };
   Button patch_save_as_hex_button
   {
      this, text = "Save As Hex:", size = { 104, 21 }, position = { 480, 608 };

      bool NotifyClicked(Button button, int x, int y, Modifiers mods)
      {
        patch_save_as_hex_dialog.type=save;
         
         if (patch_save_as_hex_dialog.Modal() == ok)
         {
         strcpy(patch_save_as_hex_path, patch_save_as_hex_dialog.filePath);
         patch_save_as_hex_edit_box.contents = patch_save_as_hex_dialog.filePath;
         
         patch_save_as_hex_file = FileOpen(patch_save_as_hex_path, write);
         
         patch_loaded_hex_edit_box_size = patch_loaded_hex_edit_box.GetCaretSize();
   
         patch_loaded_hex_edit_box.Save(patch_save_as_hex_file, true);
            
         delete patch_save_as_hex_file;
         }

         return true;
        }
   };
   EditBox patch_save_as_hex_edit_box { this, text = "patch_save_as_hex_edit_box", size = { 422, 19 }, position = { 584, 608 }, readOnly = true, noCaret = true };
   EditBox patch_save_as_edit_box { this, text = "patch_save_as_edit_box", size = { 422, 19 }, position = { 584, 632 }, readOnly = true, noCaret = true };

   bool OnCreate(void)
   {
      
      
      if (!strcmp(najitool_language, "English"))
      {
      patch_save_as_button.text="Save As:";
      patch_save_as_hex_button.text="Save As Hex:";
      patch_load_file_button.text="Load File:";
      }

      else if (!strcmp(najitool_language, "Turkish"))
      {
      patch_save_as_button.text="Farkli Kaydet:";
      patch_save_as_hex_button.text="Onalti Kaydet:";
      patch_load_file_button.text="Dosya Ac:";
      }
 

      return true;
   }



}

void msgbox(char *the_text, char *the_contents)
{
MessageBox { text = the_text, contents = the_contents }.Modal();
}







class tab_batch : Tab
{
   text = "Batch";
   background = { r = 110, g = 161, b = 180 };
   font = { "Verdana", 8.25f, bold = true };
   size = { 1024, 768 };

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

               sprintf(tempbuffer, "%i", batchfilemaxitems);
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
         
         sprintf(tempbuffer, "%i", batchfilemaxitems);
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
      this, text = "output_folder_edit_box", size = { 398, 19 }, position = { 592, 376 }, maxNumLines = 1;

      bool NotifyModified(EditBox editBox)
      {
         strcpy(output_folder_path, output_folder_edit_box.contents);
         return true;
      }
   };
   EditBox new_files_prefix_edit_box { this, text = "new_files_prefix_edit_box", size = { 94, 19 }, position = { 400, 400 } };
   Label new_files_prefix_label { this, text = "New Files Prefix:", position = { 288, 400 } };
   EditBox new_files_suffix_edit_box { this, text = "new_files_suffix_edit_box", size = { 94, 19 }, position = { 616, 400 } };
   Label new_files_extra_extension_label { this, text = "New Files Extra Extension:", position = { 720, 400 } };
   Label new_files_suffix_label { this, text = "New Files Suffix:", position = { 504, 400 } };
   Button same_folder_as_files_radio { this, text = "Same Folder As Files:", size = { 167, 15 }, position = { 288, 376 }, isRadio = true };
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


   
   for (row = najbatch_list_box.firstRow; row; row = row.next)
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






   
   msgbox(processing_output_file_path, processing_output_file_path);

   //help_edit_box.AddS(processing_output_file_path);


   /*
   if (! strcmp(najitool_command, "copyfile") )
   copyfile(najbatch_list_box.GetData(batchfilenumber), processing_output_file_path);
   */

   }



   /*
   if (! strcmp(najitool_command, "8bit256") )
   _8bit256(processing_output_file_path, atoi(parameter_1_string));
 
   if (! strcmp(najitool_command, "addim") )
   addim(atoi(parameter_1_string), processing_output_file_path);

   if (! strcmp(najitool_command, "allfiles") )
   notbatch();
 
   if (! strcmp(najitool_command, "allbmp16") )
   allbmp16(output_folder_path);

   if (! strcmp(najitool_command, "arab2eng") )
   arab2eng(batchfilelist[batchfilenumber], processing_output_file_path);
 
   if (! strcmp(najitool_command, "asc2ebc") )
   asc2ebc(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "asctable") )
   asctable(processing_output_file_path);

   if (! strcmp(najitool_command, "ay") )
   {
   notbatch();
   return true;
   }
 
   if (! strcmp(najitool_command, "ayinkaci") )
   {
   notbatch();
   return true;
   }

   if (! strcmp(najitool_command, "bigascif") )
   bigascif(parameter_1_string, processing_output_file_path);

   if (! strcmp(najitool_command, "bigascii") )
   {
   notbatch();
   return true;
   }

   if (! strcmp(najitool_command, "bin2c") )
   bin2c(batchfilelist[batchfilenumber], processing_output_file_path, parameter_1_string);

   if (! strcmp(najitool_command, "bin2hexi") )
   bin2hexi(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "bin2text") )
   bin2text(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "blanka") )
   blanka(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "bremline") )
   bremline(parameter_1_string, batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "bugun") )
   {
   notbatch();
   return true;
   }
 
   if (! strcmp(najitool_command, "calc") )
   {
   najicalc naji_calc {};
   naji_calc.Modal();
   return true;
   }

   if (! strcmp(najitool_command, "cat_head") )
   {
   cat_head(batchfilelist[batchfilenumber], atoi(parameter_1_string));
   return true;
   }

   if (! strcmp(najitool_command, "cat_tail") )
   {
   cat_tail(batchfilelist[batchfilenumber], atoi(parameter_1_string));
   return true;
   }

   if (! strcmp(najitool_command, "cat_text") )
   {
   cat_text(batchfilelist[batchfilenumber]);
   return true;
   }

   if (! strcmp(najitool_command, "catrandl") )
   {
   catrandl(batchfilelist[batchfilenumber]);
   return true;
   }
 
   if (! strcmp(najitool_command, "ccompare") )
   {
   notbatch();
   return true;
   }
 
   if (! strcmp(najitool_command, "cfind") )
   {
   cfind(batchfilelist[batchfilenumber], parameter_1_string);
   return true;
   }

   if (! strcmp(najitool_command, "cfindi") )
   {
   cfindi(batchfilelist[batchfilenumber], parameter_1_string);
   return true;
   }
 
   if (! strcmp(najitool_command, "charaftr") )
   charaftr(batchfilelist[batchfilenumber], processing_output_file_path, parameter_1_string[0]);

   if (! strcmp(najitool_command, "charbefr") )
   charbefr(batchfilelist[batchfilenumber], processing_output_file_path, parameter_1_string[0]);

   if (! strcmp(najitool_command, "charfile") )
   charfile(processing_output_file_path, atoi(parameter_2_string), parameter_1_string[0]);
   
   if (! strcmp(najitool_command, "charsort") )
   charsort(batchfilelist[batchfilenumber], processing_output_file_path);
   
   if (! strcmp(najitool_command, "charwrap") )
   charwrap(atoi(parameter_1_string), batchfilelist[batchfilenumber], processing_output_file_path);
       
   if (! strcmp(najitool_command, "chchar") )
   chchar(batchfilelist[batchfilenumber], processing_output_file_path, parameter_1_string[0], parameter_2_string[0]);

   if (! strcmp(najitool_command, "chchars") )
   chchars(batchfilelist[batchfilenumber], processing_output_file_path, parameter_1_string, parameter_2_string);

   if (! strcmp(najitool_command, "chstr") )
   chstr(batchfilelist[batchfilenumber], processing_output_file_path, parameter_1_string, parameter_2_string);

   if (! strcmp(najitool_command, "coffset") )
   {
   coffset(batchfilelist[batchfilenumber], atoi(parameter_1_string), atoi(parameter_2_string));
   return true;
   }

   if (! strcmp(najitool_command, "compare") )
   {
   notbatch();
   return true;
   }

   if (! strcmp(najitool_command, "copyfile") )
   copyfile(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "copyoffs") )
   copyoffs(batchfilelist[batchfilenumber], atoi(parameter_1_string), atoi(parameter_2_string), processing_output_file_path);

   if (! strcmp(najitool_command, "copyself") )
   {
   notbatch();
   }

   if (! strcmp(najitool_command, "cpfroml") )
   cpfroml(atol(parameter_1_string), batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "cptiline") )  
   cptiline(atol(parameter_1_string), batchfilelist[batchfilenumber], processing_output_file_path); 


   if (! strcmp(najitool_command, "credits") )
   {
   najitool_gui_credits();
   return true;
   }
   
   if (! strcmp(najitool_command, "database") )
   {
   tabdatabase.SelectTab();
   return true;
   }

   if (! strcmp(najitool_command, "datetime") )
   {
   notbatch();
   return true;
   }
 
   if (! strcmp(najitool_command, "dayofmon") )
   {
   notbatch();
   return true;
   }

   if (! strcmp(najitool_command, "dos2unix") )
   dos2unix(batchfilelist[batchfilenumber], processing_output_file_path);
 
   if (! strcmp(najitool_command, "downlist") )
   downlist(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "dumpoffs") )
   {
   dumpoffs(batchfilelist[batchfilenumber], atoi(parameter_1_string), atoi(parameter_2_string));
   return true;
   }
   
   if (! strcmp(najitool_command, "e2ahtml") )
   e2ahtml(batchfilelist[batchfilenumber], processing_output_file_path);
   
   if (! strcmp(najitool_command, "ebc2asc") )
   ebc2asc(batchfilelist[batchfilenumber], processing_output_file_path);
   
   if (! strcmp(najitool_command, "eng2arab") )
   eng2arab(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "engnum") )
   engnum(processing_output_file_path);
 
   if (! strcmp(najitool_command, "eremline") )  
   eremline(parameter_1_string, batchfilelist[batchfilenumber], processing_output_file_path); 
 
   if (! strcmp(najitool_command, "f2lower") )
   f2lower(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "f2upper") )
   f2upper(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "filebreed") )
   notbatch();

   if (! strcmp(najitool_command, "file2bin") )
   file2bin(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "file2dec") )
   file2dec(batchfilelist[batchfilenumber], processing_output_file_path);
   
   if (! strcmp(najitool_command, "file2hex") )
   file2hex(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "filechop") )
   notbatch();
   
   if (! strcmp(najitool_command, "filejoin") )
   notbatch();
   
   if (! strcmp(najitool_command, "fillfile") )
   fillfile(processing_output_file_path, parameter_1_string[0]);
   
   if (! strcmp(najitool_command, "find") )
   {
   find(batchfilelist[batchfilenumber], parameter_1_string);
   return true;
   }

   if (! strcmp(najitool_command, "findi") )
   {
   findi(batchfilelist[batchfilenumber], parameter_1_string);
   return true;
   }
  
   if (! strcmp(najitool_command, "flipcopy") )
   flipcopy(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "freverse") )
   freverse(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "fswpcase") )
   fswpcase(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "ftothe") )
   ftothe(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "genhelp") )
   notbatch();
   
   if (! strcmp(najitool_command, "genlic") )
   naji_genlic(processing_output_file_path);

   if (! strcmp(najitool_command, "getlinks") )
   getlinks(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "gdivide") )
   notbatch();

   if (! strcmp(najitool_command, "gigabyte") )
   {
   notbatch();
   return true;
   }

   if (! strcmp(najitool_command, "gminus") )
   notbatch();

   if (! strcmp(najitool_command, "gplus") )
   notbatch();
   
   if (! strcmp(najitool_command, "gtimes") )
   notbatch();

   // help

   if (! strcmp(najitool_command, "hexicat") )
   hexicat(batchfilelist[batchfilenumber]);

   if (! strcmp(najitool_command, "hilist") )
   hilist(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "hmaker") )
   hmaker(batchfilelist[batchfilenumber]);

   if (! strcmp(najitool_command, "hmakerf") )
   hmakerf(batchfilelist[batchfilenumber], processing_output_file_path);
   
   if (! strcmp(najitool_command, "html_db") )
   {
   naji_db_html_selected = true;
   tabdatabase.SelectTab();
   return true;
   }

   if (! strcmp(najitool_command, "html2txt") )
   html2txt(batchfilelist[batchfilenumber], processing_output_file_path);
  
   if (! strcmp(najitool_command, "htmlfast") )
   htmlfast(batchfilelist[batchfilenumber], processing_output_file_path);
   
   if (! strcmp(najitool_command, "htmlhelp") )
   notbatch();
   
   if (! strcmp(najitool_command, "kitten") )
   {
   kitten(batchfilelist[batchfilenumber]);
   return true;
   }
        
   if (! strcmp(najitool_command, "lcharvar") )
   {
   lcharvar(parameter_1_string);
   return true;
   }

   if (! strcmp(najitool_command, "lcvfiles") )
   lcvfiles(batchfilelist[batchfilenumber], output_folder_path);
   
   if (! strcmp(najitool_command, "leetfile") )
   leetfile(batchfilelist[batchfilenumber], processing_output_file_path);
   
   if (! strcmp(najitool_command, "leetstr") )
   {
   leetstr(parameter_1_string);
   return true;
   }
   
   if (! strcmp(najitool_command, "length") )
   {
   tablength.SelectTab();
   return true;
   }

   if (! strcmp(najitool_command, "lensortl") )
   lensortl(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "lensorts") )
   lensorts(batchfilelist[batchfilenumber], processing_output_file_path);
   
   if (! strcmp(najitool_command, "license") )
   {
   najitool_gui_license();
   return true;
   }

   if (! strcmp(najitool_command, "linesnip") )
   linesnip(atoi(parameter_1_string), batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "makarray") )
   makarray(batchfilelist[batchfilenumber], processing_output_file_path, parameter_1_string);


   if (! strcmp(najitool_command, "mathgame") )
   {
   tabmathgame.SelectTab();
   return true;
   }

   if (! strcmp(najitool_command, "mergline") )
   notbatch();

   if (! strcmp(najitool_command, "mkpatch") )
   notbatch();

   if (! strcmp(najitool_command, "month") )
   {
   notbatch();
   return true;
   }

   if (! strcmp(najitool_command, "mp3split") )
   mp3split(batchfilelist[batchfilenumber], processing_output_file_path, atoi(parameter_1_string), atoi(parameter_2_string));

   if (! strcmp(najitool_command, "mp3taged") )
   {
   
   if (!strcmp(najitool_language, "English"))
   msgbox("najitool GUI mp3taged information", "Sorry the mp3 tag editor is not implemented in this version because it has bugs which need to be fixed first.");
   else if (!strcmp(najitool_language, "Turkish"))
   msgbox("najitool GUI mp3taged bilgi", "Maalesef mp3 tag editoru bu verisyon icinde uygulanmadi cunku oncelikle duzeltilmesi gereken hatalar var.");
   
   
   return true;
   }

   if (! strcmp(najitool_command, "mp3tagnf") )
   {
   mp3info_gui(batchfilelist[batchfilenumber]);
   return true;
   }

   if (! strcmp(najitool_command, "n2ch") )
   n2ch(parameter_1_string[0], batchfilelist[batchfilenumber], processing_output_file_path);


   if (! strcmp(najitool_command, "n2str") )
   n2str(parameter_1_string, batchfilelist[batchfilenumber], processing_output_file_path);


   if (! strcmp(najitool_command, "najcrypt") )
   {
   tabcrypt.SelectTab();
   return true;
   }

   if (! strcmp(najitool_command, "naji_bmp") )
   naji_bmp(output_folder_path);
   
   if (! strcmp(najitool_command, "najirle") )
   najirle(batchfilelist[batchfilenumber], processing_output_file_path);
   
   if (! strcmp(najitool_command, "najisum") )
   najisum(batchfilelist[batchfilenumber]);
   
   if (! strcmp(najitool_command, "numlines") )
   numlines(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "onlalnum") )
   onlalnum(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "onlalpha") )
   onlalpha(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "onlcntrl") )
   onlcntrl(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "onldigit") )
   onldigit(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "onlgraph") )
   onlgraph(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "onllower") )
   onllower(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "onlprint") )
   onlprint(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "onlpunct") )
   onlpunct(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "onlspace") )
   onlspace(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "onlupper") )
   onlupper(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "onlxdigt") )
   onlxdigt(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "onlycat") )
   onlycat(batchfilelist[batchfilenumber], parameter_1_string);
  
   if (! strcmp(najitool_command, "onlychar") )
   onlychar(batchfilelist[batchfilenumber], processing_output_file_path, parameter_1_string);

   if (! strcmp(najitool_command, "patch") )
   {
   tabpatch.SelectTab();
   return true;
   }

   if (! strcmp(najitool_command, "printftx") )
   printftx(batchfilelist[batchfilenumber], processing_output_file_path);
   
   if (! strcmp(najitool_command, "putlines") )
   putlines(batchfilelist[batchfilenumber], processing_output_file_path, parameter_1_string, parameter_2_string);

   if (! strcmp(najitool_command, "qcrypt") )
   qcrypt(batchfilelist[batchfilenumber], processing_output_file_path);
   
   if (! strcmp(najitool_command, "qpatch") )
   qpatch(processing_output_file_path, batchfilelist[batchfilenumber]);

   if (! strcmp(najitool_command, "randkill") )
   randkill(processing_output_file_path);

   if (! strcmp(najitool_command, "rbcafter") )
   rbcafter(batchfilelist[batchfilenumber], processing_output_file_path);
   
   if (! strcmp(najitool_command, "rbcbefor") )
   rbcbefor(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "rcharvar") )
   {
   rcharvar(parameter_1_string);
   return true;
   }
 
   if (! strcmp(najitool_command, "rcvfiles") )
   rcvfiles(batchfilelist[batchfilenumber], output_folder_path);

   if (! strcmp(najitool_command, "remline") )
   remline(parameter_1_string, batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "repcat") )
   repcat(batchfilelist[batchfilenumber], atoi(parameter_1_string));

   if (! strcmp(najitool_command, "repcatpp") )
   repcatpp(batchfilelist[batchfilenumber], atoi(parameter_1_string));

   if (! strcmp(najitool_command, "repchar") )
   repchar(batchfilelist[batchfilenumber], processing_output_file_path, atoi(parameter_1_string));

   if (! strcmp(najitool_command, "repcharp") )
   repcharp(batchfilelist[batchfilenumber], processing_output_file_path, atoi(parameter_1_string));

   if (! strcmp(najitool_command, "revcat") )
   revcat(batchfilelist[batchfilenumber]);
  
   if (! strcmp(najitool_command, "revlines") )
   revlines(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "rmunihtm") )
   naji_del_gen_unicode_html_pages(output_folder_path);

   if (! strcmp(najitool_command, "rndbfile") )
   rndbfile(batchfilelist[batchfilenumber], atol(parameter_1_string));

   if (! strcmp(najitool_command, "rndbsout") )
   {
   rndbsout(atol(parameter_1_string));
   return true;
   }

   if (! strcmp(najitool_command, "rndffill") )
   rndffill(processing_output_file_path);

   if (! strcmp(najitool_command, "rndtfile") )
   rndtfile(batchfilelist[batchfilenumber], atol(parameter_1_string));

   if (! strcmp(najitool_command, "rndtsout") )
   {
   rndtsout(atol(parameter_1_string));
   return true;
   }

   if (! strcmp(najitool_command, "rrrchars") )
   rrrchars(batchfilelist[batchfilenumber], processing_output_file_path, atoi(parameter_1_string), atoi(parameter_2_string));

   if (! strcmp(najitool_command, "rstrach") )
   rstrach(atoi(parameter_1_string), batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "rstrbch") )
   rstrbch(atoi(parameter_1_string), batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "rtcafter") )
   rtcafter(batchfilelist[batchfilenumber], processing_output_file_path);
   
   if (! strcmp(najitool_command, "rtcbefor") )
   rtcbefor(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "saat") )
   {
   notbatch();
   return true;
   }

   if (! strcmp(najitool_command, "saatarih") )
   {
   notbatch();
   return true;
   }
          
   if (! strcmp(najitool_command, "showline") )
   {
   showline(batchfilelist[batchfilenumber], atoi(parameter_1_string));
   return true;
   }
 

   if (! strcmp(najitool_command, "skipcat") )
   {
   skipcat(batchfilelist[batchfilenumber], parameter_1_string);
   return true;
   }
  
   if (! strcmp(najitool_command, "skipchar") )
   skipchar(batchfilelist[batchfilenumber], processing_output_file_path, parameter_1_string);

   if (! strcmp(najitool_command, "skipstr") )
   skipstr(batchfilelist[batchfilenumber], processing_output_file_path, parameter_1_string);
 
   if (! strcmp(najitool_command, "skpalnum") )
   skpalnum(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "skpalpha") )
   skpalpha(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "skpcntrl") )
   skpcntrl(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "skpdigit") )
   skpdigit(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "skpgraph") )
   skpgraph(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "skplower") )
   skplower(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "skpprint") )
   skpprint(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "skppunct") )
   skppunct(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "skpspace") )
   skpspace(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "skpupper") )
   skpupper(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "skpxdigt") )
   skpxdigt(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "strachar") )
   strachar(parameter_1_string, batchfilelist[batchfilenumber], processing_output_file_path);
   
   if (! strcmp(najitool_command, "strbchar") )
   strbchar(parameter_1_string, batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "strbline") )
   strbline(batchfilelist[batchfilenumber], processing_output_file_path, parameter_1_string);

   if (! strcmp(najitool_command, "streline") )
   streline(batchfilelist[batchfilenumber], processing_output_file_path, parameter_1_string);

   if (! strcmp(najitool_command, "strfile") )
   strfile(processing_output_file_path, atoi(parameter_1_string), parameter_2_string);

   if (! strcmp(najitool_command, "swapfeb") )
   notbatch();

   if (! strcmp(najitool_command, "systemdt") )
   {
   notbatch();
   return true;
   }

   if (! strcmp(najitool_command, "tabspace") )
   tabspace(atoi(parameter_1_string), batchfilelist[batchfilenumber], processing_output_file_path);
   
   
   if (! strcmp(najitool_command, "telltime") )
   {
   notbatch();
   return true;
   }

   if (! strcmp(najitool_command, "today") )
   {
   notbatch();
   return true;
   }
            
   if (! strcmp(najitool_command, "tothe") )
   {
   tothe(parameter_1_string);
   return true;
   }

   if (! strcmp(najitool_command, "ttt") )
   {
   ttt ttt_game {};
   ttt_game.Modal();
   return true;
   }  

   if (! strcmp(najitool_command, "turnum") )
   {
   turnum(processing_output_file_path);
   return true;
   }

   if (! strcmp(najitool_command, "txt2html") )
   txt2html(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "unihtml") )
   naji_gen_unicode_html_pages(output_folder_path);

   if (! strcmp(najitool_command, "unajirle") )
   unajirle(batchfilelist[batchfilenumber], processing_output_file_path);
  
   if (! strcmp(najitool_command, "unblanka") )
   unblanka(batchfilelist[batchfilenumber], processing_output_file_path);  
 
   if (! strcmp(najitool_command, "unix2dos") )
   unix2dos(batchfilelist[batchfilenumber], processing_output_file_path);      
 
   if (! strcmp(najitool_command, "uudecode") )
   uudecode(batchfilelist[batchfilenumber], processing_output_file_path);
 
   if (! strcmp(najitool_command, "uuencode") )
   uuencode(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "vowelwrd") )
   {
   help_edit_box.Clear();
   vowelwrd(parameter_1_string);
   return true;
   }

   if (! strcmp(najitool_command, "wordline") )
   wordline(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "wordwrap") )
   wordwrap(batchfilelist[batchfilenumber], processing_output_file_path);

   if (! strcmp(najitool_command, "wrdcount") )
   {
   help_edit_box.Clear();
   help_edit_box.Printf("%u", wrdcount(batchfilelist[batchfilenumber]));
   return true;
   }
 
   if (! strcmp(najitool_command, "year") )
   {
   notbatch();
   return true;
   }
 
   if (! strcmp(najitool_command, "yil") )
   {
   notbatch();
   return true;
   }

   if (! strcmp(najitool_command, "zerokill") )
   zerokill(processing_output_file_path);

*/



   if (!strcmp(najitool_language, "English"))
   MessageBox { text = "najitool GUI", contents = "Processing complete." }.Modal();
   
   else if (!strcmp(najitool_language, "Turkish"))
   MessageBox { text = "najitool GUI", contents = "Islem tamamlandi." }.Modal();

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
   BitmapResource najitool_logo_bitmap { ":najitool.pcx", window = this };

   void OnRedraw(Surface surface)
   {
   surface.Blit(najitool_logo_bitmap.bitmap, 8, 24, 0,0, najitool_logo_bitmap.bitmap.width, najitool_logo_bitmap.bitmap.height);
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

    while(1)
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

    while(1)
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


     while(1)
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
char *units[10] = {
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

char *teens[10] = {
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

char *tens[8] = {
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
char *units[10] = {
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

char *teens[10] = {
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

char *tens[8] = {
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


        for(x=0; x<cvlen; x++)
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
                swap_char(cva[x], cva[y])
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

  if (b == 'a') { help_edit_box.Printf("4"); return; }
  if (b == 'b') { help_edit_box.Printf("8"); return; }
  if (b == 'e') { help_edit_box.Printf("3"); return; }
  if (b == 'i') { help_edit_box.Printf("1"); return; }
  if (b == 'o') { help_edit_box.Printf("0"); return; }
  if (b == 's') { help_edit_box.Printf("5"); return; }
  if (b == 't') { help_edit_box.Printf("7"); return; }
  if (b == 'd') { help_edit_box.Printf("|>");     return; }
  if (b == 'c') { help_edit_box.Printf("<");      return; }
  if (b == 'k') { help_edit_box.Printf("|<");     return; }
  if (b == 'm') { help_edit_box.Printf("/\\/\\"); return; }
  if (b == 'v') { help_edit_box.Printf("\\/");    return; }
  if (b == 'w') { help_edit_box.Printf("\\/\\/"); return; }
  if (b == 'h') { help_edit_box.Printf("|-|");    return; }
  if (b == 'n') { help_edit_box.Printf("|\\|");   return; }
  if (b == 'x') { help_edit_box.Printf("><");     return; }
  if (b == 'u') { help_edit_box.Printf("|_|");    return; }
  if (b == 'l') { help_edit_box.Printf("|_");     return; }
  if (b == 'j') { help_edit_box.Printf("_|");     return; }


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


        if(remove(fnamebuf) < 0)
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

    while(1)
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

























class HexEditorTop : Window 
{
   size = { 1024, 24 };
   disabled = true;


   Label hex_top_label { this, text = "Offset:           0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F     0 1 2 3 4 5 6 7 8 9 A B C D E F" , position = { 316, 2}};
}


class HexEditor : Window
{
 
   size = { 1024, 768 };

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
      this, text = "Scroll Down", size = { 104, 21 }, position = { 8, 128 };

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
      this, text = "Scroll Up", size = { 104, 21 }, position = { 8, 88 };

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


   };
   EditBox patch_load_file_edit_box { this, text = "patch_load_file_edit_box", size = { 104, 19 }, position = { 8, 24 }, readOnly = true, noCaret = true };
   Button patch_load_file_button
   {
      this, text = "Load File:", font = { "Verdana", 8.25f, bold = true }, clientSize = { 104, 21 }, position = { 8 };

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
      patch_load_file_button.text="Load File:";
      }

      else if (!strcmp(najitool_language, "Turkish"))
      {
      patch_load_file_button.text="Dosya Ac:";
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






class tab_hex : Tab
{
   text = "HexEdit";
   background = { r = 110, g = 161, b = 180 };
   font = { "Verdana", 8.25f, bold = true };
   size = { 1024, 768 };

   
   HexEditorTop najihexTop { this, anchor = { 0, 0, 0, 0 } };
   HexEditor najihex { this, anchor = { 0, 0, 0, 0 }, position = { 0, 24}};
}



































 class naji_gui : GuiApplication
 {
 driver = "OpenGL";
 }


