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
