--------------------------------------------------------------------------------
--                          Cake War Process Data                             --
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

	KDCake_Role =
	{
		"KDCake_Role_01",
		"KDCake_Role_02",
		"KDCake_Role_03",
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
		LOSE = 10,		-- ���� �й� �̸��
		DRAW = 10,		-- ���� ���º� �̸��
	}
}


-- ��� ����
CakeWarResult =
{
	WIN  = { EffectMsg = EFFECT_MSG_TYPE["EMT_SOCCER_WIN"],  RewardIndex = "REW_KQ_CAKE_WIN", },		-- �¸�
	LOSE = { EffectMsg = EFFECT_MSG_TYPE["EMT_SOCCER_LOSE"], RewardIndex = "REW_KQ_CAKE_LOSE", },		-- �й�
	DRAW = { EffectMsg = EFFECT_MSG_TYPE["EMT_SOCCER_DRAW"], RewardIndex = "REW_KQ_CAKE_DRAW", },		-- ���º�
}


-- �� ������
TeamUniform =
{
	[ KQ_TEAM["RED"] ] 	= { "Cos_WesternPink01_1", "KQ_InvincibleWeapon" },
	[ KQ_TEAM["BLUE"] ]	= { "Cos_WesternSky01_1", "KQ_InvincibleWeapon" },
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
	[ KQ_TEAM["RED"] ]  = { X = 7411, Y = 6150, },
	[ KQ_TEAM["BLUE"] ] = { X = 6415, Y = 7147, },
}


-- ���� ��ġ ����
PrisonLocation = { X = 6904, Y = 6643, }


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
