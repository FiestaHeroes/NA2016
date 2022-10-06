require( "common" )


--------------------------------------------------------------------
--※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
--// [S_21003] 크리스마스_2014_이벤트 관련 데이터
---------------------------------------------------------START-----
--※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
--------------------------------------------------------------------

--------------------------------------------------------------------
--// 대형나무 처리 관련 데이터
--------------------------------------------------------------------

-- 디펜스 이벤트 진행시 변경될 애니메이션
TREE_DEFENCE_TABLE =
{
	TREE_DIE 		= { AniIndex = "E_XTreeBig_Idle05", },	-- 부서지는 모양
	TREE_REGEN	 	= { AniIndex = "E_XTreeBig_Idle00", },	-- 원래대로 되돌림( 0단계로 )
}

--------------------------------------------------------------------
--// 산타 깨빙 처리 관련 데이터
--------------------------------------------------------------------

SANTA_KEBING_MOB_REGEN_TABLE =
{
	RunSpeed 		= 700,
	MobIndex		= "KebingX_14",

	{ RegenX = 18427, RegenY = 15754, 	Dir = 0,},
	{ RegenX = 13598, RegenY = 15727, 	Dir = 0,},
	{ RegenX = 14685, RegenY = 9746,	Dir = 0,},
	{ RegenX = 11327, RegenY = 13423, 	Dir = 0,},
}


SANTA_KEBING_MOB_ANI_TABLE =
{
	CastAniIndex		= "KebingKnockBackCasting",
	CastAniKeepTime		= 3,							-- CastAniIndex 재생시간. 이 시간만큼 CastAniIndex 애니 재생 후, SwingAniIndex로 넘어감

	SwingAniIndex		= "KebingKnockBackSwing",
}

-- 이동 상태값 flag
MOVESTATE = {}
MOVESTATE["STOP"] = "STOP"
MOVESTATE["MOVE"] = "MOVE"

PATHTYPE_CHK_DLY	= 1
PATHTYPE_GAP    	= 100				-- 웨이브몹 이동좌표체크 여유거리

SANTA_KEBING_PATH_TABLE =
{

	-- RegenX = 18427, RegenY = 15754에서 리젠될 산타깨빙의 PATH정보
	{
		--{ x =  18427, y =  15754, },	-- 출발점(리젠좌표)

		{ x =  17473, y =  14197, },
		{ x =  16386, y =  13974, },
		{ x =  15572, y =  13385, },	-- 트리 좌표
	},

	-- RegenX = 13598, RegenY = 15727에서 리젠될 산타깨빙의 PATH정보
	{
		--{ x =  13598, y =  15727, },	-- 출발점(리젠좌표)

		{ x =  14139, y =  14478, },
		{ x =  15572, y =  13385, },
	},

	-- RegenX = 14685, RegenY = 9746에서 리젠될 산타깨빙의 PATH정보
	{
		--{ x = 14685, y =  9746, },	-- 출발점(리젠좌표)

		{ x =  14954, y =  11265, },
		{ x =  15555, y =  11704, },
		{ x =  15572, y =  13385, },
	},

	-- RegenX = 11327, RegenY = 13423에서 리젠될 산타깨빙의 PATH정보
	{
		--{ x =  11327, y =  13423, },	-- 출발점(리젠좌표)

		{ x =  12547, y =  13423, },
		{ x =  13178, y =  12963, },
		{ x =  14022, y =  13411, },
		{ x =  15572, y =  13385, },
	},
}

--------------------------------------------------------------------
--// 크러시볼 처리 관련 데이터
--------------------------------------------------------------------

CRUSHBALL_TABLE =
{
	MobIndex		= "BallCrush",
	SkillIndex		= "BallCrush_Skill01_W",
}

-- 크러시볼에 맞았을때, 산타깨빙에게 걸어줄 넉백 상태이상
CRUSHBALL_ABSTATE_TABLE =
{
	AbStateHitRate	= 300,						-- 상태이상이 발생할 확률
	AbstateIndex	= "StaKnockBackFly",
	Strength 		= 1,
	KeepTime 		= 1,
}

--------------------------------------------------------------------
--// 디펜스이벤트 보상 관련 데이터
--------------------------------------------------------------------

DEFENCE_EVENT_REWARD_ABSTATE_TABLE =
{
	AbstateIndex 	= "StaXmas_StatUp",
	Strength 		= 1,
	KeepTime 		= (60*60*1000),
	Range 			= 10000,							-- 산타깨빙 모두 물리쳤을때, 메인트리 기준으로 Range안에 들어와있는 캐릭터에 상태이상을 줌
}

--------------------------------------------------------------------
--// Script
--------------------------------------------------------------------

E_XKebingChat01			= "E_XKebingChat01"				-- 지난번처럼 당할거라고 생각하지마라!!
E_X_Notice_DefenseStart	= "E_X_Notice_DefenseStart"		-- 크리스마스 깨빙의 습격이 시작되었습니다. 트리를 지켜주세요.
E_X_Notice_DefenseSucc	= "E_X_Notice_DefenseSucc"		-- 크리스마스 보스 깨빙의 습격으로 부터 방어를 성공하였습니다.
E_X_Notice_DefenseFail	= "E_X_Notice_DefenseFail"		-- 크리스마스 깨빙에 의해 트리가 파괴되었습니다.
E_X_Notice_TreeRegen	= "E_X_Notice_TreeRegen"		-- 새로운 트리가 세워졌습니다. 트리를 꾸며 주세요.

--------------------------------------------------------------------
--// 디펜스이벤트 처리 관련 데이터
--------------------------------------------------------------------

NEED_KEBING_KILLCOUNT_FOR_DEFENCE_EVENT		= 100			-- 장난꾸러기 깨빙 n마리 사냥시, 디펜스이벤트가 시작됨

SANTAKEBING_CRUSHBALL_HIT_COUNT				= 50			-- 산타깨빙이 크러시볼에 n번 맞으면 사망함

SANTAKEBING_RANGE_WITH_TREE					= 50			-- 산타깨빙과 메인트리 충돌 범위
SANTAKEBING_RANGE_WITH_CRUSHBALL			= 50			-- 산타깨빙과 크러시볼 충돌 범위

DEFENCE_EVENT_FAIL_TREE_REGEN_TIME			= 15			-- 디펜스 실패후, 트리가 다시 리젠될때까지 걸리는 시간(초)

--------------------------------------------------------------------
--// 게임로그
--------------------------------------------------------------------

NC_LOG_GAME_CHRISTMAS_DECO_TRY_BIG_TREE			= 2045		-- 대형트리 꾸미기를 시도
NC_LOG_GAME_CHRISTMAS_DECO_TRY_SMALL_TREE		= 2046		-- 소형트리 꾸미기를 시도( 소형트리 몹 아이디 )
NC_LOG_GAME_CHRISTMAS_DECO_COMPLETE_BIG_TREE	= 2047		-- 대형트리 꾸미기를 완성
NC_LOG_GAME_CHRISTMAS_DECO_COMPLETE_SMALL_TREE	= 2048		-- 소형트리 꾸미기를 완성( 소형트리 몹 아이디 )
NC_LOG_GAME_CHRISTMAS_START_DEFENCE				= 2049		-- 디펜스 이벤트 진행
NC_LOG_GAME_CHRISTMAS_SUCC_DEFENCE				= 2050		-- 디펜스 이벤트 성공

--------------------------------------------------------------------
--※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
--// [S_21003] 크리스마스_2014_이벤트 관련 데이터
---------------------------------------------------------END-------
--※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
--------------------------------------------------------------------


--------------------------------------------------------------------
--// Defined
--------------------------------------------------------------------

VALID_MAP_INDEX		= "Eld"				-- 메인트리 리젠시 체크할 맵인덱스
IMMORTAL_INDEX		= "StaImmortal"		-- 몹 리젠시 풀어줄 상태이상
TREE_CAST_TIME		= (2*1000)			-- 나무 캐스팅 시간
TREE_CAST_ANI		= "ActionProduct"	-- 나무 캐스팅 애니메이션 인덱스
TREE_CAST_ITEM		= "E_XTreeDeco"		-- 나무 캐스팅 이후 소모 아이템



--------------------------------------------------------------------
--// Script
--------------------------------------------------------------------

-- 파일 이름
SCRIPT_FILE_NAME	= "Event"

-- 스크립트 인덱스
E_X_Notice_TreeUp01		= "E_X_Notice_TreeUp01"		-- 트리가 2단계로 변형되어 장식이 늘어납니다.
E_X_Notice_TreeUp02		= "E_X_Notice_TreeUp02"		-- 트리가 3단계로 변형되어 빛나는 장식이 늘어납니다.
E_X_Notice_TreeUp03		= "E_X_Notice_TreeUp03"		-- 트리가 4단계로 변형되어 불빛이 화려해집니다.
E_X_Notice_TreeUp04		= "E_X_Notice_TreeUp04"		-- 트리가 5단계로 변형되어 화려함의 극치를 보여줍니다.
E_X_Notice_TreeUp05		= "E_X_Notice_TreeUp05"		-- 장난꾸러기 깨빙들이 트리 장식들을 훔쳐갑니다.
E_X_Notice_TreeInit		= "E_X_Notice_TreeInit"		-- 장난꾸러기 깨빙들이 모두 도망쳤습니다. 트리를 다시 꾸며주세요.
E_X_Notice_Buff01		= "E_X_Notice_Buff01"		-- 크리스마스의 소망이 느껴질랑가 몰라
E_X_Notice_Buff02		= "E_X_Notice_Buff02"		-- 루돌프의 소망이 느껴질랑가 몰라
E_X_Notice_Buff03		= "E_X_Notice_Buff03"		-- 산타 요정의 소망이 느껴질랑가 몰라
E_X_Notice_Buff04		= "E_X_Notice_Buff04"		-- 산타의 소망이 느껴질랑가 몰라
E_X_SysMsg_Deco01		= "E_X_SysMsg_Deco01"		-- 크리스마스 소망 트리에 별 장식을 달았습니다.
E_X_SysMsg_Deco02		= "E_X_SysMsg_Deco02"		-- 루돌프의 소망 트리에 별 장식을 달았습니다.
E_X_SysMsg_Deco03		= "E_X_SysMsg_Deco03"		-- 산타요정의 소망 트리에 별 장식을 달았습니다.
E_X_SysMsg_Deco04		= "E_X_SysMsg_Deco04"		-- 산타의 소망 트리에 별 장식을 달았습니다.
E_X_SysMsg_Deco05		= "E_X_SysMsg_Deco05"		-- 아이샤의 소망 트리에 별 장식을 달았습니다.
E_X_ErrMsg_DecoFail		= "E_X_ErrMsg_DecoFail"		-- 트리 별 장식이 없습니다. 아이템을 가지고 다시 시도 해주세요.
E_X_SysMsg_DecoFail		= "E_X_SysMsg_Fail1"		-- 지금은 트리에 장식을 추가할 수 없습니다. 잠시 후 다시 시도해주세요.
E_X_SysMsg_DecoFail_2	= "E_X_SysMsg_Fail2"		-- Cannot use the item due to an Abnormal State


--------------------------------------------------------------------
--// 대형나무 처리 관련 데이터
--------------------------------------------------------------------

-- 레벨 테이블
-- NeedCount	: 해당 레벨이 되기위해 필요한 아이템 수. (레벨은 0단계부터)
-- LevDwnKeep	: 1 = 1Sec, 최대 레벨이 된 이후 각 레벨 유지 시간
TREE_LEVEL_TABLE =
{
	{ NeedCount = 50 , AniIndex = "E_XTreeBig_Idle01", LevDwnKeep = 100, Notice = E_X_Notice_TreeUp01, },
	{ NeedCount = 100, AniIndex = "E_XTreeBig_Idle02", LevDwnKeep = 100, Notice = E_X_Notice_TreeUp02, },
	{ NeedCount = 150, AniIndex = "E_XTreeBig_Idle03", LevDwnKeep = 100, Notice = E_X_Notice_TreeUp03, },
	{ NeedCount = 200, AniIndex = "E_XTreeBig_Idle04", LevDwnKeep = 600, Notice = E_X_Notice_TreeUp04, },
}


-- 몹 리젠 테이블
-- RegenInterval: 1 = 1Sec, 몹이 죽은 이후 다시 리젠 되는 시간.
REWARD_MOB_REGEN_TABLE =
{
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15861, CenterY = 15069, Range = 2000, RegenInterval = 2, },

	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 15612, CenterY = 11399, Range = 2000, RegenInterval = 2, },

	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },
	{ MobIndex = "E_XKebing", CenterX = 12342, CenterY = 11267, Range = 2000, RegenInterval = 2, },

}


-- 연출
TREE_LEVEL_DOWN_EVENT_INFO =
{
	MobLifeTime	= 5,					-- n초동안 유지되는
	MobIndex	= "E_XKebing_Show",		-- s몹을
	RegenTick	= 3,					-- n+1틱마다(1Tick=0.1Sec)
	RegenDist	= 300,					-- 나무와 n만큼 떨어진 거리에서 리젠하고
	FollowGap	= 180,					-- 나무와 n만큼 떨어진 거리까지 이동해서
	AniTime		= 3,					-- n초 동안
	AniIndex	= "E_XKebing_Skill01_N",	-- s애니메이션을 보여주고
	RunSpeed	= 2000,					-- (n/1000)의 이동속도로
	RunMaxDist	= 2000,					-- 나무와 n만큼 떨어진 거리까지 도망가는 연출을
	KeepTime	= 30,					-- n초 동안 유지한다.
}



--------------------------------------------------------------------
--// 소형나무 처리 관련 데이터
--------------------------------------------------------------------

-- 보상 상태이상 테이블
-- KeepTime	: 1000 = 1sec
-- Range	: 보상 범위
REWARD_ABSTATE_TABLE =
{
	Reward01 = { AbstateIndex = "StaXReward01", Strength = 1, KeepTime = (60*60*1000), Range = 1000, Notice = E_X_Notice_Buff01, },
	Reward02 = { AbstateIndex = "StaXReward02", Strength = 1, KeepTime = (60*60*1000), Range = 1000, Notice = E_X_Notice_Buff02, },
	Reward03 = { AbstateIndex = "StaXReward03", Strength = 1, KeepTime = (60*60*1000), Range = 1000, Notice = E_X_Notice_Buff03, },
	Reward04 = { AbstateIndex = "StaXReward04", Strength = 1, KeepTime = (60*60*1000), Range = 1000, Notice = E_X_Notice_Buff04, },
}


-- 레벨 테이블
-- MaxLevelKeep : 1 = 1Sec, 최대 레벨이 된 이후 유지 시간
-- NeedCount	: 해당 레벨이 되기위해 필요한 아이템 수. (레벨은 0단계부터)
SMALL_TREE_LEVEL_TABLE =
{
	MaxLevelKeep = 300,

	{ NeedCount = 5, 	AniIndex = "E_XTree_Idle01", },
	{ NeedCount = 10, 	AniIndex = "E_XTree_Idle02", },
}


-- 소형나무 정보
-- LevelTable	: SMALL_TREE_LEVEL_TABLE 데이터 인덱스
-- RewardAbstate: REWARD_ABSTATE_TABLE 데이터 인덱스
SMALL_TREE_INFO =
{
	{ MobIndex = "E_XTree_Xmas", 	RegenX = 14738, RegenY = 13055, Dir = 7, 	CastSuccMsg = E_X_SysMsg_Deco01, RewardAbstate = "Reward01", },
	{ MobIndex = "E_XTree_Rudolph", RegenX = 17372, RegenY = 13673, Dir = 129, 	CastSuccMsg = E_X_SysMsg_Deco02, RewardAbstate = "Reward02", },
	{ MobIndex = "E_XTree_Fairy", 	RegenX = 15582, RegenY = 13827, Dir = 43, 	CastSuccMsg = E_X_SysMsg_Deco03, RewardAbstate = "Reward03", },
	{ MobIndex = "E_XTree_Santa", 	RegenX = 14797, RegenY = 13758, Dir = 132, 	CastSuccMsg = E_X_SysMsg_Deco04, RewardAbstate = "Reward04", },
	{ MobIndex = "E_XTree_Xmas", 	RegenX = 16750, RegenY = 13852, Dir = 128, 	CastSuccMsg = E_X_SysMsg_Deco01, RewardAbstate = "Reward01", },
	{ MobIndex = "E_XTree_Rudolph", RegenX = 15769, RegenY = 12928, Dir = 81, 	CastSuccMsg = E_X_SysMsg_Deco02, RewardAbstate = "Reward02", },
	{ MobIndex = "E_XTree_Fairy", 	RegenX = 16517, RegenY = 12977, Dir = 53, 	CastSuccMsg = E_X_SysMsg_Deco03, RewardAbstate = "Reward03", },
	{ MobIndex = "E_XTree_Santa", 	RegenX = 17363, RegenY = 13090, Dir = 146, 	CastSuccMsg = E_X_SysMsg_Deco04, RewardAbstate = "Reward04", },
}



--------------------------------------------------------------------
--// 눈사람 처리 관련 데이터
--------------------------------------------------------------------

-- 아이템 드랍 테이블
-- Rate : 1000000 = 100%
ITEM_DROP_TABLE =
{
	SnowMan =
	{
		{ ItemIndex = "E_XTreeDeco",	Rate =  700000, },
		{ ItemIndex = "E_XCrystal",		Rate =  500000, },
		{ ItemIndex = "E_BallSnow02",	Rate =  500000, },
	},
}


-- 눈사람 정보
-- CenterX, CenterY, Range		: 리젠 중심 좌표와 범위
-- LifeTime_Min, LifeTime_Max	: 1 = 1Sec, 리젠후 눈사람 유지시간(다시 리젠될 시간) 범위
-- DropTable					: ITEM_DROP_TABLE 데이터 인덱스
SNOWMAN_INFO =
{
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 16000, CenterY = 15640, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },


	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 14813, CenterY = 10438, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },


	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 11142, CenterY = 10910, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },


	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },
	{ MobIndex = "E_XSnowman", CenterX = 18261, CenterY = 10737, Range = 1000, LifeTime_Min = 5, LifeTime_Max = 7, DropTable = "SnowMan", },

}



--------------------------------------------------------------------
--// 크리스마스 이벤트 전역 변수
--------------------------------------------------------------------

-- 몹정보 처리에 사용
MemBlock = {}



--------------------------------------------------------------------
--// 스크립트 메인
--------------------------------------------------------------------

function E_XTreeBig( Handle, MapIndex )
cExecCheck( "E_XTreeBig" )


	if MapIndex ~= VALID_MAP_INDEX
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end


	if cIsObjectDead( Handle ) == 1
	then
		KebingVanishAll( MemBlock[Handle] )
		cAIScriptSet( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	end


	local Var		= MemBlock[Handle]
	local CurSec	= cCurrentSecond()

	if Var == nil
	then

		MemBlock[Handle]		= {}

		Var						= MemBlock[Handle]

		Var["MapIndex"] 		= MapIndex
		Var["Handle"]			= Handle

		Var["CurSec"]			= CurSec
		Var["NextTick"]			= CurSec

		Var["Level"]			= 0
		Var["Count"]			= 0

		Var["RegenKebing"]		= false
		Var["KebingList"]		= {}
		Var["KebingRegenList"]	= {}

		Var["LevelDownEvent"]	= false
		Var["EventKeepTime"]	= CurSec
		Var["TickCount"]		= TREE_LEVEL_DOWN_EVENT_INFO["RegenTick"]

		-- 죽은 장난꾸러기 깨빙의 수
		Var["KebingDeadCount"] = 0

		-- 대형트리핸들
		MemBlock["TreeHandle"]	= Handle

		-- 대형트리 프로세스
		MemBlock["BonusDefenceEvent"]						= {}
		MemBlock["BonusDefenceEvent"]["IsProgress"] 		= false		-- 디펜스 이벤트가 발동중인가
		MemBlock["BonusDefenceEvent"]["IsSantaKebingCrush"]	= false		-- 깨빙과 충돌했는가
		cAIScriptFunc( Handle, "NPCClick", "TreeClick" )
		cAIScriptFunc( Handle, "NPCMenu",  "TreeCastingComplete" )
		cSetFieldScript 	( Var["MapIndex"], Handle )
		cFieldScriptFunc	( Var["MapIndex"], "ServantSummon", "ServantSummon" )
	end


	-- 0.1초마다 처리
	if Var["NextTick"] <= CurSec
	then
		Var["CurSec"]	= CurSec
		Var["NextTick"]	= Var["NextTick"] + 0.1
	else
		return ReturnAI["END"]
	end

	TreeProcess( Var )
	SmallTreeProcess( Var )
	SnowManProcess( Var )

	SantaKebingRegenProcess( Var )

	return ReturnAI["END"]

end



--------------------------------------------------------------------
--// 나무 처리
--------------------------------------------------------------------

-- 나무 처리
function TreeProcess( Var )
cExecCheck( "TreeProcess" )

	if Var == nil
	then
		return
	end

	if Var["CurSec"] == nil
	then
		return
	end

	if Var["Level"] == nil
	then
		return
	end

	if Var["Count"] == nil
	then
		return
	end

	if Var["RegenKebing"] == nil
	then
		return
	end

	if Var["LevelDownEvent"] == nil
	then
		return
	end


	-- TreeCastingComplete 에서 세팅됨
	if Var["LevDwnKeep"] ~= nil
	then
		-- 유지 시간 지나면
		if Var["LevDwnKeep"] <= Var["CurSec"]
		then
			-- 첫 레벨다운이면
			if Var["Level"] == #TREE_LEVEL_TABLE
			then
				-- ※ 게임로그
				-- 대형 트리 완성 횟수( 5단계까지 꾸미기 성공 )
				cSendGameLogDataType_5( NC_LOG_GAME_CHRISTMAS_DECO_COMPLETE_BIG_TREE, 0, 0, 0 )
				-- 공지
				cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, E_X_Notice_TreeUp05 )

				-- 깨빙 리젠 시작
				Var["RegenKebing"] = true
			end

			-- 레벨 다운
			Var["Level"] = Var["Level"] - 1


			if Var["Level"] <= 0
			then
				-- 공지
				-- cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, E_X_Notice_TreeInit )

				-- 애니메이션 원상태로
				cAnimate( Var["Handle"], "stop" )

				-- 깨빙 리젠 중지, 제거
				Var["RegenKebing"] = false
				KebingVanishAll( Var )

				-- 레벨과 카운트 초기화
				Var["Level"]		= 0
				Var["Count"]		= 0

				Var["LevDwnKeep"]	= nil
				-- 깨빙 100 마리 넘게 죽였으면 디펜스이벤트 발생
				if Var["KebingDeadCount"] >= NEED_KEBING_KILLCOUNT_FOR_DEFENCE_EVENT
				then

					-- ※ 게임로그 남길 부분
					-- 디펜스 이벤트 진행 횟수
					cSendGameLogDataType_5( NC_LOG_GAME_CHRISTMAS_START_DEFENCE, 0, 0, 0 )

					-- 공지 : 크리스마스 깨빙의 습격이 시작되었습니다. 트리를 지켜주세요.
					cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, E_X_Notice_DefenseStart )
					MemBlock["BonusDefenceEvent"]["IsProgress"] = true

				else
					-- 공지 : 장난꾸러기 깨빙들이 모두 도망쳤습니다. 트리를 다시 꾸며주세요.
					cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, E_X_Notice_TreeInit )
				end

				-- 깨빙 죽인 수 초기화
				Var["KebingDeadCount"] = 0
			else
				local CurLevData = TREE_LEVEL_TABLE[ Var["Level"] ]

				-- 다음 레벨다운 시간
				Var["LevDwnKeep"] = Var["CurSec"] + CurLevData["LevDwnKeep"]

				-- 애니메이션 변경
				cAnimate( Var["Handle"], "start", CurLevData["AniIndex"] )

				-- 레벨다운 애니메이션 세팅
				Var["LevelDownEvent"]	= true
				Var["EventKeepTime"]	= Var["CurSec"] + TREE_LEVEL_DOWN_EVENT_INFO["KeepTime"]

			end
		end
	end


	if Var["RegenKebing"] == true
	then
		KebingRegenProcess( Var )
	end

	if Var["LevelDownEvent"] == true
	then
		TreeLevelDownEventProcess( Var )
	end

	-- 디펜스 이벤트 발동
	if MemBlock["BonusDefenceEvent"]["IsProgress"] == true
	then

		if MemBlock["BonusDefenceEvent"]["IsSantaKebingCrush"] == false
		then
			-- 대형깨빙 죽은 마리 수 체크, 모두 죽었으면
			if IsSantaKebingAllDead( Var ) == true
			then
				-- ※ 게임로그
				-- 디펜스 이벤트 성공 횟수
				cSendGameLogDataType_5( NC_LOG_GAME_CHRISTMAS_SUCC_DEFENCE, 0, 0, 0 )

				-- 공지처리 ( 트리를 잘 지켜냇군요 )
				cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, E_X_Notice_DefenseSucc )

				-- 버프 부여
				cSetAbstate_Range( Var["Handle"], DEFENCE_EVENT_REWARD_ABSTATE_TABLE["Range"], ObjectType["Player"], DEFENCE_EVENT_REWARD_ABSTATE_TABLE["AbstateIndex"], DEFENCE_EVENT_REWARD_ABSTATE_TABLE["Strength"], DEFENCE_EVENT_REWARD_ABSTATE_TABLE["KeepTime"] )

				-- 모든 정보들 초기화 해주기
				MemBlock["BonusDefenceEvent"]["IsSantaKebingCrush"]		= false
				MemBlock["BonusDefenceEvent"]["ResetCoolTime"] 			= nil
				MemBlock["BonusDefenceEvent"]["IsProgress"] 			= false

				-- 산타깨빙 객체 삭제하기
				SantaKebingVanishAll( Var )

				MemBlock["SantaKebingList"] 		= nil
				MemBlock["SantaKebingListHandle"]	= nil
			end
		end

		-- 트리와 깨빙이 충돌한 상태면,
		if MemBlock["BonusDefenceEvent"]["IsSantaKebingCrush"] == true
		then

			if MemBlock["BonusDefenceEvent"]["ResetCoolTime"] == nil
			then
				-- 공지 처리( 크리스마스 깨빙에 의해 트리가 파괴되었습니다. )
				cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, E_X_Notice_DefenseFail )

				-- 산타깨빙 객체 삭제하기
				SantaKebingVanishAll( Var )

				MemBlock["BonusDefenceEvent"]["ResetCoolTime"]	= Var["CurSec"] + DEFENCE_EVENT_FAIL_TREE_REGEN_TIME

				-- 애니메이션 변경( 부서지는 애니 )
				cAnimate( Var["Handle"], "start", TREE_DEFENCE_TABLE["TREE_DIE"]["AniIndex"] )
			end
		end

		-- 트리 재건할 시간이 되면,
		if MemBlock["BonusDefenceEvent"]["ResetCoolTime"] ~= nil
		then
			if MemBlock["BonusDefenceEvent"]["ResetCoolTime"] <= Var["CurSec"]
			then

				-- 공지 처리( 새로운 트리가 세워졌습니다. 트리를 꾸며 주세요. )
				cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, E_X_Notice_TreeRegen )

				-- 애니메이션 변경( 기본상태로 )
				cAnimate( Var["Handle"], "start", TREE_DEFENCE_TABLE["TREE_REGEN"]["AniIndex"] )

				MemBlock["BonusDefenceEvent"]["IsProgress"] 			= false
				MemBlock["BonusDefenceEvent"]["IsSantaKebingCrush"]		= false
				MemBlock["BonusDefenceEvent"]["ResetCoolTime"] 			= nil

				MemBlock["SantaKebingList"] 		= nil
				MemBlock["SantaKebingListHandle"]	= nil
			end
		end
	end
end


-- 깨빙 리젠
function KebingRegenProcess( Var )
cExecCheck( "KebingRegenProcess" )

	if Var == nil
	then
		return
	end

	if Var["CurSec"] == nil
	then
		return
	end

	if Var["KebingList"] == nil
	then
		return
	end

	if Var["KebingRegenList"] == nil
	then
		return
	end


	for i = 1, #REWARD_MOB_REGEN_TABLE do

		if Var["KebingList"][i] == nil or cIsObjectDead( Var["KebingList"][i] ) == 1
		then
			-- 깨빙 죽었는지 체크하고, 데드카운트 증가
			if cIsObjectDead( Var["KebingList"][i] ) == 1
			then
				Var["KebingDeadCount"] = Var["KebingDeadCount"] + 1
			end
			Var["KebingList"][i] = nil

			if Var["KebingRegenList"][i] == nil
			then
				Var["KebingRegenList"][i] = Var["CurSec"] + REWARD_MOB_REGEN_TABLE[i]["RegenInterval"]
			end
		end

		if Var["KebingRegenList"][i] ~= nil and Var["KebingRegenList"][i] <= Var["CurSec"]
		then
			Var["KebingList"][i] = cMobRegen_Circle( Var["MapIndex"], REWARD_MOB_REGEN_TABLE[i]["MobIndex"],
																		REWARD_MOB_REGEN_TABLE[i]["CenterX"],
																		REWARD_MOB_REGEN_TABLE[i]["CenterY"],
																		REWARD_MOB_REGEN_TABLE[i]["Range"] )
			Var["KebingRegenList"][i]	= nil
		end
	end

end


-- 깨빙 제거
function KebingVanishAll( Var )
cExecCheck( "KebingVanishAll" )

	if Var == nil
	then
		return
	end

	if Var["KebingList"] == nil
	then
		return
	end

	if Var["KebingRegenList"] == nil
	then
		return
	end

	for i = 1, #REWARD_MOB_REGEN_TABLE
	do
		if Var["KebingList"][i] ~= nil
		then
			cNPCVanish( Var["KebingList"][i] )
			Var["KebingList"][i] = nil
		end

		Var["KebingRegenList"][i] = nil
	end

end


-- 나무 레벨다운 연출 처리
function TreeLevelDownEventProcess( Var )
cExecCheck( "TreeLevelDownEventProcess" )

	if Var == nil
	then
		return
	end

	if Var["Handle"] == nil
	then
		return
	end

	if Var["CurSec"] == nil
	then
		return
	end

	if Var["LevelDownEvent"] == nil
	then
		return
	end

	if Var["EventKeepTime"] == nil
	then
		return
	end

	if Var["TickCount"] == nil
	then
		return
	end


	if Var["LevelDownEvent"] == false
	then
		return
	end

	if Var["EventKeepTime"] <= Var["CurSec"]
	then
		Var["LevelDownEvent"]	= false
		Var["TickCount"]		= TREE_LEVEL_DOWN_EVENT_INFO["RegenTick"]
		return
	end

	if Var["TickCount"] < TREE_LEVEL_DOWN_EVENT_INFO["RegenTick"]
	then
		Var["TickCount"] = Var["TickCount"] + 1
		return
	end

	Var["TickCount"] = 0


	local Dir				= cRandomInt( 1, 90 ) * 4
	local RegenX, RegenY	= cGetAroundCoord( Var["Handle"], Dir, TREE_LEVEL_DOWN_EVENT_INFO["RegenDist"] )

	local MobHandle = cMobRegen_XY( Var["MapIndex"], TREE_LEVEL_DOWN_EVENT_INFO["MobIndex"], RegenX, RegenY, Dir )
	if MobHandle ~= nil
	then
		if cAIScriptSet( MobHandle, Var["Handle"] ) ~= nil
		then
			cAIScriptFunc( MobHandle, "Entrance", "EventMobRoutine" )

			MemBlock[MobHandle]					= {}
			MemBlock[MobHandle]["Handle"]		= MobHandle
			MemBlock[MobHandle]["MapIndex"]		= Var["MapIndex"]
			MemBlock[MobHandle]["CurSec"]		= Var["CurSec"]
			MemBlock[MobHandle]["NextTick"]		= Var["CurSec"]
			MemBlock[MobHandle]["LifeTime"]		= Var["CurSec"] + TREE_LEVEL_DOWN_EVENT_INFO["MobLifeTime"]
			MemBlock[MobHandle]["MasterHandle"]	= Var["Handle"]
			MemBlock[MobHandle]["GoalX"],
			MemBlock[MobHandle]["GoalY"]		= cGetAroundCoord( Var["Handle"], Dir, TREE_LEVEL_DOWN_EVENT_INFO["RunMaxDist"] )
		end
	end


end


-- 이벤트몹 루틴
function EventMobRoutine( Handle, MapIndex )
cExecCheck( "EventMobRoutine" )

	local Var		= MemBlock[Handle]
	local CurSec	= cCurrentSecond()

	if Var == nil
	then
		cAIScriptSet( Handle )

		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) == 1
	then
		cAIScriptSet( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	end

	if cIsObjectDead( Var["MasterHandle"] ) == 1
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	end


	-- 이동
	if Var["Step"] == nil
	then
		cFollow( Handle, Var["MasterHandle"], TREE_LEVEL_DOWN_EVENT_INFO["FollowGap"], 9999 )

		Var["Step"] = 1
	end

	-- 0.1초마다 처리
	if Var["NextTick"] <= CurSec
	then
		Var["CurSec"]	= CurSec
		Var["NextTick"]	= Var["NextTick"] + 0.1
	else
		return ReturnAI["END"]
	end


	-- 1스탭부턴 0.1초마다 하기위해 if문 분리
	if 	Var["Step"] == 1
	then
		local MoveState, KeepTime = cGetMoveState( Handle )

		if MoveState ~= nil and MoveState == 0
		then
			cAnimate( Handle, "start", TREE_LEVEL_DOWN_EVENT_INFO["AniIndex"] )
			Var["Step"] = Var["Step"] + 1
		end

	elseif Var["Step"] == 2
	then
		local MoveState, KeepTime = cGetMoveState( Handle )

		if MoveState ~= nil and MoveState == 0 and KeepTime >= TREE_LEVEL_DOWN_EVENT_INFO["AniTime"]
		then
			cAnimate( Handle, "stop" )
			Var["Step"] = Var["Step"] + 1
		end

	elseif Var["Step"] == 3
	then
		if Var["GoalX"] ~= nil and Var["GoalY"] ~= nil
		then
			cRunTo( Handle, Var["GoalX"], Var["GoalY"], TREE_LEVEL_DOWN_EVENT_INFO["RunSpeed"] )
		end
		Var["Step"] = Var["Step"] + 1
	end



	-- 라이프 시간이 지났으면 몹 제거
	if Var["LifeTime"] <= Var["CurSec"]
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	end


	return ReturnAI["END"]

end


-- 나무 클릭처리
function TreeClick( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "TreeClick" )

	local Var = MemBlock[NPCHandle]

	if Var == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Level"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Count"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if #TREE_LEVEL_TABLE == 0
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Count"] >= TREE_LEVEL_TABLE[ #TREE_LEVEL_TABLE ]["NeedCount"]
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	-- 디펜스 이벤트 중이라서 처리하지않음
	if MemBlock["BonusDefenceEvent"]["IsProgress"] == true
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end
	if cIsNoAttacOrNoMove( PlyHandle ) == 1
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail_2 )
		return
	end


	cCastingBar( PlyHandle, NPCHandle, TREE_CAST_TIME, TREE_CAST_ANI )

end


-- 나무 캐스팅 완료 처리
function TreeCastingComplete( NPCHandle, PlyHandle, RegistNumber, Menu )
cExecCheck( "TreeCastingComplete" )

	local Var = MemBlock[NPCHandle]

	if Var == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Level"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Count"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["MapIndex"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if #TREE_LEVEL_TABLE == 0
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Level"] >= #TREE_LEVEL_TABLE
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Count"] >= TREE_LEVEL_TABLE[ #TREE_LEVEL_TABLE ]["NeedCount"]
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	-- 디펜스 이벤트 중이라서 처리하지않음
	if MemBlock["BonusDefenceEvent"]["IsProgress"] == true
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if cInvenItemDestroy( PlyHandle, TREE_CAST_ITEM, 1 ) == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_ErrMsg_DecoFail )
		return
	end


	cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_Deco05 )

	Var["Count"] = Var["Count"] + 1

	-- ※ 게임로그
	-- 유저가 대형나무에 트리장식 1개 사용함
	cSendGameLogDataType_5( NC_LOG_GAME_CHRISTMAS_DECO_TRY_BIG_TREE, 0, 0, 0 )

	local NextLevData = TREE_LEVEL_TABLE[ Var["Level"]+1 ]

	if Var["Count"] >= NextLevData["NeedCount"]
	then
		cAnimate( NPCHandle, "start", NextLevData["AniIndex"] )
		cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, NextLevData["Notice"] )

		Var["Level"] = Var["Level"] + 1
	end

	if Var["Level"] >= #TREE_LEVEL_TABLE
	then
		if NextLevData["LevDwnKeep"] == nil
		then
			Var["LevDwnKeep"] = cCurrentSecond() + 0.5
		else
			Var["LevDwnKeep"] = cCurrentSecond() + NextLevData["LevDwnKeep"]
		end
	end

	--------------------------
	--local CurX, CurY = cObjectLocate( Var["Handle"] )
	--cEffectRegen_XY( Var["MapIndex"], "LightShield", CurX, CurY, 0, 4, 0, 1000 )
	--------------------------

end



--------------------------------------------------------------------
--// 소형나무 처리
--------------------------------------------------------------------

-- 소형나무 처리 함수
function SmallTreeProcess( Var )
cExecCheck( "SmallTreeProcess" )

	if Var == nil
	then
		return
	end

	if Var["MapIndex"] == nil
	then
		return
	end

	if Var["Handle"] == nil
	then
		return
	end

	if Var["SmallTreeList"] == nil
	then
		Var["SmallTreeList"] = {}
	end


	for i = 1, #SMALL_TREE_INFO
	do
		if Var["SmallTreeList"][i] == nil
		then
			Var["SmallTreeList"][i]	= {}

			local CurTree = Var["SmallTreeList"][i]

			-- 소형나무 리젠
			CurTree["Handle"] = cMobRegen_XY( Var["MapIndex"], SMALL_TREE_INFO[i]["MobIndex"], SMALL_TREE_INFO[i]["RegenX"], SMALL_TREE_INFO[i]["RegenY"], SMALL_TREE_INFO[i]["Dir"] )

			if CurTree["Handle"] ~= nil
			then
				-- 무적상태이상 제거
				cResetAbstate( CurTree["Handle"], IMMORTAL_INDEX )

				-- 스크립트 세팅 및 필요정보 세팅
				if cAIScriptSet( CurTree["Handle"], Var["Handle"] ) ~= nil
				then
					cAIScriptFunc( CurTree["Handle"], "Entrance", "SmallTreeRoutine" )
					cAIScriptFunc( CurTree["Handle"], "NPCClick", "SmallTreeClick" )
					cAIScriptFunc( CurTree["Handle"], "NPCMenu",  "SmallTreeCastingComplete" )

					-- 소형나무쪽에서 필요한 정보
					MemBlock[CurTree["Handle"]]					= {}
					MemBlock[CurTree["Handle"]]["MasterHandle"]	= Var["Handle"]
					MemBlock[CurTree["Handle"]]["MasterMobID"]	= cGetMobID( Var["Handle"] )
					MemBlock[CurTree["Handle"]]["Handle"]		= CurTree["Handle"]
					MemBlock[CurTree["Handle"]]["MapIndex"]		= Var["MapIndex"]
					MemBlock[CurTree["Handle"]]["CurSec"]		= Var["CurSec"]
					MemBlock[CurTree["Handle"]]["NextTick"]		= Var["CurSec"]
					MemBlock[CurTree["Handle"]]["Level"]		= 0
					MemBlock[CurTree["Handle"]]["Count"]		= 0
					MemBlock[CurTree["Handle"]]["DataIndex"]	= i

					-- 메인에서 소형나무 체크하기 위한 정보
					CurTree["MobID"]	= cGetMobID( CurTree["Handle"] )
					CurTree["RegenX"],
					CurTree["RegenY"]	= cObjectLocate( CurTree["Handle"] )
				end
			end
		end

		if Var["SmallTreeList"][i] ~= nil
		then

			if SmallTreeValidCheck( Var["SmallTreeList"][i] ) == false
			then
				Var["SmallTreeList"][i] = nil
			end
		end
	end

end


-- 소형나무 유효성 체크(메인쪽에서 소형나무가 존재하는지 확인)
function SmallTreeValidCheck( Var )
cExecCheck( "SmallTreeValidCheck" )

	-- 기본 정보들 확인
	if Var == nil
	then
		return false
	end

	if Var["Handle"] == nil
	then
		return false
	end

	if Var["MobID"] == nil
	then
		return false
	end

	if Var["RegenX"] == nil or Var["RegenY"] == nil
	then
		return false
	end

	-- 죽었나 확인
	if cIsObjectDead( Var["Handle"] ) == 1
	then
		return false
	end

	-- 리젠시킨 몹아이디와 맞는지 확인
	local MobID = cGetMobID( Var["Handle"] )
	if MobID == nil
	then
		return false
	end

	if MobID ~= Var["MobID"]
	then
		return false
	end

	-- 리젠좌표확인
	local CurX, CurY = cObjectLocate( Var["Handle"] )
	if CurX == nil or CurY == nil
	then
		return false
	end

	if CurX ~= Var["RegenX"] or CurY ~= Var["RegenY"]
	then
		return false
	end


	return true

end


-- 소형나무 루틴
function SmallTreeRoutine( Handle, MapIndex )
cExecCheck( "SmallTreeRoutine" )

	local Var		= MemBlock[Handle]
	local CurSec	= cCurrentSecond()

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) == 1
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	end

	-- 0.1초마다 처리
	if Var["NextTick"] <= CurSec
	then
		Var["CurSec"]	= CurSec
		Var["NextTick"]	= Var["NextTick"] + 0.1
	else
		return ReturnAI["END"]
	end

	-- 마스터 존재 확인
	if MainTreeValidCheck( Var ) == false
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	end


	-- SmallTreeCastingComplete 에서 최대레벨 될때 세팅됨
	if Var["MaxLevelKeep"] ~= nil
	then
		-- 유지 시간 지나면
		if Var["MaxLevelKeep"] <= Var["CurSec"]
		then
			-- 애니메이션 원상태로
			cAnimate( Handle, "stop" )

			-- 레벨과 카운트 초기화
			Var["Level"]		= 0
			Var["Count"]		= 0

			Var["MaxLevelKeep"]	= nil
		end
	end


	return ReturnAI["END"]

end


-- 마스터 유효성 체크(소형나무 루틴쪽에서 마스터가 있는지 확인)
function MainTreeValidCheck( Var )
cExecCheck( "MainTreeValidCheck" )

	-- 기본 정보 확인
	if Var == nil
	then
		return false
	end

	if Var["MasterHandle"] == nil
	then
		return false
	end

	if Var["MasterMobID"] == nil
	then
		return false
	end

	-- 죽었나 확인
	if cIsObjectDead( Var["MasterHandle"] ) == 1
	then
		return false
	end

	-- 리젠시킨 몹아이디와 맞는지 확인
	local MobID = cGetMobID( Var["MasterHandle"] )
	if MobID == nil
	then
		return false
	end

	if MobID ~= Var["MasterMobID"]
	then
		return false
	end


	return true

end


-- 소형나무 클릭 처리
function SmallTreeClick( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "SmallTreeClick" )

	local Var = MemBlock[NPCHandle]

	if Var == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Level"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Count"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["DataIndex"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	local LevelData = SMALL_TREE_LEVEL_TABLE

	if LevelData == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if #LevelData == 0
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Count"] >= LevelData[ #LevelData ]["NeedCount"]
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if cIsNoAttacOrNoMove( PlyHandle ) == 1
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail_2 )
		return
	end


	cCastingBar( PlyHandle, NPCHandle, TREE_CAST_TIME, TREE_CAST_ANI )

end


-- 소형나무 캐스팅 완료 처리
function SmallTreeCastingComplete( NPCHandle, PlyHandle, RegistNumber, Menu )
cExecCheck( "SmallTreeCastingComplete" )

	local Var = MemBlock[NPCHandle]

	if Var == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Level"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Count"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["DataIndex"] == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	local LevelData = SMALL_TREE_LEVEL_TABLE

	if LevelData == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if #LevelData == 0
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Level"] >= #LevelData
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if Var["Count"] >= LevelData[ #LevelData ]["NeedCount"]
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_SysMsg_DecoFail )
		return
	end

	if cInvenItemDestroy( PlyHandle, TREE_CAST_ITEM, 1 ) == nil
	then
		cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, E_X_ErrMsg_DecoFail )
		return
	end


	cSystemMessage_Obj( PlyHandle, SCRIPT_FILE_NAME, SMALL_TREE_INFO[ Var["DataIndex"] ]["CastSuccMsg"] )


	Var["Count"] = Var["Count"] + 1

	-- ※ 게임로그 남길 부분
	-- 유저가 소형나무에 트리장식 1개 사용함
	cSendGameLogDataType_5( NC_LOG_GAME_CHRISTMAS_DECO_TRY_SMALL_TREE, 0, cGetMobID(NPCHandle), 0 )

	local NextLevData = LevelData[ Var["Level"]+1 ]

	if Var["Count"] >= NextLevData["NeedCount"]
	then
		cAnimate( NPCHandle, "start", NextLevData["AniIndex"] )

		Var["Level"] = Var["Level"] + 1
	end

	if Var["Level"] >= #LevelData
	then

	-- ※ 게임로그
	-- 소형 트리 완성 횟수(소형트리 4종)
	cSendGameLogDataType_5( NC_LOG_GAME_CHRISTMAS_DECO_COMPLETE_SMALL_TREE, 0, cGetMobID(NPCHandle), 0 )
		local RewardData = REWARD_ABSTATE_TABLE[ SMALL_TREE_INFO[ Var["DataIndex"] ]["RewardAbstate"] ]

		if RewardData ~= nil
		then
			cSetAbstate_Range( NPCHandle, RewardData["Range"], ObjectType["Player"], RewardData["AbstateIndex"], RewardData["Strength"], RewardData["KeepTime"] )
			cNotice( Var["MapIndex"], SCRIPT_FILE_NAME, RewardData["Notice"] )
		end

		if LevelData["MaxLevelKeep"] == nil
		then
			Var["MaxLevelKeep"] = cCurrentSecond() + 1
		else
			Var["MaxLevelKeep"] = cCurrentSecond() + LevelData["MaxLevelKeep"]
		end
	end

	--------------------------
	--local CurX, CurY = cObjectLocate( Var["Handle"] )
	--cEffectRegen_XY( Var["MapIndex"], "LightShield", CurX, CurY, 0, 4, 0, 1000 )
	--------------------------

end



--------------------------------------------------------------------
--// 눈사람 처리
--------------------------------------------------------------------

-- 눈사람 처리 함수
function SnowManProcess( Var )
cExecCheck( "SnowManProcess" )

	if Var == nil
	then
		return
	end

	if Var["SnowManList"] == nil
	then
		Var["SnowManList"] = {}
	end

	for i = 1, #SNOWMAN_INFO
	do
		if Var["SnowManList"][i] == nil
		then
			Var["SnowManList"][i] = Var["CurSec"] + cRandomInt( SNOWMAN_INFO[i]["LifeTime_Min"], SNOWMAN_INFO[i]["LifeTime_Max"] )

			-- 눈사람 리젠
			local MobHandle = cMobRegen_Circle( Var["MapIndex"], SNOWMAN_INFO[i]["MobIndex"], SNOWMAN_INFO[i]["CenterX"], SNOWMAN_INFO[i]["CenterY"], SNOWMAN_INFO[i]["Range"] )

			if MobHandle ~= nil
			then
				-- 무적상태이상 제거
				cResetAbstate( MobHandle, IMMORTAL_INDEX )

				-- 스크립트 세팅 및 필요정보 세팅
				if cAIScriptSet( MobHandle, Var["Handle"] ) ~= nil
				then
					cAIScriptFunc( MobHandle, "Entrance", "SnowManRoutine" )

					MemBlock[MobHandle]				= {}
					MemBlock[MobHandle]["Handle"]	= MobHandle
					MemBlock[MobHandle]["MapIndex"]	= Var["MapIndex"]
					MemBlock[MobHandle]["CurSec"]	= Var["CurSec"]
					MemBlock[MobHandle]["NextTick"]	= Var["CurSec"]
					MemBlock[MobHandle]["LifeTime"]	= Var["SnowManList"][i]
					MemBlock[MobHandle]["RegenX"],
					MemBlock[MobHandle]["RegenY"]	= cObjectLocate( MobHandle )
					MemBlock[MobHandle]["DropTable"]= ITEM_DROP_TABLE[ SNOWMAN_INFO[i]["DropTable"] ]
				end
			end
		end

		if Var["SnowManList"][i] + 0.5 <= Var["CurSec"]
		then
			Var["SnowManList"][i] = nil
		end
	end

end

-- 눈사람 루틴
function SnowManRoutine( Handle, MapIndex )
cExecCheck( "SnowManRoutine" )

	local Var		= MemBlock[Handle]
	local CurSec	= cCurrentSecond()

	if Var == nil
	then
		cAIScriptSet( Handle )

		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) == 1
	then
		cAIScriptSet( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	end

	-- 0.1초마다 처리
	if Var["NextTick"] <= CurSec
	then
		Var["CurSec"]	= CurSec
		Var["NextTick"]	= Var["NextTick"] + 0.1
	else
		return ReturnAI["END"]
	end


	-- 크러쉬볼 상태이상 시간이 짧아 체크가 제대로 안되서 좌표로 체크
	local CurX, CurY = cObjectLocate( Handle )
	if CurX == nil or CurY == nil or Var["RegenX"] == nil or Var["RegenY"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	else
		if CurX ~= Var["RegenX"] or CurY ~= Var["RegenY"]
		then
			-- 아이템 드랍
			if Var["DropTable"] ~= nil
			then
				for j = 1, #Var["DropTable"]
				do
					cDropItem( Var["DropTable"][j]["ItemIndex"], Handle, -1, Var["DropTable"][j]["Rate"] )
				end
			end

			-- 몹 죽이고 메모리 해제
			cAIScriptSet( Handle )
			cKillObject( Handle )
			MemBlock[Handle] = nil

			return ReturnAI["END"]
		end
	end

	-- 라이프 시간이 지났으면 몹 제거
	if Var["LifeTime"] <= Var["CurSec"]
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]
	end


	return ReturnAI["END"]

end

--------------------------------------------------------------------
--// 산타깨빙 처리 : SantaKebingRegenProcess
--------------------------------------------------------------------

function SantaKebingRegenProcess( Var )
cExecCheck ( "SantaKebingRegenProcess" )

	if Var == nil
	then
		return
	end

	-- 디펜스이벤트 처리중 아니면 return
	if MemBlock["BonusDefenceEvent"]["IsProgress"] == false
	then
		return
	end

	if MemBlock["SantaKebingList"] == nil and MemBlock["SantaKebingListHandle"] == nil
	then
		MemBlock["SantaKebingList"] 		= {}
		MemBlock["SantaKebingListHandle"] 	= {}


		for i = 1, #SANTA_KEBING_MOB_REGEN_TABLE
		do
			local temphandle	= cMobRegen_XY( Var["MapIndex"], SANTA_KEBING_MOB_REGEN_TABLE["MobIndex"], SANTA_KEBING_MOB_REGEN_TABLE[i]["RegenX"],
								SANTA_KEBING_MOB_REGEN_TABLE[i]["RegenY"], SANTA_KEBING_MOB_REGEN_TABLE[i]["Dir"] )

			if temphandle == nil
			then
				return
			end

			if MemBlock["SantaKebingList"][temphandle] == nil
			then
				MemBlock["SantaKebingList"][temphandle]	= {}

				if cAIScriptSet( temphandle, Var["Handle"] ) ~= nil
				then
					cAIScriptFunc( temphandle, "Entrance", "SantaKebingRoutine" )
				end

				MemBlock["SantaKebingList"][temphandle]["Handle"]				= temphandle
				MemBlock["SantaKebingList"][temphandle]["RunSpeed"]				= SANTA_KEBING_MOB_REGEN_TABLE["RunSpeed"]
				MemBlock["SantaKebingList"][temphandle]["TargetHandle"]			= Var["Handle"]
				MemBlock["SantaKebingList"][temphandle]["GoalX"],
				MemBlock["SantaKebingList"][temphandle]["GoalY"]				= cObjectLocate( Var["Handle"] )
				MemBlock["SantaKebingList"][temphandle]["CrushBallHitCount"]	= 0
				MemBlock["SantaKebingList"][temphandle]["PathFinding"]			= SANTA_KEBING_PATH_TABLE[i]
				MemBlock["SantaKebingListHandle"][i] = temphandle

				-- 산타깨빙 몹챗( 지난번처럼 당할거라고 생각하지마라!! )
				cMobChat( temphandle, SCRIPT_FILE_NAME, E_XKebingChat01 )

				-- 몹리젠시 걸려있는 무적 상태이상 제거
				cResetAbstate( temphandle , "StaImmortal" )
			end
		end
	end

end

--------------------------------------------------------------------
--// 산타깨빙 처리 : SantaKebingRoutine
--------------------------------------------------------------------
function SantaKebingRoutine( Handle, MapIndex )
cExecCheck ( "SantaKebingRoutine" )

	if MapIndex ~= VALID_MAP_INDEX
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) == 1
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	local CurSantaKebing	= MemBlock["SantaKebingList"][Handle]

	-- 루틴에서 계속 돌면서, 길찾기 프로세스 실행
	PathTypeProcess( Handle )

	-- 메인트리랑 가까우면 처리해준다
	if cDistanceSquar( Handle, CurSantaKebing["TargetHandle"] ) <= ( SANTAKEBING_RANGE_WITH_TREE * SANTAKEBING_RANGE_WITH_TREE )
	then

		-- 깨빙 애니메이션 처리( 스킬애니가 두개로 나뉘어져 있어, 시간체크해서 연달아 사용 )
		if MemBlock["SantaKebingList"][Handle]["CrushAniTime"] == nil
		then
			MemBlock["SantaKebingList"][Handle]["CrushAniTime"] = cCurrentSecond() + SANTA_KEBING_MOB_ANI_TABLE["CastAniKeepTime"]
			cAnimate( Handle, "start", SANTA_KEBING_MOB_ANI_TABLE["CastAniIndex"] )
		end

		if MemBlock["SantaKebingList"][Handle]["CrushAniTime"] ~= nil
		then
			if MemBlock["SantaKebingList"][Handle]["CrushAniTime"] > cCurrentSecond()
			then
				return ReturnAI["CPP"]
			end

			cAnimate( Handle, "start", SANTA_KEBING_MOB_ANI_TABLE["SwingAniIndex"] )
		end

		MemBlock["BonusDefenceEvent"]["IsSantaKebingCrush"] = true

		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	-- 크러시볼에 몇번 맞았는지 체크한다
	if CurSantaKebing["CrushBallHitCount"] >= SANTAKEBING_CRUSHBALL_HIT_COUNT
	then
		cMobSuicide( MapIndex, Handle )

		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	return ReturnAI["END"]
end


--------------------------------------------------------------------
--// 산타깨빙 처리 : IsSantaKebingAllDead
--------------------------------------------------------------------
-- 대형깨빙(산타깨빙) 모두 죽었는지 판단
function IsSantaKebingAllDead( Var )
cExecCheck( "IsSantaKebingAllDead" )

	if MemBlock["SantaKebingList"] == nil
	then
		return false
	end

	for i = 1, #MemBlock["SantaKebingListHandle"] do
		if cIsObjectDead( MemBlock["SantaKebingListHandle"][i] ) == nil
		then
			return false	-- 한놈이라도 살아있으면 false반환
		end

		if i == #MemBlock["SantaKebingListHandle"]
		then
			return true	-- 모두 다 죽었으면 true 반환
		end
	end
end

--------------------------------------------------------------------
--// 산타깨빙 처리 : SantaKebingVanishAll
--------------------------------------------------------------------
-- 산타 깨빙 제거
function SantaKebingVanishAll( Var )
cExecCheck( "SantaKebingVanishAll" )

	if Var == nil
	then
		return
	end

	if MemBlock["SantaKebingList"] == nil
	then
		return
	end

	for i = 1, #MemBlock["SantaKebingListHandle"]
	do
		local CurHandle = MemBlock["SantaKebingListHandle"][i]

		if MemBlock["SantaKebingList"][CurHandle] ~= nil
		then
			cNPCVanish( MemBlock["SantaKebingList"][CurHandle]["Handle"] )
			MemBlock["SantaKebingList"][CurHandle] = nil
		end
	end
end


--------------------------------------------------------------------
--// 산타깨빙 path처리 : PathTypeProcess
--------------------------------------------------------------------
function PathTypeProcess( Handle )

	local CurSantaKebing	= MemBlock["SantaKebingList"][Handle]

	if cIsObjectDead( Handle ) == 1
	then
		return
	end

	if CurSantaKebing == nil
	then
		return
	end

	if CurSantaKebing["PathFinding"] == nil
	then
		return
	end

	-- 이미 충돌 처리 중이므로, return
	if CurSantaKebing["CrushAniTime"] ~= nil
	then
		return
	end

	if MemBlock["SantaKebingList"][Handle]["PathProgress"] == nil
	then

		MemBlock["SantaKebingList"][Handle]["PathProgress"] = {}

		MemBlock["SantaKebingList"][Handle]["PathProgress"]["GoalCheckTime"] = cCurrentSecond()
		MemBlock["SantaKebingList"][Handle]["PathProgress"]["CurPathStep"]   = 1
		MemBlock["SantaKebingList"][Handle]["PathProgress"]["CurMoveState"]  = MOVESTATE["STOP"]

	end

	if CurSantaKebing["PathProgress"]["CurPathStep"] > #CurSantaKebing["PathFinding"]
	then
		return
	end


	if CurSantaKebing["PathProgress"]["CurMoveState"] == MOVESTATE["STOP"]
	then

		if cWillMovement( Handle ) == nil
		then
			return
		end

		cRunTo( Handle,
				CurSantaKebing["PathFinding"][CurSantaKebing["PathProgress"]["CurPathStep"]]["x"],
				CurSantaKebing["PathFinding"][CurSantaKebing["PathProgress"]["CurPathStep"]]["y"],
				SANTA_KEBING_MOB_REGEN_TABLE["RunSpeed"] )

		CurSantaKebing["PathProgress"]["CurMoveState"] = MOVESTATE["MOVE"]

	end


	if CurSantaKebing["PathProgress"]["CurMoveState"] == MOVESTATE["MOVE"]
	then

		-- 움직일 수 없는 상태
		if cWillMovement( Handle ) == nil
		then
			CurSantaKebing["PathProgress"]["CurMoveState"] = MOVESTATE["STOP"]
			return
		end

	end

	-- 목표점 체크 제한
	local CurSec = cCurrentSecond()

	if CurSantaKebing["PathProgress"]["GoalCheckTime"] + PATHTYPE_CHK_DLY > CurSec
	then
		return
	end

	CurSantaKebing["PathProgress"]["GoalCheckTime"] = CurSec


	-- 목표점 체크
	local curr = {}
	local goal = {}

	curr["x"], curr["y"] 	= cObjectLocate( Handle )
	goal["x"]            	= CurSantaKebing["PathFinding"][CurSantaKebing["PathProgress"]["CurPathStep"]]["x"]
	goal["y"] 				= CurSantaKebing["PathFinding"][CurSantaKebing["PathProgress"]["CurPathStep"]]["y"]



	local dx = goal["x"] - curr["x"]
	local dy = goal["y"] - curr["y"]
	local distsquar = dx * dx + dy * dy

	if distsquar < PATHTYPE_GAP then


		CurSantaKebing["PathProgress"]["CurPathStep"]	= CurSantaKebing["PathProgress"]["CurPathStep"] + 1
		CurSantaKebing["PathProgress"]["CurMoveState"]	= MOVESTATE["STOP"]

		return

	end

	-- 몹이 이동 멈추는 현상 때문에 목적지 체크
	curr["x"], curr["y"] = cMove2Where( Handle )

	if curr["x"] ~= goal["x"] and curr["y"] ~= goal["y"] then

		cRunTo( Handle,
				CurSantaKebing["PathFinding"][CurSantaKebing["PathProgress"]["CurPathStep"]]["x"],
				CurSantaKebing["PathFinding"][CurSantaKebing["PathProgress"]["CurPathStep"]]["y"],
				SANTA_KEBING_MOB_REGEN_TABLE["RunSpeed"] )
	end

	return

end



--------------------------------------------------------------------
--// 크러시볼 처리 : ServantSummon
--------------------------------------------------------------------
-- 크러시볼에 붙을 함수
function ServantSummon( MapIndex, ServantHandle, ServantIndex, MasterHandle )
cExecCheck "ServantSummon"

	-- 잘못된 맵 정보
	if MapIndex ~= VALID_MAP_INDEX
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	-- 현재 디펜스이벤트 작동중이 아닌경우 리턴해
	if MemBlock["BonusDefenceEvent"]["IsProgress"] ~= true
	then
		return
	end

	-- 소환한 몹이 크러시볼 아닌경우,
	if ServantIndex ~= CRUSHBALL_TABLE["MobIndex"]
	then
		return
	end

	cAIScriptSet( ServantHandle, MemBlock["TreeHandle"] )
	cAIScriptFunc( ServantHandle, "Entrance",  "Crushball_Entrance" )
end


--------------------------------------------------------------------
--// 크러시볼 처리 : Crushball_Entrance
--------------------------------------------------------------------
function Crushball_Entrance( Handle, MapIndex )
cExecCheck "Crushball_Entrance"

	-- 잘못된 맵 정보
	if MapIndex ~= VALID_MAP_INDEX
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	-- 산타깨빙 정보없으면 처리할 필요없으므로
	if MemBlock["SantaKebingList"] == nil
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	-- 죽었으면 스크립트 해제
	if cIsObjectDead( Handle ) == 1
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	-- 죽음 대기면 스크립트 해제
	if cIsObjectAlreadyDead( Handle ) == true
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	local NearSanta = cObjectFind( Handle, SANTAKEBING_RANGE_WITH_CRUSHBALL, SANTA_KEBING_MOB_REGEN_TABLE["MobIndex"], "so_mobile_GetIdxName" )

	-- 목표로 삼은 산타깨빙이 이미 죽었거나, 죽음 예약인 경우 스크립트 해제
	-- 산타깨빙이 이미 죽었다면, 그 근처에 있는 다른 대상에게 기본 크러시볼 스킬이 적용되야 하므로

	if NearSanta ~= nil
	then

		if cIsObjectDead( NearSanta ) == 1 or cIsObjectAlreadyDead( NearSanta ) == true
		then
			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end

		-- 확률적으로 산타깨빙에 넉백 상태이상을 걸어준다.
		if cPermileRate( CRUSHBALL_ABSTATE_TABLE["AbStateHitRate"] ) == 1
		then
			cSetAbstate( NearSanta, CRUSHBALL_ABSTATE_TABLE["AbstateIndex"], CRUSHBALL_ABSTATE_TABLE["Strength"], CRUSHBALL_ABSTATE_TABLE["KeepTime"], Handle )
		end

		MemBlock["SantaKebingList"][NearSanta]["CrushBallHitCount"]		= MemBlock["SantaKebingList"][NearSanta]["CrushBallHitCount"] + 1
		--DebugLog("산타깨빙핸들값 : "..NearSanta..", 맞은 크러시볼 : "..MemBlock["SantaKebingList"][NearSanta]["CrushBallHitCount"])
		cSkillBlast		( Handle, Handle, CRUSHBALL_TABLE["SkillIndex"] )
		cVanishReserv	( Handle, 3 )

		return ReturnAI["END"]
	end

	-- 아직 움직이고 있다면 처음으로 돌아간다.
	if cGetMoveState( Handle ) ~= 0
	then
		return ReturnAI["CPP"]
	end

	return ReturnAI["END"]

end


----------------------------------------------------------------------
-- Log Functions
----------------------------------------------------------------------

function DebugLog( String )
cExecCheck ( "DebugLog" )

	if String == nil
	then
		cAssertLog( "DebugLog::String == nil" )
		return
	end
	cAssertLog( "Debug - "..String )
end


function ErrorLog( String )
cExecCheck ( "ErrorLog" )

	if String == nil
	then
		cAssertLog( "ErrorLog::String == nil" )
		return
	end
	cAssertLog( "Error - "..String )
end
