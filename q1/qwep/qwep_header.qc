/*
  q1 weapon header
  8/27/2016
*/
//defs
.float hit_z;
entity	multi_ent;
float	multi_damage;
void() ClearMultiDamage;
void() ApplyMultiDamage
void(entity hit, float damage) AddMultiDamage;

void() W_Precache;
float() crandom;
vector() wall_velocity;
//effects==============================================================
void(vector org, vector vel) SpawnMeatSpray;
void(vector org, vector vel, float damage) SpawnBlood;
void(float damage) spawn_touchblood;
void(vector org, vector vel) SpawnChunk ;
void() BecomeExplosion;
//projectiles==============================================================
void(float damage, vector dir) TraceAttack;
void(float shotcount, vector dir, vector spread) FireBullets;
void() T_MissileTouch;
void(vector p1, vector p2, entity from, float damage) LightningDamage;
void() spike_touch;
void() superspike_touch;
void(vector org, vector dir) launch_spike;
//weapon attack calls==============================================================
void() W_FireAxe;
void() W_FireShotgun;
void() W_FireSuperShotgun;
void() W_FireLightning;
void() GrenadeExplode;
void() GrenadeTouch;
void() W_FireGrenade;
void() W_FireRocket ;
void() W_FireSuperSpikes;
void(float ox) W_FireSpikes ;
void() spike_touch ;
