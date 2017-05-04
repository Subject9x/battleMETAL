/*
mech Mod
Author: Subject9x
Date: 9/6/2016
Overview: header for t_damage class

according to the original source code, there should only be one 
t_damage function and 1 killed function...for some reason, maybe good house keeping?
*/

void(entity trg, entity inflictor, entity attacker, float dmg_amt, float dmg_type, vector dmg_point, vector force) t_damage={
  
  local float canDamage, new_dmg;
  local entity oself, targ_act;
    
  if(!trg.takedamage){
    return;
  }
  
  damage_attacker = attacker;
  
  //add in ignore team damage
  
  if(trg.flags & FL_GODMODE){
    return;
  }
  
  canDamage = TRUE;
  
  if(trg.flags & FL_CLIENT){
    trg.dmg_inflictor = inflictor;
  }

  //calculate hit time and angle
  if(trg.was_hit < time){
    trg.was_hit = time + 1;
  }
  local float hit_ang;
  oself = self;
  self = trg;
    hit_ang = util_checkPointAngle(inflictor);
  self = oself;
  if(hit_ang == 0){
    if(!(trg.hitdir_buffer & STAT_HIT_LF)){
      trg.hitdir_buffer = trg.hitdir_buffer + STAT_HIT_LF;
    }
  }
  else if(hit_ang == 1){
    if(!(trg.hitdir_buffer & STAT_HIT_RT)){
      trg.hitdir_buffer = trg.hitdir_buffer + STAT_HIT_RT;
    }
  }
  else if(hit_ang == 2){
    if(!(trg.hitdir_buffer & STAT_HIT_BK)){
      trg.hitdir_buffer = trg.hitdir_buffer + STAT_HIT_BK;
    }
  }
  
  //check shields
  if(trg.sh_cur >= 0){
    new_dmg = damage_shield(trg, dmg_amt, dmg_type);
  } 
  
  if(trg.sh_cur <= 0){
    trg.sh_cur = 0;
  }
  
  if(new_dmg > 0){
    dmg_amt = new_dmg;
  }
  else{
    te_particlecube(dmg_point + '-1 -1 -1', dmg_point + '1 1 1', '0 0 0', dmg_amt, 150, TRUE, 100);
    return;
  }
  
  te_spark(dmg_point, inflictor.velocity, new_dmg); 
  
  //the special hit-location calculator is only run for P_MECH
  //units
  if(trg.p_class == P_MECH){
    //filter out leg hits
    if(dmg_point_z < (trg.origin_z - 10)){
      trg = trg.e_legs;
    }
    else{
      local float irad;
      irad = vlen(dmg_point - trg.origin);
      targ_act = t_find_part(dmg_point, irad, trg);
      if(targ_act != world){
        if(targ_act.deadflag <= DEAD_NO){
          trg = targ_act;
        }
      }
    }
  }
  
  trg.health = trg.health - dmg_amt;
  
  if(trg.health <= 0){
   if(trg.th_die){
      if(trg.th_die != SUB_Null){
        killed(trg, attacker, dmg_type);
        return;
      }
    }
  }

	if ( (self.flags & FL_MONSTER) && attacker != world){
	// get mad unless of the same class (except for soldiers)
		if (self != attacker && attacker != self.enemy){
			if ( (self.classname != attacker.classname) 
              || (self.classname == "monster_army" ) ){
				if (self.enemy.classname == "player")
					self.oldenemy = self.enemy;
				self.enemy = attacker;
				q_FoundTarget ();
			}
		}
	}
};


/*
  2 jan 2017
  quake c is beyond subtetly - its not worth the effort to really make this 
  code nice. This func brute forces a search for the closest mech component
  when a shot hits the player's main bbox.
  
  many a clever approach was attempted before I sank into exhaustion to use this.
  :(
*/
entity(vector point, float rad, entity trg) t_find_part={
  
  local float cur_dist;
  local entity  cprt, f_wep, toSender;
  cur_dist = rad;
  cprt = trg;
  f_wep = trg;
  while(cprt){
    local float diff;
    if(cprt != trg){
      diff = vlen(point - cprt.origin);
      if(cprt.deadflag <= DEAD_NO){
        if(diff < cur_dist){
          cur_dist = diff;
          toSender = cprt;
        }
      }
    }
    cprt = cprt.c_part;
  }
  //NOTE - perhaps only check for weapons when armor is below a certain threshold?
  f_wep = closestWeapon(trg, point, rad);
  if(f_wep != world){
    if(f_wep != trg){
      local float chk;
      chk = vlen(point - f_wep.origin);
      if(chk < cur_dist){
        local entity part;
        part = util_getPartFromName(f_wep.c_parent, trg);
        if(part.health < (part.max_health / 3)){
          toSender = f_wep;
        }
      }
    }
  }
  return toSender;
};

entity(entity parent, vector org, float start_rad) closestWeapon={
  local float cur_dist;
  local entity wep, toSender;
  cur_dist = start_rad;
  wep = parent;
  while(wep){
    local float diff;
    diff = vlen(wep.origin - org);
    if((wep != parent)){
      if(wep.deadflag <= DEAD_NO){
        if(diff < cur_dist){
          cur_dist = diff;
          toSender = wep;
        }
      }
    }
    wep = wep.w_slot;
  }
  if(wep == world){
    wep = parent;
  }
  return toSender;
};


/*
add game logic here to catch what is 'killed' and adjust that based on logic

*/
void(entity targ, entity attacker, float dmg_type) filter_killed={
  local entity filter;
  filter = targ;
  if(targ.owner.classname == "player"){
    if(targ.owner.p_class == P_MECH){
      if(targ.classname == M_LEGS){
        return;
      }
    }
  }
  killed(filter, attacker, dmg_type);
};

void(entity targ, entity attacker, float dmg_type) killed={
  local entity oself;
  
  oself = self;
  self = targ;
	// I honestly don't care if it shows a strange number,
	// and disabling this means I can check for worse damage
	// in the kill messages etc.
	// infact I've never seen a case where the number shows,
	// always hidden by the score bar stuff.
	// if (self.health < -99)
	//         self.health = -99;              // don't let sbar look bad if a player - not Roohr

  if (self.health < -99)
		self.health = -99;		// don't let sbar look bad if a player
  
	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE){	// doors, triggers, etc
		self.th_die ();
    self = oself;
    return;
	}
  
  self.enemy = attacker;
  
  self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;
  
  if (!self.iscorpse){
		// bump the monster counter
		if (self.flags & FL_MONSTER){
			/*self.enemy = attacker;
			killed_monsters = killed_monsters + 1;
			WriteByte (MSG_ALL, SVC_KILLEDMONSTER);*/
    }
  }
  
  self.doobits = 0;
  
  if((self.classname == MECH_PIECE) && (self.c_name != "weapon")){
    local entity wep;
    wep = self.owner;
    while(wep){
      wep = wep.w_slot;
      if(wep.c_parent == self.c_name){
        if(wep.deadflag <= DEAD_NO){
            killed(wep, attacker, 0);      
        }
      }
    }
  }
  
  if(self.enemy.enemy == self){
    self.enemy.stat_trg_vid = -1;
    self.enemy.stat_trg_sh = -1;
    self.enemy.enemy = world;
  }

  self.th_die();
  
  self = oself;
};

//returns remain damage to be passed on to armor
float(entity targ, float dmg_amt, float dmg_type) damage_shield={
  targ.sh_hit = time + SHIELD_RECHARGE_COOLDOWN;
  float dmg_remainder;
  dmg_remainder = 0;
  if((dmg_type & DMG_BAL)){
    dmg_remainder = shield_vs_bal(targ, dmg_amt, dmg_type);
  }
  else if((dmg_type & DMG_EXP)){
    dmg_remainder = shield_vs_mis(targ, dmg_amt, dmg_type);
  }
  else if((dmg_type & DMG_ENE)){
    dmg_remainder = shield_vs_ene(targ, dmg_amt, dmg_type);
  }

  if(targ.sh_cur < 0){
    targ.sh_cur = 0;
  }
  
  return dmg_remainder;
};


float(entity targ, float dmg_amt, float dmg_type) shield_vs_bal={

  local float remainder, mod;
  if((dmg_type & EFF_PRC)){
    mod = dmg_amt / SHVBAL_EFFPRC_PERCENTAGE;
    targ.sh_cur = targ.sh_cur - mod;
    remainder = dmg_amt - mod;
  }
  else if((dmg_type & EFF_STX)){
    targ.sh_cur = targ.sh_cur - dmg_amt;
    remainder = 0;
  }
  else if((dmg_type & EFF_RAM)){
    mod = dmg_amt * SHVBAL_EFFRAM_PERCENTAGE;
    targ.sh_cur = targ.sh_cur - mod;
    remainder = 0;
  }
  else if((dmg_type & EFF_ENG)){
    mod = dmg_amt;
    targ.en_cur = targ.en_cur - mod;
    remainder = 0;
  }
  else{
    if(dmg_amt >= targ.sh_cur){
      targ.sh_cur = targ.sh_cur - targ.sh_cur;
      remainder = dmg_amt - (targ.sh_cur * SHVBAL_EFFNON_PERCENTAGE);
    }
    else{
      mod = dmg_amt/ SHVBAL_EFFNON_REDUCE;
      targ.sh_cur = targ.sh_cur - mod;
      remainder = 0;
    }
  }
  return remainder;
};

float(entity targ, float dmg_amt, float dmg_type) shield_vs_ene={
  
  local float remainder, mod;
  if((dmg_type & EFF_PRC)){
    mod = dmg_amt / SHVENE_EFFPRC_PERCENTAGE;
    targ.sh_cur = targ.sh_cur - mod;
    remainder = dmg_amt - mod;
  }
  else if((dmg_type & EFF_STX)){
    targ.sh_cur = targ.sh_cur - dmg_amt;
    remainder = 0;
  }
  else if((dmg_type & EFF_RAM)){
    mod = dmg_amt * SHVENE_EFFRAM_PERCENTAGE;
    targ.sh_cur = targ.sh_cur - mod;
    remainder = 0;
  }  
  else if((dmg_type & EFF_ENG)){
    mod = dmg_amt;
    targ.en_cur = targ.en_cur - mod;
    remainder = 0;
  }
  else{
    if(dmg_amt >= targ.sh_cur){
      targ.sh_cur = targ.sh_cur - targ.sh_cur;
      remainder = dmg_amt - targ.sh_cur;
    }
    else{
      mod = dmg_amt;
      targ.sh_cur = targ.sh_cur - mod;
      remainder = 0;
    }
  }
  return remainder;
};

float(entity targ, float dmg_amt, float dmg_type) shield_vs_mis={
  
  local float remainder, mod;
  if((dmg_type & EFF_PRC)){
    mod = dmg_amt / SHVEXP_EFFPRC_PERCENTAGE;
    targ.sh_cur = targ.sh_cur - mod;
    remainder = dmg_amt - mod;
  }
  else if((dmg_type & EFF_STX)){
    mod = dmg_amt / SHVEXP_EFFSTX_PERCENTAGE;
    targ.sh_cur = targ.sh_cur - mod;
    remainder = 0;
  }
  else if((dmg_type & EFF_RAM)){
    mod = dmg_amt * SHVEXP_EFFRAM_PERCENTAGE;
    targ.sh_cur = targ.sh_cur - mod;
    remainder = 0;
  }
  else if((dmg_type & EFF_ENG)){
    mod = dmg_amt;
    targ.en_cur = targ.en_cur - mod;
    remainder = 0;
  }
  else{
    if(dmg_amt >= targ.sh_cur){
      targ.sh_cur = targ.sh_cur - targ.sh_cur;
      remainder = dmg_amt - (targ.sh_cur * SHVEXP_EFFNON_PERCENTAGE);
    }
    else{
      mod = dmg_amt / SHVEXP_EFFNON_REDUCE;
      targ.sh_cur = targ.sh_cur - mod;
      remainder = 0;
    }
  }
  return remainder;
};


float(entity targ, float dmg_amt, float dmg_type, float arm_type) damage_armor={
  local float mod;
  if((arm_type & ARM_LIT)){
    mod = dmg_amt * ARM_LT_MOD;
    dmg_amt = dmg_amt - mod;
  }
  else if((arm_type & ARM_MED)){
    mod = dmg_amt * ARM_MD_MOD;
    dmg_amt = dmg_amt - mod;  
  }
  else if((arm_type & ARM_HVY)){
    mod = dmg_amt * ARM_HV_MOD;
    dmg_amt = dmg_amt - mod;  
  }
  return dmg_amt;
};

/*
  2 Jan 2017
    kept here for posterity, apparently agile recursion has no
    place in quake C, the dream was just too beautiful.


  this is some ugly code...

entity(entity targ, entity inflictor, entity attacker, vector dmg_point) damage_mech={

  local entity found;
  local float radi;
  radi = vlen(targ.origin - dmg_point);
  found = t_find_recurse(dmg_point, radi, targ, targ,targ);
  
  if(found == world){
    found = targ;
  }
  if(found.c_name == "cpit"){
    found = targ;
  }
  return found;
};

entity(vector point, float rad, entity src, entity own, entity prev) t_find_recurse={

  local entity found, elm;
  local float rad_dist, cur_dist;
  found = world;
  prev = own;
  rad_dist = vlen(src.origin - point);
  elm = findradius(src.origin, rad_dist);
  while(elm){
    if(elm != world){
      if(elm.owner == own){
        if((elm.c_name) && (elm.c_name != "cpit")){
          cur_dist =  vlen(elm.origin - point);
          if(cur_dist < rad_dist){
            rad_dist = cur_dist;
            if(elm.deadflag <= DEAD_NO){
              found = elm;
            }else{
              prev = elm;
              found = t_find_recurse(found.origin, rad_dist, found, own, prev); 
            }
          }
        }
      }
    }
    elm = elm.chain;
  }

  if(!found){
    return prev;
  }
  
  return found;
};
*/