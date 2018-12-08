/*
mech Mod
Author: Peter Roohr
Date: 11/02/2016
Overview: hud data ents field vars
*/

entity CLIENTDATA;

.vector entorg;
.entity client_data;
.entity viewmodel;

.float sh_cur;
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

//Armor Types
float ARM_LIT = 2;  //light armor
float ARM_MED = 4;  //heavy armor;
float ARM_HVY = 8;  //radiation armor
float ARM_CER = 16; 
float ARM_RAD = 24;

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

.vector w1_ofs;
.vector w2_ofs;
.vector w3_ofs;
.vector w4_ofs;
.vector w5_ofs;
.vector w6_ofs;
.vector w7_ofs;
.vector w8_ofs;
.vector w9_ofs;

.float dmg_type;
.float dmg_amt;
//mech
.float en_cur;
.float sh_cur;
.float hp_ctor;
.float hp_stor;
.float hp_stor2;
.float hp_arm;
.float hp_arm2;
.float hp_leg;
.float radar_range;

//weapon
.float en_rate;
.float rl_max;
.float i_techlvl; //what is the appropriate tech level of the unit? this is also used for levels 
.float i_reserve; //how many reserve points does the unit cost?
.float i_size;
.float i_faction;
.float w_range;
.string note1;
.string note2;
.string note3;
.string note4;
.string w_icon;

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