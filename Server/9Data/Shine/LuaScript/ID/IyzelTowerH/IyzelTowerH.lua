--------------------------------------------------------------------------------
--                       Tower Of Iyzel Main File                             --
--------------------------------------------------------------------------------

require( "common" )

require( "ID/IyzelTowerH/Data/Name" ) 			-- ���ϰ��, �����̸�, �������� ���� ���� ���̺�
require( "ID/IyzelTowerH/Data/Process" )			-- ���� ������Ÿ�Ӱ� ��ũ ����, ����, ����Ʈ ���� ���� ���� ������
require( "ID/IyzelTowerH/Data/Regen" )			-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "ID/IyzelTowerH/Data/NPC" )				-- NPC�� �ൿ ����(���̽���(Dialog), ������, �Ϲ� ä�� ��)
require( "ID/IyzelTowerH/Data/Boss" )			-- ���� Boss�� �ൿ ����(ä�� �� ������ ������ ��� ���� ������(����ȯ ���� ����))

require( "ID/IyzelTowerH/Functions/SubFunc" )	-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "ID/IyzelTowerH/Functions/Routine" )	-- �� � �ٴ� AI ���� ��ƾ��
require( "ID/IyzelTowerH/Functions/Progress" )	-- �� �ܰ谡 ���ǵ� ���� �Լ���


function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then

		InstanceField[ Field ] = {}

		Var					= InstanceField[ Field ]
		Var["MapIndex"]		= Field

		Var["Enemy"]		= {}
		Var["Door"]			= {}
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
