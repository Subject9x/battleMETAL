/*
mech Mod
Author: Peter Roohr
Date: 11/02/2016
Overview: hud data ents field vars
*/

//SendEnt constants
float E_NAV = 1;
float E_OBJ = 2;
float E_AIU = 3;
float E_BLD = 4;
float E_VEC = 5;
float E_MEC = 6;
float E_DEP = 7;

//Damage types
float DMG_BAL = 1;  //ballstic damage
float DMG_ENE = 2;  //energy damage
float DMG_EXP = 4;  //explosive damage
float DMG_MSC = 128; //up to the weapon
float EFF_PRC = 8;  //piercing damage
float EFF_RAM = 16; //dmg is doubled
float EFF_STX = 32; //dmg only affects shields
float EFF_ENG = 64; //dmg only affects energy

//Armor Types
float ARM_LIT = 2;  //light armor
float ARM_MED = 4;  //heavy armor;
float ARM_HVY = 8;  //radiation armor
float ARM_CER = 16; 
float ARM_RAD = 24;

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
.float plr_nex_grp4;
.float plr_nex_grp5;
.float plr_nav_pnt;
.float plr_sel_hrpnt_size;
.float plr_sel_hrpnt_types;
.float plr_menu_choice; 

.float wep1_reload;
.vector show_box_pos;
.vector show_box_sz;
.vector show_box_color;
.float show_box_life;

.entity wdg_sh; //shield widget
.entity wdg_en; //energy widget
.entity wdg_pd; //paper doll widget
.entity wdg_wp; //weapons list widget

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
.float hardpoint_cnt;
//mech
.float hp_ctor;
.float hp_stor;
.float hp_stor2;
.float hp_arm;
.float hp_arm2;
.float hp_leg;
.float radar_range;

//weapon
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
.float p_class;
.float sh_cur;
.float stat_rdr_mode;