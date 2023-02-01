/*
battleMETAL
Author: Peter Roohr
Date: 05/24/2019
Overview:
    Data File - Unit - Mech
        Matok
        Medium Lancer.
*/

#ifdef CSQC
void() matok_config_default_reg;
void() matok_config_default_missile;
void() matok_config_default_brawl;
#endif
/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_matok_={
  
  self.unitModFlags = self.unitModFlags | MODFLAG_BATTLEMETAL;
  
  self.data_idx = UID_MECH_matok;
  self.vec_size = 2;
  self.vec_name = "Matok";
 
  //Center Torso Health / player central health.
  self.max_health = 650;
  
  //Hitbox size, X width, Y Length, Z height.
  self.mins = '-18 -18 -40';
  self.maxs = '18 18 22';
  
//ENERGY AND SHIELDS===================
  self.energyMax   = 800;
  self.energyRate  = 4.85;
  self.shieldMax   = 600;
  self.shieldRate  = 3.33;
  self.startupDelay = 7;
  self.evasionDrain = 2.5;
//=====================================
 
//RADAR================================
  self.radar_range = 1800;
  self.w_firetime = 2;  //lock-on time in seconds
//=====================================

//SPEED================================
  self.data_speed_forward = 155.0;
  self.data_speed_strafe = 155.0;
  self.data_speed_backward = 80.0;
  self.data_speed_accel = 1.45;
  self.ramUpMax = 1.5;
  self.ramCooldown = 3;
#ifdef CSQC
  //animation playback sync to player move speed.
  self.legMoveRate = 12;
  self.legRunRate = 18;
#endif
#ifdef SSQC
  //AI-only Server values.
  self.spreadDefault = ACCURACY_MARKSMAN;
  self.yaw_speed = 3;
  self.turret_yaw_speed = 3.75;
  self.ai_angleLimits = '-180 180 0';
  if( (self.flags & FL_MONSTER) ){
    self.data_speed_accel = 0.015;
  }
#endif
//=====================================
 
//MECH COMPONENTS====================
  //center torso
  data_ini_torso_center_( "models/mechs/matok/matok_tor_c.md3", 650, '0 0 0', '0 6 0' );
 
  //left torso
  data_ini_torso_left_( "models/mechs/matok/matok_tor_l.md3", 600, '-10 12.25 1', '-8 12.25 0' );
 
  //right torso
  data_ini_torso_right_( "models/mechs/matok/matok_tor_r.md3", 600, '10 12.25 1', '8 12.25 0' );
 
  //left arm
  data_ini_arm_left_( "models/mechs/matok/matok_arm_l.md3", 675, '-11 12 0', '-14 7 0' );

  //right arm
  data_ini_arm_right_( "models/mechs/matok/matok_arm_r.md3", 675, '11 12 0', '14 7 0' );

  //legs
  data_ini_legs_( "models/mechs/matok/matok_legs.md3", 900, '0 -12 0' );
  
  //camera location
  #ifdef CSQC
    self.cameraOffset = '0 15 13';
  #else
    self.cameraOffset = '0 15 7';
  #endif
  
//=====================================
 
//HARDPOINT DATA======================
  data_ini_unitHardpoint_1( M_TOR_RIGHT, '9.25 8.65 9', '0 0 0',     (BAL1|BAL2|ENE1|MSC1|MIS1) );
  data_ini_unitHardpoint_2( M_TOR_LEFT, '-9.25 8.65 9', '0 0 0',     (BAL1|BAL2|ENE1|MSC1|MIS1) );
  data_ini_unitHardpoint_3( M_ARM_RIGHT, '19 3 2.25', '0 0 90',       (BAL1|ENE1|ENE2|ENE3) );
  data_ini_unitHardpoint_4( M_ARM_LEFT, '-19 3 2.25', '0 0 -90',      (BAL1|ENE1|ENE2|ENE3) );
  data_ini_unitHardpoint_5( M_TOR_CENTER, '0 20 0', '0 0 0',         (BAL1|BAL2|BAL3|BAL4|ENE1|ENE2|ENE3|ENE4|MIS1|MIS2|MIS3|MIS4|MSC1|MSC2) );
  data_ini_unitHardpoint_6( M_TOR_CENTER, '0 6 7', '0 0 0',          (MSC1|MSC2|MSC3|MSC4) );
//=====================================

//HUD Data=============================
#ifdef CSQC
  if( self.classname == "UI_ITEM" ){
    precache_model("models/mechs/matok/matok_view.obj");
    precache_model("models/mechs/matok/matok_hud.obj");
    self.weaponmodel = "models/mechs/matok/matok_view.obj";
    self.hud_model = "models/mechs/matok/matok_hud.obj";
    self.hud_StrutsOffset = '0 -2 -0.75';
    self.pitchMax = 55;
    self.pitchMin = -45;
    self.hud_rollangle = 3.25;
    
    self.hud_bob = 3.0;
    self.hud_bob_up = 5.0;
    
    self.hud_bob_cycle = 0.5;
    self.hud_bob_model = 1;
    self.hud_bob_side = 0.35;
    self.hud_bob_speed = 6.55;
    self.hud_bob_model_up = 0.1;
  //====================================

  //UI Data=============================
    self.config_default_regular = matok_config_default_reg;
    self.config_default_missile = matok_config_default_missile;
    self.config_default_brawl = matok_config_default_brawl;
    self.description = "The MATOK was the second-generation combat mech that Federal Military churned out as the threat of AUTHOR was increasing. MATOKs are the main stay of Federal squadrons today, found in almost every deployment and any combat. | | A dangerous generalist, the MATOK is design to engage targets head on with a slew of direct-fire power and large reactor recharge capacity. | | MATOK operators have to remember not to get surrounded though, the MATOK's defensive capabilities are not as strong as its offense. Its speed is also a problem against more agile targets.";
    
    //Menu position for hardpoint icons in UI_HANGAR / UI_ARMING
    local entity hardpnt;
    hardpnt = self.w_slot;
    hardpnt.uiOffset = '-48 20';  //#1
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '50 20';  //#2
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '-96 50';  //#3
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '98 50';  //#4
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '2 -35'; //#5
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '2 34'; //#6
  //====================================
  }
#endif
};

#ifdef CSQC
void() matok_config_default_reg={
  
  //Hardpoint 5 - BAL1|BAL2|BAL3|BAL4 | ENE1|ENE2|ENE3|ENE4 | MIS1|MIS2|MIS3|MIS4 | MSC1|MSC2
  if( INV_HAS_emp ){
    self.next_wepn5 = INV_HAS_emp;
  }
  else if( INV_HAS_ion_coil ){
    self.next_wepn5 = INV_HAS_ion_coil;
  }
  else if( INV_HAS_snub_artillery ){
    self.next_wepn5 = INV_HAS_snub_artillery;
  }
  else if( INV_HAS_missile_swarm ){
    self.next_wepn5 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_missile_activeradar ){
    self.next_wepn5 = INV_HAS_missile_activeradar;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn5 = INV_HAS_rocket_launcher;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn5 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn5 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn5 = INV_HAS_light_laser;
  }
  else if( INV_HAS_flak ) {
    self.next_wepn5 = INV_HAS_flak;
  }
  else {
    self.next_wepn5 = INV_HAS_NONE;
  }
  
  
  //Hardpoint 3 - BAL1|ENE1|ENE2|ENE3
  if( INV_HAS_particle_cannon ){
    self.next_wepn3 = INV_HAS_particle_cannon;
  }
  else if( INV_HAS_electro_repeater ){
    self.next_wepn3 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_light_laser ) {
    self.next_wepn3 = INV_HAS_light_laser;
  }
  else if( INV_HAS_light_autocannon ) {
    self.next_wepn3 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_flak ) {
    self.next_wepn3 = INV_HAS_flak;
  }
  else {
    self.next_wepn3 = INV_HAS_NONE;
  }
  
  //Hardpoint 4 - BAL1|ENE1|ENE2|ENE3
  if( INV_HAS_particle_cannon ){
    self.next_wepn4 = INV_HAS_particle_cannon;
  }
  else if( INV_HAS_electro_repeater ){
    self.next_wepn4 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_light_laser ) {
    self.next_wepn4 = INV_HAS_light_laser;
  }
  else if( INV_HAS_light_autocannon ) {
    self.next_wepn4 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_flak ) {
    self.next_wepn4 = INV_HAS_flak;
  }
  else {
    self.next_wepn4 = INV_HAS_NONE;
  }
  
  //Hardpoint 6 - MSC1|MSC2|MSC3|MSC4
  if( (self.next_wepn5 == INV_HAS_emp || self.next_wepn5 == INV_HAS_ion_coil) && 
        ( self.next_wepn3 == INV_HAS_particle_cannon || self.next_wepn4 == INV_HAS_particle_cannon ) && INV_HAS_recharge_capacitor ){
    self.next_wepn6 = INV_HAS_recharge_capacitor;
  }
  else if( (self.next_wepn5 == INV_HAS_emp || self.next_wepn5 == INV_HAS_ion_coil) && 
        ( self.next_wepn3 == INV_HAS_particle_cannon || self.next_wepn4 == INV_HAS_particle_cannon ) && INV_HAS_energy_battery){
    self.next_wepn6 = INV_HAS_energy_battery;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn6 = INV_HAS_shield_emitter;
  }
  else if( INV_HAS_shield_capacitor ){
    self.next_wepn6 = INV_HAS_shield_capacitor;
  }
  else if( (self.next_wepn5 == INV_HAS_snub_artillery || self.next_wepn5 == INV_HAS_missile_activeradar || self.next_wepn5 == INV_HAS_missile_swarm) && INV_HAS_adv_reload ){
    self.next_wepn6 = INV_HAS_adv_reload;
  }
  else if( INV_HAS_heatsink  ){
    self.next_wepn6 = INV_HAS_heatsink;
  }
  else{
    self.next_wepn6 = INV_HAS_NONE;
  }
  
  
  //Hardpoint 1 - BAL1|BAL2|ENE1|MSC1|MIS1
  if( (INV_HAS_recharge_capacitor && self.next_wepn6 == INV_HAS_recharge_capacitor) && INV_HAS_rotary_plasma ){
    self.next_wepn1 = INV_HAS_rotary_plasma;
  }
  else if( (INV_HAS_recharge_capacitor && self.next_wepn6 == INV_HAS_recharge_capacitor) && INV_HAS_rocket_launcher ){
    self.next_wepn1 = INV_HAS_rocket_launcher;
  }
  else if( (self.next_wepn5 == INV_HAS_missile_activeradar || self.next_wepn5 == INV_HAS_missile_swarm || self.next_wepn5 == INV_HAS_snub_artillery) && INV_HAS_adv_reload ) {
    self.next_wepn1 = INV_HAS_adv_reload;
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
  else {
    self.next_wepn1 = INV_HAS_NONE;
  }
  
  //Hardpoint 2 - BAL1|BAL2|ENE1|MSC1|MIS1
  if( (INV_HAS_recharge_capacitor && self.next_wepn6 == INV_HAS_recharge_capacitor) && INV_HAS_rotary_plasma ){
    self.next_wepn2 = INV_HAS_rotary_plasma;
  }
  else if( (INV_HAS_recharge_capacitor && self.next_wepn6 == INV_HAS_recharge_capacitor) && INV_HAS_rocket_launcher ){
    self.next_wepn2 = INV_HAS_rocket_launcher;
  }
  else if( (self.next_wepn5 == INV_HAS_missile_activeradar || self.next_wepn5 == INV_HAS_missile_swarm || self.next_wepn5 == INV_HAS_snub_artillery) && INV_HAS_adv_reload ) {
    self.next_wepn2 = INV_HAS_adv_reload;
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
  else {
    self.next_wepn2 = INV_HAS_NONE;
  }
  
  //2-PAC EMP exception
  if( self.next_wepn5 == INV_HAS_emp && (self.next_wepn3 == INV_HAS_particle_cannon && self.next_wepn4 == INV_HAS_particle_cannon) ){
    if( INV_HAS_ion_coil ){    
      self.next_wepn5 = INV_HAS_ion_coil;
    }
  }
  
  //GROUPS
  if( self.next_wepn5 == INV_HAS_snub_artillery || self.next_wepn5 == INV_HAS_missile_activeradar || self.next_wepn5 == INV_HAS_missile_swarm){
    self.w_group3 = WEAPON5;
  }
  else if( self.next_wepn5 == INV_HAS_light_autocannon && (self.next_wepn1 == self.next_wepn5 && self.next_wepn2 == self.next_wepn5) ){
    self.w_group1 = WEAPON1 | WEAPON2 | WEAPON5;
  }
  else if( (self.next_wepn3 == self.next_wepn4) && (self.next_wepn3 == INV_HAS_particle_cannon || self.next_wepn3 == INV_HAS_electro_repeater) ){
    self.w_group2 = WEAPON3 | WEAPON4;
    self.w_group3 = WEAPON5;
  }
  else if( self.next_wepn5 == INV_HAS_emp  || self.next_wepn5 == INV_HAS_ion_coil ){
    self.w_group2 = WEAPON5;
  }
  else{
    self.w_group3 = WEAPON5;
  }
  
  if( self.next_wepn1 == self.next_wepn2 ){
    self.w_group1 = WEAPON1 | WEAPON2;
  }
  if( self.next_wepn2 == self.next_wepn1 ){
    if( self.next_wepn1 == self.next_wepn3 && self.next_wepn4 == self.next_wepn3 ){
      self.w_group1 = self.w_group1 | WEAPON1 | WEAPON2 | WEAPON3 | WEAPON4;
    }
    if( self.next_wepn4 == self.next_wepn3 && (self.next_wepn4 == INV_HAS_light_laser || self.next_wepn4 == INV_HAS_light_autocannon) ){
      self.w_group1 = self.w_group1 | WEAPON1 | WEAPON2 | WEAPON3 | WEAPON4;
    }
  }

  
};

/*
  Config: Missile Boats
    prioritize missiles in every available hardpoint possible.
*/
void() matok_config_default_missile={
  //Hardpoint 5 BAL1|BAL2|BAL3|BAL4 | ENE1|ENE2|ENE3|ENE4 | MIS1|MIS2|MIS3|MIS4 | MSC1|MSC2
  if( INV_HAS_missile_laserguide ){
    self.next_wepn5 = INV_HAS_missile_laserguide;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn5 = INV_HAS_rocket_launcher;
  }
  else if( INV_HAS_missile_activeradar ){
    self.next_wepn5 = INV_HAS_missile_activeradar;
  }
  else if( INV_HAS_missile_swarm ){
    self.next_wepn5 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_ion_coil ){
    self.next_wepn5 = INV_HAS_ion_coil;
  }
  else if( INV_HAS_shield_capacitor ){
    self.next_wepn5 = INV_HAS_shield_capacitor;
  }
  else{
    self.next_wepn5 = INV_HAS_NONE;
  }
  //Hardpoint 3 BAL1 |ENE1|ENE2|ENE3
  if( INV_HAS_light_laser ){
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
  
  //Hardpoint 4 BAL1 |ENE1|ENE2|ENE3
  if( INV_HAS_light_laser ){
    self.next_wepn4 = INV_HAS_light_laser;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn4 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_flak ){
    self.next_wepn4 = INV_HAS_flak;
  }
  else{
    self.next_wepn4 = INV_HAS_NONE;
  }
  
  //Hardpoint 1 BAL1|BAL2| ENE1| MSC1| MIS1
  if( INV_HAS_missile_laserguide ){
    self.next_wepn1 = INV_HAS_missile_laserguide;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn1 = INV_HAS_rocket_launcher;
  }
  else if( INV_HAS_quantum_rifle ){
    self.next_wepn1 = INV_HAS_quantum_rifle;
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
  
  //Hardpoint 2 BAL1|BAL2| ENE1| MSC1| MIS1
  if( INV_HAS_missile_laserguide ){
    self.next_wepn2 = INV_HAS_missile_laserguide;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn2 = INV_HAS_rocket_launcher;
  }
  else if( INV_HAS_quantum_rifle ){
    self.next_wepn2 = INV_HAS_quantum_rifle;
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
  
  //Hardpoint 6 MSC1|MSC2|MSC3|MSC4
  if( self.next_wepn5 == INV_HAS_missile_activeradar || self.next_wepn5 == INV_HAS_missile_swarm ){
    self.next_wepn6 = INV_HAS_adv_reload;
  }
  else if( INV_HAS_turbo_charger ) {
    self.next_wepn6 = INV_HAS_turbo_charger;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn6 = INV_HAS_shield_emitter;
  }
  else if( INV_HAS_shield_capacitor ){
    self.next_wepn6 = INV_HAS_shield_capacitor;
  }
  else{
    self.next_wepn6 = INV_HAS_NONE;
  }
  
  //GROUPS
  self.w_group1 = WEAPON3 | WEAPON4;
  
  if(self.next_wepn5 == INV_HAS_missile_activeradar || self.next_wepn5 == INV_HAS_missile_swarm){
    self.w_group2 = WEAPON5;
  }
  else{
    self.w_group2 = WEAPON1 | WEAPON1;
  }
  if( self.next_wepn1 == self.next_wepn2 && self.next_wepn1 == self.next_wepn5 ){
    self.w_group2 = self.w_group2 | WEAPON1 | WEAPON2;
    if( self.next_wepn5 == self.next_wepn1 ){
      self.w_group2 = self.w_group2 | WEAPON5;
    }
  }
  else{
    self.w_group1 = self.w_group1 | WEAPON1 | WEAPON2;
  }
  
};

/*
  Config: Brawler
    specializes in fire-fights of attrition.
*/
void() matok_config_default_brawl={
  //Hardpoint 5 BAL1|BAL2|BAL3|BAL4 | ENE1|ENE2|ENE3|ENE4 | MIS1|MIS2|MIS3|MIS4 | MSC1|MSC2
  if( INV_HAS_electro_repeater ){
    self.next_wepn5 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_quantum_rifle ){
    self.next_wepn5 = INV_HAS_quantum_rifle;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn5 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn5 = INV_HAS_rocket_launcher;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn5 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_flak ){
    self.next_wepn5 = INV_HAS_flak;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn5 = INV_HAS_light_laser;
  }
  else{
    self.next_wepn5 = INV_HAS_NONE;
  }
  
  
  //Hardpoint 3 BAL1|ENE1|ENE2|ENE3
  if( INV_HAS_electro_repeater ){
    self.next_wepn3 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn3 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_flak ){
    self.next_wepn3 = INV_HAS_flak;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn3 = INV_HAS_light_laser;
  }
  else{
    self.next_wepn3 = INV_HAS_NONE;
  }
  
  //Hardpoint 4 BAL1|ENE1|ENE2|ENE3
  if( INV_HAS_electro_repeater ){
    self.next_wepn4 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn4 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_flak ){
    self.next_wepn4 = INV_HAS_flak;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn4 = INV_HAS_light_laser;
  }
  else{
    self.next_wepn4 = INV_HAS_NONE;
  }
  
  //Hardpoint 1 BAL1|BAL2|ENE1|MSC1|MIS1
  if( INV_HAS_quantum_rifle ){
    self.next_wepn1 = INV_HAS_quantum_rifle;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn1 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn1 = INV_HAS_rocket_launcher;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn1 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_flak ){
    self.next_wepn1 = INV_HAS_flak;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn1 = INV_HAS_light_laser;
  }
  else{
    self.next_wepn1 = INV_HAS_NONE;
  }
  
  //Hardpoint 2 BAL1|BAL2|ENE1|MSC1|MIS1
  if( INV_HAS_quantum_rifle ){
    self.next_wepn2 = INV_HAS_quantum_rifle;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn2 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn2 = INV_HAS_rocket_launcher;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn2 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_flak ){
    self.next_wepn2 = INV_HAS_flak;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn2 = INV_HAS_light_laser;
  }
  else{
    self.next_wepn2 = INV_HAS_NONE;
  }
  
  //Hardpoint 6 MSC1|MSC2|MSC3|MSC4
  if( self.next_wepn5 == INV_HAS_electro_repeater && 
      (self.next_wepn3 == self.next_wepn5 && self.next_wepn4 == self.next_wepn5) &&
        INV_HAS_recharge_capacitor ){
    self.next_wepn6 = INV_HAS_recharge_capacitor;
  }
  else if( self.next_wepn5 == INV_HAS_electro_repeater && 
      (self.next_wepn3 == self.next_wepn5 && self.next_wepn4 == self.next_wepn5) &&
        INV_HAS_energy_battery ){
    self.next_wepn6 = INV_HAS_energy_battery;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn6 = INV_HAS_shield_emitter;
  }
  else if( INV_HAS_shield_capacitor ){
    self.next_wepn6 = INV_HAS_shield_capacitor;
  }
  else if( INV_HAS_turbo_charger ){
    self.next_wepn6 = INV_HAS_turbo_charger;
  }
  else {
    self.next_wepn6 = INV_HAS_NONE;
  }
  
  //low-tier check
  if( INV_HAS_ion_coil ){
    if( self.next_wepn1 == INV_HAS_flak && 
      (self.next_wepn2 == self.next_wepn1 && self.next_wepn3 == self.next_wepn1) &&
      self.next_wepn4 == self.next_wepn1 ){
      
      self.next_wepn5 = INV_HAS_ion_coil;
    }
  }
  
  //GROUPS
  if( self.next_wepn3 == self.next_wepn5 && self.next_wepn4 == self.next_wepn5 && self.next_wepn5 == INV_HAS_electro_repeater){
    self.w_group1 = WEAPON3 | WEAPON4 | WEAPON5;
  }
  if( self.next_wepn3 == self.next_wepn5 && self.next_wepn4 == self.next_wepn5 && self.next_wepn5 == INV_HAS_quantum_rifle){
    self.w_group1 = WEAPON3 | WEAPON4 | WEAPON5;
  }
  if( self.next_wepn5 == INV_HAS_ion_coil ){
    self.w_group2 = WEAPON5;
    self.w_group1 = WEAPON1 | WEAPON2 | WEAPON3 | WEAPON4;
  }
  
  
  if( !(self.w_group1 & WEAPON1) && !(self.w_group1 & WEAPON2) ){
    if( self.next_wepn1 == self.next_wepn2 ){
      self.w_group2 = WEAPON1 | WEAPON2;
    }
  }
};
#endif