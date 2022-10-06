--------------------------------------------------------------------------------
--                         Crystal Castle Boss Data                           --
--------------------------------------------------------------------------------


-- 보스 스킬이 발동되는 한계치를 정해놓은 테이블
ThresholdTable =
{
	SummonHP_Boss1 = { 750, 500, 250, },
	SummonHP_Boss2 = { 750, 500, 250, },
	SummonHP_Boss3 = { 750, 500, 250, 200, 150, },
}


-- 합계가 100이 되도록 선택할 것, 0 또는 자연수로만 기입 가능
-- 보스 타입 추가/삭제 시 소스 수정 필요, 확률 변경시에는 값의 변경으로 해결됨
BossSelectProbablityPercent =
{
	Boss1 = 40,
	Boss2 = 40,
	Boss3 = 20,
}


BossArea =
{
	Index = "Tower02_A11",

	-- 보스방 문 닫히는 카운트 : 현재 0.5초마다 증가하므로 10초를 원하면 20을 입력해야함.
	TriggerCount = 20,
}

-- if cSetAbstate( 객체 핸들, "상태이상 인덱스", 강도, 지속시간 ) == nil then
BossAbstate =
{
	AC_Plus  = { Index = "StaMobACPlus",   Strength = 1, KeepTime = 3600000 },
	MR_Plus  = { Index = "StaMobMRPlus",   Strength = 1, KeepTime = 3600000 },
	Immortal = { Index = "StaMobImmortal", Strength = 1, KeepTime = 3600000 },
}


-- 보스 스킬
BossSkill =
{
	-- 잔몹 소환
	SummonHP_Boss1 =
	{
		HP750 =
		{
			SummonMobs =
			{
				{ Index = "C_LizardManIyzel", 		Count = 5, },
			},
		},

		HP500 =
		{
			SummonMobs =
			{
				{ Index = "C_DarkLizardManIyzel", 	Count = 1, },
			},
		},

		HP250 =
		{
			SummonMobs =
			{
				{ Index = "C_LizardManIyzel", 		Count = 5, },
				{ Index = "C_DarkLizardManIyzel", 	Count = 1, },
			},
		},
	},

	SummonHP_Boss2 =
	{
		HP750 =
		{
			SummonMobs =
			{
				{ Index = "C_OrcIyzel", 		Count = 5, },
			},
		},

		HP500 =
		{
			SummonMobs =
			{
				{ Index = "C_CurseOrcIyzel", 	Count = 1, },
			},
		},

		HP250 =
		{
			SummonMobs =
			{
				{ Index = "C_OrcIyzel", 		Count = 5, },
				{ Index = "C_CurseOrcIyzel", 	Count = 1, },
			},
		},
	},

	SummonHP_Boss3 =
	{
		HP750 =
		{
			SummonMobs =
			{
				{ Index = "C_SkelArcherIyzel", 		Count = 5, },
			},
		},

		HP500 =
		{
			SummonMobs =
			{
				{ Index = "C_OneSkelArcherIyzel", 	Count = 3, },
			},
		},

		HP250 =
		{
			SummonMobs =
			{
				{ Index = "C_OneSkelArcherIyzel", 	Count = 3, },
			},
		},

		HP200 =
		{
			SummonMobs =
			{
				{ Index = "C_SkelArcherIyzel", 		Count = 5, },
				{ Index = "C_OneSkelArcherIyzel", 	Count = 3, },
			},

			RegenMobs =
			{
				{ Index = "C_PillarofLight", x = 9094, y = 11259, dir = 0, },
				{ Index = "C_PillarofLight", x = 8746, y = 11481, dir = 0, },
				{ Index = "C_PillarofLight", x = 8578, y = 11156, dir = 0, },
				{ Index = "C_PillarofLight", x = 8922, y = 10969, dir = 0, },
			},
		},

		HP150 =
		{
			SummonMobs =
			{
				{ Index = "C_SkelArcherIyzel", 		Count = 5, },
				{ Index = "C_OneSkelArcherIyzel", 	Count = 3, },
			},
		},
	},
}
