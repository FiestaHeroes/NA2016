--------------------------------------------------------------------------------
--                            Anti Henis Routine                              --
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


function AntiHenisBossRoutine( Handle, MapIndex )
cExecCheck "AntiHenisBossRoutine"

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local RoutineTimeIndex = ""..Handle

	-- // 0.1�ʸ��� üũ�ϴ� ��ƾ
	if Var["RoutineTime"][ RoutineTimeIndex ] == nil
	then
		Var["RoutineTime"][ RoutineTimeIndex ] = cCurrentSecond()
	end


	if Var["RoutineTime"][ RoutineTimeIndex ] + 0.1 > cCurrentSecond()
	then
		return ReturnAI["CPP"]
	else
		Var["RoutineTime"][ RoutineTimeIndex ] = cCurrentSecond()
	end
	-- 0.1�ʸ��� üũ�ϴ� ��ƾ //


	if Var["Enemy"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- Anti Henis Boss ���
	if cIsObjectDead( Handle ) == 1
	then
		cMobShout( Handle, AntiHenisBossChat["ScriptFileName"], AntiHenisBossChat["DeathShout"]["Index"] )

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ]["PhaseNumber"] = nil
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	-- ������ ���� üũ �� �ൿ
	if Var["Enemy"][ Handle ]["PhaseNumber"] == nil
	then
		Var["Enemy"][ Handle ]["PhaseNumber"] = 1
	end

	local CurHP, MaxHP	= cObjectHP( Handle )
	local RoutineStepFunc = nil

	if CurHP == MaxHP
	then
		RoutineStepFunc	= DummyPhaseFunc
	elseif Var["Enemy"][ Handle ]["PhaseNumber"] < #BossPhaseNameTable
	then
		local NextBossPhase	= BossPhaseNameTable[ Var["Enemy"][ Handle ]["PhaseNumber"] + 1 ]
		local HP_RealRate	= ( CurHP * 1000 ) / MaxHP -- 1000����

		if HP_RealRate < AntiHenisBossSummon[ NextBossPhase ]["HP_Rate"]
		then
			-- ���� ������� �ٲ� ���� �������� ���� �׼� ����
			Var["Enemy"][ Handle ]["PhaseNumber"] = Var["Enemy"][ Handle ]["PhaseNumber"] + 1
			RoutineStepFunc	= PhaseActionFunc
		else
			RoutineStepFunc	= DummyPhaseFunc
		end
	else
		RoutineStepFunc	= DummyPhaseFunc
	end

	RoutineStepFunc( Handle, MapIndex )


	return ReturnAI["CPP"]

end


function DummyPhaseFunc( )
cExecCheck "DummyPhaseFunc"

end


function PhaseActionFunc( BossHandle, MapIndex )
cExecCheck "PhaseActionFunc"

	if BossHandle == nil
	then
		return
	end

	if MapIndex == nil
	then
		return
	end

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		return
	end


	local PhaseNumber 	= Var["Enemy"][ BossHandle ]["PhaseNumber"]
	local BossPhase 	= BossPhaseNameTable[ PhaseNumber ]

	DebugLog( "Start PhaseActionFunc::"..BossPhase )

	cMobShout( BossHandle, AntiHenisBossChat["ScriptFileName"], AntiHenisBossChat["SummonMobShout"]["Index"] )

	for i = 1, #AntiHenisBossSummon[ BossPhase ]["SummonMobs"]
	do
		local SummonMobInfo		= {}
		local SummonMobHandle 	= nil

		SummonMobHandle = cMobRegen_Obj( AntiHenisBossSummon[ BossPhase ]["SummonMobs"][i], BossHandle )

		if SummonMobHandle ~= nil
		then
			cSetAIScript ( MainLuaScriptPath, SummonMobHandle )
			cAIScriptFunc( SummonMobHandle, "Entrance", "SummonMobRoutine" )

			Var["Enemy"][ SummonMobHandle ] 			= SummonMobInfo
			Var["Enemy"][ SummonMobHandle ]["Handle"] 	= SummonMobHandle
		end
	end

	DebugLog( "End PhaseActionFunc::"..BossPhase )

end


function SummonMobRoutine( Handle, MapIndex )
cExecCheck "SummonMobRoutine"

	local Var = InstanceField[ MapIndex ]

	if Var == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- // 0.1�ʸ��� üũ�ϴ� ��ƾ
	local RoutineTimeIndex = ""..Handle

	if Var["RoutineTime"][ RoutineTimeIndex ] == nil
	then
		Var["RoutineTime"][ RoutineTimeIndex ] = cCurrentSecond()
	end

	if Var["RoutineTime"][ RoutineTimeIndex ] + 0.1 > cCurrentSecond()
	then
		return ReturnAI["CPP"]
	else
		Var["RoutineTime"][ RoutineTimeIndex ] = cCurrentSecond()
	end
	-- 0.1�ʸ��� üũ�ϴ� ��ƾ //


	if Var["Enemy"] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["RoutineTime"][ RoutineTimeIndex ] = nil
		return ReturnAI["END"]
	end


	if Var["Enemy"][ Handle ] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["RoutineTime"][ RoutineTimeIndex ] = nil
		return ReturnAI["END"]
	end


	if cIsObjectDead( Handle ) == 1
	then
		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		Var["RoutineTime"][ RoutineTimeIndex ] = nil
		return ReturnAI["END"]
	end

	return ReturnAI["CPP"]

end

