/*
mech Mod
Author: Peter Roohr
Date: 02/26/2017
Overview: 
*/
//PARTICLE ACCELERATOR CANNON=======================
float DAT_PAC_HPX = 100;

void() data_pac_atk;
void() data_pac_think;

void() data_pac_ini={
  self.data_idx = ID_WEP_PAC;
  self.w_name = DAT_PAC_NAME;
  self.p_damage = DAT_PAC_DMG;
  self.p_dmgtype = self.p_dmgtype | DMG_ENE | EFF_PRC;
  self.w_firetime = 0;
  self.w_clipsize = DAT_PAC_CLIPSIZE;
  self.w_currentammo = DAT_PAC_CLIPSIZE;
  self.w_fire_ofs = DAT_PAC_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_PAC_MODEL;
  self.w_attack = data_pac_atk;
  self.rl_cur = DAT_PAC_RL_MAX;
  self.rl_rate = DAT_PAC_RL_RATE;
  self.rl_max = DAT_PAC_RL_MAX;
  self.en_rate = DAT_PAC_EN_RATE;
  self.fire_sound = DAT_PAC_FIRESOUND;
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
      self.owner.en_cur = self.owner.en_cur - self.en_rate;
      self.rl_cur = self.rl_cur + self.rl_rate;
      if(self.rl_cur >= self.rl_max){
        self.rl_cur = self.rl_max;
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
  makevectors(self.angles);
  self.fx_origin = self.fx_origin + (v_forward*DAT_PAC_FIRE_OFS_z);
  setorigin(laser_org, self.fx_origin);

  t_damage(trace_ent, self, player, self.p_damage, self.p_dmgtype, dir + (v_forward*3), '0 0 0');
  sound (laser_org, CHAN_WEAPON, self.fire_sound, 1, ATTN_NORM); 
  
  te_beam_pac(laser_org.origin, dir);
  
  te_flamejet(dir, '0 25 0', 5);
  te_plasmaburn(dir);
 
  laser_org.think = SUB_Remove;
  laser_org.nextthink = time + 0.011;// + 0.35;
};
