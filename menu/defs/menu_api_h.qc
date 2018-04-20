/*
  author: Peter Roohr
  date: 04/13/2018
  overview: header for menu_api
*/

//API GLOBALS
float GAME_SAVES_MAX = 10;
string GAME_SAVES[GAME_SAVES_MAX];
string GAME_SAVES_DRAWNAME[GAME_SAVES_MAX];

entity TEXTFIELD_TARGET;
entity KEYBIND_TARGET;
float UI_INPUT_ACTIVE;  //buffer to track textfields
float UI_INPUT_FILTER_MAX = 84;
float UI_INPUT_FILTER[UI_INPUT_FILTER_MAX];  //filter out these chars;
float UI_KEYBIND_ACTIVE;

vector VID_RESO_SIZE[56];
vector VID_RESO_HALF[56];
string VID_RESO_NAME[56];

//UI ELEMENT FLAGS
float UI_FLAG_NOLABEL     = 1;  //don't render label
float UI_FLAG_NEW         = 2;  //is new
float UI_FLAG_ALIGN       = 4;  //use alignment field
float UI_FLAG_NOHIGHLIGHT = 8;  //don't render highlight overlay
float UI_FLAG_SIZE_IMG    = 16; //base item size on img1 field
float UI_FLAG_CENTER_IMG  = 32; //centers image on widget
float UI_FLAG_TXTFIELD_NUM = 64;
float UI_FLAG_TXTFIELD_SPEC = 128;
float UI_FLAG_TXTFIELD_LOW = 256;
float UI_FLAG_TXTFIELD_MOUSE = 512;
float UI_FLAG_TXTFIELD_FUNC = 1024;

// UI fields
.string label;
.float selected;
.float menuId;
.string image1;
.float drawme;
.void() predraw;
.void(entity myself) draw;
.void(entity myself) isclick;  //internal, runs when clicked, if onClick() defined, then will execute within
.void(entity myself) ischange;
.void() onClick;
.void() onRollOver;
.void() onChange;
.string command;
.float rolledover;
.float align;
.float alpha;
.vector color;
.vector select_color;
.float data_bind;  //used in lists
.float len; //used if needed to track char len of entity.
.string data_text;
.float subid; //sub menu, used sparingly

//some of this ported over from ui_defs in the client code
float(vector mpos, vector org, vector sz) menu_checkMouseInBounds;
float(vector org, vector mpos, vector list_size, vector row_size, float max_items, float space) listListener;

//new stuff
void() menu_ini_txtfilter;
void() menu_ini_keyfilter;
void() menu_scan_saves;
void() menu_exit_togame;
void(float menu_id) menu_clear_items;
float(float keynr, float uiFlags) menu_textfilter_validate;
void(float keynr, float ascii) menu_do_textfield;
void(float keynr, float ascii) menu_do_keybind;
void(string bind_cmd) menu_keybind_change;
string(float keynr) menu_keybind_get;
vector(string comd) menu_keybind_keyfor;
float(vector vsize) menu_getvideo_modeid;
string(float id) menu_getvideo_clean;

void() render_predraw;
void(entity btn) render_btn;
void(entity btn) render_btn_txt;
void(entity lbl) render_lbl_img;
void(entity lbl) render_lbl_text;

void(entity txt) render_textfield;
void(entity txt) render_bindfield;

entity() btn_new_blank;
entity() new_ui_elm;
entity(vector org, vector siz, string lbl, vector clr, float algn, float menu_id, float alph, float flgs) lbl_text;
entity(vector org, vector siz, string img1, vector clr, float algn, float menu_id, float alph, float flgs) lbl_img;
entity(vector org, vector siz, string img1, float algn, float menu_id, void() click, vector clr, vector hclr, float alph, float flgs) btn_img_callback;
entity(vector org, vector siz, string txt, float algn, float menu_id, void() click, vector clr, vector hclr, float alph, float flgs) btn_text_callback;
entity(vector org, vector siz, string img1, float algn, float menu_id, string commd, vector clr, vector hclr, float alph, float flgs) btn_img_command;

entity(vector org, vector siz, float charlen, void()  onchange, float algn, float menu_id, vector clr, vector hclr, float alph, float flgs) inp_textfield;
entity(vector org, vector siz, void() onchange, string ini_bind_cmd, float menu_id, vector clr, vector hclr, float alph, float flgs) inp_keybindfield;

void() m_sys_doclick; //called by all menus to process widget clicks
void() btn_noclick={};  //simple null function
void(entity myself) btn_isclick;
void(entity myself) txtfld_isclick;
void(entity myself) txtfld_ischange;

void(entity myself) bindfld_isclick;
void(entity myself) bindfld_ischange;

void() btn_onClick_runCommand;

//clearly super handy
void() dynamic_precache =
{
	local float f;                                      // file handle, basically assigns a number to whatever file is open
	local string ln;                                    // ln = line of the file being read
	f = fopen("data/cache/precache_menu.txt", FILE_READ);        // opens "system/precache.txt" to be read
	if (f != -1)                                        // if f = -1 then the file could not be found
	{ 
		ln = fgets(f); 
		while(ln != "")    
		{ 
			if(strstrofs(ln, ".png",0) != -1)   // this checks if the file extension is .png for a sound file
			{
				precache_pic(ln, 0);
        print(strcat("loaded menu img : ", ln, "\n"));  //DEBUG
			}
			ln = fgets(f);
		} 
	} 
	fclose(f);                                          
};

string(float typ) map_list_getmap ={
	local float f, itr;
	local string ln, found;
  found = "";
  itr = 0;
  f = -1;
  if(typ){
    f = fopen("data/cache/maps_tdm.txt", FILE_READ);
  }
  else{
    f = fopen("data/cache/maps_coop.txt", FILE_READ);
  }
	if (f != -1){ 
		ln = fgets(f); 
		while(ln != ""){ 
			if(strstrofs(ln, "//",0) == -1){
        if(typ){
          if(MAPS_TDM[itr] != ""){
            strunzone(MAPS_TDM[itr]);
          }
          MAPS_TDM[itr] = strzone(ln);
        }
        else{
          if(MAPS_COOP[itr] != ""){
            strunzone(MAPS_COOP[itr]);
          }
          MAPS_COOP[itr] = strzone(ln);
        }
        print(strcat("loaded menu img : ", ln, "\n"));  //DEBUG
			}
      itr = itr + 1;
			ln = fgets(f);
		} 
	} 
	fclose(f);
  return found;
};

/*
  Darkplaces source code hardcodes this, I guess quake doesn't actually
  poll the display device for achievable ratios, so here we are :|
*/
void() menu_ini_display_constants={
  	local float f, itr;
	local string ln, found;
  found = "";
  itr = 0;
  f = fopen("data/cache/precache_resolutions.txt", FILE_READ);
	if (f != -1){ 
		ln = fgets(f); 
		while(ln != ""){ 
			if(strstrofs(ln, "//",0) == -1){
        tokenizebyseparator(ln, ",");
        local vector vsize, vasize;
        vsize_x = stof(argv(1));
        vsize_y = stof(argv(2));
        vsize_z = stof(argv(5));
        vasize_x = stof(argv(3));
        vasize_y = stof(argv(4));
        VID_RESO_SIZE[itr] = vsize;
        VID_RESO_HALF[itr] = vasize;
        VID_RESO_NAME[itr] = strzone(argv(0));
			}
      itr = itr + 1;
			ln = fgets(f);
		} 
	} 
	fclose(f);
};

void(string filename) menu_execute_cvar_list={
  local float f;
	local string ln;
  f = fopen(filename, FILE_READ);
	if (f != -1){
		ln = fgets(f); 
		while(ln != ""){ 
			if(strstrofs(ln, "//",0) == -1){
        tokenizebyseparator(ln, " ");
        cvar_set(argv(0), argv(1));
			}
			ln = fgets(f);
		}
    fclose(f);    
	} 
};