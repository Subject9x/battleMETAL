/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//SNUB FIELD GUN ARTILLERY======================
float DAT_SFGA_HPX = 200;

void() data_sfga_atk;
void() data_sfga_think; 

void() data_sfga_ini={
  self.data_idx = ID_WEP_SFGA;
  self.w_name = DAT_SFGA_NAME;
  self.damageType = self.damageType | (DMG_BAL | EFF_ARC);
  self.damageValue = DAT_SFGA_DMG;
  self.w_firetime = 0;
  self.w_clipsize = DAT_SFGA_CLIPSIZE;
  self.w_currentammo = 1;
  self.w_fire_ofs = DAT_SFGA_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_SFGA_MODEL;
  self.w_attack = data_sfga_atk;
  self.w_proj = DAT_SFGA_PROJ_ID;
  self.reloadValue = 1;
  self.reloadRate = DAT_SFGA_RL_RATE;
  self.reloadMax = DAT_SFGA_RL_MAX;
  self.energyRate = DAT_SFGA_EN_RATE;
  self.fire_sound = DAT_SFGA_FIRESOUND;
  self.techLevel = DAT_SFGA_TECH_LEVEL;
  self.i_size = DAT_SFGA_WSIZE;
  self.w_think = data_sfga_think;
  self.health = DAT_SFGA_HPX;
  self.max_health = DAT_SFGA_HPX;
  self.w_range = DAT_SFGA_RANGE;
  self.w_isburst = FALSE;
  self.w_state = READY;
  self.spreadDefault = DAT_SFGA_ACC;
};

void() data_sfga_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    if(time > self.w_firetime){
      self.reloadValue = 100;
      self.w_state = READY;
    }
    else{
      local float delta, lim;
      delta = time - self.count1;
      lim = self.reloadMax;      
      self.reloadValue = (delta / lim) * 100;
    }
  }
};

void() data_sfga_atk={
  local entity player, oself, part;
  local vector dir, org, adj;
  local float range;
  
  player = self.owner;
  range = self.w_range;

  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.reloadValue = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_firetime = time + self.reloadMax;
    self.count1 = time;
  }
  else{
    self.w_firetime = time + self.w_firerate;
    self.w_state = RECOIL;
  }
  
  adj = self.c_ofs + self.w_fire_ofs;
  part = util_getPartFromName(self.partParentId, player);
  makevectors( part.angles );
  org = player.origin + (v_forward * adj_z) + (v_right * adj_x) + (v_up * adj_y);
  dir = util_applySpreadToTrace( player.v_angle, range, self.spreadDefault, player.accuracy );//becomes 'endpoint' for shot angle

  newmis = spawn();
  oself = self;
  self = newmis;
    self.owner = player;
    data_iniProjectile(oself.w_proj);
    self.damageType = oself.damageType;
    self.damageValue = oself.damageValue;
    self.velocity = normalize(dir - org);
    self.velocity = self.velocity * self.p_velocity;
    self.velocity_z = self.velocity_z + 100;
    if( (player.flags & FL_MONSTER) ){
      self.velocity_z = self.velocity_z + 200;  //extra arc for AI attacks
    }
    self.avelocity = '0 0 500';
    util_setCollider(0, SOLID_BBOX, MOVETYPE_BOUNCE);
    util_setModel(self.c_model, 0, 0);
    setsize(self, '0 0 0', '0 0 0');
    setorigin(self, org);
    self.angles = vectoangles(self.velocity);
    self.gravity = 0.50;
  self = oself;
  
  if((player.flags & FL_CLIENT)){
    player.punchangle_x = -2 + crandom() * -6;
    player.punchangle_y = -3 + crandom() * -6;
  }
    
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_SFGA_MUZZLE"), org, normalize(dir-org), 1);
};
