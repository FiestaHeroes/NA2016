--------------------------------------------------------------
--�� KingSlime ��ų����
--------------------------------------------------------------
SkillInfo_KingSlime =
{
	-- ���ʳ���( 1ȸ )
	KS_ShowUp =
	{
		SkillIndex = "SD_KingSlimeSkill05_W",
	},

	-- ����
	KS_Warp =
	{
		SkillIndex = "SD_KingSlimeSkill04_W",

		-- �ش� ��ų�ִ� ������, ������ Ÿ���� �Ұ����ϰ� ó���� �ð�(��)
		NotTargetStartDelay = 1.6,

		-- ŷ�����ӿ� �ɾ��� �����̻�
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

	-- ����( �� ��ȯ )
	KS_BombSlimePiece =
	{
		-- ���� ��ų �ε���
		SkillIndex_Lump 	= "SD_KingSlimeSkill06_N",
		SkillIndex_Ice 		= "SD_KingSlimeSkill07_N",
		SkillIndex_All 		= "SD_KingSlimeSkill08_N",

		-- ��ȯ�� ���� ������
		SummonNum			= 80,

		-- �ش� ��ų�ִ� ������, ������ ��ȯ�۾��� ������ �ð�(��)
		SummonStartDelay 	= 0.5,

		-- ������ ����, �������� ��ȯ�� ���� ����( ������ )
		SummonRadius		= 800,

		-- ���ʸ��� ����?
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
