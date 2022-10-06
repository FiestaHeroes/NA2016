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
			NormalMobGroup = { "IDH_DragonNomal01","IDH_DragonNomal02","IDH_DragonNomal03","IDH_DragonNomal04",
								"IDH_DragonNomal05","IDH_DragonNomal06","IDH_DragonNomal07","IDH_DragonNomal08",
								"IDH_DragonNomal09","IDH_DragonNomal10","IDH_DragonNomal11","IDH_DragonNomal12",
								"IDH_DragonNomal13","IDH_DragonNomal14","IDH_DragonNomal15","IDH_DragonNomal16",
								"IDH_DragonNomal17","IDH_DragonNomal18","IDH_DragonNomal19","IDH_DragonNomal20",

								"IDH_Dragon01","IDH_Dragon02","IDH_Dragon03","IDH_Dragon04",
								"IDH_Dragon06","IDH_Dragon07","IDH_Dragon08","IDH_Dragon09",
								"IDH_Dragon11","IDH_Dragon12","IDH_Dragon13",
								"IDH_Dragon15","IDH_Dragon16","IDH_Dragon17","IDH_Dragon18","IDH_Dragon19",
								"IDH_Dragon21","IDH_Dragon22","IDH_Dragon23",
								"IDH_Dragon25","IDH_Dragon26","IDH_Dragon27","IDH_Dragon28","IDH_Dragon29","IDH_Dragon30",
								"IDH_Dragon31","IDH_Dragon32","IDH_Dragon33","IDH_Dragon34",
								"IDH_Dragon36","IDH_Dragon37",
								"IDH_Dragon42","IDH_Dragon43","IDH_Dragon44","IDH_Dragon45",
								"IDH_Dragon48","IDH_Dragon49","IDH_Dragon50",

								"IDH_PresentBox01","IDH_PresentBox02","IDH_PresentBox03","IDH_PresentBox04","IDH_PresentBox05",

								"IDH_MINE01",
			},
		},

		-- Door1 ¿ÀÇÂ½Ã, ¸®Á¨µÉ ¸÷ Á¤º¸
		Door1 =
		{
			NormalMobGroup = { "IDH_Dragon24", "IDH_Dragon41", },

			Boss =
			{
				{ Index = "UrgDTH_ID_GiantMagmaton", x = 5034, y = 10483, dir = 0, },
			},
		},

		-- Door2 ¿ÀÇÂ½Ã, ¸®Á¨µÉ ¸÷ Á¤º¸
		Door2 =
		{
			NormalMobGroup = { "IDH_Dragon14", "IDH_Dragon35", },

			Boss =
			{
				{ Index = "UrgDTH_ID_BigMudMan", x = 8321, y = 9168, dir = 0, },
			},
		},

		-- Door3 ¿ÀÇÂ½Ã, ¸®Á¨µÉ ¸÷ Á¤º¸
		Door3 =
		{
			NormalMobGroup = { "IDH_Dragon05", "IDH_Dragon38", },

			Boss =
			{
				{ Index = "UrgDTH_ID_FireTaitan", x = 3858, y = 3017, dir = 0, },
			},
		},

		-- Door4 ¿ÀÇÂ½Ã, ¸®Á¨µÉ ¸÷ Á¤º¸
		Door4 =
		{
			NormalMobGroup = { "IDH_Dragon20", "IDH_Dragon39", "IDH_Dragon46", },

			Boss =
			{
				{ Index = "UrgDTH_ID_Weasel", x = 6900, y = 2021, dir = 0, },
			},
		},

		-- BossDoor ¿ÀÇÂ½Ã, ¸®Á¨µÉ ¸÷ Á¤º¸
		DoorBoss =
		{
			NormalMobGroup = { "IDH_Dragon10", "IDH_Dragon40", "IDH_Dragon47", },

			Boss =
			{
				{ Index = "UrgDTH_ID_FandomCornelius", x = 11363, y = 4241, dir = 0, },
			},
		},
	},


	Stuff =
	{
		Door =
		{
			{ Name = "Door1_1", 	Index = "UrgDTH_DBossDoor01", 		x = 4368,	y = 10143,	dir = 5,	scale = 2500, },
			{ Name = "Door1_2", 	Index = "UrgDTH_DBossDoor01_1", 	x = 5690,	y = 10122,	dir = 0,	scale = 2500, },
			{ Name = "Door2", 		Index = "UrgDTH_DBossDoor02", 		x = 7861,	y = 9793,	dir = 60,	scale = 2800, },
			{ Name = "Door3", 		Index = "UrgDTH_DBossDoor03", 		x = 4102,	y = 2251,	dir = 72,	scale = 2800, },
			{ Name = "Door4_1", 	Index = "UrgDTH_DBossDoor04", 		x = 6262,	y = 1810,	dir = 345,	scale = 2500, },
			{ Name = "Door4_2", 	Index = "UrgDTH_DBossDoor04_1", 	x = 7411,	y = 2383,	dir = 338,	scale = 2500, },
			{ Name = "DoorBoss", 	Index = "UrgDTH_DBossDoor00", 		x = 10589,	y = 5269,	dir = 338,	scale = 2500, },
		},

		StartExitGate = { Index = "IDMapLinkGate02",	x = 626,	y = 5783,	dir = 270,	scale = 1000 }, -- ½ÃÀÛÁöÁ¡¿¡¼­ ³ª°¡´Â ¹®
		EndExitGate   = { Index = "C_Gate01",			x = 11564,	y = 3804,	dir = 151,	scale = 1000 },	-- Å¬¸®¾î ÀÌÈÄ ³ª°¡´Â ¹®
	},
}
