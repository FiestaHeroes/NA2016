--------------------------------------------------------------------------------
--                          Pet System Sub Functions                          --
--------------------------------------------------------------------------------

function DummyFunc( Var )
	cExecCheck( "DummyFunc" )
end

function DebugLog( String )
--[[
	if String == nil
	then
		cAssertLog( "DebugLog::String == nil" )
		return
	end

	cAssertLog( "Debug - "..String )
--]]
end


function CheckLog( String )
--[[
	if String == nil
	then
		cAssertLog( "CheckLog::String == nil" )
		return
	end

	cAssertLog( "Check - "..String )
--]]
end


function ErrorLog( String )

	if String == nil
	then
		cAssertLog( "ErrorLog::String == nil" )
		return
	end

	cAssertLog( "Error - "..String )

end


function GetSquare( number )

	if ( type( number ) == "number" )
	then
		return number * number
	else
		return nil
	end

end
