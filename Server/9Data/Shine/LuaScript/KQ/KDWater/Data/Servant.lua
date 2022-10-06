--------------------------------------------------------------------------------
--                                Servant Data                                --
--------------------------------------------------------------------------------


-- 물풍선
WaterBalloon =
{
	MobIndex		= "BallWater",										-- 몹 인덱스
	SkillIndex		= "BallWater_Skill01_N",							-- 스킬 인덱스
	Dist			= 50,												-- 폭발 시 체크 범위
	Abstate 		= { Index = "StaKnockBackFly", KeepTime = 2000 },	-- 폭발 시 걸어줄 상태이상 정보
	SetAbstateWait	= 0.2,												-- SetAbstateWait 시간 후 상태이상 걸이줌
	LinktoWait		= 2,												-- 감옥으로 보내기전 대기시간
}

-- 물대포
WaterCannon =
{
	MobIndex	= "BallCannon",										-- 몹 인덱스
	Dist		= 100,												-- 폭발 시 체크 범위
	Abstate 	= { Index = "StaKnockBackRoll", KeepTime = 2000 },	-- 폭발 시 걸어줄 상태이상 정보
	LinktoWait	= 2,												-- 감옥으로 보내기전 대기시간
}
