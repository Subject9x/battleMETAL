/*
mech Mod
Author: Peter Roohr
Date: 3/2/2018
Overview: ai objects used for map logic
*/

void() ai_logic_changeFaction_use={
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
  if(self.w_state == 1){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
  }
};

void() ai_logic_changeOrder_use={
  local entity e;
  if(self.group){
    e = findchain(group, self.group);
    while(e){
      e.state_1 = self.state_1;
      ai_util_firstOrder_nonStatic(e.state_1);
      e = e.chain;
    }
  }
  if(self.target){
    e = find(world, targetname, self.target);
    if(e){
      e.state_1 = self.state_1;
      ai_util_firstOrder_nonStatic(e.state_1);
    }
  }
  if(self.w_state == 1){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
  }
};

void() ai_logic_changeRank_use={
  local entity e, this;
  if(self.group){
    e = findchain(group, self.group);
    while(e){
      self = e;
        self.p_damage = this.p_damage;
        if (!self.yaw_speed){
          local float m;
          m = ai_pilot_yaw_mod();
          self.yaw_speed = self.m_rot_speed - (self.m_rot_speed * m);
        }
        self.ai_leading = ai_pilot_rating_leading();
        self.stat_spr_x = self.conv_min_x + self.conv_max_x;
        self.stat_spr_y = self.conv_min_y + self.conv_max_y;
        self.ai_rte_cnv = ai_pilot_rating_converg();
        self.ai_rte_rng = ai_pilot_rating_range();
      self = this;
      e = e.chain;
    }
  }
  if(self.target){
    e = find(world, targetname, self.target);
    if(e){
      self = e;
        self.p_damage = this.p_damage;
        if (!self.yaw_speed){
          local float m;
          m = ai_pilot_yaw_mod();
          self.yaw_speed = self.m_rot_speed - (self.m_rot_speed * m);
        }
        self.ai_leading = ai_pilot_rating_leading();
        self.stat_spr_x = self.conv_min_x + self.conv_max_x;
        self.stat_spr_y = self.conv_min_y + self.conv_max_y;
        self.ai_rte_cnv = ai_pilot_rating_converg();
        self.ai_rte_rng = ai_pilot_rating_range();
      self = this;
    }
  }
  if(self.w_state == 1){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
  }
};

void() ai_logic_changeStyle_use={
  local entity e;
  if(self.group){
    e = findchain(group, self.group);
    while(e){
      e.state_1 = self.ai_style;
      e = e.chain;
    }
  }
  if(self.target){
    e = find(world, targetname, self.target);
    if(e){
      e.state_1 = self.ai_style;
    }
  }
  if(self.w_state == 1){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
  }
};

void() ai_logic_changeType_use={
  local entity e;
  if(self.group){
    e = findchain(group, self.group);
    while(e){
      e.state_1 = self.ai_type;
      e = e.chain;
    }
  }
  if(self.target){
    e = find(world, targetname, self.target);
    if(e){
      e.state_1 = self.ai_type;
    }
  }
  if(self.w_state == 1){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
  }
};

void() ai_spawner_use={
  if ( self.isActive ){
    self.isActive = FALSE; 
  }
  else{
    if( self.count2 > 0 ){
      if( self.count3 > 0 ){
        self.isActive = TRUE;
      }
    }
    else{
      self.isActive = TRUE;
    }
  }
};


void() ai_spawner_think={
  local float bSpawn;
  bSpawn = FALSE;
  if( self.isActive ){
    if( time > self.count4 ){
      if( self.count2 > 0 ){
        if( self.count3 > 0 ){
          bSpawn = TRUE;
          self.count3 = self.count3 - 1;
        }
      }
      else{
        bSpawn = TRUE;
      }
    }
  }
  
  if(bSpawn){
    ai_spawner_activate();
    self.count4 = time + self.delay;
  }
      
  self.think = ai_spawner_think;
  self.nextthink = time + 0.1;
};

void() ai_spawner_activate={
  local entity bot, this;
  bot = spawn();
  this = self;
  self = bot;
    setorigin(self, this.origin);
    self.angles = this.angles;
    self.i_faction = this.i_faction;
    self.p_damage = this.p_damage;
    self.ai_style = this.ai_style;
    self.ai_type = this.ai_type;
    self.target = this.target;
    self.target_die = this.target_die;
    self.group = this.w_name;
    self.state_1 = this.state_1;
    self.nextVecChoice = this.nextVecChoice;
    self.vec_size = this.vec_size;
    self.next_wepn1 = this.next_wepn1;
    self.next_wepn2 = this.next_wepn2;
    self.next_wepn3 = this.next_wepn3;
    self.next_wepn4 = this.next_wepn4;
    self.next_wepn5 = this.next_wepn5;
    self.next_wepn6 = this.next_wepn6;
    self.next_wepn7 = this.next_wepn7;
    self.next_wepn8 = this.next_wepn8;
    self.next_wepn9 = this.next_wepn9;
    self.mskin = this.mskin;
    ai_mech();
  self = this;
};

/*QUAKED ai_spawner (0.45 0.45 0.45) (-15 -15 -15) (15 15 15) START_ON
a bit more controllable ai spawn mechanism
"delay" - interval if INTERVAL is checked
"count1" - initial delay when activated
"count2" - max times it can be used, otherwise it wont stop unless shut off
"target" - gives spawned AI a target
"targetname" - callable from other triggers
"nextVecChoice" : number, match to mech data id
"vec_size" : number, weight class for mech data
"i_faction" : bitflags for faction which faction
"w_name" - assigns a groupId to this ai
"state_1" : number, initial order
  -1 = debug mode (stand still, no interaction)
  1 = stand at the .target
  2 = defend the .target
  3 = patrol the .target
  4 = attack the .target
"p_damage" : number,AI pilot rating, will affect accuracy
  0 = ACE 
  1 = VETERAN
  2 = REGULAR
  3 = ROOKIE
"ai_style" : AI's combat style
  0, or none = skirmisher - normal movement
  1 = sniper - tries to stay at long range
  2 = brawler - always stays up close to target
  3 = flanker - tries to get behind player
  4 = stalker - extra patience when hunting targets
  5 = random of 1-4
"ai_type" : AI's personality
  0, or none = normal
  1 = aggressive - will always run around, stay in fight
  2 = rescue - tries to save friendlies by pulling aggro
  3 = coward - will run away or to friends easily
  4 = random of 1-4
"next_wepn1" : float, data_idx for weapon slot
    this goes to next_wepn9
*/
void() ai_spawner={
  if( (self.spawnflags & 1) ){
    self.isActive = TRUE;
  }
  else{
    self.isActive = FALSE;
  }
  if(self.count2 > 0){
    self.count3 = self.count2;
  }
  self.th_missile = ai_spawner_activate;
  self.think = ai_spawner_think;
  self.use = ai_spawner_use;
  self.nextthink = time + 0.001;
};

/*QUAKED ai_logic_changeFaction (.25 .25 .25) (-5 -5 -5) (5 5 5)
changes the i_faction field of targted items
set .group for use with groups of items
set .target to specicify by targetname
set .w_state = 1 to have this remove after firing
*/
void() ai_logic_changeFaction={
  self.use = ai_logic_changeFaction_use;
};

/*QUAKED ai_logic_changeOrder (.25 .25 .25) (-5 -5 -5) (5 5 5)
changes the i_faction field of targted items
set .group for use with groups of items
set .target to specicify by targetname
set .w_state = 1 to have this remove after firing
"state_1" : number, initial order
  -1 = debug mode (stand still, no interaction)
  1 = stand at the .target
  2 = defend the .target
  3 = patrol the .target
  4 = attack the .target
*/
void() ai_logic_changeOrder={
  self.use = ai_logic_changeOrder_use;
};

/*QUAKED ai_logic_changeRank (.25 .25 .25) (-5 -5 -5) (5 5 5)
changes the i_faction field of targted items
set .group for use with groups of items
set .target to specicify by targetname
set .w_state = 1 to have this remove after firing
"p_damage" : number,AI pilot rating, will affect accuracy
  0 = ACE 
  1 = VETERAN
  2 = REGULAR
  3 = ROOKIE
*/
void() ai_logic_changeRank={
  self.use = ai_logic_changeRank_use;
};

/*QUAKED ai_logic_changeStyle (.25 .25 .25) (-5 -5 -5) (5 5 5)
changes the i_faction field of targted items
set .group for use with groups of items
set .target to specicify by targetname
set .w_state = 1 to have this remove after firing
"ai_style" : AI's combat style
  0, or none = skirmisher - normal movement
  1 = sniper - tries to stay at long range
  2 = brawler - always stays up close to target
  3 = flanker - tries to get behind player
  4 = stalker - extra patience when hunting targets
  5 = random of 1-4
*/
void() ai_logic_changeStyle={
  self.use = ai_logic_changeStyle_use;
};

/*QUAKED ai_logic_changeType (.25 .25 .25) (-5 -5 -5) (5 5 5)
changes the i_faction field of targted items
set .group for use with groups of items
set .target to specicify by targetname
set .w_state = 1 to have this remove after firing
"ai_type" : AI's personality
  0, or none = normal
  1 = aggressive - will always run around, stay in fight
  2 = rescue - tries to save friendlies by pulling aggro
  3 = coward - will run away or to friends easily
  4 = random of 1-4
*/
void() ai_logic_changeType={
  self.use = ai_logic_changeType_use;
};

