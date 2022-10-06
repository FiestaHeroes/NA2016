
---------------------------------------------
---------------------------------------------
--[[ 		Ʃ�丮�� �⺻ ������		 ]]--

SCRIPT_MAIN      	= "Tutorial/Tutorial"
STA_STUN 		 	= "StaAdlFStun"
STA_DAMAGESHIELD 	= "StaDmgShield"
STA_MAGEATKUP		= "StaRouTMageAtkUp"


FIRST_BATTLE_STEP_NO	= 10							-- ù ���� ���� ��ȣ
LAST_BATTLE_STEP_NO		= 18							-- ������ ���� ���� ��ȣ
MINI_HOUSE_STEP_NO		= (FIRST_BATTLE_STEP_NO + 1)	-- �̴��Ͽ콺 ���� ��ȣ
FREESTAT_INIT_STEP_NO	= 20							-- �������� �ʱ�ȭ ���� ��ȣ


LINK_DATA =
{
	MAP_INDEX 	= "RouN",
	REGEN_X 	= 6386,
	REGEN_Y 	= 6379
}

NPC_DATA =
{
	"RouT_Smith",
	"RouT_Soul",
	"RouT_Skill",
}

TUTORIAL_LEVEL_LIMIT = 6	-- ���� ������ Ȥ�� Ʃ�丮�� �����ϰ� �� ��쿡 �������� ���� �δ��� �̵��� �� �� ���� �ϱ� ����
---------------------------------------------
---------------------------------------------
--[[ 			���̾� ����  		     ]]--

TUTORIAL_LAYER_DATA=
{
	LAYER_TYPE 			= 1, -- Ʃ�丮�� ���̾�
	LAYER_NUMBER_TYPE	= 1, -- ĳ���� ��ȣ Ÿ��
}


---------------------------------------------
---------------------------------------------
--[[ 			ù��° ����  		     ]]--

TSD_STEP_DATA_1ST =
{
	GATE_INFO =
	{
		GATE_INDEX 		= "RouT_Gate",
		REGEN_POSITION 	= { X = 7363, Y = 7031, DIR = 161 },
	},

	MOB_INFO =
	{
		MOB_INDEX 		= "RouT_Slime",
		REGEN_POSITION 	=
		{
			{
				START_POS 	= { X = 7363, Y = 7031, DIR = 0 },
				GOAL_POS	= { X = 7388, Y = 7242 	},
			},
			{
				START_POS 	= { X = 7363, Y = 7031, DIR = 0 },
				GOAL_POS	= { X = 7311, Y = 7204 	},
			},
			{
				START_POS 	= { X = 7363, Y = 7031, DIR = 0 },
				GOAL_POS	= { X = 7209, Y = 7158 	},
			},
		}
	},

	CAMERA_INFO =
	{
		AngleXZ			= 0,
		AngleY 			= 30,
		Distance		= 700,
		AbstateTime		= 100000,
	}
}


---------------------------------------------
---------------------------------------------
--[[ 			�ι�° ����  		     ]]--

TSD_STEP_DATA_2ND =
{
	GATE_INFO =
	{
		GATE_INDEX 		= "RouT_Gate",
		REGEN_POSITION 	= { X = 4798, Y = 5717, DIR = 90 },
	},

	MOB_INFO =
	{
		MOB_INDEX 		= "RouT_Honeying",
		REGEN_POSITION 	=
		{
			{
				START_POS 	= { X = 4943, Y = 5591, DIR = 50 },
				GOAL_POS	= { X = 5000, Y = 5812 	},
			},
			{
				START_POS 	= { X = 5082, Y = 5704, DIR = 50 },
				GOAL_POS	= { X = 4998, Y = 5742},
			},
			{
				START_POS 	= { X = 5085, Y = 5845, DIR = 50 },
				GOAL_POS	= { X = 4995, Y = 5692 	},
			},
			{
				START_POS 	= { X = 5018, Y = 5786, DIR = 50 },
				GOAL_POS	= { X = 5048, Y = 5748 	},
			},
			{
				START_POS 	= { X = 5002, Y = 5618, DIR = 50 },
				GOAL_POS	= { X = 5061, Y = 5825 	},
			},
		}
	},

	CAMERA_INFO =
	{
		AngleXZ			= 270,
		AngleY 			= 30,
		Distance		= 700,
		AbstateTime		= 100000,
	}
}




