--------------------------------------------------------------------------------
--                                Process Data                                --
--------------------------------------------------------------------------------

LinkInfo =
{
	ReturnMap	= { MapIndex = "Ser", x = 18621, y = 4841 },
}


DelayTime =
{
	AfterInit 				= 5,
	GapDialog				= 3,
	WaitReturnToHome		= 3,
	GapIDReturnNotice		= 5,
	RootManagerFuncTick		= 2,
	TeleportFuncTick		= 2,
}


AreaInfo =
{
	Zone5_FaceCut =
	{
		"Area5FaceCut1",
		"Area5FaceCut2"
	},

	Zone5_Teleport =
	{
		{
			AreaName 	= "Teleport1",
			LinkX 		= 9268,
			LinkY 		= 6454,
		},

		{
			AreaName 	= "Teleport2",
			LinkX 		= 9268,
			LinkY 		= 6454,
		},
	},

	Zone5_BossRoom	= "BossZone"
}

AbStateInfo =
{
	-- �����̵� ���� ������, ���������� �ִ� ������ ������ �ɾ��� ���� �����̻�
	Stun	=
	{
		Index 		= "StaSDVale01_STN",
		Strength 	= 1,
		--KeepTime	= ���ĭ ����ϴµ��� ��� 1��¥�� �����̻� �ɾ���
	},

	-- ���μ� ��� �ı�������, ���ĭ���� �ɾ��� ���� �����̻�
	Stun_ToBlakan_WhenSave =
	{
		Index 		= "StaSDVale01_STN",
		Strength 	= 1,
		KeepTime 	= 5 * 60 * 1000,	-- 5��
	},

	-- ���μ� �ı��� ���ĭ���� �ɾ��� ���ݷ� ���� �����̻�
	BlakanAtkUp =
	{
		Index 		= "StaWarCry",
		Strength 	= 1,
		KeepTime 	= 30 * 60 * 1000,	-- 30��
	},
}



Blakan_Data_Info =
{

	WaitBlakanDialog		= 5,		-- ù ������ �����̵��� ��, n�� �� ���ĭ ��� ����
	WaitFagelsDialog		= 120,		-- ù ������ �����̵��� ��, n�� �� �İֽ� ��� ����
	WaitFirstSummon			= 10,		-- ù ������ �����̵��� ��, n�� �� Summon ����
	WaitNextFagelsStep		= 5,		-- ���ĭ �����, �İֽ� ���� ���ð�


	-- ù��° ��ȯ -> Dialog ( "Fargels06_1" ) -> �ι�° ��ȯ
	-- ù��° ��ȯ
	SummonInfo1 =
	{
		KeepTime			= 2 * 60,	-- 2��
		SummonTick			= 20,		-- 20��
		Mob =
		{

			{ Index = "Summon_Soldier", 	x = 9626, 	y = 6807, radius = 200, },
			{ Index = "Summon_Archer", 		x = 9626, 	y = 6807, radius = 200, },
			{ Index = "Summon_Alchemist", 	x = 9626, 	y = 6807, radius = 200, },


			{ Index = "Summon_Soldier", 	x = 9626, 	y = 6088, radius = 200, },
			{ Index = "Summon_Archer", 		x = 9626, 	y = 6088, radius = 200, },
			{ Index = "Summon_Alchemist", 	x = 9626, 	y = 6088, radius = 200, },

		},
	},


	-- �ι�° ��ȯ
	SummonInfo2 =
	{
		KeepTime			= 200 * 60 * 1000,	-- 200��
		SummonTick			= 60,
		Mob =
		{

			{ Index = "Summon_Soldier", 	x = 9898, 	y = 6375, radius = 200, },
			{ Index = "Summon_Gladiator", 	x = 9898, 	y = 6375, radius = 200, },
			{ Index = "Summon_Archer", 		x = 9898, 	y = 6375, radius = 200, },
			{ Index = "Summon_Assassin", 	x = 9898, 	y = 6375, radius = 200, },
			{ Index = "Summon_Alchemist", 	x = 9898, 	y = 6375, radius = 200, },
			{ Index = "Summon_Mage", 		x = 9898, 	y = 6375, radius = 200, },


			{ Index = "Summon_Soldier", 	x = 9220, 	y = 6512, radius = 200, },
			{ Index = "Summon_Gladiator", 	x = 9220, 	y = 6512, radius = 200, },
			{ Index = "Summon_Archer", 		x = 9220, 	y = 6512, radius = 200, },
			{ Index = "Summon_Assassin", 	x = 9220, 	y = 6512, radius = 200, },
			{ Index = "Summon_Alchemist", 	x = 9220, 	y = 6512, radius = 200, },
			{ Index = "Summon_Mage", 		x = 9220, 	y = 6512, radius = 200, },

		},
	},


	-- ���ĭ HP�� 50%���Ϸ� ����������
	HP50 =
	{
		SummonTick 			= 1 * 60,	-- 1��
		Mob =
		{
			{ Index = "IDBla_Tornado", x = 9914, y = 6702, },
			{ Index = "IDBla_Tornado", x = 9832, y = 6070, },
			{ Index = "IDBla_Tornado", x = 9202, y = 6176, },
			{ Index = "IDBla_Tornado", x = 9292, y = 6801, },
		},
	},

}








