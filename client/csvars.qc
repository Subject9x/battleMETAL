
float autocvar_vid_conwidth;
float autocvar_vid_conheight;
float autocvar_vid_pixelheight;
float maxclients;
float vid_width;
float vid_height;
float vid_conwidth;
float vid_conheight;
float vid_pixelheight;
float autocvar_chase_active;

.float() t_remove; // called by CSQC_Ent_Remove to clean up this entity, return TRUE if remove(self) should be performed afterward

float ENT_INVALID = 0; // never used
float ENT_GAMESETTINGS = 1; // provide game parameters such as frag limit, time limit, etc...
float ENT_PLAYER = 2; // player entity (origin, aimdir, active weapon, etc)
float ENT_INVENTORYITEM = 3; // inventory items in this player's inventory are networked this way
