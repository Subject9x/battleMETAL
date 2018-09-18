/*
mech Mod
Author: Peter Roohr
Date: 9/6/2016
Overview: header for t_damage class

according to the original source code, there should only be one 
t_damage function and 1 killed function...for some reason, maybe good house keeping?
*/

entity(entity trg, entity inflictor, entity attacker, float dmg_amt, float dmg_type, vector dmg_point, vector force) t_damage={
  
  local float new_dmg;
  local entity oself, targ_act;
    
  if( !trg.takedamage ){
    return trg;
  }
  
  if( (trg.flags & FL_GODMODE) ){
    return trg;
  }
  
  //add in ignore team damage
  if(trg.i_faction == attacker.i_faction){
    dmg_amt = dmg_amt / 2;
  }
  
  if( (trg.flags & FL_CLIENT) ){
    trg.dmg_inflictor = inflictor;
    if(trg.was_hit < time){
      trg.was_hit = time + 1;
    }
  }
  //calculate hit time and angle
  util_chekPointToHitDir(trg, dmg_point);
  
  if( (attacker.flags & FL_CLIENT) ){
    attacker.w_proj = time + 0.15;
    if( !(attacker.hitdir_buffer & STAT_HIT_TRG) ){
      attacker.hitdir_buffer = attacker.hitdir_buffer | STAT_HIT_TRG;
    }
  }

  //check shields
  if(trg.sh_cur >= 0){
    new_dmg = damage_shield(trg, dmg_amt, dmg_type);
  } 
  
  if( (trg.sh_cur <= (trg.sh_max / 2) ) ){
    if( (trg.flags & FL_MONSTER) ){
      ai_damage_react( trg, attacker );
    }
  }
  
  if(trg.sh_cur <= 0){
    trg.sh_cur = 0;
  }
  
  if(new_dmg > 0){
    dmg_amt = new_dmg;
    sound (trg, CHAN_BODY, "sound/fx_armorhit.ogg", 1, ATTN_NORM);
  }
  else{
    te_shield_test( dmg_point, vectoangles( attacker.origin - dmg_point ) );
    return trg;
  }
  
  te_spark(dmg_point, inflictor.velocity, new_dmg); 
  
  //the special hit-location calculator is only run for P_MECH
  //units
  if(trg.data_type == DATA_MECH){
    //filter out leg hits
    if(dmg_point_z < (trg.origin_z - 5)){
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
  else if(trg.data_type == DATA_BLD){
    //ai_util_defense_callForHelp(attacker);
  }
  
  trg.health = trg.health - dmg_amt;
  
  if( trg.health <= 0 ){
    //trg.health = 0;
    if( trg.th_die ){
      if( trg.c_name == M_LEGS ){
        trg.owner.m_fspeed = trg.owner.m_fspeed / 2;
        trg.deadflag = DEAD_DYING;
      }
      else{
        killed(trg, attacker, dmg_type);     
        return trg;
      }
    }
  }
  return trg;
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
  /*f_wep = closestWeapon(trg, point, rad);
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
        else{
          toSender = part;
        }
      }
    }
  }*/
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
    if(targ.owner.data_type == DATA_MECH){
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
     if (self.health < -99){
      self.health = -99;              // don't let sbar look bad if a player - not Roohr
     }
    //if (self.health > 0 ){
     // self.health = 0;
    //}
    
    if(!self.data_type){
      if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE){	// doors, triggers, etc
        self.th_die();
        self = oself;
        return;
      }
    }

    //AI mech / tank death trigger fix
    if( (self.data_type == DATA_MECH) || (self.data_type == DATA_VEHC) || (self.data_type == DATA_BLD)){
      self.ladder_entity = attacker;
    }
    
    self.enemy = attacker;
    
    self.takedamage = DAMAGE_NO;
    self.touch = SUB_Null;
    
    if (!self.iscorpse){
      // bump the monster counter
      if ( (self.flags & FL_MONSTER) ){
        /*self.enemy = attacker;
        killed_monsters = killed_monsters + 1;
        WriteByte (MSG_ALL, SVC_KILLEDMONSTER);*/
      }
    }
    
    self.doobits = 0;
    
    if( (self.classname == MECH_PIECE) && (self.c_name != "weapon") ){
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
      self.th_die();
    }
    else{
      self.th_die();
    }
  
  self = oself;
};

//returns remain damage to be passed on to armor
float(entity targ, float dmg_amt, float dmg_type) damage_shield={
  float dmg_remainder;
  if(dmg_amt > 5){
    //this makes shields a bit more important, and additionally - anti-shield weapons
    targ.sh_hit = time + SHIELD_RECHARGE_COOLDOWN;
  }
  else{
    if( dmg_amt != 0 ){
      targ.sh_hit = time + (SHIELD_RECHARGE_COOLDOWN / 4);
    }
  }
  if( ( dmg_type  & EFF_STX) ){
    targ.sh_hit = targ.sh_hit  + 4;
  }
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
      mod = dmg_amt * SHVBAL_EFFNON_REDUCE;
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
  AI has been hit by something, and has to react to it
*/
void(entity trg, entity atk) anger_monster={

};


//LEGACY FROM COMBAT.QC

void() T_MissileTouch;
void() T_MissileTouch={};
void() info_player_start;
//void(entity targ, entity attacker) ClientObituary;

void() monster_death_use;

//============================================================================

/*
============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
*/
float(entity targ, entity inflictor) CanDamage =
{
// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}
	
	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	return FALSE;
};


/*
============
Killed
============
*/
void(entity targ, entity attacker) Killed =
{
	local entity oself;

	oself = self;
	self = targ;
	
	if (self.health < -99)
		self.health = 0;		// don't let sbar look bad if a player

	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
	{	// doors, triggers, etc
		self.th_die ();
		self = oself;
		return;
	}

	self.enemy = attacker;

// bump the monster counter
	if (self.flags & FL_MONSTER)
	{
		killed_monsters = killed_monsters + 1;
		WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
	}

	//ClientObituary(self, attacker);
	
	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;

	monster_death_use();
	self.th_die ();
	
	self = oself;
};


/*
============
T_Damage

The damage is coming from inflictor, but get mad at attacker
This should be the only function that ever reduces health.
============
*/
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage=
{
	local	vector	dir;
	local	entity	oldself;
	local	float	save;
	local	float	take;

	if (!targ.takedamage)
		return;

// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;

// check for quad damage powerup on the attacker
	if (attacker.super_damage_finished > time)
		damage = damage * 4;

// save damage based on the target's armor level

	save = ceil(targ.armortype*damage);
	if (save >= targ.armorvalue)
	{
		save = targ.armorvalue;
		targ.armortype = 0;	// lost all armor
		targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
	}
	
	targ.armorvalue = targ.armorvalue - save;
	take = ceil(damage-save);

// add to the damage total for clients, which will be sent as a single
// message at the end of the frame
// FIXME: remove after combining shotgun blasts?
	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}

// figure momentum add
	if ( (inflictor != world) && (targ.movetype == MOVETYPE_WALK) )
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize(dir);
		targ.velocity = targ.velocity + dir*damage*8;
	}

// check for godmode or invincibility
	if (targ.flags & FL_GODMODE)
		return;
	if (targ.invincible_finished >= time)
	{
		if (self.invincible_sound < time)
		{
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			self.invincible_sound = time + 2;
		}
		return;
	}

// team play damage avoidance
//	if ( (teamplay == 1) && (targ.team > 0)&&(targ.team == attacker.team) )
	if ( (teamplay == 1) && (targ.team > 0) && (targ.team == attacker.team)
	&& (targ != attacker) 			
	&& (attacker.classname == "player")
	&& (inflictor.classname != "door") )	// because squishing a teammate is still possible
		return;
		
// do the damage
	targ.health = targ.health - take;
			
	if (targ.health <= 0)
	{
		Killed (targ, attacker);
		return;
	}

// react to the damage
	oldself = self;
	self = targ;

	if ( (self.flags & FL_MONSTER) && attacker != world)
	{
	// get mad unless of the same class (except for soldiers)
		if (self != attacker && attacker != self.enemy)
		{
			if ( (self.classname != attacker.classname) || (self.classname == "monster_army" ) ){
				if (self.enemy.classname == "player")
					self.oldenemy = self.enemy;
				self.enemy = attacker;
				//self.ai_next_state = ai_hunt_target;
        //q_FoundTarget ();
			}
		}
	}

	if (self.th_pain)
	{
		self.th_pain (attacker, take, 0, "");
	// nightmare mode monsters don't go into pain frames often
		if ( skill == 3 )
			self.pain_finished = time + 5;
	}

	self = oldself;
};

/*
============
T_RadiusDamage
============
*/
void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage =
{
	local	float 	points;
	local	entity	head;
	local	vector	org;

	head = findradius(inflictor.origin, damage+40);
	
	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.5*vlen (inflictor.origin - org);
				if (points < 0)
					points = 0;
				points = damage - points;
				if (head == attacker)
					points = points * 0.5;
				if (points > 0)
				{
					if (CanDamage (head, inflictor))
					{	// shambler takes half damage from all explosions
						if (head.classname == "monster_shambler")						
							T_Damage (head, inflictor, attacker, points*0.5);
						else
							T_Damage (head, inflictor, attacker, points);
					}
				}
			}
		}
		head = head.chain;
	}
};

/*
============
T_BeamDamage
============
*/
void(entity attacker, float damage) T_BeamDamage =
{
	local	float 	points;
	local	entity	head;
	
	head = findradius(attacker.origin, damage+40);
	
	while (head)
	{
		if (head.takedamage)
		{
			points = 0.5*vlen (attacker.origin - head.origin);
			if (points < 0)
				points = 0;
			points = damage - points;
			if (head == attacker)
				points = points * 0.5;
			if (points > 0)
			{
				if (CanDamage (head, attacker))
				{
					if (head.classname == "monster_shambler")						
						T_Damage (head, attacker, attacker, points*0.5);
					else
						T_Damage (head, attacker, attacker, points);
				}
			}
		}
		head = head.chain;
	}
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
* 