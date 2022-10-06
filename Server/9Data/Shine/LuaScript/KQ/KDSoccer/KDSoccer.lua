--------------------------------------------------------------------------------
--                             Main File                                 --
--------------------------------------------------------------------------------
require( "common" )

--[[
require( "Data/Name" ) 				-- ���ϰ��, �����̸�, �������� ���� ���� ���̺�
require( "Data/Process" )		    -- ���� ������Ÿ�Ӱ� ��ũ ����, ����, ����Ʈ ���� ���� ���� ������
require( "Data/NPC" )			    -- NPC ����
require( "Data/Regen" )				-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)

require( "Functions/SubFunc" )		-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "Functions/Routine" )		-- �� � �ٴ� AI ���� ��ƾ��
require( "Functions/Progress" )		-- �� �ܰ谡 ���ǵ� ���� �Լ���
--]]--


require( "KQ/KDSoccer/Data/Name" ) 				-- ���ϰ��, �����̸�, �������� ���� ���� ���̺�
require( "KQ/KDSoccer/Data/Process" )		    -- ���� ������Ÿ�Ӱ� ��ũ ����, ����, ����Ʈ ���� ���� ���� ������
require( "KQ/KDSoccer/Data/NPC" )			    -- NPC ����
require( "KQ/KDSoccer/Data/Regen" )				-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)

require( "KQ/KDSoccer/Functions/SubFunc" )		-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "KQ/KDSoccer/Functions/Routine" )		-- �� � �ٴ� AI ���� ��ƾ��
require( "KQ/KDSoccer/Functions/Progress" )		-- �� �ܰ谡 ���ǵ� ���� �Լ���
--]]--


function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then
		InstanceField[ Field ]	= {}						-- ŷ�� ���̺� ����

		Var					= InstanceField[ Field ]
		Var["MapIndex"]		= Field					-- �� �ε���( �ʵ� �ε��� )
		Var["KQLimitTime"]	= 0						-- ŷ�� ���� �ð�
		Var["InitialSec"]	= cCurrentSecond()		-- ���� ���� �ð�
		Var["CurSec"] 		= Var["InitialSec"]		-- ���� �ð�
		Var["StepFunc"]		= InitSoccer			-- ���� �Լ�-


		-- �÷��̾� ���� �ʱ�ȭ
		Var["Player"] = {}
--		Var["Player"][ i ]["CharNo"]	= nil
--		Var["Player"][ i ]["CharID"]	= nil
--		Var["Player"][ i ]["Handle"]	= nil
--		Var["Player"][ i ]["TeamType"]	= KQ_TEAM["MAX"]
--		Var["Player"][ i ]["Goal"]		= nil
--		Var["Player"][ i ]["IsInMap"]	= true
--		Var["Player"][ i ]["SpeedUpBuff"]		= {}	-- �ɸ��� ������ش�.
--		Var["Player"][ i ]["InvincibleBuff"]	= {}	-- �ɸ��� ������ش�.



		-- �� ����(����) �ʱ�ȭ
		Var["Team"]	= {}
		Var["Team"][ KQ_TEAM["RED"] ] 	= 0
		Var["Team"][ KQ_TEAM["BLUE"] ] 	= 0


		-- Kicker ���� �ʱ�ȭ
		Var["Kicker"]	= {}
--		Var["Kicker"]["IsPlayer"]	= nil
--		Var["Kicker"]["TeamType"]	= KQ_TEAM["MAX"]
--		Var["Kicker"]["CharNo"]		= nil
--		Var["Kicker"]["NPCHandle"]	= nil


		-- InvisibleDoor ���� �ʱ�ȭ
		Var["InvisibleDoor"] = nil


		-- SoccerBall ���� �ʱ�ȭ
		Var["SoccerBall"] = nil


		-- Referee ���� �ʱ�ȭ
		Var["Referee"] = {}
--		Var["Referee"]["Handle"]			= nil
--		Var["Referee"]["FollowCheckTime"]	= 0
--		Var["Referee"]["RoutineCheckTime"]	= 0


		-- Keeper ���� �ʱ�ȭ
		Var["Keeper"] = {}
--		Var["Keeper"][ i ]["Handle"]			= nil
--		Var["Keeper"][ i ]["TeamType"]			= KQ_TEAM["MAX"]
--		Var["Keeper"][ i ]["RoutineCheckTime"]	= 0
--		Var["Keeper"][ i ]["MoveStep"]			= 1
--		Var["Keeper"][ i ]["MoveBack"]			= false


		-- BuffBox ���� �ʱ�ȭ
		Var["BuffBox"] = {}
--		Var["BuffBox"][ i ] = 0  ���� ���� �ð�


		-- �� �α��� �Լ� ����
		cSetFieldScript ( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )
	end


	-- 0.1�� ���� ����
	if Var["CurSec"] + 0.1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	-- �����Լ� ���� ( Functions/Progress.lua )
	Var["StepFunc"]   ( Var )

end
