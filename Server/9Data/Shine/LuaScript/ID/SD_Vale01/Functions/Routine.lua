--------------------------------------------------------------------------------
-- DummyRoutineFunc
--------------------------------------------------------------------------------

function DummyRoutineFunc( )
cExecCheck "DummyRoutineFunc"
end

--------------------------------------------------------------------------------
-- PlayerMapLogin
--------------------------------------------------------------------------------
function PlayerMapLogin( MapIndex, Handle )
cExecCheck "PlayerMapLogin"

	if MapIndex == nil
	then
		DebugLog( "PlayerMapLogin::MapIndex == nil")
		return
	end

	if Handle == nil
	then
		DebugLog( "PlayerMapLogin::Handle == nil")
		return
	end

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		DebugLog( "PlayerMapLogin::Var == nil")
		return
	end

	-- ù �÷��̾��� �� �α��� üũ
	Var["bPlayerMapLogin"] = true

end


