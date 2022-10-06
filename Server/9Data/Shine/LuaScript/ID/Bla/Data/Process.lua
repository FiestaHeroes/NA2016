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
	-- 강제이동 지역 도착시, 보스영역에 있는 유저와 몹에게 걸어줄 스턴 상태이상
	Stun	=
	{
		Index 		= "StaSDVale01_STN",
		Strength 	= 1,
		--KeepTime	= 블라칸 대사하는동안 계속 1초짜리 상태이상 걸어줌
	},

	-- 봉인석 모두 파괴했을때, 블라칸에게 걸어줄 스턴 상태이상
	Stun_ToBlakan_WhenSave =
	{
		Index 		= "StaSDVale01_STN",
		Strength 	= 1,
		KeepTime 	= 5 * 60 * 1000,	-- 5분
	},

	-- 봉인석 파괴시 블라칸에게 걸어줄 공격력 증가 상태이상
	BlakanAtkUp =
	{
		Index 		= "StaWarCry",
		Strength 	= 1,
		KeepTime 	= 30 * 60 * 1000,	-- 30분
	},
}



Blakan_Data_Info =
{

	WaitBlakanDialog		= 5,		-- 첫 유저가 강제이동한 후, n초 후 블라칸 대사 실행
	WaitFagelsDialog		= 120,		-- 첫 유저가 강제이동한 후, n초 후 파겔스 대사 실행
	WaitFirstSummon			= 10,		-- 첫 유저가 강제이동한 후, n초 후 Summon 시작
	WaitNextFagelsStep		= 5,		-- 블라칸 구출시, 파겔스 등장 대기시간


	-- 첫번째 소환 -> Dialog ( "Fargels06_1" ) -> 두번째 소환
	-- 첫번째 소환
	SummonInfo1 =
	{
		KeepTime			= 2 * 60,	-- 2분
		SummonTick			= 20,		-- 20초
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


	-- 두번째 소환
	SummonInfo2 =
	{
		KeepTime			= 200 * 60 * 1000,	-- 200분
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


	-- 블라칸 HP가 50%이하로 떨어졌을때
	HP50 =
	{
		SummonTick 			= 1 * 60,	-- 1분
		Mob =
		{
			{ Index = "IDBla_Tornado", x = 9914, y = 6702, },
			{ Index = "IDBla_Tornado", x = 9832, y = 6070, },
			{ Index = "IDBla_Tornado", x = 9202, y = 6176, },
			{ Index = "IDBla_Tornado", x = 9292, y = 6801, },
		},
	},

}








