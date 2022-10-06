--------------------------------------------------------------------------------
--                       Crystal Castle Progress Func                         --
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
		랜덤함수를 이용하여 순환방식으로 하나씩 채택
		미리 배열을 만들어서 사용되기로 한 패턴은 체크를 해둬서 겹치지 않게 하나씩 고른다.
		그렇게 9개 패턴을 고르고 보스도 골라 놓는다.
		이제 거기서 빼온다. 패턴 이름과 순번을 해당 던전 내부 메모리에 저장해놓는다.

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
			for k = 1, #RegenInfo["Group"][ sPattern ]
			do
				PatternPointerTable[ nPatternCount + k ] = { PatternName = sPattern, PatternOrderNo = k }
			end

			nPatternCount = nPatternCount + #RegenInfo["Group"][ sPattern ]
		end


		local CheckPatternSelected = {}			-- 인덱스: 통합순번, 값: 체크 될 경우 true
		local nCheckPatternSelectedCount = 0 	-- 선택완료된 패턴의 수

		-- 패턴 지정( 층 개수 만큼 )
		while nCheckPatternSelectedCount < #StepNameTable - 2
		do
			local nCurPatternSelected = cRandomInt( 1, nPatternCount ) -- 잠시 패턴의 통합순번을 랜덤으로 선택

			-- 통합순번과 순번매칭정보가 없으면 패턴 지정 불가하므로 해당 패턴 패스
			if PatternPointerTable[ nCurPatternSelected ] ~= nil
			then
				-- 이미 선택된 것은 제외
				if CheckPatternSelected[ nCurPatternSelected ] ~= true
				then
					-- 최초 5개 층은 Pattern_KamarisTrap 을 제외함
					DebugLog( "InitDungeon::Pattern is Tried ( "..PatternPointerTable[ nCurPatternSelected ]["PatternName"].." "..PatternPointerTable[ nCurPatternSelected ]["PatternOrderNo"].." )" )
					if nCheckPatternSelectedCount >= 5 or PatternPointerTable[ nCurPatternSelected ]["PatternName"] ~= "Pattern_KamarisTrap"
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
		end

		-- 메모리에 패턴 셋팅 정보 저장
		Var["StageInfo"]["PatternSetting"] = PatternSettingTable



		-- 확률 총합 체크
		local nTotalProb = BossSelectProbablityPercent["Boss1"] + BossSelectProbablityPercent["Boss2"] + BossSelectProbablityPercent["Boss3"]
		if nTotalProb ~= 100
		then
			ErrorLog( "InitDungeon::TotalProb ~= 100 in Boss Selecting Mode" )
			return
		end

		-- 정해진 확률에 의거한 보스 선택
		local nPercent = cRandomInt( 1, 100 )

		if nPercent <= BossSelectProbablityPercent["Boss1"]
		then
			Var["StageInfo"]["BossTypeNo"] = 1
		elseif nPercent <= BossSelectProbablityPercent["Boss1"] + BossSelectProbablityPercent["Boss2"]
		then
			Var["StageInfo"]["BossTypeNo"] = 2
		else
			Var["StageInfo"]["BossTypeNo"] = 3
		end


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


-- 1~9 번째 층의 몹들과 보스전
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


	-- 각 단계 초기 설정
	if Var["EachFloor"..CurStepNo ] == nil
	then

		DebugLog( "Start EachFloor "..CurStepNo )

		Var["EachFloor"..CurStepNo ] = {}


		-- 몹 그룹 젠
		local CurGroupRegen = RegenInfo["Group"][ CurPatternInfo["PatternName"] ][ CurPatternInfo["PatternOrderNo"] ]

		if CurGroupRegen ~= nil
		then
			if CurPatternInfo["PatternName"] ~= "Pattern_KamarisTrap" and CurPatternInfo["PatternName"] ~= "Pattern_OnlyOneIsKey"
			then
				for i = 1, #CurGroupRegen
				do
					cGroupRegenInstance_XY( Var["MapIndex"], CurGroupRegen[ i ], CurRegenCoord["x"], CurRegenCoord["y"] )
				end
			elseif CurPatternInfo["PatternName"] == "Pattern_KamarisTrap"
			then
				-- 카마리스만 불러냄
				for i = 1, #CurGroupRegen[ 1 ]
				do
					cGroupRegenInstance_XY( Var["MapIndex"], CurGroupRegen[ 1 ][ i ], CurRegenCoord["x"], CurRegenCoord["y"] )
				end
			end
		end


		-- 단일 몹 젠
		local CurMobRegen = RegenInfo["Mob"][ CurPatternInfo["PatternName"] ][ CurPatternInfo["PatternOrderNo"] ]

		if CurMobRegen ~= nil
		then
			for MobType, MobRegenInfo in pairs ( CurMobRegen )
			do
				local nMobCount = MobRegenInfo["count"]
				if nMobCount == nil
				then
					nMobCount = 1
				end

				for i = 1, nMobCount
				do
					local MobHandle = cMobRegen_Circle( Var["MapIndex"], MobRegenInfo["Index"], RegenInfo["Coord"][ CurStepNo ]["x"], RegenInfo["Coord"][ CurStepNo ]["y"], MobRegenInfo["radius"] )

					if MobHandle ~= nil
					then

						Var["Enemy"][ MobHandle ] = { Index = MobRegenInfo["Index"], x = RegenInfo["Coord"][ CurStepNo ]["x"], y = RegenInfo["Coord"][ CurStepNo ]["y"], radius = MobRegenInfo["radius"] }

						Var["RoutineTime"][ MobHandle ] = cCurrentSecond()
						cSetAIScript ( MainLuaScriptPath, MobHandle )

						if MobType == "Boss"
						then
							Var["EachFloor"..CurStepNo ]["MidBossHandle"] = MobHandle
							cAIScriptFunc( MobHandle, "Entrance", "MidBossMobRoutine" )
						elseif MobType == "Key"
						then
							cAIScriptFunc( MobHandle, "Entrance", "KeyBoxRoutine" )
						elseif MobType == "Mob"
						then
							cAIScriptFunc( MobHandle, "Entrance", "MobBoxRoutine" )
						elseif MobType == "Jewel"
						then
							cAIScriptFunc( MobHandle, "Entrance", "JewelBoxRoutine" )
						end

					end
				end
			end
		end


		-- 페이스컷 단계 구분용 변수 설정
		Var["EachFloor"..CurStepNo ]["BeforeDialogStepSec"] = Var["CurSec"]
		Var["EachFloor"..CurStepNo ]["BeforeDialogStepNo"] = 1

		Var["EachFloor"..CurStepNo ]["AfterDialogStepSec"] = Var["CurSec"]
		Var["EachFloor"..CurStepNo ]["AfterDialogStepNo"] = 1

		Var["EachFloor"..CurStepNo ]["OpenKeyDialogStepSec"] = Var["CurSec"]
		Var["EachFloor"..CurStepNo ]["OpenKeyDialogStepNo"] = 1

		Var["EachFloor"..CurStepNo ]["OpenMobDialogStepSec"] = Var["CurSec"]
		Var["EachFloor"..CurStepNo ]["OpenMobDialogStepNo"] = 1

		Var["EachFloor"..CurStepNo ]["AppearMobDialogStepSec"] = Var["CurSec"]
		Var["EachFloor"..CurStepNo ]["AppearMobDialogStepNo"] = 1


		-- 페이스컷 종료 여부 설정
		Var["EachFloor"..CurStepNo ]["bBeforeDialogEnd"] = false
		Var["EachFloor"..CurStepNo ]["bAfterDialogEnd"] = false
		Var["EachFloor"..CurStepNo ]["bOpenMobDialogEnd"] = nil	-- 몹상자를 열때마다 false가 되고 메세지 뜬 후 true 됨.
		Var["EachFloor"..CurStepNo ]["bOpenKeyDialogEnd"] = nil -- 당첨상자를 열면 false가 되어 상자가 1개이므로 1회 실행
		Var["EachFloor"..CurStepNo ]["bAppearMobDialogEnd"] = false


		-- 몹 전멸 여부 설정
		Var["EachFloor"..CurStepNo ]["bMobEliminated"] = false
		Var["EachFloor"..CurStepNo ]["bDestroyedKamaris"] = false


		Var["EachFloor"..CurStepNo ]["WaitMobGenSec"] = Var["CurSec"] + DelayTime["WaitAfterGenMob"]

	end

	-- 채팅
	local CurChat = ChatInfo["EachPattern"][ CurPatternInfo["PatternName"] ][ CurPatternInfo["PatternOrderNo"] ]

	-- 전투 전
	if CurChat["Before"] ~= nil
	then
		if Var["EachFloor"..CurStepNo ]["bBeforeDialogEnd"] == false
		then
			local nCurDialogNo = Var["EachFloor"..CurStepNo ]["BeforeDialogStepNo"]

			if nCurDialogNo <= #CurChat["Before"]
			then
				if Var["EachFloor"..CurStepNo ]["BeforeDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["Before"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["Before"][ nCurDialogNo ]["Index"] )

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

	-- 상자열기 패턴
	if CurPatternInfo["PatternName"] == "Pattern_OnlyOneIsKey"
	then
		if Var["EachFloor"..CurStepNo ]["nMobBoxOpened"] == nil
		then
			Var["EachFloor"..CurStepNo ]["nMobBoxOpened"] = 0
		end

		if Var["EachFloor"..CurStepNo ]["nMobBoxOpened"] > 0 and Var["EachFloor"..CurStepNo ]["bOpenMobDialogEnd"] ~= false
		then
			-- 몹상자 오픈 다이얼로그 띄우도록 설정
			Var["EachFloor"..CurStepNo ]["bOpenMobDialogEnd"] = false

			-- 몹 그룹 젠
			local CurGroupRegen = RegenInfo["Group"][ CurPatternInfo["PatternName"] ][ CurPatternInfo["PatternOrderNo"] ]

			if CurGroupRegen ~= nil
			then
				-- 몹 상자를 열면 나타나는 몹
				for i = 1, #CurGroupRegen
				do
					cGroupRegenInstance_XY( Var["MapIndex"], CurGroupRegen[ i ], CurRegenCoord["x"], CurRegenCoord["y"] )
				end
			end

			-- 채팅 단계 변수 초기화
			Var["EachFloor"..CurStepNo ]["OpenMobDialogStepNo"] = 1
			Var["EachFloor"..CurStepNo ]["OpenMobDialogStepSec"] = Var["CurSec"]

			-- 열린 상자 수를 하나 줄여줌( 열린 상자에 대한 처리를 완료 했기 때문에 )
			Var["EachFloor"..CurStepNo ]["nMobBoxOpened"] = Var["EachFloor"..CurStepNo ]["nMobBoxOpened"] - 1
		end

		if Var["EachFloor"..CurStepNo ]["KeyBoxOpened"] == true
		then
			-- 정답 상자 오픈 다이얼로그 띄우도록 설정
			Var["EachFloor"..CurStepNo ]["bOpenKeyDialogEnd"] = false

			Var["EachFloor"..CurStepNo ]["KeyBoxOpened"] = false
		end


		-- 몹 나올 경우 : 반복
		if CurChat["OpenMob"] ~= nil
		then
			if Var["EachFloor"..CurStepNo ]["bOpenMobDialogEnd"] == false
			then
				local nCurDialogNo = Var["EachFloor"..CurStepNo ]["OpenMobDialogStepNo"]

				if nCurDialogNo <= #CurChat["OpenMob"]
				then
					if Var["EachFloor"..CurStepNo ]["OpenMobDialogStepSec"] <= Var["CurSec"]
					then
						cMobDialog( Var["MapIndex"], CurChat["OpenMob"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["OpenMob"][ nCurDialogNo ]["Index"] )

						Var["EachFloor"..CurStepNo ]["OpenMobDialogStepNo"] = Var["EachFloor"..CurStepNo ]["OpenMobDialogStepNo"] + 1
						Var["EachFloor"..CurStepNo ]["OpenMobDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
					end

					-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
					return
				else
					-- 페이스컷 종료
					Var["EachFloor"..CurStepNo ]["bOpenMobDialogEnd"] = true
				end
			end
		else
			-- 페이스컷 자체가 없을 때
			Var["EachFloor"..CurStepNo ]["bOpenMobDialogEnd"] = true
		end

		-- 상자가 싹 사라질 경우 : 1회
		if CurChat["OpenKey"] ~= nil
		then
			if Var["EachFloor"..CurStepNo ]["bOpenKeyDialogEnd"] == false
			then
				local nCurDialogNo = Var["EachFloor"..CurStepNo ]["OpenKeyDialogStepNo"]

				if nCurDialogNo <= #CurChat["OpenKey"]
				then
					if Var["EachFloor"..CurStepNo ]["OpenKeyDialogStepSec"] <= Var["CurSec"]
					then
						cMobDialog( Var["MapIndex"], CurChat["OpenKey"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["OpenKey"][ nCurDialogNo ]["Index"] )

						Var["EachFloor"..CurStepNo ]["OpenKeyDialogStepNo"] = Var["EachFloor"..CurStepNo ]["OpenKeyDialogStepNo"] + 1
						Var["EachFloor"..CurStepNo ]["OpenKeyDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
					end

					-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
					return
				else
					-- 페이스컷 종료
					Var["EachFloor"..CurStepNo ]["bOpenKeyDialogEnd"] = true
				end
			end
		else
			-- 페이스컷 자체가 없을 때
			Var["EachFloor"..CurStepNo ]["bOpenKeyDialogEnd"] = true
		end
	-- 카마리스 패턴
	elseif CurPatternInfo["PatternName"] == "Pattern_KamarisTrap"
	then
		-- 몹 전멸체크
		if Var["EachFloor"..CurStepNo ]["bDestroyedKamaris"] == false
		then
			if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) <= 0
			then
				Var["EachFloor"..CurStepNo ]["bDestroyedKamaris"] = true

				-- 몹 그룹 젠
				local CurGroupRegen = RegenInfo["Group"][ CurPatternInfo["PatternName"] ][ CurPatternInfo["PatternOrderNo"] ]

				if CurGroupRegen ~= nil
				then
					if CurGroupRegen[ 2 ] ~= nil
					then
						-- 카마리스 부순 후 나타나는 몹
						for i = 1, #CurGroupRegen[ 2 ]
						do
							cGroupRegenInstance_XY( Var["MapIndex"], CurGroupRegen[ 2 ][ i ], CurRegenCoord["x"], CurRegenCoord["y"] )
						end
					end
				end
			end

			return
		else
			-- 카마리스가 죽고 몹이 쫙 솬되는 경우 : 1회
			if CurChat["AppearMob"] ~= nil
			then
				if Var["EachFloor"..CurStepNo ]["bAppearMobDialogEnd"] == false
				then
					local nCurDialogNo = Var["EachFloor"..CurStepNo ]["AppearMobDialogStepNo"]

					if nCurDialogNo <= #CurChat["AppearMob"]
					then
						if Var["EachFloor"..CurStepNo ]["AppearMobDialogStepSec"] <= Var["CurSec"]
						then
							cMobDialog( Var["MapIndex"], CurChat["AppearMob"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["AppearMob"][ nCurDialogNo ]["Index"] )

							Var["EachFloor"..CurStepNo ]["AppearMobDialogStepNo"] = Var["EachFloor"..CurStepNo ]["AppearMobDialogStepNo"] + 1
							Var["EachFloor"..CurStepNo ]["AppearMobDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
						end

						-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
						return
					else
						-- 페이스컷 종료
						Var["EachFloor"..CurStepNo ]["bAppearMobDialogEnd"] = true
					end
				end
			else
				-- 페이스컷 자체가 없을 때
				Var["EachFloor"..CurStepNo ]["bAppearMobDialogEnd"] = true
			end
		end

	else
		-- There is no process here.
	end


	-- 몹 전멸체크
	if Var["EachFloor"..CurStepNo ]["bMobEliminated"] == false
	then
		if Var["EachFloor"..CurStepNo ]["WaitMobGenSec"] <= Var["CurSec"]
		then
			if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) <= 0
			then
				Var["EachFloor"..CurStepNo ]["bMobEliminated"] = true
			end
		end

		return
	else
		-- 전투 끝 이후
		if CurChat["After"] ~= nil
		then
			if Var["EachFloor"..CurStepNo ]["bAfterDialogEnd"] == false
			then
				local nCurDialogNo = Var["EachFloor"..CurStepNo ]["AfterDialogStepNo"]

				if nCurDialogNo <= #CurChat["After"]
				then
					if Var["EachFloor"..CurStepNo ]["AfterDialogStepSec"] <= Var["CurSec"]
					then
						cMobDialog( Var["MapIndex"], CurChat["After"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["After"][ nCurDialogNo ]["Index"] )

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
		if Var["EachFloor"..CurStepNo ]["bAfterDialogEnd"] == true
		then
			if CurPatternInfo["PatternName"] == "Pattern_KamarisTrap"
			then
				if Var["EachFloor"..CurStepNo ]["bDestroyedKamaris"] ~= true
				then
					return
				end

			elseif CurPatternInfo["PatternName"] == "Pattern_OnlyOneIsKey"
			then
				if Var["EachFloor"..CurStepNo ]["bOpenKeyDialogEnd"] ~= true
				then
					return
				end

			else
				if Var["EachFloor"..CurStepNo ]["bMobEliminated"] ~= true
				then
					return
				end

			end



			-- 클리어 액션
			if Var["Door"..CurStepNo ] ~= nil
			then
				cDoorAction( Var["Door"..CurStepNo ], Var["Door"][ Var["Door"..CurStepNo ] ]["Block"], "open" )
			end

			-- 다음 단계로
			Var["EachFloor"..CurStepNo ] = nil
			Var["EachFloor"]["StepNumber"] = CurStepNo + 1

			DebugLog( "End EachFloor "..CurStepNo )

			-- 모든 층 클리어 시
			if Var["EachFloor"]["StepNumber"] > #StepNameTable - 2
			then

				Var["EachFloor"] = nil
				GoToNextStep( Var )
				return
			end

			return
		end
	end

end


-- 보스전
function BossBattle( Var )
cExecCheck "BossBattle"

	if Var == nil
	then
		return
	end

	if Var["StageInfo"]["BossTypeNo"] == nil
	then
		ErrorLog( "BossBattle::Var[\"StageInfo\"][\"BossTypeNo\"] == nil" )
		return
	end

	local nBossType = Var["StageInfo"]["BossTypeNo"]

	if Var["BossBattle"] == nil
	then
		DebugLog( "BossBattle::Start" )
		Var["BossBattle"] = {}

		-- 몹 그룹 젠
		for i = 1, #RegenInfo["Group"]["BossBattle"][ nBossType ]
		do
			cGroupRegenInstance( Var["MapIndex"], RegenInfo["Group"]["BossBattle"][ nBossType ][ i ] )
		end


		-- 보스 젠
		if Var["BossBattle"]["BossAC_PlusEffectCount"] == nil
		then
			Var["BossBattle"]["BossAC_PlusEffectCount"] = 0
		end

		if Var["BossBattle"]["BossMR_PlusEffectCount"] == nil
		then
			Var["BossBattle"]["BossMR_PlusEffectCount"] = 0
		end

		if Var["BossBattle"]["BossImmortalEffectCount"] == nil
		then
			Var["BossBattle"]["BossImmortalEffectCount"] = 0
		end

		for MobType, MobRegenInfo in pairs( RegenInfo["Mob"]["BossBattle"][ nBossType ] )
		do
			local nMobHandle = cMobRegen_XY( Var["MapIndex"], MobRegenInfo["Index"], MobRegenInfo["x"], MobRegenInfo["y"], MobRegenInfo["dir"] )

			if nMobHandle ~= nil
			then
				-- 공통 처리
				Var["Enemy"][ nMobHandle ] = MobRegenInfo
				Var["RoutineTime"][ nMobHandle ] = cCurrentSecond()
				cSetAIScript ( MainLuaScriptPath, nMobHandle )

				-- 분류 처리
				if MobType == "LizardManGuardian" or MobType == "HeavyOrc" or MobType == "JewelGolem"
				then

					Var["BossHandle"] = nMobHandle
					cAIScriptFunc( nMobHandle, "Entrance",   "BossRoutine" )
					cAIScriptFunc( nMobHandle, "MobDamaged", "BossDamaged" )

				elseif MobType == "PhysicalPillar"
				then
					cAIScriptFunc( nMobHandle, "Entrance", "PhysicalPillarRoutine" )

					-- 보스 물리 방어 강화 효과를 주는 필러 개수를 젠 할 때마다 셋팅
					Var["BossBattle"]["BossAC_PlusEffectCount"] = Var["BossBattle"]["BossAC_PlusEffectCount"] + 1

				elseif MobType == "MagicalPillar"
				then
					cAIScriptFunc( nMobHandle, "Entrance", "MagicalPillarRoutine" )

					-- 보스 마법 방어 강화 효과를 주는 필러 개수를 젠 할 때마다 셋팅
					Var["BossBattle"]["BossMR_PlusEffectCount"] = Var["BossBattle"]["BossMR_PlusEffectCount"] + 1

				elseif MobType == "ImmortalPillar1" or MobType == "ImmortalPillar2" or MobType == "ImmortalPillar3" or MobType == "ImmortalPillar4"
				then
					cAIScriptFunc( nMobHandle, "Entrance", "ImmortalPillarRoutine" )

					-- 보스 무적효과를 주는 필러 개수를 젠 할 때마다 셋팅
					Var["BossBattle"]["BossImmortalEffectCount"] = Var["BossBattle"]["BossImmortalEffectCount"] + 1

				end
			else
				DebugLog( "BossBattle::nMobHandle == nil" )
			end
		end -- 보스젠 for문

		-- 페이스컷 단계 구분용 변수 설정
		Var["BossBattle"]["InitDialogStepSec"] = Var["CurSec"]
		Var["BossBattle"]["InitDialogStepNo"] = 1

		Var["BossBattle"]["ReInitDialogStepSec"] = Var["CurSec"]
		Var["BossBattle"]["ReInitDialogStepNo"] = 1

		Var["BossBattle"]["ShutDoorDialogAndNoticeStepSec"] = Var["CurSec"]
		Var["BossBattle"]["ShutDoorDialogAndNoticeStepNo"] = 1

		Var["BossBattle"]["ClearDialogAndNoticeStepSec"] = Var["CurSec"]
		Var["BossBattle"]["ClearDialogAndNoticeStepNo"] = 1

		-- 페이스컷 종료 여부 설정
		Var["BossBattle"]["bInitDialogEnd"] 				= false
		Var["BossBattle"]["bReInitDialogEnd"] 				= nil -- 재시작 조건시 false가 되어 초기화가 실행됨.
		Var["BossBattle"]["bShutDoorDialogAndNoticeEnd"] 	= nil -- 문닫힘 조건시 false가 되어 초기화가 실행됨.
		Var["BossBattle"]["bClearDialogAndNoticeEnd"] 		= nil -- 종료 조건시 종료

		-- 몹 전멸 여부 설정
		Var["BossBattle"]["bMobEliminated"] = false

		Var["BossBattle"]["WaitMobGenSec"] = Var["CurSec"] + DelayTime["WaitAfterGenMob"]

	end -- BossBattle 초기화 if문


	-- 재시작 조건
	if Var["BossBattle"]["bRestartCondition"] == true
	then
		DebugLog( "BossBattle::Restart-Vanish All" )

		-- 기존 몹 사라지기
		local CenterCoord = { x = RegenInfo["Mob"]["BossBattle"][ 1 ]["LizardManGuardian"]["x"], y = RegenInfo["Mob"]["BossBattle"][ 1 ]["LizardManGuardian"]["y"] }
		local PreviousMobHandleList = { cGetNearObjListByCoord( Var["MapIndex"], CenterCoord["x"], CenterCoord["y"], 1000, ObjectType["Mob"], "so_ObjectType", 50 ) }
		for i = 1, #PreviousMobHandleList
		do
			cNPCVanish( PreviousMobHandleList[ i ] )
		end

		-- 다 사라졌는가 체크하기
		if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) > 0
		then
			ErrorLog( "BossBattle::Mob Reinitializing(Vanishing Step) is failed." )
			return
		end

		cDoorAction( Var["Door"..(#StepNameTable - 2) ], RegenInfo["Stuff"]["Door"..(#StepNameTable - 2) ]["Block"], "open" )

		DebugLog( "BossBattle::Restart-Regen" )

		Var["BossBattle"] = nil

		Var["BossBattle"] = {}

		-- 몹 그룹 젠
		for i = 1, #RegenInfo["Group"]["BossBattle"][ nBossType ]
		do
			cGroupRegenInstance( Var["MapIndex"], RegenInfo["Group"]["BossBattle"][ nBossType ][ i ] )
		end


		-- 보스 젠
		if Var["BossBattle"]["BossAC_PlusEffectCount"] == nil
		then
			Var["BossBattle"]["BossAC_PlusEffectCount"] = 0
		end

		if Var["BossBattle"]["BossMR_PlusEffectCount"] == nil
		then
			Var["BossBattle"]["BossMR_PlusEffectCount"] = 0
		end

		if Var["BossBattle"]["BossImmortalEffectCount"] == nil
		then
			Var["BossBattle"]["BossImmortalEffectCount"] = 0
		end

		for MobType, MobRegenInfo in pairs( RegenInfo["Mob"]["BossBattle"][ nBossType ] )
		do
			local nMobHandle = cMobRegen_XY( Var["MapIndex"], MobRegenInfo["Index"], MobRegenInfo["x"], MobRegenInfo["y"], MobRegenInfo["dir"] )

			if nMobHandle ~= nil
			then
				-- 공통 처리
				Var["Enemy"][ nMobHandle ] = MobRegenInfo
				Var["RoutineTime"][ nMobHandle ] = cCurrentSecond()
				cSetAIScript ( MainLuaScriptPath, nMobHandle )

				-- 분류 처리
				if MobType == "LizardManGuardian" or MobType == "HeavyOrc" or MobType == "JewelGolem"
				then
					-- 보스 핸들 추가 등록 및 AI 설정
					Var["BossHandle"] = nMobHandle
					cAIScriptFunc( nMobHandle, "Entrance",   "BossRoutine" )
					cAIScriptFunc( nMobHandle, "MobDamaged", "BossDamaged" )

				elseif MobType == "PhysicalPillar"
				then

					cAIScriptFunc( nMobHandle, "Entrance", "PhysicalPillarRoutine" )

					-- 보스 물리 방어 강화 효과를 주는 필러 개수를 젠 할 때마다 셋팅
					Var["BossBattle"]["BossAC_PlusEffectCount"] = Var["BossBattle"]["BossAC_PlusEffectCount"] + 1

				elseif MobType == "MagicalPillar"
				then
					cAIScriptFunc( nMobHandle, "Entrance", "MagicalPillarRoutine" )

					-- 보스 마법 방어 강화 효과를 주는 필러 개수를 젠 할 때마다 셋팅
					Var["BossBattle"]["BossMR_PlusEffectCount"] = Var["BossBattle"]["BossMR_PlusEffectCount"] + 1

				elseif MobType == "ImmortalPillar1" or MobType == "ImmortalPillar2" or MobType == "ImmortalPillar3" or MobType == "ImmortalPillar4"
				then
					cAIScriptFunc( nMobHandle, "Entrance", "ImmortalPillarRoutine" )

					-- 보스 무적효과를 주는 필러 개수를 젠 할 때마다 셋팅
					Var["BossBattle"]["BossImmortalEffectCount"] = Var["BossBattle"]["BossImmortalEffectCount"] + 1

				end
			else
				DebugLog( "BossBattle::nMobHandle == nil" )
			end
		end -- 보스젠 for문

		-- 페이스컷 단계 구분용 변수 설정
		Var["BossBattle"]["ReInitDialogStepSec"] = Var["CurSec"]
		Var["BossBattle"]["ReInitDialogStepNo"] = 1

		Var["BossBattle"]["ShutDoorDialogAndNoticeStepSec"] = Var["CurSec"]
		Var["BossBattle"]["ShutDoorDialogAndNoticeStepNo"] = 1

		Var["BossBattle"]["ClearDialogAndNoticeStepSec"] = Var["CurSec"]
		Var["BossBattle"]["ClearDialogAndNoticeStepNo"] = 1

		-- 페이스컷 종료 여부 설정
		Var["BossBattle"]["bInitDialogEnd"] 				= true  -- 이미 이 부분은 끝난 상황임
		Var["BossBattle"]["bReInitDialogEnd"] 				= false -- 재시작 조건이 되었으므로 해당 다이얼로그 시작
		Var["BossBattle"]["bShutDoorDialogAndNoticeEnd"] 	= nil   -- 문 닫힘 조건이 되면 false가 되어 실행
		Var["BossBattle"]["bClearDialogAndNoticeEnd"] 		= nil -- 클리어 조건이 되면 해당 구문 실행

		-- 몹 전멸 여부 설정
		Var["BossBattle"]["bMobEliminated"] = false

		Var["BossBattle"]["WaitMobGenSec"] = Var["CurSec"] + DelayTime["WaitAfterGenMob"]

	end -- BossBattle 재시작용 초기화 if문


	-- 문 닫힘 조건 체크 및 설정
	if Var["BossBattle"]["bShutDoorDialogAndNoticeEnd"] == nil
	then
		-- 모든 플레이어 중 한명이라도 영역안에 들어온 상태에서 일정시간이 지나면 나가지 못하도록 뒤쪽 문을 닫는다.
		local InBossAreaHandleList = { cGetAreaObjectList( Var["MapIndex"], BossArea["Index"], ObjectType["Player"] ) }

		if #InBossAreaHandleList > 0
		then
			if Var["BossBattle"]["InAreaStackCount"] == nil
			then
				Var["BossBattle"]["InAreaStackCount"] = 0
			end

			Var["BossBattle"]["InAreaStackCount"] = Var["BossBattle"]["InAreaStackCount"] + 1

			if Var["BossBattle"]["InAreaStackCount"] > BossArea["TriggerCount"]
			then
				cDoorAction( Var["Door"..(#StepNameTable - 2) ], RegenInfo["Stuff"]["Door"..(#StepNameTable - 2) ]["Block"], "close" )
				Var["BossBattle"]["bShutDoorDialogAndNoticeEnd"] = false
			end
		end
	end


	-- 클리어 조건 체크 및 채팅 조건 설정
	if Var["BossBattle"]["bClearDialogAndNoticeEnd"] == nil
	then
		if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) < 1
		then
			Var["BossBattle"]["bClearDialogAndNoticeEnd"] = false
		end
	end

---------------------------------------------------------------------------------------------------------------------------------------------------
	-- 채팅
	local CurChat = ChatInfo["BossBattle"]["Boss"..nBossType ]

	-- 최초 초기화 시
	if CurChat["InitDialog"] ~= nil
	then
		if Var["BossBattle"]["bInitDialogEnd"] == false
		then
			local nCurDialogNo = Var["BossBattle"]["InitDialogStepNo"]

			if nCurDialogNo <= #CurChat["InitDialog"]
			then
				if Var["BossBattle"]["InitDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["InitDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["InitDialog"][ nCurDialogNo ]["Index"] )

					Var["BossBattle"]["InitDialogStepNo"] = Var["BossBattle"]["InitDialogStepNo"] + 1
					Var["BossBattle"]["InitDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
				return
			else
				-- 페이스컷 종료
				Var["BossBattle"]["bInitDialogEnd"] = true
			end
		end
	else
		-- 페이스컷 자체가 없을 때
		Var["BossBattle"]["bInitDialogEnd"] = true
	end


	-- 모든 플레이어가 범위 밖으로 벗어나서 초기화 된 경우
	if CurChat["ReInitDialog"] ~= nil
	then
		if Var["BossBattle"]["bReInitDialogEnd"] == false
		then
			local nCurDialogNo = Var["BossBattle"]["ReInitDialogStepNo"]

			if nCurDialogNo <= #CurChat["ReInitDialog"]
			then
				if Var["BossBattle"]["ReInitDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["ReInitDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["ReInitDialog"][ nCurDialogNo ]["Index"] )

					Var["BossBattle"]["ReInitDialogStepNo"] = Var["BossBattle"]["ReInitDialogStepNo"] + 1
					Var["BossBattle"]["ReInitDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
				return
			else
				-- 페이스컷 종료
				Var["BossBattle"]["bReInitDialogEnd"] = true
			end
		end
	else
		-- 페이스컷 자체가 없을 때
		Var["BossBattle"]["bReInitDialogEnd"] = true
	end


	-- 보스방 문 닫힘 다이얼로그 조건이 된 경우
	if CurChat["ShutDoorDialog"] ~= nil and CurChat["ShutDoorNotice"] ~= nil
	then
		if Var["BossBattle"]["bShutDoorDialogAndNoticeEnd"] == false
		then
			local nCurDialogNo = Var["BossBattle"]["ShutDoorDialogAndNoticeStepNo"]

			if nCurDialogNo <= #CurChat["ShutDoorDialog"]
			then
				if Var["BossBattle"]["ShutDoorDialogAndNoticeStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["ShutDoorDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["ShutDoorDialog"][ nCurDialogNo ]["Index"] )
					if Var["BossBattle"]["ShutDoorDialogAndNoticeStepNo"] == 1
					then
						cNotice( Var["MapIndex"], ChatInfo["ScriptFileName"], CurChat["ShutDoorNotice"][ nCurDialogNo ]["Index"] )
					end

					Var["BossBattle"]["ShutDoorDialogAndNoticeStepNo"] = Var["BossBattle"]["ShutDoorDialogAndNoticeStepNo"] + 1
					Var["BossBattle"]["ShutDoorDialogAndNoticeStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
				return
			else
				-- 페이스컷 종료
				Var["BossBattle"]["bShutDoorDialogAndNoticeEnd"] = true
			end
		end
	else
		-- 페이스컷 자체가 없을 때
		Var["BossBattle"]["bShutDoorDialogAndNoticeEnd"] = true
	end


	-- 보스 클리어 조건이 된 경우
	if CurChat["ClearDialog"] ~= nil and CurChat["ClearNotice"] ~= nil
	then
		if Var["BossBattle"]["bClearDialogAndNoticeEnd"] == false
		then
			local nCurDialogNo = Var["BossBattle"]["ClearDialogAndNoticeStepNo"]

			if nCurDialogNo <= #CurChat["ClearDialog"]
			then
				if Var["BossBattle"]["ClearDialogAndNoticeStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["ClearDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["ClearDialog"][ nCurDialogNo ]["Index"] )
					if nCurDialogNo == 1
					then
						cNotice( Var["MapIndex"], ChatInfo["ScriptFileName"], CurChat["ClearNotice"][ nCurDialogNo ]["Index"] )
					end

					Var["BossBattle"]["ClearDialogAndNoticeStepNo"] = Var["BossBattle"]["ClearDialogAndNoticeStepNo"] + 1
					Var["BossBattle"]["ClearDialogAndNoticeStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
				return
			else
				-- 페이스컷 종료
				Var["BossBattle"]["bClearDialogAndNoticeEnd"] = true
			end
		end
	else
		-- 페이스컷 자체가 없을 때
		Var["BossBattle"]["bClearDialogAndNoticeEnd"] = true
	end


	-- 다음 단계로 넘어갈 조건
	if Var["BossBattle"]["bClearDialogAndNoticeEnd"] == true
	then
		-- Quest Mob Kill 세기.
		Var["BossBattle"] = nil
		DebugLog( "BossBattle::End" )
		cDoorAction( Var["Door"..(#StepNameTable - 2) ], RegenInfo["Stuff"]["Door"..(#StepNameTable - 2) ]["Block"], "open" )
		cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )
		GoToNextStep( Var )
	end

end


-- 아이젤의 보상
function IyzelReward( Var )
cExecCheck "IyzelReward"

	if Var == nil
	then
		return
	end


	local nBossType = Var["StageInfo"]["BossTypeNo"]

	if Var["IyzelReward"] == nil
	then
		DebugLog( "IyzelReward::Start" )

		Var["IyzelReward"] = {}

		-- 아이젤 젠
		local IyzelRegenInfo = RegenInfo["NPC"]["IyzelReward"]["Iyzel"]
		local nIyzelHandle = cMobRegen_XY( Var["MapIndex"], IyzelRegenInfo["Index"], IyzelRegenInfo["x"], IyzelRegenInfo["y"], IyzelRegenInfo["dir"] )

		if nIyzelHandle ~= nil
		then
			Var["Enemy"][ nIyzelHandle ] = IyzelRegenInfo
			Var["IyzelHandle"] = nIyzelHandle

			-- 아이젤 무적 처리
			local AbstateInfo = NPC_Abstate["Immortal"]
			cSetAbstate( nIyzelHandle, AbstateInfo["Index"], AbstateInfo["Strength"], AbstateInfo["KeepTime"] )

		else
			ErrorLog( "IyzelReward::Iyzel Gen Failed" )
		end


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


		-- 특별한 보상 상자 젠
		local TreasureBoxRegenInfo = RegenInfo["Mob"]["IyzelReward"][ nBossType ]
		local nBoxHandle = cMobRegen_Circle( Var["MapIndex"], TreasureBoxRegenInfo["Index"], TreasureBoxRegenInfo["x"], TreasureBoxRegenInfo["y"], TreasureBoxRegenInfo["radius"] )

		if nBoxHandle ~= nil
		then
			Var["Enemy"][ nBoxHandle ] = TreasureBoxRegenInfo
			Var["RoutineTime"][ nBoxHandle ] = cCurrentSecond()

			if cSetAIScript( MainLuaScriptPath, nBoxHandle ) == nil
			then
				ErrorLog( "IyzelReward::Special Box cSetAIScript( ) Failed" )
			end

			if cAIScriptFunc( nBoxHandle, "Entrance", "TreasureBoxRoutine" ) == nil
			then
				ErrorLog( "IyzelReward::Special Box cAIScriptFunc( ) Failed - Entrance Mode" )
			end

			if cAIScriptFunc( nBoxHandle, "ObjectDied", "TreasureBoxOpened" ) == nil
			then
				ErrorLog( "IyzelReward::Special Box cAIScriptFunc( ) Failed - ObjectDied Mode" )
			end

		else
			ErrorLog( "IyzelReward::Special Box Gen Failed" )
		end


		-- 보상 상자 그룹 젠
		local RewardBoxesRegenInfo = RegenInfo["Group"]["IyzelReward"][ nBossType ]
		for i = 1, #RewardBoxesRegenInfo
		do
			cGroupRegenInstance( Var["MapIndex"], RewardBoxesRegenInfo[ i ] )
		end


		-- 채팅 단계 설정용 변수 셋팅
		Var["IyzelReward"]["AppearDialogStepSec"] = Var["CurSec"]
		Var["IyzelReward"]["AppearDialogStepNo"] = 1
		Var["IyzelReward"]["OpenBoxTimeOverDialogStepSec"] = Var["CurSec"] + DelayTime["RewardBoxTryTime"]
		Var["IyzelReward"]["OpenBoxTimeOverDialogStepNo"] = 1

		Var["IyzelReward"]["bAppearDialogEnd"] = false
		Var["IyzelReward"]["bOpenBoxTimeOverDialogEnd"] = nil -- 제한시간 끝나면 false로 바뀌어 실행

		cTimer( Var["MapIndex"], DelayTime["RewardBoxTryTime"] )
	end


---------------------------------------------------------------------------------------------------------------------------------------------------
	-- 단계 설정
	if Var["IyzelReward"]["OpenBoxTimeOverDialogStepSec"] <= Var["CurSec"]
	then
		Var["IyzelReward"]["bOpenBoxTimeOverDialogEnd"] = false

---[[
		-- 박스 죽어서 아이템 내뱉기 모드
		local HandleList = { cNearObjectList( Var["IyzelHandle"], 500, ObjectType["Mob"] ) }
		for DummyIndex, nTargetHandle in pairs ( HandleList )
		do
			if nTargetHandle ~= Var["IyzelHandle"]
			then
				cMobSuicide( Var["MapIndex"], nTargetHandle )
			end
		end
--]]


--[[
		-- 박스 사라지기 모드
		for nIndex, sIndexName in pairs ( RewardBoxIndexes )
		do
			cVanishAll( Var["MapIndex"], sIndexName )
		end
--]]
	end


---------------------------------------------------------------------------------------------------------------------------------------------------
	-- 채팅

	local CurChat = ChatInfo["IyzelReward"]["Boss"..nBossType ]
	local sIyzelIndex = ChatInfo["IyzelReward"]["SpeakerIndex"]

	-- 아이젤이 나타나자마자
	if CurChat["IyzelAppearDialog"] ~= nil
	then
		if Var["IyzelReward"]["bAppearDialogEnd"] == false
		then
			local nCurDialogNo = Var["IyzelReward"]["AppearDialogStepNo"]

			if nCurDialogNo <= #CurChat["IyzelAppearDialog"]
			then
				if Var["IyzelReward"]["AppearDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], sIyzelIndex, ChatInfo["ScriptFileName"], CurChat["IyzelAppearDialog"][ nCurDialogNo ]["Index"] )

					Var["IyzelReward"]["AppearDialogStepNo"] = Var["IyzelReward"]["AppearDialogStepNo"] + 1
					Var["IyzelReward"]["AppearDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
				return
			else
				-- 페이스컷 종료
				Var["IyzelReward"]["bAppearDialogEnd"] = true
			end
		end
	else
		-- 페이스컷 자체가 없을 때
		Var["IyzelReward"]["bAppearDialogEnd"] = true
	end


	-- 보상상자 제한시간이 지나고 나서
	if CurChat["OpenBoxTimeOverDialog"] ~= nil
	then
		if Var["IyzelReward"]["bOpenBoxTimeOverDialogEnd"] == false
		then
			local nCurDialogNo = Var["IyzelReward"]["OpenBoxTimeOverDialogStepNo"]

			if nCurDialogNo <= #CurChat["OpenBoxTimeOverDialog"]
			then
				if Var["IyzelReward"]["OpenBoxTimeOverDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], sIyzelIndex, ChatInfo["ScriptFileName"], CurChat["OpenBoxTimeOverDialog"][ nCurDialogNo ]["Index"] )

					Var["IyzelReward"]["OpenBoxTimeOverDialogStepNo"] = Var["IyzelReward"]["OpenBoxTimeOverDialogStepNo"] + 1
					Var["IyzelReward"]["OpenBoxTimeOverDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
				return
			else
				-- 페이스컷 종료
				Var["IyzelReward"]["bOpenBoxTimeOverDialogEnd"] = true
			end
		end
	else
		-- 페이스컷 자체가 없을 때
		Var["IyzelReward"]["bOpenBoxTimeOverDialogEnd"] = true
	end


	-- 끝
	if Var["IyzelReward"]["bOpenBoxTimeOverDialogEnd"] == true
	then
		Var["IyzelReward"] = nil
		GoToNextStep( Var )
		DebugLog( "IyzelReward::End" )
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
	{ Function = InitDungeon,  Name = "InitDungeon",  },
	{ Function = EachFloor,    Name = "EachFloor",    },
	{ Function = BossBattle,   Name = "BossBattle",   },
	{ Function = IyzelReward,  Name = "IyzelReward",  },
	{ Function = QuestSuccess, Name = "QuestSuccess", },
	{ Function = QuestFailed,  Name = "QuestFailed",  },
	{ Function = ReturnToHome, Name = "ReturnToHome", },
}


-- 역참조 리스트
ID_StepsIndexList =
{
}

for index, funcValue in pairs ( ID_StepsList )
do
	ID_StepsIndexList[ funcValue["Name"] ] = index
end
