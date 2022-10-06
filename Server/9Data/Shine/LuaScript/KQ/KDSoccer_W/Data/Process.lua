--------------------------------------------------------------------------------
--                          Arena Process Data                                --
--------------------------------------------------------------------------------


-- 기본 이동 속도
Player_WalkSpeed	= 33		-- 플레이어 걷는 속도
Player_RunSpeed		= 127		-- 플레이어 달리기 속도
StaticMoveSpeedRate = 1.5		-- 킹퀘에 입장했을때 고정시켜줄 이동 속도 비율 (ex) 1.5 : 150%


-- 링크 위치 정보
LinkInfo =
{
	ReturnMap = { MapIndex = "Gate", x = 1487, y = 1517 },
}



-- 대기 시간 정보
DelayTime =
{
	StartWait						= 30,		-- 시작 대기 시간
	LimitTime						= 600,		-- 경기 진행 시간

	GoalInWait						= 2,
	GoalEventWait					= 5,
	LineOutWait__DelBall			= 2,
	LineOutWait						= 2,

	StartDialogInterval				= 5,

	GapKQReturnNotice				= 5,
}


-- 알림 출력 정보
NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	KQReturn =
	{
		ScriptFileName = "Event",

		{ Index = "KQReturn30", },	-- 30초 남음		--trunk\Design\Dev\RawData\Script.xlsx	???
		{ Index = nil,          },	-- 25초 남음: 메세지 없음
		{ Index = "KQReturn20", },	-- 20초 남음
		{ Index = nil,          },	-- 15초 남음: 메세지 없음
		{ Index = "KQReturn10", },	-- 10초 남음
		{ Index = "KQReturn5" , },	-- 05초 남음
	},

	Start	= "KDSoccer_W_A01",		--trunk\Design\Dev\RawData\ScriptMsg.xlsx
	End		= "KDSoccer_W_A04",

	PlayerGoal =
	{
		[ KQ_TEAM["RED"]  ] = "KDSoccer_W_A02",
		[ KQ_TEAM["BLUE"] ] = "KDSoccer_W_A03",
	},

	NPCGoal =
	{
		[ KQ_TEAM["RED"]  ] = "KDSoccer_W_A08",
		[ KQ_TEAM["BLUE"] ] = "KDSoccer_W_A09",
	},

	Win =
	{
		[ KQ_TEAM["RED"]  ] = "KDSoccer_W_A05",
		[ KQ_TEAM["BLUE"] ] = "KDSoccer_W_A06",
	},

	Draw = "KDSoccer_W_A07"
}


-- 영역 정보
AreaInfo =
{
	TouchLine =
	{
		AreaName = "TouchLine",			-- 영역 정보
		Dist	 = 500,					-- 거리 내의 상태팀에게 공 소환
	},

	PenaltyBox = { "penalty_Box01", "penalty_Box02"	},

	GoalIn	  =
	{
		--  팀별 골 영역 정보
		{ Team = KQ_TEAM["RED"],  AreaName = "GoalPost_Red" },
		{ Team = KQ_TEAM["BLUE"], AreaName = "GoalPost_Blue" },


		-- 골 처리시 연출 정보
		Emotion		= { Score = 12, LoseAScore = 10 },
		CameraMove	= { X = 6450, Y = 3690, AngleXZ = 310, AngleY = 30, Dist = 1600, Stun = "StaAdlFStun" },
	}
}


-- 축구 경기 결과 정보
SoccerResult =
{
	WIN  = { EffectMsg = EFFECT_MSG_TYPE["EMT_SOCCER_WIN"],  RewardIndex = "REW_KQ_SOCCER_W_WIN", },		-- 승리		--cKQRewardIndex 호출시에 사용.
	LOSE = { EffectMsg = EFFECT_MSG_TYPE["EMT_SOCCER_LOSE"], RewardIndex = "REW_KQ_SOCCER_W_LOSE", },		-- 패배
	DRAW = { EffectMsg = EFFECT_MSG_TYPE["EMT_SOCCER_DRAW"], RewardIndex = "REW_KQ_SOCCER_W_DRAW", },		-- 무승부

	SoccerTopScorerTitle	= 120,	-- 최고 득점자 타이틀
	SoccerPlayerTitle		= 121,	-- 축구 킹퀘 참여 타이틀
}


--[[
-- 팀 유니폼
TeamUniform =
{
	[ KQ_TEAM["RED"] ] 	= { "Cos_Uniform_ESP_Shirt01_1", "Cos_Uniform_ESP_Pants01_1", "Cos_Uniform_ESP_Boots01_1" },
	[ KQ_TEAM["BLUE"] ]	= { "Cos_Uniform_FRA_Shirt01",   "Cos_Uniform_FRA_Pants01",   "Cos_Uniform_FRA_Boots01" },
}
--]]

-- 팀별 리젠 위치 정보
TeamRegenLocation =
{
	[ KQ_TEAM["RED"] ]  = { { X = 6683, Y = 3672, }, { X = 6973, Y = 3672, }, },
	[ KQ_TEAM["BLUE"] ] = { { X = 6199, Y = 3672, }, { X = 5879, Y = 3672, }, }
}


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


--로그인 할때 걸어줄 상태이상
LoginSetAbstate =
{
	[ KQ_TEAM["RED"]  ]	= "StaE_SnowmanR",
	[ KQ_TEAM["BLUE"] ]	= "StaE_SnowmanB",	--팀 별 상태이상 인덱스

	AbstateStrength = 1,					--상태이상의 강도
	AbstateDuration = 60 * 1000 * 60 		--상태이상의 지속시간
}





