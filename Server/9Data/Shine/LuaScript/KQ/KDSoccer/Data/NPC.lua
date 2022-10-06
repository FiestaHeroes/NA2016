--------------------------------------------------------------------------------
--                               NPC Data                               --
--------------------------------------------------------------------------------


-- ������ �ʴ� ��
InvisibleDoor =
{
	BlockName = "KickOffCircle"
}


-- �౸��
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
	MoveDist		 = 200,							-- �̵� �Ÿ�
	MoveAngle		 = { Min = 0, Max = 25 },		-- �̵� ���� Min ~ Max �� ��ŭ ȸ��
	MoveSpeedRate	 = 3000,						-- ���� �� ������Ʈ�� �̵��ӵ� ������
	MissRateMax		 = 500,							-- �̵� ���� ȸ�� Ȯ�� �ִ�
	LineOutRegenDist = 50,							-- ���� �ƿ��� ��ȯ ��ġ
	GoalAni			 = "KDSoccer_Ball_Skill01_W",	-- ��
}


-- ����
Referee =
{
	KickDist		= 50,		-- �� ���� �Ÿ�
	FollowDist		= 200,		-- ���󰡱� �Ÿ�
	StopDist		= 100,		-- ���� �Ÿ�
	MoveSpeedRate	= 1300, 	-- �̵� �ӵ� ������
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


-- �� Ű��
GoalKeeper =
{
	KickDist		= 50,	-- �� ���� �Ÿ�
	LocCheckDist	= 10,	-- �������� üũ �Ÿ�

	-- ��Ű�� �̵� ���
	[ KQ_TEAM["RED"] ]	= { { X = 7343, Y = 3567 }, { X = 7244, Y = 3669 }, { X = 7336, Y = 3790 }, { X = 7354, Y = 3662 } },
	[ KQ_TEAM["BLUE"] ]	= { { X = 5515, Y = 3558 }, { X = 5609, Y = 3661 }, { X = 5501, Y = 3793 }, { X = 5517, Y = 3670 } },
}


-- ���� �ڽ� NPC
SpeedUpBox =
{
	AbsIndex	= "StaE_KDSoccer_SpeedUp",	-- �����̻�
	AbsStr		= 1,
	KeepTime	= 10,						-- �����ð�
	MoveSpeed	= 0.4						-- �̵��ӵ� ���� ���� (ex) 0.4 : 40%
}


InvincibleBox =
{
	AbsIndex  = "StaE_KDSoccer_Invincible",	-- �����̻�
	AbsStr	  = 1,
	KeepTime  = 5,							-- �����ð�
	TickTime  = 0.3,						-- ó������
	Dist	  = 100,						-- ���Ž�� �Ÿ�

	TargetAbs =								-- ��󿡰� �ɾ��� �����̻� ����
	{
		Index		= "StaKnockBackFly",		-- �����̻�
		Str			= 1,					-- ����
		KeepTime	= 1,					-- �����ð�
	},
}
