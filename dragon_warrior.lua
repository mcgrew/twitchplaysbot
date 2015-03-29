
require("irc")
require("settings")
require("controls")

moveframes = 16

TILE = {
  GRASS = 0,
  DESERT = 1,
  HILLS = 2,
  STAIRS_UP = 3,
  TILES = 4,
  STAIRS_DOWN = 5,
  SWAMP = 6,
  TOWN = 7,
  CAVE = 8,
  CASTLE = 10,
  BRIDGE = 11,
  FOREST = 12,
  CHEST = 13,
  FORCE_FIELD = 14
}

function cancel(c)
	if c == nil then
		c = 3
	end
	for j=1,c do
		pressb()
	end
end

function movedown(c)
	if c == nil or c < 1 then 
		c = 1
	end
	pressdown()
	input = {}
	input.down = true
	for j=1,c do
		for i=1,moveframes do
			joypad.set(1, input)
			emu.frameadvance()
		end
		for i=1,16 do
			joypad.set(1, {})
			emu.frameadvance()
		end
	end
end

function moveup(c)
	if c == nil or c < 1 then 
		c = 1
	end
	pressup()
	input = {}
	input.up = true
	for j=1,c do
		for i=1,moveframes do
			joypad.set(1, input)
			emu.frameadvance()
		end
		for i=1,16 do
			joypad.set(1, {})
			emu.frameadvance()
		end
	end
end

function moveleft(c)
	if c == nil or c < 1 then 
		c = 1
	end
	pressleft()
	input = {}
	input.left = true
	for j=1,c do
		for i=1,moveframes do
			joypad.set(1, input)
			emu.frameadvance()
		end
		for i=1,16 do
			joypad.set(1, {})
			emu.frameadvance()
		end
	end
end

function moveright(c)
	if c == nil or c < 1 then 
		c = 1
	end
	pressright()
	input = {}
	input.right = true
	for j=1,c do
		for i=1,moveframes do
			joypad.set(1, input)
			emu.frameadvance()
		end
		for i=1,16 do
			joypad.set(1, {})
			emu.frameadvance()
		end
	end
end

function talk() 
	cancel()
	pressa(2)
	wait(30)
	pressa(2)
end

function status() 
	cancel()
	pressa(2)
	wait(30)
	pressdown()
	pressa(2)
end


function stairs() 
	cancel()
	pressa(2)
	wait(30)
	pressdown()
	pressdown()
	pressa(2)
end


function search() 
	cancel()
	pressa(2)
	wait(30)
	pressdown()
	pressdown()
	pressdown()
	pressa(2)
end


function spell(c) 
	cancel(5)
	pressa(2)
	wait(30)
	pressright()
	pressa(2)
	wait(30)
	if c ~= nil then
		for j=1,c-1 do
			pressdown()
		end
		pressa(2)
	end
end


function item(c) 
	cancel(5)
	pressa(2)
	wait(30)
	pressdown()
	pressright()
	pressa(2)
	wait(30)
	if c ~= nil then
		for j=1,c-1 do
			pressdown()
		end
		pressa(2)
	end
end


function door() 
	cancel(5)
	pressa(2)
	wait(30)
	pressdown()
	pressdown()
	pressright()
	pressa(2)
end


function take() 
	cancel()
	pressa(2)
	wait(30)
	pressdown()
	pressdown()
	pressdown()
	pressright()
	pressa(2)
end

function fight() 
	cancel()
	wait(30)
	pressa(2)
end

function run() 
	cancel()
	wait(30)
	pressdown()
	pressa(2)
end

function commandlist()
	say("General Commands:")
	say("up#, down#, left#, right#, a, b, select, start")
	say("Overworld Commands:")
	say("talk, status, stairs, search, spell#, item#, door, take")
	say("Battle Commands:")
	say("fight, run, spell#, item#")
	say("Menu Commands:")
	say("pup, pdown, pleft, pright")
end

function say(str) 
	irc.send(string.format("PRIVMSG %s :%s", irc.settings.channel, str))
end

function parsecommand(command)
      c = tonumber(string.sub(command, -2))
      if c == nil then
        c = tonumber(string.sub(command, -1))
      end
      if string.sub(command, 1, 2) == "up" then
        moveup(c)
      elseif string.sub(command, 1, 4) == "down" then
        movedown(c)
      elseif string.sub(command, 1, 4) == "left" then
        moveleft(c)
      elseif string.sub(command, 1, 5) == "right" then
        moveright(c)
      elseif string.sub(command, 1, 3) == "pup" then
        pressup()
      elseif string.sub(command, 1, 5) == "pdown" then
        pressdown()
      elseif string.sub(command, 1, 5) == "pleft" then
        pressleft()
      elseif string.sub(command, 1, 6) == "pright" then
        pressright()
      elseif string.sub(command, 1, 1) == "a" then
        pressa(2)
      elseif string.sub(command, 1, 1) == "b" then
        pressb()
      elseif string.sub(command, 1, 5) == "start" then
        pressselect()
      elseif string.sub(command, 1, 6) == "select" then
        pressstart()
      elseif string.sub(command, 1, 4) == "talk" then
        talk()
      elseif string.sub(command, 1, 6) == "status" then
        status()
      elseif string.sub(command, 1, 6) == "stairs" then
        stairs()
      elseif string.sub(command, 1, 6) == "search" then
        search()
      elseif string.sub(command, 1, 5) == "spell" then
        spell()
      elseif string.sub(command, 1, 4) == "item" then
        item(c)
      elseif string.sub(command, 1, 4) == "door" then
        door()
      elseif string.sub(command, 1, 4) == "take" then
        take()
      elseif string.sub(command, 1, 5) == "fight" then
        fight()
      elseif string.sub(command, 1, 3) == "run" then
        run()
      elseif string.sub(command, 1, 8) == "!command" then
        commandlist()
      elseif string.sub(command, 1, 5) == "!help" then
        commandlist()
      else
      end
end

Player = {
  level = 0,
  hp = 0,
  mp = 0,
  gold = 0,
  experience = 0,
  change = {
    level = 0,
    hp = 0,
    mp = 0,
    gold = 0,
    experience = 0
  },
  tile = 0,
  last_tile = 0,
  in_battle = 0
}

function Player.update (self)

  -- read in the values from memory.
  level = memory.readbyte(0xc7)
  hp = memory.readbyte(0xc5)
  mp = memory.readbyte(0xc6)
  gold = memory.readbyte(0xbd) * 256 + memory.readbyte(0xbc)
  experience = memory.readbyte(0xbb) * 256 + memory.readbyte(0xba)

  -- update the changes.
  self.change.level = level - self.level
  self.change.hp = hp - self.hp
  self.change.mp = mp - self.mp
  self.change.gold = gold - self.gold
  self.change.experience = experience - self.experience

  -- update the object variables.
  self.level = level
  self.hp = hp
  self.mp = mp
  self.gold = gold
  self.experience = experience

  self.last_tile = self.tile
  self.tile = memory.readbyte(0xe0)

end

Enemy = {
  hp = 0,
  change = {
    hp = 0
  }
}

function Enemy.update (self)

  -- read in the values from memory.
  hp = memory.readbyte(0xe2)

  -- update the changes.
  self.change.hp = hp - self.hp

  -- update the object variables.
  self.hp = hp

end


-- main loop
irc.initialize(irc.settings)
irc.connect()
player = Player
player:update()
enemy = Enemy
enemy:update()

while(true) do
  if (emu.framecount() % 64 == 0) then
    player:update()
    enemy:update()
  end
  if ((player.tile == TILE.STAIRS_UP or player.tile == TILE.STAIRS_DOWN) and
      not (player.last_tile == TILE.STAIRS_UP or 
           player.last_tile == TILE.STAIRS_DOWN)) then
    player.last_tile = player.tile
    stairs()
  end
    irc.read()
  if irc.messages_size() > 0 then
    msg = irc.message()
    if msg ~= nil then
      command = string.lower(msg.message)
      parsecommand(command)
    end
  end
emu.frameadvance()
end

