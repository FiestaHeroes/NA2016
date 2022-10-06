require( "common" )


LoussierMemBlock = {}

function AdlFH_Loussier( Handle, MapIndex )
cExecCheck "AdlFH_Loussier"

	local Var = LoussierMemBlock[Handle]

	if cIsObjectDead( Handle ) then	-- 죽었음

		cAIScriptSet( Handle )	-- 스크립트 없앰
		LoussierMemBlock[Handle] = nil	-- 메모리해제

		cMobDialog( MapIndex,
			DialogInfo.Loussier_Death[1].Portrait,
			DialogInfo.Loussier_Death[1].FileName,
			DialogInfo.Loussier_Death[1].Index )

		cDebugLog( "AdlF_Loussier Dead" )
		return ReturnAI.END
	end


	local cursec = cCurrentSecond()

	if Var == nil then
		LoussierMemBlock[Handle] = {}

		Var					= LoussierMemBlock[Handle]
		Var.Handle			= Handle
		Var.MapIndex		= MapIndex

		Var.MoveToChkTime	= nil
		Var.MoveTo			= nil
		Var.CurSec			= cursec

		Var.StepFunc		= Loussier_Default

		cAIScriptFunc( Var.Handle, "NPCClick", "Loussier_Click" )
		cAIScriptFunc( Var.Handle, "NPCMenu",  "Loussier_Menu" )

		cSetNPCParam ( Var.Handle, "HPRegen",  RegenInfo.Loussier.HPRegen )
	end


	if Var.CurSec < cursec then

		Var.CurSec = cursec + 0.5

		local PlayerList	= { cGetPlayerList( Var.MapIndex ) }
		for i=1, #PlayerList do
			if cDistanceSquar( Var.Handle, PlayerList[i] ) < 160000 then
				cSetAbstate( PlayerList[i], LOUSSIBUF, 1, 999 )
			end
		end
	end

	return Var.StepFunc( Var )
end




function Loussier_Default( Var )

	if  Var == nil then
		return ReturnAI.CPP
	end


	if InstanceField[Var.MapIndex] == nil then
		return ReturnAI.CPP
	end

	local Field = InstanceField[Var.MapIndex]


	-- 소환마법석 작동 이후에는 아무 행동을 하지 않도록 함
	if Field.SummonStone_Active ~= nil then
		return ReturnAI.END
	end

	-- 루시에 관련 연출 중일때는 아무 행동을 하지 않도록 함
	if Field.Loussier_Stop ~= nil then
		return ReturnAI.END
	end

	-- 소환마법석 캐스팅중에는 아무 행동을 하지 않도록 함
	if Var.StepFunc == LoussierSummonStoneCasting then
		return ReturnAI.END
	end


	return ReturnAI.CPP
end



function MoveToPlayer( Var )
cExecCheck "MoveToPlayer"

	if  Var == nil then
		Var.StepFunc = Loussier_Default
		return ReturnAI.CPP
	end

	-- 목표가 있는지 체크
	if Var.MoveTo == nil then
		Var.StepFunc = Loussier_Default
		return ReturnAI.CPP
	end

	-- 이동처리가 필요한 거리면 1초 단위로 목표점을 바꿔주며 이동
	local CurSec = cCurrentSecond()
	if Var.MoveToChkTime == nil or Var.MoveToChkTime <= CurSec then

		if cFollow( Var.Handle, Var.MoveTo, 100, 1000 ) == nil then
			Var.StepFunc	= Loussier_Default
			Var.MoveTo		= nil
			return ReturnAI.CPP
		end

		Var.MoveToChkTime = CurSec + 1

	end

	return ReturnAI.CPP
end




function Loussier_Click(NPCHandle, PlyHandle, RegistNumber)
cExecCheck "Loussier_Click"

	local Var = LoussierMemBlock[NPCHandle]
	if Var == nil then
		cDebugLog( "Loussier_Click : nil NPC " .. NPCHandle )
		return 0
	end

	if InstanceField[Var.MapIndex] == nil then
		return
	end

	local Field = InstanceField[Var.MapIndex]

	-- 소환마법석 작동 이후에는 아무 행동을 하지 않도록 함
	if Field.SummonStone_Active ~= nil then
		return
	end

	-- 루시에 관련 연출 중일때는 아무 행동을 하지 않도록 함
	if Field.Loussier_Stop ~= nil then
		return
	end

	-- 소환마법석 캐스팅중에는 아무 행동을 하지 않도록 함
	if Var.StepFunc == LoussierSummonStoneCasting then
		return
	end

	cNPCMenuOpen( NPCHandle, PlyHandle )

end


function Loussier_Menu(NPCHandle, PlyHandle, RegistNumber, Menu)
cExecCheck "Loussier_Menu"

	local Var = LoussierMemBlock[NPCHandle]
	if Var == nil then
		cDebugLog( "Loussier_Menu : nil NPC " .. NPCHandle )
		return
	end

	if Menu == 1 then

		LussierFollow( NPCHandle, PlyHandle, RegistNumber )

	elseif Menu == 2 then

		LussierWait( NPCHandle, PlyHandle, RegistNumber )

	elseif Menu == 3 then

		LussierSummonStone( NPCHandle, PlyHandle, RegistNumber )

	else
		cDebugLog( "Loussier_Menu : Invalid Menu " .. Menu )
	end

end


-- 따라가기 설정
function LussierFollow( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "LussierFollow"

	local Var = LoussierMemBlock[NPCHandle]
	if Var == nil then
		cDebugLog( "LussierFollow : nil NPC " .. NPCHandle )
		return
	end

	Var.StepFunc	= MoveToPlayer
	Var.MoveTo		= PlyHandle

	cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Loussier_Follow, cGetPlayerName( PlyHandle ) )

end


-- 따라가기 해제
function LussierWait( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "LussierWait"

	local Var = LoussierMemBlock[NPCHandle]
	if Var == nil then
		cDebugLog( "LussierWait : nil NPC " .. NPCHandle )
		return
	end

	Var.StepFunc	= Loussier_Default
	Var.MoveTo		= nil

end


-- 소환석 작동
function LussierSummonStone( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "LussierSummonStone"

	local Var = LoussierMemBlock[NPCHandle]
	if Var == nil then
		cDebugLog( "LussierWait : nil NPC " .. NPCHandle )
		return
	end

	if cGetAreaObject( Var.MapIndex, AreaIndex.Zone3_2, NPCHandle ) == nil then
		cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Loussier_RStone )
		return
	end


	Var.StepFunc = LoussierSummonStoneCastingStart

end



function LoussierSummonStoneCastingStart( Var )
cExecCheck "LoussierSummonStoneCastingStart"

	if  Var == nil then
		return ReturnAI.CPP
	end

	-- 필드 전역변수
	if InstanceField[Var.MapIndex] == nil then
		Var.StepFunc = Loussier_Default
		return ReturnAI.CPP
	end

	local Field = InstanceField[Var.MapIndex]

	if Field.SummonStone_Active ~= nil then
		Var.StepFunc = Loussier_Default
		return ReturnAI.CPP
	end

	if Field.SummonStone == nil then
		Var.StepFunc = Loussier_Default
		return ReturnAI.CPP
	end


	if cDistanceSquar( Var.Handle, Field.SummonStone ) <= 30000 then

		cSkillBlast( Var.Handle, Field.SummonStone, "AdlF_Loussier_Skill04_N" )
		Var.StepFunc = LoussierSummonStoneCasting

		return ReturnAI.CPP
	else
		if cFollow( Var.Handle, Field.SummonStone, 170, 10000 ) == nil then
			Var.StepFunc	= Loussier_Default
			Var.MoveTo		= nil
			return ReturnAI.CPP
		end
	end

	return ReturnAI.END
end


function LoussierSummonStoneCasting( Var )

	if  Var == nil then
		return ReturnAI.CPP
	end

	-- 필드 전역변수
	if InstanceField[Var.MapIndex] == nil then
		Var.StepFunc = Loussier_Default
		return ReturnAI.CPP
	end

	local Field = InstanceField[Var.MapIndex]


	local CurSec = cCurrentSecond()

	if Var.Casting_Step == nil then

		Var.Casting_Step		= 1
		Var.Casting_Step_Delay	= CurSec + 2

		return ReturnAI.CPP
	end

	if Var.Casting_Step == 1 then

		if Var.Casting_Step_Delay > CurSec then
			return ReturnAI.END
		end


		Field.SummonStone_Active= "Loussier"

		Var.Casting_Step		= 2
		Var.Casting_Step_Delay	= CurSec

		return ReturnAI.CPP
	end


	Var.Casting_Step		= nil
	Var.Casting_Step_Delay	= nil

	Var.StepFunc			= Loussier_Default

	return ReturnAI.END
end

