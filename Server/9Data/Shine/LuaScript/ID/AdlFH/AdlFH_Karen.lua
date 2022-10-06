require("common")


KarenMemBlock = {}

function AdlFH_Karen( Handle, MapIndex )
cExecCheck "AdlFH_Karen"

	local Var = KarenMemBlock[Handle]

	if cIsObjectDead( Handle ) then	-- �׾���

		cAIScriptSet( Handle )		-- ��ũ��Ʈ ����
		KarenMemBlock[Handle] = nil	-- �޸�����

		return ReturnAI.END
	end


	if Var == nil then
		KarenMemBlock[Handle] = {}

		Var					= KarenMemBlock[Handle]

		Var.Handle			= Handle
		Var.MapIndex		= MapIndex

		Var.ActChk			= cCurrentSecond()
		Var.StepFunc		= KarenDummy
	end


	return Var.StepFunc( Var )

end


function KarenDummy( Var )

	local CurSec = cCurrentSecond()

	if Var.ActChk > CurSec then
		return ReturnAI.END
	end

	Var.ActChk = CurSec + 1

	-- ī�� ���� �����̻��� �ƴ� �������� HPȸ������ ó�� - 4/20
	local CurHP, MaxHP = cObjectHP( Var.Handle )

	cHeal( Var.Handle, MaxHP )

	-- ī�� -> �̱׷� ����ٴ�
	local Field = InstanceField[Var.MapIndex]


	-- ī�� ���� ���ϵ��� �ٽ� ���� 5/3

	if Field == nil then
		return ReturnAI.END
	end

	if Field.Eglack == nil then
		return ReturnAI.END
	end


	cFollow( Var.Handle, Field.Eglack, 150, 9999 )


	return ReturnAI.END
end
