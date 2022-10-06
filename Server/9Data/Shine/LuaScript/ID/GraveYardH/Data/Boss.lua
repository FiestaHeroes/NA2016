--------------------------------------------------------------------------------
--                                 Boss Data                                  --
--------------------------------------------------------------------------------

--[[
	�� ���� ) Phase ����
	Phase ���̺� �����ص� Condition_HPRate �� % ���ϰ� �Ǹ�,
	�ش� �ִϸ��̼��� �ϰ� SummonMob�� ��ȯ�Ѵ�.
--]]

BossInfo =
{
	UrgDTH_ID_GiantMagmaton =
	{
		Lua_EntranceFunc 	= "Routine_Boss",

		Phase =
		{
			{
				Condition_HPRate 		= 20,
				Animation 	= "GiantMagmaTon_skill01",
				SummonMob	= { Index = "UrgDTH_ID_EarthCalerben", Num = 2, }
			},
		},
	},

	UrgDTH_ID_BigMudMan =
	{
		Lua_EntranceFunc 	= "Routine_Boss",

		Phase =
		{
			{
				Condition_HPRate 		= 20,
				Animation 	= "BigMudMan_skill",
				SummonMob	= { Index = "UrgDTH_ID_EarthCalerben", Num = 2, }
			},
		},
	},

	UrgDTH_ID_FireTaitan =
	{
		Lua_EntranceFunc 	= "Routine_Boss",

		Phase =
		{
			{
				Condition_HPRate 		= 20,
				Animation 	= "FireTaitan_skill",
				SummonMob	= { Index = "UrgDTH_ID_EarthCalerben", Num = 2, }
			},
		},

	},

	UrgDTH_ID_Weasel =
	{
		Lua_EntranceFunc 	= "Routine_Boss",

		Phase =
		{
			{
				Condition_HPRate 		= 20,
				Animation 	= "Weasel_skill",
				SummonMob	= { Index = "UrgDTH_ID_EarthCalerben", Num = 2, }
			},
		},
	},

	UrgDTH_ID_FandomCornelius =
	{
		Lua_EntranceFunc 	= "Routine_Boss",

		Phase =
		{
			{
				Condition_HPRate 		= 50,
				Animation 	= "Dragonneut_Skill3",
				SummonMob	= { Index = "UrgDTH_ID_FireShella", Num = 3, }
			},

			{
				Condition_HPRate 		= 30,
				Animation 	= "Dragonneut_Skill3",
				SummonMob	= { Index = "UrgDTH_ID_EarthNerpa", Num = 3, }
			},
		},
	},

}
