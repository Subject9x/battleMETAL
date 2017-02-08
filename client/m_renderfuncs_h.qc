/*
mech Mod
Author: Subject9x
Date: 11/02/2016
Overview: header for common hud widge callbacks
*/

void() hud_renderHelmet;
void() hud_renderEnergy;
void() hud_renderShield;
void() hud_renderPaper;
void(float cur_group) hud_renderWeapons;
void() hud_renderSpeed;
void() hud_renderRadar;
void() hud_renderTarget;
void(float cgrp, float wid, float wgr, vector statusColor, vector ofs, entity src) hud_renderWeapon;