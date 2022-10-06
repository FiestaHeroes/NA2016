
ChatInfo =
{
	--ScriptFileName = MsgScriptFileDefault,

	-- �δ� �ʱ�ȭ
	InitDungeon =
	{
		{ Index = "SD_Vale02_01" },
		{ Index = "SD_Vale02_02" },
		{ Index = "SD_Vale02_03" },
		{ Index = "SD_Vale02_04" },
		{ Index = "SD_Vale02_05" },
		{ Index = "SD_Vale02_06" },
		{ Index = "SD_Vale01_01" },
	},

	-- ŷũ�� ���μ���
	KingCrabProcess =
	{
		AfterBossRegen =
		{
			-- ŷũ�� ���� ����,
			-- ��? ���� ���� ��鸮�°� ���� �ʾƿ�?
			Index = "SD_Vale01_02",
		},

		AfterBossDead =
		{
			-- ŷũ�� ���� ��,
			-- �ؾȰ��� �ִ� �Ϲ����� ŷũ������ ���� �����Ⱑ �ٸ�����?
			Index = "SD_Vale01_03",
		},
	},

	-- ŷ������ ���μ���
	KingSlimeProcess =
	{
		AfterBossRegen =
		{
			-- ŷ������ ���� ����,
			-- ��? �ٴڿ� �� �׸��ڴ� ����?
			Index = "SD_Vale01_04",
		},

		AfterBossDead =
		{
			-- ŷ�� ���� ��,
			-- Ȯ���� ������ �ִ� �ؾȰ� ���͵��ϰ� ���� �޶������. �ٵ� �����ϼ���.
			Index = "SD_Vale01_05",
		},
	},

	-- �̴ϵ巡�� ���μ���
	MiniDragonProcess =
	{
		-- ���� ��� ���� ����
	},

	-- ���ʽ� ��������
	BonusStageProcess =
	{
		AfterBossRegen =
		{
			-- ���ʽ� �������� ���۽�,
			-- �̰� �� ����?
			Index = "SD_Vale01_06",
		},

	},

	-- ��ȯ
	ReturnToHome =
	{
		-- ������ ������ �� ��޳ʽ� ����Բ� �� ����� �����صδ°� ���ھ��. �ϴ� ������ ���ڱ���.
		Index = "SD_Vale01_07",
	},
}


NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	IDReturn =
	{
		{ Index = "KQReturn30", },	-- 30�� ����
		{ Index = nil,          },	-- 25�� ���� : �޼��� ����
		{ Index = "KQReturn20", },	-- 20�� ����
		{ Index = nil,          },	-- 15�� ���� : �޼��� ����
		{ Index = "KQReturn10", },	-- 10�� ����
		{ Index = "KQReturn5" , },	-- 05�� ����
	},
}
