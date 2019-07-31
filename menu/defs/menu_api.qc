/*
  battleMETAL
  author: Peter Roohr
  date: 04/13/2018
  overview: impl of menu_api
*/

// UI fields - referenced
/*
.vector origin;
.vector size;
.float flags;
.string label;
.float selected;
.float menuId;
.string classname;
.string image1;
.string image2;
.float drawme;
.void() predraw;
.void() draw;
.void() onClick;
.void() onRollOver;
.void() onChange; //used in textfield
.string command;
.float rolledover;
.float align;
.float alpha;
.vector color;
.float data_bind;  //used in lists
.float len; //used if needed to track char len of entity.
.string data_text; //short storage, primarly for textfields
.float subid; //sub menu, used sparingly
.size; //assign a pixel-accurate size to the item

UI_FLAG_NOLABEL     = 1;  //don't render label
UI_FLAG_NEW         = 2;  //is new
UI_FLAG_ALIGN       = 4;  //use alignment field
UI_FLAG_NOHIGHLIGHT = 8;  //don't render highlight overlay
UI_FLAG_SIZE_IMG    = 16; //base item size on img1 field
*/

entity() new_ui_elm={
  local entity element, this;
  element = spawn();
  this = self;
  self = element;
    self.label = "";
    self.selected = FALSE;
    self.menuId = -1;
    self.image1 = "";
    self.drawme = TRUE;
    self.command = "";
    self.rolledover = FALSE;
    self.align = 0;
    self.alpha = 0;
    self.color = '0 0 0';
    self.select_color = '0 0 0';
    self.subid = FALSE;
  self = this;
  return element;
};

entity(vector org, vector siz, string lbl, vector clr, float algn, float menu_id, float alph, float flgs) lbl_text={
  local entity elbl, this;
  
  this = self;
  elbl = new_ui_elm();
  self = elbl;
    self.classname = "label";
    self.menuId = menu_id;
    self.origin = org;
    self.size = siz;
    self.label = lbl;
    self.draw = render_lbl_text;
    self.flags = flgs;
    self.align = algn;
    self.alpha = alph;
    self.color = clr;
    self.subid = FALSE;
  self = this;
  
  return elbl;
};
entity(vector org, vector siz, string img1, vector clr, float algn, float menu_id, float alph, float flgs) lbl_img={
  local entity elbl, this;
  
  this = self;
  elbl = new_ui_elm();
  self = elbl;
    self.classname = "label";
    self.menuId = menu_id;
    self.origin = org;
    self.size = siz;
    self.image1 = img1;
    self.draw = render_lbl_img;
    self.flags = flgs;
    self.align = algn;
    self.alpha = alph;
    self.color = clr;
    self.subid = FALSE;
  self = this;
  
  return elbl;
};

entity() btn_new_blank={
  local entity button, this;
  
  this = self;
  button = spawn();
  self = button;
    self.classname = "button";
    self.menuId = -1;
    self.origin = '0 0 0';
    self.rolledover = FALSE;
    self.selected = FALSE;
    self.image1 = "";
    self.drawme = TRUE;
    self.label = "";
    self.isclick = btn_isclick;
    self.draw = render_btn;
    self.flags = 0;
    self.align = 0;
    self.alpha = 1;
    self.color = '1 1 1';
    self.select_color = '1 1 1';
    self.subid = FALSE;
  self = this;
  
  return button;
};

entity(vector org, vector siz, string img1, float algn, float menu_id, void() click, vector clr, vector hclr, float alph, float flgs) btn_img_callback={
  local entity newBtn, this;
  
  newBtn = btn_new_blank();
  this = self;
  self = newBtn;
    self.origin = org;
    self.size = siz;
    self.image1 = img1;
    self.menuId = menu_id;
    self.onClick = click;
    self.flags = flgs;
    self.align = algn;
    self.alpha = alph;
    self.color = clr;
    self.select_color = hclr;
  self = this;
  return newBtn;
};

/*
  Text-only button
  NOTE - IF using Flag UI_FLAG_SIZE_IMG
    then param2 - siz should be font size
*/
entity(vector org, vector siz, string txt, float algn, float menu_id, void() click, vector clr, vector hclr, float alph, float flgs) btn_text_callback={
  local entity newBtn, this;
  
  newBtn = btn_new_blank();
  this = self;
  self = newBtn;
    self.draw = render_btn_txt;
    self.origin = org;
    self.size = siz;
    self.label = txt;
    self.menuId = menu_id;
    self.onClick = click;
    self.flags = flgs;
    self.align = algn;
    self.alpha = alph;
    self.color = clr;
    self.select_color = hclr;
  self = this;
  return newBtn;
};

entity(vector org, vector siz, string img1, float algn, float menu_id, string commd, vector clr, vector hclr, float alph, float flgs) btn_img_command={
  local entity newBtn, this;
  
  newBtn = btn_new_blank();
  this = self;
  self = newBtn;
    self.origin = org;
    self.size = siz;
    self.image1 = img1;
    self.menuId = menu_id;
    self.command = commd;
    self.onClick = btn_onClick_runCommand;
    self.flags = flgs;
    self.align = algn;
    self.alpha = alph;
    self.color = clr;
    self.select_color = hclr;
    self.subid = FALSE;
  self = this;
  return newBtn;
};

entity(vector org, vector siz, float charlen, void() onchange, float algn, float menu_id, vector clr, vector hclr, float alph, float flgs) inp_textfield={
  local entity newtxt, this;
  this = self;
  newtxt = spawn();
  self = newtxt;
    self.classname = "textfield";
    self.drawme = TRUE;
    self.data_text = "";
    self.len = charlen;
    self.rolledover = FALSE;
    self.selected = FALSE;
    self.origin = org;
    self.size = siz;
    self.align = algn;
    self.menuId = menu_id;
    self.color = clr;
    self.select_color = hclr;
    self.alpha = alph;
    self.flags = flgs;
    self.draw = render_textfield;
    self.isclick = txtfld_isclick;
    self.ischange = txtfld_ischange;
    self.onChange = onchange;
    self.subid = FALSE;
  self = this;
  return newtxt;
};

entity(vector org, vector siz, void() onchange, string ini_bind_cmd, float menu_id, vector clr, vector hclr, float alph, float flgs) inp_keybindfield={
  local entity newtxt, this;
  this = self;
  newtxt = inp_textfield(org, siz, 0, onchange, 0, menu_id, clr, hclr, alph, flgs);
  self = newtxt;
    self.classname = "bindfield";
    self.drawme = TRUE;
    self.data_text = strzone(ini_bind_cmd);
    local vector bind;
    bind = menu_keybind_keyfor(self.data_text);
    self.len = bind_x;
    self.label = "";
    self.draw = render_bindfield;
    self.isclick = bindfld_isclick;
    self.ischange = bindfld_ischange;
    self.subid = FALSE;
  self = this;
  return newtxt;
};


void(entity btn) render_btn={
  local entity this;
  local vector org, sizzle, bclr;
  if(btn.drawme){
    this = self;
    self = btn;
      org = gui_percentToPixelRawVec(self.origin);
      
      sizzle = gui_percentToPixelRawVec(self.size);
      if( (self.flags & UI_FLAG_SIZE_IMG) ){
        sizzle = drawgetimagesize(self.image1);
        sizzle = gui_percentToPixelRawVec( gui_scaleSize(sizzle, VIEW_SCALE) );
      }
      
      if(menu_checkMouseInBounds(VIEW_MPOS, org, sizzle)){
        MOUSE_TARGET = self;
        if( self.rolledover == FALSE){ 
          localsound("sound/misc/menu3.wav");
          self.rolledover = TRUE;
        }    
      }
      else{
        if( self.rolledover == TRUE){
          self.rolledover = FALSE;
          MOUSE_TARGET = null_entity;
        }
      }

      bclr = self.color;
      if( !(self.flags & UI_FLAG_NOHIGHLIGHT) ){  
        if(self.rolledover){
          bclr = self.select_color;
        }  
      }
      
      if(self.image1 != ""){
        drawpic(org, self.image1, sizzle, bclr, self.alpha, 0);
      }
    self = this; 
  }
};


void(entity btn) render_btn_txt={
  local entity this;
  local vector org, sizzle, bclr;
  
  if(btn.drawme){
    this = self;
    self = btn;
      org = gui_percentToPixelRawVec(self.origin);
      
      sizzle = gui_percentToPixelRawVec(self.size);
      if( (self.flags & UI_FLAG_SIZE_IMG) ){
        local float txt_len;
        txt_len = stringwidth(self.label, 0, self.size);
        sizzle_x =  self.size_x * txt_len;
        sizzle_y = self.size_y;
        sizzle = gui_percentToPixelRawVec( sizzle );
      }
      
      bclr = self.color;
      if(menu_checkMouseInBounds(VIEW_MPOS, org, sizzle)){
        MOUSE_TARGET = self;
        if( self.rolledover == FALSE){ 
          localsound("sound/misc/menu3.wav");
          self.rolledover = TRUE;
        }    
      }
      else{
        if( self.rolledover == TRUE){
          self.rolledover = FALSE;
          MOUSE_TARGET = null_entity;
        }
      }
      
      if( !(self.flags & UI_FLAG_NOHIGHLIGHT) ){  
        if(self.rolledover){
          bclr = self.select_color;
        }  
      }
      
      drawstring(org, self.label, self.size, bclr, self.alpha, 0);
      
    self = this;
  }
};

void(entity lbl) render_lbl_text={
  local entity this;
  local vector org, sizzle;
  if(lbl.drawme){
    this = self;
    self = lbl;
      org = gui_percentToPixelRawVec(self.origin);
      
      sizzle = gui_percentToPixelRawVec(self.size);
      if( (self.flags & UI_FLAG_SIZE_IMG) ){
        local float txt_len;
        txt_len = stringwidth(self.label, 0, self.size);
        sizzle_x = txt_len;
        sizzle_y = self.size_y;
        sizzle = gui_percentToPixelRawVec( sizzle );
      }
      drawstring(org, self.label, sizzle, self.color, self.alpha, 0);
    self = this;
  }
};

void(entity lbl) render_lbl_img={
  local entity this;
  local vector org, sizzle;
  
  if(lbl.drawme){
    this = self;
    self = lbl;
      org = gui_percentToPixelRawVec(self.origin);
      
      sizzle = gui_percentToPixelRawVec(self.size);
      if( (self.flags & UI_FLAG_SIZE_IMG) ){
        sizzle = drawgetimagesize(self.image1);
        sizzle = gui_percentToPixelRawVec( gui_scaleSize(sizzle, VIEW_SCALE) );
      }

      if(self.image1 != ""){
        drawpic(org, self.image1, sizzle, self.color, self.alpha, 0);
      }
    self = this;
  }
};


void(entity txt) render_textfield={
  local entity this;
  if(txt.drawme){
    this = self;
    self = txt;
      local vector org, sizzle, bclr;
      
      org = gui_percentToPixelRawVec(self.origin);
      sizzle_x = self.size_x * self.len;
      sizzle_y = self.size_y;
      sizzle = gui_percentToPixelRawVec(sizzle);
      
      bclr = self.color;
      if(menu_checkMouseInBounds(VIEW_MPOS, org, sizzle)){
        MOUSE_TARGET = self;
        if( self.rolledover == FALSE){ 
          localsound("sound/misc/menu3.wav");
          self.rolledover = TRUE;
        }    
      }
      else{
        if( self.rolledover == TRUE){
          self.rolledover = FALSE;
          MOUSE_TARGET = null_entity;
        }
      }
      
      if(self.rolledover){
        bclr = self.select_color;
      }
      
      if( (TEXTFIELD_TARGET == self) && (UI_INPUT_ACTIVE) ){
        bclr = CLR_DEF_ARM_THREEQ;
      }

      drawstring(org, self.data_text, self.size, bclr, self.alpha, 0);
    self = this;
  }
};

void(entity txt) render_bindfield={
  local entity this;
  if(txt.drawme){
    this = self;
    self = txt;
      
      self.label = "UNBOUND";
      if(self.len > -1){
        self.label = keynumtostring(self.len);
      }
      
      local vector org, sizzle, bclr;
      org = gui_percentToPixelRawVec(self.origin);
      sizzle_x = stringwidth(self.label, 0, self.size);
      sizzle_y = self.size_y;
      sizzle = gui_percentToPixelRawVec(sizzle);
      
      bclr = self.color;
      if(menu_checkMouseInBounds(VIEW_MPOS, org, sizzle)){
        MOUSE_TARGET = self;
        if( self.rolledover == FALSE){ 
          localsound("sound/misc/menu3.wav");
          self.rolledover = TRUE;
        }    
      }
      else{
        if( self.rolledover == TRUE){
          self.rolledover = FALSE;
          MOUSE_TARGET = null_entity;
        }
      }
      
      if(self.rolledover){
        bclr = self.select_color;
      }
      
      if( (KEYBIND_TARGET == self) && (UI_KEYBIND_ACTIVE) ){
        bclr = CLR_DEF_ARM_THREEQ;
      }

      drawstring(org, self.label, self.size, bclr, self.alpha, 0);
    self = this;
  }
};

void(entity myself) txtfld_ischange={
  local entity this;
  this = self;
  self = myself;
    if(self.onChange){
      self.onChange();
    }
  self = this;
};

void(entity myself) txtfld_isclick={
  local entity this;
  this = self;
  self = myself;
    UI_INPUT_ACTIVE = TRUE;
    TEXTFIELD_TARGET = self;
  self = this;
};

void(entity myself) bindfld_ischange={
  local entity this;
  this = self;
  self = myself;
    if(self.onChange){
      self.onChange();
    }
  self = this;
};

void(entity myself) bindfld_isclick={
  local entity this;
  this = self;
  self = myself;
      UI_KEYBIND_ACTIVE = TRUE;
      KEYBIND_TARGET = self;
  self = this;
};

void(entity myself) btn_isclick={
  local entity this;
  this = self;
  self = myself;
    if(self.onClick){
      self.onClick();
    }
  self = this;
};

void() btn_onClick_runCommand={
  if(self.command){
    cmd(self.command);
  }
};

/*
  loads up to 10 .sav files
  10 = size of GAME_SAVES global
*/
void() menu_scan_saves={
  local float itr;
  itr = 0;
  while(itr < GAME_SAVES_MAX){
    if(GAME_SAVES[itr] != ""){
      strunzone(GAME_SAVES[itr]);
    }
    if(GAME_SAVES_DRAWNAME[itr] != ""){
      strunzone(GAME_SAVES_DRAWNAME[itr]);
    }
    local string fname;
    local float flannel;
    fname = strcat("saves/save_", ftos(itr), ".sav");
    flannel = fopen(fname, FILE_READ);
    if(flannel != -1){
      local float line_count, line_tag;
      local string line, save_name, save_num, map_name, contents;
      line_count = 0;
      contents = fgets(flannel);
      tokenizebyseparator(contents, "{", ",", "}");
      line = fgets(flannel);
      while( (line != "") ){
        if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
          line_tag = tokenizebyseparator(line, "'","'",": ",",");
          if( argv(1) == "save" ){
            save_num = argv(3);
          }
          if( argv(1) == "mission" ){
            map_name = argv(3);
          }
        }
        line = fgets(flannel);
      }
      fclose(flannel);
      save_name = strcat("[SAVE ", save_num,"]  ", map_name);
      GAME_SAVES[itr] = strzone(fname);
      GAME_SAVES_DRAWNAME[itr] = strzone(save_name);
    }
    else{
      GAME_SAVES[itr] = strzone(" ");
      GAME_SAVES_DRAWNAME[itr] = strzone("- NEW SAVE SLOT -");
    }
    itr = itr + 1;
  }
};

/*
  mouse bounds check - 
*/
float(vector mpos, vector org, vector sz) menu_checkMouseInBounds={

  local vector asz;
  asz = org + sz;
  if( ( (mpos_x > org_x) && (mpos_x < asz_x) ) && ( (mpos_y > org_y) && (mpos_y < asz_y) ) ){
    return TRUE;
  }
  return FALSE;
};

/*
  calculates the screen-area of a list, determines if the mouse is within the bounds of one of these
  and returns the index number of the item if any'
*/
float(vector org, vector mpos, vector list_size, vector row_size, float max_items, float space) listListener={
  if(menu_checkMouseInBounds(VIEW_MPOS, org, list_size)){
    local float lst_idx, toSender;
    lst_idx = 1;
    toSender = 0;
    while(lst_idx <= max_items){
      local vector lofs;
      local float chk;
      lofs_x = org_x;
      lofs_y = org_y + (lst_idx * row_size_y);
      chk = menu_checkMouseInBounds(VIEW_MPOS, lofs, row_size);
      //drawline doesnt work in-menu
      //gui_DrawRect(lofs, gui_percentToPixel(row_size_x, row_size_y), '0 0 0', '1 1 1');
      if(chk){
        //gui_DrawRect(lofs, lofs + row_size, '2 2', '1 1 1');
        toSender = lst_idx;
      }
      lst_idx = lst_idx + 1;
    }
    return toSender;
  }
  else{
    return 0;
  }
};

/*
  generic 'exit to game/client' func
*/
void() menu_exit_togame={
  DRAW_MOUSE = FALSE;
  M_STATE = M_NONE;
  setkeydest(KEY_GAME);
};

/*
 called by all menus to process widget clicks
*/
void() m_sys_doclick={
  if(MOUSE_TARGET != null_entity){
    localsound("sound/misc/menu1.wav");
    if( !UI_KEYBIND_ACTIVE ){
      MOUSE_TARGET.isclick(MOUSE_TARGET);
    }
    MOUSE_TARGET = null_entity;
  }
};

/*
  garbage collection on menu transition
*/
void(float menu_id) menu_clear_items={
  MOUSE_TARGET = null_entity;
  TEXTFIELD_TARGET = null_entity;
  UI_INPUT_ACTIVE = FALSE;
  SUB_MENU = FALSE;
  local entity widgets;
  widgets = findchainfloat(menuId, menu_id);
  while(widgets){
    local entity next;
    next = widgets.chain;
    remove(widgets);
    widgets = next;
  }
};

float(float keynr, float uiFlags) menu_textfilter_validate={
  local float itr, valid;
  valid = FALSE;
  while(itr <= UI_INPUT_FILTER_MAX){
    if( UI_INPUT_FILTER[itr] == keynr ){
      if( (uiFlags & UI_FLAG_TXTFIELD_NUM) ){
        if( (itr >= 26) && (itr <= 36) ){
          valid = TRUE;
        }
      }
      if( (uiFlags & UI_FLAG_TXTFIELD_SPEC) ){
        if( (itr >= 169) && (itr <= 173) ){
          valid = TRUE;
        }
      }
      if( (uiFlags & UI_FLAG_TXTFIELD_LOW) ){
        if( (itr >= 0) && (itr <= 25) ){
          valid = TRUE;
        }
      }
      if( (uiFlags & UI_FLAG_TXTFIELD_MOUSE) ){
        if( (itr >= 67) && (itr <= 84) ){
          valid = TRUE;
        }
      }
      if( (uiFlags & UI_FLAG_TXTFIELD_FUNC) ){
        if( (itr >= 42) && (itr <= 66) ){
          valid = TRUE;
        }
      }
      if( keynr == K_SPACE ){
        valid = TRUE;
      }
    }
    itr = itr + 1;
  }
  return valid;
};

void(float keynr, float ascii) menu_do_textfield={
  if( (keynr == K_ENTER) || (keynr == K_ESCAPE) ){
    TEXTFIELD_TARGET.ischange(TEXTFIELD_TARGET);
    UI_INPUT_ACTIVE = FALSE;
    return;
  }
  local float txtlen;
  local string txt;
  txtlen = strlen(TEXTFIELD_TARGET.data_text);
  if( (keynr == K_BACKSPACE) ){
    if( txtlen != 0){
      txt = substring(TEXTFIELD_TARGET.data_text, 0, (txtlen - 1) );
      TEXTFIELD_TARGET.data_text = strzone(txt);
    }
    return;
  }
  if( menu_textfilter_validate(keynr, TEXTFIELD_TARGET.flags) ){
    if( txtlen < TEXTFIELD_TARGET.len){
      txt = TEXTFIELD_TARGET.data_text;
      if( keynr == K_SPACE ){
        txt = strcat(txt, " ");
      }
      else{
        txt = strcat(txt, keynumtostring(keynr) );
      }
      TEXTFIELD_TARGET.data_text = strzone(txt);
    } 
  }
};

void(float keynr, float  ascii) menu_do_keybind={
  if( keynr == K_ESCAPE ){
    UI_KEYBIND_ACTIVE = FALSE;
    KEYBIND_TARGET = null_entity;
    return;
  }
  if( menu_textfilter_validate(keynr, KEYBIND_TARGET.flags) ){
    KEYBIND_TARGET.len = keynr;
    local entity this;
    this = self;
    self = KEYBIND_TARGET;
      self.ischange(self);
    self = this;
    UI_KEYBIND_ACTIVE = FALSE;
    KEYBIND_TARGET = null_entity;
  } 
};

vector(string comd) menu_keybind_keyfor={
  local string k1, k2;
  local vector binds;
  tokenize(findkeysforcommand(comd, 0));
  k1 = argv(0);
  k2 = argv(1);
  binds_x = stof(k1);
  binds_y = stof(k2);
  return binds;
};

void(string bind_cmd) menu_keybind_change={
  local vector keybound;
  local entity keybinds;
  
  keybound = menu_keybind_keyfor(bind_cmd);
  
  setkeybind_bindmap(keybound_x, " ", 0);  //unbind desired key first
  setkeybind_bindmap(keybound_y, " ", 0);  //unbind desired key first
  
  strunzone(self.data_text);
  self.data_text = strzone(bind_cmd);
  setkeybind_bindmap(self.len, self.data_text, 0);  //now bind the key
  keybinds = findchainstring(classname, "bindfield");
  while(keybinds){
    if(keybinds != self){
      if( keybinds.len == self.len ){
        strunzone(keybinds.data_text);
        keybinds.data_text = strzone(" ");
        keybinds.len = -1;
      }
    }
    keybinds = keybinds.chain;
  }
};

string(float id) menu_getvideo_clean={
  local vector v;
  local string s;
  v = VID_RESO_SIZE[id];
  s = sprintf("%s x %s", ftos(v_x), ftos(v_y));
  return s;
}

float(vector vsize) menu_getvideo_modeid={
  local float itr, found;
  itr = 1;
  while( itr <= 56){
    if( VID_RESO_SIZE[itr] == vsize ){  
      found = itr;
    }
    itr = itr + 1;
  }
  return found;
};

string(float val) menu_float_bool={
  if(val){
    return "ON";
  }
  return "OFF";
};

/*
  only allow these keys when typing in textfield
  not one of my best moments here...
*/
void() menu_ini_txtfilter={
  //lower case  a - z
  UI_INPUT_FILTER[0] = 97;
  UI_INPUT_FILTER[1] = 98;
  UI_INPUT_FILTER[2] = 99;
  UI_INPUT_FILTER[3] = 100;
  UI_INPUT_FILTER[4] = 101;
  UI_INPUT_FILTER[5] = 102;
  UI_INPUT_FILTER[6] = 103;
  UI_INPUT_FILTER[7] = 104;
  UI_INPUT_FILTER[8] = 105;
  UI_INPUT_FILTER[9] = 106;
  UI_INPUT_FILTER[10] = 107;
  UI_INPUT_FILTER[11] = 108;
  UI_INPUT_FILTER[12] = 109;
  UI_INPUT_FILTER[13] = 110;
  UI_INPUT_FILTER[14] = 111;
  UI_INPUT_FILTER[15] = 112;
  UI_INPUT_FILTER[16] = 113;
  UI_INPUT_FILTER[17] = 114;
  UI_INPUT_FILTER[18] = 115;
  UI_INPUT_FILTER[19] = 116;
  UI_INPUT_FILTER[20] = 117;
  UI_INPUT_FILTER[21] = 118;
  UI_INPUT_FILTER[22] = 119;
  UI_INPUT_FILTER[23] = 120;
  UI_INPUT_FILTER[24] = 121;
  UI_INPUT_FILTER[25] = 122;
  
  //keys 0 - 9
  UI_INPUT_FILTER[26] = 48;
  UI_INPUT_FILTER[27] = 49;
  UI_INPUT_FILTER[28] = 50;
  UI_INPUT_FILTER[29] = 51;
  UI_INPUT_FILTER[30] = 52;
  UI_INPUT_FILTER[31] = 53;
  UI_INPUT_FILTER[32] = 54;
  UI_INPUT_FILTER[33] = 55;
  UI_INPUT_FILTER[34] = 56;
  UI_INPUT_FILTER[35] = 57;
  UI_INPUT_FILTER[36] = 58;
  
  //special keys
  UI_INPUT_FILTER[37] = K_SPACE;//;
  UI_INPUT_FILTER[38] = 169;//K_KP_MULTIPLY;
  UI_INPUT_FILTER[39] = 170;//K_KP_MINUS;
  UI_INPUT_FILTER[40] = 171;// K_KP_PLUS;
  UI_INPUT_FILTER[41] = 173;//K_KP_EQUALS;
  
  //arrow keys
  UI_INPUT_FILTER[42] = K_UPARROW;
  UI_INPUT_FILTER[43] = K_DOWNARROW;
  UI_INPUT_FILTER[44] = K_LEFTARROW;
  UI_INPUT_FILTER[45] = K_RIGHTARROW;
  
  //ctrl
  UI_INPUT_FILTER[46] = K_ALT;
  UI_INPUT_FILTER[47] = K_CTRL;
  UI_INPUT_FILTER[48] = K_SHIFT;
  
  //function keys
  UI_INPUT_FILTER[49] = K_F1;
  UI_INPUT_FILTER[50] = K_F2;
  UI_INPUT_FILTER[51] = K_F3;
  UI_INPUT_FILTER[52] = K_F4;
  UI_INPUT_FILTER[53] = K_F5;
  UI_INPUT_FILTER[54] = K_F6;
  UI_INPUT_FILTER[55] = K_F7;
  UI_INPUT_FILTER[56] = K_F8;
  UI_INPUT_FILTER[57] = K_F9;
  UI_INPUT_FILTER[58] = K_F10;
  UI_INPUT_FILTER[59] = K_F11;
  UI_INPUT_FILTER[60] = K_F12;
  
  //ins - del
  UI_INPUT_FILTER[61] = K_INS;
  UI_INPUT_FILTER[62] = K_DEL;
  UI_INPUT_FILTER[63] = K_PGDN;
  UI_INPUT_FILTER[64] = K_PGUP;
  UI_INPUT_FILTER[65] = K_HOME;
  UI_INPUT_FILTER[66] = K_END;
  
  //mouse input
  UI_INPUT_FILTER[67] = K_MOUSE1;
  UI_INPUT_FILTER[68] = K_MOUSE2;
  UI_INPUT_FILTER[69] = K_MOUSE3;
  UI_INPUT_FILTER[70] = K_MWHEELUP;
  UI_INPUT_FILTER[71] = K_MWHEELDOWN;
  UI_INPUT_FILTER[72] = K_MOUSE4;
  UI_INPUT_FILTER[73] = K_MOUSE5;
  UI_INPUT_FILTER[74] = K_MOUSE6;
  UI_INPUT_FILTER[75] = K_MOUSE7;
  UI_INPUT_FILTER[76] = K_MOUSE8;
  UI_INPUT_FILTER[77] = K_MOUSE9;
  UI_INPUT_FILTER[78] = K_MOUSE10;
  UI_INPUT_FILTER[79] = K_MOUSE11;
  UI_INPUT_FILTER[80] = K_MOUSE12;
  UI_INPUT_FILTER[81] = K_MOUSE13;
  UI_INPUT_FILTER[82] = K_MOUSE14;
  UI_INPUT_FILTER[83] = K_MOUSE15;
  UI_INPUT_FILTER[84] = K_MOUSE16;
};