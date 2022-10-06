--------------------------------------------------------------------------------
--                      Tower Of Iyzel Regen Data                             --
--------------------------------------------------------------------------------

RegenInfo =
{
	Group =
	{
		-- 각 쫄 몹들
		Floor01 = { "201",  "202",  },
		Floor02 = { "301",  "302",  },
		Floor03 = { "401",  "402",  },
		Floor04 = { "501",  },

		Floor05 = { "601",  },
		Floor06 = { "701",  },
		Floor07 = { "801",  "802",  },
		Floor08 = { "901",  "902",  "903",  "904",  "905",  "906", },
		Floor09 = { "1002", },

		Floor10 = { "1101", "1102", },
		Floor11 = { "1201", "1202", },
		Floor12 = { "1301", },
		Floor13 = { "1401", "1402", },

		Floor14 = { "1501", "1502", },
		Floor15 = { "1601", },
		Floor16 = { "1701", },
		Floor17 = { "1801", },
		Floor18 = { "1901", },
		Floor19 = { "2001", "2003", },
	},

	Mob =
	{
		-- 각 보스몹
		Floor04 = { DustGolem   = { Index = "T_DustGolem", 		x = 6776,  y = 963,   dir = 0, }, },
		Floor09 = { StoneGolem  = { Index = "T_StoneGolem", 	x = 10709, y = 9808,  dir = 0, }, },
		Floor13 = { PoisonGolem = { Index = "T_PoisonGolem", 	x = 3262,  y = 8795,  dir = 0, }, },
		Floor19 = { IronGolem   = { Index = "T_IronGolem", 		x = 5013,  y = 7773,  dir = 0, }, },
	},

	NPC =
	{
		-- 입구쪽의 클릭하여 나가는 게이트
	},

	Stuff =
	{
		-- 각 층의 블럭 도어
		Door00   = { Index = "T_Gate",   x = 1184,  y = 3723,  dir = 0, Block = "DOOR00", scale = 1000 },
		Door01   = { Index = "T_Gate",   x = 2732,  y = 1863,  dir = 0, Block = "DOOR01", scale = 1000 },
		Door02   = { Index = "T_Gate",   x = 5069,  y = 1058,  dir = 0, Block = "DOOR02", scale = 1000 },
		Door03   = { Index = "T_Gate",   x = 7556,  y = 937,   dir = 0, Block = "DOOR03", scale = 1000 },
		Door04   = { Index = "T_Gate",   x = 10035, y = 951,   dir = 0, Block = "DOOR04", scale = 1000 },
		Door05   = { Index = "T_Gate",   x = 10241, y = 3883,  dir = 0, Block = "DOOR05", scale = 1000 },
		Door06   = { Index = "T_Gate",   x = 11531, y = 5975,  dir = 0, Block = "DOOR06", scale = 1000 },
		Door07   = { Index = "T_Gate",   x = 11727, y = 8426,  dir = 0, Block = "DOOR07", scale = 1000 },
		Door08   = { Index = "T_Gate",   x = 10190, y = 10335, dir = 0, Block = "DOOR08", scale = 1000 },
		Door09   = { Index = "T_Gate",   x = 8139,  y = 11611, dir = 0, Block = "DOOR09", scale = 1000 },
		Door10   = { Index = "T_Gate",   x = 5701,  y = 11825, dir = 0, Block = "DOOR10", scale = 1000 },
		Door11   = { Index = "T_Gate",   x = 3564,  y = 10499, dir = 0, Block = "DOOR11", scale = 1000 },
		Door12   = { Index = "T_Gate",   x = 3278,  y = 8097,  dir = 0, Block = "DOOR12", scale = 1000 },
		Door13   = { Index = "T_Gate",   x = 3276,  y = 5629,  dir = 0, Block = "DOOR13", scale = 1000 },
		Door14   = { Index = "T_Gate",   x = 5394,  y = 4529,  dir = 0, Block = "DOOR14", scale = 1000 },
		Door15   = { Index = "T_Gate",   x = 7902,  y = 4434,  dir = 0, Block = "DOOR15", scale = 1000 },
		Door16   = { Index = "T_Gate",   x = 8976,  y = 6493,  dir = 0, Block = "DOOR16", scale = 1000 },
		Door17   = { Index = "T_Gate",   x = 7003,  y = 7615,  dir = 0, Block = "DOOR17", scale = 1000 },

		ExitGate = { Index = "T_Gate02", x = 1179,  y = 7721,  dir = 0, Block = nil,      scale = 1000 },
	},
}
