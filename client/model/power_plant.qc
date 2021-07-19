/*
battleMETAL
Author: Peter Roohr
Date: 03/23/2020
Overview: 
  CSQC-side animations for power plant
*/


/*
  Shield Generator - IDLE
*/
void() power_plant_idle={
  local vector smoke;
  if( self.energy > 0 ){
    self.think = power_plant_active;
    self.nextthink = time + 1;
    return;
  }
  
  makevectors(self.angles);
  smoke = self.origin + (v_up * (self.maxs_z * 0.33)) + (v_right * self.mins_x * 0.75) + (v_forward * self.maxs_y);
  
  self.think = power_plant_idle;
  self.nextthink = time + 1;
};

/*
  Shield Generator - IDLE
*/
void() power_plant_active={
  local vector vfx, vfx2, vfx3;
  
  if( self.energy <= 0 ){
    self.think = power_plant_idle;
    self.nextthink = time + 0.1;
    return;
  }
  
  //local vfx - green ball
  vfx = randompos( self.compAltOffset, self.compOffset);
  te_field_rad( vfx, normalize(self.origin - vfx), 0.5 );
  
  //local vfx - blue vent front
  vfx2 = randompos(self.wepFireOffset, self.wepFireOffsetCache);
  te_field_mineral( vfx2, normalize(self.origin - vfx2), 1 );
    
  //local vfx - blue vent front
  vfx3 = randompos(self.cockpitOffset, self.w_adj_ang);
  te_field_mineral( vfx3, normalize(self.origin - vfx3), 1 );
   
  self.think = power_plant_active;
  self.nextthink = time + (random() * 1);
};


/*
  DEATH
*/
void() power_plant_die1={
  local vector margin;
  
  self.solid = SOLID_NOT;
  
  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) );
  
  sound7(self, CHAN_AUTO, "sound/weapons/esr_fire.ogg", 1, ATTN_NORM, (0.5 + (random() * 0.5)) * 175, 0 );
  
  self.think = power_plant_die2;
  self.nextthink = time + 0.1;
};

void() power_plant_die2={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  self.think = power_plant_die3;
  self.nextthink = time + 0.1;
};

void() power_plant_die3={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  
  sound7(self, CHAN_AUTO, "sound/weapons/esr_fire.ogg", 1, ATTN_NORM, (0.5 + (random() * 0.5)) * 175, 0 );
  self.think = power_plant_die4;
  self.nextthink = time + 0.1;
};

void() power_plant_die4={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  self.think = power_plant_die5;
  self.nextthink = time + 0.1;
};

void() power_plant_die5={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  
  sound7(self, CHAN_AUTO, "sound/weapons/esr_fire.ogg", 1, ATTN_NORM, (0.5 + (random() * 0.5)) * 175, 0 );
  self.think = power_plant_die6;
  self.nextthink = time + 0.1;
};

void() power_plant_die6={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  self.think = power_plant_die7;
  self.nextthink = time + 0.1;
};

void() power_plant_die7={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  
  sound7(self, CHAN_AUTO, "sound/weapons/esr_fire.ogg", 1, ATTN_NORM, (0.5 + (random() * 0.5)) * 175, 0 );
  self.think = power_plant_die8;
  self.nextthink = time + 0.1;
};

void() power_plant_die8={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  
  sound7(self, CHAN_AUTO, "sound/weapons/esr_fire.ogg", 1, ATTN_NORM, (0.5 + (random() * 0.5)) * 175, 0 );
  self.think = power_plant_die9;
  self.nextthink = time + 0.1;
};

void() power_plant_die9={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  self.think = power_plant_die10;
  self.nextthink = time + 0.10;
};

void() power_plant_die10={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  building_sound_explode();
  
  self.think = power_plant_die11;
  self.nextthink = time + 0.1;
};

void() power_plant_die11={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  
  sound7(self, CHAN_AUTO, "sound/weapons/esr_fire.ogg", 1, ATTN_NORM, (0.5 + (random() * 0.5)) * 175, 0 );
  building_sound_explode();
  self.think = power_plant_die12;
  self.nextthink = time + 0.1;
};

void() power_plant_die12={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  building_sound_explode();
  self.think = power_plant_die13;
  self.nextthink = time + 0.1;
};

void() power_plant_die13={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  
  sound7(self, CHAN_AUTO, "sound/weapons/esr_fire.ogg", 1, ATTN_NORM, (0.5 + (random() * 0.5)) * 175, 0 );
  building_sound_explode();
  self.think = power_plant_die14;
  self.nextthink = time + 0.1;
};
void() power_plant_die14={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  
  sound7(self, CHAN_AUTO, "sound/weapons/esr_fire.ogg", 1, ATTN_NORM, (0.5 + (random() * 0.5)) * 175, 0 );
  building_sound_explode();
  self.think = power_plant_die15;
  self.nextthink = time + 0.1;
};
void() power_plant_die15={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  
  sound7(self, CHAN_AUTO, "sound/weapons/esr_fire.ogg", 1, ATTN_NORM, (0.5 + (random() * 0.5)) * 175, 0 );
  building_sound_explode();
  self.think = power_plant_die16;
  self.nextthink = time + 0.1;
};
void() power_plant_die16={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  
  sound7(self, CHAN_AUTO, "sound/weapons/esr_fire.ogg", 1, ATTN_NORM, (0.5 + (random() * 0.5)) * 175, 0 );
  building_sound_explode();
  
  self.think = sendevent_building_die;
  self.nextthink = time + 0.1;
};