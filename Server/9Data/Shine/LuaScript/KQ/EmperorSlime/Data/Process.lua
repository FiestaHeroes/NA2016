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
		{ Index = "KQReturn30", },	-- 30�� ����
		{ Index = nil,          },	-- 25�� ����: �޼��� ����
		{ Index = "KQReturn20", },	-- 20�� ����
		{ Index = nil,          },	-- 15�� ����: �޼��� ����
		{ Index = "KQReturn10", },	-- 10�� ����
		{ Index = "KQReturn5" , },	-- 05�� ����
	},
}


QuestMobKillInfo =
{
	QuestID  		= 2668,
	MobIndex 		= "Daliy_Check",
	MaxKillCount 	= 1,
}
