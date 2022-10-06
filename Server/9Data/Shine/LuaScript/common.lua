-- 스크립트의 리턴값

-- 몹 AIScript
ReturnAI = {}
ReturnAI.END = 1    -- Return_AI_END = 1;//    -- 모든 AI루틴 끝
ReturnAI.CPP = 2    -- Return_AI_CPP = 2;//    -- 루아로 일부 처리한 후 cpp의 AI루틴 돌림



-- 오브젝트 타입
ObjectType = {}
ObjectType.Invalid		= - 1
ObjectType.Flag			=   0
ObjectType.DropItem		=   1
ObjectType.Player		=   2
ObjectType.MiniHouse	=   3
ObjectType.NPC			=   4
ObjectType.Mob			=   5
ObjectType.MagicField	=   6
ObjectType.Door			=   7
ObjectType.Bandit		=   8
ObjectType.Effect		=   9
ObjectType.Servant		=  10
ObjectType.Mover		=  11
ObjectType.Pet			=  12
ObjectType.Max			=  13


BasicClass = {}

BasicClass.None			= 0
BasicClass.Fighter		= 1
BasicClass.Cleric		= 6
BasicClass.Archer		= 11
BasicClass.Mage			= 16
BasicClass.Joker		= 21


EFFECT_MSG_TYPE =
{
	EMT_WIN				= 0,
	EMT_LOSE			= 1,
	EMT_DRAW			= 2,
	EMT_START			= 3,
	EMT_COUNT_8_SEC		= 4,
	EMT_SUCCESS			= 5,
	EMT_FAIL			= 6,
	EMT_START_OLYMPIC	= 7,
	EMT_GOAL_OLYMPIC	= 8,
	EMT_SOCCER_WIN		= 9,
	EMT_SOCCER_LOSE		= 10,
	EMT_SOCCER_DRAW		= 11,
	EMT_SOCCER_KICK_OFF = 12,
	EMT_SOCCER_GOAL		= 13,
	EMT_WATER_START		= 14,
}


-- 킹덤 퀘스트 팀
KQ_TEAM =
{
	RED		= 0,
	BLUE	= 1,

	MAX		= 2,
}


-- 맵에 첫 플레이어가 로그인 하기를 기다리는 최대 시간
WAIT_PLAYER_MAP_LOGIN_SEC_MAX = 240


--인던 필드 정보
InstanceField = {}

function InstanceDungeonClear( Field )
cExecCheck "InstanceDungeonClear"

	InstanceField[Field] = nil

end
