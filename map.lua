require("astar")

Map = {
}


function Map.init(self)
  self.nodes = {}
  for m=1,29 do
    for x=0,127 do
      for y=0,(127)do
        table.insert(self.nodes, { x = x, y = y, m = m, cost = self:cost(x, y, m)})
      end
    end
  end
end

function Map.generate(self)
  if (self.map == nil) then
    self.map = {}
    for m=1,28 do
      self.map[m] = {}
      for x=1,128 do
        self.map[m][x] = {}
        for y=1,128 do
          self.map[m][x][y] = 255
        end
      end
    end
  end
end

function Map.dump(self) 
  if emu.framecount() % 4000 == 0 then
    self.dumproutine = coroutine.create(function(map)
      local f = io.open('worldmap.lua', 'w')
      for m=1,28 do
        f:write(string.format("Map.map[%d] = {\n", m))
        for i=1,128 do
          f:write("{")
          for j=1,128 do
            f:write(string.format("%3d", map[m][i][j]))
            if j < 128 then
              f:write(",")
            end
          end
          if i < 128 then
            f:write("},\n")
          else
            f:write("}\n")
          end
        end
        f:write("}\n")
        coroutine.yield()
      end
      f:close()
      print(("Map dumped at %d"):format(emu.framecount()))
    end)
  end
  if self.dumproutine ~= nil then
    return coroutine.resume(self.dumproutine, self.map) or false
  end
  return false
end
 

function Map.set_tile(self, x, y, map_num, tile)
  -- set the tile to the specified value
  if self.map[map_num] ~= nil and self.map[map_num][x+1] ~= nil and 
      self.map[map_num][x+1][y+1] ~= nil then
    self.map[map_num][x+1][y+1] = tile
    -- update the tile cost in the node list
    self.nodes[((map_num-1) * 128 * 128) + x * 128 + y + 1].cost = self:cost(x, y, map_num)
  end
end

function Map.get_tile(self, x, y, map_num)
  if self.map[map_num] == nil or self.map[map_num][x+1] == nil or self.map[map_num][x+1][y+1] == nil then
    return nil
  end
  return self.map[map_num][x+1][y+1]
end

function Map.cost(self, x, y, map_num)
  local tile = self:get_tile(x, y, map_num)
  if tile == nil then
    return 255
  end
  if     tile == 0x0 then --grass
    return 1
  elseif tile == 0x1 then --desert
    return 3
  elseif tile == 0x2 then --hill
    return 3
  elseif tile == 0x3 then --stairs up
    return 16 -- actually 1, but we should avoid them when navigating
  elseif tile == 0x4 then --brick
    return 2
  elseif tile == 0x5 then --stairs down
    return 16 -- actually 1, but we should avoid them when navigating
  elseif tile == 0x6 then --swamp
    return 6 -- actually 2, but we normally want to avoid swamp.
    -- at some point, maybe we should account for Erdrick's armor
  elseif tile == 0x7 then --town
    return 1 --?
  elseif tile == 0x8 then --cave
    return 16 -- probably 1, but we should avoid them when navigating
  elseif tile == 0x9 then --castle
    return 16 -- probably 1, but we should avoid them when navigating
  elseif tile == 0xa then --bridge
    return 1 -- not sure about this value
  elseif tile == 0xb then --forest
    return 2
  elseif tile == 0xc then --treasure chest
    return 1
  elseif tile == 0xd then --barrier
    return 16 -- actually 2, but we should avoid them when navigating
    -- at some point, maybe we should account for Erdrick's armor
  else
    return tile
  end
end


function Map.getnode(self, x, y, map_num)
  return self.nodes[(map_num-1) * 128 * 128 + x * 128 + y + 1]
end

function Map.path(self, from_x, from_y, from_map, to_x, to_y, to_map)
  local start
  local goal
  if to_x == nil then
    start = self:getnode(player:get_x(), player:get_y(), player:get_map())
    goal  = self:getnode(from_x, from_y, from_map)
  else
    start = self:getnode(from_x, from_y, from_map)
    goal  = self:getnode(  to_x,   to_y,   to_map)
  end
  return path(start, goal, self.nodes, false, is_valid)
end

function Map.path_length(self, path)
  local length = 0
  for i=1,#path do
    length = length + path[i].cost
  end
  return length
end

function Map.warp(self, x, y, map_num) 
  for i=1,500 do
    local w = self.warps[i]
    if w == nil then
      break
    end
    if (w.from.x == nil or w.from.x == x) and 
       (w.from.y == nil or w.from.y == y) and 
        w.from.m == map_num then
      return self.warps[i]
    end
  end
  return nil
end

function Map.is_door(self, x, y, map_num)
  for i=1,#self.doors do
    local door = self.doors[i]
    if door.x == x and door.y == y and 
       door.m == map_num and door.open ~= true then
      return true
    end
  end
  return false
end

function Map.mark_door(self, x, y, map_num)
  for i=1,#self.doors do
    local door = self.doors[i]
    if door.x == x and door.y == y and door.m == map_num then
      door.open = true
    end
  end
end

function Map.reset_doors(self)
  for i=1,#self.doors do
    local door = self.doors[i]
      door.open = false
  end
end

function Map.name_from_map(self, mapnum)
  for k,v in pairs(self.locations) do
    if v.map == mapnum then
      return k
    end
  end
end

-- Overrides for astar
function is_valid(node1, node2)
  return math.abs(node1.x - node2.x) == 1 and node1.y == node2.y 
    and math.abs(node1.y - node2.y) == 1 and node1.x == node2.x 
    and node2.cost < 200
end

function dist_between(current, neighbor)
  return neighbor.cost
end


function neighbor_nodes(current, nodes)
  local x = current.x
  local y = current.y
  local m = current.m
  local node
  local neighbors = {}
  local warp = map:warp(x, y, m)
  if warp ~= nil then
      node = map:getnode(warp.to.x, warp.to.y, warp.to.m)
      table.insert(neighbors, node)
  end
  if x > 0 then
    node = map:getnode(x-1, y  , m)
    if node.cost < 255 then
      table.insert(neighbors, node)
    end
  end
  if x < 128 then
    node = map:getnode(x+1, y  , m)
    if node.cost < 255 then
      table.insert(neighbors, node)
    end
  end
  if y > 0 then
    node = map:getnode(x  , y-1, m)
    if node.cost < 255 then
      table.insert(neighbors, node)
    end
  end
  if y < 128 then
    node = map:getnode(x  , y+1, m)
    if node.cost < 255 then
      table.insert(neighbors, node)
    end
  end
  return neighbors
end

map = Map
map:generate()
-- local f = io.open("worldmap.lua","r")
-- if f ~= nil then 
--   io.close(f) 
  require("worldmap")
-- end

map:init()

