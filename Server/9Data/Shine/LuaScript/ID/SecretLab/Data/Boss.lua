--------------------------------------------------------------------------------
--                      Secret Laboratory Boss Data                           --
--------------------------------------------------------------------------------


-- ���� ��ų�� �ߵ��Ǵ� �Ѱ�ġ�� ���س��� ���̺�
ThresholdTable =
{
	SummonHP_Boss1 			= { },
	SummonHP_Boss2 			= { 750, },
	PeriodicSummonHP_Boss1 	= { 500, },
	PeriodicSummonHP_Boss2 	= { 700, 250, },
}


-- if cSetAbstate( ��ü �ڵ�, "�����̻� �ε���", ����, ���ӽð� ) == nil then
SemiBossAbstate =
{
	TimeAttackMini 	= { Index = "StaTimeAttackMini", Strength = 1, KeepTime = 180000 },
	TimeAttack     	= { Index = "StaTimeAttack",     Strength = 1, KeepTime = 180000 },
	Immortal		= { Index = "StaImmortal",		 Strength = 1, KeepTime = 180000 },
}


-- OccurSec "AfterSecond" �϶� ���
SemiBossWarning =
{
	Entrance 		= { Code = "Started",		OccurCond = "EntranceArea",	OccurSec = nil,	},
	Remain_60_Sec 	= { Code = "Remain1min",	OccurCond = "AfterSecond",	OccurSec = 120,	},
	Remain_30_Sec 	= { Code = "Remain30sec",	OccurCond = "AfterSecond",	OccurSec = 150,	},
	Awakened 		= { Code = "BeAwakened",	OccurCond = "TimeOver",		OccurSec = nil,	},
}


-- ���� ��ų
BossSkill =
{
	-- �ܸ� ��ȯ
	SummonHP_Boss1 =
	{
	},

	SummonHP_Boss2 =
	{
		HP750 =
		{
			SummonMobs =
			{
				{ Index = "Lab_Battle02", 	Count = 1, },
			},
		},
	},

	-- CountPerSummon 	: 1ȸ ��ȯ�� ��ȯ�ϴ� ������
	-- SummonCount 		: �� ��ȯ Ƚ��(0�ϰ�� ������) - �ʱ�ȭ ���� ���� ���� �ִ� ��ȯ Ƚ����
	-- Interval 		: ��ȯ ������ �ð� ����(��)
	PeriodicSummonHP_Boss1 	=
	{
		HP500 =
		{
			SummonMobs =
			{
				{ Index = "Lab_Ghost02", 	CountPerSummon = 2,	SummonCount = 0, Interval = 180 },
			},
		},
	},

	PeriodicSummonHP_Boss2 	=
	{
		HP700 =
		{
			SummonMobs =
			{
				{ Index = "Lab_Ghost02", 	CountPerSummon = 2,	SummonCount = 0, Interval = 180 },
			},
		},

		HP250 =
		{
			SummonMobs =
			{
				{ Index = "Lab_Snake_In", 	CountPerSummon = 2,	SummonCount = 0, Interval = 180 },
			},
		},
	},
}

