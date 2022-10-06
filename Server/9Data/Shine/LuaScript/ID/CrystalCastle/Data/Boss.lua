--------------------------------------------------------------------------------
--                         Crystal Castle Boss Data                           --
--------------------------------------------------------------------------------


-- ���� ��ų�� �ߵ��Ǵ� �Ѱ�ġ�� ���س��� ���̺�
ThresholdTable =
{
	SummonHP_Boss1 = { 750, 500, 250, },
	SummonHP_Boss2 = { 750, 500, 250, },
	SummonHP_Boss3 = { 750, 500, 250, 200, 150, },
}


-- �հ谡 100�� �ǵ��� ������ ��, 0 �Ǵ� �ڿ����θ� ���� ����
-- ���� Ÿ�� �߰�/���� �� �ҽ� ���� �ʿ�, Ȯ�� ����ÿ��� ���� �������� �ذ��
BossSelectProbablityPercent =
{
	Boss1 = 40,
	Boss2 = 40,
	Boss3 = 20,
}


BossArea =
{
	Index = "Tower02_A11",

	-- ������ �� ������ ī��Ʈ : ���� 0.5�ʸ��� �����ϹǷ� 10�ʸ� ���ϸ� 20�� �Է��ؾ���.
	TriggerCount = 20,
}

-- if cSetAbstate( ��ü �ڵ�, "�����̻� �ε���", ����, ���ӽð� ) == nil then
BossAbstate =
{
	AC_Plus  = { Index = "StaMobACPlus",   Strength = 1, KeepTime = 3600000 },
	MR_Plus  = { Index = "StaMobMRPlus",   Strength = 1, KeepTime = 3600000 },
	Immortal = { Index = "StaMobImmortal", Strength = 1, KeepTime = 3600000 },
}


-- ���� ��ų
BossSkill =
{
	-- �ܸ� ��ȯ
	SummonHP_Boss1 =
	{
		HP750 =
		{
			SummonMobs =
			{
				{ Index = "C_LizardManIyzel", 		Count = 5, },
			},
		},

		HP500 =
		{
			SummonMobs =
			{
				{ Index = "C_DarkLizardManIyzel", 	Count = 1, },
			},
		},

		HP250 =
		{
			SummonMobs =
			{
				{ Index = "C_LizardManIyzel", 		Count = 5, },
				{ Index = "C_DarkLizardManIyzel", 	Count = 1, },
			},
		},
	},

	SummonHP_Boss2 =
	{
		HP750 =
		{
			SummonMobs =
			{
				{ Index = "C_OrcIyzel", 		Count = 5, },
			},
		},

		HP500 =
		{
			SummonMobs =
			{
				{ Index = "C_CurseOrcIyzel", 	Count = 1, },
			},
		},

		HP250 =
		{
			SummonMobs =
			{
				{ Index = "C_OrcIyzel", 		Count = 5, },
				{ Index = "C_CurseOrcIyzel", 	Count = 1, },
			},
		},
	},

	SummonHP_Boss3 =
	{
		HP750 =
		{
			SummonMobs =
			{
				{ Index = "C_SkelArcherIyzel", 		Count = 5, },
			},
		},

		HP500 =
		{
			SummonMobs =
			{
				{ Index = "C_OneSkelArcherIyzel", 	Count = 3, },
			},
		},

		HP250 =
		{
			SummonMobs =
			{
				{ Index = "C_OneSkelArcherIyzel", 	Count = 3, },
			},
		},

		HP200 =
		{
			SummonMobs =
			{
				{ Index = "C_SkelArcherIyzel", 		Count = 5, },
				{ Index = "C_OneSkelArcherIyzel", 	Count = 3, },
			},

			RegenMobs =
			{
				{ Index = "C_PillarofLight", x = 9094, y = 11259, dir = 0, },
				{ Index = "C_PillarofLight", x = 8746, y = 11481, dir = 0, },
				{ Index = "C_PillarofLight", x = 8578, y = 11156, dir = 0, },
				{ Index = "C_PillarofLight", x = 8922, y = 10969, dir = 0, },
			},
		},

		HP150 =
		{
			SummonMobs =
			{
				{ Index = "C_SkelArcherIyzel", 		Count = 5, },
				{ Index = "C_OneSkelArcherIyzel", 	Count = 3, },
			},
		},
	},
}
