--------------------------------------------------------------------------------
--                   Secret Laboratory Regen Data                             --
--------------------------------------------------------------------------------

RegenInfo =
{
	-- �� ���� �߽� ��ǥ
	Coord =
	{
		{ x = 10719, y = 9805 },
		{ x = 11727, y = 7553 },
		{ x = 11007, y = 5298 },
		{ x = 10244, y = 3139 },
		{ x = 9288,  y = 956  },
		{ x = 6798,  y = 952  },
		{ x = 4330,  y = 1207 },
		{ x = 2102,  y = 2477 },
		{ x = 1192,  y = 4492 },
		{ x = 1186,  y = 7321 },
	},

	-- ������ ���� ���� ������ �� �ֵ��� �س����� �������� �����ʹ� ������ �����Ǿ� �����Ƿ�, ������ ������� �����ؼ��� �ȵȴ�.
	-- cGroupRegenInstance( stringMapIndex, stringGroupIndex )
	Group =
	{
		-- �� �� ����
		EachPattern =
		{
			-- 1, 6, 7
			Pattern_KillAll =
			{
				{ "RGN_T3_02_02", "RGN_T3_02_03", "RGN_T3_02_04", "RGN_T3_02_05", "RGN_T3_02_06", },
				{ "RGN_T3_07_02", "RGN_T3_07_03", "RGN_T3_07_04", "RGN_T3_07_05", "RGN_T3_07_06", "RGN_T3_07_07", },
				{ "RGN_T3_08_02", "RGN_T3_08_03", "RGN_T3_08_04", "RGN_T3_08_05", "RGN_T3_08_06", "RGN_T3_08_07", "RGN_T3_08_08", },
			},

			-- 2, 3, 4, 8, 9
			Pattern_TimeAttack =
			{
				{ "RGN_T3_03_02", "RGN_T3_03_03", "RGN_T3_03_04", "RGN_T3_03_05", "RGN_T3_03_06", "RGN_T3_03_07", "RGN_T3_03_08", },
				{ "RGN_T3_04_02", "RGN_T3_04_05", "RGN_T3_04_06", "RGN_T3_04_07", "RGN_T3_04_08", "RGN_T3_04_09", "RGN_T3_04_10", "RGN_T3_04_11", "RGN_T3_04_12", "RGN_T3_04_13", "RGN_T3_04_14", },
				{ "RGN_T3_05_04", "RGN_T3_05_05", "RGN_T3_05_06", "RGN_T3_05_07", "RGN_T3_05_08", "RGN_T3_05_09", "RGN_T3_05_10", "RGN_T3_05_11", "RGN_T3_05_12", },
				{ "RGN_T3_09_02", "RGN_T3_09_03", "RGN_T3_09_06", "RGN_T3_09_07", "RGN_T3_09_08", "RGN_T3_09_09", "RGN_T3_09_10", "RGN_T3_09_11", "RGN_T3_09_12", "RGN_T3_09_13", },
				{ "RGN_T3_10_02", "RGN_T3_10_05", "RGN_T3_10_07", "RGN_T3_10_08", "RGN_T3_10_09", "RGN_T3_10_10", "RGN_T3_10_11", "RGN_T3_10_12", "RGN_T3_10_13", "RGN_T3_10_14","RGN_T3_10_15", "RGN_T3_10_17", "RGN_T3_10_18", },
			},

			-- 5, 10
			Pattern_KillBoss =
			{
				{ "RGN_T3_06_02", "RGN_T3_06_05", },
				{ "RGN_T3_11_02", "RGN_T3_11_04", },
			},
		},
	},

	Mob =
	{
		-- Ư�� ����
		EachPattern =
		{
			Pattern_KillAll =
			{
				{},
				{},
				{},
			},

			Pattern_TimeAttack =
			{
				{ SemiBoss = { Index = "Lab_Slime", x = nil, y = nil, dir = 0, },	},
				{ SemiBoss = { Index = "Lab_19", 	x = nil, y = nil, dir = 0, },	},
				{ SemiBoss = { Index = "Lab_19", 	x = nil, y = nil, dir = 0, },	},
				{ SemiBoss = { Index = "Lab_23",	x = nil, y = nil, dir = 0, },	},
				{ SemiBoss = { Index = "Lab_23", 	x = nil, y = nil, dir = 0, },	},
			},

			Pattern_KillBoss =
			{
				{ MidBoss = { Index = "Lab_20", 	x = nil, y = nil, dir = 0, },	},
				{ Boss    = { Index = "Lab_25", 	x = nil, y = nil, dir = 0, },	},
			},
		},

		-- �ش� ���� �ڽ��� �� �Ѹ����� SemiBoss�� ����� �ʰ� �Ͽ� Ŭ���� �� �־�����.
		RescuedChildren =
		{
			SpecialRewardBox = { Index = "Lab_Box", x = 1186,  y = 7321, dir = 0, }
		},
	},

	NPC =
	{
		EachPattern =
		{
			Pattern_KillAll 	= {},
			Pattern_TimeAttack 	= {},
			Pattern_KillBoss 	= {},
		},

		RescuedChildren =
		{
			Lab_Child_Melt 		= { Index = "Lab_Child_Melt",     x = 1321, y = 7676, dir = 0, },
			Lab_Child_Balus 	= { Index = "Lab_Child_Balus",    x = 1341, y = 7631, dir = 0, },
			Lab_Child_Chechale 	= { Index = "Lab_Child_Chechale", x = 1389, y = 7627, dir = 0, },
			Lab_Child_Fred 		= { Index = "Lab_Child_Fred",     x = 1368, y = 7658, dir = 0, },
		},
	},

	Stuff =
	{
		-- �� ���� �� ����
		Door0	= { Index = "Lab_Gate",   x = 9175,  y = 11012, dir = 0, Block = "DBLOCK01",  scale = 1000 },	-- ������������ ���� �ִ� ��
		Door1	= { Index = "Lab_Gate",   x = 11097, y = 9428,  dir = 0, Block = "DBLOCK02",  scale = 1000 },	-- 1���� 2�� ����
		Door2	= { Index = "Lab_Gate",   x = 11732, y = 7187,  dir = 0, Block = "DBLOCK03",  scale = 1000 },	-- 2���� 3�� ����
		Door3	= { Index = "Lab_Gate",   x = 10793, y = 5009,  dir = 0, Block = "DBLOCK04",  scale = 1000 },	-- 3���� 4�� ����
		Door4	= { Index = "Lab_Gate",   x = 10230, y = 2643,  dir = 0, Block = "DBLOCK05",  scale = 1000 },	-- 4���� 5�� ����
		Door5	= { Index = "Lab_Gate",   x = 8772,  y = 952,   dir = 0, Block = "DBLOCK06",  scale = 1000 },	-- 5���� 6�� ����
		Door6	= { Index = "Lab_Gate",   x = 6296,  y = 951,   dir = 0, Block = "DBLOCK07",  scale = 1000 },	-- 6���� 7�� ����
		Door7	= { Index = "Lab_Gate",   x = 3876,  y = 1354,  dir = 0, Block = "DBLOCK08",  scale = 1000 },	-- 7���� 8�� ����
		Door8	= { Index = "Lab_Gate",   x = 1844,  y = 2714,  dir = 0, Block = "DBLOCK09",  scale = 1000 },	-- 8���� 9�� ����
		Door9	= { Index = "Lab_Gate",   x = 1179,  y = 4985,  dir = 0, Block = "DBLOCK10",  scale = 1000 },	-- 9���� 10�� ����

		-- ���̵��� ���� ����
		Prison	= { Index = "Lab_Prison", x = 1368,  y = 7658,  dir = 0, Block = "DBLOCK11",  scale = 1000 },	-- 9���� 10�� ����

		-- ��ũ ����Ʈ
		StartExitGate = { Index = "Lab_Gate", x = 8455,  y = 11431, dir = 0, scale = 1000 },	-- ������������ ������ ��
		EndExitGate   = { Index = "Lab_Gate", x = 1178,  y = 7727,  dir = 0, scale = 1000 },	-- Ŭ���� ���� ������ ��
	},
}
