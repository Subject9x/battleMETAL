/*
mech Mod
Author: Subject9x
Date: 1/29/2017
Overview: the defintion file for my radar idea
*/


//scope - self = unit making the sweep
vector() radar_MakeSweep={

  local entity oself, contact, root;
  local float heat_front, heat_back, ht, face;
  heat_front = 0;
  heat_back = 0;
  contact = findradius(self.origin, self.radar_range);
  root = contact;
  while(contact){
    if(contact != world){
      if(contact.classname != MECH_PIECE){
        if(contact.p_class != P_OBS){
          if(contact.deadflag <= DEAD_NO){
            ht = 0;
            ht = ht + radar_calcPlayerDist(contact, ht);
            ht = ht + radar_calcEnemyDist(root, contact, ht);
            ht = ht + radar_calcUnitValue(contact, ht) ;
            face = infront(contact); //oh look an actual use for original qc code
            if(face == 0){
              heat_back =  heat_back + ht;
            }
            else{
              heat_front =  heat_front + ht;
            }
          }
        }
      }
    }
    contact = contact.chain;
  }
  local vector toSender;
  toSender_x = heat_front;
  toSender_y = heat_back;

  
  return toSender;
};

float(entity contact, float current_total) radar_calcPlayerDist={
  local float dist, mod;
  dist = vlen(contact.origin - self.origin);
  if(dist == 0){
    dist = 1;
  }
  mod = (RADAR_ETOT_RATIO / dist) * 100;
  return mod;
};

float(entity root, entity contact, float current_total) radar_calcEnemyDist={
  local entity oself, sub;
  local float total;
  total = 0;
  sub = root;
  while(sub){
    if(sub != world){
      if(sub.classname != MECH_PIECE){
        if(sub.p_class != P_OBS){
          local float dist;
          dist = vlen(sub.origin - contact.origin);
          dist = dist * RADAR_ETOE_RATIO;
        }
      }
    }
    sub = sub.chain;
  }
  return -total;
};

float(entity contact, float current_total) radar_calcUnitValue={
  local float val;
  val = 0;
  if(contact.p_class == P_MECH){
    val = val + RADAR_ISMECH;
  }
  
  if(contact.p_class == P_VECH){
    val = val + RADAR_ISCIV;
  }
  return val ;
};