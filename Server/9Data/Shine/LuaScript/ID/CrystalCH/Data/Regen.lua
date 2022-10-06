--------------------------------------------------------------------------------
--                      Crystal Castle Regen Data                             --
--------------------------------------------------------------------------------

RegenInfo =
{
	-- �� ���� �߽� ��ǥ
	Coord =
	{
		{ x = 1185,  y = 4460 },
		{ x = 2118,  y = 2454 },
		{ x = 4351,  y = 1244 },
		{ x = 6780,  y = 957  },
		{ x = 9228,  y = 983  },
		{ x = 10222, y = 3036 },
		{ x = 11019, y = 5312 },
		{ x = 11734, y = 7709 },
		{ x = 10723, y = 9788 },
	},

	-- cGroupRegenInstance_XY( stringMapIndex, stringGroupIndex, numberCenterX, numberCenterY )
	Group =
	{
		-- �� �� ����
		Pattern_KillAll =
		{
			-- 1,2,3,4,5,6,7,8,-,MR,17,18,AC,19,20,-,24,25,-,29,30,Hard,31,
			{ "RGNH_C1_1",  "RGNH_C1_2",  },
			{ "RGNH_C2_1",  "RGNH_C2_2",  },
			{ "RGNH_C3_1",  "RGNH_C3_2",  },
			{ "RGNH_C4_1",  "RGNH_C4_2",  },
			{ "RGNH_C5_1",  "RGNH_C5_2",  },
			{ "RGNH_C6_1",  "RGNH_C6_2",  },
			{ "RGNH_C7_1",  "RGNH_C7_2",  },
			{ "RGNH_C8_1",  "RGNH_C8_2",  },
			{ "RGNH_C17_1", "RGNH_C17_2", },	-- 17 : MR High
			{ "RGNH_C18_1", "RGNH_C18_2", },	-- 18 : MR High
			{ "RGNH_C19_1", "RGNH_C19_2", },	-- 19 : AC High
			{ "RGNH_C20_1", "RGNH_C20_2", },	-- 20 : AC High
			{ "RGNH_C24_1",              },
			{ "RGNH_C25_1", "RGNH_C25_2", },
			{ "RGNH_C29_1", "RGNH_C29_2", },
			{ "RGNH_C30_1", "RGNH_C30_2", },
			{ "RGNH_C31_1", "RGNH_C31_2",	"RGNH_C31_3", },	-- 31 : Marlone
		},

		Pattern_KillBoss =
		{
			-- 9,10,11,12,13,14,15,16,-,26,
			-- �ܸ� ���ٴ� ������ ��ƾ� ���� ����
			{ "RGNH_C9_1",	},
			{ "RGNH_C10_1",	},
			{ "RGNH_C11_1",	},
			{ "RGNH_C12_1",	},
			{ "RGNH_C13_1",	},
			{ "RGNH_C14_1",	},
			{ "RGNH_C15_1",	},
			{ "RGNH_C16_1",	},
			{ "RGNH_C26_1", "RGNH_C26_2",	},
		},


		-- �� ���ڸ� ���� ��Ÿ���� �� �׷�
		Pattern_OnlyOneIsKey =
		{
			-- 27,28,32
			-- Mob ���ڸ� ���� �׶����� ����� �� �׷�
			{ "RGNH_C27_3", },
			{ "RGNH_C28_3", },
			{ "RGNH_C35_4", },
		},

		-- �̰Ͱ� 33�� ����� ��� ����üũ�� ���� �ɵ�.
		-- ù��°�� ī������, �ι�°�� ī������ �׿��� �� ��Ÿ���� ����
		Pattern_KamarisTrap =
		{
			-- 21,22,23
			{ { "RGNH_C21_1", }, { "RGNH_C21_2", }, },
			{ { "RGNH_C22_1", }, { "RGNH_C22_2", }, },
			{ { "RGNH_C23_1", }, { "RGNH_C23_2", }, },
		},

--[[
		Pattern_TrapPrisonType =
		{
			-- 33 �� ���� : ���� PS Script���� ������ �Ǵ� �� �����̰� ���� ���� ������ ���� �����̹Ƿ� ��ƹ��������� ���� �ʴ´�.
			nil,
		},
--]]

		BossBattle =
		{
			-- Case : LizardMan Guardian
			{ "RGNH_C32_2", "RGNH_C32_3", },
			-- Case : Heavy Orc
			{ "RGNH_C33_2", "RGNH_C33_3", },
			-- Case : Jewel Golem
			{ "RGNH_C34_2", "RGNH_C34_3", },
		},


		IyzelReward =
		{
			-- Case : LizardMan Guardian
			{ "RGNH_C32_5",  "RGNH_C32_6", },
			-- Case : Heavy Orc
			{ "RGNH_C33_5",  "RGNH_C33_6", },
			-- Case : Jewel Golem
			{ "RGNH_C34_10", "RGNH_C34_11", },
		},
	},

	Mob =
	{
		Pattern_KillAll =
		{
			-- 1,2,3,4,5,6,7,8,-,MR,17,18,AC,19,20,-,24,25,-,29,30,Hard,31,
		},

		-- cMobRegen_Circle( MapIndex, MobIndex, CenterX, CenterY, Radius )
		Pattern_KillBoss =
		{
			-- 9,10,11,12,13,14,15,16,-,26,
			-- �̰����� �� �Ǵ� �������� ��ƾ� �ܸ��� �װ� ���� ����
			{ Boss = { Index = "CH_BigJewelKeeper", 		x = nil, y = nil, radius = 366, },	},
			{ Boss = { Index = "CH_BigDarkArchon", 		x = nil, y = nil, radius = 366, },	},
			{ Boss = { Index = "CH_BigDarkLips", 		x = nil, y = nil, radius = 366, },	},
			{ Boss = { Index = "CH_CurseDarkOrc", 		x = nil, y = nil, radius = 366, },	},
			{ Boss = { Index = "CH_CurseDarkNavar", 		x = nil, y = nil, radius = 366, },	},
			{ Boss = { Index = "CH_BigDarkSpakeDog", 	x = nil, y = nil, radius = 366, },	},
			{ Boss = { Index = "CH_BigGoldJewelKeeper",	x = nil, y = nil, radius = 366, },	},
			{ Boss = { Index = "CH_KingMushRoom", 		x = nil, y = nil, radius = 366, },	},
			{ Boss = { Index = "CH_RangerSkelArcher", 	x = nil, y = nil, radius = 366, },	},
		},

		-- cMobRegen_Circle( MapIndex, MobIndex, CenterX, CenterY, Radius )
		Pattern_OnlyOneIsKey =
		{
			-- 27,28,32
			-- Key ���ڸ� ���� ��� ���ڰ� �������
			-- Mob ���ڸ� ���� �׶����� ���� �����
			-- Jewel ���ڸ� ���� ���������� ���´�.
			{
				Key   = { Index = "CH_DarkPresentBox01", x = nil, y = nil, radius = 366, count = 1, },
				Mob   = { Index = "CH_DarkPresentBox02", x = nil, y = nil, radius = 366, count = 7, },
				Jewel = { Index = "CH_DarkPresentBox03", x = nil, y = nil, radius = 366, count = 1, },
			},

			{
				Key   = { Index = "CH_DarkMine1", 		x = nil, y = nil, radius = 366, count = 1, },
				Mob   = { Index = "CH_DarkMine2", 		x = nil, y = nil, radius = 366, count = 7, },
				Jewel = { Index = "CH_DarkMine3", 		x = nil, y = nil, radius = 366, count = 1, },
			},

			{
				Key   = { Index = "DarkCoffin01", 		x = nil, y = nil, radius = 366, count = 1, },
				Mob   = { Index = "DarkCoffin02", 		x = nil, y = nil, radius = 366, count = 7, },
				Jewel = { Index = "DarkCoffin03", 		x = nil, y = nil, radius = 366, count = 1, },
			},
		},

		Pattern_KamarisTrap =
		{
			-- 21,22,23
		},

		-- �� ������
		BossBattle =
		{
			-- Case : LizardMan Guardian
			{
				LizardManGuardian = { Index = "CH_LizardManGuardian",    x = 8800, y = 11213, dir = 53, },
				PhysicalPillar    = { Index = "CH_PillarofLightIyzel02", x = 8488, y = 11097, dir = 53, },
				MagicalPillar     = { Index = "CH_PillarofLightIyzel03", x = 8775, y = 11583, dir = 53, },
			},

			-- Case : Heavy Orc
			{
				HeavyOrc       = { Index = "CH_HeavyOrc",             x = 8800, y = 11213, dir = 53, },
				PhysicalPillar = { Index = "CH_PillarofLightIyzel02", x = 8488, y = 11097, dir = 53, },
				MagicalPillar  = { Index = "CH_PillarofLightIyzel03", x = 8775, y = 11583, dir = 53, },
			},

			-- Case : Jewel Golem
			{
				JewelGolem      = { Index = "CH_JewelGolem",    x = 8800, y = 11213, dir = 53, },
				ImmortalPillar1 = { Index = "CH_PillarofLight", x = 9094, y = 11259, dir = 0,  },
				ImmortalPillar2 = { Index = "CH_PillarofLight", x = 8746, y = 11481, dir = 0,  },
				ImmortalPillar3 = { Index = "CH_PillarofLight", x = 8578, y = 11156, dir = 0,  },
				ImmortalPillar4 = { Index = "CH_PillarofLight", x = 8922, y = 10969, dir = 0,  },
			},
		},

		-- �� �������� ���� �������� ������� �� Ư���� ������ ������� ���ɼ��� �ִ� ����.
		IyzelReward =
		{
			-- Case : LizardMan Guardian
			{ Index = "CH_IyzenPresentBox01", x = 8923, y = 11189, radius = 90, },
			-- Case : Heavy Orc
			{ Index = "CH_IyzenPresentBox02", x = 8923, y = 11189, radius = 90, },
			-- Case : Jewel Golem
			{ Index = "CH_IyzenClPresentBox", x = 8923, y = 11189, radius = 90, },
		},
	},

	NPC =
	{
		IyzelReward = { Iyzel = { Index = "CH_Iyzel", x = 8800, y = 11213, dir = 315, }, },
	},

	Stuff =
	{
		-- �� ���� �� ����
		Door0	= { Index = "CH_Gate03", x = 1194,  y = 6749,  dir = 0, Block = "DOOR0",   scale = 1000 },	-- ������������ ���� �ִ� ��
		Door1	= { Index = "CH_Gate03", x = 1191,  y = 3949,  dir = 0, Block = "DOOR00",  scale = 1000 },	-- 1���� 2�� ����
		Door2	= { Index = "CH_Gate03", x = 2589,  y = 1944,  dir = 0, Block = "DOOR01",  scale = 1000 },	-- 2���� 3�� ����
		Door3	= { Index = "CH_Gate03", x = 4899,  y = 1072,  dir = 0, Block = "DOOR02",  scale = 1000 },	-- 3���� 4�� ����
		Door4	= { Index = "CH_Gate03", x = 7373,  y = 960,   dir = 0, Block = "DOOR03",  scale = 1000 },	-- 4���� 5�� ����
		Door5	= { Index = "CH_Gate03", x = 9847,  y = 959,   dir = 0, Block = "DOOR04",  scale = 1000 },	-- 5���� 6�� ����
		Door6	= { Index = "CH_Gate03", x = 10250, y = 3698,  dir = 0, Block = "DOOR05",  scale = 1000 },	-- 6���� 7�� ����
		Door7	= { Index = "CH_Gate03", x = 11415, y = 5872,  dir = 0, Block = "DOOR06",  scale = 1000 },	-- 7���� 8�� ����
		Door8	= { Index = "CH_Gate03", x = 11710, y = 8284,  dir = 0, Block = "DOOR07",  scale = 1000 },	-- 8���� 9�� ����
		Door9	= { Index = "CH_Gate03", x = 10323, y = 10216, dir = 0, Block = "DOOR08",  scale = 1000 },	-- 9���� 10�� ����

		StartExitGate = { Index = "CH_Gate01", x = 1193,  y = 7669,  dir = 0, Block = nil, scale = 1000 },	-- ������������ ������ ��
		EndExitGate   = { Index = "CH_Gate02", x = 8572,  y = 11355, dir = 0, Block = nil, scale = 1000 },	-- Ŭ�������� ������ ��

		-- Ȯ���� �鸸����
		Jewel	= { Index = "Q_CJewel1", Prob = 1, },

		-- C_IyzenPresentBox01
		Boss1_Reward =
		{
			-- Prob Ȯ���� ����Ǹ� ���õ������ �ʴ´�. ���� ������.
			{ Index = "BeastBoots",     Prob = 0.025, }, -- 1/40 Ȯ���� ���� ������.
			{ Index = "FirmamentBoots", Prob = 0.025, },
			{ Index = "GaeaBoots",      Prob = 0.025, },
			{ Index = "ShamanBoots",    Prob = 0.025, },
		},

		-- C_IyzenPresentBox02
		Boss2_Reward =
		{
			{ Index = "BeastPants",     Prob = 0.025, },
			{ Index = "FirmamentPants", Prob = 0.025, },
			{ Index = "GaeaPants",      Prob = 0.025, },
			{ Index = "ShamanPants",    Prob = 0.025, },
		},

		-- C_IyzenClPresentBox
		Boss3_Reward =
		{
			{ Index = "BeastArmor",     Prob = 0.025, },
			{ Index = "FirmamentArmor", Prob = 0.025, },
			{ Index = "GaeaArmor",      Prob = 0.025, },
			{ Index = "ShamanShirt",    Prob = 0.025, },
		},

	},
}
