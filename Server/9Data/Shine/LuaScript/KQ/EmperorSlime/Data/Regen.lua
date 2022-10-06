--------------------------------------------------------------------------------
--                         Emperor Slime Regen Data                           --
--------------------------------------------------------------------------------

RegenInfo =
{
	Group =
	{
		FirstFloor =
		{
			"KDGreenHillArea05", "KDGreenHillArea06", "KDGreenHillArea07", "KDGreenHillArea08", "KDGreenHillArea09",
			"KDGreenHillArea10", "KDGreenHillArea11", "KDGreenHillArea12", "KDGreenHillArea13", "KDGreenHillArea14",
			"KDGreenHillArea15", "KDGreenHillArea16", "KDGreenHillArea24",
		},

		SecondFloor =
		{
			"KDGreenHillArea17", "KDGreenHillArea18", "KDGreenHillArea19", "KDGreenHillArea20", "KDGreenHillArea21",
			"KDGreenHillArea28", "KDGreenHillArea48", "KDGreenHillArea49", "KDGreenHillArea50", "KDGreenHillArea51",
			"KDGreenHillArea52", "KDGreenHillArea53", "KDGreenHillArea56", "KDGreenHillArea57",
		},

		ThirdFloor =
		{
			"KDGreenHillArea03", "KDGreenHillArea04", "KDGreenHillArea22", "KDGreenHillArea23", "KDGreenHillArea25",
			"KDGreenHillArea26", "KDGreenHillArea27", "KDGreenHillArea29", "KDGreenHillArea30", "KDGreenHillArea44",
			"KDGreenHillArea45", "KDGreenHillArea46", "KDGreenHillArea47",
		},
	},



	Mob =
	{
		ThirdFloor =
		{
			{ Index = "Emp_KingSlime", x =8063, y = 6037, dir = 0 },
			{ Index = "Emp_KingSlime", x =5770, y = 4937, dir = 0 },
			{ Index = "Emp_KingSlime", x =6357, y = 7410, dir = 0 },
		},

		TopFloor =
		{
			EmperorSlime = { Index = "Emp_EmperorSlime", x = 7084, y = 6147, dir = 90 },

			-- 블럭 상황 고려하여 범위, 위치 등 테스트 후 수정 예정
			SlimeTroops =
			{
				{ Index = "Emp_Slime2", x = 6845, y = 6550, radius = 500, count1 = 4, count2 = 9, count3 = 15, },
				{ Index = "Emp_Slime2", x = 6737, y = 5779, radius = 500, count1 = 4, count2 = 9, count3 = 15, },
				{ Index = "Emp_Slime2", x = 6620, y = 6121, radius = 500, count1 = 4, count2 = 9, count3 = 15, },
			},

			FireSlimeTroops =
			{
				-- 블럭 상황 고려하여 범위, 위치 등 테스트 후 수정 예정
				{ Index = "Emp_FireSlime2", x = 6845, y = 6550, radius = 500, count1 = 3, count2 = 5, count3 = 7, },
				{ Index = "Emp_FireSlime2", x = 6737, y = 5779, radius = 500, count1 = 3, count2 = 5, count3 = 7, },
				{ Index = "Emp_FireSlime2", x = 6620, y = 6121, radius = 500, count1 = 3, count2 = 5, count3 = 7, },
			},

			IronSlimeTroops =
			{
				-- 블럭 상황 고려하여 범위, 위치 등 테스트 후 수정 예정
				{ Index = "Emp_IronSlime2", x = 6845, y = 6550, radius = 500, count1 = 2, count2 = 3, count3 = 5, },
				{ Index = "Emp_IronSlime2", x = 6737, y = 5779, radius = 500, count1 = 2, count2 = 3, count3 = 5, },
				{ Index = "Emp_IronSlime2", x = 6620, y = 6121, radius = 500, count1 = 2, count2 = 3, count3 = 5, },
			},

			TwinQueenSlimes =
			{
				-- 블럭 상황 고려하여 범위, 위치 등 테스트 후 수정 예정
				{ Index = "Emp_QueenSlime2", x = nil, y = nil, radius = 200, count1 = 2, count2 = 2, count3 = 2, },
			},
		},
	},

	NPC =
	{
		NPC_Guard = { Index = "EldSpeGuard01", x = 2099, y = 10440, dir = 180 },
	},

	Stuff =
	{
		Door1 =	{ Index = "KQ_SlimeGate", x = 10060, y = 6094, dir = 272, 	Block = "CloseGate01", scale = 1000 }, -- 1층 과 2층 사이
		Door2 =	{ Index = "KQ_SlimeGate", x = 6692, y = 3944, dir = 6, 		Block = "CloseGate02", scale = 1000 }, -- 2층 과 3층 사이
		Door3 =	{ Index = "KQ_SlimeGate", x = 5894, y = 6098, dir = 88, 	Block = "CloseGate03", scale = 1000 }, -- 3층 과 4층 사이
	},
}
