require( "common" )


-- ������
function AdlF_Marlene( Handle, MapIndex )
cExecCheck "AdlF_Marlene"

	return Guarder( Handle, MapIndex )

end

-- ���
function AdlF_GuardAlber( Handle, MapIndex )
cExecCheck "AdlF_GuardAlber"

	return Guarder( Handle, MapIndex )

end

-- ���
function AdlF_GuardEstelle( Handle, MapIndex )
cExecCheck "AdlF_GuardEstelle"

	return Guarder( Handle, MapIndex )

end



GuardMemBlock = {}

function Guarder( Handle, MapIndex )
cExecCheck "Guarder"

	local Var = GuardMemBlock[Handle]

	if cIsObjectDead( Handle ) then	-- �׾���

		-- ���� ����� ������ �� ��� ����ϰ� ����
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

		cAIScriptSet( Handle )		-- ��ũ��Ʈ ����
		GuardMemBlock[Handle] = nil	-- �޸�����

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

	-- �ʵ� ��������. ��ÿ� �ڵ�
	if InstanceField[Var.MapIndex] == nil then
		return
	end

	local loussier = InstanceField[Var.MapIndex].LoussierHandle

	-- �������� ����� ����ϴٰ� ��ÿ��� ������ ����
	if loussier == nil then

		cAIScriptSet( Handle )		-- ��ũ��Ʈ ����
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


