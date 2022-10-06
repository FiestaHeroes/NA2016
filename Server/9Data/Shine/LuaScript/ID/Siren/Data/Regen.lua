--------------------------------------------------------------------------------
--                                 Seiren Castle Regen Data                                       --
--------------------------------------------------------------------------------

RegenInfo =
{
	Mob =
	{
		-- 입구 경비 구역
		EntranceGuardArea =
		{
			NormalMobGroup = { "S_01_CW_01", "S_01_CW_02", "S_01_CW_03", "S_01_CW_04", "S_01_CW_05",
							   "S_01_SW_01", "S_01_SW_02", "S_01_SW_03", },

			Boss =
			{
				{ Index = "S_Varamus", x = 3068, y = 10098, dir = 0, },
			},
		},

		-- 중앙 경비 구역
		CenterGuardArea =
		{
			NormalMobGroup = { "S_02_CW_01", "S_02_CW_02", "S_02_CW_03", "S_02_CW_04",
							   "S_02_SW_01", "S_02_SW_02", "S_02_SW_03", },

			Boss =
			{
				{ Index = "S_CyrusKey", x = 7527, y = 10523, dir = 0, },
			},
		},

		-- 동쪽 구역
		EastArea =
		{
			NormalMobGroup = { "S_03_CW_01", "S_03_CW_02",
							   "S_03_SW_01", "S_03_SW_02", "S_03_SW_03", "S_03_SW_04", },

			Boss =
			{
				{ Index = "S_Anais", x = 9205, y = 11613, dir = 0, },
			},
		},

		-- 서쪽 구역
		WestArea =
		{
			NormalMobGroup = { "S_04_CW_01", "S_04_CW_02", "S_04_CW_03", "S_04_CW_04", "S_04_CW_05",
							   "S_04_SW_01", "S_04_SW_02", "S_04_SW_03", "S_04_SW_04", "S_04_SW_05", },

			Boss =
			{
				{ Index = "S_Anika", x = 7206, y = 8613, dir = 0, },
				{ Index = "S_Tamyu", x = 4870, y = 8709, dir = 0, },
			},
		},

		-- 무너진 중앙홀
		FallenCenterHall =
		{
			NormalMobGroup = { "S_05_CW_01", "S_05_CW_02", "S_05_CW_03",
							   "S_05_SW_01", "S_05_SW_02", "S_05_SW_03",
							   "S_05_CT_01", "S_05_CT_02", "S_05_CT_03", "S_05_CT_04", "S_05_CT_05",
							   "S_05_CT_06", "S_05_CT_07", "S_05_CT_08", "S_05_CT_09", "S_05_CT_10",
							   "S_05_CT_11", "S_05_CT_12", "S_05_CT_13",
							   "S_05_ST_01", "S_05_ST_02", "S_05_ST_03", "S_05_ST_04", "S_05_ST_05",
							   "S_05_ST_06", "S_05_ST_07", "S_05_ST_08", "S_05_ST_09", "S_05_ST_10", },

			Boss =
			{
				{ Index = "S_Hayreddin", x = 11465, y = 7725, dir = 0, },
			},
		},

		-- 수호자의 제단
		GuardianAltar =
		{
			NormalMobGroup = {},

			Boss =
			{
				{ Index = "S_HayreddinEvo", x = 7245, y = 6351, dir = 0, },
			},
		},

		-- 심연의 홀
		AbyssHall =
		{
			NormalMobGroup = { },

			Boss =
			{
				{ Index = "S_Freloan", x = 2896, y = 3763, dir = 0, },
			},
		},
	},

	NPC =
	{
		"Chaoming",
	},

	Stuff =
	{
		Door =
		{
			{ Name = "Door1", Index = "S_Door", x = 4091,	y = 10376,	dir = 75,	scale = 1000, },
			{ Name = "Door2", Index = "S_Door", x = 7938,	y = 11087,	dir = 30,	scale = 1000, },
			{ Name = "Door3", Index = "S_Door", x = 8105,	y = 10117,	dir = 120,	scale = 1000, },
--			{ Name = "Door4", Index = "S_Door", x = 7132,	y = 9941,	dir = -120,	scale = 1000, },
			{ Name = "Door4", Index = "S_Door", x = 7132,	y = 9941,	dir = 220,	scale = 1000, },
			{ Name = "Door5", Index = "S_Door", x = 10238,	y = 11933,	dir = 72,	scale = 1000, },
			{ Name = "Door6", Index = "S_Door", x = 10012,	y = 10902,	dir = 135,	scale = 1000, },
			{ Name = "Door7", Index = "S_Door", x = 8165,	y = 8157,	dir = 115,	scale = 1000, },
--			{ Name = "Door8", Index = "S_Door", x = 10900,	y = 6867,	dir = -135,	scale = 1000, },
			{ Name = "Door8", Index = "S_Door", x = 10900,	y = 6867,	dir = 215,	scale = 1000, },
		},


		Portal1 = { Name = "Portal1", Index = "S_Portal",	x = 4577,	y = 8585,	dir = 60,	scale = 1000 },
		Portal2 = { Name = "Portal2", Index = "S_Portal",	x = 11497,	y = 11830,	dir = 135,	scale = 1000 },
		Portal3 = { Name = "Portal3", Index = "S_Portal",	x = 6407,	y = 5534,	dir = 55,	scale = 1000 },


		StartExitGate = { Index = "S_GateOut",	x = 378,	y = 10820,	dir = 100,	scale = 1000 }, -- 시작지점에서 나가는 문
		EndExitGate   = { Index = "S_GateOut",	x = 3289,	y = 3697,	dir = 0,	scale = 1000 },	-- 클리어 이후 나가는 문
	},
}
