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
