--------------------------------------------------------------------------------
--                          Arena Process Data                                --
--------------------------------------------------------------------------------


-- ��ũ ��ǥ ����
LinkInfo =
{
	ReturnMap = { MapIndex = "Gate", x = 1487, y = 1517 },
}


-- ��� �ð� ����
DelayTime =
{
	StartWait						= 30,
	BeforeStartDialog				= 5,
	BetweenStartDialog				= 4,
	BeforeStartEffect				= 25,
	ArenaKeepTime					= 900,
	ReviveWaitTime					= 3,
	ArenaProcessIntervalTime		= 1,
	GoalConditionNoticeIntervalTime = 5,
	GapKQReturnNotice				= 5,
}


-- �˸� ��� ����
NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	KQReturn =
	{
		{ Index = "KQReturn30", },	-- 30�� ����
		{ Index = nil,          },	-- 25�� ����: �޼��� ����
		{ Index = "KQReturn20", },	-- 20�� ����
		{ Index = nil,          },	-- 15�� ����: �޼��� ����
		{ Index = "KQReturn10", },	-- 10�� ����
		{ Index = "KQReturn5" , },	-- 05�� ����
	},
}


-- ���̾�� ��� ����
NPCDialogInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	StartWait =
	{
		{ Index = "FaceCut01",	FaceCut = "RouGaianMaria" },
		{ Index = "FaceCut02",	FaceCut = "RouGaianMaria" },
		{ Index = "FaceCut03",	FaceCut = "RouGaianMaria" },
		{ Index = "FaceCut04",	FaceCut = "RouGaianMaria" },
	},
}


-- �� ��ȣ
 RED_TEAM		= 1
BLUE_TEAM		= 2
 DEF_TEAM		= 3

 TeamNumberList =
 {
	RED_TEAM,
	BLUE_TEAM,
 }

 -- �� ������
 TeamUniform =
 {
	[ RED_TEAM ] 	= { "Menian_RedA", "Menian_RedP", "Menian_RedS" },
	[ BLUE_TEAM ]	= { "Menian_BlueA", "Menian_BlueP", "Menian_BlueS" },
 }

 -- �Ʒ��� ���, ���� ����
 ArenaResult =
 {
	 WIN  = { EffectMsg = EFFECT_MSG_TYPE["EMT_WIN"],  RewardIndex = "REW_KQ_ARENA_WIN",  RewardAbs = { Index = "StaArenaReward", Str = 1, KeepTime = 3600000 }, },
	 LOSE = { EffectMsg = EFFECT_MSG_TYPE["EMT_LOSE"], RewardIndex = "REW_KQ_ARENA_LOSE", RewardAbs = nil },
	 DRAW = { EffectMsg = EFFECT_MSG_TYPE["EMT_DRAW"], RewardIndex = "REW_KQ_ARENA_DRAW", RewardAbs = nil },
 }
