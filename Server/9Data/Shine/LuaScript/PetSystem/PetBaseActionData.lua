
PetSystem_ActionEventCode =
{
	Idle	= 101000,
	Attack	= 301000,
	Die		= 501000,
	Dance	= 800000,
}


PetSystem_tIdleActionData =
{
	tHeader	=
	{
		nStepNo 			= 1,
		nStepType			= 2,
		nX					= 3,
		nY					= 4,
		nDir				= 5,
		nNextStepCondType	= 6,
		nNextStepDistance	= 7,
		dNextStepTime		= 8,
	},
	tData 	=
	{
		tRevolution =
		{
			-- ���� ���� ���� ���۸� ����
			{	1,	PISAT_MOVE,	-30,	0,	0,	PNIST_DISTANCE,	20,	0	},
			{	2,	PISAT_MOVE,	-20,	20,	0,	PNIST_DISTANCE,	20,	0	},
			{	3,	PISAT_MOVE,	0,	30,	0,	PNIST_DISTANCE,	20,	0	},
			{	4,	PISAT_MOVE,	20,	20,	0,	PNIST_DISTANCE,	20,	0	},
			{	5,	PISAT_MOVE,	30,	0,	0,	PNIST_DISTANCE,	20,	0	},
			{	6,	PISAT_MOVE,	20,	-20,	0,	PNIST_DISTANCE,	20,	0	},
			{	7,	PISAT_MOVE,	0,	-30,	0,	PNIST_DISTANCE,	20,	0	},
			{	8,	PISAT_MOVE,	-20,	-20,	0,	PNIST_DISTANCE,	20,	0	},
		},

		ttDance =
		{
			-- 1�� ��~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			{
				-- �·�
				{	1,	PISAT_ROTATION,	0,	0,	-90,	PNIST_TIME,	0,	1	},
				-- �ι�����
				{	2,	PISAT_ATTACK,	0,	0,	0,	PNIST_TIME,	0,	2	},
				{	3,	PISAT_ATTACK,	0,	0,	0,	PNIST_TIME,	0,	2	},
				-- ���
				{	4,	PISAT_ROTATION,	0,	0,	180,	PNIST_TIME,	0,	1	},
				-- �ι�����
				{	5,	PISAT_ATTACK,	0,	0,	0,	PNIST_TIME,	0,	2	},
				{	6,	PISAT_ATTACK,	0,	0,	0,	PNIST_END,	0,	2	},
			},

			-- 2�� ��~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			{
				-- ���ڸ� ����
				{	1,	PISAT_DANCE,	0,	0,	0,	PNIST_TIME,	0,	5	},
				{	2,	PISAT_MOVE,		0,	0,	0,	PNIST_END,	0,	0	},
			},

			-- 3�� ��~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			{
				-- ��
				{	1,	PISAT_MOVE,	-30,	-70,	0,	PNIST_DISTANCE,	30,	0	},
				{	2,	PISAT_MOVE,	0,	80,	0,	PNIST_DISTANCE,	30,	0	},
				{	3,	PISAT_MOVE,	30,	-70,	0,	PNIST_DISTANCE,	30,	0	},
				{	4,	PISAT_MOVE,	-75,	25,	0,	PNIST_DISTANCE,	30,	0	},
				{	5,	PISAT_MOVE,	75,	25,	0,	PNIST_DISTANCE,	30,	0	},
			},

			-- 4�� ��~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			{
				-- �Ұ���
				{	1,	PISAT_MOVE,	0,	0,	0,	PNIST_END,	30,	0	},
			},

			-- 5�� ��~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			{
				-- ������ 50 �� �׸���
				{	1,	PISAT_MOVE,	-50,	0,	0,	PNIST_DISTANCE,	30,	0	},
				{	2,	PISAT_MOVE,	-30,	30,	0,	PNIST_DISTANCE,	30,	0	},
				{	3,	PISAT_MOVE,	0,	50,	0,	PNIST_DISTANCE,	30,	0	},
				{	4,	PISAT_MOVE,	30,	30,	0,	PNIST_DISTANCE,	30,	0	},
				{	5,	PISAT_MOVE,	50,	0,	0,	PNIST_DISTANCE,	30,	0	},
				{	6,	PISAT_MOVE,	30,	-30,	0,	PNIST_DISTANCE,	30,	0	},
				{	7,	PISAT_MOVE,	0,	-50,	0,	PNIST_DISTANCE,	30,	0	},
				{	8,	PISAT_MOVE,	-30,	-30,	0,	PNIST_DISTANCE,	30,	0	},
			},
		},

		tAttack =
		{
			{	1,	PISAT_ATTACK,	0,	0,	0,	PNIST_TIME,	0,	2	},
			{	2,	PISAT_ATTACK,	0,	0,	0,	PNIST_TIME,	0,	2	},
			{	3,	PISAT_ATTACK,	0,	0,	0,	PNIST_END,	0,	2	},
		},

		tRotation =
		{
			{	1,	PISAT_DANCE,	0,	0,	0,	PNIST_TIME,	0,	5	},
			{	2,	PISAT_MOVE,		0,	0,	0,	PNIST_END,	0,	0	},
		},
	},

}
