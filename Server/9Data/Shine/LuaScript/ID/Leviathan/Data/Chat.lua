
ChatInfo =
{
	-- 인던 초기화
	InitDungeon =
	{
	},

	-- 킹부기 프로세스
	KingBoogyStep =
	{
		-- 던전 입장시
		Start =
		{
			{ Index = "Levi_RouNChief00", },	-- Soldiers, be careful!
			{ Index = "Levi_RouNChief01", },	-- I know you want to see how Leviathan looks like, but don't push it.  This is a dangerous place...
			{ Index = "Levi_RouNChief02", },	-- Gather some valuable artifacts and come back safe.  Although it won't be easy.....
		},
	},

	-- 킹크랩 프로세스
	KingCrabStep =
	{
		-- 킹 부기 죽인 후
		AfterKingBoogyDead =
		{
			{ Index = "Levi_KingBoogy00", },	-- We captured King Boogy!
			{ Index = "Levi_KingBoogy01", },
			{ Index = "Levi_KingBoogy02", },
			{ Index = "Levi_KingBoogy03", },
			{ Index = "Levi_KingBoogy04", },
		},

	},


	-- 레비아탄 프로세스
	LeviathanStep =
	{
		-- 킹크랩 죽인 후
		AfterKingCrabDead =
		{
			{ Index = "Levi_KingCrap00", },		-- Wow, you defeated King Crab.  Nice job.
			{ Index = "Levi_KingCrap01", },
			{ Index = "Levi_KingCrap02", },
			{ Index = "Levi_KingCrap03", },
			{ Index = "Levi_KingCrap04", },
		},


	},

	-- 인던 종료
	ReturnToHome =
	{
		-- 레비아탄 죽인 후
		AfterLeviDead =
		{
			{ Index = "Levi_Leviathan00", },	-- Unbelievable!
			{ Index = "Levi_Leviathan01", },
			{ Index = "Levi_Leviathan02", },
			{ Index = "Levi_Leviathan03", },
			{ Index = "Levi_Leviathan04", },
		},

	},

}

