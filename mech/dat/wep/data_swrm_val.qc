/*
mech Mod
Author: Peter Roohr
Date: 01/21/2018
Overview: weapon data file for the Swarm Missile launcher
*/
//Swarm Missile Launcher=======================


float DAT_SWRM_HPX = 150; 

void() data_swrm_atk;
void() data_swrm_think;

void() data_swrm_ini={
  self.data_idx = ID_WEP_SWRM;
  self.w_name = DAT_SWRM_NAME;
  self.w_firetime = 0;
  self.w_clipsize = DAT_SWRM_CLIPSIZE;
  self.w_currentammo = DAT_SWRM_CLIPSIZE;
  self.w_fire_ofs = DAT_SWRM_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_SWRM_MODEL;
  self.w_attack = data_swrm_atk;
  self.w_think = data_swrm_think;
  self.w_proj = DAT_SWRM_PROJ_ID;
  self.rl_cur = DAT_SWRM_RL_MAX;
  self.rl_rate = DAT_SWRM_RL_RATE;
  self.rl_max = DAT_SWRM_RL_MAX;
  self.en_rate = DAT_SWRM_EN_RATE;
  self.fire_sound = DAT_SWRM_FIRESOUND;
  self.i_techlvl = DAT_SWRM_TECH_LEVEL;
  self.i_size = DAT_SWRM_WSIZE;
  self.health = DAT_SWRM_HPX;
  self.max_health = DAT_SWRM_HPX;
  self.w_range = DAT_SWRM_RANGE;
  self.w_isburst = FALSE;
  self.w_state = READY;
  self.p_dmgtype = self.p_dmgtype | DMG_EXP;
  self.p_damage = DAT_SWRM_DMG;
  self.spreadDefault = DAT_SWRM_ACC;
};

void() data_swrm_think={
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

void() data_swrm_atk={
  local entity player, oself, part;
  local vector dir, org, adj;
  local float range, maxtarg;
  
  player = self.owner;
  range = self.w_range; 
  
  if( !player.stat_rdr_mode ){
    //only fires if radar is on
    return;
  }
  
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
    self.w_firetime = time + self.rl_rate + ( random() * 0.1 ); 
    self.w_state = RECOIL;
    self.w_isburst = TRUE;
  }
  
  adj = self.c_ofs + self.w_fire_ofs;
  part = util_getPartFromName(self.c_parent, player);
  makevectors( part.angles );
  org = player.origin + (v_forward * adj_z) + (v_right * adj_x) + (v_up * adj_y);
  dir = util_applySpreadToTrace( player.v_angle, range, self.spreadDefault, player.accuracy );//becomes 'endpoint' for shot angle

  local entity targs;
  maxtarg = 3;
  targs = findradius(player.origin, self.w_range);
  while(targs){
    if( maxtarg > 0 ){
      if( (ai_check_face(targs, 0.7)) && (targs != player) ){
        if( (targs.flags & FL_CLIENT) || (targs.flags & FL_MONSTER) ){
          if( targs.i_faction != player.i_faction){
            if(targs.deadflag == DEAD_NO){
              maxtarg = maxtarg - 1;
              newmis = spawn();
              oself = self;
              self = newmis;
                self.owner = player;
                data_iniProjectile(oself.w_proj);
                util_setCollider(0, SOLID_BBOX, MOVETYPE_BOUNCE);
                util_setModel(self.c_model, 0, 0);
                setsize(self, '0 0 0', '0 0 0');
                self.p_dmgtype = oself.p_dmgtype;
                self.p_damage = oself.p_damage;
                self.enemy = targs;
                self.p_lifetime = time + self.p_lifetime;
                self.touch = data_prj_swrm_touch;
                self.velocity = normalize(targs.origin - org);
                self.velocity = self.velocity * self.p_velocity;
                self.velocity_z = self.velocity_z + 500;
                self.think = data_prj_swrm_think;
                self.nextthink = time + 0.1;
                setorigin(self, org);
                self.angles = vectoangles(self.velocity);
              self = oself;
              sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
              pointparticles( particleeffectnum("TE_SWRM_MUZZLE"), self.origin, normalize( targs.origin - org ), 1);
            }
          }
        }
      }
    }
    targs = targs.chain;
  }
};