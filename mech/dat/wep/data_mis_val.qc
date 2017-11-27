/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//ROCKET POD=======================
float DAT_MIS_IDX = ID_WEP_MIS;
string DAT_MIS_NAME = "Missile Launcher";
float DAT_MIS_FIRETIME = 0;
float DAT_MIS_CLIPSIZE = 6;
float DAT_MIS_CURRENTAMMO = 6;
float DAT_MIS_FIRERATE = 0.2; //0.3;
float DAT_MIS_RELOADTIME = 8;//1.85;
vector DAT_MIS_FIRE_OFS = '0 0 2';
string DAT_MIS_MODEL = "q3mdl/weapons/w_mis.md3";
float DAT_MIS_PROJ_ID= ID_PRJ_MIS;
float DAT_MIS_EN_COST= 10;
float DAT_MIS_EN_MAX= 800;
string DAT_MIS_SOUND = "sound/weapons/mis_fire.ogg";
float DAT_MIS_TECH_LEVEL = 1;
float DAT_LAS_SPR_X = 10;
float DAT_LAS_SPR_Y = 3; //v0.0.3
float DAT_MIS_WSIZE = 1; //v0.0.3
float DAT_MIS_HPX = 150; //v0.0.3
float DAT_MIS_RANGE = 1000;//v0.0.3

void() data_mis_atk;
void() data_mis_think;

void() data_mis_ini={
  self.data_idx = DAT_MIS_IDX;
  self.w_name = DAT_MIS_NAME;
  self.w_firetime = DAT_MIS_FIRETIME;
  self.w_clipsize = DAT_MIS_CLIPSIZE;
  self.w_currentammo = DAT_MIS_CURRENTAMMO;
  self.w_firerate = DAT_MIS_FIRERATE;
  self.w_fire_ofs = DAT_MIS_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_MIS_MODEL;
  self.w_attack = data_mis_atk;
  self.w_proj = DAT_MIS_PROJ_ID;
  self.en_cur = DAT_MIS_EN_MAX;
  self.en_rate = DAT_MIS_EN_COST;
  self.en_max = DAT_MIS_EN_MAX;
  self.fire_sound = DAT_MIS_SOUND;
  self.i_techlvl = DAT_MIS_TECH_LEVEL;
  self.stat_spr_x = DAT_LAS_SPR_X;
  self.stat_spr_y = DAT_LAS_SPR_Y;
  self.i_size = DAT_MIS_WSIZE;
  self.w_think = data_mis_think;
  self.health = DAT_MIS_HPX;
  self.max_health = DAT_MIS_HPX;
  self.w_range = DAT_MIS_RANGE;
  self.w_isburst = FALSE;
  self.w_state = READY;
};

void() data_mis_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    self.en_cur = self.en_cur + self.en_rate;
    if(self.en_cur >= self.en_max){
      self.w_state = READY;
    }
  }
};

void() data_mis_atk={
  local entity player, proj, cam, oself;
  player = self.owner;
  local vector dir, org, end, adj;

  if((player.flags & FL_CLIENT)){
    end = util_traceForPlayer(player, self.w_range);
  }
  else{
    end = util_traceForAI(player, self.w_range, player.ai_leading);
    if((player.flags & FL_MONSTER)){
      if(end == player.origin){
        player.patience = player.patience + 1;
        return;
      }
    }
  }
  dir = util_traceForOffset(player, self, end, player.stat_spr_x + self.stat_spr_x, player.stat_spr_y + self.stat_spr_y);
  

  
  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.en_cur = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_isburst = FALSE;
  }
  else{
    if((player.flags & FL_MONSTER)){
      self.w_firetime = time + (self.w_firerate/1000);
    }
    else{
      self.w_firetime = time + self.w_firerate;
    }
    self.w_state = RECOIL;
    self.w_isburst = TRUE;
  }
  
  adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;
  makevectors(player.angles);
  org = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
  
  newmis = spawn();
  oself = self;
  self = newmis;
    self.owner = player;
    data_iniProjectile(oself.w_proj);
    util_setModel(self.c_model, 0);
    util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
    util_setBoundBox('0 0 0', '0 0 0');
    self.velocity = normalize(dir - org);
    self.think = BecomeExplosion;
    self.nextthink = time + self.p_lifetime;
    setorigin(self, org);
    self.velocity = self.velocity * self.p_velocity;
    self.angles = vectoangles(self.velocity);
  self = oself;
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
};
