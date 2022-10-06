require( "common" )

SCRIPT_MAIN        = "ID/WarLH/WarLH"	-- 스크립트



EVENT_ROUTINE_END 		= 999999
EM_STATE = { }

EM_STATE["Start"]	= 1
EM_STATE["Play"]	= 2
EM_STATE["End"]		= 3


ES_STATE = { }

ES_STATE["State1"] = 1
ES_STATE["State2"] = 2
ES_STATE["State3"] = 3
ES_STATE["State4"] = 4
ES_STATE["State5"] = 5
ES_STATE["State6"] = 6
ES_STATE["State7"] = 7
ES_STATE["State8"] = 8
ES_STATE["State9"] = 9
ES_STATE["State10"] = 10
ES_STATE["State11"] = 11
ES_STATE["State12"] = 12
ES_STATE["State13"] = 13
ES_STATE["State14"] = 14
ES_STATE["State15"] = 15
ES_STATE["State16"] = 16
ES_STATE["State17"] = 17
ES_STATE["State18"] = 18
ES_STATE["State19"] = 19
ES_STATE["State20"] = 20
ES_STATE["State21"] = 21
ES_STATE["State22"] = 22
ES_STATE["State23"] = 23





-- 포라스족장 상태
FC_STATE = { }
FC_STATE["Dialog1"] = 1
FC_STATE["Dialog2"] = 2
FC_STATE["Follow"] 	= 3


--마계병사 상태
D_STATE = { }
D_STATE["Aggro"]	= 1
D_STATE["Battle"]	= 2

--세뇌장치 상태
BW_SATATE = { }
BW_SATATE["BrainWash"] 	= 1
BW_SATATE["Damage1"]	= 2
BW_SATATE["Damage2"]	= 3
BW_SATATE["Damage3"]	= 4
BW_SATATE["Damage4"]	= 5
BW_SATATE["Damage5"]	= 6
BW_SATATE["End"]		= 7

PR_STATE = { }
PR_STATE["Normal"]	= 1
PR_STATE["Damage1"]	= 2
PR_STATE["Damage2"]	= 3
PR_STATE["Damage3"]	= 4

--작은방 상태
RS_STATE = { }
RS_STATE["Aggro"] 	= 1
RS_STATE["Battle"] 	= 2

--시트리 상태
CT_STATE = { }
CT_STATE["Aggro"] 	= 1
CT_STATE["Battle"] 	= 2

PF_STATE = { }
PF_STATE["STUN"] 	= 1
PF_STATE["RUNAWAY"] = 2
PF_STATE["END"]		= 3


STA_IMMORTAL     	= "StaImmortal"			-- 포라스 족장 / 잡혀있는 포라스 상태이상
STA_NEGLECT     	= "StaNeglect"			-- 동력석 / 세뇌장치 이벤트 상태이상
STATICDAMAGE		= 160					-- 동력석 / 세뇌장치 이벤트를 위한 스테이틱 데미지
STA_STUN			= "StaAdlFStun"
STA_BRAINWASH		= "StaWarLBrainWash"
DOOR_CHECK_TIME		= 2
DOOR_CHECK_TIME2	= 4

BASE_CAMERAMOVE_DATA =
{
	ABSTATE		= "StaAdlFStun",
	KEEPTIME 	= 5,
	ABSTATETIME = 10000
}

CITRIE_CAMERAMOVE		 	= { AngleY = 10, Distance = 500 }													-- 시트리 멀리서 보는 카메라
CITRIE_CAMERAMOVE2		 	= { AngleY = 23, Distance = 1500 }													-- 시트리 가까이서 보는 카메라
LINE_CAMERAMOVE 		 	= { AngleY = 15, Distance = 3000 }													-- 동력선 제거 카메라
DOOR1_CAMERAMOVE 		 	= { AngleY = 20, Distance = 3000 }													-- 첫번째 문 카메라 무브
DOOR_CAMERAMOVE 		 	= { AngleY = 23, Distance = 3000 }													-- 2, 3번째 문 / 동력석 카메라
BRAINWASH_CAMERAMOVE 	 	= { AngleY = 30, Distance = 4000, KEEPTIME = 5 }									-- 세뇌장치 카메라
BRAINWASH_CAMERAMOVE_DAMGE 	= { ABSTATE	= "StaStunCanAttack", AngleY = 25, Distance = 1800, KEEPTIME = 5 }		-- 세뇌장치 이벤트


LINE_DATA =
{
	LEFT_POSITION 	= { X = 11000, Y = 8384, DIR = 45 },
	RIGHT_POSITION 	= { X = 11000, Y = 5573, DIR = 135 }
}


NOTICEINFO =
{
	{ FILENAME = "WarL", INDEX = "Notice_01", DELAYTIME = 0 },
	{ FILENAME = "WarL", INDEX = "Notice_02", DELAYTIME = 0 },
	{ FILENAME = "WarL", INDEX = "Notice_03", DELAYTIME = 0 }
}


DOOR_BLOCK_DATA =
{
	{
		DOOR_INDEX 		= "WarLH_Door1",
		DOOR_BLOCK		= "Door01",
		REGEN_POSITION 	= { X = 6331, Y = 6993, DIR = 90 }
	},
	{
		DOOR_INDEX 		= "WarLH_Door2",
		DOOR_BLOCK		= "Door02",
		REGEN_POSITION 	= { X = 8478, Y = 8384, DIR = 0 }
	},
	{
		DOOR_INDEX 		= "WarLH_Door2",
		DOOR_BLOCK		= "Door03",
		REGEN_POSITION 	= { X = 8478, Y = 5573, DIR = 180 }
	},
	{
		DOOR_INDEX 		= "GuildGate00",
		DOOR_BLOCK		= "WarL_Pore01",
		REGEN_POSITION 	= { X = 0, Y = 0, DIR = 0 }
	},
	{
		DOOR_INDEX 		= "GuildGate00",
		DOOR_BLOCK		= "WarL_Pore02",
		REGEN_POSITION 	= { X = 0, Y = 0, DIR = 0}
	}

}

GATE_DATA =
{
	START_GATE =
	{
		GATE_INDEX 		= "DT_ExitGate",
		REGEN_POSITION 	= { X = 2225, Y = 6947, DIR = -91 },
		LINK     		= { FIELD = "EldGbl02", X = 9757, Y = 6171 }
	},

	END_GATE =
	{
		GATE_INDEX 		= "DT_ExitGate",
		REGEN_POSITION 	= { X = 11014, Y = 6988, DIR = 89 },
		LINK     		= { FIELD = "EldGbl02", X = 9757, Y = 6171 }
	}
}

GATE_TITLE =
{
	Start 	= { Title = "Exit Gate", Yes = "Exit", No = "Cancel" },
	End		= { Title = "Exit Gate", Yes = "Exit", No = "Cancel" }
}

DIALOGINFO		=
{
	{ FACECUT = "WarL_ForasChief", FILENAME = "WarL", INDEX = "ForasC_01", DELAY = 2 },
	{ FACECUT = "WarL_ForasChief", FILENAME = "WarL", INDEX = "ForasC_02", DELAY = 2 },
	{ FACECUT = "WarL_ForasChief", FILENAME = "WarL", INDEX = "ForasC_03", DELAY = 2 },
	{ FACECUT = "WarL_ForasChief", FILENAME = "WarL", INDEX = "ForasC_04", DELAY = 2 },
	{ FACECUT = "WarL_ForasChief", FILENAME = "WarL", INDEX = "ForasC_05", DELAY = 2 },
	{ FACECUT = "WarL_ForasChief", FILENAME = "WarL", INDEX = "ForasC_06", DELAY = 2 },
	{ FACECUT = "WarL_ForasChief", FILENAME = "WarL", INDEX = "ForasC_07", DELAY = 2 },
	{ FACECUT = "WarL_ForasChief", FILENAME = "WarL", INDEX = "ForasC_08", DELAY = 2 },
	{ FACECUT = "WarL_ForasChief", FILENAME = "WarL", INDEX = "ForasC_09", DELAY = 2 },
	{ FACECUT = "WarL_ForasChief", FILENAME = "WarL", INDEX = "ForasC_10", DELAY = 2 },
	{ FACECUT = "WarL_ForasChief", FILENAME = "WarL", INDEX = "ForasC_11", DELAY = 2 },
	{ FACECUT = "WarL_ForasChief", FILENAME = "WarL", INDEX = "ForasC_12", DELAY = 2 }
}



MAP_MARK_DATA =
{
	LINKTOWN	= { GROUP = 100, KEEPTIME = 99999999, ICON = "LinkTown" 	},
	DOOR		= { GROUP = 300, KEEPTIME = 99999999, ICON = "Gate"			}
}

EVNET_DATA_NO1 =
{
	FORASCHIEF =
	{
		MOBINDEX		= "WarLH_ForasChief",
		REGENPOSITION	= { X = 3377, Y = 6955, DIR = 88 },
		FOLLOWDISTANCE	= 200,
		DELAYTIME		= 10
	}
}

EVNET_DATA_NO2 =
{
	DAVILDOM =
	{
		MOBINDEX		= "WarLH_Devildom",
		MOBCOUNT		= 5,
		AGGRO_DISTANCE	= 300,
		SEARCH_RANGE	= 5000,
		REGENPOSITION 	= { X = 5884, Y = 6985, RADIUS = 300 }
	},
}

EVNET_DATA_NO3 =
{
	DAVILDOM =
	{
		MOBINDEX		= "WarLH_Foras",
		MOBCOUNT		= 5,
		AGGRO_DISTANCE	= 300,
		SEARCH_RANGE	= 5000,
		REGENPOSITION 	= { X = 5884, Y = 6985, RADIUS = 300 }
	}
}

EVNET_DATA_NO4 =
{
	BRAINWASH =
	{
		MOBINDEX		= "WarLH_BrainWash",
		REGENPOSITION	= { X = 10912, Y = 6995, DIR = -90 },
		DAMAGE			= { 85, 65, 45, 25, 5 }
	},

	DAVILDOM =
	{
		MOBINDEX		= "WarLH_Devildom",
		MOBCOUNT		= 10,
		AGGRO_DISTANCE	= 300,
		SEARCH_RANGE	= 7000,
		DELAYTIME 		= 5,
		REGENPOSITION 	= { X = 9000, Y = 6988 }
	},

	PFORAS =
	{
		{ MOBINDEX = "WarLH_PForas", REGENPOSITION = { X = 11523, Y = 6977, DIR = 256  } },
		{ MOBINDEX = "WarLH_PForas", REGENPOSITION = { X = 11619, Y = 6977, DIR = 256  } },
		{ MOBINDEX = "WarLH_PForas", REGENPOSITION = { X = 11707, Y = 6977, DIR = 256  } },
		{ MOBINDEX = "WarLH_PForas", REGENPOSITION = { X = 11479, Y = 7215, DIR = 256  } },
		{ MOBINDEX = "WarLH_PForas", REGENPOSITION = { X = 11562, Y = 7255, DIR = 256  } },
		{ MOBINDEX = "WarLH_PForas", REGENPOSITION = { X = 11659, Y = 7292, DIR = 256  } },
		{ MOBINDEX = "WarLH_PForas", REGENPOSITION = { X = 11368, Y = 7440, DIR = 256  } },
		{ MOBINDEX = "WarLH_PForas", REGENPOSITION = { X = 11431, Y = 7494, DIR = 256  } },
		{ MOBINDEX = "WarLH_PForas", REGENPOSITION = { X = 11506, Y = 7554, DIR = 256  } },
		{ MOBINDEX = "WarLH_PForas", REGENPOSITION = { X = 11489, Y = 6734, DIR = 289 } },
		{ MOBINDEX = "WarLH_PForas", REGENPOSITION = { X = 11566, Y = 6708, DIR = 289 } },
		{ MOBINDEX = "WarLH_PForas", REGENPOSITION = { X = 11655, Y = 6668, DIR = 289 } },
		{ MOBINDEX = "WarLH_PForas", REGENPOSITION = { X = 11368, Y = 6528, DIR = 289 } },
		{ MOBINDEX = "WarLH_PForas", REGENPOSITION = { X = 11441, Y = 6474, DIR = 289 } },
		{ MOBINDEX = "WarLH_PForas", REGENPOSITION = { X = 11514, Y = 6421, DIR = 289 } },
	}
}

EVNET_DATA_NO5 =
{
	PORE =
	{
		MOBINDEX		= "WarLH_Pore",
		REGENPOSITION	= { X = 9901, Y = 9375, DIR = -90 },
		DAMAGE			= { 65, 35, 5}
	},

	DAVILDOM =
	{
		MOBINDEX		= "WarLH_Devildom",
		MOBCOUNT		= 5,
		REGENPOSITION 	= { X = 9100, Y = 9365, RADIUS = 500 },
		AGGRO_RANGE		= 700
	},

	FORAS =
	{
		MOBINDEX		= "WarLH_Foras",
		MOBCOUNT		= 5,
		REGENPOSITION 	= { X = 9100, Y = 9365, RADIUS = 500 },
		AGGRO_RANGE		= 700
	}
}

EVNET_DATA_NO6 =
{
	CITRIE =
	{
		MOBINDEX		= "WarLH_FCitrie",
		REGENPOSITION	= { X = 8694, Y = 7078, DIR = 270 },
		AGGRO_RANGE		= 700
	},

	DAVILDOM =
	{
		MOBINDEX		= "WarLH_Devildom",
		AGGRO_DISTANCE	= 300,
		SEARCH_RANGE	= 4000,
		DELAYTIME 		= 15,
		REGENPOSITION 	= { X = 9000, Y = 6988 }
	}
}

EVNET_DATA_NO7 =
{
	PORE =
	{
		MOBINDEX		= "WarLH_Pore",
		REGENPOSITION	= { X = 9901, Y = 4610, DIR = -90 },
		DAMAGE			= { 65, 35, 5 }
	},

	DAVILDOM =
	{
		MOBINDEX		= "WarLH_Devildom",
		MOBCOUNT		= 5,
		REGENPOSITION 	= { X = 9000, Y = 4575, RADIUS = 500 },
		AGGRO_RANGE		= 700
	},

	FORAS =
	{
		MOBINDEX		= "WarLH_Foras",
		MOBCOUNT		= 5,
		REGENPOSITION 	= { X = 9000, Y = 4575, RADIUS = 500 },
		AGGRO_RANGE		= 700
	}
}

EVNET_DATA_NO8 =
{
	CITRIE =
	{
		MOBINDEX		= "WarLH_TCitrie",
		REGENPOSITION	= { X = 10002, Y = 7006, DIR = 270 },
		AGGRO_RANGE		= 700
	},

	DAVILDOM =
	{
		MOBINDEX		= "WarLH_Devildom",
		AGGRO_DISTANCE	= 300,
		SEARCH_RANGE	= 4000,
		DELAYTIME 		= 10,
		REGENPOSITION 	= { X = 10212, Y = 6988 }
	}
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
EVENT_ENDING_DATA =
{
	-- 인던 종료
	KQReturn =
	{
		{ FileName = "WarL", Index = "KQReturn60", WaitTime = 30, },
		{ FileName = "WarL", Index = "KQReturn30", WaitTime = 10, },
		{ FileName = "WarL", Index = "KQReturn20", WaitTime = 10, },
		{ FileName = "WarL", Index = "KQReturn10", WaitTime =  5, },
		{ FileName = "WarL", Index = "KQReturn5",  WaitTime =  5, },
	}
}


EVNET_DATA 		= { }
EVNET_DATA[1]	= EVNET_DATA_NO1
EVNET_DATA[2]	= EVNET_DATA_NO2
EVNET_DATA[3]	= EVNET_DATA_NO3
EVNET_DATA[4]	= EVNET_DATA_NO4
EVNET_DATA[5]	= EVNET_DATA_NO5
EVNET_DATA[6]	= EVNET_DATA_NO6
EVNET_DATA[7]	= EVNET_DATA_NO7
EVNET_DATA[8]	= EVNET_DATA_NO8
EVNET_DATA[9]	= EVNET_DATA_NO9
