require( "common" )


----------------------------------------------------------------------------------------------------
-- 할로윈 이벤트 데이터
----------------------------------------------------------------------------------------------------
EVENT_MAP_NAME = "E_Hwin"


-- 나갈 맵 정보
EXIT_MAP_DATA =
{
	EMD_INDEX	= "Eld",
	EMD_REGEN_X	= 13059,
	EMD_REGEN_Y	= 13815,
}


-- 맵 이동 서버메뉴 정보
SERVER_MENU_DATA =
{
	-- 타이틀
	SMD_TITLE 	= { TITLE_SCRIPT_FILENAME = "MenuString", TITLE_INDEX = "LinkTitle", TITLE_STRING = nil },

	-- 버튼
	SMD_BT_YES	= { BT_SCRIPT_FILENAME = "ETC", BT_INDEX = "Yes", BT_STRING = nil, BT_FUNC = "Click_Yes" },
	SMD_BT_NO	= { BT_SCRIPT_FILENAME = "ETC", BT_INDEX = "No",  BT_STRING = nil, BT_FUNC = "Click_No" }
}


-- 함정 소환 정보
TRAP_BASE_DATA =
{
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 1
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1200, TBD_EFFECT = "TED_SPEEDDOWN"   },	-- 2
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1100, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 3
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED =  900, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 4
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1400, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 5
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1300, TBD_EFFECT = "TED_SPEEDDOWN"   },	-- 6
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 7
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1200, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 8
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 9
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1400, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 10
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_SPEEDDOWN"   },	-- 11
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1100, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 12
	{ TBD_INDEX = "E_HwinGHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1200, TBD_EFFECT = "TED_TELEPORT_GH" },	-- 13
	{ TBD_INDEX = "E_HwinGHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 14
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_SPEEDDOWN"   },	-- 15
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1200, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 16
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 17
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1300, TBD_EFFECT = "TED_SPEEDDOWN"   },	-- 18
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 19
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1400, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 20

	{ TBD_INDEX = "E_HwinKingCrab",  TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1100, TBD_EFFECT = "TED_AIRBORNE"    },	-- 21
	{ TBD_INDEX = "E_HwinKingCrab",  TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1200, TBD_EFFECT = "TED_TELEPORT_KC" },	-- 22

	{ TBD_INDEX = "E_HwinGHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_TELEPORT_GH" },	-- 23
	{ TBD_INDEX = "E_HwinGHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1200, TBD_EFFECT = "TED_SPEEDUP"     },	-- 24
	{ TBD_INDEX = "E_HwinGHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_TELEPORT_GH" },	-- 25
	{ TBD_INDEX = "E_HwinGHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1300, TBD_EFFECT = "TED_TELEPORT_GH" },	-- 26
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_SPEEDDOWN"   },	-- 27
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1200, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 28

	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_SPEEDDOWN"   },	-- 29
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1200, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 30
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 31
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1200, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 32
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_SPEEDDOWN"   },	-- 33
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1400, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 34
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1300, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 35
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_SPEEDDOWN"   },	-- 36
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 37
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1200, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 38
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_SPEEDDOWN"   },	-- 39
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1100, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 40
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 41
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1200, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 42

	{ TBD_INDEX = "E_HwinGHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_SPEEDUP"     },	-- 43
	{ TBD_INDEX = "E_HwinGHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1300, TBD_EFFECT = "TED_TELEPORT_GH" },	-- 44

	{ TBD_INDEX = "E_HwinKingCrab",  TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_TELEPORT_KC" },	-- 45

	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1200, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 46
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 47
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1400, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 48

	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1000, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 49
	{ TBD_INDEX = "E_HwinDHoneying", TBD_REGEN_MP_STEP = 1, TBD_MOVE_SPEED = 1100, TBD_EFFECT = "TED_TELEPORT_DH" },	-- 50


}


-- 함정 이동 패턴 정보
TRAP_MOVE_PATTERN_DATA =
{
	TMPD_CHECK_INTERVAL	= 0.1,	-- 도착지점 확인 시간 간격
	TMPD_GOAL_INTERVAL	= 10,	-- 도착지점과의 체크 거리

	-- 함정 이동 좌표
	{ { X = 1511, Y = 151  }, { X = 1700, Y = 320  } },																									-- 1
	{ { X = 1511, Y = 320  }, { X = 1700, Y = 151  } },																									-- 2
	{ { X = 1620, Y = 320  }, { X = 1914, Y = 151  }, { X = 2050, Y = 320  }, { X = 2249, Y = 151  }, { X = 2374, Y = 320  }, { X = 2482, Y = 151  } },	-- 3
	{ { X = 1924, Y = 151  }, { X = 1924, Y = 320  } },																									-- 4
	{ { X = 2130, Y = 151  }, { X = 2179, Y = 320  }, { X = 1924, Y = 237  } },																			-- 5
	{ { X = 2527, Y = 243  }, { X = 2650, Y = 320  }, { X = 2742, Y = 151  }, { X = 2857, Y = 286  } },													-- 6
	{ { X = 2956, Y = 544  }, { X = 2791, Y = 733  } },																									-- 7
	{ { X = 2789, Y = 540  }, { X = 2955, Y = 733  } },																									-- 8
	{ { X = 2789, Y = 655  }, { X = 2955, Y = 839  }, { X = 2789, Y = 1062 }, { X = 2955, Y = 1263 }, { X = 2789, Y = 1365 }, { X = 2955, Y = 1522 } },	-- 9
	{ { X = 2872, Y = 955  }, { X = 2955, Y = 1161 }, { X = 2789, Y = 1209 } },																			-- 10
	{ { X = 2789, Y = 955  }, { X = 2955, Y = 955  } },																									-- 11
	{ { X = 2849, Y = 1577 }, { X = 2760, Y = 1752 }, { X = 2947, Y = 1752 } },																			-- 12
	{ { X = 2864, Y = 2622 }, { X = 2647, Y = 2570 }, { X = 2686, Y = 3072 }, { X = 3116, Y = 3076 }, { X = 3097, Y = 2633 } },							-- 13
	{ { X = 2025, Y = 1694 }, { X = 2003, Y = 1943 }, { X = 1495, Y = 1908 }, { X = 1486, Y = 1443 }, { X = 2025, Y = 1439 } },							-- 14
	{ { X = 1575, Y = 2763 }, { X = 1329, Y = 2902 } },																									-- 15
	{ { X = 1505, Y = 2902 }, { X = 1337, Y = 2735 } },																									-- 16
	{ { X = 539,  Y = 2768 }, { X = 642,  Y = 2879 }, { X = 775,  Y = 2769 }, { X = 979,  Y = 2879 }, { X = 1207, Y = 2767 }, { X = 1388, Y = 2853 } },	-- 17
	{ { X = 1089, Y = 2735 }, { X = 1091, Y = 2902 } },																									-- 18
	{ { X = 1089, Y = 2819 }, { X = 887,  Y = 2735 }, { X = 836,  Y = 2902 } },																			-- 19
	{ { X = 832,  Y = 2833 }, { X = 775,  Y = 2769 }, { X = 705,  Y = 2906 }, { X = 590,  Y = 2882 } },													-- 20

	{ { X = 1733, Y = 1679 }, { X = 2874, Y = 1679 }, { X = 2874, Y = 2828 }, { X = 1733, Y = 2828 }, { X = 1733, Y = 3521 } },							-- 21
	{ { X = 2870, Y = 2828 }, { X = 1744, Y = 2828 }, { X = 1744, Y = 1679 }, { X = 3833, Y = 1679 }, { X = 2870, Y = 1678 } },							-- 22

	{ { X = 2862, Y = 2021 }, { X = 3052, Y = 2018 }, { X = 3130, Y = 2219 }, { X = 1450, Y = 2196 }, { X = 1515, Y = 2023 } },							-- 23
	{ { X = 2522, Y = 2835 }, { X = 2525, Y = 3025 }, { X = 2324, Y = 3103 }, { X = 2347, Y = 1424 }, { X = 2520, Y = 1488 } },							-- 24
	{ { X = 2171, Y = 1685 }, { X = 2168, Y = 1293 }, { X = 1996, Y = 1424 }, { X = 1973, Y = 3103 }, { X = 2174, Y = 3182 } },							-- 25
	{ { X = 1738, Y = 2482 }, { X = 1536, Y = 2473 }, { X = 1534, Y = 2133 }, { X = 1911, Y = 2114 }, { X = 2080, Y = 2470 } },							-- 26
	{ { X = 1631, Y = 1775 }, { X = 1720, Y = 1600 }, { X = 1818, Y = 1774 }, { X = 1846, Y = 1647 } },													-- 27
	{ { X = 2912, Y = 2883 }, { X = 2814, Y = 2708 }, { X = 2726, Y = 2883 }, { X = 2940, Y = 2756 } },													-- 28

	{ { X = 1480, Y = 1620 }, { X = 1330, Y = 1760 } },																									-- 29
	{ { X = 1480, Y = 1760 }, { X = 1330, Y = 1605 } },																									-- 30
	{ { X = 1480, Y = 1750 }, { X = 1200, Y = 1605 }, { X = 880,  Y = 1750 }, { X = 700,  Y = 1560 }, { X = 565, Y = 1750 }, { X = 440, Y = 1600 } },	-- 31
	{ { X = 1065, Y = 1600 }, { X = 1025, Y = 1770 } },																									-- 32
	{ { X = 795,  Y = 1600 }, { X = 700,  Y = 1770 } },																									-- 33
	{ { X = 2010, Y = 1920 }, { X = 350,  Y = 2050 } },																									-- 34
	{ { X = 340,  Y = 1960 }, { X = 200,  Y = 2200 } },																									-- 35
	{ { X = 200,  Y = 2070 }, { X = 350,  Y = 2225 }, { X = 200,  Y = 2370 }, { X = 350,  Y = 2410 } },													-- 36
	{ { X = 200,  Y = 2280 }, { X = 350,  Y = 2350 }, { X = 200,  Y = 2510 }, { X = 335,  Y = 2620 } },													-- 37
	{ { X = 200,  Y = 2620 }, { X = 350,  Y = 2475 } },																									-- 38
	{ { X = 200,  Y = 3020 }, { X = 350,  Y = 3140 } },																									-- 39
	{ { X = 200,  Y = 3160 }, { X = 350,  Y = 3320 }, { X = 260,  Y = 3470 }, { X = 300,  Y = 3650 } },													-- 40
	{ { X = 200,  Y = 3650 }, { X = 380,  Y = 3560 } },																									-- 41
	{ { X = 300,  Y = 3930 }, { X = 440,  Y = 3870 }, { X = 280,  Y = 3760 }, { X = 260,  Y = 3870 } },													-- 42

	{ { X = 500,  Y = 3860 }, { X = 430,  Y = 4160 }, { X = 15,   Y = 4100 }, { X = 5,    Y = 3870 }, { X = 530,  Y = 3620 } },							-- 43
	{ { X = 430,  Y = 1680 }, { X = 500,  Y = 2000 }, { X = 50,   Y = 1890 }, { X = 350,  Y = 1400 }, { X = 540,  Y = 1520 } },							-- 44

	{ { X = 320,  Y = 2830 }, { X = 0,    Y = 2830 }, { X = 320,  Y = 2830 }, { X = 0,  Y = 2830 }, { X = 1710,  Y = 2830 }, { X = 0, Y = 2830 } }, 	-- 45

	{ { X = 410,  Y = 3820 }, { X = 540,  Y = 3915 }, { X = 620,  Y = 3820 }, { X = 705,  Y = 3880 }, { X = 805,  Y = 3880 } },							-- 46

	{ { X = 410,  Y = 3950 }, { X = 510,  Y = 3790 }, { X = 600,  Y = 3950 } },																			-- 47
	{ { X = 730,  Y = 3950 }, { X = 730,  Y = 3790 } },																									-- 48

	{ { X = 410,  Y = 1800 }, { X = 520,  Y = 1615 }, { X = 650,  Y = 1685 }, { X = 790,  Y = 1685 } }, 												-- 49
	{ { X = 205,  Y = 1720 }, { X = 310,  Y = 1620 }, { X = 400,  Y = 1730 }, { X = 270,  Y = 1790 } },												 	-- 50

}


-- 함정 효과 정보
TRAP_EFFECT_DATA =
{
	TED_AIRBORNE    = { TED_CHECK_INTERVAL = 0.3, TED_CHECK_DIST = 150, TED_ABSTATE = "StaLVTWarN", 	     TED_TEL_LOCATE = nil,                            TED_SKILL_INTERVAL = 0, 	TED_SKILL = nil, },								-- Airborne Trap
	TED_TELEPORT_DH = { TED_CHECK_INTERVAL = 0.3, TED_CHECK_DIST = 30,  TED_ABSTATE = "StaKnockBackRoll", 	 TED_TEL_LOCATE = { TTL_X = 1000, TTL_Y = 235, }, TED_SKILL_INTERVAL = 0.5, 	TED_SKILL = "E_HwinDHoneying_Skill01_N", },	-- Teleport Trap
	TED_TELEPORT_GH = { TED_CHECK_INTERVAL = 0.3, TED_CHECK_DIST = 30,  TED_ABSTATE = "StaKnockBackRoll", 	 TED_TEL_LOCATE = { TTL_X = 1000, TTL_Y = 235, }, TED_SKILL_INTERVAL = 0, 	TED_SKILL = nil, },	-- Teleport Trap
	TED_TELEPORT_KC = { TED_CHECK_INTERVAL = 0.3, TED_CHECK_DIST = 150, TED_ABSTATE = "StaKnockBackRoll", 	 TED_TEL_LOCATE = { TTL_X = 1000, TTL_Y = 235, }, TED_SKILL_INTERVAL = 0, 	TED_SKILL = nil, },	-- Teleport Trap
	TED_SPEEDUP	    = { TED_CHECK_INTERVAL = 0.3, TED_CHECK_DIST = 30,  TED_ABSTATE = "StaE_H_WinSpeedUp",   TED_TEL_LOCATE = nil,                            TED_SKILL_INTERVAL = 0, 	TED_SKILL = nil, },	                            -- SpeedUp Trap
	TED_SPEEDDOWN   = { TED_CHECK_INTERVAL = 0.3, TED_CHECK_DIST = 30,  TED_ABSTATE = "StaE_H_WinSpeedDown", TED_TEL_LOCATE = nil,                            TED_SKILL_INTERVAL = 0.5, 	TED_SKILL = "E_HwinDHoneying_Skill01_N", },	                            -- SpeedDown Trap
}


-- 골인 지점 정보
AREA_DATA =
{
	AD_START	= "StartLine",
	AD_GOAL		= "EndLine",
}

-- 보상 정보
PLAYER_STATE =
{
	START_CHECK	= 1,
	GOAL_CHECK	= 2,
}

-- 메시지 정보
MSG_DATA =
{
	MD_SUCC = "E_Hwin_TimeSucc",
	MD_FAIL = "E_Hwin_TimeFail"
}

-- 시간에 따른 보상정보
TIME_REWARD_DATA =
{
	{ TIME = 70,		TITLE_TYPE = 122, TITLE_VALUE = 1, },
	{ TIME = 90,		TITLE_TYPE = 123, TITLE_VALUE = 1, },
	{ TIME = 2592000,	TITLE_TYPE = 124, TITLE_VALUE = 1, },
}

-- 변신 상태에 따른 보상정보
POLYMORPH_REWARD_DATA =
{
	{ ABS_INDEX = "StaE_Helga", 		TITLE_TYPE = 125, TITLE_VALUE = 1, },
	{ ABS_INDEX = "StaE_B_CrackerHumar", 		TITLE_TYPE = 126, TITLE_VALUE = 1, },
	{ ABS_INDEX = "StaE_JackO", 	TITLE_TYPE = 127, TITLE_VALUE = 1, },
}



----------------------------------------------------------------------------------------------------
-- 할로윈 이벤트 전역 변수
----------------------------------------------------------------------------------------------------
-- 이벤트 게이트 용 버퍼
--EventGateBuf = {}
--[[
EventGateBuf[ Handle ]["GoalAreaCehckTime"]			= 골인 지점 확인 시간
--]]

-- 함정 용 버퍼
--EvnetTrapBuf = {}
--[[
EvnetTrapBuf[ TrapHandle ] = {}
EvnetTrapBuf[ TrapHandle ]["BaseData"]				= 함정 기본 정보
EvnetTrapBuf[ TrapHandle ]["MovePattern"]			= 이동 패턴 정보
EvnetTrapBuf[ TrapHandle ]["MoveBack"]				= 이동 패턴 돌아가기
EvnetTrapBuf[ TrapHandle ]["MoveStep"] 				= 이동 패턴 단계
EvnetTrapBuf[ TrapHandle ]["MoveCheckTime"] 		= 이동 패턴 확인 시간

EvnetTrapBuf[ TrapHandle ]["EffectData"] 			= 함정 효과 정보
EvnetTrapBuf[ TrapHandle ]["EffectBlastTime"] 		= 함정 효과 사용 시간
EvnetTrapBuf[ TrapHandle ]["SkillBlastTime"] 		= 함정 스킬 사용 시간
--]]

-- 플레이어 용 버퍼
--EventPlayerBuf = {}
--[[
EventPlayerBuf[ i ]["Handle"]
EventPlayerBuf[ i ]["CharNo"]
--]]



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 할로윈 이벤트 함수
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Gate
function E_HwinOut( Handle, MapIndex )
cExecCheck "E_HwinOut"


	-- 이벤트 맵이 아닌곳에서 실행되어서는 안된다.
	if MapIndex ~= EVENT_MAP_NAME
	then
		cVanishAll( MapIndex )

		EventGateBuf	= nil
		EvnetTrapBuf	= nil
		EventPlayerBuf	= nil

		return ReturnAI["END"]
	end


	local CurSec = cCurrentSecond()

	-- 게이트 초기화
	if EventGateBuf == nil
	then
		EventGateBuf = {}
		EventGateBuf["Handle"]			= Handle
		EventGateBuf["PlayerCheckTime"] = CurSec

		cAIScriptFunc( Handle, "NPCClick", "EventGateClick" )
		cSetObjectDirect( Handle, 135 )


		cSetFieldScript( MapIndex, Handle )
		cFieldScriptFunc( MapIndex, "MapLogin", "MapLogin" )


		-- 서버메뉴에서 사용할 문자열 가져오기
		if SERVER_MENU_DATA["SMD_TITLE"]["TITLE_STRING"] == nil
		then
			local MapName = cGetMapName( EXIT_MAP_DATA["EMD_INDEX"] )
			SERVER_MENU_DATA["SMD_TITLE"]["TITLE_STRING"] = cGetScriptString( SERVER_MENU_DATA["SMD_TITLE"]["TITLE_SCRIPT_FILENAME"], SERVER_MENU_DATA["SMD_TITLE"]["TITLE_INDEX"], MapName )
			SERVER_MENU_DATA["SMD_BT_YES"]["BT_STRING"]	  = cGetScriptString( SERVER_MENU_DATA["SMD_BT_YES"]["BT_SCRIPT_FILENAME"], SERVER_MENU_DATA["SMD_BT_YES"]["BT_INDEX"] )
			SERVER_MENU_DATA["SMD_BT_NO"]["BT_STRING"]	  = cGetScriptString( SERVER_MENU_DATA["SMD_BT_NO"]["BT_SCRIPT_FILENAME"], SERVER_MENU_DATA["SMD_BT_NO"]["BT_INDEX"] )
		end


		-- 함정 초기화
		if EvnetTrapBuf == nil
		then
			EvnetTrapBuf = {}
		end

		for i = 1, #TRAP_BASE_DATA
		do
			local dataTrapBase	= TRAP_BASE_DATA[ i ]
			local Regen_X 		= TRAP_MOVE_PATTERN_DATA[ i ][ dataTrapBase["TBD_REGEN_MP_STEP"] ]["X"]
			local Regen_Y		= TRAP_MOVE_PATTERN_DATA[ i ][ dataTrapBase["TBD_REGEN_MP_STEP"] ]["Y"]
			local TrapHandle	= cMobRegen_XY( MapIndex, dataTrapBase["TBD_INDEX"], Regen_X, Regen_Y, 0 )

			if TrapHandle ~= nil
			then
				cAIScriptSet( TrapHandle, Handle )
				cAIScriptFunc( TrapHandle, "Entrance", "TrapMobRoutine" )

				EvnetTrapBuf[ TrapHandle ] = {}
				EvnetTrapBuf[ TrapHandle ]["BaseData"]				= dataTrapBase

				EvnetTrapBuf[ TrapHandle ]["MovePattern"]			= TRAP_MOVE_PATTERN_DATA[ i ]
				EvnetTrapBuf[ TrapHandle ]["MoveBack"]				= false
				EvnetTrapBuf[ TrapHandle ]["MoveStep"] 				= dataTrapBase["TBD_REGEN_MP_STEP"]
				EvnetTrapBuf[ TrapHandle ]["MoveCheckTime"] 		= CurSec

				EvnetTrapBuf[ TrapHandle ]["EffectData"] 			= TRAP_EFFECT_DATA[ dataTrapBase["TBD_EFFECT"] ]
				EvnetTrapBuf[ TrapHandle ]["EffectBlastTime"] 		= CurSec

				EvnetTrapBuf[ TrapHandle ]["SkillBlastTime"]		= CurSec

				cRunTo( TrapHandle, Regen_X, Regen_Y, dataTrapBase["TBD_MOVE_SPEED"] )
			else
				cAssertLog( "Trap regen fail ".. i )
			end
		end
	end


	-- 게이트 죽으면 스크립트 해제
	if cIsObjectDead( Handle ) ~= nil
	then
		cVanishAll( MapIndex )

		EventGateBuf	= nil
		EvnetTrapBuf	= nil
		EventPlayerBuf	= nil

		return ReturnAI["END"]
	end


	PlayerManager( )


	return ReturnAI["END"]
end

-- 게이트 클릭
function EventGateClick( NPCHandle, PlyHandle, PlyCharNo  )
cExecCheck "EventGateClick"

	cServerMenu( PlyHandle, NPCHandle, SERVER_MENU_DATA["SMD_TITLE"]["TITLE_STRING"],
									   SERVER_MENU_DATA["SMD_BT_YES"]["BT_STRING"], SERVER_MENU_DATA["SMD_BT_YES"]["BT_FUNC"],
									   SERVER_MENU_DATA["SMD_BT_NO"]["BT_STRING"],  SERVER_MENU_DATA["SMD_BT_NO"]["BT_FUNC"] )
end

-- 예 클릭( 이벤트 맵 나가기 )
function Click_Yes( NPCHandle, PlyHandle, PlyCharNo )
cExecCheck "Click_Yes"

	cLinkTo( PlyHandle, EXIT_MAP_DATA["EMD_INDEX"], EXIT_MAP_DATA["EMD_REGEN_X"], EXIT_MAP_DATA["EMD_REGEN_Y"] )
end

-- 아니오 클릭
function Click_No( NPCHandle, PlyHandle, PlyCharNo )
cExecCheck "Click_No"
end


-- 맵 로그인
function MapLogin( MapIndex, Handle )
cExecCheck "MapLogin"


	if MapIndex ~= EVENT_MAP_NAME
	then
		return
	end


	local nCharNo = cGetCharNo( Handle )


	if EventPlayerBuf == nil
	then
		EventPlayerBuf = {}
	end


	-- 플레이어 정보 설정
	if EventPlayerBuf[ Handle ] == nil
	then
		EventPlayerBuf[ Handle ]				= {}
		EventPlayerBuf[ Handle ]["CharNo"]		= nCharNo
		EventPlayerBuf[ Handle ]["StartTime"]	= 0
		EventPlayerBuf[ Handle ]["State"]		= PLAYER_STATE["START_CHECK"]
	else
		if EventPlayerBuf[ Handle ]["CharNo"] ~= nCharNo
		then
			EventPlayerBuf[ Handle ]["CharNo"]		= nCharNo
			EventPlayerBuf[ Handle ]["StartTime"]	= 0
			EventPlayerBuf[ Handle ]["State"]		= PLAYER_STATE["START_CHECK"]
		end
	end
end


-- 플레이어 관리자
function PlayerManager( )
cExecCheck "PlayerManager"


	if EventPlayerBuf == nil
	then
		return
	end


	local CurSec = cCurrentSecond()


	-- 일정 시간마다, 플레이어를 확인한다
	if EventGateBuf["PlayerCheckTime"] > CurSec
	then
		return
	end


	-- 다음 확인 시간 설정
	EventGateBuf["PlayerCheckTime"] = CurSec + 0.1


	-- 플레이어 확인
	for Handle, PlayerInfo in pairs( EventPlayerBuf )
	do

		-- 맵에 존재하는지 확인
		if cIsInMap( Handle, EVENT_MAP_NAME ) == nil
		then
			EventPlayerBuf[ Handle ] = nil
		else

			-- 플레이어 상태에 따른 확인
			if PlayerInfo["State"] == PLAYER_STATE["START_CHECK"]
			then

				-- 출발선 확인
				if cGetAreaObject( EVENT_MAP_NAME, AREA_DATA["AD_START"], Handle ) ~= nil
				then
					PlayerInfo["StartTime"]	= CurSec
					PlayerInfo["State"]		= PLAYER_STATE["GOAL_CHECK"]

					cTimerStart( Handle )
				end

			elseif PlayerInfo["State"] == PLAYER_STATE["GOAL_CHECK"]
			then

				-- 도착선 확인
				if cGetAreaObject( EVENT_MAP_NAME, AREA_DATA["AD_GOAL"], Handle ) ~= nil
				then

					-- 시간 확인 후 보상 설정
					local PlayTime = CurSec - PlayerInfo["StartTime"]

					for i = 1, #TIME_REWARD_DATA
					do
						if PlayTime <= TIME_REWARD_DATA[ i ]["TIME"]
						then
							cCharTitleAddValue( Handle, TIME_REWARD_DATA[ i ]["TITLE_TYPE"], TIME_REWARD_DATA[ i ]["TITLE_VALUE"] )
							break
						end
					end

					for i = 1, #POLYMORPH_REWARD_DATA
					do
						if cAbstateRestTime( Handle, POLYMORPH_REWARD_DATA[ i ]["ABS_INDEX"] ) ~= nil
						then
							cCharTitleAddValue( Handle, POLYMORPH_REWARD_DATA[ i ]["TITLE_TYPE"], POLYMORPH_REWARD_DATA[ i ]["TITLE_VALUE"] )
							break
						end
					end


					cDePolymorph( Handle )																										-- 폴리모프 해제
					cTimerEnd( Handle, 5 )																										-- 타이머 삭제 예약
					cScriptMsg( Handle, nil, MSG_DATA["MD_SUCC"], tostring(math.floor(PlayTime / 60)), tostring(math.floor(PlayTime % 60)) )	-- 메시지 출력

					EventPlayerBuf[ Handle ]["StartTime"]	= 0
					EventPlayerBuf[ Handle ]["State"]		= PLAYER_STATE["START_CHECK"]
				end
			end
		end
	end
end
-- Gate
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Trap
function TrapMobRoutine( Handle, MapIndex )
cExecCheck "TrapMobRoutine"


	 -- 함정 버퍼 확인
	if EvnetTrapBuf == nil
	then
		cAIScriptSet( Handle )
		cAssertLog( "TrapMobRoutine - EventTrapBuf nil" )
		return ReturnAI["END"]
	end


	local CurSec 		= cCurrentSecond()
	local infoTrapBuf	= EvnetTrapBuf[ Handle ]


	if infoTrapBuf == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		cAssertLog( "TrapMobRoutine - EventTrapBuf[Handle] nil" )
		return ReturnAI["END"]
	end


	-- 함정 살아 있는지 확인
	if cIsObjectDead( Handle ) ~= nil
	then
		EvnetTrapBuf[ Handle ] = nil
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		cAssertLog( "TrapMobRoutine - Dead" )
		return ReturnAI["END"]
	end

	-- 함정 정보 확인
	if infoTrapBuf["BaseData"] == nil			-- 기본 정보
	then
		EvnetTrapBuf[ Handle ] = nil
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		cAssertLog( "TrapMobRoutine - EventTrapBuf[Handle][\"BaseData\"] nil" )
		return ReturnAI["END"]
	end

	if infoTrapBuf["MovePattern"] == nil		-- 이동 패턴 정보
	then
		EvnetTrapBuf[ Handle ] = nil
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		cAssertLog( "TrapMobRoutine - EventTrapBuf[Handle][\"MovePattern\"] nil" )
		return ReturnAI["END"]
	end

	if infoTrapBuf["EffectData"] == nil			-- 효과 정보
	then
		EvnetTrapBuf[ Handle ] = nil
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		cAssertLog( "TrapMobRoutine - EventTrapBuf[Handle][\"EffectData\"] nil" )
		return ReturnAI["END"]
	end


	-- 함정 이동 제어
	if infoTrapBuf["MoveCheckTime"] <= CurSec
	then
		local MoveStep 					= infoTrapBuf["MoveStep"]
		local GoalInterval				= TRAP_MOVE_PATTERN_DATA["TMPD_GOAL_INTERVAL"] * TRAP_MOVE_PATTERN_DATA["TMPD_GOAL_INTERVAL"]
		local CurLocate_X, CurLocate_Y 	= cObjectLocate( Handle )
		local MaxMovePattern			= #infoTrapBuf["MovePattern"]

		if cDistanceSquar( CurLocate_X, CurLocate_Y, infoTrapBuf["MovePattern"][ MoveStep ]["X"], infoTrapBuf["MovePattern"][ MoveStep ]["Y"] ) < GoalInterval
		then
			-- 이동 단계 계산
			if infoTrapBuf["MoveBack"] == false
			then
				MoveStep = MoveStep + 1

				if MoveStep > MaxMovePattern
				then
					MoveStep 				= MaxMovePattern - 1
					infoTrapBuf["MoveBack"]	= true
				end
			else
				MoveStep = MoveStep - 1

				if MoveStep < 1
				then
					MoveStep 				= 2
					infoTrapBuf["MoveBack"]	= false
				end
			end

			cRunTo( Handle, infoTrapBuf["MovePattern"][ MoveStep ]["X"], infoTrapBuf["MovePattern"][ MoveStep ]["Y"], infoTrapBuf["BaseData"]["TBD_MOVE_SPEED"] )

			infoTrapBuf["MoveStep"] 	= MoveStep
		else
			if cGetMoveState( Handle ) == 0
			then
				cRunTo( Handle, infoTrapBuf["MovePattern"][ MoveStep ]["X"], infoTrapBuf["MovePattern"][ MoveStep ]["Y"], infoTrapBuf["BaseData"]["TBD_MOVE_SPEED"] )
			end
		end

		infoTrapBuf["MoveCheckTime"] = CurSec + TRAP_MOVE_PATTERN_DATA["TMPD_CHECK_INTERVAL"]
	end


	-- 함정 효과 제어
	if infoTrapBuf["EffectBlastTime"] <= CurSec
	then

		-- 함정 효과 적용
		if infoTrapBuf["EffectData"]["TED_ABSTATE"]    ~= nil or
		   infoTrapBuf["EffectData"]["TED_TEL_LOCATE"] ~= nil
		then

			local PlayerList = { cNearObjectList( Handle, infoTrapBuf["EffectData"]["TED_CHECK_DIST"], ObjectType["Player"] ) }


			for i = 1, #PlayerList
			do

				local PlayerHandle = PlayerList[ i ]


				-- 텔레포트
				if infoTrapBuf["EffectData"]["TED_TEL_LOCATE"] ~= nil
				then
					cCastTeleport( PlayerHandle, "SpecificCoord", infoTrapBuf["EffectData"]["TED_TEL_LOCATE"]["TTL_X"], infoTrapBuf["EffectData"]["TED_TEL_LOCATE"]["TTL_Y"] )

					-- 타임 어택 실패 처리
					if EventPlayerBuf ~= nil
					then
						if EventPlayerBuf[ PlayerHandle ] ~= nil
						then
							EventPlayerBuf[ PlayerHandle ]["StartTime"]	= 0
							EventPlayerBuf[ PlayerHandle ]["State"]		= PLAYER_STATE["START_CHECK"]

							cTimerEnd( PlayerHandle, 1 )							-- 타이머 삭제 예약
							cScriptMsg( PlayerHandle, nil, MSG_DATA["MD_FAIL"] )	-- 메시지 출력
						end
					end
				end


				-- 상태이상
				if infoTrapBuf["EffectData"]["TED_ABSTATE"] ~= nil
				then
					cSetAbstate( PlayerHandle, infoTrapBuf["EffectData"]["TED_ABSTATE"], 1, 0, Handle )
				end
			end
		end

		-- 다음 사용 시간
		infoTrapBuf["EffectBlastTime"] = CurSec + infoTrapBuf["EffectData"]["TED_CHECK_INTERVAL"]
	end


	-- 함정 스킬 사용
	if infoTrapBuf["EffectData"]["TED_SKILL"] ~= nil
	then
		if infoTrapBuf["SkillBlastTime"] <= CurSec
		then

			cSkillBlast( Handle, Handle, infoTrapBuf["EffectData"]["TED_SKILL"] )
			infoTrapBuf["SkillBlastTime"] = CurSec + infoTrapBuf["EffectData"]["TED_SKILL_INTERVAL"]

		end
	end


	return ReturnAI["END"]
end
-- Trap
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
