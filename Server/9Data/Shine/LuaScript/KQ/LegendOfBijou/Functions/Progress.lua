--------------------------------------------------------------------------------
--                    Legend Of Bijou Progress Func                           --
--------------------------------------------------------------------------------

-- ���� �ʱ�ȭ
function InitDungeon( Var )
cExecCheck "InitDungeon"

	if Var == nil
	then
		return
	end

	-- ŷ�� ����Ʈ ���� ���� �÷��̾��� ù �α����� ��ٸ���.
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

		-- �� ����
		Var["Door1"] = cDoorBuild( Var["MapIndex"], Door1["Index"], Door1["x"], Door1["y"], Door1["dir"], Door1["scale"] )
		Var["Door2"] = cDoorBuild( Var["MapIndex"], Door2["Index"], Door2["x"], Door2["y"], Door2["dir"], Door2["scale"] )
		Var["Door3"] = cDoorBuild( Var["MapIndex"], Door3["Index"], Door3["x"], Door3["y"], Door3["dir"], Door3["scale"] )

		-- �� �ݱ�
		cDoorAction( Var["Door1"], Door1["Block"], "open" )
		cDoorAction( Var["Door2"], Door2["Block"], "open" )
		cDoorAction( Var["Door3"], Door3["Block"], "open" )

		-- �ι�° ���� ī������ ����ŭ �ڹ��� �ɱ�
		Var["Door2Lock"] = #RegenInfo["Mob"]["GardenSquare"]["Kamaris"]["CoordList"]

		-- ���� : Į�� ������ �θ��� ���� �ν��� �ϴ� �ش� ��ġ�� ī������ �� ����
		Var["CallBossLock"] = #RegenInfo["Mob"]["EndOfLegend"]["Kamaris"]["CoordList"]

		-- �Ȱ� ����
		cMapFog( Var["MapIndex"], MapFogInfo["FogValue"], MapFogInfo["SightDistance"] )

		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"] + DelayTime["AfterInit"]

	end


	-- ���� �ð� �� ���� �ܰ��
	if Var["InitDungeon"]["WaitSecDuringInit"] <= Var["CurSec"]
	then
		GoToNextStep( Var )
		Var["InitDungeon"] = nil
		DebugLog( "End InitDungeon" )
		return
	end

end


-- ������� ����
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
		-- Real Kingdom Quest ���� !!!!
		Var["KQLimitTime"] = Var["CurSec"] + nLimitSec
		-- Ÿ�̸� ����!
		cShowKQTimerWithLife( Var["MapIndex"], nLimitSec )
	end


	DebugLog( "End CommandOfGuard" )

	return

end


-- �ذ�ü��� ��Ű�� �ִ� ����, ù��° ���� �����϶�
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


		-- ������Ʈ 1 ��ȯ
		local RegenMobGate	= RegenInfo["Mob"]["FirstGateAndWall"]["FirstMobGate"]
		local MobGateHandle	= nil

		MobGateHandle = cMobRegen_XY( Var["MapIndex"], RegenMobGate["Index"], RegenMobGate["x"], RegenMobGate["y"], RegenMobGate["dir"] )

		if MobGateHandle ~= nil
		then
			Var["Enemy"][ MobGateHandle ] = RegenMobGate

			cSetAIScript ( MainLuaScriptPath, MobGateHandle )
			cAIScriptFunc( MobGateHandle, "Entrance", "MobGateRoutine" )
		end


		-- ù��° ī������
		local Regen1stKamaris	= RegenInfo["Mob"]["FirstGateAndWall"]["FirstKamaris"]
		local KamarisHandle		= nil

		KamarisHandle = cMobRegen_XY( Var["MapIndex"], Regen1stKamaris["Index"], Regen1stKamaris["x"], Regen1stKamaris["y"], Regen1stKamaris["dir"] )

		if KamarisHandle ~= nil
		then
			cSetAIScript ( MainLuaScriptPath, KamarisHandle )
			cAIScriptFunc( KamarisHandle, "Entrance", "TeleportKamarisRoutine" )

			Var["Enemy"][ KamarisHandle ] = Regen1stKamaris
		end


		-- ������ ��Ű�� �ذ� �ü���
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

				-- �ٽ� �ǻ츮�� ���� �뵵�� �� ����
				Var["Enemy"][ nMobHandle ] 			= TempRegenTable
				Var["Enemy"]["WallDefenders"][ i ] 	= nMobHandle

				cSetAIScript ( MainLuaScriptPath, nMobHandle )
				cAIScriptFunc( nMobHandle, "Entrance", "WallDefenderRoutine" )

				-- �������̴� �����̻� ����
				cSetAbstate( nMobHandle, AbstateInfo["Index"], AbstateInfo["Strength"], AbstateInfo["KeepTime"] )
			else
				DebugLog( "FirstGateAndWall::Gen WallDefenders::nMobHandle is nil.(when i="..i..")" )
			end
		end


		-- �������� �����̴� �� ���� ���ݴ� ����
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

		-- 1��° ����� ����
		cDoorAction( Var["Door1"], RegenInfo["Stuff"]["FirstGate"]["Block"], "close" )

		Var["FirstGateAndWall"]["bMobGateDamaged"] 		= false
		Var["FirstGateAndWall"]["bMobGateLive"] 	  	= true
		Var["FirstGateAndWall"]["bMobGateOpened"] 	  	= false

		Var["FirstGateAndWall"]["MobRevivalInterval"] 		= Var["CurSec"] + DelayTime["WallDefenderRevivalInterval"]
		Var["FirstGateAndWall"]["StartStep_N_DoorOpenGap"] 	= Var["CurSec"] + DelayTime["StartStep_N_DoorOpenGap"]
	end


	-- ���� �ð����� ������ ��Ű�� �ذ� �ü� �ǻ츮��
	if Var["FirstGateAndWall"]["MobRevivalInterval"] <= Var["CurSec"]
	then

		-- ���� ��Ȱ �ð� ����
		Var["FirstGateAndWall"]["MobRevivalInterval"] = Var["CurSec"] + DelayTime["WallDefenderRevivalInterval"]


		-- ���� �ذ� �ü� ��Ȱ
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

						-- �׾��� �� ���� �޸� ����
						Var["Enemy"][ nCurHandle ] = nil

						-- �ٽ� �� �� �� ���� �޸� ����
						Var["Enemy"][ nNewHandle ] 			= TempRegenTable
						Var["Enemy"]["WallDefenders"][ i ] 	= nNewHandle

						cSetAIScript ( MainLuaScriptPath, nNewHandle )
						cAIScriptFunc( nNewHandle, "Entrance", "WallDefenderRoutine" )

						-- �������̴� �����̻� ����
						cSetAbstate( nNewHandle, AbstateInfo["Index"], AbstateInfo["Strength"], AbstateInfo["KeepTime"] )

					end
				end
			end
		end -- for ��
	end -- if�� : Var["FirstGateAndWall"]["MobRevivalInterval"] <= Var["CurSec"] //


	local bEndCondition = false

	-- �� ������ ���� �ð� �� ���ݴ� �����̻� ���� - ������ �� �ְ� �ϱ� & ���� �ܰ��
	if Var["FirstGateAndWall"]["bMobGateLive"] == false
	then
		-- ������Ʈ 1 ����� ����� ����
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


	-- Fail Case : ���� �� Ȥ�� �÷��̾ �ƹ��� ���� ���
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["FirstGateAndWall"] = nil
		return
	end

	-- Fail Case : Ÿ�� ����
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["FirstGateAndWall"] = nil
		return
	end


	-- Next Case : �� ������ 3�� �� ���ݴ� ���� �̻��� ���� �Ǿ� ������ �� �ִ� ���
	if bEndCondition == true
	then
		GoToNextStep( Var )
		Var["FirstGateAndWall"] = nil
		DebugLog( "End FirstGateAndWall" )
		return
	end

end


-- �簢 ���������� ���� : 5���� ī�������� �ı��϶�
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


		-- ������Ʈ 2 ��ȯ
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


		-- ī������ 5�� -- ������ �������� �Ѿ�� ���� �ڹ��谡 �ϳ��� Ǯ��
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


		-- �� �׷� ��
		local RegenGroup	= RegenInfo["Group"]["GardenSquare"]
		local NumOfGroup	= #RegenInfo["Group"]["GardenSquare"]

		for i = 1, NumOfGroup
		do
			cGroupRegenInstance( Var["MapIndex"], RegenInfo["Group"]["GardenSquare"][ i ] )
		end


		-- 2��° ����� ����
		cDoorAction( Var["Door2"], RegenInfo["Stuff"]["SecondGate"]["Block"], "close" )


		Var["GardenSquare"]["bGateOpen"] = false
	end



	-- Fail Case : ���� �� Ȥ�� �÷��̾ �ƹ��� ���� ���
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["GardenSquare"] = nil
		return
	end


	-- Fail Case : Ÿ�� ����
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["GardenSquare"] = nil
		return
	end


	-- Next Case : ���� ������ ���
	if Var["GardenSquare"]["bGateOpen"] == true
	then
		cMobDialog( Var["MapIndex"], NPC_GuardChat["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["Destroy5KamarisDialog"]["Index"] )

		GoToNextStep( Var )
		Var["GardenSquare"] = nil
		DebugLog( "End GardenSquare" )
		return
	end

end


-- ������ �������� ���� : 2���� ����� ���긦 �Ѿ� ���� �ν���
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


		-- ������Ʈ 3 ��ȯ - �̰� ���� �����ؾ���
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


		-- ī������ 2�� -- ����� ����
		local RegenBijou		= RegenInfo["Mob"]["FinalGate"]["BijouOfDarknesss"]
		local RegenBijouCoord	= RegenInfo["Mob"]["FinalGate"]["BijouOfDarknesss"]["CoordList"]
		local NumOfBijou		= #RegenInfo["Mob"]["FinalGate"]["BijouOfDarknesss"]["CoordList"]

		for i = 1, NumOfBijou
		do
			cMobRegen_XY( Var["MapIndex"], RegenBijou["Index"], RegenBijouCoord[ i ]["x"], RegenBijouCoord[ i ]["y"], RegenBijou["SameDirect"] )
		end


		-- �������� �����̴� �� ���� ���ݴ� ����
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


		-- 3��° ����� ����
		cDoorAction( Var["Door3"], RegenInfo["Stuff"]["ThirdGate"]["Block"], "close" )


		Var["FinalGate"]["bMobGateLive"] 	= true
		Var["FinalGate"]["bMobGateOpened"] 	= false

		Var["FinalGate"]["StartStep_N_DoorOpenGap"] = Var["CurSec"] + DelayTime["StartStep_N_DoorOpenGap"]

	end


	local bEndCondition = false

	-- �� ������ ���� �ð� �� ���ݴ� �����̻� ���� - ������ �� �ְ� �ϱ� & ���� �ܰ��
	if Var["FinalGate"]["bMobGateLive"] == false
	then
		-- ������Ʈ 3 ����� ����� ����
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


	-- Fail Case : ���� �� Ȥ�� �÷��̾ �ƹ��� ���� ���
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["FinalGate"] = nil
		return
	end


	-- Fail Case : Ÿ�� ����
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["FinalGate"] = nil
		return
	end


	-- Next Case : �� ������ 3�� �� ���ݴ� ���� �̻��� ���� �Ǿ� ������ �� �ִ� ���
	if bEndCondition == true
	then
		GoToNextStep( Var )
		Var["FinalGate"] = nil
		DebugLog( "End FinalGate" )
		return
	end

end


-- Į�ݿ����� �ִ� �������� ī�������� ��� �ı� �ϰ� Į�� ������ �����߷���
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


		-- ī������ 4�� -- Į�� ������ ��ȯ�ϱ� ���ؼ��� 4���� ī�������� ��� �ı��Ǿ�� ��
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


		-- �� �׷� ��
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


	-- ������ �����鼭 ����� ��Ʈ�� �˷���
	if Var["EndOfLegend"]["DialogStepNo"] <= #NPC_GuardChat["BeforeBossSquareDialog"]
	then
		if Var["EndOfLegend"]["DialogStepSec"] <= Var["CurSec"]
		then
			cMobDialog( Var["MapIndex"], NPC_GuardChat["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["BeforeBossSquareDialog"][ Var["EndOfLegend"]["DialogStepNo"] ]["Index"] )

			Var["EndOfLegend"]["DialogStepSec"] = Var["CurSec"] + DelayTime["GapBeforeBossSquareDialog"]
			Var["EndOfLegend"]["DialogStepNo"]	= Var["EndOfLegend"]["DialogStepNo"] + 1
		end
	end


	-- ī������ ����� ���� ��ȯ
	if Var["CallBossLock"] == 0
	then
		-- �ѹ��� ����ǵ��� �ʱ�ȭ ��Ŵ
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


	-- Fail Case : ���� �� Ȥ�� �÷��̾ �ƹ��� ���� ���
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["EndOfLegend"] = nil
		return
	end


	-- Fail Case : Ÿ�� ����
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["EndOfLegend"] = nil
		return
	end


	-- Success Case : ���� ���(Į�� ����)
	if Var["EndOfLegend"]["bBossDied"] == true
	then
		GoToSuccess( Var )
		Var["EndOfLegend"] = nil
		DebugLog( "End EndOfLegend" )
		return
	end

end


-- ŷ�� ����Ʈ Ŭ����
function QuestSuccess( Var )
cExecCheck "QuestSuccess"

	if Var == nil
	then
		return
	end


	if Var["QuestSuccess"] == nil
	then

		DebugLog( "Start QuestSuccess" )

		-- Success ����
		cVanishTimer( Var["MapIndex"] )
		cQuestResult( Var["MapIndex"], "Success" )

		-- �÷��̾�� Ŭ���� ���� �ֱ�
		cReward( Var["MapIndex"], "KQ" )

		-- Quest Mob Kill ����.
		cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )

		Var["QuestSuccess"] = {}
		Var["QuestSuccess"]["SuccessStepSec"] 	= Var["CurSec"]
		Var["QuestSuccess"]["SuccessStepNo"] 	= 1

	end


	-- ���â���� �޼���
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

	-- ���̾�α� ��
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


-- ŷ�� ����Ʈ ����
function QuestFailed( Var )
cExecCheck "QuestFailed"

	if Var == nil
	then
		return
	end


	DebugLog( "Start QuestFailed" )
	Var["QuestFailed"] = {}

	-- Fail ����
	cVanishTimer( Var["MapIndex"] )
	cQuestResult( Var["MapIndex"], "Fail" )

	GoToNextStep( Var )

	DebugLog( "End QuestFailed" )


end


-- ��ȯ
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
			-- ������
			Var["ReturnToHome"]["ReturnStepNo"] = 1
		else
			-- ���н�
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


-- ���� ������ ���� ���� ���� �Լ� ����Ʈ
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

-- ������ ����Ʈ
KQ_StepsIndexList =
{
}

for index, funcValue in pairs ( KQ_StepsList )
do
	KQ_StepsIndexList[ funcValue["Name"] ] = index
end

