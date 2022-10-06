--------------------------------------------------------------------------------
--                          Arena Process Data                                --
--------------------------------------------------------------------------------


-- �⺻ �̵� �ӵ�
Player_WalkSpeed	= 33		-- �÷��̾� �ȴ� �ӵ�
Player_RunSpeed		= 127		-- �÷��̾� �޸��� �ӵ�
StaticMoveSpeedRate = 1.5		-- ŷ���� ���������� ���������� �̵� �ӵ� ���� (ex) 1.5 : 150%


-- ��ũ ��ġ ����
LinkInfo =
{
	ReturnMap = { MapIndex = "Gate", x = 1487, y = 1517 },
}



-- ��� �ð� ����
DelayTime =
{
	StartWait						= 30,		-- ���� ��� �ð�
	LimitTime						= 600,		-- ��� ���� �ð�

	GoalInWait						= 2,
	GoalEventWait					= 5,
	LineOutWait__DelBall			= 2,
	LineOutWait						= 2,

	StartDialogInterval				= 5,

	GapKQReturnNotice				= 5,
}


-- �˸� ��� ����
NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	KQReturn =
	{
		ScriptFileName = "Event",

		{ Index = "KQReturn30", },	-- 30�� ����
		{ Index = nil,          },	-- 25�� ����: �޼��� ����
		{ Index = "KQReturn20", },	-- 20�� ����
		{ Index = nil,          },	-- 15�� ����: �޼��� ����
		{ Index = "KQReturn10", },	-- 10�� ����
		{ Index = "KQReturn5" , },	-- 05�� ����
	},

	Start	= "KDSoccer_A01",
	End		= "KDSoccer_A04",

	PlayerGoal =
	{
		[ KQ_TEAM["RED"]  ] = "KDSoccer_A02",
		[ KQ_TEAM["BLUE"] ] = "KDSoccer_A03",
	},

	NPCGoal =
	{
		[ KQ_TEAM["RED"]  ] = "KDSoccer_A08",
		[ KQ_TEAM["BLUE"] ] = "KDSoccer_A09",
	},

	Win =
	{
		[ KQ_TEAM["RED"]  ] = "KDSoccer_A05",
		[ KQ_TEAM["BLUE"] ] = "KDSoccer_A06",
	},

	Draw = "KDSoccer_A07"
}


-- ���� ����
AreaInfo =
{
	TouchLine =
	{
		AreaName = "TouchLine",			-- ���� ����
		Dist	 = 500,					-- �Ÿ� ���� ���������� �� ��ȯ
	},

	PenaltyBox = { "penalty_Box01", "penalty_Box02"	},

	GoalIn	  =
	{
		--  ���� �� ���� ����
		{ Team = KQ_TEAM["RED"],  AreaName = "GoalPost_Red" },
		{ Team = KQ_TEAM["BLUE"], AreaName = "GoalPost_Blue" },


		-- �� ó���� ���� ����
		Emotion		= { Score = 12, LoseAScore = 10 },
		CameraMove	= { X = 6450, Y = 3690, AngleXZ = 310, AngleY = 30, Dist = 1600, Stun = "StaAdlFStun" },
	}
}


-- �౸ ��� ��� ����
SoccerResult =
{
	WIN  = { EffectMsg = EFFECT_MSG_TYPE["EMT_SOCCER_WIN"],  RewardIndex = "REW_KQ_SOCCER_WIN", },		-- �¸�
	LOSE = { EffectMsg = EFFECT_MSG_TYPE["EMT_SOCCER_LOSE"], RewardIndex = "REW_KQ_SOCCER_LOSE", },		-- �й�
	DRAW = { EffectMsg = EFFECT_MSG_TYPE["EMT_SOCCER_DRAW"], RewardIndex = "REW_KQ_SOCCER_DRAW", },		-- ���º�

	SoccerTopScorerTitle	= 120,	-- �ְ� ������ Ÿ��Ʋ
	SoccerPlayerTitle		= 121,	-- �౸ ŷ�� ���� Ÿ��Ʋ
}


-- �� ������
TeamUniform =
{
	[ KQ_TEAM["RED"] ] 	= { "Cos_Uniform_ESP_Shirt01_1", "Cos_Uniform_ESP_Pants01_1", "Cos_Uniform_ESP_Boots01_1" },
	[ KQ_TEAM["BLUE"] ]	= { "Cos_Uniform_FRA_Shirt01",   "Cos_Uniform_FRA_Pants01",   "Cos_Uniform_FRA_Boots01" },
}


-- ���� ���� ��ġ ����
TeamRegenLocation =
{
	[ KQ_TEAM["RED"] ]  = { { X = 6683, Y = 3672, }, { X = 6973, Y = 3672, }, },
	[ KQ_TEAM["BLUE"] ] = { { X = 6199, Y = 3672, }, { X = 5879, Y = 3672, }, }
}


-- �����
OpposingTeamInfo =
{
	[ KQ_TEAM["RED"]  ]	= KQ_TEAM["BLUE"],
	[ KQ_TEAM["BLUE"] ]	= KQ_TEAM["RED"],
}


-- �α��� �Ҷ� �����ִ� �����̻�
LoginResetAbstate =
{
	"StaHide", "StaEntrapHide",
}
