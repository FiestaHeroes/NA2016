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


	-- ù �÷��̾��� �� �α��� üũ
	Var["bPlayerMapLogin"] = true
end

--------------------------------------------------------------------------------
-- Routine_Boss
--------------------------------------------------------------------------------
function Routine_Boss( Handle, MapIndex )
cExecCheck "Routine_Boss"

	-- �Լ� ���� Ȯ��
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


	-- �ʵ� ���� Ȯ��
	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Routine_Hayreddin::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- �׾����� Ȯ��
	if cIsObjectDead( Handle ) ~= nil
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end


	-- ���۰� �ִ��� Ȯ��
	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "Routine_Hayreddin::CurBossInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- ������ �ִ��� Ȯ��
	local CurBossInfo = Var["Enemy"][ Handle ]["Info"]
	if CurBossInfo == nil
	then
		ErrorLog( "Routine_Hayreddin::CurBossInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- ������ ��ȣ Ȯ��
	local PhaseNumber = Var["Enemy"][ Handle ]["Phase"]
	if PhaseNumber == nil
	then
		ErrorLog( "Routine_Hayreddin::PhaseNumber  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- ������ ���� Ȯ��( Phase ���̺��� �ִ��� �˻� )
	local PhaseInfo = CurBossInfo["Phase"]
	if PhaseInfo == nil
	then
		ErrorLog( "Routine_Hayreddin::PhaseInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- ������ ��ȣ Ȯ��
	if PhaseNumber < 0
	then
		return ReturnAI["END"]
	end

	if PhaseNumber > #PhaseInfo
	then
		-- ó���ؾ� �� phase�� ��� ����Ǿ����Ƿ� AIScript �ʱ�ȭ ���ش�.
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end


	-- ���� ������ ���� Ȯ��
	local CurPhaseInfo = PhaseInfo[ PhaseNumber ]
	if CurPhaseInfo == nil
	then
		ErrorLog( "Routine_Hayreddin::CurPhaseInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["CPP"]
	end


	-- HP ���� Ȯ��
	if CurPhaseInfo["Condition_HPRate"] ~= nil
	then
		-- HP ����
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

	-- Phase�� ������ �ִϸ��̼�, �� ��ȯ ó��
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

	-- ������ �� 1 ����
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


	-- �÷��̾ ���踦 ������ �ִ��� Ȯ��
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


	-- ĳ���� ����
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

	-- �÷��̾ ���踦 ������ �ִ��� Ȯ��
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

	-- ���� �ı�
	if cInvenItemDestroy( PlyHandle, Var["Door"][ NPCHandle ]["Info"]["NeedItem"], 1 ) ~= 1
	then
		return
	end

	-- ������ Ŭ���� ���� ���ÿ� ��������� �� ������, �ش� �� �����ֱ�
	if Var["Door"][ NPCHandle ]["TwinGate"] ~= nil
	then
		local TwinNPCHandle = Var["Door"][ Var["Door"][ NPCHandle ]["TwinGate"] ]

		DebugLog("�ֵ��� ����Ʈ�� "..Var["Door"][ NPCHandle ]["TwinGate"] )
		DebugLog("�ֵ��� ����Ʈ �ڵ鰪�� : "..TwinNPCHandle )

		if TwinNPCHandle == nil
		then
			ErrorLog( "Menu_Door::TwinNPCHandle == nil" )
		end

		cDoorAction( TwinNPCHandle, Var["Door"][ TwinNPCHandle ]["Info"]["Block"], "open" )
		Var["Door"][ TwinNPCHandle ]["IsOpen"] = true
		cAIScriptSet( TwinNPCHandle )
	end

	-- ������ Ŭ���� �� �����ֱ�
	cDoorAction( NPCHandle, Var["Door"][ NPCHandle ]["Info"]["Block"], "open" )
	Var["Door"][ NPCHandle ]["IsOpen"] = true
	cAIScriptSet( NPCHandle )

	-- ���� ����Ʈ�� �����ؾ� �� �Լ� ����
	local FuncName = Var["Door"][ NPCHandle ]["Info"]["FuncName"]

	Var["GateProcess"][FuncName] 				= {}
	Var["GateProcess"][FuncName]["IsProceed"]	= false

	DebugLog( "Menu_Door::End" )
end
