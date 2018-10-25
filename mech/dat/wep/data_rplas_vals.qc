/*
mech Mod
Author: Peter Roohr
Date: 02/26/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//ROTARY PLASMA CANNON=======================
float DAT_RPLAS_HPX = 150;
float DAT_RPLAS_SHOT = 6;

void() data_rplas_atk;
void() data_rplas_think;

void() data_rplas_ini={
  self.data_idx = ID_WEP_RPC;
  self.w_name = DAT_RPC_NAME;
  self.w_isready = 0;
  self.p_dmgtype = self.p_dmgtype | DMG_BAL | EFF_PRC;
  self.p_damage = DAT_RPLAS_DMG;
  self.w_firetime = 0;
  self.w_clipsize = DAT_RPLAS_CLIPSIZE;
  self.w_currentammo = DAT_RPLAS_CLIPSIZE;
  self.w_fire_ofs = DAT_RPLAS_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_RPLAS_MODEL;
  self.w_attack = data_rplas_atk;
  self.w_proj = DAT_RPLAS_PROJ_ID;
  self.rl_cur = DAT_RPLAS_RL_MAX;
  self.rl_rate = DAT_RPLAS_RL_RATE;
  self.rl_max = DAT_RPLAS_RL_MAX;
  self.en_rate = DAT_RPLAS_EN_RATE;
  self.fire_sound = DAT_RPLAS_FIRESOUND;
  self.i_techlvl = DAT_RPLAS_TECH_LEVEL;
  self.stat_spr_x = DAT_RPLAS_SPR_X;
  self.stat_spr_y = DAT_RPLAS_SPR_Y;
  self.i_size = DAT_RPLAS_WSIZE;
  self.w_think = data_rplas_think;
  self.health = DAT_RPLAS_HPX;
  self.max_health = DAT_RPLAS_HPX;
  self.w_range = DAT_RPLAS_RANGE;
  self.w_isburst = FALSE;
  self.w_state = READY;
};

void() data_rplas_think={
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

void() data_rplas_atk={
  local entity player, proj, oself;
  local vector dir, org, end, adj, angl;
  local float range, convx, convy;
 
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
    if( (player.flags & FL_MONSTER) ){
        self.w_firetime = time + (self.rl_rate / 1.5) * 2;
    }
    else{
        self.w_firetime = time + self.rl_rate / 1.5;
    }
    self.w_state = RECOIL;
    self.w_isburst = TRUE;
  }
 
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);

  local vector sfx;
  //sfx = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
  //sfx would be 'org' value now, right?

  local vector sfx;
  sfx = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
 
  newmis = spawn();
  newmis.solid = SOLID_NOT;
  newmis.classname = "flash";
  newmis.movetype = MOVETYPE_NONE;
  newmis.glow_color = 250;
  newmis.glow_size = 1;
  newmis.glow_trail = TRUE;
  newmis.color = '0 1 0';
  newmis.alpha = 0.5;
  setmodel(newmis, "progs/muzzleflash.spr32");
  setsize(newmis, '0 0 0', '0 0 0');
  setorigin(newmis, sfx);
  newmis.think = SUB_Remove;
  newmis.nextthink = time + 0.1;// + 0.35;

  newmis = spawn();
  oself = self;
  self = newmis;
    self.owner = player;
    data_iniProjectile(oself.w_proj);
    self.think = SUB_Remove;
    self.nextthink = time + self.p_lifetime;
    self.p_dmgtype = oself.p_dmgtype;
    self.p_damage = oself.p_damage;
    util_setModel(self.c_model, 0, 0);
    util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
    setsize(self, '0 0 0', '0 0 0');        
    setorigin(self, org);
    self.velocity = normalize(dir - org);
    self.velocity = self.velocity * self.p_velocity;
    self.angles = vectoangles(self.velocity);
  self = oself;
};
