--------------------------------------------------------------------------------
--                     Legend Of Bijou Regen Data                             --
--------------------------------------------------------------------------------

RegenInfo =
{
	Group =
	{
		GardenSquare =
		{
			"Regen00",	"Regen01",	"Regen02",	"Regen03",	"Regen04",
			"Regen05",	"Regen06",	"Regen07",	"Regen08",	"Regen09",
			"Regen100",
		},

		EndOfLegend =
		{
			"Regen10",	"Regen11",	"Regen12",	"Regen13",	"Regen14",
			"Regen15",	"Regen16",	"Regen17",	"Regen101",
		},
	},

	Mob =
	{
		FirstGateAndWall =
		{
			-- 첫번째 카마리스
			FirstKamaris 		= { Index = "KQ_Kamaris", x = 6122, y = 1850, dir = 0, TeleportCoord = { x = 6179, y = 3026 } },

			-- 첫번째 문의 몹형태
			FirstMobGate 		= { Index = "KQ_VGate01", x = 6118, y = 3335, dir = 180 },

			-- 첫번째 문위에서 성벽을 방어하는 궁수
			WallDefenders =
			{
				-- 아래 인덱스 중 랜덤으로 선택
				IndexList =
				{
					"KQ_SK_SkelArcher1",
					"KQ_SK_SkelArcher2",
					"KQ_SK_SkelArcher3",
				},

				-- 해당 좌표당 한마리씩 배치
				CoordList =
				{
					{ x = 5767, y = 3246 },	{ x = 5746, y = 3225 },	{ x = 5721, y = 3187 },	{ x = 5699, y = 3165 },	{ x = 5672, y = 3143 },
					{ x = 5660, y = 3106 },	{ x = 5639, y = 3066 },	{ x = 5618, y = 3029 },	{ x = 5604, y = 2988 },	{ x = 5599, y = 2928 },
					{ x = 5600, y = 2873 },	{ x = 5592, y = 2828 },	{ x = 5600, y = 2787 },	{ x = 6442, y = 3276 },	{ x = 6468, y = 3258 },
					{ x = 6491, y = 3236 },	{ x = 6519, y = 3201 },	{ x = 6555, y = 3166 },	{ x = 6583, y = 3137 },
				},

				SameDirect = 0,

				-- 성벽위 해골 궁수들을 움직이지 않게 하기 위함
				AbstateAlways = { Index = "StaQuestEntangle2", Strength = 1, KeepTime = 4200000000 },
			},

			-- 첫번째 문 뒤에서 대기하고 있는 돌격대로 문이 열리자마자 움직일 수 있게 됨
			Chargers =
			{
				Index = "KQ_SK_Dash",

				-- 좌표는 x = 5915, y = 4086 을 기점으로 x방향, y방향으로 127 만큼씩 총 0~4번 더해져서 25마리가 젠 됨
				{ x = 5915, y = 4086 },	{ x = 5915, y = 4213 },	{ x = 5915, y = 4340 },	{ x = 5915, y = 4467 },	{ x = 5915, y = 4594 },
				{ x = 6042, y = 4086 },	{ x = 6042, y = 4213 },	{ x = 6042, y = 4340 },	{ x = 6042, y = 4467 },	{ x = 6042, y = 4594 },
				{ x = 6169, y = 4086 },	{ x = 6169, y = 4213 },	{ x = 6169, y = 4340 },	{ x = 6169, y = 4467 },	{ x = 6169, y = 4594 },
				{ x = 6296, y = 4086 },	{ x = 6296, y = 4213 },	{ x = 6296, y = 4340 },	{ x = 6296, y = 4467 },	{ x = 6296, y = 4594 },
				{ x = 6423, y = 4086 },	{ x = 6423, y = 4213 },	{ x = 6423, y = 4340 },	{ x = 6423, y = 4467 },	{ x = 6423, y = 4594 },

				SameDirect = 0,

				AbstateBeforeOpening1stGate = { Index = "StaQuestEntangle", Strength = 1, KeepTime = 4200000000 },
			},
		},

		GardenSquare =
		{
			-- 사각 정원에서의 5 카마리스 - 스켈레톤을 소환함
			Kamaris =
			{
				Index = "KQ_Kamaris2",

				CoordList =
				{
					{ x = 5190, y = 3894 },
					{ x = 5190, y = 5530 },
					{ x = 7205, y = 5530 },
					{ x = 7030, y = 3983 },
					{ x = 6107, y = 5234 },
				},

				SameDirect = 0,
			},

			-- 두번째 문의 몹형태
			SecondMobGate = { Index = "KQ_VGate02", x = 6124, y = 6822, dir = 0 },
		},


		FinalGate =
		{
			-- 어둠의 비쥬(카마리스) 두개 젠
			BijouOfDarknesss =
			{
				Index = "KQ_Kamaris",

				CoordList =
				{
					{ x = 5889, y = 8485  },
					{ x = 6340, y = 8485  },
				},

				SameDirect = 0,
			},

			-- 세번째 문의 몹형태
			ThirdMobGate = { Index = "KQ_VGate01", x = 6116, y = 8691, dir = 180 },

			-- 세번째 문 뒤에서 대기하고 있는 돌격대로 문이 열리자마자 움직일 수 있게 됨
			Chargers =
			{
				Index = "KQ_SK_Dash",

				-- 좌표는 x = 5915, y = 9000 을 기점으로 x방향, y방향으로 127 만큼씩 총 0~4번 더해져서 25마리가 젠 됨
				{ x = 5915, y = 9000 },	{ x = 5915, y = 9127 },	{ x = 5915, y = 9254 },	{ x = 5915, y = 9381 },	{ x = 5915, y = 9508 },
				{ x = 6042, y = 9000 },	{ x = 6042, y = 9127 },	{ x = 6042, y = 9254 },	{ x = 6042, y = 9381 },	{ x = 6042, y = 9508 },
				{ x = 6169, y = 9000 },	{ x = 6169, y = 9127 },	{ x = 6169, y = 9254 },	{ x = 6169, y = 9381 },	{ x = 6169, y = 9508 },
				{ x = 6296, y = 9000 },	{ x = 6296, y = 9127 },	{ x = 6296, y = 9254 },	{ x = 6296, y = 9381 },	{ x = 6296, y = 9508 },
				{ x = 6423, y = 9000 },	{ x = 6423, y = 9127 },	{ x = 6423, y = 9254 },	{ x = 6423, y = 9381 },	{ x = 6423, y = 9508 },

				SameDirect = 0,

				AbstateBeforeOpening2stGate = { Index = "StaQuestEntangle", Strength = 1, KeepTime = 4200000000 },
			},
		},

		EndOfLegend =
		{
			-- 보스 에서의 4 카마리스 - 스켈레톤을 소환함
			Kamaris =
			{
				Index = "KQ_Kamaris3",

				CoordList =
				{
					{ x = 4892, y =  9297 },
					{ x = 4892, y = 11097 },
					{ x = 7522, y =  9270 },
					{ x = 7522, y = 11097 },
				},

				SameDirect = 0,
			},

			-- 보스 칼반오벳
			KalBanObet = { Index = "KQ_KalBanObeb", x = 6081, y = 10506, dir = 0 },
		},

	},

	NPC =
	{
	},

	Stuff =
	{
		-- 몹의 위치와 겹치지 않게 하기 위하여 x좌표를 100씩 작게 만들었다.(겹치면 보이는 문의 위치가 옆으로 밀림)
		FirstGate 	= { Index = "OX_gate", x = 6018, y = 3335, dir = 0, Block = "DoorBlock01", scale = 1000 },
		SecondGate 	= { Index = "OX_gate", x = 6024, y = 6822, dir = 0, Block = "DoorBlock02", scale = 1000 },
		ThirdGate 	= { Index = "OX_gate", x = 6016, y = 8691, dir = 0, Block = "DoorBlock03", scale = 1000 },
	},
}
