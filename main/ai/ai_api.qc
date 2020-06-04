/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: 
  Main Impl for AI API
*/

/*
  Go through spawn flags
  Check Game Mode and Difficulty Skill
  remove AI if they're flagged to not be in a category; 
*/
float() ai_can_spawn={  

  if( self.nextVecChoice < 1 ){
    return FALSE;
  }
  
  if( (skill == 0) && (self.spawnflags & NO_NOVICE) ){
    return FALSE;
  }
  if( (skill == 1) && (self.spawnflags & NO_REGULAR) ){
    return FALSE;
  }
  if( (skill == 2) && (self.spawnflags & NO_VETERAN) ){
    return FALSE;
  }
  if( (skill == 3) && (self.spawnflags & NO_ELITE) ){
    return FALSE;
  }
  
  if( (self.spawnflags & NO_CAMPAIGN) ){
    if( cvar("gamemode") == GAMEMODE_CAMPAIGN ){
      return FALSE;
    }
  }
  
  if( (self.spawnflags & NO_COOP) ){
    if( cvar("gamemode") == GAMEMODE_COOP ){
      return FALSE;
    }
  }

  if( (self.spawnflags & NO_DM) ){
    if( cvar("gamemode") == GAMEMODE_DM  ){
      return FALSE;
     }
  }
  
  if( (self.spawnflags & NO_TDM) ){
    if( cvar("gamemode") == GAMEMODE_TEAMDM ){
      return FALSE;
    }
  }

  return TRUE;
};

void( entity t ) ai_call_for_help={
  local float allies;
  local entity ally;
  
  if( time < self.helpTime ){
    return;
  }
  self.helpTime = time + self.helpTimeDelay;
  
  allies = 0;
  ai_sfx_help();
  for(ally=nextent(world); ally != world; ally = nextent(ally)){
    if( !ai_valid_target(ally) ){
      continue;
    }
    if( !(ally.flags & FL_MONSTER) ){
      continue;
    }
    if( (ally.flags & FL_DISARMED) ){
      continue;
    }
    if( ally.faction != self.faction ){
      continue;
    }
    if( vlen( ally.origin - self.origin ) > self.ai_view ){
      continue;
    }
    ai_give_target( ally, t, (self.ai_rank <= ally.ai_rank) );
    allies = allies + 1;
  }
  
  if( allies < self.ai_rank ){
    if( self.th_pain ){
      self.th_pain( t );
    }
  }
}; 

float(entity t) ai_valid_target={  
  if( t != self ){
    if( (t.flags & FL_UNIT) && (t.deadflag == DEAD_NO) ){
      return TRUE;
    }
  }
  return FALSE;
};

entity( float radiius) ai_find_friend={
  local entity ally, friend;
  local float dist, rad;
  
  rad = radiius;
  
  for(ally = findchainfloat(faction,self.faction); ally != world; ally = ally.chain){
    if( !ai_valid_target(ally) ){
      continue;
    }
    dist = vlen( ally.origin - self.origin );
    if( dist > rad ){
      continue;
    }
    rad = dist;
    friend = ally;
  }
  return friend;
};


void( entity t) ai_alert_close={
  
  local entity ally;
  ai_sfx_help();
  for(ally = findradius(self.origin, self.ai_view); ally != world; ally = ally.chain){
    if( ally.faction != self.faction ){
      continue;
    }
    if( !ai_valid_target(ally) ){
      continue;
    }
    ai_give_target( ally, t, (self.ai_rank >= ally.ai_rank) );
  }
};

/*
  ai_find_friend() but we look for the friend furthest away.
*/
entity( float startSmallRadius ) ai_find_friend_farthest={
  local entity ally, friend;
  local float dist, rad;
  
  rad = startSmallRadius;

  for(ally=findchainfloat(faction, self.faction); ally != world; ally = ally.chain){
    if( !ai_valid_target(ally) ){
      continue;
    }
    //oh and the potential friend needs to offer something in protection.
    if( (ally.flags & FL_DISARMED) ){
      continue;
    }
    dist = vlen( ally.origin - self.origin );
    if( dist < rad ){
      continue;
    }
    rad = dist;
    friend = ally;
  }
  return friend;
};

float() ai_find_target_visual={
  local entity targ, found;
  local entity ally; 
  local float rng, fog, fogLen, ndist;

  if( ai_valid_target(self.enemy) ){
    return FALSE;
  }
    
  rng =  self.ai_view;
  if( self.fog_alpha ){
    fogLen = self.fog_dist_y - self.fog_dist_x;
    fog = self.fog_alpha * self.fog_density;
    fog = fog * fogLen;
    rng = self.ai_view - fogLen;
    if( rng < AI_RANGE_M ){
      rng = AI_RANGE_M;
    }
    rng = rng + fog;
  }
  selfSensorOrg_x = self.origin_x;
  selfSensorOrg_y = self.origin_y;
  selfSensorOrg_z = 0;
  
  for(targ = findradius(self.origin, rng); targ != world; targ = targ.chain){ 
    
    if( targ.faction == self.faction ){
      continue;
    }
    if( !ai_valid_target(targ) ){
      continue;
    }
    enemySensorOrg_x = targ.origin_x;
    enemySensorOrg_y = targ.origin_y;
    enemySensorOrg_z = 0;
    ndist = vlen(enemySensorOrg - selfSensorOrg);
    if(ndist > rng){
      continue;
    }
    if( ai_check_vis(targ) != VIS_FRAC && ai_check_vis(targ) != VIS_FRN ){
      continue;
    }
    if( (self.flags & FL_TURRET) ){
      if( !ai_check_targ_infront( targ, self.ai_fov, TRUE)){
        continue;
      }
    }
    else{
      if( ai_check_face(targ, self.ai_fov) == FALSE){
        continue;
      }
    }
    rng = ndist;
    found = targ;
  }

  if( found != world ){
    if( (self.flags & FL_DISARMED) ){
      if( self.stat_rdr_mode ){       
        ai_sfx_help();
        ally = ai_find_friend( self.ai_view );
        if( ally ){
          ai_give_target( ally, found, (ally.ai_rank <= self.ai_rank));
        }
      }
      return FALSE;
    }
    else{
      self.enemy = found;
      ai_sfx_spotted();
      return TRUE;
    }
  }
  return FALSE;
};

float() ai_find_target_radar={
  if( ai_valid_target(self.enemy) ){
    return FALSE;
  }
  local entity targ, found;
  local float rng, ndist;
  local entity ally; 
  
  selfSensorOrg_x = self.origin_x;
  selfSensorOrg_y = self.origin_y;
  selfSensorOrg_z = 0;
  
  rng = self.ai_view;
  for(targ = findradius(self.origin, self.ai_view); targ != world; targ = targ.chain){
    if( !ai_valid_target(targ) ){
      continue;
    }
    if( targ.faction == self.faction ){
      continue;
    }
    enemySensorOrg_x = targ.origin_x;
    enemySensorOrg_y = targ.origin_y;
    enemySensorOrg_z = 0;
    ndist = vlen(enemySensorOrg - selfSensorOrg);
    if( ndist > rng ){
      continue;
    }
    if( (targ.flags & FL_CLIENT) && (targ.stat_rdr_mode == FALSE) ){
      if( ndist > (rng / 2) ){
        continue;
      }
    }
    if( (ai_check_vis(targ) != VIS_FRAC) && (ai_check_vis(targ) != VIS_FRN)){
      continue;
    }
    rng = ndist;
    found = targ;
  }
  if( found ){
    if( (self.flags & FL_DISARMED) ){
      if( self.stat_rdr_mode ){       
        ai_sfx_help();
        ally = ai_find_friend( self.ai_view );
        if( ally ){
          ai_give_target( ally, found, (ally.ai_rank <= self.ai_rank));
        }
      }
      return FALSE;
    }
    else{
      self.enemy = found;
      ai_sfx_spotted();
      return TRUE;
    }
  }
  return FALSE;
};

void( entity ally, entity targ, float override ) ai_give_target={
  local entity this;
  local float validTarg;
  
  if( !ally.th_missile ){
    return;
  }
  
  this = self;
  //validTarg = ai_valid_target(ally.enemy);  note: every other func calling this one already involes ai_valid_target()
  //if( validTarg ){
  self = ally;
  //providing clause where ally has no target
  if( override || !ai_valid_target(ally.enemy) ){
    self.enemy = ally.enemy;
    macro_ai_frame(self.th_missile)
    if( (this.enemy.flags & FL_CLIENT) ){
      ai_sfx_roger();
    }
  }
  else{
    if( self.th_react ){
      self.th_react(ally.enemy);
    }
  }
  //}
  self = this;
};

/*
  Main AI attack function, called when AI's self.button0 = 1.
  Runs through AI's weapon list, and finds which are able to be fired, then calls that function.
*/
void() ai_ranged_attack={
  local entity wep_chain, this;
  local float fired;
  local vector diff;

  self.ai_weaponEnergy = 0;
  this = self;
  self.v_angle = self.angles;
  if( (self.flags & FL_TURRET) ){
    //if the AI has a turret, use the turret's angles for Line of Sight offset origins.
    self.v_angle = self.torsoCenter.angles;
    diff = vectoangles( self.enemy.origin - self.cockpit.origin);
    self.v_angle_x = diff_x;
  }
  
  for( wep_chain = self.w_slot; wep_chain.owner == self; wep_chain = wep_chain.w_slot){
    if(self.button0){
      if(wep_chain.w_state != READY){
        continue;
      }
      if( !(self.currentWeaponGroup & wep_chain.w_group) ){
        continue;
      }
      if( ai_attack_blockcheck(wep_chain) ){
        continue;
      }
      if( !ai_check_face(this.enemy, 0.85) ){
        continue;
      }
      self = wep_chain;
        self.w_attack();
        fired = fired + 1;
      self = this;
    }
    else{
      //Weapon has a bust-fire mode, and has been fired at least once, run through the burst.
      if(wep_chain.w_isburst != TRUE){
        continue;
      }
      if(wep_chain.w_state != READY){
        continue;
      }
      self = wep_chain;
        self.w_attack();
      self = this;
    }
  }
  self.currentWeaponGroup = 0;
};

/*
  Don't fire if the weapon's barrel is blocked by things like:
  non-target entity,
  friendlies
*/  
float(entity wep) ai_attack_blockcheck={
  local vector viewpont, vang;

  //ai v_angle already set by ai_ranged_attack
  vang = self.v_angle;
  
  if( self.enemy.data_type == DATA_BLD ){
    viewpont = normalize(self.enemy.hitOffset - wep.origin);
  }
  else{
    viewpont = normalize((self.enemy.origin + '0 0 10') - wep.origin);
  }
  
  makevectors( vang );
  traceline (wep.origin + v_forward * 1, wep.origin + viewpont*wep.w_range, (wep.damageType & EFF_ARC), self);

  if(trace_ent == world){
    return TRUE;
  }
  if(!trace_ent.takedamage){
    return TRUE;
  }
  if( trace_ent.faction == self.faction ){
    return TRUE;
  }
  
  //not sure what this does anymore
  /*if( (viewpont * v_forward) <= 0.99 ){
    return TRUE;
  }*/
  return FALSE;
};

/*
  Only used for RANDOM_START
*/
entity() ai_node_pick_rand={
  local entity anode;
  local float clr, total, pick;
  local string grpid;
  
  if( self.target ){
    anode = find(world, targetname, self.target);
    if( anode && anode.group ){
      grpid = anode.group;
      total = 0;
      clr = 0;
      while( clr <= 128 ){
        AI_NODES[clr] = world;
        clr = clr + 1;
      }
      
      anode = findchain( group, grpid);
      if( anode && (anode.flags & FL_NODE) ){  
        while( anode ){
          AI_NODES[total] = anode;
          total = total + 1;
          anode = anode.chain;
        }
        pick = rint(random() * total );
        anode = AI_NODES[pick];
      }
    }
    else{
      self.spawnflags = self.spawnflags - self.spawnflags & RANDOM_START;
    }
  }
  return anode;
};


/*
  finds a random spot offset from goalentity to move to,
  this alleviates issue of bots traffic jamming at terminal patrol nodes.
*/
entity() ai_goal_offset_node={
  local vector angl;
  local float incr;
  local float tests;
  local float testLen;
  local float checkLen;
  local vector offsetNodeOrg;
  local entity offsetNode;
  angl = self.angles;
  angl_y = anglemod(self.angles_y - 99);
  incr = 33;
  tests = 1;
  checkLen = 250;
  while( tests < 7 ){
    angl_y = anglemod( angl_y + (incr * tests) );
    makevectors(angl);
    traceline(self.origin, self.origin + (v_forward * 200), FALSE, self);
    if( pointcontents(trace_endpos) == 0 || pointcontents(trace_endpos) == CONTENT_WATER){
      testLen = vlen(trace_endpos - self.origin);
      if( testLen < checkLen && testLen > 33 ){
        checkLen = testLen;
        offsetNodeOrg = trace_endpos;
      }
    }
    tests = tests + 1;
  }
  if( checkLen == 250 ){
    return world;
  }
  offsetNode = spawn();
  offsetNode.classname = "ai_node";
  offsetNode.ai_rank = (random() * 50) + (random() * 33);
  setsize(offsetNode, '-16 -16 -32', '16 16 32');
  setorigin(offsetNode, offsetNodeOrg);
  return offsetNode;
};


void(float dst, float grp, float bracket) ai_wep_group_track={
  if( dst <= bracket ){
    self.currentWeaponGroup = self.currentWeaponGroup | grp;
  }
  else{
    self.currentWeaponGroup = self.currentWeaponGroup - self.currentWeaponGroup & grp;
  }
};

/*
  AI checks to see if it has enough energy to fire this weapon in relation
  to the total energy cost of ALL its energy weapons.
*/  
float(entity wep) ai_attack_checkEne={
  if( self.energy >= self.ai_weaponEnergy ){
    return TRUE;
  }
  return FALSE;
};

/*
  AI attempts to hold-off on making an attack until their accuracy is as best as
  it can be
*/
float( float bestAccuracy ) ai_wait_for_shot={
  if( self.accuracy <= bestAccuracy ){
    return TRUE;
  }
  return FALSE;
};

void() ai_lock_on={
  //can only lock-on to enemy units
  if( self.enemy.faction != self.faction ){
    if( util_lockOnChoke(self.enemy.origin) ){
      if( !(self.stat_lck_stt & LOCK_TARG_START) && !(self.stat_lck_stt & LOCK_TARG_HAS) ){
        self.stat_lck_stt = self.stat_lck_stt | LOCK_TARG_START;
        self.power_timer_segment = time;
        if(self.stat_rdr_mode){
          self.lock_timer = time + self.w_firetime;
        }
        else{
          self.lock_timer = time + (self.w_firetime * 2);
        }
      }
      if( time > self.lock_timer ){
        if( !(self.stat_lck_stt & LOCK_TARG_HAS) ){
          self.stat_lck_stt = self.stat_lck_stt - LOCK_TARG_START;
          self.stat_lck_stt = self.stat_lck_stt | LOCK_TARG_HAS;
        }
      }
    }
    else{
      if( (self.stat_lck_stt & LOCK_TARG_START) ){
        self.stat_lck_stt = self.stat_lck_stt - LOCK_TARG_START;
      }
      if( (self.stat_lck_stt & LOCK_TARG_HAS) ){
        self.stat_lck_stt = self.stat_lck_stt - LOCK_TARG_HAS;
      }
      if( (self.enemy.stat_lck_stt & LOCK_PLAYER) ){
        self.enemy.stat_lck_stt = self.enemy.stat_lck_stt - LOCK_PLAYER;
      }
    }
  }
};

//AI MAP FUNCS
/*
  called by any AI unit that needs to spawn onto the map.
  This function delegates HOW the AI should be spawned based on its starting parameters.
  
  if the AI is to be triggered by another object, then postpone full ini into the use() function
  else
  fall-through and create the ai

  now macro_ai_setup - Roohr

float( void() ai_ini ) ai_unit_setup={
  
  self.wait = 1;
  if( self.delay > 0 ){
    //defaults the wait value in case map didnt specify
    self.wait = self.delay;
  }
  if( (!self.nextVecChoice) ){
    //safety check
    self.think = SUB_Remove;
    self.nextthink = time + 0.05;
    return TRUE;
  }
  
  if( (self.spawnflags & TRIGGER_ME) && (self.targetname) ){
    //checking the targetname is mostly for validation
    self.use = ai_unit_make_trigger;
    self.think = ai_ini;
    self.spawnflags = self.spawnflags - (self.spawnflags & TRIGGER_ME);
    return TRUE;
  }
  //fall-through, AI is cleared to happen
  self.use = multi_trigger;
  return FALSE;
};
*/

void() ai_unit_make_trigger={
  self.spawnflags = self.spawnflags - TRIGGER_ME;
  self.use = SUB_Null;  //triggered
  self.think = self.unit_ini;
  self.nextthink = time + self.wait + (random() * 1);
  self.unit_ini = SUB_Null;
  trigger_event( find(world, classname, "player"), self.trigOnSpawn ); //event interface
};

/*
  initialize weapon loadout default IF
  the weapon slot is not overridden -
  ie the map spawn call can override any and all weapon
  choices.
*/
void( float wep1, float wep2, float wep3, float wep4, float wep5, float wep6, float wep7, float wep8, float wep9) ai_ini_weapons={
  if( !self.next_wepn1 ){
    self.next_wepn1 = wep1;
  }
  if( !self.next_wepn2 ){
    self.next_wepn2 = wep2;
  }
  if( !self.next_wepn3 ){
    self.next_wepn3 = wep3;
  }
  if( !self.next_wepn4 ){
    self.next_wepn4 = wep4;
  }
  if( !self.next_wepn5 ){
    self.next_wepn5 = wep5;
  }
  if( !self.next_wepn6 ){
    self.next_wepn6 = wep6;
  }
  if( !self.next_wepn7 ){
    self.next_wepn7 = wep7;
  }
  if( !self.next_wepn8 ){
    self.next_wepn8 = wep8;
  }
  if( !self.next_wepn9 ){
    self.next_wepn9 = wep9;
  }
}; 