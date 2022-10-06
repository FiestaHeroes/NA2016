--------------------------------------------------------------------------------
--                        Mara Pirate Process Data                            --
--------------------------------------------------------------------------------

LinkInfo =
{
	ReturnMap = { MapIndex = "Eld", x = 17214, y = 13445 },
}


DelayTime =
{
	AfterInit 					= 5,
	BetweenSpyLieChat			= 5,
	BeforeSpyReportDialog		= 3,
	BetweenSpyReportDialog		= 1,
	BetweenMiddleReportDialog	= 5,
	BetweenKQFailedDialog		= 5,
	BetweenKQReturnNotice		= 5,
}


NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	KQReturn =
	{
		{ Index = "KQReturn30", },	-- 30초 남음
		{ Index = nil,          },	-- 25초 남음: 메세지 없음
		{ Index = "KQReturn20", },	-- 20초 남음
		{ Index = nil,          },	-- 15초 남음: 메세지 없음
		{ Index = "KQReturn10", },	-- 10초 남음
		{ Index = "KQReturn5" , },	-- 05초 남음
	},
}


QuestMobKillInfo =
{
	QuestID  		= 2668,
	MobIndex 		= "Daliy_Check",
	MaxKillCount 	= 1,
}
