--------------------------------------------------------------------------------
--                        Emperor Slime Process Data                          --
--------------------------------------------------------------------------------

LinkInfo =
{
	ReturnMap = { MapIndex = "Gate", x = 1487, y = 1517 },
}


DelayTime =
{
	AfterInit 						= 5,
	AfterMobGen						= 5,
	BetweenGuardWarnDialog 			= 3,
	BetweenEmperorSlimeWarnDialog	= 3,
	AfterKillBoss					= 5,
	BetweenSuccessDialog			= 3,
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
