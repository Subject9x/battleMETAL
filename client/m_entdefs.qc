/*
mech Mod
Author: Subject9x
Date: 11/02/2016
Overview: hud data ents field vars
*/

float DATA_HUD = 0;

float OBJ_METER = 0;
float OBJ_SQURS = 1;
float OBJ_SPHRS = 2;

.entity wdg_sh; //shield widget
.entity wdg_en; //energy widget
.entity wdg_pd; //paper doll widget
.entity wdg_wp; //weapons list widget

.string c_mdl;
.float data_idx;
.float data_type;
.float obj_type;
.float scale;
.string hud_img;
.float() actionCallback;
.float drawme;
.vector drawsize;
.vector drawcolor1;
.vector drawcolor2;
.float value1;
.float value2;
.float value3;
.float value4;
.float value5;
.float value6;



