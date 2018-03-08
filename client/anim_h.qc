/*
mech Mod
Author: Peter Roohr
Date: 3/3/2018
Overview: Header for loading Anim files .anim

An 'anim' or 'animatic' file is for playing simple
slideshow-esque animatics
*/

.float ANM_FILE_STATUS;

//meta tags
string ANM_FILE_META_MUS = "music";
string ANM_FILE_META_MUS_NO = "nomusic";
string ANM_FILE_META_BACK = "backimg";
string ANM_FILE_META_TRANS = "trans";

string ANM_FILE_TAG_IMG = "image";
string ANM_FILE_TAG_SND = "sound";
string ANM_FILE_TAG_TIM = "time";
string ANM_FILE_TAG_POS = "pos";
string ANM_FILE_TAG_SIZE = "size";
string ANM_FILE_TAG_MSG = "text";

float ANM_FRAME_MAX = 20; //this is here for reference, but if modified, MODIFY THE FOLLOWING ARRAY LIMITS!
.float ANM_FRAME_TOTAL;
.float ANM_FRAME_CUR;
.float ANM_FRAME_TIME;
float ANM_PLAYING = FALSE;
float ANM_LOADED = FALSE;
/*
Animatic frames are expressed by 3 things;
  frame_image = the image to display for this frame
  frame_sound = the sound to play at the start of the frame
  frame_time =  the amount of time to show the frame for
*/
string ANM_META_DATA[5];  //_META_ tags
string ANM_FRAME_IMG[20];
string ANM_FRAME_SND[20];
float ANM_FRAME_TIM[20];
vector ANM_FRAME_POS[20];
vector ANM_FRAME_SIZE[20];
string ANM_FRAME_MSG[20];


void(string fileToOpen) anm_getFile;
void(string fileToOpen) anm_parseFile;
void() anm_execute_frame;
void() anm_cleanup;