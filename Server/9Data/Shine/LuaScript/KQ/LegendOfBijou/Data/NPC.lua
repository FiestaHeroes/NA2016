--------------------------------------------------------------------------------
--                      Legend Of Bijou NPC Data                              --
--------------------------------------------------------------------------------

NPC_GuardChat =
{
	ScriptFileName = MsgScriptFileDefault,

	SpeakerIndex = "EldSpeGuard01",

	StartDialog 			= { Index = "KQLbMessage1" },

	Destroy1stKamarisDialog = { Index = "KQLbMessage2" },

	Destroy5KamarisDialog 	= { Index = "KQLbMessage4" },

	BeforeBossSquareDialog 	=
	{
		{ Index = "KQLbMessage5" },
		{ Index = "KQLbMessage6" },
	},

	BossAppearedDialog = { Index = "KQLbMessage7" },

	CongratulateSuccessDialog 	=
	{
		{ Index = "KQLbMessage8" },
		{ Index = "KQLbMessage9" },
	},

}
