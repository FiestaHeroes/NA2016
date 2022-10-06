--------------------------------------------------------------------------------
--                           Kingkong Boss Data                             --
--------------------------------------------------------------------------------

BossDetectRange =
{
	Regen	= 150,
	View	= 1000,
}


BossDialog =
{
	ScriptFileName	= MsgScriptFileDefault,

	BossFloorStart =
	{
		{ Index = 	"Phinoflie01",	MobIndex = 	"KQ_K_PhinoFlie",	Delay = 2,	},
		{ Index = 	"Phinoflie02",	MobIndex = 	"KQ_K_PhinoFlie",	Delay = 3,	},
		{ Index = 	"Phinoflie03",	MobIndex = 	"KQ_K_PhinoFlie",	Delay = 3,	},
		{ Index = 	"Kingkong01",	MobIndex = 	"KQ_K_BossPhino",	Delay = 2,	},
		{ Index = 	"Kingkong02",	MobIndex = 	"KQ_K_BossPhino",	Delay = 3,	},
		{ Index = 	"Kingkong03",	MobIndex = 	"KQ_K_BossPhino",	Delay = 3,	},
		{ Index = 	"Kingkong04",	MobIndex = 	"KQ_K_BossPhino",	Delay = 3,	},
		{ Index = 	"Kingkong05",	MobIndex = 	"KQ_K_BossPhino",	Delay = 3,	},
		{ Index = 	"Phinoflie04",	MobIndex = 	"KQ_K_PhinoFlie",	Delay = 3,	},
		{ Index = 	"Phinoflie05",	MobIndex = 	"KQ_K_PhinoFlie",	Delay = 3,	},
		{ Index = 	"Phinoflie06",	MobIndex = 	"KQ_K_PhinoFlie",	Delay = 4,	},

	},

	SummonMob		= {	Index = "Summon01"	},
	Heal			= { Index = "Heal01"	},
}


BossSkillRate =
{
	HP1000	= {	HPRate =	1000,	Value = {	1000,	200,	100,	0,	},	},
	HP900	= {	HPRate =	900,	Value = {	1000,	200,	200,	0,	},	},
	HP800	= {	HPRate =	800,	Value = {	1000,	200,	150,	150,},	},
	HP700	= {	HPRate =	700,	Value = {	1000,	300,	200,	0,	},	},
	HP600	= {	HPRate =	600,	Value = {	1000,	350,	150,	200,},	},
	HP500	= {	HPRate =	500,	Value = {	1000,	400,	300,	0,	},	},
	HP400	= {	HPRate =	400,	Value = {	1000,	200,	250,	250,},	},
	HP300	= {	HPRate =	300,	Value = {	1000,	300,	400,	0,	},	},
	HP200	= {	HPRate =	200,	Value = {	1000,	400,	400,	0,	},	},
	HP100	= {	HPRate =	100,	Value = {	1000,	300,	400,	30,	},	},
}

BossSummon =
{
	BossSummonDelay = 2,

	Summon850 = {	HPRate =	850,	Value = {	"KQ_K_Ogre",		"KQ_K_KingCall",	"KQ_K_KingCall",											},	},
	Summon670 = {	HPRate =	670,	Value = {	"KQ_K_Harkan",		"KQ_K_Harkan",		"KQ_K_VampireBat",	"KQ_K_VampireBat",	"KQ_K_Prisoner",	},	},
	Summon620 = {	HPRate =	620,	Value = {	"KQ_K_VampireBat",	"KQ_K_VampireBat",	"KQ_K_Prisoner",	"KQ_K_Prisoner",	"KQ_K_Torturer",	},	},
	Summon470 = {	HPRate =	470,	Value = {	"KQ_K_Torturer",	"KQ_K_Templer",		"KQ_K_Templer",		"KQ_K_Ratman",		"KQ_K_Ratman",		},	},
	Summon420 = {	HPRate =	420,	Value = {	"KQ_K_Torturer",	"KQ_K_Templer",		"KQ_K_Templer",		"KQ_K_Solider",		"KQ_K_Solider",		},	},
	Summon280 = {	HPRate =	280,	Value = {	"KQ_K_Solider",		"KQ_K_Solider",		"KQ_K_Templer",		"KQ_K_Ratman",							},	},
	Summon240 = {	HPRate =	240,	Value = {	"KQ_K_GoldenBat",	"KQ_K_Spider",		"KQ_K_Nox",			"KQ_K_Nox",								},	},
	Summon170 = {	HPRate =	170,	Value = {	"KQ_K_Mara",		"KQ_K_Marlone",																	},	},
	Summon050 = {	HPRate =	50,		Value = {	"KQ_K_Robo",																						},	},
}

BossHeal =
{
	BossHealDelay	= 2,

	Abstate			= { Index = "StaQuestEntangle", Strength = 1, KeepTime = 15000, },	-- 힐하는 동안 걸릴 상태이상
	AniIndex		= "Pino_Bip01_heal",												-- 힐하는 애니메이션(15초짜리)

	TickTime		= 1,
	Tick			= 15,

	Heal750	= {	HPRate =	750,	Value =	1500,	}, -- 1초마다 1500씩 15회동안 채움
	Heal550	= {	HPRate =	550,	Value =	2000,	},
	Heal350	= {	HPRate =	350,	Value =	2500,	},
	Heal150	= {	HPRate =	150,	Value =	3000,	},
}


