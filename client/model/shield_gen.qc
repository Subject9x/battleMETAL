/*
battleMETAL
Author: Peter Roohr
Date: 03/23/2020
Overview: 
  CSQC-side animations for shield generator
*/


/*
  Shield Generator - DEATH
*/
void() shield_gen_die1={
  local vector margin;

  margin = randompos(self.absmin * 1.5, self.absmax * 1.5);
  
  te_field_quantum( randompos(self.absmin * 1.5, self.absmax * 1.5), randompos(self.absmin * 1.5, self.absmax * 1.5) );
  te_field_quantum_light( margin, rint(random()*5) ) ;
  
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '0.33 1 2', 0.0075 );
  self.think = shield_gen_die1;
  self.nextthink = time + 0.1;
};

void() shield_gen_die2;

void() shield_gen_die3;

void() shield_gen_die4;

void() shield_gen_die5;

void() shield_gen_die6;

void() shield_gen_die7;

void() shield_gen_die8;

void() shield_gen_die9;

void() shield_gen_die10;

void() shield_gen_die11;

void() shield_gen_die12;

void() shield_gen_die13;

void() shield_gen_die14;

void() shield_gen_die15;

void() shield_gen_die16;