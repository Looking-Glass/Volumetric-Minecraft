# Volumetric-Minecraft
It's a minecraft shader!

These should be the steps to get it working:

First install Minecraft, you can log in with my account:

dioby77@gmail.com  
tothefuture88


Then get:

https://files.minecraftforge.net/
(under Download Recommended, get the installer)
After installing, the minecraft launcher should let you make a new profile.
On that screen, click the Open Game Dir button.

Put the optifine .jar file (in this repo) in the mods folder of the game dir (which is created when minecraft launches or you can just create it manually)

Put the VolumetricMinecraft folder (in this repo) in the shaderpacks folder!

Now that shader should be selectable in-game, in the menu it's Video Settings>Shaders>VolumetricMinecraft
Run in fullscreen and F1 hides the UI. 

final.fsh in the shaders folder is the important, messy fragment shader itself, for the time being changing what the n and f values are set to in the LinearizeDepth function changes depthyness.