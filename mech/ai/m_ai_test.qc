/*
  mech Mod
  Date: 5/2/2017
  Overview: super simple ai test
*/

float(entity ent, float changed) send_ai_mech={
//super ugly hack, send ai's e_cam ent
  WriteByte( MSG_ENTITY, 3 ); // Unique Identifier, I suggest you use enums to make it easy on yourself
  WriteByte( MSG_ENTITY, self.owner.data_idx);
  WriteByte( MSG_ENTITY, self.owner.p_class);
  WriteByte( MSG_ENTITY, self.owner.sh_cur);
  WriteByte( MSG_ENTITY, self.owner.stat_rdr_mode);
  WriteByte( MSG_ENTITY, self.owner.i_faction);
  WriteCoord( MSG_ENTITY, self.owner.origin_x ); // Position X
  WriteCoord( MSG_ENTITY, self.owner.origin_y ); // Position Y
  WriteCoord( MSG_ENTITY, self.owner.origin_z ); // Position Z
  return TRUE;
};


/*QUAKED ai_mech (1 0 0) (-16 -16 -24) (16 16 40)
nextVecChoice = match to mech data id
i_faction = which faction
ai_leading = how bad does the ai suck? 0.0 is ACE, 0.2 is pretty bad
*/
void() ai_mech={
  //DEBUG
  /*if(deathmatch){
    remove(self);
    return;
  }*/
  
  self.flags = self.flags | FL_MONSTER;
  //ini all the unit stats
  self.p_class = P_MECH;
  self.i_faction = 2; // DEBUG
  self.ai_leading = 0.075; //DEBUG
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
  self.stat_rdr_mode = 0;
  
  self.stat_spr_x = 0;
  self.stat_spr_y = 0;
  self.conv_min = '0 0 0';
  self.conv_max = '0 0 0';
  self.stat_lck_stt = LOCK_NONE;


  local entity dat;
  dat = mh_world_findData(self.nextVecChoice, DATA_MECH);
  if(!dat){
    bprint(strcat("mech id:",ftos(self.nextVecChoice)," was not found","\n"));
    remove(self);
    return;
  }

  self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed){
    if(self.nextVecChoice == 1){
      self.yaw_speed = 8;//20;
    }
    else if(self.nextVecChoice == 2){
      self.yaw_speed = 6;//10;
    }
    else if(self.nextVecChoice == 3){
      self.yaw_speed = 4;//2.5;
    }
  }
		
  buildVehicle(dat);
  
  self.solid = SOLID_BBOX;
  self.th_die = ai_mech_die;
  self.th_missile = ai_mech_attack;
  self.ai_unit_update = ai_mech_update;
  self.ai_next_state = ai_state_ready;
  self.ai_next_move = ai_move_stand;
  self.touch = ai_mech_touch;
  self.ai_optical = self.radar_range /2;
  self.patience = 0;
  self.origin_z = self.origin_z + 1;	// raise off floor a bit
	droptofloor();
  self.movetarget = world;
  self.oldgoal = world;
  
	if (!walkmove(0,0))
	{
		dprint ("walkmonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}
  if (self.target)
	{
		self.goalentity = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!self.goalentity)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		if (self.goalentity.classname == "ai_node"){
      self.ai_next_state = ai_state_tonode;
      self.ai_next_move = ai_move_walk_goal;
		}else{
			self.pausetime = 99999999;
      self.ai_next_state = ai_state_ready;
      self.ai_next_move = ai_move_stand;
    }
	}
	else
	{
		self.pausetime = 99999999;
    self.ai_next_state = ai_state_ready;
    self.ai_next_move = ai_move_stand;
	}

  self.e_cam.SendEntity = send_ai_mech;
  self.e_cam.SendFlags = 1;
  self.think = ai_control;
  self.nextthink = time + 5; //power up timer
};