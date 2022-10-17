# Probe-Hunter
A game written in lua using Love 2D and Visual Studio Code
All of the sounds were made using jfxr and the art assets were drawn in GIMP. Also to play this game, you will need to download Love 2D. Upon completing the download,
just drag and drop the game files on the Love.exe executable.

Story
--
You play as a cave ranger who was sent into a cave to hunt down alien probes that landed on earth and drilled deep underground.

Controls
--
**WASD = Move**

**K = Shoot**

**L = Dash**

Gameplay
--
The goal of each level is to get to an **alien passage way** or to shoot a **probe**. The passage ways open upon being shot.
However to reach these goals you need to survive the enemies that show up in each level as well.

The Spikies chase you down and leap into the air if you try to jump over them.
The flying bugs shoot at you and fly up and down.
the alien drones shoot at you predicting your movements, and ram you if you get too close to them.

There are also **destructable walls** and **wind plants**.
The **wind plants** are plants that blow gusts of wind, firing nearby objects into the air,
and the **destructable walls** are self explanitory.

Engine
--
If you want to copy code from this then go ahead.
The game works on a **messaging system**. Basicly objects communicate using messages that consist of a string, and 2 numbers. The object that was messaged
resives the data and if it recognizes the string it returns true. If not it returns false.

The "Helper functions" file contains a ton of general useful functions like math functions
some physics functions like finding overlap between 2 rectangles.

The **lighting system** works by building a list of active lights using the addLight function. Then upon filling out the list it sends it over to a shader.
The shader then goes over each pixel and bases its color, on its image color, and distance from each light source. This lighting system also supports colored lights.
