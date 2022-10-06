--------------------------------------------------------------------------------
--                     Tower Of Iyzel Process Data                            --
--------------------------------------------------------------------------------

LinkInfo =
{
	-- ��ũ ��İ� ��ġ
	ReturnMapOnGateClick 	= { MapIndex = "RouVal01", x = 4664, y = 8416 },
	ReturnMapOnClear 		= { MapIndex = "RouVal01", x = 4661, y = 8208 },
}


DelayTime =
{
	AfterInit 			= 10,	-- ���� ���� �� �ν��Ͻ� ���� ���� ���۱��� ��ٸ��� �ð�

	GapDialog			= 2,	-- ���̽��� ������ �ð�

	WaitAfterGenMob		= 5,	-- �� ������ �� �� �� Ŭ���� ���� üũ���� �ּ� ��� �ð�

	GapIDReturnNotice	= 10,	-- ���� ���� ���� �⺻ ����
}


NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	IDReturn =
	{
		{ Index = "Chat2001System", },	-- 60�� ����
		{ Index = nil,              },	-- 50�� ����
		{ Index = nil,              },	-- 40�� ����
		{ Index = "Chat2002System", },	-- 30�� ����
		{ Index = nil,              },	-- 20�� ����
		{ Index = "Chat2003System", },	-- 10�� ����
	},
}


QuestMobKillInfo =
{
	QuestID  		= 2663,
	MobIndex 		= "Daliy_Check_Tower01",
	MaxKillCount 	= 5,
}
