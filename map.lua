require("astar")

Map = {
}


function Map.init(self)
  self.nodes = {}
  for m=1,29 do
    for x=0,127 do
      for y=0,(127)do
        table.insert(self.nodes, { x = x, y = y, cost = self:cost(x, y, m)})
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
  local f = io.open('mymap.lua', 'w')
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
  self.nodes[((map_num-1) * 16384) + x * 128 + y + 1].cost = self:cost(x, y, map_num)
end

function Map.get_tile(self, x, y, map_num)
  return self.map[map_num][x+1][y+1]
end

function Map.cost(self, x, y, map_num)
  if self.map[map_num] == nil or self.map[map_num][x] == nil or self.map[map_num][x][y] == nil then
    return 255
  end
  local tile = self:get_tile(x, y, map_num)
  if     tile == 0x0 then --grass
    return 1
  elseif tile == 0x1 then --desert
    return 3
  elseif tile == 0x2 then --hill
    return 3
  elseif tile == 0x3 then --stairs up
    return 1
  elseif tile == 0x4 then --brick
    return 2
  elseif tile == 0x5 then --stairs down
    return 1
  elseif tile == 0x6 then --swamp
    return 6 -- actually 2, but we want to avoid swamp.
  elseif tile == 0x7 then --town
    return 1 --?
  elseif tile == 0x8 then --cave
    return 1 --?
  elseif tile == 0x9 then --castle
    return 1 --?
  elseif tile == 0xa then --bridge
    return 1 --?
  elseif tile == 0xb then --forest
    return 2
  elseif tile == 0xc then --treasure chest
    return 1
  elseif tile == 0xd then --barrier
    return 2
  else
    return tile
  end
end


function Map.getnode(self, x, y, map_num)
  return self.nodes[(map_num-1) * 16384 + x * 128 + y + 1]
end

function Map.path(self, from_x, from_y, from_map, to_x, to_y, to_map)
  local start = self:getnode(from_x, from_y, from_map)
  local goal  = self:getnode(  to_x,   to_y,   to_map)
  return path(start, goal, self.nodes, false, is_valid)
end

-- Overrides for astar
function is_valid(node1, node2)
  return math.abs(node1.x - node2.x) == 1 and node1.y == node2.y 
    and math.abs(node1.y - node2.y) == 1 and node1.x == node2.x 
    and node2.cost < 127
end

function dist_between(current, neighbor)
  return neighbor.cost
end


function neighbor_nodes(current, nodes)
  local x = current.x
  local y = current.y % 128
  local m = math.floor(current.y / 128) + 1
  local node
  neighbors = {}
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
-- local f = io.open("mymap.lua","r")
-- if f ~= nil then 
--   io.close(f) 
  require("mymap")
-- end

map:init()

