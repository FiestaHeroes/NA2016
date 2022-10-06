--------------------------------------------------------------------------------
--                      Seiren Castle Main File                               --
--------------------------------------------------------------------------------

require( "common" )

require( "ID/SirenH/Data/Name" )				-- ���ϰ��, �����̸�, ������, �ܰ� ������ ���� ���� ���̺�
require( "ID/SirenH/Data/Chat" )				-- ��� ä�� ����
require( "ID/SirenH/Data/Process" )			-- ���� ������Ÿ�Ӱ� ��ũ ����, ����Ʈ ���� ���� ���� ������
require( "ID/SirenH/Data/Regen" )			-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "ID/SirenH/Data/Stuff" )			-- Stuff���� ó�� ������( NPC �׼� ���� �� �׼��� ����Ű�� ���� ��� ���� )
require( "ID/SirenH/Data/Boss" )				-- Boss���� ó�� ������( ������ Phase Data(��ȯ �� ����), �����̻�, ġ���� ���� ��� ���� )

require( "ID/SirenH/Functions/SubFunc" )		-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "ID/SirenH/Functions/Routine" )		-- �� � �ٴ� AI ���� ��ƾ��
require( "ID/SirenH/Functions/Progress" )	-- �� �ܰ谡 ���ǵ� ���� �Լ���


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
		Var["Portal"]		= {}	-- ��Ż ���� ��� �޸�
		Var["RoutineTime"] 	= {}	-- ��ƾ Ÿ���� �ڵ鸶�� �����ϴ� �޸�


		cSetFieldScript ( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )


		Var["StepIndex"]	= nil
		Var["StepFunc"] 	= nil


		-- ���� �ð� �Է�
		Var["InitialSec"] 	= cCurrentSecond()
		Var["CurSec"] 	  	= cCurrentSecond()


		-- ù ��������
		GoToNextStep( Var )

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
