/*
battleMETAL
Author: Peter Roohr
Date: 9/6/2016
mod 03/05/2019
Overview: header for t_damage class

according to the original source code, there should only be one 
t_damage function and 1 killed function...for some reason, maybe good house keeping?
*/

entity(entity trg, entity inflictor, entity attacker, float dmg_amt, vector dmg_point, vector force) t_damage={
  local entity dmgTrg, dmgInflictor;
  local entity notTarg;
  local float dmgAmt;
  
  if( !trg.takedamage ){
    return world;
  }
  if( (trg.flags & FL_GODMODE) ){
    return world;
  }
  if( trg.deadflag != DEAD_NO ){
    return world;
  }
  
  dmgTrg = trg;
  dmgInflictor = inflictor;
  dmgAmt = dmg_amt;
  
  //reduce friendly fire damage on easier settings
  if( (serverflags & SVFLAG_FIREON) ){
    if( (trg.faction != FACTION_ALL) ){
      if( trg.faction == attacker.faction ){
        if( skill < 2 ){
          dmgAmt = dmgAmt * DMG_FRIENDLY_FIRE_REDUCE;
        }
        else{
          dmgAmt = dmgAmt * DMG_FRIENDLY_FIRE_REDUCE_SKILL;
        }
      }
    }
  }
  
                            //------------> Damage Buffer system
                            if( (dmgTrg.flags & FL_CLIENT) ){
                              if( trg.faction == FACTION_ALL && trg.data_type != DATA_BLD ){
                                dmgTrg.clientData.SendFlags = dmgTrg.clientData.SendFlags | SENDFLAG_IMPACT;
                              }
                            }
                            //-----------------------
                            
  trg.dmg_inflictor = inflictor;
  if(trg.was_hit < time){
    trg.was_hit = time + 1;
  }
  
  //shield delay check=============================
  /*
    the idea is to make sure the delay is proportionate to the 'damage dealt.' 
    IE it doesn't make sense (to the designer) that shield delay is the same whether hit by an autocannon or an EMP blast.
  */
  //shield delay should be communicated to the player
  //if( time > trg.shieldHitRegen ){} //commenting out no-op
  if( time < trg.shieldHitDelay ){
    //stack
    trg.shieldHitDelay = trg.shieldHitDelay + 0.1;
  }
  //================================================
  
  //calculate hit time and angle
  util_chekPointToHitDir(trg, dmg_point);
  
  if( (attacker.flags & FL_CLIENT) ){
    attacker.playerDMdamage = attacker.playerDMdamage + dmgAmt;
    if( !attacker.enemy && dmgTrg.canTarget ){
      attacker.enemy = dmgTrg;
      attacker.targetEntId = num_for_edict(dmgTrg);
      //attacker.targLockState = attacker.targLockState | LOCK_TARG_START; //2.0.0: lock-on not timer-based anymore
      attacker.clientData.SendFlags = attacker.clientData.SendFlags | SENDFLAG_TARGET;
    }
    attacker.w_proj = time + 0.2;
    if( !(attacker.hitdir_buffer & STAT_HIT_TRG) ){
      attacker.hitdir_buffer = attacker.hitdir_buffer | STAT_HIT_TRG;
    }
  }
                        
                         //------------>TODO: Damage Buffer system
                        //AI react to Damage
                        if( (trg.flags & FL_MONSTER) ){
                          notTarg = self;
                          self = dmgTrg;
                          if( self.th_pain ){  
                            self.th_pain( attacker );
                          }
                          if( attacker.faction != self.faction ){
                            if( self.ai_rank > AI_RANK_REG ){
                              if( self.shield <= (self.shieldMax / 2) ){
                                ai_call_for_help(attacker);
                              }
                            }
                          }
                          self = notTarg;
                        }
                        //-----------------------------
  
  if( dmgAmt <= 0 ){
    return trg;
  }
  
  //the special hit-location calculator is only run for DATA_MECH units
  if( trg.data_type == DATA_MECH ){
    //filter out leg hits
    if( !(dmgTrg.legs.flags & FL_DISARMED) && (dmg_point_z < (trg.origin_z - 5)) ){
      dmgTrg = dmgTrg.legs;
    }
    else{
      if(dmg_point_z < (trg.origin_z - 5) ){
        dmgAmt = dmgAmt * 0.33;  //NOTE: indirect hit to not completely punished wasted leg shots
      }
      dmgTrg = t_find_part(dmg_point, dmgTrg);
    }
  }
  
  
                              //TODO: this goes to damage buffer
                              if( dmgTrg.health > 0 ){
                                if( (trg.flags & FL_UNIT) && trg.data_type == DATA_MECH){
                                  if( !(dmgTrg.partTypeId & (M_TOR_LEFT | M_TOR_RIGHT | M_ARM_LEFT | M_ARM_RIGHT)) ){
                                    if( (trg.criticalHits & M_TOR_LEFT) ){
                                      dmgAmt = dmgAmt * DMG_TORSO_CRIT_MULTI;
                                    }
                                    if( (trg.criticalHits & M_TOR_RIGHT) ){
                                      dmgAmt = dmgAmt * DMG_TORSO_CRIT_MULTI;
                                    }
                                  }
                                }
                                
                                dmgTrg.health = dmgTrg.health - dmgAmt;
                                if( dmgTrg.health < 0){
                                  dmgTrg.health = 0;
                                }
                              }
                              
                              
                              if( (dmgTrg.flags & FL_MONSTER) && (dmgTrg.data_type != DATA_BLD) ){
                                if( util_getMechHpAverage(dmgTrg) < 0.5){
                                  if( attacker.faction != self.faction ){
                                    notTarg = self;
                                    self = dmgTrg;
                                      ai_call_for_help( attacker );
                                    self = notTarg;
                                  }
                                }
                              }
                              if( dmgTrg.health <= 0 ){
                                if( dmgTrg.th_die ){
                                  killed(dmgTrg, attacker);
                                }
                              }
                              //---------------------------------
  return dmgTrg;
};


/*
  you've already checked shield levels before calling this.
*/
entity(entity trg, entity inflictor, entity attacker, float dmg_amt, vector dmg_point, float shieldBreaker) t_damage_shield={
  local entity dmgTrg, dmgInflictor;
  local entity notTarg;
  local float dmgAmt;
  
  if( !trg.takedamage ){
    return world;
  }
  if( (trg.flags & FL_GODMODE) ){
    return world;
  }
  if( trg.deadflag != DEAD_NO ){
    return world;
  }
  
  dmgTrg = trg;
  dmgInflictor = inflictor;
  dmgAmt = dmg_amt;
  
  //reduce friendly fire damage on easier settings
  if( (serverflags & SVFLAG_FIREON) ){
    if( (trg.faction != FACTION_ALL) ){
      if( trg.faction == attacker.faction ){
        if( skill < 2 ){
          dmgAmt = dmgAmt * 0.67;
        }
        else{
          dmgAmt = dmgAmt * 0.33;
        }
      }
    }
  }
  
  dmgTrg.shield = dmgTrg.shield - dmgAmt;
  if( dmgTrg.shield < 0 ){
    dmgTrg.shield = 0;
    if(shieldBreaker){
      dmgTrg.shieldHitFlag = SHIELD_HIT_IXP;
    }
    else{
      dmgTrg.shieldHitFlag = SHIELD_HIT_EXP;
    }
  }
  else{
    if(shieldBreaker){
      dmgTrg.shieldHitFlag = SHIELD_HIT_EMP;
    }
    else{
      dmgTrg.shieldHitFlag = SHIELD_HIT_REG;
    }
  }
  
  if( (dmgTrg.flags & FL_CLIENT) ){
    dmgTrg.clientData.SendFlags = dmgTrg.clientData.SendFlags | SENDFLAG_IMPACT;
  }
  else{
    dmgTrg.SendFlags = dmgTrg.SendFlags | SENDFLAG_IMPACT;
  }
  
  dmgTrg.dmg_inflictor = inflictor;
  if(dmgTrg.was_hit < time){
    dmgTrg.was_hit = time + 1;
  }

  //calculate hit time and angle
  util_chekPointToHitDir(dmgTrg, dmg_point);
  
  if( (attacker.flags & FL_CLIENT) ){
    attacker.w_proj = time + 0.2;
    if( !attacker.enemy && dmgTrg.canTarget ){
      attacker.enemy = dmgTrg;
      attacker.targetEntId = num_for_edict(dmgTrg);
      //attacker.targLockState = attacker.targLockState | LOCK_TARG_START; //2.0.0: lock-on not timer-based anymore
      attacker.clientData.SendFlags = attacker.clientData.SendFlags | SENDFLAG_TARGET;
    }
    if( !(attacker.hitdir_buffer & STAT_HIT_TRG) ){
      attacker.hitdir_buffer = attacker.hitdir_buffer | STAT_HIT_TRG;
    }
  }
  
  //shield delay check=============================
  /*
    the idea is to make sure the delay is proportionate to the 'damage dealt.' 
    IE it doesn't make sense (to the designer) that shield delay is the same whether hit by an autocannon or an EMP blast.
  */
  //shield delay should be communicated to the player
  //ION / EMP should be better than most for messing with delay
  if( dmgTrg.shield <= 0 ){
    if( time > dmgTrg.shieldHitRegen ){
      //fresh hit
      if( shieldBreaker ){
        dmgTrg.shieldHitRegen = time + (SHIELD_DELAY * 2);
      }
      else{
        dmgTrg.shieldHitRegen = time + SHIELD_DELAY;
      }
      dmgTrg.shieldHitRegenStart = time;
    }
  }
  else{
    if( time > dmgTrg.shieldHitDelay ){
      if( shieldBreaker ){
        dmgTrg.shieldHitDelay = time + (SHIELD_DELAY * 0.75);
      }
      else{
        dmgTrg.shieldHitDelay = time + (SHIELD_DELAY * 0.33);
      }
      dmgTrg.shieldHitDelayStart = time;
    }
    else{
      if( (dmgTrg.shieldHitDelay - dmgTrg.shieldHitDelayStart ) < SHIELD_DELAY ){
        if( shieldBreaker ){
          dmgTrg.shieldHitDelay = dmgTrg.shieldHitDelay + (SHIELD_DELAY * 0.75);
        }
        else{
          dmgTrg.shieldHitDelay = dmgTrg.shieldHitDelay + (SHIELD_DELAY * 0.33);
        }
      }
    }
  }
  //================================================
  
  //AI react to Damage
  if( (dmgTrg.flags & FL_MONSTER) ){
    notTarg = self;
    self = dmgTrg;
    if( self.th_pain ){  
      if( time > self.ai_react_buffer ){
        self.th_pain( attacker );
      }
    }
    if( attacker.faction != self.faction ){
      if( self.ai_rank > AI_RANK_REG ){
        if( self.shield < (self.shieldMax / 2) ){
          ai_call_for_help(attacker);
        }
      }
    }
    self = notTarg;
  }
  return dmgTrg;
}


/*
  finds closest sub-entity
*/
entity(vector point, entity trgUnit) t_find_part={
  local entity part;
  local float radi;
  
  part = trgUnit;
  radi = vlen(trgUnit.torsoCenter.hitOffset - point);
    
  if( vlen(trgUnit.armLeft.hitOffset - point ) < radi ){
    part = trgUnit.armLeft;
    radi = vlen(point - trgUnit.armLeft.hitOffset);
  }
  if( vlen(trgUnit.armRight.hitOffset - point ) < radi ){
    part = trgUnit.armRight;
    radi = vlen(point - trgUnit.armRight.hitOffset);
  }
  if( vlen(trgUnit.torsoLeft.hitOffset - point ) < radi ){
    part = trgUnit.torsoLeft;
    radi = vlen(point - trgUnit.torsoLeft.hitOffset);
  }
  if( vlen(trgUnit.torsoRight.hitOffset - point ) < radi ){
    part = trgUnit.torsoRight;
    radi = vlen(point - trgUnit.torsoRight.hitOffset);
  }

  if( part.deadflag > DEAD_NO ){
    part = part.realowner;
  }
  if( part == trgUnit.torsoCenter ){
    part = trgUnit;
  }
  return part;
};

/*
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
*/


void(entity targ, entity attacker) killed={
  local entity thisOldSelf;
  
  thisOldSelf = self;
  self = targ;
    self.enemy = attacker;
    if( targ.partTypeId != FALSE ){
      self.takedamage = DAMAGE_NO;
      self.touch = SUB_Null;
      self.th_die();
      self = thisOldSelf;
      return;
    }
    // I honestly don't care if it shows a strange number,
    // and disabling this means I can check for worse damage
    // in the kill messages etc.
    // infact I've never seen a case where the number shows,
    // always hidden by the score bar stuff.
    // don't let sbar look bad if a player - not Roohr
    if (self.health < -99){
      self.health = -99;              
    }
    
    if(!self.data_type){
      if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE){	// doors, triggers, etc
        self.th_die();
        self = thisOldSelf;
        return;
      }
    }

    self.takedamage = DAMAGE_NO;
    self.touch = SUB_Null;
    
    // bump the monster counter
    if ( (self.flags & (FL_MONSTER | FL_UNIT)) || (self.spawnflags & IS_VIP)){
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
      if( (self.enemy.flags & FL_CLIENT) ){
        self.enemy.botKills = self.enemy.botKills + 1;
      }
      killed_monsters = killed_monsters + 1;
    }
    if( (self.flags & FL_CLIENT) && (attacker.flags & FL_CLIENT) ){
      //deathmatch edge-case
      if( self.faction == FACTION_ALL ){
        attacker.frags = attacker.frags + 1;
      }
      else{
        if( (self.faction == attacker.faction) ){
          if( (serverflags & SVFLAG_FIREON) ){
            attacker.frags = attacker.frags - 1;
            if( attacker.frags < 0 ){
              attacker.frags = 0;
            }
          }
        }
        else{
          attacker.frags = attacker.frags + 1;
        }
      }
    }
    
    self.doobits = 0;
    self.th_die();
  self = thisOldSelf;
};


//LEGACY FROM COMBAT.QC
/*
================
TraceAttack
================
ported over from orginal q1src,modified to return
  TRUE = do damage logic
  FALSE = a miss.
*/
float(float damage, vector dir) TraceAttack =
{
	local	vector	vel, org;
	
	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
		/*SpawnBlood (org, vel*0.2, damage);
		AddMultiDamage (trace_ent, damage);*/
    return TRUE;
	}
	else{
    return FALSE;
		/*WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);*/
	}
};


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
   /* if (targ.flags & FL_CLIENT)
    {
      targ.dmg_take = targ.dmg_take + take;
      targ.dmg_save = targ.dmg_save + save;
      targ.dmg_inflictor = inflictor;
    }*/

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