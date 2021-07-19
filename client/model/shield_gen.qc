/*
battleMETAL
Author: Peter Roohr
Date: 03/23/2020
Overview: 
  CSQC-side animations for shield generator
*/


/*
  Shield Generator - IDLE
*/
void() shield_gen_idle={
  if( self.energy > 0 ){
    self.think = shield_gen_active;
    self.nextthink = time + 1;
    return;
  }
  
  self.think = shield_gen_idle;
  self.nextthink = time + 1;
};

/*
  Shield Generator - IDLE
*/

void() shield_gen_active={
  local vector vfx, vfx2;
  
  if( self.energy <= 0 ){
    self.think = shield_gen_idle;
    self.nextthink = time + 0.1;
    return;
  }
  
  vfx = randompos(self.compOffset, self.compAltOffset);
  vfx2= randompos(self.compOffset, self.compAltOffset);
  
  te_field_quantum( vfx2, vfx );
  if( random() > 0.67 ){
    te_field_quantum_light( vfx2, 0.5) ;
  }  
  self.think = shield_gen_active;
  self.nextthink = time + (random() * 1.5);
  
};

/*
  Shield Generator - DEATH
*/
void() shield_gen_die1={
  local vector margin;
  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  te_field_quantum( randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)), randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)) );
  te_field_quantum_light( margin, rint(random()*5) ) ;
  
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.99 0.15 0.85', -0.02 );
  
  sound7(self, CHAN_AUTO, "sound/weapons/qrfl_fire.ogg", 1, ATTN_NORM, (0.1 + (random() * 0.9)) * 200, 0 );
  building_sound_explode();
  
  self.scale = self.scale - 0.01;
  self.alpha = self.alpha - 0.01;
  self.think = shield_gen_die2;
  self.nextthink = time + 0.1;
};

void() shield_gen_die2={
  local vector margin;

  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  te_field_quantum( randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)), randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)) );
  te_field_quantum_light( margin, rint(random()*5) ) ;
  
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.99 0.15 0.85', -0.02 );
  sound7(self, CHAN_AUTO, "sound/weapons/qrfl_fire.ogg", 1, ATTN_NORM, (0.1 + (random() * 0.9)) * 200, 0 );
  building_sound_explode();
  self.scale = self.scale - 0.01;
  self.alpha = self.alpha - 0.01;
  
  self.think = shield_gen_die3;
  self.nextthink = time + 0.1;
};

void() shield_gen_die3={
  local vector margin;

  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  te_field_quantum( randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)), randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)) );
  te_field_quantum_light( margin, rint(random()*5) ) ;
  
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.99 0.15 0.85', -0.02 );
  sound7(self, CHAN_AUTO, "sound/weapons/qrfl_fire.ogg", 1, ATTN_NORM, (0.1 + (random() * 0.9)) * 200, 0 );
  self.scale = self.scale - 0.01;
  self.alpha = self.alpha - 0.01;
  
  self.think = shield_gen_die4;
  self.nextthink = time + 0.1;
};

void() shield_gen_die4={
  local vector margin;

  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  te_field_quantum( randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)), randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)) );
  te_field_quantum_light( margin, rint(random()*5) ) ;
  
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.99 0.15 0.85', -0.02 );
  sound7(self, CHAN_AUTO, "sound/weapons/qrfl_fire.ogg", 1, ATTN_NORM, (0.1 + (random() * 0.9)) * 200, 0 );
  self.scale = self.scale - 0.01;
  self.alpha = self.alpha - 0.01;
  
  self.think = shield_gen_die5;
  self.nextthink = time + 0.1;
};

void() shield_gen_die5={
  local vector margin;

  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  te_field_quantum( randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)), randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)) );
  te_field_quantum_light( margin, rint(random()*5) ) ;
  
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.99 0.15 0.85', -0.02 );
  sound7(self, CHAN_AUTO, "sound/weapons/qrfl_fire.ogg", 1, ATTN_NORM, (0.1 + (random() * 0.9)) * 200, 0 );
  building_sound_explode();
  self.scale = self.scale - 0.01;
  self.alpha = self.alpha - 0.01;
  
  self.think = shield_gen_die6;
  self.nextthink = time + 0.1;
};

void() shield_gen_die6={
  local vector margin;

  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  te_field_quantum( randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)), randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)) );
  te_field_quantum_light( margin, rint(random()*5) ) ;
  
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.99 0.15 0.85', -0.02 );
  sound7(self, CHAN_AUTO, "sound/weapons/qrfl_fire.ogg", 1, ATTN_NORM, (0.1 + (random() * 0.9)) * 200, 0 );
  self.scale = self.scale - 0.01;
  self.alpha = self.alpha - 0.01;
  
  self.think = shield_gen_die7;
  self.nextthink = time + 0.1;
};

void() shield_gen_die7={
  local vector margin;

  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  te_field_quantum( randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)), randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)) );
  te_field_quantum_light( margin, rint(random()*5) ) ;
  
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.99 0.15 0.85', -0.02 );
  sound7(self, CHAN_AUTO, "sound/weapons/qrfl_fire.ogg", 1, ATTN_NORM, (0.1 + (random() * 0.9)) * 200, 0 );
  self.scale = self.scale - 0.01;
  self.alpha = self.alpha - 0.01;
  
  self.think = shield_gen_die8;
  self.nextthink = time + 0.1;
};

void() shield_gen_die8={
  local vector margin;

  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  te_field_quantum( randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)), randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)) );
  pointparticles( particleeffectnum("TE_EMP_EXPL"), margin, normalize(margin - self.origin) * 1.1, 1);
  
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.99 0.15 0.85', -0.02 );
  sound7(self, CHAN_AUTO, "sound/weapons/qrfl_fire.ogg", 1, ATTN_NORM, (0.1 + (random() * 0.9)) * 200, 0 );
  building_sound_explode();
  self.scale = self.scale - 0.01;
  self.alpha = self.alpha - 0.01;
  
  self.think = shield_gen_die9;
  self.nextthink = time + 0.1;
};

void() shield_gen_die9={
  local vector margin;

  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  te_field_quantum( randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)), randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)) );
  pointparticles( particleeffectnum("TE_EMP_EXPL"), margin, normalize(margin - self.origin) * 1.1, 1);
  
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.99 0.15 0.85', -0.02 );
  building_sound_explode();
  self.scale = self.scale - 0.01;
  self.alpha = self.alpha - 0.01;
  
  self.think = shield_gen_die10;
  self.nextthink = time + 0.1;
};

void() shield_gen_die10={
  local vector margin;

  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  te_field_quantum( randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)), randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)) );
  pointparticles( particleeffectnum("TE_EMP_EXPL"), margin, normalize(margin - self.origin) * 1.1, 1);
  self.scale = self.scale - 0.01;
  self.alpha = self.alpha - 0.01;
  
  self.think = shield_gen_die11;
  self.nextthink = time + 0.1;
};

void() shield_gen_die11={
  local vector margin;

  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  te_field_quantum( randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)), randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)) );
  pointparticles( particleeffectnum("TE_EMP_EXPL"), margin, normalize(margin - self.origin) * 1.1, 1);
  building_sound_explode();
  
  self.scale = self.scale - 0.01;
  self.alpha = self.alpha - 0.01;
  
  self.think = shield_gen_die12;
  self.nextthink = time + 0.1;
};

void() shield_gen_die12={
  local vector margin;

  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  pointparticles( particleeffectnum("TE_EMP_EXPL"), margin, normalize(margin - self.origin) * 1.1, 1);
  
  self.think = shield_gen_die13;
  self.nextthink = time + 0.1;
};

void() shield_gen_die13={
  local vector margin;

  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  pointparticles( particleeffectnum("TE_EMP_EXPL"), margin, normalize(margin - self.origin) * 1.1, 1);
  
  self.think = shield_gen_die14;
  self.nextthink = time + 0.1;
};

void() shield_gen_die14={
  local vector margin;

  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  pointparticles( particleeffectnum("TE_EMP_EXPL"), margin, normalize(margin - self.origin) * 1.1, 1);
  
  self.think = shield_gen_die15;
  self.nextthink = time + 0.1;
};

void() shield_gen_die15={
  local vector margin;

  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  pointparticles( particleeffectnum("TE_EMP_EXPL"), margin, normalize(margin - self.origin) * 1.1, 1);
  
  self.think = shield_gen_die16;
  self.nextthink = time + 0.1;
};

void() shield_gen_die16={
  local vector margin;

  margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));
  
  pointparticles( particleeffectnum("TE_EMP_EXPL"), margin, normalize(margin - self.origin) * 1.1, 1);
  
  self.think = sendevent_building_die;
  self.nextthink = time + 0.1;
};