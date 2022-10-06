--------------------------------------------------------------------------------
--                    Legend Of Bijou Process Data                            --
--------------------------------------------------------------------------------

LinkInfo =
{
	ReturnMap = { MapIndex = "Urg_Alruin", x = 6120, y = 10286 },
}


DelayTime =
{
	AfterInit 							= 5,
	StartStep_N_DoorOpenGap				= 3,
	WallDefenderRevivalInterval 		= 15,
	GapGateOpenAndChargerAbstateReset	= 3,
	GapBeforeBossSquareDialog			= 3,
	GapSuccessDialog					= 3,
	GapKQReturnNotice					= 5,
}


MapFogInfo = { FogValue = 70, SightDistance = 1600 }


NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	QuestSuccess 	= { Index = "SucMessage" },
	QuestFail 		= { Index = "FailMessage" },

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
