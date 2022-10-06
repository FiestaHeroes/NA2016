--------------------------------------------------------------------------------
--                                Seiren Castle Process Data                                      --
--------------------------------------------------------------------------------

LinkInfo =
{
	ReturnMap	= { MapIndex = "BerFrz01", x = 24870, y = 471 },
}


DelayTime =
{
	AfterInit 			= 5,	-- ���� ���� �� �ν��Ͻ� ���� ���� ���۱��� ��ٸ��� �ð�
	GapDialog			= 3,	-- ���̽��� ������ �ð�
	WaitReturnToHome	= 150,	--
	GapIDReturnNotice	= 5,	--
}

-- �ܰ谡 ������ ��, ������ �� ����
Step_DoorOpenList =
{
	EntranceGuardArea	= { "Door1" },
	EastArea			= { "Door5", "Door6" },
	WestArea			= { "Door7" },
	FallenCenterHall	= { "Door8" },
}

-- �ܰ� �� �׾����� Ȯ���� �ʿ��� ���� �ε���
Step_BossDeadCheckList =
{
	EntranceGuardArea	= "SH_Varamus",
	CenterGuardArea		= "SH_CyrusKey",
	EastArea			= "SH_Anais",
	WestArea			= "SH_Anika",
	FallenCenterHall	= "SH_Hayreddin",
	GuardianAltar		= "SH_HayreddinEvo",
	AbyssHall			= "SH_Freloan",
}

-- ���� ������ ��, ����Ǵ� �ܰ� ����
Step_DoorOpenCheckList =
{
	CenterGuardArea =
	{
		{ DoorName = "Door2", NextStep = "EastArea" },
		{ DoorName = "Door3", NextStep = "FallenCenterHall" },
		{ DoorName = "Door4", NextStep = "WestArea" },
	}
}

-- �ܰ� �� �̿��ߴ��� Ȯ���� �ʿ��� ��Ż �ε���
Step_PortalUseCheckList =
{
	AbyssHall = "Portal3"
}

-- ���� ����Ʈ �� ����
QuestMobKillInfo =
{
	QuestID  		= 2667,
	MobIndex 		= "Daliy_Check_Tower03",
	MaxKillCount 	= 5,
}
