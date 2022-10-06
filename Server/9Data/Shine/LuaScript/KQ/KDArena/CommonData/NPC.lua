--------------------------------------------------------------------------------
--                              Arena NPC Data                               --
--------------------------------------------------------------------------------


WarpGate	=
{
	-- ����Ʈ �̵� ��ġ
	{ Team = RED_TEAM,	X = 2600, Y = 2700, },
	{ Team = RED_TEAM,	X = 3200, Y = 4260, },
	{ Team = BLUE_TEAM,	X = 3800, Y = 3700, },
	{ Team = BLUE_TEAM,	X = 3200, Y = 2130, },
}


ArenaStone =
{
	-- ���� �������� ����ϴ� ��ų
	SkillIndex		= "ArenaStone_Skill01_W",
	IntervalTime	= 7
}


ArenaFlag =
{
	-- ������ ��� ����
	[ RED_TEAM ] =
	{
		Abstate	= { Index = "StaArenaFlagRed", 	Str = 1, KeepTime = 900000 },	-- ��� �����̻� ����

		ScriptMsg =
		{
			Have_Flag		= "KDArena_A01",
			GetPoint		= "KDArena_A03",
			Drop_Dead		= "KDArena_A05",
			Drop_Logoff		= "KDArena_A10",
			Drop_Hide		= "KDArena_A11",
			Drop_Flag_Dead	= "KDArena_A05",
			Return_Flag 	= "KDArena_A08",
			GoalCondition	= "KDArena_A09",
		},

		GoalPoint =
		{
			X = 1325,
			Y = 3216,
		},

		IconIndex = "RedFlag",
	},

	-- ����� ��� ����
	[ BLUE_TEAM ]	=
	{
		Abstate	= { Index = "StaArenaFlagBlue", 	Str = 1, KeepTime = 900000 },	-- ��� �����̻� ���

		ScriptMsg =
		{
			Have_Flag		= "KDArena_A02",
			GetPoint		= "KDArena_A04",
			Drop_Dead		= "KDArena_A06",
			Drop_Logoff		= "KDArena_A12",
			Drop_Hide		= "KDArena_A13",
			Return_Flag		= "KDArena_A07",
			GoalCondition	= "KDArena_A09",
		},

		GoalPoint =
		{
			X = 5036,
			Y = 3176,
		},

		IconIndex = "BlueFlag",
	},

	-- ��� ���� �г�Ƽ
	Penalty =
	{
		Abstate =
		{
			{ Index = "StaArenaSpdDw", Str = 1, KeepTime = 900000 },
			{ Index = "StaArenaAllDw", Str = 1, KeepTime = 900000 },
		},

		Step =
		{
			{ CheckTick = 30, AbstateStr = 2 },
			{ CheckTick = 60, AbstateStr = 3 },
		}
	},

	Drop_Abstate 		= { "StaHide", "StaPolymorph" },
	Drop_LifeTime		= 30,
	CheckDistance_Falg	= 10,
	CheckDistance_Goal	= 10000,		-- 100 * 100
	PickDelay			= 2,
}
