-------------------------------------------------------------------------------
SCRIPT_MAIN				= "KQ/KDEgg/KDEgg"	-- ��ũ��Ʈ
ABSTATE_IMT_IDX			= "StaImmortal"		-- ���� �����̻� �ε���
PATHTYPE_GAP   			= 100				-- ���̺�� �̵���ǥüũ �����Ÿ�
MM_G_WAVEMOB    		= 0					-- �ʸ�ŷ �׷� ����, ���̺�� ���� ǥ��
MM_G_GATE   		    = 1000				-- �ʸ�ŷ �׷� ����, ����Ʈ ��ġ ǥ��
MM_G_MAIN				= 1500				-- �ʸ�ŷ �׷� ����, �ް� ��ġ
MAP_MARK_CHK_DLY		= 1
PATHTYPE_CHK_DLY		= 1
DEF_TYPE_CHK_DLY		= 1
CM_STUN_INDEX			= "StaAdlFStun"
CM_STUN_KEEP			= 30000
QUEST_SUCCESS			= 1
QUEST_FAIL				= 2
END_EFFECT_WAIT			= 3					-- ���� ����Ʈ ������ ��� �ð�
-------------------------------------------------------------------------------


--[[*************************************************************************]]--
--[[*****			�÷��̾� ���� ���� �� �帧 ���� ������				*****]]--
--[[*****																*****]]--
--STATIC_SPEED_RATE   = 2000		-- �̵��ӵ�
ABSTATE_SPEED_UP_INDEX	= "StaKQEggSpUp"
ABSTATE_SPEED_UP_KEEP	= 9999999
KD_JOIN_WAIT_TIME   = 32		-- ŷ�� ��ũ��Ʈ ���� �� ���ð�
KD_WAVE_WAIT_TIME   = 960		-- ���̺� ���� �� ���� �ð� ��
KD_END_LINKTO = {}				-- ŷ�� ������ �̵� ��ġ
KD_END_LINKTO["Index"] = "Eld"
KD_END_LINKTO["x"] = 17214
KD_END_LINKTO["y"] = 13445
--[[*****																*****]]--
--[[*****					�÷��̾� ���� ���� ������					*****]]--
--[[*************************************************************************]]--


--[[*************************************************************************]]--
--[[*****						���� ������ ���� ������					*****]]--
--[[*****																*****]]--
-- [�����̻�]
-- ��ź�� ������ �ɾ��� Abstate �ε����� �߰�.
-- KeepTime�� �и��� ����
AbstateTypeTable =
{
	None            = nil,
	MineIce         = { Index = "StaMineIce",      keepTime =  6000, },
	MineStun        = { Index = "StaMineStun",     keepTime =  3000, },
}

-- [����]
-- ���ÿ� ���� ItemID Ȯ�� �ʿ�
MineTable =
{
	MineMelee = { MobIndex = "Egg_Melee", ItemID = 62569, Skill = "EggMelee_W", Dist = 0, HitTime = 5, LifeTime = 7, Damage = 1500, Range = 100, AbstateType = "None",     },
	MineRange = { MobIndex = "Egg_Range", ItemID = 62570, Skill = "EggRange_W", Dist = 0, HitTime = 5, LifeTime = 7, Damage = 500, Range = 200, AbstateType = "None",     },
}
--[[*****																*****]]--
--[[*****						���� ������ ���� ������					*****]]--
--[[*************************************************************************]]--


--[[*************************************************************************]]--
--[[*****						�ʸ�ŷ ���� ������						*****]]--
--[[*****																*****]]--
-- [�ʸ�ŷŸ��]
MapMarkTypeTable =
{
	None          = nil,
	Normal        = { IconIndex = "MobNormal",      KeepTime =     3000, Order = 1, },
	Gate          = { IconIndex = "Gate",           KeepTime = 99999999, Order = 0, },
	LastGate      = { IconIndex = "Templer",        KeepTime = 99999999, Order = 0, },
}
--[[*****																*****]]--
--[[*****						�ʸ�ŷ ���� ������						*****]]--
--[[*************************************************************************]]--


--[[*************************************************************************]]--
--[[*****					��� ������Ʈ ���� ������					*****]]--
--[[*****																*****]]--
-- [���ο�����Ʈ]
-- �ı��Ǹ� �̼� ����
MainDefenceObject =
{ Index = "Egg_GoldEgg", x = 11437, y = 13426, dir = 90, HP = 2000, DamageRange = 150, MapMarkType = "LastGate", }

Ani_Index =
{
	"Egg_GoldEgg_Stand",	-- �Ⱦ�
	"Egg_GoldEgg_Stand1",	-- ���� ��
	"Egg_GoldEgg_Damage",	-- �Ⱦ�
	"Egg_GoldEgg_Die",		-- �Ⱦ�
	"Egg_GoldEgg_Stand1_chain",	-- ���� ����
	"Egg_GoldEgg_Die_chain",	-- ���� ����
}

CameraMove =
{ x = MainDefenceObject["x"], y = MainDefenceObject["y"], AngleXZ = 270, AngleY = 20, Dist = 800, }

-- [����Ʈ]
-- �� ���� ��ġ�� �ƹ� ���� ���� ����Ʈ
ObjectTable =
{
	{ Index = "Egg_Door", x = 15102, y = 15743, dir = 124, MapMarkType = "Gate", },
	{ Index = "Egg_Door", x = 16298, y = 13384, dir = 136, MapMarkType = "Gate", },
	{ Index = "Egg_Door", x = 14886, y = 11423, dir = 0, MapMarkType = "Gate", },
}

-- [����NPC]
MerchantNPC = "Egg_Digger"
--[[*****																*****]]--
--[[*****					��� ������Ʈ ���� ������					*****]]--
--[[*************************************************************************]]--


--[[*************************************************************************]]--
--[[*****						���̺� ���� ������						*****]]--
--[[*****																*****]]--
-- [��][������][����]
-- ���� ���潺 ���̺� �״�λ��
ResistTypeTable =
{
	Normal          = { ResDot       =    0,		-- rate/1000
						ResStun      =    0,
						ResMoveSpeed =    0,
						ResFear      =    0,
						ResBinding   =    0,
						ResReverse   =    0,
						ResMesmerize =    0,
						ResSeverBone =    0,
						ResKnockBack =    0,
						ResTBMinus   =    0, },
	Elite           = { ResDot       =  500,
						ResStun      =  500,
						ResMoveSpeed =  500,
						ResFear      =  500,
						ResBinding   =  500,
						ResReverse   =  500,
						ResMesmerize =  500,
						ResSeverBone =  500,
						ResKnockBack =  500,
						ResTBMinus   =  500, },
	Chief           = { ResDot       = 1000,
						ResStun      = 1000,
						ResMoveSpeed = 1000,
						ResFear      = 1000,
						ResBinding   = 1000,
						ResReverse   = 1000,
						ResMesmerize = 1000,
						ResSeverBone = 1000,
						ResKnockBack = 1000,
						ResTBMinus   = 1000, },
}


-- [��][������][�⺻]
-- ���� �⺻ �ɷ�ġ��.
MobSettingTypeTable =
{
	Boogy			= { Index = "Egg_Boogy01",		Demage = 100,	HP = 3000,		HPRegen = 0,	AC = 0, MR = 0,	Speed = 60,	Exp = 1,	ItemDrop = 1, },
	BoogyKnight		= { Index = "Egg_Boogy02",		Demage = 100,	HP = 3000,		HPRegen = 0,	AC = 0, MR = 0, Speed = 60,	Exp = 1,	ItemDrop = 1, },
	KingBoogy		= { Index = "Egg_Boogy03",		Demage = 100,	HP = 8000,		HPRegen = 0,	AC = 0, MR = 0, Speed = 60,	Exp = 1,	ItemDrop = 1, },
	Honeying		= { Index = "Egg_Honeying01",	Demage = 100,	HP = 3000,		HPRegen = 0,	AC = 0, MR = 0, Speed = 60,	Exp = 1,	ItemDrop = 1, },
	FlameHoneying	= { Index = "Egg_Honeying02",	Demage = 100,	HP = 3000,		HPRegen = 0,	AC = 0, MR = 0, Speed = 60,	Exp = 1,	ItemDrop = 1, },
	Honeying_G		= { Index = "Egg_Honeying03",	Demage = 60,	HP = 8000,		HPRegen = 0,	AC = 0, MR = 0, Speed = 100,	Exp = 1,	ItemDrop = 1, },
	Kebing			= { Index = "Egg_Kebing",		Demage = 100,	HP = 3000,		HPRegen = 0,	AC = 0, MR = 0, Speed = 60,	Exp = 1,	ItemDrop = 1, },
	Crab			= { Index = "Egg_Crab",			Demage = 100,	HP = 3000,		HPRegen = 0,	AC = 0, MR = 0, Speed = 60,	Exp = 1,	ItemDrop = 1, },
	KingCrab		= { Index = "Egg_KingCrab",		Demage = 60,	HP = 8000,		HPRegen = 0,	AC = 0, MR = 0, Speed = 100,	Exp = 1,	ItemDrop = 1, },
}


-- [��][��ê]
MobChatTypeTable =
{
	None = nil,

	MobChat_1 =
	{
		NormalChatTime = { Min = 10, Max = 100, },

		Normal =
		{
			{ FileName = "KDEgg", Index = "Mob01_Normal01", },
			{ FileName = "KDEgg", Index = "Mob01_Normal02", },
			{ FileName = "KDEgg", Index = "Mob01_Normal03", },
		},

		DieChatRate = 5,

		Die =
		{
			{ FileName = "KDEgg", Index = "Mob01_Die01", },
			{ FileName = "KDEgg", Index = "Mob01_Die02", },
			{ FileName = "KDEgg", Index = "Mob01_Die03", },
		},
	},

	MobChat_2 =
	{
		NormalChatTime = { Min = 10, Max = 100, },

		Normal =
		{
			{ FileName = "KDEgg", Index = "Mob02_Normal01", },
			{ FileName = "KDEgg", Index = "Mob02_Normal02", },
			{ FileName = "KDEgg", Index = "Mob02_Normal03", },
		},

		DieChatRate = 5,

		Die =
		{
			{ FileName = "KDEgg", Index = "Mob02_Die01", },
			{ FileName = "KDEgg", Index = "Mob02_Die02", },
		},
	},
}


-- [���̺��]
-- ���̺꿡�� ������ �� ����
WaveMobTypeTable =
{
	W_Boogy			= { MobSettingType = "Boogy",			ResistType = "Normal",	MapMarkType = "Normal", MobChatType = "MobChat_1" },
	W_BoogyKnight	= { MobSettingType = "BoogyKnight",		ResistType = "Normal",	MapMarkType = "Normal", MobChatType = "None" },
	W_KingBoogy		= { MobSettingType = "KingBoogy",		ResistType = "Normal",	MapMarkType = "Normal", MobChatType = "None" },

	W_Honeying		= { MobSettingType = "Honeying",		ResistType = "Normal",	MapMarkType = "Normal", MobChatType = "None" },
	W_FlameHoneying	= { MobSettingType = "FlameHoneying",	ResistType = "Normal",	MapMarkType = "Normal", MobChatType = "MobChat_2" },
	W_Honeying_G	= { MobSettingType = "Honeying_G",		ResistType = "Normal",	MapMarkType = "Normal", MobChatType = "MobChat_2" },

	W_Kebing		= { MobSettingType = "Kebing",			ResistType = "Normal",	MapMarkType = "Normal", MobChatType = "MobChat_1" },

	W_Crab			= { MobSettingType = "Crab",			ResistType = "Normal",	MapMarkType = "Normal", MobChatType = "MobChat_1" },
	W_KingCrab		= { MobSettingType = "KingCrab",		ResistType = "Normal",	MapMarkType = "Normal", MobChatType = "None" },
}


-- [���̺�][���]
-- ���̺������ ������ ��� ��ǥ
-- �� ����� ù��° ��ǥ�� ������ǥ�� ���
PathTypeTable =
{
	PathA   = { { x = 15102, y = 15743, },
				{ x = 14703, y = 15542, },
				{ x = 14132, y = 15349, },
				{ x = 14061, y = 15296, },
				{ x = 14000, y = 14906, },
				{ x = 14072, y = 14492, },
				{ x = 14201, y = 14182, },
				{ x = 14230, y = 14121, },
				{ x = 14415, y = 14013, },
				{ x = 14510, y = 13888, },
				{ x = 14519, y = 13685, },
				{ x = 14557, y = 13449, },
				{ x = 14446, y = 13472, },
				{ x = 13897, y = 13448, },
				{ x = 13687, y = 13438, },
				{ x = 13565, y = 13527, },
				{ x = 13531, y = 13680, },
				{ x = 13543, y = 13794, },
				{ x = 13556, y = 13967, },
				{ x = 13519, y = 14133, },
				{ x = 13390, y = 14228, },
				{ x = 13246, y = 14249, },
                                { x = 13104, y = 14241, },
                                { x = 12940, y = 14145, },
                                { x = 12853, y = 13971, },
                                { x = 12863, y = 13738, },
                                { x = 12780, y = 13580, },
                                { x = 12636, y = 13445, },
                                { x = 12523, y = 13419, },
                                { x = 12191, y = 13434, },
                                { x = 11695, y = 13427, },
                                { x = 11437, y = 13426, }, },
	PathB   = { { x = 16323, y = 13384, },
				{ x = 16018, y = 13419, },
				{ x = 15719, y = 13443, },
				{ x = 15370, y = 13460, },
				{ x = 15051, y = 13468, },
				{ x = 14905, y = 13470, },
				{ x = 14557, y = 13449, },
				{ x = 14446, y = 13472, },
				{ x = 13897, y = 13448, },
				{ x = 13687, y = 13438, },
				{ x = 13565, y = 13527, },
				{ x = 13531, y = 13680, },
				{ x = 13543, y = 13794, },
				{ x = 13556, y = 13967, },
				{ x = 13519, y = 14133, },
				{ x = 13390, y = 14228, },
				{ x = 13246, y = 14249, },
                                { x = 13104, y = 14241, },
                                { x = 12940, y = 14145, },
                                { x = 12853, y = 13971, },
                                { x = 12863, y = 13738, },
                                { x = 12780, y = 13580, },
                                { x = 12636, y = 13445, },
                                { x = 12523, y = 13419, },
                                { x = 12191, y = 13434, },
                                { x = 11695, y = 13427, },
                                { x = 11437, y = 13426, }, },
	PathC   = { { x = 14886, y = 11423, },
				{ x = 14908, y = 11800, },
				{ x = 14911, y = 12276, },
				{ x = 14913, y = 12553, },
				{ x = 14943, y = 13088, },
				{ x = 14956, y = 13226, },
				{ x = 14905, y = 13470, },
				{ x = 14557, y = 13449, },
				{ x = 14446, y = 13472, },
				{ x = 13897, y = 13448, },
				{ x = 13687, y = 13438, },
				{ x = 13565, y = 13527, },
				{ x = 13531, y = 13680, },
				{ x = 13543, y = 13794, },
				{ x = 13556, y = 13967, },
				{ x = 13519, y = 14133, },
				{ x = 13390, y = 14228, },
				{ x = 13246, y = 14249, },
                                { x = 13104, y = 14241, },
                                { x = 12940, y = 14145, },
                                { x = 12853, y = 13971, },
                                { x = 12863, y = 13738, },
                                { x = 12780, y = 13580, },
                                { x = 12636, y = 13445, },
                                { x = 12523, y = 13419, },
                                { x = 12191, y = 13434, },
                                { x = 11695, y = 13427, },
                                { x = 11437, y = 13426, }, },
         PathD   = { { x = 10926, y = 15203, },
                                { x = 10927, y = 15026, },
                                { x = 10947, y = 14919, },
                                { x = 11258, y = 14942, },
                                { x = 11432, y = 14918, },
                                { x = 11437, y = 14723, },
                                { x = 11430, y = 13832, },
                                { x = 11437, y = 13426, }, },
         PathE   = { { x = 10940, y = 11321, },
                                { x = 10920, y = 11780, },
                                { x = 10996, y = 11917, },
                                { x = 11368, y = 11907, },
                                { x = 11439, y = 11998, },
                                { x = 11442, y = 12420, },
                                { x = 11446, y = 12923, },
                                { x = 11437, y = 13426, }, },
}


-- [���̺� �׷�]
WaveGroup =
{
	GroupA =
	{
		{ WaveMobType = "W_Boogy",			Num =  10,	RegenInterval =   2, WaveStepInterval =	2, },
		{ WaveMobType = "W_BoogyKnight",	Num =   3,	RegenInterval =   2, WaveStepInterval =	2, },
		{ WaveMobType = "W_KingBoogy",		Num =   2,	RegenInterval =   2, WaveStepInterval =	2, },
	},

	GroupB =
	{
		{ WaveMobType = "W_Honeying",		Num =  10,	RegenInterval =   2, WaveStepInterval =	2, },
		{ WaveMobType = "W_FlameHoneying",	Num =   3,	RegenInterval =   2, WaveStepInterval =	2, },
		{ WaveMobType = "W_Honeying_G",		Num =   2,	RegenInterval =   2, WaveStepInterval =	2, },
	},

	GroupC =
	{
		{ WaveMobType = "W_Kebing",			Num =  15,	RegenInterval =   2, WaveStepInterval =	2, },
	},

	GroupD =
	{
		{ WaveMobType = "W_Crab",			Num =  10,	RegenInterval =   2, WaveStepInterval =	2, },
		{ WaveMobType = "W_KingCrab",		Num =   3,	RegenInterval =   2, WaveStepInterval =	2, },
	},
}


-- *[���̺�]*
-- ���� ���̺� ����
-- Num�� ������ �ϴ� Ƚ��, RegenInterval�� �����ϱ��� ������, WaveStepInterval�� ���̺� ���� �� ������
WaveTable =
{
--[[1]]	{
			Dialog		= "W_1",
			Announce	= "KDEgg_MobRegen01",

			PathA = WaveGroup["GroupA"],
		},

--[[2]]	{
			Dialog		= "W_2",
			Announce	= "KDEgg_MobRegen01",

			PathA = WaveGroup["GroupA"],
			PathC = WaveGroup["GroupA"],
		},

--[[3]]	{
			Dialog		= "W_3",
			Announce	= "KDEgg_MobRegen01",

			PathB = WaveGroup["GroupC"],
			PathC = WaveGroup["GroupA"],
		},

--[[4]]	{
			Announce	= "KDEgg_MobRegen01",

			PathA = WaveGroup["GroupC"],
			PathC = WaveGroup["GroupC"],
		},

--[[5]]	{
			Dialog		= "W_5",
			Announce	= "KDEgg_MobRegen01",

			PathB = WaveGroup["GroupB"],
			PathC = WaveGroup["GroupC"],
		},

--[[6]]	{
                        Dialog          = "W_6",
			Announce	= "KDEgg_MobRegen01",

			PathD = WaveGroup["GroupD"],
			PathE = WaveGroup["GroupC"],
		},

--[[7]]	{
			Announce	= "KDEgg_MobRegen01",

			PathB = WaveGroup["GroupA"],
			PathC = WaveGroup["GroupB"],
		},

--[[8]]	{
			Dialog		= "W_8",
			Announce	= "KDEgg_MobRegen02",

			PathA = WaveGroup["GroupA"],
			PathB = WaveGroup["GroupB"],
			PathD = WaveGroup["GroupC"],
		},

--[[9]]	{
			PathA = WaveGroup["GroupB"],
			PathB = WaveGroup["GroupC"],
			PathE = WaveGroup["GroupD"],
		},

--[[10]]{
			Dialog		= "W_10",

			PathA = WaveGroup["GroupC"],
			PathB = WaveGroup["GroupD"],
			PathC = WaveGroup["GroupA"],
		},
}


-- [�ʸ�ŷ]
-- üũ�� ��ǥ �� �Ÿ�
-- �ٸ� ���̺��� �������� ����
MapMarkLocateTable =
{
	{ x = 15102, y = 15743, Range = 100, },
	{ x = 14261, y = 15371, Range = 100, },
	{ x = 14089, y = 15290, Range = 100, },
	{ x = 13998, y = 15174, Range = 100, },
	{ x = 14043, y = 14895, Range = 100, },
	{ x = 14120, y = 14116, Range = 100, },
	{ x = 14283, y = 13555, Range = 100, },

	{ x = 16323, y = 13384, Range = 100, },
	{ x = 15259, y = 13404, Range = 100, },
	{ x = 14695, y = 13406, Range = 100, },

	{ x = 14886, y = 11423, Range = 100, },
	{ x = 14875, y = 12190, Range = 100, },
	{ x = 14680, y = 12555, Range = 100, },
	{ x = 14659, y = 12700, Range = 100, },
	{ x = 14678, y = 13178, Range = 100, },
	{ x = 14695, y = 13406, Range = 100, },

	{ x = 14323, y = 13421, Range = 100, },
	{ x = 14079, y = 13426, Range = 100, },
	{ x = 13755, y = 13431, Range = 100, },
	{ x = 13619, y = 13461, Range = 100, },
	{ x = 13624, y = 13646, Range = 100, },
	{ x = 13497, y = 13891, Range = 100, },
	{ x = 13338, y = 13991, Range = 100, },
	{ x = 13025, y = 13967, Range = 100, },
	{ x = 12917, y = 13901, Range = 100, },
	{ x = 12761, y = 13713, Range = 100, },
	{ x = 12673, y = 13554, Range = 100, },
	{ x = 12496, y = 13441, Range = 100, },
	{ x = 12129, y = 13453, Range = 100, },
	{ x = 11581, y = 13432, Range = 100, },
	{ x = 11387, y = 13433, Range = 100, },

        { x = 10926, y = 15203, Range = 100, },
        { x = 10927, y = 15026, Range = 100, },
        { x = 10947, y = 14919, Range = 100, },
        { x = 11258, y = 14942, Range = 100, },
        { x = 11432, y = 14918, Range = 100, },
        { x = 11437, y = 14723, Range = 100, },
        { x = 11430, y = 13832, Range = 100, },

        { x = 10940, y = 11321, Range = 100, },
        { x = 10920, y = 11780, Range = 100, },
        { x = 10996, y = 11917, Range = 100, },
        { x = 11368, y = 11907, Range = 100, },
        { x = 11439, y = 11998, Range = 100, },
        { x = 11442, y = 12420, Range = 100, },
        { x = 11446, y = 12923, Range = 100, },
}
--[[*****																*****]]--
--[[*****						���̺� ���� ������						*****]]--
--[[*************************************************************************]]--


--[[*************************************************************************]]--
--[[*****						���� �����̻� 							*****]]--
--[[*****																*****]]--
-- [����]
RewardAbstate =
{
	{ Index = "StaKQEggReward", KeepTime = (60 * 60 * 1000) },
}
--[[*****																*****]]--
--[[*****						���� �����̻� 							*****]]--
--[[*************************************************************************]]--


--[[*************************************************************************]]--
--[[*****				��ũ��Ʈ �� ���� ���� ������					*****]]--
--[[*****																*****]]--
-- [���̾�α�]
-- Delay = ��������
DialogInfo =
{
	-- �����
	Egg_Join =
	{
		{ Facecut = "EldCastleLordElderiss",	FileName = "KDEgg", Index = "EldLord_01",	Delay = 0 },
		{ Facecut = "EldKidWorze",				FileName = "KDEgg", Index = "Worze_01",		Delay = 3 },
		{ Facecut = "EldItemMctKenton",			FileName = "KDEgg", Index = "Kenton_01",	Delay = 3 },
		{ Facecut = "EldGaianBjurin",			FileName = "KDEgg", Index = "Maria_01",		Delay = 3 },
		{ Facecut = "RouDiggerPalmers",			FileName = "KDEgg", Index = "Palmers_01",	Delay = 3 },
	},

	-- ���̺�
	W_1 =
	{
		{ Facecut = "EldGuardCaptainShutian",	FileName = "KDEgg", Index = "Shutian_01",	Delay = 3 },
		{ Facecut = "Egg_Boogy01",				FileName = "KDEgg", Index = "Boogy_01",		Delay = 3 },
		{ Facecut = "RouDiggerPalmers",			FileName = "KDEgg", Index = "Palmers_02",	Delay = 3 },
		{ Facecut = "RouDiggerPalmers",			FileName = "KDEgg", Index = "Palmers_03",	Delay = 3 },
	},

	W_2 =
	{
		{ Facecut = "EldKidWorze",				FileName = "KDEgg", Index = "Worze_02",		Delay = 0 },
		{ Facecut = "EldItemMctKenton",			FileName = "KDEgg", Index = "Kenton_02",	Delay = 3 },
	},

	W_3 =
	{
		{ Facecut = "Egg_Kebing",				FileName = "KDEgg", Index = "Kebing_01",	Delay = 0 },
	},

	W_5 =
	{
		{ Facecut = "Honeyng",					FileName = "KDEgg", Index = "Honeyng_01",	Delay = 0 },
	},
        W_6 =
        {
                { Facecut = "EldGuardCaptainShutian",    FileName = "KDEgg", Index = "Shutian_03",        Delay = 0 },
        },
	W_8 =
	{
		{ Facecut = "Honeyng",					FileName = "KDEgg", Index = "Honeyng_02",	Delay = 0 },
		{ Facecut = "Egg_Kebing",				FileName = "KDEgg", Index = "Kebing_02",	Delay = 3 },
		{ Facecut = "Egg_Boogy01",				FileName = "KDEgg", Index = "Boogy_02",		Delay = 3 },
	},

	W_10 =
	{
		{ Facecut = "EldGuardCaptainShutian",	FileName = "KDEgg", Index = "Shutian_02",	Delay = 0 },
		{ Facecut = "RouDiggerPalmers",			FileName = "KDEgg", Index = "Palmers_04",	Delay = 3 },
	},

	-- ����
	Egg_Success =
	{
		{ Facecut = "Egg_Kebing",				FileName = "KDEgg", Index = "Kebing_03",	Delay = 4 },
		{ Facecut = "RouDiggerPalmers",			FileName = "KDEgg", Index = "Palmers_05",	Delay = 3 },
		{ Facecut = "RouDiggerPalmers",			FileName = "KDEgg", Index = "Palmers_06",	Delay = 3 },
		{ Facecut = "RouDiggerPalmers",			FileName = "KDEgg", Index = "Palmers_07",	Delay = 3 },
		{ Facecut = "EldItemMctKenton",			FileName = "KDEgg", Index = "Kenton_03",	Delay = 3 },
		{ Facecut = "EldItemMctKenton",			FileName = "KDEgg", Index = "Kenton_04",	Delay = 3 },
	},

	-- ����
	Egg_Fail =
	{
		{ Facecut = "Honeyng",					FileName = "KDEgg", Index = "Honeyng_03",	Delay = 4 },
		{ Facecut = "RouDiggerPalmers",			FileName = "KDEgg", Index = "Palmers_08",	Delay = 3 },
		{ Facecut = "RouDiggerPalmers",			FileName = "KDEgg", Index = "Palmers_09",	Delay = 3 },
	},
}

-- [����]
-- WaitTime = �ĵ�����
NoticeInfo =
{
	-- �δ� ����
	KQReturn =
	{
		{ FileName = "KDEgg",	Index = "KQReturn30",	WaitTime = 10, },
		{ FileName = "KDEgg",	Index = "KQReturn20",	WaitTime = 10, },
		{ FileName = "KDEgg",	Index = "KQReturn10",	WaitTime =  5, },
		{ FileName = "KDEgg",	Index = "KQReturn5",	WaitTime =  5, },
	},
}

AnnounceInfo =
{
	KDEgg_MobRegen01	= "KDEgg_MobRegen01",	-- ���̺� ����
	KDEgg_MobRegen02	= "KDEgg_MobRegen02",	-- ���̺� ���� ( ������ )
	KDEgg_EggHp			= "KDEgg_EggHp",		-- �ް� HP
	KDEgg_Success		= "KDEgg_Success",		-- ����
	KDEgg_Fail			= "KDEgg_Fail",			-- ����
}
--[[*****																*****]]--
--[[*****				��ũ��Ʈ �� ���� ���� ������					*****]]--
--[[*************************************************************************]]--


