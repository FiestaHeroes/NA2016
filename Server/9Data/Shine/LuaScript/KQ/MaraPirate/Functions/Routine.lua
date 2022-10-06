--------------------------------------------------------------------------------
--                           Mara Pirate Routine                              --
--------------------------------------------------------------------------------

function PlayerMapLogin( MapIndex, Handle )
	cExecCheck( "PlayerMapLogin" )

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


-- 중간 보스 마라
function MiddleMaraDead( Handle, MapIndex )
	cExecCheck( "MiddleMaraDead" )

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["CPP"]
	end

	if cIsObjectDead( Handle ) == 1
	then
		cMobChat( Handle, MiddleBossChat["ScriptFileName"], MiddleBossChat["MaraDeadChat"]["Index"], true )
		cAIScriptSet( Handle )
		return ReturnAI["CPP"]
	end

	return ReturnAI["CPP"]

end


-- 중간 보스 말론
function MiddleMarloneDead( Handle, MapIndex )
	cExecCheck( "MiddleMarloneDead" )

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["CPP"]
	end

	if cIsObjectDead( Handle ) == 1
	then
		cMobChat( Handle, MiddleBossChat["ScriptFileName"], MiddleBossChat["MarloneDeadChat"]["Index"], true )
		cAIScriptSet( Handle )
		return ReturnAI["CPP"]
	end

	return ReturnAI["CPP"]

end


-- 마지막 보스 마라
function LastMaraDead( Handle, MapIndex )
	cExecCheck( "LastMaraDead" )

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["CPP"]
	end

	if cIsObjectDead( Handle ) == 1
	then
		cMobChat( Handle, BossChat["ScriptFileName"], BossChat["MaraDeadChat"]["Index"], true )
		cAIScriptSet( Handle )
		return ReturnAI["CPP"]
	end

	return ReturnAI["CPP"]

end


-- 마지막 보스 말론
function LastMarloneDead( Handle, MapIndex )
	cExecCheck( "LastMarloneDead" )

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["CPP"]
	end

	if cIsObjectDead( Handle ) == 1
	then
		cMobChat( Handle, BossChat["ScriptFileName"], BossChat["MarloneDeadChat"]["Index"], true )
		cAIScriptSet( Handle )
		return ReturnAI["CPP"]
	end

	return ReturnAI["CPP"]

end


-- 가짜 보스 마라
function VirtualMaraDead( Handle, MapIndex )
	cExecCheck( "VirtualMaraDead" )

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["CPP"]
	end

	if cIsObjectDead( Handle ) == 1
	then
		local MaraRegenInfo	= RegenInfo["Mob"]["Boss"]["RegenMara"]

		for i = 1, MaraRegenInfo["RegenNumber"]
		do
			cMobRegen_XY( Var["MapIndex"], MaraRegenInfo["Index"], MaraRegenInfo["x"], MaraRegenInfo["y"], MaraRegenInfo["dir"] )
		end

		cAIScriptSet( Handle )
		return ReturnAI["CPP"]
	end

	return ReturnAI["CPP"]

end


-- 가짜 보스 말론
function VirtualMarloneDead( Handle, MapIndex )
	cExecCheck( "VirtualMarloneDead" )

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["CPP"]
	end

	if cIsObjectDead( Handle ) == 1
	then
		local MarloneRegenInfo = RegenInfo["Mob"]["Boss"]["RegenMarlone"]

		for i = 1, MarloneRegenInfo["RegenNumber"]
		do
			cMobRegen_XY( Var["MapIndex"], MarloneRegenInfo["Index"], MarloneRegenInfo["x"], MarloneRegenInfo["y"], MarloneRegenInfo["dir"] )
		end

		cAIScriptSet( Handle )
		return ReturnAI["CPP"]
	end

	return ReturnAI["CPP"]

end
