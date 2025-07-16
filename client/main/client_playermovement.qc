/*
battleMETAL
Author: Peter Roohr
Date: 01/16/2023
Overview: main player move code
ported over from Darkplaces mod.

Copied down to CSQC to be run for player prediction.

*/

void() CS_PlayerPhysics =
{
	local vector wishvel;
	local vector wishdir; 
	local vector v;
	local float wishspeed; 
	local float f;
	local float stopSpeedSlide;
	local float frictionSlide;
	local float accelerationSlide;
	local float hitStop;
	local float avgTopSpeed;
	local float decel;
	local float friction;
	local vector stepOne;
	local vector stepTwo;
	local vector stepAngles;
	local vector stepDir;
	local float ramSpeedMax;
  
	// this is the first function run each frame, so do bot think here
	//if (clienttype(self) == CLIENTTYPE_BOT)
		//havocbot_think();

	if (self.movetype == MOVETYPE_NONE)
		return;

	if (time != lastclientthink)
	{
		lastclientthink = time;
		cs_maxairspeed = cvar("cs_maxairspeed");
		cs_maxspeed = cvar("cs_maxspeed");
		cs_friction = cvar("cs_friction");
		cs_accelerate = cvar("cs_accelerate");
		cs_stopspeed = cvar("cs_stopspeed");
		cs_gravity = cvar("cs_gravity");
	}

	/*if (self.punchangle != '0 0 0')
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
	}*/

	// if dead, behave differently
	if (self.deadflag){
		return;
	}
	if (!self.fixangle)
	{
		// show 1/3 the pitch angle and all the roll angle
		// LordHavoc: no real interest in porting V_CalcRoll
		//self.angles_z = V_CalcRoll (self.angles, self.velocity)*4;
		self.angles_x = 0;
		//self.angles_y = self.v_angle_y + self.punchangle_y;
		self.angles_y = self.v_angle_y;
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
		self.velocity = self.velocity * (1 - frametime * cs_friction);
		makevectors(self.v_angle);
		//wishvel = v_forward * self.movement_x + v_right * self.movement_y + v_up * self.movement_z;
		wishvel = v_forward * self.movement_x + v_right * self.movement_y + '0 0 1' * self.movement_z;
		// acceleration
		wishdir = normalize(wishvel);
		wishspeed = vlen(wishvel);
		if (wishspeed > cs_maxspeed){
			wishspeed = cs_maxspeed;
		}
		if (time >= self.teleport_time)
		{
			f = wishspeed - (self.velocity * wishdir);
			if (f > 0){
				self.velocity = self.velocity + wishdir * min(f, cs_accelerate * frametime * wishspeed);
			}
		}
	}
	// 
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
    accelerationSlide = cs_accelerate;
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
	if (wishspeed > (self.data_speed_forward * (self.data_speed_sprint * 2))){
		wishspeed = self.data_speed_forward * (self.data_speed_sprint * 2);
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
	makevectors(self.v_angle_y * '0 1 0');
	wishvel = v_forward * self.movement_x + v_right * self.movement_y;
	if( self.button8 ){
		wishvel = wishvel * self.data_speed_sprint;
	}
	decel = self.data_speed_decel;
	friction = cvar("sv_friction");
	if(vlen(wishvel) != 0){
		decel = decel * 0.25;
		friction = friction * 0.5;
	}
	
	// friction
	if (self.velocity_x || self.velocity_y)
	{
		v = self.velocity;
		v_z = 0;
		f = vlen(v);
		if (f < decel){
			f = 1 - frametime * (decel / f) * friction;
		}
		else{
			f = 1 - frametime * friction;
		}
		if (f > 0){
			self.velocity = self.velocity * f;
		}
		else{
			self.velocity = '0 0 0';
		}
	}


	// acceleration
	wishdir = normalize(wishvel);
	wishspeed = vlen(wishvel);
	if(self.data_speed_forward > self.data_speed_strafe){
		avgTopSpeed = self.data_speed_forward;
	}
	else{
		avgTopSpeed = (self.data_speed_forward + self.data_speed_strafe) / 2;
	}
	if( self.button8 ){
		avgTopSpeed = avgTopSpeed * self.data_speed_sprint;
	}
	if(wishspeed > avgTopSpeed){
		wishspeed = avgTopSpeed;
	}
    
	//actual terrain test
	if( (self.flags & FL_ONGROUND) && vlen(self.movement) != 0.0){
		stepDir = vectoangles(wishvel);
		makevectors(stepDir);
		
		traceline(self.origin + (v_forward * -8), self.origin + (v_up * -512) + (v_forward * -32), MOVE_WORLDONLY, self);
		stepOne = trace_endpos;

		traceline(self.origin + (v_forward * 8), self.origin + (v_up * -512) + (v_forward * 32), MOVE_WORLDONLY, self);
		stepTwo = trace_endpos;
		
		stepAngles = vectoangles(normalize(stepTwo - stepOne));
		if( stepAngles_x >= 33.0 && stepAngles_x < 90.0 ) {
			//walking up-hill.

			stepAngles = vectoangles((stepTwo + (v_up * 2)) - stepOne);  //relish factor
			//clamp to max 55 deg, anything larger drops player move to near-stop.
			stepAngles_x = min(55.0, stepAngles_x);
			wishspeed = wishspeed * (1.0 - (stepAngles_x / 90.0));
		}
		else if( stepAngles_x >= 340.0 && stepAngles_x <= 359.99 ){
			//going dowhill
			wishspeed = wishspeed * 1.1;	//blanket modest speed boost to downhill
		}
		}
    
	if (wishspeed > cvar("sv_maxspeed")){
		wishspeed = cvar("sv_maxspeed");
	}
	if (time >= self.teleport_time)
	{
		f = wishspeed - (self.velocity * wishdir);
		if (f > 0){	
			self.velocity = self.velocity + wishdir * min(f, self.data_speed_accel * frametime * wishspeed);
		}
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
		if (wishspeed > cs_maxairspeed){
			wishspeed = cs_maxairspeed;
		}
		if (time >= self.teleport_time)
		{
			f = wishspeed - (self.velocity * wishdir);
			if (f > 0){
				self.velocity = self.velocity + wishdir * min(f, cs_accelerate * frametime * wishspeed);
			}
		}
	}
	// else if (self.waterlevel >= 2)
	// {
	// 	// swimming
	// 	makevectors(self.v_angle);
	// 	//wishvel = v_forward * self.movement_x + v_right * self.movement_y + v_up * self.movement_z;
	// 	wishvel = v_forward * self.movement_x + v_right * self.movement_y + '0 0 1' * self.movement_z;
	// 	if (wishvel == '0 0 0'){
	// 		wishvel = '0 0 -60'; // drift towards bottom
	// 	}
	// 	wishdir = normalize(wishvel);
	// 	wishspeed = vlen(wishvel);
	// 	if (wishspeed > cs_maxspeed){
	// 		wishspeed = cs_maxspeed;
	// 	}
	// 	wishspeed = wishspeed * 0.7;

	// 	// water friction
	// 	self.velocity = self.velocity * (1 - frametime * cs_friction);

	// 	// water acceleration
	// 	f = wishspeed - (self.velocity * wishdir);
	// 	if (f > 0){
	// 		self.velocity = self.velocity + wishdir * min(f, cs_accelerate * frametime * wishspeed);
	// 	}
	// }
	// else if (time < self.ladder_time)
	// {
	// 	// on a func_ladder or swimming in func_water
	// 	self.velocity = self.velocity * (1 - frametime * cs_friction);
	// 	makevectors(self.v_angle);
	// 	//wishvel = v_forward * self.movement_x + v_right * self.movement_y + v_up * self.movement_z;
	// 	wishvel = v_forward * self.movement_x + v_right * self.movement_y + '0 0 1' * self.movement_z;
	// 	if (self.gravity){
	// 		self.velocity_z = self.velocity_z + self.gravity * cs_gravity * frametime;
	// 	}
	// 	else{
	// 		self.velocity_z = self.velocity_z + cs_gravity * frametime;
	// 	}

	// 	if (self.ladder_entity.classname == "func_water")
	// 	{
	// 		f = vlen(wishvel);
	// 		if (f > self.ladder_entity.speed)
	// 			wishvel = wishvel * (self.ladder_entity.speed / f);

	// 		self.watertype = self.ladder_entity.skin;
	// 		f = self.ladder_entity.origin_z + self.ladder_entity.maxs_z;
	// 		if ((self.origin_z + self.view_ofs_z) < f){
	// 			self.waterlevel = 3;
	// 		}
	// 		else if ((self.origin_z + (self.mins_z + self.maxs_z) * 0.5) < f){
	// 			self.waterlevel = 2;
	// 		}
	// 		else if ((self.origin_z + self.mins_z + 1) < f){
	// 			self.waterlevel = 1;
	// 		}
	// 		else
	// 		{
	// 			self.waterlevel = 0;
	// 			self.watertype = CONTENT_EMPTY;
	// 		}
	// 	}
	// 	// acceleration
	// 	wishdir = normalize(wishvel);
	// 	wishspeed = vlen(wishvel);
	// 	if (wishspeed > cs_maxspeed){
	// 		wishspeed = cs_maxspeed;
	// 	}
	// 	if (time >= self.teleport_time)
	// 	{
	// 		f = wishspeed - (self.velocity * wishdir);
	// 		if (f > 0){
	// 			self.velocity = self.velocity + wishdir * min(f, cs_accelerate * frametime * wishspeed);
	// 		}
	// 	}
	// }
  self.prevMovement = self.movement;
};