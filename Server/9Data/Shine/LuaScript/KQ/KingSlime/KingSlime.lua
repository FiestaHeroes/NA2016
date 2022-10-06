--------------------------------------------------------------------------------
--                           King Slime Main File                             --
--------------------------------------------------------------------------------

require( "common" )

require( "KQ/KingSlime/Data/Name" ) 			-- ���ϰ��, �����̸�, �������� ���� ���� ���̺�
require( "KQ/KingSlime/Data/Process" )			-- ���� ������Ÿ�Ӱ� ��ũ ����, ����, ����Ʈ ���� ���� ���� ������
require( "KQ/KingSlime/Data/Regen" )			-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "KQ/KingSlime/Data/NPC" )				-- NPC�� �ൿ ����(���̽���(Dialog), ������, �Ϲ� ä�� ��)
require( "KQ/KingSlime/Data/Boss" )				-- ���� Boss�� �ൿ ����(ä�� �� ������ ������ ��� ���� ������(����ȯ ���� ����))

require( "KQ/KingSlime/Functions/SubFunc" )		-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "KQ/KingSlime/Functions/Routine" )		-- �� � �ٴ� AI ���� ��ƾ��
require( "KQ/KingSlime/Functions/Progress" )	-- �� �ܰ谡 ���ǵ� ���� �Լ���


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
