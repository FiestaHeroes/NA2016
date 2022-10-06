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

	-- 0.2�ʸ��� üũ�ϴ� ��ƾ
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


	-- Mid Boss ���
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


	-- �����߿� ���� ������ �����ϰ� �����ϱ� ����
	if Var["BossBattle"]["Casting"] == nil
	then
		Var["BossBattle"]["Casting"] = {}
	end


	local HP_Rate = ( CurHP * 1000 ) / MaxHP


	-- ��ų���� �ѹ� �� Ž��
	for nIndex, sSkillName in pairs ( BossSkillNameTable )
	do
		-- ������� ��ų��������� �ʱ�ȭ
		if Var["BossBattle"][ sSkillName.."PhaseNo"] == nil
		then
			Var["BossBattle"][ sSkillName.."PhaseNo"] = 1
		end

		-- ���� ��ų ������ ���� ���̺��� ������� ����
		if Var["BossBattle"][ sSkillName ] == nil
		then
			Var["BossBattle"][ sSkillName ] = {}
		end

		-- ��ų ������ ����
		local nCurPhase = Var["BossBattle"][ sSkillName.."PhaseNo"]
		local nMaxPhase = #ThresholdTable[ sSkillName.."HP"]

		if nCurPhase <= nMaxPhase
		then
			-- ���� HP�� ��ų�� Threshold �� ���Ͽ� ���������� �ұ� �����Ͽ� ����
			while ThresholdTable[ sSkillName.."HP"][ nCurPhase ] >= HP_Rate
			do
				-- ������ ��ų�� ���̺� �� �ε��� �޾ƿ���
				local sCurSkillIndex 	= "HP"..ThresholdTable[ sSkillName.."HP"][ nCurPhase ]

				if BossSkill[ sSkillName ][ sCurSkillIndex ] ~= nil
				then
					-- ��ų�� ��ƾ���� �����ϵ��� ����
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

			end -- ��ų�� �����϶�� ������� �������ִ� ����

			-- �޸��� ��ų ������ ���� �� ����
			Var["BossBattle"][ sSkillName.."PhaseNo"] = nCurPhase

		end -- �� ��ų�� ������ �ʰ��ߴ��� Ȯ�����ִ� ���ǹ� //

	end -- ��ų���� �ѹ��� Ž���ϴ� ���� //

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


	-- 0.2�ʸ��� üũ�ϴ� ��ƾ
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


	--    Mini Dragon ���
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


	-- ���� Ÿ�� ������ DetectRange ����
	if Var["BossBattle"]["BossInitialTargetHandle"] == nil
	then
		Var["BossBattle"]["BossInitialTargetHandle"] = cTargetHandle( Handle )
		if Var["BossBattle"]["BossInitialTargetHandle"] ~= nil
		then
			cMobDetectRange( Handle, BossDetectRange["View"] )
		end
	end


	-- MobDamaged ��ƾ ���
	cAIScriptFunc( Handle, "MobDamaged", "BossDamaged" )


	-- ���� ��ų Ȯ�� ������ ���� MobDamaged ��ƾ ���� ������ ����
	if Var["BossBattle"]["bInitialSkillRateSet"] == nil
	then
		Var["BossBattle"]["bInitialSkillRateSet"] = true

		local CurHP, MaxHP = cObjectHP( Handle )
		BossDamaged( MapIndex, 0, MaxHP, CurHP, Handle )
	end


	-- ��ų���� �ѹ� �� Ž��
	for nIndex, sSkillName in pairs ( BossSkillNameTable )
	do
		-- ���� ��ų ������ �ش� ��ų �������̺��� ���ٸ� ���� ������ �ȵ� ���̹Ƿ� �н�
		if Var["BossBattle"][ sSkillName.."PhaseNo"] ~= nil and Var["BossBattle"][ sSkillName ] ~= nil
		then
			-- �������ε� ��ų�鸸 ������� �����ؾ���.
			for i = 1, #Var["BossBattle"][ sSkillName ]
			do
				-- ����üũ
				if Var["BossBattle"][ sSkillName ][ i ] == nil
				then
					break
				end

				-- �غ�� ��ų ����
				if Var["BossBattle"][ sSkillName ][ i ]["bCasting"] == true
				then
					local sCurSkillTableIndex = Var["BossBattle"][ sSkillName ][ i ]["sSkillTableIndex"]
					local CurSkillInfo = BossSkill[ sSkillName ][ sCurSkillTableIndex ]

					if sSkillName == "SkillRateChange" -- ��ųȮ�� ��ȯ
					then
						DebugLog( "BossDamaged::StartSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )
						local Values = CurSkillInfo["SkillRate"]
						cMobWeaponRate( Handle, Values[1], Values[2], Values[3], Values[4] )
						DebugLog( "BossDamaged::CastSkill-"..sSkillName.." "..sCurSkillTableIndex.." "..i..":"..Values[1].." "..Values[2].." "..Values[3].." "..Values[4] )
						-- ���� �Ϸ� ó��
						Var["BossBattle"][ sSkillName ][ i ]["bCasting"] = false
						DebugLog( "BossDamaged::EndSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )

					elseif sSkillName == "Summon" -- �ܸ� ��ȯ
					then
						DebugLog( "BossDamaged::StartSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )
						for i = 1, #CurSkillInfo["SummonMobs"]
						do
							cMobRegen_Obj( CurSkillInfo["SummonMobs"][ i ], Handle )
							DebugLog( "BossDamaged::CastSkill-"..sSkillName.." "..sCurSkillTableIndex.." "..i..":"..CurSkillInfo["SummonMobs"][ i ] )
						end
						-- ���� �Ϸ� ó��
						Var["BossBattle"][ sSkillName ][ i ]["bCasting"] = false
						DebugLog( "BossDamaged::EndSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )

					elseif sSkillName == "Heal" -- ����
					then
						-- �������� �ƴҰ�� ���������� �ٲ��ָ� �ʱ� ������ ��
						if Var["BossBattle"]["bBossIsHealingItself"] ~= true
						then
							DebugLog( "BossDamaged::StartSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )
							Var["BossBattle"]["bBossIsHealingItself"] = true

							-- �� �ܰ� ���� �ʱ�ȭ
							Var["BossBattle"]["HealCastingStepNo"] = 1
							Var["BossBattle"]["HealCastingStepSec"] = Var["CurSec"]

							local BossHealAbstate = BossSkill["Heal"]["Abstate"]
							cSetAbstate( Handle, BossHealAbstate["Index"], BossHealAbstate["Strength"], BossHealAbstate["KeepTime"] )
							cAnimate( Handle, "start", BossSkill["Heal"]["AnimationIndex"] )
						end

						-- �������ϰ�� Ÿ�̹��� �� ������ ���� ����
						if Var["BossBattle"]["bBossIsHealingItself"] == true
						then
							-- �� ������
							if Var["BossBattle"]["HealCastingStepNo"] <= BossSkill["Heal"]["TickCount"]
							then
								if Var["BossBattle"]["HealCastingStepSec"] <= Var["CurSec"]
								then
									cHeal( Handle, BossSkill["Heal"][ sCurSkillTableIndex ]["HealAmount"] )
									DebugLog( "BossDamaged::CastSkill-"..sSkillName.." "..sCurSkillTableIndex.." "..i..":"..Var["BossBattle"]["HealCastingStepNo"].." "..BossSkill["Heal"][ sCurSkillTableIndex ]["HealAmount"] )

									Var["BossBattle"]["HealCastingStepNo"] = Var["BossBattle"]["HealCastingStepNo"] + 1
									Var["BossBattle"]["HealCastingStepSec"] = Var["BossBattle"]["HealCastingStepSec"] + BossSkill["Heal"]["TickTimeSec"]

									break -- �ش� ������ ��ų�� ������ �������´�.
								end

							else
								cAnimate( Handle, "stop" )
								Var["BossBattle"]["bBossIsHealingItself"] = false
								-- ���� �Ϸ� ó��
								Var["BossBattle"][ sSkillName ][ i ]["bCasting"] = false
								DebugLog( "BossDamaged::EndSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )
							end

						end

					end -- ��ų �̸� ���� ���ǹ� //

				end -- ��ų ������ �غ� �Ǿ����� Ȯ���ϴ� ���ǹ� //

			end -- �� ��ų�� ���� ������ ���� ���� //

		end -- ��ų ���� ��ü�� �ߴ°� Ȯ���ϴ� ���ǹ� //

	end -- �� ��ų�� �ѹ��� Ž���ϴ� ���� //

	return ReturnAI["CPP"]

end
