------------------------------------------------------------------------------------------
--                                킹덤 퀘스트 데이터                                    --
------------------------------------------------------------------------------------------

KQ_SCRIPT_NAME			= "KQ/KDSpring/KDSpring"		-- 스크립트 이름
KQ_MAX_PLAYER			= 10							-- 최대 접속 인원 ( 접속자 수가 KQ_PLAYER_MAX 를 채웠을 경우, 대기 시간 없이 바로 시작으로 넘어간다. )
KQ_PLAYER_PICK_DELAY	= 2								-- 플레이어가 맵에 접속했을때 일정 시간 동안 깃발을 획득 할 수 없도록 딜레이시간 설정
KQ_INVALID_HANDLE		= -1							-- 유효하지않은 핸들

-- 킹덤 퀘스트가 끝나고 돌아갈 마을 정보
KQ_RETURN_MAP =
{

	-- 로컬 버전
	KRM_INDEX	= 'Gate',
	KRM_X		= 1487,
	KRM_Y		= 1517,
}

-- 맵 로그인시 걸어줄 상태이상
KQ_MAPLOGIN_ABSTATE =
{
	KMA_INDEX 		= "StaKQSpUpRateBuff",
	KMA_STR 		= 1,
	KMA_KEEPTIME 	= 1200000,
}

-- 시간 종료 후 잠시 멈춤 상태이상
KQ_STUN_ABSTATE =
{
	KSA_INDEX 		= "StaAdlFStun",
	KSA_STR 		= 1,
	KSA_KEEPTIME 	= 3500,
}


-- 게임 타입
KQ_GAME_TYEP =
{
	KGT_NORMAL		= 1,						-- 일반
	KGT_EXTRATIME	= 2,						-- 연장전
}


-- 킹덤 퀘스트 결과
KQ_RESULT =
{
			---------------------------------------------------------------------------------------------
			--  킹퀘 보상 인덱스,					이모션 ID, 			이펙트 메시지 타입( common.lua 에 정의되어 있음 )
			---------------------------------------------------------------------------------------------
	KR_WIN	= {	KRE_REWAED = "REW_KQ_SPRING_WIN",	KRE_EMOTICON = 14,	KRE_EFFECT_MSG = EFFECT_MSG_TYPE["EMT_WIN"] 	},
	KR_LOSE	= { KRE_REWAED = "REW_KQ_SPRING_LOSE",	KRE_EMOTICON = 10,	KRE_EFFECT_MSG = EFFECT_MSG_TYPE["EMT_LOSE"] 	},
	KR_DRAW	= { KRE_REWAED = "REW_KQ_SPRING_DRAW",	KRE_EMOTICON = 16,	KRE_EFFECT_MSG = EFFECT_MSG_TYPE["EMT_DRAW"]	},
}


-- 문
KQ_DOOR =
{
  ---------------------------------------------------------------------------------------------------------------------------
  --  몹 인덱스,					도어 블럭 인덱스,		좌표 X,			좌표 Y,			방향,			크기
  ---------------------------------------------------------------------------------------------------------------------------
	{ KD_INDEX = "KQSpringDoor",	KD_BLOCK = "Door01",	KD_X = 1366,	KD_Y = 3264,	KD_DIR = 80,	KD_SCALE = 1000 },
	{ KD_INDEX = "KQSpringDoor",	KD_BLOCK = "Door02",	KD_X = 1471,	KD_Y = 2061,	KD_DIR = 85,	KD_SCALE = 1000 },
}


-- NPC
KQ_NPC = { "KQSpring_Rman", "KQSpring_Bman" }


-- 아이템 몬스터
KQ_ITEM_MOB =
{
  ----------------------------------------------------------------------------------------------
  --  몹 인덱스,				좌표 X,			좌표 Y,			방향,			리젠 간격(초)
  ----------------------------------------------------------------------------------------------
	{ KIM_INDEX = "SpUpShoes",	KIM_X = 1819,	KIM_Y = 3244,	KIM_DIR = 0,	KIM_REGEN_TICK = 60 },
	{ KIM_INDEX = "SpUpShoes",	KIM_X = 1898,	KIM_Y = 2238,	KIM_DIR = 0,	KIM_REGEN_TICK = 60 },
}


-- 팀 데이터
KQ_MAX_TEAM_MEMBER			= (KQ_MAX_PLAYER / 2)	-- 팀원 최대 인원
KQ_TEAM_POINT_CHECK_DIST 	= 75					-- 득점 포인트 체크 거리

KQ_TEAM_NO =									-- 팀 번호
{
	KTN_DEFAULT	= 0,
	KTN_RED		= 1,							-- 레드팀
	KTN_BLUE	= 2,							-- 블루팀
}

KQ_TEAM =
{
  -------------------------------------------------------------------------------------------------------------------------------------------
  --  팀 포인트 몹 인덱스,			팀 포인트 좌표 X	팀 포인트 좌표 Y,	팀 유니폼 아이템 인덱스
  -------------------------------------------------------------------------------------------------------------------------------------------
	{ KT_POINT_INDEX = "RedPoint",	KT_POINT_X = 764,	KT_POINT_Y = 3542,	KT_UNIFORM = { "Menian_RedA", "Menian_RedP", "Menian_RedS" } },
	{ KT_POINT_INDEX = "BluePoint",	KT_POINT_X = 940,	KT_POINT_Y = 1798,	KT_UNIFORM = { "Menian_BlueA", "Menian_BlueP", "Menian_BlueS" } },
}


-- 깃발 데이터
KQ_FLAG_ICON = "MobChrLocFlag"

KQ_FLAG =										-- 깃발
{
	KF_INDEX		= "FiestaFlag",				-- 깃발 몹 인덱스
	KF_CHECK_DIST	= 10,						-- 깃발 체크 거리
	KF_PICK_DELAY	= 2,						-- 깃발 소환 후 Pick 할 수 있기까지 시간(1초 후 획득 가능)
}

KQ_FLAG_POINT =									-- 깃발 포인트
{
	KFP_INDEX 		= "FlagPoint",				-- 깃발 포인트 몹 인덱스
	KFP_CHECK_DIST	= 75,						-- 깃발 포인트 체크 거리
	KFP_X			= 3653,						-- 좌표 X
	KFP_Y			= 2942,						-- 좌표 Y
	KFP_DIR			= 0,						-- 방향
	KFP_REGEN_TIME	= 5,						-- 득점 후 리젠 시간(5초 후)
}

KQ_FLAG_ABSTATE =								-- 깃발 상태이상
{
  -----------------------------------------------------------------------------------------------------------------------------
  --  상태이상 인덱스,					상태이상 강도,	상태이상 지속 시간(1/1000초)
  -----------------------------------------------------------------------------------------------------------------------------
	{ KFA_INDEX = "StaKQSpringSlow",	KFA_STR = 1, 	KFA_KEEPTIME = 1200000, },
	{ KFA_INDEX = "StaKQSpringArrow",	KFA_STR = 1, 	KFA_KEEPTIME = 1200000, },
}

KQ_FLAG_SCRIPT_MSG =							-- 깃발 관련 스크립트 메시지
{
	KFSM_HAVE 		= "KQSpring_Have_Flag",
	KFSM_DROP 		= "KQSpring_Drop_Flag",
	KFSM_REGEN01 	= "KQSpring_FlagRegen01",
	KFSM_REGEN02 	= "KQSpring_FlagRegen02",
	KFSM_POINT_RED 	= "KQSpring_Point_Red",
	KFSM_POINT_BLUE = "KQSpring_Point_Blue",
}


-- 스크립트 메시지
KQ_MSG_TYPE =
{
	KMT_SHN = 1,
	KMT_TXT = 2,
}

KQ_MSG =
{
	KM_DIVIDE_TEAM =							-- 팀 나누기
	{
	  -----------------------------------------------------------------------------------------------------------------------------
	  --  메시지 타입,						파일 이름,					메시지 인덱스,						출력 시간(초),	인자
	  -----------------------------------------------------------------------------------------------------------------------------
		{ KM_TYPE = KQ_MSG_TYPE["KMT_SHN"],	KM_FILE_NAME = "",			KM_INDEX = "KQSpring_DivideTeam",	KM_TIME = 0,	KM_VAL = nil }
	},

	KM_START_WAIT =								-- 게임 시작 대기
	{
		{ KM_TYPE = KQ_MSG_TYPE["KMT_SHN"],	KM_FILE_NAME = "",			KM_INDEX = "KQSpring_KQStart",		KM_TIME = 30,	KM_VAL = "30" },
		{ KM_TYPE = KQ_MSG_TYPE["KMT_SHN"],	KM_FILE_NAME = "",			KM_INDEX = "KQSpring_KQStart",		KM_TIME = 20,	KM_VAL = "10" },
	},

	KM_GAME_TIME =									-- 게임 시간 종료
	{
		{ KM_TYPE = KQ_MSG_TYPE["KMT_SHN"],	KM_FILE_NAME = "",			KM_INDEX = "KQSpring_Timeover",		KM_TIME = 0,	KM_VAL = nil },
	},

	KM_EXTRA_TIME_WAIT =						-- 연장전 대기
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


-- 사운드
KQ_SOUND =
{
	KS_GETFLAG	= "KQSpringGetFlag",
	KS_GETPOINT	= "KQSpringGetPoint",
	KS_LOSEPOINT	= "KQSpringLosePoint",
}
