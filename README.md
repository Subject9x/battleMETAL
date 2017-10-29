# battleMETAL
A Total-conversion-mod for the DarkPlaces engine all about mecha combat.

I have been coding this since 7/4/2016 based on some initial tests that the Darkplaces Engine might
be robust enough to have an arcadey mech mod. 

This is just a repo for the code, the media assets (models, texture, fx) aren't available yet because
I have not fully decoupled all the original iD assets from the mod. 

following features are currently live

+ Location-based damage
+ Multi-part models
+ Multiple weapons
+ Unit data allows for customization of weapons on a particular unit
+ Visual weapon display
+ Every weapon is visually displayed as protruding from the unit
+ Sound queue system
+ Client-side enhancement, allows for a short sequencing of sounds to play
+ Completely customized hud api
+ Complex armor diagrams
+ Navigation bar
+ Weapons display
+ Distance display
+ Pitch display
+ New API for GUI
    > Accessed by client UI API’s
    > Render meters
    > Render scrolling images
    > Render labels on things
+ Factory pattern applied to many unit spawn functions
+ Entire code base designed to be a platform for making mech games
+ Paradigm has a bit of an API feel to it
+ Originally used a recursive method to locate nearest child parts of a parent entity
+ Convergence mechanics for weapons fire
+ single , group, chain fire modes
+ Being able to target something
+ Target highlight only sent to player and their allies
+ Player-changeable loadout system
+ Menu system for making client-side menus during gameplay.
+ In-depth Level design options
+ Mission objectives
+ Navigation points
+ Deployment Screen
+ Sound-event queue system for player notifications
+ AI can use a limited node-graph system to navigate some more dense terrain
