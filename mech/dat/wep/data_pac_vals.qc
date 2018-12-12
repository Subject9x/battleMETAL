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
  self.p_dmgtype = self.p_dmgtype | DMG_ENE | EFF_PRC | EFF_ENE;
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
  self.spreadDefault = DAT_PAC_ACC;
};

void() data_pac_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.rl_cur = 100;
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
    else{
      local float delta, lim;
      delta = time - self.count1;
      lim = self.rl_max;      
      self.rl_cur = (delta / lim) * 100;
    }
  }
};

void() data_pac_atk={
  local entity player, proj, oself;
  local vector dir, org, end, adj, angl;
  local float range;
  player = self.owner;
  
  if( self.w_currentammo ==  self.w_clipsize){
    if(self.en_rate && (player.en_cur >= self.en_rate)){
      player.en_cur = player.en_cur - self.en_rate;
      if(player.en_cur < 0){
        player.en_cur = 0;
      }
    }
    else{
      return;
    }
  }
  
  adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;    //complete offset from player origin
  angl = player.angles;
  range = self.w_range;
  if( (player.flags & FL_MONSTER) ){
    angl = player.v_angle; //set by each AI, due to FL_TURRET
    range = player.ai_minrange;    //convergence / spread works differently for AI
  }
  org = util_getOffsetOfVector( player.origin, adj, angl );    //origin for barrel of weapon
 
  if((player.flags & FL_CLIENT)){
    end = util_traceForPlayer(player, self.w_range);
  }
  else{
    end = util_traceForAI( org, angl, self.w_range, player );
  }
  dir = util_applySpreadToTrace( player.v_angle, range, self.spreadDefault, player.accuracy );//becomes 'endpoint' for shot angle
  
  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.rl_cur = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_firetime = time + self.rl_max;
    self.count1 = time;
  }
  else{
    self.w_firetime = time + self.w_firerate;
    self.w_state = RECOIL;
  }

  local entity laser_org;
  laser_org = spawn();
  laser_org.movetype = MOVETYPE_NONE;
  laser_org.solid = SOLID_NOT;
  laser_org.classname = "missile";
  setsize(laser_org, '0 0 0', '0 0 0');
  makevectors(self.angles);
  setorigin(laser_org, org + (v_forward*DAT_PAC_FIRE_OFS_z));

  t_damage(trace_ent, self, player, self.p_damage, self.p_dmgtype, dir + (v_forward*3), '0 0 0');
  sound (laser_org, CHAN_WEAPON, self.fire_sound, 1, ATTN_NORM); 
  
  te_beam_pac(org, dir);
  
  te_flamejet(dir, '0 25 0', 5);
  te_plasmaburn(dir);
 
  laser_org.think = SUB_Remove;
  laser_org.nextthink = time + 0.011;// + 0.35;
};
