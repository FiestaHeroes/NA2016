require("common")


KarenMemBlock = {}

function AdlFH_Karen( Handle, MapIndex )
cExecCheck "AdlFH_Karen"

	local Var = KarenMemBlock[Handle]

	if cIsObjectDead( Handle ) then	-- 죽었음

		cAIScriptSet( Handle )		-- 스크립트 없앰
		KarenMemBlock[Handle] = nil	-- 메모리해제

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

	-- 카렌 무적 상태이상이 아닌 지속적인 HP회복으로 처리 - 4/20
	local CurHP, MaxHP = cObjectHP( Var.Handle )

	cHeal( Var.Handle, MaxHP )

	-- 카렌 -> 이그렉 따라다님
	local Field = InstanceField[Var.MapIndex]


	-- 카렌 공격 안하도록 다시 수정 5/3

	if Field == nil then
		return ReturnAI.END
	end

	if Field.Eglack == nil then
		return ReturnAI.END
	end


	cFollow( Var.Handle, Field.Eglack, 150, 9999 )


	return ReturnAI.END
end
