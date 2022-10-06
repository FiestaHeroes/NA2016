require( "common" )

SCRIPT_MAIN        = "ID/WarH/WarH"


CAMERA_STATE = { }
CAMERA_STATE["NORMAL"] 		= 1
CAMERA_STATE["MOVE"] 		= 2
CAMERA_STATE["REMOVE"] 		= 3
CAMERA_STATE["NEXT_STEP"]	= 4

STA_IMMORTAL 	= "StaImmortal"
STA_RANGEATTACK = "StaStrongerRangeAttack"
STA_MELEEATTACK = "StaStrongerMeleeAttack"

EM_STATE = { }

EM_STATE["Start"]	= 1
EM_STATE["Play"]	= 2
EM_STATE["End"]		= 3


MONSTER_STATE = { }
MONSTER_STATE["NORMAL"] = 1
MONSTER_STATE["AGGRO"] 	= 2
MONSTER_STATE["CAMERA"]	= 3


SEARCH_RANGE 			= 5000
AGGRO_RANGE				= 700
EVENT_ROUTINE_END		= 999999
DOOR_CHECK_TIME			= 2
ANIMATION_CHECK_TIME 	= 4


ES_STATE = { }
ES_STATE["STATE_1"] = 1
ES_STATE["STATE_2"] = 2
ES_STATE["STATE_3"] = 3
ES_STATE["STATE_4"] = 4
ES_STATE["STATE_5"] = 5
ES_STATE["STATE_6"] = 6
ES_STATE["STATE_7"] = 7
ES_STATE["STATE_8"] = 8
ES_STATE["STATE_9"] = 9
ES_STATE["STATE_10"] = 10
ES_STATE["STATE_11"] = 11
ES_STATE["STATE_12"] = 12
ES_STATE["STATE_13"] = 13
ES_STATE["STATE_14"] = 14
ES_STATE["STATE_15"] = 15
ES_STATE["STATE_16"] = 16
ES_STATE["STATE_17"] = 17
ES_STATE["STATE_18"] = 18
ES_STATE["STATE_19"] = 19
ES_STATE["STATE_20"] = 20



FC_STATE = { }

FC_STATE["NORMAL"] 		= 1
FC_STATE["MOVE"] 		= 2
FC_STATE["MOVE_END"] 	= 3
FC_STATE["FOLLOW"] 		= 4


MS_STATE = { }

MS_STATE["NORMAL"]		= 1
MS_STATE["SUMMON"]		= 2
MS_STATE["DEAD"]		= 3
MS_STATE["CAMERA"]		= 4


DOOR_BLOCK_DATA =
{
	{ DOOR_INDEX = "WarH_TDoor", DOOR_BLOCK = "Door01", REGEN_POSITION 	= { X = 3977, 	Y = 12400, DIR = 90 } },
	{ DOOR_INDEX = "WarH_NDoor", DOOR_BLOCK = "Door02", REGEN_POSITION 	= { X = 8347, 	Y = 12536, DIR = 90 } },
	{ DOOR_INDEX = "WarH_IDoor", DOOR_BLOCK = "Door03", REGEN_POSITION 	= { X = 13313, 	Y = 12560, DIR = 90 } },
	{ DOOR_INDEX = "WarH_FDoor", DOOR_BLOCK = "Door04", REGEN_POSITION 	= { X = 17526, 	Y = 12540, DIR = 90 } }
}

DOOR_LOCK_DATA =
{
	{ LOCK_INDEX = "WarH_DoorLock2", REGEN_POSITION = { X = 3967,  Y = 12400, DIR = 90 } },
	{ LOCK_INDEX = "WarH_DoorLock",  REGEN_POSITION = { X = 8337,  Y = 12536, DIR = 90 } },
	{ LOCK_INDEX = "WarH_DoorLock",  REGEN_POSITION = { X = 13303, Y = 12560, DIR = 90 } },
	{ LOCK_INDEX = "WarH_DoorLock",  REGEN_POSITION = { X = 17516, Y = 12540, DIR = 90 } },
}

CAMERAMOVE_DATA =
{
-- 寇己
	{ AngleY = 10, Distance = 1200, KeepTime = 4, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },
	{ AngleY = 20, Distance = 1400, KeepTime = 5, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },
	{ AngleY = 23, Distance = 3000, KeepTime = 4, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },

-- 1己
	{ AngleY = 10, Distance = 1200, KeepTime = 4, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },
	{ AngleY = 20, Distance = 1400, KeepTime = 6, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },
	{ AngleY = 20, Distance = 2500, KeepTime = 6, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },

-- 2己
	{ AngleY = 10, Distance = 1200, KeepTime = 5, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },
	{ AngleY = 7,  Distance = 1200, KeepTime = 4, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },
	{ AngleY = 20, Distance = 1400, KeepTime = 5, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },
	{ AngleY = 20, Distance = 2500, KeepTime = 4, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },


-- 3己
	{ AngleY = 10, Distance = 1200, KeepTime = 4, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },
	{ AngleY = 7,  Distance = 800, 	KeepTime = 4, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },
	{ AngleY = 20, Distance = 1400, KeepTime = 4, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },
	{ AngleY = 20, Distance = 2500, KeepTime = 6, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },

-- 郴己
	{ AngleY = 10, Distance = 1200, KeepTime = 4, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },
	{ AngleY = 7,  Distance = 800, 	KeepTime = 4, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },
	{ AngleY = 20, Distance = 1400, KeepTime = 4, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },
}

DIALOG_DATA =
{
-- 寇己
	{ FACECUT = "WarL_ForasChief", 	FILENAME = "WarH", INDEX = "ForasC_01", DELAY = 5 },
	{ FACECUT = "WarL_ForasChief", 	FILENAME = "WarH", INDEX = "ForasC_02", DELAY = 0 },
	{ FACECUT = nil, 				FILENAME = "WarH", INDEX = "Notice_01", DELAY = 0 },
	{ FACECUT = "WarL_ForasChief", 	FILENAME = "WarH", INDEX = "ForasC_03", DELAY = 9 },
	{ FACECUT = "WarL_ForasChief", 	FILENAME = "WarH", INDEX = "ForasC_04", DELAY = 0 },

-- 1己
	{ FACECUT = "WarL_ForasChief", 	FILENAME = "WarH", INDEX = "ForasC_02", DELAY = 0 },
	{ FACECUT = nil, 				FILENAME = "WarH", INDEX = "Notice_01", DELAY = 0 },
	{ FACECUT = "WarL_ForasChief", 	FILENAME = "WarH", INDEX = "ForasC_03", DELAY = 2 },
	{ FACECUT = "WarL_ForasChief", 	FILENAME = "WarH", INDEX = "ForasC_04", DELAY = 2 },

-- 2己
	{ FACECUT = "WarL_ForasChief", 	FILENAME = "WarH", INDEX = "ForasC_02", DELAY = 2 },
	{ FACECUT = nil, 				FILENAME = "WarH", INDEX = "Notice_01", DELAY = 0 },
	{ FACECUT = "WarL_ForasChief", 	FILENAME = "WarH", INDEX = "ForasC_03", DELAY = 2 },
	{ FACECUT = "WarL_ForasChief", 	FILENAME = "WarH", INDEX = "ForasC_04", DELAY = 2 },

-- 3己
	{ FACECUT = "WarL_ForasChief", 	FILENAME = "WarH", INDEX = "ForasC_02", DELAY = 0 },
	{ FACECUT = nil, 				FILENAME = "WarH", INDEX = "Notice_01", DELAY = 0 },
	{ FACECUT = "WarL_ForasChief", 	FILENAME = "WarH", INDEX = "ForasC_05", DELAY = 2 },
	{ FACECUT = "WarL_ForasChief", 	FILENAME = "WarH", INDEX = "ForasC_03", DELAY = 2 },
	{ FACECUT = "WarL_ForasChief", 	FILENAME = "WarH", INDEX = "ForasC_06", DELAY = 2 },

-- 郴己
	{ FACECUT = "WarL_ForasChief", 	FILENAME = "WarH", INDEX = "ForasC_07", DELAY = 2 },

-- 辆丰
	{ FACECUT = nil, 				FILENAME = "WarH", INDEX = "KQReturn5m", DELAY = 60 },
	{ FACECUT = nil, 				FILENAME = "WarH", INDEX = "KQReturn4m", DELAY = 60 },
	{ FACECUT = nil, 				FILENAME = "WarH", INDEX = "KQReturn3m", DELAY = 60 },
	{ FACECUT = nil, 				FILENAME = "WarH", INDEX = "KQReturn2m", DELAY = 60 },
	{ FACECUT = nil, 				FILENAME = "WarH", INDEX = "KQReturn60", DELAY = 30 },
	{ FACECUT = nil, 				FILENAME = "WarH", INDEX = "KQReturn30", DELAY = 10 },
	{ FACECUT = nil, 				FILENAME = "WarH", INDEX = "KQReturn20", DELAY = 10 },
	{ FACECUT = nil, 				FILENAME = "WarH", INDEX = "KQReturn10", DELAY = 5 },
	{ FACECUT = nil, 				FILENAME = "WarH", INDEX = "KQReturn5",  DELAY = 0 },
}

MAP_MARK_DATA =
{
	LINKTOWN	= { GROUP = 100, KEEPTIME = 99999999, ICON = "LinkTown" 	},
	DOOR		= { GROUP = 300, KEEPTIME = 99999999, ICON = "Gate"			}
}

GATE_DATA =
{
	START_GATE =
	{
		GATE_INDEX 		= "DT_ExitGate",
		REGEN_POSITION 	= { X = 796, Y = 12338, DIR = -90 },
		LINK     		= { FIELD = "UrgSwa01", X = 17304, Y = 4638 }
	},

	END_GATE =
	{
		GATE_INDEX 		= "DT_ExitGate",
		REGEN_POSITION 	= { X = 20969, Y = 12563, DIR = -90 },
		LINK     		= { FIELD = "UrgSwa01", X = 17304, Y = 4638 }
	}
}

GATE_TITLE =
{
	Start 	= { Title = "Exit Gate", Yes = "Exit", No = "Cancel" },
	End		= { Title = "Exit Gate", Yes = "Exit", No = "Cancel" }
}

FORAS_CHIEF =
{
	MOBINDEX = "WarH_ForasChief",
	REGEN_POSITION = { X = 1582, Y = 12361, DIR = 90 },
	EVENT_POSITION =
	{
		{ START_POS = { X = 3300, Y = 12400, DIR = 90 }, 	END_POS = { X = 3600, Y = 12400, DIR = 90} },
		{ START_POS = { X = 7800, Y = 12520, DIR = 90 }, 	END_POS = { X = 8100, Y = 12520, DIR = 90} },
		{ START_POS = { X = 12800, Y = 12557, DIR = 90 }, 	END_POS = { X = 13100, Y = 12565, DIR = 90} },
		{ START_POS = { X = 16800, Y = 12535, DIR = 90 }, 	END_POS = { X = 17100, Y = 12535, DIR = 90} },
	},
	ANIMATION = "ForasChief_Action01"
}

EVNET_DATA_NO1 =
{
	FENCE =
	{
		MOBINDEX = "WarH_Fence",
		REGEN_POSITION =
		{
			{ X = 2488, Y = 12411, DIR = 90 },
			{ X = 2839, Y = 12806, DIR = 90 },
			{ X = 2811, Y = 11957, DIR = 90 },
			{ X = 3131, Y = 13162, DIR = 90 },
			{ X = 3177, Y = 11581, DIR = 90 },
		}
	},

	DEVILDOM =
	{
		MOBINDEX = "WarH_Devildom",
		REGEN_POSITION =
		{
			{ X = 3050, Y = 13018, DIR = 90 },
			{ X = 2997, Y = 12977, DIR = 90 },
			{ X = 2746, Y = 12672, DIR = 90 },
			{ X = 2688, Y = 12625, DIR = 90 },
			{ X = 2549, Y = 12230, DIR = 90 },
			{ X = 2631, Y = 12147, DIR = 90 },
			{ X = 2703, Y = 12086, DIR = 90 },
			{ X = 2977, Y = 11749, DIR = 90 },
			{ X = 3063, Y = 11691, DIR = 90 },
			{ X = 3538, Y = 12210, DIR = 90 },
			{ X = 3538, Y = 12554, DIR = 90 },
		}
	},

	HIGH_DEVILDOM =
	{
		MOBINDEX = "WarH_TDevildom",
		REGEN_POSITION =
		{
			{ X = 2931, Y = 12938, DIR = 90 },
			{ X = 2610, Y = 12568, DIR = 90 },
			{ X = 2900, Y = 11821, DIR = 90 },
		}
	},

	FMCORPS =
	{
		MOBINDEX = "WarH_FMCorps",
		REGEN_POSITION =
		{
			{ X = 3050, Y = 13018, DIR = 90 },
			{ X = 2997, Y = 12977, DIR = 90 },
			{ X = 2931, Y = 12938, DIR = 90 },
			{ X = 2746, Y = 12672, DIR = 90 },
			{ X = 2688, Y = 12625, DIR = 90 },
			{ X = 2610, Y = 12568, DIR = 90 },
			{ X = 2549, Y = 12230, DIR = 90 },
			{ X = 2631, Y = 12147, DIR = 90 },
			{ X = 2703, Y = 12086, DIR = 90 },
			{ X = 2900, Y = 11821, DIR = 90 },
			{ X = 2977, Y = 11749, DIR = 90 },
			{ X = 3063, Y = 11691, DIR = 90 },
		}
	},

	EVENT_DEVILDOM =
	{
		MOBINDEX = "WarH_Devildom",
		REGEN_POSITION = { X = 3819, Y = 12375, RADIUS = 300},
		MOBCOUNT = 8,
	},

	EVENT_TDEVILDOM =
	{
		MOBINDEX = "WarH_TDevildom",
		REGEN_POSITION = { X = 3819, Y = 12375, RADIUS = 300 },
		MOBCOUNT = 1,
	}
}

EVNET_DATA_NO2 =
{
	DEVILDOM =
	{
		MOBINDEX = "WarH_Devildom",
		REGEN =
		{
			{ MOBCOUNT = 5, POSITION = { X = 6932, Y = 11806, RADIUS = 450 } },
			{ MOBCOUNT = 5, POSITION = { X = 6938, Y = 12379, RADIUS = 450 } },
			{ MOBCOUNT = 5, POSITION = { X = 6939, Y = 12959, RADIUS = 450 } },
			{ MOBCOUNT = 2, POSITION = { X = 6735, Y = 13882, RADIUS = 300 } },
			{ MOBCOUNT = 2, POSITION = { X = 6735, Y = 11395, RADIUS = 300 } },
		}
	},

	HIGH_DEVILDOM =
	{
		MOBINDEX = "WarH_SDevildom",
		REGEN =
		{
			{ MOBCOUNT = 1, POSITION = { X = 6932, Y = 11806, RADIUS = 300 } },
			{ MOBCOUNT = 1, POSITION = { X = 6938, Y = 12379, RADIUS = 300 } },
			{ MOBCOUNT = 1, POSITION = { X = 6939, Y = 12959, RADIUS = 300 } },
			{ MOBCOUNT = 1, POSITION = { X = 6735, Y = 13882, RADIUS = 300 } },
			{ MOBCOUNT = 1, POSITION = { X = 6735, Y = 11395, RADIUS = 300 } },
		}
	},

	FMCORPS =
	{
		MOBINDEX = "WarH_FMCorps",
		REGEN =
		{
			{ MOBCOUNT = 3, POSITION = { X = 6922, Y = 11806, RADIUS = 200 } },
			{ MOBCOUNT = 3, POSITION = { X = 6928, Y = 12379, RADIUS = 200 } },
			{ MOBCOUNT = 3, POSITION = { X = 6929, Y = 12959, RADIUS = 200 } },
		}
	},

	SCITRIE 	=
	{
		MOBINDEX = "WarH_SCitrie",
		REGEN_POSITION =
		{
			{ X = 7894, Y = 12534, DIR = 270 },
		}
	},

	SFOCALOR 	= { MOBINDEX = "WarH_SFocalor", REGEN_POSITION = { X = 7894, Y = 12534, DIR = 270 } },
	SRANGE 		=
	{
		MOBINDEX = "WarH_SRange",
		REGEN_POSITION =
		{
			{ X = 7657, Y = 13079, DIR = 270 },
			{ X = 7657, Y = 11959, DIR = 270 },
		}
	},
	EVENT_DEVILDOM =
	{
		MOBINDEX = "WarH_Devildom",
		REGEN_POSITION = { X = 7349, Y = 12485, RADIUS = 200 },
		MOBCOUNT = 5,
	},

	EVENT_SDEVILDOM =
	{
		MOBINDEX = "WarH_SDevildom",
		REGEN_POSITION = { X = 7349, Y = 12485, RADIUS = 200 },
		MOBCOUNT = 1,
	}
}

EVNET_DATA_NO3 =
{
	DEVILDOM =
	{
		MOBINDEX = "WarH_Devildom",
		REGEN =
		{
			{ MOBCOUNT = 7, POSITION = { X = 11740, Y = 11897, RADIUS = 400 } },
			{ MOBCOUNT = 5, POSITION = { X = 11250, Y = 12546, RADIUS = 300 } },
			{ MOBCOUNT = 6, POSITION = { X = 11739, Y = 13172, RADIUS = 400 } },
			{ MOBCOUNT = 4, POSITION = { X = 11394, Y = 13523, RADIUS = 200 } },
			{ MOBCOUNT = 4, POSITION = { X = 11394, Y = 11468, RADIUS = 200 } },
		}
	},

	HIGH_DEVILDOM =
	{
		MOBINDEX = "WarH_IDevildom",
		REGEN =
		{
			{ MOBCOUNT = 1, POSITION = { X = 11740, Y = 11897, RADIUS = 400 } },
			{ MOBCOUNT = 2, POSITION = { X = 11250, Y = 12546, RADIUS = 300 } },
			{ MOBCOUNT = 1, POSITION = { X = 11739, Y = 13172, RADIUS = 400 } },
			{ MOBCOUNT = 1, POSITION = { X = 11394, Y = 13523, RADIUS = 200 } },
			{ MOBCOUNT = 2, POSITION = { X = 11394, Y = 11468, RADIUS = 200 } },
		}
	},

	FMCORPS =
	{
		MOBINDEX = "WarH_FMCorps",
		REGEN =
		{
			{ MOBCOUNT = 3, POSITION = { X = 11730, Y = 11897, RADIUS = 200 } },
			{ MOBCOUNT = 3, POSITION = { X = 11240, Y = 12546, RADIUS = 200 } },
			{ MOBCOUNT = 3, POSITION = { X = 11729, Y = 13172, RADIUS = 200 } },
		}
	},


	SCITRIE 	=
	{
		MOBINDEX = "WarH_ICitrie",
		REGEN_POSITION =
		{
			{ X = 12632, Y = 12552, DIR = 270 },
			{ X = 12632, Y = 12252, DIR = 270 },
		}
	},

	SFOCALOR 	= { MOBINDEX = "WarH_IFocalor", REGEN_POSITION = { X = 12632, Y = 12552, DIR = 270 } },

	SRANGE 		=
	{
		MOBINDEX = "WarH_IRange",
		REGEN_POSITION =
		{
			{ X = 12412, Y = 11851, DIR = 270 },
			{ X = 12412, Y = 13084, DIR = 270 },
			{ X = 11719, Y = 11281, DIR = 270 },
			{ X = 11719, Y = 13794, DIR = 270 },
		}
	},

	EVENT_DEVILDOM =
	{
		MOBINDEX = "WarH_Devildom",
		REGEN_POSITION = { X = 11771, Y = 12522, RADIUS = 300 },
		MOBCOUNT = 10,
	},

	EVENT_IDEVILDOM =
	{
		MOBINDEX = "WarH_IDevildom",
		REGEN_POSITION = { X = 11771, Y = 12522, RADIUS = 200 },
		MOBCOUNT = 1,
	},

	EVENT_IMELEE =
	{
		MOBINDEX = "WarH_IMelee",
		REGEN_POSITION = { X = 11771, Y = 12522, DIR = 270 },
	}
}

EVNET_DATA_NO4 =
{
	DEVILDOM =
	{
		MOBINDEX = "WarH_Devildom",
		REGEN =
		{
			{ MOBCOUNT = 5, POSITION = { X = 15985, Y = 11947, RADIUS = 300 } },
			{ MOBCOUNT = 6, POSITION = { X = 15834, Y = 12563, RADIUS = 400 } },
			{ MOBCOUNT = 7, POSITION = { X = 16037, Y = 13052, RADIUS = 450 } },
			{ MOBCOUNT = 5, POSITION = { X = 16397, Y = 11334, RADIUS = 300 } },
			{ MOBCOUNT = 8, POSITION = { X = 16397, Y = 13653, RADIUS = 400 } },
		}
	},

	HIGH_DEVILDOM =
	{
		MOBINDEX = "WarH_FDevildom",
		REGEN =
		{
			{ MOBCOUNT = 1, POSITION = { X = 15985, Y = 11947, RADIUS = 300 } },
			{ MOBCOUNT = 2, POSITION = { X = 15834, Y = 12563, RADIUS = 400 } },
			{ MOBCOUNT = 3, POSITION = { X = 16037, Y = 13052, RADIUS = 450 } },
			{ MOBCOUNT = 2, POSITION = { X = 16397, Y = 11334, RADIUS = 300 } },
			{ MOBCOUNT = 1, POSITION = { X = 16397, Y = 13653, RADIUS = 400 } },
		}
	},

	FMCORPS =
	{
		MOBINDEX = "WarH_FMCorps",
		REGEN =
		{
			{ MOBCOUNT = 4, POSITION = { X = 15975, Y = 11947, RADIUS = 400 } },
			{ MOBCOUNT = 4, POSITION = { X = 15824, Y = 12563, RADIUS = 400 } },
			{ MOBCOUNT = 4, POSITION = { X = 16027, Y = 13052, RADIUS = 400 } },
		}
	},

	SCITRIE 	=
	{
		MOBINDEX = "WarH_FCitrie",
		REGEN_POSITION =
		{
			{ X = 16817, Y = 12553, DIR = 270},
			{ X = 16855, Y = 12429, DIR = 270},
		}
	},

	SFOCALOR 	= { MOBINDEX = "WarH_FFocalor", REGEN_POSITION = { X = 16817, Y = 12553, DIR = 270} },
	SRANGE 		=
	{
		MOBINDEX = "WarH_FRange",
		REGEN_POSITION =
		{
			{ X = 16777, Y = 13439, DIR = 270 },
			{ X = 16817, Y = 11643, DIR = 270 },
			{ X = 16324, Y = 13024, DIR = 270 },
			{ X = 16324, Y = 11982, DIR = 270 },
			{ X = 16000, Y = 13439, DIR = 270 },
			{ X = 16000, Y = 11643, DIR = 270 },
		}
	},

	EVENT_DEVILDOM =
	{
		MOBINDEX = "WarH_Devildom",
		REGEN_POSITION = { X = 16203, Y = 12551, RADIUS = 400 },
		MOBCOUNT = 12,
	},

	EVENT_FDEVILDOM =
	{
		MOBINDEX = "WarH_FDevildom",
		REGEN_POSITION = { X = 16203, Y = 12551, RADIUS = 300 },
		MOBCOUNT = 4,
	},

	EVENT_FMELEE =
	{
		MOBINDEX			= "WarH_FMelee",
		REGEN_POSITION		=
		{
			{ X = 16192, Y = 12478, DIR = 270 },
			{ X = 16192, Y = 12623, DIR = 270 },
		},
		REVIVAL_POSITION 	= { X = 16192, Y = 12551, DIR = 270 }
	}
}

EVNET_DATA_NO5 =
{
	FAVANAS =
	{
		MOBINDEX 		= "WarH_FAvanas",
		REGEN_POSITION	= { X = 21641, Y = 12560, DIR = 270 },
		ANIMATION 		= "SW_FAvanas_Skill01_W_SS"
	},
	FAVANAS_GATE =
	{
		MOBINDEX		= "WarH_FAvanasGate",
		REGEN_POSITION	=
		{
			{ X = 22553, Y = 13084, DIR = -129 	},
			{ X = 22762, Y = 12829, DIR = -129 	},
			{ X = 22605, Y = 12226, DIR = -34 	},
			{ X = 22408, Y = 12076, DIR = -34 	},
			{ X = 22081, Y = 12094, DIR = 41 	},
			{ X = 21823, Y = 12277, DIR = 41 	},
			{ X = 21813, Y = 12825, DIR = 123 	},
			{ X = 21996, Y = 13095, DIR = 123 	}
		},
		DELAYTIME 		= 60,

		REGEN_MONSTER 	=
		{
			{ MOBINDEX = "WarH_FDevildom", 	REGEN_TIME = 18 },
			{ MOBINDEX = "WarH_TDevildom", 	REGEN_TIME = 18 },
			{ MOBINDEX = "WarH_FDevildom", 	REGEN_TIME = 18 },
		}
	}
}

-- 侩鞠单捞磐
BOMB_DATA =
{
	MOBINDEX 	= "WarH_FBomb",
	SKILLINDEX	= "WarH_FBomb_Skill01_W",
	RADIUS		= 100,
	REGEN_TIME	= 3,
	DELAY_TIME	= 2,
	DAMAGE		= 600,
}

EVNET_DATA 		= { }

EVNET_DATA[1] 	= EVNET_DATA_NO1
EVNET_DATA[2] 	= EVNET_DATA_NO2
EVNET_DATA[3] 	= EVNET_DATA_NO3
EVNET_DATA[4] 	= EVNET_DATA_NO4
EVNET_DATA[5] 	= EVNET_DATA_NO5

