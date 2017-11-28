/*
mech Mod
Author: Peter Roohr
Date: 02/26/2017
Overview: 
*/
//LIGHT AUTOCANNON=======================
float DAT_PAC_IDX = ID_WEP_PAC;
string DAT_PAC_NAME = "PAC";
float DAT_PAC_DMG = 200;//v0.0.03
float DAT_PAC_FIRETIME = 0;
float DAT_PAC_CLIPSIZE = 1;
float DAT_PAC_CURRENTAMMO = 1;
float DAT_PAC_FIRERATE = 8;
float DAT_PAC_RELOADTIME = 8;
vector DAT_PAC_FIRE_OFS = '0 0 8';
string DAT_PAC_MODEL = "q3mdl/weapons/w_pac.md3";
float DAT_PAC_EN_COST =  10;
float DAT_PAC_EN_MAX =  800;
string DAT_PAC_SOUND = "sound/weapons/pac_fire.ogg";
float DAT_PAC_TECH_LEVEL = 1;
float DAT_PAC_SPR_X = 0;
float DAT_PAC_SPR_Y = 0;
float DAT_PAC_WSIZE = 2;
float DAT_PAC_HPX = 100; //v0.0.3
float DAT_PAC_RANGE = 1600;//v0.0.3

void() data_pac_atk;
void() data_pac_think;

void() data_pac_ini={
  self.data_idx = DAT_PAC_IDX;
  self.w_name = DAT_PAC_NAME;
  self.p_damage = DAT_PAC_DMG;
  self.p_dmgtype = self.p_dmgtype | DMG_ENE | EFF_PRC;
  self.w_firetime = DAT_PAC_FIRETIME;
  self.w_clipsize = DAT_PAC_CLIPSIZE;
  self.w_currentammo = DAT_PAC_CURRENTAMMO;
  self.w_firerate = DAT_PAC_FIRERATE;
  self.w_fire_ofs = DAT_PAC_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_PAC_MODEL;
  self.w_attack = data_pac_atk;
  self.en_cur = DAT_PAC_EN_MAX;
  self.en_rate = DAT_PAC_EN_COST;
  self.en_max = DAT_PAC_EN_MAX;
  self.fire_sound = DAT_PAC_SOUND;
  self.i_techlvl = DAT_PAC_TECH_LEVEL;
  self.i_size = DAT_PAC_WSIZE;
  self.w_think = data_pac_think;
  self.health = DAT_PAC_HPX;
  self.max_health = DAT_PAC_HPX;
  self.w_range = DAT_PAC_RANGE;
  self.w_isburst = FALSE;
  self.w_state = READY;
};

void() data_pac_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    if(self.owner.en_cur > self.en_rate){
      self.owner.en_cur = self.owner.en_cur - (self.en_rate / 4); //v0.0.3 - was /3
      self.en_cur = self.en_cur + self.en_rate;
      if(self.en_cur >= self.en_max){
        self.w_state = READY;
      }
    }
  }
};

void() data_pac_atk={
  

  local entity cam, player, oself, proj;
  local vector spread;
	local vector dir, end, adj;
  player = self.owner;
  
  if((player.flags & FL_CLIENT)){
    end = util_traceForPlayer(player, self.w_range);
  }
  else{
    end = util_traceForAI(player, self.w_range, player.ai_leading); 
  }
  dir = util_traceForOffset(player, self, end, player.stat_spr_x + self.stat_spr_x, player.stat_spr_y + self.stat_spr_y);
  
  if((player.flags & FL_MONSTER)){
    if(end == player.origin){
      player.patience = player.patience + 1;
      return;
    }
  }
  
  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.en_cur = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
  }
  else{
    self.w_firetime = time + self.w_firerate;
    self.w_state = RECOIL;
  }

  local entity laser_org;
  laser_org = spawn();
  laser_org.movetype = SOLID_NOT;
  laser_org.classname = "missile";
  setsize(laser_org, '0 0 0', '0 0 0');
  makevectors(self.angles);
  self.fx_origin = self.fx_origin + (v_forward*DAT_PAC_FIRE_OFS_z);
  setorigin(laser_org, self.fx_origin);

  t_damage(trace_ent, self, player, self.p_damage, self.p_dmgtype, dir + (v_forward*3), '0 0 0');
  sound (laser_org, CHAN_WEAPON, self.fire_sound, 1, ATTN_NORM); 
  te_beam(laser_org, laser_org.origin, dir); 
  te_flamejet(dir, '0 25 0', 5);
  te_plasmaburn(dir);
 
  laser_org.think = SUB_Remove;
  laser_org.nextthink = time + 0.011;// + 0.35;
};
