------------------------------------------------------------------------------------------
--                                ŷ�� ����Ʈ ������                                    --
------------------------------------------------------------------------------------------

KQ_SCRIPT_NAME			= "KQ/KDSpring/KDSpring"		-- ��ũ��Ʈ �̸�
KQ_MAX_PLAYER			= 10							-- �ִ� ���� �ο� ( ������ ���� KQ_PLAYER_MAX �� ä���� ���, ��� �ð� ���� �ٷ� �������� �Ѿ��. )
KQ_PLAYER_PICK_DELAY	= 2								-- �÷��̾ �ʿ� ���������� ���� �ð� ���� ����� ȹ�� �� �� ������ �����̽ð� ����
KQ_INVALID_HANDLE		= -1							-- ��ȿ�������� �ڵ�

-- ŷ�� ����Ʈ�� ������ ���ư� ���� ����
KQ_RETURN_MAP =
{

	-- ���� ����
	KRM_INDEX	= 'Gate',
	KRM_X		= 1487,
	KRM_Y		= 1517,
}

-- �� �α��ν� �ɾ��� �����̻�
KQ_MAPLOGIN_ABSTATE =
{
	KMA_INDEX 		= "StaKQSpUpRateBuff",
	KMA_STR 		= 1,
	KMA_KEEPTIME 	= 1200000,
}

-- �ð� ���� �� ��� ���� �����̻�
KQ_STUN_ABSTATE =
{
	KSA_INDEX 		= "StaAdlFStun",
	KSA_STR 		= 1,
	KSA_KEEPTIME 	= 3500,
}


-- ���� Ÿ��
KQ_GAME_TYEP =
{
	KGT_NORMAL		= 1,						-- �Ϲ�
	KGT_EXTRATIME	= 2,						-- ������
}


-- ŷ�� ����Ʈ ���
KQ_RESULT =
{
			---------------------------------------------------------------------------------------------
			--  ŷ�� ���� �ε���,					�̸�� ID, 			����Ʈ �޽��� Ÿ��( common.lua �� ���ǵǾ� ���� )
			---------------------------------------------------------------------------------------------
	KR_WIN	= {	KRE_REWAED = "REW_KQ_SPRING_WIN",	KRE_EMOTICON = 14,	KRE_EFFECT_MSG = EFFECT_MSG_TYPE["EMT_WIN"] 	},
	KR_LOSE	= { KRE_REWAED = "REW_KQ_SPRING_LOSE",	KRE_EMOTICON = 10,	KRE_EFFECT_MSG = EFFECT_MSG_TYPE["EMT_LOSE"] 	},
	KR_DRAW	= { KRE_REWAED = "REW_KQ_SPRING_DRAW",	KRE_EMOTICON = 16,	KRE_EFFECT_MSG = EFFECT_MSG_TYPE["EMT_DRAW"]	},
}


-- ��
KQ_DOOR =
{
  ---------------------------------------------------------------------------------------------------------------------------
  --  �� �ε���,					���� �� �ε���,		��ǥ X,			��ǥ Y,			����,			ũ��
  ---------------------------------------------------------------------------------------------------------------------------
	{ KD_INDEX = "KQSpringDoor",	KD_BLOCK = "Door01",	KD_X = 1366,	KD_Y = 3264,	KD_DIR = 80,	KD_SCALE = 1000 },
	{ KD_INDEX = "KQSpringDoor",	KD_BLOCK = "Door02",	KD_X = 1471,	KD_Y = 2061,	KD_DIR = 85,	KD_SCALE = 1000 },
}


-- NPC
KQ_NPC = { "KQSpring_Rman", "KQSpring_Bman" }


-- ������ ����
KQ_ITEM_MOB =
{
  ----------------------------------------------------------------------------------------------
  --  �� �ε���,				��ǥ X,			��ǥ Y,			����,			���� ����(��)
  ----------------------------------------------------------------------------------------------
	{ KIM_INDEX = "SpUpShoes",	KIM_X = 1819,	KIM_Y = 3244,	KIM_DIR = 0,	KIM_REGEN_TICK = 60 },
	{ KIM_INDEX = "SpUpShoes",	KIM_X = 1898,	KIM_Y = 2238,	KIM_DIR = 0,	KIM_REGEN_TICK = 60 },
}


-- �� ������
KQ_MAX_TEAM_MEMBER			= (KQ_MAX_PLAYER / 2)	-- ���� �ִ� �ο�
KQ_TEAM_POINT_CHECK_DIST 	= 75					-- ���� ����Ʈ üũ �Ÿ�

KQ_TEAM_NO =									-- �� ��ȣ
{
	KTN_DEFAULT	= 0,
	KTN_RED		= 1,							-- ������
	KTN_BLUE	= 2,							-- �����
}

KQ_TEAM =
{
  -------------------------------------------------------------------------------------------------------------------------------------------
  --  �� ����Ʈ �� �ε���,			�� ����Ʈ ��ǥ X	�� ����Ʈ ��ǥ Y,	�� ������ ������ �ε���
  -------------------------------------------------------------------------------------------------------------------------------------------
	{ KT_POINT_INDEX = "RedPoint",	KT_POINT_X = 764,	KT_POINT_Y = 3542,	KT_UNIFORM = { "Menian_RedA", "Menian_RedP", "Menian_RedS" } },
	{ KT_POINT_INDEX = "BluePoint",	KT_POINT_X = 940,	KT_POINT_Y = 1798,	KT_UNIFORM = { "Menian_BlueA", "Menian_BlueP", "Menian_BlueS" } },
}


-- ��� ������
KQ_FLAG_ICON = "MobChrLocFlag"

KQ_FLAG =										-- ���
{
	KF_INDEX		= "FiestaFlag",				-- ��� �� �ε���
	KF_CHECK_DIST	= 10,						-- ��� üũ �Ÿ�
	KF_PICK_DELAY	= 2,						-- ��� ��ȯ �� Pick �� �� �ֱ���� �ð�(1�� �� ȹ�� ����)
}

KQ_FLAG_POINT =									-- ��� ����Ʈ
{
	KFP_INDEX 		= "FlagPoint",				-- ��� ����Ʈ �� �ε���
	KFP_CHECK_DIST	= 75,						-- ��� ����Ʈ üũ �Ÿ�
	KFP_X			= 3653,						-- ��ǥ X
	KFP_Y			= 2942,						-- ��ǥ Y
	KFP_DIR			= 0,						-- ����
	KFP_REGEN_TIME	= 5,						-- ���� �� ���� �ð�(5�� ��)
}

KQ_FLAG_ABSTATE =								-- ��� �����̻�
{
  -----------------------------------------------------------------------------------------------------------------------------
  --  �����̻� �ε���,					�����̻� ����,	�����̻� ���� �ð�(1/1000��)
  -----------------------------------------------------------------------------------------------------------------------------
	{ KFA_INDEX = "StaKQSpringSlow",	KFA_STR = 1, 	KFA_KEEPTIME = 1200000, },
	{ KFA_INDEX = "StaKQSpringArrow",	KFA_STR = 1, 	KFA_KEEPTIME = 1200000, },
}

KQ_FLAG_SCRIPT_MSG =							-- ��� ���� ��ũ��Ʈ �޽���
{
	KFSM_HAVE 		= "KQSpring_Have_Flag",
	KFSM_DROP 		= "KQSpring_Drop_Flag",
	KFSM_REGEN01 	= "KQSpring_FlagRegen01",
	KFSM_REGEN02 	= "KQSpring_FlagRegen02",
	KFSM_POINT_RED 	= "KQSpring_Point_Red",
	KFSM_POINT_BLUE = "KQSpring_Point_Blue",
}


-- ��ũ��Ʈ �޽���
KQ_MSG_TYPE =
{
	KMT_SHN = 1,
	KMT_TXT = 2,
}

KQ_MSG =
{
	KM_DIVIDE_TEAM =							-- �� ������
	{
	  -----------------------------------------------------------------------------------------------------------------------------
	  --  �޽��� Ÿ��,						���� �̸�,					�޽��� �ε���,						��� �ð�(��),	����
	  -----------------------------------------------------------------------------------------------------------------------------
		{ KM_TYPE = KQ_MSG_TYPE["KMT_SHN"],	KM_FILE_NAME = "",			KM_INDEX = "KQSpring_DivideTeam",	KM_TIME = 0,	KM_VAL = nil }
	},

	KM_START_WAIT =								-- ���� ���� ���
	{
		{ KM_TYPE = KQ_MSG_TYPE["KMT_SHN"],	KM_FILE_NAME = "",			KM_INDEX = "KQSpring_KQStart",		KM_TIME = 30,	KM_VAL = "30" },
		{ KM_TYPE = KQ_MSG_TYPE["KMT_SHN"],	KM_FILE_NAME = "",			KM_INDEX = "KQSpring_KQStart",		KM_TIME = 20,	KM_VAL = "10" },
	},

	KM_GAME_TIME =									-- ���� �ð� ����
	{
		{ KM_TYPE = KQ_MSG_TYPE["KMT_SHN"],	KM_FILE_NAME = "",			KM_INDEX = "KQSpring_Timeover",		KM_TIME = 0,	KM_VAL = nil },
	},

	KM_EXTRA_TIME_WAIT =						-- ������ ���
	{
		{ KM_TYPE = KQ_MSG_TYPE["KMT_SHN"],	KM_FILE_NAME = "",			KM_INDEX = "KQSpring_ExtraTime01",	KM_TIME = 0,	KM_VAL = nil  },
		{ KM_TYPE = KQ_MSG_TYPE["KMT_SHN"],	KM_FILE_NAME = "",			KM_INDEX = "KQSpring_ExtraTime02",	KM_TIME = 2,	KM_VAL = "3" },
	},

	KM_END =
	{
		{ KM_TYPE = KQ_MSG_TYPE["KMT_TXT"],	KM_FILE_NAME = "KDSpring",	KM_INDEX = "KQReturn30",			KM_TIME = 30,	KM_VAL = nil },
		{ KM_TYPE = KQ_MSG_TYPE["KMT_TXT"],	KM_FILE_NAME = "KDSpring",	KM_INDEX = "KQReturn20",			KM_TIME = 10,	KM_VAL = nil },
		{ KM_TYPE = KQ_MSG_TYPE["KMT_TXT"],	KM_FILE_NAME = "KDSpring",	KM_INDEX = "KQReturn10",			KM_TIME = 10,	KM_VAL = nil },
		{ KM_TYPE = KQ_MSG_TYPE["KMT_TXT"],	KM_FILE_NAME = "KDSpring",	KM_INDEX = "KQReturn5",				KM_TIME = 5,	KM_VAL = nil },
	},
}


-- ����
KQ_SOUND =
{
	KS_GETFLAG	= "KQSpringGetFlag",
	KS_GETPOINT	= "KQSpringGetPoint",
	KS_LOSEPOINT	= "KQSpringLosePoint",
}
