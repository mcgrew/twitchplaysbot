
Player.equipment_list = {
  { name="Small Shield", value=1  },
  { name="Large Sheild", value=2  },
  { name="Silver Shield", value=3  },
  { name="Clothes", value=4  },
  { name="Leather Armor", value=8  },
  { name="Chain Mail", value=12 },
  { name="Half Plate Armor", value=16 },
  { name="Full Plate Armor", value=20 },
  { name="Magic Armor", value=24 },
  { name="Erdrick's Armor", value=28 },
  { name="Bamboo Pole", value=32 },
  { name="Club", value=64 },
  { name="Copper Sword", value=96 },
  { name="Hand Axe", value=128},
  { name="Broad Sword", value=160},
  { name="Flame Sword", value=182},
  { name="Erdrick's Sword", value=214},
}

Player.levels = {
     0,     7,     23,    47,   110,
   220,   450,    800,  1300,  2000,
  2900,   4000,  5500,  7500, 10000,
  13000, 16000, 19000, 22000, 26000,
  30000, 34000, 38000, 42000, 46000,
  50000, 54000, 58000, 62000, 65535
}

Items = {
  "Torch",
  "Fairy Water",
  "Wings",
  "Dragon's Scale",
  "Fairy Flute",
  "Fighter's Ring",
  "Erdrick's Token",
  "Gwaelin's Love",
  "Cursed Belt",
  "Silver Harp",
  "Death Necklace",
  "Stones of Sunlight",
  "Staff of Rain",
  "Rainbow Drop",
  "Herb"
}

Map.doors = {
    { x=18, y= 6, m= 4}, --tantegel
    { x=21, y= 6, m= 8}, --brecconary
    { x=17, y=10, m= 9}, --garinham
    { x= 8, y=25, m=10}, --cantlin
    { x= 4, y=21, m=10},
    { x=26, y= 9, m=10}
}

-- callback to execute for inn
function inn_callback ()
  if player:get_hp() < player:max_hp() or
     player:get_mp() < player:max_mp() then
    pressa()
    return false
  end
  wait(300)
  pressb()
  wait(120)
  pressb()
  return true
end

Map.shops = {
  tool = {
    { x=23, y=25, m= 8, commands = {"right", "talk"}, items = { --brecconary
      "herb",
      "torch",
      "dragon's scale"
    }},
    -- this one moves around behind the counter
    { x=22, y= 4, m= 8, commands = {"right", "talk"}, items = { --brecconary
      "fairy water"
    }},
    { x= 3, y=11, m= 9, commands = {"right", "talk"}, items = { --garinham
      "herb",
      "torch",
      "dragon's scale"
    }},
    { x=12, y=21, m= 7, commands = {"right", "talk"}, items = { --kol
      "herb",
      "torch",
      "dragon's scale",
      "wings"
    }},
    { x= 4, y= 7, m=10, commands = {"left", "talk"}, items = { --cantlin
      "herb",
      "torch"
    }},
    { x= 5, y=12, m=10, commands = {"right", "talk"}, items = { --cantlin
      "dragon's scale",
      "wings"
    }},
    { x=20, y=13, m=10, commands = {"right", "talk"}, items = { --cantlin
      "fairy water"
    }},
  },
  weapon = {
    { x= 5, y= 6, m= 8, commands = {"up", "talk"}, items = { --brecconary
      "bamboo pole",
      "club",
      "copper sword",
      "clothes",
      "leather armor",
      "small shield"
    }},
    { x=10, y=16, m= 9, commands = {"down", "talk"}, items = { --garinham
      "club",
      "copper sword",
      "hand axe",
      "chain mail",
      "half plate",
      "large sheild"
    }},
    { x=20, y=12, m= 7, commands = {"right", "talk"}, items = { --kol
      "copper sword",
      "hand axe",
      "half plate",
      "full plate",
      "small shield"
    }},
    { x=23, y= 9, m=11, commands = {"up", "talk"}, items = { --rimuldar
      "copper sword",
      "hand axe",
      "broad sword",
      "half plate",
      "full plate",
      "magic armor"
    }},
    -- this one moves around behind the counter
    { x=20, y= 4, m=10, commands = {"right", "talk"}, items = { --cantlin
      "bamboo pole",
      "club",
      "copper sword",
      "leather armor",
      "chain mail",
      "large sheild"
    }},
    { x=25, y=26, m=10, commands = {"right", "talk"}, items = { --cantlin
      "bamboo pole",
      "club",
      "copper sword",
      "leather armor",
      "chain mail",
      "large sheild"
    }},
    { x=26, y=12, m=10, commands = {"left", "talk"}, items = { --cantlin
      "hand axe",
      "broad sword",
      "full plate",
      "magic armor"
    }}
  },
  key = {
    { x=24, y= 3, m= 4, commands = {"up",   "talk"}}, --tantegel
    { x= 4, y= 5, m=11, commands = {"down", "talk"}}, --rimuldar
    { x=27, y= 8, m=10, commands = {"up", "talk"}},   --cantlin
  },
  inn = {
    { x= 8, y=21, m= 8, commands = {"right", "talk"}, callback=inn_callback}, --brecconary
    { x=15, y=15, m= 9, commands = {"right", "talk"}, callback=inn_callback}, --garinham
    { x=19, y= 2, m= 7, commands = {"down",  "talk"}, callback=inn_callback}, --kol
    { x=18, y=18, m=11, commands = {"left",  "talk"}, callback=inn_callback}, --rimuldar
    { x= 8, y= 5, m=10, commands = {"up",  "talk"}, callback=inn_callback}, --rimuldar
  }
}


Map.warps = {
  { from = {x= 43, y= 43, m= 1}, to = {x= 11, y= 29, m= 4}, command = nil },   --tantegel
  { from = {x=nil, y=  0, m= 4}, to = {x= 43, y= 43, m= 1}, command = "up" },
  { from = {x=nil, y= 29, m= 4}, to = {x= 43, y= 43, m= 1}, command = "down" },
  { from = {x=  0, y=nil, m= 4}, to = {x= 43, y= 43, m= 1}, command = "left" },
  { from = {x= 29, y=nil, m= 4}, to = {x= 43, y= 43, m= 1}, command = "right" },
  { from = {x=  7, y=  7, m= 4}, to = {x=  8, y=  8, m= 5}, command = "stairs" },
  { from = {x=  8, y=  8, m= 5}, to = {x=  7, y=  7, m= 4}, command = "stairs" },
  { from = {x= 29, y= 29, m= 4}, to = {x=  0, y=  4, m=12}, command = "stairs" },
  { from = {x=  0, y=  4, m=12}, to = {x= 29, y= 29, m= 4}, command = "stairs" },

  { from = {x= 48, y= 41, m= 1}, to = {x=  8, y=  0, m= 8}, command = nil },   --brecconary
  { from = {x=nil, y=  0, m= 8}, to = {x= 48, y= 41, m= 1}, command = "up" },
  { from = {x=  0, y=nil, m= 8}, to = {x= 48, y= 41, m= 1}, command = "left" },
  { from = {x= 29, y=nil, m= 8}, to = {x= 48, y= 41, m= 1}, command = "right" },

  { from = {x=  2, y=  2, m= 1}, to = {x=  0, y= 14, m= 9}, command = nil },   --garinham
  { from = {x=nil, y=  0, m= 9}, to = {x=  2, y=  2, m= 1}, command = "up" },
  { from = {x=nil, y= 19, m= 9}, to = {x=  2, y=  2, m= 1}, command = "down" },
  { from = {x=  0, y=nil, m= 9}, to = {x=  2, y=  2, m= 1}, command = "left" },
  { from = {x= 19, y=nil, m= 9}, to = {x=  2, y=  2, m= 1}, command = "right" },

  { from = {x= 19, y=  0, m= 9}, to = {x=  6, y= 11, m=24}, command = "stairs" }, --grave of garin
  { from = {x=  6, y= 11, m=24}, to = {x= 19, y=  0, m= 9}, command = "stairs" }, 
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

  { from = {x=104, y= 10, m= 1}, to = {x=  0, y= 14, m= 7}, command = nil },   --kol
  { from = {x=nil, y=  0, m= 7}, to = {x=104, y= 10, m= 1}, command = "up" },
  { from = {x=nil, y= 23, m= 7}, to = {x=104, y= 10, m= 1}, command = "down" },
  { from = {x=  0, y=nil, m= 7}, to = {x=104, y= 10, m= 1}, command = "left" },
  { from = {x= 23, y=nil, m= 7}, to = {x=104, y= 10, m= 1}, command = "right" },

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
  }

Map.locations = {
  tantegel      = {x= 43, y= 43, m= 1, map= 4},
  brecconary    = {x= 48, y= 41, m= 1, map= 8},
  garinham      = {x=  2, y=  2, m= 1, map= 9},
  kol           = {x=104, y= 10, m= 1, map= 7},
  rimuldar      = {x=102, y= 72, m= 1, map=11},
  cantlin       = {x= 73, y=102, m= 1, map=10},
  hauksness     = {x= 25, y= 89, m= 1, map= 3},

  ['northern shrine']   = {x= 81, y=  1, m= 1, map=13, commands = {"stairs"}},
  ['southern shrine']   = {x=108, y=109, m= 1, map=14, commands = {"stairs"}},
  ['the king' ]         = {x=  3, y=  4, m= 5, commands = { "up", "talk" }, 
      callback = function() for i=1,6 do wait(90); pressa() end return true end },
  ['magic man']         = {x= 18, y= 26, m= 4, commands = { "right", "talk" }},
-- ["silver harp"]      = {x= 13, y=  6, m=26, commands={"take"},
-- dragonlord           = {x= 17, y= 24, m= 6, commands={"left","talk"},
-- ["erdrick's sword"]  = {x=  5, y=  5, m=16, commands={"take"},
-- ["erdrick's armor"]  = {x= 17, y= 12, m= 3}, -- one step left of the armor
-- ["erdrick's token"]  = {x= 83, y=113, m= 1, commands={"search"}}, 
-- ["stones of sunlight"]= {x=  4, y=  5, m=12, commands={"take"}}, 
  charlock      = {x= 48, y= 48, m= 1, map= 2}
}


