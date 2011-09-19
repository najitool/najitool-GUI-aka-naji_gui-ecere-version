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

class tab_database : Tab
{
    text = "Database";
    background = { r = 110, g = 161, b = 180 };
    font = { "Verdana", 8.25f, bold = true };
    size = { 1280, 1024 };
    position = { 8, 16 };

    void OnRedraw(Surface surface)
    {
        ColorKey keys[2] = { {0x6EA1B4, 0.0f}, { white, 1.0f } };
        surface.Gradient(keys, sizeof(keys) / sizeof(ColorKey), 1, vertical, 1, 0, 1280-3, 1024 - 3);
        Update(null);
    }

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