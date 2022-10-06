----------------------------------------------------------------------
-- Dummy Functions
----------------------------------------------------------------------
function DummyFunc( Var )
cExecCheck "DummyFunc"
end

----------------------------------------------------------------------
-- Log Functions
----------------------------------------------------------------------
function DebugLog( String )
cExecCheck ( "DebugLog" )

	if String == nil
	then
		cAssertLog( "DebugLog::String == nil" )
		return
	end
	--cAssertLog( "Debug - "..String )
end


function ErrorLog( String )
cExecCheck ( "ErrorLog" )

	if String == nil
	then
		cAssertLog( "ErrorLog::String == nil" )
		return
	end
	cAssertLog( "Error - "..String )
end

--------------------------------------------------------------------------------
-- Click Function
--------------------------------------------------------------------------------
function Click_ExitGate( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "Click_ExitGate"

	DebugLog( "ExitGateClick::Start" )

	if NPCHandle == nil
	then
		ErrorLog( "ExitGateClick::NPCHandle == nil" )
		return
	end

	if PlyHandle == nil
	then
		ErrorLog( "ExitGateClick::PlyHandle == nil" )
		return
	end


	cLinkTo( PlyHandle, LinkInfo["ReturnMap"]["MapIndex"], LinkInfo["ReturnMap"]["x"], LinkInfo["ReturnMap"]["y"] )

	DebugLog( "ExitGateClick::End" )
end
