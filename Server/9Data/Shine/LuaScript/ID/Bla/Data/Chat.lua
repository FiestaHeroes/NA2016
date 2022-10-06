--------------------------------------------------------------------------------
--                                 Chat Data                                  --
--------------------------------------------------------------------------------

ChatInfo =
{
	-------------------------------------------------
	-- 1���� ~ 4������ �ش�
	-------------------------------------------------
	WayToBossRoom_FaceCut =
	{
		-- 1���� �����
		{
			"Mildwin01_1",
			"Mildwin01_2",
			"Mildwin01_3",
		},

		-- 2���� �����
		{
			"Mildwin01_4",
			"Mildwin01_5",
			"Mildwin01_6",
			"Mildwin01_7",
			"Mildwin01_8",
			"Mildwin01_9",
		},

		-- 3���� �����
		{
			"Mildwin02_1"
		},


		-- 4���� �����
		{
			"Mildwin03_1" ,
		},


		-- 5���� �����
		{
			"Mildwin04_1" ,
		},
	},


	-------------------------------------------------
	-- �Ʒ��� 5������ �ش�
	-------------------------------------------------
	-- 5���� ���̽��� ���� �����( AreaName = "Area5FaceCut1", "Area5FaceCut2" )
	BossRoom_Stairway =
	{
		"Mildwin05_1" ,
		"Blakhan05_1" ,
		"Mildwin05_2" ,
		"Blakhan05_2" ,
		"Mildwin05_3" ,
	},

	-- 5���� �����̵����ۿ��� �����( AreaName = "Teleport1", "Teleport2" )
	BossRoom_CenterHall =
	{
		"Blakhan05_3" ,
		"Mildwin05_4" ,
		"Mildwin05_5" ,
		"Mildwin05_6" ,
	},

	-- 5���� �����̵��������� ���� ��, �İֽ� ���
	BossRoom_Fagels_Show =
	{
		"Fargels06_1" ,
	},

	-- �� ���μ� �ı���
	Seal_Broken =
	{
		"IDBla_01",
	},

	-- ���ĭ �����
	Boss_Blakan_Dead =
	{
		"Blakhan06_1" ,
	},

	-- ���ĭ ����� ( ��� ���μ� �ı��� )
	Boss_Blakan_Save =
	{
		"Mildwin06_1" ,
		"Blakhan06_3" ,
		"Blakhan06_4" ,
		"Blakhan06_5" ,
		"Fargels06_2" ,
	},

	-- �İֽ� �����
	Boss_Fagels_Dead =
	{
		"Fargels07_1" ,
		"Fargels07_2" ,

		-- �е��� ��ȯ
		"Mildwin07_1" ,
		"Mildwin07_2" ,
		"Mildwin07_3" ,
		"Mildwin07_4" ,
	},
}



--------------------------------------------------------------------------------
--                                Notice Data                                 --
--------------------------------------------------------------------------------

NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	IDReturn =
	{
		--{ Index = "KQReturn30", },	-- 30�� ����
		--{ Index = nil,          },	-- 25�� ���� : �޼��� ����
		{ Index = "KQReturn20", },		-- 20�� ����
		{ Index = nil,          },		-- 15�� ���� : �޼��� ����
		{ Index = "KQReturn10", },		-- 10�� ����
		{ Index = "KQReturn5" , },		-- 05�� ����
	},
}
