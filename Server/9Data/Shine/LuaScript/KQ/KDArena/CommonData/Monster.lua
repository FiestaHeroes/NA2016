--------------------------------------------------------------------------------
--                           Arena Monster Data                               --
--------------------------------------------------------------------------------


ArenaCrystal =
{
	-- 일정 간격으로 사용하는 스킬
	Routine =
	{
		SkillIndex	= "ArenaCrystal_Skill01_W",
		BlastTime	= 10,
	},

	-- 죽을때 사용하는 스킬
	Dead =
	{
		SkillIndex	= "ArenaCrystal_Skill02_W",
		BlastTime	= 2,
	},

	-- 리젠시 걸리는 상태이상
	RegenAbsatate =
	{
		Index		= "StaArenaMinHP",
		Str			= 1,
		KeepTime	= 900000
	},
}
