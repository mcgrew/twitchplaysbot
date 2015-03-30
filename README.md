twitchplaysbot
==============

Simple opensource reimplementation of the Twitch Plays Pokémon bot, in case you want to make your own.

Only tested with [FCEUX](http://www.fceux.com/).

Installation
------------
1.  Get and install fceux and a copy of the appropriate game.
2.  Put the .lua files in the same folder, remove the .example to the settings.lua.example file and edit it accordingly.
3.  If your emulator don't natively support Lua sockets, download [the latest version of LuaSocket](http://files.luaforge.net/releases/luasocket/luasocket/luasocket-2.0.2) and unzip the folders (not lua5.1.dll and lua5.1.exe found in the root of the .zip) in the directory where your emulator is installed.
4.  Load up dragon_warrior.lua in the Lua scripting dialog of the emulator, run it and have fun!
5.  Optionally set up Twitch to capture the output of the emulator if you set it up to run on irc.twitch.tv.


