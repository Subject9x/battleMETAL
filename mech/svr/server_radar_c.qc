/*
mech Mod
Author: Subject9x
Date: 1/29/2017
Overview: the defintion file for my radar idea
*/


//scope - self = unit making the sweep
vector() radar_MakeSweep={

  local entity oself, contact, root;
  local float heat_front, heat_back, face;
  heat_front = 0;
  heat_back = 0;
  contact = findradius(self.origin, self.radar_range);
  root = contact;
  while(contact){
    if(contact.data_idx){
      if(contact.faction != self.faction){
        if(contact.p_class != P_OBS){
          if(contact.deadflag <= DEAD_NO){
            local float ht;
            ht = 0;
            ht = ht + radar_calcPlayerDist(contact, ht);
            ht = ht + radar_calcEnemyDist(root, contact, ht);
            ht = ht + radar_calcUnitValue(contact, ht) ;
            face = infront(contact); //oh look an actual use for original qc code
            if(face){
              heat_front =  heat_front + ht;
            }
            else{
              heat_back =  heat_back + ht;
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
  if(dist <= 0){
    dist = 1;
  }
  mod = (1 / (dist *dist)); 
  return mod;
};

float(entity root, entity contact, float current_total) radar_calcEnemyDist={
  local entity oself, sub;
  local float total;
  total = 0;
  sub = root;
  while(sub){
    if(sub.classname == "player"){
      if(sub.p_class != P_OBS){
        if(sub != self){
          if(sub.faction == contact.faction){
            local float dist, mod;
            dist = vlen(sub.origin - contact.origin);
            if(dist == 0){
              dist = 1;
            }
            mod = 1 / (dist * dist);
            total = total + mod;
          }
        }
      }
    }
    sub = sub.chain;
  }
  return total;
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