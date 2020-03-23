/*
battleMETAL
Author: Peter Roohr
Date: 03/23/2020
Overview: 
  CSQC-side animations for power plant
*/

/*
  DEATH
*/
void() power_plant_die1={
  local vector margin;

  margin = randompos(self.absmin * 1.5, self.absmax * 1.5);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) );
  
  pointsound( margin, "sound/weapons/esr_fire.ogg", (0.33 + random() * 0.33), ATTN_NORM);
  
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
  
  pointsound( margin, "sound/weapons/esr_fire.ogg", (0.4 + random() * 0.33), ATTN_NORM);
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
  
  pointsound( margin, "sound/weapons/esr_fire.ogg", (0.5 + random() * 0.33), ATTN_NORM);
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
  
  pointsound( margin, "sound/weapons/esr_fire.ogg", (0.5 + random() * 0.33), ATTN_NORM);
  self.think = power_plant_die8;
  self.nextthink = time + 0.1;
};

void() power_plant_die8={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  
  pointsound( margin, "sound/weapons/esr_fire.ogg", (0.5 + random() * 0.33), ATTN_NORM);
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
  pointsound( margin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  
  self.think = power_plant_die11;
  self.nextthink = time + 0.1;
};

void() power_plant_die11={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  
  pointsound( margin, "sound/weapons/esr_fire.ogg", (0.6 + random() * 0.33), ATTN_NORM);
  pointsound( margin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = power_plant_die12;
  self.nextthink = time + 0.1;
};

void() power_plant_die12={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  pointsound( margin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = power_plant_die13;
  self.nextthink = time + 0.1;
};

void() power_plant_die13={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  
  pointsound( margin, "sound/weapons/esr_fire.ogg", (0.6 + random() * 0.33), ATTN_NORM);
  pointsound( margin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = power_plant_die14;
  self.nextthink = time + 0.1;
};
void() power_plant_die14={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  
  pointsound( margin, "sound/weapons/esr_fire.ogg", (0.6 + random() * 0.33), ATTN_NORM);
  pointsound( margin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = power_plant_die15;
  self.nextthink = time + 0.1;
};
void() power_plant_die15={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  
  pointsound( margin, "sound/weapons/esr_fire.ogg", (0.6 + random() * 0.33), ATTN_NORM);
  pointsound( margin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = power_plant_die16;
  self.nextthink = time + 0.1;
};
void() power_plant_die16={
  local vector margin;

  margin = randompos(self.absmin, self.absmax);
  
  te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
  te_field_mineral_light( margin, rint(random()*3) ) ;
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  
  pointsound( margin, "sound/weapons/esr_fire.ogg", (0.6 + random() * 0.33), ATTN_NORM);
  pointsound( margin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  
  self.think = sendevent_building_die;
  self.nextthink = time + 0.1;
};