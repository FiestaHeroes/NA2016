--------------------------------------------------------------------------------
--                                 Boss Data                                  --
--------------------------------------------------------------------------------


--[[
require( "Functions/SubFunc" )
--]]

require( "ID/Bla/Functions/SubFunc" )
--]]


FARGELS_ABSTATE =
{
	ABSTATE1 =
	{
		{
			ABSTATE_INDEX 	= "StaFatalKnockBack",
			KEEPTIME 		= 15,						-- 상태이상1 적용 유지 시간
			PREPARETIME		= 3,						-- 상태이상 적용 준비 시간
			INTERVALTIME	= 1,						-- 상태이상 반복 주기 시간
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
		DELAY 			= 30,						-- 스킬 발동 주기
		MINHPRATE 		= 70,						-- 스킬 발동 조건( 최소 체력 비율 )
		MAXHPRATE 		= 90,						-- 스킬 발동 조건( 최대 체력 비율 )
		RANGE 			= 500,						-- 스킬 적용 범위
		ABSTATE			= FARGELS_ABSTATE["ABSTATE1"],
		FUNC			= KDFargelsSkill01,			-- 스킬 특화 함수
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
		MINHPRATE 		= 10,
		MAXHPRATE 		= 20,
		RANGE 			= 600,
		ABSTATE			= FARGELS_ABSTATE["ABSTATE2"],
		FUNC			= KDFargelsSkill02,
	},

	{
		SKILL_INDEX 	= nil,
		DELAY 			= 30,
		MINHPRATE 		= 0,
		MAXHPRATE 		= 10,
		RANGE 			= nil,
		ABSTATE			= nil,
		FUNC			= KDFargelsSkill03,		-- 몹 리젠

		SUMMON_MOBDATA	=
		{
			{ Index = "Summon_Archer", 		x = 9914, y = 6702, 	radius = 200,},
			{ Index = "Summon_Archer", 		x = 9914, y = 6702, 	radius = 200,},
			{ Index = "Summon_Assassin", 	x = 9914, y = 6702, 	radius = 200,},
			{ Index = "Summon_Alchemist", 	x = 9914, y = 6702, 	radius = 200,},
			{ Index = "Summon_Mage", 		x = 9914, y = 6702, 	radius = 200,},


			{ Index = "Summon_Archer", 		x = 9832, y = 6070, 	radius = 200,},
			{ Index = "Summon_Archer", 		x = 9832, y = 6070, 	radius = 200,},
			{ Index = "Summon_Assassin", 	x = 9832, y = 6070, 	radius = 200,},
			{ Index = "Summon_Alchemist", 	x = 9832, y = 6070, 	radius = 200,},
			{ Index = "Summon_Mage", 		x = 9832, y = 6070, 	radius = 200,},


			{ Index = "Summon_Archer", 		x = 9202, y = 6176, 	radius = 200,},
			{ Index = "Summon_Archer", 		x = 9202, y = 6176, 	radius = 200,},
			{ Index = "Summon_Assassin", 	x = 9202, y = 6176, 	radius = 200,},
			{ Index = "Summon_Alchemist", 	x = 9202, y = 6176, 	radius = 200,},
			{ Index = "Summon_Mage", 		x = 9202, y = 6176, 	radius = 200,},


			{ Index = "Summon_Archer", 		x = 9292, y = 6801, 	radius = 200,},
			{ Index = "Summon_Archer", 		x = 9292, y = 6801, 	radius = 200,},
			{ Index = "Summon_Assassin", 	x = 9292, y = 6801, 	radius = 200,},
			{ Index = "Summon_Alchemist", 	x = 9292, y = 6801, 	radius = 200,},
			{ Index = "Summon_Mage", 		x = 9292, y = 6801, 	radius = 200,},

		}

	},
}





