--------------------------------------------------------------------------------
--                    Secret Laboratory Main File                             --
--------------------------------------------------------------------------------

require( "common" )

require( "ID/SecretLabH/Data/Name" ) 			-- ���ϰ��, �����̸�, ������, �ܰ� ������ ���� ���� ���̺�
require( "ID/SecretLabH/Data/Process" )			-- ���� ������Ÿ�Ӱ� ��ũ ����, ����Ʈ ���� ���� ���� ������
require( "ID/SecretLabH/Data/Regen" )			-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "ID/SecretLabH/Data/NPC" )				-- NPC���� ó�� ������( NPC �׼� ���� �� �׼��� ����Ű�� ���� ��� ���� )
require( "ID/SecretLabH/Data/Boss" )				-- Boss���� ó�� ������( ������ Phase Data(��ȯ �� ����), �����̻�, ġ���� ���� ��� ���� )
require( "ID/SecretLabH/Data/Chat" )				-- ��� ä�� ����

require( "ID/SecretLabH/Functions/SubFunc" )		-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "ID/SecretLabH/Functions/Routine" )		-- �� � �ٴ� AI ���� ��ƾ��
require( "ID/SecretLabH/Functions/Progress" )	-- �� �ܰ谡 ���ǵ� ���� �Լ���


function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then

		InstanceField[ Field ] = {}

		Var					= InstanceField[ Field ]
		Var["MapIndex"]		= Field

		Var["Friend"]		= {}	-- �Ʊ� ���� ��� �޸�
		Var["Enemy"]		= {}	-- �� ���� ��� �޸�
		Var["Door"]			= {}	-- �� ���� ��� �޸�
		Var["RoutineTime"] 	= {}	-- ��ƾ Ÿ���� �ڵ鸶�� �����ϴ� �޸�
		Var["StageInfo"]	= {}	-- �������� ������ �Բ� �� �ܰ� ������ �������� �޸�


		cSetFieldScript ( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )

		Var["StepFunc"] = DummyFunc

		-- ���� �ð� �Է�
		Var["InitialSec"] = cCurrentSecond()
		Var["CurSec"] 	  = cCurrentSecond()

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
	Var["StepFunc"]   ( Var )

end
