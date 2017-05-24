/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_LATC_IDX = ID_WEP_LATC;
string DAT_LATC_NAME = "Light Autocannon";
float DAT_LATC_DMG = 2; //was 2 - 3/27/2017
float DAT_LATC_FIRETIME = 0;
float DAT_LATC_CLIPSIZE = 1;  //was 3 - 3/27/2017
float DAT_LATC_CURRENTAMMO = 1;  //was 3 - 3/27/2017
float DAT_LATC_FIRERATE = 0.4;//was 0.15; - 5/14/2-017  //was 0.2 - 3/27/2017
float DAT_LATC_RELOADTIME = 0.4;
vector DAT_LATC_FIRE_OFS = '0 0 2';
string DAT_LATC_MODEL = "q3mdl/weapons/w_atc.md3";
float DAT_LATC_PROJ_ID= ID_PRJ_LATC;
float DAT_LATC_EN_COST= -1;
string DAT_LATC_SOUND = "sound/ac5.ogg";
float DAT_LATC_TECH_LEVEL = 1;
float DAT_LATC_SPR_X = 3;
float DAT_LATC_SPR_Y = 2;
float DAT_LATC_WSIZE = 1;
float DAT_LATC_HPX = 30;
float DAT_LATC_RANGE = 1500;

void() data_wep_latc;
void() data_latc_ini;
void() data_latc_atk;
void() data_latc_think; 

void() data_wep_latc={
  local entity oself, latc;
  latc = spawn();
  oself = self;
  self = latc;
    self.classname = "data";
    self.data_idx = DAT_LATC_IDX;
    self.data_type = DATA_WEPN;
    self.unit_ini = data_latc_ini;
    self.w_name = DAT_LATC_NAME;
  self = oself;
};

void() data_latc_ini={
  self.data_idx = DAT_LATC_IDX;
  self.w_name = DAT_LATC_NAME;
  self.w_firetime = DAT_LATC_FIRETIME;
  self.w_clipsize = DAT_LATC_CLIPSIZE;
  self.w_currentammo = DAT_LATC_CURRENTAMMO;
  self.w_firerate = DAT_LATC_FIRERATE;
  self.w_reloadtime = DAT_LATC_RELOADTIME;
  self.w_isready = 0;
  self.w_fire_ofs = DAT_LATC_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_LATC_MODEL;
  self.w_attack = data_latc_atk;
  self.w_proj = DAT_LATC_PROJ_ID;
  self.en_cur = -1;
  self.en_max = DAT_LATC_EN_COST;
  self.fire_sound = DAT_LATC_SOUND;
  self.i_techlvl = DAT_LATC_TECH_LEVEL;
  self.stat_spr_x = DAT_LATC_SPR_X;
  self.stat_spr_y = DAT_LATC_SPR_Y;
  self.i_size = DAT_LATC_WSIZE;
  self.w_think = data_latc_think;
  self.health = DAT_LATC_HPX;
  self.max_health = DAT_LATC_HPX;
  self.w_range = DAT_LATC_RANGE;
};


void() data_latc_think={
  if(time > self.w_firetime){
    if(self.w_currentammo > 0){
      self.w_isready = TRUE;
    }
  }
  else{
    self.w_isready = FALSE;
  }
};

void() data_latc_atk={
  local entity player, proj, cam, oself;
  local vector dir, end, adj; 
  
  player = self.owner;
  
  if((player.flags & FL_CLIENT)){
    end = util_traceForPlayer(player, (player.stat_spr_x + self.stat_spr_x), (player.stat_spr_y+self.stat_spr_y), '1 1 1', self.w_range);
  }
  else{
    local vector spr;
    spr_x = player.stat_spr_x + self.stat_spr_x;
    spr_y = player.stat_spr_y + self.stat_spr_y;
    end = util_traceForAI(player, spr, '1 1 1', self.w_range, 10); 
  }

  dir = util_traceForOffset(player, self, end);
  if((player.flags & FL_MONSTER)){
    if(dir == player.origin){
      player.ai_patience = player.ai_patience + 1;
      return;
    }
  }
  self.w_isready = FALSE;
  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <=0){
    self.w_firetime = time + self.w_reloadtime;
    self.power_timer = self.w_firetime;
    self.w_currentammo = self.w_clipsize;
  }
  else{
    self.w_firetime = time + self.w_firerate;
  }
  
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  te_superspike(dir);
  t_damage(trace_ent, self, player, DAT_LATC_DMG, DMG_BAL, dir + (v_forward*3), '0 0 0');
  
  local entity bul_fx;
  bul_fx = spawn();
  bul_fx.movetype = SOLID_NOT;
  bul_fx.classname = "missile";
  setmodel(bul_fx, "progs/muzzleflash.spr32");
  setsize(bul_fx, '-1 -1 -1', '1 1 1');
  setorigin(bul_fx, self.fx_origin);
  bul_fx.alpha = 0.85;
  bul_fx.glow_color = 250;
  bul_fx.glow_size = 1;
  bul_fx.glow_trail = TRUE;
  bul_fx.color = '1 0 0';
  bul_fx.think = SUB_Remove;
  bul_fx.nextthink = time + 0.001;// + 0.35;
};
