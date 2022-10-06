require( "common" )


SCRIPT_MAIN        = "ID/WarBL/WarBL"	-- 스크립트

-- 메인루틴 상태
MRE_START	= 1
MRE_PLAY	= 2
MRE_END		= 3

-- 룸 이벤트 상태 ( 각 룸마다 공통으로 사용하기 위해서 범용적인 이름 사용)
RE_STATE_1 	= 1
RE_STATE_2 	= 2
RE_STATE_3 	= 3
RE_STATE_4 	= 4
RE_STATE_5 	= 5
RE_STATE_6 	= 6
RE_STATE_7 	= 7
RE_STATE_8 	= 8
RE_STATE_9 	= 9
RE_STATE_10 = 10
RE_STATE_11 = 11


-- 룸1 포라스리스트 상태
FL_SEARCH			= 1
FL_SEARCH_SUCCESS	= 2
FL_SURPRISE			= 3
FL_ESCAPE			= 4
FL_REMOVE			= 5

-- 룸 1 마계병사 상태
D_Normal			= 1
D_Aggro				= 2

-- 룸3 포라스 그룹 상태
FG_WORKING		= 1
FG_ESCAPE		= 2
FG_REMOVE		= 3


-- 룸3 마계병사 그룹 상태
DG_NORMAL		= 1
DG_AGGRO		= 2
DG_AGGRO_SUCC	= 3
DG_END			= 4

-- 마계병사 상태
D_NORMAL		= 1
D_AGGRO			= 2
D_Aggro_SUCC	= 3
D_AnimateStart	= 4
D_END			= 5

-- 포라스 족장 상태
FC_NORMAL		= 1
FC_IDLE			= 2
FC_DAMAGE		= 3
FC_FOLLOW		= 4
FC_REMOVE		= 5
FC_MOVE			= 6

--시트리 상태
C_HP_90_UNDER	= 1
C_HP_60_UNDER	= 2
C_HP_30_UNDER	= 3
C_NORMAL		= 4
C_END			= 5


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    초기화							-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
EVENT_ROUTINE_END 		= 999999
EVNET_DATA_END_NUMBER 	= 6 -- 마지막 이벤트 번호
STA_IMMORTAL      		= "StaImmortal"
STA_STUN				= "StaAdlFStun"
STA_SURPRISE			= "StaSurprise"
DOOR_CHECK_TIME			= 2


FORAS_CAMERAMOVE =
{
	AngleY 			= 7,
	Distance		= 300,
	KeepTime		= 4,
	AbstateIndex	= "StaAdlFStun",
	AbstateTime		= 10000
}


DOOR_CAMERAMOVE =
{
	AngleY 			= 12,
	Distance		= 1200,
	KeepTime		= 5,
	AbstateIndex	= "StaAdlFStun",
	AbstateTime		= 10000
}

EVENT4_CAMERAMOVE =
{
	AngleY 			= 15,
	Distance		= 700,
	KeepTime		= 5,
	AbstateIndex	= "StaAdlFStun",
	AbstateTime		= 10000
}

ENDING_CAMERAMOVE =
{
	AngleY 			= 7,
	Distance		= 300,
	KeepTime		= 6,
	AbstateIndex	= "StaAdlFStun",
	AbstateTime		= 100000
}


PRIORITY_CLASS = {}


PRIORITY_CLASS[BasicClass["Fighter"]] 	= 1
PRIORITY_CLASS[BasicClass["Cleric"]] 	= 2
PRIORITY_CLASS[BasicClass["Joker"]] 	= 3
PRIORITY_CLASS[BasicClass["Archer"]] 	= 4
PRIORITY_CLASS[BasicClass["Mage"]] 		= 5



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --				    NOTICE DATA							-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

NOTICE_INFO =
{
	{ FileName = "WarBL", Index = "Notice_01", DelayTime = 3 },
	{ FileName = "WarBL", Index = "Notice_02", DelayTime = 0 }
}

DialogInfo =
{
	{ Facecut = "WarBL_SCitrie", FileName = "WarBL", Index = "Boss_01" },
	{ Facecut = "WarBL_SCitrie", FileName = "WarBL", Index = "Boss_02" },
	{ Facecut = "WarBL_SCitrie", FileName = "WarBL", Index = "Boss_03" }
}



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --				   GATE & DOOR BLOCK					-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

DOOR_BLOCK_DATA =
{
	{
		DOOR_INDEX 		= "WarBL_Door1",
		DOOR_BLOCK		= "Door01",
		REGEN_POSITION 	= { X = 1399, Y = 5704, DIR = 0 }
	},
	{
		DOOR_INDEX 		= "WarBL_Door1",
		DOOR_BLOCK		= "Door02",
		REGEN_POSITION 	= { X = 2236, Y = 6518, DIR = -90 }
	},
	{
		DOOR_INDEX 		= "WarBL_Door2",
		DOOR_BLOCK		= "Door03",
		REGEN_POSITION 	= { X = 4934, Y = 1740, DIR = -136 }
	}
}

GATE_DATA =
{
	START_GATE =
	{
		GATE_INDEX 		= "DT_ExitGate",
		REGEN_POSITION 	= { X = 1319, Y = 1262, DIR = 178 },
		LINK     		= { FIELD = "Linkfield01", X = 2209, Y = 9846 }
	},

	END_GATE =
	{
		GATE_INDEX 		= "DT_ExitGate",
		REGEN_POSITION 	= { X = 3982, Y = 783, DIR = -136 },
		LINK     		= { FIELD = "Linkfield01", X = 2209, Y = 9846 }
	},

	MIDDLE_GATE =
	{
		GATE_INDEX 		= "MapLinkGate",
		REGEN_POSITION 	= { X = 1028, Y = 1696, DIR = 268 },
		LINK     		=
		{
			{ X = 1403, Y =  6502 },
			{ X = 7001, Y =  3674 },
		}
	}
}

GATE_TITLE =
{
	Start 	= { Title = "Exit Gate", Yes = "Exit", No = "Cancel" },
	Middle 	= { Title = "Exit Gate", Yes = "Exit", No = "Cancel" },
	End		= { Title = "Exit Gate", Yes = "Exit", No = "Cancel" }
}

MAP_MARK_DATA =
{
	LINKTOWN	= { GROUP = 100, KEEPTIME = 99999999, ICON = "LinkTown" },
	DOOR		= { GROUP = 300, KEEPTIME = 99999999, ICON = "Gate"		}
}



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 1							-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


MOVE_INTERVER	= 10


EVENT_ROOM_ONE_DATA =
{
	ENVENT_FORAS =
	{
		MOB_INDEX		= "WarBL_Foras",
		SEARCH_RANGE	= 800,
		MOB_CHAT		= "Mob_04",
		ANIMATION		= "Foras_Mining",
		SURPRISE_DELAY 	= 5,

		FORAS_POSITION 	=
		{
			{ REGEN_POS = { X = 889, Y = 3659, DIR = 301 }, 	PATH = { { X = 1288, Y = 4151 }, { X = 1392, Y = 5343 } } },
			{ REGEN_POS = { X = 727, Y = 3233, DIR = 245 },		PATH = { { X = 1407, Y = 4013 }, { X = 1392, Y = 5343 } } },
			{ REGEN_POS = { X = 1986, Y = 3557, DIR = 97 },		PATH = { { X = 1518, Y = 4201 }, { X = 1392, Y = 5343 } } }
		},

		MOB_CHAT =
		{
			INDEX = { "Mob_01", "Mob_02", "Mob_03", "Mob_04", "Mob_05" },
			DELAY = 5
		}
	},

	EVNET_DAVILDOM =
	{
		MOB_INDEX			= "WarBL_Devildom",
		MOB_TOTAL_COUNT		= 5,
		REGEN_DELAY_TIME	= 1,
		BATTLE_DELAY_TIME	= 3,
		SEARCH_RANGE		= 500,

		DAVILDOM_POSITION =
		{
			START_POSITION 	= { X = 1407, Y = 4013, DIR = 121 },
			END_POSITION	= { X = 1384, Y = 3504 }
		}
	},
}


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 2							-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

EVENT_ROOM_TWO_DATA =
{
	ROOM_CITRIE =
	{
		MOB_INDEX 		= "WarBL_ICitrie",
		START_POSITION	= { X =1396, Y = 6529, DIR = 0 }
	}
}


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 3							-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

EVENT_ROOM_THREE_DATA =
{
	EVENT_FORAS 	=
	{
		MOB_INDEX		= "WarBL_Foras",
		MOB_CHAT		= "Mob_05",
		ANIMATION		= "Foras_Mining",

		Group =
		{
			{
				{ REGEN_POS = { X = 4798, Y = 7497, DIR = 6 } },
				{ REGEN_POS = { X = 4976, Y = 7544, DIR = 10 } },
				{ REGEN_POS = { X = 5106, Y = 7666, DIR = 298 } }
			},
			{
				{ REGEN_POS = { X = 5773, Y = 5114, DIR = 131 } },
				{ REGEN_POS = { X = 5587, Y = 4840, DIR = 110 } }
			},
			{
				{ REGEN_POS = { X = 8907, Y = 7564, DIR = 43 } },
				{ REGEN_POS = { X = 6082, Y = 7421, DIR = 20 } }
			}
		},

		PATH =
		{
			{ X = 6505, Y = 6281 },
			{ X = 7244, Y = 5555 }
		}
	},

	EVENT_DAVILDOM =
	{
		MOB_INDEX		= "WarBL_Devildom",
		MOB_CHAT		= "Mob_04",
		ANIMATION		= "DT_Devildom_Atk2",
		AGGRO_POINT		= 50,
		SEARCH_RANGE	= 1000,

		Group =
		{

			{
				{ REGEN_POS = { X = 5035, Y = 7454, DIR = 10 }, ANIMATION = 1 },
				{ REGEN_POS = { X = 4759, Y = 7242, DIR = 10 }, ANIMATION = 0 },
				{ REGEN_POS = { X = 4982, Y = 7294, DIR = 10 }, ANIMATION = 0 },
				{ REGEN_POS = { X = 5187, Y = 7371, DIR = 10 }, ANIMATION = 0 },
				{ REGEN_POS = { X = 5296, Y = 7497, DIR = 10 }, ANIMATION = 0 }
			},
			{
				{ REGEN_POS = { X = 5696, Y = 5177, DIR = 129 }, ANIMATION = 1 },
				{ REGEN_POS = { X = 5512, Y = 4881, DIR = 113 }, ANIMATION = 1 },
				{ REGEN_POS = { X = 5670, Y = 4968, DIR = 304 }, ANIMATION = 0 },
				{ REGEN_POS = { X = 5533, Y = 5092, DIR = 124 }, ANIMATION = 0 }
			},
			{
				{ REGEN_POS = { X = 5845, Y = 7488, DIR = 53 }, ANIMATION = 1 },
				{ REGEN_POS = { X = 6043, Y = 7326, DIR = 20 }, ANIMATION = 1 },
				{ REGEN_POS = { X = 5975, Y = 7443, DIR = 30 }, ANIMATION = 0 }
			}
		}
	},


	REGEN_DAVILDOM =
	{
		MOB_INDEX			= "WarBL_Devildom",
		MOB_COUNT 			= { 5, 10 },
		CENTER_POSITION		= { X = 6960, Y = 6129, RADIUS = 300 },
		AGGRO_POINT			= 50,
		AGGRO_DISTANCE		= 300,
		SEARCH_RANGE		= 2800
	}
}



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 4							-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

EVENT_ROOM_FOUR_DATA =
{
	FORAS_CHIEF =
	{
		MOB_INDEX				= "WarBL_ForasChief",
		REGEN_POSITION 			= { X = 7041, Y = 3681, DIR = 223 },
		END_POSITION			= { X = 7088, Y = 6099 },
		ANIMATION				= { DAMAGE = "ForasChief_Dmg2", IDLE = "ForasChief_Idle" },
		MASKITEM				= "Mask_Foras01",
		MOB_CHAT				= { "Foras_01", "Foras_02" },

		FOLLOW_DATA				=
		{
			RANGE 		= 200,
			MASTERHP	= 50,
			HEALAMOUNT	= 40,
			COOLTIME	= 5,
			ANIMATION	= "ForasChief_attack"
		}
	},

	EVENT_DAVILDOM =
	{
		MOB_INDEX				= "WarBL_Devildom",

		DAVILDOM_POSITION =
		{
			{ X = 7049, Y = 3752, DIR = 180	},
			{ X = 6993, Y = 3792, DIR = 134 },
			{ X = 6960, Y = 3677, DIR = 103 },
			{ X = 6987, Y = 3628, DIR = 41 },
			{ X = 7045, Y = 3613, DIR = 31 },
			{ X = 7101, Y = 3671, DIR = 281 }
		},

		ANIMATION				= "DT_Devildom_Atk2"
	},
}


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    보스방							-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

EVENT_ROOM_BOSS_DATA =
{
	SCITRIE =
	{
		MOB_INDEX			= "WarBL_SCitrie",
		REGEN_POSITION 		= { X = 4328, Y = 1142, DIR = -136 },

		SUMMON				=
		{
			MOB_INDEX 	= "WarBL_Devildom",
			RADIUS		= 400
		},

		AI_DATA =
		{
			{ HP = 90, REGEN_NUM = 3 },
			{ HP = 60, REGEN_NUM = 6 },
			{ HP = 30, REGEN_NUM = 9 }
		}
	},

	FORAS_CHIEF =
	{
		MOB_INDEX			= "WarBL_ForasChief",
		MOB_CHAT			=

		{
			INDEX = {"Foras_03", "Foras_04"},
			DELAY = 2
		},

		START_POSITION 		= { X = 4920, Y = 1734, DIR = 45 },
		END_POSITION		= { X = 4663, Y = 1450, DIR = 0 }
	}
}


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    엔딩							-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
EVENT_ENDING_DATA =
{
	-- 인던 종료
	KQReturn =
	{
		{ FileName = "WarBL", Index = "KQReturn60", WaitTime = 30, },
		{ FileName = "WarBL", Index = "KQReturn30", WaitTime = 10, },
		{ FileName = "WarBL", Index = "KQReturn20", WaitTime = 10, },
		{ FileName = "WarBL", Index = "KQReturn10", WaitTime =  5, },
		{ FileName = "WarBL", Index = "KQReturn5",  WaitTime =  5, },
	}
}





EVENT_ROOM_DATA = { }


EVENT_ROOM_DATA[1] = EVENT_ROOM_ONE_DATA
EVENT_ROOM_DATA[2] = EVENT_ROOM_TWO_DATA
EVENT_ROOM_DATA[3] = EVENT_ROOM_THREE_DATA
EVENT_ROOM_DATA[4] = EVENT_ROOM_FOUR_DATA
EVENT_ROOM_DATA[5] = EVENT_ROOM_BOSS_DATA
EVENT_ROOM_DATA[6] = EVENT_ENDING_DATA

