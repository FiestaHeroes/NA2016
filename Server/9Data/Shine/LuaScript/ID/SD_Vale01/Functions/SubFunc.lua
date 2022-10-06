

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
cExecCheck "ExitGateClick"

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

--------------------------------------------------------------------------------
-- KingCrab :: 휠윈드 SubFunction
--------------------------------------------------------------------------------
function PopMyTarget( TargetList )
cExecCheck "PopMyTarget"

	-- TargetList에 있는 값 중, 가장 큰 값을 지닌(우선순위가 가장높은) 색인값 (유저의 핸들값)을 리턴한다

	local maxPriority 	= 0
	local myTarget 		= INVALID_HANDLE

	for i, v in pairs( TargetList )
	do
		if v > maxPriority
		then
			myTarget 	= i
			maxPriority	= v
		end
	end

	TargetList[myTarget] = nil

	return myTarget
end
