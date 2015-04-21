require("astar")

Map = {
  warps = {
    { from = {x= 43, y= 43, m= 1}, to = {x= 11, y= 29, m= 4}, command = nil },   --tantegel
    { from = {x=nil, y=  0, m= 4}, to = {x= 43, y= 43, m= 1}, command = "up" },
    { from = {x=nil, y= 29, m= 4}, to = {x= 43, y= 43, m= 1}, command = "down" },
    { from = {x=  0, y=nil, m= 4}, to = {x= 43, y= 43, m= 1}, command = "left" },
    { from = {x= 29, y=nil, m= 4}, to = {x= 43, y= 43, m= 1}, command = "right" },
    { from = {x=  7, y=  7, m= 4}, to = {x=  8, y=  8, m= 5}, command = "stairs" },
    { from = {x=  8, y=  8, m= 5}, to = {x=  7, y=  7, m= 4}, command = "stairs" },

    { from = {x= 48, y= 41, m= 1}, to = {x=  8, y=  0, m= 8}, command = nil },   --brecconary
    { from = {x=nil, y=  0, m= 8}, to = {x= 48, y= 41, m= 1}, command = "up" },
    { from = {x=  0, y=nil, m= 8}, to = {x= 48, y= 41, m= 1}, command = "left" },
    { from = {x= 29, y=nil, m= 8}, to = {x= 48, y= 41, m= 1}, command = "right" },

    { from = {x=  2, y=  2, m= 1}, to = {x=  0, y= 14, m= 9}, command = nil },   --garinham
    { from = {x=nil, y=  0, m= 9}, to = {x=102, y= 72, m= 1}, command = "up" },
    { from = {x=nil, y= 19, m= 9}, to = {x=102, y= 72, m= 1}, command = "down" },
    { from = {x=  0, y=nil, m= 9}, to = {x=102, y= 72, m= 1}, command = "left" },
    { from = {x= 19, y=nil, m= 9}, to = {x=102, y= 72, m= 1}, command = "right" },

    { from = {x= 19, y=  0, m= 9}, to = {x=  6, y= 11, m=24}, command = "stairs" }, --grave of garin
    { from = {x=  6, y= 11, m=24}, to = {x= 19, y=  0, m= 9}, command = "stairs" }, --grave of garin
    { from = {x=  1, y= 18, m=24}, to = {x= 11, y=  2, m=25}, command = "stairs" },
    { from = {x= 11, y=  2, m=25}, to = {x=  1, y= 18, m=24}, command = "stairs" },
    { from = {x= 12, y=  1, m=25}, to = {x= 18, y=  1, m=26}, command = "stairs" },
    { from = {x= 18, y=  1, m=26}, to = {x= 12, y=  1, m=25}, command = "stairs" },
    { from = {x= 12, y= 10, m=25}, to = {x= 18, y= 13, m=26}, command = "stairs" },
    { from = {x= 18, y= 13, m=26}, to = {x= 12, y= 10, m=25}, command = "stairs" },
    { from = {x= 14, y=  1, m=26}, to = {x=  1, y=  1, m=25}, command = "stairs" },
    { from = {x=  1, y=  1, m=25}, to = {x= 14, y=  1, m=26}, command = "stairs" },
    { from = {x=  5, y=  6, m=25}, to = {x=  6, y= 11, m=26}, command = "stairs" },
    { from = {x=  6, y= 11, m=26}, to = {x=  5, y=  6, m=25}, command = "stairs" },
    { from = {x=  1, y= 10, m=25}, to = {x=  2, y= 17, m=26}, command = "stairs" },
    { from = {x=  2, y= 17, m=26}, to = {x=  1, y= 10, m=25}, command = "stairs" },
    { from = {x=  9, y=  5, m=26}, to = {x=  0, y=  4, m=27}, command = "stairs" },
    { from = {x=  0, y=  4, m=27}, to = {x=  9, y=  5, m=26}, command = "stairs" },
    { from = {x=  5, y=  4, m=27}, to = {x= 10, y=  9, m=26}, command = "stairs" },
    { from = {x= 10, y=  9, m=26}, to = {x=  5, y=  4, m=27}, command = "stairs" },

    { from = {x=104, y= 10, m= 1}, to = {x=  0, y= 14, m= 9}, command = nil },   --kol
    { from = {x=nil, y=  0, m= 9}, to = {x=104, y= 10, m= 1}, command = "up" },
    { from = {x=nil, y= 23, m= 9}, to = {x=104, y= 10, m= 1}, command = "down" },
    { from = {x=  0, y=nil, m= 9}, to = {x=104, y= 10, m= 1}, command = "left" },
    { from = {x= 23, y=nil, m= 9}, to = {x=104, y= 10, m= 1}, command = "right" },

    { from = {x=104, y= 44, m= 1}, to = {x=  0, y=  0, m=21}, command = nil },   -- swamp cave
    { from = {x=  0, y=  0, m=21}, to = {x=104, y= 44, m= 1}, command = "stairs"},
    { from = {x=  0, y= 29, m=21}, to = {x=104, y= 49, m= 1}, command = "stairs" },
    { from = {x=104, y= 49, m= 1}, to = {x=  0, y= 29, m=21}, command = nil },

    { from = {x=102, y= 72, m= 1}, to = {x= 29, y= 14, m=11}, command = nil },   --rimuldar
    { from = {x=nil, y=  0, m=11}, to = {x=102, y= 72, m= 1}, command = "up" },
    { from = {x=nil, y= 29, m=11}, to = {x=102, y= 72, m= 1}, command = "down" },
    { from = {x=  0, y=nil, m=11}, to = {x=102, y= 72, m= 1}, command = "left" },
    { from = {x= 29, y=nil, m=11}, to = {x=102, y= 72, m= 1}, command = "right" },

    { from = {x= 73, y=102, m= 1}, to = {x= 15, y=  0, m=10}, command = nil },   --cantlin
    { from = {x=nil, y=  0, m=10}, to = {x= 73, y=102, m= 1}, command = "up" },
    { from = {x=nil, y= 29, m=10}, to = {x= 73, y=102, m= 1}, command = "down" },
    { from = {x=  0, y=nil, m=10}, to = {x= 73, y=102, m= 1}, command = "left" },
    { from = {x= 29, y=nil, m=10}, to = {x= 73, y=102, m= 1}, command = "right" },

    { from = {x= 25, y= 89, m= 1}, to = {x=  0, y= 10, m= 3}, command = nil },   --hauksness
    { from = {x=nil, y=  0, m= 3}, to = {x= 25, y= 89, m= 1}, command = "up" },
    { from = {x=nil, y= 19, m= 3}, to = {x= 25, y= 89, m= 1}, command = "down" },
    { from = {x=  0, y=nil, m= 3}, to = {x= 25, y= 89, m= 1}, command = "left" },
    { from = {x= 19, y=nil, m= 3}, to = {x= 25, y= 89, m= 1}, command = "right" },

    { from = {x= 48, y= 48, m= 1}, to = {x= 10, y= 19, m= 2}, command = nil },   --charlock
    { from = {x=nil, y= 19, m= 2}, to = {x= 48, y= 48, m= 1}, command = "down" },

    { from = {x= 10, y=  1, m= 2}, to = {x=  9, y=  0, m=15}, command = "stairs" },
    { from = {x=  9, y=  0, m=15}, to = {x= 10, y=  1, m= 2}, command = "stairs" },
    { from = {x=  8, y= 19, m=15}, to = {x=  5, y=  0, m=16}, command = "stairs" },
    { from = {x=  5, y=  0, m=16}, to = {x=  8, y= 19, m=15}, command = "stairs" },
    { from = {x=  3, y=  0, m=16}, to = {x=  7, y=  0, m=17}, command = "stairs" },
    { from = {x=  7, y=  0, m=17}, to = {x=  3, y=  0, m=16}, command = "stairs" },
    { from = {x=  5, y=  4, m=17}, to = {x=  0, y=  8, m=16}, command = "stairs" },
    { from = {x=  0, y=  8, m=16}, to = {x=  5, y=  4, m=17}, command = "stairs" },
    { from = {x=  1, y=  9, m=16}, to = {x=  0, y=  9, m=17}, command = "stairs" },
    { from = {x=  0, y=  9, m=17}, to = {x=  1, y=  9, m=16}, command = "stairs" },
    { from = {x=  1, y=  6, m=17}, to = {x=  0, y=  9, m=18}, command = "stairs" },
    { from = {x=  0, y=  9, m=18}, to = {x=  1, y=  6, m=17}, command = "stairs" },
    { from = {x=  8, y=  1, m=18}, to = {x=  4, y=  0, m=19}, command = "stairs" },
    { from = {x=  4, y=  0, m=19}, to = {x=  8, y=  1, m=18}, command = "stairs" },
    { from = {x=  5, y=  5, m=19}, to = {x=  0, y=  0, m=20}, command = "stairs" },
    { from = {x=  0, y=  0, m=20}, to = {x=  5, y=  5, m=19}, command = "stairs" },
    { from = {x=  9, y=  0, m=20}, to = {x=  0, y=  0, m=20}, command = "stairs" },
    { from = {x=  7, y=  7, m=18}, to = {x=  7, y=  7, m=17}, command = "stairs" },
    { from = {x=  7, y=  7, m=17}, to = {x=  7, y=  7, m=18}, command = "stairs" },
    { from = {x=  2, y=  2, m=17}, to = {x=  9, y=  1, m=16}, command = "stairs" },
    { from = {x=  9, y=  1, m=16}, to = {x=  2, y=  2, m=17}, command = "stairs" },
    { from = {x=  8, y=  0, m=16}, to = {x= 15, y=  1, m=15}, command = "stairs" },
    { from = {x= 15, y=  1, m=15}, to = {x=  8, y=  0, m=16}, command = "stairs" },
    { from = {x= 13, y= 17, m=15}, to = {x=  4, y=  4, m=16}, command = "stairs" },
    { from = {x=  4, y=  4, m=16}, to = {x= 13, y= 17, m=15}, command = "stairs" },
    { from = {x=  2, y=  2, m=18}, to = {x=  9, y=  0, m=19}, command = "stairs" },
    { from = {x=  9, y=  0, m=19}, to = {x=  2, y=  2, m=18}, command = "stairs" },
    { from = {x=  0, y=  0, m=19}, to = {x=  0, y=  6, m=20}, command = "stairs" },
    { from = {x=  0, y=  6, m=20}, to = {x=  0, y=  0, m=19}, command = "stairs" },
    { from = {x=  9, y=  6, m=20}, to = {x= 10, y= 29, m= 6}, command = "stairs" },
    { from = {x= 10, y= 29, m= 6}, to = {x=  9, y=  6, m=20}, command = "stairs" },
  },
  locations = {
    ['the king' ] = {x=  3, y=  4, m= 5        },
    ['magic man'] = {x= 18, y= 26, m= 4        },
    tantegel      = {x= 43, y= 43, m= 1, map= 4},
    brecconary    = {x= 48, y= 41, m= 1, map= 8},
    garinham      = {x=  2, y=  2, m= 1, map= 9},
    kol           = {x=104, y= 10, m= 1, map= 7},
    rimuldar      = {x=102, y= 72, m= 1, map=11},
    cantlin       = {x= 73, y=102, m= 1, map=10},
    hauksness     = {x= 25, y= 89, m= 1, map= 3},
    charlock      = {x= 48, y= 48, m= 1, map= 2}
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
  end
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
    if (w.from.x == nil or w.from.x == x) and 
       (w.from.y == nil or w.from.y == y) and 
        w.from.m == map_num then
      return self.warps[i]
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

