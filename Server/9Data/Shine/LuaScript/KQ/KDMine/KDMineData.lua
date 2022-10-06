-------------------------------------------------------------------------------
--** �� �κ��� ���α׷����� ���� �� ������ ����
SCRIPT_MAIN = "KQ/KDMine/KDMine"-- ��ũ��Ʈ
Fig = 1							-- ĳ���� ���̽�Ŭ���� ��ȣ ����
Cle = 6
Arc = 11
Mag = 16
Jok = 21
ABSTATE_IMT_IDX = "StaImmortal"		-- ���� �����̻� �ε���
BOOM_AP         = 10000				-- ��ź�� ��׷� ������
PATHTYPE_GAP    = 100				-- ���̺�� �̵���ǥüũ �����Ÿ�
ESCORT_H_GAP    = 100				-- ȣ���� ����ġüũ �����Ÿ�
ESCORT_H_S_RATE = 1500				-- ȣ���� ����ġ ��߳����� �̵��ӵ���
ESCORT_H_G_INIT = 0					-- ȣ���� ����ġ ��߳����� �ʱ�ȭ ��ǥ��ǥ
ESCORT_M_GAP    = 50				-- ȣ���� �������� ��ǥ��üũ �����Ÿ�
MM_G_WAVEMOB    = 0					-- �ʸ�ŷ �׷� ����, ���̺�� ���� ǥ��
MM_G_GATE       = 1000				-- �ʸ�ŷ �׷� ����, ����Ʈ ��ġ ǥ��
MM_G_FENCE      = 1500				-- �ʸ�ŷ �׷� ����, ��å ǥ��
MM_G_MAIN       = 2000              -- �ʸ�ŷ �׷� ����, ���ο�����Ʈ
MM_K_GATE       = 99999999			-- ����Ʈ �ʸ�ŷ ǥ�� �ð�
CHAR_CASTING    = "ActionProduct"	-- �÷��̾� ĳ���ý� �ִϸ��̼�
MAP_MARK_CHK_DLY= 1
BOOMTYPE_CHK_DLY= 1
SUMMTYPE_CHK_DLY= 1
ESCOTYPE_CHK_DLY= 1
PATHTYPE_CHK_DLY= 1
DEF_TYPE_CHK_DLY= 1
-------------------------------------------------------------------------------





--[[*************************************************************************]]--
--[[*****			�÷��̾� ���� ���� �� �帧 ���� ������				*****]]--
--[[*****																*****]]--

-- �߰� ���� 9. Ŭ���� �� ������� ������ ���� ����
--STATIC_DAMAGE       = 100		-- ������
STATIC_DAMAGE = {}
STATIC_DAMAGE[Fig]  = 641
STATIC_DAMAGE[Cle]  = 794
STATIC_DAMAGE[Arc]  = 336
STATIC_DAMAGE[Mag]  = 316
STATIC_DAMAGE[Jok]  = 678
STATIC_SPEED_RATE   = 2000		-- �̵��ӵ�
STATIC_MOVER_SPEED  = 4000		-- ���� �̵��ӵ�
KD_JOIN_WAIT_TIME   = 32 		-- ŷ�� ��ũ��Ʈ ���� �� ���ð�
KD_WAVE_WAIT_TIME   = 960              -- ���̺� ���� �� ���� �ð� ��
KD_END_LINKTO = {}				-- ŷ�� ������ �̵� ��ġ
KD_END_LINKTO["Index"] = "Gate"
KD_END_LINKTO["x"] = 1487
KD_END_LINKTO["y"] = 1517
--[[*****																*****]]--
--[[*****					�÷��̾� ���� ���� ������					*****]]--
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


-- [��][������][��ź][Ŭ����]
-- Ÿ�Կ� ������ ���̽�Ŭ���� ��ȣ�� ��� �־��ְ� �߰�
FollowTypeTable =
{
	All             = { Fig, Cle, Arc, Mag, Jok, },
	Fighter         = { Fig, },
	Cleric          = { Cle, },
	Archer          = { Arc, },
	Mage            = { Mag, },
	Joker           = { Jok, },

	Range           = { Arc, Mag, },
	Melee           = { Fig, Cle, Jok, },
}


-- [��][������][��ź][�����̻�]
-- ��ź�� ������ �ɾ��� Abstate �ε����� �߰�.
-- KeepTime�� �и��� ����
AbstateTypeTable =
{
	None            = nil,
	ShortStun       = { Index = "StaMineFireViVi", KeepTime =  2000, },
	LongSlow        = { Index = "StaMineIceViVi",  keepTime =  5000, },
	MineIce         = { Index = "StaMineIce",      keepTime =  6000, },
	MineStun        = { Index = "StaMineStun",     keepTime =  3000, },
}


-- [��][������][��ź]
-- ��ź�� Ÿ���� �߰�.
-- �����̻� ���̺�� Ŭ���� ���̺��� �ε����� ����
BoomTypeTable =
{
	None			= nil,
	StunBoom        = { AbstateType = "ShortStun",  FollowType = "Melee",   FollowInterval = 30, ExplosionGap = 100, FollowSpeedRate = 300, },
	Slowboom        = { AbstateType = "LongSlow",   FollowType = "Range",   FollowInterval = 30, ExplosionGap = 100, FollowSpeedRate = 300, },
}


-- [��][������][�⺻]
-- ���� �⺻ �ɷ�ġ��.
-- Index �� MobInfo�� �ε����� ���
-- HPRegen �� �޽Ļ��·� ���� �ٲ������� ȸ����
-- ItemDrop �� 0�̸� ��� ����
MobSettingTypeTable =
{
	Slime           = { Index = "MineSlime",        Demage = 40,    HP =   90,     HPRegen =   10,   AC =    30000, MR =    30000, Speed = 50,  Exp = 1, ItemDrop = 0, },
	EscortSlime     = { Index = "MineSlime",        Demage = 50,    HP =   95,     HPRegen =   12,   AC =    30000, MR =    30000, Speed = 50,  Exp = 1, ItemDrop = 0, },
	Honeying        = { Index = "MineHoneying",     Demage = 45,    HP =   110,    HPRegen =   16,   AC =    30000, MR =    30000, Speed = 50,  Exp = 1, ItemDrop = 0, },
	EscortHoneying  = { Index = "MineHoneying",     Demage = 55,    HP =   110,    HPRegen =   22,   AC =    30000, MR =    30000, Speed = 50,  Exp = 1, ItemDrop = 0, },
	Pinky           = { Index = "MinePinky",        Demage = 160,   HP =   200,    HPRegen =   28,   AC =    30000, MR =    30000, Speed = 50,  Exp = 1, ItemDrop = 0, },
	Kebing          = { Index = "MineKebing",       Demage = 70,    HP =   240,    HPRegen =   28,   AC =    30000, MR =    30000, Speed = 50,  Exp = 1, ItemDrop = 0, },
	EscortKebing    = { Index = "MineKebing",       Demage = 80,    HP =   260,    HPRegen =   32,   AC =    30000, MR =    30000, Speed = 50,  Exp = 1, ItemDrop = 0, },
	Boogy           = { Index = "MineBoogy",        Demage = 90,    HP =   280,    HPRegen =   36,   AC =    30000, MR =    30000, Speed = 50,  Exp = 1, ItemDrop = 0, },
	Crab            = { Index = "MineCrab",         Demage = 100,   HP =   300,    HPRegen =   40,   AC =    30000, MR =    30000, Speed = 50,  Exp = 1, ItemDrop = 0, },
	EscortCrab      = { Index = "MineCrab",         Demage = 120,   HP =   340,    HPRegen =   45,   AC =    30000, MR =    30000, Speed = 50,  Exp = 1, ItemDrop = 0, },
	Monkey_Boss     = { Index = "MineMonkey_Boss",  Demage = 1000,  HP =   2000,   HPRegen =   120,  AC =    30000, MR =    30000, Speed = 100, Exp = 1, ItemDrop = 0, },
	S_Kebing        = { Index = "MineS_Kebing",     Demage = 150,   HP =   400,    HPRegen =   60,   AC =    30000, MR =    30000, Speed = 50,  Exp = 1, ItemDrop = 0, },
	EscortS_Kebing  = { Index = "MineS_Kebing",     Demage = 150,   HP =   400,    HPRegen =   60,   AC =    30000, MR =    30000, Speed = 50,  Exp = 1, ItemDrop = 0, },
	KingBoogy       = { Index = "MineKingBoogy",    Demage = 180,   HP =   460,    HPRegen =   66,   AC =    30000, MR =    30000, Speed = 50,  Exp = 1, ItemDrop = 0, },
	Rock            = { Index = "MineRock",         Demage = 200,   HP =   500,    HPRegen =   80,   AC =    30000, MR =    30000, Speed = 60,  Exp = 1, ItemDrop = 0, },
	EmperorCrab     = { Index = "MineEmperorCrab",  Demage = 500,   HP =   1000,   HPRegen =   200,  AC =    30000, MR =    30000, Speed = 50,  Exp = 1, ItemDrop = 0, },
	StoneGolem      = { Index = "MineStoneGolem",   Demage = 600,   HP =   3000,   HPRegen =   240,  AC =    30000, MR =    30000, Speed = 80,  Exp = 1, ItemDrop = 0, },
	FireGolem       = { Index = "MineFireGolem",    Demage = 800,   HP =   5000,   HPRegen =   320,  AC =    30000, MR =    30000, Speed = 80,  Exp = 1, ItemDrop = 0, },
	IronGolem       = { Index = "MineIronGolem",    Demage = 1000,  HP =   8000,   HPRegen =   400,  AC =    30000, MR =    30000, Speed = 100, Exp = 1, ItemDrop = 0, },
	IceViVi         = { Index = "MineIceViVi",      Demage = 1,     HP =   1000,   HPRegen =   200,  AC =    30000, MR =    30000, Speed = 60,  Exp = 1, ItemDrop = 0, },
	FireViVi        = { Index = "MineFireViVi",     Demage = 1,     HP =   1000,   HPRegen =   200,  AC =    30000, MR =    30000, Speed = 60,  Exp = 1, ItemDrop = 0, },
	MineCar         = { Index = "MineCar",          Demage = 500,   HP =   1000,   HPRegen =   300,  AC =    30000, MR =    30000, Speed = 50,  Exp = 1, ItemDrop = 0, },
	MineCarHard     = { Index = "MineCar",          Demage = 1000,  HP =   5000,   HPRegen =   500,  AC =    30000, MR =    30000, Speed = 60,  Exp = 1, ItemDrop = 0, },
}


-- [��ȯ��]
-- ���̺���� ��ȯ�� ��ȯ������
-- �⺻�ɷ�ġ ���̺�� ��ź Ÿ�����̺�� �������̺� ���
-- ��źŸ���� None�ϰ�� ���� ���ǵ� �⺻ AI�� Ȱ��
SummonMobTypeTable =
{
	S_Slime         = { MobSettingType = "EscortSlime",    BoomType = "None",      ResistType = "Normal",   },
	S_Honeying      = { MobSettingType = "EscortHoneying", BoomType = "None",      ResistType = "Normal",   },
	S_Kebing        = { MobSettingType = "EscortKebing",   BoomType = "None",      ResistType = "Normal",   },
	S_S_Kebing      = { MobSettingType = "EscortS_Kebing", BoomType = "None",      ResistType = "Normal",   },
	S_Crab          = { MobSettingType = "EscortCrab",     BoomType = "None",      ResistType = "Normal",   },
	S_IceViVi       = { MobSettingType = "IceViVi",        BoomType = "Slowboom",  ResistType = "Chief",   },
	S_FireViVi      = { MobSettingType = "FireViVi",       BoomType = "StunBoom",  ResistType = "Chief",   },
--	S_SlimeP        = { MobSettingType = "PowerSlime",     BoomType = "None",      ResistType = "Elite",    },
--	E_SlimeBoom     = { MobSettingType = "PowerSlime",     BoomType = "StunBoom",  ResistType = "Chief",    },
}


-- [���̺��][��ȯ][��ȯ�׷�]
-- ���̺���� ��ȯ�� ������ �׷����� ����
-- Rotate�� true�ϰ�� ���̺���� ���� ������ �߽����� Dir���⿡ ����
-- false�ϰ�� Dir ���⿡ ����
SummonGroupTypeTable =
{
	SG_Slime   = { { SummonMobType = "S_Slime",      Rotate = true,  Dir =  90, Dist = 100, },
						{ SummonMobType = "S_Slime",      Rotate = true,  Dir = 270, Dist = 100, }, },
	SG_Honeying   = { { SummonMobType = "S_Honeying",      Rotate = true,  Dir =  90, Dist = 100, },
						{ SummonMobType = "S_Honeying",      Rotate = true,  Dir = 270, Dist = 100, }, },
	SG_Kebing   = { { SummonMobType = "S_Kebing",      Rotate = true,  Dir =  90, Dist = 100, },
						{ SummonMobType = "S_Kebing",      Rotate = true,  Dir = 270, Dist = 100, }, },
	SG_S_Kebing   = { { SummonMobType = "S_S_Kebing",      Rotate = true,  Dir =  90, Dist = 100, },
						{ SummonMobType = "S_S_Kebing",      Rotate = true,  Dir = 270, Dist = 100, }, },
	SG_Crab   = { { SummonMobType = "S_Crab",      Rotate = true,  Dir =  90, Dist = 100, },
						{ SummonMobType = "S_Crab",      Rotate = true,  Dir = 270, Dist = 100, }, },
	SG_IceViVi   = { { SummonMobType = "S_IceViVi",      Rotate = true,  Dir =  90, Dist = 100, },
						{ SummonMobType = "S_IceViVi",      Rotate = true,  Dir = 270, Dist = 100, }, },
	SG_FireViVi   = { { SummonMobType = "S_FireViVi",      Rotate = true,  Dir =  90, Dist = 100, },
						{ SummonMobType = "S_FireViVi",      Rotate = true,  Dir = 270, Dist = 100, }, },
}

-- [���̺��][��ȯ]
-- ��ȯ�� ��Ÿ�Ӱ� üũ�� �÷��̾� �νĹ��� ����
-- None�ϰ�� ��ȯ���� ����
SummonTypeTable =
{
	None            = nil,
	DefenseSummonS1    = { SummonGroupType = "SG_Slime",  CheckRange =  200, CoolTime = 10, },
	DefenseSummonS2    = { SummonGroupType = "SG_Honeying",  CheckRange =  200, CoolTime = 10, },
	DefenseSummonS3    = { SummonGroupType = "SG_Kebing",  CheckRange =  200, CoolTime = 10, },
	DefenseSummonS4    = { SummonGroupType = "SG_S_Kebing",  CheckRange =  200, CoolTime = 10, },
	DefenseSummonS5    = { SummonGroupType = "SG_Crab",  CheckRange =  200, CoolTime = 10, },
	OffenseSummonS1    = { SummonGroupType = "SG_IceViVi",  CheckRange =  300, CoolTime = 30, },
	OffenseSummonS2    = { SummonGroupType = "SG_FireViVi",  CheckRange =  300, CoolTime = 30, },
}


-- [���̺��][ȣ�ֱ׷�]
-- ȣ���ϴ� ������ �׷����� ����
-- ��ȯ�� ���̺��� ����ϰ�, None�ϰ�� ��ȯ���� ����
-- ȣ���ϴ� ������ �⺻������ ���̺�� �ֺ����� �Բ� �̵�
EscortGroupTypeTable =
{
	None            = nil,
	EG_Slime   = { { SummonMobType = "S_Slime",      Rotate =  true, Dir =   90, Dist = 100, },
						{ SummonMobType = "S_Slime",      Rotate =  true, Dir = 270, Dist = 100, }, },
	EG_Honeying   = { { SummonMobType = "S_Honeying",      Rotate =  true, Dir =   90, Dist = 100, },
						{ SummonMobType = "S_Honeying",      Rotate =  true, Dir = 270, Dist = 100, }, },
	EG_Kebing   = { { SummonMobType = "S_Kebing",      Rotate =  true, Dir =   90, Dist = 100, },
						{ SummonMobType = "S_Kebing",      Rotate =  true, Dir = 270, Dist = 100, }, },
	EG_S_Kebing   = { { SummonMobType = "S_S_Kebing",      Rotate =  true, Dir =   90, Dist = 100, },
						{ SummonMobType = "S_S_Kebing",      Rotate =  true, Dir = 270, Dist = 100, }, },
	EG_Crab   = { { SummonMobType = "S_Crab",      Rotate =  true, Dir =   45, Dist = 100, },
						{ SummonMobType = "S_Crab",      Rotate =  true, Dir = 315, Dist = 100, }, },
	EG_IceViVi   = { { SummonMobType = "S_IceViVi",      Rotate =  true, Dir =   90, Dist = 100, },
						{ SummonMobType = "S_IceViVi",      Rotate =  true, Dir = 270, Dist = 100, }, },
	EG_FireViVi   = { { SummonMobType = "S_FireViVi",      Rotate =  true, Dir =   90, Dist = 100, },
						{ SummonMobType = "S_FireViVi",      Rotate =  true, Dir = 270, Dist = 100, }, },
}


-- [�ʸ�ŷ]
-- IconIndex�� �߰��� �۷ι��ε��� �߰��� ������ ��� �Լ� ������ �ʿ���
-- ������ ������ �켱 ������ �������� Order ���� ���� ����. ���̺�������� ���.
-- �� ��ŷ�� ��ǥ ���� ���̺�� ���� �־�� ó�� ����
MapMarkTypeTable =
{
	None          = nil,
	Normal        = { IconIndex = "MobNormal",  	KeepTime =     3000, Order = 1, },
	Chief         = { IconIndex = "MobChief",   	KeepTime =     3000, Order = 2, },
	Gate          = { IconIndex = "Gate",       	KeepTime = 99999999, Order = 0, },
	FenceNormal   = { IconIndex = "NotDamaged",   	KeepTime = 99999999, Order = 0, },
	FenceDamage   = { IconIndex = "AlreadyDamaged", KeepTime = 99999999, Order = 0, },
	FenceDestruct = { IconIndex = "MobDmg",     	KeepTime = 99999999, Order = 0, },
	LastGate      = { IconIndex = "Templer",    	KeepTime = 99999999, Order = 0, },
}


-- [���̺��]
-- ���̺꿡�� ������ �� ����
-- �⺻�ɷ�ġ, ��ź, ����, ��ȯ, ȣ�ֱ׷� ���̺��� ���
WaveMobTypeTable =
{
	W_1_Slime            = { MobSettingType = "Slime",       BoomType = "None",     ResistType = "Normal",   SummonType = "None",          EscortGroupType = "None",         MapMarkType = "Normal",    },
	W_1_Pinky            = { MobSettingType = "Pinky",       BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "None",  MapMarkType = "Normal",    },
	W_1_1_MineCar        = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "EG_Honeying",  MapMarkType = "Normal",    },

	W_1_Crab             = { MobSettingType = "Crab",        BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "None",         MapMarkType = "Normal",    },
	W_1_2_MineCar        = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "None",         MapMarkType = "Normal",    },
	W_1_EmperorCrab      = { MobSettingType = "EmperorCrab", BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "EG_Crab",      MapMarkType = "Normal",    },

	W_1_3_MineCar        = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "EG_S_Kebing",    MapMarkType = "Normal",    },
	W_1_KingBoogy        = { MobSettingType = "KingBoogy",   BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Normal",    },


	W_2_1_KingBoogy      = { MobSettingType = "KingBoogy",   BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "None",    MapMarkType = "Normal",    },
	W_2_1_1_Monkey_Boss    = { MobSettingType = "Monkey_Boss", BoomType = "None",     ResistType = "Chief",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Chief",    },
	W_2_1_MineCar        = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "EG_S_Kebing",    MapMarkType = "Normal",    },

	W_2_2_EmperorCrab    = { MobSettingType = "EmperorCrab", BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "EG_Crab",     MapMarkType = "Normal",    },
	W_2_2_1_Monkey_Boss    = { MobSettingType = "Monkey_Boss", BoomType = "None",     ResistType = "Chief",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Chief",    },
	W_2_2_MineCar        = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "None",     MapMarkType = "Normal",    },

	W_2_3_Honeying       = { MobSettingType = "Honeying",       BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "EG_Honeying", MapMarkType = "Normal",    },
	W_2_3_MineCar        = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "EG_IceViVi",  MapMarkType = "Normal",    },
	W_2_3_1_Monkey_Boss    = { MobSettingType = "Monkey_Boss", BoomType = "None",     ResistType = "Chief",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Chief",    },
	W_2_3_1_MineCar      = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "EG_FireViVi", MapMarkType = "Normal",    },

	W_3_1_Monkey_Boss    = { MobSettingType = "Monkey_Boss", BoomType = "None",     ResistType = "Chief",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Chief",    },
	W_3_2_Monkey_Boss    = { MobSettingType = "Monkey_Boss", BoomType = "None",     ResistType = "Chief",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Chief",    },
	W_3_3_Monkey_Boss    = { MobSettingType = "Monkey_Boss", BoomType = "None",     ResistType = "Chief",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Chief",    },

	W_4_1_FireGolem       = { MobSettingType = "FireGolem",    BoomType = "None",     ResistType = "Chief",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Chief",    },
	W_4_1_1_MineCar      = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "EG_IceViVi",  MapMarkType = "Normal",    },
	W_4_1_2_MineCar      = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "EG_FireViVi", MapMarkType = "Normal",    },

	W_4_2_MineCar        = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "EG_Crab",     MapMarkType = "Normal",    },
	W_4_2_Honeying       = { MobSettingType = "Honeying",    BoomType = "None",     ResistType = "Normal",   SummonType = "None",          EscortGroupType = "None",  MapMarkType = "Normal",    },
	W_4_2_1_Honeying     = { MobSettingType = "Honeying",    BoomType = "None",     ResistType = "Normal",   SummonType = "None",          EscortGroupType = "None", MapMarkType = "Normal",    },

	W_4_3_1_MineCar      = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "None",    MapMarkType = "Normal",    },
	W_4_3_KingBoogy      = { MobSettingType = "KingBoogy",   BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "EG_S_Kebing",    MapMarkType = "Normal",    },
	W_4_3_2_MineCar      = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "EG_IceViVi",  MapMarkType = "Normal",    },

	W_5_1_MineCar        = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "EG_Kebing",   MapMarkType = "Normal",    },
	W_5_1_S_Kebing       = { MobSettingType = "S_Kebing",    BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "None",   MapMarkType = "Normal",    },
	W_5_1_Slime          = { MobSettingType = "Slime",       BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "None",    MapMarkType = "Normal",    },

	W_5_2_MineCar        = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "EG_Crab",     MapMarkType = "Normal",    },
	W_5_2_EmperorCrab    = { MobSettingType = "EmperorCrab", BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "EG_Honeying", MapMarkType = "Normal",    },

	W_5_3_MineCar        = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Normal",    },
	W_5_3_StoneGolem     = { MobSettingType = "StoneGolem",  BoomType = "None",     ResistType = "Chief",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Chief",    },
	W_5_3_Rock           = { MobSettingType = "Rock",        BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Chief",    },

	W_6_1_Monkey_Boss    = { MobSettingType = "Monkey_Boss", BoomType = "None",     ResistType = "Chief",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Chief",    },
	W_6_2_Monkey_Boss    = { MobSettingType = "Monkey_Boss", BoomType = "None",     ResistType = "Chief",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Chief",    },
	W_6_3_Monkey_Boss    = { MobSettingType = "Monkey_Boss", BoomType = "None",     ResistType = "Chief",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Chief",    },

	W_7_1_MineCar        = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Normal",    },
	W_7_1_StoneGolem     = { MobSettingType = "StoneGolem",  BoomType = "None",     ResistType = "Chief",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Chief",    },
	W_7_2_MineCar        = { MobSettingType = "MineCar",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Normal",    },
	W_7_2_FireGolem      = { MobSettingType = "FireGolem",   BoomType = "None",     ResistType = "Chief",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Chief",    },
	W_7_3_MineCar        = { MobSettingType = "MineCarHard",     BoomType = "None",     ResistType = "Elite",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Normal",    },
	W_7_3_IronGolem      = { MobSettingType = "IronGolem",   BoomType = "None",     ResistType = "Chief",   SummonType = "None",          EscortGroupType = "None",        MapMarkType = "Chief",    },
}


-- [���̺�][���]
-- ���̺������ ������ ��� ��ǥ
-- �� ����� ù��° ��ǥ�� ������ǥ�� ���
PathTypeTable =
{
	PathA           = { { x =  8478, y =  7812, },
						{ x =  8464, y =  7632, },
						{ x =  8221, y =  7437, },
						{ x =  7960, y =  7346, },
						{ x =  7214, y =  7336, },
						{ x =  7063, y =  7295, },
						{ x =  6895, y =  7130, },
						{ x =  6884, y =  6405, },
						{ x =  6819, y =  6296, },
						{ x =  6680, y =  6203, },
						{ x =  6521, y =  6170, },
						{ x =  6229, y =  6170, },
						{ x =  5855, y =  6170, },
						{ x =  5686, y =  6229, },
						{ x =  5530, y =  6427, },
						{ x =  5460, y =  6556, },
						{ x =  5301, y =  6642, },
						{ x =  5126, y =  6674, },
						{ x =  4900, y =  6656, },
						{ x =  4755, y =  6583, },
						{ x =  4632, y =  6455, },
						{ x =  4643, y =  5373, },
						{ x =  4643, y =  4273, },
						{ x =  4646, y =  3433, },
						{ x =  4764, y =  3289, },
						{ x =  4995, y =  3166, },
						{ x =  5083, y =  3029, },
						{ x =  5087, y =  1874, },
						{ x =  5084, y =  511, }, },

	PathB           = { { x =  9430, y =  5105, },
						{ x =  8640, y =  5105, },
						{ x =  6387, y =  5105, },
						{ x =  5845, y =  5110, },
						{ x =  5530, y =  5334, },
						{ x =  5530, y =  6427, },
						{ x =  5460, y =  6556, },
						{ x =  5301, y =  6642, },
						{ x =  5126, y =  6674, },
						{ x =  4900, y =  6656, },
						{ x =  4755, y =  6583, },
						{ x =  4632, y =  6455, },
						{ x =  4643, y =  5373, },
						{ x =  4643, y =  4273, },
						{ x =  4646, y =  3433, },
						{ x =  4764, y =  3289, },
						{ x =  4995, y =  3166, },
						{ x =  5083, y =  3029, },
						{ x =  5087, y =  1874, },
						{ x =  5084, y =   511, }, },

	PathC           = { { x =  8478, y =  2690, },
						{ x =  8469, y =  2690, },
						{ x =  8219, y =  2833, },
						{ x =  7913, y =  2846, },
						{ x =  7218, y =  2837, },
						{ x =  7015, y =  2908, },
						{ x =  6892, y =  3077, },
						{ x =  6886, y =  3748, },
						{ x =  6834, y =  3864, },
						{ x =  6687, y =  3976, },
						{ x =  6534, y =  4007, },
						{ x =  6236, y =  4007, },
						{ x =  5858, y =  4007, },
						{ x =  5699, y =  4060, },
						{ x =  5539, y =  4234, },
						{ x =  5530, y =  5334, },
						{ x =  5530, y =  6427, },
						{ x =  5460, y =  6556, },
						{ x =  5301, y =  6642, },
						{ x =  5126, y =  6674, },
						{ x =  4900, y =  6656, },
						{ x =  4755, y =  6583, },
						{ x =  4632, y =  6455, },
						{ x =  4643, y =  5373, },
						{ x =  4643, y =  4273, },
						{ x =  4646, y =  3433, },
						{ x =  4764, y =  3289, },
						{ x =  4995, y =  3166, },
						{ x =  5083, y =  3029, },
						{ x =  5087, y =  1874, },
						{ x =  5084, y =  511, }, },
}


-- *[���̺�]*
-- ���� ���̺� ����
-- ���̺���� ��� ���̺� ���
-- Num�� ������ �ϴ� Ƚ��, RegenInterval�� �����ϱ��� ������, WaveStepInterval�� ���̺� ���� �� ������
WaveTable =
{
--[[1]]	  { { WaveMobType = "W_1_Slime",        PathType = "PathB",         Num =  30, RegenInterval =   2, WaveStepInterval =   2, },
			{ WaveMobType = "W_1_Pinky",            PathType = "PathB",         Num =  12,  RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_1_1_MineCar",        PathType = "PathB",         Num =  2,   RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_1_Crab",             PathType = "PathA",         Num =  20,  RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_1_2_MineCar",        PathType = "PathA",         Num =  2,   RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_1_EmperorCrab",      PathType = "PathA",         Num =  3,   RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_1_3_MineCar",        PathType = "PathC",         Num =  3,   RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_1_KingBoogy",        PathType = "PathC",         Num =  4,   RegenInterval =   2, WaveStepInterval =  2, }, },

--[[2]]   { { WaveMobType = "W_2_1_KingBoogy",     PathType = "PathB",         Num =  5, RegenInterval =   2, WaveStepInterval =  6, },
			{ WaveMobType = "W_2_1_1_Monkey_Boss",  PathType = "PathC",         Num =  1,  RegenInterval =   2, WaveStepInterval =  6, },
			{ WaveMobType = "W_2_1_MineCar",        PathType = "PathB",         Num =  4,  RegenInterval =   2, WaveStepInterval =  6, },
			{ WaveMobType = "W_2_2_EmperorCrab",    PathType = "PathA",         Num =  3,  RegenInterval =   3, WaveStepInterval =  2, },
			{ WaveMobType = "W_2_2_1_Monkey_Boss",  PathType = "PathB",         Num =  1,  RegenInterval =   2, WaveStepInterval =  6, },
			{ WaveMobType = "W_2_2_MineCar",        PathType = "PathA",         Num =  8,  RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_2_3_Honeying",       PathType = "PathC",         Num =  10, RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_2_3_1_Monkey_Boss",  PathType = "PathA",         Num =  1,  RegenInterval =   2, WaveStepInterval =  6, },
			{ WaveMobType = "W_2_3_MineCar",        PathType = "PathC",         Num =  8,  RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_2_3_1_MineCar",      PathType = "PathC",         Num =  6,  RegenInterval =   2, WaveStepInterval =  2, }, },

--[[3]]   { { WaveMobType = "W_3_1_Monkey_Boss",     PathType = "PathB",         Num =  1, RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_3_2_Monkey_Boss",    PathType = "PathA",         Num =  1,  RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_3_3_Monkey_Boss",    PathType = "PathC",         Num =  1,  RegenInterval =   2, WaveStepInterval =  2, }, },

--[[4]]   { { WaveMobType = "W_4_1_FireGolem",     PathType = "PathB",         Num =  1, RegenInterval =   2, WaveStepInterval =  6, },
			{ WaveMobType = "W_4_2_Honeying",       PathType = "PathA",         Num =  20,  RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_4_1_1_MineCar",      PathType = "PathB",         Num =  4,   RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_4_2_1_Honeying",     PathType = "PathA",         Num =  8,   RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_4_1_2_MineCar",      PathType = "PathB",         Num =  5,   RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_4_3_1_MineCar",      PathType = "PathC",         Num =  4,   RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_4_2_MineCar",        PathType = "PathA",         Num =  5,   RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_4_1_FireGolem",      PathType = "PathB",         Num =  1,   RegenInterval =   2, WaveStepInterval =  8, },
			{ WaveMobType = "W_4_3_KingBoogy",      PathType = "PathC",         Num =  10,  RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_4_3_2_MineCar",      PathType = "PathC",         Num =  2,   RegenInterval =   2, WaveStepInterval =  3, }, },

--[[5]]   { { WaveMobType = "W_5_1_MineCar",     PathType = "PathB",         Num =  5, RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_5_1_S_Kebing",       PathType = "PathB",         Num =  12,  RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_5_1_Slime",          PathType = "PathA",         Num =  20,  RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_5_1_S_Kebing",       PathType = "PathC",         Num =  12,  RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_5_1_Slime",          PathType = "PathA",         Num =  20,  RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_5_2_MineCar",        PathType = "PathB",         Num =  4,   RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_5_2_EmperorCrab",    PathType = "PathB",         Num =  5,   RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_6_3_Monkey_Boss",    PathType = "PathA",         Num =  2,   RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_6_2_Monkey_Boss",    PathType = "PathC",         Num =  2,   RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_5_2_MineCar",        PathType = "PathC",         Num =  4,   RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_5_2_EmperorCrab",    PathType = "PathA",         Num =  5,   RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_5_3_MineCar",        PathType = "PathC",         Num =  3,   RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_5_3_StoneGolem",     PathType = "PathC",         Num =  3,  RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_5_3_Rock",           PathType = "PathC",         Num =  7,   RegenInterval =   2, WaveStepInterval =  3, }, },

--[[6]]   { { WaveMobType = "W_6_1_Monkey_Boss",     PathType = "PathA",         Num =  7, RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_6_2_Monkey_Boss",    PathType = "PathB",         Num =  5,  RegenInterval =   2, WaveStepInterval =  3, },
			{ WaveMobType = "W_6_3_Monkey_Boss",    PathType = "PathC",         Num =  8,  RegenInterval =   2, WaveStepInterval =  3, }, },

--[[7]]   { { WaveMobType = "W_7_1_MineCar",     PathType = "PathB",         Num =  7, RegenInterval =   4, WaveStepInterval =  5, },
			{ WaveMobType = "W_5_2_EmperorCrab",    PathType = "PathC",         Num =  5,  RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_7_1_StoneGolem",     PathType = "PathB",         Num =  7,  RegenInterval =   4, WaveStepInterval =  3, },
			{ WaveMobType = "W_7_2_MineCar",        PathType = "PathA",         Num =  10,  RegenInterval =   4, WaveStepInterval =  3, },
			{ WaveMobType = "W_6_2_Monkey_Boss",    PathType = "PathB",         Num =  5,  RegenInterval =   2, WaveStepInterval =  2, },
			{ WaveMobType = "W_7_2_FireGolem",      PathType = "PathA",         Num =  8,  RegenInterval =   4, WaveStepInterval =  3, },
			{ WaveMobType = "W_7_3_MineCar",        PathType = "PathC",         Num =  5,  RegenInterval =   4, WaveStepInterval =  3, },
			{ WaveMobType = "W_7_3_IronGolem",      PathType = "PathC",         Num =  3,  RegenInterval =   4, WaveStepInterval =  3, }, },
}


-- [�ʸ�ŷ]
-- üũ�� ��ǥ �� �Ÿ�
-- �ٸ� ���̺��� �������� ����
MapMarkLocateTable =
{
	{ x =  8468, y =  7716, Range = 100 },
	{ x =  7937, y =  7347, Range = 100 },
	{ x =  7259, y =  7336, Range = 100 },
	{ x =  6901, y =  7140, Range = 100 },
	{ x =  6881, y =  6720, Range = 100 },
	{ x =  6868, y =  6365, Range = 100 },
	{ x =  6595, y =  5174, Range = 100 },
	{ x =  6032, y =  6174, Range = 100 },
	{ x =  5613, y =  6291, Range = 100 },
--
	{ x =  9366, y =  5089, Range = 100 },
	{ x =  8937, y =  5036, Range = 100 },
	{ x =  8473, y =  5101, Range = 100 },
	{ x =  7806, y =  5098, Range = 100 },
	{ x =  7205, y =  5102, Range = 100 },
	{ x =  6646, y =  5098, Range = 100 },
	{ x =  5673, y =  5156, Range = 100 },
--
	{ x =  5484, y =  2375, Range = 100 },
	{ x =  8275, y =  2678, Range = 100 },
	{ x =  7910, y =  2829, Range = 100 },
	{ x =  7463, y =  2834, Range = 100 },
	{ x =  7035, y =  2894, Range = 100 },
	{ x =  6891, y =  3205, Range = 100 },
	{ x =  6884, y =  3689, Range = 100 },
	{ x =  6698, y =  3969, Range = 100 },
	{ x =  6236, y =  4007, Range = 100 },
	{ x =  5682, y =  4079, Range = 100 },
	{ x =  5540, y =  4610, Range = 100 },
--
	{ x =  5495, y =  4279, Range = 100 },
	{ x =  5537, y =  4684, Range = 100 },
	{ x =  5535, y =  5069, Range = 100 },
	{ x =  5539, y =  6042, Range = 100 },
	{ x =  5422, y =  6607, Range = 100 },
	{ x =  5531, y =  5715, Range = 100 },
	{ x =  7959, y =  6647, Range = 100 },
	{ x =  4598, y =  6562, Range = 100 },
	{ x =  4647, y =  5938, Range = 100 },
	{ x =  4641, y =  5417, Range = 100 },
	{ x =  4639, y =  4716, Range = 100 },
	{ x =  4640, y =  4034, Range = 100 },
	{ x =  4637, y =  3442, Range = 100 },
	{ x =  5002, y =  3146, Range = 100 },
	{ x =  5084, y =  2717, Range = 100 },
	{ x =  5086, y =  2054, Range = 100 },
	{ x =  5085, y =  1527, Range = 100 },
	{ x =  5093, y =  919, Range = 100 },
}
--[[*****																*****]]--
--[[*****						���̺� ���� ������						*****]]--
--[[*************************************************************************]]--




--[[*************************************************************************]]--
--[[*****				�ο��� �� ĳ���� ������ ���� ������				*****]]--
--[[*****																*****]]--
-- [Ŭ������ ���� ������]
-- ��ġ���� ����
ClassBalanceValue = {}
ClassBalanceValue[Fig] = 1000		-- rate
ClassBalanceValue[Cle] =  700
ClassBalanceValue[Arc] = 1400
ClassBalanceValue[Mag] = 2000
ClassBalanceValue[Jok] =  800


-- [������]
-- BalanceValue�� ���� ������ ����
BalanceTable =
{
	{ BalanceValue =   50, DamageRate = 1000, SpeedRate = 1000, HPRate = 2000, },
	{ BalanceValue =  100, DamageRate = 1000, SpeedRate = 1000, HPRate = 3000, },
	{ BalanceValue =  150, DamageRate = 1000, SpeedRate = 1000, HPRate = 4000, },
	{ BalanceValue = 1000, DamageRate = 1000, SpeedRate = 1050, HPRate = 5500, },
	{ BalanceValue = 1500, DamageRate = 1000, SpeedRate = 1100, HPRate = 7000, },
	{ BalanceValue = 2000, DamageRate = 1100, SpeedRate = 1200, HPRate = 9000, },
	{ BalanceValue = 2500, DamageRate = 1200, SpeedRate = 1300, HPRate = 12000, },
	{ BalanceValue = 3000, DamageRate = 1300, SpeedRate = 1400, HPRate = 15000, },
}
--[[*****																*****]]--
--[[*****				�ο��� �� ĳ���� ������ ���� ������				*****]]--
--[[*************************************************************************]]--




--[[*************************************************************************]]--
--[[*****						����Ʈ ���� ������						*****]]--
--[[*****																*****]]--
-- [����Ʈ]
-- ����Ʈ ��ġ, �̵��� ��ġ �� ����
-- �÷��̾� ����� �ʸ�ŷ �ʿ� ������ MapMarkType = "None"
GateSettingTable =
{
	{ Index = "Gate_ID_Complete", RegenX = 7460, RegenY = 2734, RegenDir = 0, GoalX = 6866, GoalY = 5105, MapMarkType = "Gate" },
	{ Index = "Gate_ID_Complete", RegenX = 6757, RegenY = 4507, RegenDir = 0, GoalX = 7186, GoalY = 2808, MapMarkType = "Gate" },
	{ Index = "Gate_ID_Complete", RegenX = 7460, RegenY = 7496, RegenDir = 0, GoalX = 6866, GoalY = 5105, MapMarkType = "Gate" },
	{ Index = "Gate_ID_Complete", RegenX = 6726, RegenY = 5665, RegenDir = 0, GoalX = 7263, GoalY = 7338, MapMarkType = "Gate" },
}
--[[*****																*****]]--
--[[*****						����Ʈ ���� ������						*****]]--
--[[*************************************************************************]]--




--[[*************************************************************************]]--
--[[*****					��� ������Ʈ ���� ������					*****]]--
--[[*****																*****]]--
-- [�ִϻ���]
-- �� ���� �ִϸ��̼� �ε��� ����
-- HPRate�� õ�з�, ���� ������ ����
AniStateTypeTable =
{
	MineFence = {	{ HPRate =    0, AniIndex = "MineFence_Action04", },
					{ HPRate =  300, AniIndex = "MineFence_Action03", },
					{ HPRate =  700, AniIndex = "MineFence_Action02", },
					{ HPRate = 1000, AniIndex = "MineFence_Action01", },	},
}


-- [������]
-- �ʿ� ǥ���� ������ Ÿ��
-- ���¿� ���� �ٸ� ������ ����ϱ� ���� ���̺� �и�
MMGroupTypeTable =
{
	Default = { Normal = "FenceNormal", Damage = "FenceDamage", Destruct = "FenceDestruct", },
}


-- [���뷱��]
-- ��å�� �μ������� ������ ��
DefBalanceTypeTable =
{
	None    = nil,
	Light   = { DamageRate = 100, SpeedRate =  10, HPRate = 100, },
	Normal  = { DamageRate = 200, SpeedRate =  20, HPRate = 200, },
	weight  = { DamageRate = 300, SpeedRate =  30, HPRate = 400, },
}


-- [��������Ʈ]
DefenceObjectTable =
{
	{
		Index          = "MineFence",
		x              = 6229,
		y              = 6170,
		dir            = 90,
		HP             = 150,
		DamageRange    = 150,
		RepairTime     = 7,
		RepairDlyTime  = 5,
		AniStateType   = "MineFence",
		MMGroupType    = "Default",
		DefBalanceType = "Light",
	},
	{
		Index          = "MineFence",
		x              = 6387,
		y              = 5105,
		dir            = 90,
		HP             = 150,
		DamageRange    = 150,
		RepairTime     = 7,
		RepairDlyTime  = 5,
		AniStateType   = "MineFence",
		MMGroupType    = "Default",
		DefBalanceType = "weight",
	},
	{
		Index          = "MineFence",
		x              = 6236,
		y              = 4007,
		dir            = 90,
		HP             = 150,
		DamageRange    = 150,
		RepairTime     = 7,
		RepairDlyTime  = 5,
		AniStateType   = "MineFence",
		MMGroupType    = "Default",
		DefBalanceType = "weight",
	},
	{
		Index          = "MineFence",
		x              = 5530,
		y              = 6427,
		dir            = 180,
		HP             = 200,
		DamageRange    = 150,
		RepairTime     = 7,
		RepairDlyTime  = 5,
		AniStateType   = "MineFence",
		MMGroupType    = "Default",
		DefBalanceType = "Normal",
	},
	{
		Index          = "MineFence",
		x              = 5530,
		y              = 5334,
		dir            = 180,
		HP             = 200,
		DamageRange    = 150,
		RepairTime     = 7,
		RepairDlyTime  = 5,
		AniStateType   = "MineFence",
		MMGroupType    = "Default",
		DefBalanceType = "weight",
	},
	{
		Index          = "MineFence",
		x              = 4643,
		y              = 5373,
		dir            = 180,
		HP             = 300,
		DamageRange    = 150,
		RepairTime     = 7,
		RepairDlyTime  = 5,
		AniStateType   = "MineFence",
		MMGroupType    = "Default",
		DefBalanceType = "weight",
	},
	{
		Index          = "MineFence",
		x              = 4643,
		y              = 4273,
		dir            = 180,
		HP             = 300,
		DamageRange    = 150,
		RepairTime     = 7,
		RepairDlyTime  = 5,
		AniStateType   = "MineFence",
		MMGroupType    = "Default",
		DefBalanceType = "weight",
	},
	{
		Index          = "MineFence",
		x              = 5083,
		y              = 3029,
		dir            = 180,
		HP             = 300,
		DamageRange    = 150,
		RepairTime     = 7,
		RepairDlyTime  = 5,
		AniStateType   = "MineFence",
		MMGroupType    = "Default",
		DefBalanceType = "weight",
	},
	{
		Index          = "MineFence",
		x              = 5087,
		y              = 1874,
		dir            = 180,
		HP             = 300,
		DamageRange    = 150,
		RepairTime     = 7,
		RepairDlyTime  = 5,
		AniStateType   = "MineFence",
		MMGroupType    = "Default",
		DefBalanceType = "weight",
	},
}


-- [���ο�����Ʈ]
-- �ı��Ǹ� �̼� ����
MainDefenceObject =
{ Index = "MineGate", x = 5084, y = 511, dir = 0, HP = 5000, DamageRange = 150, MapMarkType = "LastGate", }


-- [�κ�]
-- �ƹ� ���� ����
ObjectTable =
{
	{ Index = "MineDigger01", x = 6108, y = 6320, dir = 90, },
	{ Index = "MineDigger01", x = 5646, y = 6568, dir = 180, },
	{ Index = "MineDigger01", x = 4715, y = 5249, dir = 0, },
	{ Index = "MineDigger01", x = 4726, y = 4151, dir = 0, },
	{ Index = "MineDigger01", x = 5184, y = 2885, dir = 0, },
	{ Index = "MineDigger01", x = 6267, y = 5215, dir = 90, },
	{ Index = "MineDigger01", x = 5606, y = 5510, dir = 180, },
	{ Index = "MineDigger01", x = 6141, y = 4134, dir = 90, },
}
--[[*****																*****]]--
--[[*****					��� ������Ʈ ���� ������					*****]]--
--[[*************************************************************************]]--





--[[*************************************************************************]]--
--[[*****						���� ������ ���� ������					*****]]--
--[[*****																*****]]--
-- [����]
-- ���ÿ� ���� ItemID Ȯ�� �ʿ�
MineTable =
{
	MineMelee = { MobIndex = "MineMelee", ItemID = 59040, Skill = "MineMelee_W", Dist = 0, HitTime = 5, LifeTime = 7, Damage = 1500, Range = 100, AbstateType = "None",     },
	MineRange = { MobIndex = "MineRange", ItemID = 59041, Skill = "MineRange_W", Dist = 0, HitTime = 5, LifeTime = 7, Damage = 750, Range = 200, AbstateType = "None",     },
	MineIce   = { MobIndex = "MineIce"  , ItemID = 59042, Skill = "MineIce_W",   Dist = 0, HitTime = 5, LifeTime = 7, Damage =  50, Range = 200, AbstateType = "MineIce",  },
	MineStun  = { MobIndex = "MineStun" , ItemID = 59043, Skill = "MineStun_W",  Dist = 0, HitTime = 5, LifeTime = 7, Damage = 100, Range = 200, AbstateType = "MineStun", },
}
--[[*****																*****]]--
--[[*****						���� ������ ���� ������					*****]]--
--[[*************************************************************************]]--





--[[*************************************************************************]]--
--[[*****				��ũ��Ʈ �� ���� ���� ������					*****]]--
--[[*****																*****]]--
-- [���̾�α�]
-- Delay = ��������
DialogInfo =
{
	-- �����
	KDMine_Join =
	{
		{ Portrait = "RouDiggerPalmers", FileName = "KDMine", Index = "MineDigger_01",      Delay = 4 },
		{ Portrait = "RouDiggerPalmers", FileName = "KDMine", Index = "MineDigger_02",      Delay = 4 },
		{ Portrait = "RouDiggerPalmers", FileName = "KDMine", Index = "MineDigger_03",      Delay = 4 },
		{ Portrait = "RouDiggerPalmers", FileName = "KDMine", Index = "MineDigger_04",      Delay = 4 },
		{ Portrait = "RouDiggerPalmers", FileName = "KDMine", Index = "MineDigger_05",      Delay = 4 },
		{ Portrait = "RouDiggerPalmers", FileName = "KDMine", Index = "MineDigger_06",      Delay = 4 },
		{ Portrait = "MineSlime",        FileName = "KDMine", Index = "MineSlime_01",       Delay = 4 },
		{ Portrait = "MineHoneying",     FileName = "KDMine", Index = "MineHoneying_01",    Delay = 4 },
		{ Portrait = "MineSlime",        FileName = "KDMine", Index = "MineSlime_02",       Delay = 4 },
		{ Portrait = "MineHoneying",     FileName = "KDMine", Index = "MineHoneying_02",    Delay = 4 },
		{ Portrait = "RouDiggerPalmers", FileName = "KDMine", Index = "MineDigger_07",      Delay = 4 },
		{ Portrait = "MineSlime",        FileName = "KDMine", Index = "MineSlime_03",       Delay = 4 },

		-- �������� �ٽ� ���
		{ Portrait = "RouDiggerPalmers", FileName = "KDMine", Index = "MineDigger_05",      Delay = 4 },
		{ Portrait = "RouDiggerPalmers", FileName = "KDMine", Index = "MineDigger_08",      Delay = 4 },
	},

	-- �̼� ������
	KDMine_Success =
	{
		{ Portrait = "RouDiggerPalmers", FileName = "KDMine", Index = "MineDigger_Success", Delay = 4 },
	},

	-- �̼� ���н�
	KDMine_Fail =
	{
		{ Portrait = "MineHoneying",     FileName = "KDMine", Index = "MineHoneying_Fail",  Delay = 4 },
		{ Portrait = "RouDiggerPalmers", FileName = "KDMine", Index = "MineDigger_Fail",    Delay = 4 },
	},
}

-- [����]
-- WaitTime = �ĵ�����
NoticeInfo =
{
	KQReturn =
	{
		{ FileName = "KDMine", Index = "KQReturn30", WaitTime = 10, },
		{ FileName = "KDMine", Index = "KQReturn20", WaitTime = 10, },
		{ FileName = "KDMine", Index = "KQReturn10", WaitTime = 5, },
		{ FileName = "KDMine", Index = "KQReturn5",  WaitTime = 5, },
	}
}


-- [����]
AnnounceInfo =
{
	KDMine_Fence_Atk = "KDMine_Fence_Atk",   -- %s ������ ��å�� ���ݹް� �ֽ��ϴ�.
	KDMine_Fence_Dst = "KDMine_Fence_Dst",   -- %s ������ ��å�� �ı� �Ǿ����ϴ�.
	KDMine_Fence_Rep = "KDMine_Fence_Rep",   -- %s ������ ��å�� ���� �Ǿ����ϴ�.
	KDMine_Gate_Esc  = "KDMine_Gate_Esc",    -- ������ ������ �ⱸ�� ���͵��� Ż���ϰ� �ֽ��ϴ�.
	KDMine_Gate_Dst  = "KDMine_Gate_Dst",    -- ����� ���� ���͵��� Ż���Ͽ� �� ���� �Ͽ����ϴ�.
	-- �߰� ���� 2. ���̺� ������ ��, ���� ó�� �ʿ�
	KDMine_Wave_No   = "KDMine_Wave_No",    -- ���̺� ����
}
--[[*****																*****]]--
--[[*****				��ũ��Ʈ �� ���� ���� ������					*****]]--
--[[*************************************************************************]]--





--[[*************************************************************************]]--
--[[*****						���� �����̻� 							*****]]--
--[[*****																*****]]--
-- [����]
RewardAbstate =
{
	{ Index = "StaMineReward", KeepTime = (60 * 60 * 1000) },
}
--[[*****																*****]]--
--[[*****						���� �����̻� 							*****]]--
--[[*************************************************************************]]--
