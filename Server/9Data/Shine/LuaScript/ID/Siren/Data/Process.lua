--------------------------------------------------------------------------------
--                                Seiren Castle Process Data                                      --
--------------------------------------------------------------------------------

LinkInfo =
{
	ReturnMap	= { MapIndex = "BerFrz01", x = 24870, y = 471 },
}


DelayTime =
{
	AfterInit 			= 5,	-- 던전 입장 후 인스턴스 던전 진행 시작까지 기다리는 시간
	GapDialog			= 3,	-- 페이스컷 사이의 시간
	WaitReturnToHome	= 150,	--
	GapIDReturnNotice	= 5,	--
}

-- 단계가 끝났을 때, 열리는 문 정보
Step_DoorOpenList =
{
	EntranceGuardArea	= { "Door1" },
	EastArea			= { "Door5", "Door6" },
	WestArea			= { "Door7" },
	FallenCenterHall	= { "Door8" },
}

-- 단계 별 죽었는지 확인이 필요한 보스 인덱스
Step_BossDeadCheckList =
{
	EntranceGuardArea	= "S_Varamus",
	CenterGuardArea		= "S_CyrusKey",
	EastArea			= "S_Anais",
	WestArea			= "S_Anika",
	FallenCenterHall	= "S_Hayreddin",
	GuardianAltar		= "S_HayreddinEvo",
	AbyssHall			= "S_Freloan",
}

-- 문이 열렸을 때, 진행되는 단계 정보
Step_DoorOpenCheckList =
{
	CenterGuardArea =
	{
		{ DoorName = "Door2", NextStep = "EastArea" },
		{ DoorName = "Door3", NextStep = "FallenCenterHall" },
		{ DoorName = "Door4", NextStep = "WestArea" },
	}
}

-- 단계 별 이용했는지 확인이 필요한 포탈 인덱스
Step_PortalUseCheckList =
{
	AbyssHall = "Portal3"
}

-- 던전 퀘스트 용 정보
QuestMobKillInfo =
{
	QuestID  		= 2667,
	MobIndex 		= "Daliy_Check_Tower03",
	MaxKillCount 	= 5,
}
