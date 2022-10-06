--------------------------------------------------------------------------------
--                      Seiren Castle Main File                               --
--------------------------------------------------------------------------------

require( "common" )

require( "ID/Siren/Data/Name" )				-- ���ϰ��, �����̸�, ������, �ܰ� ������ ���� ���� ���̺�
require( "ID/Siren/Data/Chat" )				-- ��� ä�� ����
require( "ID/Siren/Data/Process" )			-- ���� ������Ÿ�Ӱ� ��ũ ����, ����Ʈ ���� ���� ���� ������
require( "ID/Siren/Data/Regen" )			-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "ID/Siren/Data/Stuff" )			-- Stuff���� ó�� ������( NPC �׼� ���� �� �׼��� ����Ű�� ���� ��� ���� )
require( "ID/Siren/Data/Boss" )				-- Boss���� ó�� ������( ������ Phase Data(��ȯ �� ����), �����̻�, ġ���� ���� ��� ���� )

require( "ID/Siren/Functions/SubFunc" )		-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "ID/Siren/Functions/Routine" )		-- �� � �ٴ� AI ���� ��ƾ��
require( "ID/Siren/Functions/Progress" )	-- �� �ܰ谡 ���ǵ� ���� �Լ���


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
