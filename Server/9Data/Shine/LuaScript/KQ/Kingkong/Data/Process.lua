--------------------------------------------------------------------------------
--                         Kingkong Process Data                            --
--------------------------------------------------------------------------------

LinkInfo =
{
	ReturnMap = { MapIndex = "Urg", x = 6436, y = 7169 },
}


DelayTime =
{
	AfterInit 					= 10,
	QuestSuccessDelay			= 10,
	BetweenKQReturnNotice		= 5,
}


NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	KQReturn =
	{
		Success =
		{
			{ Index = "KQReturn60",	},
			{ Index = nil,			},
			{ Index = "KQReturn50",	},
			{ Index = nil,			},
			{ Index = "KQReturn40",	},
			{ Index = nil,			},
			{ Index = "KQReturn30",	},
			{ Index = nil,			},
			{ Index = "KQReturn20",	},
			{ Index = nil,			},
			{ Index = "KQReturn10",	},
			{ Index = "KQReturn5",	},
		},

		Fail =
		{
			{ Index = "KQFReturn30",},	-- 30초 남음
			{ Index = nil,			},	-- 25초 남음: 메세지 없음
			{ Index = "KQFReturn20",},	-- 20초 남음
			{ Index = nil,			},	-- 15초 남음: 메세지 없음
			{ Index = "KQFReturn10",},	-- 10초 남음
			{ Index = "KQFReturn5",	},	-- 05초 남음
		},
	},
}


QuestMobKillInfo =
{
	QuestID  		= 2668,
	MobIndex 		= "Daliy_Check",
	MaxKillCount 	= 1,
}
