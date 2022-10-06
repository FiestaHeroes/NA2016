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
		HP800 = { SummonMobs = { "T_Imp", "T_Imp", "T_Imp", "T_Imp", "T_GangImp", "T_GangImp", "T_GangImp", "T_GangImp", }, },
		HP200 = { SummonMobs = { "T_HungryWolf", "T_HungryWolf", "T_Ratman", "T_Ratman", }, },
	},
	Summon_Floor09 =
	{
		HP700 = { SummonMobs = { "T_SkelArcher01", "T_SkelArcher01", }, },
		HP200 = { SummonMobs = { "T_SkelWarrior", "T_SkelWarrior", "T_SkelWarrior", "T_SkelArcher02", }, },
	},
	Summon_Floor13 =
	{
		HP700 = { SummonMobs = { "T_OldFox", "T_OldFox", "T_OldFox", "T_OldFox", "T_DesertWolfC", "T_DesertWolfC", "T_DesertWolfC", "T_DesertWolfC", }, },
		HP200 = { SummonMobs = { "T_Ghost", "T_Ghost", "T_Ghost", "T_Ghost", "T_IceViVi", "T_IceViVi", "T_IceViVi", "T_IceViVi", }, },
	},
	Summon_Floor19 =
	{
		HP700 = { SummonMobs = { "T_Prock", "T_Spider00", "T_Spider00", "T_Spider00", "T_Spider00", }, },
		HP500 = { SummonMobs = { "T_KingCall", "T_KingCall", }, },
		HP200 = { SummonMobs = { "T_FlyingStaff01", "T_FlyingStaff01", "T_IronSlime01", "T_IronSlime01", }, },
	},
}
