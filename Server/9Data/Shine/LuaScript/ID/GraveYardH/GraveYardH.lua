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

require( "ID/GraveYardH/Data/Name" )				-- ���ϰ��, �����̸�, ������, �ܰ� ������ ���� ���� ���̺�
require( "ID/GraveYardH/Data/Chat" )				-- ��� ä�� ����
require( "ID/GraveYardH/Data/Process" )				-- ���� ������Ÿ�Ӱ� ��ũ ����, ����Ʈ ���� ���� ���� ������
require( "ID/GraveYardH/Data/Regen" )				-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "ID/GraveYardH/Data/Stuff" )				-- Stuff���� ó�� ������( NPC �׼� ���� �� �׼��� ����Ű�� ���� ��� ���� )
require( "ID/GraveYardH/Data/Boss" )				-- Boss���� ó�� ������( ������ Phase Data(��ȯ �� ����), �����̻�, ġ���� ���� ��� ���� )

require( "ID/GraveYardH/Functions/SubFunc" )		-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "ID/GraveYardH/Functions/Routine" )		-- �� � �ٴ� AI ���� ��ƾ��
require( "ID/GraveYardH/Functions/Progress" )		-- �� �ܰ谡 ���ǵ� ���� �Լ���
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
		Var["GateProcess"]	= {}	-- ����Ʈ ���º��� ó���ϴ� �޸�


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
