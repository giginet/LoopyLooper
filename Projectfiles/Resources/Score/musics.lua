--[[
  1面 :オーソドックス
  2面 :パターン
  3面 :トリッキー
]]

local musics = {
  {
    file = "Loop_3_%d.caf",
    title = "LoopyLooper",
    bpm = 120,
    score = "%@0.lua",
    loops = 4
  }, {
    file = "Loop_Poppy_%d.caf",
    title = "Poppy",
    bpm = 120,
    score = "%@1.lua",
    loops = 4
  }, {
    file = "Loop_Underground_%d.caf",
    title = "Underground",
    bpm = 120,
    score = "%@2.lua",
    loops = 4
  }
}

return musics