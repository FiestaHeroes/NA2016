--------------------------------------------------------------------------------
--                        Mini Dragon Process Data                            --
--------------------------------------------------------------------------------

LinkInfo =
{
	ReturnMap = { MapIndex = "Eld", x = 17214, y = 13445 },
}


DelayTime =
{
	AfterInit 			= 10,	-- 던전 입장 후 킹퀘 시작까지 기다리는 시간
	WaitAfterKillBoss	= 10,	-- 보스 킬 후 성공 처리까지 대기시간
	GapKQReturnNotice	= 5,	-- 리턴 공지 사이 기본 간격
}


NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	KQReturn =
	{
		{ Index = "KQReturn60", },	-- 60초 남음
		{ Index = nil,          },	-- 55초 남음: 메세지 없음
		{ Index = "KQReturn50", },	-- 50초 남음
		{ Index = nil,          },	-- 45초 남음: 메세지 없음
		{ Index = "KQReturn40", },	-- 40초 남음
		{ Index = nil,          },	-- 35초 남음: 메세지 없음
		{ Index = "KQReturn30", },	-- 30초 남음
		{ Index = nil,          },	-- 25초 남음: 메세지 없음
		{ Index = "KQReturn20", },	-- 20초 남음
		{ Index = nil,          },	-- 15초 남음: 메세지 없음
		{ Index = "KQReturn10", },	-- 10초 남음
		{ Index = "KQReturn5" , },	-- 05초 남음
	},

	KQFReturn =
	{
		{ Index = "KQFReturn30", },	-- 30초 남음
		{ Index = nil,           },	-- 25초 남음: 메세지 없음
		{ Index = "KQFReturn20", },	-- 20초 남음
		{ Index = nil,           },	-- 15초 남음: 메세지 없음
		{ Index = "KQFReturn10", },	-- 10초 남음
		{ Index = "KQFReturn5" , },	-- 05초 남음
	},
}


QuestMobKillInfo =
{
	QuestID  		= 2668,
	MobIndex 		= "Daliy_Check",
	MaxKillCount 	= 1,
}
