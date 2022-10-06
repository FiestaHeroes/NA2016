--------------------------------------------------------------------------------
--                           King Slime Boss Data                             --
--------------------------------------------------------------------------------

KingSlimeChat =
{
	ScriptFileName = MsgScriptFileDefault,

	WarningDialog =
	{
		{ Index = "KingSlime0" },
		{ Index = "KingSlime1" },
	},

	SummonMobShout 	= {	Index = "KingSlimeSummon" },
	DeathShout 		= { Index = "KingSlimeDead" },
}


KingSlimeSummon =
{
	FirstSummon =
	{
		HP_Rate = 800,
		SummonMobs =
		{
			"KQ_Slime", "KQ_Slime", "KQ_Slime",
		},
	},

	SecondSummon =
	{
		HP_Rate = 600,
		SummonMobs =
		{
			"KQ_FireSlime", "KQ_FireSlime", "KQ_FireSlime",
		},
	},

	ThirdSummon =
	{
		HP_Rate = 400,
		SummonMobs =
		{
			"KQ_IronSlime", "KQ_IronSlime", "KQ_IronSlime", "KQ_IronSlime",
		},
	},

	LastSummon =
	{
		HP_Rate = 200,
		SummonMobs =
		{
			"KQ_QueenSlime",
			"KQ_PrinceSlime", "KQ_PrinceSlime",
		},
	},
}
