--------------------------------------------------------------------------------
--                           Arena Regen Data                                 --
--------------------------------------------------------------------------------


RegenInfo =
{
	Monster =
	{
		-- 아레나 크리스탈
		ArenaCrystal		= 	{ Index = "ArenaCrystal", X = 3200, Y = 3200, Dir = 0, RegenInterval = 10 },

		-- 고대 아레나 용사
		AncientArenaWarrior	=
		{
			-- 원거리
			{ Index = "Arena70_A",	X = 2970, Y = 3200, Dir = 0, RegenInterval = 20 },
			{ Index = "Arena70_A",	X = 3430, Y = 3200, Dir = 0, RegenInterval = 20 },
			
			-- 근거리
			{ Index = "Arena70_F",	X = 3200, Y = 2970, Dir = 0, RegenInterval = 20 },
			{ Index = "Arena70_F",	X = 3200, Y = 3430, Dir = 0, RegenInterval = 20 },
		}
	},

	NPC	=
	{
		-- 아레나 게이트
		ArenaGate	=	{
							{ Index = "ArenaGate_R", X = 4440,	Y = 2830, Dir = 55, },
							{ Index = "ArenaGate_R", X = 5070,	Y = 3900, Dir = 0, },
							{ Index = "ArenaGate_B", X = 1960,	Y = 3560, Dir = 55, },
							{ Index = "ArenaGate_B", X = 1320,	Y = 2494, Dir = 0, },
						},

		-- 크리스탈 수호석
		ArenaStone	= 	{
							{ Index = "ArenaStone", X = 2097, Y = 2358, Dir = 0, },
							{ Index = "ArenaStone", X = 4326, Y = 4027, Dir = 0, },
						},

		-- 깃발
		ArenaFlag	=	{
							[ RED_TEAM ]	= { Index = "ArenaFlag_R", X = 5069, Y = 3207, Dir = 0, },
							[ BLUE_TEAM ]	= { Index = "ArenaFlag_B", X = 1330, Y = 3202, Dir = 0, },
						}
	},
}



