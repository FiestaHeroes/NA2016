--------------------------------------------------------------------------------
--                          Emperor Slime Boss Data                           --
--------------------------------------------------------------------------------

KingSlimeChat =
{
	ScriptFileName = MsgScriptFileDefault,

	SpeakerIndex = "KQ_KingSlime", -- ���� ���ҽ� ��Ȱ��

	FloorClearDialog =
	{
		{ Index = "King_FaceCut01" },	-- 1�� Ŭ�����	: Ȳ������ ������� ���� ���̴�!!
		{ Index = "King_FaceCut02" },	-- 2�� Ŭ����� : ��� �����ӵ��� ��Ͻ� ������� óġ�϶�!!
	},

	DeathDialogIndex = "King_FaceCut03", -- 1, 2��° ���� ŷ�����Ӹ� : ���� ��¥ ŷ���������� ���̳�? ������! ������ �� �� ������!
}


EmperorSlimeChat =
{
	ScriptFileName = MsgScriptFileDefault,

	SpeakerIndex = "Emp_EmperorSlime",

	WarningDialog =
	{
		{ Index = "Emperor_FaceCut01" }, -- ŷ������ 3������ �׾ ������ ���۵ɶ� : ���� Ȳ���� �Ļ�ð��� �����ϴ°�? ������ �༮�� ȥ���� ���ָ�!!
	},

	SummonMobShout 	=
	{
		FirstSummon  = { Index = "Emperor_Shout01" }, -- ������! �� ������ �������� ��¡�϶�!
		SecondSummon = { Index = "Emperor_Shout02" }, -- �����ϴ±�! �ұ��� ����� ���� �����ӵ��̿�! ����!
		ThirdSummon  = { Index = "Emperor_Shout03" }, -- ��ö���� �����ӵ��̿�! ���� ���� ����� ���̱���!
		LastSummon   = { Index = "Emperor_Shout04" }, -- ����! �������ӵ��̿�.. ���� ȸ������ ��Ͻ� ������� �����ݰ� �شٿ�!
	},

	DeathDialogIndex = "Emperor_FaceCut02", -- Ū.. �̷��� �㹫�ϰ� ���ϴٴ�.. � �������̵� ������ �� �� ���̴�!
}




EmperorSlimeSkill =
{
	-- �̸��� ���ڸ��� ��ȯ�� �� �ֵ��� ������ ������ġ�� ���� ������ �� �ִ� �ִ� �Ÿ�
	LimitDistanceFromOrigin = 1200,

	SummonEffect =
	{
		-- ���ۺ��� ���� ��ų
		EffectSkillIndex = "Emp_EmperorSlime_Skill02_N",
		AnimationKeepSec = 3,
		-- 3�ʿ� 5����
	},

	TornadoEffect =
	{
		-- ���� ��ȯ�ϸ� �˾Ƽ� ȸ���� ��� �߻��ϰ� ����� ��Ʒ� ����
		CenterMobIndex = "Emp_Tornado",
		MobLifeSec = 4,
	},

	FirstSummon =
	{
		HP_Rate = 800,

		SummonMobsTableIndex = "SlimeTroops",
		SummonCount = 1,
		SummonGapSec = nil, -- ��ȿ

		MobLifeSec = nil,	-- ���� �ð� ����

		bBossSpinning = true,
		bSummonAreaCenterTornado = true,
	},

	SecondSummon =
	{
		HP_Rate = 600,

		SummonMobsTableIndex = "FireSlimeTroops",
		SummonCount = 3,
		SummonGapSec = 20,

		MobLifeSec = nil,

		bBossSpinning = true,
		bSummonAreaCenterTornado = true,
	},

	ThirdSummon =
	{
		HP_Rate = 400,

		SummonMobsTableIndex = "IronSlimeTroops",
		SummonCount = nil,	-- ������
		SummonGapSec = 20,

		MobLifeSec = 15,

		bBossSpinning = true,
		bSummonAreaCenterTornado = true,

		-- �Ʒ��� ��� ��ȯ ����
		-- ���� �� 40�� �Ѿ ��
		-- ���� ��׷� �ʱ�ȭ��
		-- ���� �����

	},

	LastSummon =
	{
		HP_Rate = 200,

		SummonMobsTableIndex = "TwinQueenSlimes",
		SummonCount = 1,
		SummonGapSec = nil,

		MobLifeSec = nil,				-- �ð��� ���� ������ ������ �Ʒ� ������ ����
		MobVanishCondBossHP_Rate = 450, -- ���� HP �� �� ������ �Ѿ�� �������� �Ҹ�

		bBossSpinning = true,
		bSummonAreaCenterTornado = false,

		-- �Ʒ��� ��� �� ������ �����
		-- ����HP 45%�̻��
		-- 1���� ��� �� 30�� �̳��� �ٸ� 1������ ��� ��
		-- ���� ��׷� �ʱ�ȭ
	},
}

-- ���������� ���ݾ��� ���� �Ѵ�. : ������ ���� �ʿ�
QueenSlimeInfo =
{
	-- �ش� ���� ������ �������Ӹ��� ����ȴ�.
	HealInfo =
	{
-- ���̵��� ���� ���������� �������� ���̵� 1�� 2~5��, 2�� 6~10�� 3�� 11~15������ 1���׽�Ʈ�ÿ��� �ְ��̵��� ����
		HealAmount1 = 3000,
		HealAmount2 = 5000,
		HealAmount3 = 10000,
		HealGapSec = 2,
		HealEffectIndex = "EKQ_MD_BuffSkil1_1",
	},

	RevivalInfo =
	{
		-- �Ѹ����� ���� �� �Ʒ� �ð� �ȿ� �ٸ� ���������� ������ ������ �ǻ�Ƴ���.
		RevivalSec = 30,

		AbstateIndex = "StaCount30",
		AbstateStrength = 1,
		AbstateKeepTime = 30000,
	},
}

