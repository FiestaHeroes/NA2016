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

Referee_Chat =
{
	None	= "KDSoccer_MC03",
	KickOff = "KDSoccer_MC09",
	TimeOut = "KDSoccer_MC10",

	StartDialog =
	{
		"KDSoccer_F01",
		"KDSoccer_F02",
		"KDSoccer_F03",
		"KDSoccer_F04",
	},

	PlayerGoal =
	{
		[ KQ_TEAM["RED"] ]  = "KDSoccer_MC01",
		[ KQ_TEAM["BLUE"] ] = "KDSoccer_MC02",
	},

	NPCGoal =
	{
		[ KQ_TEAM["RED"] ]  = "KDSoccer_MC07",
		[ KQ_TEAM["BLUE"] ] = "KDSoccer_MC08",
	},

	PlayerLineOut =
	{
		[ KQ_TEAM["RED"] ]  = "KDSoccer_MC04",
		[ KQ_TEAM["BLUE"] ] = "KDSoccer_MC05",
	},

	NPCLineOut = "KDSoccer_MC06",
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
		Index		= "StaKnockBackFly",		-- 상태이상
		Str			= 1,					-- 강도
		KeepTime	= 1,					-- 유지시간
	},
}
