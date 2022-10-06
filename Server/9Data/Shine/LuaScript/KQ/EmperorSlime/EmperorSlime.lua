--------------------------------------------------------------------------------
--                          Emperor Slime Main File                           --
--------------------------------------------------------------------------------

require( "common" )

require( "KQ/EmperorSlime/Data/Name" ) 			-- ���ϰ��, �����̸�, �������� ���� ���� ���̺�
require( "KQ/EmperorSlime/Data/Process" )		-- ���� ������Ÿ�Ӱ� ��ũ ����, ����, ����Ʈ ���� ���� ���� ������
require( "KQ/EmperorSlime/Data/Regen" )			-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "KQ/EmperorSlime/Data/NPC" )			-- NPC�� �ൿ ����(���̽���(Dialog), ������, �Ϲ� ä�� ��)
require( "KQ/EmperorSlime/Data/Boss" )			-- ���� Boss�� �ൿ ����(ä�� �� ������ ������ ��� ���� ������(����ȯ ���� ����))

require( "KQ/EmperorSlime/Functions/SubFunc" )	-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "KQ/EmperorSlime/Functions/Routine" )	-- �� � �ٴ� AI ���� ��ƾ��
require( "KQ/EmperorSlime/Functions/Progress" )	-- �� �ܰ谡 ���ǵ� ���� �Լ���


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
