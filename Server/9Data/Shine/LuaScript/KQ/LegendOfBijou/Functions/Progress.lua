--------------------------------------------------------------------------------
--                    Legend Of Bijou Progress Func                           --
--------------------------------------------------------------------------------

-- 던전 초기화
function InitDungeon( Var )
cExecCheck "InitDungeon"

	if Var == nil
	then
		return
	end

	-- 킹덤 퀘스트 시작 전에 플레이어의 첫 로그인을 기다린다.
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


		local Doors = RegenInfo["Stuff"]
		local Door1 = Doors["FirstGate"]
		local Door2 = Doors["SecondGate"]
		local Door3 = Doors["ThirdGate"]

		-- 문 생성
		Var["Door1"] = cDoorBuild( Var["MapIndex"], Door1["Index"], Door1["x"], Door1["y"], Door1["dir"], Door1["scale"] )
		Var["Door2"] = cDoorBuild( Var["MapIndex"], Door2["Index"], Door2["x"], Door2["y"], Door2["dir"], Door2["scale"] )
		Var["Door3"] = cDoorBuild( Var["MapIndex"], Door3["Index"], Door3["x"], Door3["y"], Door3["dir"], Door3["scale"] )

		-- 문 닫기
		cDoorAction( Var["Door1"], Door1["Block"], "open" )
		cDoorAction( Var["Door2"], Door2["Block"], "open" )
		cDoorAction( Var["Door3"], Door3["Block"], "open" )

		-- 두번째 문에 카마리스 수만큼 자물쇠 걸기
		Var["Door2Lock"] = #RegenInfo["Mob"]["GardenSquare"]["Kamaris"]["CoordList"]

		-- 보스 : 칼반 오벳을 부르기 위해 부숴야 하는 해당 위치의 카마리스 수 설정
		Var["CallBossLock"] = #RegenInfo["Mob"]["EndOfLegend"]["Kamaris"]["CoordList"]

		-- 안개 생성
		cMapFog( Var["MapIndex"], MapFogInfo["FogValue"], MapFogInfo["SightDistance"] )

		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"] + DelayTime["AfterInit"]

	end


	-- 일정 시간 뒤 다음 단계로
	if Var["InitDungeon"]["WaitSecDuringInit"] <= Var["CurSec"]
	then
		GoToNextStep( Var )
		Var["InitDungeon"] = nil
		DebugLog( "End InitDungeon" )
		return
	end

end


-- 가디언의 지시
function CommandOfGuard( Var )
cExecCheck "CommandOfGuard"

	if Var == nil
	then
		return
	end

	DebugLog( "Start CommandOfGuard" )

	cMobDialog( Var["MapIndex"], NPC_GuardChat["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["StartDialog"]["Index"] )

	GoToNextStep( Var )


	local nLimitSec = cGetKQLimitSecond( Var["MapIndex"] )

	if nLimitSec == nil
	then
		ErrorLog( "GuideOfRoumenus::nLimitSec == nil" )
	else
		-- Real Kingdom Quest 시작 !!!!
		Var["KQLimitTime"] = Var["CurSec"] + nLimitSec
		-- 타이머 시작!
		cShowKQTimerWithLife( Var["MapIndex"], nLimitSec )
	end


	DebugLog( "End CommandOfGuard" )

	return

end


-- 해골궁수가 지키고 있는 성벽, 첫번째 문을 돌파하라
function FirstGateAndWall( Var )
cExecCheck "FirstGateAndWall"


	if Var == nil
	then
		return
	end


	if Var["FirstGateAndWall"] == nil
	then
		DebugLog( "Start FirstGateAndWall" )
		Var["FirstGateAndWall"] = {}


		-- 몹게이트 1 소환
		local RegenMobGate	= RegenInfo["Mob"]["FirstGateAndWall"]["FirstMobGate"]
		local MobGateHandle	= nil

		MobGateHandle = cMobRegen_XY( Var["MapIndex"], RegenMobGate["Index"], RegenMobGate["x"], RegenMobGate["y"], RegenMobGate["dir"] )

		if MobGateHandle ~= nil
		then
			Var["Enemy"][ MobGateHandle ] = RegenMobGate

			cSetAIScript ( MainLuaScriptPath, MobGateHandle )
			cAIScriptFunc( MobGateHandle, "Entrance", "MobGateRoutine" )
		end


		-- 첫번째 카마리스
		local Regen1stKamaris	= RegenInfo["Mob"]["FirstGateAndWall"]["FirstKamaris"]
		local KamarisHandle		= nil

		KamarisHandle = cMobRegen_XY( Var["MapIndex"], Regen1stKamaris["Index"], Regen1stKamaris["x"], Regen1stKamaris["y"], Regen1stKamaris["dir"] )

		if KamarisHandle ~= nil
		then
			cSetAIScript ( MainLuaScriptPath, KamarisHandle )
			cAIScriptFunc( KamarisHandle, "Entrance", "TeleportKamarisRoutine" )

			Var["Enemy"][ KamarisHandle ] = Regen1stKamaris
		end


		-- 성벽을 지키는 해골 궁수들
		local RegenWallDefenders = RegenInfo["Mob"]["FirstGateAndWall"]["WallDefenders"]
		local NumOfWallDefenders = #RegenWallDefenders["CoordList"]
		local NumOfTypes 		 = #RegenWallDefenders["IndexList"]
		local AbstateInfo 		 = RegenWallDefenders["AbstateAlways"]

		Var["Enemy"]["WallDefenders"] = {}

		for i = 1, NumOfWallDefenders
		do
			local nMobTypeNum 	= cRandomInt( 1, NumOfTypes )
			local CurMob 		= RegenWallDefenders["CoordList"][ i ]
			local nMobHandle	= cMobRegen_XY( Var["MapIndex"], RegenWallDefenders["IndexList"][ nMobTypeNum ], CurMob["x"], CurMob["y"], RegenWallDefenders["SameDirect"] )

			if nMobHandle ~= nil
			then
				local TempRegenTable = {}

				TempRegenTable["Index"] = RegenWallDefenders["IndexList"][ nMobTypeNum ]
				TempRegenTable["x"]		= CurMob["x"]
				TempRegenTable["y"]		= CurMob["y"]
				TempRegenTable["dir"]	= RegenWallDefenders["SameDirect"]
				TempRegenTable["bLive"] = true

				-- 다시 되살리기 위한 용도의 몹 정보
				Var["Enemy"][ nMobHandle ] 			= TempRegenTable
				Var["Enemy"]["WallDefenders"][ i ] 	= nMobHandle

				cSetAIScript ( MainLuaScriptPath, nMobHandle )
				cAIScriptFunc( nMobHandle, "Entrance", "WallDefenderRoutine" )

				-- 못움직이는 상태이상 셋팅
				cSetAbstate( nMobHandle, AbstateInfo["Index"], AbstateInfo["Strength"], AbstateInfo["KeepTime"] )
			else
				DebugLog( "FirstGateAndWall::Gen WallDefenders::nMobHandle is nil.(when i="..i..")" )
			end
		end


		-- 문열리면 움직이는 문 뒤의 돌격대 셋팅
		local RegenChargers = RegenInfo["Mob"]["FirstGateAndWall"]["Chargers"]
		local NumOfChargers = #RegenInfo["Mob"]["FirstGateAndWall"]["Chargers"]
		local AbstateInfo   = RegenChargers["AbstateBeforeOpening1stGate"]

		Var["Enemy"]["FirstChargers"] = {}

		for i = 1, NumOfChargers
		do
			local nChargerHandle = cMobRegen_XY( Var["MapIndex"], RegenChargers["Index"], RegenChargers[ i ]["x"], RegenChargers[ i ]["y"], RegenChargers["SameDirect"] )

			if nChargerHandle ~= nil
			then
				Var["Enemy"]["FirstChargers"][ i ] 	= nChargerHandle

				cSetAbstate( nChargerHandle, AbstateInfo["Index"], AbstateInfo["Strength"], AbstateInfo["KeepTime"] )
			else
				Var["Enemy"]["FirstChargers"][ i ] 	= -1
			end
		end

		-- 1번째 도어블럭 닫음
		cDoorAction( Var["Door1"], RegenInfo["Stuff"]["FirstGate"]["Block"], "close" )

		Var["FirstGateAndWall"]["bMobGateDamaged"] 		= false
		Var["FirstGateAndWall"]["bMobGateLive"] 	  	= true
		Var["FirstGateAndWall"]["bMobGateOpened"] 	  	= false

		Var["FirstGateAndWall"]["MobRevivalInterval"] 		= Var["CurSec"] + DelayTime["WallDefenderRevivalInterval"]
		Var["FirstGateAndWall"]["StartStep_N_DoorOpenGap"] 	= Var["CurSec"] + DelayTime["StartStep_N_DoorOpenGap"]
	end


	-- 일정 시간마다 성벽을 지키는 해골 궁수 되살리기
	if Var["FirstGateAndWall"]["MobRevivalInterval"] <= Var["CurSec"]
	then

		-- 다음 부활 시간 설정
		Var["FirstGateAndWall"]["MobRevivalInterval"] = Var["CurSec"] + DelayTime["WallDefenderRevivalInterval"]


		-- 죽은 해골 궁수 부활
		local NumOfWallDefenders = #RegenInfo["Mob"]["FirstGateAndWall"]["WallDefenders"]["CoordList"]
		local AbstateInfo 		 = RegenInfo["Mob"]["FirstGateAndWall"]["WallDefenders"]["AbstateAlways"]

		for i = 1, NumOfWallDefenders
		do
			local nCurHandle 	= Var["Enemy"]["WallDefenders"][ i ]
			local CurRegen 		= Var["Enemy"][ nCurHandle ]

			if CurRegen ~= nil
			then
				if CurRegen["bLive"] == false
				then
					local nNewHandle = cMobRegen_XY( Var["MapIndex"], CurRegen["Index"], CurRegen["x"], CurRegen["y"], CurRegen["dir"] )

					if nNewHandle ~= nil
					then
						local TempRegenTable = {}

						TempRegenTable["Index"] = CurRegen["Index"]
						TempRegenTable["x"]		= CurRegen["x"]
						TempRegenTable["y"]		= CurRegen["y"]
						TempRegenTable["dir"]	= CurRegen["dir"]
						TempRegenTable["bLive"] = true

						-- 죽었던 몹 정보 메모리 해제
						Var["Enemy"][ nCurHandle ] = nil

						-- 다시 젠 된 몹 정보 메모리 셋팅
						Var["Enemy"][ nNewHandle ] 			= TempRegenTable
						Var["Enemy"]["WallDefenders"][ i ] 	= nNewHandle

						cSetAIScript ( MainLuaScriptPath, nNewHandle )
						cAIScriptFunc( nNewHandle, "Entrance", "WallDefenderRoutine" )

						-- 못움직이는 상태이상 셋팅
						cSetAbstate( nNewHandle, AbstateInfo["Index"], AbstateInfo["Strength"], AbstateInfo["KeepTime"] )

					end
				end
			end
		end -- for 문
	end -- if문 : Var["FirstGateAndWall"]["MobRevivalInterval"] <= Var["CurSec"] //


	local bEndCondition = false

	-- 문 열리고 일정 시간 후 돌격대 상태이상 해제 - 움직일 수 있게 하기 & 다음 단계로
	if Var["FirstGateAndWall"]["bMobGateLive"] == false
	then
		-- 몹게이트 1 사망시 도어블럭 오픈
		if Var["FirstGateAndWall"]["bMobGateOpened"] == false
		then
			if Var["FirstGateAndWall"]["StartStep_N_DoorOpenGap"] <= Var["CurSec"]
			then
				cDoorAction( Var["Door1"], RegenInfo["Stuff"]["FirstGate"]["Block"], "open" )
				Var["FirstGateAndWall"]["bMobGateOpened"] = true
			end
		end

		if Var["FirstGateAndWall"]["WaitSecAfterOpeningGate"] == nil
		then
			Var["FirstGateAndWall"]["WaitSecAfterOpeningGate"] = Var["CurSec"] + DelayTime["GapGateOpenAndChargerAbstateReset"]
		end

		if Var["FirstGateAndWall"]["WaitSecAfterOpeningGate"] <= Var["CurSec"]
		then
			local RegenChargers = RegenInfo["Mob"]["FirstGateAndWall"]["Chargers"]
			local NumOfChargers = #RegenInfo["Mob"]["FirstGateAndWall"]["Chargers"]

			for i = 1, NumOfChargers
			do
				local nChargerHandle = Var["Enemy"]["FirstChargers"][ i ]

				if nChargerHandle ~= nil and nChargerHandle ~= -1
				then
					cResetAbstate( nChargerHandle, RegenChargers["AbstateBeforeOpening1stGate"]["Index"] )
				end
			end

			bEndCondition = true
		end

	end


	-- Fail Case : 전멸 시 혹은 플레이어가 아무도 없을 경우
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["FirstGateAndWall"] = nil
		return
	end

	-- Fail Case : 타임 오버
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["FirstGateAndWall"] = nil
		return
	end


	-- Next Case : 문 열리고 3초 뒤 돌격대 상태 이상이 해제 되어 움직일 수 있는 경우
	if bEndCondition == true
	then
		GoToNextStep( Var )
		Var["FirstGateAndWall"] = nil
		DebugLog( "End FirstGateAndWall" )
		return
	end

end


-- 사각 정원에서의 전투 : 5개의 카마리스를 파괴하라
function GardenSquare( Var )
cExecCheck "GardenSquare"


	if Var == nil
	then
		return
	end


	if Var["GardenSquare"] == nil
	then
		DebugLog( "Start GardenSquare" )
		Var["GardenSquare"] = {}


		-- 몹게이트 2 소환
		local RegenMobGate	= RegenInfo["Mob"]["GardenSquare"]["SecondMobGate"]
		local MobGateHandle	= nil

		MobGateHandle = cMobRegen_XY( Var["MapIndex"], RegenMobGate["Index"], RegenMobGate["x"], RegenMobGate["y"], RegenMobGate["dir"] )

		if MobGateHandle ~= nil
		then
			Var["Enemy"][ MobGateHandle ] 	= RegenMobGate
			Var["Enemy"]["Door2Mob"] 		= MobGateHandle

			cSetAIScript ( MainLuaScriptPath, MobGateHandle )
			cAIScriptFunc( MobGateHandle, "Entrance", "MobGateRoutine" )
			cAIScriptFunc( MobGateHandle, "NPCClick", "MobGateClick" )
		end


		-- 카마리스 5개 -- 죽으면 다음으로 넘어가는 문의 자물쇠가 하나씩 풀림
		local RegenKamaris		= RegenInfo["Mob"]["GardenSquare"]["Kamaris"]
		local RegenKamarisCoord	= RegenInfo["Mob"]["GardenSquare"]["Kamaris"]["CoordList"]
		local NumOfKamaris		= #RegenInfo["Mob"]["GardenSquare"]["Kamaris"]["CoordList"]

		for i = 1, NumOfKamaris
		do
			local KamarisHandle	= nil

			KamarisHandle = cMobRegen_XY( Var["MapIndex"], RegenKamaris["Index"], RegenKamarisCoord[ i ]["x"], RegenKamarisCoord[ i ]["y"], RegenKamaris["SameDirect"] )

			if KamarisHandle ~= nil
			then
				Var["Enemy"][ KamarisHandle ] = { Index = RegenKamaris["Index"], x = RegenKamarisCoord[ i ]["x"], y = RegenKamarisCoord[ i ]["y"], dir = RegenKamaris["SameDirect"] }

				cSetAIScript ( MainLuaScriptPath, KamarisHandle )
				cAIScriptFunc( KamarisHandle, "Entrance", "GardenKamarisRoutine" )
			end

		end


		-- 몹 그룹 젠
		local RegenGroup	= RegenInfo["Group"]["GardenSquare"]
		local NumOfGroup	= #RegenInfo["Group"]["GardenSquare"]

		for i = 1, NumOfGroup
		do
			cGroupRegenInstance( Var["MapIndex"], RegenInfo["Group"]["GardenSquare"][ i ] )
		end


		-- 2번째 도어블럭 닫음
		cDoorAction( Var["Door2"], RegenInfo["Stuff"]["SecondGate"]["Block"], "close" )


		Var["GardenSquare"]["bGateOpen"] = false
	end



	-- Fail Case : 전멸 시 혹은 플레이어가 아무도 없을 경우
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["GardenSquare"] = nil
		return
	end


	-- Fail Case : 타임 오버
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["GardenSquare"] = nil
		return
	end


	-- Next Case : 문이 열렸을 경우
	if Var["GardenSquare"]["bGateOpen"] == true
	then
		cMobDialog( Var["MapIndex"], NPC_GuardChat["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["Destroy5KamarisDialog"]["Index"] )

		GoToNextStep( Var )
		Var["GardenSquare"] = nil
		DebugLog( "End GardenSquare" )
		return
	end

end


-- 마지막 문에서의 전투 : 2개의 어둠의 비쥬를 넘어 문을 부숴라
function FinalGate( Var )
cExecCheck "FinalGate"

	if Var == nil
	then
		return
	end


	if Var["FinalGate"] == nil
	then
		DebugLog( "Start FinalGate" )
		Var["FinalGate"] = {}


		-- 몹게이트 3 소환 - 이걸 직접 공격해야함
		local RegenMobGate	= RegenInfo["Mob"]["FinalGate"]["ThirdMobGate"]
		local MobGateHandle	= nil

		MobGateHandle = cMobRegen_XY( Var["MapIndex"], RegenMobGate["Index"], RegenMobGate["x"], RegenMobGate["y"], RegenMobGate["dir"] )

		if MobGateHandle ~= nil
		then
			Var["Enemy"][ MobGateHandle ] = RegenMobGate
			Var["Enemy"]["Door3Mob"] 	  = MobGateHandle

			cSetAIScript ( MainLuaScriptPath, MobGateHandle )
			cAIScriptFunc( MobGateHandle, "Entrance", "MobGateRoutine" )
		end


		-- 카마리스 2개 -- 어둠의 비쥬
		local RegenBijou		= RegenInfo["Mob"]["FinalGate"]["BijouOfDarknesss"]
		local RegenBijouCoord	= RegenInfo["Mob"]["FinalGate"]["BijouOfDarknesss"]["CoordList"]
		local NumOfBijou		= #RegenInfo["Mob"]["FinalGate"]["BijouOfDarknesss"]["CoordList"]

		for i = 1, NumOfBijou
		do
			cMobRegen_XY( Var["MapIndex"], RegenBijou["Index"], RegenBijouCoord[ i ]["x"], RegenBijouCoord[ i ]["y"], RegenBijou["SameDirect"] )
		end


		-- 문열리면 움직이는 문 뒤의 돌격대 셋팅
		local RegenChargers = RegenInfo["Mob"]["FinalGate"]["Chargers"]
		local NumOfChargers = #RegenInfo["Mob"]["FinalGate"]["Chargers"]
		local AbstateInfo   = RegenChargers["AbstateBeforeOpening2stGate"]

		Var["Enemy"]["SecondChargers"] = {}

		for i = 1, NumOfChargers
		do
			local nChargerHandle = cMobRegen_XY( Var["MapIndex"], RegenChargers["Index"], RegenChargers[ i ]["x"], RegenChargers[ i ]["y"], RegenChargers["SameDirect"] )

			if nChargerHandle ~= nil
			then
				Var["Enemy"]["SecondChargers"][ i ] = nChargerHandle

				cSetAbstate( nChargerHandle, AbstateInfo["Index"], AbstateInfo["Strength"], AbstateInfo["KeepTime"] )
			else
				Var["Enemy"]["SecondChargers"][ i ] = -1
			end
		end


		-- 3번째 도어블럭 닫음
		cDoorAction( Var["Door3"], RegenInfo["Stuff"]["ThirdGate"]["Block"], "close" )


		Var["FinalGate"]["bMobGateLive"] 	= true
		Var["FinalGate"]["bMobGateOpened"] 	= false

		Var["FinalGate"]["StartStep_N_DoorOpenGap"] = Var["CurSec"] + DelayTime["StartStep_N_DoorOpenGap"]

	end


	local bEndCondition = false

	-- 문 열리고 일정 시간 후 돌격대 상태이상 해제 - 움직일 수 있게 하기 & 다음 단계로
	if Var["FinalGate"]["bMobGateLive"] == false
	then
		-- 몹게이트 3 사망시 도어블럭 오픈
		if Var["FinalGate"]["bMobGateOpened"] == false
		then
			if Var["FinalGate"]["StartStep_N_DoorOpenGap"] <= Var["CurSec"]
			then
				cDoorAction( Var["Door3"], RegenInfo["Stuff"]["ThirdGate"]["Block"], "open" )
				Var["FinalGate"]["bMobGateOpened"] = true
			end
		end

		if Var["FinalGate"]["WaitSecAfterOpeningGate"] == nil
		then
			Var["FinalGate"]["WaitSecAfterOpeningGate"] = Var["CurSec"] + DelayTime["GapGateOpenAndChargerAbstateReset"]
		end

		if Var["FinalGate"]["WaitSecAfterOpeningGate"] <= Var["CurSec"]
		then
			local RegenChargers = RegenInfo["Mob"]["FinalGate"]["Chargers"]
			local NumOfChargers = #RegenInfo["Mob"]["FinalGate"]["Chargers"]

			for i = 1, NumOfChargers
			do
				local nChargerHandle = Var["Enemy"]["SecondChargers"][ i ]

				if nChargerHandle ~= nil and nChargerHandle ~= -1
				then
					cResetAbstate( nChargerHandle, RegenChargers["AbstateBeforeOpening2stGate"]["Index"] )
				end
			end

			bEndCondition = true
		end

	end


	-- Fail Case : 전멸 시 혹은 플레이어가 아무도 없을 경우
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["FinalGate"] = nil
		return
	end


	-- Fail Case : 타임 오버
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["FinalGate"] = nil
		return
	end


	-- Next Case : 문 열리고 3초 뒤 돌격대 상태 이상이 해제 되어 움직일 수 있는 경우
	if bEndCondition == true
	then
		GoToNextStep( Var )
		Var["FinalGate"] = nil
		DebugLog( "End FinalGate" )
		return
	end

end


-- 칼반오벳이 있는 정원에서 카마리스를 모두 파괴 하고 칼반 오벳을 쓰러뜨려라
function EndOfLegend( Var )
cExecCheck "EndOfLegend"

	if Var == nil
	then
		return
	end


	if Var["EndOfLegend"] == nil
	then
		DebugLog( "Start EndOfLegend" )
		Var["EndOfLegend"] = {}


		-- 카마리스 4개 -- 칼반 오벳을 소환하기 위해서는 4개의 카마리스가 모두 파괴되어야 함
		local RegenKamaris		= RegenInfo["Mob"]["EndOfLegend"]["Kamaris"]
		local RegenKamarisCoord	= RegenInfo["Mob"]["EndOfLegend"]["Kamaris"]["CoordList"]
		local NumOfKamaris		= #RegenInfo["Mob"]["EndOfLegend"]["Kamaris"]["CoordList"]

		for i = 1, NumOfKamaris
		do
			local KamarisHandle	= nil

			KamarisHandle = cMobRegen_XY( Var["MapIndex"], RegenKamaris["Index"], RegenKamarisCoord[ i ]["x"], RegenKamarisCoord[ i ]["y"], RegenKamaris["SameDirect"] )

			if KamarisHandle ~= nil
			then
				Var["Enemy"][ KamarisHandle ] = { Index = RegenKamaris["Index"], x = RegenKamarisCoord[ i ]["x"], y = RegenKamarisCoord[ i ]["y"], dir = RegenKamaris["SameDirect"] }

				cSetAIScript ( MainLuaScriptPath, KamarisHandle )
				cAIScriptFunc( KamarisHandle, "Entrance", "GardenKamarisRoutine" )
			end

		end


		-- 몹 그룹 젠
		local RegenGroup	= RegenInfo["Group"]["EndOfLegend"]
		local NumOfGroup	= #RegenInfo["Group"]["EndOfLegend"]

		for i = 1, NumOfGroup
		do
			cGroupRegenInstance( Var["MapIndex"], RegenInfo["Group"]["EndOfLegend"][ i ] )
		end

		Var["EndOfLegend"]["bBossDied"] 	= false

		Var["EndOfLegend"]["DialogStepNo"]	= 1
		Var["EndOfLegend"]["DialogStepSec"] = Var["CurSec"] + DelayTime["GapBeforeBossSquareDialog"]
	end


	-- 보스방 들어오면서 경비병이 힌트를 알려줌
	if Var["EndOfLegend"]["DialogStepNo"] <= #NPC_GuardChat["BeforeBossSquareDialog"]
	then
		if Var["EndOfLegend"]["DialogStepSec"] <= Var["CurSec"]
		then
			cMobDialog( Var["MapIndex"], NPC_GuardChat["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["BeforeBossSquareDialog"][ Var["EndOfLegend"]["DialogStepNo"] ]["Index"] )

			Var["EndOfLegend"]["DialogStepSec"] = Var["CurSec"] + DelayTime["GapBeforeBossSquareDialog"]
			Var["EndOfLegend"]["DialogStepNo"]	= Var["EndOfLegend"]["DialogStepNo"] + 1
		end
	end


	-- 카마리스 전멸시 보스 소환
	if Var["CallBossLock"] == 0
	then
		-- 한번만 실행되도록 초기화 시킴
		Var["CallBossLock"] = nil

		cMobDialog( Var["MapIndex"], NPC_GuardChat["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["BossAppearedDialog"]["Index"] )

		local RegenBoss  = RegenInfo["Mob"]["EndOfLegend"]["KalBanObet"]
		local BossHandle = cMobRegen_XY( Var["MapIndex"], RegenBoss["Index"], RegenBoss["x"], RegenBoss["y"], RegenBoss["dir"] )

		if BossHandle ~= nil
		then
			Var["Enemy"][ BossHandle ] = RegenBoss

			cSetAIScript ( MainLuaScriptPath, BossHandle )
			cAIScriptFunc( BossHandle, "Entrance", "BossRoutine" )
		end
	end


	-- Fail Case : 전멸 시 혹은 플레이어가 아무도 없을 경우
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["EndOfLegend"] = nil
		return
	end


	-- Fail Case : 타임 오버
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["EndOfLegend"] = nil
		return
	end


	-- Success Case : 보스 사망(칼반 오벳)
	if Var["EndOfLegend"]["bBossDied"] == true
	then
		GoToSuccess( Var )
		Var["EndOfLegend"] = nil
		DebugLog( "End EndOfLegend" )
		return
	end

end


-- 킹덤 퀘스트 클리어
function QuestSuccess( Var )
cExecCheck "QuestSuccess"

	if Var == nil
	then
		return
	end


	if Var["QuestSuccess"] == nil
	then

		DebugLog( "Start QuestSuccess" )

		-- Success 띄우고
		cVanishTimer( Var["MapIndex"] )
		cQuestResult( Var["MapIndex"], "Success" )

		-- 플레이어에게 클리어 보상 주기
		cReward( Var["MapIndex"], "KQ" )

		-- Quest Mob Kill 세기.
		cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )

		Var["QuestSuccess"] = {}
		Var["QuestSuccess"]["SuccessStepSec"] 	= Var["CurSec"]
		Var["QuestSuccess"]["SuccessStepNo"] 	= 1

	end


	-- 경비창병의 메세지
	if Var["QuestSuccess"]["SuccessStepNo"] <= #NPC_GuardChat["CongratulateSuccessDialog"]
	then

		if Var["QuestSuccess"]["SuccessStepSec"] <= Var["CurSec"]
		then
			local GuardDialog = NPC_GuardChat["CongratulateSuccessDialog"]

			cMobDialog( Var["MapIndex"], NPC_GuardChat["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], GuardDialog[ Var["QuestSuccess"]["SuccessStepNo"] ]["Index"] )

			Var["QuestSuccess"]["SuccessStepNo"]	= Var["QuestSuccess"]["SuccessStepNo"] + 1		-- go to next dialog
			Var["QuestSuccess"]["SuccessStepSec"]	= Var["CurSec"] + DelayTime["GapSuccessDialog"]	-- set time for changing step

		end

		return
	end

	-- 다이얼로그 끝
	if Var["QuestSuccess"]["SuccessStepNo"] > #NPC_GuardChat["CongratulateSuccessDialog"]
	then

		if Var["QuestSuccess"]["SuccessStepSec"] <= Var["CurSec"]
		then
			GoToNextStep( Var )
			Var["QuestSuccess"] = nil
			DebugLog( "End QuestSuccess" )
		end

	end

end


-- 킹덤 퀘스트 실패
function QuestFailed( Var )
cExecCheck "QuestFailed"

	if Var == nil
	then
		return
	end


	DebugLog( "Start QuestFailed" )
	Var["QuestFailed"] = {}

	-- Fail 띄우고
	cVanishTimer( Var["MapIndex"] )
	cQuestResult( Var["MapIndex"], "Fail" )

	GoToNextStep( Var )

	DebugLog( "End QuestFailed" )


end


-- 귀환
function ReturnToHome( Var )
cExecCheck "ReturnToHome"

	if Var == nil
	then
		return
	end


	if Var["ReturnToHome"] == nil
	then
		DebugLog( "Start ReturnToHome" )

		Var["ReturnToHome"] = {}
		Var["ReturnToHome"]["ReturnStepSec"] = Var["CurSec"]

		if Var["QuestFailed"] == nil
		then
			-- 성공시
			Var["ReturnToHome"]["ReturnStepNo"] = 1
		else
			-- 실패시
			Var["ReturnToHome"]["ReturnStepNo"] = #NoticeInfo["KQReturn"]
			Var["QuestFailed"] = nil
		end
	end


	-- Return : return notice substep
	if Var["ReturnToHome"]["ReturnStepNo"] <= #NoticeInfo["KQReturn"]
	then

		if Var["ReturnToHome"]["ReturnStepSec"] <= Var["CurSec"]
		then

			-- Notice of Escape
			if NoticeInfo["KQReturn"][ Var["ReturnToHome"]["ReturnStepNo"] ]["Index"] ~= nil
			then
				cNotice( Var["MapIndex"], NoticeInfo["ScriptFileName"], NoticeInfo["KQReturn"][ Var["ReturnToHome"]["ReturnStepNo"] ]["Index"] )
			end

			-- Go To Next Notice
			Var["ReturnToHome"]["ReturnStepNo"]  = Var["ReturnToHome"]["ReturnStepNo"] + 1
			Var["ReturnToHome"]["ReturnStepSec"] = Var["CurSec"] + DelayTime["GapKQReturnNotice"]

		end

		return

	end


	-- Return : linkto substep
	if Var["ReturnToHome"]["ReturnStepNo"] > #NoticeInfo["KQReturn"]
	then

		if Var["ReturnToHome"]["ReturnStepSec"] <= Var["CurSec"]
		then
			--Finish_KQ
			cLinkToAll( Var["MapIndex"], LinkInfo["ReturnMap"]["MapIndex"], LinkInfo["ReturnMap"]["x"], LinkInfo["ReturnMap"]["y"] )

			GoToNextStep( Var )
			Var["ReturnToHome"] = nil

			if cEndOfKingdomQuest( Var["MapIndex"] ) == nil
			then
				ErrorLog( "ReturnToHome::Function cEndOfKingdomQuest failed" )
			end

			DebugLog( "End ReturnToHome" )
		end

		return

	end


end


-- 스텝 구분을 위한 던전 진행 함수 리스트
KQ_StepsList =
{
	{ Function = InitDungeon,  			Name = "InitDungeon",		},
	{ Function = CommandOfGuard, 		Name = "CommandOfGuard",	},
	{ Function = FirstGateAndWall,   	Name = "FirstGateAndWall",	},
	{ Function = GardenSquare,  		Name = "GardenSquare",  	},
	{ Function = FinalGate, 			Name = "FinalGate", 		},
	{ Function = EndOfLegend,     		Name = "EndOfLegend",		},
	{ Function = QuestSuccess, 			Name = "QuestSuccess",		},
	{ Function = QuestFailed,  			Name = "QuestFailed",		},
	{ Function = ReturnToHome, 			Name = "ReturnToHome",		},
}

-- 역참조 리스트
KQ_StepsIndexList =
{
}

for index, funcValue in pairs ( KQ_StepsList )
do
	KQ_StepsIndexList[ funcValue["Name"] ] = index
end

