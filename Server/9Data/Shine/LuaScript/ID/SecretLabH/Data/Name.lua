--------------------------------------------------------------------------------
--                     Secret Laboratory Name Data                            --
--------------------------------------------------------------------------------

MainLuaScriptPath 		= "ID/SecretLabH/SecretLabH"
MsgScriptFileDefault 	= "Tower03"


-- 각 단계 이름을 모아놓음
StepNameTable =
{
	"Floor01",
	"Floor02",
	"Floor03",
	"Floor04",
	"Floor05",

	"Floor06",
	"Floor07",
	"Floor08",
	"Floor09",
	"Floor10",

	"RescuedChildren",
}


-- 타임어택 시 시작되는 지역인덱스를 모아놓은 테이블.
-- 타임어택 순서대로 지역 이름이 하나씩 순차적으로 적용됨.
AreaIndexTable =
{
	"TimeStart01",
	"TimeStart02",
	"TimeStart03",
	"TimeStart04",
	"TimeStart05",
}


-- 패턴 이름이 지정된 테이블
PatternNameTable =
{
	"Pattern_KillAll",
	"Pattern_TimeAttack",
	"Pattern_KillBoss",
}


-- 각 층마다 어떤 패턴인지 지정되어 있는 테이블
FloorPatternInfoTable =
{
	"Pattern_KillAll",		-- 1st Floor
	"Pattern_TimeAttack",	-- 2nd Floor
	"Pattern_TimeAttack",	-- 3rd Floor
	"Pattern_TimeAttack",	-- 4th Floor
	"Pattern_KillBoss",		-- 5th Floor

	"Pattern_KillAll",		-- 6th Floor
	"Pattern_KillAll",		-- 7th Floor
	"Pattern_TimeAttack",	-- 8th Floor
	"Pattern_TimeAttack",	-- 9th Floor
	"Pattern_KillBoss",		-- 10th Floor
}


-- 보스가 사용하는 기술 이름을 모아놓음
BossSkillNameTable =
{
	"Summon",
	"PeriodicSummon",
}
