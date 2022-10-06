--------------------------------------------------------------------------------
--                         Tower Of Iyzel Boss Data                           --
--------------------------------------------------------------------------------


-- 보스 스킬이 발동되는 한계치를 정해놓은 테이블
ThresholdTable =
{
	SummonHP_Floor04 = { 800, 200, },
	SummonHP_Floor09 = { 700, 200, },
	SummonHP_Floor13 = { 700, 200, },
	SummonHP_Floor19 = { 700, 500, 200, },
}


-- 보스 스킬
BossSkill =
{
	-- 잔몹 소환
	Summon_Floor04 =
	{
		HP800 = { SummonMobs = { "TH_Imp", "TH_Imp", "TH_Imp", "TH_Imp", "TH_GangImp", "TH_GangImp", "TH_GangImp", "TH_GangImp", }, },
		HP200 = { SummonMobs = { "TH_HungryWolf", "TH_HungryWolf", "TH_Ratman", "TH_Ratman", }, },
	},
	Summon_Floor09 =
	{
		HP700 = { SummonMobs = { "TH_SkelArcher01", "TH_SkelArcher01", }, },
		HP200 = { SummonMobs = { "TH_SkelWarrior", "TH_SkelWarrior", "TH_SkelWarrior", "TH_SkelArcher02", }, },
	},
	Summon_Floor13 =
	{
		HP700 = { SummonMobs = { "TH_OldFox", "TH_OldFox", "TH_OldFox", "TH_OldFox", "TH_DesertWolfC", "TH_DesertWolfC", "TH_DesertWolfC", "TH_DesertWolfC", }, },
		HP200 = { SummonMobs = { "TH_Ghost", "TH_Ghost", "TH_Ghost", "TH_Ghost", "TH_IceViVi", "TH_IceViVi", "TH_IceViVi", "TH_IceViVi", }, },
	},
	Summon_Floor19 =
	{
		HP700 = { SummonMobs = { "TH_Prock", "TH_Spider00", "TH_Spider00", "TH_Spider00", "TH_Spider00", }, },
		HP500 = { SummonMobs = { "TH_KingCall", "TH_KingCall", }, },
		HP200 = { SummonMobs = { "TH_FlyingStaff01", "TH_FlyingStaff01", "TH_IronSlime01", "TH_IronSlime01", }, },
	},
}
