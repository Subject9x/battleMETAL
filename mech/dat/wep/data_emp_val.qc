/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//EMP CANNON=======================
float DAT_EMP_HPX = 200;

void() data_emp_atk;  //the actual attack call
void() data_emp_think;

void() data_emp_ini={
  self.data_idx = ID_WEP_EMP;
  self.w_name = DAT_EMP_NAME;
  self.w_firetime = 0;
  self.w_clipsize = DAT_EMP_CLIPSIZE;
  self.w_currentammo = 1;
  self.w_fire_ofs = DAT_EMP_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_EMP_MODEL;
  self.w_attack = data_emp_atk;
  self.w_proj = DAT_EMP_PROJ_ID;
  self.rl_cur = DAT_EMP_RL_MAX;
  self.rl_rate = DAT_EMP_RL_RATE;
  self.rl_max = DAT_EMP_RL_MAX;
  self.en_rate = DAT_EMP_EN_RATE;
  self.fire_sound = DAT_EMP_FIRESOUND;
  self.i_techlvl = DAT_EMP_TECH_LEVEL;
  self.i_size = DAT_EMP_WSIZE;
  self.w_think = data_emp_think;
  self.health = DAT_EMP_HPX;
  self.max_health = DAT_EMP_HPX;
  self.p_dmgtype = (DMG_ENE | EFF_STX | EFF_ENE);
  self.w_range = DAT_EMP_RANGE;
  self.w_state = READY;
  self.p_damage = DAT_EMP_DMG;
  self.spreadDefault = DAT_EMP_ACC;
};

void() data_emp_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    if(time > self.w_firetime){
      self.rl_cur = 100;
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

void() data_emp_atk={
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
  range = self.w_range;
  angl = player.v_angle; //set by each AI, due to FL_TURRET
  
  org = util_getOffsetOfVector( player.origin, adj, angl );    //origin for barrel of weapon
  dir = util_applySpreadToTrace( player.v_angle, range, self.spreadDefault, player.accuracy );//becomes 'endpoint' for shot angle

  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_firetime = time + self.rl_max;
    self.rl_cur = 0;
    self.count1 = time;
  }
  else{
    self.w_firetime = time + self.w_firerate;
    self.w_state = RECOIL;
  }
  
  newmis = spawn();
  oself = self;
  self = newmis;
    self.owner = player;
    data_iniProjectile(oself.w_proj);
    self.velocity = normalize(dir - org);
    self.p_dmgtype = oself.p_dmgtype;
    self.p_damage = oself.p_damage;
    self.p_lifetime = time + self.p_lifetime;
    self.w_firetime = time + 0.5;
    self.velocity = self.velocity * self.p_velocity;
    self.angles = vectoangles(self.velocity);
    self.think = data_prj_emp_think;
    self.nextthink = time + 0.01;
    util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
    util_setModel(self.c_model, 0, 0);
    setsize(self, '0 0 0', '0 0 0');
    setorigin(self, org);
  self = oself;
  
  sound (newmis, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_EMP_MUZZLE"), org + v_forward * 3 + v_up * 0.1, normalize( dir - org ) * 4, 1);
};
