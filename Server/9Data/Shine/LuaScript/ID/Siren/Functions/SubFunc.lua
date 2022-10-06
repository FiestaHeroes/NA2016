--------------------------------------------------------------------------------
--                     Seiren Castle Sub Functions                            --
--------------------------------------------------------------------------------

function DummyFunc( Var )
cExecCheck "DummyFunc"
end


function GoToNextStep( Var )
cExecCheck "GoToNextStep"

	if Var == nil
	then
		ErrorLog( "GoToNextStep::Var == nil" )
		return false
	end


	-- StepIndex �� nil �̸� �δ� �ʱ�ȭ ����
	if Var["StepIndex"] == nil and Var["StepFunc"] == nil
	then
		Var["StepIndex"]	= "InitDungeon"
		Var["StepFunc"]		= ID_StepsList["InitDungeon"]["Function"]
		return true
	end


	-- StepIndex �� ������ �ܰ� ���� Ȯ��
	local StepIndex = Var["StepIndex"]
	if ID_StepsList[ StepIndex ] == nil
	then
		ErrorLog( "GoToNextStep : StepInfo nil : "..StepIndex )

		Var["StepFunc"] = DummyFunc
		return true
	end


	-- ���� �ܰ谡 ������ �ٸ� ���� Ȯ��
	local NextStepIndex = ID_StepsList[ StepIndex ]["NextStep"]

	if NextStepIndex == nil
	then

		-- �� ������ ��, �ܰ� ����ó��
		local DoorOpenCheckList	= Step_DoorOpenCheckList[ StepIndex ]

		if DoorOpenCheckList ~= nil
		then
			for i = 1, #DoorOpenCheckList
			do
				local DoorName		= DoorOpenCheckList[ i ]["DoorName"]
				local nDoorHandle 	= Var["Door"][ DoorName ]

				if nDoorHandle ~= nil
				then
					if Var["Door"][ nDoorHandle ]["IsOpen"] == true
					then
						NextStepIndex = DoorOpenCheckList[ i ]["NextStep"]
						break
					end
				end
			end

			-- ���� ���� ���� ���, ���� ������ ���� ���� �ܰ��� ���� ��������Ѵ�.
			if NextStepIndex == nil
			then
				return false
			end
		end
	end


	-- ���� �ܰ� ����
	if NextStepIndex == nil
	then
		Var["StepIndex"]	= nil
		Var["StepFunc"]		= DummyFunc
		return true
	else
		Var["StepIndex"]	= NextStepIndex
		StepIndex			= NextStepIndex
	end


	-- ���� �ܰ� ���� Ȯ��
	if ID_StepsList[ StepIndex ] == nil
	then
		ErrorLog( "GoToNextStep : StepInfo nil : "..StepIndex )

		Var["StepFunc"] = DummyFunc
		return true
	end


	-- �ܰ� �Լ� ����
	if ID_StepsList[ StepIndex ]["Function"] == nil
	then
		Var["StepFunc"] = DummyFunc
	else
		Var["StepFunc"]	= ID_StepsList[ StepIndex ]["Function"]
	end

	return true
end


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

