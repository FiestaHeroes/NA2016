--------------------------------------------------------------
--�� MiniDragon ��ų����
--------------------------------------------------------------
SkillInfo_MiniDragon =
{
	-- ���� �� ����
	MD_ShowUp =
	{
		SkillIndex = "SD_DragonSkill09_W",
	},

	-- ���ɼ�ȯ
	MD_SummonSoul =
	{
		-- ���� ��ų �ε���
		SkillIndex_Fire 	= "SD_DragonSkill08_N",
		SkillIndex_Ice 		= "SD_DragonSkill12_N",
		SkillIndex_All 		= "SD_DragonSkill13_N",

		-- ��ȯ�� ���� ������
		SummonNum			= 100,

		-- �ش� ��ų�ִ� ������, ������ ��ȯ�۾��� ������ �ð�(��)
		SummonStartDelay 	= 0.1,

		-- ������ ����, �������� ��ȯ�� ���� ����( ������ )
		SummonRadius		= 800,

		-- ���ʸ��� ����?
		SummonTick			= 0.03,

		SummonFire =
		{
			SummonIndex 		= "SD_SpiritFire",
			SummonSkillIndex 	= "SD_SpiritFireSkill01_W",
		},

		SummonIce =
		{
			SummonIndex 		= "SD_SpiritIce",
			SummonSkillIndex 	= "SD_SpiritIceSkill01_W",
		},
	},
}
