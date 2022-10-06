--------------------------------------------------------------------------------
--                                Process Data                                --
--------------------------------------------------------------------------------

INVALID_HANDLE 			= -1

--------------------------------------------------------------
--※ 진행 관련 DelayTime 정보
--------------------------------------------------------------
DelayTime =
{
	AfterInit 					= 15,	-- 던전 입장 후, 첫 대사 출력시까지의 대기시간
	GapDialog					= 3,	-- 페이스컷 사이의 시간
}

--------------------------------------------------------------
--※ ReturnMap 정보
--------------------------------------------------------------
-- 출구 게이트 클릭시, 유저들 링크보낼 좌표
LinkInfo =
{
	ReturnMap	= { MapIndex = "IDGate01", x = 1004, y = 1306 },
}

--------------------------------------------------------------
--※ 던전 퀘스트 용 정보
--------------------------------------------------------------
QuestMobKillInfo =
{
	QuestID  		= 2666,
	MobIndex 		= "Daliy_Check_d_Leviathan",
	MaxKillCount 	= 5,
}

--------------------------------------------------------------
--※ 레비아탄 스킬정보
--------------------------------------------------------------
LeviathanSkillInfo =
{
	------------------------------------------------------
	-- ※ 레비아탄 BossMain, BossHead

	-- RegenTick 마다,
	-- RegenMob_Index 몹(알)이 RegenMob_Num 마리씩 리젠되며,
	-- 최대 RegenMaxCount 만큼 발생한다.
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
	-- ※ 레비아탄이 소환하는 Egg 루틴 정보

	-- [ GuardianEgg, GuardEgg의 경우 ]
	-- 소환된 Egg는 리젠되고 EggBrakeTime (초)가 지나면 자살한다.
	-- 죽을때 Summon_Index 에 해당하는 몹을 Summon_Num 마리 소환한다.

	-- [ BuffEgg의 경우 ]
	-- 유저에 의해 죽임을 당했을 경우, 자신을 죽인 유저에게 Buff 상태이상을 걸어준다.
	-------------------------------------------------------
	-- Egg 정보
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
	-- ※ 레비아탄 BossMain 이 죽었을때, 같이 죽여줄 몹 정보 ( 뱀, 알 )
	-------------------------------------------------------
	Vanish_WhenLeviDead =
	{
		"ID_NestGuardianEgg", "ID_NestGuardEgg", "ID_NestBuffEgg",
		"ID_NestGuardian", "ID_NestGuard",
	}

}









