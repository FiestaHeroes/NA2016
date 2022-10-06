--------------------------------------------------------------------------------
--                          Emperor Slime Boss Data                           --
--------------------------------------------------------------------------------

KingSlimeChat =
{
	ScriptFileName = MsgScriptFileDefault,

	SpeakerIndex = "KQ_KingSlime", -- 기존 리소스 재활용

	FloorClearDialog =
	{
		{ Index = "King_FaceCut01" },	-- 1층 클리어시	: 황제께서 너희들을 벌할 것이다!!
		{ Index = "King_FaceCut02" },	-- 2층 클리어시 : 모든 슬라임들은 헤니스 모험단을 처치하라!!
	},

	DeathDialogIndex = "King_FaceCut03", -- 1, 2번째 죽은 킹슬라임만 : 내가 진짜 킹슬라임으로 보이나? 하하하! 끝까지 알 수 없을걸!
}


EmperorSlimeChat =
{
	ScriptFileName = MsgScriptFileDefault,

	SpeakerIndex = "Emp_EmperorSlime",

	WarningDialog =
	{
		{ Index = "Emperor_FaceCut01" }, -- 킹슬라임 3마리가 죽어서 보스전 시작될때 : 누가 황제의 식사시간을 방해하는가? 무엄한 녀석들 혼쭐을 내주마!!
	},

	SummonMobShout 	=
	{
		FirstSummon  = { Index = "Emperor_Shout01" }, -- 여봐라! 이 무엄한 무리들을 응징하라!
		SecondSummon = { Index = "Emperor_Shout02" }, -- 제법하는군! 불길의 기운을 담은 슬라임들이여! 가랏!
		ThirdSummon  = { Index = "Emperor_Shout03" }, -- 강철같은 슬라임들이여! 믿을 것은 너희들 뿐이구나!
		LastSummon   = { Index = "Emperor_Shout04" }, -- 오오! 퀸슬라임들이여.. 짐을 회복시켜 헤니스 모험단을 무릎꿇게 해다오!
	},

	DeathDialogIndex = "Emperor_FaceCut02", -- 큭.. 이렇게 허무하게 당하다니.. 어떤 슬라임이든 복수를 해 줄 것이다!
}




EmperorSlimeSkill =
{
	-- 쫄몹이 제자리에 소환될 수 있도록 보스가 리젠위치로 부터 떨어질 수 있는 최대 거리
	LimitDistanceFromOrigin = 1200,

	SummonEffect =
	{
		-- 빙글빙글 도는 스킬
		EffectSkillIndex = "Emp_EmperorSlime_Skill02_N",
		AnimationKeepSec = 3,
		-- 3초에 5바퀴
	},

	TornadoEffect =
	{
		-- 몹만 소환하면 알아서 회오리 잠깐 발생하고 사라짐 루아로 제어
		CenterMobIndex = "Emp_Tornado",
		MobLifeSec = 4,
	},

	FirstSummon =
	{
		HP_Rate = 800,

		SummonMobsTableIndex = "SlimeTroops",
		SummonCount = 1,
		SummonGapSec = nil, -- 무효

		MobLifeSec = nil,	-- 제한 시간 없음

		bBossSpinning = true,
		bSummonAreaCenterTornado = true,
	},

	SecondSummon =
	{
		HP_Rate = 600,

		SummonMobsTableIndex = "FireSlimeTroops",
		SummonCount = 3,
		SummonGapSec = 20,

		MobLifeSec = nil,

		bBossSpinning = true,
		bSummonAreaCenterTornado = true,
	},

	ThirdSummon =
	{
		HP_Rate = 400,

		SummonMobsTableIndex = "IronSlimeTroops",
		SummonCount = nil,	-- 무제한
		SummonGapSec = 20,

		MobLifeSec = 15,

		bBossSpinning = true,
		bSummonAreaCenterTornado = true,

		-- 아래의 경우 소환 중지
		-- 보스 피 40퍼 넘어갈 때
		-- 보스 어그로 초기화시
		-- 보스 사망시

	},

	LastSummon =
	{
		HP_Rate = 200,

		SummonMobsTableIndex = "TwinQueenSlimes",
		SummonCount = 1,
		SummonGapSec = nil,

		MobLifeSec = nil,				-- 시간에 의한 제한은 없으나 아래 조건이 있음
		MobVanishCondBossHP_Rate = 450, -- 보스 HP 가 이 비율을 넘어가면 퀸슬라임 소멸

		bBossSpinning = true,
		bSummonAreaCenterTornado = false,

		-- 아래의 경우 퀸 슬라임 사라짐
		-- 보스HP 45%이상시
		-- 1마리 사망 후 30초 이내에 다른 1마리가 사망 시
		-- 보스 어그로 초기화
	},
}

-- 퀸슬라임은 공격없이 힐만 한다. : 데이터 셋팅 필요
QueenSlimeInfo =
{
	-- 해당 힐은 각각의 퀸슬라임마다 적용된다.
	HealInfo =
	{
-- 난이도에 따른 퀸슬라임의 힐량으로 난이도 1이 2~5명, 2가 6~10명 3이 11~15명으로 1명테스트시에는 최고난이도로 셋팅
		HealAmount1 = 3000,
		HealAmount2 = 5000,
		HealAmount3 = 10000,
		HealGapSec = 2,
		HealEffectIndex = "EKQ_MD_BuffSkil1_1",
	},

	RevivalInfo =
	{
		-- 한마리를 죽인 후 아래 시간 안에 다른 퀸슬라임을 죽이지 않으면 되살아난다.
		RevivalSec = 30,

		AbstateIndex = "StaCount30",
		AbstateStrength = 1,
		AbstateKeepTime = 30000,
	},
}

