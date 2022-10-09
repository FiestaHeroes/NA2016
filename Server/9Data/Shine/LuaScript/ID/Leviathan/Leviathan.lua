
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

require( "ID/Leviathan/Data/Name" )
require( "ID/Leviathan/Data/Process" )
require( "ID/Leviathan/Data/Chat" )
require( "ID/Leviathan/Data/Regen" )

require( "ID/Leviathan/Functions/SubFunc" )
require( "ID/Leviathan/Functions/Routine" )
require( "ID/Leviathan/Functions/Progress" )
--]]

function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then

		InstanceField[ Field ] = {}

		Var					= InstanceField[ Field ]
		Var["MapIndex"]		= Field

		Var["Door"]			= {}	-- �� ���� ��� �޸�
		Var["Boss"]			= {}	-- ������ ���� ��� �޸�
		Var["RoutineTime"] 	= {}	-- ��ƾ Ÿ���� �ڵ鸶�� �����ϴ� �޸�

		cSetFieldScript ( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )

		-- ���� �ð� �Է�
		Var["InitialSec"] 	= cCurrentSecond()
		Var["CurSec"] 	  	= cCurrentSecond()

		-- ù ��������
		Var["StepFunc"] = InitDungeon

	end

	-- 0.05�ʸ��� ����
	if Var["CurSec"] + 0.05 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end

	Var["StepFunc"] ( Var )

end