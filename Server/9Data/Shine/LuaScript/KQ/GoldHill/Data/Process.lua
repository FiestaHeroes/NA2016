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
	Layer1st	= 300,		-- 5분
	Layer2nd	= 480,		-- 8분
	Layer3rd	= 780,		-- 13분
	Layer4th	= 900,		-- 15분
	LastBattle	= 300,		-- 5분
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
