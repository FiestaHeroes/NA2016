--------------------------------------------------------------------------------
--                     Secret Laboratory Routine                              --
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


function PrisonClick( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "PrisonClick"

	DebugLog( "PrisonClick::Start" )

	if NPCHandle == nil
	then
		ErrorLog( "PrisonClick::NPCHandle == nil" )
		return
	end

	if PlyHandle == nil
	then
		ErrorLog( "PrisonClick::PlyHandle == nil" )
		return
	end


	local MapIndex = cGetCurMapIndex( PlyHandle )

	if MapIndex == nil
	then
		ErrorLog( "PrisonClick::MapIndex == nil" )
		return
	end


	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		ErrorLog( "PrisonClick::Var == nil" )
		return
	end

	if Var["Prison"] == nil
	then
		ErrorLog( "PrisonClick::Var[\"Prison\"] == nil" )
		return
	end

	if Var["Prison"]["RegenInfo"] == nil
	then
		ErrorLog( "PrisonClick::Var[\"Prison\"][\"RegenInfo\"] == nil" )
		return
	end


	-- 해당 열쇠가 있을 때만 감옥을 열고 열쇠를 사라지게 함
	local nLotKey = cGetItemLot( PlyHandle, PrisonKeyIndex )
	if nLotKey > 0
	then
		if cInvenItemDestroy( PlyHandle, PrisonKeyIndex, nLotKey ) ~= 1
		then
			return
		end

		cDoorAction( NPCHandle, Var["Prison"]["RegenInfo"]["Block"], "open" )
		Var["Prison"]["bOpened"] = true
	end


	DebugLog( "PrisonClick::End" )
end


function SemiBossRoutine( Handle, MapIndex )
cExecCheck "SemiBossRoutine"

	if Handle == nil
	then
		ErrorLog( "SemiBossRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "SemiBossRoutine::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "SemiBossRoutine::Var == nil" )
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
		ErrorLog( "SemiBossRoutine::Var[\"Enemy\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "SemiBossRoutine::Var[\"Enemy\"]["..Handle.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- SemiBoss 사망
	if cIsObjectDead( Handle ) == 1
	then
		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

	-- 아래 파트는 이 몹이 살이있을 경우임.

	if Var["EachFloor"] == nil
	then
		ErrorLog( "SemiBossRoutine::Var[\"EachFloor\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

	local CurStepNo = Var["EachFloor"]["StepNumber"]

	if Var["EachFloor"..CurStepNo ] == nil
	then
		ErrorLog( "SemiBossRoutine::Var[\"EachFloor\""..CurStepNo.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	local sAbstateIndex
	if Var["Enemy"][ Handle ]["Index"] == "Lab_Slime"
	then
		sAbstateIndex = SemiBossAbstate["TimeAttackMini"]["Index"]
	else
		sAbstateIndex = SemiBossAbstate["TimeAttack"]["Index"]
	end

	local AbstateStrength, AbstateRestTime = cGetAbstate( Handle, sAbstateIndex )
	if AbstateStrength == nil or AbstateStrength == 0 or AbstateRestTime == nil or AbstateRestTime == 0
	then
		-- 안걸려있는 상태 : 깨어난 상태 혹은 죽음이 예약된 상태
		if cIsObjectDead( Handle ) == nil
		then
			-- 이 상황에서 무적이 걸렸다는 것은 죽음이 예약되었다는 얘기
			local ImmortalStrength, ImmortalRestTime = cGetAbstate( Handle, SemiBossAbstate["Immortal"]["Index"] )
			if ImmortalStrength == 1
			then
				cMobSuicide( Var["MapIndex"], Handle )
				cAIScriptSet( Handle )
				Var["Enemy"][ Handle ] = nil
				return ReturnAI["END"]
			else
			-- 무적이 안걸렸다면 깨어난 상태를 얘기함.
				Var["EachFloor"..CurStepNo ]["bSemiBossAwakened"] = true

				--한마리라도 깨어나면 특별 보상을 받을 수 없다.
				Var["bSpecialRewardMode"] = false
			end
		end

		-- 중간 경고를 모두 해제한다.( 깨어났으므로.. )
		Var["EachFloor"..CurStepNo ]["bSemiBossWarned60Sec"] = true
		Var["EachFloor"..CurStepNo ]["bSemiBossWarned30Sec"] = true
	elseif AbstateStrength == 2
	then
		-- 한대 맞은 상태 : 중간 경고를 모두 해제한다.( 남은 시간이 달라지고 몇초안에 폭발하므로.. )
		Var["EachFloor"..CurStepNo ]["bSemiBossWarned60Sec"] = true
		Var["EachFloor"..CurStepNo ]["bSemiBossWarned30Sec"] = true
	end

	-- 상태이상이 걸려있는 상태에서 주변몹들이 다 죽으면 이 몹도 죽는다.(다음루틴에서 몹은 자살처리됨)
	if AbstateStrength == 1 or AbstateStrength == 2
	then
		-- 다른 몹들이 젠 되는 시간을 기다렸다가 체크
		if Var["CurSec"] >= Var["EachFloor"..CurStepNo ]["WaitMobGenSec"]
		then
			if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) == 1
			then
				cSetAbstate( Handle, SemiBossAbstate["Immortal"]["Index"], SemiBossAbstate["Immortal"]["Strength"], SemiBossAbstate["Immortal"]["KeepTime"] )
				cResetAbstate( Handle, sAbstateIndex )

				-- 중간 경고를 모두 해제한다.( 죽을것이므로.. )
				Var["EachFloor"..CurStepNo ]["bSemiBossWarned60Sec"] = true
				Var["EachFloor"..CurStepNo ]["bSemiBossWarned30Sec"] = true
			end
		end
	end

	return ReturnAI["CPP"]
end


function MidBossRoutine( Handle, MapIndex )
cExecCheck "MidBossRoutine"

	if Handle == nil
	then
		ErrorLog( "MidBossRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "MidBossRoutine::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "MidBossRoutine::Var == nil" )
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
		ErrorLog( "MidBossRoutine::Var[\"Enemy\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "MidBossRoutine::Var[\"Enemy\"]["..Handle.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- Mid Boss 사망
	if cIsObjectDead( Handle ) == 1
	then
		-- 잔몹 모두 자살
		cMobSuicide( Var["MapIndex"] )

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	if Var["EachFloor"] == nil
	then
		ErrorLog( "MidBossRoutine::Var[\"EachFloor\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
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


	-- 시전중에 대한 정보를 저장하고 공유하기 위함
	if Var["BossBattle"]["Casting"] == nil
	then
		Var["BossBattle"]["Casting"] = {}
	end


	local HP_Rate = ( CurHP * 1000 ) / MaxHP

	local nBossType = Var["StageInfo"]["BossTypeNo"]

	-- 스킬별로 한번 씩 탐색
	for nIndex, sSkillName in pairs ( BossSkillNameTable )
	do
		-- 없을경우 스킬페이즈순번 초기화
		if Var["BossBattle"][ sSkillName.."PhaseNo"] == nil
		then
			Var["BossBattle"][ sSkillName.."PhaseNo"] = 1
		end

		-- 실제 스킬 시전을 위한 테이블이 없을경우 생성
		if Var["BossBattle"][ sSkillName ] == nil
		then
			Var["BossBattle"][ sSkillName ] = {}
		end


		-- 스킬 페이즈 순번
		local sThresholdTableIndex = sSkillName.."HP_Boss"..nBossType -- ex ) "SummonHP_Boss1"
		local nCurPhase = Var["BossBattle"][ sSkillName.."PhaseNo"]
		local nMaxPhase = #ThresholdTable[ sThresholdTableIndex ]

		if sSkillName ~= "PeriodicSummon"
		then
			if nCurPhase <= nMaxPhase
			then
				-- 현재 HP와 스킬의 Threshold 와 비교하여 순차적으로 소급 적용하여 시전
				while ThresholdTable[ sThresholdTableIndex ][ nCurPhase ] >= HP_Rate
				do
					-- 시전할 스킬의 테이블 내 인덱스 받아오기
					local sCurSkillIndex = "HP"..ThresholdTable[ sThresholdTableIndex ][ nCurPhase ] -- ex) "HP800"
					local sBossSkillTableIndex = sThresholdTableIndex -- 동일하게 설정함

					if BossSkill[ sBossSkillTableIndex ][ sCurSkillIndex ] ~= nil
					then
						-- 스킬을 루틴에서 시전하도록 설정
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

				end -- 스킬을 시전하라고 순서대로 셋팅해주는 루프

				-- 메모리의 스킬 페이즈 순번 값 갱신
				Var["BossBattle"][ sSkillName.."PhaseNo"] = nCurPhase

			end -- 각 스킬의 순번이 초과했는지 확인해주는 조건문 //

		end -- 주기적인 스킬 체크는 루틴에서 함 //

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

	if Var["StageInfo"]["BossTypeNo"] == nil
	then
		ErrorLog( "BossRoutine::Var[\"StageInfo\"][\"BossTypeNo\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

	if Var["BossBattle"] == nil
	then
		ErrorLog( "BossRoutine::Var[\"BossBattle\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

	if Var["EachFloor"] == nil
	then
		ErrorLog( "BossRoutine::Var[\"EachFloor\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

	if Var["EachFloor"..Var["EachFloor"]["StepNumber"] ] == nil
	then
		ErrorLog( "BossRoutine::Var[ EachFloor"..Var["EachFloor"]["StepNumber"].."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	-- Boss 사망
	if cIsObjectDead( Handle ) ~= nil
	then
		DebugLog( "BossRoutine::BossDead" )
		cMobSuicide( Var["MapIndex"] )

		-- 스킬관련 메모리 초기화
		for nIndex, sSkillName in pairs ( BossSkillNameTable )
		do
			Var["BossBattle"][ sSkillName ] = nil
			Var["BossBattle"][ sSkillName.."PhaseNo"] = nil
		end

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

	local CurStepNo = Var["EachFloor"]["StepNumber"]
	local nBossType = Var["StageInfo"]["BossTypeNo"]

--///////---------------------- 주기적 시전을 셋팅하기 위한 루틴 속 체크 ------------------------------------

	-- 시전중에 대한 정보를 저장하고 공유하기 위함
	if Var["BossBattle"]["Casting"] == nil
	then
		Var["BossBattle"]["Casting"] = {}
	end

	local CurHP, MaxHP = cObjectHP( Handle )

	-- HP 불러오기 실패시 Full로 간주
	local HP_Rate = 1000
	if CurHP ~= nil
	then
		if MaxHP > 0
		then
			HP_Rate = ( CurHP * 1000 ) / MaxHP
		end
	end

	if #BossSkillNameTable >= 2
	then
		-- 주기적 소환 스킬만 탐색
		local sSkillName = BossSkillNameTable[2]	-- ex) sSkillName = "PeriodicSummon"

		-- 없을경우 스킬페이즈순번 초기화
		if Var["BossBattle"][ sSkillName.."PhaseNo"] == nil
		then
			Var["BossBattle"][ sSkillName.."PhaseNo"] = 1
		end

		-- 실제 스킬 시전을 위한 테이블이 없을경우 생성
		if Var["BossBattle"][ sSkillName ] == nil
		then
			Var["BossBattle"][ sSkillName ] = {}
		end


		-- 스킬 페이즈 순번
		local sThresholdTableIndex = sSkillName.."HP_Boss"..nBossType -- ex ) "PeriodicSummonHP_Boss1"

		-- 이 주기적인 스킬은 규칙이 다음과 같다
		-- HP가 일정 이하일 때 발동
		-- 연이어 스킬이 HP 에 따라 발동이 된다면 한가지만 발동
		-- HP가 해당 스킬이 발동되는 범위를 벗어나면 무조건 그 스킬은 초기화
		-- 초기화 된 상태는 처음과 같아서 다시 HP가 스킬발동에 해당되는 상황이면 그대로 발동
		--
		for nCurPhase = 1, #ThresholdTable[ sThresholdTableIndex ]
		do
			-- 스킬 시전 각 페이즈 테이블
			if Var["BossBattle"][ sSkillName ][ nCurPhase ] == nil
			then
				Var["BossBattle"][ sSkillName ][ nCurPhase ] = {}
			end

			local CurPhaseCastingInfo = Var["BossBattle"][ sSkillName ][ nCurPhase ]

			-- 현재 HP와 스킬의 Threshold 와 비교하여 해당되는 부분 시전 요청

			local bCastCurPhaseSkill = false

			-- HP 범위 체크
			if ThresholdTable[ sThresholdTableIndex ][ nCurPhase ] >= HP_Rate
			then
				if ThresholdTable[ sThresholdTableIndex ][ nCurPhase + 1 ] ~= nil
				then
					if ThresholdTable[ sThresholdTableIndex ][ nCurPhase + 1 ] < HP_Rate
					then
						bCastCurPhaseSkill = true
					else
						-- HP 범위가 해당 페이즈를 벗어나면 시전 주기는 초기화 된다.
						CurPhaseCastingInfo["dLastCastedTime"] = 0

						-- 소환 관련 페이스컷이 끝난 상황인 경우에만 초기화해줌
						if Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] == true
						then
							Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] = nil
							Var["EachFloor"..CurStepNo ]["nHP_BossSummonDialog"] = nil
						end
					end
				else
					bCastCurPhaseSkill = true
				end
			else
				-- HP 범위가 해당 페이즈를 벗어나면 시전 주기는 초기화 된다.
				CurPhaseCastingInfo["dLastCastedTime"] = 0

				-- 소환 관련 페이스컷이 끝난 상황인 경우에만 초기화해줌
				if Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] == true
				then
					Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] = nil
					Var["EachFloor"..CurStepNo ]["nHP_BossSummonDialog"] = nil
				end
			end

			-- 시전할 스킬의 테이블 내 인덱스 받아오기
			local sBossSkillTableIndex = sThresholdTableIndex -- 동일하게 설정함 ex ) "SummonHP_Boss1"
			local sCurSkillIndex = "HP"..ThresholdTable[ sThresholdTableIndex ][ nCurPhase ] -- ex) "HP800"


			-- HP 범위 체크 결과 스킬을 쓸 타이밍일 경우
			if bCastCurPhaseSkill == true
			then

				if CurPhaseCastingInfo["dLastCastedTime"] == nil
				then
					CurPhaseCastingInfo["dLastCastedTime"] = 0
				end

				if BossSkill[ sBossSkillTableIndex ] ~= nil
				then
					local CurBossSkillInfo = BossSkill[ sBossSkillTableIndex ][ sCurSkillIndex ]

					if CurPhaseCastingInfo["nSummonCount"] == nil
					then
						CurPhaseCastingInfo["nSummonCount"] = 0
					end

					if CurBossSkillInfo ~= nil and CurBossSkillInfo["SummonMobs"] ~= nil
					then
						for nCurSubPhase = 1, #CurBossSkillInfo["SummonMobs"]
						do
							if CurBossSkillInfo["SummonMobs"][ nCurSubPhase ] ~= nil
							then
								local CurSubPhaseInfo = CurBossSkillInfo["SummonMobs"][ nCurSubPhase ]

								-- 총 소환 횟수가 0으로 설정되어있으면 무제한 소환 / 0이 아니라면 해당 횟수만큼 소환
								if CurPhaseCastingInfo["nSummonCount"] < CurSubPhaseInfo["SummonCount"] or CurSubPhaseInfo["SummonCount"] == 0
								then
									if Var["CurSec"] >= CurPhaseCastingInfo["dLastCastedTime"] + CurSubPhaseInfo["Interval"]
									then
										if CurPhaseCastingInfo["bCasting"] ~= true
										then
											-- 스킬을 루틴에서 시전하도록 설정
											CurPhaseCastingInfo["bCasting"] = true
											CurPhaseCastingInfo["sSkillTableIndex"] = sCurSkillIndex
											DebugLog( "BossRoutine::SetSkillCasting-"..sSkillName.." "..sCurSkillIndex.." "..nCurPhase )
										end
									end
								end
							end
						end
					else
						ErrorLog( "BossRoutine::CurBossSkillInfo does not exist.")
					end
				else
					ErrorLog( "BossRoutine::BossSkillInfo does not exist.")
				end

			end

		end

	end

---------------------- 주기적 시전을 셋팅하기 위한 루틴 속 체크 ------------------------------------/////


-------------시전단계---------------------------------------------------------

	-- 이전 소환스킬 관련 페이스컷이 안끝났다면 끝날때까지 기다린다.
	if Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] ~= false -- true or nil 일때 진행
	then
		-- 스킬별로 한번 씩 탐색
		for nIndex, sSkillName in pairs ( BossSkillNameTable )
		do
			-- 스킬 페이즈 순번
			local sThresholdTableIndex = sSkillName.."HP_Boss"..nBossType -- ex ) "PeriodicSummonHP_Boss1"

			-- 다음 스킬 순번과 해당 스킬 시전테이블이 없다면 아직 시전도 안된 것이므로 패스
			if Var["BossBattle"][ sSkillName.."PhaseNo"] ~= nil and Var["BossBattle"][ sSkillName ] ~= nil
			then
				-- 시전승인된 스킬들만 순서대로 시전해야함.
				for nCurPhase = 1, #Var["BossBattle"][ sSkillName ]
				do
					-- 에러체크
					if Var["BossBattle"][ sSkillName ][ nCurPhase ] == nil
					then
						break
					end

					local CurPhaseCastingInfo = Var["BossBattle"][ sSkillName ][ nCurPhase ]

					-- 준비된 스킬 시전
					if CurPhaseCastingInfo["bCasting"] == true
					then
						local sCurSkillTableIndex = CurPhaseCastingInfo["sSkillTableIndex"] -- ex) "HP800"

						local sBossSkillTableIndex = sSkillName.."HP_Boss"..nBossType -- ex ) "SummonHP_Boss1"
						local CurSkillInfo = BossSkill[ sBossSkillTableIndex ][ sCurSkillTableIndex ]

						-- 잔몹 소환
						if sSkillName == "Summon"
						then
							DebugLog( "BossRoutine::StartSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..nCurPhase )

							for nCurSubPhase = 1, #CurSkillInfo["SummonMobs"]
							do
								for k = 1, CurSkillInfo["SummonMobs"][ nCurSubPhase ]["Count"]
								do
									cMobRegen_Obj( CurSkillInfo["SummonMobs"][ nCurSubPhase ]["Index"], Handle )
									DebugLog( "BossRoutine::CastSkill-"..sSkillName.." "..sCurSkillTableIndex.." ("..k.."/"..CurSkillInfo["SummonMobs"][ nCurSubPhase ]["Count"]..") :"..CurSkillInfo["SummonMobs"][ nCurSubPhase ]["Index"] )
								end
							end

						elseif sSkillName == "PeriodicSummon"
						then
							DebugLog( "BossRoutine::StartSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..nCurPhase )

							for nCurSubPhase = 1, #CurSkillInfo["SummonMobs"]
							do
								for k = 1, CurSkillInfo["SummonMobs"][ nCurSubPhase ]["CountPerSummon"]
								do
									cMobRegen_Obj( CurSkillInfo["SummonMobs"][ nCurSubPhase ]["Index"], Handle )
									DebugLog( "BossRoutine::CastSkill-"..sSkillName.." "..sCurSkillTableIndex.." ("..k.."/"..CurSkillInfo["SummonMobs"][ nCurSubPhase ]["CountPerSummon"]..") :"..CurSkillInfo["SummonMobs"][ nCurSubPhase ]["Index"] )
								end
							end

							if CurPhaseCastingInfo["nSummonCount"] == nil
							then
								CurPhaseCastingInfo["nSummonCount"] = 0
							end

							-- 해당 회차 시전 완료 처리
							CurPhaseCastingInfo["dLastCastedTime"] = Var["CurSec"]
							CurPhaseCastingInfo["nSummonCount"] = CurPhaseCastingInfo["nSummonCount"] + 1

						else
							ErrorLog( "BossRoutine::This name of skill("..sSkillName..") is invalid." )
						end -- 스킬 이름 관련 조건문 //


						-- 시전 완료 처리
						CurPhaseCastingInfo["bCasting"] = false
						DebugLog( "BossRoutine::EndSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..nCurPhase )

						-- 페이스컷 시작
						Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] = false
						Var["EachFloor"..CurStepNo ]["nHP_BossSummonDialog"] = ThresholdTable[ sThresholdTableIndex ][ nCurPhase ]

					end -- 스킬 시전이 준비 되었는지 확인하는 조건문 //

				end -- 한 스킬에 대한 순차적 시전 루프 //

			end -- 스킬 시전 자체를 했는가 확인하는 조건문 //

		end -- 각 스킬을 한번씩 탐색하는 루프 //

	end -- 소환스킬 사용 관련 페이스컷이 진행중인지 확인하는 조건문 //

	return ReturnAI["CPP"]

end
