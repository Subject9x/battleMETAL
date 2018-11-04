/*
mech Mod
Author: Peter Roohr
Date: 2/17/2017
mod - 5/11/2017
mod - 9/15/2018
Overview: the interface for hud rendering
every hud ent has to implement this format
*/


//HUD CONSTANTS==============================
vector HUD_COLOR_DEF;
float HUD_UID_IMG_HELM      = 1;
float HUD_UID_ENERGY        = 2;
float HUD_UID_ARM_PLAYER    = 3;
float HUD_UID_SHIELD_PLAYER = 4;
float HUD_UID_ARM_TARGET    = 5;
float HUD_UID_SHIELD_TARGET = 6;
float HUD_UID_WEP_TYPE1     = 7;
float HUD_UID_WEP_TYPE2     = 8;
float HUD_UID_RADAR_TYPE1   = 9;
float HUD_UID_RADAR_TYPE2   = 10;
float HUD_UID_RADAR_GRAPH   = 11;
float HUD_UID_NAV           = 12;
float HUD_UID_TARGET_NAME   = 13;
float HUD_UID_TARGET_RANGE  = 14;
float HUD_UID_ARM_TARG_VEC  = 15;
float HUD_UID_ARM_TARG_BLD  = 16;
//==========================================


//HUD GLOBALS===============================
  vector RADAR_VORG;
  vector RADAR_ORG;
  vector RADAR_VCENTER;
  vector RADAR_VSIZE;
//==========================================

//HUD Text Data Arrays======================
float UI_DATA_UIDS[32]; // - primary key / table for hud objects
vector UI_DATA_POS[32];
vector UI_DATA_SIZE[32];
float UI_DATA_ALIGN[32];
float UI_DATA_LABEL_FLAG[32];
float UI_DATA_LABEL_ALIGN[32];
float UI_DATA_AXIS_FLAG[32];
vector UI_DATA_LABEL_OFS[32];
vector UI_DATA_COLOR1[32];
vector UI_DATA_COLOR2[32];
string UI_DATA_IMG[32]; //background image if needed
string UI_DATA_LABEL[32];
float UI_DATA_WEPBIT[32];

//==========================================

string HUT_RET_PIP_HRZ;
string HUT_RET_PIP_VRT;
string HUT_RET_LOK;
string HUD_RET_HIT;
string HUD_RAD_PIP_BLD;
string HUD_RAD_PIP_MCH;
string HUD_RAD_PIP_NAV;
string HUD_RAD_PIP_VEC;

string HUD_TRG_PIP_L;
string HUD_TRG_PIP_R;
string HUD_TRG_PIP_B;

string HUD_DMG_PIP_H;

string HUD_TARGET_BOX;

.entity data;

.float prev_ang;
.vector nav_ofs;

void(float hitdirection, float lockval, float accuracy, float trg_shield) hud_renderCrosshairs;
void(float hitDirBit) hud_renderDirectionHit;
void(float targdir, float plrFaction, float trgfaction, float dattype) hud_renderTargetDirection;
void(vector pos, float algn, float pitchVal, float pitch_max, float pitch_min) hud_renderPitchIndicator;
void(vector pos, float algn, float val) hud_renderReticleRange;
void(vector pos, float algn, vector angle) hud_renderNavHeading;
void(vector pos, float algn, float val, vector mSize, float bool_label, float lbl_algn, vector lbl_ofs, float meterAxis) hud_renderShield;
void(vector pos, float algn, float val, vector mSize, float bool_label, float lbl_algn, vector lbl_ofs, float meterAxis) hud_renderEnergy;
void(vector grpCtr, vector pos, float val, vector mSize, float lbl_algn, vector lbl_ofs, float meterAxis, string label) hud_renderArmorMeter;
void(vector pos, float algn, float ct, float lt, float rt, float la, float ra, float lg) hud_renderArmorGraph;
void(vector vorg, float algn, float i_faction, vector radarOrg, float radarRange, float radarMode, vector siz) hud_renderRadar;
void(entity blip, float plrFaction, float radRange ) hud_renderRadarContact;
void(vector navOrg, float navState, float radRange ) hud_renderRadarNav;
void(vector torg, float algn, float status, float radius, float flag) hud_renderRadarStatus1;
void(vector torg, float algn, float status, float radius, float flag) hud_renderRadarStatus2;
void(vector pos, vector imgSz, float algn, float wepGrp, float w_id, float w_bit, float w_rel) hud_renderWeapon;
void(vector pos, vector imgSz, float algn, float wepGrp, float w_id, float w_bit, float w_rel) hud_renderWeapon2;
void(vector org, vector pos, float algn, float val, float radRange, float tsize, vector mSize, float meterAxis) hud_renderShieldOverlay;
void(vector org, vector pos, float algn, float faction1, float faction2, float radRange) hud_renderTargetOverlay;
void(vector pos, float algn, string name) hud_renderNameOverlay;
void(vector vorg, float algn, vector siz, float val) hud_renderArmorBuilding;
void(vector vorg, float algn, vector siz, float val)hud_renderArmorVehicle;
void(vector post, float plr_fact, float e_fact, float e_alpha) hud_RenderRadar_Mech;
void(vector post, float plr_fact, float e_fact, float e_alpha) hud_RenderRadar_Vehc;
void(vector post,float plr_fact, float e_fact, float e_alpha) hud_RenderRadar_Building;
void(vector post, float isOn, vector fac_clr) hud_RenderRadar_Nav;
void(vector ofs, vector img_sz, string bimg, float valign, float alpha, vector clr) hud_HelmetImage;
void(vector ofs, vector torg, vector porg, float algn) hud_renderTargetRange;
void(vector ofs, string targType, float algn) hud_renderTargetName;
void(float delta) hud_renderRepairValue;
//entry point for the mech hud system
void( float mech_id ) hud_frame;

//new text-based hud system
void( float uid, float targetId ) hud_data_renderTarget_Shield;
vector( float wbit ) hud_data_weapon_info;
void() data_hud_frame;