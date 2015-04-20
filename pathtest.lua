
require("map")


start = map:getnode(104, 50, 1)
goal =  map:getnode( 83, 113, 1)

p = path(start, goal, map.map, false, is_valid)

if p == nil then
  print("Can't find a path")
else
  for t=1,500 do
    if p[t] == nil then
      break
    end
    print(("X: %d, Y: %d, map: %d, cost: %d"):format(p[t].x, p[t].y, p[t].m, p[t].cost))
  end
end

