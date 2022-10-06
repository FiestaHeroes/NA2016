--------------------------------------------------------------
--※ KingSlime 스킬정보
--------------------------------------------------------------
SkillInfo_KingSlime =
{
	-- 최초낙하( 1회 )
	KS_ShowUp =
	{
		SkillIndex = "SD_KingSlimeSkill05_W",
	},

	-- 강림
	KS_Warp =
	{
		SkillIndex = "SD_KingSlimeSkill04_W",

		-- 해당 스킬애니 시작후, 실제로 타겟팅 불가능하게 처리할 시간(초)
		NotTargetStartDelay = 1.6,

		-- 킹슬라임에 걸어줄 상태이상
		AbState_To_KingSlime =
		{
			NotTargetted =
			{
				Index		= "StaNotTarget",
				Strength	= 1,
				KeepTime	= 10,
			},
		},
	},

	-- 폭격( 몹 소환 )
	KS_BombSlimePiece =
	{
		-- 메인 스킬 인덱스
		SkillIndex_Lump 	= "SD_KingSlimeSkill06_N",
		SkillIndex_Ice 		= "SD_KingSlimeSkill07_N",
		SkillIndex_All 		= "SD_KingSlimeSkill08_N",

		-- 소환할 몹의 마리수
		SummonNum			= 80,

		-- 해당 스킬애니 시작후, 실제로 소환작업을 시작할 시간(초)
		SummonStartDelay 	= 0.5,

		-- 보스몹 기준, 랜덤으로 소환할 원의 범위( 반지름 )
		SummonRadius		= 800,

		-- 몇초마다 리젠?
		SummonTick			= 0.04,

		SummonLump =
		{
			SummonIndex 		= "SD_SlimeLump",
			SummonSkillIndex 	= "SD_SlimeLumpSkill01_W",
		},

		SummonIce =
		{
			SummonIndex 		= "SD_SlimeIce",
			SummonSkillIndex 	= "SD_SlimeIceSkill01_W",
		},
	},
}
