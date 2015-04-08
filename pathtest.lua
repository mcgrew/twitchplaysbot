
require("map")
require("mymap")


start = map:getnode(43, 43)
goal = map:getnode( 2,  2)

p = path(start, goal, map, false, is_valid)

for t=1,500 do
  if p[t] == nil then
    break
  end
  print(("X: %d, Y: %d, cost: %d"):format(p[t].x, p[t].y, p[t].cost))
end
