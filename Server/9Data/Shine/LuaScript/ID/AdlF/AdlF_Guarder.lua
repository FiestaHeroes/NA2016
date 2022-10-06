require( "common" )


-- 마렌느
function AdlF_Marlene( Handle, MapIndex )
cExecCheck "AdlF_Marlene"

	return Guarder( Handle, MapIndex )

end

-- 경비병
function AdlF_GuardAlber( Handle, MapIndex )
cExecCheck "AdlF_GuardAlber"

	return Guarder( Handle, MapIndex )

end

-- 경비병
function AdlF_GuardEstelle( Handle, MapIndex )
cExecCheck "AdlF_GuardEstelle"

	return Guarder( Handle, MapIndex )

end



GuardMemBlock = {}

function Guarder( Handle, MapIndex )
cExecCheck "Guarder"

	local Var = GuardMemBlock[Handle]

	if cIsObjectDead( Handle ) then	-- 죽었음

		-- 죽은 경비병이 마렌느 일 경우 대사하고 죽음
		if InstanceField[MapIndex] ~= nil then

			local Field = InstanceField[MapIndex]

			if Field ~= nil then

				if Handle == Field.Marlene then

					cMobDialog( MapIndex,
									DialogInfo.Marlene_Death[1].Portrait,
									DialogInfo.Marlene_Death[1].FileName,
									DialogInfo.Marlene_Death[1].Index )

				end

			end
		end

		cAIScriptSet( Handle )		-- 스크립트 없앰
		GuardMemBlock[Handle] = nil	-- 메모리해제

		return ReturnAI.END
	end


	if Var == nil then
		GuardMemBlock[Handle] = {}

		Var					= GuardMemBlock[Handle]

		Var.Handle			= Handle
		Var.MapIndex		= MapIndex

		Var.StepFunc		= GuarderStop
	end


	return Var.StepFunc( Var )

end




function CheckOnSurvivalOfLoussier( Var )
cExecCheck "CheckOnSurvivalOfLoussier"

	if Var == nil then
		return
	end

	-- 필드 전역변수. 루시에 핸들
	if InstanceField[Var.MapIndex] == nil then
		return
	end

	local loussier = InstanceField[Var.MapIndex].LoussierHandle

	-- 마렌느와 경비병은 대기하다가 루시에가 죽으면 없앰
	if loussier == nil then

		cAIScriptSet( Handle )		-- 스크립트 없앰
		cNPCVanish( Var.Handle )

		Var = nil
	end

end


function GuarderStop( Var )
cExecCheck "GuarderStop"

	CheckOnSurvivalOfLoussier( Var )

	return ReturnAI.END

end


function GuarderActivity( Var )
cExecCheck "GuarderActivity"

	CheckOnSurvivalOfLoussier( Var )

	return ReturnAI.CPP

end


