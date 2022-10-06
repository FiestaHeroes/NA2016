require( "common" )



------------------------------------------------------------------------------------------------------
--
-- DATA
--
------------------------------------------------------------------------------------------------------
EVENT_INFO =								-- [�̺�Ʈ ����]
{
	MapIndex				= "E_Olympic",	-- �� �ε���
	QuestNPC				= "E_Ski_QuestNPC", -- ����Ʈ NPC
	NPCDirect				= 180,

	MaxRanking				= 20,			-- ��ŷ �ִ밪
	MaxPlayer				= 200,			-- �÷��̾� �ִ밪

	SeasonProcressSec		= 3000,			-- ���� ���� �ð�
	SeasonRestSec			= 600,			-- ���� ��� �ð�

	GameResultLogType		= 2026,			-- ��� ��� ���ӷα� Ÿ��
	SeasonbRewardLogType	= 2027,			-- ���� ���� ���ӷα� Ÿ��

	GameResultType =						-- ���� ��� Ÿ��
	{
		GRT_SeasonEnd		= 1,			-- ���� ����� ���� : ����
		GRT_StanbyTimeout	= 2,			-- ��� ���� ���� �ð��ȿ� ���� ���� : ����
		GRT_RunTimeout		= 3,			--   �� ���� ���� �ð��ȿ� ���� ���� : ����
		GRT_Goal			= 4,			-- ����
	},

	GoalNPCLink =							-- ������ NPC ��ũ ����
	{
		MapIndex = "E_Olympic",
		x		 = 5463,
		y		 = 22711,
	},

	TimerDeleteSec			= 20,			-- Ÿ�̸� ���� �ð�
}

GAME_INFO =												-- [���� ����]
{
	StanbyTimeout	= 60,								-- ���� �� ���� �ð�
	RunTimeout		= 300,								-- ��� �� ���� �ð�
	PointTimeout	= 60,								-- ����Ʈ ���� ���� �ð� ( ���� �ð� ���� ����Ʈ ���� )

	PointIncPerSec	= 2,								-- �ʴ� ���� ����Ʈ
	PointDecPerSec	= 2,								-- ��� ���� ����Ʈ

	StartLineArea	= "Area_Start",						-- ��� ���� �̸�
	GoalLineArea	= "Area_Finish",					-- �� ���� �̸�

	StartEffectMsg	= EFFECT_MSG_TYPE["EMT_START_OLYMPIC"],		-- ���� ����Ʈ �޽���
	GoalEffectMsg	= EFFECT_MSG_TYPE["EMT_GOAL_OLYMPIC"],		-- �� ����Ʈ �޽���
	FailEffectMsg	= EFFECT_MSG_TYPE["EMT_FAIL"],		-- ����(�ǰ�) ����Ʈ �޽���


	-- ĳ���� Ÿ��Ʋ ��ȣ��, ���� ������Ʈ�� ����ɼ� �ִ� �κ��Դϴ�.
	RankingReward =										-- ���� ����
	{
		{ TitleType = 117, ElementNo = 0 },				-- ��
		{ TitleType = 118, ElementNo = 0 },				-- ��
		{ TitleType = 119, ElementNo = 0 },				-- ��
	},

	GoalReward =
	{
		AbsIndex 	= "StaE_Ski_Reward",
		AbsStr 		= 1,
		AbsKeepTime = 3600000,
	},
}

MSG_INFO =												-- [�޽��� ����]
{
	GoalMsg_Point			= "E_Olympic_A01",			-- %s���� �� %sPoint�� �����Ͽ����ϴ�.
	GoalMsg_RankingFail1	= "E_Olympic_A02",			-- �ƽ�����, 20�� �ǿ� �Ի����� ���Ͽ����ϴ�.
	GoalMsg_RankingFail2	= "E_Olympic_A08",			-- ���� ����� ������ �� ���� ���� ������ ������� �ʽ��ϴ�.
	GoalMsg_RankingSuc		= "E_Olympic_A03",			-- ���ϵ帳�ϴ�. %d���� �Ի��ϼ̽��ϴ�.

	Season_Start			= "E_Olympic_A04",			-- ī�� ��Ű��ȸ ������ �����մϴ�.
	Season_End				= "E_Olympic_A05",			-- ī�� ��Ű��ȸ ������ �����մϴ�.
	Season_Ranking			= "E_Olympic_A06",			-- �̹� ���� 1���� %s��, 2���� %s��, 3���� %s�� �Դϴ�.
	Season_RankingEmpty		= "E_Olympic_A07",			-- �̹� ������ 1,2,3�� �����ڰ� �������� �ʽ��ϴ�.

	Error_SeasonEnd			= "E_Olympic_F01",			-- ������ ����Ǿ����ϴ�. ���� ���� �ٽ� ������ �ּ���.
	Error_SeasonRest		= "E_Olympic_F02",			-- ������ ���������Դϴ�. ���ο� ������ ���۵Ǹ� �ٽ� ������ �ּ���.
	Error_JoinPlayer		= "E_Olympic_F03",			-- �̹� ������ ��ܿ� ��ϵǼ̽��ϴ�. � ����� �ּ���.
	Error_StanbyTimeout		= "E_Olympic_F07",			--
	Error_RunTimeout		= "E_Olympic_F07",			-- ���ѽð����� Finish���ο� �������� ���ϼ̳׿�. �ƽ��Ե� �ǰ��Դϴ�.

	NPCChat	=											-- NPC ä��
	{
		{ Index = "E_Olympic_MC01", Interval = 20, },	-- ī�� ��Ű��ȸ ���� 1���� %s�� �Դϴ�.
		{ Index = "E_Olympic_MC02", Interval = 20, },	-- ������!! � 1���� ������ ������~
		{ Index = "E_Olympic_MC03", Interval = 20, },	-- ��~ �������~ ��Ű��ȸ�� �����Ͻð� Ǫ���� ��ǰ�� �޾ư�����~
	},

	Game_Guide =										-- ���� ��û �� ��µǴ� ���̵�
	{
		{ Index = "E_Olympic_F04", Interval = 10 },		-- ���ѽð� 5�оȿ� Finish���ο� �����ϼž� �մϴ�. ���ѽð��� �������ּ���.
		{ Index = "E_Olympic_F05", Interval = 10 },		-- Finish ������ ����� �ð��� �⹮���Ƚ���� ���������� �����մϴ�.
		{ Index = "E_Olympic_F06", Interval = 10 },		-- ��ֹ��� ���� �� ���ӽð� 2�� �ʰ��� �г�Ƽ�� ������ �������ּ���. �ִ��� ���� ���� �⹮�� ����Ͻô°��� �����մϴ�.
	},
}

FLAG_DOOR_INFO =	-- [�⹮]
{
	Type =			-- ��� ����
	{
		{ Index = "E_SkiFlag_Red",  Point = 50, AbsIndex = "StaE_Ski_SpeedUp", AbsStr = 1, AbsKeepTime = 3000, SkillIndex = "E_SkiFlag_Red_Skill01_N" },
		{ Index = "E_SkiFlag_Blue", Point = 25, AbsIndex = "StaE_Ski_SpeedUp", AbsStr = 1, AbsKeepTime = 3000, SkillIndex = "E_SkiFlag_Red_Skill01_N" },
		{ Index = "E_SkiFlag_Gold", Point = 10, AbsIndex = "StaE_Ski_SpeedUp", AbsStr = 1, AbsKeepTime = 3000, SkillIndex = "E_SkiFlag_Red_Skill01_N" },
	},

	Location =		-- ��ġ ����
	{
		{ { x =  3782, y = 21659 }, { x =  4082, y = 21659 }, { x =  3582, y = 21659 }, },	-- 1
		{ { x =  3604, y = 20531 }, { x =  3604, y = 20531 }, { x =  3604, y = 20531 }, },	-- 2
		{ { x =  4320, y = 19844 }, { x =  3920, y = 19844 }, { x =  4520, y = 19844 }, },	-- 3
		{ { x =  3591, y = 19028 }, { x =  3291, y = 19028 }, { x =  3791, y = 19028 }, },	-- 4
		{ { x =  4558, y = 18491 }, { x =  4708, y = 18491 }, { x =  4358, y = 18491 }, },	-- 5
		{ { x =  3829, y = 17885 }, { x =  3629, y = 17885 }, { x =  4000, y = 17885 }, },	-- 6
		{ { x =  4464, y = 17585 }, { x =  4264, y = 17585 }, { x =  4664, y = 17585 }, },	-- 7
		{ { x =  3864, y = 16568 }, { x =  3164, y = 16468 }, { x =  3664, y = 16368 }, },	-- 8
		{ { x =  3530, y = 15708 }, { x =  4730, y = 15708 }, { x =  4030, y = 15708 }, },	-- 9
		{ { x =  4322, y = 15240 }, { x =  4122, y = 15240 }, { x =  4522, y = 15240 }, },	-- 10

		{ { x =  3773, y = 14346 }, { x =  3973, y = 14346 }, { x =  4173, y = 14346 }, },	-- 11
		{ { x =  4164, y = 13314 }, { x =  3964, y = 13314 }, },							-- 12
		{ { x =  3704, y = 12899 }, { x =  4004, y = 12899 }, { x =  3505, y = 12899 }, },	-- 13
		{ { x =  3845, y = 12255 }, { x =  3545, y = 12255 }, { x =  3245, y = 12255 }, },	-- 14
		{ { x =  3139, y = 11496 }, { x =  3339, y = 11496 }, { x =  3539, y = 11496 }, },	-- 15
		{ { x =  3827, y = 10808 }, { x =  3527, y = 10808 }, { x =  3227, y = 10808 }, },	-- 16
		{ { x =  3287, y =  9869 }, { x =  3287, y = 9869  }, { x =  3287, y =  9869 }, },	-- 17
		{ { x =  3733, y =  9043 }, { x =  3433, y = 9043  }, { x =  3133, y =  9043 }, },	-- 18
		{ { x =  3397, y =  8387 }, { x =  2997, y = 8387  }, { x =  3697, y =  8387 }, },	-- 19
		{ { x =  4142, y =  7860 }, { x =  3742, y = 7860  }, { x =  4342, y =  7860 }, },	-- 20

		{ { x =  4049, y =  6588 }, { x =  4349, y =  6588 }, { x =  3849, y =  6588 }, },	-- 21
		{ { x =  5082, y =  5945 }, { x =  4482, y =  6045 }, { x =  4882, y =  5945 }, },	-- 22
		{ { x =  5119, y =  5023 }, { x =  5319, y =  5023 }, { x =  5519, y =  5023 }, },	-- 23
		{ { x =  6049, y =  4353 }, { x =  6349, y =  4353 }, { x =  5749, y =  4353 }, },	-- 24
		{ { x =  6826, y =  3842 }, { x =  6651, y =  4035 }, { x =  6670, y =  3628 }, },	-- 25
		{ { x =  7405, y =  3445 }, { x =  7583, y =  3621 }, { x =  7405, y =  3145 }, },	-- 26
		{ { x =  8078, y =  3749 }, { x =  8078, y =  3549 }, { x =  7878, y =  3749 }, },	-- 27
		{ { x =  8619, y =  3684 }, { x =  8619, y =  3884 }, { x =  8619, y =  4184 }, },	-- 28
		{ { x =  9417, y =  3928 }, { x =  9417, y =  4584 }, { x =  9619, y =  4384 }, },	-- 29
		{ { x = 10363, y =  4339 }, { x = 10172, y =  4487 }, { x = 10183, y =  4741 }, },	-- 30

		{ { x = 10928, y =  4593 }, { x = 10786, y =  4829 }, { x = 10599, y =  4992 }, },	-- 31
		{ { x = 11449, y =  5122 }, { x = 11449, y =  5422 }, { x = 11148, y =  5665 }, },	-- 32
		{ { x =  2894, y =  7960 }, { x =  2594, y =  7960 }, { x =  2194, y =  7960 }, },	-- 33
		{ { x =  2309, y =  7386 }, { x =  2099, y =  7276 }, { x =  1907, y =  7197 }, },	-- 34
		{ { x =  2007, y =  6727 }, { x =  1847, y =  6689 }, { x =  1745, y =  6509 }, },	-- 35
		{ { x =  1974, y =  6029 }, { x =  2094, y =  6106 }, { x =  1864, y =  5929 }, },	-- 36
		{ { x =  2238, y =  5317 }, { x =  2038, y =  5317 }, { x =  2438, y =  5317 }, },	-- 37
		{ { x =  2198, y =  4508 }, { x =  2333, y =  4553 }, { x =  2061, y =  4326 }, },	-- 38
		{ { x =  2500, y =  3923 }, { x =  2814, y =  3820 }, { x =  2563, y =  3261 }, },	-- 39
		{ { x =  3276, y =  2777 }, { x =  3518, y =  2810 }, { x =  3294, y =  2382 }, },	-- 40

		{ { x =  4215, y =  2400 }, { x =  4086, y =  2155 }, { x =  4360, y =  2518 }, },	-- 41
		{ { x =  4805, y =  1883 }, { x =  4988, y =  2126 }, { x =  5151, y =  2284 }, },	-- 42
		{ { x =  5817, y =  1694 }, { x =  5776, y =  1998 }, { x =  5996, y =  1532 }, },	-- 43
		{ { x =  6713, y =  1892 }, { x =  6922, y =  1876 }, { x =  6662, y =  2151 }, },	-- 44
		{ { x =  7233, y =  2166 }, { x =  7046, y =  2546 }, { x =  7630, y =  2240 }, },	-- 45
	}
}


-- ��ֹ� : ������
SNOWMAN_INFO =
{
	-- 1
	{ Index = "E_Ski_Snowman", Point = 5, x = 4002, y = 16760, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4002, y = 16760, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4002, y = 16760, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4002, y = 16760, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4002, y = 16760, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4002, y = 16760, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4002, y = 16760, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4002, y = 16760, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4002, y = 16760, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4002, y = 16760, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4002, y = 16760, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4002, y = 16760, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4002, y = 16760, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4002, y = 16760, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4002, y = 16760, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4002, y = 16760, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },


	-- 2
	{ Index = "E_Ski_Snowman", Point = 5, x = 4252, y = 14499, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4252, y = 14499, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4252, y = 14499, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4252, y = 14499, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4252, y = 14499, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4252, y = 14499, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4252, y = 14499, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4252, y = 14499, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4252, y = 14499, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4252, y = 14499, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4252, y = 14499, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4252, y = 14499, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4252, y = 14499, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4252, y = 14499, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4252, y = 14499, Range = 700, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },

	-- 3
	{ Index = "E_Ski_Snowman", Point = 5, x = 3352, y =  8311, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3352, y =  8311, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3352, y =  8311, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3352, y =  8311, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3352, y =  8311, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3352, y =  8311, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3352, y =  8311, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3352, y =  8311, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3352, y =  8311, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3352, y =  8311, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3352, y =  8311, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3352, y =  8311, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3352, y =  8311, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3352, y =  8311, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3352, y =  8311, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3352, y =  8311, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },

	-- 4
	{ Index = "E_Ski_Snowman", Point = 5, x = 7526, y =  3079, Range = 1000, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 7526, y =  3079, Range = 1000, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 7526, y =  3079, Range = 1000, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 7526, y =  3079, Range = 1000, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 7526, y =  3079, Range = 1000, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 7526, y =  3079, Range = 1000, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 7526, y =  3079, Range = 1000, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 7526, y =  3079, Range = 1000, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 7526, y =  3079, Range = 1000, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 7526, y =  3079, Range = 1000, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 7526, y =  3079, Range = 1000, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 7526, y =  3079, Range = 1000, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 7526, y =  3079, Range = 1000, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },

	-- 5
	{ Index = "E_Ski_Snowman", Point = 5, x = 4843, y =  5813, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4843, y =  5813, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4843, y =  5813, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4843, y =  5813, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4843, y =  5813, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4843, y =  5813, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4843, y =  5813, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4843, y =  5813, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4843, y =  5813, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4843, y =  5813, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4843, y =  5813, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 4843, y =  5813, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },

	-- 6
	{ Index = "E_Ski_Snowman", Point = 5, x = 3247, y =  2931, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3247, y =  2931, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3247, y =  2931, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3247, y =  2931, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3247, y =  2931, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3247, y =  2931, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3247, y =  2931, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3247, y =  2931, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3247, y =  2931, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3247, y =  2931, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3247, y =  2931, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 3247, y =  2931, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },

	-- 7
	{ Index = "E_Ski_Snowman", Point = 5, x = 10177, y =  4518, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 10177, y =  4518, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 10177, y =  4518, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 10177, y =  4518, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 10177, y =  4518, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 10177, y =  4518, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 10177, y =  4518, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 10177, y =  4518, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 10177, y =  4518, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 10177, y =  4518, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 10177, y =  4518, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 10177, y =  4518, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 10177, y =  4518, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },
	{ Index = "E_Ski_Snowman", Point = 5, x = 10177, y =  4518, Range = 500, LifeTime_Min = 1, LifeTime_Max = 3, RegenInterval = 1 },


}

-- ��ֹ� : �ϴ�
HONEYING_INFO =
{
	Index 				= "E_Ski_IDHoneying",
	MoveCheckInterval	= 0.1,
	GoalDistInterval	= 10,
	AbsIndex 			= "StaE_Ski_Stun",
	AbsStr 				= 1,
	AbsKeepTime 		= 3000,
	SkillIndex 			= "E_SkiFlag_Red_Skill01_N",

	-- 1
	{ Speed = 2000, { x = 1931, y =  4980 }, { x = 2502, y =  5738 } },
	{ Speed = 2000, { x = 1875, y =  5412 }, { x = 2406, y =  4954 } },

	-- 2
	{ Speed = 2000, { x = 4320, y =  2671 }, { x = 4150, y =  1846 } },
	{ Speed = 2000, { x = 4231, y =  1766 }, { x = 4516, y =  2530 } },

	-- 3
	{ Speed = 2000, { x = 9257, y =  4697 }, { x = 9075, y =  3774 } },
	{ Speed = 3000, { x = 9472, y =  4026 }, { x = 8728, y =  4510 } },

	-- 4
	{ Speed = 3000, { x = 4025, y =  6381 }, { x = 4494, y =  6500 }, { x = 4171, y =  6137 }, { x = 4416, y =  6870 } },

	-- 5
	{ Speed = 2000, { x = 3425, y = 12405 }, { x = 3924, y = 12177 } },
	{ Speed = 2000, { x = 3457, y = 12818 }, { x = 4161, y = 12742 } },

	-- 6
	{ Speed = 2000, { x = 3458,	y = 12773 }, { x = 3925, y = 12187 } },
	{ Speed = 2000, { x = 3388, y = 12428 }, { x = 4140, y = 12778 } },

	-- 7
	{ Speed = 2000, { x = 2897, y = 10075 }, { x = 4055, y = 10314 } },
	{ Speed = 2000, { x = 3036, y = 10831 }, { x = 3917, y = 10550 } },

	-- 8
	{ Speed = 2000, { x = 8418, y = 3376 }, { x = 8229, y = 4197 } },
	{ Speed = 2000, { x = 8099, y = 3970 }, { x = 8945, y = 3701 } },

	-- 9
	{ Speed = 3000, { x = 7994, y = 4004 }, { x = 4055, y = 3017 } },
	{ Speed = 3000, { x = 4055, y = 3017 }, { x = 7075, y = 3100 } },
	{ Speed = 3000, { x = 7075, y = 3100 }, { x = 8105, y = 2860 } },

	-- 10
	{ Speed = 2000, { x = 5084, y = 6205 }, { x = 4756, y = 5125 } },
	{ Speed = 2000, { x = 5474, y = 5833 }, { x = 4370, y = 5635 } },

	-- 11
	{ Speed = 2000, { x = 2296, y = 5815 }, { x = 1656, y = 5806 }, { x = 2057, y = 6336} },

	-- 12
	{ Speed = 2000, { x = 9825, y = 4692 }, { x = 10608, y = 4428 }, { x = 10670, y = 5122}, { x = 11437, y = 5053} , { x = 11168, y = 5751} , { x = 11838, y = 6131}, { x = 11263, y = 6616}  },

	-- 13
	{ Speed = 2000, { x = 9972, y = 4111 }, { x = 10056, y = 4748 }, { x = 10989, y = 4525}, { x = 10877, y = 5412} , { x = 11633, y = 5477} , { x = 11288, y = 5983}, { x = 11888, y = 6412}  },

	-- 14
	{ Speed = 2000, { x = 10852, y = 4508 }, { x = 10475, y = 4928 } },
	{ Speed = 2000, { x = 11471, y = 5153 }, { x = 10978, y = 5519 } },


}

-- �̵��ӵ� ���� ����
SLOW_AREA =
{
	{ AreaName = "SlowArea01", AbsIndex = "StaE_Ski_ICE", AbsStr = 1, AbsKeepTime = 1000 },
	{ AreaName = "SlowArea02", AbsIndex = "StaE_Ski_ICE", AbsStr = 1, AbsKeepTime = 1000 },
	{ AreaName = "SlowArea03", AbsIndex = "StaE_Ski_ICE", AbsStr = 1, AbsKeepTime = 1000 },
	{ AreaName = "SlowArea04", AbsIndex = "StaE_Ski_ICE", AbsStr = 1, AbsKeepTime = 1000 },
	{ AreaName = "SlowArea05", AbsIndex = "StaE_Ski_ICE", AbsStr = 1, AbsKeepTime = 1000 },
	{ AreaName = "SlowArea06", AbsIndex = "StaE_Ski_ICE", AbsStr = 1, AbsKeepTime = 1000 },
	{ AreaName = "SlowArea07", AbsIndex = "StaE_Ski_ICE", AbsStr = 1, AbsKeepTime = 1000 },
	{ AreaName = "SlowArea08", AbsIndex = "StaE_Ski_ICE", AbsStr = 1, AbsKeepTime = 1000 },
}

------------------------------------------------------------------------------------------------------
--
-- GLOBAL VARIABLES
--
------------------------------------------------------------------------------------------------------
gEventMain = nil			-- [�̺�Ʈ ����]
--{
--	NPCHandle		= 0,	-- NPC �ڵ�
--	FunctionCallSec	= 0,	-- �Լ� ȣ�� �ð�
--	Function		= 0,	-- �Լ�
--	ChatIndex		= 0,	-- ä�� �ε���
--	ChatSec			- 0,	-- ä�� �ð�
--}

gSeasonTime =				-- [���� �ð�]
{
	StartSec	= 0,		-- ���� �ð�
	EndSec		= 0,		-- ���� �ð�
}

gPlayerCnt	= 0						-- �÷��̾� ��
gPlayerList	= nil					-- [�÷��̾� ����Ʈ]
--{
--	{
--		CharNo				= 0,	-- ĳ���� ��ȣ
--		Handle				= 0,	-- �ڵ�
--		Score				= 0,	-- ����
--		RegistSec			= 0,	-- ���� �ð�
--		StartSec			= 0,	-- ��� �ð�
--		GuideIndex			= 0,	-- ���̵� �ε���
--		GuideSec			= 0,	-- ���̵� ��� �ð�
--		CheckFlagDoorList	= {}	-- ���� ȹ���� �⹮ ����Ʈ
--	}
--}

gRankingList		= nil	-- [���� ���� ��ŷ ����Ʈ]
gPreviousankingList	= nil	-- [���� ���� ��ŷ ����Ʈ]
--{
--	{
--		nRanking	= 0,	-- ����
--		nCharNo		= 0,	-- ĳ���� ��ȣ
--		sCharID		= "",	-- ĳ���� ID
--		nScore		= 0,	-- ����
--	}
--}

gFlagDoorIndexList	= nil						-- �⹮ �ε��� ����Ʈ
gFlagDoorList		= nil						-- [�⹮ ����Ʈ]
--{
--	{
--		Handle		= 0,						-- �ڵ�
--		TypeInfo	= FLAG_DOOR_INFO["Type"][1],-- �⹮ Ÿ�� ����
--	}
--}

gSnowManIndexList	= nil
gSnowManList		= nil
--{
--	{
--		Handle
--		RegenSec
--		LifeTime
--	}
--}

gHoneyingIndexList	= nil
gHoneyingList		= nil
--{
---	{
--		Handle
--		MoveInfo
--		MoveCheckSec
--		MoveIndex
--		MoveBack
--	}
--}



------------------------------------------------------------------------------------------------------
--
-- FUNCTION : CPP -> LUA
--
------------------------------------------------------------------------------------------------------
function DummyFunction()
end


function E_Ski_CongressNPC( Handle, MapIndex )
cExecCheck( "E_Ski_CongressNPC" )


	-- ���� �ð� ��������
	local nCurSec = cCurrentSecond()


	-- �̺�Ʈ �ʱ�ȭ
	if gEventMain == nil
	then
		-- �� Ȯ��
		if MapIndex ~= EVENT_INFO["MapIndex"]
		then
			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end


		-- ���� �ð� ��������
		local CurLocalTime = os.date( "*t", os.time() )

		-- ���� �ð��� ���� ���� ���� ���� ����
		gSeasonTime["StartSec"]	= nCurSec-- + ((60 - CurLocalTime["min"]) * 60) - CurLocalTime["sec"]	-- ó�� ���۽� ���� ������ �����ϵ��� ����
		gSeasonTime["EndSec"]	= nCurSec


		-- AISctipt Function ����
		cAIScriptFunc( Handle, "NPCClick", "WinterOlympic_Click" )
		cAIScriptFunc( Handle, "NPCMenu",  "WinterOlympic_Menu"  )


		-- EventNPC ����
		gEventMain = {}
		gEventMain["NPCHandle"]			= Handle
		gEventMain["FunctionCallSec"]	= nCurSec
		gEventMain["Function"]			= Season_Start
		gEventMain["ChatIndex"]			= 1
		gEventMain["ChatSec"]			= nCurSec


		-- ��Ÿ ���� ���� �ʱ�ȭ
		gPlayerCnt			= 0
		gPlayerList			= {}

		gRankingList		= {}
		gPreviousankingList	= {}

		gFlagDoorIndexList	= {}
		gFlagDoorList		= {}

		gSnowManIndexList	= {}
		gSnowManList		= {}

		gHoneyingIndexList	= {}
		gHoneyingList		= {}


		-- ���� ����
		cSetObjectDirect( Handle, EVENT_INFO["NPCDirect"] )


		-- QuestNPC
		local QuestHandle = cGetNPCHandle( EVENT_INFO["MapIndex"], EVENT_INFO["QuestNPC"] )
		if QuestHandle ~= nil
		then
			cAIScriptSet( QuestHandle, Handle )
			cAIScriptFunc( QuestHandle, "Entrance",  "DummyFunction" )
			cAIScriptFunc( QuestHandle, "NPCMenu",  "E_Ski_QuestNPC_Menu"  )
		end
	end


	-- �ڵ� Ȯ��
	if gEventMain["NPCHandle"] ~= Handle
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end


	-- ���� ������Ʈ��, ��ũ��Ʈ ���� �� �Լ� ����
	if cIsObjectDead( Handle ) == 1
	then
		cAIScriptSet( Handle )


		FlagDoor_Delete()
		SnowMan_Delete()
		Honeying_Delete()


		gEventMain			= nil
		gPlayerCnt			= 0
		gPlayerList			= nil

		gRankingList 		= nil
		gPreviousankingList	= nil


		cSetFieldScript( EVENT_INFO["MapIndex"] )


		return ReturnAI["END"]
	end


	-- NPC ä��
	if nCurSec >= gEventMain["ChatSec"]
	then
		local NPCChatInfo = MSG_INFO["NPCChat"][gEventMain["ChatIndex"]]

		if gEventMain["ChatIndex"] == 1
		then
			if gRankingList[1] ~= nil
			then
				cScriptMsg( EVENT_INFO["MapIndex"], gEventMain["NPCHandle"], NPCChatInfo["Index"], gRankingList[1]["sCharID"] )
			end
		else
			cScriptMsg( EVENT_INFO["MapIndex"], gEventMain["NPCHandle"], NPCChatInfo["Index"] )
		end

		gEventMain["ChatIndex"] = gEventMain["ChatIndex"] + 1
		gEventMain["ChatSec"]	= nCurSec + NPCChatInfo["Interval"]

		if gEventMain["ChatIndex"] > #MSG_INFO["NPCChat"]
		then
			gEventMain["ChatIndex"] = 1
		end
	end


	-- �̺�Ʈ ���� �Լ� ����
	if nCurSec >= gEventMain["FunctionCallSec"]
	then
		gEventMain["Function"]( nCurSec )
		gEventMain["FunctionCallSec"] = nCurSec + 0.1
	end


	return ReturnAI["END"]
end


function WinterOlympic_Click( NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "WinterOlympic_Click" )

	-- ���̾�α� �޴� ���
	cNPCMenuOpen( NPCHandle, PlyHandle )

end


function WinterOlympic_Menu( NPCHandle, PlyHandle, PlyCharNo, Value )
cExecCheck( "WinterOlympic_Menu" )


	-- ���� �ð� ��������
	local nCurSec = cCurrentSecond()


	-- ��ȸ ����
	if Value == 1
	then
		-- ���� ���� ������ Ȯ��
		if nCurSec >= gSeasonTime["EndSec"]
		then
			cScriptMsg( PlyHandle, nil, MSG_INFO["Error_SeasonRest"] )
			return
		end

		-- �����ϰ� �ִ� �÷��̾� �� Ȯ��
		if gPlayerCnt >= EVENT_INFO["MaxPlayer"]
		then
			return
		end

		-- �÷��̾� ������ �����ϴ��� Ȯ��
		if gPlayerList[PlyCharNo] ~= nil
		then
			cScriptMsg( PlyHandle, nil, MSG_INFO["Error_JoinPlayer"] )
			return
		end


		-- ���� �÷��̾� ���� �ʱ�ȭ
		gPlayerList[PlyCharNo] = {}
		gPlayerList[PlyCharNo]["CharNo"]			= PlyCharNo
		gPlayerList[PlyCharNo]["Handle"]			= PlyHandle
		gPlayerList[PlyCharNo]["Score"]				= 0
		gPlayerList[PlyCharNo]["RegistSec"]			= nCurSec
		gPlayerList[PlyCharNo]["StartSec"]			= 0
		gPlayerList[PlyCharNo]["GuideIndex"]		= 1
		gPlayerList[PlyCharNo]["GuideSec"]			= nCurSec
		gPlayerList[PlyCharNo]["CheckFlagDoorList"] = {}

		gPlayerCnt = gPlayerCnt + 1

	-- ���� ����
	elseif Value == 2
	then
		-- ��ŷ ����Ʈ UI ���
		cSendRankingList( PlyHandle, gPreviousankingList, gRankingList )
	end

end


function E_Ski_QuestNPC_Menu( NPCHandle, PlyHandle, PlyCharNo, Value )
cExecCheck( "E_Ski_QuestNPC_Menu" )


	-- ���� �ð� ��������
	local nCurSec = cCurrentSecond()

	if Value == 1
	then
		-- ��ŷ ����Ʈ UI ���
		cSendRankingList( PlyHandle, gPreviousankingList, gRankingList )
	elseif Value == 2
	then
		cLinkTo( PlyHandle, EVENT_INFO["GoalNPCLink"]["MapIndex"], EVENT_INFO["GoalNPCLink"]["x"], EVENT_INFO["GoalNPCLink"]["y"] )
	end

end


function FlagDoor_NPCAction( MapIndex, NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "FlagDoor_NPCAction" )


	-- �⹮ ���� ��������
	local nFlagInx = gFlagDoorIndexList[NPCHandle]
	if nFlagInx == nil
	then
		cAssertLog( "FlagDoor_NPCAction:gFlagDoorIndexList[NPCHandle] nil" );
		cNPCVanish( NPCHandle )
		return
	end

	if gFlagDoorList[nFlagInx] == nil
	then
		cAssertLog( "FlagDoor_NPCAction:gFlagDoorList[FlagInx] nil" );
		cNPCVanish( NPCHandle )
		return
	end

	local TypeInfo = gFlagDoorList[nFlagInx]["TypeInfo"]
	if TypeInfo == nil
	then
		cAssertLog( "FlagDoor_NPCAction:gFlagDoorList[nFlagInx][TypeInfo] nil" );
		cNPCVanish( NPCHandle )
		return
	end


	-- �÷��̾� ���� ��������
	local PlyInfo = gPlayerList[PlyCharNo]
	if PlyInfo == nil
	then
		-- cAssertLog( "FlagDoor_NPCAction:gPlayerList[PlyCharNo] nil" );
		return
	end


	-- ���� ���
	if PlyInfo["CheckFlagDoorList"][nFlagInx] == nil
	then
		PlyInfo["Score"]						= PlyInfo["Score"] + TypeInfo["Point"]
		PlyInfo["CheckFlagDoorList"][nFlagInx]	= true

		cSetAbstate( PlyHandle, TypeInfo["AbsIndex"], TypeInfo["AbsStr"], TypeInfo["AbsKeepTime"], NPCHandle )
		cSkillBlast( NPCHandle, PlyHandle, TypeInfo["SkillIndex"] )
	end
end


function SnowMan_NPCAction( MapIndex, NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "SnowMan_NPCAction" )


	local nCurSec = cCurrentSecond()


	-- �⹮ ���� ��������
	local nSnowManInx = gSnowManIndexList[NPCHandle]
	if nSnowManInx == nil
	then
		cAssertLog( "SnowMan_NPCAction:gSnowManIndexList[NPCHandle] nil" );
		cNPCVanish( NPCHandle )
		return
	end

	if gSnowManList[nSnowManInx] == nil
	then
		cAssertLog( "SnowMan_NPCAction:gSnowManList[nSnowManInx] nil" );
		cNPCVanish( NPCHandle )
		return
	end

	local SnowManInfo = SNOWMAN_INFO[nSnowManInx]
	if SnowManInfo == nil
	then
		cAssertLog( "SnowMan_NPCAction:SNOWMAN_INFO[nSnowManInx] nil" );
		cNPCVanish( NPCHandle )

		gSnowManList[nSnowManInx]		= nil
		gSnowManIndexList[NPCHandle]	= nil
		return
	end


	-- �÷��̾� ���� ��������
	local PlyInfo = gPlayerList[PlyCharNo]
	if PlyInfo == nil
	then
		-- cAssertLog( "SnowMan_NPCAction:gPlayerList[PlyCharNo] nil" );
		return
	end


	-- ���� ���
	PlyInfo["Score"] = PlyInfo["Score"] - SnowManInfo["Point"]


	-- SnowMan ���� / �ʱ�ȭ
	cNPCVanish( NPCHandle )

	gSnowManList[nSnowManInx]["Handle"]   = nil
	gSnowManList[nSnowManInx]["RegenSec"] = nCurSec + SnowManInfo["RegenInterval"]
	gSnowManList[nSnowManInx]["LifeTime"] = 0

	gSnowManIndexList[NPCHandle] = nil

end



function Honeying_Routine( Handle, MapIndex )
cExecCheck( "Honeying_Routine" )


	-- ���� �ð� ��������
	local nCurSec = cCurrentSecond()

	local nHoneyingInx = gHoneyingIndexList[Handle]
	if nHoneyingInx == nil
	then
		cAssertLog( "Honeying_Routine:gHoneyingIndexList[Handle] nil" );
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if gHoneyingList[nHoneyingInx] == nil
	then
		cAssertLog( "Honeying_Routine:gHoneyingList[nHoneyingInx] nil" );
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if gHoneyingList[nHoneyingInx]["MoveCheckSec"] > nCurSec
	then
		return ReturnAI["END"]
	end



	-- �ϴ� �̵� ����
	local MoveInfo		= gHoneyingList[nHoneyingInx]["MoveInfo"]
	local MoveInx		= gHoneyingList[nHoneyingInx]["MoveIndex"]
	local MaxMoveInx	= #gHoneyingList[nHoneyingInx]["MoveInfo"]
	local CurX, CurY	= cObjectLocate( Handle )

	if cDistanceSquar( CurX, CurY, MoveInfo[MoveInx]["x"], MoveInfo[MoveInx]["y"] ) < (HONEYING_INFO["GoalDistInterval"] * HONEYING_INFO["GoalDistInterval"])
	then
		if gHoneyingList[nHoneyingInx]["MoveBack"] == false
		then
			MoveInx = MoveInx + 1

			if MoveInx > MaxMoveInx
			then
				MoveInx 								= MaxMoveInx - 1
				gHoneyingList[nHoneyingInx]["MoveBack"]	= true
			end
		else
			MoveInx = MoveInx- 1

			if MoveInx < 1
			then
				MoveInx 								= 2
				gHoneyingList[nHoneyingInx]["MoveBack"]	= false
			end
		end
		cRunTo( Handle, MoveInfo[MoveInx]["x"], MoveInfo[MoveInx]["y"], MoveInfo["Speed"] )

		gHoneyingList[nHoneyingInx]["MoveIndex"] = MoveInx
	else
		if cGetMoveState( Handle ) == 0
		then
			cRunTo( Handle, MoveInfo[MoveInx]["x"], MoveInfo[MoveInx]["y"], MoveInfo["Speed"] )
		end
	end


	gHoneyingList[nHoneyingInx]["MoveCheckSec"] = gHoneyingList[nHoneyingInx]["MoveCheckSec"] + HONEYING_INFO["MoveCheckInterval"]
	return ReturnAI["END"]
end


function Honeying_NPCAction( MapIndex, NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "Honeying_NPCAction" )


	-- �⹮ ���� ��������
	local nHoneyingInx = gHoneyingIndexList[NPCHandle]
	if nHoneyingInx == nil
	then
		cAssertLog( "Honeying_NPCAction:gHoneyingIndexList[NPCHandle] nil" );
		cNPCVanish( NPCHandle )
		return
	end

	if gHoneyingList[nHoneyingInx] == nil
	then
		cAssertLog( "Honeying_NPCAction:gHoneyingList[nHoneyingInx] nil" );
		cNPCVanish( NPCHandle )
		return
	end


	-- �÷��̾� ���� ��������
	if gPlayerList[PlyCharNo] == nil
	then
		-- cAssertLog( "SnowMan_NPCAction:gPlayerList[PlyCharNo] nil" );
		return
	end

	cSetAbstate( PlyHandle, HONEYING_INFO["AbsIndex"], HONEYING_INFO["AbsStr"], HONEYING_INFO["AbsKeepTime"], NPCHandle )
	cSkillBlast( NPCHandle, NPCHandle, HONEYING_INFO["SkillIndex"] )

end


------------------------------------------------------------------------------------------------------
--
-- FUNCTION : LUA -> LUA
--
------------------------------------------------------------------------------------------------------
function Season_Start( nCurSec )
cExecCheck( "Season_Start" )


	-- �̺�Ʈ ���� �ð� Ȯ��
	if nCurSec < gSeasonTime["StartSec"]
	then
		return
	end


	-- �⹮ ����
	for i = 1, #FLAG_DOOR_INFO["Location"]
	do
		-- �����ϰ� �����ϱ� ����, �⹮ ����, ��ġ �� ��������
		local nTypeInx		= cRandomInt( 1, #FLAG_DOOR_INFO["Type"] )
		local nLocationInx	= cRandomInt( 1, #FLAG_DOOR_INFO["Location"][i] )

		-- ��ȯ�� �⹮ ����
		local TypeInfo		= FLAG_DOOR_INFO["Type"][nTypeInx]
		local LocationInfo	= FLAG_DOOR_INFO["Location"][i][nLocationInx]

		-- �⹮ ��ȯ
		local FlagHandle	= cMobRegen_XY( EVENT_INFO["MapIndex"], TypeInfo["Index"], LocationInfo["x"], LocationInfo["y"], 0 )

		if FlagHandle ~= nil
		then
			gFlagDoorList[i] = {}
			gFlagDoorList[i]["Handle"]		= FlagHandle
			gFlagDoorList[i]["TypeInfo"]	= TypeInfo

			gFlagDoorIndexList[FlagHandle]	= i

			cAIScriptSet( FlagHandle, gEventMain["NPCHandle"] )
			cAIScriptFunc( FlagHandle, "Entrance",  "DummyFunction" )
			cAIScriptFunc( FlagHandle, "NPCAction", "FlagDoor_NPCAction" )
		else
			cAssertLog( "FlagDoor regen fail : "..i.." X : "..LocationInfo["x"].." Y : "..LocationInfo["y"] )
		end
	end


	-- ���� ��ȯ
	for i = 1, #HONEYING_INFO
	do
		local HoneyingHandle = cMobRegen_XY( EVENT_INFO["MapIndex"], HONEYING_INFO["Index"], HONEYING_INFO[i][1]["x"], HONEYING_INFO[i][1]["y"], 0 )

		if HoneyingHandle ~= nil
		then
			gHoneyingList[i] = {}
			gHoneyingList[i]["Handle"] 			= HoneyingHandle
			gHoneyingList[i]["MoveInfo"]		= HONEYING_INFO[i]
			gHoneyingList[i]["MoveCheckSec"]	= nCurSec
			gHoneyingList[i]["MoveIndex"]		= 1
			gHoneyingList[i]["MoveBack"]		= false

			gHoneyingIndexList[HoneyingHandle] 	= i

			cAIScriptSet( HoneyingHandle, gEventMain["NPCHandle"] )
			cAIScriptFunc( HoneyingHandle, "Entrance",  "Honeying_Routine" )
			cAIScriptFunc( HoneyingHandle, "NPCAction",  "Honeying_NPCAction" )
		else
			cAssertLog( "Honeying regen fail : "..i.." X : "..HONEYING_INFO[i][1]["x"].." Y : "..HONEYING_INFO[i][1]["y"] )
		end
	end


	-- ��ŷ ���� ����
	gPreviousankingList = gRankingList
	gRankingList		= nil
	gRankingList		= {}


	-- ���� ������ �ð�
	gSeasonTime["EndSec"] = nCurSec + EVENT_INFO["SeasonProcressSec"]


	-- ���� ����
	cScriptMsg_World( nil, MSG_INFO["Season_Start"] )


	-- ���� �ܰ� �Լ� ����
	gEventMain["Function"] = Season_Doing

end


function Season_Doing( nCurSec )
cExecCheck( "Season_Doing" )


	-- �̺�Ʈ ���� �ð� Ȯ��
	if nCurSec >= gSeasonTime["EndSec"]
	then
		gEventMain["Function"] = Season_End
		return
	end


	-- ���� ���� �� Ȯ�� ����
	Player_Manager()
	SnowMan_Manager()

end


function Season_End( nCurSec )
cExecCheck( "Season_End" )


	-- ���� �������̴� �÷��̾� �ǰ� ó��, ����Ʈ �ʱ�ȭ
	for nPlyInx, PlyValue in pairs( gPlayerList )
	do
		cEffectMsg( PlyValue["Handle"], EFFECT_MSG_TYPE["EMT_FAIL"] )
		cScriptMsg( PlyValue["Handle"], MSG_INFO["Error_SeasonEnd"] )
		cTimerEnd( PlyValue["Handle"], EVENT_INFO["TimerDeleteSec"] )

		cSendGameLogDataType_4( EVENT_INFO["GameResultLogType"], PlyValue["CharNo"], "", 0, 0, EVENT_INFO["GameResultType"]["GRT_SeasonEnd"],
							   0, 0, PlyValue["Score"] )
	end

	gPlayerCnt	= 0
	gPlayerList = nil
	gPlayerList = {}


	-- 1, 2, 3 �� �̸�
	local TopPlayerNameList = {}

	-- ��ŷ ���� ó��
	for i = 1, #gRankingList
	do
		local nRanking		= gRankingList[i]["nRanking"]
		local RewardInfo	= GAME_INFO["RankingReward"][nRanking]

		if RewardInfo ~= nil
		then
			cAddCharacterTitle( gRankingList[i]["nCharNo"], RewardInfo["TitleType"], RewardInfo["ElementNo"] )
			cSendGameLogDataType_4( EVENT_INFO["SeasonbRewardLogType"], gRankingList[i]["nCharNo"], "", 0, 0, 0, nRanking, RewardInfo["TitleType"], RewardInfo["ElementNo"] )

			if TopPlayerNameList[nRanking] == nil
			then
				TopPlayerNameList[nRanking] = gRankingList[i]["sCharID"]
			end
		end
	end


	-- ������Ʈ ����
	FlagDoor_Delete()
	SnowMan_Delete()
	Honeying_Delete()



	-- ���� ����
	cScriptMsg_World( nil, MSG_INFO["Season_End"] )

	if #gRankingList > 0
	then
		for i = 1, 3
		do
			if TopPlayerNameList[i] == nil
			then
				TopPlayerNameList[i] = " "
			end
		end

		cScriptMsg_World( nil, MSG_INFO["Season_Ranking"], TopPlayerNameList[1], TopPlayerNameList[2], TopPlayerNameList[3] )
	else
		cScriptMsg_World( nil, MSG_INFO["Season_RankingEmpty"] )
	end


	-- ���� ���� ����
	gSeasonTime["StartSec"] = nCurSec + EVENT_INFO["SeasonRestSec"]


	-- ���� �ܰ� �Լ� ����
	gEventMain["Function"] = Season_Start

end


function Player_Manager()
cExecCheck( "Player_Manager" )


	-- �ȳ� ���̾�α� ����
	local GameGuideInfo = MSG_INFO["Game_Guide"]
	local nGameGuideCnt = #MSG_INFO["Game_Guide"]


	-- �������� �÷��̾� ó��
	for nPlyInx, PlyValue in pairs( gPlayerList )
	do

		-- �÷��̾ ã�� �� ������, ����Ʈ���� ����
		if cPlayerExist( PlyValue["Handle"] ) == nil
		then
			gPlayerList[nPlyInx] = nil
			gPlayerCnt = gPlayerCnt - 1

		else
			local nCurSec 		= cCurSec()
			local PlyMapIndex 	= cGetCurMapIndex( PlyValue["Handle"] )
			local PlyCharNo 	= cGetCharNo( PlyValue["Handle"] )


			-- �ʿ� ���ų� ĳ���� ��ȣ�� �ٸ���, ����Ʈ���� ����
			if PlyMapIndex ~= EVENT_INFO["MapIndex"] or
			   PlyCharNo ~= PlyValue["CharNo"]
			then
				gPlayerList[nPlyInx] = nil
				gPlayerCnt = gPlayerCnt - 1

			-- ��� ��
			elseif PlyValue["StartSec"] == 0
			then
				-- ���� �ð� �ѱ� �÷��̾� �ǰ� ó��
				if (nCurSec - PlyValue["RegistSec"]) >= GAME_INFO["StanbyTimeout"]
				then
					gPlayerList[nPlyInx] = nil
					gPlayerCnt = gPlayerCnt - 1

					cScriptMsg( PlyValue["Handle"], nil, MSG_INFO["Error_StanbyTimeout"] )
					cEffectMsg( PlyValue["Handle"], GAME_INFO["FailEffectMsg"] )
					cSendGameLogDataType_4( EVENT_INFO["GameResultLogType"], PlyValue["CharNo"], "", 0, 0, EVENT_INFO["GameResultType"]["GRT_StanbyTimeout"],
										   0, (nCurSec - PlyValue["RegistSec"]), PlyValue["Score"] )

				-- ���� �ð� ���� ���� �÷��̾�
				else
					-- StartLine �Ѿ����� Ȯ��
					if cIsInArea( PlyValue["Handle"], EVENT_INFO["MapIndex"], GAME_INFO["StartLineArea"] ) == true
					then
						PlyValue["StartSec"] = nCurSec

						cEffectMsg( PlyValue["Handle"], GAME_INFO["StartEffectMsg"] )
						cTimerStart( PlyValue["Handle"] )

					else
						-- ���� ���̵� ���
						if nCurSec >= PlyValue["GuideSec"] and PlyValue["GuideIndex"] <= nGameGuideCnt
						then
							local GameGuideMsg = GameGuideInfo[PlyValue["GuideIndex"]]
							cScriptMsg( PlyValue["Handle"], nil, GameGuideMsg["Index"] )

							PlyValue["GuideSec"]	= nCurSec + GameGuideMsg["Interval"]
							PlyValue["GuideIndex"]	= PlyValue["GuideIndex"] + 1
						end
					end
				end

			-- ��� ��
			else
				-- ���� �ð� �ѱ� �÷��̾� �ǰ� ó��
				if (nCurSec - PlyValue["StartSec"]) >= GAME_INFO["RunTimeout"]
				then
					gPlayerList[nPlyInx] = nil
					gPlayerCnt = gPlayerCnt - 1

					cEffectMsg( PlyValue["Handle"], GAME_INFO["FailEffectMsg"] )
					cScriptMsg( PlyValue["Handle"], nil, MSG_INFO["Error_RunTimeout"] )
					cTimerEnd( PlyValue["Handle"], EVENT_INFO["TimerDeleteSec"] )

					cSendGameLogDataType_4( EVENT_INFO["GameResultLogType"], PlyValue["CharNo"], "", 0, 0, EVENT_INFO["GameResultType"]["GRT_RunTimeout"],
										   0, (nCurSec - PlyValue["StartSec"]), PlyValue["Score"] )

				-- ���� �ð� ���� ���� �÷��̾�
				else

					-- �̵��ӵ� ���� ���� Ȯ��
					for i = 1, #SLOW_AREA
					do
						if cIsInArea( PlyValue["Handle"], EVENT_INFO["MapIndex"], SLOW_AREA[i]["AreaName"] ) == true
						then
							cSetAbstate( PlyValue["Handle"], SLOW_AREA[i]["AbsIndex"], SLOW_AREA[i]["AbsStr"], SLOW_AREA[i]["AbsKeepTime"], PlyValue["Handle"] )
						end
					end


					-- GoalLine �Ѿ����� Ȯ��
					if cIsInArea( PlyValue["Handle"], EVENT_INFO["MapIndex"], GAME_INFO["GoalLineArea"] ) == true
					then
						-- �������� �ɸ� �ð�
						local nRunSec		= (nCurSec - PlyValue["StartSec"])
						local TimeScore 	= 0

						-- �ð����� ���� ���
						if nRunSec < GAME_INFO["PointTimeout"]
						then
							TimeScore = ((GAME_INFO["PointTimeout"] - nRunSec) * GAME_INFO["PointIncPerSec"])
							TimeScore = ((TimeScore * TimeScore) * 4)

						elseif nRunSec > GAME_INFO["PointTimeout"]
						then
							TimeScore = ((GAME_INFO["PointTimeout"] - nRunSec) * GAME_INFO["PointIncPerSec"])
							TimeScore = (TimeScore * 20)
						end

						PlyValue["Score"] = PlyValue["Score"] + TimeScore
						if PlyValue["Score"] < 0
						then
							PlyValue["Score"] = 0
						end


						-- �߰��� ��ŷ ����
						local InsertRanking = {}
						InsertRanking["nRanking"]	= 0
						InsertRanking["nCharNo"]	= PlyValue["CharNo"]
						InsertRanking["sCharID"]	= cGetPlayerName( PlyValue["Handle"] )
						InsertRanking["nScore"]		= PlyValue["Score"]

						cScriptMsg( PlyValue["Handle"], nil, MSG_INFO["GoalMsg_Point"], InsertRanking["sCharID"], tostring(InsertRanking["nScore"]) )


						-- ��ŷ ����Ʈ�� �߰�
						local nRankingInx, nRankingScore = GetPlayerRankingScore( PlyValue["CharNo"], -1 )

						if nRankingScore < PlyValue["Score"]
						then
							-- ��ŷ ����Ʈ���� ���� ���� ����
							if nRankingInx ~= 0
							then
								PlayerRankingDelete( nRankingInx )
							end

							-- ��ŷ ����Ʈ�� ���� �߰�
							if PlayerRankingInsert( InsertRanking ) == true
							then
								cScriptMsg( PlyValue["Handle"], nil, MSG_INFO["GoalMsg_RankingSuc"], tostring(InsertRanking["nRanking"]) )
							else
								cScriptMsg( PlyValue["Handle"], nil, MSG_INFO["GoalMsg_RankingFail1"] )
							end
						else
							cScriptMsg( PlyValue["Handle"], nil, MSG_INFO["GoalMsg_RankingFail2"] )
						end


						-- �� ���� ����
						cSetAbstate( PlyValue["Handle"], GAME_INFO["GoalReward"]["AbsIndex"], GAME_INFO["GoalReward"]["AbsStr"], GAME_INFO["GoalReward"]["AbsKeepTime"], PlyValue["Handle"] )


						-- �÷��̾� ����Ʈ���� ����
						gPlayerList[nPlyInx] = nil
						gPlayerCnt = gPlayerCnt - 1

						cEffectMsg( PlyValue["Handle"], GAME_INFO["GoalEffectMsg"] )
						cTimerEnd( PlyValue["Handle"], EVENT_INFO["TimerDeleteSec"] )

						cSendGameLogDataType_4( EVENT_INFO["GameResultLogType"], InsertRanking["nCharNo"], "", 0, 0, EVENT_INFO["GameResultType"]["GRT_Goal"],
											   InsertRanking["nRanking"], nRunSec, InsertRanking["nScore"] )
					end
				end
			end
		end
	end

end


function SnowMan_Manager()
cExecCheck( "SnowMan_Manager" )


	for i = 1, #SNOWMAN_INFO
	do
		-- ���� �ð�(�� ����)
		local nCurSec 		= cCurrentSecond()
		local SnowManInfo	= SNOWMAN_INFO[i]


		-- �⺻ ���� ����
		if gSnowManList[i] == nil
		then
			gSnowManList[i] = {}
			gSnowManList[i]["Handle"]	= nil
			gSnowManList[i]["RegenSec"] = nCurSec + SnowManInfo["RegenInterval"]
			gSnowManList[i]["LifeTime"] = 0
		end


		-- SnowMan�� �׾��� ���
		if gSnowManList[i]["Handle"] ~= nil
		then
			if cIsObjectDead( gSnowManList[i]["Handle"] )
			then
				local SnowManHandle = gSnowManList[i]["Handle"]

				gSnowManList[i]["Handle"] 	= nil
				gSnowManList[i]["RegenSec"] = nCurSec + SnowManInfo["RegenInterval"]
				gSnowManList[i]["LifeTime"] = 0

				gSnowManIndexList[SnowManHandle] = nil
			end
		end


		-- ���� �ð��� ������ ����
		if gSnowManList[i]["LifeTime"] ~= 0 and
		   gSnowManList[i]["LifeTime"] <= nCurSec
		then
			local SnowManHandle = gSnowManList[i]["Handle"]

			cNPCVanish( SnowManHandle )

			gSnowManList[i]["Handle"] 	= nil
			gSnowManList[i]["RegenSec"] = nCurSec + SnowManInfo["RegenInterval"]
			gSnowManList[i]["LifeTime"] = 0

			gSnowManIndexList[SnowManHandle]	= nil
		end


		-- SnowMan ����
		if gSnowManList[i]["RegenSec"] ~= 0 and
		   gSnowManList[i]["RegenSec"] <= nCurSec
		then
			local SnowManHandle = cMobRegen_Circle( EVENT_INFO["MapIndex"], SnowManInfo["Index"], SnowManInfo["x"], SnowManInfo["y"], SnowManInfo["Range"] )

			if SnowManHandle ~= nil
			then
				gSnowManList[i]["Handle"]	= SnowManHandle
				gSnowManList[i]["LifeTime"]	= nCurSec + cRandomInt( SnowManInfo["LifeTime_Min"], SnowManInfo["LifeTime_Max"] )
				gSnowManList[i]["RegenSec"]	= 0

				gSnowManIndexList[gSnowManList[i]["Handle"]] = i

				cAIScriptSet( gSnowManList[i]["Handle"], gEventMain["NPCHandle"] )
				cAIScriptFunc( gSnowManList[i]["Handle"], "Entrance",  "DummyFunction" )
				cAIScriptFunc( gSnowManList[i]["Handle"], "NPCAction", "SnowMan_NPCAction" )
			end
		end
	end
end


function FlagDoor_Delete()
cExecCheck( "FlagDoor_Delete" )


	for i = 1, #FLAG_DOOR_INFO["Location"]
	do
		if gFlagDoorList[i] ~= nil
		then
			if gFlagDoorList[i]["Handle"] ~= nil
			then
				cNPCVanish( gFlagDoorList[i]["Handle"] )
			end
		end
	end

	gFlagDoorList 		= nil
	gFlagDoorIndexList 	= nil
	gFlagDoorList 		= {}
	gFlagDoorIndexList	= {}

end


function SnowMan_Delete()
cExecCheck( "SnowMan_Delete" )


	for i = 1, #SNOWMAN_INFO
	do
		if gSnowManList[i] ~= nil
		then
			if gSnowManList[i]["Handle"] ~= nil
			then
				cNPCVanish( gSnowManList[i]["Handle"] )
			end
		end
	end

	gSnowManList 		= nil
	gSnowManIndexList	= nil
	gSnowManList 		= {}
	gSnowManIndexList	= {}

end


function Honeying_Delete()
cExecCheck( "Honeying_Delete" )


	for i = 1, #HONEYING_INFO
	do
		if gHoneyingList[i] ~= nil
		then
			if gHoneyingList[i]["Handle"] ~= nil
			then
				cNPCVanish( gHoneyingList[i]["Handle"] )
			end
		end
	end

	gHoneyingList		= nil
	gHoneyingIndexList	= nil
	gHoneyingList		= {}
	gHoneyingIndexList	= {}

end

------------------------------------------------------------
-- GetPlayerRankingScore( CharNo, DefaultValue )
-- gRankingList �� �ִ� �÷��̾� �ε���(nIndex), ����(nScore) ��ȯ
-- �÷��̾ ���� ��쿡�� DefaultValue ���� ��ȯ
------------------------------------------------------------
function GetPlayerRankingScore( CharNo, DefaultValue )
cExecCheck( "GetPlayerRankingScore" )


	local nScore = DefaultValue
	local nIndex = 0

	for i = 1, #gRankingList
	do
		if gRankingList[i]["nCharNo"] == CharNo
		then
			nScore = gRankingList[i]["nScore"]
			nIndex = i
			break
		end
	end

	return nIndex, nScore
end


------------------------------------------------------------
-- PlayerRankingDelete( nIndex )
-- gRankingList �� �ִ� �÷��̾� ����
------------------------------------------------------------
function PlayerRankingDelete( nIndex )
cExecCheck( "PlayerRankingDelete" )


	if nIndex == nil
	then
		return
	end

	if nIndex > #gRankingList
	then
		return
	end


	local bSameRanking = false

	-- gRankingList �� ���� Ranking �� �ִ��� Ȯ��
	for i = 1, #gRankingList
	do
		if i ~= nIndex
		then
			if gRankingList[i]["nRanking"] == gRankingList[nIndex]["nRanking"]
			then
				bSameRanking = true
				break
			end
		end
	end


	-- gRankingList ���� ����
	if nIndex == #gRankingList
	then
		gRankingList[nIndex] = nil
	else
		for i = (nIndex + 1), #gRankingList
		do
			if bSameRanking == false
			then
				gRankingList[i]["nRanking"] = gRankingList[i]["nRanking"] - 1
			end

			gRankingList[i - 1]	= gRankingList[i]
		end

		gRankingList[#gRankingList] = nil
	end
end


------------------------------------------------------------
-- PlayerRankingInsert( RankingInfo )
-- gRankingList �� �÷��̾� �߰�
-- ��ȯ��
--		true	: �÷��̾� �߰� ����
--		false	: �÷��̾� �߰� ����
------------------------------------------------------------
function PlayerRankingInsert( RankingInfo )
cExecCheck( "PlayerRankingInsert" )


	local nInsertInx 	= 1
	local nRankingCnt	= #gRankingList
	local nRankingPlus	= 1

	RankingInfo["nRanking"] = 0


	-- gRankingList ���� �߰��� ��ġ ã��
	for i = 1, nRankingCnt
	do
		-- �߰��� ������ ������ ������, �� ��ġ�� RankingInfo �߰�
		if gRankingList[i]["nScore"] < RankingInfo["nScore"]
		then
			-- ��ŷ ������ �ȵ�������, ��ŷ ����
			if RankingInfo["nRanking"] == 0
			then
				RankingInfo["nRanking"] = gRankingList[i]["nRanking"]
			end

			nInsertInx = i
			break
		end

		-- ���� ������ ������ �ִ� �÷��̾ ������, ���� ��ŷ���� �����Ѵ�.
		if gRankingList[i]["nScore"] == RankingInfo["nScore"]
		then
			RankingInfo["nRanking"] = gRankingList[i]["nRanking"]
			nRankingPlus	= 0
		end

		nInsertInx = i + 1
	end


	-- nInsertInx Ȯ��
	if nInsertInx > EVENT_INFO["MaxRanking"]
	then
		-- �÷��̾� ���� �߰� ����
		return false
	end


	-- �߰��� ��ġ���� ���� ��ŷ �ϳ��� �̷��
	if nRankingCnt == nInsertInx
	then
		if nInsertInx < EVENT_INFO["MaxRanking"]
		then
			gRankingList[nInsertInx]["nRanking"]	= gRankingList[nInsertInx]["nRanking"] + nRankingPlus
			gRankingList[nInsertInx + 1]			= gRankingList[nInsertInx]
		end
	elseif nRankingCnt > nInsertInx
	then
		for i = nRankingCnt, nInsertInx, -1
		do
			if (i + 1) <= EVENT_INFO["MaxRanking"]
			then
				gRankingList[i]["nRanking"] = gRankingList[i]["nRanking"] + nRankingPlus
				gRankingList[i + 1]			= gRankingList[i]
			end
		end
	end



	-- ���� ������ �ȵ� ���� ���. ó������ �÷��̾ �߰��Ǵ� ���
	if RankingInfo["nRanking"] == 0
	then
		if nRankingCnt == 0
		then
			RankingInfo["nRanking"]	= 1
		else
			RankingInfo["nRanking"] = gRankingList[nInsertInx - 1]["nRanking"] + 1
		end
	end


	-- �÷��̾� ���� �߰�
	gRankingList[nInsertInx] = RankingInfo
	return true
end
