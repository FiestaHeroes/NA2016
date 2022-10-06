--------------------------------------------------------------------------------
--                          Emperor Slime Routine                             --
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

function KingSlimeRoutine( Handle, MapIndex )
cExecCheck "KingSlimeRoutine"

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local RoutineTimeIndex = ""..Handle

	-- // 0.2초마다 체크하는 루틴
	if Var["RoutineTime"][ RoutineTimeIndex ] == nil
	then
		Var["RoutineTime"][ RoutineTimeIndex ] = cCurrentSecond()
	end


	if Var["RoutineTime"][ RoutineTimeIndex ] + 0.2 > cCurrentSecond()
	then
		return ReturnAI["CPP"]
	else
		Var["RoutineTime"][ RoutineTimeIndex ] = cCurrentSecond()
	end
	-- 0.2초마다 체크하는 루틴 //


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

	if Var["LowerFloor"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["LowerFloor"]["FloorNumber"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	local CurFloorNo = Var["LowerFloor"]["FloorNumber"]

	if Var["LowerFloor"..CurFloorNo ] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["LowerFloor"..CurFloorNo ]["nKingSlimeCount"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	-- 사망
	if cIsObjectDead( Handle ) == 1
	then
		Var["LowerFloor"..CurFloorNo ]["nKingSlimeCount"] = Var["LowerFloor"..CurFloorNo ]["nKingSlimeCount"] - 1

		if Var["LowerFloor"..CurFloorNo ]["nKingSlimeCount"] > 0
		then
			cMobShout( Handle, KingSlimeChat["ScriptFileName"], KingSlimeChat["DeathDialogIndex"] )
		else
			cMobSuicide( MapIndex )
		end

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

end


function EmperorSlimeRoutine( Handle, MapIndex )
cExecCheck "EmperorSlimeRoutine"

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	local RoutineTimeIndex = ""..Handle

	-- // 0.2초마다 체크하는 루틴
	if Var["RoutineTime"][ RoutineTimeIndex ] == nil
	then
		Var["RoutineTime"][ RoutineTimeIndex ] = cCurrentSecond()
	end


	if Var["RoutineTime"][ RoutineTimeIndex ] + 0.2 > cCurrentSecond()
	then
		return ReturnAI["CPP"]
	else
		Var["RoutineTime"][ RoutineTimeIndex ] = cCurrentSecond()
	end
	-- 0.2초마다 체크하는 루틴 //


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

	if Var["TopFloor"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ]["PhaseNumber"] == nil
	then
		Var["Enemy"][ Handle ]["PhaseNumber"] = 1
	end

	local CurPhaseNumber = Var["Enemy"][ Handle ]["PhaseNumber"]

	-- 퀸슬라임이 죽거나 사라질 경우 힐이 끝난 경우이므로 해당 이펙트 제거
	if CurPhaseNumber == 5 or CurPhaseNumber == 3
	then
		if Var["QueenSlimeHandle"] ~= nil
		then
			for i = 1, #Var["QueenSlimeHandle"]
			do
				if cIsObjectDead( Var["QueenSlimeHandle"][ i ] ) == 1 or cIsObjectDead( Handle ) == 1
				then
					if Var["HealEffect"] ~= nil
					then
						if Var["HealEffect"][ i ]["Boss"] ~= nil
						then
							cNPCVanish( Var["HealEffect"][ i ]["Boss"] )
							DebugLog( "Effect Vanished : "..Var["HealEffect"][ i ]["Boss"] )
						end

						if Var["HealEffect"][ i ]["Queen"] ~= nil
						then
							cNPCVanish( Var["HealEffect"][ i ]["Queen"] )
							DebugLog( "Effect Vanished : "..Var["HealEffect"][ i ]["Queen"] )
						end

						Var["HealEffect"][ i ] = {}
					else
						ErrorLog( "Var[\"HealEffect\"] ~= nil" )
					end
				end
			end
		end
	end


	-- Emperor Slime 사망
	if cIsObjectDead( Handle ) == 1
	then
		cMobDialog( MapIndex, EmperorSlimeChat["SpeakerIndex"], EmperorSlimeChat["ScriptFileName"], EmperorSlimeChat["DeathDialogIndex"] )
		cMobSuicide( MapIndex )

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ]["PhaseNumber"] = nil
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	-- 보스의 제자리 빙빙 돌기 스킬이 끝난 경우
	if Var["TopFloor"]["bBossTurning"] == true
	then
		if Var["TopFloor"]["BossAnimationStopStepSec"] <= Var["CurSec"]
		then
			cAnimate( Handle, "stop" )
			Var["TopFloor"]["bBossTurning"] = false
		end
	end


	-- 페이즈 조건 체크 후 행동
	local CurHP, MaxHP	= cObjectHP( Handle )
	local RoutineStepFunc = DummyPhaseFunc

	if CurHP == MaxHP
	then
		-- 만피 상태에서 어그로를 가진 대상이 없다면 보스 페이즈 초기화
		if cAggroListSize( Handle ) == 0
		then
			if CurPhaseNumber ~= 1
			then
				Var["Enemy"][ Handle ]["PhaseNumber"] = 1
				Var["TopFloor"]["bCurPhaseSummonEnd"] = false
				Var["TopFloor"]["CurPhaseNextSummonStepSec"] = Var["CurSec"]
				Var["TopFloor"]["QueenRevivalStepSec"] = nil

				cVanishAll( MapIndex, "Emp_Tornado" )
				cVanishAll( MapIndex, "Emp_Slime2" )
				cVanishAll( MapIndex, "Emp_FireSlime2" )
				cVanishAll( MapIndex, "Emp_IronSlime2" )
				cVanishAll( MapIndex, "Emp_QueenSlime2" )
			end
		end

		return ReturnAI["CPP"]
	end

	-- 페이즈 번호와 다음 페이즈 번호를 사용하기 위하여 페이즈 번호 체크
	if CurPhaseNumber >= #BossPhaseNameTable
	then
		return ReturnAI["CPP"]
	end

	-- 현재, 다음 페이즈 번호가 유효 할 경우
	local CurBossPhaseName	= BossPhaseNameTable[ CurPhaseNumber ]
	local NextBossPhaseName	= BossPhaseNameTable[ CurPhaseNumber + 1 ]
	local CurPhaseSkill		= EmperorSlimeSkill[ CurBossPhaseName ]
	local NextPhaseSkill	= EmperorSlimeSkill[ NextBossPhaseName ]
	local HP_RealRate		= ( CurHP * 1000 ) / MaxHP -- 1000분율

	-- 다음 페이즈 진입조건일 경우
	if HP_RealRate <= NextPhaseSkill["HP_Rate"]
	then
		-- 실행 될 페이즈로 바꾼 후, 페이즈의 보스 액션 실행
		Var["Enemy"][ Handle ]["PhaseNumber"] = CurPhaseNumber + 1
		RoutineStepFunc	= PhaseActionFunc


		-- 소환 회차 관련 초기화
		Var["TopFloor"]["CurSummonCount"] = 1
		Var["TopFloor"]["bCurPhaseSummonEnd"] = false
		Var["TopFloor"]["CurPhaseNextSummonStepSec"] = Var["CurSec"]


		-- 소환 횟수가 무제한이 아닌 경우에 한해서 소환 횟수 체크
		if NextPhaseSkill["SummonCount"] ~= nil
		then
			if NextPhaseSkill["SummonCount"] <= Var["TopFloor"]["CurSummonCount"]
			then
				Var["TopFloor"]["bCurPhaseSummonEnd"] = true
			end
		end

		-- 소환과 소환 사이의 시간이 무효가 아닌 경우에 한해서 시간 설정 : 무효인 경우 해당 페이즈의 소환은 이번 턴으로 종료됨
		if NextPhaseSkill["SummonGapSec"] ~= nil
		then
			Var["TopFloor"]["CurPhaseNextSummonStepSec"] = Var["CurSec"] + NextPhaseSkill["SummonGapSec"]
		else
			Var["TopFloor"]["bCurPhaseSummonEnd"] = true
		end

	-- 다음 페이즈 진입 조건 안됨 & 현재 페이즈에서 할일이 남았거나 모두 끝난 상태
	else
		-- 현재 페이즈에서 소환이 모두 끝났으면 다음 페이즈 조건에 도달할 때까지 대기
		if Var["TopFloor"]["bCurPhaseSummonEnd"] == true
		then
			return ReturnAI["CPP"]
		end

	-- 소환이 시작되기 전에는 아무것도 하지 않는다.
		if CurPhaseNumber == 1
		then
			return ReturnAI["CPP"]
		end

		-- 소환 사이의 시간이 무효인 경우 한번 소환한 이후 이 페이즈에서는 소환할 일이 없음
		if CurPhaseSkill["SummonGapSec"] == nil
		then
			-- 혹시 이 조건까지 들어왔을 경우를 대비하여 처리를 한번 더 함
			Var["TopFloor"]["bCurPhaseSummonEnd"] = true

			return ReturnAI["CPP"]
		end

		-- 시간상 다음 소환 타이밍
		if Var["TopFloor"]["CurPhaseNextSummonStepSec"] <= Var["CurSec"]
		then

			local bSummonTiming = true

			-- 아이언 슬라임 소환 시에만 HP 조건을 한번 더 체크 한다.
			if CurPhaseNumber == 4
			then
				-- 보스의 피가 소환 단계 진입 조건보다 높아지면 소환을 잠시 쉰다.
				if HP_RealRate > CurPhaseSkill["HP_Rate"]
				then
					bSummonTiming = false
				end
			end

			if bSummonTiming == true
			then
				RoutineStepFunc	= PhaseActionFunc

				-- 소환 회차 증가
				Var["TopFloor"]["CurSummonCount"] = Var["TopFloor"]["CurSummonCount"] + 1

				-- 소환 횟수가 무제한이 아닌 경우에 한해서 소환 횟수 체크
				if CurPhaseSkill["SummonCount"] ~= nil
				then
					if CurPhaseSkill["SummonCount"] <= Var["TopFloor"]["CurSummonCount"]
					then
						Var["TopFloor"]["bCurPhaseSummonEnd"] = true
					end
				end

				-- 다음 소환 시간 설정
				Var["TopFloor"]["CurPhaseNextSummonStepSec"] = Var["CurSec"] + CurPhaseSkill["SummonGapSec"]

			else
				-- 소환을 잠시 중지하면서 피가 다시 기준치 이하로 떨어 질 시 바로 소환하도록 시간 설정.
				Var["TopFloor"]["CurPhaseNextSummonStepSec"] = Var["CurSec"]

				return ReturnAI["CPP"]
			end

		end
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

	if PhaseNumber == 1
	then
		ErrorLog( "PhaseActionFunc::Normal-Phase does not have Phase-Action." )
		return
	elseif PhaseNumber < 1 and PhaseNumber > #BossPhaseNameTable
	then
		-- 비정상 케이스
		ErrorLog( "PhaseActionFunc::Invalid-Phase" )
		return
	end

	local BossPhase 	= BossPhaseNameTable[ PhaseNumber ]

	DebugLog( "Start PhaseActionFunc::"..BossPhase )


	if EmperorSlimeChat["SummonMobShout"][ BossPhase ] ~= nil
	then
		if Var["TopFloor"]["CurSummonCount"] == 1
		-- 페이즈 시작 시에만 외침
		then
			cMobShout( BossHandle, EmperorSlimeChat["ScriptFileName"], EmperorSlimeChat["SummonMobShout"][ BossPhase ]["Index"] )
		end
	end


	local i = 1

	local SummonMobTableInfo = nil

	if EmperorSlimeSkill[ BossPhase ] ~= nil
	then
		SummonMobTableInfo = RegenInfo["Mob"]["TopFloor"][ EmperorSlimeSkill[ BossPhase ]["SummonMobsTableIndex"] ]

		-- 소환하면서 보스가 회전하는 부분
		if EmperorSlimeSkill[ BossPhase ]["bBossSpinning"] == true
		then
			cAnimate( BossHandle, "start", EmperorSlimeSkill["SummonEffect"]["EffectSkillIndex"] )
			Var["TopFloor"]["bBossTurning"] = true
			Var["TopFloor"]["BossAnimationStopStepSec"] = Var["CurSec"] + EmperorSlimeSkill["SummonEffect"]["AnimationKeepSec"] + 1 -- + 1 은 약간의 시간차를 위한 설정
		end

	else
		ErrorLog( "SummonMobInfo is not exist( BossPhase : ".. BossPhase.." )" )
	end

	if SummonMobTableInfo ~= nil
	then
		-- 한 루프당 소환 범위가 다름
		for k = 1, #SummonMobTableInfo
		do
			if SummonMobTableInfo[ k ] ~= nil
			then
				local SummonMobInfo = { Index = SummonMobTableInfo[ k ]["Index"], x = SummonMobTableInfo[ k ]["x"], y = SummonMobTableInfo[ k ]["y"], dir = 0, }

				-- 보스가 리젠위치로 부터 일정거리 이상 벌어졌을 경우 잔몹은 보스몹 중심으로 소환
				local BossX, BossY = cObjectLocate( BossHandle )
				local OriginX = Var["Enemy"][ BossHandle ]["x"]
				local OriginY = Var["Enemy"][ BossHandle ]["y"]
				local LimitSquare = EmperorSlimeSkill["LimitDistanceFromOrigin"] * EmperorSlimeSkill["LimitDistanceFromOrigin"]

				-- 거리 초과시
				if cDistanceSquar( BossX, BossY, OriginX, OriginY ) > LimitSquare
				then
					SummonMobInfo["x"] = BossX
					SummonMobInfo["y"] = BossY
				end

				-- 토네이도 소환
				if EmperorSlimeSkill[ BossPhase ]["bSummonAreaCenterTornado"] == true
				then
					local TornadoHandle = cMobRegen_XY( MapIndex, EmperorSlimeSkill["TornadoEffect"]["CenterMobIndex"], SummonMobInfo["x"], SummonMobInfo["y"], 0 )

					if TornadoHandle ~= nil
					then
						cSetAIScript ( MainLuaScriptPath, TornadoHandle )
						cAIScriptFunc( TornadoHandle, "Entrance", "SummonMobRoutine" )

						local TornadoInfo = { Index = EmperorSlimeSkill["TornadoEffect"]["CenterMobIndex"], x = SummonMobInfo["x"], y = SummonMobInfo["y"], dir = 0, }

						Var["Enemy"][ TornadoHandle ] = TornadoInfo
						if EmperorSlimeSkill["TornadoEffect"]["MobLifeSec"] ~= nil
						then
							Var["Enemy"][ TornadoHandle ]["DieStepSec"] = Var["CurSec"] + EmperorSlimeSkill["TornadoEffect"]["MobLifeSec"]
						end
					else
						ErrorLog( "Summon Tornado Fail"..TornadoInfo["Index"] )
					end
				end

				-- 일정 범위에 정해진 수만큼 몹 소환
				if Var["KQ_Difficulty"] == nil
				then
					Var["KQ_Difficulty"] = 3
				end

				for nSummonCount = 1, SummonMobTableInfo[ k ]["count"..Var["KQ_Difficulty"] ]
				do
					local SummonMobHandle = nil

					-- 퀸슬라임은 보스 주위에 소환
					if PhaseNumber == 5
					then
						SummonMobInfo["x"] = BossX
						SummonMobInfo["y"] = BossY
					end

					SummonMobHandle = cMobRegen_Circle( MapIndex, SummonMobInfo["Index"], SummonMobInfo["x"], SummonMobInfo["y"], SummonMobInfo["radius"] )

					if SummonMobHandle ~= nil
					then
						cSetAIScript ( MainLuaScriptPath, SummonMobHandle )
						cAIScriptFunc( SummonMobHandle, "Entrance", "SummonMobRoutine" )

						Var["Enemy"][ SummonMobHandle ] = SummonMobInfo
						if EmperorSlimeSkill[ BossPhase ]["MobLifeSec"] ~= nil
						then
							Var["Enemy"][ SummonMobHandle ]["DieStepSec"] = Var["CurSec"] + EmperorSlimeSkill[ BossPhase ]["MobLifeSec"]
						end

						if PhaseNumber == 5
						then
							if Var["QueenSlimeHandle"] == nil
							then
								Var["QueenSlimeHandle"] = {}
							end

							Var["QueenSlimeHandle"][ nSummonCount ] = SummonMobHandle
						end
					else
						ErrorLog( "Summon Mob Fail : "..SummonMobInfo["Index"] )
					end
				end
			end
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


	-- // 0.2초마다 체크하는 루틴
	local RoutineTimeIndex = ""..Handle

	if Var["RoutineTime"][ RoutineTimeIndex ] == nil
	then
		Var["RoutineTime"][ RoutineTimeIndex ] = cCurrentSecond()
	end

	if Var["RoutineTime"][ RoutineTimeIndex ] + 0.2 > cCurrentSecond()
	then
		return ReturnAI["CPP"]
	else
		Var["RoutineTime"][ RoutineTimeIndex ] = cCurrentSecond()
	end
	-- 0.2초마다 체크하는 루틴 //


	if Var["Enemy"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["RoutineTime"][ RoutineTimeIndex ] = nil
		return ReturnAI["END"]
	end


	if Var["Enemy"][ Handle ] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["RoutineTime"][ RoutineTimeIndex ] = nil
		return ReturnAI["END"]
	end


	if Var["TopFloor"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["RoutineTime"][ RoutineTimeIndex ] = nil
		return ReturnAI["END"]
	end


	-- 소환된 몹 사망시
	if cIsObjectDead( Handle ) == 1
	then
		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		Var["RoutineTime"][ RoutineTimeIndex ] = nil
		return ReturnAI["END"]
	end

	-- 보스 사망시
	if cIsObjectDead( Var["Enemy"]["BossHandle"] ) == 1
	then
		cMobSuicide( MapIndex, Handle )
		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		Var["RoutineTime"][ RoutineTimeIndex ] = nil
		return ReturnAI["END"]
	end


	local sSkillIndex = ""

	if 	Var["Enemy"][ Handle ]["Index"] == "Emp_Tornado"
	then
		sSkillIndex = "TornadoEffect"

	elseif 	Var["Enemy"][ Handle ]["Index"] == "Emp_Slime2"
	then
		sSkillIndex = "FirstSummon"
	elseif	Var["Enemy"][ Handle ]["Index"] == "Emp_FireSlime2"
	then
		sSkillIndex = "SecondSummon"
	elseif	Var["Enemy"][ Handle ]["Index"] == "Emp_IronSlime2"
	then
		sSkillIndex = "ThirdSummon"
	elseif	Var["Enemy"][ Handle ]["Index"] == "Emp_QueenSlime2"
	then
		sSkillIndex = "LastSummon"

		-- 퀸 슬라임 소멸 조건
		local CurHP, MaxHP	= cObjectHP( Var["Enemy"]["BossHandle"] )

		local HP_RealRate = 1000

		if MaxHP ~= 0
		then
			HP_RealRate	= ( CurHP * 1000 ) / MaxHP -- 1000분율
		end

		if HP_RealRate >= EmperorSlimeSkill[ sSkillIndex ]["MobVanishCondBossHP_Rate"]
		then
			-- 보스 피가 일정 이상 넘어가면 퀸슬라임 자동 소멸 ( 하나만 죽었을 때 하는 처리 때문에 두마리를 한번에 없앤다. )
			cVanishAll( MapIndex, Var["Enemy"][ Handle ]["Index"] )

			for i = 1, #Var["QueenSlimeHandle"]
			do
				local VanishHandle = Var["QueenSlimeHandle"][ i ]
				DebugLog( "VanishedByHP"..EmperorSlimeSkill[ sSkillIndex ]["MobVanishCondBossHP_Rate"].."More : "..sSkillIndex..", Handle("..VanishHandle..")" )
				cAIScriptSet( VanishHandle )
				Var["Enemy"][ VanishHandle ] = nil
				Var["RoutineTime"][ ""..VanishHandle ] = nil
			end

			-- 보스의 페이즈 일부 초기화 : 딜이 약한 경우 클리어 불가능하게 만듬
			-- 보스의 소환페이즈를 파이어슬라임 소환 이후로 변경한다 ( 현재 HP에 적합하게 맞춤 )
			Var["Enemy"][ Var["Enemy"]["BossHandle"] ]["PhaseNumber"] = 3
			Var["TopFloor"]["bCurPhaseSummonEnd"] = true

			return ReturnAI["END"]
		end

		-- 이 시점까지 온 퀸슬라임은 살아있는 퀸 슬라임
		-- 한마리만 죽으면 30초 안에 이 퀸 슬라임도 죽어야 퀸슬라임이 또 생기지 않는다.
		local QueenDeadCount = 0
		local CurQueenNo = 0
		local DeadQueenNo = 0

		for i = 1, #Var["QueenSlimeHandle"]
		do
			if cIsObjectDead( Var["QueenSlimeHandle"][ i ] ) == 1
			then
				-- 사망한 퀸 슬라임 카운팅 및 번호 얻기
				QueenDeadCount = QueenDeadCount + 1
				DeadQueenNo = i
			else
				-- 현재 루틴의 퀸 슬라임 번호 얻기
				if Handle == Var["QueenSlimeHandle"][ i ]
				then
					CurQueenNo = i
				end
			end
		end

		-- 퀸 사망체크가 제대로 이뤄지고 있는지 체크하는 부분(과도한 로그 발생 우려로 인해 대부분의 경우 비활성화 필요)
		--DebugLog( "AtThisRoutine, QueenDeathCount("..QueenDeadCount.."), CurQueenNo("..CurQueenNo.."), DeadQueenNo("..DeadQueenNo..")" )

		-- 현재 루틴의 퀸 슬라임이 살아있지 않거나 제대로 제어중이 아니면 자살처리
		if CurQueenNo == 0
		then
			ErrorLog( "This QueenSlime was aleady died." )
			cMobSuicide( Handle )
			cAIScriptSet( Handle )
			Var["Enemy"][ Handle ] = nil
			Var["RoutineTime"][ RoutineTimeIndex ] = nil
			return ReturnAI["END"]
		end

		if QueenDeadCount == 1
		then
			if Var["TopFloor"]["QueenRevivalStepSec"] ~= nil
			then
				-- 퀸슬라임 하나가 죽은 후 다른 하나가 안죽은채로 일정시간이 지나면 부활
				if Var["TopFloor"]["QueenRevivalStepSec"] <= Var["CurSec"]
				then
					DebugLog( "AtThisRoutine, YesQueenRevivalTiming" )
					local BossX, BossY = cObjectLocate( Var["Enemy"]["BossHandle"] )
					local QueenSlimeRegenInfo = RegenInfo["Mob"]["TopFloor"]["TwinQueenSlimes"][ 1 ]
					local QueenSlimeHandle = cMobRegen_Circle( MapIndex, QueenSlimeRegenInfo["Index"], BossX, BossY, QueenSlimeRegenInfo["radius"] )
					if QueenSlimeHandle ~= nil
					then
						DebugLog( "Revival : "..sSkillIndex..", Handle("..QueenSlimeHandle.."), No("..DeadQueenNo..")" )
--						cNoticeString( MapIndex, "Revival : "..sSkillIndex..", Handle("..QueenSlimeHandle.."), No("..DeadQueenNo..")" )
						Var["QueenSlimeHandle"][ DeadQueenNo ] = QueenSlimeHandle

						cSetAIScript ( MainLuaScriptPath, QueenSlimeHandle )
						cAIScriptFunc( QueenSlimeHandle, "Entrance", "SummonMobRoutine" )

						Var["Enemy"][ QueenSlimeHandle ] = { Index = Var["Enemy"][ Handle ]["Index"], x = Var["Enemy"][ Handle ]["x"], y = Var["Enemy"][ Handle ]["y"], dir = 0, }
					else
						ErrorLog( "Summon Queen Fail"..Var["Enemy"][ Handle ]["Index"] )
					end

					Var["TopFloor"]["QueenRevivalStepSec"] = nil
					QueenDeadCount = 0
				else
					-- 퀸 부활까지 얼마나 남았는지 출력
--					DebugLog( "Queen Revival Remain Sec : "..( Var["TopFloor"]["QueenRevivalStepSec"] - Var["CurSec"] ) )
				end
			end


			if QueenDeadCount == 1 and Var["TopFloor"]["QueenRevivalStepSec"] == nil
			then
				local RevivalInfo = QueenSlimeInfo["RevivalInfo"]
				if cGetAbstate( Handle, RevivalInfo["AbstateIndex"] ) == nil
				then
					DebugLog( "AtThisRoutine, NoQueenAbstate" )
					if cSetAbstate( Handle, RevivalInfo["AbstateIndex"], RevivalInfo["AbstateStrength"], RevivalInfo["AbstateKeepTime"] ) == nil
					then
						ErrorLog( "cSetAbstate To Queen : Failed" )
--						cNoticeString( MapIndex, "Queen("..Handle..") Abstate Fail" )
					else
--						cNoticeString( MapIndex, "Queen("..Handle..") Abstate Success" )
					end
					Var["TopFloor"]["QueenRevivalStepSec"] = Var["CurSec"] + RevivalInfo["RevivalSec"]
				else
	--				DebugLog( "AtThisRoutine, YesQueenAbstate" )
				end
			end

		else
			Var["TopFloor"]["QueenRevivalStepSec"] = nil
		end

		-- 퀸 슬라임의 힐
		if Var["Enemy"][ Handle ]["HealStepSec"] == nil
		then
			Var["Enemy"][ Handle ]["HealStepSec"] = Var["CurSec"]
		end

		if Var["Enemy"][ Handle ]["HealStepSec"] <= Var["CurSec"]
		then

			-- 힐 이펙트 핸들 보관 테이블 초기화
			if Var["HealEffect"] == nil
			then
				Var["HealEffect"] = {}

				for i = 1, #Var["QueenSlimeHandle"]
				do
					Var["HealEffect"][ i ] = {}
				end
			end

			-- 힐 이펙트 삭제 확실하게 한번 더 처리하기
			if Var["QueenSlimeHandle"] ~= nil
			then
				for i = 1, #Var["QueenSlimeHandle"]
				do
					if cIsObjectDead( Var["QueenSlimeHandle"][ i ] ) == 1
					then
						if Var["HealEffect"] ~= nil
						then

							if Var["HealEffect"][ i ]["Boss"] ~= nil
							then
								cNPCVanish( Var["HealEffect"][ i ]["Boss"] )
								DebugLog( "Effect Vanished : "..Var["HealEffect"][ i ]["Boss"] )
							end

							if Var["HealEffect"][ i ]["Queen"] ~= nil
							then
								cNPCVanish( Var["HealEffect"][ i ]["Queen"] )
								DebugLog( "Effect Vanished : "..Var["HealEffect"][ i ]["Queen"] )
							end

							Var["HealEffect"][ i ] = {}

						else
							ErrorLog( "Var[\"HealEffect\"] ~= nil" )
						end
					end
				end
			end

			-- 힐적용
			if Var["KQ_Difficulty"] == nil
			then
				Var["KQ_Difficulty"] = 3
			end

			cHeal( Var["Enemy"]["BossHandle"], QueenSlimeInfo["HealInfo"]["HealAmount"..Var["KQ_Difficulty"] ] )

			local sHealEffectIndex = QueenSlimeInfo["HealInfo"]["HealEffectIndex"]

			-- 이펙트가 없을때만 이펙트를 생성
			if Var["HealEffect"][ CurQueenNo ]["Queen"] == nil
			then
				-- 힐이펙트 to 퀸
				local QueenHealEffectHandle = cEffectRegen_Object( MapIndex, sHealEffectIndex, Handle, 3600000, 1, 1000 )

				if QueenHealEffectHandle ~= nil
				then
					Var["HealEffect"][ CurQueenNo ]["Queen"] = QueenHealEffectHandle
				else
					ErrorLog( "QueenHealEffectHandle is nil" )
				end
			end

			-- 이펙트가 없을때만 이펙트를 생성
			if Var["HealEffect"][ CurQueenNo ]["Boss"] == nil
			then
				-- 힐이펙트 to 엠퍼러
				local BossHealEffectHandle = cEffectRegen_Object( MapIndex, sHealEffectIndex, Var["Enemy"]["BossHandle"], 3600000, 1, 1000 )

				if BossHealEffectHandle ~= nil
				then
					Var["HealEffect"][ CurQueenNo ]["Boss"] = BossHealEffectHandle
				else
					ErrorLog( "BossHealEffectHandle is nil" )
				end
			end


			-- 다음 힐 시점 설정
			Var["Enemy"][ Handle ]["HealStepSec"] = Var["CurSec"] + QueenSlimeInfo["HealInfo"]["HealGapSec"]

		end

	else
		-- 잘못된 몹인덱스이므로 몹을 없애고 AI를 제거한다.
		ErrorLog( "MobIndex is invalid : "..Var["Enemy"][ Handle ]["Index"] )

		cNPCVanish( Handle )
		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		Var["RoutineTime"][ RoutineTimeIndex ] = nil
		return ReturnAI["END"]
	end

	-- 수명이 정해져 있는 몬스터인 경우 체크하여 수명이 다하면 자살처리
	if EmperorSlimeSkill[ sSkillIndex ]["MobLifeSec"] ~= nil
	then
		if Var["Enemy"][ Handle ]["DieStepSec"] <= Var["CurSec"]
		then
			if sSkillIndex == "TornadoEffect"
			then
				-- 토네이도는 없어지는 시간과 모션의 이상함 제거를 위해 소멸처리로 한다.
--				DebugLog( "Vanished : "..sSkillIndex..", Handle("..Handle..")" )
				cNPCVanish( Handle )
				cAIScriptSet( Handle )
				Var["Enemy"][ Handle ] = nil
				Var["RoutineTime"][ RoutineTimeIndex ] = nil
				return ReturnAI["END"]
			else
				-- 그 외의 몹은 수명이 다하면 자살한다.
--				DebugLog( "Suicided : "..sSkillIndex..", Handle("..Handle..")" )
				cMobSuicide( MapIndex, Handle )
				cAIScriptSet( Handle )
				Var["Enemy"][ Handle ] = nil
				Var["RoutineTime"][ RoutineTimeIndex ] = nil
				return ReturnAI["END"]
			end
		end
	end

	return ReturnAI["CPP"]

end

