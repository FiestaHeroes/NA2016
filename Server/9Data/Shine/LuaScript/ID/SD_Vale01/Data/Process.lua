--------------------------------------------------------------------------------
--                                Process Data                                      --
--------------------------------------------------------------------------------

INVALID_HANDLE 			= -1

--------------------------------------------------------------
--※ 진행 관련 DelayTime 정보
--------------------------------------------------------------
DelayTime =
{
	AfterInit 					= 5,	-- 던전 입장 후, 첫 대사 출력시까지의 대기시간
	GapDialog					= 3,	-- 페이스컷 사이의 시간
	GapIDReturnNotice			= 5,	--

	WaitKingCrabProcess			= 5,	-- InitDungeon 			-> KingCrabProcess 대기시간
	WaitKingSlimeProcess		= 5,	-- KingCrabProcess 		-> KingSlimeProcess 대기시간
	WaitMiniDragonProcess 		= 5,	-- KingSlimeProcess 	-> MiniDragonProcess 대기시간

	WaitAfterMiniDragonProcess 	= 5,	-- MiniDragonProcess 	-> BonusStage/ReturnToHome 대기시간
	WaitReturnToHome			= 5,
}

--------------------------------------------------------------
--※ 제한 시간 정보
--------------------------------------------------------------
-- 이 시간(초)안에 미니드래곤 죽이면 보너스스테이지 실행
LimitTime =
{
	ForBonusStage	   = 900,
}

--------------------------------------------------------------
--※ ReturnMap 정보
--------------------------------------------------------------
-- 게이트로 스스로 나가지 않는 유저들, 일정 시간후 강제로 이동시켜 줄 좌표
LinkInfo =
{
	ReturnMap	= { MapIndex = "RouN", x = 5292, y = 5779 },
}

--------------------------------------------------------------
--※ 맵 좌표 정보
--------------------------------------------------------------
MapInfo =
{
	CenterCoord 	= { x = 5620, y = 6850 },	-- 맵 중앙 좌표
	UserLinkCoord 	= { x = 5922, y = 5765 },	-- 게이트 통해서 입장했을때 유저 리젠좌표
}


--------------------------------------------------------------
--※ 각 보스를 해치웠을때 지급될 보상정보
--------------------------------------------------------------
RewardItemInfo =
{
	KingCrabProcess 	= { Index = "IM_SD_Vale01", Num = 1 },
	KingSlimeProcess 	= { Index = "IM_SD_Vale01", Num = 1 },
	--MiniDragonProcess	= { Index = "IM_SD_Vale01", Num = 1 },
	BonusStageProcess 	= { Index = "IM_SD_Vale01", Num = 1 },
}











