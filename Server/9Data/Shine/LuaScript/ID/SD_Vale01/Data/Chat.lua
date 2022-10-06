
ChatInfo =
{
	--ScriptFileName = MsgScriptFileDefault,

	-- 인던 초기화
	InitDungeon =
	{
		{ Index = "SD_Vale02_01" },
		{ Index = "SD_Vale02_02" },
		{ Index = "SD_Vale02_03" },
		{ Index = "SD_Vale02_04" },
		{ Index = "SD_Vale02_05" },
		{ Index = "SD_Vale02_06" },
		{ Index = "SD_Vale01_01" },
	},

	-- 킹크랩 프로세스
	KingCrabProcess =
	{
		AfterBossRegen =
		{
			-- 킹크랩 리젠 직후,
			-- 응? 왠지 땅이 흔들리는거 같지 않아요?
			Index = "SD_Vale01_02",
		},

		AfterBossDead =
		{
			-- 킹크랩 죽은 후,
			-- 해안가에 있는 일반적인 킹크랩과는 뭔가 분위기가 다른데요?
			Index = "SD_Vale01_03",
		},
	},

	-- 킹슬라임 프로세스
	KingSlimeProcess =
	{
		AfterBossRegen =
		{
			-- 킹슬라임 리젠 직후,
			-- 응? 바닥에 저 그림자는 뭐죠?
			Index = "SD_Vale01_04",
		},

		AfterBossDead =
		{
			-- 킹슬 죽은 후,
			-- 확실히 예전에 있던 해안가 몬스터들하고 뭔가 달라졌어요. 다들 조심하세요.
			Index = "SD_Vale01_05",
		},
	},

	-- 미니드래곤 프로세스
	MiniDragonProcess =
	{
		-- 아직 대사 정보 없음
	},

	-- 보너스 스테이지
	BonusStageProcess =
	{
		AfterBossRegen =
		{
			-- 보너스 스테이지 시작시,
			-- 이건 또 뭐야?
			Index = "SD_Vale01_06",
		},

	},

	-- 귀환
	ReturnToHome =
	{
		-- 전열도 정비할 겸 루메너스 촌장님께 이 사실을 보고해두는게 좋겠어요. 일단 마을로 가자구요.
		Index = "SD_Vale01_07",
	},
}


NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	IDReturn =
	{
		{ Index = "KQReturn30", },	-- 30초 남음
		{ Index = nil,          },	-- 25초 남음 : 메세지 없음
		{ Index = "KQReturn20", },	-- 20초 남음
		{ Index = nil,          },	-- 15초 남음 : 메세지 없음
		{ Index = "KQReturn10", },	-- 10초 남음
		{ Index = "KQReturn5" , },	-- 05초 남음
	},
}
