/*
mech Mod
Author: Peter Roohr
Date: 3/2/2018
Overview: ai objects used for map logic
*/

void() ai_change_faction_use={
  local entity e;
  if(self.group){
    e = findchain(group, self.group);
    while(e){
      e.i_faction = self.i_faction;
      e = e.chain;
    }
  }
  if(self.target){
    e = find(world, targetname, self.target);
    if(e){
      e.i_faction = self.i_faction;
    }
  }
  if( (self.spawnflags & 2) ){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
  }
};

void() ai_change_rank_use={
  local entity e, this;
  if(self.group){
    e = findchain(group, self.group);
    while(e){
      self = e;
        self.ai_rank = this.ai_rank;
        if (!self.yaw_speed){
          local float m;
          m = ai_pilot_yaw_mod();
          self.yaw_speed = self.m_rot_speed - (self.m_rot_speed * m);
        }
        self.ai_leading = ai_pilot_rating_leading();
      self = this;
      e = e.chain;
    }
  }
  if(self.target){
    e = find(world, targetname, self.target);
    if(e){
      self = e;
        self.ai_rank = this.ai_rank;
        if (!self.yaw_speed){
          local float m;
          m = ai_pilot_yaw_mod();
          self.yaw_speed = self.m_rot_speed - (self.m_rot_speed * m);
        }
        self.ai_leading = ai_pilot_rating_leading();
      self = this;
    }
  }
  if( (self.spawnflags & 2) ){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
  }
};

/*QUAKED ai_change_faction(0.988 0.976 0.267) (-4 -4 -6) (4 4 6) - REMOVE_ONUSE
changes the i_faction field of the targeted objects

-------- KEYS -------- 
.group = <string> [group] objects with this groupId will be affected
.target = <string> [targetname] objects with this targetname will be affected
-------- SPAWNFLAGS -------- 
REMOVE_ONUSE 2 - removed after its first use.
*/
void() ai_change_faction={
  
  setsize( self, '-3 -3 -3', '3 3 3' );
  setorigin( self, self.origin );
  self.use = ai_change_faction_use;
};

/*QUAKED ai_change_rank (.25 .25 .25) (-5 -5 -5) (5 5 5)
changes the i_faction field of the targeted objects

-------- KEYS -------- 
.group = <string> [group] objects with this groupId will be affected
.target = <string> [targetname] objects with this targetname will be affected
.ai_rank = <float> [rank] rank to change the targets ai_rank to.
-------- SPAWNFLAGS -------- 
REMOVE_ONUSE 2 - removed after its first use.
*/
void() ai_change_rank={

  setsize( self, '-3 -3 -3', '3 3 3' );
  setorigin( self, self.origin );
  self.use = ai_change_rank_use;
};
