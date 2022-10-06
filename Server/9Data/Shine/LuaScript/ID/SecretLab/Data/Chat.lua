--------------------------------------------------------------------------------
--                      Secret Laboratory Chat Data                           --
--------------------------------------------------------------------------------

ChatInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	EachPattern =
	{

		Pattern_KillAll =
		{
			--1-----------------------------------------------------------------
			{
				BeforeDialog =
				{
					{ SpeakerIndex = "UruSkillChyburn",			Index = "T3_01_01" },
					{ SpeakerIndex = "UruSkillChyburn",			Index = "T3_01_02" },
					{ SpeakerIndex = "UruSkillChyburn",			Index = "T3_01_03" },
					{ SpeakerIndex = "EldWarSkillMarty",		Index = "T3_01_05" },
				},
			},
			--6------------------------------------------------------------------
			{
				BeforeDialog =
				{
					{ SpeakerIndex = "Lab_20",					Index = "T3_06_01" },
					{ SpeakerIndex = "Lab_20",					Index = "T3_06_02" },
					{ SpeakerIndex = "Lab_20",					Index = "T3_06_03" },
				},
			},
			--7------------------------------------------------------------------
			{
				BeforeDialog =
				{
					{ SpeakerIndex = "Lab_25",					Index = "T3_07_01" },
					{ SpeakerIndex = "Lab_25",					Index = "T3_07_02" },
					{ SpeakerIndex = "EldWarSkillMarty",		Index = "T3_07_03" },
				},
			},
		},
		Pattern_TimeAttack =
		{
			--2------------------------------------------------------------------
			{
				BeforeDialog =
				{
					{ SpeakerIndex = "RouSkillRubi",			Index = "T3_02_01" },
					{ SpeakerIndex = "UruGuildLump",			Index = "T3_02_02" },
					{ SpeakerIndex = "UruSmithHans",			Index = "T3_02_03" },
				},
			},
			--3------------------------------------------------------------------
			{
				BeforeDialog =
				{
					{ SpeakerIndex = "EldGuardCaptainShutian",	Index = "T3_03_01" },
					{ SpeakerIndex = "EldGuardCaptainShutian",	Index = "T3_03_02" },
				},

				SemiBossAwakenedDialog =
				{
					{ SpeakerIndex = "Lab_19",					Index = "T3_02_TA01" },
					{ SpeakerIndex = "Lab_19",					Index = "T3_02_TA02" },
				},
			},
			--4------------------------------------------------------------------
			{
				BeforeDialog =
				{
					{ SpeakerIndex = "Lab_Guardian01",			Index = "T3_04_01" },
					{ SpeakerIndex = "Lab_Guardian01",			Index = "T3_04_02" },
					{ SpeakerIndex = "EldScoSkillDeikid",		Index = "T3_04_03" },
				},

				SemiBossAwakenedDialog =
				{
					{ SpeakerIndex = "Lab_19",					Index = "T3_02_TA01" },
					{ SpeakerIndex = "Lab_19",					Index = "T3_02_TA02" },
				},
			},
			--8------------------------------------------------------------------
			{
				BeforeDialog =
				{
					{ SpeakerIndex = "Lab_25",					Index = "T3_08_01" },
					{ SpeakerIndex = "Lab_25",					Index = "T3_08_02" },
				},

				SemiBossAwakenedDialog =
				{
					{ SpeakerIndex = "Lab_23",					Index = "T3_07_TA01" },
					{ SpeakerIndex = "Lab_23",					Index = "T3_07_TA02" },
				},
			},
			--9------------------------------------------------------------------
			{
				BeforeDialog =
				{
					{ SpeakerIndex = "EldWarSkillMarty",		Index = "T3_09_01" },
					{ SpeakerIndex = "EldScoSkillDeikid",		Index = "T3_09_02" },
				},

				SemiBossAwakenedDialog =
				{
					{ SpeakerIndex = "Lab_23",					Index = "T3_07_TA01" },
					{ SpeakerIndex = "Lab_23",					Index = "T3_07_TA02" },
				},
			},
		},
		Pattern_KillBoss =
		{
			--5------------------------------------------------------------------
			{
				BeforeDialog =
				{
					{ SpeakerIndex = "Lab_20",					Index = "T3_05_01" },
					{ SpeakerIndex = "Lab_20",					Index = "T3_05_02" },
					{ SpeakerIndex = "EldScoSkillDeikid",		Index = "T3_05_03" },
				},

				-- Interval : 1 sec
				Summon500Dialog =
				{
					{ SpeakerIndex = "Lab_20",					Index = "T3_06_SUMMON"    },
					{ SpeakerIndex = "EldScoSkillDeikid",		Index = "T3_06_SUMMON_RE" },
				},
			},
			--10-----------------------------------------------------------------
			{
				BeforeDialog =
				{
					{ SpeakerIndex = "Lab_25",					Index = "T3_10_01" },
					{ SpeakerIndex = "Lab_25",					Index = "T3_10_02" },
					{ SpeakerIndex = "EldGuardCaptainShutian",	Index = "T3_10_03" },
					{ SpeakerIndex = "EldGuardCaptainShutian",	Index = "T3_10_04" },
				},

				-- Interval : 1 sec
				Summon750Dialog =
				{
					{ SpeakerIndex = "Lab_25",					Index = "T3_11_SUMMON01"    },
					{ SpeakerIndex = "UruSkillChyburn",			Index = "T3_11_SUMMON01_RE" },
				},

				-- Interval : 1 sec
				Summon700Dialog =
				{
					{ SpeakerIndex = "Lab_25",					Index = "T3_11_SUMMON02"    },
					{ SpeakerIndex = "RouSkillRubi",			Index = "T3_11_SUMMON02_RE" },
				},

				-- Interval : 1 sec
				Summon250Dialog =
				{
					{ SpeakerIndex = "Lab_25",					Index = "T3_11_SUMMON03"    },
					{ SpeakerIndex = "RouSkillRubi",			Index = "T3_11_SUMMON03_RE" },
				},

				-- Interval : BeforeDialog 끝난 직후부터 시작, 일정시간(DelayTime["GapHelpUsChat"]) 마다 랜덤으로..하나씩
				HelpUsChat =
				{
					SpeakerIndex 	= "Lab_Prison",

					{ Index = "T3_11_CHILD01", },
					{ Index = "T3_11_CHILD02", },
					{ Index = "T3_11_CHILD03", },
					{ Index = "T3_11_CHILD04", },
					{ Index = "T3_11_CHILD05", },
					{ Index = "T3_11_CHILD06", },
				},
			},
		},
	},

	RescuedChildren =
	{
		-- cMobDialog( "맵 인덱스", "몬스터 인덱스", "스크립트 파일이름", "스크립트 인덱스" )
		SequentialDialog =
		{
			{ SpeakerIndex = "Lab_25",					Index = "T3_11_01" },
			{ SpeakerIndex = "Lab_25",					Index = "T3_11_02" },
			{ SpeakerIndex = "UruItemMctVellon",		Index = "T3_11_03" },
			{ SpeakerIndex = "UruItemMctVellon",		Index = "T3_11_04" },
		},

		-- cMobChat( 몬스터 핸들, "스크립트 파일이름", "스크립트 인덱스", 채팅창 표시 여부(true, false) )
		AfterAnimationChat =
		{
			{ SpeakerIndex = "Lab_Child_Melt",		Index = "T3_11_CHILD001", },
			{ SpeakerIndex = "Lab_Child_Balus",		Index = "T3_11_CHILD004", },
			{ SpeakerIndex = "Lab_Child_Chechale",	Index = "T3_11_CHILD012", },
			{ SpeakerIndex = "Lab_Child_Fred",		Index = "T3_11_CHILD002", },
		},
	},

}
