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


	-- // 0.2초마다 체크하는 루틴
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
	-- 0.2초마다 체크하는 루틴 //


	if Var["Enemy"][ Handle ] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "TeleportKamarisRoutine::Var[\"Enemy\"][ Handle ] == nil" )
		return ReturnAI["END"]
	end


	if cIsObjectDead( Handle ) == 1
	then
		-- 가드 다이얼로그
		cMobDialog( Var["MapIndex"], NPC_GuardChat["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["Destroy1stKamarisDialog"]["Index"] )
		Var["Enemy"][ Handle ] = nil
		Var["RoutineTime"][ Handle ] = nil
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end


	-- 게이트의 HP가 깎이는 순간에 첫 카마리스가 생존시 텔레포트 해온다.
	if Var["FirstGateAndWall"] ~= nil
	then
		if Var["FirstGateAndWall"]["bMobGateDamaged"] == true
		then
			-- 한번만 텔레포트 하도록 초기화
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


	-- // 0.2초마다 체크하는 루틴
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
	-- 0.2초마다 체크하는 루틴 //


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

			-- 첫번째 성벽의 문이 사망함을 셋팅
			Var["FirstGateAndWall"]["bMobGateLive"] = false
			-- 문1사망
			DebugLog( "Door1-Died" )

			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end

		-- 피가 조금이라도 달면 문이 데미지 입음을 셋팅
		local nCurHP, nMaxHP = cObjectHP( Handle )

		-- 해당 객체가 존재하지 않을 경우 에러
		if nCurHP == nil or nMaxHP == nil
		then
			ErrorLog( "MobGateRoutine::MobGate does not exist" )
			return ReturnAI["END"]
		end

		local Damaged_HP = nMaxHP - nCurHP
		if Damaged_HP > 0
		then
			-- 텔레포트를 딱 한번만 하게 하기 위해서
			if Var["FirstGateAndWall"]["bMobGateDamaged"] == false
			then
				Var["FirstGateAndWall"]["bMobGateDamaged"] = true
			end
		end

	elseif Var["GardenSquare"] ~= nil
	then
		if cIsObjectDead( Handle ) == 1
		then
			-- 테스트 도우미용 코드 : 문2 가 사망시 도어블럭을 열어준다.
--			cDoorAction( Var["Door2"], RegenInfo["Stuff"]["SecondGate"]["Block"], "open" )
--			Var["GardenSquare"]["bGateOpen"] = true

			-- 문2사망
			DebugLog( "Door2-Died" )

			-- 두번째 문이 사망하면 그냥 죽기
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
			-- 세번째 문이 사망함을 셋팅
			Var["FinalGate"]["bMobGateLive"] = false
			-- 문3사망
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


	-- 5개의 카마리스가 모두 없어진 경우에만 문을 열리게 함
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
-- 죽으면 죽었다 모드로 변경 Var["Enemy"][ nMobHandle ]["bLive"]

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


	-- // 0.2초마다 체크하는 루틴
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
	-- 0.2초마다 체크하는 루틴 //


	if Var["Enemy"][ Handle ] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ErrorLog( "WallDefenderRoutine::Var[\"Enemy\"][ Handle ] == nil" )
		return ReturnAI["END"]
	end


	if cIsObjectDead( Handle ) == 1
	then
		-- 사망했음을 셋팅
		Var["Enemy"][ Handle ]["bLive"] = false
		DebugLog( "DeadHandle("..Handle..")" )

		-- 이 경우 메모리 초기화는 죽은 해골 부활 이후에 처리함
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


	-- // 0.2초마다 체크하는 루틴
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
	-- 0.2초마다 체크하는 루틴 //


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
			-- 사각정원에서 다음단계를 가로 막는 문의 잠금 장치를 1개씩 해제
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
			-- 소환에 필요한 카마리스 사망수를 하나씩 줄여줌
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


	-- // 0.2초마다 체크하는 루틴
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
	-- 0.2초마다 체크하는 루틴 //


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
		-- 보스 사망 셋팅
		Var["EndOfLegend"]["bBossDied"] = true

		Var["Enemy"][ Handle ] = nil
		Var["RoutineTime"][ Handle ] = nil

		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end
end
