#ifdef ECERE_STATIC
import static "ecere"
#else
import "ecere"
#endif
import "najicmds"
import "najihelp"
#include "naji_gui.eh"


void notbatch(void)
{


      MessageBox { text = "najitool GUI 0.3.0.0 Error", contents = 

      "\nSorry, this command is not available in batch mode.\n"
      }.Modal(); 

}



void najitool_gui_license(void)
{


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

}
           

void najitool_gui_credits()
{

      MessageBox { text = "najitool GUI 0.3.0.0 Credits - in order of joining the project", contents = 
      "\n"
      "NECDET COKYAZICI - England, London - cokyazici@yahoo.co.uk\n"
      "Main author, programmer, planner, designer, tester, debugger,\n"
      "and project manager. Wrote everything that someone else didn't write.\n"
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
      "Programmer. Gave a lot of help and advice and bug fixes for naji_gui 0.3.0.0.\n"
      "He also designed the eC programming language and is currently developing the\n"
      "Ecere SDK since 1996, which is what naji_gui 0.3.0.0 and above use from 2011.\n"
      "\n"
      "The Ecere SDK is copyright Ecere corporation and the\n"
      "full source code is available at www.ecere.com\n"
      "The Ecere SDK is Free Open Source Software\n"
      "released under a revised BSD license.\n"
      "\n"
      "The source code to najitool, libnaji, and naji_gui aka najitool GUI,\n"
      "Are in the Public Domain (non-copyrighted) 2003-2011.\n"
      
       }.Modal();


}


void naji_getfilename(char *destination, char *source)
{
int len;
char *p;

  p = NULL;

  len = strlen(source);
 
  if (len <= 1)
  return;
  
  p = strrchr(source, '\\');
  
  if (p == NULL)
  p = strrchr(source, '/');
  
  if (p != NULL)
  {
  
  p++;

  len = strlen(p);

  memcpy(destination, p, len);

  msgbox(destination, destination);
  
  
  }

}
