--------------------------------------------------------------------------------
--                    Mini Dragon (Hard Mode) Routine                         --
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
		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

	return ReturnAI["CPP"]
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
		local nCurPhase = Var["BossBattle"][ sSkillName.."PhaseNo"]
		local nMaxPhase = #ThresholdTable[ sSkillName.."HP"]

		if nCurPhase <= nMaxPhase
		then
			-- 현재 HP와 스킬의 Threshold 와 비교하여 순차적으로 소급 적용하여 시전
			while ThresholdTable[ sSkillName.."HP"][ nCurPhase ] >= HP_Rate
			do
				-- 시전할 스킬의 테이블 내 인덱스 받아오기
				local sCurSkillIndex 	= "HP"..ThresholdTable[ sSkillName.."HP"][ nCurPhase ]

				if BossSkill[ sSkillName ][ sCurSkillIndex ] ~= nil
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

	end -- 스킬별로 한번씩 탐색하는 루프 //

end


function MiniDragonRoutine( Handle, MapIndex )
cExecCheck "MiniDragonRoutine"

	if Handle == nil
	then
		ErrorLog( "MiniDragonRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "MiniDragonRoutine::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "MiniDragonRoutine::Var == nil" )
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
		ErrorLog( "MiniDragonRoutine::Var[\"Enemy\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "MiniDragonRoutine::Var[\"Enemy\"]["..Handle.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	--    Mini Dragon 사망
	if cIsObjectDead( Handle ) == 1
	then
		DebugLog( "MiniDragonRoutine::BossDead" )
		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	if Var["BossBattle"] == nil
	then
		ErrorLog( "MiniDragonRoutine::Var[\"BossBattle\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 최초 타겟 설정시 DetectRange 변경
	if Var["BossBattle"]["BossInitialTargetHandle"] == nil
	then
		Var["BossBattle"]["BossInitialTargetHandle"] = cTargetHandle( Handle )
		if Var["BossBattle"]["BossInitialTargetHandle"] ~= nil
		then
			cMobDetectRange( Handle, BossDetectRange["View"] )
		end
	end


	-- MobDamaged 루틴 등록
	cAIScriptFunc( Handle, "MobDamaged", "BossDamaged" )


	-- 최초 스킬 확률 설정을 위한 MobDamaged 루틴 강제 실행을 해줌
	if Var["BossBattle"]["bInitialSkillRateSet"] == nil
	then
		Var["BossBattle"]["bInitialSkillRateSet"] = true

		local CurHP, MaxHP = cObjectHP( Handle )
		BossDamaged( MapIndex, 0, MaxHP, CurHP, Handle )
	end


	-- 스킬별로 한번 씩 탐색
	for nIndex, sSkillName in pairs ( BossSkillNameTable )
	do
		-- 다음 스킬 순번과 해당 스킬 시전테이블이 없다면 아직 시전도 안된 것이므로 패스
		if Var["BossBattle"][ sSkillName.."PhaseNo"] ~= nil and Var["BossBattle"][ sSkillName ] ~= nil
		then
			-- 시전승인된 스킬들만 순서대로 시전해야함.
			for i = 1, #Var["BossBattle"][ sSkillName ]
			do
				-- 에러체크
				if Var["BossBattle"][ sSkillName ][ i ] == nil
				then
					break
				end

				-- 준비된 스킬 시전
				if Var["BossBattle"][ sSkillName ][ i ]["bCasting"] == true
				then
					local sCurSkillTableIndex = Var["BossBattle"][ sSkillName ][ i ]["sSkillTableIndex"]
					local CurSkillInfo = BossSkill[ sSkillName ][ sCurSkillTableIndex ]

					if sSkillName == "SkillRateChange" -- 스킬확률 변환
					then
						DebugLog( "BossDamaged::StartSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )
						local Values = CurSkillInfo["SkillRate"]
						cMobWeaponRate( Handle, Values[1], Values[2], Values[3], Values[4] )
						DebugLog( "BossDamaged::CastSkill-"..sSkillName.." "..sCurSkillTableIndex.." "..i..":"..Values[1].." "..Values[2].." "..Values[3].." "..Values[4] )
						-- 시전 완료 처리
						Var["BossBattle"][ sSkillName ][ i ]["bCasting"] = false
						DebugLog( "BossDamaged::EndSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )

					elseif sSkillName == "Summon" -- 잔몹 소환
					then
						DebugLog( "BossDamaged::StartSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )
						for i = 1, #CurSkillInfo["SummonMobs"]
						do
							cMobRegen_Obj( CurSkillInfo["SummonMobs"][ i ], Handle )
							DebugLog( "BossDamaged::CastSkill-"..sSkillName.." "..sCurSkillTableIndex.." "..i..":"..CurSkillInfo["SummonMobs"][ i ] )
						end
						-- 시전 완료 처리
						Var["BossBattle"][ sSkillName ][ i ]["bCasting"] = false
						DebugLog( "BossDamaged::EndSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )

					elseif sSkillName == "Heal" -- 자힐
					then
						-- 시전중이 아닐경우 시전중으로 바꿔주며 초기 설정을 함
						if Var["BossBattle"]["bBossIsHealingItself"] ~= true
						then
							DebugLog( "BossDamaged::StartSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )
							Var["BossBattle"]["bBossIsHealingItself"] = true

							-- 힐 단계 설정 초기화
							Var["BossBattle"]["HealCastingStepNo"] = 1
							Var["BossBattle"]["HealCastingStepSec"] = Var["CurSec"]

							local BossHealAbstate = BossSkill["Heal"]["Abstate"]
							cSetAbstate( Handle, BossHealAbstate["Index"], BossHealAbstate["Strength"], BossHealAbstate["KeepTime"] )
							cAnimate( Handle, "start", BossSkill["Heal"]["AnimationIndex"] )
						end

						-- 시전중일경우 타이밍이 될 때마다 힐을 시전
						if Var["BossBattle"]["bBossIsHealingItself"] == true
						then
							-- 힐 시전중
							if Var["BossBattle"]["HealCastingStepNo"] <= BossSkill["Heal"]["TickCount"]
							then
								if Var["BossBattle"]["HealCastingStepSec"] <= Var["CurSec"]
								then
									cHeal( Handle, BossSkill["Heal"][ sCurSkillTableIndex ]["HealAmount"] )
									DebugLog( "BossDamaged::CastSkill-"..sSkillName.." "..sCurSkillTableIndex.." "..i..":"..Var["BossBattle"]["HealCastingStepNo"].." "..BossSkill["Heal"][ sCurSkillTableIndex ]["HealAmount"] )

									Var["BossBattle"]["HealCastingStepNo"] = Var["BossBattle"]["HealCastingStepNo"] + 1
									Var["BossBattle"]["HealCastingStepSec"] = Var["BossBattle"]["HealCastingStepSec"] + BossSkill["Heal"]["TickTimeSec"]

									break -- 해당 종류의 스킬의 루프만 빠져나온다.
								end

							else
								cAnimate( Handle, "stop" )
								Var["BossBattle"]["bBossIsHealingItself"] = false
								-- 시전 완료 처리
								Var["BossBattle"][ sSkillName ][ i ]["bCasting"] = false
								DebugLog( "BossDamaged::EndSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )
							end

						end

					end -- 스킬 이름 관련 조건문 //

				end -- 스킬 시전이 준비 되었는지 확인하는 조건문 //

			end -- 한 스킬에 대한 순차적 시전 루프 //

		end -- 스킬 시전 자체를 했는가 확인하는 조건문 //

	end -- 각 스킬을 한번씩 탐색하는 루프 //

	return ReturnAI["CPP"]

end
