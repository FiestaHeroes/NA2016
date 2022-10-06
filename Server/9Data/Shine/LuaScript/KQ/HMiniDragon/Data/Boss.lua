--------------------------------------------------------------------------------
--                      Mini Dragon (Hard Mode) Boss Data                     --
--------------------------------------------------------------------------------

-- 비활성/활성 상태를 바꿀 스킬은 Name.lua 참조.

-- 인식거리
BossDetectRange =
{
	Regen	= 150,	-- 처음 리젠될 때
	View	= 1000, -- 보스가 첫 타겟을 잡은 후
}


-- 보스 스킬이 발동되는 한계치를 정해놓은 테이블
ThresholdTable =
{
	-- 스킬 비율 바꾸기는 현재 하드모드에서는 비활성 상태
	SkillRateChangeHP =
	{	1000,	900,	800,	700,	600,	500,	400,	300,	200,	100,	},

	SummonHP =
	{	850,	670,	620,	470,	420,	280,	240,	170,	50,		30,		},

	HealHP =
	{	750,	550,	350,	150,	},
}


-- 보스 스킬
BossSkill =
{
	-- 스킬 비율 바꾸기는 현재 하드모드에서는 비활성 상태
	-- 스킬비율 바꾸기
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

	-- 잔몹 소환
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

	-- 자힐
	Heal =
	{
		Abstate			= { Index = "StaQuestEntangle", Strength = 1, KeepTime = 15000, },	-- 힐하는 동안 걸릴 상태이상
		AnimationIndex	= "KQ_MD_BuffSkil1_1",												-- 힐하는 애니메이션(15초짜리)

		TickTimeSec		= 1,	-- 틱당 시간
		TickCount		= 15,	-- 총 틱 수

		-- TickTimeSec 초마다 TickCount 회동안 HP를 HealAmount 만큼씩 채움
		HP750	= {	HP_Rate = 750,	HealAmount = 5000,	},
		HP550	= {	HP_Rate = 550,	HealAmount = 6000,	},
		HP350	= {	HP_Rate = 350,	HealAmount = 7000,	},
		HP150	= {	HP_Rate = 150,	HealAmount = 10000,	},
	},
}
