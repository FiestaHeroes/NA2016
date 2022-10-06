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
		Index		= "StaKnockBackFly",	-- �����̻�
		Str			= 1,					-- ����
		KeepTime	= 1,					-- �����ð�
	},
}


--���� ( ������ �ʴ� ) ���ز� NPC
InvisibleMonster =
{
	LocCheckDist				= 10,		-- �������� üũ �Ÿ�
	Dist	  					= 15 * 15,-- ���� ���ĳ��� ���Ž�� �Ÿ�

	TargetAbs					=			-- ���� ���ĳ���, ������ �ɸ��� �Ǵ� �����̻� ����
	{
		Index		= "StaKnockBack",	-- ���ز� NPC�� ������ �浹��, ������ �ɸ��ԵǴ� �����̻�
		Str			= 1,					-- ����
		KeepTime	= 1000,					-- �����ð�
	},

	-- ���ز� NPC ������ �̵� ���
	[ 1 ]	= { { X = 5816, Y = 3693 }, { X = 6103, Y = 3184 }, { X = 6367, Y = 3666 }, { X = 6097, Y = 4156 }, { X = 5816, Y = 3693 } },
	[ 2 ]	= { { X = 5661, Y = 3189 }, { X = 5874, Y = 3187 }, { X = 5863, Y = 4170 }, { X = 5661, Y = 3189 }, { X = 5661, Y = 3189 } },
	[ 3 ]	= { { X = 6433, Y = 4296 }, { X = 6078, Y = 3187 }, { X = 6463, Y = 3083 }, { X = 6744, Y = 3679 }, { X = 6433, Y = 4296 } },
	[ 4 ]	= { { X = 6940, Y = 3674 }, { X = 6749, Y = 3200 }, { X = 6519, Y = 3677 }, { X = 6788, Y = 4186 }, { X = 6940, Y = 3674 } },
	[ 5 ]	= { { X = 7010, Y = 4152 }, { X = 7224, Y = 4154 }, { X = 7242, Y = 3175 }, { X = 7016, Y = 3177 }, { X = 7010, Y = 4152 } },

}




