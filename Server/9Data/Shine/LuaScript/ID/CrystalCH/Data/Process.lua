--------------------------------------------------------------------------------
--                     Crystal Castle Process Data                            --
--------------------------------------------------------------------------------

LinkInfo =
{
	-- 링크 방식과 위치
	ReturnMapOnGateClick 	= { MapIndex = "Urg", x = 9375, y = 1079 },
}


DelayTime =
{
	AfterInit 			= 10,	-- 던전 입장 후 인스턴스 던전 진행 시작까지 기다리는 시간

	GapDialog			= 2,	-- 페이스컷 사이의 시간

	WaitAfterGenMob		= 5,	-- 각 층에서 몹 젠 후 클리어 조건 체크까지 최소 대기 시간

	RewardBoxTryTime	= 40, 	-- 클리어 후에 보이는 보상 상자를 열어볼 수 있는 시간
}


QuestMobKillInfo =
{
	QuestID  		= 2664,
	MobIndex 		= "Daliy_Check_Tower02",
	MaxKillCount 	= 5,
}
