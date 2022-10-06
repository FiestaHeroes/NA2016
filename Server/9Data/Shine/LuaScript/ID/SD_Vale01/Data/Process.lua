--------------------------------------------------------------------------------
--                                Process Data                                      --
--------------------------------------------------------------------------------

INVALID_HANDLE 			= -1

--------------------------------------------------------------
--�� ���� ���� DelayTime ����
--------------------------------------------------------------
DelayTime =
{
	AfterInit 					= 5,	-- ���� ���� ��, ù ��� ��½ñ����� ���ð�
	GapDialog					= 3,	-- ���̽��� ������ �ð�
	GapIDReturnNotice			= 5,	--

	WaitKingCrabProcess			= 5,	-- InitDungeon 			-> KingCrabProcess ���ð�
	WaitKingSlimeProcess		= 5,	-- KingCrabProcess 		-> KingSlimeProcess ���ð�
	WaitMiniDragonProcess 		= 5,	-- KingSlimeProcess 	-> MiniDragonProcess ���ð�

	WaitAfterMiniDragonProcess 	= 5,	-- MiniDragonProcess 	-> BonusStage/ReturnToHome ���ð�
	WaitReturnToHome			= 5,
}

--------------------------------------------------------------
--�� ���� �ð� ����
--------------------------------------------------------------
-- �� �ð�(��)�ȿ� �̴ϵ巡�� ���̸� ���ʽ��������� ����
LimitTime =
{
	ForBonusStage	   = 900,
}

--------------------------------------------------------------
--�� ReturnMap ����
--------------------------------------------------------------
-- ����Ʈ�� ������ ������ �ʴ� ������, ���� �ð��� ������ �̵����� �� ��ǥ
LinkInfo =
{
	ReturnMap	= { MapIndex = "RouN", x = 5292, y = 5779 },
}

--------------------------------------------------------------
--�� �� ��ǥ ����
--------------------------------------------------------------
MapInfo =
{
	CenterCoord 	= { x = 5620, y = 6850 },	-- �� �߾� ��ǥ
	UserLinkCoord 	= { x = 5922, y = 5765 },	-- ����Ʈ ���ؼ� ���������� ���� ������ǥ
}


--------------------------------------------------------------
--�� �� ������ ��ġ������ ���޵� ��������
--------------------------------------------------------------
RewardItemInfo =
{
	KingCrabProcess 	= { Index = "IM_SD_Vale01", Num = 1 },
	KingSlimeProcess 	= { Index = "IM_SD_Vale01", Num = 1 },
	--MiniDragonProcess	= { Index = "IM_SD_Vale01", Num = 1 },
	BonusStageProcess 	= { Index = "IM_SD_Vale01", Num = 1 },
}











