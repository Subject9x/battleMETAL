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
.string command;
.float rolledover;
.float align;
.float alpha;
.vector color;
.float data_bind;  //used in lists

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
    self.label = "";
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
      save_name = strcat("--[", map_name, "]- ", map_title, " --");
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
  if(((mpos_x > org_x) && (mpos_x < asz_x)) && ((mpos_y > org_y) && (mpos_y < asz_y))){
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