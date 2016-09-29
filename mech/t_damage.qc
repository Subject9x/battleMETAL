/*
mech Mod
Author: Subject9x
Date: 9/6/2016
Overview: header for t_damage class

according to the original source code, there should only be one 
t_damage function and 1 killed function...for some reason, maybe good house keeping?
*/


void(entity targ, entity inflictor, entity attacker, float dmg_amt, float dmg_type, vector dmg_point, vector force) t_damage={
  
  local float canDamage;
    
  if(!targ.takedamage){
    return;
  }
  
  damage_attacker = attacker;
  
  //add in ignore team damage
  
  if(targ.flags & FL_GODMODE){
    return;
  }
  
  canDamage = TRUE;
  
  if(targ.flags & FL_CLIENT){
    targ.dmg_inflictor = inflictor;
  }

  if(targ.classname == "player"){
    if(targ.p_class == P_MECH){
      targ = damage_mech(targ, inflictor, attacker, dmg_amt, dmg_type, dmg_point, force);
    }
  }
  targ.health = targ.health - dmg_amt;
  
  if(targ.health <= 0){
   if(targ.th_die){
      if(targ.th_die != SUB_Null){
        killed(targ, attacker, dmg_type);
        return;
      }
    }
  }
  
  if((targ.flags & FL_MONSTER) && attacker != world){
    if(attacker.takedamage){
      if(targ.enemy == world){
        if(targ != attacker && attacker != targ.enemy){
          if ( (targ.classname != attacker.classname) || (targ.classname == "monster_army" ) ){
            
          }
        }
      }
    }
  }
};

entity(entity targ, entity inflictor, entity attacker, float dmg_amt, float dmg_type, vector dmg_point, vector force) damage_mech={

  //todo
    //run shield check
  
  //if shields are down, find the closest entity
  //check weapons first
  local entity wep, found;
  local float dist, cur_dist;

  found = world;
  dist = vlen(dmg_point - targ.origin);
  wep = targ.w_slot;
  while(wep){
    cur_dist = vlen(dmg_point - wep.origin);
    if(found.deadflag <= DEAD_NO){
      if(cur_dist < dist){
        dist = cur_dist;
        found = wep;
      }
    }
    wep = wep.w_slot;
  }
  
  if(found.deadflag == DEAD_DEAD){
    if(found.c_parent != M_TOR_CENTER){
      if(found.c_parent == M_TOR_LEFT){
        if(targ.e_tor_l != world){
          if(targ.e_tor_l.deadflag == DEAD_DEAD){
            cur_dist = vlen(dmg_point - targ.e_tor_l.origin);
            if(cur_dist < dist){
              dist = cur_dist;
              found = targ.e_tor_l;
            }
          }
        }
      }
      else if(found.c_parent == M_TOR_RIGHT){
        if(targ.e_tor_r != world){
          if(targ.e_tor_l.deadflag == DEAD_DEAD){
            cur_dist = vlen(dmg_point - targ.e_tor_l.origin);
            if(cur_dist < dist){
              dist = cur_dist;
              found = targ.e_tor_l;
            }
          }
        }
      }
    }
  }  
  /*if(targ.e_arm_l != world){
    cur_dist = vlen(dmg_point - targ.e_arm_l.origin);
    if(cur_dist < dist){
      dist = cur_dist;
      found = targ.e_arm_l;
    }
  }
  
  if(targ.e_arm_r != world){
    cur_dist = vlen(dmg_point - targ.e_arm_r.origin);
    if(cur_dist < dist){
      dist = cur_dist;
      found = targ.e_arm_r;
    }
  }*/

  if(targ.e_legs != world){
    cur_dist = vlen(dmg_point - targ.e_legs.origin);
    if(cur_dist < dist){
      dist = cur_dist;
      found = targ.e_legs;
    }
  }
  
  if(found == world){
    found = targ;
  }
  return found;
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
	//         self.health = -99;              // don't let sbar look bad if a player

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
  
  self.th_die();

  self = oself;
};
