--------------------------------------------------------------------------------
--                     		Sub Functions		                              --
--------------------------------------------------------------------------------
function DummyFunc( Var )
cExecCheck "DummyFunc"
end

--------------------------------------------------------------------------------
-- EnemyBufferClear
--------------------------------------------------------------------------------
function EnemyBufferClear( Var, Handle )
cExecCheck "EnemyBufferClear"

	if Var == nil
	then
		ErrorLog( "EnemyBufferClear::Var == nil" )
		return
	end

	if Var["Enemy"] == nil
	then
		ErrorLog( "EnemyBufferClear::Var[\"Enemy\"] == nil" )
		return
	end

	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "EnemyBufferClear::Var[\"Enemy\"][Handle] == nil" )
		return
	end


	local EnemyIndex = Var["Enemy"][ Handle ]["Index"]

	if EnemyIndex ~= nil
	then
		Var["Enemy"][ EnemyIndex ] 	= nil
	end

	Var["Enemy"][ Handle ]			= nil
end

--------------------------------------------------------------------------------
-- DebugLog
--------------------------------------------------------------------------------
function DebugLog( String )

	if String == nil
	then
		cAssertLog( "DebugLog::String == nil" )
		return
	end

	--cAssertLog( "Debug - "..String )

end

--------------------------------------------------------------------------------
-- ErrorLog
--------------------------------------------------------------------------------
function ErrorLog( String )

	if String == nil
	then
		cAssertLog( "ErrorLog::String == nil" )
		return
	end

	cAssertLog( "Error - "..String )

end

