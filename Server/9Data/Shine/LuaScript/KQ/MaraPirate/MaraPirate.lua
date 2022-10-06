--------------------------------------------------------------------------------
--                          Mara Pirate Main File                             --
--------------------------------------------------------------------------------

require( "common" )

require( "KQ/MaraPirate/Data/Name" )			-- ���ϰ��, �����̸�, �������� ���� ���� ���̺�
require( "KQ/MaraPirate/Data/Process" )         -- ���� ������Ÿ�Ӱ� ��ũ ����, ����, ����Ʈ ���� ���� ���� ������
require( "KQ/MaraPirate/Data/Regen" )           -- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "KQ/MaraPirate/Data/NPC" )             -- NPC�� �ൿ ����(���̽���(Dialog), ������, �Ϲ� ä�� ��)
require( "KQ/MaraPirate/Data/Boss" )            -- ���� Boss�� �ൿ ����(ä�� �� ������ ������ ��� ���� ������(����ȯ ���� ����))

require( "KQ/MaraPirate/Functions/SubFunc" )    -- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "KQ/MaraPirate/Functions/Routine" )    -- �� � �ٴ� AI ���� ��ƾ��
require( "KQ/MaraPirate/Functions/Progress" )   -- �� �ܰ谡 ���ǵ� ���� �Լ���


function Main( Field )
	cExecCheck( "Main" )

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


	-- �����Լ� ����( Functions/Progress.lua )
	Var["StepFunc"]( Var )
end
