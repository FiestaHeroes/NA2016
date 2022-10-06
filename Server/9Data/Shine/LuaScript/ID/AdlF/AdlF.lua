require( "common" )
require( "ID/AdlF/AdlF_Loussier" )		-- 루시에 관련 스크립트
require( "ID/AdlF/AdlF_MagicStone" )	-- 비상작동마법석 관련 스크립트
require( "ID/AdlF/AdlF_Guarder" )		-- 경비병,마렌느 관련 스크립트
require( "ID/AdlF/AdlF_Gate" )			-- 게이트 관련 스크립트
require( "ID/AdlF/AdlF_Karen" )			-- 카렌 관련 스크립트
require( "ID/AdlF/AdlF_Zone1" )
require( "ID/AdlF/AdlF_Zone2" )
require( "ID/AdlF/AdlF_Zone3" )
require( "ID/AdlF/AdlF_Zone4" )


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- 스크립트 처리가 필요한 오브젝트들 리젠 정보
RegenInfo =
{
	-- 이동 게이트, ( 인덱스 수정시 AdlF_Gate.lua파일의 진입함수 수정 )
	-- 이동 위치는 AdlF_Gate.lua파일에서 cLinkTo 직접 수정
	ExitGate	= { Index = "Gate_ID_Complete",  x =  2208, y =  9966, dir =  48, Title = "Exit Gate", Yes = "Exit", No = "Cancel" },
	BossRoomGate= { Index = "Gate_ID_Exit",      x =  9412, y = 20075, dir =  48, Title = "Exit Gate", Yes = "Exit", No = "Cancel" },
	ExitBossGate= { Index = "Gate_ID_Exit",      x = 12924, y =  6373, dir =  48, Title = "Exit Gate", Yes = "Exit", No = "Cancel" },
	CompleteGate= { Index = "Gate_ID_Complete",  x = 12720, y =  8518, dir =  48, Title = "Exit Gate", Yes = "Exit", No = "Cancel" },

	-- 관문
	Door1    = { Index = "Barrier01", x =  3203, y =  18025, dir = 176, Block = "DoorBlock01", scale = 1000},
	Door2    = { Index = "Barrier02", x =  6144, y =  20229, dir = 270, Block = "DoorBlock02", scale = 1000},

	-- 어둠의돌
	DStone1  = { Index = "DStone",               x =  2040, y = 15921, dir =   0 },
	DStone2  = { Index = "DStone",               x =  5091, y = 18970, dir =   0 },
	DStone3  = { Index = "DStone",               x =  2026, y = 22448, dir =   0 },
	DStone4  = { Index = "DStone",               x =  3450, y = 20235, dir =   0 },

	-- 중간보스, 보스
	Salare   = { Index = "Salare",               x =  5159, y = 20960, dir =   0 },
	SalareMan= { Index = "SalareMan",                                            },

	Eglack   = { Index = "Eglack",               x = 12925, y =  9654, dir =   0 },
	EglackMad= { Index = "EglackMad",                                            },
	EglackMan= { Index = "EglackMan",                                            },

	-- 카렌
	Karen    = { Index = "AdlF_Karen",                                           },

	-- 비상작동마법석, 소환마법석
	MStoneA  = { Index = "EStone01",             x = 11654, y = 21809, dir =   0 },
	MStoneB  = { Index = "EStone02",             x = 11226, y = 18783, dir =   0 },
	MStoneC  = { Index = "EStone03",             x =  8359, y = 21779, dir =   0 },
	SStone   = { Index = "RStone",               x =  9934, y = 20479, dir =   0 },

	-- 루시에
	-- 평화상태시 HP가 회복되는 문제 때문에 HPRegen 추가
	Loussier = { Index = "AdlF_Loussier",        x =  4245, y = 10349, dir =   0, BossRoomLoc = { x = 12720, y = 8518, dir = 180}, HPRegen = 0 },

	-- 루시에 최초 이벤트 마렌느, 경비병
	Marlene  = { Index = "AdlF_Marlene",         x =  3620, y =  9549, dir =   0 },
	Guard1   = { Index = "AdlF_GuardAlber",      x =  3584, y =  9418, dir =   0 },
	Guard2   = { Index = "AdlF_GuardEstelle",    x =  3546, y =  9666, dir =   0 },

	-- 루시에 최초 이벤트 몹들. 타락한 창병, 타락한 격투가
	Zone1_Event =	{
						{ Index = "AdlF_Fspearman",       x =  4153, y = 10662, dir =  58 },
						{ Index = "AdlF_Fspearman",       x =  4153, y = 10662, dir =  58 },
						{ Index = "AdlF_Fspearman",       x =  4153, y = 10662, dir =  58 },
						{ Index = "AdlF_Fknuckleman",     x =  4525, y = 10391, dir =  58 },
						{ Index = "AdlF_Fknuckleman",     x =  4525, y = 10391, dir =  58 },
						{ Index = "AdlF_Fknuckleman",     x =  4525, y = 10391, dir =  58 },
						{ Index = "AdlF_Fknuckleman",     x =  4525, y = 10391, dir =  58 },
					},


	-- 1지역 리젠 그룹
	Zone1_Regen_Group =	{
							"AdlF_01_SP01",
							"AdlF_01_SP02",
							"AdlF_01_SP03",
							"AdlF_01_SP04",
							"AdlF_01_SP05",
							"AdlF_01_SP06",
							"AdlF_01_SP07",
							"AdlF_01_SP08",
							"AdlF_01_KN01",
							"AdlF_01_DL01",
							"AdlF_01_GU01",
							"AdlF_01_GU02",
							"AdlF_01_GU03",
							"AdlF_01_GU04",
						},
	Zone1_Regen_Franger =	{ -- AdlF_01_RA01, AdlF_01_RA02, AdlF_01_RA03
								{ Index = "AdlF_Franger", x =  4936, y = 15234, dir =   0 },
								{ Index = "AdlF_Franger", x =  4936, y = 15234, dir =   0 },
								{ Index = "AdlF_Franger", x =  4936, y = 15234, dir =   0 },
								{ Index = "AdlF_Franger", x =  3525, y = 16058, dir =   0 },
								{ Index = "AdlF_Franger", x =  3525, y = 16058, dir =   0 },
								{ Index = "AdlF_Franger", x =  3525, y = 16058, dir =   0 },
								{ Index = "AdlF_Franger", x =  2975, y = 16316, dir =   0 },
								{ Index = "AdlF_Franger", x =  2975, y = 16316, dir =   0 },
								{ Index = "AdlF_Franger", x =  2975, y = 16316, dir =   0 },
							},

	-- 2지역 리젠 그룹
	Zone2_Regen_Group =	{
							"AdlF_02_SP01",
							"AdlF_02_SP02",
							"AdlF_02_KN01",
							"AdlF_02_KN02",
							"AdlF_02_DL01",
							"AdlF_02_DL02",
							"AdlF_02_DL03",
						},

	Zone2_Regen_Franger =	{ -- AdlF_02_RA01, AdlF_02_RA02, AdlF_02_RA03, AdlF_02_RA04, AdlF_02_RA05, AdlF_02_RA06, AdlF_02_RA07
								{ Index = "AdlF_Franger", x =  1918, y = 19135, dir =   0 },
								{ Index = "AdlF_Franger", x =  1918, y = 19135, dir =   0 },
								{ Index = "AdlF_Franger", x =  1918, y = 19135, dir =   0 },
								{ Index = "AdlF_Franger", x =  2244, y = 19803, dir =   0 },
								{ Index = "AdlF_Franger", x =  2244, y = 19803, dir =   0 },
								{ Index = "AdlF_Franger", x =  2244, y = 19803, dir =   0 },
								{ Index = "AdlF_Franger", x =  1990, y = 20712, dir =   0 },
								{ Index = "AdlF_Franger", x =  1990, y = 20712, dir =   0 },
								{ Index = "AdlF_Franger", x =  1990, y = 20712, dir =   0 },
								{ Index = "AdlF_Franger", x =  1928, y = 21447, dir =   0 },
								{ Index = "AdlF_Franger", x =  1928, y = 21447, dir =   0 },
								{ Index = "AdlF_Franger", x =  1928, y = 21447, dir =   0 },
								{ Index = "AdlF_Franger", x =  5080, y = 22412, dir =   0 },
								{ Index = "AdlF_Franger", x =  5080, y = 22412, dir =   0 },
								{ Index = "AdlF_Franger", x =  5080, y = 22412, dir =   0 },
								{ Index = "AdlF_Franger", x =  5290, y = 21987, dir =   0 },
								{ Index = "AdlF_Franger", x =  5290, y = 21987, dir =   0 },
								{ Index = "AdlF_Franger", x =  5290, y = 21987, dir =   0 },
								{ Index = "AdlF_Franger", x =  5131, y = 21553, dir =   0 },
								{ Index = "AdlF_Franger", x =  5131, y = 21553, dir =   0 },
								{ Index = "AdlF_Franger", x =  5131, y = 21553, dir =   0 },
							},

	-- 3지역 리젠 그룹
	Zone3_Regen_Group =	{
							"AdlF_03_KN01",
							"AdlF_03_KN02",
							"AdlF_03_KN03",
						},
}


-- 대화 이벤트 관련 내용
DialogInfo =
{
	-- 루시에 죽을 때
	Loussier_Death =
	{
		{ Portrait = "AdlLoussier",   FileName = "AdlF", Index = "Loussier_Dead",     Delay = 2 },
	},

	Marlene_Death =
	{
		{ Portrait = "AdlMarlene",    FileName = "AdlF", Index = "Marlene_Dead",      Delay = 2 },
	},

	-- 루시에 구출 이벤트 발생시
	Loussier_Rescue_Event =
	{
		{ Portrait = "EldSpeGuard01", FileName = "AdlF", Index = "GuardAlber01_01",   Delay = 2 },
		{ Portrait = "AdlMarlene",    FileName = "AdlF", Index = "Marlene01_01",      Delay = 3 },
		{ Portrait = "EldSpeGuard01", FileName = "AdlF", Index = "GuardAlber01_02",   Delay = 2 },
	},

	-- 루시에 구출 이벤트 성공시
	Loussier_Rescue_Succ =
	{
		--보스끼리 대화
		{ Portrait = "Salare",        FileName = "AdlF", Index = "Salare01_S01",      Delay = 2 },
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack01_S01",      Delay = 2 },
		{ Portrait = "Salare",        FileName = "AdlF", Index = "Salare01_S02",      Delay = 2 },
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack01_S02",      Delay = 4 },
		--엔피씨 대화
		{ Portrait = "AdlMarlene",    FileName = "AdlF", Index = "Marlene01_S01",     Delay = 2 },
		{ Portrait = "AdlLoussier",   FileName = "AdlF", Index = "Loussier01_S01",    Delay = 2 },
		{ Portrait = "EldSpeGuard01", FileName = "AdlF", Index = "GuardAlber01_S01",  Delay = 2 },
		{ Portrait = "AdlLoussier",   FileName = "AdlF", Index = "Loussier01_S02",    Delay = 3 },
		{ Portrait = "AdlLoussier",   FileName = "AdlF", Index = "Loussier01_S03",    Delay = 2 },
		{ Portrait = "AdlLoussier",   FileName = "AdlF", Index = "Loussier01_S04",    Delay = 2 },
		{ Portrait = "AdlLoussier",   FileName = "AdlF", Index = "Loussier01_S05",    Delay = 3 },
		{ Portrait = "EldSpeGuard01", FileName = "AdlF", Index = "GuardAlber01_S02",  Delay = 2 },
		{ Portrait = "AdlMarlene",    FileName = "AdlF", Index = "Marlene01_S02",     Delay = 3 },
		{ Portrait = "AdlLoussier",   FileName = "AdlF", Index = "Loussier01_S06",    Delay = 2 },
		{ Portrait = "AdlMarlene",    FileName = "AdlF", Index = "Marlene01_S03",     Delay = 2 },
		{ Portrait = "AdlMarlene",    FileName = "AdlF", Index = "Marlene01_S04",     Delay = 3 },
		{ Portrait = "AdlMarlene",    FileName = "AdlF", Index = "Marlene01_S05",     Delay = 3 },
		{ Portrait = "AdlLoussier",   FileName = "AdlF", Index = "Loussier01_S07",    Delay = 4 },
	},

	-- 루시에 구출 이벤트 실패시
	Loussier_Rescue_Fail =
	{
		{ Portrait = "Salare",        FileName = "AdlF", Index = "Salare01_F01N",     Delay = 2 },
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack01_F01",      Delay = 3 },
	},

	-- 살라르 진입 전. 살라르, 이그렉 대화
	Zone2_Event1 =
	{
		{ Portrait = "Salare",        FileName = "AdlF", Index = "Salare03_01",       Delay = 3 },
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack03_01",       Delay = 3 },
		{ Portrait = "Salare",        FileName = "AdlF", Index = "Salare03_02",       Delay = 3 },
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack03_02",       Delay = 2 },
	},

	-- 살라르 진입. 살라르, 루시에 대화
	Zone2_Event2_alive =
	{
		{ Portrait = "Salare",        FileName = "AdlF", Index = "Salare03_S01",      Delay = 3 },
		{ Portrait = "AdlLoussier",   FileName = "AdlF", Index = "Loussier03_S01",    Delay = 3 },
		{ Portrait = "Salare",        FileName = "AdlF", Index = "Salare03_S02",      Delay = 3 },
		{ Portrait = "AdlLoussier",   FileName = "AdlF", Index = "Loussier03_S02",    Delay = 2 },
	},

	-- 살라르 진입. 살라르 대화
	Zone2_Event2_Dead =
	{
		{ Portrait = "Salare",        FileName = "AdlF", Index = "Salare03_F01",      Delay = 4 },
	},

	-- 살라르 전투 종료
	Zone2_Event3_Dead =
	{
		{ Portrait = "Salare",        FileName = "AdlF", Index = "Salare03_F02N",     Delay = 4 },
	},

	Zone2_Event3_alive =
	{
		{ Portrait = "AdlLoussier",   FileName = "AdlF", Index = "Loussier03_S03N",    Delay = 4 },
		{ Portrait = "Salare",        FileName = "AdlF", Index = "Salare03_S04N",      Delay = 4 },
		{ Portrait = "AdlLoussier",   FileName = "AdlF", Index = "Loussier03_S05N",    Delay = 4 },
	},


	-- 3지역 입장
	Zone3_ChatEvent =
	{
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack04_01N",      Delay = 2 },
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack04_02",       Delay = 2 },
	},

	-- 4지역 보스
	Zone4_Event1_alive =
	{
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack05_S01",      Delay = 3 },
		{ Portrait = "AdlLoussier",   FileName = "AdlF", Index = "Loussier05_S01",    Delay = 3 },
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack05_S02",      Delay = 3 },
	},

	Zone4_Event1_Dead =
	{
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack05_F01",      Delay = 2 },
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack05_F02",      Delay = 2 },
	},

	-- 4지역 전투 후
	Zone4_Event2_alive =
	{
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack05_S01N",      Delay = 3 },
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack05_S02N",      Delay = 3 },
		{ Portrait = "AdlLoussier",   FileName = "AdlF", Index = "Loussier05_S02N",    Delay = 3 },
	},

	Zone4_Event2_Dead_1 =
	{
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack05_F03",      Delay = 4 },
		{ Portrait = "AdlF_Karen",    FileName = "AdlF", Index = "Karen05_F01",       Delay = 2 },
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack05_F04A",      Delay = 2 },
		{ Portrait = "AdlF_Karen",    FileName = "AdlF", Index = "Karen05_F02",       Delay = 4 },
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack05_F04B",      Delay = 3 },
		{ Portrait = "AdlF_Karen",    FileName = "AdlF", Index = "Karen05_F03",       Delay = 2 },
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "Eglack05_F05",      Delay = 2 },
	},

	Zone4_Event2_Dead_2 =
	{
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "EglackMad05_F01",   Delay = 4 },
	},

	-- 4지역 2차 전투 후
	Zone4_Event3_Dead =
	{
		{ Portrait = "Eglack",        FileName = "AdlF", Index = "EglackMad05_F02N",  Delay = 2 },
		{ Portrait = "AdlF_Karen",    FileName = "AdlF", Index = "Karen05_F04",       Delay = 3 },
	},
}


-- 임시
-- 플레이어 카메라 무빙중 걸어줄 상태이상
STUN		= "StaAdlFStun"
-- 루시에 버프
LOUSSIBUF	= "StaAdlFLoussier"


-- 공지, 루시에 따라가기 설정시 스크립트 메시지
AnnounceInfo =
{
	AdlF_Mission_01_001 	= "AdlF_Mission_01_001",	--" 미션 : 루시에를 몬스터의 공격으로 부터 구출하라."
	AdlF_Mission_01_002 	= "AdlF_Mission_01_002",	--" 미션 : 어둠의 돌을 파괴하여 첫번째 관문을 돌파하라."
	AdlF_Msg_01_001			= "AdlF_Msg_01_001",		--" 관문의 어둠의 힘이 해제되었습니다."
	AdlF_Mission_02_001		= "AdlF_Mission_02_001",	--" 미션 : 어둠의 돌을 모두 파괴하여 두번째 관문을 돌파하라. (d%/3)"
	AdlF_Msg_02_001			= "AdlF_Msg_02_001",		--" 관문의 어둠의 힘이 해제되었습니다."
	AdlF_Mission_02_002		= "AdlF_Mission_02_002",	--" 미션: 살라르를 쓰터르려라. "
	AdlF_Msg_02_002			= "AdlF_Msg_02_002",		--" 관문의 어둠의 힘이 해제되었습니다."
	AdlF_Mission_03_001		= "AdlF_Mission_03_001",	-- 소환마법석 작동 루시에 없음
	AdlF_Mission_03_002		= "AdlF_Mission_03_002",	-- 소환마법석 작동 루시에 있음
	AdlF_Msg_03_001			= "AdlF_Msg_03_001",		--" 소환 마법석이 작동 됩니다. 작동 될 때까지 3분의 시간이 소요 됩니다."
	AdlF_Mission_03_003		= "AdlF_Mission_03_003",	--" 미션: 몬스터의 공격이 시작 됩니다. 소환 마법석이 작동 될 때까지 몬스터의 공격을 막아내라."
	AdlF_Msg_03_F_001		= "AdlF_Msg_03_F_001",		--"10초후 소환 마법석이 다시 소환 됩니다."
	AdlF_Mission_04_001		= "AdlF_Mission_04_001",	--" 미션: 마을을 파괴하는 이그렉을 무찔러 마을을 수호하라."
	AdlF_Loussier_Follow	= "AdlF_Loussier_Follow",	--" 루시에가 [%s]을 따라다닙니다."
	AdlF_Loussier_RStone	= "AdlF_Loussier_RStone",	--루시에 소환마법석 작동 위치 아닐시 메시지
}


-- 지역정보
AreaIndex =
{
	Zone1_1 = "AdlF_Zone01_1",	-- 1지역 루시에 구출 이벤트 발생
	Zone2_1 = "AdlF_Zone02_1",	-- 2지역 전부. ????루시에 존재여부 판단용????
	Zone2_2	= "AdlF_Zone02_2",	-- 2지역 보스간 대화 발생
	Zone2_3 = "AdlF_Zone02_3",	-- 2지역 보스 & NPC 대화 발생, 루시에 유무 판단
	Zone3_1 = "AdlF_Zone03_1",	-- 3지역 소환마법석 충돌범위
	Zone3_2 = "AdlF_Zone03_2",	-- 3지역 루시에 소환마법석 스킬 사용 가능 범위
	Zone3_3 = "AdlF_Zone03_3",	-- 3지역 전체. 3지역 몬스터 소환석으로 이동하기위함, 실패시 데미지 주기위함, 입장 체크
	Zone4_1 = "AdlF_Zone04_1",	-- 4지역 대화이벤트 발생
	Zone4_2 = "AdlF_Zone04_2",	-- 4지역 보스방 지역. 카렌 스킬 사용 범위
}


-- 1지역 이벤트 카메라 처리 정보 , 추가시 마지막줄에 추가
-- x, y    = 카메라 뷰 좌표
-- AngleXZ = 0 : 맵의 북쪽          ~ 180 : 맵의 남쪽
-- AngleY  = 0 : 케릭터와 동일 선상 ~  90 : 케릭터 머리 위에서 보는 각도
-- Dist    = 뷰 좌표와의 거리
CameraMoveInfo =
{
--[[ 1 ]]	{ x = RegenInfo.Loussier.x, y = RegenInfo.Loussier.y, AngleXZ = 315, AngleY =  20, Dist =  400 },
--[[ 2 ]]	{ x = RegenInfo.Marlene.x,  y = RegenInfo.Marlene.y,  AngleXZ =   0, AngleY =  30, Dist =  400 },
--[[ 3 ]]	{ x = RegenInfo.Loussier.x, y = RegenInfo.Loussier.y, AngleXZ = 135, AngleY =  20, Dist =  600 },
}


-- 연출 애니메이션 인덱스
AniIndex =
{
	CharactorCasting	= "ActionProduct",		-- 캐릭터 비상작동 캐스팅
	MagicStoneActive	=	{
								"EStone01_Idle1",
								"EStone02_Idle1",
								"EStone03_Idle1",
							},
	SummonStone			=	{
								"RStone_Idle",
								"RStone_Idle1",
								"RStone_Idle2",
								"RStone_Idle3",
							},
												-- 소환마법석
}

-- 3지역 몬스터 방어 이벤트 정보
WaveEvent =
{
	-- 방어해야 하는 시간.
	Timer			= 180,

	-- 소환마법석 hp
	SummonStone_HP	= 9,

	-- 비상작동 캐스팅시간, 활성화 시간. 초단위
	MS_CastingTime	= 3,
	MS_ActiveTime	= 10,

	-- 몹들이동위치, 소환마법석 좌표
	-- 좌표를 사용하지 않고 소환마법석 위치로 이동
	--MoveTo		= { x = 9947, y = 20481 },

	-- 각 웨이브 선딜레이.(
	WaveTime	= { 20, 15, 15, 15, 15, 15, 15, 10, 10, 10, 10, 10, 10, 10 },

	-- 몹들정보
	MobInfo		=
	{
		{
			{ MobIndex = "AdlF_Fknuckleman", x = 10722, y = 21032, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x =  9596, y = 19360, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x =  9075, y = 21275, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },
		},
		{
			{ MobIndex = "AdlF_Fknuckleman", x = 10722, y = 21032, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x =  9596, y = 19360, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x =  9075, y = 21275, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },
		},
		{
			{ MobIndex = "AdlF_Fknuckleman", x =  8910, y = 21952, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x = 11389, y = 20990, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x =  9628, y = 18674, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },
		},
		{
			{ MobIndex = "AdlF_Fknuckleman", x =  8910, y = 21952, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x = 11389, y = 20990, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x =  9628, y = 18674, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },
		},
		{
			{ MobIndex = "AdlF_Fknuckleman", x =  8910, y = 21952, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x = 11389, y = 20990, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x =  9628, y = 18674, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },
		},
		{
			{ MobIndex = "AdlF_Fknuckleman", x =  8910, y = 21952, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x = 11389, y = 20990, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x =  9628, y = 18674, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },
		},
		{
			{ MobIndex = "AdlF_Fknuckleman", x =  8910, y = 21952, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x = 11389, y = 20990, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x =  9628, y = 18674, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },
		},
		{
			{ MobIndex = "AdlF_Fknuckleman", x =  8910, y = 21952, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x = 11389, y = 20990, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x =  9628, y = 18674, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },
		},
		{
			{ MobIndex = "AdlF_Fknuckleman", x =  8910, y = 21952, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x = 11389, y = 20990, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x =  9628, y = 18674, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },
		},
		{
			{ MobIndex = "AdlF_Fknuckleman", x =  8910, y = 21952, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x = 11389, y = 20990, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x =  9628, y = 18674, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },
		},
		{
			{ MobIndex = "AdlF_Fknuckleman", x =  8910, y = 21952, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x = 11389, y = 20990, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x =  9628, y = 18674, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },
		},
		{
			{ MobIndex = "AdlF_Fknuckleman", x =  8910, y = 21952, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x = 11389, y = 20990, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x =  9628, y = 18674, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },
		},
		{
			{ MobIndex = "AdlF_Fknuckleman", x =  8910, y = 21952, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x = 11389, y = 20990, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x =  9628, y = 18674, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },
		},
		{
			{ MobIndex = "AdlF_Fknuckleman", x =  8910, y = 21952, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x = 11389, y = 20990, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },

			{ MobIndex = "AdlF_Fknuckleman", x =  9628, y = 18674, dir = 0, HP =    11, RunSpeed =  100, AC =    1, MR =    1, MobEXP =    2 },
		},
	},
}


function WaveMobDummy( Handle, MapIndex )
cExecCheck "WaveMobDummy"
	return ReturnAI.END
end

-- 웨이브 몹 인덱스 모두 추가 필요.
function DStone			( Handle, MapIndex ) return WaveMobDummy( Handle, MapIndex ) end	-- 공격 당할시 회전 하는 문제 때문에 다시 추가
function AdlF_Fknuckleman	( Handle, MapIndex ) return WaveMobDummy( Handle, MapIndex ) end




-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --



function Dummy( Var )
	return
end




function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[Field]

	if Var == nil then

		InstanceField[Field] = {}

		Var				= InstanceField[Field]
		Var.MapIndex	= Field

		Var.ControlFunc	= StepControl
		Var.StepFunc	= Dummy

	end


	Var.ControlFunc( Var )
	Var.StepFunc( Var )

	return
end


--[[																		]]--
--[[							관문 및 주 흐름 관리 						]]--
--[[																		]]--
function StepControl( Var )
cExecCheck "StepControl"

	if Var.LoussierHandle ~= nil then
		if cIsObjectDead( Var.LoussierHandle ) ~= nil then
			Var.LoussierHandle = nil
		end
	end

	-- 어둠의돌, 보스들, 루시에, 관문 등 셋팅
	if Var.Step == nil then

		Var.Step		= 1
		Var.StepFunc	= Default_Setting

		return
	end


	-- 1지역 셋팅후에 루시에 구출 이벤트 처리
	if Var.Step == 1 then

		Var.Step		= 3
		Var.StepFunc	= Zone1_Setting  -- Zone1_LoussierRescueEvent

		return
	end


	-- 1지역 어둠의돌이 죽으면 1관문 열고 2지역 셋팅
	if Var.Step == 3 then

		-- 어둠의돌이 리젠 됐는지 체크
		if Var.Zone_1_Darkstone_1 == nil then
			return
		end

		if cIsObjectDead( Var.Zone_1_Darkstone_1 ) ~= nil then

			Var.Zone_1_Darkstone_1 = nil

			Var.Step		= 4
			Var.StepFunc	= Zone2_Setting

			cDoorAction( Var.Door1, RegenInfo.Door1.Block, "open" )

			cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Msg_01_001 )
		end

		return
	end


	-- 2지역 입장 대기
	if Var.Step == 4 then

		local Object = cGetAreaObjectList( Var.MapIndex, AreaIndex.Zone2_1, ObjectType.Player )

		if Object == nil then
			return
		end

		Var.Step		= 5

		return
	end


	-- 2지역 어둠의돌 3개가 죽었으면 2지역 첫번째 관문 연다
	if Var.Step == 5 then

		local darkstone = 0


		if Var.Zone_2_Darkstone_1 == nil then
			darkstone = darkstone + 1
		elseif cIsObjectDead( Var.Zone_2_Darkstone_1 ) ~= nil then
			Var.Zone_2_Darkstone_1	= nil
		end
		if Var.Zone_2_Darkstone_2 == nil then
			darkstone = darkstone + 1
		elseif cIsObjectDead( Var.Zone_2_Darkstone_2 ) ~= nil then
			Var.Zone_2_Darkstone_2	= nil
		end
		if Var.Zone_2_Darkstone_3 == nil then
			darkstone = darkstone + 1
		elseif cIsObjectDead( Var.Zone_2_Darkstone_3 ) ~= nil then
			Var.Zone_2_Darkstone_3	= nil
		end


		if	Var.DarkStoneCount == nil then
			Var.DarkStoneCount = 0
			cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Mission_02_001, Var.DarkStoneCount )
		end

		if Var.DarkStoneCount < 3 then

			if Var.DarkStoneCount < darkstone then

				Var.DarkStoneCount = darkstone
				cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Mission_02_001, Var.DarkStoneCount )

				return
			end

			return
		end


		-- 관문에 대한 내용 수정에 따라 이 부분에서 살라르 소환 하도록함
		Var.Salare = cMobRegen_XY( Var.MapIndex, RegenInfo.Salare.Index, RegenInfo.Salare.x, RegenInfo.Salare.y, RegenInfo.Salare.dir )

		--cSetDeadDelayTime( Var.Salare, 9999 )

		if Var.Salare == nil then
			cDebugLog( "Fail cMobRegen_XY Salare" )
			return
		end


		Var.Step			= 6
		Var.StepFunc		= Zone2_ChatEvent_1
		Var.DarkStoneCount	= nil

		return
	end


	-- 살라르 전투 후 연출
	if Var.Step == 6 then

		if cIsObjectDead( Var.Salare ) ~= nil then

			Var.SalareDeadLocX, Var.SalareDeadLocY	= cObjectLocate( Var.Salare )
			Var.SalareDeadDir						= cGetDirect( Var.Salare )

			Var.Step		= 7
			Var.StepFunc	= Zone2_ChatEvent_3

		end

		return
	end


	-- 3지역 입장 체크
	if Var.Step == 7 then

		local Object = cGetAreaObjectList( Var.MapIndex, AreaIndex.Zone3_3, ObjectType.Player )

		if Object == nil then
			return
		end

		Var.Step		= 8
		Var.StepFunc	= Zone3_Setting

		return
	end


	-- 웨이브 이벤트 시작 체크
	if Var.Step == 8 then

		-- 비상 작동 마법석 시간 체크해서 풀어줌 3개 다 활성화시 소환마법석 작동
		local CurSec	= cCurrentSecond()
		local msCount	= 0

		if Var.MagicStoneA_ActiveTime ~= nil then

			if Var.MagicStoneA_ActiveTime < CurSec then
				Var.MagicStoneA_ActiveTime = nil
				cAnimate( Var.Magic_stoneA, "stop" )
			else
				msCount = msCount + 1
			end

		end
		if Var.MagicStoneB_ActiveTime ~= nil then

			if Var.MagicStoneB_ActiveTime < CurSec then
				Var.MagicStoneB_ActiveTime = nil
				cAnimate( Var.Magic_stoneB, "stop" )
			else
				msCount = msCount + 1
			end

		end
		if Var.MagicStoneC_ActiveTime ~= nil then

			if Var.MagicStoneC_ActiveTime < CurSec then
				Var.MagicStoneC_ActiveTime = nil

				cAnimate( Var.Magic_stoneC, "stop" )

			else
				msCount = msCount + 1
			end

		end



		if Var.msCount == nil then
			Var.msCount = 0
		end


		-- 비상작동 전부 활성중인지 체크
		if msCount == 3 then
			Var.SummonStone_Active = "MagicStone"
		end


		if Var.msCount ~= msCount then

			Var.msCount = msCount
			cAnimate( Var.SummonStone, "start", AniIndex.SummonStone[Var.msCount+1] )
			cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Mission_03_001, Var.msCount )

			return
		end

		-- 루시에 작동 & 비상작동
		if Var.SummonStone_Active ~= nil then

			cAnimate( Var.SummonStone, "start", AniIndex.SummonStone[#AniIndex.SummonStone] )

			Var.msCount			= nil
			Var.Zone3_WaveTimer	= CurSec + WaveEvent.Timer


			Var.Step		= 9
			Var.StepFunc	= Zone3_WaveEvent

			cTimer( Var.MapIndex, (Var.Zone3_WaveTimer - CurSec) )

			return
		end

		return
	end


	-- 웨이브 디펜스 시간 체크, 실패 체크
	if Var.Step == 9 then

		if Var.SummonStone_HP == nil then
			Var.SummonStone_HP = WaveEvent.SummonStone_HP
		end

		local CurSec = cCurrentSecond()


		-- 소환석, 몬스터 충돌처리
		local CrashMobList = { cGetAreaObjectList( Var.MapIndex, AreaIndex.Zone3_1, ObjectType.Mob ) }
		for i=1, #CrashMobList do

			if	CrashMobList[i] ~= Var.Magic_stoneA	and
				CrashMobList[i] ~= Var.Magic_stoneB	and
				CrashMobList[i] ~= Var.Magic_stoneC	and
				CrashMobList[i] ~= Var.SummonStone	and
				CrashMobList[i] ~= Var.LoussierHandle then

				Var.SummonStone_HP = Var.SummonStone_HP - 1

				cNPCVanish( CrashMobList[i] )

			end

		end


		-- 소환석 HP 체크
		if Var.SummonStone_HP <= 0 then

			Var.Step		= 8
			Var.StepFunc	= Zone3_WaveEvent_Reset

			return
		end

		-- 웨이브 방어시간 끝났는지 체크
		if Var.Zone3_WaveTimer < CurSec then

			Var.Step		= 10
			Var.StepFunc	= Zone3_WaveEvent_Clear -- 다음으로 Zone4_Setting 함수로 넘어감

			return
		end

		return
	end


	-- 보스방 입장 이벤트
	if Var.Step == 10 then

		-- 보스존 대화 이벤트 발생지점에 누군가 들어왔는지 체크 후 이벤트 발생
		local player = cGetAreaObjectList( Var.MapIndex, AreaIndex.Zone4_1, ObjectType.Player )

		if player == nil then
			return
		end

		Var.Step		= 11
		Var.StepFunc	= Zone4_Event_1

		return
	end


	-- 보스 1차 죽였을때 이벤트
	if Var.Step == 11 then

		if cIsObjectDead( Var.Eglack ) ~= nil then

			Var.EglackDeadLocX, Var.EglackDeadLocY	= cObjectLocate( Var.Eglack )
			Var.EglackDeadDir						= cGetDirect( Var.Eglack )


			Var.Step		= 12
			Var.StepFunc	= Zone4_Event_2

		end

		return
	end


end






function Default_Setting( Var )
cExecCheck "Default_Setting"

	if Var == nil then
		return
	end

	-- 관문 소환
	Var.Door1 = cDoorBuild( Var.MapIndex, RegenInfo.Door1.Index, RegenInfo.Door1.x, RegenInfo.Door1.y, RegenInfo.Door1.dir, RegenInfo.Door1.scale )
	Var.Door2 = cDoorBuild( Var.MapIndex, RegenInfo.Door2.Index, RegenInfo.Door2.x, RegenInfo.Door2.y, RegenInfo.Door2.dir, RegenInfo.Door2.scale )
	cDoorAction( Var.Door1, RegenInfo.Door1.Block, "close" )
	cDoorAction( Var.Door2, RegenInfo.Door2.Block, "close" )


	if Var.Door1 == nil then
		cDebugLog( "Default_Setting : Fail cDoorBuild 1" )
		return
	end
	if Var.Door2 == nil then
		cDebugLog( "Default_Setting : Fail cDoorBuild 2" )
		return
	end


	Var.ExitGate = cMobRegen_XY( Var.MapIndex, RegenInfo.ExitGate.Index,
													RegenInfo.ExitGate.x,
													RegenInfo.ExitGate.y,
													RegenInfo.ExitGate.dir )

	if Var.ExitGate == nil then
		cDebugLog( "Default_Setting : Fail cMobRegen_XY ExitGate" )
		return
	end

	if cSetAIScript( "ID/AdlF/AdlF", Var.ExitGate ) == nil then
		cDebugLog( "Default_Setting : Fail cSetAIScript ExitGate" )
		return
	end

	if cAIScriptFunc( Var.ExitGate, "NPCClick", "ExitGateFunc" ) == nil then
		cDebugLog( "Default_Setting : Fail cAIScriptFunc ExitGate" )
		return
	end


	Var.ExitBossGate = cMobRegen_XY( Var.MapIndex, RegenInfo.ExitBossGate.Index,
													RegenInfo.ExitBossGate.x,
													RegenInfo.ExitBossGate.y,
													RegenInfo.ExitBossGate.dir )
	if Var.ExitBossGate == nil then
		cDebugLog( "Default_Setting : Fail cMobRegen_XY ExitBossGate" )
		return
	end

	if cSetAIScript( "ID/AdlF/AdlF", Var.ExitBossGate ) == nil then
		cDebugLog( "Default_Setting : Fail cSetAIScript ExitGate" )
		return
	end

	if cAIScriptFunc( Var.ExitBossGate, "NPCClick", "ExitBossGateFunc" ) == nil then
		cDebugLog( "Default_Setting : Fail cAIScriptFunc ExitGate" )
		return
	end


	Var.StepFunc = Dummy

	return
end
