
require("irc")
require("settings")
require("controls")
require("map")
require("worldmap")


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
  say("up, down, left, right, a, b, select, start")
  say("Overworld Commands:")
  say("talk, status, stairs, search, spell, item, door, take")
  say("Battle Commands:")
  say("fight, run, spell, item#")
end

function say(str) 
  if debug.offline then
    print(string.format("%s\n", str))
  else
    if not player.quiet then
      irc.send(string.format("PRIVMSG %s :%s", irc.settings.channel, str))
    end
  end
end

function parsecommand(player, command)
      local c = tonumber(string.sub(command, -2))
      if c == nil then
        c = tonumber(string.sub(command, -1))
      end
      if string.sub(command, 1, 2) == "up" then
        player:up(c)
      elseif string.sub(command, 1, 4) == "down" then
        player:down(c)
      elseif string.sub(command, 1, 4) == "left" then
        player:left(c)
      elseif string.sub(command, 1, 5) == "right" then
        player:right(c)
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
      elseif string.sub(command, 1, 8) == "!command" then
        commandlist()
      elseif string.sub(command, 1, 5) == "!help" then
        commandlist()
      elseif string.sub(command, 1, 11) == "!autobattle" then
        player:set_mode("autobattle")
      elseif string.sub(command, 1, 10) == "!fraidycat" then
        player:set_mode("fraidycat")
      elseif string.sub(command, 1, 10) == "!manual" then
        player:set_mode("manual")
      elseif string.sub(command, 1, 6) == "!grind" then
        player:set_mode("grind")
        return false
      else
        return false
      end
      return true
end

in_battle = false
function battle_mode (battling, reset_enemy_hp)
  if battling ~= nil then
    in_battle = battling
    if not battling then
      if (reset_enemy_hp == true) then
        -- overwrite monster hp to avoid confusion
        enemy:set_hp(0)
      end
    else
      player.path = nil
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
  player_x = 0,
  player_y = 0,
  current_map = 0,
  tile = 0,
  last_tile = 0,

  last_command = 0,
  grind_action = 0,
  quiet = false,
  mode = {
    grind = false,
    auto_battle = false,
    fraidy_cat = false,
    autonav = false,
    explore = false,
    manual = true
  },
  path = nil,
  path_pointer = 1,
  destination = nil
}

function Player.update (self)

  -- read in the values from memory.
  local level = memory.readbyte(0xc7)
  local hp = memory.readbyte(0xc5)
  local mp = memory.readbyte(0xc6)
  local gold = memory.readbyte(0xbd) * 256 + memory.readbyte(0xbc)
  local experience = memory.readbyte(0xbb) * 256 + memory.readbyte(0xba)

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

  self.herbs = self.get_herbs()
  self.keys = self:get_keys()

  self.last_tile = self.tile
  self.tile = self:get_tile()
  local map_x = self:get_x()
  local map_y = self.get_y()
  if (in_battle and (map_x ~= self.map_x or map_y ~= self.map_y)) then
    battle_mode(false, true)
  end
  self.map_x = map_x
  self.map_y = map_y
  self.player_x = memory.readbyte(0x3a)
  self.player_y = memory.readbyte(0x3b)
  self.current_map = memory.readbyte(0x45)

  if not in_battle then
    -- being in a battle changes the tile (to enemy type?)
    map:set_tile(self.player_x, self.player_y, self.current_map, self.tile)
  end

end

function Player.get_tile(self)
  return memory.readbyte(0xe0)
end

function Player.get_x(self)
  return memory.readbyte(0x8e)
end

function Player.get_y(self)
  return memory.readbyte(0x8f)
end

function Player.get_herbs(self)
  return memory.readbyte(0xc0)
end

function Player.get_keys(self)
  return memory.readbyte(0xbf)
end

function Player.max_hp(self)
  return memory.readbyte(0xca)
end

function Player.max_mp(self)
  return memory.readbyte(0xcb)
end

function Player.cancel(self, c)
  if c == nil then
    c = 3
  end
  for j=1,c do
    pressb()
  end
end

function Player.check_cursor(self, x, y)
  return memory.readbyte(0xd8) == x and memory.readbyte(0xd9) == y
end

function Player.down(self, c)
  if c == nil or c < 1 then 
    c = 1
  end
  local input = {}
  input.down = true
  for j=1,c do
    local starty = memory.readbyte(0x8f)
    local startcursor = memory.readbyte(0xd9)
    for i=1,45 do
      joypad.set(1, input)
      emu.frameadvance()
      if memory.readbyte(0x8f) > starty or memory.readbyte(0xd9) > startcursor then
        break
      end
    end
    -- we were unable to move, give up
    if memory.readbyte(0x8f) == starty and memory.readbyte(0xd9) == startcursor then
      return false
    end
  end
  return true
end

function Player.up(self, c)
  if c == nil or c < 1 then 
    c = 1
  end
  local input = {}
  input.up = true
  for j=1,c do
    local starty = memory.readbyte(0x8f)
    local startcursor = memory.readbyte(0xd9)
    for i=1,45 do
      joypad.set(1, input)
      emu.frameadvance()
      if memory.readbyte(0x8f) < starty or memory.readbyte(0xd9) < startcursor then
        break
      end
    end
    -- we were unable to move, give up
    if memory.readbyte(0x8f) == starty and memory.readbyte(0xd9) == startcursor then
      return false
    end
  end
end

function Player.left(self, c)
  if c == nil or c < 1 then 
    c = 1
  end
  local input = {}
  input.left = true
  for j=1,c do
    local startx = memory.readbyte(0x8e)
    local startcursor = memory.readbyte(0xd8)
    for i=1,45 do
      joypad.set(1, input)
      emu.frameadvance()
      if memory.readbyte(0x8e) < startx or memory.readbyte(0xd8) < startcursor then
        break
      end
    end
    -- we were unable to move, give up
    if memory.readbyte(0x8e) == startx and memory.readbyte(0xd8) == startcursor then
      return false
    end
  end
end

function Player.right(self, c)
  if c == nil or c < 1 then 
    c = 1
  end
  local input = {}
  input.right = true
  for j=1,c do
    local startx = memory.readbyte(0x8e)
    local startcursor = memory.readbyte(0xd8)
    for i=1,45 do
      joypad.set(1, input)
      emu.frameadvance()
      if memory.readbyte(0x8e) > startx or memory.readbyte(0xd8) > startcursor then
        break
      end
    end
    -- we were unable to move, give up
    if memory.readbyte(0x8e) == startx and memory.readbyte(0xd8) == startcursor then
      return false
    end
  end
end

function Player.talk(self) 
  self:cancel()
  pressa(2)
  wait(30)
  if not self:check_cursor(0,0) then
    self:cancel()
    return false
  end
  pressa(2)
  return true
end

function Player.status(self) 
  self:cancel()
  pressa(2)
  wait(30)
  self:down(1)
  wait(6)
  if not self:check_cursor(0,1) then
    self:cancel()
    return false
  end
  pressa(2)
  return true
end


function Player.stairs(self) 
  self:cancel()
  pressa(2)
  wait(30)
   self:down(2)
  wait(6)
  if not self:check_cursor(0,2) then
    self:cancel()
    return false
  end
  pressa(2)
  return true
end


function Player.search(self) 
  self:cancel()
  pressa(2)
  wait(30)
  self:down(3)
  wait(6)
  if not self:check_cursor(0,3) then
    self:cancel()
    return false
  end
  pressa(2)
  return true
end


function Player.spell(self, c) 
  self:cancel()
  if not in_battle then
    pressa(2)
  end
  wait(30)
  self:right()
  wait(6)
  if not self:check_cursor(1,0) then
    self:cancel()
    return false
  end
  pressa(2)
  wait(30)
  if c ~= nil then
    for j=1,c-1 do
      self:down()
    end
    if not self:check_cursor(0,c-1) then
      self:cancel()
      return false
    end
    wait(6)
    pressa(2)
  end
  return true
end


function Player.item(self, c) 
  self:cancel()
  if not in_battle then
    pressa(2)
  end
  wait(30)
  self:down()
  self:right()
  wait(6)
  if not self:check_cursor(1,1) then
    self:cancel()
    return false
  end
  pressa(2)
  wait(30)
  if c ~= nil then
    for j=1,c-1 do
      self:down()
    end
    if not self:check_cursor(0,c-1) then
      self:cancel()
      return false
    end
    wait(6)
    pressa(2)
  end
  return true
end


function Player.door(self) 
  self:cancel(5)
  pressa(2)
  wait(30)
  self:down(2)
  self:right()
  wait(6)
  if not self:check_cursor(1,2) then
    self:cancel()
    return false
  end
  pressa(2)
  return true
end


function Player.take(self) 
  self:cancel()
  pressa(2)
  wait(30)
  self:down(3)
  self:right()
  wait(6)
  if not self:check_cursor(1,3) then
    self:cancel()
    return false
  end
  pressa(2)
  return true
end

function Player.fight(self) 
  self:cancel()
  if in_battle then
    wait(30)
    pressa(2)
    return true
  end
  return false
end

function Player.run(self) 
  self:cancel()
  if in_battle then
    wait(30)
    self:down()
    wait(6)
    if not self:check_cursor(0,1) then
      self:cancel()
      return false
    end
    pressa(2)
    return true
  end
  return false
end

function Player.heal(self)
  if (AND(memory.readbyte(0xce), 0x1) > 0) then
    if self.mp < 4 then
      say("I do not have enough magic to cast heal")
      return false
    end
    self:spell(1)
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
    self:spell(2)
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
    self:spell(3)
  else
    say("I do not yet have the sleep spell")
    return false
  end 
  return true
end

function Player.radiant(self)
  if (AND(memory.readbyte(0xce), 0x8) > 0) then
    self:spell(4)
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
    self:spell(5)
  else
    say("I do not yet have the stopspell spell")
    return false
  end 
  return true
end

function Player.outside(self)
  if (AND(memory.readbyte(0xce), 0x20) > 0) then
    self:spell(6)
  else
    say("I do not yet have the outside spell")
    return false
  end 
  return true
end

function Player.return_(self)
  if (AND(memory.readbyte(0xce), 0x40) > 0) then
    self:spell(7)
  else
    say("I do not yet have the return spell")
    return false
  end 
  return true
end

function Player.repel(self)
  if (AND(memory.readbyte(0xce), 0x80) > 0) then
    self:spell(8)
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
    self:spell(9)
  else
    say("I do not yet have the healmore spell")
    return false
  end 
  return true
end

function Player.hurtmore(self)
  if (AND(memory.readbyte(0xcf), 0x2) > 0) then
    if not in_battle then
      say("Hurtmore is a battle spell. I are not in battle.")
      return false
    end
    self:spell(10)
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
    if (self:add_gold(-self.level * self.level)) then 
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

function Player.grind_move(self)
  if not in_battle then
    self.grind_action = (self.grind_action + 1) % 4
  end
  if self.grind_action == 0 then
    return self:up()
  elseif self.grind_action == 1 then
    return self:left()
  elseif self.grind_action == 2 then
    return self:down()
  else
    return self:right()
  end
end

function Player.grind(self) 
  if self.mode.grind then
    self:heal_thy_self()
    if not self:grind_move() then
      self:cancel()
    end
  end
  if in_battle then
    if self.mode.grind or self.mode.auto_battle then
      self:grind_move()
      if self:heal_thy_self() then
        wait(120)
      end
      self:fight()
      self:cancel() -- in case the enemy runs immediately
      wait(200)
    end
    if self.mode.fraidy_cat then
      if not self:heal_thy_self() then
        self:run()
      end
      wait(200)
    end
  end
end

function Player.go_to(self, x, y, m)
  self.path = map:path(self:get_x(), self:get_y(), self.current_map, x, y, m)
  if self.path == nil then
    say("I don't know how to get there. Little help?")
    self.destination = nil
    return false
  else
    self.destination = { x = x, y = y, m = m }
    self.path_pointer = 2
    self.mode.auto_battle = true
    return true
  end
end

function Player.stairs_trigger(self) 
  return (self:get_tile() == 0x3 or self:get_tile() == 0x5) and
         (self.last_tile ~= 0x3 or self.last_tile ~= 0x5)
end

function Player.follow_path(self)
  if not in_battle then
    if self.destination ~= nil then
      if self.path ~= nil then
        local node = self.path[self.path_pointer]
        if node == nil then 
          return false
        end
        -- see if we're on stairs
        if self:stairs_trigger() then
          self.last_tile = self:get_tile()
          return self:stairs()
        end
        if (node.x == map_x and node.y == map_y) then
          self.path_pointer = self.path_pointer + 1
          return 
        end
        self:move_to_node(node)
      else
--         return self:go_to(self.destination.x, self.destination.y, self.destination.m)
      end
    end
  end
end

function Player.move_to_node(self, node)
  local map_x = self:get_x()
  local map_y = self:get_y()
  if (math.abs(map_x - node.x) + math.abs(map_y - node.y) > 1) then
    self.path = nil
    return false
  end
  local result
  print(("Next: X %d, Y %d"):format(node.x, node.y))
  -- this could be more elegant/efficient
  if     (map_x - node.x ==  1) then
    result = self:left()
  elseif (map_x - node.x == -1) then
    result = self:right()
  elseif (map_y - node.y ==  1) then
    result = self:up()
  elseif (map_y - node.y == -1) then
    result = self:down()
  end
  if result or (self:get_x() == map_x and self:get_y() == map_y) then
    self.path_pointer = self.path_pointer + 1
  end
end

function Player.go_to_name(self, location)
end

function Player.set_mode(self, mode)
  if mode == "autobattle" then
    self.mode.grind = false
    self.mode.auto_battle = true
    self.mode.fraidy_cat = false
--     self.mode.autonav = false
    self.mode.explore    = false
  elseif mode == "fraidycat" then
    self.mode.grind = false
    self.mode.auto_battle = false
    self.mode.fraidy_cat = true
--     self.mode.autonav = false
    self.mode.explore    = false
  elseif mode == "manual" then
    self.mode.grind = false
    self.mode.auto_battle = false
    self.mode.fraidy_cat = false
    self.mode.autonav = false
    self.mode.explore    = false
  elseif cheat.grind_mode and mode == "grind" then
    self.mode.grind = true
    self.mode.auto_battle = false
    self.mode.fraidy_cat = false
    self.mode.autonav = false
    self.mode.explore    = false
  end
end

function Player.heal_thy_self(self)
  self.quiet = true
  if self.hp * 3 < self.max_hp() then
    if self:healmore() then
      return true
    elseif self:herb() then
      return true
    elseif self:heal() then 
      return true
    end
  elseif not in_battle then
    if self.max_hp() - self.hp >= 30 then
      if self:herb() then
        return true
      elseif self:heal() then
        return true
      end
    end
  end
  self.quiet = false
  return false
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
    battle_mode(true, false)
  end

  -- update grind mode if needed
  if not debug.offline and cheat.grind_mode and not player.mode.grind and 
    emu.framecount() - player.last_command > 36000 then
    player:set_mode("grind")
  end
  -- hit points wrap below zero, so check for large increases.
  if self.hp == 0 or self.change.hp > 160 then
    battle_mode(false, false)
  end

end

function Enemy.show_hp (self)
  if (in_battle and cheat.enemy_hp) then 
    gui.drawbox(152, 134, 190, 144, "black")
    gui.text(154, 136, string.format( "HP %3d", self.hp), "white", "black")
  end
end

function Enemy.set_hp(hp)
  if (hp > 255 or hp < 0) then
    return false
  end
  memory.writebyte(0xe2, hp)
  return true
end
-- 
--  Draws any hud elements, such as the enemy hit points
-- 
function overlay()
  enemy:show_hp()
  if cheat.grind_mode and player.mode.grind then
    gui.drawbox(0, 0, 60, 15, "black")
    gui.text(8, 8, "Grind mode", "white", "black")
  end
  if player.mode.auto_battle then
    gui.drawbox(0, 0, 82, 15, "black")
    gui.text(8, 8, "Auto-battle mode", "white", "black")
  end
  if player.mode.fraidy_cat then
    gui.drawbox(0, 0, 82, 15, "black")
    gui.text(8, 8, "Fraidy-cat mode", "white", "black")
  end

  if debug.hud then
    gui.text(8, 16, 
      string.format( "Frame:  %d", emu.framecount()), "white", "black")
    gui.text(8, 24,
      string.format( "Map: [%3d,%3d,%3d]",
        memory.readbyte(0x45), memory.readbyte(0x8e), memory.readbyte(0x8f)
      ), "white", "black")
    gui.text(8, 32,
      string.format( "Player: [%3d,%3d,%3d]",
        memory.readbyte(0x45), memory.readbyte(0x3a), memory.readbyte(0x3b)
      ), "white", "black")
    gui.text(8, 40, 
      string.format( "Tile:  %d", memory.readbyte(0xe0)), "white", "black")
    if player.path ~= nil then
      local pathnode = player.path[player.path_pointer]
      if pathnode ~= nil and pathnode.m ~= nil and pathnode.x ~= nil and pathnode.y ~= nil then
        gui.text(8, 48,
          string.format( "Nextnode: [%3d,%3d,%3d]",
            pathnode.m, pathnode.x, pathnode.y
          ), "white", "black")
      end
    end

--     gui.text(8, 32,
--       string.format( "Player Pos: [%3d,%3d]",
--         memory.readbyte(0x3a), memory.readbyte(0x3b)
--       ), "white", "black")
--     gui.text(8, 40,
--       string.format( "Cursor: [%3d,%3d]",
--         memory.readbyte(0xd8), memory.readbyte(0xd9)
----        ), "white", "black")

  end

--  local zone = math.floor(memory.readbyte(0x3b) / 15) * 4 + memory.readbyte(0x3a) / 30
--  gui.text(8, 32, string.format( "Zone %3d", zone), "white", "black")

end

function update()
  -- create a save state every 10 minutes in case of a crash
  if (emu.framecount() % 1000 == 0) then
    map:dump()
    print(("Map dumped at %d"):format(emu.framecount()))
  end
--   if (emu.framecount() % 3600 == 0) then
--    savestate.persist(savestate.object(1))
    -- path test
--   end
  -- update the player and enemy info every 1/4 second
  if (emu.framecount() % 15 == 0) then
    player:update()
    enemy:update()
  end

  -- down + select => grind mode
  if memory.readbyte(0x47) == 36 then
    player.last_command = 0
  end

  if cheat.repulsive then
    memory.writebyte(0xdb, 0xff)
  end
end

-- main loop
savestate.load(savestate.object(1))
irc.initialize(irc.settings)
if not debug.offline then
  irc.connect()
end
player = Player
enemy = Enemy
enemy:update()
player:update()
player.last_command = emu.framecount()
player:go_to( 18,  26, 4)
gui.register(overlay)
emu.registerafter(update)

while(true) do
  -- auto stairs
--   if ((player.tile == TILE.STAIRS_UP or player.tile == TILE.STAIRS_DOWN) and
--       not (player.last_tile == TILE.STAIRS_UP or 
--            player.last_tile == TILE.STAIRS_DOWN)) then
--     player.last_tile = player.tile
--     player:stairs()
--   end
  if not debug.offline then
    irc.read()
    if irc.messages_size() > 0 then
      msg = irc.message()
      if msg ~= nil then
        command = string.lower(msg.message)
        if (parsecommand(player, command)) then
          player.last_command = emu.framecount()
          player.mode.grind = false
        end
      end
    end
  end
  player:grind()
  player:follow_path()
  emu.frameadvance()
end

