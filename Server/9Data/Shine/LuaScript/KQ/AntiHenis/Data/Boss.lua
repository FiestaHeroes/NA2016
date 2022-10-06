--------------------------------------------------------------------------------
--                           Anti Henis Boss Data                             --
--------------------------------------------------------------------------------

AntiHenisBossChat =
{
	ScriptFileName = MsgScriptFileDefault,

	WarningDialog =
	{
		{ Index = "AntiHenis0" },
		{ Index = "AntiHenis1" },
	},

	SummonMobShout 	= {	Index = "AntiHenisSummon" },
	DeathShout 		= { Index = "AntiHenisDead" },
}


AntiHenisBossSummon =
{
	FirstSummon =
	{
		HP_Rate = 800,
		SummonMobs =
		{
			"Anti_Henis_G_A100", "Anti_Henis_G_A100", "Anti_Henis_G_A100", "Anti_Henis_G_A100", "Anti_Henis_G_A100", "Anti_Henis_G_A100",
		},
	},

	SecondSummon =
	{
		HP_Rate = 600,
		SummonMobs =
		{
			"Anti_Henis_G_A100", "Anti_Henis_G_A100", "Anti_Henis_G_A100", "Anti_Henis_G_A100", "Anti_Henis_G_A100", "Anti_Henis_G_A100",
		},
	},

	ThirdSummon =
	{
		HP_Rate = 400,
		SummonMobs =
		{
			"Anti_Henis_G_M100", "Anti_Henis_G_M100", "Anti_Henis_G_M100", "Anti_Henis_G_M100",
		},
	},

	LastSummon =
	{
		HP_Rate = 200,
		SummonMobs =
		{
			"Anti_Henis_G_A100", "Anti_Henis_G_A100", "Anti_Henis_G_A100", "Anti_Henis_G_A100", "Anti_Henis_G_A100", "Anti_Henis_G_A100",
			"Anti_Henis_G_M100", "Anti_Henis_G_M100", "Anti_Henis_G_M100", "Anti_Henis_G_M100", "Anti_Henis_G_M100", "Anti_Henis_G_M100",
			"Anti_Henis_G_C100", "Anti_Henis_G_C100",
		},
	},
}
