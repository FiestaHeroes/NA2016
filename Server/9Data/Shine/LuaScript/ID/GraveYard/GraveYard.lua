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
require( "Data/Boss" )				-- Boss���� ó�� ������( ������ Phase Data(��ȯ �� ����), �����̻�, ġ���� ���� ��� ���� )

require( "Functions/SubFunc" )		-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "Functions/Routine" )		-- �� � �ٴ� AI ���� ��ƾ��
require( "Functions/Progress" )		-- �� �ܰ谡 ���ǵ� ���� �Լ���
--]]

require( "ID/GraveYard/Data/Name" )				-- ���ϰ��, �����̸�, ������, �ܰ� ������ ���� ���� ���̺�
require( "ID/GraveYard/Data/Chat" )				-- ��� ä�� ����
require( "ID/GraveYard/Data/Process" )			-- ���� ������Ÿ�Ӱ� ��ũ ����, ����Ʈ ���� ���� ���� ������
require( "ID/GraveYard/Data/Regen" )			-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "ID/GraveYard/Data/Stuff" )			-- Stuff���� ó�� ������( NPC �׼� ���� �� �׼��� ����Ű�� ���� ��� ���� )
require( "ID/GraveYard/Data/Boss" )				-- Boss���� ó�� ������( ������ Phase Data(��ȯ �� ����), �����̻�, ġ���� ���� ��� ���� )

require( "ID/GraveYard/Functions/SubFunc" )		-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "ID/GraveYard/Functions/Routine" )		-- �� � �ٴ� AI ���� ��ƾ��
require( "ID/GraveYard/Functions/Progress" )	-- �� �ܰ谡 ���ǵ� ���� �Լ���
--]]

function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then

		InstanceField[ Field ] = {}

		Var					= InstanceField[ Field ]
		Var["MapIndex"]		= Field

		Var["Enemy"]		= {}	-- �� ���� ��� �޸�
		Var["Door"]			= {}	-- �� ���� ��� �޸�
		Var["RoutineTime"] 	= {}	-- ��ƾ Ÿ���� �ڵ鸶�� �����ϴ� �޸�
		Var["GateProcess"]	= {}	-- ���� ����Ʈ ������ ��� �޸�


		cSetFieldScript ( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )

		-- ���� �ð� �Է�
		Var["InitialSec"] 	= cCurrentSecond()
		Var["CurSec"] 	  	= cCurrentSecond()

		DebugLog("�����Լ� ����")

		-- ù ��������
		Var["StepFunc"]		= InitDungeon

	end


	-- 0.5�ʸ��� ����
	if Var["CurSec"] + 0.5 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	-- �����Լ� ���� ( Functions/Progress.lua )
	Var["StepFunc"]( Var )
end
