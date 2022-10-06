--------------------------------------------------------------------------------
--                          Arena Process Data                                --
--------------------------------------------------------------------------------


-- 링크 좌표 정보
LinkInfo =
{
	ReturnMap = { MapIndex = "Gate", x = 1487, y = 1517 },
}


-- 대기 시간 정보
DelayTime =
{
	StartWait						= 30,
	BeforeStartDialog				= 5,
	BetweenStartDialog				= 4,
	BeforeStartEffect				= 25,
	ArenaKeepTime					= 900,
	ReviveWaitTime					= 3,
	ArenaProcessIntervalTime		= 1,
	GoalConditionNoticeIntervalTime = 5,
	GapKQReturnNotice				= 5,
}


-- 알림 출력 정보
NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	KQReturn =
	{
		{ Index = "KQReturn30", },	-- 30초 남음
		{ Index = nil,          },	-- 25초 남음: 메세지 없음
		{ Index = "KQReturn20", },	-- 20초 남음
		{ Index = nil,          },	-- 15초 남음: 메세지 없음
		{ Index = "KQReturn10", },	-- 10초 남음
		{ Index = "KQReturn5" , },	-- 05초 남음
	},
}


-- 다이얼로 출력 정보
NPCDialogInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	StartWait =
	{
		{ Index = "FaceCut01",	FaceCut = "RouGaianMaria" },
		{ Index = "FaceCut02",	FaceCut = "RouGaianMaria" },
		{ Index = "FaceCut03",	FaceCut = "RouGaianMaria" },
		{ Index = "FaceCut04",	FaceCut = "RouGaianMaria" },
	},
}


-- 팀 번호
 RED_TEAM		= 1
BLUE_TEAM		= 2
 DEF_TEAM		= 3

 TeamNumberList =
 {
	RED_TEAM,
	BLUE_TEAM,
 }

 -- 팀 유니폼
 TeamUniform =
 {
	[ RED_TEAM ] 	= { "Menian_RedA", "Menian_RedP", "Menian_RedS" },
	[ BLUE_TEAM ]	= { "Menian_BlueA", "Menian_BlueP", "Menian_BlueS" },
 }

 -- 아레나 결과, 보상 정보
 ArenaResult =
 {
	 WIN  = { EffectMsg = EFFECT_MSG_TYPE["EMT_WIN"],  RewardIndex = "REW_KQ_ARENA_WIN",  RewardAbs = { Index = "StaArenaReward", Str = 1, KeepTime = 3600000 }, },
	 LOSE = { EffectMsg = EFFECT_MSG_TYPE["EMT_LOSE"], RewardIndex = "REW_KQ_ARENA_LOSE", RewardAbs = nil },
	 DRAW = { EffectMsg = EFFECT_MSG_TYPE["EMT_DRAW"], RewardIndex = "REW_KQ_ARENA_DRAW", RewardAbs = nil },
 }
