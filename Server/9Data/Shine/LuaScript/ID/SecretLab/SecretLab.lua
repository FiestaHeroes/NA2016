--------------------------------------------------------------------------------
--                    Secret Laboratory Main File                             --
--------------------------------------------------------------------------------

require( "common" )

require( "ID/SecretLab/Data/Name" ) 			-- ���ϰ��, �����̸�, ������, �ܰ� ������ ���� ���� ���̺�
require( "ID/SecretLab/Data/Process" )			-- ���� ������Ÿ�Ӱ� ��ũ ����, ����Ʈ ���� ���� ���� ������
require( "ID/SecretLab/Data/Regen" )			-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "ID/SecretLab/Data/NPC" )				-- NPC���� ó�� ������( NPC �׼� ���� �� �׼��� ����Ű�� ���� ��� ���� )
require( "ID/SecretLab/Data/Boss" )				-- Boss���� ó�� ������( ������ Phase Data(��ȯ �� ����), �����̻�, ġ���� ���� ��� ���� )
require( "ID/SecretLab/Data/Chat" )				-- ��� ä�� ����

require( "ID/SecretLab/Functions/SubFunc" )		-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "ID/SecretLab/Functions/Routine" )		-- �� � �ٴ� AI ���� ��ƾ��
require( "ID/SecretLab/Functions/Progress" )	-- �� �ܰ谡 ���ǵ� ���� �Լ���


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
