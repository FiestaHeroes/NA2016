--------------------------------------------------------------------------------
--                          Mini Dragon Main File                             --
--------------------------------------------------------------------------------

require( "common" )

require( "KQ/MiniDragon/Data/Name" ) 			-- ���ϰ��, �����̸�, �������� ���� ���� ���̺�
require( "KQ/MiniDragon/Data/Process" )			-- ���� ������Ÿ�Ӱ� ��ũ ����, ����, ����Ʈ ���� ���� ���� ������
require( "KQ/MiniDragon/Data/Regen" )			-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "KQ/MiniDragon/Data/Boss" )			-- ���� Boss�� �ൿ ����(ä�� �� ������ ������ ��� ���� ������(����ȯ ���� ����))

require( "KQ/MiniDragon/Functions/SubFunc" )	-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "KQ/MiniDragon/Functions/Routine" )	-- �� � �ٴ� AI ���� ��ƾ��
require( "KQ/MiniDragon/Functions/Progress" )	-- �� �ܰ谡 ���ǵ� ���� �Լ���


function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then

		InstanceField[ Field ] = {}

		Var					= InstanceField[ Field ]
		Var["MapIndex"]		= Field

		Var["Friend"]		= {}
		Var["Enemy"]		= {}
		Var["RoutineTime"] 	= {}


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
