--------------------------------------------------------------------------------
--                        KDFargels Boss Data                              	  --
--------------------------------------------------------------------------------

require( "KQ/KDFargels/Functions/SubFunc" )

FARGELS_ABSTATE =
{
	ABSTATE1 =
	{
		{
			ABSTATE_INDEX 	= "StaFatalKnockBack",
			KEEPTIME 		= 15,						-- �����̻�1 ���� ���� �ð�
			PREPARETIME		= 3,						-- �����̻� ���� �غ� �ð�
			INTERVALTIME	= 1,						-- �����̻� �ݺ� �ֱ� �ð�
		},

		{
			ABSTATE_INDEX 	= "StaKDFargels_Blood03",
			KEEPTIME 		= 15,
			PREPARETIME		= 3,
			INTERVALTIME	= 1,
		},
	},

	ABSTATE2 =
	{
		{
			ABSTATE_INDEX 	= "",
			KEEPTIME 		= 10,
			PREPARETIME		= 0,
			INTERVALTIME	= 10,
		},

		{
			ABSTATE_INDEX 	= "StaDmgShield",
			KEEPTIME 		= 10,
			PREPARETIME		= 0,
			INTERVALTIME	= 10,
		},
	},
}

FARGELS_SKILL =
{
	{
		SKILL_INDEX 	= "KDFargels_Skill01_W",
		DELAY 			= 30,						-- ��ų �ߵ� �ֱ�
		MINHPRATE 		= 70,						-- ��ų �ߵ� ����( �ּ� ü�� ���� )
		MAXHPRATE 		= 90,						-- ��ų �ߵ� ����( �ִ� ü�� ���� )
		RANGE 			= 500,						-- ��ų ���� ����
		ABSTATE			= FARGELS_ABSTATE["ABSTATE1"],
		FUNC			= KDFargelsSkill01,			-- ��ų Ưȭ �Լ�
	},

	{
		SKILL_INDEX 	= "KDFargels_Skill05_N",
		DELAY 			= 30,
		MINHPRATE 		= 40,
		MAXHPRATE 		= 70,
		RANGE 			= 600,
		ABSTATE			= nil,
		FUNC			= nil,
	},

	{
		SKILL_INDEX 	= "KDFargels_Skill06_N",
		DELAY 			= 30,
		MINHPRATE 		= 20,
		MAXHPRATE 		= 40,
		RANGE 			= 600,
		ABSTATE			= nil,
		FUNC			= nil,
	},

	{
		SKILL_INDEX 	= "KDFargels_Skill07_W",
		DELAY 			= 30,
		MINHPRATE 		= 0,
		MAXHPRATE 		= 20,
		RANGE 			= 600,
		ABSTATE			= FARGELS_ABSTATE["ABSTATE2"],
		FUNC			= KDFargelsSkill02,
	},
}
