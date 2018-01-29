/*
mech Mod
Author: Peter Roohr
Date: 01/26/2018
overview: master header file for all hud functions across all mechs
*/

string HUD_BLK_IMG_B;
string HUD_MTK_IMG_B;
string HUD_MNT_IMG_B;

//-------------------------BALAKET------------------------
void() hud_blk_frame;
void() otl_HelmetImage;    
void(float shieldval) otl_playerShield;
void(float energyval) otl_playerEnergy;
void(float ct, float lt, float rt, float la, float ra, float lg) otl_playerArmor;
void(float rad_mode, float rad_range, float i_fact) otl_Radar;
void(float lockval, float conv_x, float conv_y, float pitch) otl_renderCrosshairs;
void() blk_renderWeapons;
void(float trgvid, float trgdat, float trgsh, float trgdist, float trglock, float trgdir, vector tpos) otl_renderTarget
void(float lg, float ct, float lt, float rt, float la, float ra) otl_targetArmor;

//-------------------------MATOK------------------------
void() hud_mtk_frame;
void() mtk_HelmetImage;    
void(float shieldval) mtk_playerShield;
void(float energyval) mtk_playerEnergy;
void(float ct, float lt, float rt, float la, float ra, float lg) mtk_playerArmor;
void(float rad_mode, float rad_range, float i_fact) mtk_Radar;
void(float lockval, float conv_x, float conv_y, float pitch) mtk_renderCrosshairs; 

//-------------------------MONITOR------------------------
void() hud_mnt_frame;
void() mnt_HelmetImage;     
void(float shieldval) mnt_playerShield;
void(float energyval) mnt_playerEnergy;
void(float ct, float lt, float rt, float la, float ra, float lg) mnt_playerArmor;
void(float rad_mode, float rad_range, float i_fact) mnt_Radar;
void(float lockval, float conv_x, float conv_y, float pitch) mnt_renderCrosshairs;