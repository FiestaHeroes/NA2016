--------------------------------------------------------------------------------
--                       Seiren Castle Chat Data                              --
--------------------------------------------------------------------------------

ChatInfo =
{
	ScriptFileName = MsgScriptFileDefault,


	InitDungeon =
	{
		AfterDialog =
		{
			{ SpeakerIndex = "S_Hayreddin",	Index = "Hayreddin_FaceCut01" },
		}
	},

	CenterGuardArea =
	{
		BeforeDialog =
		{
			{ SpeakerIndex = "S_CyrusKey",	Index = "CyrusKey_FaceCut01" },
		},

		AfterDialog =
		{
			{ SpeakerIndex = "S_CyrusKey",	Index = "CyrusKey_FaceCut02" },
		},
	},

	FallenCenterHall =
	{

	},

	GuardianAltar =
	{
		BeforeDialog =
		{
			{ SpeakerIndex = "S_Hayreddin",	Index = "HayEvo_FaceCut01" },
			{ SpeakerIndex = "S_Hayreddin",	Index = "HayEvo_FaceCut02" },
		},

		AfterDialog =
		{
			{ SpeakerIndex = "S_Hayreddin",	Index = "HayEvo_FaceCut03" },
		},
	},

	AbyssHall =
	{
		BeforeDialog =
		{
			{ SpeakerIndex = "S_Freloan",	Index = "Freloan_FaceCut01" },
			{ SpeakerIndex = "S_Freloan",	Index = "Freloan_FaceCut02" },
		},

		AfterDialog =
		{
			{ SpeakerIndex = "S_Freloan",	Index = "Freloan_FaceCut03" },
		},
	},


	Hayreddin_EscapeDialog = { SpeakerIndex = "S_Hayreddin", Index = "Hayreddin_FaceCut02" },


	SystemMessage =
	{
		Error_DoorOpen = "SystemMessage01",
	},
}


NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	IDReturn =
	{
		{ Index = "KQReturn30", },	-- 30�� ����
		{ Index = nil,          },	-- 25�� ���� : �޼��� ����
		{ Index = "KQReturn20", },	-- 20�� ����
		{ Index = nil,          },	-- 15�� ���� : �޼��� ����
		{ Index = "KQReturn10", },	-- 10�� ����
		{ Index = "KQReturn5" , },	-- 05�� ����
	},
}
