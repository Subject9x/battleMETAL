/*
mech Mod
Author: Subject9x
Date: 2/17/2017
Overview: the interface for hud rendering
every hud ent has to implement this format
*/

.entity data;
.entity hud_pnl1;
.entity hud_pnl2;
.entity hud_pnl3;
.entity hud_pnl4;
.entity hud_pnl5;
.entity hud_pnl6;
.entity hud_pnl7;
.entity hud_pnl8;
.entity hud_pnl9;

.float prev_ang;
.vector nav_ofs;

.void(entity vec_data) hud_prep;
.void(vector view_x, vector view_ctr) hud_HelmetImage;
.void(float pvid, float lockval, float conv_x, float conv_y, float pitch) hud_renderCrosshairs;  
.void(float shieldval) hud_playerShield;
.void(float energyval) hud_playerEnergy;
.void(float ct, float lt, float rt, float la, float ra, float lg) hud_playerArmor;
.void(float rad_front, float rad_back, float rad_mode) hud_Radar;
.void(float hit_dir) hud_hitDirectionPips;
.void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hud_renderWeapon1;
.void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hud_renderWeapon2;
.void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hud_renderWeapon3;
.void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hud_renderWeapon4;
.void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hud_renderWeapon5;
.void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hud_renderWeapon6;
.void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hud_renderWeapon7;
.void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hud_renderWeapon8;
.void(float w_grp, float w_state, float w_id, float w_bit, float w_dd, float w_ok, float w_rel) hud_renderWeapon9;
.void(float trgvid, float trgdat, float trgsh, float trgdist, float trglock, float trgdir, vector tpos)hud_renderTarget; //this will call the functions below
.void(float shieldval, vector tpos) hud_targetShield;
.void(float lg, float ct, float lt, float rt, float la, float ra) hud_targetArmor;
.void(float range) hud_targetRange;
.void(float islock) hud_targetLock;
.void(float targdir) hud_targetDirectionPip;

