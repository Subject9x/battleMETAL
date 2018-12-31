/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: These are the legacy move functions ported from Quake 1.
I put them here so that they could be swapped out at a level of abstraction above themselves.
This universalizes the ai move functions in ai_ctrl.
*/

void(float dist) q1_ai_forward =
{
	walkmove (self.angles_y, dist);
};

void(float dist) q1_ai_back =
{
	walkmove ( (self.angles_y+180), dist);
};


/*
=============
ai_pain

stagger back a bit
=============
*/
void(float dist) q1_ai_pain =
{
	q1_ai_back (dist);
/*
	local float	away;
	
	away = anglemod (vectoyaw (self.origin - self.enemy.origin) 
	+ 180*(random()- 0.5) );
	
	walkmove (away, dist);
*/
};

/*
=============
ai_painforward

stagger back a bit
=============
*/
void(float dist) q1_ai_painforward =
{
	walkmove (self.ideal_yaw, dist);
};

/*
=============
ai_walk

The monster is walking it's beat
=============
*/
void(float dist) q1_ai_walk =
{
	local vector		mtemp;
	
	movedist = dist;
	
	if (self.classname == "monster_dragon")
	{
		movetogoal (dist);
		return;
	}
	// check for noticing a player
	//if (FindTarget ())
		//return;

	movetogoal (dist);
};

/*
=============
ai_stand

The monster is staying in one place for a while, with slight angle turns
=============
*/
void() q1_ai_stand =
{
	//if (FindTarget ())
	//	return;
	
	if (time > self.pausetime)
	{
		self.th_walk ();
		return;
	}
	
// change angle slightly

};

/*
=============
ai_turn

don't move, but turn towards ideal_yaw
=============
*/
void() q1_ai_turn =
{
	//if (FindTarget ())
		//return;
	
	ChangeYaw ();
};

//=============================================================================

/*
=============
ai_run_missile

Turn in place until within an angle to launch a missile attack
=============
*/
void() q1_ai_run_missile ={
  self.ideal_yaw = enemy_yaw;
  ChangeYaw ();
  //if (FacingIdeal()){
  //  self.th_missile ();
  //  self.attack_state = AS_STRAIGHT;
  //}
};

/*
=============
ai_run_slide

Strafe sideways, but stay at aproximately the same range
=============
*/
void() q1_ai_run_slide =
{
	local float	ofs;
	
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (self.lefty)
		ofs = 90;
	else
		ofs = -90;
	
	if (walkmove (self.ideal_yaw + ofs, movedist))
		return;
		
	self.lefty = 1 - self.lefty;
	
	walkmove (self.ideal_yaw - ofs, movedist);
};


/*
=============
ai_run

The monster has an enemy it is trying to kill
=============
*/
void(float dist) q1_ai_run =
{
	local	vector	delta;
	local	float	axis;
	local	float	direct, ang_rint, ang_floor, ang_ceil;
	
	movedist = dist;
// see if the enemy is dead
	if (self.enemy.health <= 0)
	{
		self.enemy = world;
	// FIXME: look all around for other targets
		if (self.oldenemy.health > 0)
		{
			self.enemy = self.oldenemy;
			//HuntTarget ();
      ai_hunt_target();
		}
		else
		{
			if (self.movetarget)
				self.th_walk ();
			else
				self.th_stand ();
			return;
		}
	}

	//self.show_hostile = time + 1;		// wake up other monsters

// check knowledge of enemy
	//enemy_vis = ai_visible(self.enemy);
	if (enemy_vis)
		//self.search_time = time + self.maxpatience;

// look for other coop players
	//if (coop && self.search_time < time)
	if (coop )
	{
    if(  ai_find_target_visual()) {
      return;
    }
    else{
      self.enemy = world;
    }
		//if (FindTarget ())
			//return;
    if( ai_find_target_visual() ){
      return;
    }
	}

	//enemy_infront = infront(self.enemy);
	//enemy_infront = ai_target_infront(self.enemy.origin, self.ai_optical / 2, self.ai_optical / 2);
	//enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	if (self.attack_state == AS_MISSILE)
	{
//dprint ("ai_run_missile\n");
		q1_ai_run_missile ();
		return;
	}
	if (self.attack_state == AS_MELEE)
	{
//dprint ("ai_run_melee\n");
		//ai_run_melee ();
		return;
	}

	//if (CheckAnyAttack ())
		//return;					// beginning an attack
		
	if (self.attack_state == AS_SLIDING)
	{
		q1_ai_run_slide ();
		return;
	}
		
// head straight in
	movetogoal (dist);		// done in C code...
};