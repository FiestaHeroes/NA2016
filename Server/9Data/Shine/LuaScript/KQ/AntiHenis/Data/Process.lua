--------------------------------------------------------------------------------
--                         Anti Henis Process Data                            --
--------------------------------------------------------------------------------

LinkInfo =
{
	ReturnMap = { MapIndex = "Urg_Alruin", x = 6120, y = 10286 },
}


DelayTime =
{
	AfterInit 						= 5,
	AfterMobGen						= 5,
	BetweenGuardWarnDialog 			= 3,
	BetweenAntiHenisBossWarnDialog	= 2,
	BetweenSuccessDialog			= 2,
	BetweenKQReturnNotice			= 5,
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
