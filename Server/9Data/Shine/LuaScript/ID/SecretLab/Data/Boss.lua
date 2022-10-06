--------------------------------------------------------------------------------
--                      Secret Laboratory Boss Data                           --
--------------------------------------------------------------------------------


-- 보스 스킬이 발동되는 한계치를 정해놓은 테이블
ThresholdTable =
{
	SummonHP_Boss1 			= { },
	SummonHP_Boss2 			= { 750, },
	PeriodicSummonHP_Boss1 	= { 500, },
	PeriodicSummonHP_Boss2 	= { 700, 250, },
}


-- if cSetAbstate( 객체 핸들, "상태이상 인덱스", 강도, 지속시간 ) == nil then
SemiBossAbstate =
{
	TimeAttackMini 	= { Index = "StaTimeAttackMini", Strength = 1, KeepTime = 180000 },
	TimeAttack     	= { Index = "StaTimeAttack",     Strength = 1, KeepTime = 180000 },
	Immortal		= { Index = "StaImmortal",		 Strength = 1, KeepTime = 180000 },
}


-- OccurSec "AfterSecond" 일때 사용
SemiBossWarning =
{
	Entrance 		= { Code = "Started",		OccurCond = "EntranceArea",	OccurSec = nil,	},
	Remain_60_Sec 	= { Code = "Remain1min",	OccurCond = "AfterSecond",	OccurSec = 120,	},
	Remain_30_Sec 	= { Code = "Remain30sec",	OccurCond = "AfterSecond",	OccurSec = 150,	},
	Awakened 		= { Code = "BeAwakened",	OccurCond = "TimeOver",		OccurSec = nil,	},
}


-- 보스 스킬
BossSkill =
{
	-- 잔몹 소환
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

	-- CountPerSummon 	: 1회 소환시 소환하는 마리수
	-- SummonCount 		: 총 소환 횟수(0일경우 무제한) - 초기화 여부 관련 없이 최대 소환 횟수임
	-- Interval 		: 소환 사이의 시간 간격(초)
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

