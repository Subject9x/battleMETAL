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
  self.p_dmgtype = self.p_dmgtype | DMG_BAL | EFF_ARC;
  self.p_damage = DAT_SFGA_DMG;
  self.w_firetime = 0;
  self.w_clipsize = DAT_SFGA_CLIPSIZE;
  self.w_currentammo = 1;
  self.w_fire_ofs = DAT_SFGA_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_SFGA_MODEL;
  self.w_attack = data_sfga_atk;
  self.w_proj = DAT_SFGA_PROJ_ID;
  self.rl_cur = 1;
  self.rl_rate = DAT_SFGA_RL_RATE;
  self.rl_max = DAT_SFGA_RL_MAX;
  self.en_rate = DAT_SFGA_EN_RATE;
  self.fire_sound = DAT_SFGA_FIRESOUND;
  self.i_techlvl = DAT_SFGA_TECH_LEVEL;
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
      self.rl_cur = 100;
      self.w_state = READY;
    }
    else{
      local float delta, max;
      delta = time - self.count1;
      max = self.rl_max;      
      self.rl_cur = (delta / max) * 100;
    }
  }
};

void() data_sfga_atk={
  local entity player, proj, oself;
  local vector dir, org, end, adj, angl;
  local float range;
  
  player = self.owner;

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
  
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  newmis = spawn();
  oself = self;
  self = newmis;
    self.owner = player;
    data_iniProjectile(oself.w_proj);
    self.p_dmgtype = oself.p_dmgtype;
    self.p_damage = oself.p_damage;
    self.velocity = normalize(dir - org);
    self.velocity = self.velocity * self.p_velocity;
    self.velocity_z = self.velocity_z + 200;
    if( (player.flags & FL_MONSTER) ){
      self.velocity_z = self.velocity_z + 200;  //extra arc for AI attacks
    }
    self.think = BecomeExplosion;
    self.nextthink = time + self.p_lifetime;
    util_setCollider(0, SOLID_BBOX, MOVETYPE_BOUNCE);
    util_setModel(self.c_model, 0, 0);
    setsize(self, '0 0 0', '0 0 0');
    setorigin(self, org);
    self.angles = vectoangles(self.velocity);
  self = oself;
  if((player.flags & FL_CLIENT)){
    player.punchangle = randomvec();
  }
    
  local entity bul_fx;
  bul_fx = spawn();
  bul_fx.movetype = SOLID_NOT;
  bul_fx.classname = "missile";
  setmodel(bul_fx, "progs/muzzleflash.spr32");
  setsize(bul_fx, '0 0 0', '0 0 0');
  setorigin(bul_fx, self.fx_origin);
  bul_fx.glow_color = 250;
  bul_fx.glow_size = 1;
  bul_fx.glow_trail = TRUE;
  bul_fx.color = '1 0 0';
  bul_fx.think = SUB_Remove;
  bul_fx.nextthink = time + 0.001;// + 0.35;
};
