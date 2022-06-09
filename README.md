# _battleMETAL_

## Overview
----------------------
A Total-conversion for the _[DarkPlaces](https://icculus.org/twilight/darkplaces/)_ engine all about mecha combat.

_battleMETAL_ brings giant robot combat inspired by the _Mechwarrior_ and _Earthsiege_ franchises to _Quake's_ frenetic pacing and tech stack. This project adds the following large features to _Darkplaces_ via the _Quake C_ scripting language and use of external file reading.

This is just a repo for the code, the media assets (models, texture, fx) will not be available as they are part of the commercial release of this game. 
![image](https://user-images.githubusercontent.com/12732481/114804853-fe669b00-9d6f-11eb-884d-4f045ab88247.png)
![image](https://user-images.githubusercontent.com/12732481/114804865-045c7c00-9d70-11eb-8f14-35af72008949.png)

An important design goal of _battleMETAL_ has been to create a simple SDK for making small mech games. 
https://github.com/Subject9x/battleMETAL/wiki

### Game Play
----------------------
+ Units can now be mutli-part units, such as the mechs where they have multiple hit locations.
+ Refactored damage logic and algorithm to handle location-specific damage.
+ Locations on units are visibly represented with unique model geomtry and can be removed with animations and logic.
+ Units (and players) can multiple weapons.
+ These multiple weapons can be fired at the same time by using Weapon Groups.
+ Units have new statistics; Energy, Shields, Radar, pitch limits, etc.
+ Weapons and Shields can interact in important ways - certain weapons are better at damaging shields.
+ Weapons are assigned to locations on units, and the player can customize their unit.
+ Weapons are lost when their parent component is destroyed.
+ Buildings also exist in addition to combat units.
+ Base buildings can be interacted with.
+ Sequential unlocks / progression of mechs and weapons.

### AI
----------------------
+ A bespoke solution that replaces the original _Quake_ AI code.
+ Packaged into an API for ease of maintenance.
+ AI uses most of the gameplay features listed here, almost on parity with player.
+ AI behavior is boken down by unit type, each leveraging the API in a few unique ways.
+ Implemented a Nodegraph using something close to A* for navigation.


### HUD
----------------------
+ Player's Heads Up Display rewritten from scratch.
+ HUD layouts are defined in distinct text files.
+ API for rendering all HUD elements.
+ SFX queue system for playing HUD notification sounds in a defined sequence.
+ HUD can display complex information items such as Unit armor diagrams, targeting boxes, reticles, pitch indicators, radar.
+ Full RADAR display system.
+ Player can choose between 4 different reticles each with their own style and animation setup.
+ Player can choose between a few different colors for the HUD text
+ Player can adjust the alpha blending of their HUD.


### GUI
----------------------
+ I'm defining GUI here as all menus that were not covered by the Main Menu System (_Quake_ keeps these distinct).
+ GUI API written from the ground up for the project.
+ GUI can render various common elements such as bar graphs, text wrapping, and buttons.
+ GUI has mouse support just like the Main Menu.
+ GUI is display agnostic, using %'s for screen positions, sizes, and such.


### Map Design
----------------------
+ Documented pipeline for implementing full 3D terrain meshes for engine.
+ All custom game entities have supporting documentation for use in engine standard map editors such as Trenchbroom, NetRadiant and GTKRadiant.
+ Map and Mission file system for loading mission briefing files, game save files.
+ Maps can have formal Objectives that are communicated to the player during gameplay.
+ Maps can have Navigation (Nav) points that are marked for the player.


### Miscellaneous
----------------------
+ An _Animatic_ system for cutscenes. These are defined in their own script files and can be called by the map file using map logic.


### Main Menu System
----------------------
+ Completely overhauled
+ Implemented _Darkplaces_ mouse function extension to the main menu system
+ New layouts for menus. 
+ Graphical improvements to menus.


### Graphics
----------------------
+ New models for almost everything in the game.
+ Weapons have been modeled and are attached to units visibly.
+ Projectile models have also been made from scratch.
+ Particles and special effects have been written using Darkplaces particle system.
+ Completely new terrain textures with normal maps.


### Sound
----------------------
+ Brand new sounds added to game.


### Music
----------------------
+ All new Soundtrack created specifically for the game
+ [Soundtrack by INNER JOIN](https://soundcloud.com/eamonn-mchugh-roohr)

