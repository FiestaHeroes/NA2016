--------------------------------------------------------------------------------
--                  Secret Laboratory Process Data                            --
--------------------------------------------------------------------------------

LinkInfo =
{
	-- 링크 방식과 위치
	ReturnMapOnGateClick 	= { MapIndex = "Urg_Alruin", x = 21948, y = 5509 },
}


DelayTime =
{
	AfterInit 			= 10,	-- 던전 입장 후 인스턴스 던전 진행 시작까지 기다리는 시간

	GapDialog			= 2,	-- 페이스컷 사이의 시간
	GapHelpUsChat		= 10,	-- 보스전 도중 감옥에서 구해달라고 아이들이 하는 말 사이 간격
	GapChildrenChat		= 1,	-- 구출된 아이들이 말하는 사이간격
	GapSummonDialog		= 1,	-- 보스의 몹소환 페이스컷 사이의 시간

	WaitAfterGenMob		= 5,	-- 각 층에서 몹 젠 후 클리어 조건 체크까지 최소 대기 시간

	BeforePrisonVanish	= 1,	-- 감옥이 열리고 사라지기 까지의 시간
	AnimationTime		= 1,	-- 애니메이션 시간
	BeforeChildrenRun	= 5,	-- 아이들이 달리기 전의 대기시간
	AfterChildrenRun	= 5,	-- 아이들이 달리기 시작한 후 사라지기까지의 시간
}


QuestMobKillInfo =
{
	QuestID  		= 2667,
	MobIndex 		= "Daliy_Check_Tower03",
	MaxKillCount 	= 5,
}
