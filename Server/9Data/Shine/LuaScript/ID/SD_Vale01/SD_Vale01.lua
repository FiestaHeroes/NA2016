
require( "common" )

--[[

require( "Data/Name" )
require( "Data/Process" )
require( "Data/Chat" )
require( "Data/Regen" )
require( "Data/SkillInfo_KingCrab" )
require( "Data/SkillInfo_KingSlime" )
require( "Data/SkillInfo_MiniDragon" )

require( "Functions/SubFunc" )
require( "Functions/Routine" )
require( "Functions/Routine_KingCrab" )
require( "Functions/Routine_KingSlime" )
require( "Functions/Routine_MiniDragon" )
require( "Functions/Progress" )
--]]

require( "ID/SD_Vale01/Data/Name" )
require( "ID/SD_Vale01/Data/Process" )
require( "ID/SD_Vale01/Data/Chat" )
require( "ID/SD_Vale01/Data/Regen" )
require( "ID/SD_Vale01/Data/SkillInfo_KingCrab" )
require( "ID/SD_Vale01/Data/SkillInfo_KingSlime" )
require( "ID/SD_Vale01/Data/SkillInfo_MiniDragon" )


require( "ID/SD_Vale01/Functions/SubFunc" )
require( "ID/SD_Vale01/Functions/Routine" )
require( "ID/SD_Vale01/Functions/Routine_KingCrab" )
require( "ID/SD_Vale01/Functions/Routine_KingSlime" )
require( "ID/SD_Vale01/Functions/Routine_MiniDragon" )
require( "ID/SD_Vale01/Functions/Progress" )

--]]

function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then

		InstanceField[ Field ] = {}

		Var					= InstanceField[ Field ]
		Var["MapIndex"]		= Field

		cSetFieldScript ( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )

		-- 최초 시간 입력
		Var["InitialSec"] 	= cCurrentSecond()
		Var["CurSec"] 	  	= cCurrentSecond()

		-- 첫 스텝으로
		Var["StepFunc"] = InitDungeon

	end

	-- 0.05초마다 실행
	if Var["CurSec"] + 0.05 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end

	Var["StepFunc"] ( Var )

end
