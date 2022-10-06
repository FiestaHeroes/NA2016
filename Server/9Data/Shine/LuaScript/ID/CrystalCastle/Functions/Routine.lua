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


	-- ù �÷��̾��� �� �α��� üũ
	Var["bPlayerMapLogin"] = true


	-- �÷��̾ ���� ��Ʋ ��忡�� �۵��� ��ƾ ���
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


	-- Player ���
	if cIsObjectDead( DeadHandle ) ~= nil
	then
		if Var["BossBattle"] ~= nil
		then
			-- ���� ���� �÷��̾� üũ
			local InBossAreaPlayerHandleList = { cGetAreaObjectList( Var["MapIndex"], BossArea["Index"], ObjectType["Player"] ) }

			for i, v in pairs ( InBossAreaPlayerHandleList )
			do
				DebugLog( "PlayerDied::Handle( Order "..i.." : "..v.." )" )
			end

			-- ����� ������ ��� ����� ���� ����
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


	-- 0.2�ʸ��� üũ�ϴ� ��ƾ
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


	-- Mid Boss ���
	if cIsObjectDead( Handle ) == 1
	then
		-- �ܸ� ��� �ڻ�
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


	-- 0.2�ʸ��� üũ�ϴ� ��ƾ
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


	-- Key Box ����
	if cIsObjectDead( Handle ) == 1
	then
		-- �ڽ� ��� ��������� ����
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


	-- 0.2�ʸ��� üũ�ϴ� ��ƾ
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

	-- Key Box ������ �˾Ƽ� �������.
	if Var["EachFloor"..Var["EachFloor"]["StepNumber"] ]["KeyBoxOpened"] == true
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	if cIsObjectDead( Handle ) == 1
	then
		-- ���� ���⵵�� ����
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


	-- 0.2�ʸ��� üũ�ϴ� ��ƾ
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

	-- Key Box ������ �˾Ƽ� �������.
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
-- ObjectDied ��ƾ�� ���� ���� ���� ��ƾ
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


	-- 0.2�ʸ��� üũ�ϴ� ��ƾ
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

		-- ��� Ȯ���� ���� ��� ������ ����
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


	-- 0.2�ʸ��� üũ�ϴ� ��ƾ
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


	-- 0.2�ʸ��� üũ�ϴ� ��ƾ
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


	-- 0.2�ʸ��� üũ�ϴ� ��ƾ
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


	-- �����߿� ���� ������ �����ϰ� �����ϱ� ����
	if Var["BossBattle"]["Casting"] == nil
	then
		Var["BossBattle"]["Casting"] = {}
	end


	local HP_Rate = ( CurHP * 1000 ) / MaxHP

	local nBossType = Var["StageInfo"]["BossTypeNo"]

	-- ��ų���� �ѹ� �� Ž��
	for nIndex, sSkillName in pairs ( BossSkillNameTable )
	do
		-- ������� ��ų��������� �ʱ�ȭ
		if Var["BossBattle"][ sSkillName.."PhaseNo"] == nil
		then
			Var["BossBattle"][ sSkillName.."PhaseNo"] = 1
		end

		-- ���� ��ų ������ ���� ���̺��� ������� ����
		if Var["BossBattle"][ sSkillName ] == nil
		then
			Var["BossBattle"][ sSkillName ] = {}
		end


		-- �ܰ��̸� �޾ƿ���
		local CurStepNo = #StepNameTable - 1
		local CurStep = StepNameTable[ CurStepNo ]

		-- ��ų ������ ����
		local sThresholdTableIndex = sSkillName.."HP_Boss"..nBossType -- ex ) "SummonHP_Boss1 "HP_"..CurStep
		local nCurPhase = Var["BossBattle"][ sSkillName.."PhaseNo"]
		local nMaxPhase = #ThresholdTable[ sThresholdTableIndex ]

		if nCurPhase <= nMaxPhase
		then
			-- ���� HP�� ��ų�� Threshold �� ���Ͽ� ���������� �ұ� �����Ͽ� ����
			while ThresholdTable[ sThresholdTableIndex ][ nCurPhase ] >= HP_Rate
			do
				-- ������ ��ų�� ���̺� �� �ε��� �޾ƿ���
				local sCurSkillIndex = "HP"..ThresholdTable[ sThresholdTableIndex ][ nCurPhase ] -- ex) "HP800"
				local sBossSkillTableIndex = sThresholdTableIndex -- �����ϰ� ������

				if BossSkill[ sBossSkillTableIndex ][ sCurSkillIndex ] ~= nil
				then
					-- ��ų�� ��ƾ���� �����ϵ��� ����
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

			end -- ��ų�� �����϶�� ������� �������ִ� ����

			-- �޸��� ��ų ������ ���� �� ����
			Var["BossBattle"][ sSkillName.."PhaseNo"] = nCurPhase

		end -- �� ��ų�� ������ �ʰ��ߴ��� Ȯ�����ִ� ���ǹ� //

	end -- ��ų���� �ѹ��� Ž���ϴ� ���� //

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


	-- 0.2�ʸ��� üũ�ϴ� ��ƾ
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


	-- Boss ���
	if cIsObjectDead( Handle ) == 1
	then
		DebugLog( "BossRoutine::BossDead" )
		cMobSuicide( Var["MapIndex"] )

		-- ��ų���� �޸� �ʱ�ȭ
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

	-- ���� �����̻� ����
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


	-- ��ų���� �ѹ� �� Ž��
	for nIndex, sSkillName in pairs ( BossSkillNameTable )
	do
		-- ���� ��ų ������ �ش� ��ų �������̺��� ���ٸ� ���� ������ �ȵ� ���̹Ƿ� �н�
		if Var["BossBattle"][ sSkillName.."PhaseNo"] ~= nil and Var["BossBattle"][ sSkillName ] ~= nil
		then
			-- �������ε� ��ų�鸸 ������� �����ؾ���.
			for i = 1, #Var["BossBattle"][ sSkillName ]
			do
				-- ����üũ
				if Var["BossBattle"][ sSkillName ][ i ] == nil
				then
					break
				end

				-- �غ�� ��ų ����
				if Var["BossBattle"][ sSkillName ][ i ]["bCasting"] == true
				then
					local sCurSkillTableIndex = Var["BossBattle"][ sSkillName ][ i ]["sSkillTableIndex"] -- ex) "HP800"

					-- �ܰ��̸� �޾ƿ���
					local CurStepNo = #StepNameTable - 1
					local CurStep = StepNameTable[ CurStepNo ]

					-- ��ų ���̺� �ε��� ����
					local sBossSkillTableIndex = sSkillName.."HP_Boss"..nBossType -- ex ) "SummonHP_Boss1"

					-- ��ų ���� ��������
					local CurSkillInfo = BossSkill[ sBossSkillTableIndex ][ sCurSkillTableIndex ]

					-- �ܸ� ��ȯ
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
										-- ���� ó��
										Var["Enemy"][ nMobHandle ] 			= CurRegenInfo
										Var["RoutineTime"][ nMobHandle ] 	= cCurrentSecond()

										cSetAIScript ( MainLuaScriptPath, nMobHandle )
										cAIScriptFunc( nMobHandle, "Entrance", "ImmortalPillarRoutine" )

										-- ���� ����ȿ���� �ִ� �ʷ� ������ �� �� ������ ����
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

							-- ����� ������ ��ȯ ��ų�� ������ִ� ���̽���
							if CurChat ~= nil
							then
								cMobDialog( Var["MapIndex"], CurChat["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["Index"] )
							else
								ErrorLog( "BossRoutine::There is no face-cut at This Time" )
							end

						end
						-- ���� �Ϸ� ó��
						Var["BossBattle"][ sSkillName ][ i ]["bCasting"] = false
						DebugLog( "BossRoutine::EndSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )

					end -- ��ų �̸� ���� ���ǹ� //

				end -- ��ų ������ �غ� �Ǿ����� Ȯ���ϴ� ���ǹ� //

			end -- �� ��ų�� ���� ������ ���� ���� //

		end -- ��ų ���� ��ü�� �ߴ°� Ȯ���ϴ� ���ǹ� //

	end -- �� ��ų�� �ѹ��� Ž���ϴ� ���� //

	return ReturnAI["CPP"]

end
