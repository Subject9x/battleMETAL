/*
battleMETAL
Author: Peter Roohr
Date: 05/23/2019
Overview:
    Data File - Unit - Mech
        Balaket
        Light Skirmisher Mech.
*/

#ifdef CSQC
void() balaket_config_default_reg;
void() balaket_config_default_missile;
void() balaket_config_default_brawl;
#endif

/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_balaket_={
  self.unitModFlags = rint(MODFLAG_BATTLEMETAL);
  self.data_idx = UID_MECH_balaket;
  self.vec_size = 1;
  self.vec_name = "Balaket";
  
  //Center Torso Health / player central health.
  self.max_health = 500;
  
  //Hitbox size, X width, Y Length, Z height.
  self.mins = '-18 -18 -34';
  self.maxs = '18 18 16';
  
//ENERGY AND SHIELDS===================
  self.energyMax = 400;
  self.energyRate= 4.0;
  self.shieldMax = 400;
  self.shieldRate = 3;
  self.startupDelay = 5;
  self.evasionDrain = 2.85;
//=====================================
 
//RADAR================================
  self.radar_range = 1600;
  self.w_firetime = 4;  // lock-on time in seconds
//=====================================

//SPEED================================
  self.data_speed_forward = 185.0;
  self.data_speed_strafe = 120.0;
  self.data_speed_backward = 90.0;
  self.data_speed_accel = 2.0;
  self.ramUpMax = 2;
  self.ramCooldown = 6;
#ifdef CSQC
  //animation playback sync to player move speed.
  self.legMoveRate = 9.5;
  self.legRunRate = 12;
#endif
#ifdef SSQC
  //AI-only Server values.
  self.spreadDefault = ACCURACY_SKIRMISH;
  self.yaw_speed = 5;
  self.turret_yaw_speed = 4.25;
  self.ai_angleLimits = '-175 175 0';
  if( (self.flags & FL_MONSTER) ){
    self.data_speed_accel = 0.025;
  }
#endif
//=====================================
 
//MECH COMPONENTS====================

  //center torso
  data_ini_torso_center_( "models/mechs/balaket/balaket_tor_c.md3", 500, '0 0 0', '0 3 0' );
 
  //left torso
  data_ini_torso_left_( "models/mechs/balaket/balaket_tor_l.md3", 375, '-7.5 5.5 -2.5', '-8.5 5.5 -1');
 
  //right torso
  data_ini_torso_right_( "models/mechs/balaket/balaket_tor_r.md3", 375, '7.5 5.5 -2.5', '8.5 5.5 -1');
 
  //left arm
  data_ini_arm_left_( "models/mechs/balaket/balaket_arm_l.md3", 350, '-10 7 -3', '-11 3.5 -1.5');
 
  //right arm
  data_ini_arm_right_( "models/mechs/balaket/balaket_arm_r.md3", 350, '10 7 -3', '11 3.5 -1.5');
   
  //legs      
  data_ini_legs_( "models/mechs/balaket/balaket_legs.md3", 700, '0 -16 0');
  
  //camera location
#ifdef CSQC
  self.cameraOffset = '0 7 24';
#else
  self.cameraOffset = '0 7 7';
#endif
//=====================================
 
//HARDPOINTS==========================
  data_ini_unitHardpoint_1( M_ARM_LEFT, '-12.2 0.5 0.5', '0 0 -90', (BAL1 | BAL2 | ENE1 | ENE2) );
  data_ini_unitHardpoint_2( M_ARM_RIGHT, '12.2 0.5 0.5', '0 0 90',  (BAL1 | BAL2 | ENE1 | ENE2) );
  data_ini_unitHardpoint_3( M_TOR_CENTER, '-2 10.5 0', '0 0 0',     (BAL1|BAL2|BAL3|BAL4|ENE1|ENE2|ENE3|ENE4|MIS1|MIS2|MIS3|MIS4|MSC1|MSC2|MSC3) );
  data_ini_unitHardpoint_4( M_TOR_LEFT, '-7.85 7.0 6.0', '0 0 0',    (MSC1 | MIS2) );
  data_ini_unitHardpoint_5( M_TOR_RIGHT, '7.85 7.0 6.0', '0 0 0',   (MIS2|MSC1|MSC2|MSC3) );
//=====================================

//HUD DATA=============================
#ifdef CSQC
  if( self.classname == "UI_ITEM" ){
    precache_model("models/mechs/balaket/balaket_view.obj");
    precache_model("models/mechs/balaket/balaket_hud.obj");
    self.weaponmodel = "models/mechs/balaket/balaket_view.obj";
    self.hud_model = "models/mechs/balaket/balaket_hud.obj";
    self.hud_StrutsOffset = '0 -1.5 -1';
    self.pitchMax = 30; //pitch down limit
    self.pitchMin = -35;//pitch up limit
    self.hud_rollangle = 4;
    self.hud_bob = 0.03;
    self.hud_bob_cycle = 0.5;
    self.hud_bob_up = 0.15;
    self.hud_bob_model = 1;
    self.hud_bob_side = 0.09;
    self.hud_bob_speed = 6;
    self.hud_bob_model_up = 0.1;
  //====================================

  //UI Data=============================
    self.config_default_regular = balaket_config_default_reg;
    self.config_default_missile = balaket_config_default_missile;
    self.config_default_brawl = balaket_config_default_brawl;
    self.abbrev = "BLK";
    self.description = "A primitive combat platform, BALAKETs come from the early days of the Federation. Originally billed as exploration vehicles, Federation Military found them able anti-partisan units. | | BALAKET units are best against other light and smaller targets. Their weapon mount limitations prevent them from engaging larger foes one-on-one. | | They are dangerous in packs though, their quick speed and variable-enough loadouts keeping singular targets distracted; unable to land that fatal blow.";
    
    //Menu position for hardpoint icons in UI_HANGAR / UI_ARMING
    local entity hardpnt;
    hardpnt = self.w_slot;
    hardpnt.uiOffset = '64 65'; //#1
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '-64 65'; //#2
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '12 10';//#3
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '42 30';//#4
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '-42 30'; //#5
  //====================================
  }
#endif
};

#ifdef CSQC
/*
  METALS get 2 default configs for players, allowing first-time players to not need to know what to do.
  UNLOCKED_ITEMS[]
*/
void() balaket_config_default_reg={
  
  //Balaket configs really are dictated by Hardpoint3's chosen weapon.
  //Hardpoint 3
  if( INV_HAS_emp ){
    self.next_wepn3 = INV_HAS_emp;
  }
  else if( INV_HAS_snub_artillery ){
    self.next_wepn3 = INV_HAS_snub_artillery;
  }
  else if( INV_HAS_missile_swarm ){
    self.next_wepn3 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn3 = INV_HAS_rocket_launcher;
  }
  else if( INV_HAS_ion_coil ){
    self.next_wepn3 = INV_HAS_ion_coil;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn3 = INV_HAS_light_laser;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn3 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_flak ){
    self.next_wepn3 = INV_HAS_flak;
  }
  else{
    self.next_wepn3 = INV_HAS_NONE;
  }
  
  //Hardpoint 1
  if( INV_HAS_electro_repeater ){
    self.next_wepn1 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn1 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn1 = INV_HAS_light_laser;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn1 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_flak ){
    self.next_wepn1 = INV_HAS_flak;
  }
  else{
    self.next_wepn1 = INV_HAS_NONE;
  }
  
  //Hardpoint 2
  if( INV_HAS_electro_repeater ){
    self.next_wepn2 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_ion_coil && (self.next_wepn3 != INV_HAS_ion_coil && self.next_wepn3 != INV_HAS_emp)){
    self.next_wepn2 = INV_HAS_ion_coil;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn2 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn2 = INV_HAS_light_laser;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn2 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_flak ){
    self.next_wepn2 = INV_HAS_flak;
  }
  else{
    self.next_wepn2 = INV_HAS_NONE;
  }
  
  //Hardpoint 4
  if( self.next_wepn3 == INV_HAS_emp || self.next_wepn3 == INV_HAS_ion_coil ){
    self.next_wepn4 = INV_HAS_heatsink;
  }
  else if( self.next_wepn3 == INV_HAS_snub_artillery || self.next_wepn3 == INV_HAS_missile_swarm ){
    self.next_wepn4 = INV_HAS_adv_reload;
  }
  else{
    self.next_wepn4 = INV_HAS_NONE;
  }
  
  //Hardpoint 5
  if( INV_HAS_recharge_capacitor ){
    self.next_wepn5 = INV_HAS_recharge_capacitor;
  }
  else if( self.next_wepn3 == INV_HAS_emp ){
    self.next_wepn5 = INV_HAS_energy_battery;
  }
  else if( INV_HAS_shield_capacitor ){
    self.next_wepn5 = INV_HAS_shield_capacitor;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn5 = INV_HAS_shield_emitter;
  }
  else{
    self.next_wepn5 = INV_HAS_NONE;
  }
  
  //GROUPS
  self.w_group1 = WEAPON1 | WEAPON2;
  self.w_group2 = WEAPON3;
  self.w_group3 = 0;
  self.w_group4 = 0;
};

/*
  Config: Missile Boats
    prioritize missiles in every available hardpoint possible.
*/
void() balaket_config_default_missile={
  //Hardpoint3 - BAL1|BAL2|BAL3|BAL4  ENE1|ENE2|ENE3|ENE4  MIS1|MIS2|MIS3|MIS4  MSC1|MSC2|MSC3
  if( INV_HAS_missile_swarm ){
    self.next_wepn3 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_missile_activeradar ){
    self.next_wepn3 = INV_HAS_missile_activeradar;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn3 = INV_HAS_rocket_launcher;
  }
  else if( INV_HAS_missile_laserguide ){
    self.next_wepn3 = INV_HAS_missile_laserguide;
  }
  else if( INV_HAS_ion_coil ){
    self.next_wepn3 = INV_HAS_ion_coil;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn3 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn3 = INV_HAS_light_laser;
  }
  else if( INV_HAS_flak ){
    self.next_wepn3 = INV_HAS_flak;
  }
  else{
    self.next_wepn3 = INV_HAS_NONE;
  }
  
  //Hardpoint1 - BAL1 | BAL2 | ENE1 | ENE2
  if( INV_HAS_quantum_rifle ){
    self.next_wepn1 = INV_HAS_quantum_rifle;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn1 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn1 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn1 = INV_HAS_light_laser;
  }
  else if( INV_HAS_flak ){
    self.next_wepn1 = INV_HAS_flak;
  }
  else{
    self.next_wepn1 = INV_HAS_NONE;
  }
  
  //Hardpoint2 - BAL1 | BAL2 | ENE1 | ENE2
  if( INV_HAS_quantum_rifle ){
    self.next_wepn2 = INV_HAS_quantum_rifle;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn2 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn2 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn2 = INV_HAS_light_laser;
  }
  else if( INV_HAS_flak ){
    self.next_wepn2 = INV_HAS_flak;
  }
  else{
    self.next_wepn2 = INV_HAS_NONE;
  }
  
  
  //Hardpoint4 - MSC1
  if( INV_HAS_adv_reload ){
    self.next_wepn4 = INV_HAS_adv_reload;
  }
  else if( INV_HAS_heatsink ){
    self.next_wepn4 = INV_HAS_heatsink;
  }
  else {
    self.next_wepn4 = INV_HAS_NONE;
  }
  
  //Hardpoint5 - MSC1|MSC2|MSC3
  if( INV_HAS_adv_reload && (self.next_wepn1 == INV_HAS_quantum_rifle && self.next_wepn2 == self.next_wepn1) ){
    self.next_wepn5 = INV_HAS_adv_reload;
  }
  else if( INV_HAS_adv_reload && (self.next_wepn3 == INV_HAS_missile_activeradar || self.next_wepn3 == INV_HAS_missile_swarm) ){
    self.next_wepn5 = INV_HAS_adv_reload;
  }
  else if( INV_HAS_shield_emitter ) {
    self.next_wepn5 = INV_HAS_shield_emitter;
  }
  else if( INV_HAS_shield_capacitor ){
    self.next_wepn5 = INV_HAS_shield_capacitor;
  }
  else{
    self.next_wepn5 = INV_HAS_NONE;
  }
  
  //GROUPS
  if( self.next_wepn1 == self.next_wepn2 ){
    self.w_group1 = WEAPON1 | WEAPON2;
  }
  if( self.next_wepn3 == self.next_wepn1 ){
    self.w_group1 = self.w_group1 | WEAPON3;
  }
  else{
    self.w_group2 = WEAPON3;
  }
  
};

/*
  Config: Brawler
    specializes in fire-fights of attrition.
*/
void() balaket_config_default_brawl={
  //Hardpoint3 - BAL1|BAL2|BAL3|BAL4  ENE1|ENE2|ENE3|ENE4  MIS1|MIS2|MIS3|MIS4  MSC1|MSC2|MSC3
  if( INV_HAS_missile_swarm ){
    self.next_wepn3 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_quantum_rifle ){
    self.next_wepn3 = INV_HAS_quantum_rifle;
  }
  else if( INV_HAS_electro_repeater ){
    self.next_wepn3 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn3 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_flak ){
    self.next_wepn3 = INV_HAS_flak;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn3 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn3 = INV_HAS_light_laser;
  }
  else{
    self.next_wepn3 = INV_HAS_NONE;
  }
  
  
  //Hardpoint1 - BAL1 | BAL2 | ENE1 | ENE2
  if( INV_HAS_quantum_rifle ){
    self.next_wepn1 = INV_HAS_quantum_rifle;
  }
  else if( INV_HAS_electro_repeater ){
    self.next_wepn1 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn1 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_flak ){
    self.next_wepn1 = INV_HAS_flak;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn1 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn1 = INV_HAS_light_laser;
  }
  else{
    self.next_wepn1 = INV_HAS_NONE;
  }
  //Hardpoint2 - BAL1 | BAL2 | ENE1 | ENE2
  if( INV_HAS_quantum_rifle ){
    self.next_wepn1 = INV_HAS_quantum_rifle;
  }
  else if( INV_HAS_electro_repeater ){
    self.next_wepn2 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn2 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_flak ){
    self.next_wepn2 = INV_HAS_flak;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn2 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn2 = INV_HAS_light_laser;
  }
  else{
    self.next_wepn2 = INV_HAS_NONE;
  }
  
  //Hardpoint4 - MSC1
  if( self.next_wepn3 == INV_HAS_quantum_rifle){
    self.next_wepn4 = INV_HAS_adv_reload;
  }
  else if(INV_HAS_heatsink ){
    self.next_wepn4 = INV_HAS_heatsink;
  }
  else {
    self.next_wepn4 = INV_HAS_NONE;
  }
  
  //Hardpoint5 - MSC1|MSC2|MSC3
  if( INV_HAS_shield_emitter ){
    self.next_wepn5 = INV_HAS_shield_emitter;
  }
  else if( self.next_wepn3 == INV_HAS_electro_repeater && INV_HAS_recharge_capacitor){
    self.next_wepn5 = INV_HAS_recharge_capacitor;
  }
  else if( self.next_wepn3 == INV_HAS_electro_repeater  && INV_HAS_energy_battery){
    self.next_wepn5 = INV_HAS_energy_battery;
  }
  else if( INV_HAS_shield_capacitor ){
    self.next_wepn5 = INV_HAS_shield_capacitor;
  }
  else if( self.next_wepn3 == INV_HAS_electro_repeater && INV_HAS_heatsink ){
    self.next_wepn5 = INV_HAS_heatsink;
  }
  else if( INV_HAS_adv_reload ){
    self.next_wepn5 = INV_HAS_adv_reload;
  }
  else {
    self.next_wepn5 = INV_HAS_NONE;
  }
  
  //GROUPS
  if( self.next_wepn1 == self.next_wepn2 && self.next_wepn1 == self.next_wepn3 ){
    self.w_group1 = WEAPON1 | WEAPON2 | WEAPON3;
  }
  else{
    if( self.next_wepn1 == self.next_wepn2 ){
      self.w_group1 = WEAPON1 | WEAPON2;
      self.w_group2 = WEAPON3;
    }
  }
};

#endif