--------------------------------------------------------------------------------
--                         Tower Of Iyzel NPC Data                            --
--------------------------------------------------------------------------------

NPC_GuardChat =
{
	ScriptFileName = MsgScriptFileDefault,

	-- 해당 페이스컷의 주인공
	SpeakerIndex = "EldSpeGuard01",

	-- 각 층의 단계가 시작할때의 페이스컷
	StartDialog =
	{
		Floor01 =
		{
			{ Index = "Chat0101" },
			{ Index = "Chat0102" },
			{ Index = "Chat0103" },
		},

		Floor02 =
		{
			{ Index = "Chat0201" },
		},

		Floor03 =
		{
			{ Index = "Chat0301" },
		},

		Floor04 =
		{
			{ Index = "Chat0401" },
		},

		Floor05 =
		{
			{ Index = "Chat0501" },
			{ Index = "Chat0502" },
			{ Index = "Chat0503" },
		},

		Floor06 =
		{
			{ Index = "Chat0601" },
			{ Index = "Chat0602" },
		},

		Floor07 =
		{
			{ Index = "Chat0701" },
		},

		Floor08 =
		{
			{ Index = "Chat0801" },
		},

		Floor09 =
		{
			{ Index = "Chat0901" },
			{ Index = "Chat0902" },
		},

		Floor10 =
		{
			{ Index = "Chat1001" },
			{ Index = "Chat1002" },
			{ Index = "Chat1003" },
		},

		Floor11 =
		{
			{ Index = "Chat1101" },
		},

		Floor12 =
		{
			{ Index = "Chat1201" },
		},

		Floor13 =
		{
			{ Index = "Chat1301" },
			{ Index = "Chat1302" },
		},

		Floor14 =
		{
			{ Index = "Chat1401" },
			{ Index = "Chat1402" },
			{ Index = "Chat1403" },
		},

		Floor15 =
		{
			{ Index = "Chat1501" },
		},

		Floor16 =
		{
			{ Index = "Chat1601" },
			{ Index = "Chat1602" },
		},

		Floor17 =
		{
			{ Index = "Chat1701" },
			{ Index = "Chat1702" },
			{ Index = "Chat1703" },
		},

		Floor18 =
		{
			{ Index = "Chat1801" },
			{ Index = "Chat1802" },
			{ Index = "Chat1803" },
		},
	},

	-- 각 보스전 중에 솬할 때 뜨는 페이스컷
	BossBattleDialog =
	{
		Floor04 =
		{
			{ Index = "Chat0501Boss" },
			{ Index = "Chat0502Boss" },
		},

		Floor09 =
		{
			{ Index = "Chat1001Boss" },
			{ Index = "Chat1002Boss" },
		},

		Floor13 =
		{
			{ Index = "Chat1401Boss" },
			{ Index = "Chat1402Boss" },
		},

		Floor19 =
		{
			{ Index = "Chat2001Boss" },
			{ Index = "Chat2002Boss" },
			{ Index = "Chat2003Boss" },
		},
	},

	-- 해당 층을 클리어시 뜨는 페이스컷
	ClearDialog =
	{
		Floor19 =
		{
			{ Index = "Chat2001" },
			{ Index = "Chat2002" },
			{ Index = "Chat2003" },
		},
	},

}
