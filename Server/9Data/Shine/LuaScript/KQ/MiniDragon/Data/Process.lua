--------------------------------------------------------------------------------
--                        Mini Dragon Process Data                            --
--------------------------------------------------------------------------------

LinkInfo =
{
	ReturnMap = { MapIndex = "Eld", x = 17214, y = 13445 },
}


DelayTime =
{
	AfterInit 			= 10,	-- ���� ���� �� ŷ�� ���۱��� ��ٸ��� �ð�
	WaitAfterKillBoss	= 10,	-- ���� ų �� ���� ó������ ���ð�
	GapKQReturnNotice	= 5,	-- ���� ���� ���� �⺻ ����
}


NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	KQReturn =
	{
		{ Index = "KQReturn60", },	-- 60�� ����
		{ Index = nil,          },	-- 55�� ����: �޼��� ����
		{ Index = "KQReturn50", },	-- 50�� ����
		{ Index = nil,          },	-- 45�� ����: �޼��� ����
		{ Index = "KQReturn40", },	-- 40�� ����
		{ Index = nil,          },	-- 35�� ����: �޼��� ����
		{ Index = "KQReturn30", },	-- 30�� ����
		{ Index = nil,          },	-- 25�� ����: �޼��� ����
		{ Index = "KQReturn20", },	-- 20�� ����
		{ Index = nil,          },	-- 15�� ����: �޼��� ����
		{ Index = "KQReturn10", },	-- 10�� ����
		{ Index = "KQReturn5" , },	-- 05�� ����
	},

	KQFReturn =
	{
		{ Index = "KQFReturn30", },	-- 30�� ����
		{ Index = nil,           },	-- 25�� ����: �޼��� ����
		{ Index = "KQFReturn20", },	-- 20�� ����
		{ Index = nil,           },	-- 15�� ����: �޼��� ����
		{ Index = "KQFReturn10", },	-- 10�� ����
		{ Index = "KQFReturn5" , },	-- 05�� ����
	},
}


QuestMobKillInfo =
{
	QuestID  		= 2668,
	MobIndex 		= "Daliy_Check",
	MaxKillCount 	= 1,
}
