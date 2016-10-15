#define USE_CSQC_OPTIONALFUNCTIONS 1

// --------------------------------------------------------------------------
// BEGIN REQUIRED CSQC FUNCTIONS

// CSQC_Init : Called every time the CSQC code is initialized (essentially at map load)

void CSQC_Init(float apilevel, string enginename, float engineversion)
{
  ENG_COLOR_CURRENT = DMG_COLOR_GRAY;
}
// CSQC_Shutdown : Called every time the CSQC code is shutdown (changing maps, quitting, etc)
void CSQC_Shutdown(void)
{
}
// CSQC_ConsoleCommand : Used to parse commands in the console that have been registered with the "registercmd" function
// Return value should be 1 if CSQC handled the command, otherwise return 0 to have the engine handle it.
float CSQC_ConsoleCommand(string strMessage)
{
	local float nReturn;
		nReturn = TRUE;
		
	// Tokenize String
	tokenize(strMessage);
	
	// Acquire Command
	local string strCmd;
	strCmd = argv(0);
		
	switch(strCmd)
	{

		default:
			nReturn = FALSE;
			break;
	}
	
	return nReturn;
}
/*
	eventtype: 					0 = key down, 1 = key up, 2 = mouse move delta, 
								3 = mouse move absolute, 4 = accelerometer

	scancode: 					/ mouse x / accelerator x
	unicode(character code):  	/ mouse y / accelerometer y
	key device id:			 	/ mouse device id / accelerometer z
*/

// CSQC_InputEvent : Used to perform actions based on any key pressed or released by the client.
// Return value should be 1 if CSQC handled the key press, otherwise return 0 to have the key passed to the engine.
float CSQC_InputEvent(float eventType, float scanCode, float unicode, float deviceID)
{
	local float bSkipKey;
	local vector mpos, mdelta;

	bSkipKey = FALSE;

/*	was used for showscores. 
	being kept here so i can see how to 
	use this section easier

	if (nKey == 9)
	{
		if(bKeyReleased)
		{
			show_keyItems = 0;
		}
		else
		{
			show_keyItems = 1;
		}		

		bSkipKey = TRUE;
	}
*/

	if(eventType == 2)
	{	//set mouse information
		mdelta = '0 0 0';
		mdelta_x = scanCode;
		mdelta_y = unicode;			
		mdelta_z = deviceID;
	}

	if(eventType == 3)
	{	//set mouse information
		mpos = '0 0 0';
		mpos_x = scanCode;
		mpos_y = unicode;			
		mpos_z = deviceID;

		//print(strcat(vtos(mpos),"\r"));//print mouse position
	}

	//cprint(ftos(nKey));	//print key codes when pressed.

	return bSkipKey;
}

// END REQUIRED CSQC FUNCTIONS
// --------------------------------------------------------------------------

// --------------------------------------------------------------------------
// BEGIN OPTIONAL CSQC FUNCTIONS



#ifdef USE_CSQC_OPTIONALFUNCTIONS
// CSQC_Ent_Update : Called every frame that the server has indicated an update to the SSQC / CSQC entity has occured.
// The only parameter reflects if the entity is "new" to the client, meaning it just came into the client's PVS.

void CSQC_Ent_Update(float bIsNewEntity)
{
	local float i;
	i = readbyte();
  if(i == ENT_ADDVECCOMP){
    if(bIsNewEntity){
      local string n;
      n = readstring();
      if(n == M_LEGS){
        LEG_HP_MX = readbyte();
        LEG_HP_CUR = readbyte();
        LEG_ARM_CUR = readbyte();
        LEG_ARM_MX = readbyte();
      }
    }
  }
}
// CSQC_Ent_Remove : Called when the server requests a SSQC / CSQC entity to be removed.  Essentially call remove(self) as well.
void CSQC_Ent_Remove()
{
	remove(self);
}
// CSQC_Parse_StuffCmd : Provides the stuffcmd string in the first parameter that the server provided.  To execute standard behavior, simply execute localcmd with the string.
void CSQC_Parse_StuffCmd(string strMessage)
{	
	localcmd(strMessage);
}
// CSQC_Parse_Print : Provides the print string in the first parameter that the server provided.  To execute standard behavior, simply execute print with the string.
void CSQC_Parse_Print(string printmsg, float printlvl)
{
	print(printmsg);

// DO STUFF HERE....GNOUNC
}

// CSQC_Parse_CenterPrint : Provides the centerprint string in the first parameter that the server provided.  To execute standard behavior, simply execute cprint with the string.
float CSQC_Parse_CenterPrint(string strMessage)
{
	cprint(strMessage);

	return FALSE;
//	return TRUE;
}
// CSQC_Parse_TempEntity : Handles all temporary entity network data in the CSQC layer.
// You must ALWAYS first acquire the temporary ID, which is sent as a byte.
// Return value should be 1 if CSQC handled the temporary entity, otherwise return 0 to have the engine process the event.

float CSQC_Parse_TempEntity()
{
	local float bHandled;
		bHandled  = TRUE;
	// Acquire TE ID
	local float nTEID;
		nTEID = readbyte();
		
	switch(nTEID)
	{
		//case TE_GUNSHOT:
		//	Do something cool with TE_GUNSHOT!
		//	break;
		default:
			// No special logic for this temporary entity; return 0 so the engine can handle it
			bHandled = FALSE;
			break;
	}
		
	return bHandled;
}
#endif
