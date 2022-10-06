--------------------------------------------------------------------------------
--               Promote Job2_Gamb Regen Data                                 --
--------------------------------------------------------------------------------

RegenInfo =
{
	-- npc
	NPC =
	{
		MobIndex = "Job2_JokerTm", X = 832, Y = 1018, Dir = 0, Scale = 1000,
	},


	-- ¹®
	Door =
	{
		{ Name = "Door1", MobIndex = "Job2_GamOb_door", DoorBlock = "Job2_Door00", X = 550, Y = 1480, Dir = 0, Scale = 1000 },
		{ Name = "Door2", MobIndex = "Job2_GamOb_door", DoorBlock = "Job2_Door00", X = 550, Y = 2214, Dir = 0, Scale = 1000 },
	},


	-- ·ê·¿
	Roulette =
	{
		MobIndex = "Job2_GamOb_stick-up", X = 554, Y = 551, Dir = 0, Scale = 1000,
	},


	-- ÁÖ»çÀ§
	Dice =
	{
		{ MobIndex = "Job2_GamOb_dice-01", X = 646, Y = 498, Dir = 0, Scale = 1000 },
		{ MobIndex = "Job2_GamOb_dice-02", X = 646, Y = 600, Dir = 0, Scale = 1000 },
		{ MobIndex = "Job2_GamOb_dice-03", X = 556, Y = 654, Dir = 0, Scale = 1000 },
		{ MobIndex = "Job2_GamOb_dice-04", X = 468, Y = 600, Dir = 0, Scale = 1000 },
		{ MobIndex = "Job2_GamOb_dice-05", X = 468, Y = 498, Dir = 0, Scale = 1000 },
		{ MobIndex = "Job2_GamOb_dice-06", X = 556, Y = 449, Dir = 0, Scale = 1000 },
	},

	-- ¸÷¸®Á¨±×·ì¿¡¼­ ¼³Á¤µÇ¾îÀÖ´Â ¸ðµç ¸÷ ¸®½ºÆ®
	MobList =
	{
		"Job2_CloverT", "Job2_DiaT",

	},

	-- ·ê·¿ ¸ÂÃß±â ½ÇÆÐ½Ã, ¸®Á¨µÉ ¸÷±×·ì( ¸®Á¨±×·ì _ MobRegen/Job2_Dn01.txt)
	Mob =
	{
		{ "Job2_Dice1-1", "Job2_Dice1-2" },
		{ "Job2_Dice2-1", "Job2_Dice2-2" },
		{ "Job2_Dice3-1", "Job2_Dice3-2" },
		{ "Job2_Dice4-1", "Job2_Dice4-2" },
		{ "Job2_Dice5-1", "Job2_Dice5-2" },
		{ "Job2_Dice6-1", "Job2_Dice6-2" },
	},

	-- º¸½º¸÷ Á¤º¸
	BossMob =
	{
		MobIndex = "Job2_JokerT", X = 555, Y = 2594, Dir = 273, Scale = 1000,
	},


	-- º¸½º¸÷ µå¶ø¾ÆÀÌÅÛ
	RewardDropItem =
	{
		Index = "Job2_STpiece3" , DropRate = 1000000,
	},
}
