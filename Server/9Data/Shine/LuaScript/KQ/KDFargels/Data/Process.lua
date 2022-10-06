--------------------------------------------------------------------------------
--                        KDFargels Process Data                              --
--------------------------------------------------------------------------------
--require( "KQ/KDFargels/Data/Regen" )

LINK_INFO =
{
	RETURNMAP1 = { MAP_INDEX = "Gate", X = 1487, Y = 1517 },
}

--REWARD_INFO =
--{
	--{ REWARD_INDEX = "REW_KQ_FARGELS" },
--}

-- PS script에서 있던 것을 옮겨오는 용도
QuestMobKillInfo =
{
	QuestID  		= 2668,
	MobIndex 		= "Daliy_Check",
	MaxKillCount 	= 1,
}

CAMERA_STATE = { }
CAMERA_STATE["NORMAL"] 		= 1
CAMERA_STATE["MOVE"] 		= 2
CAMERA_STATE["REMOVE"] 		= 3
CAMERA_STATE["NEXT_STEP"]	= 4

EM_STATE = { }
EM_STATE["Start"]	= 1
EM_STATE["Play"]	= 2
EM_STATE["End"]		= 3

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

EVENT_ROUTINE_END		= 999999
EVENT_GAME_OVER			= false

DOOR_BLOCK_DATA =
{
	{ DOOR_INDEX = "KDFargels_Door", DOOR_BLOCK = "CloseGate01", REGEN_POSITION = { X = 9997, 	Y = 1196, DIR = 270 }, SCALE = 1000 },
	{ DOOR_INDEX = "KDFargels_Door", DOOR_BLOCK = "CloseGate02", REGEN_POSITION = { X = 1354, 	Y = 3942, DIR = 0 	}, SCALE = 1000 },
	{ DOOR_INDEX = "KDFargels_Door", DOOR_BLOCK = "CloseGate03", REGEN_POSITION = { X = 2234, 	Y = 7581, DIR = 90 	}, SCALE = 1000 },
	{ DOOR_INDEX = "KDFargels_Door", DOOR_BLOCK = "CloseGate04", REGEN_POSITION = { X = 8475, 	Y = 9109, DIR = 54 	}, SCALE = 1500 },
}

CAMERAMOVE_DATA =
{
-- 입장 지역
	{ AngleY = 10, Distance = 1200, KeepTime = 5, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },

-- 1 지역
	{ AngleY = 10, Distance = 1200, KeepTime = 5, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },

-- 2 지역
	{ AngleY = 10, Distance = 1200, KeepTime = 5, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },


-- 3 지역
	{ AngleY = 20, Distance = 2000, KeepTime = 5, AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },

-- 4 지역
	{ AngleY = 30, Distance = 1200, KeepTime = 10,AbstateIndex = "StaAdlFStun", AbstateTime = 10000 },
}

DIALOG_DATA =
{
-- 입장 지역
	{ FACECUT = "KDFargels_Torin", 	FILENAME = "KDFargels", INDEX = "Torin_FC01", 	DELAY = 5 },
	{ FACECUT = "KDFargels_Torin", 	FILENAME = "KDFargels", INDEX = "Torin_FC02", 	DELAY = 5 },
	{ FACECUT = "KDFargels_Torin", 	FILENAME = "KDFargels", INDEX = "Torin_FC03", 	DELAY = 5 },
	{ FACECUT = "DarkFog", 	FILENAME = "KDFargels", INDEX = "Dlich_FC01", 	DELAY = 5 },

-- 1 지역
	{ FACECUT = "DarkFog", 	FILENAME = "KDFargels", INDEX = "Dlich_FC02", 	DELAY = 5 },

-- 2 지역
	{ FACECUT = "DarkFog", 	FILENAME = "KDFargels", INDEX = "Dlich_FC03", 	DELAY = 5 },
	{ FACECUT = "KDFargels_Torin", 	FILENAME = "KDFargels", INDEX = "Torin_FC04", 	DELAY = 5 },

-- 3 지역
	{ FACECUT = "KDFargels_Wizard", FILENAME = "KDFargels", INDEX = "Wizard_FC01", 	DELAY = 4 },
	{ FACECUT = "KDFargels_Wizard", FILENAME = "KDFargels", INDEX = "Wizard_FC02", 	DELAY = 4 },
	{ FACECUT = "KDFargels", 		FILENAME = "KDFargels", INDEX = "Fargels_FC01",	DELAY = 4 },
	{ FACECUT = "KDFargels_Wizard", FILENAME = "KDFargels", INDEX = "Wizard_FC03", 	DELAY = 4 },
	{ FACECUT = "KDFargels_Epis", 	FILENAME = "KDFargels", INDEX = "Epis_FC01", 	DELAY = 4 },
	{ FACECUT = "KDFargels", 		FILENAME = "KDFargels", INDEX = "Fargels_FC02", DELAY = 4 },
	{ FACECUT = "KDFargels_Torin", 	FILENAME = "KDFargels", INDEX = "Torin_FC05", 	DELAY = 4 },

	{ FACECUT = "KDFargels_Epis", 	FILENAME = "KDFargels", INDEX = "Epis_FC03", 	DELAY = 4 },
	{ FACECUT = "KDFargels", 		FILENAME = "KDFargels", INDEX = "Fargels_FC03", DELAY = 4 },
	{ FACECUT = "KDFargels_Wizard", FILENAME = "KDFargels", INDEX = "Wizard_FC04", 	DELAY = 4 },
	{ FACECUT = "KDFargels", 		FILENAME = "KDFargels", INDEX = "Fargels_FC04", DELAY = 4 },

-- 4 지역
	{ FACECUT = "KDFargels", 		FILENAME = "KDFargels", INDEX = "Fargels_FC05", DELAY = 4 },
	{ FACECUT = "KDFargels_Wizard", FILENAME = "KDFargels", INDEX = "Wizard_FC06", 	DELAY = 4 },
	{ FACECUT = "KDFargels_Torin", 	FILENAME = "KDFargels", INDEX = "Torin_FC06", 	DELAY = 4 },

-- 종료
	{ FACECUT = nil, 				FILENAME = "KDFargels", INDEX = "KQReturn30", 	DELAY = 10 },
	{ FACECUT = nil, 				FILENAME = "KDFargels", INDEX = "KQReturn20", 	DELAY = 10 },
	{ FACECUT = nil, 				FILENAME = "KDFargels", INDEX = "KQReturn10", 	DELAY = 5  },
	{ FACECUT = nil, 				FILENAME = "KDFargels", INDEX = "KQReturn5", 	DELAY = 5  },
}

-- 입장 지역
EVENT_DATA_NO1 =
{
	-- 파겔스 소환
	FARGELS =
	{
		{ MOBINDEX = "KDFargels", 		X = 10764, Y = 1080, DIR = 234 },
	},

	-- 토린
	TORIN =
	{
		{ MOBINDEX = "KDFargels_Torin", X = 10764, Y = 1080, DIR = 270 },
	},

	-- 다크 리치
	DLICH =
	{
		{ MOBINDEX = "KDFargels_DLich", X = 10225, Y = 1198, DIR = 90 },
	},
}

-- 1 지역
EVENT_DATA_NO2 =
{
	-- 리젠 오브젝트
	REGENOBJECT =
	{
		-- REGEN_CONDITION 	: SENSOR(RANGE범위만큼 감지하여 리젠), REMOVE(파괴될때 리젠), NORMAL(조건없이 리젠)
		-- REGEN_DATA		: REGEN_DATA 참조

		-- 감시 초소

		{ MOBINDEX = "InvisibleMan", 	X = 8035, Y = 787,  DIR = 0, RANGE = 500, 	REGEN_CONDITION = REGEN_CONDITION["SENSOR"], REGEN_DATA = REGEN_DATA["REGEN1"] },
		{ MOBINDEX = "InvisibleMan", 	X = 6052, Y = 1756, DIR = 0, RANGE = 500, 	REGEN_CONDITION = REGEN_CONDITION["SENSOR"], REGEN_DATA = REGEN_DATA["REGEN2"] },
		{ MOBINDEX = "InvisibleMan", 	X = 3829, Y = 1038, DIR = 0, RANGE = 500, 	REGEN_CONDITION = REGEN_CONDITION["SENSOR"], REGEN_DATA = REGEN_DATA["REGEN3"] },
		{ MOBINDEX = "InvisibleMan", 	X = 3065, Y = 2993, DIR = 0, RANGE = 500, 	REGEN_CONDITION = REGEN_CONDITION["SENSOR"], REGEN_DATA = REGEN_DATA["REGEN4"] },
		{ MOBINDEX = "InvisibleMan", 	X = 1634, Y = 1510, DIR = 0, RANGE = 500, 	REGEN_CONDITION = REGEN_CONDITION["SENSOR"], REGEN_DATA = REGEN_DATA["REGEN5"] },

		-- 케이지
		{ MOBINDEX = "KDFargels_Cage", 	X = 8209, Y = 1739, DIR = 270, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["REMOVE"], REGEN_DATA = REGEN_DATA["REGEN6"], REGEN_DIALOG_DATA = REGEN_DIALOG_DATA["REGEN_DIALOG1"] },
		{ MOBINDEX = "KDFargels_Cage", 	X = 4826, Y = 2422, DIR = 270, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["REMOVE"], REGEN_DATA = REGEN_DATA["REGEN7"], REGEN_DIALOG_DATA = REGEN_DIALOG_DATA["REGEN_DIALOG1"] },
		{ MOBINDEX = "KDFargels_Cage", 	X = 2739, Y = 1209, DIR = 90,  RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["REMOVE"], REGEN_DATA = REGEN_DATA["REGEN8"], REGEN_DIALOG_DATA = REGEN_DIALOG_DATA["REGEN_DIALOG1"] },

		-- 필드 리젠
		{ MOBINDEX = "InvisibleMan", 	X = 9422, Y = 1283, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN9"]  },
		{ MOBINDEX = "InvisibleMan", 	X = 8758, Y = 1008, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN10"] },
		{ MOBINDEX = "InvisibleMan", 	X = 8205, Y = 1590, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN9"]  },
		{ MOBINDEX = "InvisibleMan", 	X = 7267, Y = 1485, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN10"] },
		{ MOBINDEX = "InvisibleMan", 	X = 6870, Y = 1070, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN11"] },
		{ MOBINDEX = "InvisibleMan", 	X = 6128, Y = 1073, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN11"] },
		{ MOBINDEX = "InvisibleMan", 	X = 5392, Y = 1821, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN11"] },
		{ MOBINDEX = "InvisibleMan", 	X = 5003, Y = 2310, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN11"] },
		{ MOBINDEX = "InvisibleMan", 	X = 4571, Y = 1635, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN11"] },
		{ MOBINDEX = "InvisibleMan", 	X = 3371, Y = 2184, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN11"] },
		{ MOBINDEX = "InvisibleMan", 	X = 2597, Y = 1412, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN11"] },
		{ MOBINDEX = "InvisibleMan", 	X = 1188, Y = 2272, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN11"] },
		{ MOBINDEX = "InvisibleMan", 	X = 1991, Y = 2936, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN11"] },
		{ MOBINDEX = "InvisibleMan", 	X = 1097, Y = 2880, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN11"] },

	},

	-- 다크 리치
	DLICH =
	{
		{ MOBINDEX = "KDFargels_DLich", X = 1348, Y = 3706, DIR = 180 },
	},
}

-- 2 지역
EVENT_DATA_NO3 =
{
	-- 토린
	TORIN =
	{
		{ MOBINDEX = "KDFargels_Torin", X = 1372, Y = 5133, DIR = 0 },
	},

	-- 리젠 오브젝트
	REGENOBJECT =
	{

		-- 필드 리젠
		{ MOBINDEX = "InvisibleMan", 	X = 1053, Y = 7516, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN12"] },
		{ MOBINDEX = "InvisibleMan", 	X = 1373, Y = 5300, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN13"] },

		{ MOBINDEX = "InvisibleMan", 	X = 1210, Y = 5978, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN12_1"] },
		{ MOBINDEX = "InvisibleMan", 	X = 1240, Y = 5597, DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN13_1"] },

	},

	-- 다크 리치
	DLICH =
	{
		{ MOBINDEX = "KDFargels_DLich", X = 2067, Y = 7581, DIR = 270 },
	},
}

-- 3 지역
EVENT_DATA_NO4 =
{

	-- 리젠 오브젝트
	REGENOBJECT =
	{

		-- 필드 리젠
		{ MOBINDEX = "InvisibleMan", 	X = 3230, 	  Y = 7614, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN14"] },
		{ MOBINDEX = "InvisibleMan", 	X = 3380, 	  Y = 8229, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN14"] },
		{ MOBINDEX = "InvisibleMan", 	X = 4173, 	  Y = 7160, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN14"] },
		{ MOBINDEX = "InvisibleMan", 	X = 4261, 	  Y = 6688, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN14"] },

		{ MOBINDEX = "InvisibleMan", 	X = 3813, 	  Y = 5517, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN15"] },
		{ MOBINDEX = "InvisibleMan", 	X = 4164, 	  Y = 4933, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN15"] },
		{ MOBINDEX = "InvisibleMan", 	X = 5587, 	  Y = 4717, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN15"] },
		{ MOBINDEX = "InvisibleMan", 	X = 6255, 	  Y = 4137, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN15"] },
		{ MOBINDEX = "InvisibleMan", 	X = 6858, 	  Y = 3624, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN15"] },
		{ MOBINDEX = "InvisibleMan", 	X = 7422, 	  Y = 3609, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN15"] },
		{ MOBINDEX = "InvisibleMan", 	X = 8076, 	  Y = 3617, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN15"] },
		{ MOBINDEX = "InvisibleMan", 	X = 6877, 	  Y = 7196, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN15"] },
		{ MOBINDEX = "InvisibleMan", 	X = 4027, 	  Y = 8021, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN16"] },
		{ MOBINDEX = "InvisibleMan", 	X = 3501, 	  Y = 6661, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN16"] },
		{ MOBINDEX = "InvisibleMan", 	X = 4960, 	  Y = 5595, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN17"] },
		{ MOBINDEX = "InvisibleMan", 	X = 6402, 	  Y = 6411, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN18"] },
		{ MOBINDEX = "InvisibleMan", 	X = 6700, 	  Y = 4061, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN19"] },
		{ MOBINDEX = "InvisibleMan", 	X = 8612, 	  Y = 3917, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN18"] },
		{ MOBINDEX = "InvisibleMan", 	X = 4926, 	  Y = 4522, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN20"] },
		{ MOBINDEX = "InvisibleMan", 	X = 6997, 	  Y = 5215, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN21"] },
		{ MOBINDEX = "InvisibleMan", 	X = 7423, 	  Y = 6070, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN22"] },
		{ MOBINDEX = "InvisibleMan", 	X = 7907, 	  Y = 5453, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN23"] },
		{ MOBINDEX = "InvisibleMan", 	X = 6500, 	  Y = 7747, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN24"] },

		-- 경보석
		{ MOBINDEX = "KDFargels_Alarm", X = 4027, 	  Y = 8021, 	DIR = 0, RANGE = 500, 	REGEN_CONDITION = REGEN_CONDITION["SENSOR"], REGEN_DATA = REGEN_DATA["REGEN25"] },
		{ MOBINDEX = "KDFargels_Alarm", X = 3501, 	  Y = 6661, 	DIR = 0, RANGE = 500, 	REGEN_CONDITION = REGEN_CONDITION["SENSOR"], REGEN_DATA = REGEN_DATA["REGEN25"] },
		{ MOBINDEX = "KDFargels_Alarm", X = 4960, 	  Y = 5595, 	DIR = 0, RANGE = 500, 	REGEN_CONDITION = REGEN_CONDITION["SENSOR"], REGEN_DATA = REGEN_DATA["REGEN26"] },
		{ MOBINDEX = "KDFargels_Alarm", X = 6118, 	  Y = 6000, 	DIR = 0, RANGE = 300, 	REGEN_CONDITION = REGEN_CONDITION["SENSOR"], REGEN_DATA = REGEN_DATA["REGEN27"] },
		{ MOBINDEX = "KDFargels_Alarm", X = 6700, 	  Y = 4061, 	DIR = 0, RANGE = 500, 	REGEN_CONDITION = REGEN_CONDITION["SENSOR"], REGEN_DATA = REGEN_DATA["REGEN28"] },
		{ MOBINDEX = "KDFargels_Alarm", X = 8612, 	  Y = 3917, 	DIR = 0, RANGE = 500, 	REGEN_CONDITION = REGEN_CONDITION["SENSOR"], REGEN_DATA = REGEN_DATA["REGEN29"] },

		-- 추가 리젠
		{ MOBINDEX = "InvisibleMan", 	X = 6126, 	  Y = 5582, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN30"] },
		{ MOBINDEX = "InvisibleMan", 	X = 6303, 	  Y = 4739, 	DIR = 0, RANGE = 0, 	REGEN_CONDITION = REGEN_CONDITION["NORMAL"], REGEN_DATA = REGEN_DATA["REGEN31"] },

	},

	-- 에피스 소환
	EPIS =
	{
		{ MOBINDEX = "KDFargels_Epis", 	X = 8142, Y = 8850, DIR = 135 },
	},
}

-- 4 지역
EVENT_DATA_NO5 =
{
	-- 파겔스 소환
	FARGELS =
	{
		{ MOBINDEX = "KDFargels", 		X = 9723, Y = 10109, DIR = 234 },
	},

	-- 성역 기사단 소환
	GUARDIANS =
	{
		{ MOBINDEX = "KDFargels_S_Spearman", 	X = 9606,  Y = 10272, DIR = 0 },
		{ MOBINDEX = "KDFargels_S_Spearman", 	X = 9554,  Y = 10235, DIR = 0 },
		{ MOBINDEX = "KDFargels_S_Spearman", 	X = 9850,  Y = 9974,  DIR = 0 },
		{ MOBINDEX = "KDFargels_S_Spearman", 	X = 9777,  Y = 9924,  DIR = 0 },
		{ MOBINDEX = "KDFargels_S_Mage", 		X = 9867,  Y = 10183, DIR = 0 },
		{ MOBINDEX = "KDFargels_S_Mage", 		X = 9826,  Y = 10240, DIR = 0 },
		{ MOBINDEX = "KDFargels_Wizard", 		X = 10753, Y = 10938, DIR = 0 },
	},
}

EVENT_DATA 		= { }
EVENT_DATA[1] 	= EVENT_DATA_NO1
EVENT_DATA[2] 	= EVENT_DATA_NO2
EVENT_DATA[3] 	= EVENT_DATA_NO3
EVENT_DATA[4] 	= EVENT_DATA_NO4
EVENT_DATA[5] 	= EVENT_DATA_NO5
