/*
mech Mod
Author: Subject9x
Date: 11/02/2016
Overview: hud data ents field vars
*/

.float plr_sel_mech; //used for mech selection
.float plr_sel_hrpnt;
.float plr_sel_wep;
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

//widget vars - flat-tree approach
//ie - only 'animated / info-changing' stuff should be their own ent
//static images are just that
/*.string en_pnl_img;
.vector en_pnl_org;
.vector en_pnl_ofs;
.float  en_pnl_aln;

.string sh_pnl_img;
.vector sh_pnl_org;
.vector sh_pnl_ofs;
.float  sh_pnl_aln;

.string am_pnl_img;
.vector am_pnl_org;
.vector am_pnl_ofs;
.float  am_pnl_aln;

.string sp_pnl_img;
.vector sp_pnl_org;
.vector sp_pnl_ofs;
.float  sp_pnl_aln;

.string wp_pnl_img;
.vector wp_pnl_org;
.vector wp_pnl_ofs;
.float  wp_pnl_aln;

.string rd_pnl_img;
.vector rd_pnl_org;
.vector rd_pnl_ofs;
.float  rd_pnl_aln;

.string tg_pnl_img;
.vector tg_pnl_org;
.vector tg_pnl_ofs;
.float tg_pnl_aln;*/

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






