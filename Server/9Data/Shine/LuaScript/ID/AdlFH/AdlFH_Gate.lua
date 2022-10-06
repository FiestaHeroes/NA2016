require( "common" )



function Gate_ID_Complete( Handle, MapIndex )
cExecCheck "Gate_ID_Complete"

	return Gate_Main( Handle, MapIndex )
end

function Gate_ID_Exit( Handle, MapIndex )
cExecCheck "Gate_ID_Exit"

	return Gate_Main( Handle, MapIndex )
end



GateMemBlock = {}


function Gate_Main( Handle, MapIndex )
cExecCheck "Gate_Main"

	local Var = GateMemBlock[Handle]

	if cIsObjectDead( Handle ) then			-- 죽었음

		cAIScriptSet( Handle )				-- 스크립트 없앰
		GateMemBlock[Handle] = nil			-- 메모리해제

		return ReturnAI.END
	end

	if Var == nil then

		GateMemBlock[Handle] = {}

		Var = GateMemBlock[Handle]

		Var.Handle		= Handle
		Var.MapIndex	= MapIndex
	end

	return ReturnAI.END
end



function ExitGateFunc( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "ExitGateFunc"


	local Var = GateMemBlock[NPCHandle]

	if Var == nil then
		return
	end


	cServerMenu( PlyHandle, NPCHandle, RegenInfo.ExitGate.Title,
										RegenInfo.ExitGate.Yes, "LinkToVillage",
										RegenInfo.ExitGate.No,  "GateDummy")

end


function BossRoomGateFunc( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "BossRoomGate"


	local Var = GateMemBlock[NPCHandle]

	if Var == nil then
		return
	end

	cServerMenu( PlyHandle, NPCHandle, RegenInfo.BossRoomGate.Title,
										RegenInfo.BossRoomGate.Yes, "LinkToBossRoom",
										RegenInfo.BossRoomGate.No,  "GateDummy")

end


function CompleteGateFunc( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "CompleteGateFunc"


	local Var = GateMemBlock[NPCHandle]

	if Var == nil then
		return
	end

	cServerMenu( PlyHandle, NPCHandle, RegenInfo.CompleteGate.Title,
										RegenInfo.CompleteGate.Yes, "LinkToVillage",
										RegenInfo.CompleteGate.No,  "GateDummy")

end


function ExitBossGateFunc( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "ExitBossGateFunc"


	local Var = GateMemBlock[NPCHandle]

	if Var == nil then
		return
	end

	cServerMenu( PlyHandle, NPCHandle, RegenInfo.CompleteGate.Title,
										RegenInfo.CompleteGate.Yes, "LinkToZone3",
										RegenInfo.CompleteGate.No,  "GateDummy")

end



-- 취소
function GateDummy( NPCHandle, PlyHandle, RegistNumber )
end

-- 보스방으로 이동
function LinkToBossRoom( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "LinkToBossRoom"

	local Var = GateMemBlock[NPCHandle]

	if Var == nil then
		return
	end

	cLinkTo( PlyHandle, Var.MapIndex, 12924, 6373 )

end

-- 마을로 이동
function LinkToVillage( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "LinkToVillage"

	local Var = GateMemBlock[NPCHandle]

	if Var == nil then
		return
	end

	cLinkTo( PlyHandle, "AdlVal01", 26057, 6110 )

end

-- 3지역으로 이동
function LinkToZone3( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "LinkToZone3"

	local Var = GateMemBlock[NPCHandle]

	if Var == nil then
		return
	end

	cLinkTo( PlyHandle, Var.MapIndex, 9412, 20075 )

end

