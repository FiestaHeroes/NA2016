--------------------------------------------------------------
--※ MiniDragon 스킬정보
--------------------------------------------------------------
SkillInfo_MiniDragon =
{
	-- 리젠 후 착륙
	MD_ShowUp =
	{
		SkillIndex = "SD_DragonSkill09_W",
	},

	-- 정령소환
	MD_SummonSoul =
	{
		-- 메인 스킬 인덱스
		SkillIndex_Fire 	= "SD_DragonSkill08_N",
		SkillIndex_Ice 		= "SD_DragonSkill12_N",
		SkillIndex_All 		= "SD_DragonSkill13_N",

		-- 소환할 몹의 마리수
		SummonNum			= 100,

		-- 해당 스킬애니 시작후, 실제로 소환작업을 시작할 시간(초)
		SummonStartDelay 	= 0.1,

		-- 보스몹 기준, 랜덤으로 소환할 원의 범위( 반지름 )
		SummonRadius		= 800,

		-- 몇초마다 리젠?
		SummonTick			= 0.03,

		SummonFire =
		{
			SummonIndex 		= "SD_SpiritFire",
			SummonSkillIndex 	= "SD_SpiritFireSkill01_W",
		},

		SummonIce =
		{
			SummonIndex 		= "SD_SpiritIce",
			SummonSkillIndex 	= "SD_SpiritIceSkill01_W",
		},
	},
}
