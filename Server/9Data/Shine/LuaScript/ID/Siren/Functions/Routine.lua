--------------------------------------------------------------------------------
--                       Seiren Castle Routine                                --
--------------------------------------------------------------------------------

function DummyRoutineFunc( )
cExecCheck "DummyRoutineFunc"
end


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
-- Routine Function
--------------------------------------------------------------------------------
function Routine_Normal( Handle, MapIndex )
cExecCheck "Routine_Normal"


	-- 함수 인자 확인
	if Handle == nil
	then
		ErrorLog( "Routine_Normal::Handle == nil" )

		return ReturnAI["END"]
	end


	if MapIndex == nil
	then
		ErrorLog( "Routine_Normal::MapIndex == nil" )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 필드 버퍼 확인
	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Routine_Normal::Var == nil"..MapIndex )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 0.2초마다 확인하는 루틴
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	-- 보스 몬스터가 죽었는지 확인
	if cIsObjectDead( Handle ) == nil
	then
		return ReturnAI["CPP"]
	end


	-- 보스 몬스터가 할 일이 끝났으면, 보스 몬스터의 버퍼를 nil 로 초기화 해준다
	EnemyBufferClear( Var, Handle )

	cAIScriptSet( Handle )

	return ReturnAI["CPP"]

end


function Routine_DropItem( Handle, MapIndex )
cExecCheck "Routine_DropItem"


	-- 함수 인자 확인
	if Handle == nil
	then
		ErrorLog( "Routine_DropItem::Handle == nil" )

		return ReturnAI["END"]
	end


	if MapIndex == nil
	then
		ErrorLog( "Routine_DropItem::MapIndex == nil" )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 필드 버퍼 확인
	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Routine_DropItem::Var == nil"..MapIndex )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 0.2초마다 확인하는 루틴
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	-- 보스 몬스터가 죽었는지 확인
	if cIsObjectDead( Handle ) == nil
	then
		return ReturnAI["CPP"]
	end


	-- 보스 몬스터의 버퍼가 있는지 확인
	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "Routine_DropItem::CurBossInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 보스 몬스터의 정보가 있는지 확인
	local CurBossInfo = Var["Enemy"][ Handle ]["Info"]
	if CurBossInfo == nil
	then
		ErrorLog( "Routine_DropItem::CurBossInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 아이템 드랍 정보가 있는지 확인
	local CurItemDeopList = CurBossInfo[ "ItemDropList" ]
	if CurItemDeopList == nil
	then
		ErrorLog( "Routine_DropItem::CurItemDeopList  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 드랍 확률 합
	local nMaxDropRate = 0
	for i = 1, #CurItemDeopList
	do
		nMaxDropRate = nMaxDropRate + CurItemDeopList[ i ]["DropRate"]
	end


	-- 드랍 확률
	local nCurDropRate = cRandomInt( 1, nMaxDropRate )
	for i = 1, #CurItemDeopList
	do
		nCurDropRate = nCurDropRate - CurItemDeopList[ i ]["DropRate"]


		-- 아이템 드랍
		if nCurDropRate <= 0
		then
			cDropItem( CurItemDeopList[ i ]["Index"], Handle, Handle, 1000000, true )
			break
		end
	end


	-- 보스 몬스터가 할 일이 끝났으면, 보스 몬스터의 버퍼를 nil 로 초기화 해준다
	EnemyBufferClear( Var, Handle )

	cAIScriptSet( Handle )

	return ReturnAI["CPP"]

end


function Routine_PortalRegen( Handle, MapIndex )
cExecCheck "Routine_PortalRegen"

	-- 함수 인자 확인
	if Handle == nil
	then
		ErrorLog( "Routine_PortalRegen::Handle == nil" )

		return ReturnAI["END"]
	end


	if MapIndex == nil
	then
		ErrorLog( "Routine_PortalRegen::MapIndex == nil" )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 필드 버퍼 확인
	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Routine_PortalRegen::Var == nil"..MapIndex )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 0.2초마다 확인하는 루틴
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	-- 보스 몬스터가 죽었는지 확인
	if cIsObjectDead( Handle ) == nil
	then
		return ReturnAI["CPP"]
	end


	-- 보스 몬스터의 버퍼가 있는지 확인
	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "Routine_PortalRegen::CurBossInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 보스 몬스터의 정보가 있는지 확인
	local CurBossInfo = Var["Enemy"][ Handle ]["Info"]
	if CurBossInfo == nil
	then
		ErrorLog( "Routine_PortalRegen::CurBossInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 확인 대상이 있을때, 대상도 죽었는지 확인
	if CurBossInfo["BossDeadCheck"] ~= nil
	then
		local DeadBossHandle = Var["Enemy"][ CurBossInfo["BossDeadCheck"] ]
		if DeadBossHandle ~= nil
		then
			if cIsObjectDead( DeadBossHandle ) == nil
			then
				return ReturnAI["CPP"]
			end
		end
	end


	-- 생성할 포탈 정보가 있는지 확인
	local CurRegenPortalName	= CurBossInfo["PortalName"]
	local CurRegenPortal 		= RegenInfo["Stuff"][ CurRegenPortalName ]
	if  CurRegenPortal == nil
	then
		ErrorLog( "Routine_PortalRegen::CurBossInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end


	-- 포탈이 생성되어 있는지 확인
	if Var["Portal"][ CurRegenPortalName ] == nil
	then
		-- 포탈 생성 / 포탈 정보 설정
		local nPortalHandle = cDoorBuild( Var["MapIndex"], CurRegenPortal["Index"], CurRegenPortal["x"], CurRegenPortal["y"], CurRegenPortal["dir"], CurRegenPortal["scale"] )
		if nPortalHandle == nil
		then
			ErrorLog( "Routine_PortalRegen::Portal was not created. : "..CurRegenPortalName )
		else
			if cSetAIScript ( MainLuaScriptPath, nPortalHandle ) == nil
			then
				ErrorLog( "Routine_PortalRegen::cSetAIScript ( MainLuaScriptPath, nPortalHandle ) == nil" )
			end

			if  cAIScriptFunc( nPortalHandle, "NPCClick", "Click_Portal" ) == nil
			then
				ErrorLog( "Routine_PortalRegen::cAIScriptFunc( nPortalHandle, \"NPCClick\", \"Click_Portal\" )" )
			end


			Var["Portal"][ nPortalHandle ]			= {}
			Var["Portal"][ nPortalHandle ]["Info"]	= PortalInfo[ CurRegenPortalName ]
			Var["Portal"][ nPortalHandle ]["Use"]	= false
			Var["Portal"][ CurRegenPortalName ]		= nPortalHandle
		end
	end


	-- 보스 몬스터가 할 일이 끝났으면, 보스 몬스터의 버퍼를 nil 로 초기화 해준다
	EnemyBufferClear( Var, Handle )

	cAIScriptSet( Handle )

	return ReturnAI["CPP"]
end


function Routine_Hayreddin( Handle, MapIndex )
cExecCheck "Routine_Hayreddin"

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


	-- 하이레딘 죽었는지 확인
	if cIsObjectDead( Handle ) ~= nil
	then
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 하이레딘 버퍼가 있는지 확인
	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "Routine_Hayreddin::CurBossInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 하이레딘 정보가 있는지 확인
	local CurBossInfo = Var["Enemy"][ Handle ]["Info"]
	if CurBossInfo == nil
	then
		ErrorLog( "Routine_Hayreddin::CurBossInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 하이레딘 페이즈 번호 확인
	local PhaseNumber = Var["Enemy"][ Handle ]["Phase"]
	if PhaseNumber == nil
	then
		ErrorLog( "Routine_Hayreddin::PhaseNumber  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 하이레딘 페이즈 정보 확인
	local PhaseInfo = CurBossInfo["Phase"]
	if PhaseInfo == nil
	then
		ErrorLog( "Routine_Hayreddin::PhaseInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 하이레딘 진행된 페이즈 번호 확인
	if PhaseNumber < 0 or PhaseNumber > #PhaseInfo
	then
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
		-- 하이레딘 HP 정보
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


	-- 위치 조건 확인
	if CurPhaseInfo["Condition_Locate"] ~= nil
	then
		-- 하이레딘 위치 정보
		local Loc_x, Loc_y = cObjectLocate( Handle )
		if Loc_x == nil or Loc_y == nil
		then
			ErrorLog( "Routine_Hayreddin::Loc_x == nil or Loc_y == nil" )
			return ReturnAI["CPP"]
		end

		local DistSquar = cDistanceSquar( Loc_x, Loc_y, CurPhaseInfo["Condition_Locate"]["x"], CurPhaseInfo["Condition_Locate"]["y"] )
		if DistSquar > 10 * 10
		then
			return ReturnAI["END"]
		end
	end


	-- 하이레딘 도주
	if CurPhaseInfo["RunTo"] ~= nil
	then
		cRunTo( Handle, CurPhaseInfo["RunTo"]["x"], CurPhaseInfo["RunTo"]["y"], 1000 )
	end

	-- 다이얼 로그 출력
	if CurPhaseInfo["DialogInfo"] ~= nil
	then
		cMobDialog( Var["MapIndex"], CurPhaseInfo["DialogInfo"]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurPhaseInfo["DialogInfo"]["Index"] )
	end

	-- 문 열기
	if CurPhaseInfo["DoorOpen"] ~= nil
	then
		local nCurDoorHandle = Var["Door"][ CurPhaseInfo["DoorOpen"] ]
		if nCurDoorHandle ~= nil
		then
			if Var["Door"][ nCurDoorHandle ] ~= nil
			then
				cDoorAction( nCurDoorHandle, Var["Door"][ nCurDoorHandle ]["Info"]["Block"], "open" )
				Var["Door"][ nCurDoorHandle ]["IsOpen"] = true
			end
		end
	end

	-- 하이레딘 삭제
	if CurPhaseInfo["BossVanish"] == true
	then
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 다음 페이즈 설정
	Var["Enemy"][ Handle ]["Phase"] = PhaseNumber + 1

	return ReturnAI["END"]
end


function Routine_Freloan( Handle, MapIndex )
cExecCheck "Routine_Freloan"

	-- 함수 인자 확인
	if Handle == nil
	then
		ErrorLog( "Routine_Freloan::Handle == nil" )

		return ReturnAI["END"]
	end


	if MapIndex == nil
	then
		ErrorLog( "Routine_Freloan::MapIndex == nil" )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 현재 시간
	local CurSec = cCurrentSecond()
	if CurSec == nil
	then
		ErrorLog( "Routine_Freloan::Var == nil" )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 필드 버퍼 확인
	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Routine_Freloan::Var == nil" )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 프렐로안 죽었는지 확인
	if cIsObjectDead( Handle ) ~= nil
	then
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 프렐로안 버퍼가 있는지 확인
	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "Routine_Freloan::CurBossInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 프렐로안 정보가 있는지 확인
	local CurBossInfo = Var["Enemy"][ Handle ]["Info"]
	if CurBossInfo == nil
	then
		ErrorLog( "Routine_Hayreddin::CurBossInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 프렐로안 페이즈 번호 확인
	local PhaseNumber = Var["Enemy"][ Handle ]["Phase"]
	if PhaseNumber == nil
	then
		ErrorLog( "Routine_Freloan::PhaseNumber  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 프렐로안 페이즈 정보 확인
	local PhaseInfo = CurBossInfo["Phase"]
	if PhaseInfo == nil
	then
		ErrorLog( "Routine_Freloan::PhaseInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 프렐로안 진행된 페이즈 번호 확인
	if PhaseNumber < 0 or PhaseNumber > #PhaseInfo
	then
		return ReturnAI["END"]
	end


	-- 0.2초마다 체크하는 루틴
	if Var["RoutineTime"][ Handle ] <= CurSec
	then
		Var["RoutineTime"][ Handle ] = CurSec + 0.2
	else
		return ReturnAI["CPP"]
	end


	-- 현재 페이즈 정보 확인
	local CurPhaseInfo = PhaseInfo[ PhaseNumber ]
	if CurPhaseInfo == nil
	then
		ErrorLog( "Routine_Freloan::CurPhaseInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["CPP"]
	end


	-- 프렐로안 HP 정보
	local nCurHP, nMaxHP = cObjectHP( Handle )
	if nCurHP == nil or nMaxHP == nil
	then
		ErrorLog( "Routine_Freloan::nCurHP == nil or nMaxHP == nil" )
		return ReturnAI["CPP"]
	end


	local nCurHPRate = nCurHP / nMaxHP * 100


	-- 어그로가 풀렸을 경우
	if cAggroListSize( Handle ) == 0
	then
		if PhaseNumber == 1
		then
			return ReturnAI["CPP"]
		end

		-- HP 조건 확인
		if nCurHPRate > CurPhaseInfo["Condition_HPRate"]
		then
			Var["Enemy"][ Handle ]["Phase"] = PhaseNumber - 1

			-- 어그로 풀리면 페이즈 스킬 사용 정보 초기화
			Var["Enemy"][ Handle ]["UseSkillSec"]	= nil
			Var["Enemy"][ Handle ]["SummonChief"]	= nil
			Var["Enemy"][ Handle ]["SummonSec"]		= nil
		end

		return ReturnAI["CPP"]
	end


	-- 스킬 사용
	if CurPhaseInfo["UseSkill"] ~= nil
	then
		if Var["Enemy"][ Handle ]["UseSkillSec"] == nil
		then
			Var["Enemy"][ Handle ]["UseSkillSec"] = CurSec
		end

		-- 스킬 사용 시간 확인
		if Var["Enemy"][ Handle ]["UseSkillSec"] <= CurSec
		then
			if cSkillBlast( Handle, Handle, CurPhaseInfo["UseSkill"]["Index"] ) == 1
			then
				Var["Enemy"][ Handle ]["UseSkillSec"] = CurSec + CurPhaseInfo["UseSkill"]["Interval"]
			end
		end
	end


	-- 치프 소환
	if CurPhaseInfo["Summon_Chief"] ~= nil
	then
		local SummonChiefInfo = Var["Enemy"][ Handle ]["SummonChief"]
		if SummonChiefInfo == nil
		then
			Var["Enemy"][ Handle ]["SummonChief"] = {}

			SummonChiefInfo					= Var["Enemy"][ Handle ]["SummonChief"]
			SummonChiefInfo["SummonStep"]	= 1
			SummonChiefInfo["SummonList"]	= {}


			-- 소환 순서 만들기
			local TmpList 	= {}
			local SummonMax	= #CurPhaseInfo["Summon_Chief"]

			for i = 1, SummonMax
			do
				TmpList[ i ] = i
			end

			for i = SummonMax, 1, -1
			do
				local Index 						= cRandomInt( 1, i )
				SummonChiefInfo["SummonList"][ i ]	= TmpList[ Index ]

				for j = Index, (SummonMax - 1)
				do
					TmpList[ j ] 		= TmpList[ j + 1 ]
					TmpList[ j + 1 ]	= nil
				end
			end
		end

		-- 치프 소환할지 확인
		local NextBossSummon = false
		if SummonChiefInfo["Handle"] == nil
		then
			NextBossSummon = true
		else
			-- 소환된 치프가 죽으면 다음 치프 소환
			if cIsObjectDead( SummonChiefInfo["Handle"] ) == 1
			then
				SummonChiefInfo["Handle"]	= nil
				NextBossSummon 				= true
			end
		end

		-- 치프를 모두 소환 했는지 확인
		if SummonChiefInfo["SummonStep"] > #SummonChiefInfo["SummonList"]
		then
			NextBossSummon = false
		end


		-- 치프 소환
		if NextBossSummon == true
		then
			if cSkillBlast( Handle, Handle, CurPhaseInfo["Summon_Chief"]["SkillIndex"] ) == 1
			then
				local SummonIndex = SummonChiefInfo["SummonList"][ SummonChiefInfo["SummonStep"] ]
				if SummonIndex <= #CurPhaseInfo["Summon_Chief"]
				then
					local CurRegenChief = CurPhaseInfo["Summon_Chief"][ SummonIndex ]

					SummonChiefInfo["Handle"]		= cMobRegen_XY( Var["MapIndex"], CurRegenChief["Index"], CurRegenChief["x"], CurRegenChief["y"], CurRegenChief["dir"] )
					SummonChiefInfo["SummonStep"]	= SummonChiefInfo["SummonStep"] + 1

					cRunTo( SummonChiefInfo["Handle"], CurRegenChief["RunTo"]["x"], CurRegenChief["RunTo"]["y"], 1000 )
				end
			end
		end
	end


	-- 다리 소환
	if CurPhaseInfo["Summon_Leg"] ~= nil
	then
		if Var["Enemy"][ Handle ]["SummonSec"] == nil
		then
			Var["Enemy"][ Handle ]["SummonSec"] = CurSec
		end


		-- 소환 시간 확인
		if Var["Enemy"][ Handle ]["SummonSec"] <= CurSec
		then
			local TargetHandle = cTargetHandle( Handle )
			if TargetHandle ~= nil
			then
				if cSkillBlast( Handle, TargetHandle, CurPhaseInfo["Summon_Leg"]["SkillIndex"] ) == 1
				then
					for i = 1, #CurPhaseInfo["Summon_Leg"]
					do
						local CurRegenLeg = CurPhaseInfo["Summon_Leg"][ i ]
						cMobRegen_XY( Var["MapIndex"], CurRegenLeg["Index"], CurRegenLeg["x"], CurRegenLeg["y"], CurRegenLeg["dir"] )
					end

					Var["Enemy"][ Handle ]["SummonSec"] = CurSec + CurPhaseInfo["Summon_Leg"]["Interval"]
				end
			end
		end
	end


	-- 다음 단계 번호 설정
	local NextPhaseNumber = PhaseNumber + 1
	if NextPhaseNumber < 0 or NextPhaseNumber > #PhaseInfo
	then
		return ReturnAI["CPP"]
	end


	-- 다음 단계 정보 확인
	local NextPhaseInfo = PhaseInfo[ NextPhaseNumber ]
	if NextPhaseInfo == nil
	then
		ErrorLog( "Routine_Freloan::NextPhaseInfo  == nil" )
		EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["CPP"]
	end


	-- HP 조건 확인
	if nCurHPRate > NextPhaseInfo["Condition_HPRate"]
	then
		return ReturnAI["CPP"]
	end


	-- 다음 페이즈 설정
	Var["Enemy"][ Handle ]["Phase"]			= NextPhaseNumber
	Var["Enemy"][ Handle ]["UseSkillSec"]	= nil
	Var["Enemy"][ Handle ]["SummonChief"]	= nil
	Var["Enemy"][ Handle ]["SummonSec"]		= nil

	return ReturnAI["END"]
end

--------------------------------------------------------------------------------
-- Click Function
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


function Click_Portal( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "Click_Portal"

	DebugLog( "Click_Portal::Start" )

	if NPCHandle == nil
	then
		ErrorLog( "Click_Portal::NPCHandle == nil" )
		return
	end

	if PlyHandle == nil
	then
		ErrorLog( "Click_Portal::PlyHandle == nil" )
		return
	end


	local MapIndex = cGetCurMapIndex( NPCHandle )

	if MapIndex == nil
	then
		ErrorLog( "Click_Portal::MapIndex == nil" )
		return
	end


	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		ErrorLog( "Click_Portal::Var == nil" )
		return
	end

	if Var["Portal"] == nil
	then
		ErrorLog( "Click_Portal::Var[\"Portal\"] == nil" )
		return
	end

	if Var["Portal"][ NPCHandle ] == nil
	then
		ErrorLog( "Click_Portal::Var[\"Portal\"][NPCHandle] == nil" )
		return
	end


	local CurPortalInfo = Var["Portal"][ NPCHandle ]["Info"]
	if CurPortalInfo == nil
	then
		ErrorLog( "Click_Portal::Var[\"Portal\"][NPCHandle] == nil" )
		return
	end



	--  설정된 위치로 이동
	cCastTeleport( PlyHandle, "SpecificCoord", CurPortalInfo["x"], CurPortalInfo["y"] );


	Var["Portal"][ NPCHandle ]["Use"] = true


	DebugLog( "Click_Portal::End" )
end


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
-- Menu Function
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


	-- 열쇠 파괴, 문 열기
	if cInvenItemDestroy( PlyHandle, Var["Door"][ NPCHandle ]["Info"]["NeedItem"], -1 ) ~= 1
	then
		return
	end

	cDoorAction( NPCHandle, Var["Door"][ NPCHandle ]["Info"]["Block"], "open" )

	Var["Door"][ NPCHandle ]["IsOpen"] = true

	DebugLog( "Menu_Door::End" )
end
