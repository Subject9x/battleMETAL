/*
mech Mod
Author: Peter Roohr
Date: 05/06/2018
Overview: Weapon - Air Burst Torpedo
fires a single missile that will explode into bomblets on-contact with enemy target OR timer
but NOT before that
*/
//AIR BURST TORPEDO=======================

void() data_abt_atk;
void() data_abt_think;

void() data_abt_ini={
  self.data_idx = ID_WEP_ABT;
  self.w_name = DAT_ABT_NAME;
  self.w_firetime = 0;
  self.w_clipsize = DAT_ABT_CLIPSIZE;
  self.w_currentammo = DAT_ABT_CLIPSIZE;
  self.w_fire_ofs = DAT_ABT_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_ABT_MODEL;
  self.w_attack = data_abt_atk;
  self.w_proj = DAT_ABT_PROJ_ID;
  self.rl_cur = DAT_ABT_RL_MAX;
  self.rl_rate = DAT_ABT_RL_RATE;
  self.rl_max = DAT_ABT_RL_MAX;
  self.en_rate = DAT_ABT_EN_RATE;
  self.fire_sound = DAT_ABT_FIRESOUND;
  self.i_techlvl = DAT_ABT_TECH_LEVEL;
  self.stat_spr_x = 0;
  self.stat_spr_y = 0;
  self.i_size = DAT_ABT_WSIZE;
  self.w_think = data_abt_think;
  self.health = 1;
  self.max_health = 1;
  self.w_range = DAT_ABT_RANGE;
  self.w_isburst = FALSE;
  self.w_state = READY;
  self.p_dmgtype = self.p_dmgtype | DMG_EXP;
  self.p_damage = DAT_ABT_DMG;
};

void() data_abt_think={
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
      local float delta, max;
      delta = time - self.count1;
      max = self.rl_max;      
      self.rl_cur = (delta / max) * 100;
    }
  }
};

void() data_abt_atk={
  local entity player, proj, oself;
  local vector dir, org, end, adj, angl;
  local float range, convx, convy;
  player = self.owner;

  convx = player.stat_spr_x + self.stat_spr_x;
  convy = player.stat_spr_y + self.stat_spr_y;
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
    end = util_traceForAI( org, angl, self.w_range );
  }
  dir = util_applySpreadToTrace( end, player.v_angle, player.stat_trg_dist, range, convx, convy );//becomes 'endpoint' for shot angle
    
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
  
  newmis = spawn();
  oself = self;
  self = newmis;
    self.owner = player;
    data_iniProjectile(oself.w_proj);
    self.p_dmgtype = oself.p_dmgtype;
    self.p_damage = oself.p_damage;
    util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
    util_setModel(self.c_model, 0, 0);
    setsize(self, '0 0 0', '0 0 0');
    setorigin(self, org);
    self.velocity = normalize(dir - org);
    self.velocity = self.velocity * self.p_velocity;
    self.angles = vectoangles(self.velocity);
    self.think = BecomeExplosion;
    self.nextthink = time + self.p_lifetime;
  self = oself;
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
};