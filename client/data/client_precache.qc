/*
battleMETAL
Author: Peter Roohr
Date: 08/24/2018
Overview:
  resource precaching functions
*/

void() dynamic_precache =
{
	local float f;                                      // file handle, basically assigns a number to whatever file is open
	local string ln;                                    // ln = line of the file being read
	f = fopen(strcat("cache/precache_client.txt") , FILE_READ);        // opens "system/precache.txt" to be read
	if (f != -1)                                        // if f = -1 then the file could not be found
	{ 
		ln = fgets(f);                              // this line sets ln to the string read from the file with the file handle of f
		while(ln != "EOF")                    // while there is still text to be read do the following
		{ 
      if( ln != "" && substring(ln,0, 2) != "//" ){       
        if(strstrofs(ln, ".wav",0) != -1)   // this checks if the file extension is .wav for a sound file
        {
          precache_sound(ln);         // if it is a sound, then it precaches said sound
        }
        else if(strstrofs(ln, ".ogg",0) != -1){
          precache_sound(ln);
        }
        else if(strstrofs(ln, ".md3",0) != -1){
          precache_model(ln);         // so precache the model
        }
        else if( strstrofs(ln, ".obj", 0) != -1){
          precache_model(ln);
        }
        else if( strstrofs(ln, ".bsp", 0) != -1){
          precache_file(ln);
        }
        else if( strstrofs(ln, ".png", 0) != -1){
          precache_pic(ln, 8);
        }
        else if( strstrofs(ln, ".tga", 0) != -1){
          precache_pic(ln, 8);
        }
      }
			ln = fgets(f);                      // get a new line from the file
		} 
	} 
	fclose(f);  
};

void() cs_precache={
  HUT_RET_PIP_HRZ = precache_pic("gfx/hud/ret/ret_pip_hrz.png", 0);
  HUT_RET_PIP_VRT = precache_pic("gfx/hud/ret/ret_pip_vrt.png", 0);
  HUT_RET_LOK = precache_pic("gfx/hud/ret/ret_lock.png", 0);
  HUD_RET_HIT = precache_pic("gfx/hud/ret/ret_hit.png", 0);
  HUD_RAD_PIP_BLD = precache_pic("gfx/hud/rad_bld.png", 0);
  HUD_RAD_PIP_MCH = precache_pic("gfx/hud/rad_mch.png", 0);
  HUD_RAD_PIP_NAV = precache_pic("gfx/hud/rad_nav.png", 0);
  HUD_RAD_PIP_VEC = precache_pic("gfx/hud/rad_vec.png", 0);
  
  HUD_TRG_PIP_L = precache_pic("gfx/hud/trg_pip_lft.png", 0);
  HUD_TRG_PIP_R = precache_pic("gfx/hud/trg_pip_rgt.png", 0);
  HUD_TRG_PIP_B = precache_pic("gfx/hud/trg_pip_bot.png", 0);
  HUD_TRG_PIP_U = precache_pic("gfx/hud/trg_pip_up.png", 0);
  
  HUD_DMG_PIP_H = precache_pic("gfx/hud/ret/dmg_pip_hrz.png", 0);

  //cockpit voice
  SND_MCH_SFX_REACT = precache_sound2("sound/mech_react.ogg");
  SND_HUD_VFX_ONLINE = precache_sound2("sound/comp/online.ogg");
  SND_HUD_VFX_ENELOW = precache_sound2("sound/comp/en_low.ogg");
  SND_HUD_VFX_SHDLOW = precache_sound2("sound/comp/sh_low.ogg");
  SND_HUD_VFX_RDRACTIVE = precache_sound2("sound/comp/rdr_active.ogg");
  SND_HUD_VFX_RDRPASSIVE = precache_sound2("sound/comp/rdr_passive.ogg");
  SND_HUD_VFX_CRITARM = precache_sound2("sound/comp/crt_arm.ogg");
  SND_HUD_VFX_CRITTOR = precache_sound2("sound/comp/crt_torso.ogg");
  SND_HUD_VFX_CRITLEG = precache_sound2("sound/comp/crt_legs.ogg");
  SND_HUD_VFX_CRITTONE = precache_sound2("sound/comp/crt_warn.ogg");
  SND_HUD_VFX_NAVRECH = precache_sound2("sound/comp/nav_reach.ogg");
  SND_HUD_VFX_TARGKILL = precache_sound2("sound/comp/trg_kill.ogg");
  SND_HUD_VFX_OBJ_PRIME = precache_sound2("sound/comp/obj_prime.ogg");
  SND_HUD_VFX_OBJ_SECON = precache_sound2("sound/comp/obj_secon.ogg");
  SND_HUD_VFX_OBJ_THIRD = precache_sound2("sound/comp/obj_terti.ogg");
  SND_HUD_VFX_OBJ_FAIL = precache_sound2("sound/comp/obj_fail.ogg");
  SND_HUD_VFX_MSN_WIN = precache_sound2("sound/comp/msn_success.ogg");
  SND_HUD_VFX_MSN_FAL = precache_sound2("sound/comp/msn_fail.ogg");
  SND_HUD_VFX_WEAPONS_ON = precache_sound2("sound/comp/wep_online.ogg");
  SND_HUD_VFX_WEAPONS_OFF = precache_sound2("sound/comp/wep_offline.ogg");
  SND_HUD_VFX_REPAIRS_ON = precache_sound2("sound/comp/repair_on.ogg");
  SND_HUD_VFX_REPAIRS_OFF = precache_sound2("sound/comp/repair_off.ogg");
  SND_HUD_VFX_FIREMODE_CHAIN = precache_sound2("sound/comp/fire_chain.ogg");
  SND_HUD_VFX_FIREMODE_GROUP = precache_sound2("sound/comp/fire_group.ogg");
  
  
  //UI GRAPHICS
  UI_CURSOR_IMG = precache_pic("gfx/ui/ui_cursor.png", 0);
  UI_DEF_BOX_512 = precache_pic("gfx/ui/box_512.png", 0);
  UI_DEF_BOX_256 = precache_pic("gfx/ui/box_256.png", 0);
  UI_DEF_BOX_256_TALL = precache_pic("gfx/ui/box_256_tall.png",0);
  UI_DEF_BOX_256_BOX = precache_pic("gfx/ui/box_256_select.png", 0);
  UI_DEF_BOX_256_THICK = precache_pic("gfx/ui/box_256_select_wide.png", 0);
  UI_DEF_BOX_256_BTN = precache_pic("gfx/ui/box_256_btn.png",0);
  UI_DEF_BOX_256_BRIGHT = precache_pic("gfx/ui/box_256_select_bright.png",0);
  UI_DEF_BOX_64 = precache_pic("gfx/ui/box_64.png",0);
  UI_DEF_REC_64 = precache_pic("gfx/ui/box_64_rec.png",0);
  UI_BTN_ARR_RIGHT = precache_pic("gfx/ui/btn_arr_right.png",0);
  UI_BTN_ARR_LEFT = precache_pic("gfx/ui/btn_arr_left.png",0);
  
  UI_CIRCLE_256 = precache_pic("gfx/ui/circle_256.tga",0);
  UI_CIRCLE_256_SEL = precache_pic("gfx/ui/circle_256_select.tga",0);
  
  HUD_TARGET_BOX = precache_pic("gfx/hud/target_box.png", 0);
  
  HUD_TARGET_BOX_TL = precache_pic("gfx/hud/target_box_tl.png", 0);
  HUD_TARGET_BOX_TR = precache_pic("gfx/hud/target_box_tr.png", 0);
  HUD_TARGET_BOX_BR = precache_pic("gfx/hud/target_box_br.png", 0);
  HUD_TARGET_BOX_BL = precache_pic("gfx/hud/target_box_bl.png", 0);
  
  UI_DEF_NAVPOINT = precache_pic("gfx/ui/hud_navpoint.png",0);
  UI_DEF_DEPLOYPOINT = precache_pic("gfx/ui/hud_deploypoint.png", 0);
  UI_HANGAR_BOX = precache_pic("gfx/ui/hangar_portrait.png",0);
  UI_BOX_SELECT = precache_pic("gfx/ui/box_select.png",0);
  UI_HELP_IMG = precache_pic("gfx/ui/box_64_help.png", 0);
 
  UI_WEP_ENE = precache_pic("gfx/ui/wep_icons/wep_ene.png", 0);
  UI_WEP_BAL = precache_pic("gfx/ui/wep_icons/wep_bal.png", 0);
  UI_WEP_EXP = precache_pic("gfx/ui/wep_icons/wep_exp.png", 0);
  UI_WEP_MSC = precache_pic("gfx/ui/wep_icons/wep_msc.png", 0);
  
  SPRITE_deploy_point_FRAMES[0] = "gfx/ui/sprite/deploy_1.tga";
  SPRITE_deploy_point_FRAMES[1] = "gfx/ui/sprite/deploy_2.tga";
  SPRITE_deploy_point_FRAMES[2] = "gfx/ui/sprite/deploy_3.tga";
  SPRITE_deploy_point_FRAMES[3] = "gfx/ui/sprite/deploy_4.tga";
  
  //STANDUP VOICES
  AI_VOICE_A[0] = "sound/voice/voiceA/voiceA_die.ogg";
  AI_VOICE_A[1] = "sound/voice/voiceA/voiceA_heavyfire.ogg";
  AI_VOICE_A[2] = "sound/voice/voiceA/voiceA_backup.ogg";
  AI_VOICE_A[3] = "sound/voice/voiceA/voiceA_scanning.ogg";
  AI_VOICE_A[4] = "sound/voice/voiceA/voiceA_lostvis.ogg";
  AI_VOICE_A[5] = "sound/voice/voiceA/voiceA_kill.ogg";
  AI_VOICE_A[6] = "sound/voice/voiceA/voiceA_lostvis.ogg";
  AI_VOICE_A[7] = "sound/voice/voiceA/voiceA_copy.ogg";
  AI_VOICE_A[8] = "sound/voice/voiceA/voiceA_spotted.ogg";
  AI_VOICE_A[9] = "sound/voice/voiceA/voiceA_scanning.ogg";
  
  AI_VOICE_B[0] = "sound/voice/voiceB/voiceB_die.ogg";
  AI_VOICE_B[1] = "sound/voice/voiceB/voiceB_heavyfire.ogg";
  AI_VOICE_B[2] = "sound/voice/voiceB/voiceB_backup.ogg";
  AI_VOICE_B[3] = "sound/voice/voiceB/voiceB_scanning.ogg";
  AI_VOICE_B[4] = "sound/voice/voiceB/voiceB_lostvis.ogg";
  AI_VOICE_B[5] = "sound/voice/voiceB/voiceB_kill.ogg";
  AI_VOICE_B[6] = "sound/voice/voiceB/voiceB_lostvis.ogg";
  AI_VOICE_B[7] = "sound/voice/voiceB/voiceB_copy.ogg";
  AI_VOICE_B[8] = "sound/voice/voiceB/voiceB_spotted.ogg";
  AI_VOICE_B[9] = "sound/voice/voiceB/voiceB_scanning.ogg";
  
  AI_VOICE_C[0] = "sound/voice/voiceC/voiceC_die.ogg";
  AI_VOICE_C[1] = "sound/voice/voiceC/voiceC_heavyfire.ogg";
  AI_VOICE_C[2] = "sound/voice/voiceC/voiceC_backup.ogg";
  AI_VOICE_C[3] = "sound/voice/voiceC/voiceC_scanning.ogg";
  AI_VOICE_C[4] = "sound/voice/voiceC/voiceC_lostvis.ogg";
  AI_VOICE_C[5] = "sound/voice/voiceC/voiceC_kill.ogg";
  AI_VOICE_C[6] = "sound/voice/voiceC/voiceC_lostvis.ogg";
  AI_VOICE_C[7] = "sound/voice/voiceC/voiceC_copy.ogg";
  AI_VOICE_C[8] = "sound/voice/voiceC/voiceC_spotted.ogg";
  AI_VOICE_C[9] = "sound/voice/voiceC/voiceC_scanning.ogg";

};