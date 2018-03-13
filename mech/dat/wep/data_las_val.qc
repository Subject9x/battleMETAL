/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//STANDARD LASER=======================
float DAT_LAS_HPX = 200;

void() data_las_atk;
void() data_las_think;

void() data_las_ini={
  self.data_idx = ID_WEP_LAS;
  self.p_dmgtype = self.p_dmgtype | DMG_ENE | EFF_STX;
  self.p_damage = DAT_LAS_DMG;
  self.w_name = DAT_LAS_NAME;
  self.w_firetime = 0;
  self.w_clipsize = DAT_LAS_CLIPSIZE;
  self.w_currentammo = DAT_LAS_CLIPSIZE;
  self.w_fire_ofs = DAT_LAS_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_LAS_MODEL;
  self.w_attack = data_las_atk;
  self.en_rate = DAT_LAS_EN_RATE;
  self.rl_rate = DAT_LAS_RL_RATE;
  self.rl_cur = DAT_LAS_RL_MAX;
  self.rl_max = DAT_LAS_RL_MAX;
  self.fire_sound = DAT_LAS_FIRESOUND;
  self.i_techlvl = DAT_LAS_TECH_LEVEL;
  self.i_size = DAT_LAS_WSIZE;
  self.w_think = data_las_think;
  self.health = DAT_LAS_HPX;
  self.max_health = DAT_LAS_HPX;
  self.w_range = DAT_LAS_RANGE;
  self.w_state = READY;
};

void() data_las_think={  
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    if(self.owner.en_cur > self.en_rate){
      self.owner.en_cur = self.owner.en_cur - self.en_rate;
      self.rl_cur = self.rl_cur + self.rl_rate;
      if(self.rl_cur >= self.rl_max){
        self.rl_cur = self.rl_max;
        self.w_state = READY;
      }
    }
  }
};


void() data_las_atk={
  local entity cam, player, oself, proj;
  local vector spread, dir, org, end, adj;

  player = self.owner;
    
  if((player.flags & FL_CLIENT)){
    end = util_traceForPlayer(player, self.w_range);
  }
  else{
    end = ai_attack_calcSpread(player); 
  }
  dir = util_traceForOffset(player, self, end, player.stat_spr_x + self.stat_spr_x, player.stat_spr_y + self.stat_spr_y);

  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.rl_cur = 0;
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
  setorigin(laser_org, self.fx_origin);
  laser_org.think = SUB_Remove;
  laser_org.nextthink = time + 0.01;// + 0.35;
   
  te_beam_laser(laser_org.origin, dir);
  sound (laser_org, CHAN_WEAPON, self.fire_sound, 1, ATTN_NORM); 
  
  //te_lightning1(laser_org, laser_org.origin, dir);  
  te_flamejet(dir, '0 10 0', 25);

  t_damage(trace_ent, self, player, self.p_damage, DMG_ENE, dir, '0 0 0');
};
