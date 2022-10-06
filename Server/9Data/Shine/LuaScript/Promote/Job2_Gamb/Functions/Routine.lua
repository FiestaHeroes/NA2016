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

	-- 맵에 로그인하는 첫 유저의 핸들값을 한번만 저장
	if Var["PlayerHandle"] == INVALID_HANDEL
	then
		Var["PlayerHandle"] = PlayerHandle
	end
end






