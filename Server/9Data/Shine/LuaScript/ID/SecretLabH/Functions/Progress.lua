--------------------------------------------------------------------------------
--                    Secret Laboratory Progress Func                         --
--------------------------------------------------------------------------------

-- 던전 초기화
function InitDungeon( Var )
cExecCheck "InitDungeon"

	if Var == nil
	then
		return
	end

	-- 인스턴스 던전 시작 전에 플레이어의 첫 로그인을 기다린다.
	if Var["bPlayerMapLogin"] == nil
	then
		if Var["InitialSec"] + WAIT_PLAYER_MAP_LOGIN_SEC_MAX <= cCurrentSecond()
		then
			GoToFail( Var )
			return
		end

		return
	end


	if Var["InitDungeon"] == nil
	then
		DebugLog( "Start InitDungeon" )

		Var["InitDungeon"] = {}

		-- 층 사이에 있는 문 생성
		for i = 0, (#StepNameTable - 2)
		do
			local DoorTableIndex = nil

			DoorTableIndex = "Door"..i

			local CurRegenDoor = RegenInfo["Stuff"][ DoorTableIndex ]

			if CurRegenDoor ~= nil
			then
				local nCurDoorHandle = cDoorBuild( Var["MapIndex"], CurRegenDoor["Index"], CurRegenDoor["x"], CurRegenDoor["y"], CurRegenDoor["dir"], CurRegenDoor["scale"] )

				if nCurDoorHandle  ~= nil
				then
					cDoorAction( nCurDoorHandle , CurRegenDoor["Block"], "close" )

					-- 리젠 정보 보관
					Var["Door"][ nCurDoorHandle ] = CurRegenDoor

					-- 핸들 보관 : 접근용으로
					Var["Door"..i ] = nCurDoorHandle
				else
					ErrorLog( "InitDungeon::Door"..i.." was not created." )
				end
			end

		end

		-- 입구쪽 출구게이트 생성
		local RegenExitGate  = RegenInfo["Stuff"]["StartExitGate"]
		local nExitGateHandle = cDoorBuild( Var["MapIndex"], RegenExitGate["Index"], RegenExitGate["x"], RegenExitGate["y"], RegenExitGate["dir"], RegenExitGate["scale"] )

		if nExitGateHandle ~= nil
		then
			if cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil
			then
				ErrorLog( "InitDungeon::cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil" )
			end

			if cAIScriptFunc( nExitGateHandle, "NPCClick", "ExitGateClick" ) == nil
			then
				ErrorLog( "InitDungeon::cAIScriptFunc( nExitGateHandle, \"NPCClick\", \"ExitGateClick\" ) == nil" )
			end
		end

		-- 정해진 규칙에 의거한 층 별 패턴 셋팅
		--[[

		네임테이블을 하나씩 가져와서 총 패턴 개수를 구한다.
		패턴 이름과 순번은 해당 던전 내부 메모리에 셋팅한다.
		정해신 순서대로 하나씩 채택
		미리 배열을 만들어서 사용되기로 한 패턴은 체크를 해둬서 겹치지 않게 하나씩 고른다.
		그렇게 10개 패턴을 정렬한다.
		진행 시에는 정렬된 곳에서 하나씩 빼온다.

		]]

		-- 패턴을 각 층에 셋팅한 정보를 보관하는 테이블
		local PatternSettingTable = {}

		-- 각 패턴을 통합하여 순번을 매겨놓은 테이블
		local PatternPointerTable = {}

		-- 총 패턴 수
		local nPatternCount = 0
		for i = 1, #PatternNameTable
		do
			-- 총 개수 세기
			local sPattern = PatternNameTable[i]

			-- 통합순번과 각 순번 매칭
			for k = 1, #RegenInfo["Group"]["EachPattern"][ sPattern ]
			do
				PatternPointerTable[ nPatternCount + k ] = { PatternName = sPattern, PatternOrderNo = k }
			end

			nPatternCount = nPatternCount + #RegenInfo["Group"]["EachPattern"][ sPattern ]
		end

		DebugLog( "InitDungeon::Pattern pointer table was set - Size : "..#PatternPointerTable )

		local CheckPatternSelected = {}			-- 인덱스: 통합순번, 값: 체크 될 경우 true
		local nCheckPatternSelectedCount = 0 	-- 선택완료된 패턴의 수

		-- 패턴 지정( 층 개수 만큼 )
		while nCheckPatternSelectedCount < #FloorPatternInfoTable
		do
			for i = 1, #PatternPointerTable
			do
				-- 해당 순번에 맞는 패턴 종류가 골라졌으면 체크해보고 사용이 된거라면 사용 안된 스테이지가 선택될 때까지 찾는다.
				if PatternPointerTable[ i ]["PatternName"] == FloorPatternInfoTable[ nCheckPatternSelectedCount + 1 ]
				then
					if CheckPatternSelected[ i ] ~= true
					then
						nCurPatternSelected = i
						break
					else
						if i == #PatternPointerTable
						then
							ErrorLog( "InitDungeon::Pattern Setting is Failed(Logic or Data Error)" )
						end
					end
				else
					if i == #PatternPointerTable
					then
						ErrorLog( "InitDungeon::Pattern Setting is Failed(Logic or Data Error)" )
					end
				end
			end


			-- 통합순번과 순번매칭정보가 없으면 패턴 지정 불가하므로 해당 패턴 패스
			if PatternPointerTable[ nCurPatternSelected ] ~= nil
			then
				-- 이미 선택된 것은 제외
				if CheckPatternSelected[ nCurPatternSelected ] ~= true
				then
					-- 패턴 선택
					PatternSettingTable[ nCheckPatternSelectedCount + 1 ] = PatternPointerTable[ nCurPatternSelected ]
					-- 패턴 선택 여부 체크
					CheckPatternSelected[ nCurPatternSelected ] = true
					DebugLog( "InitDungeon::Pattern is Selected ( "..PatternPointerTable[ nCurPatternSelected ]["PatternName"].." "..PatternPointerTable[ nCurPatternSelected ]["PatternOrderNo"].." )" )
					-- 카운팅
					nCheckPatternSelectedCount = nCheckPatternSelectedCount + 1
				end
			end
		end

		-- 특별보상 여부 설정
		Var["bSpecialRewardMode"] = true

		-- 메모리에 패턴 셋팅 정보 저장
		Var["StageInfo"]["PatternSetting"] = PatternSettingTable


		-- 대기시간 설정
		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"] + DelayTime["AfterInit"]
	end

	-- 대기 후 다음 단계로
	if Var["InitDungeon"]["WaitSecDuringInit"] <= Var["CurSec"]
	then
		cDoorAction( Var["Door0"], Var["Door"][ Var["Door0"] ]["Block"], "open" )
		GoToNextStep( Var )
		Var["InitDungeon"] = nil
		DebugLog( "End InitDungeon" )
		return
	end

end


-- 각 층 셋팅 및 진행
function EachFloor( Var )
cExecCheck "EachFloor"

	if Var == nil
	then
		return
	end

	if Var["EachFloor"] == nil
	then
		Var["EachFloor"] = {}
	end


	-- 단계 번호 설정
	if Var["EachFloor"]["StepNumber"] == nil
	then
		Var["EachFloor"]["StepNumber"] = 1
	end


	-- 단계이름 받아오기
	local CurStepNo = Var["EachFloor"]["StepNumber"]	-- ex) 1
	local CurStep = StepNameTable[ CurStepNo ]			-- ex) Floor01

	-- 리젠 중심 좌표 가져오기
	local CurRegenCoord = RegenInfo["Coord"][ CurStepNo ]


	-- 패턴이 셋팅 되지 않았으면 진행 불가
	if Var["StageInfo"]["PatternSetting"] == nil
	then
		return
	end

	if Var["StageInfo"]["PatternSetting"][ CurStepNo ] == nil
	then
		return
	end

	local CurPatternInfo = Var["StageInfo"]["PatternSetting"][ CurStepNo ]


	-- 초기화 조건 셋팅
	local bInitFlag = false

	if Var["EachFloor"..CurStepNo ] == nil
	then
		bInitFlag = true
	else
		if Var["EachFloor"..CurStepNo ]["bEntranceArea"] == false
		then
			bInitFlag = true
		end
	end


	-- 각 단계 초기 설정
	if bInitFlag == true
	then


		if Var["EachFloor"..CurStepNo ] == nil
		then
			DebugLog( "Start EachFloor "..CurStepNo )
			Var["EachFloor"..CurStepNo ] = {}

			-- 페이스컷 단계 구분용 변수 설정
			Var["EachFloor"..CurStepNo ]["BeforeDialogStepSec"] = Var["CurSec"]
			Var["EachFloor"..CurStepNo ]["BeforeDialogStepNo"] = 1

			Var["EachFloor"..CurStepNo ]["SemiBossAwakenedDialogStepSec"] = Var["CurSec"]
			Var["EachFloor"..CurStepNo ]["SemiBossAwakenedDialogStepNo"] = 1

			Var["EachFloor"..CurStepNo ]["BossSummonDialogStepSec"] = Var["CurSec"]
			Var["EachFloor"..CurStepNo ]["BossSummonDialogStepNo"] = 1

			Var["EachFloor"..CurStepNo ]["HelpUsChatStepSec"] = Var["CurSec"]

			-- 페이스컷 종료 여부 설정
			Var["EachFloor"..CurStepNo ]["bBeforeDialogEnd"] 			= false
			Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedDialogEnd"] 	= nil	-- 실험중인 몹이 깨어나면 false로 셋팅
			Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] 		= nil	-- 보스가 소환하면 false로 셋팅하여 진행
			Var["EachFloor"..CurStepNo ]["nHP_BossSummonDialog"] 		= nil	-- 보스가 소환하면 해당 스킬의 HP정보를 입력하여 진행

			-- 진행단계 설정 플래그
			Var["EachFloor"..CurStepNo ]["bMobEliminated"] 			= false -- 실험중인 몹을 제외한 몹이 모두 죽었을 경우 True
			Var["EachFloor"..CurStepNo ]["bSemiBossWarned60Sec"] 	= false	-- 입장한지 2분 후 경고 후 true
			Var["EachFloor"..CurStepNo ]["bSemiBossWarned30Sec"] 	= false -- 입장한지 2분 30초 후 경고 후 true
			Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedWarn"] 	= false	-- 실험중인 몹이 깨어났d으면 경고 후 true
			Var["EachFloor"..CurStepNo ]["bSemiBossAwakened"] 		= false	-- 실험중인 몹이 깨어났는가

		end

		Var["EachFloor"..CurStepNo ]["bCanGenerateMonsters"] = true

		-- 타임어택 패턴에서 첫 입장 체크( 처음 입장이 인식 될 때 까지만 함 )
		if CurPatternInfo["PatternName"] == "Pattern_TimeAttack"
		then
			Var["EachFloor"..CurStepNo ]["bCanGenerateMonsters"] = false

			if Var["EachFloor"..CurStepNo ]["bEntranceArea"] == nil
			then
				Var["EachFloor"..CurStepNo ]["bEntranceArea"] = false
			end

			local EntranceArea = AreaIndexTable[ CurPatternInfo["PatternOrderNo"] ]
			if EntranceArea ~= nil
			then
				local InBossAreaHandleList = { cGetAreaObjectList( Var["MapIndex"], EntranceArea, ObjectType["Player"] ) }

				if #InBossAreaHandleList > 0
				then
					Var["EachFloor"..CurStepNo ]["bCanGenerateMonsters"] = true
					Var["EachFloor"..CurStepNo ]["bEntranceArea"] = true
					if cNoticeRedWarningCode( Var["MapIndex"], SemiBossWarning["Entrance"]["Code"] ) == nil
					then
						ErrorLog( "EachFloor"..CurStepNo.."::cNoticeRedWarningCode is Failed - Entrance" )
					end
				else
				-- 아직 해당 구역에 입장 안함
				end
			else
				ErrorLog( "EachFloor"..CurStepNo.."::Area Info does not exist!" )
				return
			end
		end


		if CurPatternInfo["PatternName"] == "Pattern_KillBoss"
		then
			if Var["BossBattle"] == nil
			then
				Var["BossBattle"] = {}
			end
		else
			Var["BossBattle"] = nil
		end


		if Var["EachFloor"..CurStepNo ]["bCanGenerateMonsters"] == true
		then

			-- 단일 몹 젠
			local CurMobRegen = RegenInfo["Mob"]["EachPattern"][ CurPatternInfo["PatternName"] ][ CurPatternInfo["PatternOrderNo"] ]

			if CurMobRegen ~= nil
			then
				for MobType, MobRegenInfo in pairs ( CurMobRegen )
				do
					local MobHandle = cMobRegen_XY( Var["MapIndex"], MobRegenInfo["Index"], RegenInfo["Coord"][ CurStepNo ]["x"], RegenInfo["Coord"][ CurStepNo ]["y"], MobRegenInfo["dir"] )

					if MobHandle ~= nil
					then

						Var["Enemy"][ MobHandle ] = { Index = MobRegenInfo["Index"], x = RegenInfo["Coord"][ CurStepNo ]["x"], y = RegenInfo["Coord"][ CurStepNo ]["y"], radius = MobRegenInfo["radius"] }

						Var["RoutineTime"][ MobHandle ] = cCurrentSecond()
						cSetAIScript ( MainLuaScriptPath, MobHandle )

						if MobType == "SemiBoss"
						then
							Var["EachFloor"..CurStepNo ]["SemiBossHandle"] = MobHandle

							-- 타임어택 셋팅
							if MobRegenInfo["Index"] == "Lab_Slime"
							then
								cSetAbstate( MobHandle, SemiBossAbstate["TimeAttackMini"]["Index"], SemiBossAbstate["TimeAttackMini"]["Strength"], SemiBossAbstate["TimeAttackMini"]["KeepTime"] )
							else
								cSetAbstate( MobHandle, SemiBossAbstate["TimeAttack"]["Index"], SemiBossAbstate["TimeAttack"]["Strength"], SemiBossAbstate["TimeAttack"]["KeepTime"] )
								cAnimate( MobHandle, "start", "&TimeAttack_Stand" )
							end

							cAIScriptFunc( MobHandle, "Entrance", "SemiBossRoutine" )
						elseif MobType == "MidBoss"
						then
							Var["StageInfo"]["BossTypeNo"] = 1
							Var["EachFloor"..CurStepNo ]["MidBossHandle"] = MobHandle
							cAIScriptFunc( MobHandle, "Entrance",   "BossRoutine" )
							cAIScriptFunc( MobHandle, "MobDamaged", "BossDamaged" )
						elseif MobType == "Boss"
						then
							Var["StageInfo"]["BossTypeNo"] = 2
							Var["EachFloor"..CurStepNo ]["BossHandle"] = MobHandle
							cAIScriptFunc( MobHandle, "Entrance",   "BossRoutine" )
							cAIScriptFunc( MobHandle, "MobDamaged", "BossDamaged" )
						end

					end
				end
			end


			-- 몹 그룹 젠
			local CurGroupRegen = RegenInfo["Group"]["EachPattern"][ CurPatternInfo["PatternName"] ][ CurPatternInfo["PatternOrderNo"] ]

			if CurGroupRegen ~= nil
			then
				for i = 1, #CurGroupRegen
				do
					cGroupRegenInstance( Var["MapIndex"], CurGroupRegen[ i ] )
				end
			end


			-- 감옥 젠 : 최종 보스전에 생성됨
			if CurStepNo == #StepNameTable - 1
			then
				local CurRegenPrison   = RegenInfo["Stuff"]["Prison"]
				local nCurPrisonHandle = cDoorBuild( Var["MapIndex"], CurRegenPrison["Index"], CurRegenPrison["x"], CurRegenPrison["y"], CurRegenPrison["dir"], CurRegenPrison["scale"] )

				if nCurPrisonHandle  ~= nil
				then
					cDoorAction( nCurPrisonHandle , CurRegenPrison["Block"], "close" )

					Var["Prison"] = {}
					Var["Prison"]["RegenInfo"] 	= CurRegenPrison
					Var["Prison"]["Handle"] 	= nCurPrisonHandle
					Var["Prison"]["bOpened"] 	= false

					if cSetAIScript ( MainLuaScriptPath, nCurPrisonHandle ) == nil
					then
						ErrorLog( "EachFloor "..CurStepNo.."::cSetAIScript ( MainLuaScriptPath, nCurPrisonHandle ) == nil" )
					end

					if cAIScriptFunc( nCurPrisonHandle, "NPCClick", "PrisonClick" ) == nil
					then
						ErrorLog( "EachFloor "..CurStepNo.."::cAIScriptFunc( nCurPrisonHandle, \"NPCClick\", \"PrisonClick\" ) == nil" )
					end

				else
					ErrorLog( "EachFloor "..CurStepNo.."::Prison"..i.." was not created." )
				end
			end


			-- 시간 체크
			Var["EachFloor"..CurStepNo ]["WaitMobGenSec"]  = Var["CurSec"] + DelayTime["WaitAfterGenMob"]
			Var["EachFloor"..CurStepNo ]["TimeAttack_R60"] = Var["CurSec"] + SemiBossWarning["Remain_60_Sec"]["OccurSec"]
			Var["EachFloor"..CurStepNo ]["TimeAttack_R30"] = Var["CurSec"] + SemiBossWarning["Remain_30_Sec"]["OccurSec"]

		end -- 몹 젠 설정 if문 끝위치///////

	end -- 초기설정 끝////////////


	-- 타임어택 시작 후부터 체크하는 부분
	if CurPatternInfo["PatternName"] == "Pattern_TimeAttack"
	then

		if Var["EachFloor"..CurStepNo ]["bEntranceArea"] == true
		then

			if Var["Enemy"][ Var["EachFloor"..CurStepNo ]["SemiBossHandle"] ] ~= nil
			then

				-- 실험중인 몹이 깨어남
				if Var["EachFloor"..CurStepNo ]["bSemiBossAwakened"] == true
				then
					if Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedDialogEnd"] == nil
					then
						Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedDialogEnd"] = false
					end
				end

				-- 1분전 경고
				if Var["EachFloor"..CurStepNo ]["bSemiBossWarned60Sec"] == false
				then
					if Var["CurSec"] >= Var["EachFloor"..CurStepNo ]["TimeAttack_R60"]
					then
						if cNoticeRedWarningCode( Var["MapIndex"], SemiBossWarning["Remain_60_Sec"]["Code"] ) == nil
						then
							ErrorLog( "EachFloor"..CurStepNo.."::cNoticeRedWarningCode is Failed - Remain1min" )
						end
						Var["EachFloor"..CurStepNo ]["bSemiBossWarned60Sec"] = true
					end
				end

				-- 30초전 경고
				if Var["EachFloor"..CurStepNo ]["bSemiBossWarned30Sec"] == false
				then
					if Var["CurSec"] >= Var["EachFloor"..CurStepNo ]["TimeAttack_R30"]
					then
						if cNoticeRedWarningCode( Var["MapIndex"], SemiBossWarning["Remain_30_Sec"]["Code"] ) == nil
						then
							ErrorLog( "EachFloor"..CurStepNo.."::cNoticeRedWarningCode is Failed - Remain30Sec" )
						end
						Var["EachFloor"..CurStepNo ]["bSemiBossWarned30Sec"] = true
					end
				end

				-- 깨어남 경고
				if Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedWarn"] == false
				then
					if Var["EachFloor"..CurStepNo ]["bSemiBossAwakened"] == true
					then
						if cNoticeRedWarningCode( Var["MapIndex"], SemiBossWarning["Awakened"]["Code"] ) == nil
						then
							ErrorLog( "EachFloor"..CurStepNo.."::cNoticeRedWarningCode is Failed - BeAwakened" )
						end
						Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedWarn"] = true
					end
				end

			else
				--ErrorLog( "EachFloor"..CurStepNo.."::Egg Info does not exist." )
			end

		end

	end



	-- 채팅
	local CurChat = ChatInfo["EachPattern"][ CurPatternInfo["PatternName"] ][ CurPatternInfo["PatternOrderNo"] ]

	-- 전투 전
	if CurChat["BeforeDialog"] ~= nil
	then
		if Var["EachFloor"..CurStepNo ]["bBeforeDialogEnd"] == false
		then
			local nCurDialogNo = Var["EachFloor"..CurStepNo ]["BeforeDialogStepNo"]

			if nCurDialogNo <= #CurChat["BeforeDialog"]
			then
				if Var["EachFloor"..CurStepNo ]["BeforeDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["BeforeDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["BeforeDialog"][ nCurDialogNo ]["Index"] )

					Var["EachFloor"..CurStepNo ]["BeforeDialogStepNo"] = Var["EachFloor"..CurStepNo ]["BeforeDialogStepNo"] + 1
					Var["EachFloor"..CurStepNo ]["BeforeDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
				return
			else
				-- 페이스컷 종료
				Var["EachFloor"..CurStepNo ]["bBeforeDialogEnd"] = true
			end
		end
	else
		-- 페이스컷 자체가 없을 때
		Var["EachFloor"..CurStepNo ]["bBeforeDialogEnd"] = true
	end


	-- 타임어택 모드일 경우 입장을 해야 진행을 시킨다.
	if CurPatternInfo["PatternName"] == "Pattern_TimeAttack"
	then
		if Var["EachFloor"..CurStepNo ]["bEntranceArea"] ~= true
		then
			return
		end
	end


	-- 감옥에 갇힌 아이들이 구해달라고 하는 말들
	if CurChat["HelpUsChat"] ~= nil
	then
		local nCurDialogNo = cRandomInt( 1, #CurChat["HelpUsChat"] )

		if nCurDialogNo <= #CurChat["HelpUsChat"]
		then
			if Var["EachFloor"..CurStepNo ]["HelpUsChatStepSec"] <= Var["CurSec"]
			then
				cMobChat( Var["Prison"]["Handle"], ChatInfo["ScriptFileName"], CurChat["HelpUsChat"][ nCurDialogNo ]["Index"], true )

				Var["EachFloor"..CurStepNo ]["HelpUsChatStepSec"] = Var["CurSec"] + DelayTime["GapHelpUsChat"]
			end
		end
	end


	-- 실험중인 몹이 깨어났을 때
	if CurChat["SemiBossAwakenedDialog"] ~= nil
	then
		if Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedDialogEnd"] == false
		then
			local nCurDialogNo = Var["EachFloor"..CurStepNo ]["SemiBossAwakenedDialogStepNo"]

			if nCurDialogNo <= #CurChat["SemiBossAwakenedDialog"]
			then
				if Var["EachFloor"..CurStepNo ]["SemiBossAwakenedDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["SemiBossAwakenedDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["SemiBossAwakenedDialog"][ nCurDialogNo ]["Index"] )

					Var["EachFloor"..CurStepNo ]["SemiBossAwakenedDialogStepNo"] = Var["EachFloor"..CurStepNo ]["SemiBossAwakenedDialogStepNo"] + 1
					Var["EachFloor"..CurStepNo ]["SemiBossAwakenedDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
				return
			else
				-- 페이스컷 종료
				Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedDialogEnd"] = true
			end
		end
	else
		-- 페이스컷 자체가 없을 때
		Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedDialogEnd"] = true
	end


	-- 보스가 몹을 소환했을 때
	if Var["EachFloor"..CurStepNo ]["nHP_BossSummonDialog"] ~= nil
	then
		local sDialogIndex = "Summon"..Var["EachFloor"..CurStepNo ]["nHP_BossSummonDialog"].."Dialog"
		if CurChat[ sDialogIndex ] ~= nil
		then
			if Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] == false
			then
				local nCurDialogNo = Var["EachFloor"..CurStepNo ]["BossSummonDialogStepNo"]

				if nCurDialogNo <= #CurChat[ sDialogIndex ]
				then
					if Var["EachFloor"..CurStepNo ]["BossSummonDialogStepSec"] <= Var["CurSec"]
					then
						cMobDialog( Var["MapIndex"], CurChat[ sDialogIndex ][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat[ sDialogIndex ][ nCurDialogNo ]["Index"] )
						DebugLog( "EachFloor"..CurStepNo .."::SummonDialog-"..Var["EachFloor"..CurStepNo ]["nHP_BossSummonDialog"].."/"..nCurDialogNo )

						Var["EachFloor"..CurStepNo ]["BossSummonDialogStepNo"] = Var["EachFloor"..CurStepNo ]["BossSummonDialogStepNo"] + 1
						Var["EachFloor"..CurStepNo ]["BossSummonDialogStepSec"] = Var["CurSec"] + DelayTime["GapSummonDialog"]
					end

					-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
					return
				else
					-- 페이스컷 종료
					Var["EachFloor"..CurStepNo ]["BossSummonDialogStepNo"] = 1
					Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] = true
				end
			end
		else
			-- 페이스컷 자체가 없을 때
			Var["EachFloor"..CurStepNo ]["BossSummonDialogStepNo"] = 1
			Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] = true
		end
	end


	-- 몹 전멸체크
	if Var["EachFloor"..CurStepNo ]["bMobEliminated"] == false
	then
		if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) <= 0
		then
			Var["EachFloor"..CurStepNo ]["bMobEliminated"] = true
		end

		return
	else
		-- 전투 끝 이후
		if CurChat["AfterDialog"] ~= nil
		then
			if Var["EachFloor"..CurStepNo ]["bAfterDialogEnd"] == false
			then
				local nCurDialogNo = Var["EachFloor"..CurStepNo ]["AfterDialogStepNo"]

				if nCurDialogNo <= #CurChat["AfterDialog"]
				then
					if Var["EachFloor"..CurStepNo ]["AfterDialogStepSec"] <= Var["CurSec"]
					then
						cMobDialog( Var["MapIndex"], CurChat["AfterDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["AfterDialog"][ nCurDialogNo ]["Index"] )

						Var["EachFloor"..CurStepNo ]["AfterDialogStepNo"] = Var["EachFloor"..CurStepNo ]["AfterDialogStepNo"] + 1
						Var["EachFloor"..CurStepNo ]["AfterDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
					end

					-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
					return
				else
					-- 페이스컷 종료
					Var["EachFloor"..CurStepNo ]["bAfterDialogEnd"] = true
				end
			end
		else
			-- 페이스컷 자체가 없을 때
			Var["EachFloor"..CurStepNo ]["bAfterDialogEnd"] = true
		end
	end


	-- Next Case : 해당 층의 몹 전멸 후 클리어 페이스컷 여부에 따라 그 페이스 컷이 종료하면.
	if Var["EachFloor"..CurStepNo ]["WaitMobGenSec"] <= Var["CurSec"]
	then
		if Var["EachFloor"..CurStepNo ]["bAfterDialogEnd"] == true and Var["EachFloor"..CurStepNo ]["bMobEliminated"] == true
		then
			-- 클리어 액션
			if Var["Door"..CurStepNo ] ~= nil
			then
				cDoorAction( Var["Door"..CurStepNo ], Var["Door"][ Var["Door"..CurStepNo ] ]["Block"], "open" )
			end

			-- 다음 단계로
			Var["EachFloor"..CurStepNo ] = nil
			Var["EachFloor"]["StepNumber"] = CurStepNo + 1

			DebugLog( "End EachFloor "..CurStepNo )


			if CurStepNo == #StepNameTable - 1
			then
				Var["EachFloor"] = nil
				GoToNextStep( Var )
				return
			end

			return
		end
	end

end


-- 아이들 구출
function RescuedChildren( Var )
cExecCheck "RescuedChildren"

	if Var == nil
	then
		return
	end


	local nBossType = Var["StageInfo"]["BossTypeNo"]

	if Var["Prison"] == nil
	then
		return
	end

	if Var["Prison"]["bOpened"] == true
	then
		cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )
	else
		return
	end


	if Var["RescuedChildren"] == nil
	then
		DebugLog( "RescuedChildren::Start" )

		Var["RescuedChildren"] = {}

		-- 특별한 보상 상자 젠
		if Var["bSpecialRewardMode"] == true
		then
			local RewardBoxInfo = RegenInfo["Mob"]["RescuedChildren"]["SpecialRewardBox"]
			local nRewardBoxHandle = cMobRegen_XY( Var["MapIndex"], RewardBoxInfo["Index"], RewardBoxInfo["x"], RewardBoxInfo["y"], RewardBoxInfo["dir"] )
			if nRewardBoxHandle == nil
			then
				ErrorLog( "RescuedChildren::SpecialRewardBox was not created - SpecialRewardMode" )
			end
		end

		-- 아이들 젠
		for Index, ChildRegenInfo in pairs( RegenInfo["NPC"]["RescuedChildren"] )
		do
			if ChildRegenInfo ~= nil
			then
				local nChildHandle = cMobRegen_XY( Var["MapIndex"], ChildRegenInfo["Index"], ChildRegenInfo["x"], ChildRegenInfo["y"], ChildRegenInfo["dir"] )
				if nChildHandle ~= nil
				then
					Var["Friend"][ ChildRegenInfo["Index"] ] = nChildHandle
					DebugLog( "RescuedChildren::Child Gen : "..Index.."-"..ChildRegenInfo["Index"].."-"..nChildHandle )
				else
					ErrorLog( "RescuedChildren::Child Gen Failed" )
				end
			end
		end

		-- 채팅 단계 설정용 변수 셋팅
		Var["RescuedChildren"]["PrisonVanishStepSec"] = Var["CurSec"] + DelayTime["BeforePrisonVanish"]

		Var["RescuedChildren"]["SequentialDialogStepSec"] = Var["CurSec"]
		Var["RescuedChildren"]["SequentialDialogStepNo"] = 1
		Var["RescuedChildren"]["AfterAnimationChatStepSec"] = Var["CurSec"]
		Var["RescuedChildren"]["AfterAnimationChatStepNo"] = 1

		Var["RescuedChildren"]["ChildrenRunToExitStepSec"] = Var["CurSec"]
		Var["RescuedChildren"]["ChildrenVanishStepSec"] = Var["CurSec"]


		Var["RescuedChildren"]["bPrisonVanishEnd"] = false
		Var["RescuedChildren"]["bSequentialDialogEnd"] = false
		Var["RescuedChildren"]["bAfterAnimationChatEnd"] = nil -- 애니메이션 끝나면 false로 바뀌어 실행
		Var["RescuedChildren"]["bChildrenRunToExitEnd"] = nil -- 아이들 이야기 끝나면 false로 바뀌어 실행
		Var["RescuedChildren"]["bChildrenVanishEnd"] = nil -- 아이들 달리기 끝나면 false로 바뀌어 실행

	end

---------------------------------------------------------------------------------------------------------------------------------------------------
	-- 감옥 사라지기
	if Var["RescuedChildren"]["bPrisonVanishEnd"] == false
	then
		if Var["RescuedChildren"]["PrisonVanishStepSec"] <= Var["CurSec"]
		then
			cAIScriptSet( Var["Prison"]["Handle"] )
			cNPCVanish( Var["Prison"]["Handle"] )
			Var["RescuedChildren"]["bPrisonVanishEnd"] = true
			DebugLog( "RescuedChildren::Prison was vanished." )
		end
	end
---------------------------------------------------------------------------------------------------------------------------------------------------
	-- 애니메이션
	if Var["RescuedChildren"]["bSequentialDialogEnd"] == true and Var["RescuedChildren"]["bAfterAnimationChatEnd"] == nil
	then
		for Index, AnimationInfo in pairs ( NPC_Animation )
		do
			if AnimationInfo ~= nil
			then
				local nHandle = Var["Friend"][ AnimationInfo["ActorIndex"] ]
				if nHandle == nil
				then
					ErrorLog( "RescuedChildren::Animation NPC Handle does not exist." )
				else
					cAnimate( nHandle, "start", AnimationInfo["Index"] )
					Var["RescuedChildren"]["AfterAnimationChatStepSec"] = Var["CurSec"] + DelayTime["AnimationTime"] -- 애니메이션이 다 돌고나서 애들이 말하게 하기 위함.
				end
			end
		end

		Var["RescuedChildren"]["bAfterAnimationChatEnd"] = false
	end

	-- 구출된 아이들의 이야기가 끝나고 달리기 모드로 셋팅
	if Var["RescuedChildren"]["bAfterAnimationChatEnd"] == true and Var["RescuedChildren"]["bChildrenRunToExitEnd"] == nil
	then
		Var["RescuedChildren"]["bChildrenRunToExitEnd"] = false
		Var["RescuedChildren"]["ChildrenRunToExitStepSec"] = Var["CurSec"] + DelayTime["BeforeChildrenRun"]
	end

	-- 아이들이 달리다 사라지는 모드로 셋팅
	if Var["RescuedChildren"]["bChildrenRunToExitEnd"] == true and Var["RescuedChildren"]["bChildrenVanishEnd"] == nil
	then
		Var["RescuedChildren"]["bChildrenVanishEnd"] = false
		Var["RescuedChildren"]["ChildrenVanishStepSec"] = Var["CurSec"] + DelayTime["AfterChildrenRun"]
	end

---------------------------------------------------------------------------------------------------------------------------------------------------
	-- 채팅
	local CurChat = ChatInfo["RescuedChildren"]

	-- 감옥이 열리자마자
	if CurChat["SequentialDialog"] ~= nil
	then
		if Var["RescuedChildren"]["bSequentialDialogEnd"] == false
		then
			local nCurDialogNo = Var["RescuedChildren"]["SequentialDialogStepNo"]

			if nCurDialogNo <= #CurChat["SequentialDialog"]
			then
				if Var["RescuedChildren"]["SequentialDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["SequentialDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["SequentialDialog"][ nCurDialogNo ]["Index"] )

					Var["RescuedChildren"]["SequentialDialogStepNo"] = Var["RescuedChildren"]["SequentialDialogStepNo"] + 1
					Var["RescuedChildren"]["SequentialDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
				return
			else
				-- 페이스컷 종료
				Var["RescuedChildren"]["bSequentialDialogEnd"] = true
			end
		end
	else
		-- 페이스컷 자체가 없을 때
		Var["RescuedChildren"]["bSequentialDialogEnd"] = true
	end


	-- 아이 한명의 애니메이션이 실행되고나서..
	if CurChat["AfterAnimationChat"] ~= nil
	then
		if Var["RescuedChildren"]["bAfterAnimationChatEnd"] == false
		then
			local nCurDialogNo = Var["RescuedChildren"]["AfterAnimationChatStepNo"]

			if nCurDialogNo <= #CurChat["AfterAnimationChat"]
			then
				if Var["RescuedChildren"]["AfterAnimationChatStepSec"] <= Var["CurSec"]
				then
					local nHandle = Var["Friend"][ CurChat["AfterAnimationChat"][ nCurDialogNo ]["SpeakerIndex"] ]
					if nHandle == nil
					then
						ErrorLog( "RescuedChildren::Animation NPC Handle does not exist." )
					else
						if nCurDialogNo == 1
						then
							cAnimate( nHandle, "stop" )
						end
						cMobChat( nHandle, ChatInfo["ScriptFileName"], CurChat["AfterAnimationChat"][ nCurDialogNo ]["Index"], true )
					end

					Var["RescuedChildren"]["AfterAnimationChatStepNo"] = Var["RescuedChildren"]["AfterAnimationChatStepNo"] + 1
					Var["RescuedChildren"]["AfterAnimationChatStepSec"] = Var["CurSec"] + DelayTime["GapChildrenChat"]
				end

				-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
				return
			else
				-- 페이스컷 종료
				Var["RescuedChildren"]["bAfterAnimationChatEnd"] = true
			end
		end
	else
		-- 페이스컷 자체가 없을 때
		Var["RescuedChildren"]["bAfterAnimationChatEnd"] = true
	end


	-- 아이들 달리기
	if NPC_RunTo ~= nil
	then
		if Var["RescuedChildren"]["bChildrenRunToExitEnd"] == false
		then
			if Var["RescuedChildren"]["ChildrenRunToExitStepSec"] <= Var["CurSec"]
			then
				for Index, RunInfo in pairs ( NPC_RunTo )
				do
					if RunInfo ~= nil
					then
						if Var["Friend"][ RunInfo["ActorIndex"] ] ~= nil
						then
							if cRunTo( Var["Friend"][ RunInfo["ActorIndex"] ], RunInfo["x"], RunInfo["y"], 1000 ) == nil
							then
								ErrorLog( "RescuedChildren::"..RunInfo["ActorIndex"].."-cRunTo was failed." )
							end
						else
							ErrorLog( "RescuedChildren::RunMode - "..RunInfo["ActorIndex"].." does not exist." )
						end
					end
				end

				Var["RescuedChildren"]["bChildrenRunToExitEnd"] = true
			end

			-- 달리기 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
			return
		end
	else
		-- 달리기 정보가 없을 떄
		Var["RescuedChildren"]["bChildrenRunToExitEnd"] = true
	end


	-- 아이들 사라지기(귀가함-_-;)
	if Var["RescuedChildren"]["bChildrenVanishEnd"] == false
	then
		if Var["RescuedChildren"]["ChildrenVanishStepSec"] <= Var["CurSec"]
		then
			for Index, ChildHandle in pairs ( Var["Friend"] )
			do
				cNPCVanish( ChildHandle )
			end

			Var["RescuedChildren"]["bChildrenVanishEnd"] = true
		end

		-- 귀가 타이밍이 될 때 까지 대기
		return
	end


	-- 아이들이 다 사라지면 출구 게이트로 나갈 수 있음
	if Var["RescuedChildren"]["bChildrenVanishEnd"] == true
	then
		-- 출구쪽 출구게이트 생성
		local RegenExitGate  = RegenInfo["Stuff"]["EndExitGate"]
		local nExitGateHandle = cDoorBuild( Var["MapIndex"], RegenExitGate["Index"], RegenExitGate["x"], RegenExitGate["y"], RegenExitGate["dir"], RegenExitGate["scale"] )

		if nExitGateHandle ~= nil
		then
			if cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil
			then
				ErrorLog( "ReturnToHome::cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil" )
			end

			if cAIScriptFunc( nExitGateHandle, "NPCClick", "ExitGateClick" ) == nil
			then
				ErrorLog( "ReturnToHome::cAIScriptFunc( nExitGateHandle, \"NPCClick\", \"ExitGateClick\" ) == nil" )
			end
		end

		Var["RescuedChildren"] = nil
		Var["Prison"] = nil
		Var["Friend"] = nil
		GoToNextStep( Var )
		DebugLog( "RescuedChildren::End" )
	end

end


-- 킹덤 퀘스트 클리어 : 이 ID 에선 기능 없음
function QuestSuccess( Var )
cExecCheck "QuestSuccess"

	if Var == nil
	then
		return
	end

	GoToNextStep( Var )
	DebugLog( "QuestSuccess::End" )

end


-- 킹덤 퀘스트 실패 : ID 에선 기능 없음
function QuestFailed( Var )
cExecCheck "QuestFailed"

	if Var == nil
	then
		return
	end

	GoToNextStep( Var )
	DebugLog( "QuestFailed::End" )

end


-- 귀환 : ID 에선 기능 없음
function ReturnToHome( Var )
cExecCheck "ReturnToHome"

	if Var == nil
	then
		return
	end

	GoToNextStep( Var )
	DebugLog( "End ReturnToHome" )

end


-- 스텝 구분을 위한 던전 진행 함수 리스트
ID_StepsList =
{
	{ Function = InitDungeon,  		Name = "InitDungeon",  		},
	{ Function = EachFloor,    		Name = "EachFloor",    		},
	{ Function = RescuedChildren,   Name = "RescuedChildren",   },
	{ Function = QuestSuccess, 		Name = "QuestSuccess", 		},
	{ Function = QuestFailed,  		Name = "QuestFailed",  		},
	{ Function = ReturnToHome, 		Name = "ReturnToHome", 		},
}


-- 역참조 리스트
ID_StepsIndexList =
{
}

for index, funcValue in pairs ( ID_StepsList )
do
	ID_StepsIndexList[ funcValue["Name"] ] = index
end
