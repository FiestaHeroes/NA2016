--------------------------------------------------------------------------------
--                            Regen Data                                 --
--------------------------------------------------------------------------------


RegenInfo =
{
	InvisibleDoor	= { Index = "GuildGate00", X = 6540, Y = 2810, Dir = 0 },

	SoccerBall		= { Index = "KDSoccer_Ball", X = 6437, Y = 3672, Dir = 0 },

	Referee			= {	Index = "KDSoccer_Referee", X = 6431, Y = 3486, Dir = 0 },

	GoalKeeper	=
	{
		{ Index = "KDSoccer_KeeperA", X = 7354, Y = 3662, Dir = 0, TeamType = KQ_TEAM["RED"] },
		{ Index = "KDSoccer_KeeperB", X = 5517, Y = 3670, Dir = 0, TeamType = KQ_TEAM["BLUE"] },
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
		"KDSoocer01", "KDSoocer02", "KDSoocer03", "KDSoocer041", "KDSoocer042",
		"KDSoocer051", "KDSoocer052", "KDSoocer061", "KDSoocer062",
		"KDSoocer071", "KDSoocer072", "KDSoocer081", "KDSoocer082",
		"KDSoocer091", "KDSoocer092",
	}
}



