/*
mech Mod
Author: Subject9x
Date: 11/02/2016
Overview: Hud Layout data for mech 'outlaw'
*/

void() tmk_hud_ini;
/*
"gfx/hud/otl/otl_am.png"
"gfx/hud/otl/otl_en.png"
"gfx/hud/otl/otl_rd.png"
"gfx/hud/otl/otl_sl.png"
"gfx/hud/otl/otl_sp.png"
"gfx/hud/otl/otl_wp.png"
*/
void() tmk_hud_ini={

  local entity oself, tmk_hud, tmk_en, tmk_sh, tmk_pd, tmk_wp;
  tmk_hud = spawn();
  oself = self;
  self = tmk_hud;
  self.classname = "hud";
  self.data_type = DATA_HUD;
  self.data_idx = 2;
  //self.c_mdl = "q3mdl/mechs/notl/mdl_notl_cpt.md3";
  self.drawmask = MASK_ENGINE;
  self.img = "gfx/hud/otl/otl_hd.png";
  
  // energy
  self.en_pnl_img = "gfx/hud/otl/otl_en_2.png";
  self.en_pnl_ofs = '152 12';
  self.en_pnl_aln = self.en_pnl_aln | VIEW_BOT | VIEW_LFT;
  
  //shield
  //outlaw doesn't have a separate shield meter panel
  
  //armor
  self.am_pnl_img = "gfx/hud/otl/otl_am_2.png";
  self.am_pnl_ofs = '48 0';
  self.am_pnl_aln =  self.am_pnl_aln | VIEW_BOT | VIEW_LFT;
  
  //weapons
  self.wp_pnl_img = "gfx/hud/otl/otl_wp_2.png";
  self.wp_pnl_ofs = '180 16';
  self.wp_pnl_aln = self.wp_pnl_aln | VIEW_BOT | VIEW_LFT;
  
  //radar
  self.rd_pnl_img = "gfx/hud/otl/otl_am_2.png";
  self.rd_pnl_ofs = '221 0';
  self.rd_pnl_aln = self.rd_pnl_aln | VIEW_BOT | VIEW_LFT;
  
  tmk_en = spawn();
  self = tmk_en;
    self.classname = "widget";
    self.owner = tmk_hud;
    self.otype = OBJ_METER;
    self.drawsize = '23 76';
    self.margin_ins = '4 8';
    self.axis = self.axis | AXIS_DOWN;
    self.pattern = PAT_BAR;
    self.pos = '0 0 0';
    self.drawcolor1 = '0.18 0.32 0.6';
    self.drawcolor2 = '0.23 0.74 0.84';
    self.drawme = TRUE;
 tmk_hud.wdg_en = tmk_en;
  
  tmk_sh = spawn();
  self = tmk_sh;
    self.classname = "widget";
    self.owner = tmk_hud;
    self.otype = OBJ_METER;
    self.drawsize = '82 16 0';
    self.margin_ins = '12 13';
    self.axis = self.axis | AXIS_LEFT;
    self.pattern = PAT_BAR;
    self.pos = '0 0 0';
    self.drawcolor1 = '0.7 0.11 0.23'; //179,30,60
    self.drawcolor2 = '0.215 0.709 0.29'; //(55,181,74)
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
  tmk_hud.wdg_sh = tmk_sh;
  
  tmk_pd = spawn();
  self = tmk_pd;
    self.classname = "widget";
    self.owner = tmk_hud;
    self.otype = OBJ_METER;
    self.drawsize = '108 20 0';
    self.margin_ins = '15 17 0';
    self.axis = self.axis | AXIS_LEFT;
    self.pattern = PAT_BAR;
    self.pos = '0 0 0';
    self.drawcolor1 = '0.7 0.11 0.23'; //179,30,60
    self.drawcolor2 = '0.215 0.709 0.29'; //(55,181,74)
    self.drawme = TRUE;
    self.align = self.align | VIEW_BOT | VIEW_LFT;
  tmk_hud.wdg_pd = tmk_pd;
  
  tmk_wp = spawn();
  self = tmk_wp;
    self.classname = "widget";
    self.owner = tmk_hud;
    self.otype = OBJ_LIST;
    self.margin_ins = '6 6';
    self.drawcolor1 = '0.7 0.11 0.23';
    self.drawme = TRUE;
    self.align = self.align | VIEW_TOP | VIEW_LFT;
  tmk_hud.wdg_wp = tmk_wp;
  
  self = oself;
  addentity(tmk_hud);
 }