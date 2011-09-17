#include "naji_gui.eh"

struct najihelp {
char *cmd;
bool input_file_1_edit_box_disabled;
bool input_file_1_button_disabled;

bool input_file_2_edit_box_disabled;
bool input_file_2_button_disabled;

bool input_folder_edit_box_disabled;
bool input_folder_button_disabled;

bool output_file_1_edit_box_disabled;
bool output_file_1_button_disabled;

bool output_file_2_edit_box_disabled;
bool output_file_2_button_disabled;

bool output_folder_edit_box_disabled;
bool output_folder_button_disabled;
   
bool parameter_1_label_disabled;
bool parameter_1_edit_box_disabled;

bool parameter_2_label_disabled;
bool parameter_2_edit_box_disabled;      

char *help_en;
char *param_1_en;
char *param_2_en;

char *help_tr;
char *param_1_tr;
char *param_2_tr;


};



najihelp helpitems[NAJITOOL_MAX_COMMANDS] = {

{
"8bit256",

true,
true,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,


"Makes a file with the character values 0 to 255\n"
"from start to finish the number of times you specify.\n"
"Specify output file and amount of times repeated in numbers.",

"Times:",
"Parameter 2:",


"Dosya yapiyor ASCII karakterler numalar ile 0-255 kadar\n"
"bastan sona kadar belirtigin kadar.\n"
"Yazilan dosyayi belirt ve kac kere tekrarlandigini belirt, numaralarla.",


"Tekrarlanis:",
"Parametre 2:"
},


{

"addim",

true,
true,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,


"Makes a multipliction square at the size you specify\n"
"Specify output file and size of square in numbers.",


"Size:",
"Parameter 2:",


"Belirttiginiz boyutta bir carpim kare yapar.\n"
"Yazilan dosyayi belirtin ve karevin boyutunu numaralarla belirtin.",

"Boyut:",
"Parametre 2:"
},



{
"allfiles",

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

false,
false,

false,
false,

true,
true,




"Generates every single file ever possible to exist at a size you specify.\n"
"Select output folder and size of files in numbers.",

"Size:",
"Parameter 2:",


"Mumkun olabilen her bir dosya olusturur, belirttiginiz boyutta.\n"
"Yazilan klasor belirt ve dosyalarin boyutlarini belirt.",

"Boyut:",
"Parametre 2:"
},


{
"allbmp16",

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,




"Generates every single .bmp file ever possible to exist at 16 width, 16 height, and 16 color.\n"
"Select output folder.",

"Parameter 1:",
"Parameter 2:",


"Mumkun olabilen her bir .bmp dosya olusturur, 16 genislik, 16 yukseklik, ve 16 renk de.\n"
"Yazilan klasor belirt.",

"Parametre 1:",
"Parametre 2:"
},




{
"arab2eng",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,




"Arabic to English transliteration system. Makes English\n"
"letters out of Arabic letters. Download the transliteration\n"
"table from http://najitool.sf.net/ for details.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Arapca'dan Ingilizce'ye cevirisi sistemi. Arapca harflerden\n"
"Ingilizce harflar yapiyor. Cevirisi tabloyu indir burdan\n"
"http://najitool.sf.net/ daha fazla detay icin.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},


{
"asc2ebc",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,


"Converts ASCII format files to EBCDIC format files.\n"
"Specify input file and output file.",


"Parameter 1:",
"Parameter 2:",


"ASCII tip dosyalari EBCDIC tip dosyalara donusturur.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},



{
"asctable",

true,
true,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,





"Makes a text file with an ASCII table and the decimal, hexidecimal,\n"
"and binary values on each line of it from values 32 to 126.\n"
"Specify output file.",

"Parameter 1:",
"Parameter 2:",





"Bir tekst dosya yapar ASCII tablosu ile ve ondalik, onaltilik,\n"
"ve ikilik, her satirinda ASCII numarlarlar 32 den 126'ya kadar.\n"
"Yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},


{
"ay",


true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,





"Shows the current month in Turkish.",
"Parameter 1:",
"Parameter 2:",





"Bu ay hangi ay oldugunu gosterir (Turkce).",
"Parametre 1:",
"Parametre 2:"


},





{
"ayinkaci",



true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,




"Shows the day of the current month.",

"Parameter 1:",
"Parameter 2:",




"Ay'in kaci oldugunu gosterir.",


"Parametre 1:",
"Parametre 2:"


},



{
"bigascif",



true,
true,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,




"Makes a file with big ASCII art text  of the word or\n"
"sentence you specify. Specify put file and text.",

"Text:",
"Parameter 2:",



"Buyuk ASCII harf ressamlikli bir dosya yapiyor belirtigin\n"
"kelime veya cumle'den. Yazilan dosyayi ve teksti belirt.",

"Tekst:",
"Parametre 2:"

},



{
"bigascii",



true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

false,
false,

true,
true,




"Shows big ASCII art version of the word or sentence you\n"
"specify to the screen. Specify the text.",

"Text:",
"Parameter 2:",



"Buyuk ASCII harf ressamlikli gosteriyor ekrana belirtigin\n"
"kelime veya cumle'den. Teksti belirt.",

"Tekst:",
"Parametre 2:"



},




{
"bin2c",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,


"Makes a compilable C programming language source code file\n"
"of any file with the contents of the file in an array.",

"Array Name",
"Parameter 2:",


"C programlama dilinde kod yapiyor her hangi bir dosyadan\n"
"ve o dosyanin icindekilerinden bir C array yapiyor.",

"C Array Isim:",
"Parametre 2:"

},










{
"bin2hexi",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,



"Dumps the file you specify in hexadecimal to a new file.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",


"Bir dosyayi onaltiliga ceviriyor yeni bir dosya kopyalayarak.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"


},





{
"bin2text",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,



"Makes a copy of the file you specify with only the\n"
"text of the file skipping binary characters.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",


"Belirtigin dosyanin kopyasini yapiyor sadece metin tekstini tutuyor\n"
"ve ikilik karakterleri tutmuyor. Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"


},




{

"blanka",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,





"When a file is converted to blanka format, depending on the decimal value\n"
"of an ASCII char it makes that many spaces, e.g. 65 spaces for the letter A,\n"
"then it makes a newline to seperate the next char, which could be B, so it\n"
"makes 66 spaces, etc. Use unblanka to convert back to original, it can still\n"
"change the file back to its original form if the blanka format file is edited\n"
"with adding anymore spaces or newlines and only other characters.\n"
"Useful for hidden messages. Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",





"Bir dosya blanka bicimine cevirildiginde, ondalik degerine bagli olarak\n"
"ASCII karakterinin o kadar bosluk yapar, mesala 65 tane bosluk A harfi icin,\n"
"ondan sonra bir satir yapar obur karakteri ayirmak icin, mesala B olabalir,\n"
"oyle ise 66 tane bosluk yapar. unblanka kulan orijinala geri cevirmek icin dosyayi,\n"
"unblanka hala originala deyistirebilir blanka biciminde dosya degistirildiyse baska\n"
"yeni bozluk veya satir eklemeden ve sadece baska karakterler eklemekle.\n"
"Gizli mesajlar icin kullanislidir. Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},


{
"bremline",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,



"Makes a copy of a file removing lines\n"
"beginning with a certain word or sentence.\n"
"Specify lines begining with the text and input and output file.",

"Text",
"Parameter 2:",


"Bir dosyayi kopyaliyor belirtigin kelime veya cumle ile baslayan satirlari\n"
"kopyalamadan. Okunan ve yazilan, ve baslayan satir teksti belirt.",

"Tekst:",
"Parametre 2:"
},


{

"bugun",


true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,





"Shows what the day is today in Turkish.",

"Parameter 1:",
"Parameter 2:",


"Bugun hangi gun oldugunu gosterir (Turkce).",


"Parametre 1:",
"Parametre 2:"

},



{

"calc",



true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,





"A calculator.",

"Parameter 1:",
"Parameter 2:",


"Bir Hesap makinasi.",

"Parametre 1:",
"Parametre 2:"

},

{
"cat_head",

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

false,
false,

true,
true,





"Shows the number of first lines in the file you specify.\n"
"Specify input file and number of first lines.",

"No.of lines:",
"Parameter 2:",



"Belirttiginiz dosyasinda ilk satir sayisini gosterir.\n"
"Okunan dosyayi ve bastan kac satir gosterilcegeni belirt.",

"Bastan Kac: ",
"Parametre 2:"
},





{

"cat_tail"

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

false,
false,

true,
true,



"Shows the number of last lines in the file you specify.\n"
"Specify input file and number of last lines.",

"No.of lines:",
"Parameter 2:",


"Belirttiginiz dosyasinda son satir sayisini gosterir. \n"
"Okunan dosyayi ve sondan kac satir gosterilcegeni belirt.",

"Sondan Kac: ",
"Parametre 2:"
},



{
"cat_text",

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,



"Shows only the text of a file to screen skipping binary characters.\n"
"Specify input file.",

"Parameter 1:",
"Parameter 2:",





"Sadece dosyanin metin karakterleri gosterir ikilikleri de kaytarir.\n"
"Okunan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},
{
"catrandl",

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,




"Shows a random line of a text file.\n"
"Specify input file.",

"Parameter 1:",
"Parameter 2:",



"Bir metin dosyasi rastgele bir satir gosterir.\n"
"Okunan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"


},

{

"ccompare",

false,
false,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,


"Compares two files and still continues when differences are encountered.\n"
"Specify input file and 2nd input file.",

"Parameter 1:",
"Parameter 2:",


"Iki dosyayi karsilastirir hala farkliliklar varsa karsilasildiginda devam ediyor.\n"
"Okunan dosya 1 ve okunan dosya 2 belirt.",

"Parametre 1:",
"Parametre 2:"
},                             

{
"cfind",

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

false,
false,

true,
true,


"Search each line for text and display the contents of the line,\n"
"also displays how many lines contained the text.\n"
"Specify input file and text.",

"Text:",
"Parameter 2:",


"Bir metin dosyanin her satirni arar belirlediginiz bir tekst icin ve gosterir satiri,\n"
"hemde kac satir icinde tekst var sayisini verir.\n"
"Okunan dosyayi belirt ve teksti belirt.",

"Tekst:",
"Parametre 2:"

},



{
"cfindi",

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

false,
false,

true,
true,





"Search each line for text (case insensitive) and display the contents of the line,\n"
"also displays how many lines contained the text.\n"
"Specify input file and text.",

"Text:",
"Parameter 2:",



"Bir metin dosyanin her satirni arar belirlediginiz bir tekst icin (buyuk veya kucuk\n"
"harf fark etmiyor) ve gosterir satiri, hemde kac satir icinde tekst var sayisini verir.\n"
"Okunan dosyayi belirt ve teksti belirt.",

"Tekst:",
"Parametre 2:"
},

{

"charaftr",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,



"Makes a copy of a file with the specified character after each byte.\n"
"Specify input file and output file and character to be added after every byte.",

"Character:",
"Parameter 2:",


"Bir dosyanin kopyasini yapip her byte den sonra bir belirlediginiz karakteri koyuyor.\n"
"Okunan dosya ve yazilan dosya ve hangi karakter her byte den sonra eklencegeni belirt.",

"Karakter:",
"Parametre 2:"
},
                  
{
"charbefr",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,



"Makes a copy of a file with the specified character before each byte.\n"
"Specify input file and output file and character to be added before every byte.",

"Character:",
"Parameter 2:",



"Bir dosyanin kopyasini yapip her byte den once bir belirlediginiz karakteri koyuyor.\n"
"Okunan dosya ve yazilan dosya ve hangi karakter her byte den once eklencegeni belirt.",

"Karakter:",
"Parametre 2:"
},                        

{
"charfile",

true,
true,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

false,
false,

false,
false,


"Makes a file containing a single character you specify the amount of times you specify.\n"
"Specify output file and character to be used and file size in bytes.",

"Character:",
"Filesize:",


"Bir dosya olusturur belirlediginiz tek bir karakter ile bir dosyayi belirlediginiz\n"
"boyutda. Yazilan dosyayi, karakteri, ve dosya boyutu belirt (kac byte).\n",

"Karakter:",
"Kac byte:"
},

{
"charsort",


false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box




"Makes a copy of a file sorting all the characters in ascending binary order.\n"
"Specify input and output file.",
"Parameter 1:",
"Parameter 2:",

"Bir dosya kopyasini yaparak butun karakterleri ikilik sayisi artarak diziyor.\n"
"Okunan ve yazilan dosyayi belirt.",
"Parametre 1:",
"Parametre 2:"


},



{

"charwrap"

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,


"Wraps characters at the specified width.\n"
"Specify input file, output file and width to wrap at.",

"Width:",
"Parameter 2:",



"Dosyanin karakterleri belirlediginiz genislikte satirlatiyor\n"
"Okunan dosya ve yazilan dosya ve genisligi belirt.",

"Genislik:",
"Parametre 2:"
},

{
"chchar",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

false,
false,

false,
false,





"Changes the specified character in a file to a new character.\n"
"Specify input file, output file, original and changed character.",

"Original:",
"Changed:",


"Dosyanin belirlediginiz karaktari yeni karaktere deyistirir.\n"
"Okunan ve yazilan dosyayi belirt ve orijinal ve deyistirelen karakteri belirt.",

"Orijinal:",
"Deyisen:"
},




{
"chchars",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

false,
false,

false,
false,



"Changes the specified characters in a file to a new characters.\n"
"Specify input file, output file, original and changed characters.",

"Original:",
"Changed:",



"Dosyanin belirlediginiz karaktarlari yeni karakterlere deyistirir.\n"
"Okunan ve yazilan dosyayi belirt ve orijinal ve deyistirelen karakterleri belirt.",

"Orijinal:",
"Deyisen:"

},                          

{

"chstr",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

false,
false,

false,
false,



"Changes the specified string in a text file to a new string. \n"
"Specify input file, output file, original and changed string.",

"Original:",
"Changed:",


"Belirlediginiz metin dosyanin teksti yeni tekste deyistirir.\n"
"Okunan ve yazilan dosyayi belirt ve orijinal ve deyistirelen teksti belirt.",

"Orijinal:",
"Deyisen:"
},

{
"coffset",

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

false,
false,

false,
false,


"Shows the characters in a file from the offset (start and end) you specify to the\n"
"screen. Specify input file, start range, and end range.",

"Start Range:",
"End Range:",


"Belirtin ofset dan (baslangic ve bitis) bir dosyanin karakterleri gosterir ekrana.\n"
"Okunan dosyayi belirt ve baslangic ve bitisini belirt.",

"Baslangic:",
"Bitis:"
},
                    
{
"compare",

false,
false,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,



"Compares two files.\n"
"Specify input file and 2nd input file.",

"Parameter 1:",
"Parameter 2:",



"Iki dosyayi karsilastirir.\n"
"Okunan dosya 1 ve okunan dosya 2 belirt.",

"Parametre 1:",
"Parametre 2:"
},            

{

"copyfile",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,





"Copies a file.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",





"Bir dosyayi kopyaliyor.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

             
{
"copyoffs",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

false,
false,

false,
false,


"Copies the characters in a file from the offset (start and end) you specify to a\n"
"new file. Specify input file, output file, start range, and end range.",

"Start Range:",
"End Range:",


"Belirtin ofset dan (baslangic ve bitis) bir dosyanin karakterleri kopyaliyor yeni.\n"
"bir dosyaya. Okunan ve yazilan dosyayi belirt ve baslangic ve bitisini belirt.",

"Baslangic:",
"Bitis:"
},              
{

"copyself",

true,
true,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,





"Copies the najitool GUI program to a new filename.\n"
"Specify output file.",

"Parameter 1:",
"Parameter 2:",





"najitool GUI programi yeni bir dosya isime kopyaliyor.\n"
"Yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"cpfroml",

false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box


"Makes a copy of a text file copying only from the specified line number.\n"
"This is useful if you get an error importing a large MySQL .sql file and\n"
"it stops with and error giving you the line number the error occured, you\n"
"can use this to make a copy of the .sql file to continue from the error.",

"From line No.:",
"Parameter 2:",

"Belirlediginiz satirdan sona kadar metin dosyayi yeni bir metin dosyaya kopyalar.\n"
"Bu isinize yarar eger buyuk bir MySQL dosyayi import ederken hatta olustuysa ve\n"
"durdugu, hatta oldugu yerde satir numarasini verir, bunu kullanilir bas edilen\n"
".sql dosyanin kopyasini yapabilirsin hatta olan yerden devam etmek icin.",


"Satir Numara:",
"Parametre 2:"


},

{
"cptiline",


false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box




"Makes a copy of a text file copying only up to the specified line number.",
"Until line No.:",
"Parameter 2:",

"Bir metin dosyanin kopyasini yapiyor, sadece belirlediginiz satira kadar.",
"Satir No.:",
"Parametre 2:"


},


{
"credits",


true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box




"Shows the names and details of najitool GUI contributors and its original author.",
"Parameter 1:",
"Parameter 2:",


"najitool GUI'nin orijinal programcinin ve diger kod yazanlar kisilerin isimleri ve\n"
"ayrintilari gosterir.",
"Parametre 1:",
"Parametre 2:"

},



                                                        

{
"database",


true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box




"Makes or appends to a text file with a list of people and their details.",
"Parameter 1:",
"Parameter 2:",


"Bir metin dosya yapiyor insanlarin listesi ile ve ayrintilari ile.",
"Parametre 1:",
"Parametre 2:"


},


{
"datetime",


true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,




"Shows the current date and time.",

"Parameter 1:",
"Parameter 2:",



"tarih ve saati Ingilizce gosterir.",



"Parametre 1:",
"Parametre 2:"



},
 

       
{
"dayofmon",


true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,




"Shows the day of the current month.",

"Parameter 1:",
"Parameter 2:",




"Ay'in kaci oldugunu gosterir.",


"Parametre 1:",
"Parametre 2:"

},


{
"dos2unix",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,


"Converts DOS/Windows text files to UNIX format.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",



"DOS/Windows tekst dosyalari UNIX bicimine donusturur.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"downlist",
false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,


"Makes a HTML file from a text file with a list of files to download.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",



"Bir HTML dosya yapiyor bir metin dosyadan indirilen dosyalar listesi ile.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"dumpoffs",
false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

false,
false,

false,
false,



"Shows the hexidecimal values of the characters in a file from the offset\n"
"(start and end) you specify to the screen.\n"
"Specify input file, start range, and end range.",



"Start Range:",
"End Range:",




"Belirtin ofset dan (baslangic ve bitis) bir dosyanin karakterleri onaltilik seklinde\n"
"gosterir ekrana. Okunan dosyayi belirt ve baslangic ve bitisini belirt.",

"Baslangic:",
"Bitis:"
},


{
"e2ahtml",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,


"English to Arabic transliteration system. Makes Arabic\n"
"letters out of English letters. This version does that with\n"
"a plain text file to a HTML file. Download the transliteration\n"
"table from http://najitool.sf.net/ for details.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",



"Ingilizce'den Arapca'ya cevirisi sistemi. Ingilizce harflerden\n"
"Arapca harflar yapiyor. Bu versiyon metin dosyadan html dosyaya yapiyor.\n"
"Cevirisi tabloyu indir burdan http://najitool.sf.net/ daha fazla detay icin.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"ebc2asc",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,


"Converts EBCDIC format files to ASCII format files.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"EBCDIC tip dosyalari ASCII tip dosyalara donusturur.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"eng2arab",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,


"English to Arabic transliteration system. Makes Arabic\n"
"letters out of English letters. Download the transliteration\n"
"table from http://najitool.sf.net/ for details.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",



"Ingilizce'den Arapca'ya cevirisi sistemi. Ingilizce harflerden\n"
"Arapca harflar yapiyor. Cevirisi tabloyu indir burdan\n"
"http://najitool.sf.net/ daha fazla detay icin.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{

"engnum"



true,
true,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,



"Makes a file with a list of numbers in English words from 1 to 9999.\n"
"Specify output file.",

"Parameter 1:",
"Parameter 2:",



"Bir dosya yapiyor 1 den 9999'a kadar numaralarinin listesi Ingilizce kelime olarak.\n"
"Yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:",


},  




{
"eremline",

false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box




"Makes a copy of a file removing lines ending with a certain word or sentence.\n"
"Specify input file, output file, and text.",

"Text:",
"Parameter 2:",

"Bir metin dosyanin kopyasini yapiyor, belirlediginiz cumele veya kelime yi\n"
"satirlarin sonunda varsa o satir kopyalamiyor. Yazilan ve okunan dosya yi ve\n"
"Teksti belirt.",

"Tekst:",
"Parametre 2:"

},

{

"f2lower",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,





"Makes a copy of a file with all the\n"
"capital letters turned into small letters.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",





"bir dosyanin kopyasini yaparak tum buyuk Ingilizce\n"
"harflerli kucuk Ingilizce harflere deyistirirn\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"f2upper",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,



"Makes a copy of a file with all the\n"
"small letters turned into capital letters.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",


"bir dosyanin kopyasini yaparak tum kucuk Ingilizce\n"
"harflerli buyuk Ingilizce harflere deyistirirn\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"filbreed",

false, // in file 1 but
false, // in file 1 box

false, // in file 2 but
false, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box
                         

"Breeds two files i.e. the first byte of the first file\n"
"then the first byte of the second file are added to the\n"
"new file and the following bytes one file after another.\n"
"Specify 1st input file, 2nd input file, and output file.",

"Parameter 1:",
"Parameter 2:",


"Iki dosyayi yavrulatiyor, yani birinci bayt ilk dosyanin\n"
"ondan sonra birinci bayt ikinci dosyanin yeni dosyaya ekleniyor\n"
"ve baytlarin birbiri ardinda iki dosyaynin yeni dosyaya.\n"
"Ilk okunan dosya, ikinci okunan dosya, ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"file2bin",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,



"Makes a file into a stream of 1 and 0 binary numbers.\n"
"Specify input file and output file.",



"Parameter 1:",
"Parameter 2:",



"1 ve 0 ikili sayi, sira sira, bir yeni dosya ya yapar.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"file2dec",
false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,



"Makes a file into a stream of decimal numbers.\n"
"Specify input file and output file.",



"Parameter 1:",
"Parameter 2:",



"Ondalik numaralar, sira sira, bir dosyayi yapar.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"



},

{
"file2hex",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,



"Makes a file into a stream of hexidecimal values.\n"
"Specify input file and output file.",



"Parameter 1:",
"Parameter 2:",



"Onaltlik degerler, sira sira, bir dosyayi yapar.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"filechop",

false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

false, // out file 2 but
false, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box

"Splits a file into two new files at the offset you specify.\n"
"Specify offset, input file, output file 1, and output file 2.",

"Offset:",
"Parameter 2:",

"Bir dosyayi iki yeni dosyaya boler belirlediginiz ofset den.\n"
"Ofset, okunan dosyayi, yazilan dosya 1 ve 2 belirt.",

"Ofset:",
"Parametre 2:"


},

{
"filejoin",
false, // in file 1 but
false, // in file 1 box

false, // in file 2 but
false, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box
                         

"Joins two files into a new file.\n"
"Specify input file 1 input file 2, and output file.",

"Parameter 1:",
"Parameter 2:",


"Iki dosyayi yeni bir dosyaya birlestirir\n"
"Okunan dosya 1, okunan dosya 2, ve yazilan dosya belirt\n",

"Parametre 1:",
"Parametre 2:"


},


{
"fillfile",
true,
true,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,





"Changes every character in a file to the character you specify.\n"
"Specify output file and character to fill file with.",

"Character:",
"Parameter 2:",





"Bir dosya'nin her karakterini deyistiriyor belirlediginiz karaktere.\n"
"Yazilan dosyayi belirt ve dosyayi doldurulak karakteri belirt.",

"Karakter:",
"Parametre 2:"


},


{
"find",

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

false,
false,

true,
true,


"Search each line for text and display the contents of the line.\n"
"Specify input file and text.",

"Text:",
"Parameter 2:",


"Bir metin dosyanin her satirni arar belirlediginiz bir tekst icin ve gosterir satiri.\n"
"Okunan dosyayi belirt ve teksti belirt.",

"Tekst:",
"Parametre 2:"
},


{
"findi",

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

false,
false,

true,
true,


"Search each line for text (case insensitive) and display the contents of the line.\n"
"Specify input file and text.",

"Text:",
"Parameter 2:",


"Bir metin dosyanin her satirni arar belirlediginiz bir tekst icin (buyuk veya kucuk\n"
"harf fark etmiyor) ve gosterir satiri.\n"
"Okunan dosyayi belirt ve teksti belirt.",

"Tekst:",
"Parametre 2:"
},









{
"flipcopy",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,


"Copies while flipping the bits of each byte, for example\n"
"11110000 becomes\n"
"00001111\n"
"and\n"
"01010101 becomes\n"
"10101010 etc.\n\n"
"Specify input and output file",

"Parameter 1:",
"Parameter 2:",


"Bir dosyayi kopyalarak her bayt'in bit'ini ters ceviriyor\n"
"11110000\n"
"00001111 olur\n"
"ve\n"
"01010101 olur\n"
"10101010 vb\n\n"
"Okunan ve yazilan dosyalari belirt",



"Parametre 1:",
"Parametre 2:"

},

{
"freverse",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

"Makes a reversed copy of the file, the start of\n"
"the file becomes the end of the file and vice versa.",

"Parameter 1:",
"Parameter 2:",

"Ters cevirilmis dosya kopyasi yapiyor, dosya'nin basi\n"
"dosya'nin sonu oluyor ve dosya'nin sonu, basi oluyor.",



"Parametre 1:",
"Parametre 2:"



},

{
"fswpcase",
false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

"Makes a copy of a file with the case of letters swapped, i.e.\n"
"if it's capital letters, they become small letters and vice versa.\n"
"Specify input and output file.",

"Parameter 1:",
"Parameter 2:",

"Takas eder buyuk/kucuk harf ile bir dosyanin bir kopyasini yapar.\n"
"Mesala buyuk harfsa kucuk harf olur, buyuk harsa kucuk harf olur.\n"
"Okunan ve yazilan dosyalari belirt.",



"Parametre 1:",
"Parametre 2:"



},

{
"ftothe",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

"Makes a copy of a file adding the text \" to the\"\n"
"after every character except the last character.\n"
"Specify input and output file",

"Parameter 1:",
"Parameter 2:",


"Son karakteri disinda her karakterden \" to the\"\n"
"metin ekler bir dosyanin kopyasini yaparak.\n"
"Okunan ve yazilan dosyalari belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"genhelp",

true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box


"Generates the najitool GUI help text file.\n"
"Specify output file.",

"Parameter 1:",
"Parameter 2:",


"najitool GUI'in yardim metin belgesini olusturuyor.\n"
"Yazilan dosyalari belirt.",

"Parametre 1:",
"Parametre 2:"

                                     
},

{
"genlic",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box


"Generates the najitool GUI license.\n"
"Specify output file.",

"Parameter 1:",
"Parameter 2:",


"najitool GUI'in lisans metin belgesini olusturuyor.\n"
"Yazilan dosyalari belirt.",

"Parametre 1:",
"Parametre 2:"
                      
},

{
"getlinks",
false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,


"Saves only the links in a HTML file to a text file.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",



"Bir HTML dosya'nin sadece internet adres baglarini kaydeder bir metin dosya'ya.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"gdivide",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

false, // param 2 label
false, // param 2 box


"Calculates a list of division from start to end value.\n",
"Start No.",
"End No.",

"Hesaplar bolumu bir listesini bastan degeri sonuna kadar.\n",
"Start No.",
"End No."


},

{
"gigabyte",

true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box



"Calculates the number of bytes, kilobytes, and megabytes for the specified gigabytes.",

"Gigabytes:",
"Parameter 2:",

"Hesaplar bayt, kilobayt ve megabayt belirtilen gigabyte sayisinin.\n",

"Gigabyteler:",
"Parametre 2:"


},

{
"gminus",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

false, // param 2 label
false, // param 2 box


"Calculates a list of subtractions from start to end value.\n",
"Start No.",
"End No.",

"Hesaplar cikarma bir listesini bastan degeri sonuna kadar.\n",
"Start No.",
"End No."

},

{
"gplus",

true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

false, // param 2 label
false, // param 2 box


"Calculates a list of addition from start to end value.\n",
"Start No.",
"End No.",

"Hesaplar ekleme bir listesini bastan degeri sonuna kadar.\n",
"Start No.",
"End No."
},


{
"gtimes",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

false, // param 2 label
false, // param 2 box


"Calculates a list of multiplication from start to end value.\n",
"Start No.",
"End No.",

"Hesaplar carpma bir listesini bastan degeri sonuna kadar.\n",
"Start No.",
"End No."

},


{
"help",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box     


"Please select a category then a command and enter the required information in the\n"
"boxes then click the process button. Once you select a command, help for the\n"
"command will be displayed here.",

"Parameter 1:",
"Parameter 2:",


"Lutfen bir kategori secin sonra bir komut secin ve gereken bilgileri\n"
"kutularin icine verin sonra isle duymesine tiklayin. Komut sectikden sonra,\n"
"komut icin yardim burda gosterilcek.",


"Parametre 1:",
"Parametre 2:"


},

{
"hexicat",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Dumps the file you specify in hexidecimal to screen with the\n"
"displayable text characters on the right. Specify input file.",

"Parameter 1:",
"Parameter 2:",


"Belirttiginiz dosya'yi Onaltilik seklinde ekrana gosterir,\n"
"sagda'da goruntulenebilir metin karakterlerle.\n"
"Okunan dosyayi belirt.",


"Parametre 1:",
"Parametre 2:"




},

{
"hilist",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a HTML file from a text with a list of image names, showing\n"
"the images when the HTML file is opened in a web browser.",

"Parameter 1:",
"Parameter 2:",

"HTML dosyasi yapar, resim adlarinin listesini metin dosya dan,\n"
"bir web tarayicisinda acildiginda resimleri gosterir.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",


"Parametre 1:",
"Parametre 2:"     
},

{
"hmaker",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes function prototypes of a .c file and shows to the screen.\n"
"Specify input file.",

"Parameter 1:",
"Parameter 2:",

"Bir .c dosyanin fonksiyon prototiplerini yapar ve ekran gosterir.\n"
"Okunan dosyayi belirt.",


"Parametre 1:",
"Parametre 2:"     

},

{
"hmakerf",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   

"Makes a .h file with the function prototypes of a .c file.\n"
"Specify input file and output file",

"Parameter 1:",
"Parameter 2:",

"Bir .h yapar, bir .c dosyanin fonksiyon prototipler ile.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",


"Parametre 1:",
"Parametre 2:"     
},

{
"html_db",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes or appends to a HTML file with a list of people and their details.",
"Parameter 1:",
"Parameter 2:",


"Bir HTML dosya yapiyor insanlarin listesi ile ve ayrintilari ile.",
"Parametre 1:",
"Parametre 2:"
},

{
"html2txt",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a text file out of a HTML file.\n"
"Specify input file and output file",

"Parameter 1:",
"Parameter 2:",


"Bir HTML dosya yapiyor bir metin dosya'dan."
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"htmlfast",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   

"Makes a HTML file out of a text file preserving the spaces.\n"
"Specify input file and output file",

"Parameter 1:",
"Parameter 2:",


"Bir HTML dosya yapiyor bir metin dosya'dan bosluklari koruyarak.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"htmlhelp",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   

"Generates the najitool GUI help in HTML format.\n"
"Specify output file.",

"Parameter 1:",
"Parameter 2:",


"najitool GUI'in yardim belgesini olusturuyor HTML tipinde.\n"
"Yazilan dosyalari belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"kitten",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Shows the contents of a file to the screen.\n"
"Specify input file.",
"Parameter 1:",
"Parameter 2:",


"Bir dosyanin iceriginin ekrana gosterir.\n"
"Okunan dosyalari belirt.",

"Parametre 1:",
"Parametre 2:"
},



{
"lcharvar",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Shows every single combination variation of a sentence or word\n"
"starting from the left to the screen. Specify text.",

"Text:",
"Parameter 2:",

"Sol dan baslayarak bir cumle ya da kelimenin\n"
"her bir kombinasyon varyasyon gosterir ekrana.\n"
"Teksti belirt.",

"Tekst:",
"Parametre 2:",

},

{
"lcvfiles",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

false, // out folder but
false, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes files with every single combination variation of the specified input file\n"
"starting from the beginning of the specified file. Specify input file and output folder.",

"Parameter 1:",
"Parameter 2:",

"En basdan baslayarak bir dosyaninher bir kombinasyon varyasyon yapar yeni dosyalara.\n"
"Okunan dosya ve yazilan klasor belirt.\n",

"Parametre 1:",
"Parametre 2:",

},



{
"leetfile",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Converts a normal text file into a \"hacker language\" text file.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir normal metin dosyayi \"hacker dil\" metin dosyaya ceviriyor.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"leetstr",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Shows a \"hacker language\" version of a sentence or word you give it. Specify text.",

"Text:",
"Parameter 2:",

"Bir \"hacker dili\" versiyonu gosterir verdigin kelime veya cumle ile. Teksti belirt.",

"Tekst:",
"Parametre 2:",

},

{
"length",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Convert between the most popular length formats:\n"
"mm, cm, inches, meters, feet, yards, km, miles.",

"Parameter 1:",
"Parameter 2:",

"En populer uzunluguk tipler arasinda cevirme yap:\n"
"mm, cm, inc, metre, fit, yarda, km, mil.",

"Parametre 1:",
"Parametre 2:"                             


},

{
"lensortl",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Sort lines in a text file by length, longest first.",

"Parameter 1:",
"Parameter 2:",

"Bir metin dosyanin uzunluguna gore satirlari siraliyor, en uzunlari bastan.",

"Parametre 1:",
"Parametre 2:"                             
  
},

{
"lensorts",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Sort lines in a text file by length, shortest first.",

"Parameter 1:",
"Parameter 2:",

"Bir metin dosyanin uzunluguna gore satirlari siraliyor, en kisalari bastan.",

"Parametre 1:",
"Parametre 2:"                             
},

{
"license",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Shows the najitool GUI license to the screen.",

"Parameter 1:",
"Parameter 2:",

"Ekrana najitool GUI lisansi gosterir.",

"Parametre 1:",
"Parametre 2:"                             
},

{
"linesnip",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file with the amount of characters\n"
"you specify to be removed from the front of each line.",
"Amount:",
"Parameter 2:",

"Bir dosyayi kopyalarak belirlediginiz miktarda karakterler\n"
"cikartiyor her satirin basindan. Okunan ve yazilan dosyalari,\n"
"ve karakter miktari belirt.",
"Miktar:",
"Parametre 2:"
},

{
"makarray",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a C programming language char *[] array out of a text file\n"
"with each item on a new line. Specify input file, output file, and array name.",

"Array name:",
"Parameter 2:",

"C programlama dilinde bir char *[] array yapar bir metin dosya dan her ogeside\n"
"yeni bir satirda olur. Yazilan ve okunan dosyalari ve array ismini belirt.",
"Array isim:",
"Parametre 2:"


},

{
"mathgame",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"A fun and educational math game.",

"Parameter 1:",
"Parameter 2:",

"eglenceli ve egitici matematik oyunu.",

"Parametre 1:",
"Parametre 2:"                             
},

{
"mergline",
false, // in file 1 but
false, // in file 1 box

false, // in file 2 but
false, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

false, // param 2 label
false, // param 2 box   

"Merges the lines of two files into a new file, at the same line,\n"
"and lets you specify text that comes at the beginning and end of each line.\n"
"Specify input file 1, input file 2, output file, start text, and end text.",

"Start text:",
"End text:",


"Iki metin dosyanin satirlarin ayni sirada birlestiriyor yeni dosyaya,\n"
"ve her satirin basindeki ve sonundeki teksti belirtebilirsiniz.\n"
"Okunan dosya 1, okunan dosya 2, yazilan dosya, bas tekst, ve son tekst belirt.",

"Bas tekst:",
"Son tekst:"
},

{
"mkpatch",
false, // in file 1 but
false, // in file 1 box

false, // in file 2 but
false, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a patch file to be used with qpatch out of differences\n"
"between two files of the same size. Specify input file 1 (original),\n"
"input file 2 (patched), and output file (patch name).",

"Parameter 1:",
"Parameter 2:",

"Bir patch dosyasi yapar qpatch fonksiyonla kulanilmasi icin,\n"
"ayni boyuta olan iki dosyanin farkliliklarindan. Okunan dosya 1 (orijinal),\n"
"okunan dosya 2 (deyistirilmis), ve yazilan dosya (patch'in ismi).",

"Parametre 1:",
"Parametre 2:"                             
},


{
"month",



true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,


"Shows the current month.",

"Parameter 1:",
"Parameter 2:",




"Bu ay hangi ay oldugunu gosterir (Ingilizce).",

"Parametre 1:",
"Parametre 2:"
},


        
{
"mp3split",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

false, // param 2 label
false, // param 2 box   

"Splits a CBR (Constant Bit Rate) MP3 file\n"
"from \"Start\" to \"End\" in seconds range.\n"
"Specify input file and output file.",

"Start:",
"End:",

"Sabit Bit Orani \"CBR (Constant Bit Rate)\" MP3 dosyasini boler,\n"
"saniye araliginda \"Baslangici\" ile \"Sonu\" dan.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Baslangici:",
"Sonu:"
},

{
"mp3taged",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Edit MP3 tag information. Only ID3v1 tags are supported in this version.\n"
"title        - specify song title\n"
"artist       - specify artist\n"
"album        - specify album\n"
"year         - specify year\n"
"comment      - specify comment\n"
"track        - specify track number\n",

"Parameter 1:",
"Parameter 2:",

"MP3 etiket bilgileri deyistir. Sadece ID3v1 etiketleri bu versiyon da destekleniyor.\n"
"basligi     - sarki adi belirt\n"
"sanatci     - sanatci belirt\n"
"album       - album belirt\n"
"yil         - yil belirt\n"
"yorum       - yorum belirt\n"
"parca       - parca numarasini belirt\n",

"Parametre 1:",
"Parametre 2:"


},

{
"mp3tagnf",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Shows MP3 tag information.\n"
"Specify input file.",


"Parameter 1:",
"Parameter 2:",

"MP3 etiket bilgilerini gosterir.\n"
"Okunan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"


},

{
"n2ch",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Converts new lines of UNIX and DOS/Windows text files to specified character.\n"
"Specify input file, output file, and character to change new lines to.",
"Character:",
"Parameter 2:",

"Kopyalarak UNIX ve DOS/Windows metin dosyalarin her satirlarini cevirir belirtigin\n"
"karaktere. Okunan dosyayi, yazilan dosyayi, ve satirlarin deyisicek karakteri belirt.",

"Karakter:",
"Parametre 2:"
},

{
"n2str",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Converts new lines of UNIX and DOS/Windows text files to specified string.\n"
"Specify input file, output file, and string to change new lines to.",
"String:",
"Parameter 2:",

"Kopyalarak UNIX ve DOS/Windows metin dosyalarin her satirlarini cevirir belirtigin\n"
"karakterlere. Okunan dosyayi, yazilan dosyayi, ve satirlarin deyisicek karakterleri\n"
"belirt.",

"Karakterler:",
"Parametre 2:"
},


{
"najcrypt",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"naji interactive encryption/decryption function.",

"Parameter 1:",
"Parameter 2:",

"naji interaktif sifreleme/desifreleme fonksiyonu.",

"Parametre 1:",
"Parametre 2:"
},

{
"naji_bmp",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

false, // out folder but
false, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Generates lots of predefined .BMP file images.",

"Parameter 1:",
"Parameter 2:",

"Bir suru onceden-belirlenmis .BMP dosya goruntuler olusturur.",

"Parametre 1:",
"Parametre 2:"
},

{
"najirle",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"naji RLE (Run-Length Encoding) compression on a single file.\n"
"Works best with files with a lot of repeated characters, such as wave files.",

"Parameter 1:",
"Parameter 2:",

"naji RLE (Run-Length Encoding) tek bir dosyaya kompresyon.\n"
"Bir suru tekrarlanan karakterli dosya icin iyi calisir, mesala .wav ses dosyalar.",

"Parametre 1:",
"Parametre 2:"

},

{
"najisum",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"naji checksum function. Specify input file.",

"Parameter 1:",
"Parameter 2:",

"naji saglama toplami fonksiyonu. Okunan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"numlines",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Add numbers to the beginning of every line, numbers increase with every line.\n"
"Specify input and output file.",

"Parameter 1:",
"Parameter 2:",

"Numaralar ekliyor her satirin basina, numaralar artiyor her satir ile.\n"
"Okunan ve yazilan dosyalari belirt.",

"Parametre 1:",
"Parametre 2:"

},


{
"onlalnum",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file copying only letters and numbers.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalarak sadece harflari ve rakamlari kopyalar.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"onlalpha",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file copying only letters.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalarak sadece harfleri kopyalar.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"onlcntrl",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file copying only control characters.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosya kopyalarak sadece kontrol karakterleri kopyalar.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"onldigit",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file copying only numbers.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalarak sadece numaralari kopyalar.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"onlgraph",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file copying only visible\n"
"printing characters, spaces are not included.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosya kopyalarak sadece gorunur baski karakterleri kopyalar,\n"
"bosluklar dahil degil. Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"


},

{
"onllower",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file copying only lower case letters.\n"
"Specify input file and output file.",


"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalarak sadece kucuk harflari kopyalar.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"onlprint",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file copying only printing\n"
"characters, which includes the space character.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalarak sadece baski karakterleri\n"
"ve bosluk karakteri kopyalar.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"onlpunct",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file copying only punctuation.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalarak sadece noktalamalari kopyalar.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"onlspace",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file copying only whitespace, that is,\n"
"carriage return, newline, form feed, tab, vertical tab, or space.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalarak sadece bosluk kopyalar, mesala,\n"
"satirbasi, satir, form besleme, sekme, dikey sekme veya bosluk.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"onlupper",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file copying only uppercase letters.\n"
"Specify input file and output file.",


"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalarak sadece buyuk harflerli kopyalar.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"onlxdigt",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file copying only\n"
"hexadecimal digits, this includes 0-9 a-f A-F.\n"
"Specify input file and output file.",


"Parameter 1:",
"Parameter 2:",

"Bir dosya kopyalar sadece onaltilik rakam kopyalar,\n"
"bu 0-9 a-f A-F icerirdir."
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},


{
"onlycat",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Shows the contents of the file you specify to the screen\n"
"using only the characters you specify. Specify input file\n"
"and characters.",

"Characters:",
"Parameter 2:",

"Belirttiginiz dosya'nin icerigini gosterir ekrana\n"
"sadece belirttiginiz karakterler kullanarak.\n"
"Okunan dosya ve karakterleri belirt.",

"Karakterler:",
"Parametre 2:"
},

{
"onlychar",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of the file you specify using only the characters you specify.\n"
"Specify input file and output file and characters.",

"Characters:",
"Parameter 2:",

"Belirlediginiz dosyayi kopyalar sadece belirlediginiz karakterleri kullanarak.\n"
"Okunan ve yazilan dosyalari belirt, ve karakterleri belirt.",

"Karakterler:",
"Parametre 2:"
},

{
"patch",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Manually patch a file in an interactive interface.",

"Parameter 1:",
"Parameter 2:",

"Elle patch yap bir dosyaya interaktif arayuz de.",

"Parametre 1:",
"Parametre 2:"

},

{
"printftx",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a text file into a .c file as printf statements out of every line.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"C programlama dilinde printf ifadeler olarak dosyasi yapar bir metin dosyayi\n"
"kopyalarak her satirindan. Okunan ve yazilan dosyalari belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"putlines",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

false, // param 2 label
false, // param 2 box   
"Makes a copy of the file you specify with text you specify for the beginning\n"
"and end of each line. Specify input file 1, output file, start text, and end text.",

"Start text:",
"End text:",

"Bir dosyayi kopyalar ve her satirin basindeki ve sonundeki teksti belirtebilirsiniz.\n"
"Okunan dosya 1, yazilan dosya, bas tekst, ve son tekst belirt.",

"Bas tekst:",
"Son tekst:"

},

{
"qcrypt",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Encrypts or decrypts a file to a new file, this does both encryption and decryption.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Sifrele veya desifrele bir dosyayi yeni dosya, bu ikisinde yapiyor, sifreleme ve desifreleme.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",


"Parametre 1:",
"Parametre 2:"


},

{
"qpatch",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Patches a file from a patch file, it must be in format:\n"
"offset\n"
"value\n"
"offset\n"
"value\n"
"etc.\n"
"in plain ASCII numbers (0-9). Offset being the place in the file you want\n"
"to patch and value being the new value (a value between 0-255).\n"
"Specify input patch file, and output file to be patched.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi patch'ler patch dosyasinla, formatti boyle olmalidir:\n"
"ofset\n"
"deger\n"
"ofset\n"
"deger\n"
"vb\n"
"normal ASCII numaralara (0-9). Ofset dosyanin patch yapmak istediginiz\n"
"yeri oluyor, ve deger istediginiz yeni degeri oluyor (0-255 arasinda bir deger).\n"
"Okunan patch dosyayi belirt ve patchlenicek yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"randkill",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Changes every character in a file to a random character\n"
"and then deletes it, this is good for secure deletion.\n"
"Specify output file to be deleted.",

"Parameter 1:",
"Parameter 2:",

"Her karakteri bir dosyanin rastgele bir karaktere degistirir\n"
"sonra dosyayi siler, bu guvenli silme icin iyidir.\n"
"Yazilan dosyayi belirt silinmek icin.",

"Parametre 1:",
"Parametre 2:"

},

{
"rbcafter",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of the file with a random binary character after each character.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalarak her karakterden sonra bir rastgele ikilik karakter ekler.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"rbcbefor",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of the file with a random binary character before each character.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalarak her karakterden once bir rastgele ikilik karakter ekler.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},


{
"rcharvar",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   

"Shows every single combination variation of a sentence or word\n"
"starting from the right to the screen. Specify text.",

"Text:",
"Parameter 2:",

"Sag dan baslayarak bir cumle ya da kelimenin\n"
"her bir kombinasyon varyasyon gosterir ekrana.\n"
"Teksti belirt.",

"Tekst:",
"Parametre 2:",   




},

{
"rcvfiles",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

false, // out folder but
false, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes files with every single combination variation of the specified input file\n"
"starting from the end of the specified file. Specify input file and output folder.",

"Parameter 1:",
"Parameter 2:",

"En sondan baslayarak bir dosyaninher bir kombinasyon varyasyon yapar yeni dosyalara.\n"
"Okunan dosya ve yazilan klasor belirt.\n",

"Parametre 1:",
"Parametre 2:",

},


{
"remline",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file removing lines containing a certain word or sentence.\n"
"Specify input file, output file, and text.",

"Text:",
"Parameter 2:",


"Bir dosyayi yapalar ve belirlediginiz kelim veya cumle olan satirler cikatir.\n"
"Okunan dosya, yazilan dosya, ve teksti belirt.",

"Tekst:",
"Parametre 2:"

},

{
"repcat",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Repeats each character in a file the number of times you specify to the screen.\n"
"Specify input file and number of repeats.",

"No. of Repeats:",
"Parameter 2:",


"Bir dosyanin karakterlerini tekrarliyor belirtiginiz kadar ve ekrana gosteriyor.\n"
"Okunan dosya ve kac kere tekralandigini belirt karakterlerin",

"Kac kere:",
"Parametre 2:"


},

{
"repcatpp",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Give it a start value and it repeats each character in a\n"
"file then repeats the next character in the file more amount\n"
"of times than the previous character to the screen.",

"Start No. Reps:",
"Parameter 2:",

"Bir baslangic sayisi ver ve bu tekrarliyor her karakteri dosyada ondan sonra obur\n"
"karakterleri dosyada oncekinden kat daha tekrarliyor ve ekrana gosteriyor.\n"
"Okunan dosyayi belirt ve baslangic sayisi belirt.",

"Baslangic:",
"Parametre 2:",

},

{
"repchar",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Repeats each character in the file you specify the number of times you specify to a new file.\n"
"Specify input file, output file, and number of repeats.",

"No. of Repeats:",
"Parameter 2:",


"Belirtiginiz bir dosyanin karakterlerini tekrarliyor belirtiginiz kadar ve yeni dosyaya\n"
"kaydediyor. Okunan dosya, yazilan, ve kac kere tekralandigini belirt karakterlerin",

"Kac kere:",
"Parametre 2:"
},

{
"repcharp",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Give it a start value and it repeats each character in a\n"
"file then repeats the next character in the file more amount\n"
"of times than the previous character to a new file.",

"Start No. Reps:",
"Parameter 2:",

"Bir baslangic sayisi ver ve bu tekrarliyor her karakteri dosyada ondan sonra obur\n"
"karakterleri dosyada oncekinden kat daha tekrarliyor ve yeni dosyaya kayediyor.\n"
"Okunan ve yazilan dosyayi belirt ve baslangic sayisi belirt.",

"Baslangic:",
"Parametre 2:",
               
},

{
"revcat",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Shows a file reversed to the screen.\n"
"Specify input file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi ekrana tersine cevirilmis gosterir.\n"
"Okunan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"revlines",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Reverses every line of the file you specify to a new file.\n"
"Specify input and output file.",

"Parameter 1:",
"Parameter 2:",

"kopyalarak ters cevirir her satiri belirlediginiz metin dosyanin.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"rmunihtm",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

false, // out folder but
false, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Deletes the files that unihtml generates.\n"
"Specify the folder containing the files.",

"Parameter 1:",
"Parameter 2:",

"unihtml fonksiyonun olusturdugu dosyalari siler.\n"
"Hangi klasor da oldugnu belirt dosyalarin.",

"Parametre 1:",
"Parametre 2:"

},

{
"rndbfile",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   

"Generates a file with random characters from value 0 to 255 at the size you specify.\n"
"Specify output file and filesize.",

"Filesize:",
"Parameter 2:",

"Belirttiginiz boyutta rasgele karakterleri degeri 0-255 arasi bir dosya olusturur.\n"
"Yazilan dosya ve boyutunu belirt.",

"Dosya boyut:",
"Parametre 2:"
},

{
"rndbsout",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   

"Puts random characters from value 0 to 255 to the screen at the size you specify.\n"
"Specify size.",

"Size:",
"Parameter 2:",

"Belirttiginiz boyutta rasgele karakterleri degeri 0-255 arasi ekrana koyar.\n"
"Boyutu belirt.",

"Boyut:",
"Parametre 2:"
},


{
"rndffill",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Changes every character in a file to a random character.\n"
"Specify output file to be edited.",

"Parameter 1:",
"Parameter 2:",

"Her karakteri bir dosyanin rastgele bir karaktere degistirir.\n"
"Yazilan dosyayi belirt deyistirmek icin.",

"Parametre 1:",
"Parametre 2:"

},

{
"rndtfile",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   

"Generates a file with random text characters at the size you specify.\n"
"Useful for generating secure random passwords. Specify output file and filesize.",

"Filesize:",
"Parameter 2:",

"Belirttiginiz boyutta rasgele metin karakterli bir dosya olusturur.\n"
"Guvenli rastgele sifreler olusturmak icin yararli. Yazilan dosya ve boyutunu belirt.",

"Dosya boyut:",
"Parametre 2:"
},



{
"rndtsout",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   

"Puts random text characters to the screen at the size you specify.\n"
"Specify size.",

"Size:",
"Parameter 2:",

"Belirttiginiz boyutta metin karakterler ekrana koyar.\n"
"Boyutu belirt.",

"Boyut:",
"Parametre 2:"

},

{
"rrrchars",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

false, // param 2 label
false, // param 2 box   
"Random range repeat characters.\n"
"Specify input file, output file, min number, and max number.",

"Min num:",
"Max num:",

"Rasgele araligi karakterler tekrarlamasi.\n"
"Okunan dosya, yazilan dosya, en az sayi, ve en fazla sayi.",


"En az:",
"En fazla:"

},

{
"rstrach",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file with random text at the size you specify after each character.\n"
"Specify input file, and output file its filesize.",

"Filesize:",
"Parameter 2:",

"Bir dosyayi kopyalarak her karakterden sonra rastgele metin karakterler ekler\n"
"belirlediginiz boyuta. Okunan dosyayi ve yazilan dosyayi ve boyutunu belirt.",

"Boyut:",
"Parametre 2:"      

},

{
"rstrbch",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   

"Makes a copy of a file with random text at the size you specify before each character.\n"
"Specify input file, and output file its filesize.",

"Filesize:",
"Parameter 2:",

"Bir dosyayi kopyalarak her karakterden once rastgele metin karakterler ekler\n"
"belirlediginiz boyuta. Okunan dosyayi ve yazilan dosyayi ve boyutunu belirt.",

"Boyut:",
"Parametre 2:"      

},

{
"rtcafter",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of the file with a random text character after each character.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalarak her karakterden sonra bir rastgele metin karakter ekler.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"rtcbefor",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of the file with a random text character before each character.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalarak her karakterden once bir rastgele metin karakter ekler.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},


{

"saat"



true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,



"Shows the time.",

"Parameter 1:",
"Parameter 2:",



"Saati gosterir.",

"Parametre 1:",
"Parametre 2:",

 

},


{
"saatarih",



true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,



"Shows the current date and time in Turkish.",

"Parameter 1:",
"Parameter 2:",



"Tarih ve saati Turkce gosterir.",



"Parametre 1:",
"Parametre 2:",


},
 

{
"showline",

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,





"Shows the contents of a line you specify.\n"
"Specify input file.",

"Parameter 1:",
"Parameter 2:",





"Belirlediginiz bir satiri gosterir.\n"
"Okunan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},



{
"skipcat",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Shows the contents of a file to the screen skipping the characters you specify.\n"
"Useful for seeing how a file would look without certain characters\n"
"Specify input file and characters to skip.",

"Chars to skip:",
"Parameter 2:",

"Belirttiginiz karakterleri atlayarak ekrana bir dosyanin icerigini gosterir.\n"
"Bir dosyayi bazi karakterleri olmadan nasil gorunecegini gormek icin kullanisli.\n"
"Okunan dosyayi ve atalancak karakterleri belirt.",

"Karakterler:",
"Parametre 2:"




},

{
"skipchar",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   

"Makes a copy of the file you specify skipping the characters you specify.\n"
"Specify input file, output file, and characters to skip.",

"Chars to skip:",
"Parameter 2:",

"Belirttiginiz bir dosyayi kopyalarak, belirttiginiz karakterleri atlar.\n"
"Okunan dosyayi, yazilan dosyayi, ve atalancak karakterleri belirt.",

"Karakterler:",
"Parametre 2:",

},

{
"skipstr",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file skipping the specified string.\n"
"Specify input and outpuf file, and string to skip.",


"Text to skip:",
"Parameter 2:",

"Belirtilen dizesini (metin teksti) atlayarak bir dosyayi kopyalar.\n"
"Okunan ve yazilan dosyayi belirt, ve atlancak dizeyi (metin teksti).",

"Tekst Atla:",
"Parametre 2:"

},

{
"skpalnum",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file skipping letters and numbers.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalar ve sadece harflari ve rakamlari atlar.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"},

{
"skpalpha",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file skipping letters.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalar ve sadece harfleri atlar.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"skpcntrl",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file skipping control characters.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosya kopyalar ve sadece kontrol karakterleri atlar.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"skpdigit",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file skipping numbers.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalar ve sadece numaralari atlar.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"skpgraph",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file skipping visible\n"
"printing characters, spaces are not included.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosya kopyalarak ve sadece gorunur baski karakterleri atlar,\n"
"bosluklar dahil degil. Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"


},

{
"skplower",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file skipping lower case letters.\n"
"Specify input file and output file.",


"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalar ve sadece kucuk harflari atlar.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"skpprint",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file skipping printing\n"
"characters, which includes the space character.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalar ve sadece baski karakterleri\n"
"ve bosluk karakteri atlar.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"skppunct",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file skipping punctuation.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalar ve sadece noktalamalari atlar.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"skpspace",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file skipping whitespace, that is,\n"
"carriage return, newline, form feed, tab, vertical tab, or space.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalar ve sadece bosluk atlar, mesala,\n"
"satirbasi, satir, form besleme, sekme, dikey sekme veya bosluk.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},
 
{
"skpupper",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file skipping uppercase letters.\n"
"Specify input file and output file.",


"Parameter 1:",
"Parameter 2:",

"Bir dosyayi kopyalar ve sadece buyuk harflerli atlar.\n"
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},
 
{
"skpxdigt",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file skipping\n"
"hexadecimal digits, this includes 0-9 a-f A-F.\n"
"Specify input file and output file.",


"Parameter 1:",
"Parameter 2:",

"Bir dosya atlar sadece onaltilik rakam atlar,\n"
"bu 0-9 a-f A-F icerirdir."
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"strachar",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   

"Makes a copy of a file with the specified text after each character.\n"
"Specify input file and output file and text to be added after every byte.",

"Text:",
"Parameter 2:",

"Bir dosyanin kopyasini yapip her byte den sonra bir belirlediginiz metin tekst koyuyor.\n"
"Okunan dosya ve yazilan dosya ve hangi metin teksti her byte den sonra eklencegeni belirt.",

"Tekst:",
"Parametre 2:"
},

{
"strbchar",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a copy of a file with the specified text before each character.\n"
"Specify input file and output file and text to be added before every byte.",

"Text:",
"Parameter 2:",

"Bir dosyanin kopyasini yapip her byte den once bir belirlediginiz metin tekst koyuyor.\n"
"Okunan dosya ve yazilan dosya ve hangi metin teksti her byte den once eklencegeni belirt.",

"Tekst:",
"Parametre 2:"

},

{
"strbline",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Puts a word or sentence on the beginning of every line.\n"
"Specify input and output file, and specify text.",

"Text:",
"Parameter 2:",

"Her satirin basinda bir kelime ya da cumle koyar.\n"
"Okunan ve yazilan dosyalari belirt ve teksti belirt.",

"Tekst:",
"Parametre 2:"
},

{
"streline",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Puts a word or sentence on the end of every line.\n"
"Specify input and output file, and specify text.",

"Text:",
"Parameter 2:",

"Her satirin sonuna bir kelime ya da cumle koyar.\n"
"Okunan ve yazilan dosyalari belirt ve teksti belirt.",

"Tekst:",
"Parametre 2:"

},

{
"strfile",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

false, // param 2 label
false, // param 2 box   
"Makes a file out of a string (word or sentence) and repeats the\n"
"string in the file that is made the number of times you specify.\n"
"Specify output file, text, and number of times its repeated.",

"No. of reps:",
"Text:",

"Bir dosya yapar bir dize (kelime veya cumle) den ve belirttiginiz\n"
"kadar tekrarlar yapilan dosyada. Yazilan dosyayi, tekst, ve kac kere\n"
"tekrarlandigini belirt.",

"Kac tane:",
"Tekst:"

},

{
"swapfeb",
false, // in file 1 but
false, // in file 1 box

false, // in file 2 but
false, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Swaps every other byte of two files\n"
"Specify input file 1, input file 2, and output file.",

"Parameter 1:",
"Parameter 2:",

"Her diger bytelari takas eder iki dosyanin.\n"
"Okunan dosya 1, okunan dosya 2, ve yazilan dosya belirt.",

"Parametre 1:",
"Parametre 2:"
},

{
"systemdt",

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,



"Shows the current date and time (asctime format).",

"Parameter 1:",
"Parameter 2:",

"Tarih ve saati (asctime biciminde) gosterir.",

"Parametre 1:",
"Parametre 2:"


},
{
"tabspace",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,



"Converts tabs to spaces with the number of spaces for a tab you specify.\n"
"Specify input file and output file and amount of spaces.",

"Spaces:",
"Parameter 2:",


"Dosyayi kopyalayarak Tab'leri bosluklara deyistiriyor,\n"
"belirtigin kadar bosluklar ile her tab icin.\n"
"Okunan ve yazilan dosyayi belirt.",

"Bosluklar:",
"Parametre 2:"
},


{
"telltime",



true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,




"Shows the time.",

"Parameter 1:",
"Parameter 2:",


"Saati gosterir."

"Parametre 1:",
"Parametre 2:",



},

{
"today",



true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,




"Shows what day it is today.",

"Parameter 1:",
"Parameter 2:",



"Bugun hangi gun oldugunu gosterir (Ingilizce).",

"Parametre 1:",
"Parametre 2:"



},
{
"tothe",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   

"Adds the text \" to the\" after every character\n"
"except the last character and displays it to the screen.\n"
"Specify text.",

"Text:",
"Parameter 2:",


"Son karakteri disinda her karakterden \" to the\"\n"
"metini ekler ve ekrana gosterir. Teksti belirt.\n",

"Tekst:",
"Parametre 2:"

},

{

"ttt"



true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,



"A fun Tic-Tac-Toe game with clever AI.\n"
"This game is also called Noughts and Crosses in the UK.",

"Parameter 1:",
"Parameter 2:",


"Eglenceli xo oyunu akili bir yapay zeka ile.\n"
"Bu oyun Tic-Tac-Toe olarak taninmistir Amerika'da ve\n"
"Noughts and Crosses olarak taninmistir Ingiltere'de.",

"Parametre 1:",
"Parametre 2:"
              

},
      
{
"turnum",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a file with a list of numbers in Turkish words from 1 to 9999.\n"
"Specify output file.",

"Parameter 1:",
"Parameter 2:",

"Bir dosya yapiyor 1 den 9999'a kadar numaralarinin listesi Turkce kelime olarak.\n"
"Yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:",

},

{
"txt2html",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Makes a HTML file out of a text file.\n"
"Specify input file and output file",

"Parameter 1:",
"Parameter 2:",


"Bir metin dosya yapiyor bir HTML dosya'dan."
"Okunan dosyayi ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"unihtml",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

false, // out folder but
false, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Generates HTML pages with every possible Unicode letter/symbol.\n"
"Specify output folder.",

"Parameter 1:",
"Parameter 2:",

"Mumkun olabilen her Unicode harf/sembol ile HTML sayfalari olusturur.\n"
"Yazilan klasoru sec/belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"unajirle",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Decompresses a file compressed with najirle.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"najirle kompreslenmis dosyayi dekompresliyor.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"unblanka",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Converts a blanka format file back to its original format.\n"
"Specify input file and output file.",


"Parameter 1:",
"Parameter 2:",

"Bir blanka biciminde ki dosyayi geri donusturur orjinal bicimine.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"


},

{
"unix2dos",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,


"Converts UNIX text files to DOS/Windows format.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",


"UNIX tekst dosyalari DOS/Windows bicimine donusturur.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},



{
"uudecode",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,



"UUDecode a UUEncoded file.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",


"UUDecode'ler bir UUEncode'lenmis dosyayi,\n"
"yani orijinal haline getirir.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"
},


{
"uuencode",

false,
false,

true,
true,

true,
true,

false,
false,

true,
true,

true,
true,

true,
true,

true,
true,

"UUEncode a binary file to be easily sent\n"
"with e-mail or posted on forums, etc. \n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Program gibi ikili dosyayi UUEncode'lar kolaylikla e-posta ile\n"
"gondermek ya da forumlarda yayinlamak icin ve benzeri gibi.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},


{
"vowelwrd",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

false, // param 1 label
false, // param 1 box

true, // param 2 label
true, // param 2 box   
"Puts vowels in between every letter of a word except the first and last letter.\n"
"Specify word.",

"Word:",
"Parameter 2:",

"Ilk ve son harfi disinda bir kelimenin her harfi arasina sesli harfler koyar\n"
"Kelimeyi belirt.",

"Kelime:",
"Parameter 2:"

},


{
"wordline",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Puts the words in sentences in new lines like in a word list.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",


"Bir kelime listesi gibi yeni bir satirlara cumle de ki kelimeleri koyar.\n"
"Okunan ve yazilan dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"wordwrap",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"wraps text to new lines (word wrap), for files that have all the text on one line.\n"
"Specify input file and output file.",

"Parameter 1:",
"Parameter 2:",

"Metin tekst kaydirir (sozcuk kaydirir) yeni satirlara, bu bir satirda\n"
"yazilan cumleli metin dosyalar icin. Okunan ve yazilan dosyalari belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"wrdcount",
false, // in file 1 but
false, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

true, // out file 1 but
true, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Counts the number of words in a text file and displays the number to the screen.\n"
"Specify text input file.",

"Parameter 1:",
"Parameter 2:",

"Bir metin dosyanin kelimelerini sayar ve sayisini ekrana gosterir.\n"
"Okunan metin dosyayi belirt.",

"Parametre 1:",
"Parametre 2:"

},

{
"year",



true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,




"Shows the current year.",

"Parameter 1:",
"Parameter 2:",


"Bu yil hangi yil oldugunu gosterir.",


"Parametre 1:",
"Parametre 2:"
},
 

{
"yil"



true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,

true,
true,




"Shows the current year.",

"Parameter 1:",
"Parameter 2:",



"Bu yil hangi yil oldugunu gosterir.",

"Parametre 1:",
"Parametre 2:",

},


{
"zerokill",
true, // in file 1 but
true, // in file 1 box

true, // in file 2 but
true, // in file 2 box

true, // in folder but
true, // in folder box

false, // out file 1 but
false, // out file 1 box

true, // out file 2 but
true, // out file 2 box

true, // out folder but
true, // out folder box

true, // param 1 label
true, // param 1 box

true, // param 2 label
true, // param 2 box   
"Changes every character in a file to the hexidecimal value 00\n"
"and then deletes it, this is good for secure deletion.\n"
"Specify output file to be deleted.",

"Parameter 1:",
"Parameter 2:",

"Her karakteri bir dosyanin onaltik degeri 00 degistirir\n"
"sonra dosyayi siler, bu guvenli silme icin iyidir.\n"
"Yazilan dosyayi belirt silinmek icin.",

"Parametre 1:",
"Parametre 2:"



}

};
