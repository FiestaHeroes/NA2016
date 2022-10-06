--------------------------------------------------------------------------------
--                          Mara Pirate Boss Data                             --
--------------------------------------------------------------------------------
MiddleBossChat =
{
	ScriptFileName 	= MsgScriptFileDefault,

	SpyReportDialog =
	{
		{ Index = "SpyReport0", FaceCut = "KQ_TrueMara" },
		{ Index = "SpyReport1", FaceCut = "EldSpeGuard01" },
		{ Index = "SpyReport2", FaceCut = "KQ_TrueMarlone" },
	},

	MiddleReportDialog	=
	{
		{ Index = "MiddleReport0", FaceCut = "KQ_TrueMarlone" },
		{ Index = "MiddleReport1", FaceCut = "KQ_TrueMara"    },
		{ Index = "MiddleReport2", FaceCut = "KQ_TrueMarlone" },
		{ Index = "MiddleReport3", FaceCut = "KQ_TrueMara"    },
		{ Index = "MiddleReport4", FaceCut = "KQ_TrueMara"    },
	},


	MaraDeadChat  	= { Index = "MidMaraDead" },
	MarloneDeadChat = { Index = "MidMarloneDead" },
}

BossChat =
{
	ScriptFileName 	= MsgScriptFileDefault,

	RegenDialog 	=
	{
		{ Index = "MiddleReport0", FaceCut = "KQ_TrueMarlone" },
		{ Index = "MiddleReport1", FaceCut = "KQ_TrueMara" },
		{ Index = "MiddleReport2", FaceCut = "KQ_TrueMarlone" },
		{ Index = "MiddleReport3", FaceCut = "KQ_TrueMara" },
		{ Index = "MiddleReport4", FaceCut = "KQ_TrueMara" },
	},


	MaraDeadChat 	= { Index = "LastMaraDead" },
	MarloneDeadChat = { Index = "LastMarloneDead" },
}
