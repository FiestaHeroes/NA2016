------------------------------------------------------
-- Main File
------------------------------------------------------

require( "common" )

--[[
require( "Data/Name" ) 					-- ���ϰ��, �����̸�, �������� ���� ���� ���̺�
require( "Data/Process" )		    	-- ���� ������Ÿ�Ӱ� ��ũ ����, ����, ����Ʈ ���� ���� ���� ������
require( "Data/Regen" )					-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)

require( "Functions/SubFunc" )			-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "Functions/Routine" )			-- �� � �ٴ� AI ���� ��ƾ��
require( "Functions/Progress" )			-- �� �ܰ谡 ���ǵ� ���� �Լ���
--]]--

require( "Promote/Job2_Gamb/Data/Name" ) 					-- ���ϰ��, �����̸�, �������� ���� ���� ���̺�
require( "Promote/Job2_Gamb/Data/Process" )		   		 	-- ���� ������Ÿ�Ӱ� ��ũ ����, ����, ����Ʈ ���� ���� ���� ������
require( "Promote/Job2_Gamb/Data/Regen" )					-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)

require( "Promote/Job2_Gamb/Functions/SubFunc" )			-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "Promote/Job2_Gamb/Functions/Routine" )			-- �� � �ٴ� AI ���� ��ƾ��
require( "Promote/Job2_Gamb/Functions/Progress" )			-- �� �ܰ谡 ���ǵ� ���� �Լ���
--]]--


----------------------------------------------------------------------
-- Main : �����Լ�
----------------------------------------------------------------------

function Main( Field )
cExecCheck "Main"

	local Var						= InstanceField[Field]	-- ����

	if Var == nil
	then

		InstanceField[Field]		= {}

		Var							= InstanceField[Field]
		Var["MapIndex"]				= Field
		Var["PlayerHandle"] 		= INVALID_HANDEL

		Var["Door"]					= {}
		--Var["Door"]["Handle"]		= {}
		--Var["Door"]["Handle"][i]	= nil

		Var["Roulette"]				= {}
		--Var["Roulette"]["Handle"]	= nil

		Var["Dice"]					= {}
		--Var["Dice"]["Handle"]		= {}
		--Var["Dice"]["Handle"][i]	= nil

		Var["NPC"]					= {}
		--Var["NPC"]["Handle"]		= nil

		--Var["InitDungeon"]		= nil
		--Var["WelcomeGamble"] 		= nil
		--Var["PlayRouletteGame"]	= nil
		--Var["LoseRouletteGame"]	= nil
		--Var["WinRouletteGame"]	= nil
		--Var["BeforeBossBattle"]	= nil
		--Var["BossBattle"]			= nil
		--Var["QuestSuccess"]		= nil
		--Var["ReturnToHome"]		= nil

		Var["InitialSec"] 			= cCurrentSecond()
		Var["CurSec"] 	  			= Var["InitialSec"]
		Var["LimitTime"]			= 0
		Var["StepFunc"]				= InitDungeon
		Var["RouletteCount"]		= 0

		-- �ʵ� ��ũ��Ʈ ����
		cSetFieldScript				( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc			( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )

	end

	-- 0.5�� ���� ����
	if Var["CurSec"] + 0.5 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end

	Var["StepFunc"] ( Var )
end
