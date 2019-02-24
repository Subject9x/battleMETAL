/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//ROCKET POD=======================
float DAT_MIS_HPX = 150; 

void() data_mis_atk;
void() data_mis_think;

void() data_mis_ini={
  self.data_idx = ID_WEP_MIS;
  self.w_name = DAT_MIS_NAME;
  self.w_firetime = 0;
  self.w_clipsize = DAT_MIS_CLIPSIZE;
  self.w_currentammo = DAT_MIS_CLIPSIZE;
  self.w_fire_ofs = DAT_MIS_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_MIS_MODEL;
  self.w_attack = data_mis_atk;
  self.w_proj = DAT_MIS_PROJ_ID;
  self.rl_cur = DAT_MIS_RL_MAX;
  self.rl_rate = DAT_MIS_RL_RATE;
  self.rl_max = DAT_MIS_RL_MAX;
  self.en_rate = DAT_MIS_EN_RATE;
  self.fire_sound = DAT_MIS_FIRESOUND;
  self.i_techlvl = DAT_MIS_TECH_LEVEL;
  self.i_size = DAT_MIS_WSIZE;
  self.w_think = data_mis_think;
  self.health = DAT_MIS_HPX;
  self.max_health = DAT_MIS_HPX;
  self.w_range = DAT_MIS_RANGE;
  self.w_isburst = FALSE;
  self.w_state = READY;
  self.p_dmgtype = self.p_dmgtype | DMG_EXP;
  self.p_damage = DAT_MIS_DMG;
  self.spreadDefault = DAT_MIS_ACC;
};

void() data_mis_think={
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

void() data_mis_atk={
  local entity player, proj, oself;
  local vector dir, org, end, adj, angl;
  local float range;
  player = self.owner;
  range = self.w_range;
 
  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.rl_cur = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_isburst = FALSE;
    self.w_firetime = time + self.rl_max;
    self.count1 = time;
  }
  else{
    if((player.flags & FL_MONSTER)){
      self.w_firetime = time + (self.rl_rate / 1.5) * 2.25;
    }
    else{
      self.w_firetime = time + self.rl_rate / 1.75;
    }
    self.w_state = RECOIL;
    self.w_isburst = TRUE;
  }
   
  adj = self.c_ofs + self.w_fire_ofs;
  makevectors( player.angles );
  org = player.origin + (v_forward * adj_z) + (v_right * adj_x) + (v_up * adj_y);
  dir = util_applySpreadToTrace( player.v_angle, range, self.spreadDefault, player.accuracy );//becomes 'endpoint' for shot angle
  
  player.punchangle_x = -2 + crandom() * -2;
  player.punchangle_y = -3 + crandom() * -4;
  pointparticles( particleeffectnum("TE_MIS_MUZZLE"), org + (v_forward * 1), normalize( dir - org ), 1);

  newmis = spawn();
  oself = self;
  self = newmis;
    self.owner = player;
    data_iniProjectile(oself.w_proj);
    self.p_dmgtype = oself.p_dmgtype;
    self.p_damage = oself.p_damage;
    self.solid = SOLID_BBOX;
    self.movetype = MOVETYPE_FLYMISSILE;
    util_setModel(self.c_model, 0, 0);
    setsize(self, '0 0 0', '0 0 0');
    setorigin(self, org);
    self.velocity = normalize(dir - org);
    self.velocity = self.velocity * self.p_velocity;
    self.angles = vectoangles(self.velocity);
    self.c_ofs = oself.origin;
    self.p_lifetime = time + self.p_lifetime;
    self.think = data_prj_mis_th;
    self.nextthink = time + 0.01;
  self = oself;
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
};