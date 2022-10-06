--------------------------------------------------------------------------------
--                                 Chat Data                                  --
--------------------------------------------------------------------------------

ChatInfo =
{
	-------------------------------------------------
	-- 1구역 ~ 4구역에 해당
	-------------------------------------------------
	WayToBossRoom_FaceCut =
	{
		-- 1구역 입장시
		{
			"Mildwin01_1",
			"Mildwin01_2",
			"Mildwin01_3",
		},

		-- 2구역 입장시
		{
			"Mildwin01_4",
			"Mildwin01_5",
			"Mildwin01_6",
			"Mildwin01_7",
			"Mildwin01_8",
			"Mildwin01_9",
		},

		-- 3구역 입장시
		{
			"Mildwin02_1"
		},


		-- 4구역 입장시
		{
			"Mildwin03_1" ,
		},


		-- 5구역 입장시
		{
			"Mildwin04_1" ,
		},
	},


	-------------------------------------------------
	-- 아래는 5구역에 해당
	-------------------------------------------------
	-- 5구역 페이스컷 영역 입장시( AreaName = "Area5FaceCut1", "Area5FaceCut2" )
	BossRoom_Stairway =
	{
		"Mildwin05_1" ,
		"Blakhan05_1" ,
		"Mildwin05_2" ,
		"Blakhan05_2" ,
		"Mildwin05_3" ,
	},

	-- 5구역 강제이동시작영역 입장시( AreaName = "Teleport1", "Teleport2" )
	BossRoom_CenterHall =
	{
		"Blakhan05_3" ,
		"Mildwin05_4" ,
		"Mildwin05_5" ,
		"Mildwin05_6" ,
	},

	-- 5구역 강제이동도착영역 입장 후, 파겔스 대사
	BossRoom_Fagels_Show =
	{
		"Fargels06_1" ,
	},

	-- 각 봉인석 파괴시
	Seal_Broken =
	{
		"IDBla_01",
	},

	-- 블라칸 사망시
	Boss_Blakan_Dead =
	{
		"Blakhan06_1" ,
	},

	-- 블라칸 구출시 ( 모든 봉인석 파괴시 )
	Boss_Blakan_Save =
	{
		"Mildwin06_1" ,
		"Blakhan06_3" ,
		"Blakhan06_4" ,
		"Blakhan06_5" ,
		"Fargels06_2" ,
	},

	-- 파겔스 사망시
	Boss_Fagels_Dead =
	{
		"Fargels07_1" ,
		"Fargels07_2" ,

		-- 밀드윈 소환
		"Mildwin07_1" ,
		"Mildwin07_2" ,
		"Mildwin07_3" ,
		"Mildwin07_4" ,
	},
}



--------------------------------------------------------------------------------
--                                Notice Data                                 --
--------------------------------------------------------------------------------

NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	IDReturn =
	{
		--{ Index = "KQReturn30", },	-- 30초 남음
		--{ Index = nil,          },	-- 25초 남음 : 메세지 없음
		{ Index = "KQReturn20", },		-- 20초 남음
		{ Index = nil,          },		-- 15초 남음 : 메세지 없음
		{ Index = "KQReturn10", },		-- 10초 남음
		{ Index = "KQReturn5" , },		-- 05초 남음
	},
}
