--------------------------------------------------------------------------------
--                           Anti Henis Main File                             --
--------------------------------------------------------------------------------

require( "common" )

require( "KQ/AntiHenis/Data/Name" ) 			-- ���ϰ��, �����̸�, �������� ���� ���� ���̺�
require( "KQ/AntiHenis/Data/Process" )			-- ���� ������Ÿ�Ӱ� ��ũ ����, ����, ����Ʈ ���� ���� ���� ������
require( "KQ/AntiHenis/Data/Regen" )			-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "KQ/AntiHenis/Data/NPC" )				-- NPC�� �ൿ ����(���̽���(Dialog), ������, �Ϲ� ä�� ��)
require( "KQ/AntiHenis/Data/Boss" )				-- ���� Boss�� �ൿ ����(ä�� �� ������ ������ ��� ���� ������(����ȯ ���� ����))

require( "KQ/AntiHenis/Functions/SubFunc" )		-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "KQ/AntiHenis/Functions/Routine" )		-- �� � �ٴ� AI ���� ��ƾ��
require( "KQ/AntiHenis/Functions/Progress" )	-- �� �ܰ谡 ���ǵ� ���� �Լ���


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
