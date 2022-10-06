--------------------------------------------------------------------------------
--                       Legend Of Bijou Routine                              --
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

	-- �ð� ������ ���� ���� ���� ��쿡�� �ƹ��͵� �������� �ʴ´�.
	if Var["KQLimitTime"] == nil
	then
		return
	end

	if Var["CurSec"] == nil
	then
		return
	end

	-- ���� �ð� �������� ���ѽð��� �޾Ƽ� ��û�Ѵ�.
	local nLimitSec = Var["KQLimitTime"] - Var["CurSec"]

	cShowKQTimerWithLife_Obj( Handle, nLimitSec )

end

function TeleportKamarisRoutine( Handle, MapIndex )
cExecCheck "TeleportKamarisRoutine"

	if Handle == nil
	then
		ErrorLog( "TeleportKamarisRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "TeleportKamarisRoutine::MapIndex == nil" )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "TeleportKamarisRoutine::Var == nil" )
		return ReturnAI["END"]
	end


	-- // 0.2�ʸ��� üũ�ϴ� ��ƾ
	if Var["RoutineTime"][ Handle ] == nil
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond()
	end

	if Var["RoutineTime"][ Handle ] + 0.2 > cCurrentSecond()
	then
		return ReturnAI["CPP"]
	else
		Var["RoutineTime"][ Handle ] = cCurrentSecond()
	end
	-- 0.2�ʸ��� üũ�ϴ� ��ƾ //


	if Var["Enemy"][ Handle ] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "TeleportKamarisRoutine::Var[\"Enemy\"][ Handle ] == nil" )
		return ReturnAI["END"]
	end


	if cIsObjectDead( Handle ) == 1
	then
		-- ���� ���̾�α�
		cMobDialog( Var["MapIndex"], NPC_GuardChat["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["Destroy1stKamarisDialog"]["Index"] )
		Var["Enemy"][ Handle ] = nil
		Var["RoutineTime"][ Handle ] = nil
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end


	-- ����Ʈ�� HP�� ���̴� ������ ù ī�������� ������ �ڷ���Ʈ �ؿ´�.
	if Var["FirstGateAndWall"] ~= nil
	then
		if Var["FirstGateAndWall"]["bMobGateDamaged"] == true
		then
			-- �ѹ��� �ڷ���Ʈ �ϵ��� �ʱ�ȭ
			Var["FirstGateAndWall"]["bMobGateDamaged"] = nil

			local Coord = Var["Enemy"][ Handle ]["TeleportCoord"]
			cCastTeleport( Handle, "SpecificCoord", Coord["x"], Coord["y"] )
		end
	end

	return ReturnAI["CPP"]
end


function MobGateRoutine( Handle, MapIndex )
cExecCheck "MobGateRoutine"

	if Handle == nil
	then
		ErrorLog( "MobGateRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "MobGateRoutine::MapIndex == nil" )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "MobGateRoutine::Var == nil" )
		return ReturnAI["END"]
	end


	-- // 0.2�ʸ��� üũ�ϴ� ��ƾ
	if Var["RoutineTime"][ Handle ] == nil
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond()
	end

	if Var["RoutineTime"][ Handle ] + 0.2 > cCurrentSecond()
	then
		return ReturnAI["CPP"]
	else
		Var["RoutineTime"][ Handle ] = cCurrentSecond()
	end
	-- 0.2�ʸ��� üũ�ϴ� ��ƾ //


	if Var["Enemy"][ Handle ] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "MobGateRoutine::Var[\"Enemy\"][ Handle ] == nil" )
		return ReturnAI["END"]
	end


	if Var["FirstGateAndWall"] ~= nil
	then
		Var["FirstGateAndWall"]["bMobGateLive"] = true

		if cIsObjectDead( Handle ) == 1
		then
			Var["Enemy"][ Handle ] = nil
			Var["RoutineTime"][ Handle ] = nil

			-- ù��° ������ ���� ������� ����
			Var["FirstGateAndWall"]["bMobGateLive"] = false
			-- ��1���
			DebugLog( "Door1-Died" )

			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end

		-- �ǰ� �����̶� �޸� ���� ������ ������ ����
		local nCurHP, nMaxHP = cObjectHP( Handle )

		-- �ش� ��ü�� �������� ���� ��� ����
		if nCurHP == nil or nMaxHP == nil
		then
			ErrorLog( "MobGateRoutine::MobGate does not exist" )
			return ReturnAI["END"]
		end

		local Damaged_HP = nMaxHP - nCurHP
		if Damaged_HP > 0
		then
			-- �ڷ���Ʈ�� �� �ѹ��� �ϰ� �ϱ� ���ؼ�
			if Var["FirstGateAndWall"]["bMobGateDamaged"] == false
			then
				Var["FirstGateAndWall"]["bMobGateDamaged"] = true
			end
		end

	elseif Var["GardenSquare"] ~= nil
	then
		if cIsObjectDead( Handle ) == 1
		then
			-- �׽�Ʈ ����̿� �ڵ� : ��2 �� ����� ������� �����ش�.
--			cDoorAction( Var["Door2"], RegenInfo["Stuff"]["SecondGate"]["Block"], "open" )
--			Var["GardenSquare"]["bGateOpen"] = true

			-- ��2���
			DebugLog( "Door2-Died" )

			-- �ι�° ���� ����ϸ� �׳� �ױ�
			Var["Enemy"][ Handle ] = nil
			Var["RoutineTime"][ Handle ] = nil
			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end
	elseif Var["FinalGate"] ~= nil
	then
		Var["FinalGate"]["bMobGateLive"] = true

		if cIsObjectDead( Handle ) == 1
		then
			-- ����° ���� ������� ����
			Var["FinalGate"]["bMobGateLive"] = false
			-- ��3���
			DebugLog( "Door3-Died" )

			Var["Enemy"][ Handle ] = nil
			Var["RoutineTime"][ Handle ] = nil

			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end
	else
		ErrorLog( "MobGateRoutine::Progress Step is illegal" )
	end

	return ReturnAI["CPP"]

end


function MobGateClick( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "MobGateClick"

	DebugLog( "MobGateClick::Start" )

	if NPCHandle == nil
	then
		ErrorLog( "MobGateClick::NPCHandle == nil" )
		return
	end

	if PlyHandle == nil
	then
		ErrorLog( "MobGateClick::PlyHandle == nil" )
		return
	end


	local MapIndex = cGetCurMapIndex( PlyHandle )

	if MapIndex == nil
	then
		ErrorLog( "MobGateClick::MapIndex == nil" )
		return
	end

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		ErrorLog( "MobGateClick::Var == nil" )
		return
	end


	if Var["Door2"] == nil
	then
		ErrorLog( "MobGateClick::Var[\"Door2\"] == nil" )
		return
	end

	if Var["GardenSquare"] == nil
	then
		ErrorLog( "MobGateClick::Var[\"GardenSquare\"] == nil" )
		return
	end


	-- 5���� ī�������� ��� ������ ��쿡�� ���� ������ ��
	if Var["Door2Lock"] <= 0
	then
		DebugLog( "MobGateClick::Gate Open!" )

		if cDoorAction( Var["Door2"], RegenInfo["Stuff"]["SecondGate"]["Block"], "open" ) == nil
		then
			ErrorLog( "MobGateClick::Gate was not Opened" )
		end

		Var["GardenSquare"]["bGateOpen"] = true

		cMobSuicide( Var["MapIndex"], NPCHandle )
		DebugLog( "MobGateClick::Gate Opened" )
	else
		DebugLog( "MobGateClick::Still Closed" )
	end

	DebugLog( "MobGateClick::End" )
end


function WallDefenderRoutine( Handle, MapIndex )
cExecCheck "WallDefenderRoutine"
-- ������ �׾��� ���� ���� Var["Enemy"][ nMobHandle ]["bLive"]

	if Handle == nil
	then
		ErrorLog( "WallDefenderRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "WallDefenderRoutine::MapIndex == nil" )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "WallDefenderRoutine::Var == nil" )
		return ReturnAI["END"]
	end


	-- // 0.2�ʸ��� üũ�ϴ� ��ƾ
	if Var["RoutineTime"][ Handle ] == nil
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond()
	end

	if Var["RoutineTime"][ Handle ] + 0.2 > cCurrentSecond()
	then
		return ReturnAI["CPP"]
	else
		Var["RoutineTime"][ Handle ] = cCurrentSecond()
	end
	-- 0.2�ʸ��� üũ�ϴ� ��ƾ //


	if Var["Enemy"][ Handle ] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "WallDefenderRoutine::Var[\"Enemy\"][ Handle ] == nil" )
		return ReturnAI["END"]
	end


	if cIsObjectDead( Handle ) == 1
	then
		-- ��������� ����
		Var["Enemy"][ Handle ]["bLive"] = false
		DebugLog( "DeadHandle("..Handle..")" )

		-- �� ��� �޸� �ʱ�ȭ�� ���� �ذ� ��Ȱ ���Ŀ� ó����
		Var["RoutineTime"][ Handle ] = nil

		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	return ReturnAI["CPP"]

end


function GardenKamarisRoutine( Handle, MapIndex )
cExecCheck "GardenKamarisRoutine"

	if Handle == nil
	then
		ErrorLog( "GardenKamarisRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "GardenKamarisRoutine::MapIndex == nil" )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "GardenKamarisRoutine::Var == nil" )
		return ReturnAI["END"]
	end


	-- // 0.2�ʸ��� üũ�ϴ� ��ƾ
	if Var["RoutineTime"][ Handle ] == nil
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond()
	end

	if Var["RoutineTime"][ Handle ] + 0.2 > cCurrentSecond()
	then
		return ReturnAI["CPP"]
	else
		Var["RoutineTime"][ Handle ] = cCurrentSecond()
	end
	-- 0.2�ʸ��� üũ�ϴ� ��ƾ //


	if Var["Enemy"][ Handle ] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "GardenKamarisRoutine::Var[\"Enemy\"][ Handle ] == nil" )
		return ReturnAI["END"]
	end


	if Var["GardenSquare"] ~= nil
	then
		if cIsObjectDead( Handle ) == 1
		then
			-- �簢�������� �����ܰ踦 ���� ���� ���� ��� ��ġ�� 1���� ����
			Var["Door2Lock"] = Var["Door2Lock"] - 1

			Var["Enemy"][ Handle ] = nil
			Var["RoutineTime"][ Handle ] = nil

			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end
	elseif Var["EndOfLegend"] ~= nil
	then
		if cIsObjectDead( Handle ) == 1
		then
			-- ��ȯ�� �ʿ��� ī������ ������� �ϳ��� �ٿ���
			Var["CallBossLock"] = Var["CallBossLock"] - 1

			Var["Enemy"][ Handle ] = nil
			Var["RoutineTime"][ Handle ] = nil

			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end
	else
		ErrorLog( "GardenKamarisRoutine::Progress Step is illegal" )
		return ReturnAI["CPP"]
	end

	return ReturnAI["CPP"]

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
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "BossRoutine::MapIndex == nil" )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "BossRoutine::Var == nil" )
		return ReturnAI["END"]
	end


	-- // 0.2�ʸ��� üũ�ϴ� ��ƾ
	if Var["RoutineTime"][ Handle ] == nil
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond()
	end

	if Var["RoutineTime"][ Handle ] + 0.2 > cCurrentSecond()
	then
		return ReturnAI["CPP"]
	else
		Var["RoutineTime"][ Handle ] = cCurrentSecond()
	end
	-- 0.2�ʸ��� üũ�ϴ� ��ƾ //


	if Var["Enemy"][ Handle ] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "BossRoutine::Var[\"Enemy\"][ Handle ] == nil" )
		return ReturnAI["END"]
	end


	if Var["EndOfLegend"] == nil
	then
		return ReturnAI["CPP"]
	end


	if cIsObjectDead( Handle ) == 1
	then
		-- ���� ��� ����
		Var["EndOfLegend"]["bBossDied"] = true

		Var["Enemy"][ Handle ] = nil
		Var["RoutineTime"][ Handle ] = nil

		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end
end
