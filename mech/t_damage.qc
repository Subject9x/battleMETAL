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

  //check shields
  if(trg.sh_cur >= 0){
    new_dmg = damage_shield(trg, attacker, dmg_amt, dmg_type);
  } 
  
  if(trg.sh_cur <= 0){
    trg.sh_cur = 0;
    te_tarexplosion(trg.origin);
  }
  
  if(new_dmg > 0){
    dmg_amt = new_dmg;
  }
  else{
    te_knightspike(dmg_point);
    return;
  }
  
  te_spark(dmg_point, attacker.velocity, new_dmg); 
  
  //the special hit-location calculator is only run for P_MECH
  //units
  if(trg.p_class == P_MECH){
    //filter out leg hits
    if(dmg_point_z < (trg.origin_z - 10)){
      trg = trg.e_legs;
    }
    else{
      local float irad;
      irad = vlen(trg.origin - dmg_point);
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

  if((trg.flags & FL_MONSTER) && attacker != world){
    if(attacker.takedamage){
      if(trg.enemy == world){
        if(trg != attacker && attacker != trg.enemy){
          if ( (trg.classname != attacker.classname) || (trg.classname == "monster_army" ) ){
            
          }
        }
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
entity(vector point, float rad, entity own) t_find_part={
  
  local float cur_dist, a_rad, t_rad, c1_rad,c2_rad;
  local entity  farm, ftor, c1, toSender;
  t_rad = rad;
  cur_dist = vlen(point - own.e_arm_l.origin);
  if(cur_dist < rad){
    a_rad = cur_dist;
    farm = own.e_arm_l;
  }

  cur_dist = vlen(point - own.e_arm_r.origin);
  if(cur_dist < rad){
    a_rad = cur_dist;
    farm = own.e_arm_r;
  }
  
  cur_dist = vlen(point - own.e_tor_l.origin);
  if(cur_dist < rad){
    t_rad = cur_dist;
    ftor = own.e_tor_l;
  }
  
  cur_dist = vlen(point - own.e_tor_r.origin);
  if(cur_dist < rad){
    t_rad = cur_dist;
    ftor = own.e_tor_r;
  }
  
  if(a_rad < t_rad){
    if(farm.deadflag <= DEAD_NO){
      c1_rad = a_rad;
      c1 = farm;
    }
    else{
      c1_rad = t_rad;
      c1 = ftor;
    }
  }
  else if(t_rad < a_rad){
    if(ftor.deadflag <= DEAD_NO){
      c1_rad = t_rad;
      c1 = ftor;
    }
    else{
      c1_rad = a_rad;
      c1 = farm;
    }
  } 
  
  if(c1_rad < rad){
    if(c1.deadflag <= DEAD_NO){
      toSender =  c1;
    }
    else{
      toSender = own;
    }
  }
  else{
    toSender = own;
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
    self.enemy.stat_trg_am = -1;
    self.enemy.enemy = world;
  }

  self.th_die();
  
  self = oself;
};

//returns remain damage to be passed on to armor
float(entity targ, entity attacker, float dmg_amt, float dmg_type) damage_shield={
  
  if(targ.sh_cur >= 0){
    targ.sh_hit = time + SHIELD_DELAY;
    if((dmg_type & DMG_ENE)){
      if((dmg_type & EFF_RAM)){
        targ.sh_cur = targ.sh_cur - dmg_amt;
        return 0;
      }
      else if((dmg_type & EFF_PRC)){
        targ.sh_cur = targ.sh_cur - (dmg_amt/SHIELD_SOAK);
        return (dmg_amt - (dmg_amt/SHIELD_SOAK));
      }
      else{
        if(targ.sh_cur < dmg_amt){
          targ.sh_cur = 0;
          dmg_amt = dmg_amt - targ.sh_cur;
          return dmg_amt;
        }
        else{
          targ.sh_cur = targ.sh_cur - dmg_amt;
          return 0;
        }
      }
    }
    else if((dmg_type & DMG_BAL)){
      if((dmg_type & EFF_RAM)){
        targ.sh_cur = targ.sh_cur - (dmg_amt + (dmg_amt * 1.5));
        return 0;
      }
      if((dmg_type & EFF_PRC)){
        return dmg_amt;
      }
      if(targ.sh_cur < dmg_amt){
        dmg_amt = dmg_amt - targ.sh_cur;
        return dmg_amt;
      }
      else{
        targ.sh_cur = targ.sh_cur - (dmg_amt/2);
        return 0;
      }
    }
    else if((dmg_type & DMG_EXP)){
    
    }
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