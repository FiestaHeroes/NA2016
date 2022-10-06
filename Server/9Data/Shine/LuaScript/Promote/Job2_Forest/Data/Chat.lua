--------------------------------------------------------------------------------
--                        Promote Job2_Forest Name Data                       --
--------------------------------------------------------------------------------
-- npc 대사 정보
ChatInfo =
{
	ScriptFileName 		= MsgScriptFileDefault,

	FirstMeeting =
	{
		{ SpeakerIndex = "Job2_BraveR",	 	MsgIndex = "FirstR0",},
		{ SpeakerIndex = "Job2_BraveR", 	MsgIndex = "FirstR1",},
		{ SpeakerIndex = "Job2_YongE", 		MsgIndex = "FirstE2",},
		{ SpeakerIndex = "Job2_BraveR", 	MsgIndex = "FirstR3",},
		{ SpeakerIndex = "Job2_YongE", 		MsgIndex = "FirstE4",},
		{ SpeakerIndex = "Job2_YongE", 		MsgIndex = "FirstE5",},
		{ SpeakerIndex = "Job2_BraveR", 	MsgIndex = "FirstR6",},
		{ SpeakerIndex = "Job2_BraveR", 	MsgIndex = "FirstR7",},
	},

	DialogSecond =
	{
		{ SpeakerIndex = "Job2_BraveR",	 	MsgIndex = "SecondR0",},
		{ SpeakerIndex = "Job2_YongE",	 	MsgIndex = "SecondE1",},
		{ SpeakerIndex = "Job2_YongE",	 	MsgIndex = "SecondE2",},
	},

	DialogThird =
	{
		{ SpeakerIndex = "Job2_YongE",	 	MsgIndex = "ThirdE0",},
		{ SpeakerIndex = "Job2_BraveR",	 	MsgIndex = "ThirdR1",},
		{ SpeakerIndex = "Job2_YongE",	 	MsgIndex = "ThirdE2",},

	},

	DialogFourth =
	{
		{ SpeakerIndex = "Job2_YongE",	 	MsgIndex = "ForthE0",},
		{ SpeakerIndex = "Job2_BraveR",	 	MsgIndex = "ForthR1",},
		{ SpeakerIndex = "Job2_YongE",	 	MsgIndex = "ForthE2",},
	},

	QuestSuccess =
	{
		{ SpeakerIndex = "Job2_BraveR", 	MsgIndex = "FifthR0",},
		{ SpeakerIndex = "Job2_YongE", 		MsgIndex = "FifthE1",},
		{ SpeakerIndex = "Job2_BraveR", 	MsgIndex = "FifthR2",},
		{ SpeakerIndex = "Job2_YongE", 		MsgIndex = "FifthE3",},
		{ SpeakerIndex = "Job2_BraveR", 	MsgIndex = "FifthR4",},
		{ SpeakerIndex = "Job2_BraveR", 	MsgIndex = "FifthR5",},
		{ SpeakerIndex = "Job2_BraveR", 	MsgIndex = "FifthR6",},
	},
}


-- ReturnToHome 공지
NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	MissionObj =
	{
		Index = "MissionObj"
	},

	IDReturn =
	{
		{ Index = "RouReturn30", },		-- 30초 남음
		{ Index = nil,          },		-- 25초 남음 : 메세지 없음
		{ Index = "RouReturn20", },		-- 20초 남음
		{ Index = nil,          },		-- 15초 남음 : 메세지 없음
		{ Index = "RouReturn10", },		-- 10초 남음
		{ Index = "RouReturn5" , },		-- 05초 남음
	},
}

