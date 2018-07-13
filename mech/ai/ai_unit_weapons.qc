/*
mech Mod
Date: 3/9/2018
Overview: Main file for executing AI weapon attacks
  contains helper functions for the AI to use its weapons semi-competently
*/

/*
  Main hook for AI attack calls
*/
void() ai_attack={
  local entity wep_chain, this;
  local float wep_count, fired;
  this = self;
  wep_chain = self.w_slot;
  wep_count = wep_chain.w_group;
  self.w_fire_ofs = ai_attack_aimpoint();
  while(wep_chain){
    local float wgrp;
    wgrp = wep_chain.w_group;
    if(self.button0){
      if(wep_chain.w_state == READY){
        if( ai_target_facingideal() && (self.stat_trg_dist <= wep_chain.w_range) ){
          if( !ai_attack_shotBlock(wep_chain) ){
            if( ai_attack_checkEne(wep_chain) ){
              self = wep_chain;
                if( (self.p_dmgtype & EFF_STX) ){
                  if (this.trigger_field.sh_cur >= self.p_damage){
                    fired = fired + 1;
                    self.w_attack();
                  }
                }
                else{
                  fired = fired + 1;
                  self.w_attack();
                }
              self = this; 
            }         
          }
        }
      }
    }
    else{
      if(wep_chain.w_isburst == TRUE){
        if(wep_chain.w_state == READY){
          self = wep_chain;
            self.w_attack();
          self = this;
        }
      }
    }
    wep_chain = wep_chain.w_slot;
  }
  if( fired > 0 ){
    self.attack_finished = time + ai_core_attackInterval();
  }
};

/*
  
*/
vector() ai_attack_aimpoint={
  local entity cam;
  local vector lead, cam_ofs;
  lead = self.trigger_field.origin - (self.trigger_field.velocity * self.ai_leading);
  lead = normalize(lead - self.origin);
  cam = self.e_cam;
  makevectors(self.angles);
  cam_ofs = cam.origin + (v_forward * (self.c_bbx_x_x / 2) );
  traceline(cam_ofs, self.trigger_field.origin, FALSE, self);
  return trace_endpos;
};

vector(entity ai) ai_attack_calcSpread={
  local vector hitorg;
  local float rng, cnv, cx, cy;
  if(ai.stat_trg_dist > ai.ai_minrange){
    cnv = cnv * rng;
  }
  cx = cnv;
  cx = cx + ( cnv / 2 * random() );
  cx = cx * crandom();
  cy = cnv; 
  cy = cy + ( cnv / 2 * random() );
  cy = cy * crandom();
  makevectors(ai.angles);
  hitorg = ai.w_fire_ofs + (v_up * cy) + (v_right * cx);
  return hitorg;
};
/*
  simple validation, AI should only fire a weapon that
  has a power draw IF the AI has more than half of the current energy
  on-hand
*/  
float(entity wep) ai_attack_checkEne={
  if(self.en_cur  >= wep.en_rate ){
    return TRUE;
  }
  return FALSE;
};

/*
  Don't fire if the weapon's barrel is blocked by things like:
  non-target entity
  friendlies
*/  
float(entity wep) ai_attack_shotBlock={
  local vector viewpont;
  makevectors(self.angles);
  traceline (self.e_cam.origin + v_forward * 1, self.trigger_field.origin, FALSE, self);
  viewpont = trace_endpos;
  
  makevectors(wep.angles);
  tracebox(viewpont, '-2 -2 -2', '2 2 2', wep.origin, FALSE, self);
  if(trace_ent == world){
    return TRUE;
  }
  if(trace_ent.i_faction == self.i_faction){
    return TRUE;
  }
  if(trace_ent != self.trigger_field){
    if(self.p_damage <= AI_RANK_VET){
      if(self.ai_type != AI_TYPE_AGGRO){
        return TRUE;
      }
    }
  }
  return FALSE;
};