/*
battleMETAL
Author: Peter Roohr
Date: 9/6/2016
mod 03/05/2019
Overview: header for t_damage class

according to the original source code, there should only be one 
t_damage function and 1 killed function...for some reason, maybe good house keeping?
*/

/*
Ballistic Damage
  IF shields are up, reduce shot damage by half
  IF EFF_PRC, increase armor damage
  IF EFF_RAM, cause energy crits
*/
float( entity targ, entity inflictor, float dmg_amt ) t_damage_bal={
  local float damage, dmgtype, shields, crit;
  dmgtype = inflictor.damageType;
  damage = dmg_amt;
  shields = targ.shield;
  
  if( (dmgtype & EFF_STX) ){
    return t_damage_ene( targ, inflictor, damage );
  }
  
  if( shields > 0 ){
    damage = damage - (damage / 2 );
    shields = shields - damage;
    damage = 0;
  }
  else{
    if( (dmgtype & EFF_PRC) ){
      damage = damage * 2;
    }
    if( (dmgtype * EFF_RAM) ){
      crit = 0.25;
      crit = crit + ((3 - skill) / 10);
      crit = crit + ((3 - targ.vec_size) / 10);
      if( (targ.flags & FL_CLIENT) ) {
        crit = crit / 1.25;
      }
      if( random() <= crit ){
        damage = damage * 1.5;
      }
    }
  }
  
  if( shields < 0 ){
    shields = 0;
  }
  targ.shield = shields;
  
  return damage;
};

/*
Energy Damage
  IF target shields are up, shields take dmg * 1.5
  IF EFF_ENE, only affects shields
  IF EFF_STX, might cause shield crit
  IF EFF_PRC, shields only consume 25% of damage
  OR EFF_RAM, spill over damage
*/
float( entity targ, entity inflictor, float dmg_amt ) t_damage_ene={
  local float damage, dmgtype, shields, mod, crit;
  
  dmgtype = inflictor.damageType;
  damage = dmg_amt;
  shields = targ.shield;

  if( shields <= 0 ){
    if( (dmgtype & EFF_ENE) ){
      return 0;
    }
    return damage;
  }
  
  damage = damage + ( damage * 0.5);
  
  if( (dmgtype & EFF_STX) ){
    crit = 0.25;
    crit = crit + ((3 - skill) / 10);
    crit = crit + ((3 - targ.vec_size) / 10);
    if( (targ.flags & FL_CLIENT) ) {
      crit = crit / 1.25;
    }
    if( random() <= crit ){
      damage = damage * 1.75;
    }
  }
  if( (dmgtype & EFF_PRC) ){
    mod = damage * 0.25;
    shields = shields - mod;
    damage = damage - mod;
  }
  else {
    shields = shields - damage;
    if( shields < 0 ){
      if( (dmgtype & EFF_RAM) ){
        mod = shields;
        damage = mod * -1;
      }
      else{
        damage = 0;
      }
      shields = 0;
    }  
  }  
  targ.shield = shields;
 
  //EFF_STX only affects shields;
  if( (dmgtype & EFF_STX) ){
    damage = 0;
  }
  return damage;
};
/*
Explosive Damage
  IF target shields > 25%, shields consume entire hit, no exceptions.
  IF target shields < 25%, treat like EFF_PRC damage
  IF shields are down, explosive might cause an armor crit
*/
float( entity targ, entity inflictor, float dmg_amt ) t_damage_mis={
  local float damage, dmgtype, shields, mod, crit, quarter;
  
  dmgtype = inflictor.damageType;
  damage = dmg_amt;
  shields = targ.shield;
  quarter = shields * 0.25;
  
  if( targ.shield > quarter ){
    damage = 0;
  }
  else if( (targ.shield <= quarter) && (targ.shield > 0) ){
    mod = targ.shield / targ.shieldMax;
    mod = mod / 2;
    damage = damage - mod;
  }
  else{
    //shields be zero
    crit = 0.25;
    crit = crit + ((3 - skill) / 10);
    crit = crit + ((3 - targ.vec_size) / 10);
    if( (targ.flags & FL_CLIENT) ) {
      crit = crit / 1.25;
    }
    if( random() <= crit ){
      damage = damage * 1.25;
    }
  }
  
  targ.shield = shields;
  
  return damage;
};

entity(entity trg, entity inflictor, entity attacker, float dmg_amt, float dmg_type, vector dmg_point, vector force) t_damage={
  local entity dmgTrg, dmgInflictor;
  local entity otherSelf, targ_act;
  local entity notTarg;
  local float dmgAmt, prevShields;  
  
  if( !trg.takedamage ){
    return trg;
  }
  
  if( (trg.flags & FL_GODMODE) ){
    return trg;
  }
  
  dmgTrg = trg;
  dmgInflictor = inflictor;
  dmgAmt = dmg_amt;
  
  prevShields = trg.shield;
  
  //reduce friendly fire damage on easier settings
  if(trg.faction == attacker.faction){
    if( skill == 0 ){
      return trg;
    }
    dmgAmt = dmgAmt / 2;
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
    attacker.w_proj = time + 0.2;
    if( !(attacker.hitdir_buffer & STAT_HIT_TRG) ){
      attacker.hitdir_buffer = attacker.hitdir_buffer | STAT_HIT_TRG;
    }
  }
  
  //check shields
  if( (dmg_type & DMG_BAL) ){
    dmgAmt = t_damage_bal( dmgTrg, dmgInflictor, dmgAmt );
  }
  else if( (dmg_type & DMG_ENE) ){
    dmgAmt = t_damage_ene( dmgTrg, dmgInflictor, dmgAmt );
  }
  else if( (dmg_type & DMG_EXP) ){
    dmgAmt = t_damage_mis( dmgTrg, dmgInflictor, dmgAmt );
  }
  
  //shield delay check=============================
  /*
    the idea is to make sure the delay is proportionate to the 'damage dealt.' 
    IE it doesn't make sense (to the designer) that shield delay is the same whether hit by an autocannon or an EMP blast.
  */
  trg.shieldHitDelay = trg.shieldHitDelay + (4 - trg.vec_size); //simulates larger reactor size on larger units.
  trg.shieldHitDelay = trg.shieldHitDelay + (3 - skill);        //easier game modes have shorter recharge delays.
  if( trg.shield <= FALSE ){
    trg.shieldHitDelay = trg.shieldHitDelay + (trg.shieldHitDelay * 3); //easier to disable shields that are already down.
  }
  else{
    trg.shieldHitDelay = trg.shieldHitDelay * 2;
  }
  trg.shieldHitDelay = trg.shieldHitDelay / 100;
  trg.shieldHitDelay = trg.shieldHitDelay + (dmg_amt / 500);  
  trg.shieldHitDelay = time + (trg.shieldHitDelay + SHIELD_DELAY);
  //================================================
  
  //AI react to Damage
  if( (trg.flags & FL_MONSTER) ){
    notTarg = self;
    self = dmgTrg;
    if( self.data_type == DATA_BLD ){
      if( self.data_idx == UI_BUILDING_radar ){
        if( self.enemy != attacker ){
          self.oldenemy = self.enemy;
          self.enemy = attacker;
          self.th_missile();
          self.enemy = self.oldenemy;
        }
        else{
          self.enemy = attacker;
          self.th_missile();
        }
      }
    }
    else{
      ai_damage_react( dmgTrg, attacker );
    }
    self = notTarg;
  }
  
  if( (prevShields > 0) && (trg.shield <= 0) ){
    te_shield_explode( trg.origin, trg.vec_size );
    if( (trg.flags & FL_MONSTER) ){
      if( trg.ai_rank <= AI_RANK_REG ){
        ai_sfx_dying();
      }
    }
  }
  
  if( !dmgAmt ){
    te_shield_hit_high( dmg_point, normalize( dmg_point - trg.origin), dmg_amt, random() * dmg_amt);
    return trg;
  }
  sound (dmgTrg, CHAN_BODY, "sound/fx_armorhit.ogg", 1, ATTN_NORM);
  
  //the special hit-location calculator is only run for DATA_MECH units
  if(trg.data_type == DATA_MECH){
    //filter out leg hits
    if(dmg_point_z < (trg.origin_z - 5)){
      dmgTrg = dmgTrg.legs;
    }
    else{
      local float irad;
      irad = vlen(dmg_point - trg.origin);
      targ_act = t_find_part(dmg_point, irad, dmgTrg);
      if(targ_act != world){
        if(targ_act.deadflag <= DEAD_NO){
          dmgTrg = targ_act;
        }
      }
    }
  }
  
  if( dmgTrg.health > 0 ){
    dmgTrg.health = dmgTrg.health - dmgAmt;
    if( dmgTrg.health < 0){
      dmgTrg.health = 0;
    }
  }
  
  if( dmgTrg.health <= 0 ){
    if( dmgTrg.th_die ){
      if( dmgTrg.partTypeId == M_LEGS ){
        if( !(dmgTrg.flags & FL_DISARMED) ){
          dmgTrg.owner.data_speed_forward = dmgTrg.owner.data_speed_forward / 2;
          dmgTrg.owner.data_speed_strafe = dmgTrg.owner.data_speed_strafe / 2;
          dmgTrg.owner.data_speed_backward = dmgTrg.owner.data_speed_backward / 2;
          dmgTrg.flags = dmgTrg.flags | FL_DISARMED;
          if( (dmgTrg.owner.flags & FL_CLIENT) ){
            otherSelf = self;
            self = dmgTrg.owner;
              client_update_moveSpeed(dmgTrg.owner.data_speed_forward, dmgTrg.owner.data_speed_strafe, dmgTrg.owner.data_speed_backward, "1", "0"); 
            self = otherSelf;
          }
        }
      }
      else{
        killed(dmgTrg, attacker, dmg_type);
      }
    }
  }
  else{
    if( (trg.flags & FL_MONSTER) && trg.deadflag == DEAD_NO ){
      if( util_getMechHpAverage( trg ) <= 0.5 ){
        otherSelf = self;
        self = trg;
          ai_call_for_help( attacker );
        self = otherSelf;
      }
    }
  }
  return dmgTrg;
};

/*
  finds closest sub-entity
*/
entity(vector point, float rad, entity trg) t_find_part={
  
  local float cur_dist;
  local float diff;
  local entity  unitPart, toSender;
  cur_dist = rad;
  unitPart = trg.partNext;
  while(unitPart){
    if( unitPart.partTypeId != M_ITEM && unitPart.partTypeId != M_CAMERA ){    
      diff = vlen(point - unitPart.origin);
      if(diff < cur_dist){
        cur_dist = diff;
        toSender = unitPart;
      }
    }
    unitPart = unitPart.partNext; //includes weapons to help increase granularity
  }

  //weapons can't be destroyed, BUT we can use their position to better find the closest mech piece.
  if( toSender.partTypeId == M_ITEM || toSender.partTypeId == M_CAMERA ){
    toSender = toSender.aiment;
  }

  if( toSender.partTypeId == M_TOR_CENTER ){
    toSender = trg;
  }
  
  return toSender;
};

/*entity(entity parent, vector org, float start_rad) closestWeapon={
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
};*/


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

    self.enemy = attacker;
    
    self.takedamage = DAMAGE_NO;
    self.touch = SUB_Null;
    
    if (self.solid != SOLID_CORPSE){
      // bump the monster counter
      if ( (self.flags & (FL_MONSTER | FL_UNIT)) ){
        switch( self.faction ){
          case FACTION_PSC:
            MISSION_LOSSES_PSC = MISSION_LOSSES_PSC + 1;
            break;
          case FACTION_SURVEST:
            MISSION_LOSSES_SURVEST = MISSION_LOSSES_SURVEST + 1;
            break;
          case FACTION_MILITAR:
            MISSION_LOSSES_MILITAR = MISSION_LOSSES_MILITAR + 1;
            break;
        }
        if( (attacker.flags & FL_CLIENT) && (self.faction != attacker.faction) ){
          attacker.frags = attacker.frags + 1;
        }
        self.enemy = attacker;
        killed_monsters = killed_monsters + 1;
        WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
      }
    }
    
    self.doobits = 0;
    
    if( (self.flags & FL_UNIT) || (self.data_type == DATA_BLD) ){      
      local entity note;
      note = findchainflags(flags, FL_CLIENT);
      while( note ){
        if( note.enemy == self ){
          client_send_hud_target_kill( note );
        }
        note = note.chain;
      }
    }
    
    if( (self.classname == MECH_PIECE) && (self.partTypeId != -1) ){
      local entity wep;
      wep = self.owner;
      while(wep){
        wep = wep.w_slot;
        if(wep.partParentId == self.partTypeId){
          if(wep.deadflag <= DEAD_NO){
            killed(wep, attacker, 0);      
          }
        }
      }
    }
    //self.th_die();
    self.think = self.th_die;
    self.nextthink = time + 0.1;
  self = oself;
};


//LEGACY FROM COMBAT.QC

void() T_MissileTouch;
void() T_MissileTouch={};
void() info_player_start;
//void(entity targ, entity attacker) ClientObituary;

//void() monster_death_use;

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
	if( (self.flags & FL_MONSTER) ){
		killed_monsters = killed_monsters + 1;
		WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
	}

	//ClientObituary(self, attacker);
	
	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;

	//monster_death_use();
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
	//if (attacker.super_damage_finished > time)
		//damage = damage * 4;

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
	/*if (targ.invincible_finished >= time)
	{
		if (self.invincible_sound < time)
		{
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			self.invincible_sound = time + 2;
		}
		return;
	}*/

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
		//self.th_pain (attacker, take, 0, "");
		self.th_pain (attacker);
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
  if(found.partTypeId == "cpit"){
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
        if((elm.partTypeId) && (elm.partTypeId != "cpit")){
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