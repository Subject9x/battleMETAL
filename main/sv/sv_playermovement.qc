/*
battleMETAL
Author: Peter Roohr
Date: 8/27/2016
Overview: main player move code
ported over from Darkplaces mod
*/

void() SV_PlayerPhysics =
{
	local vector wishvel, wishdir, v;
	local float wishspeed, f;
  
	// this is the first function run each frame, so do bot think here
	//if (clienttype(self) == CLIENTTYPE_BOT)
		//havocbot_think();

	if (self.movetype == MOVETYPE_NONE)
		return;

	if (time != lastclientthink)
	{
		lastclientthink = time;
		sv_maxairspeed = cvar("sv_maxairspeed");
		sv_maxspeed = cvar("sv_maxspeed");
		sv_friction = cvar("sv_friction");
		sv_accelerate = cvar("sv_accelerate");
		sv_stopspeed = cvar("sv_stopspeed");
		sv_gravity = cvar("sv_gravity");
	}

	if (self.punchangle != '0 0 0')
	{
		f = vlen(self.punchangle) - 10 * frametime;
		if (f > 0)
			self.punchangle = normalize(self.punchangle) * f;
		else
			self.punchangle = '0 0 0';
	}

	if (self.punchvector != '0 0 0')
	{
		f = vlen(self.punchvector) - 30 * frametime;
		if (f > 0)
			self.punchvector = normalize(self.punchvector) * f;
		else
			self.punchvector = '0 0 0';
	}

	// if dead, behave differently
	if (self.deadflag)
		return;

	if (!self.fixangle)
	{
		// show 1/3 the pitch angle and all the roll angle
		// LordHavoc: no real interest in porting V_CalcRoll
		//self.angles_z = V_CalcRoll (self.angles, self.velocity)*4;
		self.angles_x = 0;
		self.angles_y = self.v_angle_y + self.punchangle_y;
		self.angles_z = 0;
	}

	if (self.flags & FL_WATERJUMP )
	{
		self.velocity_x = self.movedir_x;
		self.velocity_y = self.movedir_y;
		if (time > self.teleport_time || self.waterlevel == 0)
		{
			self.flags = self.flags - (self.flags & FL_WATERJUMP);
			self.teleport_time = 0;
		}
	}
	else if (self.movetype == MOVETYPE_NOCLIP || self.movetype == MOVETYPE_FLY)
	{
		// noclipping or flying
		self.velocity = self.velocity * (1 - frametime * sv_friction);
		makevectors(self.v_angle);
		//wishvel = v_forward * self.movement_x + v_right * self.movement_y + v_up * self.movement_z;
		wishvel = v_forward * self.movement_x + v_right * self.movement_y + '0 0 1' * self.movement_z;
		// acceleration
		wishdir = normalize(wishvel);
		wishspeed = vlen(wishvel);
		if (wishspeed > sv_maxspeed)
			wishspeed = sv_maxspeed;
		if (time >= self.teleport_time)
		{
			f = wishspeed - (self.velocity * wishdir);
			if (f > 0)
				self.velocity = self.velocity + wishdir * min(f, sv_accelerate * frametime * wishspeed);
		}
	}
	else if (self.waterlevel >= 2)
	{
		// swimming
		makevectors(self.v_angle);
		//wishvel = v_forward * self.movement_x + v_right * self.movement_y + v_up * self.movement_z;
		wishvel = v_forward * self.movement_x + v_right * self.movement_y + '0 0 1' * self.movement_z;
		if (wishvel == '0 0 0')
			wishvel = '0 0 -60'; // drift towards bottom

		wishdir = normalize(wishvel);
		wishspeed = vlen(wishvel);
		if (wishspeed > sv_maxspeed)
			wishspeed = sv_maxspeed;
		wishspeed = wishspeed * 0.7;

		// water friction
		self.velocity = self.velocity * (1 - frametime * sv_friction);

		// water acceleration
		f = wishspeed - (self.velocity * wishdir);
		if (f > 0)
			self.velocity = self.velocity + wishdir * min(f, sv_accelerate * frametime * wishspeed);
	}
	else if (time < self.ladder_time)
	{
		// on a func_ladder or swimming in func_water
		self.velocity = self.velocity * (1 - frametime * sv_friction);
		makevectors(self.v_angle);
		//wishvel = v_forward * self.movement_x + v_right * self.movement_y + v_up * self.movement_z;
		wishvel = v_forward * self.movement_x + v_right * self.movement_y + '0 0 1' * self.movement_z;
		if (self.gravity)
			self.velocity_z = self.velocity_z + self.gravity * sv_gravity * frametime;
		else
			self.velocity_z = self.velocity_z + sv_gravity * frametime;
		if (self.ladder_entity.classname == "func_water")
		{
			f = vlen(wishvel);
			if (f > self.ladder_entity.speed)
				wishvel = wishvel * (self.ladder_entity.speed / f);

			self.watertype = self.ladder_entity.skin;
			f = self.ladder_entity.origin_z + self.ladder_entity.maxs_z;
			if ((self.origin_z + self.view_ofs_z) < f)
				self.waterlevel = 3;
			else if ((self.origin_z + (self.mins_z + self.maxs_z) * 0.5) < f)
				self.waterlevel = 2;
			else if ((self.origin_z + self.mins_z + 1) < f)
				self.waterlevel = 1;
			else
			{
				self.waterlevel = 0;
				self.watertype = CONTENT_EMPTY;
			}
		}
		// acceleration
		wishdir = normalize(wishvel);
		wishspeed = vlen(wishvel);
		if (wishspeed > sv_maxspeed)
			wishspeed = sv_maxspeed;
		if (time >= self.teleport_time)
		{
			f = wishspeed - (self.velocity * wishdir);
			if (f > 0)
				self.velocity = self.velocity + wishdir * min(f, sv_accelerate * frametime * wishspeed);
		}
	}
  //MOVEMENT - RAM SHOCKS ACTIVE------------------------------------------------------------
  else if( time < self.ramCharge ){
    local float stopSpeedSlide;
    local float frictionSlide;
    local float accelerationSlide;
    local float hitStop;

    if(time >= self.ramCharge){
      hitStop = TRUE;
    }
    if( hitStop ){      
      self.ramCharge = time;
      self.ramUp = 0;
      self.ramCool = time + self.ramCooldown;
      return;
    }
    
    stopSpeedSlide = self.vec_size;
    frictionSlide = 0.5;
    accelerationSlide = sv_accelerate;
		//ramming
    self.movement = '0 0 0';
		makevectors(self.ramAngle_y * '0 1 0');
    traceline(self.origin, self.origin + (v_up * (self.mins_z * 1.25)), MOVE_NORMAL, self);
		wishvel = v_forward * self.ramPower_x + v_right * self.ramPower_y;
		// friction
		/*if (self.velocity_x || self.velocity_y)
		{
			v = self.velocity;
			v_z = 0;
			f = vlen(v);
			if (f < stopSpeedSlide)
				f = 1 - frametime * (stopSpeedSlide / f) * frictionSlide;
			else
				f = 1 - frametime * frictionSlide;
			if (f > 0)
				self.velocity = self.velocity * f;
			else
				self.velocity = '0 0 0';
		}*/
		// acceleration
		wishdir = normalize(wishvel);
		wishspeed = vlen(wishvel);
		if (wishspeed > (self.data_speed_forward * (self.data_speed_accel * 2))){
			wishspeed = self.data_speed_forward * (self.data_speed_accel * 2);
    }
    f = wishspeed - (self.ramVelocity * wishdir);
    if (f > 0){
      self.ramVelocity = self.ramVelocity + wishdir * min(f, accelerationSlide * frametime * wishspeed);
    }
    if( self.ramVelocity_x > self.data_speed_forward * 3.5 ){
      self.ramVelocity_x = self.data_speed_forward * 3.5;
    }
    if( self.ramVelocity_y > self.data_speed_forward * 3.5 ){
      self.ramVelocity_y = self.data_speed_forward * 3.5;
    }
    self.velocity = self.ramVelocity;
    self.velocity_z = self.velocity_z + (self.ramPower_x * -0.3);
  }
  //MOVEMENT - REGULAR WALKING------------------------------------------------------------
	else if (self.flags & FL_ONGROUND)
	{
    local vector sprintMove;
		makevectors(self.v_angle_y * '0 1 0');
    if( self.button8 ){
      sprintMove = v_forward * (self.movement_x * self.data_speed_accel);
      sprintMove = sprintMove + v_right * (self.movement_y * self.data_speed_accel);
      wishvel = sprintMove;
    }
    else{
      wishvel = v_forward * self.movement_x + v_right * self.movement_y;
    }
    
		// friction
		if (self.velocity_x || self.velocity_y)
		{
			v = self.velocity;
			v_z = 0;
			f = vlen(v);
			if (f < sv_stopspeed)
				f = 1 - frametime * (sv_stopspeed / f) * sv_friction;
			else
				f = 1 - frametime * sv_friction;
			if (f > 0)
				self.velocity = self.velocity * f;
			else
				self.velocity = '0 0 0';
		}
    
		// acceleration
		wishdir = normalize(wishvel);
		wishspeed = vlen(wishvel);
    
    //actual terrain test
    if( wishvel ){
      local vector stepOne, stepTwo, stepAngles, stepDir;
      stepDir = vectoangles(wishvel);
      makevectors(stepDir);
      traceline(self.origin, self.origin + (v_up * -1024) + (v_forward * -128), MOVE_NORMAL, self);
      stepOne = trace_endpos;
      
      traceline(self.origin, self.origin + (v_up * -1024) + (v_forward * 512), MOVE_NORMAL, self);
      stepTwo = trace_endpos;
      
      stepAngles = vectoangles(stepTwo - stepOne);
      if( stepAngles_x > 1 && stepAngles_x <=90 ) {
        //walking up-hill.
        stepAngles = vectoangles((stepTwo + (v_up * 2)) - stepOne);  //relish factor
        wishspeed = wishspeed * (1.0 - (stepAngles_x / 90));
      }
      else if( stepAngles_x >= 340 && stepAngles_x < 360 ){
        //going dowhill
        stepAngles = vectoangles((stepOne + (v_up * 1.05)) - stepTwo);  //relish factor
        //wishspeed = wishspeed + (wishspeed * (1.0 - (stepAngles_x / 360)));
      }
    }
    
		if (wishspeed > sv_maxspeed)
			wishspeed = sv_maxspeed;
		if (time >= self.teleport_time)
		{
			f = wishspeed - (self.velocity * wishdir);
			if (f > 0)
				self.velocity = self.velocity + wishdir * min(f, sv_accelerate * frametime * wishspeed);
		}
	}
  //MOVEMENT - AIR BORN------------------------------------------------------------
	else
	{
		makevectors(self.v_angle_y * '0 1 0');
		wishvel = v_forward * self.movement_x + v_right * self.movement_y;
		// acceleration
		wishdir = normalize(wishvel);
		wishspeed = vlen(wishvel);
		if (wishspeed > sv_maxairspeed)
			wishspeed = sv_maxairspeed;
		if (time >= self.teleport_time)
		{
			f = wishspeed - (self.velocity * wishdir);
			if (f > 0)
				self.velocity = self.velocity + wishdir * min(f, sv_accelerate * frametime * wishspeed);
		}
	}
  self.prevMovement = self.movement;
};