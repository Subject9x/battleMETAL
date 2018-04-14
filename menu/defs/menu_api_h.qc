/*
  author: Peter Roohr
  date: 04/13/2018
  overview: header for menu_api
*/

//API GLOBALS
float GAME_SAVES_MAX = 10;
string GAME_SAVES[GAME_SAVES_MAX];
string GAME_SAVES_DRAWNAME[GAME_SAVES_MAX];

//UI ELEMENT FLAGS
float UI_FLAG_NOLABEL     = 1;  //don't render label
float UI_FLAG_NEW         = 2;  //is new
float UI_FLAG_ALIGN       = 4;  //use alignment field
float UI_FLAG_NOHIGHLIGHT = 8;  //don't render highlight overlay
float UI_FLAG_SIZE_IMG    = 16; //base item size on img1 field
float UI_FLAG_CENTER_IMG  = 32; //centers image on widget

// UI fields
.string label;
.float selected;
.float menuId;
.string image1;
.string image2;
.void() predraw;
.void(entity myself) draw;
.void(entity myself) isclick;  //internal, runs when clicked, if onClick() defined, then will execute within
.void() onClick;
.void() onRollOver;
.string command;
.float rolledover;
.float align;
.float alpha;
.vector color;
.vector select_color;
.float data_bind;  //used in lists

//some of this ported over from ui_defs in the client code
float(vector mpos, vector org, vector sz) menu_checkMouseInBounds;
float(vector org, vector mpos, vector list_size, vector row_size, float max_items, float space) listListener;

//new stuff
void() menu_scan_saves;

void() menu_exit_togame;
void(float menu_id) menu_clear_items;

void() render_predraw;
void(entity btn) render_btn;
void(entity btn) render_btn_txt;
void(entity lbl) render_lbl_img;
void(entity lbl) render_lbl_text;

entity() btn_new_blank;
entity() new_ui_elm;
entity(vector org, vector siz, string lbl, vector clr, float algn, float menu_id, float alph, float flgs) lbl_text;
entity(vector org, vector siz, string img1, vector clr, float algn, float menu_id, float alph, float flgs) lbl_img;
entity(vector org, vector siz, string img1, float algn, float menu_id, void() click, vector clr, vector hclr, float alph, float flgs) btn_img_callback;
entity(vector org, vector siz, string txt, float algn, float menu_id, void() click, vector clr, vector hclr, float alph, float flgs) btn_text_callback;
entity(vector org, vector siz, string img1, float algn, float menu_id, string commd, vector clr, vector hclr, float alph, float flgs) btn_img_command;

void() m_sys_doclick; //called by all menus to process widget clicks
void() btn_noclick={};  //simple null function
void(entity myself) btn_isclick;
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

