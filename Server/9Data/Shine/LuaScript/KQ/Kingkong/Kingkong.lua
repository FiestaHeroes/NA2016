--------------------------------------------------------------------------------
--                           Kingkong Main File                             --
--------------------------------------------------------------------------------

require( "common" )

require( "KQ/Kingkong/Data/Name" )			-- ���ϰ��, �����̸�, �������� ���� ���� ���̺�
require( "KQ/Kingkong/Data/Process" )       -- ���� ������Ÿ�Ӱ� ��ũ ����, ����, ����Ʈ ���� ���� ���� ������
require( "KQ/Kingkong/Data/Regen" )         -- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "KQ/Kingkong/Data/Boss" )          -- ���� Boss�� �ൿ ����(ä�� �� ������ ������ ��� ���� ������(����ȯ ���� ����))

require( "KQ/Kingkong/Functions/SubFunc" )  -- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "KQ/Kingkong/Functions/Routine" )  -- �� � �ٴ� AI ���� ��ƾ��
require( "KQ/Kingkong/Functions/Progress" ) -- �� �ܰ谡 ���ǵ� ���� �Լ���


function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then

		InstanceField[ Field ] = {}

		Var					= InstanceField[ Field ]
		Var["MapIndex"]		= Field


		cSetFieldScript ( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )

		Var["StepFunc"] = DummyFunc

		-- ���� �ð� �Է�
		Var["InitialSec"] = cCurrentSecond()
		Var["CurSec"] 	  = cCurrentSecond()

		-- ù ��������
		GoToNextStep( Var )

	end

	Var["StepFunc"]   ( Var )

end
