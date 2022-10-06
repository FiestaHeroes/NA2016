--------------------------------------------------------------------------------
--                     Tower Of Iyzel Process Data                            --
--------------------------------------------------------------------------------

LinkInfo =
{
	-- 링크 방식과 위치
	ReturnMapOnGateClick 	= { MapIndex = "RouVal01", x = 4664, y = 8416 },
	ReturnMapOnClear 		= { MapIndex = "RouVal01", x = 4661, y = 8208 },
}


DelayTime =
{
	AfterInit 			= 10,	-- 던전 입장 후 인스턴스 던전 진행 시작까지 기다리는 시간

	GapDialog			= 2,	-- 페이스컷 사이의 시간

	WaitAfterGenMob		= 5,	-- 각 층에서 몹 젠 후 클리어 조건 체크까지 최소 대기 시간

	GapIDReturnNotice	= 10,	-- 리턴 공지 사이 기본 간격
}


NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	IDReturn =
	{
		{ Index = "Chat2001System", },	-- 60초 남음
		{ Index = nil,              },	-- 50초 남음
		{ Index = nil,              },	-- 40초 남음
		{ Index = "Chat2002System", },	-- 30초 남음
		{ Index = nil,              },	-- 20초 남음
		{ Index = "Chat2003System", },	-- 10초 남음
	},
}


QuestMobKillInfo =
{
	QuestID  		= 2663,
	MobIndex 		= "Daliy_Check_Tower01",
	MaxKillCount 	= 5,
}
