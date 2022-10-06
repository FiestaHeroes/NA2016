----------------------------------------------------------------------------------------------------
-- PetCommon ---------------------------------------------------------------------------------------
-- PMM is equal to PET_MASTER_MODE
PMM_NONE	= 0	-- 정의 안된 모드
PMM_IDLE	= 1 -- 마스터가 가만히 있는 모드 : 성향에 따른 행동을 주기적으로 보임
PMM_AWAY	= 2 -- 마스터가 펫에서 떨어짐 : 펫이 따라감
PMM_FAR		= 3 -- 마스터가 펫에서 너무 멀어짐 : 펫 정지
PMM_CALL	= 4 -- 마스터가 펫을 부름 : 마스터에게 다가온 후 마스터를 쳐다봄
PMM_DIE		= 5 -- 마스터가 죽음 : 펫이 다가온후 정지후 슬퍼함
PMM_LINK	= 6 -- 마스터가 링크탐 : 루아 스크립트 입장에서는 여기로 올 일은 없음 : 펫 소환 해제 및 마스터 링크 이후 재소환

-- PAM is equal to PET_ACTION_MODE
PAM_NONE		= 0
PAM_IDLE_WAIT	= 1
PAM_IDLE_ACT	= 2
PAM_AWAY_FOLLOW	= 3
PAM_FAR_MISSED	= 4
PAM_CALL_COME	= 5
PAM_CALL_SEE	= 6
PAM_DIE_COME	= 7
PAM_DIE_SAD		= 8
PAM_LINK		= 9

-- PIAM is equal to PET_IDLE_ACTION_MODE
PIAM_INVALID	= 0
PIAM_NONE		= 1
PIAM_FOLLOW		= 2
PIAM_REVOLUTION	= 3
PIAM_DANCE		= 4
PIAM_ATTACK		= 5
PIAM_ROAMING	= 6
PIAM_ROTATION	= 7
PIAM_TALK		= 8
PIAM_DIE		= 9

-- PISAT is equan to PetIdleStepActionType
PISAT_INVALID	= 0
PISAT_MOVE		= 1
PISAT_ROTATION	= 2
PISAT_ATTACK	= 3
PISAT_DANCE		= 4

-- PNIST is equan to PetNextIdleStepType
PNIST_INVALID	= 0
PNIST_DISTANCE	= 1
PNIST_TIME		= 2
PNIST_END		= 3

-- PetCommon ---------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------


-- 스트링 상수

PET_ATTACK_INDEX = ""
PET_DIE_INDEX = ""
PET_SAD_INDEX = ""




-- 거리
PetSystem_nDistanceDiedStop			= 30
PetSystem_nDistanceCallingStop		= 50
PetSystem_nDistanceFollowingStop	= 30

PetSystem_nDistanceAwayStart		= 300
PetSystem_nDistanceFarStart			= 500


PetSystem_nDistanceIdleFollowingPetSelectMax	= 200
PetSystem_nDistanceIdleFollowingPetStart		= 80
PetSystem_nDistanceIdleFollowingPetStop			= 30
PetSystem_nDistanceIdleFollowingPetStayMax		= 500

PetSystem_nDistanceIdleRevolutionPetSelectMax	= 200
PetSystem_nDistanceIdleRevolutionPetStart		= 30
PetSystem_nDistanceIdleRevolutionPetStop		= 30

PetSystem_nDistanceIdleAttackPetSelectMax		= 200

PetSystem_nDistanceIdleMindChangePetSelectMax	= 200

PetSystem_nDistanceIdleRoamingMax 				= 100

PetSystem_nDistanceIdleTalkPetSelectMax			= 200
PetSystem_nDistanceIdleTalkPetStart				= 30
PetSystem_nDistanceIdleTalkPetStop				= 30
PetSystem_nDistanceIdleTalkPetStayMax			= 300


-- 다른펫 따라가기, 다른펫 공격 ( 여유거리 계산
PetFollowGap	= PetSystem_nDistanceIdleFollowingPetStop - 5
PetFollowStop	= PetSystem_nDistanceIdleFollowingPetStayMax + 10


-- 거리 제곱 PS_nDS_ => PetSystem_nDistanceSquare
PS_nDS_DiedStop					= GetSquare( PetSystem_nDistanceDiedStop )
PS_nDS_CallingStop				= GetSquare( PetSystem_nDistanceCallingStop )
PS_nDS_FollowingStop			= GetSquare( PetSystem_nDistanceFollowingStop )

PS_nDS_AwayStart				= GetSquare( PetSystem_nDistanceAwayStart )
PS_nDS_FarStart					= GetSquare( PetSystem_nDistanceFarStart )

-- Idle Actions
PS_nDS_IdleFollowingPetSelectMax	= GetSquare( PetSystem_nDistanceIdleFollowingPetSelectMax )
PS_nDS_IdleFollowingPetStart		= GetSquare( PetSystem_nDistanceIdleFollowingPetStart )
PS_nDS_IdleFollowingPetStop			= GetSquare( PetSystem_nDistanceIdleFollowingPetStop )
PS_nDS_IdleFollowingPetStayMax		= GetSquare( PetSystem_nDistanceIdleFollowingPetStayMax )

PS_nDS_IdleRevolutionPetSelectMax	= GetSquare( PetSystem_nDistanceIdleRevolutionPetSelectMax )
PS_nDS_IdleRevolutionPetStart		= GetSquare( PetSystem_nDistanceIdleRevolutionPetStart )
PS_nDS_IdleRevolutionPetStop		= GetSquare( PetSystem_nDistanceIdleRevolutionPetStop )

PS_nDS_IdleAttackPetSelectMax 		= GetSquare( PetSystem_nDistanceIdleAttackPetSelectMax )

PS_nDS_IdleTalkPetSelectMax			= GetSquare( PetSystem_nDistanceIdleTalkPetSelectMax )
PS_nDS_IdleTalkPetStart				= GetSquare( PetSystem_nDistanceIdleTalkPetStart )
PS_nDS_IdleTalkPetStop				= GetSquare( PetSystem_nDistanceIdleTalkPetStop )
PS_nDS_IdleTalkPetStayMax			= GetSquare( PetSystem_nDistanceIdleTalkPetStayMax )


-- 대기시간 (초)
PetSystem_nSecWaitMissingAtFar			= 10

PetSystem_nSecMinWaitActAtIdle			= 30
PetSystem_nSecMaxWaitActAtIdle			= 60

PetSystem_nSecWaitSaveTendencyAtIdle	= 60

-- 기획에 추가 요청
PetSystem_nSecStayAtCallSee				= 1

-- 죽었을때 슬픔대기시간
PetSystem_nSecStayAtDiedSad				= 180

-- 각 아이들 액션 최대 실행시간
PetSystem_nSecStayAtIdleFollow			= 5
PetSystem_nSecStayAtIdleRevolution		= 10
PetSystem_nSecStayAtIdleDance			= 10
PetSystem_nSecStayAtIdleRoaming			= 20
PetSystem_nSecStayAtIdleRotation		= 10
PetSystem_nSecStayAtIdleDie				= 10





-- 이동속도 ( 기본속도에 대한 천분율 )
PetSystem_nSpeedRateFollowingMil		= 1000
PetSystem_nSpeedRateCallingMil			= 1000
PetSystem_nSpeedRateDiedMil				= 1000


