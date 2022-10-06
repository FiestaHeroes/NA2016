--------------------------------------------------------------
--※ 리젠 몹 정보
--------------------------------------------------------------
RegenInfo =
{
	Mob =
	{
		InitDungeon =
		{
			NormalMobGroup =
			{
				"Leviathan001",
				"Leviathan002",
				"Leviathan003",
				"Leviathan004",
				"Leviathan005",
				"Leviathan006",
				"Leviathan007",
				"Leviathan008",
				"Leviathan009",
				"Leviathan010",

				"Leviathan011",
				"Leviathan012",
				"Leviathan013",
				"Leviathan014",
				"Leviathan015",
				"Leviathan016",
				"Leviathan017",
				"Leviathan018",
				"Leviathan019",
				"Leviathan020",

				"Leviathan021",
				"Leviathan022",
				"Leviathan023",
				"Leviathan024",
				"Leviathan025",
				"Leviathan026",
				"Leviathan027",
				"Leviathan028",
				"Leviathan029",
				"Leviathan030",

				"Leviathan031",
				"Leviathan032",
				"Leviathan033",
				"Leviathan034",
				--""Leviathan035",	-- 레비아탄이 소환하는 알, 루아에서는 몹인덱스로 바로 리젠하므로 MobRegen 인덱스는 사용안함
				--""Leviathan036",	-- 레비아탄이 소환하는 알, 루아에서는 몹인덱스로 바로 리젠하므로 MobRegen 인덱스는 사용안함
				--""Leviathan037",	-- 레비아탄이 소환하는 알, 루아에서는 몹인덱스로 바로 리젠하므로 MobRegen 인덱스는 사용안함
				"Leviathan038",
				"Leviathan039",
				"Leviathan040",

				"Leviathan041",
				"Leviathan042",
				"Leviathan043",
				"Leviathan044",
				"Leviathan045",
				"Leviathan046",
				"Leviathan047",
				"Leviathan048",
				"Leviathan049",
				"Leviathan050",

				"Leviathan051",
				"Leviathan052",
				"Leviathan053",
				"Leviathan054",
				"Leviathan055",
				"Leviathan056",
				"Leviathan057",
				"Leviathan058",
				"Leviathan059",
				"Leviathan060",

				"Leviathan061",
				"Leviathan062",
				"Leviathan063",
				"Leviathan064",
				"Leviathan065",
				"Leviathan066",
				"Leviathan067",
				"Leviathan068",
				"Leviathan069",
				"Leviathan070",

				"Leviathan071",
				"Leviathan072",
				"Leviathan073",
				"Leviathan074",
			},
		},


		KingBoogyStep =
		{
			Boss =
			{
				Index = "KingBoogy", x = 819, y = 2864, dir = 0,
			},
		},


		KingCrabStep =
		{
			Boss =
			{
				Index = "EmperorCrab", x = 5487, y = 1959, dir = 0,
			},
		},


		LeviathanStep =
		{
			BossMain =
			{
				Index = "ViciousLeviathan", 	x = 2948, y = 2743, dir = 0,
			},

			BossHead =
			{
				Index = "ViciousLeviathan01", 	x = 2948, y = 2743, dir = 90,
			}
		},
	},

	Stuff =
	{
		Door =
		{
			-- KingBoogy 죽이면 열리는 문
			GoToKingCrab =
			{
				Index 		= "Levi_Door",
				DoorBlock 	= "Door01",
				x = 816, y = 2562, dir = -180, scale = 195,
			},

			-- KingCrab 죽이면 열리는 문
			GoToLeviathan =
			{
				Index 		= "Levi_Door",
				DoorBlock 	= "Door02",
				x = 5659, y = 2157, dir = 44, scale = 195,
			},

		},

		-- 레비아탄 죽이면 드랍할 보상상자
		RewardBox =
		{
			Index = "LeviathanEggBox", 	x = 2443, 	y = 2662, 	dir = 0,
		},

		-- 입구 쪽 출구게이트
		StartExitGate =
			{ Index = "IDMapLinkGate02",	x = 3019,	y = 5573,	dir = 0,	scale = 1000 }, -- 시작지점에서 나가는 문

		-- 출구 쪽 출구게이트
		EndExitGate =
			{ Index = "IDMapLinkGate02",	x = 2253,	y = 2627,	dir = 270,	scale = 1000 },	-- 클리어 이후 나가는 문

	},
}
