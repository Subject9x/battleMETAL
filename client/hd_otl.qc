/*
mech Mod
Author: Subject9x
Date: 11/02/2016
Overview: Hud Layout data for mech 'outlaw'
*/

void() otl_hud_ini;

void() otl_hud_ini={

  local entity oself, otl_hud, otl_en, otl_sh, otl_pd, otl_wp;
  otl_hud = spawn();
  oself = self;
  self = otl_hud;
  self.classname = "hud";
  self.data_type = DATA_HUD;
  self.data_idx = 1;
  self.drawmask = MASK_ENGINE;
  
  otl_en = spawn();
  self = otl_en;
    self.classname = "widget";
    self.obj_type = OBJ_METER;
    self.drawme = TRUE;
    self.value1 = 0;
    self.drawcolor = '0 0 0';
    self.drawsize = '16 48 0';
    self.actionCallback = hud_renderEnergy;
    setorigin(self, '0 150 0');
  otl_hud.wdg_en = otl_en;
  
  otl_sh = spawn();
  self = otl_sh;
    self.classname = "widget";
    self.obj_type = OBJ_METER;
    self.drawme = TRUE;
    self.value1 = 0;
    self.drawcolor = '0 0 0';
    self.drawsize = '48 16 0';
    self.actionCallback = hud_renderShield;
    setorigin(self, '0 0 0');
  otl_hud.wdg_sh = otl_sh;
  
  otl_pd = spawn();
  self = otl_pd;
    self.classname = "widget";
    self.drawme = TRUE;
    self.value1 = 0;
    self.value2 = 0;
    self.value3 = 0;
    self.value4 = 0;
    self.value5 = 0;
    self.value6 = 0;
    self.actionCallback = hud_renderPaper;
  otl_hud.wdg_pd = otl_pd;
  
  self = oself;
  addentity(otl_hud);
};
