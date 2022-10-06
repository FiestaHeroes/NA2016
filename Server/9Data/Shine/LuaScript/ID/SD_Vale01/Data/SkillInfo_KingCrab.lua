--------------------------------------------------------------
--※ KingCrab 스킬정보
--------------------------------------------------------------
SkillInfo_KingCrab =
{
	-- 휠윈드
	KC_WhirlWind =
	{
		-- 메인 스킬인덱스
		SkillIndex					= "SD_KingCrabSkill07_N",

		-- 킹크랩 좌표기준 타겟을 검색할 범위
		Target_SearchArea		= 1500,
		SpeedRate				= 5000,

		-- 킹크랩에 걸어줄 상태이상
		AbState_To_KingCrab =
		{
			SpinDamage =
			{
				Index		= "StaSDVale01_Wheel",
				Strength	= 1,
				KeepTime	= 60 * 60 * 1000,		-- 무제한( 조건만족시 효과제거할 예정)
			},

			NotTargetted =
			{
				Index		= "StaNotTarget",
				Strength	= 1,
				KeepTime	= 60 * 60 * 1000,		-- 무제한( 조건만족시 효과제거할 예정)
			},
		},
		-- 휠윈드 최대 지속시간(초)( 타겟을 다 추적하지 못했어도, 이 시간이 되면 무조건 휠윈드 스킬은 종료한다. )
		SkillKeepTime 		= 10,

		-- 휠윈드 우선순위 계산 테이블
		-- 각 조건별로 확인해서 우선순위 점수가 계산되며, 점수가 가장 높은 유저를 가장 먼저 타겟팅한다.
		Target_Priority =
		{
			-- 상태이상
			-- 예 ) StaSDVale01_STN 상태이상에 걸려있는 유저는 우선순위 +50점 추가
			ChrAbState =
			{
				{ Index = "StaSDVale01_STN", 		arg = 50 },
				{ Index = "StaSDVale01_SpdDown", 	arg = 30 },
			},

			-- 유저의 직업
			-- 예 ) Cleric 유저(class = 6)는 우선순위 +20점 추가
			ChrBaseClass =
			{
			--[[ ※ 참고
				Fighter		= 1,
				Cleric		= 6,
				Archer		= 11,
				Mage		= 16,
				Joker		= 21,
			--]]
				{ class = 1, 	arg = 10 },
				{ class = 6, 	arg = 50 },
				{ class = 11, 	arg = 30 },
				{ class = 16, 	arg = 30 },
				{ class = 21, 	arg = 10 },
			},
		},

		-- 타겟이 킹크랩과의 거리가 이 값 이상이면, 다음타겟으로 변경한다.
		Target_Distance		= 2000,

		-- 타겟별로 뽑아줄 좌표개수
		PathListEachTarget =
		{
			ListNum			= 5,	-- 타겟 하나당 뽑을 좌표 개수
			Distance		= 200,	-- 타겟과 반경 n 안에 있는 랜덤좌표를 추출
		},
	},

	-- 거품방울소환
	KC_SummonBubble =
	{
		-- 메인 스킬인덱스
		SkillIndex			= "SD_KingCrabSkill09_N",

		-- 소환할 몹 인덱스(거품방울)
		SummonIndex 		= "SD_CrabFoam",

		-- 해당 스킬애니 시작후, 실제로 소환작업을 시작할 시간(초)
		-- ( 애니메이션 상으로 킹크랩이 땅에 들어가고 난 이후 시간으로 세팅하면 됨 )
		SummonStartDelay 	= 1.2,

		-- 소환몹이 쓰는 자폭스킬인덱스
		SummonSkillIndex 	= "SD_CrabFoamSkill01_W",

		-- 소환할 몹의 마리수
		SummonNum			= 80,

		-- 킹크랩 기준, 랜덤으로 소환할 원의 범위( 반지름 )
		SummonRadius		= 800,

		-- 몇초마다 리젠?
		SummonTick			= 0.05,

		-- 킹크랩에 걸어줄 상태이상
		AbState_To_KingCrab =
		{
			NotTargetted =
			{
				Index		= "StaNotTarget",
				Strength	= 1,
				KeepTime	= 60 * 60 * 1000,		-- 무제한( 조건만족시 효과제거할 예정)
			},
		},
	},

}
