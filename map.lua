require("astar")

Map = {
  warps = {
    {x=104, y= 44, m= 1}, {x=  0, y=  0, m=21},
    {x=  0, y=  0, m=21}, {x=104, y= 44, m= 1}, 
    {x=  0, y= 29, m=21}, {x=104, y= 49, m= 1},
    {x= 43, y= 43, m= 1}, {x= 11, y= 29, m= 4}
  },
  locations = {
    tantegel   = {x= 43, y= 43, m= 1, map= 4},
    brecconary = {x= 48, y= 41, m= 1, map= 8},
    garinham   = {x=  2, y=  2, m= 1, map= 9},
    kol        = {x=104, y= 10, m= 1, map= 7},
    rimuldar   = {x=102, y= 72, m= 1, map=11},
    cantlin    = {x= 73, y=102, m= 1, map=10},
    hauksness  = {x= 25, y= 89, m= 1, map= 3},
    charlock   = {x= 48, y= 48, m= 1, map= 2}
  }
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
  local f = io.open('worldmap.lua', 'w')
  for m=1,28 do
    f:write(string.format("Map.map[%d] = {\n", m))
    for i=1,128 do
      f:write("{")
      for j=1,128 do
        f:write(string.format("%3d", self.map[m][i][j]))
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
  end
  f:close()
end

function Map.set_tile(self, x, y, map_num, tile)
  -- set the tile to the specified value
  self.map[map_num][x+1][y+1] = tile
  -- update the tile cost in the node list
  self.nodes[((map_num-1) * 128 * 128) + x * 128 + y + 1].cost = self:cost(x, y, map_num)
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
  local start = self:getnode(from_x, from_y, from_map)
  local goal  = self:getnode(  to_x,   to_y,   to_map)
  return path(start, goal, self.nodes, false, is_valid)
end

function Map.warp(self, x, y, map_num) 
  for i=1,500 do
    local w = self.warps[i]
    if w == nil then
      break
    end
    if w.x == x and w.y == y and w.m == map_num then
      if i % 2 == 0 then 
        return self.warps[i-1]
      else 
        return self.warps[i+1]
      end
    end
  end
  return nil
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
      node = map:getnode(warp.x, warp.y, warp.m)
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

