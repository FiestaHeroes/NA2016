--------------------------------------------------------------------------------
--                   Promote Job2_Forest Sub Functions                          --
--------------------------------------------------------------------------------

function DummyFunc( Var )
cExecCheck "DummyFunc"
end


----------------------------------------------------------------------
-- IsFail : Fail ÀÎÁö Ã¼Å©
----------------------------------------------------------------------

function IsFail( Var )
cExecCheck( "IsFail" )

	--DebugLog("IsFail : Start" )

	if Var == nil
	then
		ErrorLog( "IsFail::Var == nil" )
		return
	end

	if cPlayerExist( Var["Elderin"] ) == nil
	then
		--DebugLog("¿¤´õ¸° »ç¸Á")
		return true
	end

	if cPlayerExist( Var["Roumen"] ) == nil
	then
		--DebugLog("·ç¸à »ç¸Á")
		return true
	end

	if cPlayerExist( Var["PlayerHandle"] ) == nil
	then
		--DebugLog("ÇÃ·¹ÀÌ¾î ¾ø°Å³ª »ç¸Á")
		return true
	end

end


----------------------------------------------------------------------
-- VanishMob : ÁöÁ¤µÈ ¸÷À» ¸Ê¿¡¼­ »èÁ¦(fadeout)ÇÑ´Ù
----------------------------------------------------------------------

function VanishMob( Var )
cExecCheck( "VanishMob" )
	for i = 1, #RegenInfo["MobInfo"]["MobList"]
	do
		cVanishAll( Var["MapIndex"], RegenInfo["MobInfo"]["MobList"][i] )
	end
end


----------------------------------------------------------------------
-- Log Functions
----------------------------------------------------------------------

function GoToFail( Var, Msg )
cExecCheck( "GoToFail" )

	DebugLog("GoToFail : Start" )

	if Var == nil
	then
		ErrorLog( "GoToFail : Var nil" );
		return
	end

	ErrorLog( Msg )
	Var["StepFunc"] = ReturnToHome
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
	cAssertLog( "Debug - "..String )
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
