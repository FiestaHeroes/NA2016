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
			{ Index = "KQFReturn30",},	-- 30�� ����
			{ Index = nil,			},	-- 25�� ����: �޼��� ����
			{ Index = "KQFReturn20",},	-- 20�� ����
			{ Index = nil,			},	-- 15�� ����: �޼��� ����
			{ Index = "KQFReturn10",},	-- 10�� ����
			{ Index = "KQFReturn5",	},	-- 05�� ����
		},
	},
}


QuestMobKillInfo =
{
	QuestID  		= 2668,
	MobIndex 		= "Daliy_Check",
	MaxKillCount 	= 1,
}
