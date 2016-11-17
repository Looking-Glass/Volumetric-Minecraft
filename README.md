# Volumetric-Minecraft
It's a minecraft shader!

These should be the steps to get it working:

First install Minecraft, then:

Make sure you have JDK installed 
http://www.oracle.com/technetwork/java/javase/downloads/index-jsp-138363.html

and download: 

https://files.minecraftforge.net/
(under Download Recommended, get the installer, then run it, it should automatically find your minecraft install)

and this repo.

Run minecraft normally once to check that forge is installed, it should say so in the bottom left of the game window, then quit.
Then you should be able to select a profile named "forge" in the bottom left of the minecraft launcher window, then edit that profile and click "Open Game Dir."

Put the optifine .jar file (in this repo) in the mods folder of the opened game dir.
Make a folder named "shaderpacks" and put the VolumetricMinecraft folder (in this repo) in the shaderpacks folder!

Now that shader should be selectable in-game, in the menu it's Video Settings>Shaders>VolumetricMinecraft

Finally, run it in fullscreen and hit F1 to hide the UI

final.fsh in the shaders folder is the important, messy fragment shader itself, for the time being changing what the n and f values are set to in the LinearizeDepth function changes depthyness.

IMPORTANT: So this still needs to be calibrated to look right in Volume, the _SO, _TD and _SK arrays can be overwritten with calibration tools that are in the works.