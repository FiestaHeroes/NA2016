--------------------------------------------------------------------------------
--                            Regen Data                                 --
--------------------------------------------------------------------------------



RegenInfo =
{
	InvisibleDoor	= { Index = "GuildGate00", X = 6540, Y = 2810, Dir = 0 },

	SoccerBall		= { Index = "KDSoccer_Ball_14", X = 6437, Y = 3672, Dir = 0 },

	Referee			= {	Index = "KDSoccer_Referee_14", X = 6431, Y = 3486, Dir = 0 },

	GoalKeeper	=
	{
		{ Index = "KDSoccer_KeeperA_14", X = 7354, Y = 3662, Dir = 0, TeamType = KQ_TEAM["RED"] },
		{ Index = "KDSoccer_KeeperB_14", X = 5517, Y = 3670, Dir = 0, TeamType = KQ_TEAM["BLUE"] },
	},

	BuffBox =
	{
		{ Index = "KDSoccer_SpeedUp",		NPCAction = "SpeedUp_NPCAction" },
		{ Index = "KDSoccer_Invincible",	NPCAction = "Invincible_NPCAction" },

		Location		= { X = 6432, Y = 3566, Width = 600, Height = 500, Rotate = 0 },
		RegenNum		= 10,
		RegenInterval	= { Min = 15, Max = 30 },
	},


	Spectator =
	{
		"KDSoccerW01", "KDSoccerW02", "KDSoccerW03", "KDSoccerW041", "KDSoccerW042",
		"KDSoccerW051", "KDSoccerW052", "KDSoccerW061", "KDSoccerW062",
		"KDSoccerW071", "KDSoccerW072", "KDSoccerW081", "KDSoccerW082",
		"KDSoccerW091", "KDSoccerW092",
	},

	InvisibleMonster =
	{
		{ Index = "KDSoccer_Invisible",	X = 5816, Y = 3693, Dir = 0, MonsterNumber = 1 },
		{ Index = "KDSoccer_Invisible",		X = 5661, Y = 3189, Dir = 0, MonsterNumber = 2 },
		{ Index = "KDSoccer_Invisible",	X = 6433, Y = 4296, Dir = 0, MonsterNumber = 3 },
		{ Index = "KDSoccer_Invisible",		X = 6940, Y = 3674, Dir = 0, MonsterNumber = 4 },
		{ Index = "KDSoccer_Invisible",	X = 7010, Y = 4152, Dir = 0, MonsterNumber = 5 },
	},
}

