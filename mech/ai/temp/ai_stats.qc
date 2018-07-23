/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: AI State equations
*/

/*
  Scope : Self
  initialize all the entity vars needed for the unit
*/
void() ai_unit_ini_var={
  self.flags = self.flags | (FL_MONSTER | FL_UNIT);
  //ini all the unit stats
  self.data_idx = 0;
  self.en_cur = 0;
  self.en_max = 0;
  self.en_rate = 0;
  self.sh_cur = 0;
  self.sh_max = 0;
  self.sh_rate = 0;
  self.stat_legs_hp = 0;
  self.stat_ctor_hp = 0;
  self.stat_ltor_hp = 0;
  self.stat_rtor_hp = 0;
  self.stat_larm_hp = 0;
  self.stat_rarm_hp = 0;
  
  self.radar_range = 0; 
  self.was_hit = FALSE;
  self.hitdir_buffer = 0;
  self.stat_hit_dirs = 0;
  self.stat_rdr_mode = FALSE;
  
  self.stat_spr_x = 0;
  self.stat_spr_y = 0;
  self.conv_min = '0 0 0';
  self.conv_max = '0 0 0';
  self.stat_lck_stt = LOCK_NONE;
  self.power_timer = 0;
  self.ideal_yaw = self.angles * '0 1 0';
  self.maxpatience = 0;
  self.patience = 0;
  self.ai_viewcheck = 0;
  self.ai_view = 0;
  self.ai_action_mod = 0;
  self.ai_fight = FALSE;
  self.ai_viewtime = 0;
  self.ai_minrange = 0;
  self.ai_hunt_total = -1;
};

/*
  Scope : Self
  initialize all ai pilot stats, cleans up the ini for any ai unit
*/
void(float rank) ai_pilot_ini_stats={
  local float mod_am, mod_sh, mod_yaw;
  
  self.ai_fov = ai_pilot_optical_range(rank);
  self.ai_radar = ai_pilot_radar_range(rank, self.radar_range);  
  self.ai_view = ai_pilot_view_range(rank);
  self.ai_viewcheck = ai_pilot_view_interval(rank);
  
  ai_core_calcranges();
  mod_am = ai_pilot_armor_mod();
  self.max_health = self.health = self.health * mod_am; 
  self.e_legs.max_health = self.e_legs.health = self.e_legs.health * mod_am; 
  self.e_tor_l.max_health = self.e_tor_l.health = self.e_tor_l.health * mod_am; 
  self.e_tor_r.max_health = self.e_tor_r.health = self.e_tor_r.health * mod_am; 
  self.e_arm_r.max_health = self.e_arm_r.health = self.e_arm_r.health * mod_am; 
  self.e_arm_l.max_health = self.e_arm_l.health = self.e_arm_l.health * mod_am;
  
  mod_sh = ai_pilot_shield_mod();
  self.sh_max = self.sh_cur = self.sh_cur * mod_sh;
  
  if (!self.yaw_speed){
    mod_yaw = ai_pilot_yaw_mod();
    self.yaw_speed = self.m_rot_speed - (self.m_rot_speed * mod_yaw);
  }
  self.ai_leading = ai_pilot_rating_leading();
  self.stat_spr_x = self.conv_min_x + self.conv_max_x;
  self.stat_spr_y = self.conv_min_y + self.conv_max_y;
  self.ai_rte_cnv = ai_pilot_rating_converg();
  self.ai_rte_rng = ai_pilot_rating_range();
  self.stat_rdr_mode = TRUE;
  self.maxpatience = ai_pilot_rating_patience();
  self.ai_action_mod = ai_pilot_action_mod(rank);
  ai_wep_calcranges();
};

float() ai_pilot_rank_byskill={
  switch(skill){
    case 0:
      return AI_RANK_ROK;
    case 1:
      return AI_RANK_REG;
    case 2:
      return AI_RANK_VET;
    case 3:
      return AI_RANK_ACE;
  }
};

float(float rank) ai_pilot_optical_range={
  local float diff;
  diff = cvar("skill");
  diff = (diff / 10) / 2;
  
  switch(rank){
    case AI_RANK_ACE:
      diff = diff + AI_FOV_ACE;
      break;
    case AI_RANK_VET:
      diff = diff + AI_FOV_VET;
      break;
    case AI_RANK_REG:
      diff = diff + AI_FOV_REG;
      break;
    case AI_RANK_ROK : 
    diff = diff + AI_FOV_ROK;
    break;
  }
  return diff;
};

float(float rank, float range) ai_pilot_radar_range={
  local float diff;
  diff = cvar("skill");
  diff = diff * 10;
  
  switch(rank){
    case AI_RANK_ACE :
      diff = diff + 70;
      break;
    case AI_RANK_VET :
      diff = diff + 60;
      break;
    case AI_RANK_REG :
      diff = diff + 50;
      break;
    case AI_RANK_REG : 
    diff = diff + 40;
    break;
  }
  diff = diff / 100;
  diff = range * diff;
  return diff;
};

float(float rank) ai_pilot_view_range={
  local float val, skl;
  skl = cvar("skill");
  switch(rank){
    case AI_RANK_ACE:
      val = 1200;
      break;
    case AI_RANK_VET:
      val = 1000;
      break;
    case AI_RANK_REG:
      val = 800;
      break;
    case AI_RANK_ROK:
      val = 400;
      break;
  }
  if(skl > 0){
    val = val * ( skl + 1);
  }
  return val;
};


float(float rank) ai_pilot_view_interval={
  local float mod;
  mod = cvar("skill") * 2;
  switch(rank){
    case AI_RANK_ACE:
      mod = AI_VIEW_ACE - mod;
      break;
    case AI_RANK_VET:
       mod = AI_VIEW_VET - mod;
      break;
    case AI_RANK_REG:
       mod = AI_VIEW_REG - mod;
      break;
    case AI_RANK_ROK:
       mod = AI_VIEW_ROK - mod;
      break;
  }
  return mod;
};

/*
  reduce action_timer by this amount
*/
float(float rank) ai_pilot_action_mod={
  local float mod;
  mod = cvar("skill") / 2;
  switch(rank){
    case AI_RANK_ACE:
      mod = AI_REFLEX_ACE + mod;
      break;
    case AI_RANK_VET:
       mod = AI_REFLEX_VET + mod;
      break;
    case AI_RANK_REG:
       mod = AI_REFLEX_REG + mod;
      break;
    case AI_RANK_ROK:
       mod = AI_REFLEX_ROK + mod;
      break;
  }
  if( mod < 0 ){
    mod = 0;
  }
  return mod;
};

//gets convergence factor for pilot rating
float() ai_pilot_rating_converg={
  if(self.ai_rank == AI_RANK_ACE){
    return AI_CNV_ACE;
  }
  else if(self.ai_rank == AI_RANK_VET){
    return AI_CNV_VET;
  }
  else if(self.ai_rank == AI_RANK_REG){
    return AI_CNV_REG;
  }
  else{
    return AI_CNV_ROK;
  }
};

//gets range modifier for pilot rating
float() ai_pilot_rating_range={
  if(self.ai_rank == AI_RANK_ACE){
    return AI_RNG_ACE;
  }
  else if(self.ai_rank == AI_RANK_VET){
    return AI_RNG_VET;
  }
  else if(self.ai_rank == AI_RANK_REG){
    return AI_RNG_REG;
  }
  else if(self.ai_rank == AI_RANK_ROK){
    return AI_RNG_ROK;
  }
  else{
    return 1;
  }
};

/*
  Determines how good the AI is at turning their mech around.
  Each mech has a set yaw speed, but this determines if the AI
  is good enough to turn the mech at its set speed, rather than
  having 'slower reflexes'.
*/
float() ai_pilot_yaw_mod={
  if(self.ai_rank == AI_RANK_ACE){
    return AI_ROT_ACE;
  }
  else if(self.ai_rank == AI_RANK_VET){
    return AI_ROT_VET;
  }
  else if(self.ai_rank == AI_RANK_REG){
    return AI_ROT_REG;
  }
  else if(self.ai_rank == AI_RANK_ROK){
    return AI_ROT_ROK;
  }
  else{
    return 1;
  }
};

/*
  Armor amounts for AI units is modified by the game's skill
  rating. Easier skill modes mean each AI has less armor.
*/
float() ai_pilot_armor_mod={
  if(skill == 0){
    return AI_ARMOR_EASY;
  }
  else if(skill == 1){
    return AI_ARMOR_MEDM;
  }
  else if(skill == 2){
    return AI_ARMOR_HARD;
  }
  else if(skill == 3){
    return AI_ARMOR_NIGHT;
  }
  else{
    return AI_ARMOR_EASY;
  }
}

/*
  Armor amounts for AI units is modified by tshe game's skill
  rating. Easier skill modes mean each AI has less armor.
*/
float() ai_pilot_shield_mod={
  if(skill == 0){
    return AI_SHIELD_EASY;
  }
  else if(skill == 1){
    return AI_SHIELD_MEDM;
  }
  else if(skill == 2){
    return AI_SHIELD_HARD;
  }
  else if(skill == 3){
    return AI_SHIELD_NIGHT;
  }
  else{
    return AI_SHIELD_EASY;
  }
}

/*
  This determines how good the AI is at 'leading' its target.
  In practice, this is how badly the AI's aim should trail BEHIND
  its target. Better AI's are better at this.
*/
float() ai_pilot_rating_leading={
  switch( self.ai_rank ){
    case AI_RANK_ACE:
      return AI_LEAD_ACE;
    case AI_RANK_VET:
      return AI_LEAD_VET;
    case AI_RANK_REG:
      return AI_LEAD_REG;
    default :
      return AI_LEAD_ROK;
  }
};

/*
  Determines the starting patience value of the AI.
  Patience is primarily used for ai_combat_huntTarget,
  where patience is initialized to: time + <this value>
  better AI's can hold their patience a bit longer
*/
float() ai_pilot_rating_patience={
  local float ePatience;
  if(self.ai_rank == AI_RANK_ACE){
    ePatience = AI_PTNCE_ACE;
  }
  else if(self.ai_rank == AI_RANK_VET){
    ePatience =  AI_PTNCE_VET;
  }
  else if(self.ai_rank == AI_RANK_REG){
    ePatience =  AI_PTNCE_REG;
  }
  else if(self.ai_rank == AI_RANK_ROK){
    ePatience =  AI_PTNCE_ROK;
  }
  else{
    ePatience =  AI_PTNCE_ROK;
  }
  //skill mod
  ePatience = ePatience + (ePatience * (skill / 100));
  
  //ai quirks mods
  if(self.count1 == AI_STYLE_STALK){
    //stalkers should have the longest patience
    ePatience = ePatience + (ePatience * 0.5);
  }
  else if(self.count1 ==- AI_STYLE_FLANK){
    //flankers get a minor bump in patience
    ePatience = ePatience + (ePatience * 0.25);
  }
  //yes you can have an aggressive stalker, but it wont be great
  //for long hunts
  if(self.count2 == AI_TYPE_AGGRO){
    ePatience = ePatience - (ePatience / 2);
  }
  return ePatience; 
};

/*
  time in seconds in-between checks for anger_monster();
*/
float() ai_core_hitTimeCalc={
  local float sec;
  sec = (self.ai_rank + 2);
  sec = sec * 1.5;
  
  if(self.state_1 == AI_ORDER_ATTACK){
    sec = sec + 1;
  }
  if(self.ai_style == AI_STYLE_STALK){
    sec = sec + 2.5;
  }
  if(self.ai_type == AI_TYPE_AGGRO){
    sec = sec - ( sec * 0.25);
  }
  if(self.ai_type == AI_TYPE_COWRD){
    sec = sec - ( sec * 0.5);
  }
  return sec;
};

/*
  a design conceit, to make sure bots are perfectly firing,
  or inhumanly relentlessly attacking, this function creates
  a random amount of time to make the next attack.
*/
float() ai_core_attackInterval={
  local float cooldown;
  cooldown = self.ai_rank / 2;

  if(self.ai_style == AI_STYLE_SNIPER){
    cooldown = cooldown + 0.35;
  }
  else if(self.ai_style == AI_STYLE_BRAWL){
    cooldown = cooldown + 0.15;
  }
  else if(self.ai_style == AI_STYLE_SKIRM){
    cooldown = cooldown + 0.25;
  }

  if(self.ai_type == AI_TYPE_AGGRO){
    cooldown = cooldown - 0.05;
  }

  if(skill == 0){
    cooldown = cooldown + 1;
  }
  else if(skill == 2){
    cooldown = cooldown + 0.75;
  }
  else if(skill == 2){
    cooldown = cooldown + 0.50;
  }
  else if(skill == 3){
    cooldown = cooldown + 0.25;
  }
  cooldown = util_roll_dice( fabs(cooldown) );
  return cooldown;
};
