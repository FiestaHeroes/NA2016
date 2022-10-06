--------------------------------------------------------------------------------
--                                Servant Data                                --
--------------------------------------------------------------------------------


-- 케이크
Cake =
{
	MobIndex		= "BallCake01",										-- 몹 인덱스
	SkillIndex		= "BallCake_Skill01_N",								-- 스킬 인덱스
	Dist			= 50,												-- 폭발 시 체크 범위
	Abstate 		= { Index = "StaKnockBackFly", KeepTime = 2000 },	-- 폭발 시 걸어줄 상태이상 정보
	SetAbstateWait	= 0.2,												-- SetAbstateWait 시간 후 상태이상 걸이줌
	LinktoWait		= 2,												-- 감옥으로 보내기전 대기시간
}

-- 음료수대포
DrinkCannon =
{
	MobIndex	= "BallCannon02",									-- 몹 인덱스
	Dist		= 100,												-- 폭발 시 체크 범위
	Abstate 	= { Index = "StaKnockBackRoll", KeepTime = 2000 },	-- 폭발 시 걸어줄 상태이상 정보
	LinktoWait	= 2,												-- 감옥으로 보내기전 대기시간
}
