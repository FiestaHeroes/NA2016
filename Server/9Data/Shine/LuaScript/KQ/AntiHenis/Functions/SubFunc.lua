--------------------------------------------------------------------------------
--                          Anti Henis Sub Functions                          --
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

	if KQ_StepsList == nil
	then
		ErrorLog( "GoToNextStep::KQ_StepsList == nil" )
		return
	end

	local nNumofSteps = #KQ_StepsList

	if nNumofSteps < 1
	then
		ErrorLog( "GoToNextStep::nNumofSteps < 1" )
		return
	end


	-- 첫 호출에는 첫번째 스텝을 적용
	if Var["StepIndexNo"] == nil
	then
		Var["StepIndexNo"] = 1
	-- 마지막 스텝 이후에는 아무것도 없음
	elseif Var["StepIndexNo"] >= nNumofSteps
	then
		Var["StepIndexNo"] = nil
	-- 퀘스트 성공 혹은 실패 이후에는 ReturnToHome 단계를 실행
	elseif KQ_StepsList[ Var["StepIndexNo"] ]["Name"] == "QuestSuccess" or KQ_StepsList[ Var["StepIndexNo"] ]["Name"] == "QuestFailed"
	then
		Var["StepIndexNo"] = KQ_StepsIndexList["ReturnToHome"]
	-- 그 외 케이스에는 다음단계로 이동
	else
		Var["StepIndexNo"] = Var["StepIndexNo"] + 1
	end


	-- 최초 스텝
	if Var["StepFunc"] == nil
	then
		Var["StepFunc"] = DummyFunc
	end

	if Var["StepFunc"] == DummyFunc
	then
		Var["StepFunc"] = KQ_StepsList[1]
	end


	if Var["StepIndexNo"] ~= nil
	then
		local nIndex = Var["StepIndexNo"]

		if nIndex < 1 or nIndex > nNumofSteps
		then
			ErrorLog( "GoToNextStep::Var[\"StepIndexNo\"](="..nIndex..") is out of range(from 1 to "..nNumofSteps..")." )
			return
		end
		Var["StepFunc"] = KQ_StepsList[ nIndex ]["Function"]

		DebugLog( "GoToNextStep::ResultStepName : "..KQ_StepsList[ nIndex ]["Name"] )
	else
		-- 최종 스텝 이후 호출 시
		Var["StepFunc"] = DummyFunc

		DebugLog( "GoToNextStep::ResultStepName : KQ_Finish" )
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

	Var["StepIndexNo"] 	= KQ_StepsIndexList["QuestSuccess"]

	local nIndex = Var["StepIndexNo"]

	if nIndex > 0
	then
		Var["StepFunc"] = KQ_StepsList[ nIndex ]["Function"]
	else
		ErrorLog( "GoToSuccess::nIndex is negative." )
		return
	end

	DebugLog( "GoToSuccess::ResultStepName : "..KQ_StepsList[ nIndex ]["Name"] )

end


function GoToFail( Var )
cExecCheck "GoToFail"

	if Var == nil
	then
		ErrorLog( "GoToFail::Var == nil" )
		return
	end

	Var["KQLimitTime"] = nil

	Var["StepIndexNo"] 	= KQ_StepsIndexList["QuestFailed"]

	local nIndex = Var["StepIndexNo"]

	if nIndex > 0
	then
		Var["StepFunc"] = KQ_StepsList[ nIndex ]["Function"]
	else
		ErrorLog( "GoToSuccess::nIndex is negative." )
		return
	end


	DebugLog( "GoToFail::ResultStepName : "..KQ_StepsList[ nIndex ]["Name"] )

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
