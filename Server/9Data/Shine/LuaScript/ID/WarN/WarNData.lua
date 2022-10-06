------------------------------------------------------------------------------
SCRIPT_MAIN        = "ID/WarN/WarN"	-- ��ũ��Ʈ
FM_STATE = {}						-- ���̸�, ��� ����
FM_STATE["Normal"] = 1
FM_STATE["Injury"] = 2
FM_STATE["Stop"]   = 3
STA_IMMORTAL       = "StaImmortal"	-- ���������̻�
MOB_CHK_DELAY      = 0.1			-- �� üũ ������(���� ��, ��� ���� üũ, ������)
TRAP_GOAL_INTERVAL = 10				-- ���� �Ÿ�
WARN_END_EVENT = {}						-- ���� ����� �̺�Ʈ ����
WARN_END_EVENT["Plus_Dir"]     = 180	-- CenterCoord�� dir + @ ( ���̸� ���� ���� )
WARN_END_EVENT["Dist"]         = 600	-- ������ �߽ɺ��� �Ÿ� ( ���̸� ���� ���� )
WARN_END_EVENT["Flw_Gap"]      = 150	-- ���̸�,��� ������ �̵� �� �߽����κ��� �Ÿ�
WARN_END_EVENT["Flw_Airi"]     = 60		-- ���̸� ȥ�� ������ �� ������ �̵�
WARN_END_EVENT["Interval"]     = 5		-- ��� ���� ����
WARN_END_EVENT["EventDist"]    = 10		-- ���̸� �̵� �Ϸ� üũ ���� �Ÿ�
WARN_END_EVENT["WaitAiriMove"] = 1		-- ���̸� �̵� �Ϸ� ���.
WARN_END_EVENT["GateDist"]     = 300	-- ������ ����Ʈ �Ÿ�
E_MOB_GRADE = {}						-- �� ��� ����, ����üũ ���
E_MOB_GRADE["Elite"] = 1
E_MOB_GRADE["Chief"] = 2
E_MOB_GRADE["Boss"]  = 3
MAP_MARK_CHK_DLY = 2					-- �ʸ�ŷ üũ ������ (��)
MAPMARK_TIME = {}						-- �ʸ�ŷ ���� �ð�(�и���)
MAPMARK_TIME["Guardian"]  = 1000
MAPMARK_TIME["Door"]      = 1000
MAPMARK_TIME["Ore"]       = 1000
MAPMARK_GROUP = {}						-- �ʸ�ŷ �׷� ����
MAPMARK_GROUP["Guardian"] = 100
MAPMARK_GROUP["Door"]     = 200
MAPMARK_GROUP["Ore"]      = 300
MAPMARK_ICON = {}						-- �ʸ�ŷ ������
MAPMARK_ICON["Guardian"]  = "Normal"
MAPMARK_ICON["Door"]      = "LinkTown"
MAPMARK_ICON["Ore"]       = "Mine"
MAPMARK_TIME["Door_C"]    = 99999999	-- �ʸ�ŷ ���� ����
MAPMARK_GROUP["Door_C"]   = 500
MAPMARK_ICON["Door_C"]    = "Gate"
CAMERAMOVE = {}							-- ī�޶� �̵� ó��
CAMERAMOVE["AngleY"]      = 20          -- ���ϰ���. (�¿찢�� ���� ����)
CAMERAMOVE["Dist"]        = 1500        -- �Ÿ�
CAMERAMOVE["MoveKeep"]    = 5           -- ī�޶��̵� ���� �ð�(��)
CAMERAMOVE["StaStun"]     = "StaAdlFStun" -- ī�޶� ������ �����̻�
CAMERAMOVE["StaTime"]     = 10000		-- �����̻� ���ӽð�
-------------------------------------------------------------------------------


WAIT_BOSSROOM = 20	-- ������ ��� 10��

--[�ⱸ����Ʈ]
-- RegenCoord = �δ� ����� �����Ǵ� ����Ʈ ��ǥ
-- LinkTo     = �̵� ��ġ
-- �δ� Ŭ���� �� ��ǥ�� ���� ���
GateData =
{
	Index      = "DT_ExitGate",

	RegenCoord = {                     x =  4059, y =   722, dir = -176, },
	LinkTo     = { Field = "EldFor01", x = 16015, y =  7803,             },
}

GateMenu =
{
	Title	= "Exit Gate",
	Yes		= "Exit",
	No		= "Cancel",
}


--[���̸��ູ]
-- ������ ���̸��� �ɾ��� ���� �ε����� �ð�(�и���)
AIRI_BLESSING = {}
AIRI_BLESSING["Index"]    = "StaAiriBuff"
AIRI_BLESSING["KeepTime"] = (10*60*1000)


--[���̸�]
-- x,y,dir �δ� ����� ���� ��ǥ
AiriData =
{
	MobIndex         = "DT_StancherAiri",	-- ���ε���(����� ����)

	x = 4091, y = 4060, dir = 180,			-- ������ǥ(����� ����)

	InjuryHPRate     = 100,					-- �λ���� HP ����(����� ����)
	InjuryAniIndex   = "Emotion_Injury1",	-- �λ� �ִϸ��̼�(����� ����)

	ResearchAniIndex = "ActionProduct",		-- ���� ���� �ִϸ��̼�
}

--[�����]
GuardianDataTable =
{
	{ MobIndex = "DT_StancherGuardian01", x = 4076, y = 4439, dir = 180, InjuryHPRate = 10, InjuryAniIndex = "Emotion_Injury1",  },
	{ MobIndex = "DT_StancherGuardian02", x = 3789, y = 3874, dir = 180, InjuryHPRate = 10, InjuryAniIndex = "Emotion_Injury1",  },
	{ MobIndex = "DT_StancherGuardian03", x = 4400, y = 3866, dir = 180, InjuryHPRate = 10, InjuryAniIndex = "Emotion_Injury1",  },
}


--[���ε���]
SpecialIndex =
{
	Ore    = "DT_RadionOre",	-- �� �� ���� ����
}

ElementMobIndexDataTable =
{
--[[ȭ��]]	Flame  = { Boss = "DT_FFocalor", Elite = "DT_FDevildom", Chief = "DT_FFocalor_C", Trap = "T_DT_S_FDHoneying", Door = "DT_FDoor", },
--[[�ñ�]]	Chill  = { Boss = "DT_IFocalor", Elite = "DT_IDevildom", Chief = "DT_IFocalor_C", Trap = "T_DT_S_IDHoneying", Door = "DT_IDoor", },
--[[��ǳ]]	Storm  = { Boss = "DT_SFocalor", Elite = "DT_SDevildom", Chief = "DT_SFocalor_C", Trap = "T_DT_S_SDHoneying", Door = "DT_NDoor", },
--[[����]]	Glance = { Boss = "DT_TFocalor", Elite = "DT_TDevildom", Chief = "DT_TFocalor_C", Trap = "T_DT_S_TDHoneying", Door = "DT_TDoor", },
}



--[������������]
-- ���� Trap �� �ε��� ����
-- SkillIndex �� ��ų�� Interval �ʰ������� �����
TrapDataTable =
{
	T_DT_S_FDHoneying = { SkillIndex = "DT_S_FDHoneying_Skill01_N", Interval = 0.1, },
	T_DT_S_IDHoneying = { SkillIndex = "DT_S_IDHoneying_Skill01_N", Interval = 0.1, },
	T_DT_S_SDHoneying = { SkillIndex = "DT_S_SDHoneying_Skill01_N", Interval = 0.1, },
	T_DT_S_TDHoneying = { SkillIndex = "DT_S_TDHoneying_Skill01_N", Interval = 0.1, },
}


--[����ǥ]
-- CenterCoord = Ore�� �Ӽ��� ��ȯ ��ġ
RoomCoordDataTable =
{
--[[ȭ��]]	Flame  = { CenterCoord = { x =  984, y =  975, dir = -132, }, Door = { x = 3122, y = 3104, dir = -132, Block = "WarN_F", scale = 1000}, },
--[[�ñ�]]	Chill  = { CenterCoord = { x = 1092, y = 7154, dir =  -46, }, Door = { x = 3202, y = 5020, dir =  -46, Block = "WarN_I", scale = 1000}, },
--[[��ǳ]]	Storm  = { CenterCoord = { x = 7129, y = 1108, dir =  132, }, Door = { x = 4935, y = 3308, dir =  134, Block = "WarN_N", scale = 1000}, },
--[[����]]	Glance = { CenterCoord = { x = 7154, y = 7136, dir =   45, }, Door = { x = 5005, y = 4990, dir =   45, Block = "WarN_T", scale = 1000}, },
}


--[[������ǥ]]
-- �Ǿ��� ��ǥ���� ����
-- �ʿ�� ��ǥ�� �߰�. ��ǥ ������� �̵�
TrapPatrolDataTable =
{
--[[ȭ��]]
	Flame =
	{
		{ { x = 2863, y = 3151, }, { x = 2877, y = 2538, }, },
		{ { x = 3182, y = 2843, }, { x = 2499, y = 2863, }, },
		{ { x = 2863, y = 3151, }, { x = 1881, y = 2211, }, },
		{ { x = 3182, y = 2843, }, { x = 2186, y = 1867, }, },
		{ { x = 2356, y = 2692, }, { x = 2676, y = 2347, }, },
		{ { x = 2355, y = 2381, }, { x = 2671, y = 2668, }, },
		{ { x = 2187, y = 2498, }, { x = 2205, y = 1897, }, },
		{ { x = 2543, y = 2185, }, { x = 1883, y = 2202, }, },
	},
--[[�ñ�]]
	Chill =
	{
		{ { x = 2975, y = 4952, }, { x = 2995, y = 5574, }, },
		{ { x = 3308, y = 5263, }, { x = 2677, y = 5243, }, },
		{ { x = 2975, y = 4952, }, { x = 1967, y = 5945, }, },
		{ { x = 3308, y = 5263, }, { x = 2321, y = 6248, }, },
		{ { x = 2763, y = 5484, }, { x = 2484, y = 5741, }, },
		{ { x = 2441, y = 5429, }, { x = 2798, y = 5763, }, },
		{ { x = 2650, y = 5940, }, { x = 1980, y = 5924, }, },
		{ { x = 2320, y = 6226, }, { x = 2296, y = 5568, }, },
	},
--[[��ǳ]]
	Storm =
	{
		{ { x = 5230, y = 3299, }, { x = 5204, y = 2647, }, },
		{ { x = 4934, y = 2958, }, { x = 5547, y = 2997, }, },
		{ { x = 5407, y = 2789, }, { x = 5700, y = 2501, }, },
		{ { x = 5384, y = 2493, }, { x = 5727, y = 2817, }, },
		{ { x = 5902, y = 2640, }, { x = 5876, y = 2013, }, },
		{ { x = 6226, y = 2329, }, { x = 5582, y = 2293, }, },
		{ { x = 5862, y = 1999, }, { x = 4906, y = 2953, }, },
		{ { x = 6233, y = 2325, }, { x = 5241, y = 3298, }, },
	},
--[[����]]
	Glance =
	{
		{ { x = 4944, y = 5251, }, { x = 5543, y = 5228, }, },
		{ { x = 4944, y = 5251, }, { x = 5906, y = 6246, }, },
		{ { x = 6221, y = 5886, }, { x = 5266, y = 4950, }, },
		{ { x = 5266, y = 4950, }, { x = 5223, y = 5534, }, },
		{ { x = 5436, y = 5437, }, { x = 5723, y = 5722, }, },
		{ { x = 5418, y = 5744, }, { x = 5754, y = 5407, }, },
		{ { x = 5590, y = 5923, }, { x = 6210, y = 5889, }, },
		{ { x = 5893, y = 6209, }, { x = 5937, y = 5586, }, },
	},
}


--[[������]]
-- ���� �� ��ŭ �� �̺�Ʈ �ݺ�
ElementRoom =
{
	{ ElementMobIndexData = "Flame",  RoomCoordData = "Flame",  TrapPatrolData = "Flame"  },
	{ ElementMobIndexData = "Chill",  RoomCoordData = "Chill",  TrapPatrolData = "Chill"  },
	{ ElementMobIndexData = "Storm",  RoomCoordData = "Storm",  TrapPatrolData = "Storm"  },
	{ ElementMobIndexData = "Glance", RoomCoordData = "Glance", TrapPatrolData = "Glance" },
}


--[[��]]
-- �Ϲݸ� ���� ��ǥ�׷�
NormalRegenTypeTable =
{
	Small =
	{
		{ MobIndex = "DT_Devildom", Num = 10, x = 4087, y = 4068, Range = 400, },
	},
	Medium =
	{
		{ MobIndex = "DT_Devildom", Num = 12, x = 4087, y = 4068, Range = 400, },
	},
	Large =
	{
		{ MobIndex = "DT_Devildom", Num = 14, x = 4087, y = 4068, Range = 400, },
	},
}

-- ����Ʈ�� ���� ��ǥ
-- �� ����� ����Ʈ �Ӽ��� �������� ����
EliteRegenTypeTable =
{
	Small =
	{
		{ x = 4359, y = 4077, dir = 180 },
		{ x = 3831, y = 4076, dir = 180 },
	},
	Medium =
	{
		{ x = 4359, y = 4077, dir = 180 },
		{ x = 3831, y = 4076, dir = 180 },
		{ x = 4082, y = 4338, dir = 180 },
	},
	Large =
	{
		{ x = 4087, y = 4068, dir = 180 },
		{ x = 4087, y = 4068, dir = 180 },
		{ x = 4082, y = 4338, dir = 180 },
		{ x = 4102, y = 3800, dir = 180 },
	},
}
-- 1������ ������� ����.
RegenGroupDataTable =
{
--[��]
	{ NormalRegenType = "Small",  EliteRegenType = "Small",  },
--[��]
	{ NormalRegenType = "Medium", EliteRegenType = "Medium", },
--[��]
	{ NormalRegenType = "Large",  EliteRegenType = "Large",  },
}


-- [������ȯ]
-- HPRate ��������
-- 8/16	ġ������ ����Ʈ���� ��ȯ�ϵ��� ����
--		ġ������ ��ȯ�� ������ ���� ��ȯ ��ŭ�� ��ȯ
BossSummonElite =
{
	{ HPRate = 300, EliteNum = 4, Range = 200 },
	{ HPRate = 600, EliteNum = 3, Range = 200 },
	{ HPRate = 900, EliteNum = 2, Range = 200 },
}


-- [���̾�α�]
-- Delay = ��������
DialogInfo =
{
	-- �����
	WarN_Join =
	{
		{ Facecut = "DT_StancherAiri", FileName = "WarN", Index = "Airi_01",      Delay = 5 },
		{ Facecut = "DT_StancherAiri", FileName = "WarN", Index = "Airi_02",      Delay = 5 },
	},

	-- ���̸� ���� ����
	Airi_Success =
	{
		{ Facecut = "DT_StancherAiri", FileName = "WarN", Index = "Airi_03_A",    Delay = 0 },
	},
	-- ���̸� ���� ����
	Airi_Fail =
	{
		{ Facecut = "DT_StancherAiri", FileName = "WarN", Index = "Airi_03_B",    Delay = 0 },
	},
	-- ���̸� ���� ���� ����
	Airi_End =
	{
		{ Facecut = "DT_StancherAiri", FileName = "WarN", Index = "Airi_04",      Delay = 5 },
		{ Facecut = "DT_StancherAiri", FileName = "WarN", Index = "Airi_05",      Delay = 5 },
	},

	-- ���̸� ��ȣ �̺�Ʈ
	Airi_Event =
	{
		{ Facecut = "DT_StancherAiri", FileName = "WarN", Index = "Airi_06",      Delay = 2 },
	},

	-- ������ ���� ��
	Airi_Boss =
	{
		{ Facecut = "DT_StancherAiri", FileName = "WarN", Index = "Airi_07",      Delay = 0 },
	},


	-- ���� Ŭ���� ����
	WarN_Clear_1 =
	{
		{ Facecut = "DT_StancherAiri", FileName = "WarN", Index = "Airi_08",      Delay = 0 },
		{ Facecut = "DT_StancherAiri", FileName = "WarN", Index = "Airi_09",      Delay = 5 },
	},
	WarN_Clear_2 =
	{
		{ Facecut = "DT_StancherAiri", FileName = "WarN", Index = "Airi_10",      Delay = 5 },
		{ Facecut = "DT_StancherAiri", FileName = "WarN", Index = "Airi_11",      Delay = 5 },
	},
}

-- [����]
-- WaitTime = �ĵ�����
NoticeInfo =
{
	-- �δ� ����
	WarN_Join =
	{
		{ FileName = "WarN", Index = "Notice_01",  WaitTime = 0, },
	},

	-- ���̸� ���� ����
	Airi_Success =
	{
		{ FileName = "WarN", Index = "Success_01", WaitTime = 0, },
	},

	-- ���̸� ���� ����
	Airi_Fail =
	{
		{ FileName = "WarN", Index = "Failure_01", WaitTime = 0, },
	},

	-- ���̸� ���� ���� ����(1ȸ)
	Airi_End =
	{
		{ FileName = "WarN", Index = "Notice_02",  WaitTime = 0, },
	},

	-- ������ ���� ��
	Airi_Boss =
	{
		{ FileName = "WarN", Index = "Notice_03",  WaitTime = 0, },
	},


	-- �δ� ����
	KQReturn =
	{
		{ FileName = "WarN", Index = "KQReturn30", WaitTime = 10, },
		{ FileName = "WarN", Index = "KQReturn20", WaitTime = 10, },
		{ FileName = "WarN", Index = "KQReturn10", WaitTime =  5, },
		{ FileName = "WarN", Index = "KQReturn5",  WaitTime =  5, },
	},
}
