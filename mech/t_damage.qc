/*
mech Mod
Author: Subject9x
Date: 9/6/2016
Overview: header for t_damage class

according to the original source code, there should only be one 
t_damage function and 1 killed function...for some reason, maybe good house keeping?
*/


void(entity targ, entity inflictor, entity attacker, float dmg_amt, float dmg_type, vector dmg_point, vector force) t_filter={

  local float shotdir;
  local vector dir;
  /*
    1) get shot point
    2) find angle
    3) draw halfway point
    4) 
  
  */

};

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
      targ = damage_mech(targ, inflictor, attacker, dmg_point);
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

/*
  this is some ugly code...
*/
entity(entity targ, entity inflictor, entity attacker, vector dmg_point) damage_mech={

  local entity found;
  local float radi;
  radi = vlen(targ.origin - dmg_point);
  found = t_find_recurse(dmg_point, radi, targ, targ);
  
  if(found == world){
    found = targ;
  }
  return found;
};

entity(vector point, float rad, entity src, entity own) t_find_recurse={

  local entity found, elm;
  local float rad_dist, cur_dist;
  found = world;
  rad_dist = vlen(src.origin - point);
  elm = findradius(src.origin, rad_dist);
  while(elm){
    if(elm != world){
      if(elm.owner == own){
        if(elm.c_name){
          cur_dist =  vlen(elm.origin - point);
          if(cur_dist < rad_dist){
            rad_dist = cur_dist;
            if(elm.deadflag <= DEAD_NO){
              found = elm;
            }else{
              found = t_find_recurse(found.origin, rad_dist, found, own);
            }
          } 
        }
      }
    }
    elm = elm.chain;
  }

  if(!found){
    return src;
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
