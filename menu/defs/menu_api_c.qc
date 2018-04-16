/*
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
    self.command = "";
    self.rolledover = FALSE;
    self.align = 0;
    self.alpha = 0;
    self.color = '0 0 0';
    self.select_color = '0 0 0';
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
    self.label = "";
    self.isclick = btn_isclick;
    self.draw = render_btn;
    self.flags = 0;
    self.align = 0;
    self.alpha = 1;
    self.color = '1 1 1';
    self.select_color = '1 1 1';
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
  self = this;
  return newBtn;
};

entity(vector org, vector siz, float charlen, void() onchange, float algn, float menu_id, vector clr, vector hclr, float alph, float flgs) inp_textfield={
  local entity newtxt, this;
  this = self;
  newtxt = spawn();
  self = newtxt;
    self.classname = "textfield";
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
  self = this;
  return newtxt;
};

void(entity btn) render_btn={
  local entity this;
  local vector org, sizzle, bclr;
  
  this = self;
  self = btn;
    org = gui_percentToPixelRawVec(self.origin);
    
    sizzle = gui_percentToPixelRawVec(self.size);
    if( (self.flags & UI_FLAG_SIZE_IMG) ){
      sizzle = drawgetimagesize(self.image1);
      sizzle = gui_percentToPixelRawVec( gui_scaleSize(sizzle, VIEW_SCALE) );
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
    
    if(self.image1 != ""){
      drawpic(org, self.image1, sizzle, bclr, self.alpha, 0);
    }
  self = this;
};


void(entity btn) render_btn_txt={
  local entity this;
  local vector org, sizzle, bclr;
  
  this = self;
  self = btn;
    org = gui_percentToPixelRawVec(self.origin);
    
    sizzle = gui_percentToPixelRawVec(self.size);
    if( (self.flags & UI_FLAG_SIZE_IMG) ){
      local float txt_len;
      txt_len = stringwidth(self.label, 0, self.size);
      sizzle_x = txt_len;
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
};

void(entity lbl) render_lbl_text={
  local entity this;
  local vector org, sizzle, bclr;
  
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
    drawstring(org, self.label, self.size, self.color, self.alpha, 0);
  self = this;
};

void(entity lbl) render_lbl_img={
  local entity this;
  local vector org, sizzle, bclr;
  
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
};


void(entity txt) render_textfield={
  local entity this;
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
    local string fname;
    local float flannel;
    fname = strcat("s", ftos(itr), ".sav");
    flannel = fopen(fname, FILE_READ);
    if(flannel != -1){
      local float line_count;
      local string line, save_name, map_name, map_title;
      line_count = 0;
      line = fgets(flannel);
      while (line_count < 20){
        if(line_count == 1){
          map_title = line;
        }
        if(line_count == 19){
          map_name = line;
        }
        line = fgets(flannel);
        line_count = line_count + 1;
      }
      tokenizebyseparator(map_title, "kills");
      map_title = argv(0);
      save_name = strcat("--[", map_name, "]- ", map_title);
      GAME_SAVES[itr] = strzone(fname);
      GAME_SAVES_DRAWNAME[itr] = strzone(save_name);
      fclose(flannel);
    }
    else{
      GAME_SAVES[itr] = strzone("");
      GAME_SAVES_DRAWNAME[itr] = strzone("");
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
    MOUSE_TARGET.isclick(MOUSE_TARGET);
  }
};

/*
  garbage collection on menu transition
*/
void(float menu_id) menu_clear_items={
  MOUSE_TARGET = null_entity;
  local entity widgets;
  widgets = findchainfloat(menuId, menu_id);
  while(widgets){
    local entity next;
    next = widgets.chain;
    remove(widgets);
    widgets = next;
  }
};

float(float keynr) menu_textfilter_validate={
  local float itr, valid;
  valid = FALSE;
  while(itr <= UI_INPUT_FILTER_MAX){
    if( UI_INPUT_FILTER[itr] == keynr ){
      valid = TRUE;
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
  if( menu_textfilter_validate(keynr) ){
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
  UI_INPUT_FILTER[37] = 32;//K_SPACE;
  UI_INPUT_FILTER[38] = 169;//K_KP_MULTIPLY;
  UI_INPUT_FILTER[39] = 170;//K_KP_MINUS;
  UI_INPUT_FILTER[40] = 171;// K_KP_PLUS;
  UI_INPUT_FILTER[41] = 173;//K_KP_EQUALS;
};