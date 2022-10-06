--------------------------------------------------------------------------------
--                            Gold Hill Routine                               --
--------------------------------------------------------------------------------

function PlayerMapLogin( MapIndex, Handle )
cExecCheck "PlayerMapLogin"

	if MapIndex == nil
	then
		DebugLog( "PlayerMapLogin::MapIndex == nil")
		return
	end

	if Handle == nil
	then
		DebugLog( "PlayerMapLogin::Handle == nil")
		return
	end

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		DebugLog( "PlayerMapLogin::Var == nil")
		return
	end

	-- 첫 플레이어의 맵 로그인 체크
	Var["bPlayerMapLogin"] = true

	-- 시간 설정이 아직 되지 않은 경우에는 아무것도 실행하지 않는다.
	if Var["KQLimitTime"] == nil
	then
		return
	end

	if Var["CurSec"] == nil
	then
		return
	end

	-- 현재 시간 기준으로 제한시간을 받아서 요청한다.
	local nLimitSec = Var["KQLimitTime"] - Var["CurSec"]

	cShowKQTimerWithLife_Obj( Handle, nLimitSec )

end


function CoreBreakRoutine( Handle, MapIndex )
cExecCheck "CoreBreakRoutine"

	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if Var["LayerStep"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if Var["LayerStep"]["LayerNumber"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if Var["LayerStep"]["LayerNumber"] > #LayerNameTable
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local LayerName = LayerNameTable[ Var["LayerStep"]["LayerNumber"] ]
	if Var[ LayerName ] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if cIsObjectDead( Handle ) == nil
	then
		return ReturnAI["CPP"]
	end


	local ItemDropInfo 					= ItemDrop[ LayerName ]
	Var[ LayerName ]["DeadCoreCount"] 	= Var[ LayerName ]["DeadCoreCount"] + 1


	for i = 1, #Var[ LayerName ]["KeyCore"]
	do
		if Var[ LayerName ]["DeadCoreCount"] >= Var[ LayerName ]["KeyCore"][i]
		then
			cDropItem( ItemDropInfo["Index"], Handle, -1, ItemDropInfo[i]["DropRate"] )
			cNotice( MapIndex, MsgScriptFileDefault, ItemDropInfo["Notice"] )

			Var[ LayerName ]["KeyCore"][i] = 100000
			break
		end
	end


	cAIScriptSet( Handle )
	return ReturnAI["CPP"]

end


function DoorClick( Handle, PlayerHandle, PlayerCharNo, Arg )
cExecCheck "DoorClick"


	local MapIndex = cGetCurMapIndex( Handle )
	if MapIndex == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return
	end


	if Var["LayerStep"] == nil
	then
		return
	end


	if Var["LayerStep"]["LayerNumber"] == nil
	then
		return
	end


	if Var["LayerStep"]["LayerNumber"] > #LayerNameTable
	then
		return
	end


	local LayerName = LayerNameTable[ Var["LayerStep"]["LayerNumber"] ]
	if Var[ LayerName ] == nil
	then
		return
	end


	local ItemDropInfo 		= ItemDrop[ LayerName ]
	local ItemLot, bLocked	= cGetItemLot( PlayerHandle, ItemDropInfo["Index"] )

	if ItemLot == nil or bLocked == nil
	then
		return
	end

	if ItemLot < 1
	then
		return
	end


	local PlayerList = { cGetPlayerList( MapIndex ) }
	for i = 1, #PlayerList
	do
		cInvenItemDestroy( PlayerList[ i ], ItemDropInfo["Index"], -1 )
	end


	cDoorAction( Handle, RegenInfo["Stuff"][ LayerName ]["Block"], "open" )


	Var["LayerStep"]["LayerNumber"] = Var["LayerStep"]["LayerNumber"] + 1
	Var[ LayerName ] 				= nil


	cAIScriptSet( Handle )

end


function EndGateClick( Handle, PlayerHandle, PlayerCharNo, Arg )
cExecCheck "EndGateClick"


	if Handle == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return
	end


	local MapIndex = cGetCurMapIndex( Handle )
	if MapIndex == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return
	end


	GoToSuccess( Var )

end
