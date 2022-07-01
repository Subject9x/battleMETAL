/*
battleMETAL
Author: Peter Roohr
Date: 05/24/2019
Overview:
    Data File - Unit - Mech
        Monitor
        Juggernaut Heavy
*/
#ifdef CSQC
void() monitor_config_default_reg;
void() monitor_config_default_missile;
void() monitor_config_default_brawl;
#endif
/*
  Main ini function for unit.
  Register this in <world_ext_c>
*/
void() data_ini_monitor_={

  self.unitModFlags = self.unitModFlags | MODFLAG_BATTLEMETAL;
  self.data_idx = UID_MECH_monitor;
  self.vec_size = 3;
  self.vec_name = "Monitor";
  
  //Center Torso Health / player central health.
  self.max_health = 864;
  
  //Hitbox size, X width, Y Length, Z height.
  self.mins = '-20 -20 -44';
  self.maxs = '20 20 24';
  
//ENERGY AND SHIELDS===================
  self.energyMax = 600;
  self.energyRate= 3.85;
  self.shieldMax = 375;
  self.shieldRate= 2.75;
  self.startupDelay = 9;
  self.evasionDrain = 1.4;
//=====================================
 
//RADAR================================
  self.radar_range = 1400;
  self.w_firetime = 3;  // lock-on time in seconds
//=====================================

//SPEED================================
  self.data_speed_forward = 90.0;
  self.data_speed_strafe = 90.0;
  self.data_speed_backward = 90.0;
  self.data_speed_accel = 2.0;
  self.ramUpMax = 1;
  self.ramCooldown = 2;
#ifdef CSQC
  //animation playback sync to player move speed.
  self.legMoveRate = 7.75;
  self.legRunRate = 11;
#endif
#ifdef SSQC
  //AI-only Server values.
  self.spreadDefault = ACCURACY_LOWTECH;
  self.yaw_speed = 2;
  self.turret_yaw_speed = 3;
  self.ai_angleLimits = '-150 150 0';
  if( (self.flags & FL_MONSTER) ){
    self.data_speed_accel = 0.005;
  }
#endif
//=====================================
 
//MECH COMPONENTS====================
  //center torso
  data_ini_torso_center_( "q3mdl/mechs/monitor/monitor_tor_c.md3", 864, '0 0 0', '0 6 0' );
 
  //left tors
  data_ini_torso_left_( "q3mdl/mechs/monitor/monitor_tor_l.md3", 800, '-11.5 11 -0.5', '-9.5 11 0' );
 
  //right torso
  data_ini_torso_right_( "q3mdl/mechs/monitor/monitor_tor_r.md3", 800, '11.5 11 -0.5', '8.5 11 0' );
 
  //left arm
  data_ini_arm_left_( "q3mdl/mechs/monitor/monitor_arm_l.md3", 897, '-16 17 -1', '-16 9 0' );
 
  //right arm
  data_ini_arm_right_( "q3mdl/mechs/monitor/monitor_arm_r.md3", 897, '16 17 -1', '16 9 0' );
   
  //legs
  data_ini_legs_( "q3mdl/mechs/monitor/monitor_legs.md3", 1197, '0 -22 0' );
  
  //camera location
#ifdef CSQC
  self.cameraOffset = '0 18 18';
#else
  self.cameraOffset = '0 18 8';
#endif
//=====================================
 
//HARDPOINT DATA======================
  data_ini_unitHardpoint_1( M_ARM_RIGHT, '19 3 10', '0 0 0',    (BAL1|ENE1));
  data_ini_unitHardpoint_2( M_ARM_RIGHT, '16 3 10', '0 0 0',    (BAL1|BAL2|ENE1|ENE2));
  data_ini_unitHardpoint_3( M_ARM_LEFT, '-19 3 10', '0 0 0',    (BAL1|ENE1));
  data_ini_unitHardpoint_4( M_ARM_LEFT, '-16 3 10', '0 0 0',    (BAL1|BAL2|ENE1|ENE2));
  
  data_ini_unitHardpoint_5( M_TOR_RIGHT, '9.45 15.9 6', '0 0 0',(BAL2|BAL3|ENE2|ENE3|MIS3|MSC1|MSC2|MSC3));
  data_ini_unitHardpoint_6( M_TOR_LEFT, '-9.45 15.9 6', '0 0 0',(BAL2|BAL3|ENE2|ENE3|MIS3|MSC1|MSC2|MSC3));
  data_ini_unitHardpoint_7( M_TOR_CENTER, '0 5 5.5', '0 0 0',   (BAL2|MIS1|MIS2|MIS3|MIS4|MSC1|MSC2|MSC3|MSC4));
  data_ini_unitHardpoint_8( M_TOR_RIGHT, '9 6 4.5', '0 0 0',    (BAL2|BAL4|MIS1|MIS2|MIS3|MIS4|MSC1|MSC2|MSC3|MSC4));
  data_ini_unitHardpoint_9( M_TOR_LEFT, '-9 6 4.5', '0 0 0',    (BAL2|BAL4|MIS1|MIS2|MIS3|MIS4|MSC1|MSC2|MSC3|MSC4));
//=====================================

//HUD Data=============================
#ifdef CSQC
  if( self.classname == "UI_ITEM" ){
    self.weaponmodel = "q3mdl/mechs/monitor/monitor_view.obj";
    self.hud_model = "q3mdl/mechs/monitor/monitor_hud.obj";
    self.hud_StrutsOffset = '0 -1.05 0.33';
    self.pitchMax = 43;
    self.pitchMin = -25;
    self.hud_rollangle = 2.75;
    self.hud_bob = 0.05;
    self.hud_bob_cycle = 0.65;
    self.hud_bob_up = 0.35;
    self.hud_bob_model = 1;
    self.hud_bob_side = 0.4;
    self.hud_bob_speed = 3.85;
    self.hud_bob_model_up = 0.15;
  //====================================

  //UI Data=============================
    self.config_default_regular = monitor_config_default_reg;
    self.config_default_missile = monitor_config_default_missile;
    self.config_default_brawl = monitor_config_default_brawl;
    self.abbrev = "MNT";
    self.description = "The great cities of the Federation owe their foundations to the power of the MONITOR. The MONITOR started life as a construction and logistics vehicle used in the civilian markets. | | The MONITOR has taken to its new life as a combat unit fairly well. Being a construction unit gives the MONITOR some of the best armor and structure of any mech. It also allows the MONITOR to carry a large array of weapons and equipment. | | All of this comes at a large cost, unfortunately. The Monitor is the slowest mech on the battlefield, and its reactor capacity is incredibly small.";
    
    //Menu position for hardpoint icons in UI_HANGAR / UI_ARMING
    local entity hardpnt;
    hardpnt = self.w_slot;
    hardpnt.uiOffset = '-95 55'; //#1
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '-68 55'; //#2
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '73 55';//#3
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '100 55';//#4
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '-39 -5'; //#5
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '43 -5'; //#6
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset =  '2 46'; //#7
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '-39 42'; //#8
    
    hardpnt = hardpnt.w_slot;
    hardpnt.uiOffset = '43 42'; //#9
  }
#endif
//====================================
};

#ifdef CSQC
void() monitor_config_default_reg={
  
  //ordered by hierarchy of power.
  
  //Hardpoint 5  BAL2|BAL3 |ENE2|ENE3 |MIS3| MSC1|MSC2|MSC3
  if( INV_HAS_snub_artillery ){
    self.next_wepn5 = INV_HAS_snub_artillery;
  }
  else if( INV_HAS_particle_cannon ){
    self.next_wepn5 = INV_HAS_particle_cannon;
  }
  else if( INV_HAS_emp ){
    self.next_wepn5 = INV_HAS_emp;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn5 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_electro_repeater ){
    self.next_wepn5 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_missile_activeradar ){
    self.next_wepn5 = INV_HAS_missile_activeradar;
  }
  else{
    self.next_wepn5 = INV_HAS_NONE;
  }
  
  //Hardpoint 6  BAL2|BAL3 |ENE2|ENE3 |MIS3| MSC1|MSC2|MSC3
  if( INV_HAS_snub_artillery ){
    self.next_wepn6 = INV_HAS_snub_artillery;
  }
  else if( INV_HAS_particle_cannon ){
    self.next_wepn6 = INV_HAS_particle_cannon;
  }
  else if( (!INV_HAS_emp || self.next_wepn5 != INV_HAS_emp) && INV_HAS_ion_coil ){
    self.next_wepn6 = INV_HAS_ion_coil;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn6 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_electro_repeater ){
    self.next_wepn6 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_missile_activeradar ){
    self.next_wepn5 = INV_HAS_missile_activeradar;
  }
  else{
    self.next_wepn6 = INV_HAS_NONE;
  }
  
  //Hardpoint 2  BAL1|BAL2 |ENE1|ENE2
  if( (self.next_wepn5 != INV_HAS_emp && self.next_wepn6 != INV_HAS_ion_coil) && INV_HAS_ion_coil){
    self.next_wepn2 = INV_HAS_ion_coil;
  }
  else if( (self.next_wepn5 != INV_HAS_electro_repeater && self.next_wepn6 != INV_HAS_electro_repeater) && INV_HAS_electro_repeater){
    self.next_wepn2 = INV_HAS_electro_repeater;
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
  
  //Hardpoint 4  BAL1|BAL2 |ENE1|ENE2
  if( (self.next_wepn5 != INV_HAS_emp && self.next_wepn6 != INV_HAS_ion_coil) && INV_HAS_ion_coil){
    self.next_wepn4 = INV_HAS_ion_coil;
  }
  else if( (self.next_wepn5 != INV_HAS_electro_repeater && self.next_wepn6 != INV_HAS_electro_repeater) && INV_HAS_electro_repeater){
    self.next_wepn4 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn4 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_light_autocannon ){
    self.next_wepn4 = INV_HAS_light_autocannon;
  }
  else if( INV_HAS_light_laser ){
    self.next_wepn4 = INV_HAS_light_laser;
  }
  else if( INV_HAS_flak ){
    self.next_wepn4 = INV_HAS_flak;
  }
  else{
    self.next_wepn4 = INV_HAS_NONE;
  }
  
  
  //Hardpoint 1  BAL1|ENE1
  if( self.next_wepn2 == INV_HAS_ion_coil && INV_HAS_light_autocannon){
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
  //Hardpoint 3  BAL1|ENE1
  if( self.next_wepn4 == INV_HAS_ion_coil && INV_HAS_light_autocannon){
    self.next_wepn3 = INV_HAS_light_autocannon;
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
  
  //Hardpoint 7  BAL2      |MIS1|MIS2|MIS3|MIS4 |MSC1|MSC2|MSC3|MSC4
  if( (self.next_wepn5 == INV_HAS_snub_artillery && self.next_wepn5 == self.next_wepn6) 
        && INV_HAS_adv_reload ){
    self.next_wepn7 = INV_HAS_adv_reload;
  }
  else if( ((self.next_wepn5 == INV_HAS_particle_cannon || self.next_wepn5 == INV_HAS_emp) &&
              (self.next_wepn6 == INV_HAS_particle_cannon || self.next_wepn6 == INV_HAS_ion_coil)) && 
              INV_HAS_recharge_capacitor){
    self.next_wepn7 = INV_HAS_recharge_capacitor;
  }
  else if( ((self.next_wepn5 == INV_HAS_particle_cannon || self.next_wepn5 == INV_HAS_emp) && 
            (self.next_wepn6 == INV_HAS_particle_cannon || self.next_wepn6 == INV_HAS_ion_coil)) && 
            INV_HAS_energy_battery ){
    self.next_wepn7 = INV_HAS_energy_battery;
  }
  else if( INV_HAS_turbo_charger ){
    self.next_wepn7 = INV_HAS_turbo_charger;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn7 = INV_HAS_shield_emitter;
  }
  else if( INV_HAS_shield_capacitor ){
    self.next_wepn7 = INV_HAS_shield_capacitor;
  }
  else if( INV_HAS_missile_activeradar ){
    self.next_wepn7 = INV_HAS_missile_activeradar;
  }
  else if( INV_HAS_missile_swarm ){
    self.next_wepn7 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn7 = INV_HAS_rocket_launcher;
  }
  else{
    self.next_wepn7 = INV_HAS_NONE;
  }
  
  //Hardpoint 8  BAL2|BAL4 |MIS1|MIS2|MIS3|MIS4 |MSC1|MSC2|MSC3|MSC4
  if( self.next_wepn7 == INV_HAS_missile_activeradar || 
      ( (self.next_wepn5 != INV_HAS_snub_artillery && 
          self.next_wepn6 != INV_HAS_snub_artillery) && 
          INV_HAS_missile_activeradar) ){
    self.next_wepn8 = INV_HAS_missile_activeradar;
  }
  else if( (self.next_wepn5 == INV_HAS_electro_repeater && 
          self.next_wepn6 == INV_HAS_electro_repeater) &&
            INV_HAS_rocket_launcher ){
    self.next_wepn8 = INV_HAS_rocket_launcher;
  }
  else if( (self.next_wepn5 == INV_HAS_snub_artillery && self.next_wepn5 == self.next_wepn6) &&
              INV_HAS_rotary_plasma){
    self.next_wepn8 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn8 = INV_HAS_shield_emitter;
  }
  else{
    self.next_wepn8 = INV_HAS_NONE;
  }
  
  //Hardpoint 9  BAL2|BAL4 |MIS1|MIS2|MIS3|MIS4 |MSC1|MSC2|MSC3|MSC4
  if( self.next_wepn7 == INV_HAS_missile_activeradar || 
      ( (self.next_wepn5 != INV_HAS_snub_artillery && 
          self.next_wepn6 != INV_HAS_snub_artillery) && 
          INV_HAS_missile_activeradar) ){
    self.next_wepn9 = INV_HAS_missile_activeradar;
  }
  else if( (self.next_wepn5 == INV_HAS_electro_repeater && 
          self.next_wepn6 == INV_HAS_electro_repeater) &&
            INV_HAS_rocket_launcher ){
    self.next_wepn9 = INV_HAS_rocket_launcher;
  }
  else if( (self.next_wepn5 == INV_HAS_snub_artillery && self.next_wepn5 == self.next_wepn6) &&
              INV_HAS_rotary_plasma){
    self.next_wepn9 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_shield_capacitor ){
    self.next_wepn9 = INV_HAS_shield_capacitor;
  }
  else{
    self.next_wepn9 = INV_HAS_NONE;
  }
  
  //GROUPS
  
  if(self.next_wepn5 == self.next_wepn6){
    if( self.next_wepn5 == INV_HAS_missile_activeradar ){
      self.w_group3 = WEAPON5 | WEAPON6;
    }
    else{
      self.w_group2 = WEAPON5 | WEAPON6; 
    }
  }
  else{
    if(self.next_wepn5 == INV_HAS_emp){
      self.w_group2 = WEAPON5;
      self.w_group3 = WEAPON6;
    }
    else if(self.next_wepn6 == INV_HAS_ion_coil){
      self.w_group2 = WEAPON6;
      self.w_group3 = WEAPON5;
    }
    else{
      if( self.next_wepn5 == INV_HAS_missile_activeradar ){
        self.w_group3 = WEAPON5;
      }
      else if( self.next_wepn6 == INV_HAS_missile_activeradar ){
        self.w_group3 = WEAPON6; 
      }
      else{
        if(self.next_wepn5 == INV_HAS_rotary_plasma ){
          self.w_group1 = self.w_group1 | WEAPON5;
        }
        
        if(self.next_wepn6 == INV_HAS_rotary_plasma ){
          self.w_group1 = self.w_group1 | WEAPON6;
        }
        if(!self.w_group2){
          self.w_group2 = WEAPON5;
        }
        if(!self.w_group3){
          self.w_group3 = WEAPON6;
        }
      }
    }
  }
  
  if( self.next_wepn4 == INV_HAS_ion_coil ){
    if( !self.w_group2 ){
      self.w_group2 = self.w_group2 | WEAPON4;
    }
    else{
      self.w_group1 = self.w_group1 | WEAPON4;
    }
  }
  if( self.next_wepn2 == INV_HAS_ion_coil ){
    if( self.next_wepn4 == INV_HAS_ion_coil && (self.w_group2 & WEAPON4) ){
      self.w_group2 = self.w_group2 | WEAPON2;
    }
    else{
      self.w_group1 = self.w_group1 | WEAPON2;
    }
  }
  
  if( self.next_wepn7 == self.next_wepn5 || (self.next_wepn7 == INV_HAS_missile_activeradar || self.next_wepn7 == INV_HAS_missile_swarm) ){
    self.w_group3 = self.w_group3 | WEAPON7;
  }
  if( self.next_wepn8 == self.next_wepn5 || (self.next_wepn8 == INV_HAS_missile_activeradar || self.next_wepn8 == INV_HAS_missile_swarm) ){
    self.w_group3 = self.w_group3 | WEAPON8;
  }
  if( self.next_wepn9 == self.next_wepn5 || (self.next_wepn9 == INV_HAS_missile_activeradar || self.next_wepn9 == INV_HAS_missile_swarm) ){
    self.w_group3 = self.w_group3 | WEAPON9;
  }
  
  if( self.next_wepn7 == self.next_wepn6 || (self.next_wepn7 == INV_HAS_missile_activeradar || self.next_wepn7 == INV_HAS_missile_swarm) ){
    self.w_group3 = self.w_group3 | WEAPON7;
  }
  if( self.next_wepn8 == self.next_wepn6 || (self.next_wepn8 == INV_HAS_missile_activeradar || self.next_wepn8 == INV_HAS_missile_swarm) ){
    self.w_group3 = self.w_group3 | WEAPON8;
  }
  if( self.next_wepn9 == self.next_wepn6 || (self.next_wepn9 == INV_HAS_missile_activeradar || self.next_wepn9 == INV_HAS_missile_swarm) ){
    self.w_group3 = self.w_group3 | WEAPON9;
  }
  
  //bump missiles to last group
  if( (self.next_wepn6 != INV_HAS_missile_activeradar && self.next_wepn6 != INV_HAS_missile_swarm) &&
    (self.next_wepn5 != INV_HAS_missile_activeradar && self.next_wepn5 != INV_HAS_missile_swarm) ){
    if( (self.w_group3 & WEAPON7 )){
      self.w_group3 = self.w_group3 - (self.w_group3 & WEAPON7);
      self.w_group4 = self.w_group4 | WEAPON7;
    }
    if( (self.w_group3 & WEAPON8 )){
      self.w_group3 = self.w_group3 - (self.w_group3 & WEAPON8);
      self.w_group4 = self.w_group4 | WEAPON8;
    }
    if( (self.w_group3 & WEAPON9 )){
      self.w_group3 = self.w_group3 - (self.w_group3 & WEAPON9);
      self.w_group4 = self.w_group4 | WEAPON9;
    }
  }
  
  if( self.next_wepn8 == INV_HAS_rotary_plasma ){
    self.w_group3 = self.w_group3 | WEAPON8;
  }
  
  if( self.next_wepn9 == INV_HAS_rotary_plasma ){
    self.w_group3 = self.w_group3 | WEAPON9;
  }
  
  if( self.next_wepn1 == self.next_wepn3){
    self.w_group1 = self.w_group1 | WEAPON1 | WEAPON3;
  }
  if( self.next_wepn2 == self.next_wepn4 && (self.next_wepn4 == INV_HAS_electro_repeater || self.next_wepn4 == INV_HAS_light_laser || self.next_wepn4 == INV_HAS_light_autocannon) ){
     self.w_group1 = self.w_group1 | WEAPON2 | WEAPON4;
  }
};

/*
  Config: Missile Boats
    prioritize missiles in every available hardpoint possible.
*/
void() monitor_config_default_missile={
  
  //Hardpoint 5  BAL2|BAL3 |ENE2|ENE3 |MIS3| MSC1|MSC2|MSC3
  if( INV_HAS_missile_activeradar ){
    self.next_wepn5 = INV_HAS_missile_activeradar;
  }
  else if( INV_HAS_ion_coil ){
    self.next_wepn5 = INV_HAS_ion_coil;
  }
  else if( INV_HAS_adv_reload ){
    self.next_wepn5 = INV_HAS_adv_reload;
  }
  else if( INV_HAS_emp ){
    self.next_wepn5 = INV_HAS_emp;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn5 = INV_HAS_shield_emitter;
  }
  else{
    self.next_wepn5 = INV_HAS_NONE;
  }
  //Hardpoint 6  BAL2|BAL3 |ENE2|ENE3 |MIS3| MSC1|MSC2|MSC3
  if( INV_HAS_missile_activeradar ){
    self.next_wepn6 = INV_HAS_missile_activeradar;
  }
  else if( INV_HAS_adv_reload ){
    self.next_wepn6 = INV_HAS_adv_reload;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn6 = INV_HAS_shield_emitter;
  }
  else{
    self.next_wepn6 = INV_HAS_NONE;
  }
  
  //Hardpoint 2  BAL1|BAL2 |ENE1|ENE2
  if( INV_HAS_light_laser ){
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
  //Hardpoint 4  BAL1|BAL2 |ENE1|ENE2
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
  
  //Hardpoint 1  BAL1|ENE1
  if( INV_HAS_light_laser ){
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
  //Hardpoint 3  BAL1|ENE1
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
  
  //Hardpoint 7  BAL2      |MIS1|MIS2|MIS3|MIS4 |MSC1|MSC2|MSC3|MSC4
  if( INV_HAS_missile_activeradar ){
    self.next_wepn7 = INV_HAS_missile_activeradar;
  }
  else if( INV_HAS_missile_swarm ){
    self.next_wepn7 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_missile_laserguide ){
    self.next_wepn7 = INV_HAS_missile_laserguide;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn7 = INV_HAS_rocket_launcher;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn7 = INV_HAS_shield_emitter;
  }
  else if( INV_HAS_shield_capacitor ){
    self.next_wepn7 = INV_HAS_shield_capacitor;
  }
  else{
    self.next_wepn7 = INV_HAS_NONE;
  } 
  
  //Hardpoint 8  BAL2|BAL4 |MIS1|MIS2|MIS3|MIS4 |MSC1|MSC2|MSC3|MSC4
  if( INV_HAS_missile_activeradar ){
    self.next_wepn8 = INV_HAS_missile_activeradar;
  }
  else if( INV_HAS_missile_swarm ){
    self.next_wepn8 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_missile_laserguide ){
    self.next_wepn8 = INV_HAS_missile_laserguide;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn8 = INV_HAS_rocket_launcher;
  }
  else{
    self.next_wepn7 = INV_HAS_NONE;
  } 
  
  //Hardpoint 9  BAL2|BAL4 |MIS1|MIS2|MIS3|MIS4 |MSC1|MSC2|MSC3|MSC4
  if( INV_HAS_missile_activeradar ){
    self.next_wepn9 = INV_HAS_missile_activeradar;
  }
  else if( INV_HAS_missile_swarm ){
    self.next_wepn9 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_missile_laserguide ){
    self.next_wepn9 = INV_HAS_missile_laserguide;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn9 = INV_HAS_rocket_launcher;
  }
  else{
    self.next_wepn7 = INV_HAS_NONE;
  } 
  
  //Groups
  if( self.next_wepn1 == self.next_wepn2 && self.next_wepn1 == self.next_wepn3 && self.next_wepn1 == self.next_wepn4){
    self.w_group1 = WEAPON1 | WEAPON2 | WEAPON3 | WEAPON4;
  }
  
  if( self.next_wepn5 == self.next_wepn6 ){
    if( self.next_wepn5 == INV_HAS_missile_activeradar ){
      self.w_group2 = WEAPON5 | WEAPON6;
    }
  }
  else{
    if( self.next_wepn5 == INV_HAS_ion_coil || self.next_wepn5 == INV_HAS_emp ){
      self.w_group2 = WEAPON6;
      self.w_group3 = WEAPON5;
    }
  }
  if( self.next_wepn7 == self.next_wepn8 && self.next_wepn7 == self.next_wepn9){
    if( self.next_wepn7 == INV_HAS_missile_activeradar || self.next_wepn7 == INV_HAS_missile_swarm || self.next_wepn7 == INV_HAS_rocket_launcher){
      self.w_group2 = self.w_group2 | WEAPON7 | WEAPON8 | WEAPON9;
    }
  }
};

/*
  Config: Brawler
    specializes in close-range firefights.
*/
void() monitor_config_default_brawl={
  
  //Hardpoint 5  BAL2|BAL3 |ENE2|ENE3 |MIS3| MSC1|MSC2|MSC3
  if( INV_HAS_electro_repeater ){
    self.next_wepn5 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn5 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_ion_coil ){
    self.next_wepn5 = INV_HAS_ion_coil;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn5 = INV_HAS_shield_emitter;
  }
  else{
    self.next_wepn5 = INV_HAS_NONE;
  }
  
  //Hardpoint 6  BAL2|BAL3 |ENE2|ENE3 |MIS3| MSC1|MSC2|MSC3
  if( INV_HAS_electro_repeater ){
    self.next_wepn6 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn6 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_ion_coil ){
    self.next_wepn6 = INV_HAS_ion_coil;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn6 = INV_HAS_shield_emitter;
  }
  else{
    self.next_wepn6 = INV_HAS_NONE;
  }
  
  //Hardpoint 2  BAL1|BAL2 |ENE1|ENE2
  if( INV_HAS_electro_repeater ){
    self.next_wepn2 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn2 = INV_HAS_rotary_plasma;
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
  //Hardpoint 4  BAL1|BAL2 |ENE1|ENE2
  if( INV_HAS_electro_repeater ){
    self.next_wepn4 = INV_HAS_electro_repeater;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn4 = INV_HAS_rotary_plasma;
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
  
  //Hardpoint 1  BAL1|ENE1 
  if( INV_HAS_light_autocannon ){
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
  //Hardpoint 3  BAL1|ENE1
  if( INV_HAS_light_autocannon ){
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
  
  //Hardpoint 8  BAL2|BAL4 |MIS1|MIS2|MIS3|MIS4 |MSC1|MSC2|MSC3|MSC4
  if( INV_HAS_missile_swarm ){
    self.next_wepn8 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn8 = INV_HAS_rocket_launcher;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn8 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn8 = INV_HAS_shield_emitter;
  }
  else if( INV_HAS_shield_capacitor ){
    self.next_wepn8 = INV_HAS_shield_capacitor;
  }
  else {
    self.next_wepn8 = INV_HAS_NONE;
  }
  
  //Hardpoint 9  BAL2|BAL4 |MIS1|MIS2|MIS3|MIS4 |MSC1|MSC2|MSC3|MSC4 
  if( INV_HAS_missile_swarm ){
    self.next_wepn9 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn9 = INV_HAS_rocket_launcher;
  }
  else if( INV_HAS_rotary_plasma ){
    self.next_wepn9 = INV_HAS_rotary_plasma;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn9 = INV_HAS_shield_emitter;
  }
  else if( INV_HAS_shield_capacitor ){
    self.next_wepn9 = INV_HAS_shield_capacitor;
  }
  else {
    self.next_wepn9 = INV_HAS_NONE;
  }
  
  
  //Hardpoint 7  BAL2      |MIS1|MIS2|MIS3|MIS4 |MSC1|MSC2|MSC3|MSC4
  if( INV_HAS_turbo_charger ){
    self.next_wepn7 = INV_HAS_turbo_charger;
  }
  else if( INV_HAS_shield_emitter ){
    self.next_wepn7 = INV_HAS_shield_emitter;
  }
  else if( INV_HAS_shield_capacitor ){
    self.next_wepn7 = INV_HAS_shield_capacitor;
  }
  else if( INV_HAS_missile_swarm ){
    self.next_wepn7 = INV_HAS_missile_swarm;
  }
  else if( INV_HAS_rocket_launcher ){
    self.next_wepn7 = INV_HAS_rocket_launcher;
  }
  else{
    self.next_wepn7 = INV_HAS_NONE;
  }
  if( self.next_wepn2 == INV_HAS_electro_repeater && 
      (self.next_wepn2 == self.next_wepn4 && self.next_wepn2 == self.next_wepn5 
        && self.next_wepn2 == self.next_wepn6) ){
    if( INV_HAS_recharge_capacitor ){
      self.next_wepn7 = INV_HAS_recharge_capacitor;
    }
    else if( INV_HAS_energy_battery ){
      self.next_wepn7 = INV_HAS_energy_battery;
    }
  }
  
  //GROUPS
  self.w_group1 = WEAPON1 | WEAPON3;
  if( self.next_wepn2 == self.next_wepn4 ){
    if(self.next_wepn2 == self.next_wepn1 ){
      self.w_group1 = self.w_group1 | WEAPON2 | WEAPON4;
    }
    else{
      self.w_group2 = WEAPON2 | WEAPON4;
    }
  }
  if( self.next_wepn5 == self.next_wepn6 ){
    self.w_group2 = self.w_group2 | WEAPON5 | WEAPON6;
  }
  
  if( self.next_wepn7 == INV_HAS_missile_swarm || self.next_wepn7 == INV_HAS_rocket_launcher ){
    self.w_group3 = self.w_group3 | WEAPON7;
  }
  if( self.next_wepn8 == INV_HAS_missile_swarm || self.next_wepn8 == INV_HAS_rocket_launcher ){
    self.w_group3 = self.w_group3 | WEAPON8;
  }
  else if( self.next_wepn8 == self.next_wepn2 ){
    self.w_group2 = self.w_group2 | WEAPON8;
  }
  else{
    self.w_group1 = self.w_group1 | WEAPON8;
  }
  if( self.next_wepn9 == INV_HAS_missile_swarm || self.next_wepn9 == INV_HAS_rocket_launcher ){
    self.w_group3 = self.w_group3 | WEAPON9;
  }
  else if( self.next_wepn9 == self.next_wepn2 ){
    self.w_group2 = self.w_group2 | WEAPON9;
  }
  else{
    self.w_group1 = self.w_group1 | WEAPON9;
  }
  
};
#endif