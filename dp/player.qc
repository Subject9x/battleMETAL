
/*
==============================================================================

PLAYER

==============================================================================
*/

$cd id1/models/player_4
$origin 0 -6 24
$base base
$skin skin

//
// running
//
$frame axrun1 axrun2 axrun3 axrun4 axrun5 axrun6

$frame rockrun1 rockrun2 rockrun3 rockrun4 rockrun5 rockrun6

//
// standing
//
$frame stand1 stand2 stand3 stand4 stand5

$frame axstnd1 axstnd2 axstnd3 axstnd4 axstnd5 axstnd6
$frame axstnd7 axstnd8 axstnd9 axstnd10 axstnd11 axstnd12


//
// pain
//
$frame axpain1 axpain2 axpain3 axpain4 axpain5 axpain6

$frame pain1 pain2 pain3 pain4 pain5 pain6


//
// death
//

$frame axdeth1 axdeth2 axdeth3 axdeth4 axdeth5 axdeth6
$frame axdeth7 axdeth8 axdeth9

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8
$frame deatha9 deatha10 deatha11

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11 deathc12 deathc13 deathc14 deathc15

$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7
$frame deathd8 deathd9

$frame deathe1 deathe2 deathe3 deathe4 deathe5 deathe6 deathe7
$frame deathe8 deathe9

//
// attacks
//
$frame nailatt1 nailatt2

$frame light1 light2

$frame rockatt1 rockatt2 rockatt3 rockatt4 rockatt5 rockatt6

$frame shotatt1 shotatt2 shotatt3 shotatt4 shotatt5 shotatt6

$frame axatt1 axatt2 axatt3 axatt4 axatt5 axatt6

$frame axattb1 axattb2 axattb3 axattb4 axattb5 axattb6

$frame axattc1 axattc2 axattc3 axattc4 axattc5 axattc6

$frame axattd1 axattd2 axattd3 axattd4 axattd5 axattd6


/*
==============================================================================
PLAYER
==============================================================================
*/

.float playermovestate, playermovebegin;

void() player_move = [$stand1, player_move]
{
	local float m, n, t;

	m = (self.velocity_x || self.velocity_y) + (self.weapon == IT_WEAPON1) * 2;
	if (m != self.playermovestate)
		self.playermovebegin = time;
	self.playermovestate = m;

	if (m == 0) {n =  5;self.frame = $stand1;  } // gun stand
	else if (m == 1) {n =  6;self.frame = $rockrun1;} // gun run
	else if (m == 2) {n = 12;self.frame = $axstnd1; } // axe stand
	else             {n =  6;self.frame = $axrun1;  } // axe run

	t = (time - self.playermovebegin) * 10;
	t = t - (floor(t / n) * n);
	self.frame = floor(self.frame + t);
};

void() player_movestart =
{
	self.playermovebegin = time;
	self.playermovestate = -1;
	player_move();
};

void() W_FireAxe;
void()	player_axe1		=	[$axatt1	, player_axe2		] {};
void()	player_axe2		=	[$axatt2	, player_axe3		] {};
void()	player_axe3		=	[$axatt3	, player_axe4		] {W_FireAxe();};
void()	player_axe4		=	[$axatt4	, player_movestart	] {};

void()	player_axeb1	=	[$axattb1	, player_axeb2		] {};
void()	player_axeb2	=	[$axattb2	, player_axeb3		] {};
void()	player_axeb3	=	[$axattb3	, player_axeb4		] {W_FireAxe();};
void()	player_axeb4	=	[$axattb4	, player_movestart	] {};

void()	player_axec1	=	[$axattc1	, player_axec2		] {};
void()	player_axec2	=	[$axattc2	, player_axec3		] {};
void()	player_axec3	=	[$axattc3	, player_axec4		] {W_FireAxe();};
void()	player_axec4	=	[$axattc4	, player_movestart	] {};

void()	player_axed1	=	[$axattd1	, player_axed2		] {};
void()	player_axed2	=	[$axattd2	, player_axed3		] {};
void()	player_axed3	=	[$axattd3	, player_axed4		] {W_FireAxe();};
void()	player_axed4	=	[$axattd4	, player_movestart	] {};

void()	player_shot1	=	[$shotatt1	, player_shot2		] {};
void()	player_shot2	=	[$shotatt2	, player_shot3		] {};
void()	player_shot3	=	[$shotatt3	, player_shot4		] {};
void()	player_shot4	=	[$shotatt4	, player_shot5		] {};
void()	player_shot5	=	[$shotatt5	, player_shot6		] {};
void()	player_shot6	=	[$shotatt6	, player_movestart	] {};

void()	player_nail1	=	[$nailatt1	, player_movestart	] {self.frame = $nailatt1 + ((self.weaponframe - 1) & 1);};

void()	player_rocket1	=	[$rockatt1	, player_rocket2	] {};
void()	player_rocket2	=	[$rockatt2	, player_rocket3	] {};
void()	player_rocket3	=	[$rockatt3	, player_rocket4	] {};
void()	player_rocket4	=	[$rockatt4	, player_rocket5	] {};
void()	player_rocket5	=	[$rockatt5	, player_rocket6	] {};
void()	player_rocket6	=	[$rockatt6	, player_movestart	] {};

void()	player_light1	=	[$light1	, player_movestart	] {self.frame = $light1 + ((self.weaponframe - 1) & 1);};

//============================================================================

void(float damgtype) PainSound =
{
	local float rs;

	if (self.health < 1)
		return;

	// water pain sounds
	if (self.watertype == CONTENT_WATER && self.waterlevel == 3)
	{
		self.bubble_count = self.bubble_count + 1;
		if (random() > 0.5)
			sound (self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/drown2.wav", 1, ATTN_NORM);
		return;
	}

	// slime pain sounds
	if (self.watertype == CONTENT_SLIME)
	{
		if (random() > 0.5)
			sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{
		if (random() > 0.5)
			sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
		return;
	}

	if (self.pain_finished > time)
		return;
	self.pain_finished = time + 0.3;

	// don't make multiple pain sounds right after each other

	// ax pain sound
	if (damgtype & DTF_AXHIT)
	{
		sound (self, CHAN_VOICE, "player/axhit1.wav", 1, ATTN_NORM);
		return;
	}


	rs = random() * 6;

	if (rs < 1)
		sound (self, CHAN_VOICE, "player/pain1.wav", 1, ATTN_NORM);
	else if (rs < 2)
		sound (self, CHAN_VOICE, "player/pain2.wav", 1, ATTN_NORM);
	else if (rs < 3)
		sound (self, CHAN_VOICE, "player/pain3.wav", 1, ATTN_NORM);
	else if (rs < 4)
		sound (self, CHAN_VOICE, "player/pain4.wav", 1, ATTN_NORM);
	else if (rs < 5)
		sound (self, CHAN_VOICE, "player/pain5.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "player/pain6.wav", 1, ATTN_NORM);

	return;
};

void()	player_pain1	= [$pain1	, player_pain2		] {};
void()	player_pain2	= [$pain2	, player_pain3		] {};
void()	player_pain3	= [$pain3	, player_pain4		] {};
void()	player_pain4	= [$pain4	, player_pain5		] {};
void()	player_pain5	= [$pain5	, player_pain6		] {};
void()	player_pain6	= [$pain6	, player_movestart	] {};

void()	player_axpain1	= [$axpain1	, player_axpain2	] {};
void()	player_axpain2	= [$axpain2	, player_axpain3	] {};
void()	player_axpain3	= [$axpain3	, player_axpain4	] {};
void()	player_axpain4	= [$axpain4	, player_axpain5	] {};
void()	player_axpain5	= [$axpain5	, player_axpain6	] {};
void()	player_axpain6	= [$axpain6	, player_movestart	] {};

void(entity attacker, float damage, float damgtype, string dethtype) player_pain =
{
	if (damage < 5) // ignore
		return;

	if (self.deadflag)
		return; // dead

	PainSound(damgtype);

	if (self.think != player_move)
		return;

	if (self.invisible_finished > time)
		return;		// eyes don't have pain frames

	if (self.weapon == IT_WEAPON1)
		player_axpain1 ();
	else
		player_pain1 ();
};

void() player_diea1;
void() player_dieb1;
void() player_diec1;
void() player_died1;
void() player_diee1;
void() player_die_ax1;

void() DeathSound =
{
	local float rs, p;

	// water death sounds
	p = pointcontents(self.origin + '0 0 22');
	if (p == CONTENT_SLIME || p == CONTENT_WATER)
	{
		self.bubble_count = self.bubble_count + 20;
		sound (self, CHAN_VOICE, "player/h2odeath.wav", 1, ATTN_NONE);
		return;
	}

	rs = random() * 5;
	if (rs < 1)
		sound (self, CHAN_VOICE, "player/death1.wav", 1, ATTN_NONE);
	else if (rs < 2)
		sound (self, CHAN_VOICE, "player/death2.wav", 1, ATTN_NONE);
	else if (rs < 3)
		sound (self, CHAN_VOICE, "player/death3.wav", 1, ATTN_NONE);
	else if (rs < 4)
		sound (self, CHAN_VOICE, "player/death4.wav", 1, ATTN_NONE);
	else
		sound (self, CHAN_VOICE, "player/death5.wav", 1, ATTN_NONE);
	return;
};


void() PlayerDead =
{
	self.nextthink = -1;
// allow respawn after a certain time
	self.deadflag = DEAD_DEAD;
};

void() GibPlayer =
{
	PlayerGibs("progs/h_player.mdl", 6, "", 0, "", 0);

	self.deadflag = DEAD_DEAD;

	if (self.deathtype == "TELEFRAG" || self.deathtype == "TRIEDTOTELEFRAG")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

	if (random() < 0.5)
		sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
	else
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
};

void() PlayerDie =
{
  
	local float i;

	if (self.deadflag)
	{
		bprint("warning: PlayerDie called twice\n");
		return;
	}

	if (deathmatch || coop)
		//DropBackpack();

	self.items = self.items - (self.items & IT_INVISIBILITY);
	self.invisible_finished = 0;	// don't die as eyes
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;

	//self.weaponmodel="";
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_CORPSE;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;
	if (self.velocity_z < 10)
		self.velocity_z = self.velocity_z + random()*300;

	DeathSound();

	self.angles_x = 0;
	self.angles_z = 0;
	self.avelocity = '0 0 0';
	//setmodel(self, "progs/player.mdl");
  
  self.e_mech.m_isdead = TRUE;
  self.legs.m_isdead = TRUE;
  
  BecomeCorpse(self, player_die_ax1);
	/*if (self.weapon == IT_WEAPON1)
		BecomeCorpse(self, player_die_ax1);
	else
	{
		i = random() * 5;

		if (i < 1) BecomeCorpse(self, player_diea1);
		else if (i < 2) BecomeCorpse(self, player_dieb1);
		else if (i < 3) BecomeCorpse(self, player_diec1);
		else if (i < 4) BecomeCorpse(self, player_died1);
		else            BecomeCorpse(self, player_diee1);
	}*/
};

void() player_suicideframe = [$deatha11, player_suicideframe] {body_nonsolid('-16 -16 -24', '16 16 0');PlayerDead();};

void() set_suicide_frame =
{
	// used by kill and disconnect commands
	if (self.deadflag >= DEAD_DEAD)
		return; // already dead
	self.items = self.items - (self.items & IT_INVISIBILITY);
	self.invisible_finished = 0;	// don't die as eyes
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	setmodel(self, "progs/player.mdl");
	self.frame = $deatha11;
	self.deadflag = DEAD_DEAD;
	self.nextthink = -1;
  BecomeCorpse(self, player_die_ax1);
	//BecomeCorpse(self, player_suicideframe);
};

void()	player_diea1	=	[	$deatha1,	player_diea2	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_diea2	=	[	$deatha2,	player_diea3	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_diea3	=	[	$deatha3,	player_diea4	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_diea4	=	[	$deatha4,	player_diea5	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_diea5	=	[	$deatha5,	player_diea6	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_diea6	=	[	$deatha6,	player_diea7	] {body_solid('-16 -16 -24', '16 16 21');};
void()	player_diea7	=	[	$deatha7,	player_diea8	] {body_solid('-16 -16 -24', '16 16 12');};
void()	player_diea8	=	[	$deatha8,	player_diea9	] {body_nonsolid('-16 -16 -24', '16 16 1');};
void()	player_diea9	=	[	$deatha9,	player_diea10	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diea10	=	[	$deatha10,	player_diea11	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diea11	=	[	$deatha11,	player_diea11	] {body_nonsolid('-16 -16 -24', '16 16 0');PlayerDead();};

void()	player_dieb1	=	[	$deathb1,	player_dieb2	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_dieb2	=	[	$deathb2,	player_dieb3	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_dieb3	=	[	$deathb3,	player_dieb4	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_dieb4	=	[	$deathb4,	player_dieb5	] {body_solid('-16 -16 -24', '16 16 21');};
void()	player_dieb5	=	[	$deathb5,	player_dieb6	] {body_solid('-16 -16 -24', '16 16 12');};
void()	player_dieb6	=	[	$deathb6,	player_dieb7	] {body_solid('-16 -16 -24', '16 16 7');};
void()	player_dieb7	=	[	$deathb7,	player_dieb8	] {body_solid('-16 -16 -24', '16 16 5');};
void()	player_dieb8	=	[	$deathb8,	player_dieb9	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_dieb9	=	[	$deathb9,	player_dieb9	] {body_nonsolid('-16 -16 -24', '16 16 0');PlayerDead();};

void()	player_diec1	=	[	$deathc1,	player_diec2	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_diec2	=	[	$deathc2,	player_diec3	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_diec3	=	[	$deathc3,	player_diec4	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_diec4	=	[	$deathc4,	player_diec5	] {body_solid('-16 -16 -24', '16 16 23');};
void()	player_diec5	=	[	$deathc5,	player_diec6	] {body_solid('-16 -16 -24', '16 16 12');};
void()	player_diec6	=	[	$deathc6,	player_diec7	] {body_nonsolid('-16 -16 -24', '16 16 2');};
void()	player_diec7	=	[	$deathc7,	player_diec8	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diec8	=	[	$deathc8,	player_diec9	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diec9	=	[	$deathc9,	player_diec10	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diec10	=	[	$deathc10,	player_diec11	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diec11	=	[	$deathc11,	player_diec12	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diec12	=	[	$deathc12,	player_diec13	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diec13	=	[	$deathc13,	player_diec14	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diec14	=	[	$deathc14,	player_diec15	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diec15	=	[	$deathc15,	player_diec15	] {body_nonsolid('-16 -16 -24', '16 16 0');PlayerDead();};

void()	player_died1	=	[	$deathd1,	player_died2	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_died2	=	[	$deathd2,	player_died3	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_died3	=	[	$deathd3,	player_died4	] {body_solid('-16 -16 -24', '16 16 22');};
void()	player_died4	=	[	$deathd4,	player_died5	] {body_solid('-16 -16 -24', '16 16 18');};
void()	player_died5	=	[	$deathd5,	player_died6	] {body_solid('-16 -16 -24', '16 16 13');};
void()	player_died6	=	[	$deathd6,	player_died7	] {body_nonsolid('-16 -16 -24', '16 16 3');};
void()	player_died7	=	[	$deathd7,	player_died8	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_died8	=	[	$deathd8,	player_died9	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_died9	=	[	$deathd9,	player_died9	] {body_nonsolid('-16 -16 -24', '16 16 0');PlayerDead();};

void()	player_diee1	=	[	$deathe1,	player_diee2	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_diee2	=	[	$deathe2,	player_diee3	] {body_solid('-16 -16 -24', '16 16 22');};
void()	player_diee3	=	[	$deathe3,	player_diee4	] {body_solid('-16 -16 -24', '16 16 13');};
void()	player_diee4	=	[	$deathe4,	player_diee5	] {body_solid('-16 -16 -24', '16 16 7');};
void()	player_diee5	=	[	$deathe5,	player_diee6	] {body_nonsolid('-16 -16 -24', '16 16 3');};
void()	player_diee6	=	[	$deathe6,	player_diee7	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diee7	=	[	$deathe7,	player_diee8	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diee8	=	[	$deathe8,	player_diee9	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diee9	=	[	$deathe9,	player_diee9	] {body_nonsolid('-16 -16 -24', '16 16 0');PlayerDead();};

void()	player_die_ax1	=	[	$axdeth1,	player_die_ax2	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_die_ax2	=	[	$axdeth2,	player_die_ax3	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_die_ax3	=	[	$axdeth3,	player_die_ax4	] {body_solid('-16 -16 -24', '16 16 21');};
void()	player_die_ax4	=	[	$axdeth4,	player_die_ax5	] {body_solid('-16 -16 -24', '16 16 15');};
void()	player_die_ax5	=	[	$axdeth5,	player_die_ax6	] {body_solid('-16 -16 -24', '16 16 3');};
void()	player_die_ax6	=	[	$axdeth6,	player_die_ax7	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_die_ax7	=	[	$axdeth7,	player_die_ax8	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_die_ax8	=	[	$axdeth8,	player_die_ax9	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_die_ax9	=	[	$axdeth9,	player_die_ax9	] {body_nonsolid('-16 -16 -24', '16 16 0');PlayerDead();};

/*QUAKED dead_player (1 0 0) (-16 -16 -24) (16 16 0)
*/
void() dead_player =
{
	local float r;
	r = random() * 5;
	if (r < 1) deadmonstersetup("progs/player.mdl", "progs/h_player.mdl", player_diea11, 6, 5, HEALTHBODY);
	else if (r < 2) deadmonstersetup("progs/player.mdl", "progs/h_player.mdl", player_dieb9 , 6, 5, HEALTHBODY);
	else if (r < 3) deadmonstersetup("progs/player.mdl", "progs/h_player.mdl", player_diec15, 6, 5, HEALTHBODY);
	else if (r < 4) deadmonstersetup("progs/player.mdl", "progs/h_player.mdl", player_died9 , 6, 5, HEALTHBODY);
	else            deadmonstersetup("progs/player.mdl", "progs/h_player.mdl", player_diee9 , 6, 5, HEALTHBODY);
};

/*QUAKED dead_player_axe (1 0 0) (-16 -16 -24) (16 16 0)
*/
void() dead_player_axe =
{
	deadmonstersetup("progs/player.mdl", "progs/h_player.mdl", player_die_ax9, 6, 5, HEALTHBODY);
};

