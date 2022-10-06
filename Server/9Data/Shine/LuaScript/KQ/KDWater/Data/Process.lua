--------------------------------------------------------------------------------
--                          Arena Process Data                                --
--------------------------------------------------------------------------------


-- 링크 위치 정보
LinkInfo =
{
	ReturnMap = { MapIndex = "Gate", x = 1487, y = 1517 },
}


-- 대기 시간 정보
DelayTime =
{
	StartWait					= 30,		-- 시작 대기 시간
	StartDialogInterval			= 5,		-- 시작 대기 다이얼로그 출력 간격

	RoundLimit					= 180,		-- 라운드 진행 시간
	RoundWait					= 15,		-- 라운드 대기 시간
	RoundStartMessage			= 5,		-- 라운드 시작 메시지 출력 시간
	RoundEndWait				= 5,		-- 라운드 종료 후 대기 시간

	GapKQReturnNotice			= 5,		-- 킹퀘 종료 알림 출력 간격
}


-- 알림 출력 정보
NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	KQReturn =
	{
		ScriptFileName = "Event",

		{ Index = "KQReturn30", },	-- 30초 남음
		{ Index = nil,          },	-- 25초 남음: 메세지 없음
		{ Index = "KQReturn20", },	-- 20초 남음
		{ Index = nil,          },	-- 15초 남음: 메세지 없음
		{ Index = "KQReturn10", },	-- 10초 남음
		{ Index = "KQReturn5" , },	-- 05초 남음
	},

	KDWater_Role =
	{
		"KDWater_Role_01",
		"KDWater_Role_02",
		"KDWater_Role_03",
	},

	PlayerOut =
	{
		[ KQ_TEAM["RED"]  ] = "KDRound_OutR",
		[ KQ_TEAM["BLUE"] ] = "KDRound_OutB",
	},

	RoundStart_10SecondAgo 	= "KDRound_Start",
	RoundStart				= "KDRound_Rule",
	RoundEnd				=
	{
		[ KQ_TEAM["RED"]  ] = "KDRound_Win_RoundR",
		[ KQ_TEAM["BLUE"] ] = "KDRound_Win_RoundB",
		DRAW 				= "KDRound_Draw_Round",
	},

	KQEnd =
	{
		[ KQ_TEAM["RED"]  ] = "KDRound_Win_GameR",
		[ KQ_TEAM["BLUE"] ] = "KDRound_Win_GameB",
		DRAW				= "KDRound_Draw_Game",
	}
}


-- 라운드 정보
RoundInfo =
{
	LastRound 	= 5,	-- 마지막 라운드
	WinRound	= 3,	-- 킹퀘 승리조건, 라운드 승리수

	Emotion =
	{
		WIN  = 12,		-- 라운드 승리 이모션
		LOSE = 10,		-- 라운드 폐배 이모션
		DRAW = 10,		-- 라운드 무승부 이모션
	}
}


-- 결과 정보
WaterBalloonsWarResult =
{
	WIN  = { EffectMsg = EFFECT_MSG_TYPE["EMT_SOCCER_WIN"],  RewardIndex = "REW_KQ_WATER_WIN", },		-- 승리
	LOSE = { EffectMsg = EFFECT_MSG_TYPE["EMT_SOCCER_LOSE"], RewardIndex = "REW_KQ_WATER_LOSE", },		-- 패배
	DRAW = { EffectMsg = EFFECT_MSG_TYPE["EMT_SOCCER_DRAW"], RewardIndex = "REW_KQ_WATER_DRAW", },		-- 무승부
}


-- 팀 유니폼
TeamUniform =
{
	[ KQ_TEAM["RED"] ] 	= { "Cos_SwimRedA01_2", "Cos_SwimRedP01_2", "Cos_SwimRedS01_2", "KQ_InvincibleWeapon" },
	[ KQ_TEAM["BLUE"] ]	= { "Cos_HSwimA01_3",   "Cos_HSwimP01_3",   "Cos_HSwimS01_3",	"KQ_InvincibleWeapon" },
}


-- 팀 상태이상
TeamAbstate =
{
	[ KQ_TEAM["RED"] ] 	= { Index = "StaKQWaterArrow_Red", Str = 1, KeepTime = 1800000 },
	[ KQ_TEAM["BLUE"] ]	= { Index = "StaKQWaterArrow_Blue", Str = 1, KeepTime = 1800000 },
}


-- 팀별 리젠 위치 정보
TeamRegenLocation =
{
	[ KQ_TEAM["RED"] ]  = { X = 6334,  Y = 5422, },
	[ KQ_TEAM["BLUE"] ] = { X = 4625, Y = 5422, },
}


-- 감옥 위치 정보
PrisonLocation = { X = 5433, Y = 5422, }


-- 상대팀
OpposingTeamInfo =
{
	[ KQ_TEAM["RED"]  ]	= KQ_TEAM["BLUE"],
	[ KQ_TEAM["BLUE"] ]	= KQ_TEAM["RED"],
}


-- 로그인 할때 지워주는 상태이상
LoginResetAbstate =
{
	"StaHide", "StaEntrapHide",
}
