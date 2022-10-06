--------------------------------------------------------------------------------
--                        Tower Of Iyzel Routine                              --
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

	if Var["EachFloor"] == nil
	then
		ErrorLog( "BossDamaged::Var[\"EachFloor\"] == nil" )
		return
	end


	-- 시전중에 대한 정보를 저장하고 공유하기 위함
	if Var["EachFloor"]["Casting"] == nil
	then
		Var["EachFloor"]["Casting"] = {}
	end


	local HP_Rate = ( CurHP * 1000 ) / MaxHP


	-- 스킬별로 한번 씩 탐색
	for nIndex, sSkillName in pairs ( BossSkillNameTable )
	do
		-- 없을경우 스킬페이즈순번 초기화
		if Var["EachFloor"][ sSkillName.."PhaseNo"] == nil
		then
			Var["EachFloor"][ sSkillName.."PhaseNo"] = 1
		end

		-- 실제 스킬 시전을 위한 테이블이 없을경우 생성
		if Var["EachFloor"][ sSkillName ] == nil
		then
			Var["EachFloor"][ sSkillName ] = {}
		end


		-- 단계이름 받아오기
		local CurFloorNo = Var["EachFloor"]["StepNumber"]
		local CurFloor = StepNameTable[ CurFloorNo ]

		-- 스킬 페이즈 순번
		local sThresholdTableIndex = sSkillName.."HP_"..CurFloor -- ex ) "SummonHP_Floor04
		local nCurPhase = Var["EachFloor"][ sSkillName.."PhaseNo"]
		local nMaxPhase = #ThresholdTable[ sThresholdTableIndex ]

		if nCurPhase <= nMaxPhase
		then
			-- 현재 HP와 스킬의 Threshold 와 비교하여 순차적으로 소급 적용하여 시전
			while ThresholdTable[ sThresholdTableIndex ][ nCurPhase ] >= HP_Rate
			do
				-- 시전할 스킬의 테이블 내 인덱스 받아오기
				local sCurSkillIndex = "HP"..ThresholdTable[ sThresholdTableIndex ][ nCurPhase ] -- ex) "HP800"
				local sBossSkillTableIndex = sSkillName.."_"..CurFloor -- ex) "Summon_Floor04"

				if BossSkill[ sBossSkillTableIndex ][ sCurSkillIndex ] ~= nil
				then
					-- 스킬을 루틴에서 시전하도록 설정
					if Var["EachFloor"][ sSkillName ][ nCurPhase ] == nil
					then
						Var["EachFloor"][ sSkillName ][ nCurPhase ] = {}
						Var["EachFloor"][ sSkillName ][ nCurPhase ]["bCasting"] = true
						Var["EachFloor"][ sSkillName ][ nCurPhase ]["sSkillTableIndex"] = sCurSkillIndex
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
			Var["EachFloor"][ sSkillName.."PhaseNo"] = nCurPhase

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


	-- Boss 사망
	if cIsObjectDead( Handle ) == 1
	then
		DebugLog( "BossRoutine::BossDead" )
		cMobSuicide( Var["MapIndex"] )

		-- 스킬관련 메모리 초기화
		for nIndex, sSkillName in pairs ( BossSkillNameTable )
		do
			Var["EachFloor"][ sSkillName ] = nil
			Var["EachFloor"][ sSkillName.."PhaseNo"] = nil
		end

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	if Var["EachFloor"] == nil
	then
		ErrorLog( "BossRoutine::Var[\"EachFloor\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- MobDamaged 루틴 등록
	cAIScriptFunc( Handle, "MobDamaged", "BossDamaged" )


	-- 스킬별로 한번 씩 탐색
	for nIndex, sSkillName in pairs ( BossSkillNameTable )
	do
		-- 다음 스킬 순번과 해당 스킬 시전테이블이 없다면 아직 시전도 안된 것이므로 패스
		if Var["EachFloor"][ sSkillName.."PhaseNo"] ~= nil and Var["EachFloor"][ sSkillName ] ~= nil
		then
			-- 시전승인된 스킬들만 순서대로 시전해야함.
			for i = 1, #Var["EachFloor"][ sSkillName ]
			do
				-- 에러체크
				if Var["EachFloor"][ sSkillName ][ i ] == nil
				then
					break
				end

				-- 준비된 스킬 시전
				if Var["EachFloor"][ sSkillName ][ i ]["bCasting"] == true
				then
					local sCurSkillTableIndex = Var["EachFloor"][ sSkillName ][ i ]["sSkillTableIndex"] -- ex) "HP800"

					-- 단계이름 받아오기
					local CurFloorNo = Var["EachFloor"]["StepNumber"]
					local CurFloor = StepNameTable[ CurFloorNo ]

					-- 스킬 테이블 인덱스 설정
					local sBossSkillTableIndex = sSkillName.."_"..CurFloor -- ex) "Summon_Floor04"

					-- 스킬 정보 가져오기
					local CurSkillInfo = BossSkill[ sBossSkillTableIndex ][ sCurSkillTableIndex ]

					-- 잔몹 소환
					if sSkillName == "Summon"
					then
						DebugLog( "BossRoutine::StartSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )

						for i = 1, #CurSkillInfo["SummonMobs"]
						do
							cMobRegen_Obj( CurSkillInfo["SummonMobs"][ i ], Handle )
							DebugLog( "BossRoutine::CastSkill-"..sSkillName.." "..sCurSkillTableIndex.." ("..i.."/"..#CurSkillInfo["SummonMobs"]..") :"..CurSkillInfo["SummonMobs"][ i ] )
						end

						-- 경비병이 보스의 소환 스킬을 경고해주는 페이스컷
						if NPC_GuardChat["BossBattleDialog"][ CurFloor ] ~= nil
						then
							cMobDialog( Var["MapIndex"], NPC_GuardChat["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["BossBattleDialog"][ CurFloor ][ i ]["Index"] )
						else
							ErrorLog( "BossRoutine::There is no face-cut at This Floor" )
						end
						-- 시전 완료 처리
						Var["EachFloor"][ sSkillName ][ i ]["bCasting"] = false
						DebugLog( "BossRoutine::EndSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )

					end -- 스킬 이름 관련 조건문 //

				end -- 스킬 시전이 준비 되었는지 확인하는 조건문 //

			end -- 한 스킬에 대한 순차적 시전 루프 //

		end -- 스킬 시전 자체를 했는가 확인하는 조건문 //

	end -- 각 스킬을 한번씩 탐색하는 루프 //

	return ReturnAI["CPP"]

end
