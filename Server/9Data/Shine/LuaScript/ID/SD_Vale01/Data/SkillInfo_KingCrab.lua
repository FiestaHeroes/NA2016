--------------------------------------------------------------
--�� KingCrab ��ų����
--------------------------------------------------------------
SkillInfo_KingCrab =
{
	-- ������
	KC_WhirlWind =
	{
		-- ���� ��ų�ε���
		SkillIndex					= "SD_KingCrabSkill07_N",

		-- ŷũ�� ��ǥ���� Ÿ���� �˻��� ����
		Target_SearchArea		= 1500,
		SpeedRate				= 5000,

		-- ŷũ���� �ɾ��� �����̻�
		AbState_To_KingCrab =
		{
			SpinDamage =
			{
				Index		= "StaSDVale01_Wheel",
				Strength	= 1,
				KeepTime	= 60 * 60 * 1000,		-- ������( ���Ǹ����� ȿ�������� ����)
			},

			NotTargetted =
			{
				Index		= "StaNotTarget",
				Strength	= 1,
				KeepTime	= 60 * 60 * 1000,		-- ������( ���Ǹ����� ȿ�������� ����)
			},
		},
		-- ������ �ִ� ���ӽð�(��)( Ÿ���� �� �������� ���߾, �� �ð��� �Ǹ� ������ ������ ��ų�� �����Ѵ�. )
		SkillKeepTime 		= 10,

		-- ������ �켱���� ��� ���̺�
		-- �� ���Ǻ��� Ȯ���ؼ� �켱���� ������ ���Ǹ�, ������ ���� ���� ������ ���� ���� Ÿ�����Ѵ�.
		Target_Priority =
		{
			-- �����̻�
			-- �� ) StaSDVale01_STN �����̻� �ɷ��ִ� ������ �켱���� +50�� �߰�
			ChrAbState =
			{
				{ Index = "StaSDVale01_STN", 		arg = 50 },
				{ Index = "StaSDVale01_SpdDown", 	arg = 30 },
			},

			-- ������ ����
			-- �� ) Cleric ����(class = 6)�� �켱���� +20�� �߰�
			ChrBaseClass =
			{
			--[[ �� ����
				Fighter		= 1,
				Cleric		= 6,
				Archer		= 11,
				Mage		= 16,
				Joker		= 21,
			--]]
				{ class = 1, 	arg = 10 },
				{ class = 6, 	arg = 50 },
				{ class = 11, 	arg = 30 },
				{ class = 16, 	arg = 30 },
				{ class = 21, 	arg = 10 },
			},
		},

		-- Ÿ���� ŷũ������ �Ÿ��� �� �� �̻��̸�, ����Ÿ������ �����Ѵ�.
		Target_Distance		= 2000,

		-- Ÿ�ٺ��� �̾��� ��ǥ����
		PathListEachTarget =
		{
			ListNum			= 5,	-- Ÿ�� �ϳ��� ���� ��ǥ ����
			Distance		= 200,	-- Ÿ�ٰ� �ݰ� n �ȿ� �ִ� ������ǥ�� ����
		},
	},

	-- ��ǰ����ȯ
	KC_SummonBubble =
	{
		-- ���� ��ų�ε���
		SkillIndex			= "SD_KingCrabSkill09_N",

		-- ��ȯ�� �� �ε���(��ǰ���)
		SummonIndex 		= "SD_CrabFoam",

		-- �ش� ��ų�ִ� ������, ������ ��ȯ�۾��� ������ �ð�(��)
		-- ( �ִϸ��̼� ������ ŷũ���� ���� ���� �� ���� �ð����� �����ϸ� �� )
		SummonStartDelay 	= 1.2,

		-- ��ȯ���� ���� ������ų�ε���
		SummonSkillIndex 	= "SD_CrabFoamSkill01_W",

		-- ��ȯ�� ���� ������
		SummonNum			= 80,

		-- ŷũ�� ����, �������� ��ȯ�� ���� ����( ������ )
		SummonRadius		= 800,

		-- ���ʸ��� ����?
		SummonTick			= 0.05,

		-- ŷũ���� �ɾ��� �����̻�
		AbState_To_KingCrab =
		{
			NotTargetted =
			{
				Index		= "StaNotTarget",
				Strength	= 1,
				KeepTime	= 60 * 60 * 1000,		-- ������( ���Ǹ����� ȿ�������� ����)
			},
		},
	},

}
