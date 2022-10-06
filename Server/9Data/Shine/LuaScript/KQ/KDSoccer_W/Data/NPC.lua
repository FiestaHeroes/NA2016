--------------------------------------------------------------------------------
--                               NPC Data                               --
--------------------------------------------------------------------------------


-- 보이지 않는 문
InvisibleDoor =
{
	BlockName = "KickOffCircle"
}


-- 축구공
SoccerBallManagerStep =
{
	Wait			= 1,
	KickOff			= 2,
	AreaCheck		= 3,
	LineOut_DelBall	= 4,
	LineOut			= 5,
	GoalEvent_Start	= 6,
	GoalEvent_End	= 7,
}

SoccerBall =
{
	MoveDist		 = 200,							-- 이동 거리
	MoveAngle		 = { Min = 0, Max = 25 },		-- 이동 방향 Min ~ Max 값 만큼 회전
	MoveSpeedRate	 = 3000,						-- 공을 찬 오브젝트의 이동속도 증가율
	MissRateMax		 = 500,							-- 이동 방향 회전 확률 최대
	LineOutRegenDist = 50,							-- 라이 아웃시 소환 위치
	GoalAni			 = "KDSoccer_Ball_Skill01_W",	-- 골
}


-- 심판
Referee =
{
	KickDist		= 50,		-- 공 차기 거리
	FollowDist		= 200,		-- 따라가기 거리
	StopDist		= 100,		-- 정지 거리
	MoveSpeedRate	= 1300, 	-- 이동 속도 증가율
}

Referee_Chat =		--trunk\Design\Dev\RawData\ScriptMsg.xlsx
{
	None	= "KDSoccer_W_MC03",
	KickOff = "KDSoccer_W_MC09",
	TimeOut = "KDSoccer_W_MC10",

	StartDialog =
	{
		"KDSoccer_W_F01",
		"KDSoccer_W_F02",
		"KDSoccer_W_F03",
		"KDSoccer_W_F04",
	},

	PlayerGoal =
	{
		[ KQ_TEAM["RED"] ]  = "KDSoccer_W_MC01",
		[ KQ_TEAM["BLUE"] ] = "KDSoccer_W_MC02",
	},

	NPCGoal =
	{
		[ KQ_TEAM["RED"] ]  = "KDSoccer_W_MC07",
		[ KQ_TEAM["BLUE"] ] = "KDSoccer_W_MC08",
	},

	PlayerLineOut =
	{
		[ KQ_TEAM["RED"] ]  = "KDSoccer_W_MC04",
		[ KQ_TEAM["BLUE"] ] = "KDSoccer_W_MC05",
	},

	NPCLineOut = "KDSoccer_W_MC06",
}


-- 골 키퍼
GoalKeeper =
{
	KickDist		= 50,	-- 공 차기 거리
	LocCheckDist	= 10,	-- 도착지점 체크 거리

	-- 골키퍼 이동 경로
	[ KQ_TEAM["RED"] ]	= { { X = 7343, Y = 3567 }, { X = 7244, Y = 3669 }, { X = 7336, Y = 3790 }, { X = 7354, Y = 3662 } },
	[ KQ_TEAM["BLUE"] ]	= { { X = 5515, Y = 3558 }, { X = 5609, Y = 3661 }, { X = 5501, Y = 3793 }, { X = 5517, Y = 3670 } },
}


-- 버프 박스 NPC
SpeedUpBox =
{
	AbsIndex	= "StaE_KDSoccer_SpeedUp",	-- 상태이상
	AbsStr		= 1,
	KeepTime	= 10,						-- 유지시간
	MoveSpeed	= 0.4						-- 이동속도 증가 비율 (ex) 0.4 : 40%
}


InvincibleBox =
{
	AbsIndex  = "StaE_KDSoccer_Invincible",	-- 상태이상
	AbsStr	  = 1,
	KeepTime  = 5,							-- 유지시간
	TickTime  = 0.3,						-- 처리간격
	Dist	  = 100,						-- 대상탐색 거리

	TargetAbs =								-- 대상에게 걸어줄 상태이상 정보
	{
		Index		= "StaKnockBackFly",	-- 상태이상
		Str			= 1,					-- 강도
		KeepTime	= 1,					-- 유지시간
	},
}


--투명 ( 보이지 않는 ) 방해꾼 NPC
InvisibleMonster =
{
	LocCheckDist				= 10,		-- 도착지점 체크 거리
	Dist	  					= 15 * 15,-- 유저 밀쳐내기 대상탐색 거리

	TargetAbs					=			-- 유저 밀쳐내기, 유저가 걸리게 되는 상태이상 정보
	{
		Index		= "StaKnockBack",	-- 방해꾼 NPC가 유저와 충돌시, 유저가 걸리게되는 상태이상
		Str			= 1,					-- 강도
		KeepTime	= 1000,					-- 유지시간
	},

	-- 방해꾼 NPC 각각의 이동 경로
	[ 1 ]	= { { X = 5816, Y = 3693 }, { X = 6103, Y = 3184 }, { X = 6367, Y = 3666 }, { X = 6097, Y = 4156 }, { X = 5816, Y = 3693 } },
	[ 2 ]	= { { X = 5661, Y = 3189 }, { X = 5874, Y = 3187 }, { X = 5863, Y = 4170 }, { X = 5661, Y = 3189 }, { X = 5661, Y = 3189 } },
	[ 3 ]	= { { X = 6433, Y = 4296 }, { X = 6078, Y = 3187 }, { X = 6463, Y = 3083 }, { X = 6744, Y = 3679 }, { X = 6433, Y = 4296 } },
	[ 4 ]	= { { X = 6940, Y = 3674 }, { X = 6749, Y = 3200 }, { X = 6519, Y = 3677 }, { X = 6788, Y = 4186 }, { X = 6940, Y = 3674 } },
	[ 5 ]	= { { X = 7010, Y = 4152 }, { X = 7224, Y = 4154 }, { X = 7242, Y = 3175 }, { X = 7016, Y = 3177 }, { X = 7010, Y = 4152 } },

}




