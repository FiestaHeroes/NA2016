--------------------------------------------------------------------------------
--                                Servant Data                                --
--------------------------------------------------------------------------------


-- ����ũ
Cake =
{
	MobIndex		= "BallCake01",										-- �� �ε���
	SkillIndex		= "BallCake_Skill01_N",								-- ��ų �ε���
	Dist			= 50,												-- ���� �� üũ ����
	Abstate 		= { Index = "StaKnockBackFly", KeepTime = 2000 },	-- ���� �� �ɾ��� �����̻� ����
	SetAbstateWait	= 0.2,												-- SetAbstateWait �ð� �� �����̻� ������
	LinktoWait		= 2,												-- �������� �������� ���ð�
}

-- ���������
DrinkCannon =
{
	MobIndex	= "BallCannon02",									-- �� �ε���
	Dist		= 100,												-- ���� �� üũ ����
	Abstate 	= { Index = "StaKnockBackRoll", KeepTime = 2000 },	-- ���� �� �ɾ��� �����̻� ����
	LinktoWait	= 2,												-- �������� �������� ���ð�
}
