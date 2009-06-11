I'm learning cocos2d-iphone and figured I'd show my workings in public. Here's what I've done so far:

1. Started with the Xcode project template
http://www.bit-101.com/blog/?p=2115 and cocos2d from svn (r980)

2. Added graphics 
from http://lostgarden.com/2007/05/dancs-miraculously-flexible-game.html

3. Tied Chipmunk physics engine into sprite. 
http://github.com/mattb/gameplayground/tree/bace9cb4461232b64841b856d42b0580463deab9
Progress video: http://flic.kr/p/6qm3e5

4. Made a "video sprite" that uses a 30fps animation loaded from a series of PVR-compressed image frames.
http://github.com/mattb/gameplayground/tree/81fc0e46b92b2e895838f9282de73546ff05cca7
These were made by extracting frames as jpegs from an MP4 video using mplayer, cropping them to be 128x128 (PVR images must be square and their size a power of two), and converting to PVR format with a command like: /Developer3/Platforms/iPhoneOS.platform/Developer/usr/bin/texturetool -e PVRTC -o frame1.pvr -f PVR frame1.jpg

5. Added a "Camera Zoom Action" that linearly zooms in the camera on a scene over a duration. Use this to zoom in the viewport while a touch is held down.
http://github.com/mattb/gameplayground/tree/9ed6017b47b9b1d87bd5a6cb99f59c549cbd68f5

6. Moved the MainScene behind a MenuScene so I can have more than one experiment in this app.
http://github.com/mattb/gameplayground/tree/204963f402625424da2de40d73b7a5960de41ebc

7. Add some Rock obstacles to bounce off.
http://github.com/mattb/gameplayground/tree/3258629988f93ccfaa92686f5469c15130c94b47
These are infinite mass/moment objects fixed in the game world.
Progress video: http://flic.kr/p/6qW8ke

8. Add sound support using CocosDenshion. 
http://github.com/mattb/gameplayground/tree/b6e70835be399d4e78bcfbebeb1eaeccbb9253cd
from http://groups.google.com/group/cocos2d-iphone-discuss/files
Tie sounds into collision callbacks in physics engine - one sound for player versus rock, one for player versus wall.
Sounds taken from http://www.freesound.org/packsViewSingle.php?id=1497

9. Add a particle emitter to the player sprite. Make it track the player location.
http://github.com/mattb/gameplayground/tree/acb93703c43791fed23e5753c0444ac7248a8e0f

10. Try out AtlasAnimation with a single PVRTC source (using Muybridge's classic horse photos). 
http://github.com/mattb/gameplayground/tree/17e181ba00f8ad449acbc879dd414479e4962135
Assembled using RMagick and then converted to PVR format using texturetool (ruby code in composite_atlas_grid.rb)

11. Add a new scene to play with bezier paths controlling sprites following finger touches, Flight Control style.
http://github.com/mattb/gameplayground/tree/4bb19071e54454eea2ec7791bfd3dc3299719577
First attempt uses a ringbuffer of the last ten touches and timestamps, and uses a regular timer tick to schedule BezierTo actions. Works but is a bit wobbly.

12. Add a new scene to play with the Freepixel sprite sheet from http://www.squidi.net/pixel/char.default.php
http://github.com/mattb/gameplayground/tree/d4dc28e4cadfff3dfd1804cd7f05048dc170fd80

13. Make some space invaders from a sprite sheet found via google image search (sorry!)
http://github.com/mattb/gameplayground/tree/67f66b7a1843bad8fa202723e076ce32fcbfbfc1
