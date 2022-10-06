--------------------------------------------------------------------------------
--                                 Seiren Castle Regen Data                                       --
--------------------------------------------------------------------------------

RegenInfo =
{
	Mob =
	{
		-- ÀÔÀå½Ã ¹Ù·Î ¸®Á¨µÉ ¸÷ Á¤º¸
		InitDungeon =
		{
			NormalMobGroup = { "ID_DragonNomal01","ID_DragonNomal02","ID_DragonNomal03","ID_DragonNomal04",
								"ID_DragonNomal05","ID_DragonNomal06","ID_DragonNomal07","ID_DragonNomal08",
								"ID_DragonNomal09","ID_DragonNomal10","ID_DragonNomal11","ID_DragonNomal12",
								"ID_DragonNomal13","ID_DragonNomal14","ID_DragonNomal15","ID_DragonNomal16",
								"ID_DragonNomal17","ID_DragonNomal18","ID_DragonNomal19","ID_DragonNomal20",

								"ID_Dragon01","ID_Dragon02","ID_Dragon03","ID_Dragon04",
								"ID_Dragon06","ID_Dragon07","ID_Dragon08","ID_Dragon09",
								"ID_Dragon11","ID_Dragon12","ID_Dragon13",
								"ID_Dragon15","ID_Dragon16","ID_Dragon17","ID_Dragon18","ID_Dragon19",
								"ID_Dragon21","ID_Dragon22","ID_Dragon23",
								"ID_Dragon25","ID_Dragon26","ID_Dragon27","ID_Dragon28","ID_Dragon29","ID_Dragon30",
								"ID_Dragon31","ID_Dragon32","ID_Dragon33","ID_Dragon34",
								"ID_Dragon36","ID_Dragon37",
								"ID_Dragon42","ID_Dragon43","ID_Dragon44","ID_Dragon45",
								"ID_Dragon48","ID_Dragon49","ID_Dragon50",

								"ID_PresentBox01","ID_PresentBox02","ID_PresentBox03","ID_PresentBox04","ID_PresentBox05",

								"ID_MINE01",
			},
		},

		-- Door1 ¿ÀÇÂ½Ã, ¸®Á¨µÉ ¸÷ Á¤º¸
		Door1 =
		{
			NormalMobGroup = { "ID_Dragon24", "ID_Dragon41", },

			Boss =
			{
				{ Index = "ID_GiantMagmaton", x = 5034, y = 10483, dir = 0, },
			},
		},

		-- Door2 ¿ÀÇÂ½Ã, ¸®Á¨µÉ ¸÷ Á¤º¸
		Door2 =
		{
			NormalMobGroup = { "ID_Dragon14", "ID_Dragon35", },

			Boss =
			{
				{ Index = "ID_BigMudMan", x = 8321, y = 9168, dir = 0, },
			},
		},

		-- Door3 ¿ÀÇÂ½Ã, ¸®Á¨µÉ ¸÷ Á¤º¸
		Door3 =
		{
			NormalMobGroup = { "ID_Dragon05", "ID_Dragon38", },

			Boss =
			{
				{ Index = "ID_FireTaitan", x = 3858, y = 3017, dir = 0, },
			},
		},

		-- Door4 ¿ÀÇÂ½Ã, ¸®Á¨µÉ ¸÷ Á¤º¸
		Door4 =
		{
			NormalMobGroup = { "ID_Dragon20", "ID_Dragon39", "ID_Dragon46", },

			Boss =
			{
				{ Index = "ID_Weasel", x = 6900, y = 2021, dir = 0, },
			},
		},

		-- BossDoor ¿ÀÇÂ½Ã, ¸®Á¨µÉ ¸÷ Á¤º¸
		DoorBoss =
		{
			NormalMobGroup = { "ID_Dragon10", "ID_Dragon40", "ID_Dragon47", },

			Boss =
			{
				{ Index = "ID_FandomCornelius", x = 11363, y = 4241, dir = 0, },
			},
		},
	},


	Stuff =
	{
		Door =
		{
			{ Name = "Door1_1", 	Index = "DBossDoor01", 		x = 4368,	y = 10143,	dir = 5,	scale = 2500, },
			{ Name = "Door1_2", 	Index = "DBossDoor01_1", 	x = 5690,	y = 10122,	dir = 0,	scale = 2500, },
			{ Name = "Door2", 		Index = "DBossDoor02", 		x = 7861,	y = 9793,	dir = 60,	scale = 2800, },
			{ Name = "Door3", 		Index = "DBossDoor03", 		x = 4102,	y = 2251,	dir = 72,	scale = 2800, },
			{ Name = "Door4_1", 	Index = "DBossDoor04", 		x = 6262,	y = 1810,	dir = 345,	scale = 2500, },
			{ Name = "Door4_2", 	Index = "DBossDoor04_1", 	x = 7411,	y = 2383,	dir = 338,	scale = 2500, },
			{ Name = "DoorBoss", 	Index = "DBossDoor00", 		x = 10589,	y = 5269,	dir = 338,	scale = 2500, },
		},

		StartExitGate = { Index = "IDMapLinkGate02",	x = 626,	y = 5783,	dir = 270,	scale = 1000 }, -- ½ÃÀÛÁöÁ¡¿¡¼­ ³ª°¡´Â ¹®
		EndExitGate   = { Index = "C_Gate01",			x = 11564,	y = 3804,	dir = 151,	scale = 1000 },	-- Å¬¸®¾î ÀÌÈÄ ³ª°¡´Â ¹®
	},
}
