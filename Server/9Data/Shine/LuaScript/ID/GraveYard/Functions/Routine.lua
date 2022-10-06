--------------------------------------------------------------------------------
--                       		Routine		                                  --
--------------------------------------------------------------------------------
function DummyRoutineFunc( )
cExecCheck "DummyRoutineFunc"
end

--------------------------------------------------------------------------------
-- PlayerMapLogin
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
end

--------------------------------------------------------------------------------
-- Routine_Boss
--------------------------------------------------------------------------------
function Routine_Boss( Handle, MapIndex )
cExecCheck "Routine_Boss"

	-- 함수 인자 확인
	if Handle == nil
	then
		ErrorLog( "Routine_Hayreddin::Handle == nil" )

		return ReturnAI["END"]
	end


	if MapIndex == nil
	then
		ErrorLog( "Routine_Hayreddin::MapIndex == nil" )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 필드 버퍼 확인
	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Routine_Hayreddin::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 죽었는지 확인
	if cIsObjectDead( Handle ) ~= nil
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end


	-- 버퍼가 있는지 확인
	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "Routine_Hayreddin::CurBossInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 정보가 있는지 확인
	local CurBossInfo = Var["Enemy"][ Handle ]["Info"]
	if CurBossInfo == nil
	then
		ErrorLog( "Routine_Hayreddin::CurBossInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 페이즈 번호 확인
	local PhaseNumber = Var["Enemy"][ Handle ]["Phase"]
	if PhaseNumber == nil
	then
		ErrorLog( "Routine_Hayreddin::PhaseNumber  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 페이즈 정보 확인( Phase 테이블이 있는지 검사 )
	local PhaseInfo = CurBossInfo["Phase"]
	if PhaseInfo == nil
	then
		ErrorLog( "Routine_Hayreddin::PhaseInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 페이즈 번호 확인
	if PhaseNumber < 0
	then
		return ReturnAI["END"]
	end

	if PhaseNumber > #PhaseInfo
	then
		-- 처리해야 할 phase가 모두 종료되었으므로 AIScript 초기화 해준다.
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end


	-- 현재 페이즈 정보 확인
	local CurPhaseInfo = PhaseInfo[ PhaseNumber ]
	if CurPhaseInfo == nil
	then
		ErrorLog( "Routine_Hayreddin::CurPhaseInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["CPP"]
	end


	-- HP 조건 확인
	if CurPhaseInfo["Condition_HPRate"] ~= nil
	then
		-- HP 정보
		local nCurHP, nMaxHP = cObjectHP( Handle )
		if nCurHP == nil or nMaxHP == nil
		then
			ErrorLog( "Routine_Hayreddin::nCurHP == nil or nMaxHP == nil" )
			return ReturnAI["CPP"]
		end

		local nCurHPRate = nCurHP / nMaxHP * 100

		if nCurHPRate > CurPhaseInfo["Condition_HPRate"]
		then
			return ReturnAI["CPP"]
		end
	end

	-- Phase에 설정된 애니메이션, 몹 소환 처리
	if cAnimate( Handle, "start", CurPhaseInfo["Animation"] ) == nil
	then
		DebugLog("Routine_Hayreddin::Animation Fail" )
	end

	for i = 1, CurPhaseInfo["SummonMob"]["Num"]
	do
		local Dir				= cRandomInt( 1, 90 ) * 4
		local RegenX, RegenY 	= cGetAroundCoord( Handle, Dir, 250 )

		if cMobRegen_XY( Var["MapIndex"], CurPhaseInfo["SummonMob"]["Index"], RegenX, RegenY, 0 ) == nil
		then
			ErrorLog("Routine_Boss::SummonMob Regen Fail")
		end
	end

	-- 페이즈 값 1 증가
	Var["Enemy"][ Handle ]["Phase"] = Var["Enemy"][ Handle ]["Phase"] + 1

	return ReturnAI["CPP"]
end

--------------------------------------------------------------------------------
-- Click_Door
--------------------------------------------------------------------------------
function Click_Door( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "Click_Door"

	DebugLog( "Click_Door::Start" )

	if NPCHandle == nil
	then
		ErrorLog( "Click_Door::NPCHandle == nil" )
		return
	end


	if PlyHandle == nil
	then
		ErrorLog( "Click_Door::PlyHandle == nil" )
		return
	end


	local MapIndex = cGetCurMapIndex( NPCHandle )

	if MapIndex == nil
	then
		ErrorLog( "Click_Door::MapIndex == nil" )
		return
	end


	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		ErrorLog( "Click_Door::Var == nil" )
		return
	end

	if Var["Door"] == nil
	then
		ErrorLog( "Click_Door::Var[\"Door\"] == nil" )
		return
	end

	if Var["Door"][ NPCHandle ] == nil
	then
		ErrorLog( "Click_Door::Var[\"Door\"][NPCHandle] == nil" )
		return
	end

	if Var["Door"][ NPCHandle ]["IsOpen"] == true
	then
		return
	end


	-- 플레이어가 열쇠를 가지고 있는지 확인
	local ItemLot, bLocked	= cGetItemLot( PlyHandle, Var["Door"][ NPCHandle ]["Info"]["NeedItem"] )

	if bLocked == nil
	then
		cNotice_Obj( PlyHandle, ChatInfo["ScriptFileName"], ChatInfo["SystemMessage"]["Error_DoorOpen"] )
		return
	end

	if bLocked == 1
	then
		cNotice_Obj( PlyHandle, ChatInfo["ScriptFileName"], ChatInfo["SystemMessage"]["Error_DoorOpen"] )
		return
	end

	if ItemLot == nil
	then
		cNotice_Obj( PlyHandle, ChatInfo["ScriptFileName"], ChatInfo["SystemMessage"]["Error_DoorOpen"] )
		return
	end

	if ItemLot < 1
	then
		cNotice_Obj( PlyHandle, ChatInfo["ScriptFileName"], ChatInfo["SystemMessage"]["Error_DoorOpen"] )
		return
	end


	-- 캐스팅 시작
	cCastingBar( PlyHandle, NPCHandle, (Var["Door"][ NPCHandle ]["Info"]["CastingTime"] * 1000), Var["Door"][ NPCHandle ]["Info"]["CastingAni"] )


	DebugLog( "Click_Door::End" )
end


--------------------------------------------------------------------------------
-- Click_ExitGate
--------------------------------------------------------------------------------
function Click_ExitGate( NPCHandle, PlyHandle, RegistNumber )
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


	cLinkTo( PlyHandle, LinkInfo["ReturnMap"]["MapIndex"], LinkInfo["ReturnMap"]["x"], LinkInfo["ReturnMap"]["y"] )

	DebugLog( "ExitGateClick::End" )
end


--------------------------------------------------------------------------------
-- Menu_Door
--------------------------------------------------------------------------------
function Menu_Door( NPCHandle, PlyHandle, RegistNumber, Menu )
cExecCheck "Menu_Door"

	DebugLog( "Menu_Door::Start" )

	if NPCHandle == nil
	then
		ErrorLog( "Menu_Door::NPCHandle == nil" )
		return
	end

	if PlyHandle == nil
	then
		ErrorLog( "Menu_Door::PlyHandle == nil" )
		return
	end


	local MapIndex = cGetCurMapIndex( NPCHandle )

	if MapIndex == nil
	then
		ErrorLog( "Menu_Door::MapIndex == nil" )
		return
	end


	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		ErrorLog( "Menu_Door::Var == nil" )
		return
	end

	if Var["Door"] == nil
	then
		ErrorLog( "Menu_Door::Var[\"Door\"] == nil" )
		return
	end

	if Var["Door"][ NPCHandle ] == nil
	then
		ErrorLog( "Menu_Door::Var[\"Door\"][NPCHandle] == nil" )
		return
	end


	if Var["Door"][ NPCHandle ]["IsOpen"] == true
	then
		return
	end

	-- 플레이어가 열쇠를 가지고 있는지 확인
	local ItemLot, bLocked	= cGetItemLot( PlyHandle, Var["Door"][ NPCHandle ]["Info"]["NeedItem"] )

	if bLocked == nil
	then
		cNotice_Obj( PlyHandle, ChatInfo["ScriptFileName"], ChatInfo["SystemMessage"]["Error_DoorOpen"] )
		return
	end

	if bLocked == 1
	then
		cNotice_Obj( PlyHandle, ChatInfo["ScriptFileName"], ChatInfo["SystemMessage"]["Error_DoorOpen"] )
		return
	end

	if ItemLot == nil
	then
		cNotice_Obj( PlyHandle, ChatInfo["ScriptFileName"], ChatInfo["SystemMessage"]["Error_DoorOpen"] )
		return
	end

	if ItemLot < 1
	then
		cNotice_Obj( PlyHandle, ChatInfo["ScriptFileName"], ChatInfo["SystemMessage"]["Error_DoorOpen"] )
		return
	end

	-- 열쇠 파괴
	if cInvenItemDestroy( PlyHandle, Var["Door"][ NPCHandle ]["Info"]["NeedItem"], 1 ) ~= 1
	then
		return
	end

	-- 유저가 클릭한 문과 동시에 열어줘야할 문 있으면, 해당 문 열어주기
	if Var["Door"][ NPCHandle ]["TwinGate"] ~= nil
	then
		local TwinNPCHandle = Var["Door"][ Var["Door"][ NPCHandle ]["TwinGate"] ]

		DebugLog("쌍둥이 게이트는 "..Var["Door"][ NPCHandle ]["TwinGate"] )
		DebugLog("쌍둥이 게이트 핸들값은 : "..TwinNPCHandle )

		if TwinNPCHandle == nil
		then
			ErrorLog( "Menu_Door::TwinNPCHandle == nil" )
		end

		cDoorAction( TwinNPCHandle, Var["Door"][ TwinNPCHandle ]["Info"]["Block"], "open" )
		Var["Door"][ TwinNPCHandle ]["IsOpen"] = true
		cAIScriptSet( TwinNPCHandle )
	end

	-- 유저가 클릭한 문 열어주기
	cDoorAction( NPCHandle, Var["Door"][ NPCHandle ]["Info"]["Block"], "open" )
	Var["Door"][ NPCHandle ]["IsOpen"] = true
	cAIScriptSet( NPCHandle )

	-- 열린 게이트가 실행해야 할 함수 세팅
	local FuncName = Var["Door"][ NPCHandle ]["Info"]["FuncName"]

	Var["GateProcess"][FuncName] 				= {}
	Var["GateProcess"][FuncName]["IsProceed"]	= false

	DebugLog( "Menu_Door::End" )
end
