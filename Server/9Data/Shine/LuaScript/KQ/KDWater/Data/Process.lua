--------------------------------------------------------------------------------
--                          Arena Process Data                                --
--------------------------------------------------------------------------------


-- ��ũ ��ġ ����
LinkInfo =
{
	ReturnMap = { MapIndex = "Gate", x = 1487, y = 1517 },
}


-- ��� �ð� ����
DelayTime =
{
	StartWait					= 30,		-- ���� ��� �ð�
	StartDialogInterval			= 5,		-- ���� ��� ���̾�α� ��� ����

	RoundLimit					= 180,		-- ���� ���� �ð�
	RoundWait					= 15,		-- ���� ��� �ð�
	RoundStartMessage			= 5,		-- ���� ���� �޽��� ��� �ð�
	RoundEndWait				= 5,		-- ���� ���� �� ��� �ð�

	GapKQReturnNotice			= 5,		-- ŷ�� ���� �˸� ��� ����
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


-- ���� ����
RoundInfo =
{
	LastRound 	= 5,	-- ������ ����
	WinRound	= 3,	-- ŷ�� �¸�����, ���� �¸���

	Emotion =
	{
		WIN  = 12,		-- ���� �¸� �̸��
		LOSE = 10,		-- ���� ��� �̸��
		DRAW = 10,		-- ���� ���º� �̸��
	}
}


-- ��� ����
WaterBalloonsWarResult =
{
	WIN  = { EffectMsg = EFFECT_MSG_TYPE["EMT_SOCCER_WIN"],  RewardIndex = "REW_KQ_WATER_WIN", },		-- �¸�
	LOSE = { EffectMsg = EFFECT_MSG_TYPE["EMT_SOCCER_LOSE"], RewardIndex = "REW_KQ_WATER_LOSE", },		-- �й�
	DRAW = { EffectMsg = EFFECT_MSG_TYPE["EMT_SOCCER_DRAW"], RewardIndex = "REW_KQ_WATER_DRAW", },		-- ���º�
}


-- �� ������
TeamUniform =
{
	[ KQ_TEAM["RED"] ] 	= { "Cos_SwimRedA01_2", "Cos_SwimRedP01_2", "Cos_SwimRedS01_2", "KQ_InvincibleWeapon" },
	[ KQ_TEAM["BLUE"] ]	= { "Cos_HSwimA01_3",   "Cos_HSwimP01_3",   "Cos_HSwimS01_3",	"KQ_InvincibleWeapon" },
}


-- �� �����̻�
TeamAbstate =
{
	[ KQ_TEAM["RED"] ] 	= { Index = "StaKQWaterArrow_Red", Str = 1, KeepTime = 1800000 },
	[ KQ_TEAM["BLUE"] ]	= { Index = "StaKQWaterArrow_Blue", Str = 1, KeepTime = 1800000 },
}


-- ���� ���� ��ġ ����
TeamRegenLocation =
{
	[ KQ_TEAM["RED"] ]  = { X = 6334,  Y = 5422, },
	[ KQ_TEAM["BLUE"] ] = { X = 4625, Y = 5422, },
}


-- ���� ��ġ ����
PrisonLocation = { X = 5433, Y = 5422, }


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
