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
				"Leviathan_H001",
				"Leviathan_H002",
				"Leviathan_H003",
				"Leviathan_H004",
				"Leviathan_H005",
				"Leviathan_H006",
				"Leviathan_H007",
				"Leviathan_H008",
				"Leviathan_H009",
				"Leviathan_H010",

				"Leviathan_H011",
				"Leviathan_H012",
				"Leviathan_H013",
				"Leviathan_H014",
				"Leviathan_H015",
				"Leviathan_H016",
				"Leviathan_H017",
				"Leviathan_H018",
				"Leviathan_H019",
				"Leviathan_H020",

				"Leviathan_H021",
				"Leviathan_H022",
				"Leviathan_H023",
				"Leviathan_H024",
				"Leviathan_H025",
				"Leviathan_H026",
				"Leviathan_H027",
				"Leviathan_H028",
				"Leviathan_H029",
				"Leviathan_H030",

				"Leviathan_H031",
				"Leviathan_H032",
				"Leviathan_H033",
				"Leviathan_H034",
				--""Leviathan_H035",	-- 레비아탄이 소환하는 알, 루아에서는 몹인덱스로 바로 리젠하므로 MobRegen 인덱스는 사용안함
				--""Leviathan_H036",	-- 레비아탄이 소환하는 알, 루아에서는 몹인덱스로 바로 리젠하므로 MobRegen 인덱스는 사용안함
				--""Leviathan_H037",	-- 레비아탄이 소환하는 알, 루아에서는 몹인덱스로 바로 리젠하므로 MobRegen 인덱스는 사용안함
				"Leviathan_H038",
				"Leviathan_H039",
				"Leviathan_H040",

				"Leviathan_H041",
				"Leviathan_H042",
				"Leviathan_H043",
				"Leviathan_H044",
				"Leviathan_H045",
				"Leviathan_H046",
				"Leviathan_H047",
				"Leviathan_H048",
				"Leviathan_H049",
				"Leviathan_H050",

				"Leviathan_H051",
				"Leviathan_H052",
				"Leviathan_H053",
				"Leviathan_H054",
				"Leviathan_H055",
				"Leviathan_H056",
				"Leviathan_H057",
				"Leviathan_H058",
				"Leviathan_H059",
				"Leviathan_H060",

				"Leviathan_H061",
				"Leviathan_H062",
				"Leviathan_H063",
				"Leviathan_H064",
				"Leviathan_H065",
				"Leviathan_H066",
				"Leviathan_H067",
				"Leviathan_H068",
				"Leviathan_H069",
				"Leviathan_H070",

				"Leviathan_H071",
				"Leviathan_H072",
				"Leviathan_H073",
				"Leviathan_H074",
			},
		},


		KingBoogyStep =
		{
			Boss =
			{
				Index = "LevH_KingBoogy", x = 819, y = 2864, dir = 0,
			},
		},


		KingCrabStep =
		{
			Boss =
			{
				Index = "LevH_EmperorCrab", x = 5487, y = 1959, dir = 0,
			},
		},


		LeviathanStep =
		{
			BossMain =
			{
				Index = "LevH_ViciousLeviathan", 	x = 2948, y = 2743, dir = 0,
			},

			BossHead =
			{
				Index = "LevH_ViciousLeviathan01", 	x = 2948, y = 2743, dir = 90,
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
			Index = "LevH_LeviathanEggBox", 	x = 2443, 	y = 2662, 	dir = 0,
		},

		-- 입구 쪽 출구게이트
		StartExitGate =
			{ Index = "IDMapLinkGate02",	x = 3019,	y = 5573,	dir = 0,	scale = 1000 }, -- 시작지점에서 나가는 문

		-- 출구 쪽 출구게이트
		EndExitGate =
			{ Index = "IDMapLinkGate02",	x = 2253,	y = 2627,	dir = 270,	scale = 1000 },	-- 클리어 이후 나가는 문

	},
}
