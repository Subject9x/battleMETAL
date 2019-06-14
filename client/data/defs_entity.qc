/*
battleMETAL
Author: Peter Roohr
Date: 11/02/2016
mod:  05/16/2019
Overview: 
  CSQC definition extensions for battleMETAL.
  Extends {entity} with new vars for use around CSQC.
*/

entity CLIENTDATA;

.vector entorg;
.entity client_data;
.entity viewmodel;

.float target_faction;
.float target_vecsize;
.float target_datatype;
.float target_shield;

.float timer_phys;
.float timer_r;
.vector origin_old;
.vector origin_phys;       

vector vPlayerOrigin;
vector vPlayerOriginOld;
vector vPlayerVelocity;

.float renderflags;
.float pmove_flags;

//widget vars
.string c_mdl;
.string c_ui_hf;
.float scale;
.string img1;
.string img2;
.vector img1_sz;
.vector img2_sz;
.float() actionCallback;
.float drawme;
.vector drawsize;
.vector drawcolor1; //these are interpreted differently
.vector drawcolor2; //depending on widget type :/
.float value1; //lists are for suckers
.float value2;
.float value3;
.float value4;
.float value5;
.float value6;

//mech
.float hp_ctor;
.float hp_stor;
.float hp_stor2;
.float hp_arm;
.float hp_arm2;
.float hp_leg;

//navpoint
.float obj_status;
.float controllingFaction;
.float isActive;
.float nav_name;
.vector ui_org;
.vector ui_size;

//objectives
.string obj_desc;

//ai mech
.string e_model;