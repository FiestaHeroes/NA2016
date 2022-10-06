--------------------------------------------------------------------------------
--                         Gold Hill Process Data                             --
--------------------------------------------------------------------------------

LinkInfo =
{
	ReturnMap = { MapIndex = "Eld", x = 17214, y = 13445 },
}


DelayTime =
{
	AfterInit					= 5,
	BetweenIntroDialog	 		= 3,
	AfterMobGen					= 1,
	BetweenLastBattleDialog		= 2,
	BetweenSuccessDialog		= 2,
	BetweenKQReturnNotice		= 5,
}


LimitTime =
{
	Layer1st	= 300,		-- 5��
	Layer2nd	= 480,		-- 8��
	Layer3rd	= 780,		-- 13��
	Layer4th	= 900,		-- 15��
	LastBattle	= 300,		-- 5��
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
