/*
mech Mod
Author: Subject9x
Date: 11/02/2016
Overview: hud data ents field vars
*/

.float plr_sel_mech; //used for mech selection
.float plr_sel_hrpnt;
.float plr_sel_wep;
.float plr_sel_wid;
.float plr_sel_grp;
.float plr_nex_mech;
.float plr_nex_wep1;
.float plr_nex_wep2;
.float plr_nex_wep3;
.float plr_nex_wep4;
.float plr_nex_wep5;
.float plr_nex_wep6;
.float plr_nex_wep7;
.float plr_nex_wep8;
.float plr_nex_wep9;
.float plr_nex_grp1;
.float plr_nex_grp2;
.float plr_nex_grp3;

.entity wdg_sh; //shield widget
.entity wdg_en; //energy widget
.entity wdg_pd; //paper doll widget
.entity wdg_wp; //weapons list widget

//widget vars
.string c_mdl;
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






