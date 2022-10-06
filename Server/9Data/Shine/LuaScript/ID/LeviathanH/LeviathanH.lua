
require( "common" )

--[[
require( "Data/Name" )
require( "Data/Process" )
require( "Data/Chat" )
require( "Data/Regen" )

require( "Functions/SubFunc" )
require( "Functions/Routine" )
require( "Functions/Progress" )
--]]

require( "ID/LeviathanH/Data/Name" )
require( "ID/LeviathanH/Data/Process" )
require( "ID/LeviathanH/Data/Chat" )
require( "ID/LeviathanH/Data/Regen" )

require( "ID/LeviathanH/Functions/SubFunc" )
require( "ID/LeviathanH/Functions/Routine" )
require( "ID/LeviathanH/Functions/Progress" )
--]]

function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then

		InstanceField[ Field ] = {}

		Var					= InstanceField[ Field ]
		Var["MapIndex"]		= Field

		Var["Door"]			= {}	-- 문 정보 담는 메모리
		Var["Boss"]			= {}	-- 보스몹 정보 담는 메모리
		Var["RoutineTime"] 	= {}	-- 루틴 타임을 핸들마다 보관하는 메모리

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
