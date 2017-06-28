/*
mech mod
Author: Subject9x
Date: 8/27/2016
      mod  3/15/2017
Overview: 'class' for weapon data /ents

commented vars mean they're already implemented and are here for reference!
*/
.string fire_sound;

//.string faction;
//.float i_techLevel;
//.string data_type;

//.health;
//.max_health;
//.armortype;
//.armorvalue
.float state_1;
.float state_2;
.void() w_attack;     //actual attack func
.void() w_think;     //implementable update function
.vector w_fire_ofs;     //offset for proj. origin
.vector w_adj_ang;      //rotate weapon model face correctly
.string w_name;       //label for weapon, need to keep 'classname' reserved for actual class
.float w_proj;       //pointer to projectile entity data
.float w_firerate;
.float w_firemod;     //used for modifying fire rate;
.float w_firemoddur;  //duration of effect;
.float w_firetime;
.float w_currentammo;
.float w_clipsize;
.float w_isready;
.float w_group;     //weapon group, only 1-3 - SET BY PARENT
.vector fx_origin;
.float w_range;
.float w_isburst;   //ugh
.float w_state; //double ugh