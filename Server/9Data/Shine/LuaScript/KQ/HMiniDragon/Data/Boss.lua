--------------------------------------------------------------------------------
--                      Mini Dragon (Hard Mode) Boss Data                     --
--------------------------------------------------------------------------------

-- ��Ȱ��/Ȱ�� ���¸� �ٲ� ��ų�� Name.lua ����.

-- �νİŸ�
BossDetectRange =
{
	Regen	= 150,	-- ó�� ������ ��
	View	= 1000, -- ������ ù Ÿ���� ���� ��
}


-- ���� ��ų�� �ߵ��Ǵ� �Ѱ�ġ�� ���س��� ���̺�
ThresholdTable =
{
	-- ��ų ���� �ٲٱ�� ���� �ϵ��忡���� ��Ȱ�� ����
	SkillRateChangeHP =
	{	1000,	900,	800,	700,	600,	500,	400,	300,	200,	100,	},

	SummonHP =
	{	850,	670,	620,	470,	420,	280,	240,	170,	50,		30,		},

	HealHP =
	{	750,	550,	350,	150,	},
}


-- ���� ��ų
BossSkill =
{
	-- ��ų ���� �ٲٱ�� ���� �ϵ��忡���� ��Ȱ�� ����
	-- ��ų���� �ٲٱ�
	SkillRateChange =
	{
		HP1000	= {	SkillRate = {	1000,	200,	100,	0,	},	},
		HP900	= {	SkillRate = {	1000,	200,	200,	0,	},	},
		HP800	= {	SkillRate = {	1000,	200,	150,	150,},	},
		HP700	= {	SkillRate = {	1000,	300,	200,	0,	},	},
		HP600	= {	SkillRate = {	1000,	350,	150,	200,},	},
		HP500	= {	SkillRate = {	1000,	400,	300,	0,	},	},
		HP400	= {	SkillRate = {	1000,	200,	250,	250,},	},
		HP300	= {	SkillRate = {	1000,	300,	400,	0,	},	},
		HP200	= {	SkillRate = {	1000,	400,	400,	0,	},	},
		HP100	= {	SkillRate = {	1000,	300,	400,	30,	},	},
	},

	-- �ܸ� ��ȯ
	Summon =
	{
		HP850 =	{ SummonMobs = { "KQ_H_Bat",	"KQ_H_Bat",			"KQ_H_SmallProck",	}, },
		HP670 =	{ SummonMobs = { "KQ_H_Bat",	"KQ_H_Bat",			"KQ_H_KissLips",	"KQ_H_SmallProck",	"KQ_H_SmallProck",	}, },
		HP620 =	{ SummonMobs = { "KQ_H_Bat",	"KQ_H_Bat",			"KQ_H_KissLips",	"KQ_H_SmallProck",	"KQ_H_SmallProck",	}, },
		HP470 =	{ SummonMobs = { "KQ_H_Spider",	"KQ_H_Spider",		"KQ_H_KissLips",	"KQ_H_SandRatman",	"KQ_H_SandRatman",	}, },
		HP420 =	{ SummonMobs = { "KQ_H_Spider",	"KQ_H_KissLips",	"KQ_H_SandRatman",	"KQ_H_SandRatman",	}, },
		HP280 =	{ SummonMobs = { "KQ_H_MadHob",	"KQ_H_SandRatman",	"KQ_H_SandRatman",	"KQ_H_HardboneImp",	}, },
		HP240 =	{ SummonMobs = { "KQ_H_Spider",	"KQ_H_KissLips",	"KQ_H_SandRatman",	"KQ_H_SandRatman",	}, },
		HP170 =	{ SummonMobs = { "KQ_H_Spider",	"KQ_H_MadHob",		"KQ_H_MadHob",		"KQ_H_SandRatman",	"KQ_H_SandRatman",	}, },
		HP50 =	{ SummonMobs = { "KQ_H_MadHob",	"KQ_H_Werebear",	"KQ_H_Werebear",	"KQ_H_HeavyOgre",	"KQ_H_HeavyOgre",	"KQ_H_HardboneImp",	}, },
		HP30 =	{ SummonMobs = { "KQ_H_MadHob",	"KQ_H_Werebear",	"KQ_H_Werebear",	"KQ_H_HeavyOgre",	"KQ_H_HeavyOgre",	"KQ_H_HeavyOgre",	"KQ_H_HardboneImp",	"KQ_H_HardboneImp",	}, },
	},

	-- ����
	Heal =
	{
		Abstate			= { Index = "StaQuestEntangle", Strength = 1, KeepTime = 15000, },	-- ���ϴ� ���� �ɸ� �����̻�
		AnimationIndex	= "KQ_MD_BuffSkil1_1",												-- ���ϴ� �ִϸ��̼�(15��¥��)

		TickTimeSec		= 1,	-- ƽ�� �ð�
		TickCount		= 15,	-- �� ƽ ��

		-- TickTimeSec �ʸ��� TickCount ȸ���� HP�� HealAmount ��ŭ�� ä��
		HP750	= {	HP_Rate = 750,	HealAmount = 5000,	},
		HP550	= {	HP_Rate = 550,	HealAmount = 6000,	},
		HP350	= {	HP_Rate = 350,	HealAmount = 7000,	},
		HP150	= {	HP_Rate = 150,	HealAmount = 10000,	},
	},
}
