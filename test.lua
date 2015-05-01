
require("map")
require("worldmap")

Player = {}
Enemy = {}
require("data")



start = map:getnode(104, 50, 1)
goal =  map:getnode( 83, 113, 1)

p = path(start, goal, map.map, false, is_valid)

if p == nil then
  print("Path test - FAIL")
else
  print("Path test - pass")
end

shops = map:shops_filtered('herb', 9)
if #shops ~= 1 then
  print("Shops filter - FAIL")
else
  print("Shops filter - pass")
end



