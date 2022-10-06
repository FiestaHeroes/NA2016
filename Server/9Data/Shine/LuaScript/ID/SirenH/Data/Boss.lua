--------------------------------------------------------------------------------
--                                 Seiren Castle Boss Data                                         --
--------------------------------------------------------------------------------

BossInfo =
{
	SH_Varamus =
	{
		Lua_EntranceFunc 	= "Routine_Normal",
	},

	SH_CyrusKey =
	{
		Lua_EntranceFunc 	= "Routine_DropItem",

		ItemDropList =
		{
			{ Index = "SirenKey_Anais", 	DropRate = 30 },
			{ Index = "SirenKey_Hayreddin", DropRate = 40 },
			{ Index = "SirenKey_Anika", 	DropRate = 30 },
		},
	},

	SH_Anais =
	{
		Lua_EntranceFunc 	= "Routine_PortalRegen",
		PortalName			= "Portal2",
	},

	SH_Anika =
	{
		Lua_EntranceFunc 	= "Routine_PortalRegen",
		BossDeadCheck		= "SH_Tamyu",
		PortalName			= "Portal1",
	},

	SH_Tamyu =
	{
		Lua_EntranceFunc 	= "Routine_PortalRegen",
		BossDeadCheck		= "SH_Anika",
		PortalName			= "Portal1",
	},

	SH_Hayreddin =
	{
		Lua_EntranceFunc	= "Routine_Hayreddin",

		Phase =
		{
			-- Phase 1 도주
			{
				Condition_HPRate	= 30,
				RunTo				= { x = 11097, y = 7154 },
				DialogInfo			= ChatInfo["Hayreddin_EscapeDialog"]
--				DoorOpen			= "Door8",
			},

			-- Phase 2 도주
			{
				Condition_Locate	= { x = 11097, y = 7154 },
				RunTo				= { x = 10878, y = 6840 },
				DoorOpen			= "Door8",
			},

			-- Phase 3 목표 지점 도착 1 초 후 삭제
			{
				Condition_Locate	= { x = 10878, y = 6840 },
				BossVanish			= true,
			}
		},
	},

	SH_HayreddinEvo =
	{
		Lua_EntranceFunc 	= "Routine_PortalRegen",
		PortalName			= "Portal3",
	},

	SH_Freloan =
	{
		Lua_EntranceFunc	= "Routine_Freloan",

		Phase =
		{
			-- Base
			{
			},

			-- Phase 1 스킬 사용
			{
				Condition_HPRate	= 75,
				UseSkill =
				{
					Index		= "S_Freloan_Skill02_W",
					Interval	= 20,
				},
			},

			-- Phase 2 Chief 몬스터 소환
			{
				Condition_HPRate	= 50,

				Summon_Chief =
				{
					SkillIndex	= "S_Freloan_Skill03_N",

					{ Index = "SH_Summon_Varamus",	x = 2058, y = 4377, dir = 0, RunTo = { x = 2565, y = 4006, }, },
					{ Index = "SH_Summon_Anika", 	x = 3859, y = 3028, dir = 0, RunTo = { x = 3216, y = 3535, }, },
					{ Index = "SH_Summon_Anais", 	x = 3686, y = 4633,	dir = 0, RunTo = { x = 3175, y = 4043, }, },
					{ Index = "SH_Summon_Tamyu", 	x = 2112, y = 2975, dir = 0, RunTo = { x = 2685, y = 3535, }, },
				},
			},

			-- Phase 3 스킬 사용, 프렐로안 다리 소환
			{
				Condition_HPRate	= 25,
				UseSkill =
				{
					Index 		= "S_Freloan_Skill02_W",
					Interval	= 15,
				},

				Summon_Leg =
				{
					SkillIndex	= "S_Freloan_Skill04_N",
					Interval 	= 30,

					{ Index = "SH_FreloanLeg", x = 2285, y = 3281, dir = 200, },
					{ Index = "SH_FreloanLeg", x = 2398, y = 3628, dir = 270, },
					{ Index = "SH_FreloanLeg", x = 2290, y = 3961, dir = 270, },
					{ Index = "SH_FreloanLeg", x = 2670, y = 4435, dir = 0, },
					{ Index = "SH_FreloanLeg", x = 3110, y = 4313, dir = 60, },
					{ Index = "SH_FreloanLeg", x = 3465, y = 3975, dir = 90, },
					{ Index = "SH_FreloanLeg", x = 3417, y = 3492, dir = 105, },
					{ Index = "SH_FreloanLeg", x = 3017, y = 3267, dir = 180, },
				},
			},
		},
	},
}
