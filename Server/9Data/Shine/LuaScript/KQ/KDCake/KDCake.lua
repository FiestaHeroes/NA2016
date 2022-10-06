--------------------------------------------------------------------------------
--                             Main File                                 --
--------------------------------------------------------------------------------
require( "common" )

--[[
require( "Data/Name" ) 				-- ���ϰ��, �����̸�, �������� ���� ���� ���̺�
require( "Data/Process" )		    -- ���� ������Ÿ�Ӱ� ��ũ ����, ����, ����Ʈ ���� ���� ���� ������
require( "Data/Servant" )			-- ��ȯ�� ����
require( "Data/Regen" )				-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)

require( "Functions/SubFunc" )		-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "Functions/Routine" )		-- �� � �ٴ� AI ���� ��ƾ��
require( "Functions/Progress" )		-- �� �ܰ谡 ���ǵ� ���� �Լ���
--]]--


require( "KQ/KDCake/Data/Name" ) 				-- ���ϰ��, �����̸�, �������� ���� ���� ���̺�
require( "KQ/KDCake/Data/Process" )		   		-- ���� ������Ÿ�Ӱ� ��ũ ����, ����, ����Ʈ ���� ���� ���� ������
require( "KQ/KDCake/Data/Servant" )				-- ��ȯ�� ����
require( "KQ/KDCake/Data/Regen" )				-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)

require( "KQ/KDCake/Functions/SubFunc" )		-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "KQ/KDCake/Functions/Routine" )		-- �� � �ٴ� AI ���� ��ƾ��
require( "KQ/KDCake/Functions/Progress" )		-- �� �ܰ谡 ���ǵ� ���� �Լ���
--]]--


function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then
		InstanceField[ Field ]	= {}				-- ŷ�� ���̺� ����

		Var					= InstanceField[ Field ]
		Var["MapIndex"]		= Field					-- �� �ε���( �ʵ� �ε��� )
		Var["InitialSec"]	= cCurrentSecond()		-- ���� ���� �ð�
		Var["CurSec"] 		= Var["InitialSec"]		-- ���� �ð�
		Var["StepFunc"]		= KQInit				-- ���� �Լ�
		Var["Round"]		= 1						-- ���� ����
		Var["RoundEndTime"]	= 0						-- ���� ������ �ð�
		Var["RoundTimeOver"]= false					-- ���� ���ᰡ Ÿ�ӿ��� �ϰ��


		-- �÷��̾� ���� �ʱ�ȭ
		Var["Player"] = {}
--		Var["Player"][ i ]["CharNo"]				= nil
--		Var["Player"][ i ]["CharID"]				= nil
--		Var["Player"][ i ]["Handle"]				= nil
--		Var["Player"][ i ]["TeamType"]				= KQ_TEAM["MAX"]
--------		Var["Player"][ i ]["Goal"]					= nil
--		Var["Player"][ i ]["IsInMap"]				= true
--		Var["Player"][ i ]["CakeHandle"]			= nil
--		Var["Player"][ i ]["CakeAbstateTime"]		= 0
--		Var["Player"][ i ]["PrisonLinkToWaitTime"]	= 0
--		Var["Player"][ i ]["IsOut"]					= false


		-- ���� �ڵ�
--		Var["Door"] = nil


		-- �� ����(����) �ʱ�ȭ
		Var["Team"]	= {}
		Var["Team"][ KQ_TEAM["RED"] ] 	=
		{
			Score 	= 0,
			Win		= 0,
			Lose	= 0,
			Draw	= 0,
		}

		Var["Team"][ KQ_TEAM["BLUE"] ] 	=
		{
			Score 	= 0,
			Win		= 0,
			Lose	= 0,
			Draw	= 0,
		}


--		-- InvisibleDoor ���� �ʱ�ȭ
--		Var["InvisibleDoor"] = nil


		-- �� �α��� �Լ� ����
		cSetFieldScript ( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", 		"PlayerMapLogin" )
		cFieldScriptFunc( Var["MapIndex"], "ServantSummon", "ServantSummon" )
	end


	-- 0.1�� ���� ����
	if Var["CurSec"] + 0.1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	-- �����Լ� ���� ( Functions/Progress.lua )
	Var["StepFunc"]( Var )

end
