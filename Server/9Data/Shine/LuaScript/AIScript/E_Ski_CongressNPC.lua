require( "common" )



------------------------------------------------------------------------------------------------------
--
-- DATA
--
------------------------------------------------------------------------------------------------------
EVENT_INFO =								-- [이벤트 정보]
{
	MapIndex				= "E_Olympic",	-- 맵 인덱스
	QuestNPC				= "E_Ski_QuestNPC", -- 퀘스트 NPC
	NPCDirect				= 180,

	MaxRanking				= 20,			-- 랭킹 최대값
	MaxPlayer				= 200,			-- 플레이어 최대값

	SeasonProcressSec		= 3000,			-- 시즌 진행 시간
	SeasonRestSec			= 600,			-- 시즌 대기 시간

	GameResultLogType		= 2026,			-- 경기 결과 게임로그 타입
	SeasonbRewardLogType	= 2027,			-- 시즌 보상 게임로그 타입

	GameResultType =						-- 게임 결과 타입
	{
		GRT_SeasonEnd		= 1,			-- 시즌 종료로 인한 : 실패
		GRT_StanbyTimeout	= 2,			-- 출발 선을 제한 시간안에 넘지 않음 : 실패
		GRT_RunTimeout		= 3,			--   골 선을 제한 시간안에 넘지 않음 : 실패
		GRT_Goal			= 4,			-- 성공
	},

	GoalNPCLink =							-- 골지점 NPC 링크 정보
	{
		MapIndex = "E_Olympic",
		x		 = 5463,
		y		 = 22711,
	},

	TimerDeleteSec			= 20,			-- 타이머 삭제 시간
}

GAME_INFO =												-- [게임 정보]
{
	StanbyTimeout	= 60,								-- 참가 후 제한 시간
	RunTimeout		= 300,								-- 출발 후 제한 시간
	PointTimeout	= 60,								-- 포인트 득점 제한 시간 ( 제한 시간 이후 포인트 감소 )

	PointIncPerSec	= 2,								-- 초당 증가 포인트
	PointDecPerSec	= 2,								-- 토당 감소 포인트

	StartLineArea	= "Area_Start",						-- 출발 영역 이름
	GoalLineArea	= "Area_Finish",					-- 골 역역 이름

	StartEffectMsg	= EFFECT_MSG_TYPE["EMT_START_OLYMPIC"],		-- 시작 이펙트 메시지
	GoalEffectMsg	= EFFECT_MSG_TYPE["EMT_GOAL_OLYMPIC"],		-- 골 이펙트 메시지
	FailEffectMsg	= EFFECT_MSG_TYPE["EMT_FAIL"],		-- 실패(실격) 이펙트 메시지


	-- 캐릭터 타이틀 번호로, 로컬 업데이트시 변경될수 있는 부분입니다.
	RankingReward =										-- 보상 정보
	{
		{ TitleType = 117, ElementNo = 0 },				-- 금
		{ TitleType = 118, ElementNo = 0 },				-- 은
		{ TitleType = 119, ElementNo = 0 },				-- 동
	},

	GoalReward =
	{
		AbsIndex 	= "StaE_Ski_Reward",
		AbsStr 		= 1,
		AbsKeepTime = 3600000,
	},
}

MSG_INFO =												-- [메시지 정보]
{
	GoalMsg_Point			= "E_Olympic_A01",			-- %s님은 총 %sPoint를 습득하였습니다.
	GoalMsg_RankingFail1	= "E_Olympic_A02",			-- 아쉽지만, 20위 권에 입상하지 못하였습니다.
	GoalMsg_RankingFail2	= "E_Olympic_A08",			-- 이전 기록의 점수가 더 높아 현재 점수를 기록하지 않습니다.
	GoalMsg_RankingSuc		= "E_Olympic_A03",			-- 축하드립니다. %d위에 입상하셨습니다.

	Season_Start			= "E_Olympic_A04",			-- 카할 스키대회 시즌을 시작합니다.
	Season_End				= "E_Olympic_A05",			-- 카할 스키대회 시즌을 종료합니다.
	Season_Ranking			= "E_Olympic_A06",			-- 이번 시즌 1위는 %s님, 2위는 %s님, 3위는 %s님 입니다.
	Season_RankingEmpty		= "E_Olympic_A07",			-- 이번 시즌은 1,2,3위 수상자가 존재하지 않습니다.

	Error_SeasonEnd			= "E_Olympic_F01",			-- 시즌이 종료되었습니다. 다음 시즌에 다시 도전해 주세요.
	Error_SeasonRest		= "E_Olympic_F02",			-- 지금은 오프시즌입니다. 새로운 시즌이 시작되면 다시 도전해 주세요.
	Error_JoinPlayer		= "E_Olympic_F03",			-- 이미 참가자 명단에 등록되셨습니다. 어서 출발해 주세요.
	Error_StanbyTimeout		= "E_Olympic_F07",			--
	Error_RunTimeout		= "E_Olympic_F07",			-- 제한시간내에 Finish라인에 도착하지 못하셨네요. 아쉽게도 실격입니다.

	NPCChat	=											-- NPC 채팅
	{
		{ Index = "E_Olympic_MC01", Interval = 20, },	-- 카할 스키대회 현재 1위는 %s님 입니다.
		{ Index = "E_Olympic_MC02", Interval = 20, },	-- 여러분!! 어서 1위에 도전해 보세요~
		{ Index = "E_Olympic_MC03", Interval = 20, },	-- 자~ 어서오세요~ 스키대회에 출전하시고 푸짐한 상품을 받아가세요~
	},

	Game_Guide =										-- 참가 신청 후 출력되는 가이드
	{
		{ Index = "E_Olympic_F04", Interval = 10 },		-- 제한시간 5분안에 Finish라인에 도착하셔야 합니다. 제한시간에 주의해주세요.
		{ Index = "E_Olympic_F05", Interval = 10 },		-- Finish 라인을 통과한 시간과 기문통과횟수로 종합점수를 산출합니다.
		{ Index = "E_Olympic_F06", Interval = 10 },		-- 장애물에 접촉 및 게임시간 2분 초과시 패널티가 있으니 주의해주세요. 최대한 빨리 많은 기문을 통과하시는것이 유리합니다.
	},
}

FLAG_DOOR_INFO =	-- [기문]
{
	Type =			-- 깃발 정보
	{
		{ Index = "E_SkiFlag_Red",  Point = 50, AbsIndex = "StaE_Ski_SpeedUp", AbsStr = 1, AbsKeepTime = 3000, SkillIndex = "E_SkiFlag_Red_Skill01_N" },
		{ Index = "E_SkiFlag_Blue", Point = 25, AbsIndex = "StaE_Ski_SpeedUp", AbsStr = 1, AbsKeepTime = 3000, SkillIndex = "E_SkiFlag_Red_Skill01_N" },
		{ Index = "E_SkiFlag_Gold", Point = 10, AbsIndex = "StaE_Ski_SpeedUp", AbsStr = 1, AbsKeepTime = 3000, SkillIndex = "E_SkiFlag_Red_Skill01_N" },
	},

	Location =		-- 위치 정보
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


-- 장애물 : 스노우맨
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

-- 장애물 : 하닝
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

-- 이동속도 감소 지역
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
gEventMain = nil			-- [이벤트 버퍼]
--{
--	NPCHandle		= 0,	-- NPC 핸들
--	FunctionCallSec	= 0,	-- 함수 호출 시간
--	Function		= 0,	-- 함수
--	ChatIndex		= 0,	-- 채팅 인덱스
--	ChatSec			- 0,	-- 채팅 시간
--}

gSeasonTime =				-- [시즌 시간]
{
	StartSec	= 0,		-- 시작 시간
	EndSec		= 0,		-- 종료 시간
}

gPlayerCnt	= 0						-- 플레이어 수
gPlayerList	= nil					-- [플레이어 리스트]
--{
--	{
--		CharNo				= 0,	-- 캐릭터 번호
--		Handle				= 0,	-- 핸들
--		Score				= 0,	-- 점수
--		RegistSec			= 0,	-- 참가 시간
--		StartSec			= 0,	-- 출발 시간
--		GuideIndex			= 0,	-- 가이드 인덱스
--		GuideSec			= 0,	-- 가이드 출력 시간
--		CheckFlagDoorList	= {}	-- 점수 획득한 기문 리스트
--	}
--}

gRankingList		= nil	-- [현재 시즌 랭킹 리스트]
gPreviousankingList	= nil	-- [이전 시즌 랭킹 리스트]
--{
--	{
--		nRanking	= 0,	-- 순위
--		nCharNo		= 0,	-- 캐릭터 번호
--		sCharID		= "",	-- 캐릭터 ID
--		nScore		= 0,	-- 점수
--	}
--}

gFlagDoorIndexList	= nil						-- 기문 인덱스 리스트
gFlagDoorList		= nil						-- [기문 리스트]
--{
--	{
--		Handle		= 0,						-- 핸들
--		TypeInfo	= FLAG_DOOR_INFO["Type"][1],-- 기문 타입 정보
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


	-- 서버 시간 가져오기
	local nCurSec = cCurrentSecond()


	-- 이벤트 초기화
	if gEventMain == nil
	then
		-- 맵 확인
		if MapIndex ~= EVENT_INFO["MapIndex"]
		then
			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end


		-- 로컬 시간 가져오기
		local CurLocalTime = os.date( "*t", os.time() )

		-- 로컬 시간에 따른 현재 시즌 상태 설정
		gSeasonTime["StartSec"]	= nCurSec-- + ((60 - CurLocalTime["min"]) * 60) - CurLocalTime["sec"]	-- 처음 시작시 다음 정각에 시작하도록 설정
		gSeasonTime["EndSec"]	= nCurSec


		-- AISctipt Function 설정
		cAIScriptFunc( Handle, "NPCClick", "WinterOlympic_Click" )
		cAIScriptFunc( Handle, "NPCMenu",  "WinterOlympic_Menu"  )


		-- EventNPC 설정
		gEventMain = {}
		gEventMain["NPCHandle"]			= Handle
		gEventMain["FunctionCallSec"]	= nCurSec
		gEventMain["Function"]			= Season_Start
		gEventMain["ChatIndex"]			= 1
		gEventMain["ChatSec"]			= nCurSec


		-- 기타 전역 변수 초기화
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


		-- 방향 설정
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


	-- 핸들 확인
	if gEventMain["NPCHandle"] ~= Handle
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end


	-- 죽은 오브젝트면, 스크립트 해제 후 함수 종료
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


	-- NPC 채팅
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


	-- 이벤트 진행 함수 실행
	if nCurSec >= gEventMain["FunctionCallSec"]
	then
		gEventMain["Function"]( nCurSec )
		gEventMain["FunctionCallSec"] = nCurSec + 0.1
	end


	return ReturnAI["END"]
end


function WinterOlympic_Click( NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "WinterOlympic_Click" )

	-- 다이얼로그 메뉴 출력
	cNPCMenuOpen( NPCHandle, PlyHandle )

end


function WinterOlympic_Menu( NPCHandle, PlyHandle, PlyCharNo, Value )
cExecCheck( "WinterOlympic_Menu" )


	-- 서버 시간 가져오기
	local nCurSec = cCurrentSecond()


	-- 대회 참가
	if Value == 1
	then
		-- 시즌 진행 중인지 확인
		if nCurSec >= gSeasonTime["EndSec"]
		then
			cScriptMsg( PlyHandle, nil, MSG_INFO["Error_SeasonRest"] )
			return
		end

		-- 참여하고 있는 플레이어 수 확인
		if gPlayerCnt >= EVENT_INFO["MaxPlayer"]
		then
			return
		end

		-- 플레이어 정보가 존재하는지 확인
		if gPlayerList[PlyCharNo] ~= nil
		then
			cScriptMsg( PlyHandle, nil, MSG_INFO["Error_JoinPlayer"] )
			return
		end


		-- 참여 플레이어 정보 초기화
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

	-- 순위 보기
	elseif Value == 2
	then
		-- 랭킹 리스트 UI 출력
		cSendRankingList( PlyHandle, gPreviousankingList, gRankingList )
	end

end


function E_Ski_QuestNPC_Menu( NPCHandle, PlyHandle, PlyCharNo, Value )
cExecCheck( "E_Ski_QuestNPC_Menu" )


	-- 서버 시간 가져오기
	local nCurSec = cCurrentSecond()

	if Value == 1
	then
		-- 랭킹 리스트 UI 출력
		cSendRankingList( PlyHandle, gPreviousankingList, gRankingList )
	elseif Value == 2
	then
		cLinkTo( PlyHandle, EVENT_INFO["GoalNPCLink"]["MapIndex"], EVENT_INFO["GoalNPCLink"]["x"], EVENT_INFO["GoalNPCLink"]["y"] )
	end

end


function FlagDoor_NPCAction( MapIndex, NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "FlagDoor_NPCAction" )


	-- 기문 정보 가져오기
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


	-- 플레이어 정보 가져오기
	local PlyInfo = gPlayerList[PlyCharNo]
	if PlyInfo == nil
	then
		-- cAssertLog( "FlagDoor_NPCAction:gPlayerList[PlyCharNo] nil" );
		return
	end


	-- 점수 계산
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


	-- 기문 정보 가져오기
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


	-- 플레이어 정보 가져오기
	local PlyInfo = gPlayerList[PlyCharNo]
	if PlyInfo == nil
	then
		-- cAssertLog( "SnowMan_NPCAction:gPlayerList[PlyCharNo] nil" );
		return
	end


	-- 점수 계산
	PlyInfo["Score"] = PlyInfo["Score"] - SnowManInfo["Point"]


	-- SnowMan 삭제 / 초기화
	cNPCVanish( NPCHandle )

	gSnowManList[nSnowManInx]["Handle"]   = nil
	gSnowManList[nSnowManInx]["RegenSec"] = nCurSec + SnowManInfo["RegenInterval"]
	gSnowManList[nSnowManInx]["LifeTime"] = 0

	gSnowManIndexList[NPCHandle] = nil

end



function Honeying_Routine( Handle, MapIndex )
cExecCheck( "Honeying_Routine" )


	-- 서버 시간 가져오기
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



	-- 하닝 이동 제어
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


	-- 기문 정보 가져오기
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


	-- 플레이어 정보 가져오기
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


	-- 이벤트 시작 시간 확인
	if nCurSec < gSeasonTime["StartSec"]
	then
		return
	end


	-- 기문 생성
	for i = 1, #FLAG_DOOR_INFO["Location"]
	do
		-- 랜덤하게 소한하기 위해, 기문 종류, 위치 값 가져오기
		local nTypeInx		= cRandomInt( 1, #FLAG_DOOR_INFO["Type"] )
		local nLocationInx	= cRandomInt( 1, #FLAG_DOOR_INFO["Location"][i] )

		-- 소환할 기문 정보
		local TypeInfo		= FLAG_DOOR_INFO["Type"][nTypeInx]
		local LocationInfo	= FLAG_DOOR_INFO["Location"][i][nLocationInx]

		-- 기문 소환
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


	-- 함정 소환
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


	-- 랭킹 정보 설정
	gPreviousankingList = gRankingList
	gRankingList		= nil
	gRankingList		= {}


	-- 시즌 끝나는 시간
	gSeasonTime["EndSec"] = nCurSec + EVENT_INFO["SeasonProcressSec"]


	-- 월드 공지
	cScriptMsg_World( nil, MSG_INFO["Season_Start"] )


	-- 다음 단계 함수 설정
	gEventMain["Function"] = Season_Doing

end


function Season_Doing( nCurSec )
cExecCheck( "Season_Doing" )


	-- 이벤트 시작 시간 확인
	if nCurSec >= gSeasonTime["EndSec"]
	then
		gEventMain["Function"] = Season_End
		return
	end


	-- 시즌 진행 중 확인 사항
	Player_Manager()
	SnowMan_Manager()

end


function Season_End( nCurSec )
cExecCheck( "Season_End" )


	-- 게임 참여중이던 플레이어 실격 처리, 리스트 초기화
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


	-- 1, 2, 3 등 이름
	local TopPlayerNameList = {}

	-- 랭킹 보상 처리
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


	-- 오브젝트 삭제
	FlagDoor_Delete()
	SnowMan_Delete()
	Honeying_Delete()



	-- 월드 공지
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


	-- 다음 시즌 설정
	gSeasonTime["StartSec"] = nCurSec + EVENT_INFO["SeasonRestSec"]


	-- 다음 단계 함수 설정
	gEventMain["Function"] = Season_Start

end


function Player_Manager()
cExecCheck( "Player_Manager" )


	-- 안내 다이얼로그 정보
	local GameGuideInfo = MSG_INFO["Game_Guide"]
	local nGameGuideCnt = #MSG_INFO["Game_Guide"]


	-- 참가중인 플레이어 처리
	for nPlyInx, PlyValue in pairs( gPlayerList )
	do

		-- 플레이어를 찾을 수 없으면, 리스트에서 삭제
		if cPlayerExist( PlyValue["Handle"] ) == nil
		then
			gPlayerList[nPlyInx] = nil
			gPlayerCnt = gPlayerCnt - 1

		else
			local nCurSec 		= cCurSec()
			local PlyMapIndex 	= cGetCurMapIndex( PlyValue["Handle"] )
			local PlyCharNo 	= cGetCharNo( PlyValue["Handle"] )


			-- 맵에 없거나 캐릭터 번호가 다르면, 리스트에서 삭제
			if PlyMapIndex ~= EVENT_INFO["MapIndex"] or
			   PlyCharNo ~= PlyValue["CharNo"]
			then
				gPlayerList[nPlyInx] = nil
				gPlayerCnt = gPlayerCnt - 1

			-- 출발 전
			elseif PlyValue["StartSec"] == 0
			then
				-- 제한 시간 넘긴 플레이어 실격 처리
				if (nCurSec - PlyValue["RegistSec"]) >= GAME_INFO["StanbyTimeout"]
				then
					gPlayerList[nPlyInx] = nil
					gPlayerCnt = gPlayerCnt - 1

					cScriptMsg( PlyValue["Handle"], nil, MSG_INFO["Error_StanbyTimeout"] )
					cEffectMsg( PlyValue["Handle"], GAME_INFO["FailEffectMsg"] )
					cSendGameLogDataType_4( EVENT_INFO["GameResultLogType"], PlyValue["CharNo"], "", 0, 0, EVENT_INFO["GameResultType"]["GRT_StanbyTimeout"],
										   0, (nCurSec - PlyValue["RegistSec"]), PlyValue["Score"] )

				-- 제한 시간 넘지 않은 플레이어
				else
					-- StartLine 넘었는지 확인
					if cIsInArea( PlyValue["Handle"], EVENT_INFO["MapIndex"], GAME_INFO["StartLineArea"] ) == true
					then
						PlyValue["StartSec"] = nCurSec

						cEffectMsg( PlyValue["Handle"], GAME_INFO["StartEffectMsg"] )
						cTimerStart( PlyValue["Handle"] )

					else
						-- 게임 가이드 출력
						if nCurSec >= PlyValue["GuideSec"] and PlyValue["GuideIndex"] <= nGameGuideCnt
						then
							local GameGuideMsg = GameGuideInfo[PlyValue["GuideIndex"]]
							cScriptMsg( PlyValue["Handle"], nil, GameGuideMsg["Index"] )

							PlyValue["GuideSec"]	= nCurSec + GameGuideMsg["Interval"]
							PlyValue["GuideIndex"]	= PlyValue["GuideIndex"] + 1
						end
					end
				end

			-- 출발 후
			else
				-- 제한 시간 넘긴 플레이어 실격 처리
				if (nCurSec - PlyValue["StartSec"]) >= GAME_INFO["RunTimeout"]
				then
					gPlayerList[nPlyInx] = nil
					gPlayerCnt = gPlayerCnt - 1

					cEffectMsg( PlyValue["Handle"], GAME_INFO["FailEffectMsg"] )
					cScriptMsg( PlyValue["Handle"], nil, MSG_INFO["Error_RunTimeout"] )
					cTimerEnd( PlyValue["Handle"], EVENT_INFO["TimerDeleteSec"] )

					cSendGameLogDataType_4( EVENT_INFO["GameResultLogType"], PlyValue["CharNo"], "", 0, 0, EVENT_INFO["GameResultType"]["GRT_RunTimeout"],
										   0, (nCurSec - PlyValue["StartSec"]), PlyValue["Score"] )

				-- 제한 시간 넘지 않은 플레이어
				else

					-- 이동속도 감소 지역 확인
					for i = 1, #SLOW_AREA
					do
						if cIsInArea( PlyValue["Handle"], EVENT_INFO["MapIndex"], SLOW_AREA[i]["AreaName"] ) == true
						then
							cSetAbstate( PlyValue["Handle"], SLOW_AREA[i]["AbsIndex"], SLOW_AREA[i]["AbsStr"], SLOW_AREA[i]["AbsKeepTime"], PlyValue["Handle"] )
						end
					end


					-- GoalLine 넘었는지 확인
					if cIsInArea( PlyValue["Handle"], EVENT_INFO["MapIndex"], GAME_INFO["GoalLineArea"] ) == true
					then
						-- 도착까지 걸린 시간
						local nRunSec		= (nCurSec - PlyValue["StartSec"])
						local TimeScore 	= 0

						-- 시간으로 점수 계산
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


						-- 추가할 랭킹 정보
						local InsertRanking = {}
						InsertRanking["nRanking"]	= 0
						InsertRanking["nCharNo"]	= PlyValue["CharNo"]
						InsertRanking["sCharID"]	= cGetPlayerName( PlyValue["Handle"] )
						InsertRanking["nScore"]		= PlyValue["Score"]

						cScriptMsg( PlyValue["Handle"], nil, MSG_INFO["GoalMsg_Point"], InsertRanking["sCharID"], tostring(InsertRanking["nScore"]) )


						-- 랭킹 리스트에 추가
						local nRankingInx, nRankingScore = GetPlayerRankingScore( PlyValue["CharNo"], -1 )

						if nRankingScore < PlyValue["Score"]
						then
							-- 랭킹 리스트에서 기존 정보 삭제
							if nRankingInx ~= 0
							then
								PlayerRankingDelete( nRankingInx )
							end

							-- 랭킹 리스트에 정보 추가
							if PlayerRankingInsert( InsertRanking ) == true
							then
								cScriptMsg( PlyValue["Handle"], nil, MSG_INFO["GoalMsg_RankingSuc"], tostring(InsertRanking["nRanking"]) )
							else
								cScriptMsg( PlyValue["Handle"], nil, MSG_INFO["GoalMsg_RankingFail1"] )
							end
						else
							cScriptMsg( PlyValue["Handle"], nil, MSG_INFO["GoalMsg_RankingFail2"] )
						end


						-- 골 보상 설정
						cSetAbstate( PlyValue["Handle"], GAME_INFO["GoalReward"]["AbsIndex"], GAME_INFO["GoalReward"]["AbsStr"], GAME_INFO["GoalReward"]["AbsKeepTime"], PlyValue["Handle"] )


						-- 플레이어 리스트에서 삭제
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
		-- 현재 시간(초 단위)
		local nCurSec 		= cCurrentSecond()
		local SnowManInfo	= SNOWMAN_INFO[i]


		-- 기본 정보 설정
		if gSnowManList[i] == nil
		then
			gSnowManList[i] = {}
			gSnowManList[i]["Handle"]	= nil
			gSnowManList[i]["RegenSec"] = nCurSec + SnowManInfo["RegenInterval"]
			gSnowManList[i]["LifeTime"] = 0
		end


		-- SnowMan이 죽었을 경우
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


		-- 생존 시간이 지나면 삭제
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


		-- SnowMan 생성
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
-- gRankingList 에 있는 플레이어 인덱스(nIndex), 점수(nScore) 반환
-- 플레이어가 없을 경우에는 DefaultValue 값을 반환
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
-- gRankingList 에 있는 플레이어 삭제
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

	-- gRankingList 에 같은 Ranking 이 있는지 확인
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


	-- gRankingList 에서 제거
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
-- gRankingList 에 플레이어 추가
-- 반환값
--		true	: 플레이어 추가 성공
--		false	: 플레이어 추가 실패
------------------------------------------------------------
function PlayerRankingInsert( RankingInfo )
cExecCheck( "PlayerRankingInsert" )


	local nInsertInx 	= 1
	local nRankingCnt	= #gRankingList
	local nRankingPlus	= 1

	RankingInfo["nRanking"] = 0


	-- gRankingList 에서 추가할 위치 찾기
	for i = 1, nRankingCnt
	do
		-- 추가할 정보의 점수가 높으면, 이 위치에 RankingInfo 추가
		if gRankingList[i]["nScore"] < RankingInfo["nScore"]
		then
			-- 랭킹 설정이 안되있으면, 랭킹 설정
			if RankingInfo["nRanking"] == 0
			then
				RankingInfo["nRanking"] = gRankingList[i]["nRanking"]
			end

			nInsertInx = i
			break
		end

		-- 같은 점수를 가지고 있는 플레이어가 있으면, 같은 랭킹으로 설정한다.
		if gRankingList[i]["nScore"] == RankingInfo["nScore"]
		then
			RankingInfo["nRanking"] = gRankingList[i]["nRanking"]
			nRankingPlus	= 0
		end

		nInsertInx = i + 1
	end


	-- nInsertInx 확인
	if nInsertInx > EVENT_INFO["MaxRanking"]
	then
		-- 플레이어 정보 추가 실패
		return false
	end


	-- 추가될 위치에서 부터 랭킹 하나씩 미루기
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



	-- 순위 설정이 안되 었을 경우. 처음으로 플레이어가 추가되는 경우
	if RankingInfo["nRanking"] == 0
	then
		if nRankingCnt == 0
		then
			RankingInfo["nRanking"]	= 1
		else
			RankingInfo["nRanking"] = gRankingList[nInsertInx - 1]["nRanking"] + 1
		end
	end


	-- 플레이어 정보 추가
	gRankingList[nInsertInx] = RankingInfo
	return true
end
