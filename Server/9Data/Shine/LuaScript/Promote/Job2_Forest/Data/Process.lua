--------------------------------------------------------------------------------
--                Promote Job2_Forest Process Data                            --
--------------------------------------------------------------------------------

INVALID_HANDEL				= -1

-- ��ũ ��ġ ����
LinkInfo =
{
	ReturnMap = { MapIndex = "RouN", X = 7310, Y = 7102 },
}


-- ���� �ð� ����
DelayTime =
{
	LimitTime					= 300,		-- �÷��� ���ѽð�
	FindHeroLimitTime			= 300,		-- �� �ð� ���� Ư������(Job2_Zone02)���� �̵��ؾ� ��

	GapDialog					= 3,		-- Npc��� ��½ð�����
	GapReturnNotice				= 5,		-- ReturnToHome()�� �����޽��� ��½ð�����

	WaitMobRegen				= 1,		-- �� ��ȯ�� ��, WaitMobRegen��ŭ ��ٷȴٰ� �� ī����
	WaitSeconds					= 2,		-- ��� �Ϸ��� �� �ð���ŭ �ִٰ� �����ܰ� ����

	WaitReturnToHome			= 3,		-- ReturnToHome() ���ð�

	WaitDialogSecond			= 60,		-- BattleFirst() ������, DialogSecond() �����ϱ���� ���ð�
	WaitDialogThird				= 60,		-- BattleSecond() ������, DialogThird() �����ϱ���� ���ð�
	WaitDialogFourth			= 60,		-- BattleThird() ������, DialogFourth() �����ϱ���� ���ð�
}


-- ���� ����
AreaInfo =
{
	FindNPC = "Job2_Zone02",
}


-- ����Ʈ ������ ȹ�������
RewardItem =
{
	Index = "Job2_RouNec" ,
}

