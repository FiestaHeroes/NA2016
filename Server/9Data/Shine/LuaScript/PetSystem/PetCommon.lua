----------------------------------------------------------------------------------------------------
-- PetCommon ---------------------------------------------------------------------------------------
-- PMM is equal to PET_MASTER_MODE
PMM_NONE	= 0	-- ���� �ȵ� ���
PMM_IDLE	= 1 -- �����Ͱ� ������ �ִ� ��� : ���⿡ ���� �ൿ�� �ֱ������� ����
PMM_AWAY	= 2 -- �����Ͱ� �꿡�� ������ : ���� ����
PMM_FAR		= 3 -- �����Ͱ� �꿡�� �ʹ� �־��� : �� ����
PMM_CALL	= 4 -- �����Ͱ� ���� �θ� : �����Ϳ��� �ٰ��� �� �����͸� �Ĵٺ�
PMM_DIE		= 5 -- �����Ͱ� ���� : ���� �ٰ����� ������ ������
PMM_LINK	= 6 -- �����Ͱ� ��ũŽ : ��� ��ũ��Ʈ ���忡���� ����� �� ���� ���� : �� ��ȯ ���� �� ������ ��ũ ���� ���ȯ

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


-- ��Ʈ�� ���

PET_ATTACK_INDEX = ""
PET_DIE_INDEX = ""
PET_SAD_INDEX = ""




-- �Ÿ�
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


-- �ٸ��� ���󰡱�, �ٸ��� ���� ( �����Ÿ� ���
PetFollowGap	= PetSystem_nDistanceIdleFollowingPetStop - 5
PetFollowStop	= PetSystem_nDistanceIdleFollowingPetStayMax + 10


-- �Ÿ� ���� PS_nDS_ => PetSystem_nDistanceSquare
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


-- ���ð� (��)
PetSystem_nSecWaitMissingAtFar			= 10

PetSystem_nSecMinWaitActAtIdle			= 30
PetSystem_nSecMaxWaitActAtIdle			= 60

PetSystem_nSecWaitSaveTendencyAtIdle	= 60

-- ��ȹ�� �߰� ��û
PetSystem_nSecStayAtCallSee				= 1

-- �׾����� ���Ĵ��ð�
PetSystem_nSecStayAtDiedSad				= 180

-- �� ���̵� �׼� �ִ� ����ð�
PetSystem_nSecStayAtIdleFollow			= 5
PetSystem_nSecStayAtIdleRevolution		= 10
PetSystem_nSecStayAtIdleDance			= 10
PetSystem_nSecStayAtIdleRoaming			= 20
PetSystem_nSecStayAtIdleRotation		= 10
PetSystem_nSecStayAtIdleDie				= 10





-- �̵��ӵ� ( �⺻�ӵ��� ���� õ���� )
PetSystem_nSpeedRateFollowingMil		= 1000
PetSystem_nSpeedRateCallingMil			= 1000
PetSystem_nSpeedRateDiedMil				= 1000


