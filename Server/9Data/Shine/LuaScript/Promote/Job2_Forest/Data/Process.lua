--------------------------------------------------------------------------------
--                Promote Job2_Forest Process Data                            --
--------------------------------------------------------------------------------

INVALID_HANDEL				= -1

-- 링크 위치 정보
LinkInfo =
{
	ReturnMap = { MapIndex = "RouN", X = 7310, Y = 7102 },
}


-- 지연 시간 정보
DelayTime =
{
	LimitTime					= 300,		-- 플레이 제한시간
	FindHeroLimitTime			= 300,		-- 이 시간 내에 특정영역(Job2_Zone02)으로 이동해야 함

	GapDialog					= 3,		-- Npc대사 출력시간간격
	GapReturnNotice				= 5,		-- ReturnToHome()의 공지메시지 출력시간간격

	WaitMobRegen				= 1,		-- 몹 소환한 뒤, WaitMobRegen만큼 기다렸다가 몹 카운팅
	WaitSeconds					= 2,		-- 대사 완료후 이 시간만큼 있다가 다음단계 진행

	WaitReturnToHome			= 3,		-- ReturnToHome() 대기시간

	WaitDialogSecond			= 60,		-- BattleFirst() 시작후, DialogSecond() 시작하기까지 대기시간
	WaitDialogThird				= 60,		-- BattleSecond() 시작후, DialogThird() 시작하기까지 대기시간
	WaitDialogFourth			= 60,		-- BattleThird() 시작후, DialogFourth() 시작하기까지 대기시간
}


-- 영역 정보
AreaInfo =
{
	FindNPC = "Job2_Zone02",
}


-- 퀘스트 성공시 획득아이템
RewardItem =
{
	Index = "Job2_RouNec" ,
}

