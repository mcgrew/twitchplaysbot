
require("irc")
require("settings")
require("controls")

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


function commandlist()
  say("General Commands:")
  say("up#, down#, left#, right#, a, b, select, start")
  say("Overworld Commands:")
  say("talk, status, stairs, search, spell#, item#, door, take")
  say("Battle Commands:")
  say("fight, run, spell, item#")
  say("Menu Commands:")
  say("pup, pdown, pleft, pright")
end

function say(str) 
  if not player.quiet then
    irc.send(string.format("PRIVMSG %s :%s", irc.settings.channel, str))
  end
end

function parsecommand(player, command)
      c = tonumber(string.sub(command, -2))
      if c == nil then
        c = tonumber(string.sub(command, -1))
      end
      if string.sub(command, 1, 2) == "up" then
        player:moveup(c)
      elseif string.sub(command, 1, 4) == "down" then
        player:movedown(c)
      elseif string.sub(command, 1, 4) == "left" then
        player:moveleft(c)
      elseif string.sub(command, 1, 5) == "right" then
        player:moveright(c)
      elseif string.sub(command, 1, 3) == "pup" then
        pressup()
      elseif string.sub(command, 1, 5) == "pdown" then
        pressdown()
      elseif string.sub(command, 1, 5) == "pleft" then
        pressleft()
      elseif string.sub(command, 1, 6) == "pright" then
        pressright()
      elseif command == "a" then
        pressa(2)
      elseif command == "b" then
        pressb()
      elseif string.sub(command, 1, 5) == "start" then
        pressselect()
      elseif string.sub(command, 1, 6) == "select" then
        pressstart()
      elseif string.sub(command, 1, 4) == "talk" then
        player:talk()
      elseif string.sub(command, 1, 6) == "status" then
        player:status()
      elseif string.sub(command, 1, 6) == "stairs" then
        player:stairs()
      elseif string.sub(command, 1, 6) == "search" then
        player:search()
      elseif string.sub(command, 1, 5) == "spell" then
        player:spell()
      elseif string.sub(command, 1, 4) == "item" then
        player:item(c)
      elseif string.sub(command, 1, 4) == "door" then
        player:door()
      elseif string.sub(command, 1, 4) == "take" then
        player:take()
      elseif string.sub(command, 1, 5) == "fight" then
        player:fight()
      elseif string.sub(command, 1, 3) == "run" then
        player:run()
      elseif string.sub(command, 1, 8) == "healmore" then
        player:healmore()
      elseif string.sub(command, 1, 8) == "hurtmore" then
        player:hurtmore()
      elseif string.sub(command, 1, 4) == "heal" then
        player:heal()
      elseif string.sub(command, 1, 4) == "hurt" then
        player:hurt()
      elseif string.sub(command, 1, 5) == "sleep" then
        player:sleep()
      elseif string.sub(command, 1, 7) == "radiant" then
        player:radiant()
      elseif string.sub(command, 1, 9) == "stopspell" then
        player:stopspell()
      elseif string.sub(command, 1, 7) == "outside" then
        player:outside()
      elseif string.sub(command, 1, 6) == "return" then
        player:return_()
      elseif string.sub(command, 1, 5) == "repel" then
        player:repel()
      elseif string.sub(command, 1, 4) == "herb" then
        player:herb()
      elseif string.sub(command, 1, 6) == "!grind" then
        player.last_command = 0
        return false
      elseif string.sub(command, 1, 8) == "!command" then
        commandlist()
      elseif string.sub(command, 1, 5) == "!help" then
        commandlist()
      else
        return false
      end
      return true
end

in_battle = false
function battle_mode (b)
	if b ~= nil then
		in_battle = b
		if not b then
			-- overwrite monster hp to avoid confusion
			memory.writebyte(0xe2, 0)
		end
	end
	return in_battle
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
  herbs = 0,
  keys = 0,
  map_x = 0,
  map_y = 0,
  tile = 0,
  last_tile = 0,

  last_command = 0,
  grind_action = 0,
  quiet = false
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

  self.herbs = memory.readbyte(0xc0)
  self.keys = memory.readbyte(0xbf)
  self.max_hp = memory.readbyte(0xca)
  self.max_mp = memory.readbyte(0xcb)

  self.last_tile = self.tile
  self.tile = memory.readbyte(0xe0)
  map_x = memory.readbyte(0x8e)
  map_y = memory.readbyte(0x8f)
  if (map_x ~= self.map_x or map_y ~= self.map_y) then
    battle_mode(false)
  end
  self.map_x = map_x
  self.map_y = map_y

end

function Player.cancel(self, c)
  if c == nil then
    c = 3
  end
  for j=1,c do
    pressb()
  end
end

function Player.movedown(self, c)
  if c == nil or c < 1 then 
    c = 1
  end
  for j=1,c do
    starty = memory.readbyte(0x8f)
    startframe = emu.framecount()
    for j=1,8 do
      pressdown(8)
      if memory.readbyte(0x8f) > starty then
        break
      end
    end
  end
end

function Player.moveup(self, c)
  if c == nil or c < 1 then 
    c = 1
  end
  for j=1,c do
    starty = memory.readbyte(0x8f)
    startframe = emu.framecount()
    for j=1,8 do
      pressup(8)
      if memory.readbyte(0x8f) < starty then
        break
      end
    end
  end
end

function Player.moveleft(self, c)
  if c == nil or c < 1 then 
    c = 1
  end
  for j=1,c do
    startx = memory.readbyte(0x8e)
    startframe = emu.framecount()
    for j=1,8 do
      pressleft(8)
      if memory.readbyte(0x8e) < startx then
        break
      end
    end
  end
end

function Player.moveright(self, c)
  if c == nil or c < 1 then 
    c = 1
  end
  for j=1,c do
    startx = memory.readbyte(0x8e)
    startframe = emu.framecount()
    for j=1,8 do
      pressright(8)
      if memory.readbyte(0x8e) > startx then
        break
      end
    end
  end
end

function Player.talk(self) 
  self:cancel()
  pressa(2)
  wait(30)
  pressa(2)
end

function Player.status(self) 
  self:cancel()
  pressa(2)
  wait(30)
  pressdown()
  pressa(2)
end


function Player.stairs(self) 
  self:cancel()
  pressa(2)
  wait(30)
  pressdown()
  pressdown()
  pressa(2)
end


function Player.search(self) 
  self:cancel()
  pressa(2)
  wait(30)
  pressdown()
  pressdown()
  pressdown()
  pressa(2)
end


function Player.spell(self, c) 
  self:cancel(5)
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


function Player.item(self, c) 
  self:cancel(5)
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


function Player.door(self) 
  self:cancel(5)
  pressa(2)
  wait(30)
  pressdown()
  pressdown()
  pressright()
  pressa(2)
end


function Player.take(self) 
  self:cancel()
  pressa(2)
  wait(30)
  pressdown()
  pressdown()
  pressdown()
  pressright()
  pressa(2)
end

function Player.fight(self) 
  self:cancel()
  wait(30)
  pressa(2)
end

function Player.run(self) 
  self:cancel()
  wait(30)
  pressdown()
  pressa(2)
end

function Player.heal(self)
  if (AND(memory.readbyte(0xce), 0x1) > 0) then
    if self.mp < 4 then
      say("I do not have enough magic to cast heal")
      return false
    end
    player:spell(1)
  else
    say("I do not yet have the heal spell")
    return false
  end 
  return true
end

function Player.hurt(self)
  if (AND(memory.readbyte(0xce), 0x2) > 0) then
    if not in_battle then
      say("Hurt is a battle spell. I are not in battle.")
      return false
    end
    player:spell(2)
  else
    say("I do not yet have the hurt spell")
    return false
  end 
  return true
end

function Player.sleep(self)
  if (AND(memory.readbyte(0xce), 0x4) > 0) then
    if not in_battle then
      say("Sleep is a battle spell. I are not in battle.")
      return false
    end
    player:spell(3)
  else
    say("I do not yet have the sleep spell")
    return false
  end 
  return true
end

function Player.radiant(self)
  if (AND(memory.readbyte(0xce), 0x8) > 0) then
    player:spell(4)
  else
    say("I do not yet have the radiant spell")
    return false
  end 
  return true
end

function Player.stopspell(self)
  if (AND(memory.readbyte(0xce), 0x10) > 0) then
    if not in_battle then
      say("Stopspell is a battle spell. I are not in battle.")
      return false
    end
    player:spell(5)
  else
    say("I do not yet have the stopspell spell")
    return false
  end 
  return true
end

function Player.outside(self)
  if (AND(memory.readbyte(0xce), 0x20) > 0) then
    player:spell(6)
  else
    say("I do not yet have the outside spell")
    return false
  end 
  return true
end

function Player.return_(self)
  if (AND(memory.readbyte(0xce), 0x40) > 0) then
    player:spell(7)
  else
    say("I do not yet have the return spell")
    return false
  end 
  return true
end

function Player.repel(self)
  if (AND(memory.readbyte(0xce), 0x80) > 0) then
    player:spell(8)
  else
    say("I do not yet have the repel spell")
    return false
  end 
  return true
end

function Player.healmore(self)
  if (AND(memory.readbyte(0xcf), 0x1) > 0) then
    if self.mp < 10 then
      say("I do not have enough magic to cast healmore")
      return false
    end
    player:spell(9)
  else
    say("I do not yet have the healmore spell")
    return false
  end 
  return true
end

function Player.hurtmore(self)
  if (AND(memory.readbyte(0xcf), 0x20) > 0) then
    if not in_battle then
      say("Hurtmore is a battle spell. I are not in battle.")
      return false
    end
    player:spell(10)
  else
    say("I do not yet have the hurtmore spell")
    return false
  end 
  return true
end

function Player.add_hp (self, amount)
  return self:set_hp(self.hp + amount)
end

function Player.set_hp (self, amount)
  if (amount > 255 or amount < 0) then
    return false
  end
  self.hp = amount
  memory.writebyte(0xc5, amount)
  return true
end

function Player.add_mp (self, amount)
  return self:set_mp(self.mp + amount)
end

function Player.set_mp (self, amount)
  if (amount > 255 or amount < 0) then
    return false
  end
  self.mp = amount
  memory.writebyte(0xc6, amount)
  return true
end

function Player.add_gold (self, amount)
  return self:set_gold(self.gold + amount)
end

function Player.set_gold (self, amount)
  if (amount > 65535 or amount < 0) then
    return false
  end
  self.gold = amount
  memory.writebyte(0xbd, amount / 256)
  memory.writebyte(0xbc, amount % 256)
  return true
end

function Player.add_experience (self, amount)
  return self:set_experience(self.experience + amount)
end

function Player.set_experience (self, amount)
  if (amount > 65535 or amount < 0) then
    return false
  end
  self.experience = amount
  memory.writebyte(0xbb, self.experience / 256)
  memory.writebyte(0xba, self.experience % 256)
end

function Player.add_herb (self)
  self.herbs = memory.readbyte(0xc0)
  if self.herbs >= 6 then
    return false
  end
  memory.writebyte(0xc0, self.herbs + 1)
  return true
end

function Player.herb (self)
  if self.herbs > 0 then
    self:item(1)
    return true
  end
  if cheat.herb_store then
    if (self:add_gold(-24)) then 
      self:add_herb()
      self:item(1)
      return true
    end
  end
  if cheat.herb_store then
    say("I don't have any herbs or enough gold to buy one.")
  else
    say("I don't have any herbs.")
  end
  return false
end

function Player.grind(self) 
  if emu.framecount() - self.last_command > 36000 then
    if self.grind_action == 0 then
      self:moveup()
    elseif self.grind_action == 1 then
      self:moveleft()
    elseif self.grind_action == 2 then
      self:movedown()
    else
      self:moveright()
    end
    self:cancel()
    self:heal_thy_self()
    if in_battle then
      self:fight()
			self:cancel()
      wait(240)
    end
    self.grind_action = (self.grind_action + 1) % 4
  end
end

function Player.heal_thy_self(self)
  self.quiet = true
  if self.hp * 3 < self.max_hp then
    if not (self:healmore()) then
      if not (self:heal()) then
        self:herb()
      end
    end
  elseif not in_battle then
    if self.max_hp - self.hp >= 30 then
      if not (self:heal()) then
        self:herb()
      end
    end
  end
  self.quiet = false
end

Enemy = {
  hp = 0,
  change = {
    hp = 0
  },
}

function Enemy.update (self)
  -- read in the values from memory.
  hp = memory.readbyte(0xe2)
  -- update the changes.
  self.change.hp = hp - self.hp
  -- update the object variables.
  self.hp = hp

  -- update battle status
  if not in_battle and self.change.hp ~= 0 then
    battle_mode(true)
  end
  -- hit points wrap below zero, so check for large increases.
  if self.hp == 0 or self.change.hp > 150 then
    battle_mode(false)
  end

end

function Enemy.show_hp (self)
  if (in_battle and cheat.enemy_hp) then 
    gui.drawbox(152, 134, 190, 144, "black")
    gui.text(154, 136, string.format( "HP %3d", self.hp), "white", "black")
  end
end

-- 
--  Draws any hud elements, such as the enemy hit points
-- 
function overlay()
  enemy:show_hp()
--   gui.text(8, 16,
--     string.format( "%3d %3d",
--       memory.readbyte(0x8e), memory.readbyte(0x8f)
--     ), "white", "black")
  if cheat.grind_mode and (emu.framecount() - player.last_command > 36000) then
    gui.drawbox(0, 0, 60, 15, "black")
    gui.text(8, 8, "Grind mode", "white", "black")
  end
end

function update()
  -- create a save state every 10 minutes in case of a crash
  if (emu.framecount() % 3600 == 0) then
    savestate.persist(savestate.object(1))
  end
  -- update the player and enemy info every 1/4 second
  if (emu.framecount() % 15 == 0) then
    player:update()
    enemy:update()
  end

  -- down + select => grind mode
  if memory.readbyte(0x47) == 36 then
    player.last_command = 0
  end
end

-- main loop
savestate.load(savestate.object(1))
irc.initialize(irc.settings)
if not debug.offline then
  irc.connect()
end
player = Player
player:update()
player.last_command = emu.framecount()
enemy = Enemy
enemy:update()
gui.register(overlay)
emu.registerafter(update)

while(true) do
  if ((player.tile == TILE.STAIRS_UP or player.tile == TILE.STAIRS_DOWN) and
      not (player.last_tile == TILE.STAIRS_UP or 
           player.last_tile == TILE.STAIRS_DOWN)) then
    player.last_tile = player.tile
    player:stairs()
  end
  if not debug.offline then
    irc.read()
    if irc.messages_size() > 0 then
      msg = irc.message()
      if msg ~= nil then
        command = string.lower(msg.message)
        if (parsecommand(player, command)) then
          player.last_command = emu.framecount()
        end
      end
    end
  end
  if cheat.grind_mode then
    player:grind()
  end
  emu.frameadvance()
end

