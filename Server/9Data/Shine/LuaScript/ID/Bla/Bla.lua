--------------------------------------------------------------------------------
--                      Seiren Castle Main File                               --
--------------------------------------------------------------------------------

require( "common" )

--[[
require( "Data/Name" )				-- ���ϰ��, �����̸�, ������, �ܰ� ������ ���� ���� ���̺�
require( "Data/Chat" )				-- ��� ä�� ����
require( "Data/Process" )			-- ���� ������Ÿ�Ӱ� ��ũ ����, ����Ʈ ���� ���� ���� ������
require( "Data/Regen" )				-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "Data/Stuff" )				-- Stuff���� ó�� ������( NPC �׼� ���� �� �׼��� ����Ű�� ���� ��� ���� )
require( "Data/Boss" )				-- Boss���� ó�� ������

require( "Functions/SubFunc" )		-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "Functions/Routine" )		-- �� � �ٴ� AI ���� ��ƾ��
require( "Functions/Progress" )		-- �� �ܰ谡 ���ǵ� ���� �Լ���

--]]

require( "ID/Bla/Data/Name" )
require( "ID/Bla/Data/Chat" )
require( "ID/Bla/Data/Process" )
require( "ID/Bla/Data/Regen" )
require( "ID/Bla/Data/Stuff" )
require( "ID/Bla/Data/Boss" )

require( "ID/Bla/Functions/SubFunc" )
require( "ID/Bla/Functions/Routine" )
require( "ID/Bla/Functions/Progress" )
--]]

function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then

		InstanceField[ Field ] = {}

		Var					= InstanceField[ Field ]
		Var["MapIndex"]		= Field

		Var["AreaMobGroup"] 						= {}	-- ��� ���� �������� �������� ������ ����� �����ص�

		Var["RootManager"]							= {}
		Var["RootManager"]["RootA"]					= 1
		Var["RootManager"]["RootB"]					= 1
		Var["RootManager"]["DelayTime"]				= {}
		Var["RootManager"]["DelayTime"]["RootA"]	= cCurrentSecond() + DelayTime["RootManagerFuncTick"]
		Var["RootManager"]["DelayTime"]["RootB"]	= cCurrentSecond() + DelayTime["RootManagerFuncTick"]


		Var["Door"]									= {}	-- �� ���� ��� �޸�

		Var["RoutineTime"]							= {}
		--Var["RoutineTime"]["Routine_Blakan"]
		--Var["RoutineTime"]["Routine_Seal"]
		--Var["RoutineTime"]["Routine_Fagels"]


		Var["Enemy"]								= {}	-- �� ���� ��� �޸�
		--Var["Enemy"]["MildWin"]
		--Var["Enemy"]["Blakan"]
		--Var["Enemy"]["Seal"]{}
		--Var["Enemy"]["Fagels"]



		Var["TimeList"]								= {}
		--Var["TimeList"]["FaceCutArea"]			= {}
		--Var["TimeList"]["FaceCutArea"]["PlayerEntrance"]
		--Var["TimeList"]["FaceCutArea"]["Dialog_Blakan"]

		--Var["TimeList"]["TeleportArea"]			= {}
		--Var["TimeList"]["TeleportArea"]["PlayerEntrance"]
		--Var["TimeList"]["TeleportArea"]["Dialog_Blakan"]
		--Var["TimeList"]["TeleportArea"]["Dialog_Fagels"]
		--Var["TimeList"]["TeleportArea"]["SummonStart"]


		cSetFieldScript ( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )

		-- ���� �ð� �Է�
		Var["InitialSec"] 	= cCurrentSecond()
		Var["CurSec"] 	  	= cCurrentSecond()

		DebugLog("�����Լ� ����")

		-- ù ��������
		Var["StepFunc"]		= InitDungeon

		-- �������� ������ ����
		RandomRegenMobGroupSetFunc( Var )

	end


	-- 0.2�ʸ��� ����
	if Var["CurSec"] + 0.5 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	-- �����Լ� ���� ( Functions/Progress.lua )
	Var["StepFunc"]( Var )


	RootManagerFunc( Var, "RootA" )
	RootManagerFunc( Var, "RootB" )
	TeleportFunc( Var )

end
