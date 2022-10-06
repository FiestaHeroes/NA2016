--------------------------------------------------------------------------------
--                        Crystal Castle Routine                              --
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


	-- 플레이어에 보스 배틀 모드에서 작동할 루틴 등록
	if cSetAIScript ( MainLuaScriptPath, Handle ) == nil
	then
		ErrorLog( "ExitGateClick::cSetAIScript( ) == nil" )
	end

	if cAIScriptFunc( Handle, "ObjectDied", "PlayerDied" ) == nil
	then
		ErrorLog( "ExitGateClick::cAIScriptFunc( ) == nil" )
	end


end


function ExitGateClick( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "ExitGateClick"

	DebugLog( "ExitGateClick::Start" )

	if NPCHandle == nil
	then
		ErrorLog( "ExitGateClick::NPCHandle == nil" )
		return
	end

	if PlyHandle == nil
	then
		ErrorLog( "ExitGateClick::PlyHandle == nil" )
		return
	end


	cLinkTo( PlyHandle, LinkInfo["ReturnMapOnGateClick"]["MapIndex"], LinkInfo["ReturnMapOnGateClick"]["x"], LinkInfo["ReturnMapOnGateClick"]["y"] )

	DebugLog( "ExitGateClick::End" )
end


function PlayerDied( MapIndex, KillerHandle, DeadHandle )
cExecCheck "PlayerDied"

	DebugLog( "PlayerDied::Routine Start" )

	if MapIndex == nil
	then
		ErrorLog( "PlayerDied::MapIndex == nil" )
		ErrorLog( "PlayerDied::Routine Invalid End" )
		cAIScriptSet( DeadHandle )
		return
	end

	if DeadHandle == nil
	then
		ErrorLog( "PlayerDied::DeadHandle == nil" )
		ErrorLog( "PlayerDied::Routine Invalid End" )
		return
	end



	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "PlayerDied::Var == nil" )
		ErrorLog( "PlayerDied::Routine Invalid End" )
		cAIScriptSet( DeadHandle )
		return
	end


	-- Player 사망
	if cIsObjectDead( DeadHandle ) ~= nil
	then
		if Var["BossBattle"] ~= nil
		then
			-- 영역 안의 플레이어 체크
			local InBossAreaPlayerHandleList = { cGetAreaObjectList( Var["MapIndex"], BossArea["Index"], ObjectType["Player"] ) }

			for i, v in pairs ( InBossAreaPlayerHandleList )
			do
				DebugLog( "PlayerDied::Handle( Order "..i.." : "..v.." )" )
			end

			-- 재시작 조건일 경우 재시작 동작 설정
			if #InBossAreaPlayerHandleList < 1
			then
				Var["BossBattle"]["bRestartCondition"] = true
				DebugLog( "PlayerDied::Restart Condition Set!!" )
			end
		end

		DebugLog( "PlayerDied::Routine End" )

		cAIScriptSet( DeadHandle )
		return
	end

	ErrorLog( "PlayerDied::Routine Invalid End" )

	return
end


function MidBossMobRoutine( Handle, MapIndex )
cExecCheck "MidBossMobRoutine"

	if Handle == nil
	then
		ErrorLog( "MidBossMobRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "MidBossMobRoutine::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "MidBossMobRoutine::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 0.2초마다 체크하는 루틴
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	if Var["Enemy"] == nil
	then
		ErrorLog( "MidBossMobRoutine::Var[\"Enemy\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "MidBossMobRoutine::Var[\"Enemy\"]["..Handle.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- Mid Boss 사망
	if cIsObjectDead( Handle ) == 1
	then
		-- 잔몹 모두 자살
		cMobSuicide( Var["MapIndex"] )

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	if Var["EachFloor"] == nil
	then
		ErrorLog( "MidBossMobRoutine::Var[\"EachFloor\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	return ReturnAI["CPP"]

end

function KeyBoxRoutine( Handle, MapIndex )
cExecCheck "KeyBoxRoutine"

	if Handle == nil
	then
		ErrorLog( "KeyBoxRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "KeyBoxRoutine::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "KeyBoxRoutine::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 0.2초마다 체크하는 루틴
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	if Var["Enemy"] == nil
	then
		ErrorLog( "KeyBoxRoutine::Var[\"Enemy\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "KeyBoxRoutine::Var[\"Enemy\"]["..Handle.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if Var["EachFloor"] == nil
	then
		ErrorLog( "KeyBoxRoutine::Var[\"EachFloor\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["EachFloor"..Var["EachFloor"]["StepNumber"] ] == nil
	then
		ErrorLog( "KeyBoxRoutine::Var[\"EachFloor\"..Var[\"EachFloor\"][\"StepNumber\"] ] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- Key Box 열림
	if cIsObjectDead( Handle ) == 1
	then
		-- 박스 모두 사라지도록 설정
		Var["EachFloor"..Var["EachFloor"]["StepNumber"] ]["KeyBoxOpened"] = true


		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	return ReturnAI["CPP"]

end

function MobBoxRoutine( Handle, MapIndex )
cExecCheck "MobBoxRoutine"

	if Handle == nil
	then
		ErrorLog( "MobBoxRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "MobBoxRoutine::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "MobBoxRoutine::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 0.2초마다 체크하는 루틴
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	if Var["Enemy"] == nil
	then
		ErrorLog( "MobBoxRoutine::Var[\"Enemy\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "MobBoxRoutine::Var[\"Enemy\"]["..Handle.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if Var["EachFloor"] == nil
	then
		ErrorLog( "MobBoxRoutine::Var[\"EachFloor\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["EachFloor"..Var["EachFloor"]["StepNumber"] ] == nil
	then
		ErrorLog( "MobBoxRoutine::Var[\"EachFloor\"..Var[\"EachFloor\"][\"StepNumber\"] ] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	-- Key Box 열리면 알아서 사라진다.
	if Var["EachFloor"..Var["EachFloor"]["StepNumber"] ]["KeyBoxOpened"] == true
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	if cIsObjectDead( Handle ) == 1
	then
		-- 몹이 생기도록 설정
		if Var["EachFloor"..Var["EachFloor"]["StepNumber"] ]["nMobBoxOpened"] == nil
		then
			Var["EachFloor"..Var["EachFloor"]["StepNumber"] ]["nMobBoxOpened"] = 0
		end

		Var["EachFloor"..Var["EachFloor"]["StepNumber"] ]["nMobBoxOpened"] = Var["EachFloor"..Var["EachFloor"]["StepNumber"] ]["nMobBoxOpened"] + 1

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

	return ReturnAI["CPP"]

end

function JewelBoxRoutine( Handle, MapIndex )
cExecCheck "JewelBoxRoutine"

	if Handle == nil
	then
		ErrorLog( "MobBoxRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "MobBoxRoutine::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "MobBoxRoutine::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 0.2초마다 체크하는 루틴
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	if Var["Enemy"] == nil
	then
		ErrorLog( "MobBoxRoutine::Var[\"Enemy\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "MobBoxRoutine::Var[\"Enemy\"]["..Handle.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if Var["EachFloor"] == nil
	then
		ErrorLog( "MobBoxRoutine::Var[\"EachFloor\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["EachFloor"..Var["EachFloor"]["StepNumber"] ] == nil
	then
		ErrorLog( "MobBoxRoutine::Var[\"EachFloor\"..Var[\"EachFloor\"][\"StepNumber\"] ] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	-- Key Box 열리면 알아서 사라진다.
	if Var["EachFloor"..Var["EachFloor"]["StepNumber"] ]["KeyBoxOpened"] == true
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	if cIsObjectDead( Handle ) == 1
	then
		cDropItem( RegenInfo["Stuff"]["Jewel"]["Index"], Handle, -1, RegenInfo["Stuff"]["Jewel"]["Prob"] * PROB_DROP_ALWAYS )
		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

	return ReturnAI["CPP"]

end


-------------------------------------------------------------------------------------------------------
-- ObjectDied 루틴을 돌기 위한 더미 루틴
function TreasureBoxRoutine( Handle, MapIndex )
cExecCheck "TreasureBoxRoutine"

	if Handle == nil
	then
		ErrorLog( "TreasureBoxRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "TreasureBoxRoutine::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "TreasureBoxRoutine::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 0.2초마다 체크하는 루틴
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	if Var["Enemy"] == nil
	then
		ErrorLog( "TreasureBoxRoutine::Var[\"Enemy\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "TreasureBoxRoutine::Var[\"Enemy\"]["..Handle.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if Var["IyzelReward"] == nil
	then
		ErrorLog( "TreasureBoxRoutine::Var[\"IyzelReward\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	return ReturnAI["CPP"]
end


function TreasureBoxOpened( MapIndex, LooterHandle, BoxHandle )
cExecCheck "TreasureBoxOpened"

	if BoxHandle == nil
	then
		ErrorLog( "TreasureBoxOpened::BoxHandle == nil" )
		return
	end

	if LooterHandle == nil
	then
		ErrorLog( "TreasureBoxOpened::LooterHandle == nil" )
		cAIScriptSet( BoxHandle )
		return
	end

	if MapIndex == nil
	then
		ErrorLog( "TreasureBoxOpened::MapIndex == nil" )
		cAIScriptSet( BoxHandle )
		cNPCVanish( BoxHandle )
		return
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "TreasureBoxOpened::Var == nil" )
		cAIScriptSet( BoxHandle )
		cNPCVanish( BoxHandle )
		return
	end


	if Var["Enemy"] == nil
	then
		ErrorLog( "TreasureBoxOpened::Var[\"Enemy\"] == nil" )
		cAIScriptSet( BoxHandle )
		cNPCVanish( BoxHandle )
		return
	end

	if Var["Enemy"][ BoxHandle ] == nil
	then
		ErrorLog( "TreasureBoxOpened::Var[\"Enemy\"]["..BoxHandle.."] == nil" )
		cAIScriptSet( BoxHandle )
		cNPCVanish( BoxHandle )
		return
	end


	if Var["IyzelReward"] == nil
	then
		ErrorLog( "TreasureBoxOpened::Var[\"IyzelReward\"] == nil" )
		cAIScriptSet( BoxHandle )
		cNPCVanish( BoxHandle )
		return
	end


	if Var["StageInfo"]["BossTypeNo"] == nil
	then
		ErrorLog( "TreasureBoxOpened::Var[\"StageInfo\"][\"BossTypeNo\"] == nil" )
		cAIScriptSet( BoxHandle )
		cNPCVanish( BoxHandle )
		return ReturnAI["END"]
	end


	if cIsObjectDead( BoxHandle ) == 1
	then

		-- 드랍 확률에 따른 드랍 아이템 설정
		local nBossType = Var["StageInfo"]["BossTypeNo"]

		if RegenInfo["Stuff"]["Boss"..nBossType.."_Reward"] ~= nil
		then
			local DropItemInfo = RegenInfo["Stuff"]["Boss"..nBossType.."_Reward"][ 1 ]

			local nDropItem = cRandomInt( 1, ( 1 / DropItemInfo["Prob"] ) )

			DropItemInfo = RegenInfo["Stuff"]["Boss"..nBossType.."_Reward"][ nDropItem ]

			if DropItemInfo ~= nil
			then
				local sPlayerName
				if cObjectType( LooterHandle ) == ObjectType["Player"]
				then
					sPlayerName = cGetPlayerName( LooterHandle )

					if sPlayerName == ""
					then
						sPlayerName = "Anonymous"
					end
				else
					sPlayerName = "Anonymous"
				end

				local sMsg = sPlayerName..ChatInfo["IyzelReward"]["FoundTreasureNotice"]["String"]

				cNoticeString( MapIndex, sMsg )
				cDropItem( DropItemInfo["Index"], BoxHandle, LooterHandle, PROB_DROP_ALWAYS )

			end
		end


		cAIScriptSet( BoxHandle )
		Var["Enemy"][ BoxHandle ] = nil
		return
	end

	return
end


-------------------------------------------------------------------------------------------------------
function PhysicalPillarRoutine( Handle, MapIndex )
cExecCheck "PhysicalPillarRoutine"

	if Handle == nil
	then
		ErrorLog( "PhysicalPillarRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "PhysicalPillarRoutine::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "PhysicalPillarRoutine::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 0.2초마다 체크하는 루틴
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	if Var["Enemy"] == nil
	then
		ErrorLog( "PhysicalPillarRoutine::Var[\"Enemy\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "PhysicalPillarRoutine::Var[\"Enemy\"]["..Handle.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if Var["BossBattle"] == nil
	then
		ErrorLog( "PhysicalPillarRoutine::Var[\"BossBattle\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if Var["BossBattle"]["BossAC_PlusEffectCount"] == nil
	then
		ErrorLog( "PhysicalPillarRoutine::Var[\"BossBattle\"][\"BossAC_PlusEffectCount\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if cIsObjectDead( Handle ) == 1
	then
		Var["BossBattle"]["BossAC_PlusEffectCount"] = Var["BossBattle"]["BossAC_PlusEffectCount"] - 1

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		Var["RoutineTime"][ Handle ] = nil
		return ReturnAI["END"]
	end

	return ReturnAI["CPP"]

end


function MagicalPillarRoutine( Handle, MapIndex )
cExecCheck "MagicalPillarRoutine"

	if Handle == nil
	then
		ErrorLog( "MagicalPillarRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "MagicalPillarRoutine::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "MagicalPillarRoutine::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 0.2초마다 체크하는 루틴
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	if Var["Enemy"] == nil
	then
		ErrorLog( "MagicalPillarRoutine::Var[\"Enemy\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "MagicalPillarRoutine::Var[\"Enemy\"]["..Handle.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if Var["BossBattle"] == nil
	then
		ErrorLog( "MagicalPillarRoutine::Var[\"BossBattle\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if Var["BossBattle"]["BossMR_PlusEffectCount"] == nil
	then
		ErrorLog( "MagicalPillarRoutine::Var[\"BossBattle\"][\"BossMR_PlusEffectCount\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if cIsObjectDead( Handle ) == 1
	then
		Var["BossBattle"]["BossMR_PlusEffectCount"] = Var["BossBattle"]["BossMR_PlusEffectCount"] - 1

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		Var["RoutineTime"][ Handle ] = nil
		return ReturnAI["END"]
	end

	return ReturnAI["CPP"]

end


function ImmortalPillarRoutine( Handle, MapIndex )
cExecCheck "ImmortalPillarRoutine"


	if Handle == nil
	then
		ErrorLog( "ImmortalPillarRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "ImmortalPillarRoutine::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "ImmortalPillarRoutine::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 0.2초마다 체크하는 루틴
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	if Var["Enemy"] == nil
	then
		ErrorLog( "ImmortalPillarRoutine::Var[\"Enemy\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "ImmortalPillarRoutine::Var[\"Enemy\"]["..Handle.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if Var["BossBattle"] == nil
	then
		ErrorLog( "ImmortalPillarRoutine::Var[\"BossBattle\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if cIsObjectDead( Handle ) == 1
	then
		Var["BossBattle"]["BossImmortalEffectCount"] = Var["BossBattle"]["BossImmortalEffectCount"] - 1

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		Var["RoutineTime"][ Handle ] = nil
		return ReturnAI["END"]
	end

	return ReturnAI["CPP"]

end


-------------------------------------------------------------------------------------------------------
function BossDamaged( MapIndex, AttackerHandle, MaxHP, CurHP, DefenderHandle )
cExecCheck "BossDamaged"

	if DefenderHandle == nil
	then
		ErrorLog( "BossDamaged::DefenderHandle == nil" )
		return
	end

	if MapIndex == nil
	then
		ErrorLog( "BossDamaged::MapIndex == nil" )
		return
	end

	if MaxHP == nil or CurHP == nil
	then
		ErrorLog( "BossDamaged::HP Info is nil" )
		return
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "BossDamaged::Var == nil" )
		return
	end

	if Var["Enemy"] == nil
	then
		ErrorLog( "BossDamaged::Var[\"Enemy\"] == nil" )
		return
	end

	if Var["Enemy"][ DefenderHandle ] == nil
	then
		ErrorLog( "BossDamaged::Var[\"Enemy\"]["..DefenderHandle.."] == nil" )
		return
	end

	if Var["StageInfo"]["BossTypeNo"] == nil
	then
		ErrorLog( "BossDamaged::Var[\"StageInfo\"][\"BossTypeNo\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["BossBattle"] == nil
	then
		ErrorLog( "BossDamaged::Var[\"BossBattle\"] == nil" )
		return
	end


	-- 시전중에 대한 정보를 저장하고 공유하기 위함
	if Var["BossBattle"]["Casting"] == nil
	then
		Var["BossBattle"]["Casting"] = {}
	end


	local HP_Rate = ( CurHP * 1000 ) / MaxHP

	local nBossType = Var["StageInfo"]["BossTypeNo"]

	-- 스킬별로 한번 씩 탐색
	for nIndex, sSkillName in pairs ( BossSkillNameTable )
	do
		-- 없을경우 스킬페이즈순번 초기화
		if Var["BossBattle"][ sSkillName.."PhaseNo"] == nil
		then
			Var["BossBattle"][ sSkillName.."PhaseNo"] = 1
		end

		-- 실제 스킬 시전을 위한 테이블이 없을경우 생성
		if Var["BossBattle"][ sSkillName ] == nil
		then
			Var["BossBattle"][ sSkillName ] = {}
		end


		-- 단계이름 받아오기
		local CurStepNo = #StepNameTable - 1
		local CurStep = StepNameTable[ CurStepNo ]

		-- 스킬 페이즈 순번
		local sThresholdTableIndex = sSkillName.."HP_Boss"..nBossType -- ex ) "SummonHP_Boss1 "HP_"..CurStep
		local nCurPhase = Var["BossBattle"][ sSkillName.."PhaseNo"]
		local nMaxPhase = #ThresholdTable[ sThresholdTableIndex ]

		if nCurPhase <= nMaxPhase
		then
			-- 현재 HP와 스킬의 Threshold 와 비교하여 순차적으로 소급 적용하여 시전
			while ThresholdTable[ sThresholdTableIndex ][ nCurPhase ] >= HP_Rate
			do
				-- 시전할 스킬의 테이블 내 인덱스 받아오기
				local sCurSkillIndex = "HP"..ThresholdTable[ sThresholdTableIndex ][ nCurPhase ] -- ex) "HP800"
				local sBossSkillTableIndex = sThresholdTableIndex -- 동일하게 설정함

				if BossSkill[ sBossSkillTableIndex ][ sCurSkillIndex ] ~= nil
				then
					-- 스킬을 루틴에서 시전하도록 설정
					if Var["BossBattle"][ sSkillName ][ nCurPhase ] == nil
					then
						Var["BossBattle"][ sSkillName ][ nCurPhase ] = {}
						Var["BossBattle"][ sSkillName ][ nCurPhase ]["bCasting"] = true
						Var["BossBattle"][ sSkillName ][ nCurPhase ]["sSkillTableIndex"] = sCurSkillIndex
						DebugLog( "BossDamaged::SetSkillCasting-"..sSkillName.." "..sCurSkillIndex.." "..nCurPhase )
					end
				end

				nCurPhase = nCurPhase + 1
				if nCurPhase > nMaxPhase
				then
					break
				end

			end -- 스킬을 시전하라고 순서대로 셋팅해주는 루프

			-- 메모리의 스킬 페이즈 순번 값 갱신
			Var["BossBattle"][ sSkillName.."PhaseNo"] = nCurPhase

		end -- 각 스킬의 순번이 초과했는지 확인해주는 조건문 //

	end -- 스킬별로 한번씩 탐색하는 루프 //

end


function BossRoutine( Handle, MapIndex )
cExecCheck "BossRoutine"

	if Handle == nil
	then
		ErrorLog( "BossRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "BossRoutine::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "BossRoutine::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 0.2초마다 체크하는 루틴
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	if Var["Enemy"] == nil
	then
		ErrorLog( "BossRoutine::Var[\"Enemy\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "BossRoutine::Var[\"Enemy\"]["..Handle.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["StageInfo"]["BossTypeNo"] == nil
	then
		ErrorLog( "BossRoutine::Var[\"StageInfo\"][\"BossTypeNo\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["BossBattle"] == nil
	then
		ErrorLog( "BossRoutine::Var[\"BossBattle\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- Boss 사망
	if cIsObjectDead( Handle ) == 1
	then
		DebugLog( "BossRoutine::BossDead" )
		cMobSuicide( Var["MapIndex"] )

		-- 스킬관련 메모리 초기화
		for nIndex, sSkillName in pairs ( BossSkillNameTable )
		do
			Var["BossBattle"][ sSkillName ] = nil
			Var["BossBattle"][ sSkillName.."PhaseNo"] = nil
		end

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

	local nBossType = Var["StageInfo"]["BossTypeNo"]

	-- 보스 상태이상 설정
	if Var["BossBattle"]["BossAC_PlusEffectCount"] == nil
	then
		if nBossType == 1 or nBossType == 2
		then
			ErrorLog( "BossRoutine::BossAC_PlusEffectCount is nil" )
			return ReturnAI["END"]
		end
	end

	if Var["BossBattle"]["BossMR_PlusEffectCount"] == nil
	then
		if nBossType == 1 or nBossType == 2
		then
			ErrorLog( "BossRoutine::BossMR_PlusEffectCount is nil" )
			return ReturnAI["END"]
		end
	end

	if Var["BossBattle"]["BossImmortalEffectCount"] == nil
	then
		if nBossType == 3
		then
			ErrorLog( "BossRoutine::BossImmortalEffectCount is nil" )
			return ReturnAI["END"]
		end
	end

	for sIndex, AbstateInfo in pairs( BossAbstate )
	do
		if Var["BossBattle"]["Boss"..sIndex.."EffectCount"] == nil
		then
			Var["BossBattle"]["Boss"..sIndex.."EffectCount"] = 0
		end

		if Var["BossBattle"]["Boss"..sIndex.."EffectCount"] > 0
		then
			cSetAbstate( Var["BossHandle"], AbstateInfo["Index"], AbstateInfo["Strength"], AbstateInfo["KeepTime"] )
		else
			cResetAbstate( Var["BossHandle"], AbstateInfo["Index"] )
		end
	end


	-- 스킬별로 한번 씩 탐색
	for nIndex, sSkillName in pairs ( BossSkillNameTable )
	do
		-- 다음 스킬 순번과 해당 스킬 시전테이블이 없다면 아직 시전도 안된 것이므로 패스
		if Var["BossBattle"][ sSkillName.."PhaseNo"] ~= nil and Var["BossBattle"][ sSkillName ] ~= nil
		then
			-- 시전승인된 스킬들만 순서대로 시전해야함.
			for i = 1, #Var["BossBattle"][ sSkillName ]
			do
				-- 에러체크
				if Var["BossBattle"][ sSkillName ][ i ] == nil
				then
					break
				end

				-- 준비된 스킬 시전
				if Var["BossBattle"][ sSkillName ][ i ]["bCasting"] == true
				then
					local sCurSkillTableIndex = Var["BossBattle"][ sSkillName ][ i ]["sSkillTableIndex"] -- ex) "HP800"

					-- 단계이름 받아오기
					local CurStepNo = #StepNameTable - 1
					local CurStep = StepNameTable[ CurStepNo ]

					-- 스킬 테이블 인덱스 설정
					local sBossSkillTableIndex = sSkillName.."HP_Boss"..nBossType -- ex ) "SummonHP_Boss1"

					-- 스킬 정보 가져오기
					local CurSkillInfo = BossSkill[ sBossSkillTableIndex ][ sCurSkillTableIndex ]

					-- 잔몹 소환
					if sSkillName == "Summon"
					then
						DebugLog( "BossRoutine::StartSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )

						for j = 1, #CurSkillInfo["SummonMobs"]
						do
							for k = 1, CurSkillInfo["SummonMobs"][ j ]["Count"]
							do
								cMobRegen_Obj( CurSkillInfo["SummonMobs"][ j ]["Index"], Handle )
								DebugLog( "BossRoutine::CastSkill-"..sSkillName.." "..sCurSkillTableIndex.." ("..k.."/"..CurSkillInfo["SummonMobs"][ j ]["Count"]..") :"..CurSkillInfo["SummonMobs"][ j ]["Index"] )
							end
						end

						if CurSkillInfo["RegenMobs"] ~= nil
						then
							for m = 1, #CurSkillInfo["RegenMobs"]
							do
								local CurRegenInfo = CurSkillInfo["RegenMobs"][ m ]
								local nMobHandle = cMobRegen_XY( Var["MapIndex"], CurRegenInfo["Index"], CurRegenInfo["x"], CurRegenInfo["y"], CurRegenInfo["dir"] )

								if nMobHandle ~= nil
								then
									if CurRegenInfo["Index"] == "C_PillarofLight"
									then
										-- 공통 처리
										Var["Enemy"][ nMobHandle ] 			= CurRegenInfo
										Var["RoutineTime"][ nMobHandle ] 	= cCurrentSecond()

										cSetAIScript ( MainLuaScriptPath, nMobHandle )
										cAIScriptFunc( nMobHandle, "Entrance", "ImmortalPillarRoutine" )

										-- 보스 무적효과를 주는 필러 개수를 젠 할 때마다 셋팅
										Var["BossBattle"]["BossImmortalEffectCount"] = Var["BossBattle"]["BossImmortalEffectCount"] + 1
									end
								else
									DebugLog( "BossRoutine::nMobHandle == nil" )
								end
							end
						end

						if ChatInfo["BossBattle"]["Boss"..nBossType ] ~= nil
						then
							local CurChat = ChatInfo["BossBattle"]["Boss"..nBossType ]["SummonDialog"][ sCurSkillTableIndex ]

							-- 경비병이 보스의 소환 스킬을 경고해주는 페이스컷
							if CurChat ~= nil
							then
								cMobDialog( Var["MapIndex"], CurChat["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["Index"] )
							else
								ErrorLog( "BossRoutine::There is no face-cut at This Time" )
							end

						end
						-- 시전 완료 처리
						Var["BossBattle"][ sSkillName ][ i ]["bCasting"] = false
						DebugLog( "BossRoutine::EndSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )

					end -- 스킬 이름 관련 조건문 //

				end -- 스킬 시전이 준비 되었는지 확인하는 조건문 //

			end -- 한 스킬에 대한 순차적 시전 루프 //

		end -- 스킬 시전 자체를 했는가 확인하는 조건문 //

	end -- 각 스킬을 한번씩 탐색하는 루프 //

	return ReturnAI["CPP"]

end
