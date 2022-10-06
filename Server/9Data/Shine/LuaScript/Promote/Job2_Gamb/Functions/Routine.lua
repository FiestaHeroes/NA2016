--------------------------------------------------------------------------------
--                  Promote Job2_Gamb Routine                                 --
--------------------------------------------------------------------------------

function DummyRoutineFunc()
cExecCheck "DummyRoutineFunc"
end


----------------------------------------------------------------------
-- MapLogin Function
----------------------------------------------------------------------

function PlayerMapLogin( Field, PlayerHandle )
cExecCheck "PlayerMapLogin"

	--DebugLog("PlayerMapLogin : Start" )

	local Var 	= InstanceField[Field]

	if Var == nil
	then
		cAssertLog( "PlayerMapLogin : Var nil")
		return
	end

	if PlayerHandle == nil
	then
		cAssertLog("PlayerMapLogin : PlayerHandle nil")
		return
	end

	-- �ʿ� �α����ϴ� ù ������ �ڵ鰪�� �ѹ��� ����
	if Var["PlayerHandle"] == INVALID_HANDEL
	then
		Var["PlayerHandle"] = PlayerHandle
	end
end






