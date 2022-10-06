-------------------------------------------------------------------------------
SCRIPT_MAIN				= "KQ/KDEgg/KDEgg"	-- 스크립트
ABSTATE_IMT_IDX			= "StaImmortal"		-- 무적 상태이상 인덱스
PATHTYPE_GAP   			= 100				-- 웨이브몹 이동좌표체크 여유거리
MM_G_WAVEMOB    		= 0					-- 맵마킹 그룹 구분, 웨이브몹 진행 표시
MM_G_GATE   		    = 1000				-- 맵마킹 그룹 구분, 게이트 위치 표시
MM_G_MAIN				= 1500				-- 맵마킹 그룹 구분, 달걀 위치
MAP_MARK_CHK_DLY		= 1
PATHTYPE_CHK_DLY		= 1
DEF_TYPE_CHK_DLY		= 1
CM_STUN_INDEX			= "StaAdlFStun"
CM_STUN_KEEP			= 30000
QUEST_SUCCESS			= 1
QUEST_FAIL				= 2
END_EFFECT_WAIT			= 3					-- 종료 이펙트 터지기 대기 시간
-------------------------------------------------------------------------------


--[[*************************************************************************]]--
--[[*****			플레이어 세팅 관련 및 흐름 관련 데이터				*****]]--
--[[*****																*****]]--
--STATIC_SPEED_RATE   = 2000		-- 이동속도
ABSTATE_SPEED_UP_INDEX	= "StaKQEggSpUp"
ABSTATE_SPEED_UP_KEEP	= 9999999
KD_JOIN_WAIT_TIME   = 32		-- 킹퀘 스크립트 시작 후 대기시간
KD_WAVE_WAIT_TIME   = 960		-- 웨이브 시작 후 종료 시간 초
KD_END_LINKTO = {}				-- 킹퀘 종료후 이동 위치
KD_END_LINKTO["Index"] = "Eld"
KD_END_LINKTO["x"] = 17214
KD_END_LINKTO["y"] = 13445
--[[*****																*****]]--
--[[*****					플레이어 세팅 관련 데이터					*****]]--
--[[*************************************************************************]]--


--[[*************************************************************************]]--
--[[*****						지뢰 아이템 관련 데이터					*****]]--
--[[*****																*****]]--
-- [상태이상]
-- 폭탄이 터질때 걸어줄 Abstate 인덱스를 추가.
-- KeepTime은 밀리초 단위
AbstateTypeTable =
{
	None            = nil,
	MineIce         = { Index = "StaMineIce",      keepTime =  6000, },
	MineStun        = { Index = "StaMineStun",     keepTime =  3000, },
}

-- [지뢰]
-- 로컬에 따라 ItemID 확인 필요
MineTable =
{
	MineMelee = { MobIndex = "Egg_Melee", ItemID = 62569, Skill = "EggMelee_W", Dist = 0, HitTime = 5, LifeTime = 7, Damage = 1500, Range = 100, AbstateType = "None",     },
	MineRange = { MobIndex = "Egg_Range", ItemID = 62570, Skill = "EggRange_W", Dist = 0, HitTime = 5, LifeTime = 7, Damage = 500, Range = 200, AbstateType = "None",     },
}
--[[*****																*****]]--
--[[*****						지뢰 아이템 관련 데이터					*****]]--
--[[*************************************************************************]]--


--[[*************************************************************************]]--
--[[*****						맵마킹 관련 데이터						*****]]--
--[[*****																*****]]--
-- [맵마킹타입]
MapMarkTypeTable =
{
	None          = nil,
	Normal        = { IconIndex = "MobNormal",      KeepTime =     3000, Order = 1, },
	Gate          = { IconIndex = "Gate",           KeepTime = 99999999, Order = 0, },
	LastGate      = { IconIndex = "Templer",        KeepTime = 99999999, Order = 0, },
}
--[[*****																*****]]--
--[[*****						맵마킹 관련 데이터						*****]]--
--[[*************************************************************************]]--


--[[*************************************************************************]]--
--[[*****					방어 오브젝트 관련 데이터					*****]]--
--[[*****																*****]]--
-- [메인오브젝트]
-- 파괴되면 미션 실패
MainDefenceObject =
{ Index = "Egg_GoldEgg", x = 11437, y = 13426, dir = 90, HP = 2000, DamageRange = 150, MapMarkType = "LastGate", }

Ani_Index =
{
	"Egg_GoldEgg_Stand",	-- 안씀
	"Egg_GoldEgg_Stand1",	-- 성공 끝
	"Egg_GoldEgg_Damage",	-- 안씀
	"Egg_GoldEgg_Die",		-- 안씀
	"Egg_GoldEgg_Stand1_chain",	-- 성공 시작
	"Egg_GoldEgg_Die_chain",	-- 실패 시작
}

CameraMove =
{ x = MainDefenceObject["x"], y = MainDefenceObject["y"], AngleXZ = 270, AngleY = 20, Dist = 800, }

-- [게이트]
-- 몹 리젠 위치에 아무 역할 없는 게이트
ObjectTable =
{
	{ Index = "Egg_Door", x = 15102, y = 15743, dir = 124, MapMarkType = "Gate", },
	{ Index = "Egg_Door", x = 16298, y = 13384, dir = 136, MapMarkType = "Gate", },
	{ Index = "Egg_Door", x = 14886, y = 11423, dir = 0, MapMarkType = "Gate", },
}

-- [상인NPC]
MerchantNPC = "Egg_Digger"
--[[*****																*****]]--
--[[*****					방어 오브젝트 관련 데이터					*****]]--
--[[*************************************************************************]]--


--[[*************************************************************************]]--
--[[*****						웨이브 관련 데이터						*****]]--
--[[*****																*****]]--
-- [몹][데이터][저항]
-- 기존 디펜스 테이블 그대로사용
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


-- [몹][데이터][기본]
-- 몹의 기본 능력치들.
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


-- [몹][몹챗]
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


-- [웨이브몹]
-- 웨이브에서 관리될 몹 정의
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


-- [웨이브][경로]
-- 웨이브몹들이 지나갈 경로 좌표
-- 각 경로의 첫번째 좌표를 리젠좌표로 사용
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


-- [웨이브 그룹]
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


-- *[웨이브]*
-- 실제 웨이브 정의
-- Num은 리젠을 하는 횟수, RegenInterval은 리젠하기전 딜레이, WaveStepInterval은 웨이브 시작 전 딜레이
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


-- [맵마킹]
-- 체크할 좌표 및 거리
-- 다른 테이블들과 연관성은 없음
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
--[[*****						웨이브 관련 데이터						*****]]--
--[[*************************************************************************]]--


--[[*************************************************************************]]--
--[[*****						보상 상태이상 							*****]]--
--[[*****																*****]]--
-- [보상]
RewardAbstate =
{
	{ Index = "StaKQEggReward", KeepTime = (60 * 60 * 1000) },
}
--[[*****																*****]]--
--[[*****						보상 상태이상 							*****]]--
--[[*************************************************************************]]--


--[[*************************************************************************]]--
--[[*****				스크립트 및 공지 관련 데이터					*****]]--
--[[*****																*****]]--
-- [다이얼로그]
-- Delay = 선딜레이
DialogInfo =
{
	-- 입장시
	Egg_Join =
	{
		{ Facecut = "EldCastleLordElderiss",	FileName = "KDEgg", Index = "EldLord_01",	Delay = 0 },
		{ Facecut = "EldKidWorze",				FileName = "KDEgg", Index = "Worze_01",		Delay = 3 },
		{ Facecut = "EldItemMctKenton",			FileName = "KDEgg", Index = "Kenton_01",	Delay = 3 },
		{ Facecut = "EldGaianBjurin",			FileName = "KDEgg", Index = "Maria_01",		Delay = 3 },
		{ Facecut = "RouDiggerPalmers",			FileName = "KDEgg", Index = "Palmers_01",	Delay = 3 },
	},

	-- 웨이브
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

	-- 성공
	Egg_Success =
	{
		{ Facecut = "Egg_Kebing",				FileName = "KDEgg", Index = "Kebing_03",	Delay = 4 },
		{ Facecut = "RouDiggerPalmers",			FileName = "KDEgg", Index = "Palmers_05",	Delay = 3 },
		{ Facecut = "RouDiggerPalmers",			FileName = "KDEgg", Index = "Palmers_06",	Delay = 3 },
		{ Facecut = "RouDiggerPalmers",			FileName = "KDEgg", Index = "Palmers_07",	Delay = 3 },
		{ Facecut = "EldItemMctKenton",			FileName = "KDEgg", Index = "Kenton_03",	Delay = 3 },
		{ Facecut = "EldItemMctKenton",			FileName = "KDEgg", Index = "Kenton_04",	Delay = 3 },
	},

	-- 실패
	Egg_Fail =
	{
		{ Facecut = "Honeyng",					FileName = "KDEgg", Index = "Honeyng_03",	Delay = 4 },
		{ Facecut = "RouDiggerPalmers",			FileName = "KDEgg", Index = "Palmers_08",	Delay = 3 },
		{ Facecut = "RouDiggerPalmers",			FileName = "KDEgg", Index = "Palmers_09",	Delay = 3 },
	},
}

-- [공지]
-- WaitTime = 후딜레이
NoticeInfo =
{
	-- 인던 종료
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
	KDEgg_MobRegen01	= "KDEgg_MobRegen01",	-- 웨이브 시작
	KDEgg_MobRegen02	= "KDEgg_MobRegen02",	-- 웨이브 시작 ( 마지막 )
	KDEgg_EggHp			= "KDEgg_EggHp",		-- 달걀 HP
	KDEgg_Success		= "KDEgg_Success",		-- 성공
	KDEgg_Fail			= "KDEgg_Fail",			-- 실패
}
--[[*****																*****]]--
--[[*****				스크립트 및 공지 관련 데이터					*****]]--
--[[*************************************************************************]]--


