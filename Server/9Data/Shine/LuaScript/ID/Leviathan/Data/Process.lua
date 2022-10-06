--------------------------------------------------------------------------------
--                                Process Data                                --
--------------------------------------------------------------------------------

INVALID_HANDLE 			= -1

--------------------------------------------------------------
--�� ���� ���� DelayTime ����
--------------------------------------------------------------
DelayTime =
{
	AfterInit 					= 15,	-- ���� ���� ��, ù ��� ��½ñ����� ���ð�
	GapDialog					= 3,	-- ���̽��� ������ �ð�
}

--------------------------------------------------------------
--�� ReturnMap ����
--------------------------------------------------------------
-- �ⱸ ����Ʈ Ŭ����, ������ ��ũ���� ��ǥ
LinkInfo =
{
	ReturnMap	= { MapIndex = "IDGate01", x = 1004, y = 1306 },
}

--------------------------------------------------------------
--�� ���� ����Ʈ �� ����
--------------------------------------------------------------
QuestMobKillInfo =
{
	QuestID  		= 2666,
	MobIndex 		= "Daliy_Check_d_Leviathan",
	MaxKillCount 	= 5,
}

--------------------------------------------------------------
--�� �����ź ��ų����
--------------------------------------------------------------
LeviathanSkillInfo =
{
	------------------------------------------------------
	-- �� �����ź BossMain, BossHead

	-- RegenTick ����,
	-- RegenMob_Index ��(��)�� RegenMob_Num ������ �����Ǹ�,
	-- �ִ� RegenMaxCount ��ŭ �߻��Ѵ�.
	-------------------------------------------------------
	Routine_Leviathan =
	{
		HPRateToRegenEgg		= 95,

		GuardianEgg =
		{
			RegenTick 		= 120,
			RegenMob		= { Index = "ID_NestGuardianEgg", Num = 2, },
			RegenMaxCount	= 100,
		},

		GuardEgg =
		{
			RegenTick 		= 120,
			RegenMob		= { Index = "ID_NestGuardEgg", Num = 2, },
			RegenMaxCount	= 100,
		},

		BuffEgg =
		{
			RegenTick 		= 120,
			RegenMob		= { Index = "ID_NestBuffEgg", Num = 2, },
			RegenMaxCount	= 100,
		},

	},

	------------------------------------------------------
	-- �� �����ź�� ��ȯ�ϴ� Egg ��ƾ ����

	-- [ GuardianEgg, GuardEgg�� ��� ]
	-- ��ȯ�� Egg�� �����ǰ� EggBrakeTime (��)�� ������ �ڻ��Ѵ�.
	-- ������ Summon_Index �� �ش��ϴ� ���� Summon_Num ���� ��ȯ�Ѵ�.

	-- [ BuffEgg�� ��� ]
	-- ������ ���� ������ ������ ���, �ڽ��� ���� �������� Buff �����̻��� �ɾ��ش�.
	-------------------------------------------------------
	-- Egg ����
	Routine_GuardianEgg =
	{
		EggBrakeTime 	= 60,
		Summon = { Index = "ID_NestGuardian", Num = 2, },
	},

	Routine_GuardEgg =
	{
		EggBrakeTime 	= 60,
		Summon = { Index = "ID_NestGuard", Num = 15, },
	},

	Routine_BuffEgg =
	{
		Buff = { Index = "StaDeadlyBlessing", Strength = 1, KeepTime = 15 * 1000, },
	},

	------------------------------------------------------
	-- �� �����ź BossMain �� �׾�����, ���� �׿��� �� ���� ( ��, �� )
	-------------------------------------------------------
	Vanish_WhenLeviDead =
	{
		"ID_NestGuardianEgg", "ID_NestGuardEgg", "ID_NestBuffEgg",
		"ID_NestGuardian", "ID_NestGuard",
	}

}









