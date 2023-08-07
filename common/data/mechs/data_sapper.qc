/*
battleMETAL
Author: Peter Roohr
Date: 11/01/2021
Overview:
    Data File - Unit - Mech
        Sapper
        Medium harasser.
*/


#ifdef CSQC
void() sapper_config_default_reg;
void() sapper_config_default_missile;
void() sapper_config_default_brawl;
#endif

/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_sapper_={

  self.unitModFlags = self.unitModFlags | MODFLAG_BATTLEMETAL;
  self.data_idx = UID_MECH_sapper;
  self.vec_size = 2;
  self.vec_name = "Sapper";
  
  //Center Torso Health / player central health.
  self.max_health = 650;
  
  //Hitbox size, X width, Y Length, Z height.
  self.mins = '-18 -18 -34.75';
  self.maxs = '18 18 22';
  
//ENERGY AND SHIELDS===================
  self.energyMax   = 500;
  self.energyRate  = 5.25;
  self.shieldMax   = 800;
  self.shieldRate  = 4.0;
  self.startupDelay = 8;
  self.evasionDrain = 4.5;
//=====================================
 
//RADAR================================
  self.radar_range = 1500;
  self.w_firetime = 1.33;  //lock-on time in seconds
//=====================================

//SPEED================================
  self.data_speed_forward = 125.0;
  self.data_speed_strafe = 105.0;
  self.data_speed_backward = 100.0;
  self.data_speed_accel = 2.25;
  self.data_speed_decel = 50;
  self.ramUpMax = 1.75;
  self.ramCooldown = 3;
#ifdef CSQC
  //animation playback sync to player move speed.
  self.legMoveRate = 10;
  self.legRunRate = 14;
#endif
#ifdef SSQC
  //AI-only Server values.
  self.spreadDefault = ACCURACY_MARKSMAN;
  self.yaw_speed = 2.5;
  self.turret_yaw_speed = 3.33;
  self.ai_angleLimits = '-120 120 0';
  if( (self.flags & FL_MONSTER) ){
    self.data_speed_accel = 0.007;
  }
#endif
//=====================================
 
//MECH COMPONENTS====================
  //center torso
  data_ini_torso_center_( "models/mechs/sapper/sapper_tor_c.md3", 575, '0 0 0', '0 6 0' );
  
  //left torso
  data_ini_torso_left_( "models/mechs/sapper/sapper_tor_l.md3", 500, '-6.3 9.5 -2', '-8 12.25 0' );
  
  //right torso
  data_ini_torso_right_( "models/mechs/sapper/sapper_tor_r.md3", 500, '6.3 9.5 -2', '8 12.25 0' );
  
  //left arm
  data_ini_arm_left_( "models/mechs/sapper/sapper_arm_l.md3", 450, '-10.5 10 -2', '-14 7 0' );
  
  //right arm
  data_ini_arm_right_( "models/mechs/sapper/sapper_arm_r.md3", 450, '10.5 10 -2', '14 7 0' );
  
  //legs
  data_ini_legs_( "models/mechs/sapper/sapper_legs.md3", 650, '0 0 0.5' );
  
  //camera location
  #ifdef CSQC
    self.cameraOffset = '0 15 9';
  #else
    self.cameraOffset = '0 15 2';
  #endif
  
//=====================================
 
//HARDPOINT DATA======================
  data_ini_unitHardpoint_1( M_ARM_RIGHT, '12.5 0 5', '0 0 0',       (BAL1|ENE1|MIS1) );
  data_ini_unitHardpoint_2( M_ARM_LEFT, '-12.5 0 5', '0 0 0',      (BAL1|ENE1|MIS1) );
  data_ini_unitHardpoint_3( M_TOR_RIGHT, '8.35 14.75 -1', '0 0 0',  (BAL2|BAL3|MIS1|MIS2|MIS3|ENE3) );
  data_ini_unitHardpoint_4( M_TOR_LEFT, '-8.35 14.75 -1', '0 0 0', (BAL2|BAL3|MIS1|MIS2|MIS3|ENE3));
  data_ini_unitHardpoint_5( M_TOR_CENTER, '3.35 5.5 3', '0 0 0',    (MSC1|MSC2) );
  data_ini_unitHardpoint_6( M_TOR_CENTER, '3.35 8.5 3', '0 0 0',    (MSC1|MSC3|MIS2));
  data_ini_unitHardpoint_7( M_TOR_CENTER, '-3.35 5.5 3', '0 0 0',   (MSC1|MSC2) );
  data_ini_unitHardpoint_8( M_TOR_CENTER, '-3.35 8.5 3', '0 0 0',   (MSC1|MSC3|MIS3));
//=====================================

//HUD Data=============================
#ifdef CSQC
  if( self.classname == "UI_ITEM" ){
    precache_model("models/mechs/sapper/sapper_view.obj");
    precache_model("models/mechs/sapper/sapper_hud.obj");
    self.weaponmodel = "models/mechs/sapper/sapper_view.obj";
    self.hud_model = "models/mechs/sapper/sapper_hud.obj";
    self.hud_StrutsOffset = '0 -2.2 -0.75';
    self.pitchMax = 40;
    self.pitchMin = -40;
    self.hud_rollangle = 3.25;
    
    self.hud_bob = 2.0;
    self.hud_bob_up = 4.0;
    
    self.hud_bob_cycle = 0.5;
    self.hud_bob_model = 1;
    self.hud_bob_side = 0.35;
    self.hud_bob_speed = 6.55;
    self.hud_bob_model_up = 0.1;
  //====================================

  //UI Data=============================
    self.config_default_regular = sapper_config_default_reg;
    self.config_default_missile = sapper_config_default_missile;
    self.config_default_brawl = sapper_config_default_brawl;
    self.abbrev = "SPR";
    self.description = "SAPPER mechs were drafted and produced right before the Federation treaty was ratified. Off-world concerns asked for a strong second-line METAL to support other medium formations. What they got from the factories was dubbed the SAPPER based on its hardpoint configuration and shield output. | | The mech trades a lot of offensive firepower for equipment and shields. Its ability to withstand heavy anti-shield damage allows the mech to move-and-fire against tougher opponents. | | SAPPERs won`t halt an attack by themselves but they remain a powerful force multiplier in both Militar and Survest armies...even if they can no longer be built in large numbers.";
    self.icon = "gfx/ui/mech_icons/icon_sapper.png";
    //Menu position for hardpoint icons in UI_HANGAR / UI_ARMING
    local entity hardpnt;
    hardpnt = self.w_slot;
    hardpnt.uiOffset = '-92 60';//#1 M_ARM_RIGHT
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '96 60'; //#3 M_ARM_LEFT
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '-56 -45';//#2 M_TOR_RIGHT
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '64 -45';//#4 M_TOR_LEFT
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '-22 24'; //#5 M_TOR_CENTER low/right
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '-22 -5'; //#6 M_TOR_CENTER up/right
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '25 24'; //#7 M_TOR_CENTER low/left
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '25 -5'; //#8 M_TOR_CENTER up/left
  //====================================
  }
#endif
};

#ifdef CSQC
void() sapper_config_default_reg={

  //3 and 4 are the pivot hardpoints,
  //Hardpoint3 - (BAL2|BAL3|MIS1|MIS2|MIS3|ENE3)
  if( INV_HAS_snub_artillery ){
    self.next_wepn3 = INV_HAS_snub_artillery;
  }
  else if( INV_HAS_particle_cannon ){
    self.next_wepn3 = INV_HAS_particle_cannon;
  }
  else if( INV_HAS_missile_swarm ){
    self.next_wepn3 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_missile_activeradar ){
    self.next_wepn3 = INV_HAS_missile_activeradar;
  }
  else if( INV_HAS_quantum_rifle ){
    self.next_wepn3 = INV_HAS_quantum_rifle;
  }
  else if( INV_HAS_missile_laserguide ){
    self.next_wepn3 = INV_HAS_missile_laserguide;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn3 = INV_HAS_rotary_plasma;
  }
  else{
    self.next_wepn3 = UID_ITEM_EMPTY;
  }
  
  //Hardpoint4 - (BAL2|BAL3|MIS1|MIS2|MIS3|ENE3)
  if( INV_HAS_emp ){
    self.next_wepn4 = INV_HAS_emp;
  }
  else if( INV_HAS_particle_cannon ){
    self.next_wepn4 = INV_HAS_particle_cannon;
  }
  else if( INV_HAS_snub_artillery ){
    self.next_wepn4 = INV_HAS_snub_artillery;
  }
  else if( INV_HAS_ion_coil ){
    self.next_wepn4 = INV_HAS_ion_coil;
  }
  else if( INV_HAS_missile_swarm ){
    self.next_wepn4 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_missile_activeradar ){
    self.next_wepn4 = INV_HAS_missile_activeradar;
  }
  else if( INV_HAS_missile_laserguide ){
    self.next_wepn4 = INV_HAS_missile_laserguide;
  }
  else{
    self.next_wepn4 = INV_HAS_NONE;
  }
  
  //Hardpoint6 (MSC1|MSC3|MIS2));
  if( (self.next_wepn4 == INV_HAS_emp || self.next_wepn4 == INV_HAS_ion_coil || self.next_wepn4 == INV_HAS_particle_cannon) && INV_HAS_recharge_capacitor ){
    self.next_wepn6 = INV_HAS_recharge_capacitor;
  }
  else if( (self.next_wepn4 != INV_HAS_missile_swarm || self.next_wepn4 == INV_HAS_missile_activeradar) && INV_HAS_missile_swarm ){
    self.next_wepn6 = INV_HAS_missile_swarm;
  }
  else if( (self.next_wepn4 == INV_HAS_emp || self.next_wepn4 == INV_HAS_ion_coil || self.next_wepn4 == INV_HAS_particle_cannon) && INV_HAS_heatsink ){
    self.next_wepn6 = INV_HAS_heatsink;
  }
  else if( (self.next_wepn3 == INV_HAS_snub_artillery || self.next_wepn3 != INV_HAS_missile_activeradar || self.next_wepn3 == INV_HAS_missile_swarm) && INV_HAS_adv_reload ){
    self.next_wepn6 = INV_HAS_adv_reload;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn6 = INV_HAS_shield_emitter;
  }
  else{
    self.next_wepn5 = INV_HAS_NONE;
  }
  
  //Hardpoint8 (MSC1|MSC3|MIS3));
  if( (self.next_wepn3 != INV_HAS_missile_swarm || self.next_wepn3 != INV_HAS_missile_activeradar) && INV_HAS_missile_activeradar ){
    self.next_wepn8 = INV_HAS_missile_activeradar;
  }
  else if( (self.next_wepn3 == INV_HAS_snub_artillery || self.next_wepn3 == INV_HAS_missile_activeradar || self.next_wepn3 == INV_HAS_missile_swarm) && INV_HAS_adv_reload ){
    self.next_wepn8 = INV_HAS_adv_reload;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn8 = INV_HAS_shield_emitter;
  }
  else{
    self.next_wepn8 = INV_HAS_NONE;
  } 
  
  
  //Hardpoint5 (MSC1|MSC2) );
  if( (self.next_wepn4 == INV_HAS_emp || self.next_wepn4 == INV_HAS_ion_coil || self.next_wepn4 == INV_HAS_particle_cannon) && self.next_wepn6 != INV_HAS_recharge_capacitor && INV_HAS_energy_battery ){
    self.next_wepn5 = INV_HAS_energy_battery;
  }
  else if( (self.next_wepn4 == INV_HAS_emp || self.next_wepn4 == INV_HAS_ion_coil || self.next_wepn4 == INV_HAS_particle_cannon) && INV_HAS_heatsink ){
    self.next_wepn5 = INV_HAS_heatsink;
  }
  else if( (self.next_wepn3 == INV_HAS_snub_artillery || self.next_wepn3 == INV_HAS_missile_activeradar || self.next_wepn3 == INV_HAS_missile_swarm) && INV_HAS_adv_reload ){
    self.next_wepn5 = INV_HAS_adv_reload;
  }
  else if( (self.next_wepn4 == INV_HAS_snub_artillery || self.next_wepn4 == INV_HAS_missile_activeradar || self.next_wepn4 == INV_HAS_missile_swarm) && INV_HAS_adv_reload ){
    self.next_wepn5 = INV_HAS_adv_reload;
  }
  else{
    self.next_wepn5 = INV_HAS_NONE;
  }
  //Hardpoint7 (MSC1|MSC2) );
  if( (self.next_wepn3 == INV_HAS_snub_artillery || self.next_wepn3 == INV_HAS_missile_activeradar || self.next_wepn3 == INV_HAS_missile_swarm) && INV_HAS_adv_reload ){
    self.next_wepn7 = INV_HAS_adv_reload;
  }
  else if( (self.next_wepn4 == INV_HAS_emp || self.next_wepn4 == INV_HAS_ion_coil || self.next_wepn4 == INV_HAS_particle_cannon) && INV_HAS_heatsink ){
    self.next_wepn7 = INV_HAS_heatsink;
  }
  else if( (self.next_wepn4 == INV_HAS_snub_artillery || self.next_wepn4 == INV_HAS_missile_activeradar || self.next_wepn4 == INV_HAS_missile_swarm) && INV_HAS_adv_reload ){
    self.next_wepn7 = INV_HAS_adv_reload;
  }
  else if( INV_HAS_shield_capacitor ){
    self.next_wepn7 = INV_HAS_shield_capacitor;
  }
  else{
    self.next_wepn7 = INV_HAS_NONE;
  }
  
  //Hardpoint1
  if( ( (self.next_wepn4 == INV_HAS_emp || self.next_wepn4 == INV_HAS_ion_coil) && self.next_wepn6 != INV_HAS_recharge_capacitor) && INV_HAS_light_autocannon ){
    self.next_wepn1 = INV_HAS_light_autocannon;
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
  //Hardpoint2
  if( ((self.next_wepn4 == INV_HAS_emp || self.next_wepn4 == INV_HAS_ion_coil) && self.next_wepn6 != INV_HAS_recharge_capacitor) && INV_HAS_light_autocannon ){
    self.next_wepn2 = INV_HAS_light_autocannon;
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
  
  //GROUPS
  self.w_group1 = WEAPON1 | WEAPON2;
  if( self.next_wepn3 == self.next_wepn4 ){
    self.w_group2 = WEAPON3 | WEAPON4;
  }
  else{
    //emp / ion on Group2
    self.w_group2 = WEAPON4;
    
    self.w_group3 = WEAPON3;
  }
  //link matching missiles
  if( self.next_wepn3 == self.next_wepn6 ){
    self.w_group3 =  self.w_group3 | WEAPON6;
  }
  else{
    self.w_group4 = self.w_group4 | WEAPON6;
  }
  if( self.next_wepn3 == self.next_wepn8 ){
    self.w_group3 =  self.w_group3 | WEAPON8;
  }
  else{
    self.w_group4 = self.w_group4 | WEAPON8;
  }
};

/*
  Config: Missile Boats
    prioritize missiles in every available hardpoint possible.
*/
void() sapper_config_default_missile={
  //Hardpoint3 - BAL2|BAL3| MIS1|MIS2|MIS3| ENE3
  if( INV_HAS_missile_activeradar ){
    self.next_wepn3 = INV_HAS_missile_activeradar;
  }
  else if( INV_HAS_missile_swarm ){
    self.next_wepn3 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_missile_laserguide ){
    self.next_wepn3 = INV_HAS_missile_laserguide;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn3 = INV_HAS_rocket_launcher;
  }
  else if( INV_HAS_emp ){
    self.next_wepn3 = INV_HAS_emp;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn3 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_particle_cannon ){
    self.next_wepn3 = INV_HAS_particle_cannon;
  }
  else{
    self.next_wepn3 = INV_HAS_NONE;
  }
  
  //Hardpoint4 - BAL2|BAL3| MIS1|MIS2|MIS3| ENE3
  if( INV_HAS_missile_activeradar ){
    self.next_wepn4 = INV_HAS_missile_activeradar;
  }
  else if( INV_HAS_missile_swarm ){
    self.next_wepn4 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_missile_laserguide ){
    self.next_wepn4 = INV_HAS_missile_laserguide;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn4 = INV_HAS_rocket_launcher;
  }
  else if( INV_HAS_emp ){
    self.next_wepn4 = INV_HAS_emp;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn4 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_particle_cannon ){
    self.next_wepn4 = INV_HAS_particle_cannon;
  }
  else{
    self.next_wepn4 = INV_HAS_NONE;
  }
  
  //Hardpoint6 - MSC1|MSC3| MIS2
  if( INV_HAS_missile_swarm ){
    self.next_wepn6 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_recharge_capacitor && (self.next_wepn3 == INV_HAS_particle_cannon || self.next_wepn4 == INV_HAS_particle_cannon) ){
    self.next_wepn6 = INV_HAS_recharge_capacitor;
  }
  else if( INV_HAS_recharge_capacitor && (self.next_wepn3 == INV_HAS_emp || self.next_wepn4 == INV_HAS_emp) ){
    self.next_wepn6 = INV_HAS_recharge_capacitor;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn6 = INV_HAS_shield_emitter;
  }
  else if( INV_HAS_adv_reload ){
    self.next_wepn6 = INV_HAS_adv_reload;
  }
  else if( INV_HAS_heatsink ){
    self.next_wepn6 = INV_HAS_heatsink;
  }
  else{
    self.next_wepn6 = INV_HAS_NONE;
  }
  
  //Hardpoint8 - MSC1|MSC3| MIS3
  if( INV_HAS_missile_activeradar ){
    self.next_wepn8 = INV_HAS_missile_activeradar;
  }
  else if( INV_HAS_recharge_capacitor && (self.next_wepn3 == INV_HAS_particle_cannon || self.next_wepn4 == INV_HAS_particle_cannon) ){
    self.next_wepn8 = INV_HAS_recharge_capacitor;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn8 = INV_HAS_shield_emitter;
  }
  else if( INV_HAS_shield_capacitor ){
    self.next_wepn8 = INV_HAS_shield_capacitor;
  }
  else if( INV_HAS_adv_reload ){
    self.next_wepn8 = INV_HAS_adv_reload;
  }
  else if( INV_HAS_heatsink ){
    self.next_wepn8 = INV_HAS_heatsink;
  }
  else{
    self.next_wepn8 = INV_HAS_NONE;
  }
  
  //Hardpoint5 - MSC1|MSC2
  if( (self.next_wepn3 == INV_HAS_ion_coil || self.next_wepn3 == INV_HAS_particle_cannon) && 
        (self.next_wepn4 == INV_HAS_ion_coil || self.next_wepn4 == INV_HAS_particle_cannon) && INV_HAS_energy_battery ){
    self.next_wepn5 = INV_HAS_energy_battery;
  }
  else if( (self.next_wepn3 == INV_HAS_ion_coil || self.next_wepn3 == INV_HAS_particle_cannon) && 
        (self.next_wepn4 == INV_HAS_ion_coil || self.next_wepn4 == INV_HAS_particle_cannon) && INV_HAS_heatsink ){
    self.next_wepn5 = INV_HAS_heatsink;
  }
  else if( INV_HAS_adv_reload ){
    self.next_wepn5 = INV_HAS_adv_reload;
  }
  else if( INV_HAS_shield_capacitor && self.next_wepn8 != INV_HAS_shield_capacitor ){
    self.next_wepn5 = INV_HAS_shield_capacitor;
  }
  else{
    self.next_wepn5 = INV_HAS_NONE;
  }
  
  //Hardpoint7 - MSC1|MSC2
  if( (self.next_wepn3 == INV_HAS_ion_coil || self.next_wepn3 == INV_HAS_particle_cannon) && 
        (self.next_wepn4 == INV_HAS_ion_coil || self.next_wepn4 == INV_HAS_particle_cannon) && 
         self.next_wepn5 != INV_HAS_energy_battery && INV_HAS_energy_battery ){
    self.next_wepn7 = INV_HAS_energy_battery;
  }
  else if((self.next_wepn3 == INV_HAS_ion_coil || self.next_wepn3 == INV_HAS_particle_cannon) && 
        (self.next_wepn4 == INV_HAS_ion_coil || self.next_wepn4 == INV_HAS_particle_cannon) && INV_HAS_heatsink ){
    self.next_wepn5 = INV_HAS_heatsink;
  }
  else if( INV_HAS_adv_reload ){
    self.next_wepn7 = INV_HAS_adv_reload;
  }
  else{
    self.next_wepn7 = INV_HAS_NONE;
  }
  
  
  //Hardpoint1 BAL1|ENE1|MIS1
  if( INV_HAS_missile_laserguide ){
    self.next_wepn1 = INV_HAS_missile_laserguide;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn1 = INV_HAS_rocket_launcher;
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
  else {
    self.next_wepn1 = INV_HAS_NONE;
  }
  //Hardpoint2 BAL1|ENE1|MIS1
  if( INV_HAS_missile_laserguide ){
    self.next_wepn2 = INV_HAS_missile_laserguide;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn2 = INV_HAS_rocket_launcher;
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
  else {
    self.next_wepn2 = INV_HAS_NONE;
  }
  
  //GROUPS
  self.w_group1 = WEAPON1 | WEAPON2;
  if( self.next_wepn3 == self.next_wepn1 ){
    self.w_group1 = self.w_group1 | WEAPON3;
  }
  else{
    self.w_group3 = self.w_group3 | WEAPON3;
  }
  if( self.next_wepn4 == self.next_wepn1 ){
    self.w_group1 = self.w_group1 | WEAPON4;
  }
  else{
    self.w_group3 = self.w_group3 | WEAPON4;
  }
  if( self.next_wepn8 == INV_HAS_missile_activeradar && (self.next_wepn8 == self.next_wepn3 || self.next_wepn8 == self.next_wepn4) ){
    self.w_group3 = self.w_group3 | WEAPON8;
  }
  if( self.next_wepn6 == INV_HAS_missile_swarm && (self.next_wepn6 == self.next_wepn3 || self.next_wepn6 == self.next_wepn4) ){
    self.w_group3 = self.w_group3 | WEAPON8;
  }
  else if( self.next_wepn6 == INV_HAS_missile_swarm ){
    self.w_group2 = self.w_group2 | WEAPON6;
  }
};

/*
  Config: Brawler
    specializes in fire-fights of attrition.
*/
void() sapper_config_default_brawl={
  //Hardpoint3 - BAL2|BAL3| MIS1|MIS2|MIS3 |ENE3
  if( INV_HAS_quantum_rifle ){
    self.next_wepn3 = INV_HAS_quantum_rifle;
  }
  else if( INV_HAS_missile_swarm ){
    self.next_wepn3 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn3 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn3 = INV_HAS_rocket_launcher;
  }
  else if( INV_HAS_snub_artillery ){
    self.next_wepn3 = INV_HAS_snub_artillery;
  }
  else if( INV_HAS_missile_activeradar ){
    self.next_wepn3 = INV_HAS_missile_activeradar;
  }
  else{
    self.next_wepn3 = INV_HAS_NONE;
  }
  //Hardpoint4 - BAL2|BAL3| MIS1|MIS2|MIS3 |ENE3
  if( INV_HAS_quantum_rifle ){
    self.next_wepn4 = INV_HAS_quantum_rifle;
  }
  else if( INV_HAS_missile_swarm ){
    self.next_wepn4 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn4 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn4 = INV_HAS_rocket_launcher;
  }
  else if( INV_HAS_snub_artillery ){
    self.next_wepn4 = INV_HAS_snub_artillery;
  }
  else if( INV_HAS_missile_activeradar ){
    self.next_wepn4 = INV_HAS_missile_activeradar;
  }
  else{
    self.next_wepn4 = INV_HAS_NONE;
  }
  
  //Hardpoint6 - MSC1|MSC3 |MIS2
  if( INV_HAS_missile_swarm ){
    self.next_wepn6 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn6 = INV_HAS_shield_emitter;
  }
  else if( INV_HAS_adv_reload ){
    self.next_wepn6 = INV_HAS_adv_reload;
  }
  else {
    self.next_wepn6 = INV_HAS_NONE;
  }
  
  //Hardpoint8 - MSC1|MSC3 |MIS3
  if( INV_HAS_shield_emitter ){
    self.next_wepn8 = INV_HAS_shield_emitter;
  }
  else if( INV_HAS_adv_reload ){
    self.next_wepn8 = INV_HAS_adv_reload;
  }
  else {
    self.next_wepn8 = INV_HAS_NONE;
  }
  
  //Hardpoint5 - MSC1|MSC2
  if( INV_HAS_adv_reload ){
    self.next_wepn5 = INV_HAS_adv_reload;
  }
  else {
    self.next_wepn5 = INV_HAS_NONE;
  }
  
  //Hardpoint7 - MSC1|MSC2
  if( INV_HAS_adv_reload ){
    self.next_wepn7 = INV_HAS_adv_reload;
  }
  else {
    self.next_wepn7 = INV_HAS_NONE;
  }
  
  //Hardpoint1 - BAL1 |ENE1 |MIS1
  if( INV_HAS_flak ){
    self.next_wepn1 = INV_HAS_flak;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn1 = INV_HAS_light_laser;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn1 = INV_HAS_light_autocannon;
  }
  else {
    self.next_wepn1 = INV_HAS_NONE;
  }
  
  //Hardpoint2 - BAL1 |ENE1 |MIS1
  if( INV_HAS_flak ){
    self.next_wepn2 = INV_HAS_flak;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn2 = INV_HAS_light_laser;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn2 = INV_HAS_light_autocannon;
  }
  else {
    self.next_wepn2 = INV_HAS_NONE;
  }
  
  //GROUPS
  self.w_group1 = WEAPON3 | WEAPON4;
  self.w_group2 = WEAPON1 | WEAPON2;
  self.w_group3 = WEAPON6;
};
#endif