/*
mech Mod
Author: Subject9x
Date: 01/21/2017
Overview: definition file for building entities
*/

//import
/*
.float sh_max;    //max shields
.float sh_cur;    //current amount of shields
.float sh_rate;   //shield recharge rate
.float sh_hit;
.float faction;   //which faction? consult table
.float en_max;    //max amount
.float en_cur;    //current amount
.float en_rate;   //how much energy built per frame
.void() th_ctrl;  //controller function
.float data_idx;
.string c_model;
.string c_name;
.vector c_bbx_n;    //min / max of bbox
.vector c_bbx_x;
.health;
.max_health;
.armortype;
.armorvalue
*/

.float eff_output;  //type of effect output - power or shields
.float eff_radius; //the radius of the effect


