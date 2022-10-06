--------------------------------------------------------------------------------
--                         Mara Pirate Regen Data                             --
--------------------------------------------------------------------------------
RegenInfo =
{
	Group =
	{
		InitDungeonRegen =
		{
			"KDPrtShipArea01", "KDPrtShipArea02", "KDPrtShipArea03", "KDPrtShipArea04", "KDPrtShipArea05",
			"KDPrtShipArea06", "KDPrtShipArea07", "KDPrtShipArea08", "KDPrtShipArea09", "KDPrtShipArea10",
			"KDPrtShipArea12", "KDPrtShipArea13", "KDPrtShipArea14", "KDPrtShipArea15",
		},

		MiddleBossRegen	=
		{
			"KDPrtShipArea16", "KDPrtShipArea17", "KDPrtShipArea18", "KDPrtShipArea19", "KDPrtShipArea21",
			"KDPrtShipArea22", "KDPrtShipArea23", "KDPrtShipArea24", "KDPrtShipArea25", "KDPrtShipArea26",
			"KDPrtShipArea27", "KDPrtShipArea28", "KDPrtShipArea29", "KDPrtShipArea30", "KDPrtShipArea31",
			"KDPrtShipArea32", "KDPrtShipArea33", "KDPrtShipArea34", "KDPrtShipArea35", "KDPrtShipArea36",
			"KDPrtShipArea37", "KDPrtShipArea38", "KDPrtShipArea39", "KDPrtShipArea43", "KDPrtShipArea44",
			"KDPrtShipArea46", "KDPrtShipArea49", "KDPrtShipArea50", "KDPrtShipArea51", "KDPrtShipArea52",
			"KDPrtShipArea53", "KDPrtShipArea54", "KDPrtShipArea55",
		},
	},

	Mob =
	{
		MiddleBoss =
		{
			VirtualMara 	= { Index = "KQ_Mara",        x = 9249, y = 17289, dir = 90 },
			VirtualMarlone 	= { Index = "KQ_Marlone",     x = 9565, y = 17142, dir = 90 },
		},

		Boss =
		{
			TrueMara 		= { Index = "KQ_TrueMara",    x = 4338, y = 19628, dir = 90 },
			VirtualMara 	= { Index = "KQ_Mara",        x = 4338, y = 19628, dir = 90, RegenNumber = 2 },
			TmpMara 		= { Index = "KQ_Mara",        x = 4338, y = 19628, dir = 90, RegenNumber = 1 },
			RegenMara 		= { Index = "KQ_Mara",        x = 4466, y = 19237, dir = 90, RegenNumber = 1 },
			TrueMarlone		= { Index = "KQ_TrueMarlone", x = 4392, y = 19295, dir = 90 },
			VirtualMarlone	= { Index = "KQ_Marlone",     x = 4392, y = 19295, dir = 90, RegenNumber = 2 },
			TmpMarlone		= { Index = "KQ_Marlone",     x = 4392, y = 19295, dir = 90, RegenNumber = 1 },
			RegenMarlone	= { Index = "KQ_Marlone",     x = 4500, y = 19436, dir = 90, RegenNumber = 1 },
		},
	},

	NPC	=
	{
		NPC_Guard = { Index = "EldSpeGuard01", x = 10443, y = 8712, dir = 180 },
	},
}
