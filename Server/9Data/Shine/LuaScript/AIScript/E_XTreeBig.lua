require( "common" )


--------------------------------------------------------------------
--�ءءءءءءءءءءءءءءءءءءءءءءءءءءءءءءءء�
--// [S_21003] ũ��������_2014_�̺�Ʈ ���� ������
---------------------------------------------------------START-----
--�ءءءءءءءءءءءءءءءءءءءءءءءءءءءءءءءء�
--------------------------------------------------------------------

--------------------------------------------------------------------
--// �������� ó�� ���� ������
--------------------------------------------------------------------

-- ���潺 �̺�Ʈ ����� ����� �ִϸ��̼�
TREE_DEFENCE_TABLE =
{
	TREE_DIE 		= { AniIndex = "E_XTreeBig_Idle05", },	-- �μ����� ���
	TREE_REGEN	 	= { AniIndex = "E_XTreeBig_Idle00", },	-- ������� �ǵ���( 0�ܰ�� )
}

--------------------------------------------------------------------
--// ��Ÿ ���� ó�� ���� ������
--------------------------------------------------------------------

SANTA_KEBING_MOB_REGEN_TABLE =
{
	RunSpeed 		= 700,
	MobIndex		= "KebingX_14",

	{ RegenX = 18427, RegenY = 15754, 	Dir = 0,},
	{ RegenX = 13598, RegenY = 15727, 	Dir = 0,},
	{ RegenX = 14685, RegenY = 9746,	Dir = 0,},
	{ RegenX = 11327, RegenY = 13423, 	Dir = 0,},
}


SANTA_KEBING_MOB_ANI_TABLE =
{
	CastAniIndex		= "KebingKnockBackCasting",
	CastAniKeepTime		= 3,							-- CastAniIndex ����ð�. �� �ð���ŭ CastAniIndex �ִ� ��� ��, SwingAniIndex�� �Ѿ

	SwingAniIndex		= "KebingKnockBackSwing",
}

-- �̵� ���°� flag
MOVESTATE = {}
MOVESTATE["STOP"] = "STOP"
MOVESTATE["MOVE"] = "MOVE"

PATHTYPE_CHK_DLY	= 1
PATHTYPE_GAP    	= 100				-- ���̺�� �̵���ǥüũ �����Ÿ�

SANTA_KEBING_PATH_TABLE =
{

	-- RegenX = 18427, RegenY = 15754���� ������ ��Ÿ������ PATH����
	{
		--{ x =  18427, y =  15754, },	-- �����(������ǥ)

		{ x =  17473, y =  14197, },
		{ x =  16386, y =  13974, },
		{ x =  15572, y =  13385, },	-- Ʈ�� ��ǥ
	},

	-- RegenX = 13598, RegenY = 15727���� ������ ��Ÿ������ PATH����
	{
		--{ x =  13598, y =  15727, },	-- �����(������ǥ)

		{ x =  14139, y =  14478, },
		{ x =  15572, y =  13385, },
	},

	-- RegenX = 14685, RegenY = 9746���� ������ ��Ÿ������ PATH����
	{
		--{ x = 14685, y =  9746, },	-- �����(������ǥ)

		{ x =  14954, y =  11265, },
		{ x =  15555, y =  11704, },
		{ x =  15572, y =  13385, },
	},

	-- RegenX = 11327, RegenY = 13423���� ������ ��Ÿ������ PATH����
	{
		--{ x =  11327, y =  13423, },	-- �����(������ǥ)

		{ x =  12547, y =  13423, },
		{ x =  13178, y =  12963, },
		{ x =  14022, y =  13411, },
		{ x =  15572, y =  13385, },
	},
}

--------------------------------------------------------------------
--// ũ���ú� ó�� ���� ������
--------------------------------------------------------------------

CRUSHBALL_TABLE =
{
	MobIndex		= "BallCrush",
	SkillIndex		= "BallCrush_Skill01_W",
}

-- ũ���ú��� �¾�����, ��Ÿ�������� �ɾ��� �˹� �����̻�
CRUSHBALL_ABSTATE_TABLE =
{
	AbStateHitRate	= 300,						-- �����̻��� �߻��� Ȯ��
	AbstateIndex	= "StaKnockBackFly",
	Strength 		= 1,
	KeepTime 		= 1,
}

--------------------------------------------------------------------
--// ���潺�̺�Ʈ ���� ���� ������
--------------------------------------------------------------------

DEFENCE_EVENT_REWARD_ABSTATE_TABLE =
{
	AbstateIndex 	= "StaXmas_StatUp",
	Strength 		= 1,
	KeepTime 		= (60*60*1000),
	Range 			= 10000,							-- ��Ÿ���� ��� ����������, ����Ʈ�� �������� Range�ȿ� �����ִ� ĳ���Ϳ� �����̻��� ��
}

--------------------------------------------------------------------
--// Script
--------------------------------------------------------------------

E_XKebingChat01			= "E_XKebingChat01"				-- ������ó�� ���ҰŶ�� ������������!!
E_X_Notice_DefenseStart	= "E_X_Notice_DefenseStart"		-- ũ�������� ������ ������ ���۵Ǿ����ϴ�. Ʈ���� �����ּ���.
E_X_Notice_DefenseSucc	= "E_X_Notice_DefenseSucc"		-- ũ�������� ���� ������ �������� ���� �� �����Ͽ����ϴ�.
E_X_Notice_DefenseFail	= "E_X_Notice_DefenseFail"		-- ũ�������� ������ ���� Ʈ���� �ı��Ǿ����ϴ�.
E_X_Notice_TreeRegen	= "E_X_Notice_TreeRegen"		-- ���ο� Ʈ���� ���������ϴ�. Ʈ���� �ٸ� �ּ���.

--------------------------------------------------------------------
--// ���潺�̺�Ʈ ó�� ���� ������
--------------------------------------------------------------------

NEED_KEBING_KILLCOUNT_FOR_DEFENCE_EVENT		= 100			-- �峭�ٷ��� ���� n���� ��ɽ�, ���潺�̺�Ʈ�� ���۵�

SANTAKEBING_CRUSHBALL_HIT_COUNT				= 50			-- ��Ÿ������ ũ���ú��� n�� ������ �����

SANTAKEBING_RANGE_WITH_TREE					= 50			-- ��Ÿ������ ����Ʈ�� �浹 ����
SANTAKEBING_RANGE_WITH_CRUSHBALL			= 50			-- ��Ÿ������ ũ���ú� �浹 ����

DEFENCE_EVENT_FAIL_TREE_REGEN_TIME			= 15			-- ���潺 ������, Ʈ���� �ٽ� �����ɶ����� �ɸ��� �ð�(��)

--------------------------------------------------------------------
--// ���ӷα�
--------------------------------------------------------------------

NC_LOG_GAME_CHRISTMAS_DECO_TRY_BIG_TREE			= 2045		-- ����Ʈ�� �ٹ̱⸦ �õ�
NC_LOG_GAME_CHRISTMAS_DECO_TRY_SMALL_TREE		= 2046		-- ����Ʈ�� �ٹ̱⸦ �õ�( ����Ʈ�� �� ���̵� )
NC_LOG_GAME_CHRISTMAS_DECO_COMPLETE_BIG_TREE	= 2047		-- ����Ʈ�� �ٹ̱⸦ �ϼ�
NC_LOG_GAME_CHRISTMAS_DECO_COMPLETE_SMALL_TREE	= 2048		-- ����Ʈ�� �ٹ̱⸦ �ϼ�( ����Ʈ�� �� ���̵� )
NC_LOG_GAME_CHRISTMAS_START_DEFENCE				= 2049		-- ���潺 �̺�Ʈ ����
NC_LOG_GAME_CHRISTMAS_SUCC_DEFENCE				= 2050		-- ���潺 �̺�Ʈ ����

--------------------------------------------------------------------
--�ءءءءءءءءءءءءءءءءءءءءءءءءءءءءءءءء�
--// [S_21003] ũ��������_2014_�̺�Ʈ ���� ������
---------------------------------------------------------END-------
--�ءءءءءءءءءءءءءءءءءءءءءءءءءءءءءءءء�
--------------------------------------------------------------------


--------------------------------------------------------------------
--// Defined
--------------------------------------------------------------------

VALID_MAP_INDEX		= "Eld"				-- ����Ʈ�� ������ üũ�� ���ε���
IMMORTAL_INDEX		= "StaImmortal"		-- �� ������ Ǯ���� �����̻�
TREE_CAST_TIME		= (2*1000)			-- ���� ĳ���� �ð�
TREE_CAST_ANI		= "ActionProduct"	-- ���� ĳ���� �ִϸ��̼� �ε���
TREE_CAST_ITEM		= "E_XTreeDeco"		-- ���� ĳ���� ���� �Ҹ� ������



--------------------------------------------------------------------
--// Script
--------------------------------------------------------------------

-- ���� �̸�
SCRIPT_FILE_NAME	= "Event"

-- ��ũ��Ʈ �ε���
E_X_Notice_TreeUp01		= "E_X_Notice_TreeUp01"		-- Ʈ���� 2�ܰ�� �����Ǿ� ����� �þ�ϴ�.
E_X_Notice_TreeUp02		= "E_X_Notice_TreeUp02"		-- Ʈ���� 3�ܰ�� �����Ǿ� ������ ����� �þ�ϴ�.
E_X_Notice_TreeUp03		= "E_X_Notice_TreeUp03"		-- Ʈ���� 4�ܰ�� �����Ǿ� �Һ��� ȭ�������ϴ�.
E_X_Notice_TreeUp04		= "E_X_Notice_TreeUp04"		-- Ʈ���� 5�ܰ�� �����Ǿ� ȭ������ ��ġ�� �����ݴϴ�.
E_X_Notice_TreeUp05		= "E_X_Notice_TreeUp05"		-- �峭�ٷ��� �������� Ʈ�� ��ĵ��� ���İ��ϴ�.
E_X_Notice_TreeInit		= "E_X_Notice_TreeInit"		-- �峭�ٷ��� �������� ��� �����ƽ��ϴ�. Ʈ���� �ٽ� �ٸ��ּ���.
E_X_Notice_Buff01		= "E_X_Notice_Buff01"		-- ũ���������� �Ҹ��� ���������� ����
E_X_Notice_Buff02		= "E_X_Notice_Buff02"		-- �絹���� �Ҹ��� ���������� ����
E_X_Notice_Buff03		= "E_X_Notice_Buff03"		-- ��Ÿ ������ �Ҹ��� ���������� ����
E_X_Notice_Buff04		= "E_X_Notice_Buff04"		-- ��Ÿ�� �Ҹ��� ���������� ����
E_X_SysMsg_Deco01		= "E_X_SysMsg_Deco01"		-- ũ�������� �Ҹ� Ʈ���� �� ����� �޾ҽ��ϴ�.
E_X_SysMsg_Deco02		= "E_X_SysMsg_Deco02"		-- �絹���� �Ҹ� Ʈ���� �� ����� �޾ҽ��ϴ�.
E_X_SysMsg_Deco03		= "E_X_SysMsg_Deco03"		-- ��Ÿ������ �Ҹ� Ʈ���� �� ����� �޾ҽ��ϴ�.
E_X_SysMsg_Deco04		= "E_X_SysMsg_Deco04"		-- ��Ÿ�� �Ҹ� Ʈ���� �� ����� �޾ҽ��ϴ�.
E_X_SysMsg_Deco05		= "E_X_SysMsg_Deco05"		-- ���̻��� �Ҹ� Ʈ���� �� ����� �޾ҽ��ϴ�.
E_X_ErrMsg_DecoFail		= "E_X_ErrMsg_DecoFail"		-- Ʈ�� �� ����� �����ϴ�. �������� ������ �ٽ� �õ� ���ּ���.
E_X_SysMsg_DecoFail		= "E_X_SysMsg_Fail1"		-- ������ Ʈ���� ����� �߰��� �� �����ϴ�. ��� �� �ٽ� �õ����ּ���.
E_X_SysMsg_DecoFail_2	= "E_X_SysMsg_Fail2"		-- Cannot use the item due to an Abnormal State


--------------------------------------------------------------------
--// �������� ó�� ���� ������
--------------------------------------------------------------------

-- ���� ���̺�
-- NeedCount	: �ش� ������ �Ǳ����� �ʿ��� ������ ��. (������ 0�ܰ����)
-- LevDwnKeep	: 1 = 1Sec, �ִ� ������ �� ���� �� ���� ���� �ð�
TREE_LEVEL_TABLE =
{
	{ NeedCount = 50 , AniIndex = "E_XTreeBig_Idle01", LevDwnKeep = 100, Notice = E_X_Notice_TreeUp01, },
	{ NeedCount = 100, AniIndex = "E_XTreeBig_Idle02", LevDwnKeep = 100, Notice = E_X_Notice_TreeUp02, },
	{ NeedCount = 150, AniIndex = "E_XTreeBig_Idle03", LevDwnKeep = 100, Notice = E_X_Notice_TreeUp03, },
	{ NeedCount = 200, AniIndex = "E_XTreeBig_Idle04", LevDwnKeep = 600, Notice = E_X_Notice_TreeUp04, },
}


-- �� ���� ���̺�
-- RegenInterval: 1 = 1Sec, ���� ���� ���� �ٽ� ���� �Ǵ� �ð�.
REWARD_MOB_REGEN_TABLE =
{
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },

	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },

	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },

}


-- ����
TREE_LEVEL_DOWN_EVENT_INFO =
{
	MobLifeTime	= 5,					-- n�ʵ��� �����Ǵ�
	MobIndex	= "E_XKebing_Show",		-- s����
	RegenTick	= 3,					-- n+1ƽ����(1Tick=0.1Sec)
	RegenDist	= 300,					-- ������ n��ŭ ������ �Ÿ����� �����ϰ�
	FollowGap	= 180,					-- ������ n��ŭ ������ �Ÿ����� �̵��ؼ�
	AniTime		= 3,					-- n�� ����
	AniIndex	= "E_XKebing_Skill01_N",	-- s�ִϸ��̼��� �����ְ�
	RunSpeed	= 2000,					-- (n/1000)�� �̵��ӵ���
	RunMaxDist	= 2000,					-- ������ n��ŭ ������ �Ÿ����� �������� ������
	KeepTime	= 30,					-- n�� ���� �����Ѵ�.
}



--------------------------------------------------------------------
--// �������� ó�� ���� ������
--------------------------------------------------------------------

-- ���� �����̻� ���̺�
-- KeepTime	: 1000 = 1sec
-- Range	: ���� ����
REWARD_ABSTATE_TABLE =
{
	Reward01 = { AbstateIndex = "StaXReward01", Strength = 1, KeepTime = (60*60*1000), Range = 1000, Notice = E_X_Notice_Buff01, },
	Reward02 = { AbstateIndex = "StaXReward02", Strength = 1, KeepTime = (60*60*1000), Range = 1000, Notice = E_X_Notice_Buff02, },
	Reward03 = { AbstateIndex = "StaXReward03", Strength = 1, KeepTime = (60*60*1000), Range = 1000, Notice = E_X_Notice_Buff03, },
	Reward04 = { AbstateIndex = "StaXReward04", Strength = 1, KeepTime = (60*60*1000), Range = 1000, Notice = E_X_Notice_Buff04, },
}


-- ���� ���̺�
-- MaxLevelKeep : 1 = 1Sec, �ִ� ������ �� ���� ���� �ð�
-- NeedCount	: �ش� ������ �Ǳ����� �ʿ��� ������ ��. (������ 0�ܰ����)
SMALL_TREE_LEVEL_TABLE =
{
	MaxLevelKeep = 300,

	{ NeedCount = 5, 	AniIndex = "E_XTree_Idle01", },
	{ NeedCount = 10, 	AniIndex = "E_XTree_Idle02", },
}


-- �������� ����
-- LevelTable	: SMALL_TREE_LEVEL_TABLE ������ �ε���
-- RewardAbstate: REWARD_ABSTATE_TABLE ������ �ε���
SMALL_TREE_INFO =
{
	{ MobIndex = "E_XTree_Xmas", 	RegenX = 14738, RegenY = 13055, Dir = 7, 	CastSuccMsg = E_X_SysMsg_Deco01, RewardAbstate = "Reward01", },
	{ MobIndex = "E_XTree_Rudolph", RegenX = 17372, RegenY = 13673, Dir = 129, 	CastSuccMsg = E_X_SysMsg_Deco02, RewardAbstate = "Reward02", },
	{ MobIndex = "E_XTree_Fairy", 	RegenX = 15582, RegenY = 13827, Dir = 43, 	CastSuccMsg = E_X_SysMsg_Deco03, RewardAbstate = "Reward03", },
	{ MobIndex = "E_XTree_Santa", 	RegenX = 14797, RegenY = 13758, Dir = 132, 	CastSuccMsg = E_X_SysMsg_Deco04, RewardAbstate = "Reward04", },
	{ MobIndex = "E_XTree_Xmas", 	RegenX = 16750, RegenY = 13852, Dir = 128, 	CastSuccMsg = E_X_SysMsg_Deco01, RewardAbstate = "Reward01", },
	{ MobIndex = "E_XTree_Rudolph", RegenX = 15769, RegenY = 12928, Dir = 81, 	CastSuccMsg = E_X_SysMsg_Deco02, RewardAbstate = "Reward02", },
	{ MobIndex = "E_XTree_Fairy", 	RegenX = 16517, RegenY = 12977, Dir = 53, 	CastSuccMsg = E_X_SysMsg_Deco03, RewardAbstate = "Reward03", },
	{ MobIndex = "E_XTree_Santa", 	RegenX = 17363, RegenY = 13090, Dir = 146, 	CastSuccMsg = E_X_SysMsg_Deco04, RewardAbstate = "Reward04", },
}



--------------------------------------------------------------------
--// ����� ó�� ���� ������
--------------------------------------------------------------------

-- ������ ��� ���̺�
-- Rate : 1000000 = 100%
ITEM_DROP_TABLE =
{
	SnowMan =
	{
		{ ItemIndex = "E_XTreeDeco",	Rate =  700000, },
		{ ItemIndex = "E_XCrystal",		Rate =  500000, },
		{ ItemIndex = "E_BallSnow02",	Rate =  500000, },
	},
}


-- ����� ����
-- CenterX, CenterY, Range		: ���� �߽� ��ǥ�� ����
-- LifeTime_Min, LifeTime_Max	: 1 = 1Sec, ������ ����� �����ð�(�ٽ� ������ �ð�) ����
-- DropTable					: ITEM_DROP_TABLE ������ �ε���
SNOWMAN_INFO =
{
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },


	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },


	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },


	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },

}



--------------------------------------------------------------------
--// ũ�������� �̺�Ʈ ���� ����
--------------------------------------------------------------------

-- ������ ó���� ���
MemBlock = {}



--------------------------------------------------------------------
--// ��ũ��Ʈ ����
--------------------------------------------------------------------

function E_XTreeBig( Handle, MapIndex )
cExecCheck( "E_XTreeBig" )


	if MapIndex ~= VALID_MAP_INDEX
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end


	if cIsObjectDead( Handle ) == 1
	then
		KebingVanishAll( MemBlock[Handle] )
		cAIScriptSet( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	end


	local Var		= MemBlock[Handle]
	local CurSec	= cCurrentSecond()

	if Var == nil
	then

		MemBlock[Handle]		= {}

		Var						= MemBlock[Handle]

		Var["MapIndex"] 		= MapIndex
		Var["Handle"]			= Handle

		Var["CurSec"]			= CurSec
		Var["NextTick"]			= CurSec

		Var["Level"]			= 0
		Var["Count"]			= 0

		Var["RegenKebing"]		= false
		Var["KebingList"]		= {}
		Var["KebingRegenList"]	= {}

		Var["LevelDownEvent"]	= false
		Var["EventKeepTime"]	= CurSec
		Var["TickCount"]		= TREE_LEVEL_DOWN_EVENT_INFO["RegenTick"]

		-- ���� �峭�ٷ��� ������ ��
		Var["KebingDeadCount"] = 0

		-- ����Ʈ���ڵ�
		MemBlock["TreeHandle"]	= Handle

		-- ����Ʈ�� ���μ���
		MemBlock["BonusDefenceEvent"]						= {}
		MemBlock["BonusDefenceEvent"]["IsProgress"] 		= false		-- ���潺 �̺�Ʈ�� �ߵ����ΰ�
		MemBlock["BonusDefenceEvent"]["IsSantaKebingCrush"]	= false		-- ������ �浹�ߴ°�
		cAIScriptFunc( Handle, "NPCClick", "TreeClick" )
		cAIScriptFunc( Handle, "NPCMenu",  "TreeCastingComplete" )
		cSetFieldScript 	( Var["MapIndex"], Handle )
		cFieldScriptFunc	( Var["MapIndex"], "ServantSummon", "ServantSummon" )
	end


	-- 0.1�ʸ��� ó��
	if Var["NextTick"] <= CurSec
	then
		Var["CurSec"]	= CurSec
		Var["NextTick"]	= Var["NextTick"] + 0.1
	else
		return ReturnAI["END"]
	end

	TreeProcess( Var )
	SmallTreeProcess( Var )
	SnowManProcess( Var )

	SantaKebingRegenProcess( Var )

	return ReturnAI["END"]

end



--------------------------------------------------------------------
--// ���� ó��
--------------------------------------------------------------------

-- ���� ó��
function TreeProcess( Var )
cExecCheck( "TreeProcess" )

	if Var == nil
	then
		return
	end

	if Var["CurSec"] == nil
	then
		return
	end

	if Var["Level"] == nil
	then
		return
	end

	if Var["Count"] == nil
	then
		return
	end

	if Var["RegenKebing"] == nil
	then
		return
	end

	if Var["LevelDownEvent"] == nil
	then
		return
	end


	-- TreeCastingComplete ���� ���õ�
	if Var["LevDwnKeep"] ~= nil
	then
		-- ���� �ð� ������
		if Var["LevDwnKeep"] <= Var["CurSec"]
		then
			-- ù �����ٿ��̸�
			if Var["Level"] == #TREE_LEVEL_TABLE
			then
				-- �� ���ӷα�
				-- ���� Ʈ�� �ϼ� Ƚ��( 5�ܰ���� �ٹ̱� ���� )
				cSendGameLogDataType_5( NC_LOG_GAME_CHRISTMAS_DECO_COMPLETE_BIG_TREE, 0, 0, 0 )
				-- ����
				cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, E_X_Notice_TreeUp05 )

				-- ���� ���� ����
				Var["RegenKebing"] = true
			end

			-- ���� �ٿ�
			Var["Level"] = Var["Level"] - 1


			if Var["Level"] <= 0
			then
				-- ����
				-- cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, E_X_Notice_TreeInit )

				-- �ִϸ��̼� �����·�
				cAnimate( Var["Handle"], "stop" )

				-- ���� ���� ����, ����
				Var["RegenKebing"] = false
				KebingVanishAll( Var )

				-- ������ ī��Ʈ �ʱ�ȭ
				Var["Level"]		= 0
				Var["Count"]		= 0

				Var["LevDwnKeep"]	= nil
				-- ���� 100 ���� �Ѱ� �׿����� ���潺�̺�Ʈ �߻�
				if Var["KebingDeadCount"] >= NEED_KEBING_KILLCOUNT_FOR_DEFENCE_EVENT
				then

					-- �� ���ӷα� ���� �κ�
					-- ���潺 �̺�Ʈ ���� Ƚ��
					cSendGameLogDataType_5( NC_LOG_GAME_CHRISTMAS_START_DEFENCE, 0, 0, 0 )

					-- ���� : ũ�������� ������ ������ ���۵Ǿ����ϴ�. Ʈ���� �����ּ���.
					cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, E_X_Notice_DefenseStart )
					MemBlock["BonusDefenceEvent"]["IsProgress"] = true

				else
					-- ���� : �峭�ٷ��� �������� ��� �����ƽ��ϴ�. Ʈ���� �ٽ� �ٸ��ּ���.
					cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, E_X_Notice_TreeInit )
				end

				-- ���� ���� �� �ʱ�ȭ
				Var["KebingDeadCount"] = 0
			else
				local CurLevData = TREE_LEVEL_TABLE[ Var["Level"] ]

				-- ���� �����ٿ� �ð�
				Var["LevDwnKeep"] = Var["CurSec"] + CurLevData["LevDwnKeep"]

				-- �ִϸ��̼� ����
				cAnimate( Var["Handle"], "start", CurLevData["AniIndex"] )

				-- �����ٿ� �ִϸ��̼� ����
				Var["LevelDownEvent"]	= true
				Var["EventKeepTime"]	= Var["CurSec"] + TREE_LEVEL_DOWN_EVENT_INFO["KeepTime"]

			end
		end
	end


	if Var["RegenKebing"] == true
	then
		KebingRegenProcess( Var )
	end

	if Var["LevelDownEvent"] == true
	then
		TreeLevelDownEventProcess( Var )
	end

	-- ���潺 �̺�Ʈ �ߵ�
	if MemBlock["BonusDefenceEvent"]["IsProgress"] == true
	then

		if MemBlock["BonusDefenceEvent"]["IsSantaKebingCrush"] == false
		then
			-- �������� ���� ���� �� üũ, ��� �׾�����
			if IsSantaKebingAllDead( Var ) == true
			then
				-- �� ���ӷα�
				-- ���潺 �̺�Ʈ ���� Ƚ��
				cSendGameLogDataType_5( NC_LOG_GAME_CHRISTMAS_SUCC_DEFENCE, 0, 0, 0 )

				-- ����ó�� ( Ʈ���� �� ���ѳ����� )
				cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, E_X_Notice_DefenseSucc )

				-- ���� �ο�
				cSetAbstate_Range( Var["Handle"], DEFENCE_EVENT_REWARD_ABSTATE_TABLE["Range"], ObjectType["Player"], DEFENCE_EVENT_REWARD_ABSTATE_TABLE["AbstateIndex"], DEFENCE_EVENT_REWARD_ABSTATE_TABLE["Strength"], DEFENCE_EVENT_REWARD_ABSTATE_TABLE["KeepTime"] )

				-- ��� ������ �ʱ�ȭ ���ֱ�
				MemBlock["BonusDefenceEvent"]["IsSantaKebingCrush"]		= false
				MemBlock["BonusDefenceEvent"]["ResetCoolTime"] 			= nil
				MemBlock["BonusDefenceEvent"]["IsProgress"] 			= false

				-- ��Ÿ���� ��ü �����ϱ�
				SantaKebingVanishAll( Var )

				MemBlock["SantaKebingList"] 		= nil
				MemBlock["SantaKebingListHandle"]	= nil
			end
		end

		-- Ʈ���� ������ �浹�� ���¸�,
		if MemBlock["BonusDefenceEvent"]["IsSantaKebingCrush"] == true
		then

			if MemBlock["BonusDefenceEvent"]["ResetCoolTime"] == nil
			then
				-- ���� ó��( ũ�������� ������ ���� Ʈ���� �ı��Ǿ����ϴ�. )
				cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, E_X_Notice_DefenseFail )

				-- ��Ÿ���� ��ü �����ϱ�
				SantaKebingVanishAll( Var )

				MemBlock["BonusDefenceEvent"]["ResetCoolTime"]	= Var["CurSec"] + DEFENCE_EVENT_FAIL_TREE_REGEN_TIME

				-- �ִϸ��̼� ����( �μ����� �ִ� )
				cAnimate( Var["Handle"], "start", TREE_DEFENCE_TABLE["TREE_DIE"]["AniIndex"] )
			end
		end

		-- Ʈ�� ����� �ð��� �Ǹ�,
		if MemBlock["BonusDefenceEvent"]["ResetCoolTime"] ~= nil
		then
			if MemBlock["BonusDefenceEvent"]["ResetCoolTime"] <= Var["CurSec"]
			then

				-- ���� ó��( ���ο� Ʈ���� ���������ϴ�. Ʈ���� �ٸ� �ּ���. )
				cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, E_X_Notice_TreeRegen )

				-- �ִϸ��̼� ����( �⺻���·� )
				cAnimate( Var["Handle"], "start", TREE_DEFENCE_TABLE["TREE_REGEN"]["AniIndex"] )

				MemBlock["BonusDefenceEvent"]["IsProgress"] 			= false
				MemBlock["BonusDefenceEvent"]["IsSantaKebingCrush"]		= false
				MemBlock["BonusDefenceEvent"]["ResetCoolTime"] 			= nil

				MemBlock["SantaKebingList"] 		= nil
				MemBlock["SantaKebingListHandle"]	= nil
			end
		end
	end
end


-- ���� ����
function KebingRegenProcess( Var )
cExecCheck( "KebingRegenProcess" )

	if Var == nil
	then
		return
	end

	if Var["CurSec"] == nil
	then
		return
	end

	if Var["KebingList"] == nil
	then
		return
	end

	if Var["KebingRegenList"] == nil
	then
		return
	end


	for i = 1, #REWARD_MOB_REGEN_TABLE do

		if Var["KebingList"][i] == nil or cIsObjectDead( Var["KebingList"][i] ) == 1
		then
			-- ���� �׾����� üũ�ϰ�, ����ī��Ʈ ����
			if cIsObjectDead( Var["KebingList"][i] ) == 1
			then
				Var["KebingDeadCount"] = Var["KebingDeadCount"] + 1
			end
			Var["KebingList"][i] = nil

			if Var["KebingRegenList"][i] == nil
			then
				Var["KebingRegenList"][i] = Var["CurSec"] + REWARD_MOB_REGEN_TABLE[i]["RegenInterval"]
			end
		end

		if Var["KebingRegenList"][i] ~= nil and Var["KebingRegenList"][i] <= Var["CurSec"]
		then
			Var["KebingList"][i] = cMobRegen_Circle( Var["MapIndex"], REWARD_MOB_REGEN_TABLE[i]["MobIndex"],
																		REWARD_MOB_REGEN_TABLE[i]["CenterX"],
																		REWARD_MOB_REGEN_TABLE[i]["CenterY"],
																		REWARD_MOB_REGEN_TABLE[i]["Range"] )
			Var["KebingRegenList"][i]	= nil
		end
	end

end


-- ���� ����
function KebingVanishAll( Var )
cExecCheck( "KebingVanishAll" )

	if Var == nil
	then
		return
	end

	if Var["KebingList"] == nil
	then
		return
	end

	if Var["KebingRegenList"] == nil
	then
		return
	end

	for i = 1, #REWARD_MOB_REGEN_TABLE
	do
		if Var["KebingList"][i] ~= nil
		then
			cNPCVanish( Var["KebingList"][i] )
			Var["KebingList"][i] = nil
		end

		Var["KebingRegenList"][i] = nil
	end

end


-- ���� �����ٿ� ���� ó��
function TreeLevelDownEventProcess( Var )
cExecCheck( "TreeLevelDownEventProcess" )

	if Var == nil
	then
		return
	end

	if Var["Handle"] == nil
	then
		return
	end

	if Var["CurSec"] == nil
	then
		return
	end

	if Var["LevelDownEvent"] == nil
	then
		return
	end

	if Var["EventKeepTime"] == nil
	then
		return
	end

	if Var["TickCount"] == nil
	then
		return
	end


	if Var["LevelDownEvent"] == false
	then
		return
	end

	if Var["EventKeepTime"] <= Var["CurSec"]
	then
		Var["LevelDownEvent"]	= false
		Var["TickCount"]		= TREE_LEVEL_DOWN_EVENT_INFO["RegenTick"]
		return
	end

	if Var["TickCount"] < TREE_LEVEL_DOWN_EVENT_INFO["RegenTick"]
	then
		Var["TickCount"] = Var["TickCount"] + 1
		return
	end

	Var["TickCount"] = 0


	local Dir				= cRandomInt( 1, 90 ) * 4
	local RegenX, RegenY	= cGetAroundCoord( Var["Handle"], Dir, TREE_LEVEL_DOWN_EVENT_INFO["RegenDist"] )

	local MobHandle = cMobRegen_XY( Var["MapIndex"], TREE_LEVEL_DOWN_EVENT_INFO["MobIndex"], RegenX, RegenY, Dir )
	if MobHandle ~= nil
	then
		if cAIScriptSet( MobHandle, Var["Handle"] ) ~= nil
		then
			cAIScriptFunc( MobHandle, "Entrance", "EventMobRoutine" )

			MemBlock[MobHandle]					= {}
			MemBlock[MobHandle]["Handle"]		= MobHandle
			MemBlock[MobHandle]["MapIndex"]		= Var["MapIndex"]
			MemBlock[MobHandle]["CurSec"]		= Var["CurSec"]
			MemBlock[MobHandle]["NextTick"]		= Var["CurSec"]
			MemBlock[MobHandle]["LifeTime"]		= Var["CurSec"] + TREE_LEVEL_DOWN_EVENT_INFO["MobLifeTime"]
			MemBlock[MobHandle]["MasterHandle"]	= Var["Handle"]
			MemBlock[MobHandle]["GoalX"],
			MemBlock[MobHandle]["GoalY"]		= cGetAroundCoord( Var["Handle"], Dir, TREE_LEVEL_DOWN_EVENT_INFO["RunMaxDist"] )
		end
	end


end


-- �̺�Ʈ�� ��ƾ
function EventMobRoutine( Handle, MapIndex )
cExecCheck( "EventMobRoutine" )

	local Var		= MemBlock[Handle]
	local CurSec	= cCurrentSecond()

	if Var == nil
	then
		cAIScriptSet( Handle )

		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) == 1
	then
		cAIScriptSet( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	end

	if cIsObjectDead( Var["MasterHandle"] ) == 1
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	end


	-- �̵�
	if Var["Step"] == nil
	then
		cFollow( Handle, Var["MasterHandle"], TREE_LEVEL_DOWN_EVENT_INFO["FollowGap"], 9999 )

		Var["Step"] = 1
	end

	-- 0.1�ʸ��� ó��
	if Var["NextTick"] <= CurSec
	then
		Var["CurSec"]	= CurSec
		Var["NextTick"]	= Var["NextTick"] + 0.1
	else
		return ReturnAI["END"]
	end


	-- 1���Ǻ��� 0.1�ʸ��� �ϱ����� if�� �и�
	if 	Var["Step"] == 1
	then
		local MoveState, KeepTime = cGetMoveState( Handle )

		if MoveState ~= nil and MoveState == 0
		then
			cAnimate( Handle, "start", TREE_LEVEL_DOWN_EVENT_INFO["AniIndex"] )
			Var["Step"] = Var["Step"] + 1
		end

	elseif Var["Step"] == 2
	then
		local MoveState, KeepTime = cGetMoveState( Handle )

		if MoveState ~= nil and MoveState == 0 and KeepTime >= TREE_LEVEL_DOWN_EVENT_INFO["AniTime"]
		then
			cAnimate( Handle, "stop" )
			Var["Step"] = Var["Step"] + 1
		end

	elseif Var["Step"] == 3
	then
		if Var["GoalX"] ~= nil and Var["GoalY"] ~= nil
		then
			cRunTo( Handle, Var["GoalX"], Var["GoalY"], TREE_LEVEL_DOWN_EVENT_INFO["RunSpeed"] )
		end
		Var["Step"] = Var["Step"] + 1
	end



	-- ������ �ð��� �������� �� ����
	if Var["LifeTime"] <= Var["CurSec"]
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	end


	return ReturnAI["END"]

end


-- ���� Ŭ��ó��
function TreeClick( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "TreeClick" )

	local Var = MemBlock[NPCHandle]

	if Var == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Level"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Count"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if #TREE_LEVEL_TABLE == 0
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Count"] >= TREE_LEVEL_TABLE[ #TREE_LEVEL_TABLE ]["NeedCount"]
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	-- ���潺 �̺�Ʈ ���̶� ó����������
	if MemBlock["BonusDefenceEvent"]["IsProgress"] == true
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end
	if cIsNoAttacOrNoMove( PlyHandle ) == 1
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail_2 )
		return
	end


	cCastingBar( PlyHandle, NPCHandle, TREE_CAST_TIME, TREE_CAST_ANI )

end


-- ���� ĳ���� �Ϸ� ó��
function TreeCastingComplete( NPCHandle, PlyHandle, RegistNumber, Menu )
cExecCheck( "TreeCastingComplete" )

	local Var = MemBlock[NPCHandle]

	if Var == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Level"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Count"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["MapIndex"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if #TREE_LEVEL_TABLE == 0
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Level"] >= #TREE_LEVEL_TABLE
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Count"] >= TREE_LEVEL_TABLE[ #TREE_LEVEL_TABLE ]["NeedCount"]
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	-- ���潺 �̺�Ʈ ���̶� ó����������
	if MemBlock["BonusDefenceEvent"]["IsProgress"] == true
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if cInvenItemDestroy( PlyHandle, TREE_CAST_ITEM, 1 ) == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_ErrMsg_DecoFail )
		return
	end


	cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_Deco05 )

	Var["Count"] = Var["Count"] + 1

	-- �� ���ӷα�
	-- ������ ���������� Ʈ����� 1�� �����
	cSendGameLogDataType_5( NC_LOG_GAME_CHRISTMAS_DECO_TRY_BIG_TREE, 0, 0, 0 )

	local NextLevData = TREE_LEVEL_TABLE[ Var["Level"]+1 ]

	if Var["Count"] >= NextLevData["NeedCount"]
	then
		cAnimate( NPCHandle, "start", NextLevData["AniIndex"] )
		cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, NextLevData["Notice"] )

		Var["Level"] = Var["Level"] + 1
	end

	if Var["Level"] >= #TREE_LEVEL_TABLE
	then
		if NextLevData["LevDwnKeep"] == nil
		then
			Var["LevDwnKeep"] = cCurrentSecond() + 0.5
		else
			Var["LevDwnKeep"] = cCurrentSecond() + NextLevData["LevDwnKeep"]
		end
	end

	--------------------------
	--local CurX, CurY = cObjectLocate( Var["Handle"] )
	--cEffectRegen_XY( Var["MapIndex"], "LightShield", CurX, CurY, 0, 4, 0, 1000 )
	--------------------------

end



--------------------------------------------------------------------
--// �������� ó��
--------------------------------------------------------------------

-- �������� ó�� �Լ�
function SmallTreeProcess( Var )
cExecCheck( "SmallTreeProcess" )

	if Var == nil
	then
		return
	end

	if Var["MapIndex"] == nil
	then
		return
	end

	if Var["Handle"] == nil
	then
		return
	end

	if Var["SmallTreeList"] == nil
	then
		Var["SmallTreeList"] = {}
	end


	for i = 1, #SMALL_TREE_INFO
	do
		if Var["SmallTreeList"][i] == nil
		then
			Var["SmallTreeList"][i]	= {}

			local CurTree = Var["SmallTreeList"][i]

			-- �������� ����
			CurTree["Handle"] = cMobRegen_XY( Var["MapIndex"], SMALL_TREE_INFO[i]["MobIndex"], SMALL_TREE_INFO[i]["RegenX"], SMALL_TREE_INFO[i]["RegenY"], SMALL_TREE_INFO[i]["Dir"] )

			if CurTree["Handle"] ~= nil
			then
				-- ���������̻� ����
				cResetAbstate( CurTree["Handle"], IMMORTAL_INDEX )

				-- ��ũ��Ʈ ���� �� �ʿ����� ����
				if cAIScriptSet( CurTree["Handle"], Var["Handle"] ) ~= nil
				then
					cAIScriptFunc( CurTree["Handle"], "Entrance", "SmallTreeRoutine" )
					cAIScriptFunc( CurTree["Handle"], "NPCClick", "SmallTreeClick" )
					cAIScriptFunc( CurTree["Handle"], "NPCMenu",  "SmallTreeCastingComplete" )

					-- ���������ʿ��� �ʿ��� ����
					MemBlock[CurTree["Handle"]]					= {}
					MemBlock[CurTree["Handle"]]["MasterHandle"]	= Var["Handle"]
					MemBlock[CurTree["Handle"]]["MasterMobID"]	= cGetMobID( Var["Handle"] )
					MemBlock[CurTree["Handle"]]["Handle"]		= CurTree["Handle"]
					MemBlock[CurTree["Handle"]]["MapIndex"]		= Var["MapIndex"]
					MemBlock[CurTree["Handle"]]["CurSec"]		= Var["CurSec"]
					MemBlock[CurTree["Handle"]]["NextTick"]		= Var["CurSec"]
					MemBlock[CurTree["Handle"]]["Level"]		= 0
					MemBlock[CurTree["Handle"]]["Count"]		= 0
					MemBlock[CurTree["Handle"]]["DataIndex"]	= i

					-- ���ο��� �������� üũ�ϱ� ���� ����
					CurTree["MobID"]	= cGetMobID( CurTree["Handle"] )
					CurTree["RegenX"],
					CurTree["RegenY"]	= cObjectLocate( CurTree["Handle"] )
				end
			end
		end

		if Var["SmallTreeList"][i] ~= nil
		then

			if SmallTreeValidCheck( Var["SmallTreeList"][i] ) == false
			then
				Var["SmallTreeList"][i] = nil
			end
		end
	end

end


-- �������� ��ȿ�� üũ(�����ʿ��� ���������� �����ϴ��� Ȯ��)
function SmallTreeValidCheck( Var )
cExecCheck( "SmallTreeValidCheck" )

	-- �⺻ ������ Ȯ��
	if Var == nil
	then
		return false
	end

	if Var["Handle"] == nil
	then
		return false
	end

	if Var["MobID"] == nil
	then
		return false
	end

	if Var["RegenX"] == nil or Var["RegenY"] == nil
	then
		return false
	end

	-- �׾��� Ȯ��
	if cIsObjectDead( Var["Handle"] ) == 1
	then
		return false
	end

	-- ������Ų �����̵�� �´��� Ȯ��
	local MobID = cGetMobID( Var["Handle"] )
	if MobID == nil
	then
		return false
	end

	if MobID ~= Var["MobID"]
	then
		return false
	end

	-- ������ǥȮ��
	local CurX, CurY = cObjectLocate( Var["Handle"] )
	if CurX == nil or CurY == nil
	then
		return false
	end

	if CurX ~= Var["RegenX"] or CurY ~= Var["RegenY"]
	then
		return false
	end


	return true

end


-- �������� ��ƾ
function SmallTreeRoutine( Handle, MapIndex )
cExecCheck( "SmallTreeRoutine" )

	local Var		= MemBlock[Handle]
	local CurSec	= cCurrentSecond()

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) == 1
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	end

	-- 0.1�ʸ��� ó��
	if Var["NextTick"] <= CurSec
	then
		Var["CurSec"]	= CurSec
		Var["NextTick"]	= Var["NextTick"] + 0.1
	else
		return ReturnAI["END"]
	end

	-- ������ ���� Ȯ��
	if MainTreeValidCheck( Var ) == false
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	end


	-- SmallTreeCastingComplete ���� �ִ뷹�� �ɶ� ���õ�
	if Var["MaxLevelKeep"] ~= nil
	then
		-- ���� �ð� ������
		if Var["MaxLevelKeep"] <= Var["CurSec"]
		then
			-- �ִϸ��̼� �����·�
			cAnimate( Handle, "stop" )

			-- ������ ī��Ʈ �ʱ�ȭ
			Var["Level"]		= 0
			Var["Count"]		= 0

			Var["MaxLevelKeep"]	= nil
		end
	end


	return ReturnAI["END"]

end


-- ������ ��ȿ�� üũ(�������� ��ƾ�ʿ��� �����Ͱ� �ִ��� Ȯ��)
function MainTreeValidCheck( Var )
cExecCheck( "MainTreeValidCheck" )

	-- �⺻ ���� Ȯ��
	if Var == nil
	then
		return false
	end

	if Var["MasterHandle"] == nil
	then
		return false
	end

	if Var["MasterMobID"] == nil
	then
		return false
	end

	-- �׾��� Ȯ��
	if cIsObjectDead( Var["MasterHandle"] ) == 1
	then
		return false
	end

	-- ������Ų �����̵�� �´��� Ȯ��
	local MobID = cGetMobID( Var["MasterHandle"] )
	if MobID == nil
	then
		return false
	end

	if MobID ~= Var["MasterMobID"]
	then
		return false
	end


	return true

end


-- �������� Ŭ�� ó��
function SmallTreeClick( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "SmallTreeClick" )

	local Var = MemBlock[NPCHandle]

	if Var == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Level"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Count"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["DataIndex"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	local LevelData = SMALL_TREE_LEVEL_TABLE

	if LevelData == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if #LevelData == 0
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Count"] >= LevelData[ #LevelData ]["NeedCount"]
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if cIsNoAttacOrNoMove( PlyHandle ) == 1
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail_2 )
		return
	end


	cCastingBar( PlyHandle, NPCHandle, TREE_CAST_TIME, TREE_CAST_ANI )

end


-- �������� ĳ���� �Ϸ� ó��
function SmallTreeCastingComplete( NPCHandle, PlyHandle, RegistNumber, Menu )
cExecCheck( "SmallTreeCastingComplete" )

	local Var = MemBlock[NPCHandle]

	if Var == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Level"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Count"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["DataIndex"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	local LevelData = SMALL_TREE_LEVEL_TABLE

	if LevelData == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if #LevelData == 0
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Level"] >= #LevelData
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Count"] >= LevelData[ #LevelData ]["NeedCount"]
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if cInvenItemDestroy( PlyHandle, TREE_CAST_ITEM, 1 ) == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_ErrMsg_DecoFail )
		return
	end


	cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, SMALL_TREE_INFO[ Var["DataIndex"] ]["CastSuccMsg"] )


	Var["Count"] = Var["Count"] + 1

	-- �� ���ӷα� ���� �κ�
	-- ������ ���������� Ʈ����� 1�� �����
	cSendGameLogDataType_5( NC_LOG_GAME_CHRISTMAS_DECO_TRY_SMALL_TREE, 0, cGetMobID(NPCHandle), 0 )

	local NextLevData = LevelData[ Var["Level"]+1 ]

	if Var["Count"] >= NextLevData["NeedCount"]
	then
		cAnimate( NPCHandle, "start", NextLevData["AniIndex"] )

		Var["Level"] = Var["Level"] + 1
	end

	if Var["Level"] >= #LevelData
	then

	-- �� ���ӷα�
	-- ���� Ʈ�� �ϼ� Ƚ��(����Ʈ�� 4��)
	cSendGameLogDataType_5( NC_LOG_GAME_CHRISTMAS_DECO_COMPLETE_SMALL_TREE, 0, cGetMobID(NPCHandle), 0 )
		local RewardData = REWARD_ABSTATE_TABLE[ SMALL_TREE_INFO[ Var["DataIndex"] ]["RewardAbstate"] ]

		if RewardData ~= nil
		then
			cSetAbstate_Range( NPCHandle, RewardData["Range"], ObjectType["Player"], RewardData["AbstateIndex"], RewardData["Strength"], RewardData["KeepTime"] )
			cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, RewardData["Notice"] )
		end

		if LevelData["MaxLevelKeep"] == nil
		then
			Var["MaxLevelKeep"] = cCurrentSecond() + 1
		else
			Var["MaxLevelKeep"] = cCurrentSecond() + LevelData["MaxLevelKeep"]
		end
	end

	--------------------------
	--local CurX, CurY = cObjectLocate( Var["Handle"] )
	--cEffectRegen_XY( Var["MapIndex"], "LightShield", CurX, CurY, 0, 4, 0, 1000 )
	--------------------------

end



--------------------------------------------------------------------
--// ����� ó��
--------------------------------------------------------------------

-- ����� ó�� �Լ�
function SnowManProcess( Var )
cExecCheck( "SnowManProcess" )

	if Var == nil
	then
		return
	end

	if Var["SnowManList"] == nil
	then
		Var["SnowManList"] = {}
	end

	for i = 1, #SNOWMAN_INFO
	do
		if Var["SnowManList"][i] == nil
		then
			Var["SnowManList"][i] = Var["CurSec"] + cRandomInt( SNOWMAN_INFO[i]["LifeTime_Min"], SNOWMAN_INFO[i]["LifeTime_Max"] )

			-- ����� ����
			local MobHandle = cMobRegen_Circle( Var["MapIndex"], SNOWMAN_INFO[i]["MobIndex"], SNOWMAN_INFO[i]["CenterX"], SNOWMAN_INFO[i]["CenterY"], SNOWMAN_INFO[i]["Range"] )

			if MobHandle ~= nil
			then
				-- ���������̻� ����
				cResetAbstate( MobHandle, IMMORTAL_INDEX )

				-- ��ũ��Ʈ ���� �� �ʿ����� ����
				if cAIScriptSet( MobHandle, Var["Handle"] ) ~= nil
				then
					cAIScriptFunc( MobHandle, "Entrance", "SnowManRoutine" )

					MemBlock[MobHandle]				= {}
					MemBlock[MobHandle]["Handle"]	= MobHandle
					MemBlock[MobHandle]["MapIndex"]	= Var["MapIndex"]
					MemBlock[MobHandle]["CurSec"]	= Var["CurSec"]
					MemBlock[MobHandle]["NextTick"]	= Var["CurSec"]
					MemBlock[MobHandle]["LifeTime"]	= Var["SnowManList"][i]
					MemBlock[MobHandle]["RegenX"],
					MemBlock[MobHandle]["RegenY"]	= cObjectLocate( MobHandle )
					MemBlock[MobHandle]["DropTable"]= ITEM_DROP_TABLE[ SNOWMAN_INFO[i]["DropTable"] ]
				end
			end
		end

		if Var["SnowManList"][i] + 0.5 <= Var["CurSec"]
		then
			Var["SnowManList"][i] = nil
		end
	end

end

-- ����� ��ƾ
function SnowManRoutine( Handle, MapIndex )
cExecCheck( "SnowManRoutine" )

	local Var		= MemBlock[Handle]
	local CurSec	= cCurrentSecond()

	if Var == nil
	then
		cAIScriptSet( Handle )

		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) == 1
	then
		cAIScriptSet( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	end

	-- 0.1�ʸ��� ó��
	if Var["NextTick"] <= CurSec
	then
		Var["CurSec"]	= CurSec
		Var["NextTick"]	= Var["NextTick"] + 0.1
	else
		return ReturnAI["END"]
	end


	-- ũ������ �����̻� �ð��� ª�� üũ�� ����� �ȵǼ� ��ǥ�� üũ
	local CurX, CurY = cObjectLocate( Handle )
	if CurX == nil or CurY == nil or Var["RegenX"] == nil or Var["RegenY"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	else
		if CurX ~= Var["RegenX"] or CurY ~= Var["RegenY"]
		then
			-- ������ ���
			if Var["DropTable"] ~= nil
			then
				for j = 1, #Var["DropTable"]
				do
					cDropItem( Var["DropTable"][j]["ItemIndex"], Handle, -1, Var["DropTable"][j]["Rate"] )
				end
			end

			-- �� ���̰� �޸� ����
			cAIScriptSet( Handle )
			cKillObject( Handle )
			MemBlock[Handle] = nil

			return ReturnAI["END"]
		end
	end

	-- ������ �ð��� �������� �� ����
	if Var["LifeTime"] <= Var["CurSec"]
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	end


	return ReturnAI["END"]

end

--------------------------------------------------------------------
--// ��Ÿ���� ó�� : SantaKebingRegenProcess
--------------------------------------------------------------------

function SantaKebingRegenProcess( Var )
cExecCheck ( "SantaKebingRegenProcess" )

	if Var == nil
	then
		return
	end

	-- ���潺�̺�Ʈ ó���� �ƴϸ� return
	if MemBlock["BonusDefenceEvent"]["IsProgress"] == false
	then
		return
	end

	if MemBlock["SantaKebingList"] == nil and MemBlock["SantaKebingListHandle"] == nil
	then
		MemBlock["SantaKebingList"] 		= {}
		MemBlock["SantaKebingListHandle"] 	= {}


		for i = 1, #SANTA_KEBING_MOB_REGEN_TABLE
		do
			local temphandle	= cMobRegen_XY( Var["MapIndex"], SANTA_KEBING_MOB_REGEN_TABLE["MobIndex"], SANTA_KEBING_MOB_REGEN_TABLE[i]["RegenX"],
								SANTA_KEBING_MOB_REGEN_TABLE[i]["RegenY"], SANTA_KEBING_MOB_REGEN_TABLE[i]["Dir"] )

			if temphandle == nil
			then
				return
			end

			if MemBlock["SantaKebingList"][temphandle] == nil
			then
				MemBlock["SantaKebingList"][temphandle]	= {}

				if cAIScriptSet( temphandle, Var["Handle"] ) ~= nil
				then
					cAIScriptFunc( temphandle, "Entrance", "SantaKebingRoutine" )
				end

				MemBlock["SantaKebingList"][temphandle]["Handle"]				= temphandle
				MemBlock["SantaKebingList"][temphandle]["RunSpeed"]				= SANTA_KEBING_MOB_REGEN_TABLE["RunSpeed"]
				MemBlock["SantaKebingList"][temphandle]["TargetHandle"]			= Var["Handle"]
				MemBlock["SantaKebingList"][temphandle]["GoalX"],
				MemBlock["SantaKebingList"][temphandle]["GoalY"]				= cObjectLocate( Var["Handle"] )
				MemBlock["SantaKebingList"][temphandle]["CrushBallHitCount"]	= 0
				MemBlock["SantaKebingList"][temphandle]["PathFinding"]			= SANTA_KEBING_PATH_TABLE[i]
				MemBlock["SantaKebingListHandle"][i] = temphandle

				-- ��Ÿ���� ��ê( ������ó�� ���ҰŶ�� ������������!! )
				cMobChat( temphandle, SCRIPT_FILE_NAME, E_XKebingChat01 )

				-- �������� �ɷ��ִ� ���� �����̻� ����
				cResetAbstate( temphandle , "StaImmortal" )
			end
		end
	end

end

--------------------------------------------------------------------
--// ��Ÿ���� ó�� : SantaKebingRoutine
--------------------------------------------------------------------
function SantaKebingRoutine( Handle, MapIndex )
cExecCheck ( "SantaKebingRoutine" )

	if MapIndex ~= VALID_MAP_INDEX
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) == 1
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	local CurSantaKebing	= MemBlock["SantaKebingList"][Handle]

	-- ��ƾ���� ��� ���鼭, ��ã�� ���μ��� ����
	PathTypeProcess( Handle )

	-- ����Ʈ���� ������ ó�����ش�
	if cDistanceSquar( Handle, CurSantaKebing["TargetHandle"] ) <= ( SANTAKEBING_RANGE_WITH_TREE * SANTAKEBING_RANGE_WITH_TREE )
	then

		-- ���� �ִϸ��̼� ó��( ��ų�ִϰ� �ΰ��� �������� �־�, �ð�üũ�ؼ� ���޾� ��� )
		if MemBlock["SantaKebingList"][Handle]["CrushAniTime"] == nil
		then
			MemBlock["SantaKebingList"][Handle]["CrushAniTime"] = cCurrentSecond() + SANTA_KEBING_MOB_ANI_TABLE["CastAniKeepTime"]
			cAnimate( Handle, "start", SANTA_KEBING_MOB_ANI_TABLE["CastAniIndex"] )
		end

		if MemBlock["SantaKebingList"][Handle]["CrushAniTime"] ~= nil
		then
			if MemBlock["SantaKebingList"][Handle]["CrushAniTime"] > cCurrentSecond()
			then
				return ReturnAI["CPP"]
			end

			cAnimate( Handle, "start", SANTA_KEBING_MOB_ANI_TABLE["SwingAniIndex"] )
		end

		MemBlock["BonusDefenceEvent"]["IsSantaKebingCrush"] = true

		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	-- ũ���ú��� ��� �¾Ҵ��� üũ�Ѵ�
	if CurSantaKebing["CrushBallHitCount"] >= SANTAKEBING_CRUSHBALL_HIT_COUNT
	then
		cMobSuicide( MapIndex, Handle )

		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	return ReturnAI["END"]
end


--------------------------------------------------------------------
--// ��Ÿ���� ó�� : IsSantaKebingAllDead
--------------------------------------------------------------------
-- ��������(��Ÿ����) ��� �׾����� �Ǵ�
function IsSantaKebingAllDead( Var )
cExecCheck( "IsSantaKebingAllDead" )

	if MemBlock["SantaKebingList"] == nil
	then
		return false
	end

	for i = 1, #MemBlock["SantaKebingListHandle"] do
		if cIsObjectDead( MemBlock["SantaKebingListHandle"][i] ) == nil
		then
			return false	-- �ѳ��̶� ��������� false��ȯ
		end

		if i == #MemBlock["SantaKebingListHandle"]
		then
			return true	-- ��� �� �׾����� true ��ȯ
		end
	end
end

--------------------------------------------------------------------
--// ��Ÿ���� ó�� : SantaKebingVanishAll
--------------------------------------------------------------------
-- ��Ÿ ���� ����
function SantaKebingVanishAll( Var )
cExecCheck( "SantaKebingVanishAll" )

	if Var == nil
	then
		return
	end

	if MemBlock["SantaKebingList"] == nil
	then
		return
	end

	for i = 1, #MemBlock["SantaKebingListHandle"]
	do
		local CurHandle = MemBlock["SantaKebingListHandle"][i]

		if MemBlock["SantaKebingList"][CurHandle] ~= nil
		then
			cNPCVanish( MemBlock["SantaKebingList"][CurHandle]["Handle"] )
			MemBlock["SantaKebingList"][CurHandle] = nil
		end
	end
end


--------------------------------------------------------------------
--// ��Ÿ���� pathó�� : PathTypeProcess
--------------------------------------------------------------------
function PathTypeProcess( Handle )

	local CurSantaKebing	= MemBlock["SantaKebingList"][Handle]

	if cIsObjectDead( Handle ) == 1
	then
		return
	end

	if CurSantaKebing == nil
	then
		return
	end

	if CurSantaKebing["PathFinding"] == nil
	then
		return
	end

	-- �̹� �浹 ó�� ���̹Ƿ�, return
	if CurSantaKebing["CrushAniTime"] ~= nil
	then
		return
	end

	if MemBlock["SantaKebingList"][Handle]["PathProgress"] == nil
	then

		MemBlock["SantaKebingList"][Handle]["PathProgress"] = {}

		MemBlock["SantaKebingList"][Handle]["PathProgress"]["GoalCheckTime"] = cCurrentSecond()
		MemBlock["SantaKebingList"][Handle]["PathProgress"]["CurPathStep"]   = 1
		MemBlock["SantaKebingList"][Handle]["PathProgress"]["CurMoveState"]  = MOVESTATE["STOP"]

	end

	if CurSantaKebing["PathProgress"]["CurPathStep"] > #CurSantaKebing["PathFinding"]
	then
		return
	end


	if CurSantaKebing["PathProgress"]["CurMoveState"] == MOVESTATE["STOP"]
	then

		if cWillMovement( Handle ) == nil
		then
			return
		end

		cRunTo( Handle,
				CurSantaKebing["PathFinding"][CurSantaKebing["PathProgress"]["CurPathStep"]]["x"],
				CurSantaKebing["PathFinding"][CurSantaKebing["PathProgress"]["CurPathStep"]]["y"],
				SANTA_KEBING_MOB_REGEN_TABLE["RunSpeed"] )

		CurSantaKebing["PathProgress"]["CurMoveState"] = MOVESTATE["MOVE"]

	end


	if CurSantaKebing["PathProgress"]["CurMoveState"] == MOVESTATE["MOVE"]
	then

		-- ������ �� ���� ����
		if cWillMovement( Handle ) == nil
		then
			CurSantaKebing["PathProgress"]["CurMoveState"] = MOVESTATE["STOP"]
			return
		end

	end

	-- ��ǥ�� üũ ����
	local CurSec = cCurrentSecond()

	if CurSantaKebing["PathProgress"]["GoalCheckTime"] + PATHTYPE_CHK_DLY > CurSec
	then
		return
	end

	CurSantaKebing["PathProgress"]["GoalCheckTime"] = CurSec


	-- ��ǥ�� üũ
	local curr = {}
	local goal = {}

	curr["x"], curr["y"] 	= cObjectLocate( Handle )
	goal["x"]            	= CurSantaKebing["PathFinding"][CurSantaKebing["PathProgress"]["CurPathStep"]]["x"]
	goal["y"] 				= CurSantaKebing["PathFinding"][CurSantaKebing["PathProgress"]["CurPathStep"]]["y"]



	local dx = goal["x"] - curr["x"]
	local dy = goal["y"] - curr["y"]
	local distsquar = dx * dx + dy * dy

	if distsquar < PATHTYPE_GAP then


		CurSantaKebing["PathProgress"]["CurPathStep"]	= CurSantaKebing["PathProgress"]["CurPathStep"] + 1
		CurSantaKebing["PathProgress"]["CurMoveState"]	= MOVESTATE["STOP"]

		return

	end

	-- ���� �̵� ���ߴ� ���� ������ ������ üũ
	curr["x"], curr["y"] = cMove2Where( Handle )

	if curr["x"] ~= goal["x"] and curr["y"] ~= goal["y"] then

		cRunTo( Handle,
				CurSantaKebing["PathFinding"][CurSantaKebing["PathProgress"]["CurPathStep"]]["x"],
				CurSantaKebing["PathFinding"][CurSantaKebing["PathProgress"]["CurPathStep"]]["y"],
				SANTA_KEBING_MOB_REGEN_TABLE["RunSpeed"] )
	end

	return

end



--------------------------------------------------------------------
--// ũ���ú� ó�� : ServantSummon
--------------------------------------------------------------------
-- ũ���ú��� ���� �Լ�
function ServantSummon( MapIndex, ServantHandle, ServantIndex, MasterHandle )
cExecCheck "ServantSummon"

	-- �߸��� �� ����
	if MapIndex ~= VALID_MAP_INDEX
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	-- ���� ���潺�̺�Ʈ �۵����� �ƴѰ�� ������
	if MemBlock["BonusDefenceEvent"]["IsProgress"] ~= true
	then
		return
	end

	-- ��ȯ�� ���� ũ���ú� �ƴѰ��,
	if ServantIndex ~= CRUSHBALL_TABLE["MobIndex"]
	then
		return
	end

	cAIScriptSet( ServantHandle, MemBlock["TreeHandle"] )
	cAIScriptFunc( ServantHandle, "Entrance",  "Crushball_Entrance" )
end


--------------------------------------------------------------------
--// ũ���ú� ó�� : Crushball_Entrance
--------------------------------------------------------------------
function Crushball_Entrance( Handle, MapIndex )
cExecCheck "Crushball_Entrance"

	-- �߸��� �� ����
	if MapIndex ~= VALID_MAP_INDEX
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	-- ��Ÿ���� ���������� ó���� �ʿ�����Ƿ�
	if MemBlock["SantaKebingList"] == nil
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	-- �׾����� ��ũ��Ʈ ����
	if cIsObjectDead( Handle ) == 1
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	-- ���� ���� ��ũ��Ʈ ����
	if cIsObjectAlreadyDead( Handle ) == true
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	local NearSanta = cObjectFind( Handle, SANTAKEBING_RANGE_WITH_CRUSHBALL, SANTA_KEBING_MOB_REGEN_TABLE["MobIndex"], "so_mobile_GetIdxName" )

	-- ��ǥ�� ���� ��Ÿ������ �̹� �׾��ų�, ���� ������ ��� ��ũ��Ʈ ����
	-- ��Ÿ������ �̹� �׾��ٸ�, �� ��ó�� �ִ� �ٸ� ��󿡰� �⺻ ũ���ú� ��ų�� ����Ǿ� �ϹǷ�

	if NearSanta ~= nil
	then

		if cIsObjectDead( NearSanta ) == 1 or cIsObjectAlreadyDead( NearSanta ) == true
		then
			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end

		-- Ȯ�������� ��Ÿ������ �˹� �����̻��� �ɾ��ش�.
		if cPermileRate( CRUSHBALL_ABSTATE_TABLE["AbStateHitRate"] ) == 1
		then
			cSetAbstate( NearSanta, CRUSHBALL_ABSTATE_TABLE["AbstateIndex"], CRUSHBALL_ABSTATE_TABLE["Strength"], CRUSHBALL_ABSTATE_TABLE["KeepTime"], Handle )
		end

		MemBlock["SantaKebingList"][NearSanta]["CrushBallHitCount"]		= MemBlock["SantaKebingList"][NearSanta]["CrushBallHitCount"] + 1
		--DebugLog("��Ÿ�����ڵ鰪 : "..NearSanta..", ���� ũ���ú� : "..MemBlock["SantaKebingList"][NearSanta]["CrushBallHitCount"])
		cSkillBlast		( Handle, Handle, CRUSHBALL_TABLE["SkillIndex"] )
		cVanishReserv	( Handle, 3 )

		return ReturnAI["END"]
	end

	-- ���� �����̰� �ִٸ� ó������ ���ư���.
	if cGetMoveState( Handle ) ~= 0
	then
		return ReturnAI["CPP"]
	end

	return ReturnAI["END"]

end


----------------------------------------------------------------------
-- Log Functions
----------------------------------------------------------------------

function DebugLog( String )
cExecCheck ( "DebugLog" )

	if String == nil
	then
		cAssertLog( "DebugLog::String == nil" )
		return
	end
	cAssertLog( "Debug - "..String )
end


function ErrorLog( String )
cExecCheck ( "ErrorLog" )

	if String == nil
	then
		cAssertLog( "ErrorLog::String == nil" )
		return
	end
	cAssertLog( "Error - "..String )
end
