--------------------------------------------------------------------------------
--                      Tower Of Iyzel Sub Functions                          --
--------------------------------------------------------------------------------

function DummyFunc( Var )
cExecCheck "DummyFunc"
end


function GoToNextStep( Var )
cExecCheck "GoToNextStep"

	if Var == nil
	then
		ErrorLog( "GoToNextStep::Var == nil" )
		return
	end

	if ID_StepsList == nil
	then
		ErrorLog( "GoToNextStep::ID_StepsList == nil" )
		return
	end

	local nNumofSteps = #ID_StepsList

	if nNumofSteps < 1
	then
		ErrorLog( "GoToNextStep::nNumofSteps < 1" )
		return
	end


	-- ù ȣ�⿡�� ù��° ������ ����
	if Var["StepIndexNo"] == nil
	then
		Var["StepIndexNo"] = 1
	-- ������ ���� ���Ŀ��� �ƹ��͵� ����
	elseif Var["StepIndexNo"] >= nNumofSteps
	then
		Var["StepIndexNo"] = nil
	-- ����Ʈ ���� Ȥ�� ���� ���Ŀ��� ReturnToHome �ܰ踦 ����
	elseif ID_StepsList[ Var["StepIndexNo"] ]["Name"] == "QuestSuccess" or ID_StepsList[ Var["StepIndexNo"] ]["Name"] == "QuestFailed"
	then
		Var["StepIndexNo"] = ID_StepsIndexList["ReturnToHome"]
	-- �� �� ���̽����� �����ܰ�� �̵�
	else
		Var["StepIndexNo"] = Var["StepIndexNo"] + 1
	end


	-- ���� ����
	if Var["StepFunc"] == nil
	then
		Var["StepFunc"] = DummyFunc
	end


	if Var["StepIndexNo"] ~= nil
	then
		local nIndex = Var["StepIndexNo"]

		if nIndex < 1 or nIndex > nNumofSteps
		then
			ErrorLog( "GoToNextStep::Var[\"StepIndexNo\"](="..nIndex..") is out of range(from 1 to "..nNumofSteps..")." )
			return
		end
		Var["StepFunc"] = ID_StepsList[ nIndex ]["Function"]

		DebugLog( "GoToNextStep::ResultStepName : "..ID_StepsList[ nIndex ]["Name"] )
	else
		-- ���� ���� ���� ȣ�� ��
		Var["StepFunc"] = DummyFunc

		DebugLog( "GoToNextStep::ResultStepName : ID_Finish" )
	end


end


function GoToSuccess( Var )
cExecCheck "GoToSuccess"

	if Var == nil
	then
		ErrorLog( "GoToSuccess::Var == nil" )
		return
	end

	Var["KQLimitTime"] = nil

	Var["StepIndexNo"] 	= ID_StepsIndexList["QuestSuccess"]

	local nIndex = Var["StepIndexNo"]

	if nIndex > 0
	then
		Var["StepFunc"] = ID_StepsList[ nIndex ]["Function"]
	else
		ErrorLog( "GoToSuccess::nIndex is negative." )
		return
	end

	DebugLog( "GoToSuccess::ResultStepName : "..ID_StepsList[ nIndex ]["Name"] )

end


function GoToFail( Var )
cExecCheck "GoToFail"

	if Var == nil
	then
		ErrorLog( "GoToFail::Var == nil" )
		return
	end

	Var["KQLimitTime"] = nil

	Var["StepIndexNo"] 	= ID_StepsIndexList["QuestFailed"]

	local nIndex = Var["StepIndexNo"]

	if nIndex > 0
	then
		Var["StepFunc"] = ID_StepsList[ nIndex ]["Function"]
	else
		ErrorLog( "GoToSuccess::nIndex is negative." )
		return
	end


	DebugLog( "GoToFail::ResultStepName : "..ID_StepsList[ nIndex ]["Name"] )

end


function IsKQTimeOver( Var )

	if Var == nil
	then
		ErrorLog( "IsKQTimeOver::Var == nil" )
		return
	end

	if Var["KQLimitTime"] == nil
	then
		ErrorLog( "IsKQTimeOver::Var[\"KQLimitTime\"] == nil" )
		return
	end

	if Var["CurSec"] == nil
	then
		ErrorLog( "IsKQTimeOver::Var[\"CurSec\"] == nil" )
		return
	end


	if Var["KQLimitTime"] < Var["CurSec"]
	then
		return true
	else
		return false
	end

end


function DebugLog( String )

	if String == nil
	then
		cAssertLog( "DebugLog::String == nil" )
		return
	end

--	cAssertLog( "Debug - "..String )

end


function ErrorLog( String )

	if String == nil
	then
		cAssertLog( "ErrorLog::String == nil" )
		return
	end

	cAssertLog( "Error - "..String )

end
