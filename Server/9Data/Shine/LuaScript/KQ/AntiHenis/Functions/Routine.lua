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

	-- // 0.1초마다 체크하는 루틴
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
	-- 0.1초마다 체크하는 루틴 //


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


	-- Anti Henis Boss 사망
	if cIsObjectDead( Handle ) == 1
	then
		cMobShout( Handle, AntiHenisBossChat["ScriptFileName"], AntiHenisBossChat["DeathShout"]["Index"] )

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ]["PhaseNumber"] = nil
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	-- 페이즈 조건 체크 후 행동
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
		local HP_RealRate	= ( CurHP * 1000 ) / MaxHP -- 1000분율

		if HP_RealRate < AntiHenisBossSummon[ NextBossPhase ]["HP_Rate"]
		then
			-- 다음 페이즈로 바꾼 후의 페이즈의 보스 액션 실행
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


	-- // 0.1초마다 체크하는 루틴
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
	-- 0.1초마다 체크하는 루틴 //


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

