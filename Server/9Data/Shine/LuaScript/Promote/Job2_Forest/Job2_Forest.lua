------------------------------------------------------
-- Promote Job2_Forest Main File
------------------------------------------------------

require( "common" )

--[[
require( "Data/Name" ) 										-- ���ϰ��, �����̸�, �������� ���� ���� ���̺�
require( "Data/Process" )		    						-- ���� ������Ÿ�Ӱ� ��ũ ����, ����, ����Ʈ ���� ���� ���� ������
require( "Data/Regen" )										-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "Data/Chat" )										-- ��� ������( NPCDlg, ���� �� )

require( "Functions/SubFunc" )								-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "Functions/Routine" )								-- �� � �ٴ� AI ���� ��ƾ��
require( "Functions/Progress" )								-- �� �ܰ谡 ���ǵ� ���� �Լ���
--]]--

require( "Promote/Job2_Forest/Data/Name" ) 					-- ���ϰ��, �����̸�, �������� ���� ���� ���̺�
require( "Promote/Job2_Forest/Data/Process" )		   		-- ���� ������Ÿ�Ӱ� ��ũ ����, ����, ����Ʈ ���� ���� ���� ������
require( "Promote/Job2_Forest/Data/Regen" )					-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "Promote/Job2_Forest/Data/Chat" )					-- ��� ������( NPCDlg, ���� �� )

require( "Promote/Job2_Forest/Functions/SubFunc" )			-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "Promote/Job2_Forest/Functions/Routine" )			-- �� � �ٴ� AI ���� ��ƾ��
require( "Promote/Job2_Forest/Functions/Progress" )			-- �� �ܰ谡 ���ǵ� ���� �Լ���
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

		Var["InitialSec"] 			= cCurrentSecond()
		Var["CurSec"] 	  			= Var["InitialSec"]
		Var["LimitTime"]			= 0
		Var["FindHeroLimitTime"]	= 0

		Var["StepFunc"]				= InitDungeon

		Var["Elderin"]				= nil
		Var["Roumen"]				= nil

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
