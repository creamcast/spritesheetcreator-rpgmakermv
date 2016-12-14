# spritesheetcreator-rpgmakermv
create a character sprite sheet for rpg maker MV based on a definition file.

**********************************************
INSTANT SPRITE SHEET CREATOR for RPG MAKER MV
**********************************************

*******Download Latest Version*******

Version 0.1: http://www.mediafire.com/file/49kjbtqu6dp02yi/spritesheetcreator.rar

*Mac OSX Users: Download https://github.com/creamcast/spritesheetcreator-rpgmakermv/blob/master/spritesheetcreator-macosx then drop it in the same folder as map.txt, then run it through the terminal using ./spritesheetcreator-macosx )

*******Description*******

This program will instantly create a sprite sheet from seperate sprites based on the variables in definition file "map.txt".
Upon extraction an example project is already setup to be run. Example sprites are located in folders p1 and p2. 
execute spritesheetcreator.exe and an example spreadsheet will be output as "output.png" in the same folder as the executable.

*******Usage*******

1)the 'map.txt' defines how the seperate images will be mapped out on the final sprite sheet, it must be placed in the same folder as the executable.

2)the definition file 'map.txt' is seperated into several sections where the variables will be set. These sections are:

[spec] - settings for the entire sprite sheet

[sprite1] - settings for the first character sprite (top left)

[sprite2] - settings for the second character sprite (next to sprite1)
.
.
.
[sprite8]

3)after you have setup the folders and set the variables in the map.txt file, run the executable and hope for the best.

!!See map.txt for examples!!!

*******List of variables*******

[spec]
* sprite_w	set the width of the character sprite
* sprite_h	set the height of the character sprite

[sprite1~8]
* folder		specify the folder of where the sprite images are stored relative to the executable file
* front		front sprites of the character (total of 3)
* left		left sprites of the character (total of 3)
* right		right sprites of the character (total of 3)
* back		back sprites of the character (total of 3)
* dummy		set to 1 to skip this section and place empty images as a placeholder
* flip_left	set to 1 to flip the images set in the 'left' variable
* flip_right	set to 1 to flip the images set in the 'right' variable
