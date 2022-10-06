--------------------------------------------------------------------------------
--                      	Progress Func 			                          --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- InitDungeon
--------------------------------------------------------------------------------
-- 던전 초기화
function InitDungeon( Var )
cExecCheck "InitDungeon"


	if Var == nil
	then
		ErrorLog( "InitDungeon :: Var == nil" )
		return
	end


	-- 인스턴스 던전 시작 전에 플레이어의 첫 로그인을 기다린다.
	if Var["bPlayerMapLogin"] == nil
	then
		if Var["InitialSec"] + WAIT_PLAYER_MAP_LOGIN_SEC_MAX <= cCurrentSecond()
		then
			--GoToFail( Var )
			return
		end

		return
	end


	if Var["InitDungeon"] == nil
	then
		DebugLog( "InitDungeon :: Start InitDungeon" )

		Var["InitDungeon"] 							= {}
		Var["InitDungeon"]["WaitSecDuringInit"] 	= Var["CurSec"] + DelayTime["AfterInit"]


		-- 문 생성
		DebugLog( "InitDungeon :: Door Build Start" )
		for i = 1, #RegenInfo["Stuff"]["Door"]
		do
			local CurRegenDoor 	= RegenInfo["Stuff"]["Door"][ i ]

			if CurRegenDoor == nil
			then
				ErrorLog( "InitDungeon::Door CurRegenDoor == nil : "..i )
			else
				local nCurDoorHandle = cDoorBuild( Var["MapIndex"], CurRegenDoor["Index"], CurRegenDoor["x"], CurRegenDoor["y"], CurRegenDoor["dir"], CurRegenDoor["scale"] )

				if nCurDoorHandle == nil
				then
					ErrorLog( "InitDungeon::Door was not created. : "..i )
				else
					cDoorAction( nCurDoorHandle, CurRegenDoor["Block"], "close" )

					-- 문 정보 보관
					Var["Door"][ nCurDoorHandle ]			= {}
					Var["Door"][ nCurDoorHandle ]["Info"]	= CurRegenDoor
					Var["Door"][ CurRegenDoor["Name"] ] 	= nCurDoorHandle

				end
			end
		end


		-- 입구쪽 출구게이트 생성
		local RegenExitGate  	= RegenInfo["Stuff"]["StartExitGate"]
		local nExitGateHandle 	= cDoorBuild( Var["MapIndex"], RegenExitGate["Index"], RegenExitGate["x"], RegenExitGate["y"], RegenExitGate["dir"], RegenExitGate["scale"] )

		if nExitGateHandle ~= nil
		then
			DebugLog("InitDungeon::입구쪽 출구게이트 생성")

			if cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil
			then
				ErrorLog( "InitDungeon::cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil" )
			end

			if cAIScriptFunc( nExitGateHandle, "NPCClick", "Click_ExitGate" ) == nil
			then
				ErrorLog( "InitDungeon::cAIScriptFunc( nExitGateHandle, \"NPCClick\", \"Click_ExitGate\" ) == nil" )
			end
		end


		-- A, B 영역 몬스터 그룹별 생성
		local RegenMobGroupList = DoorMobRegenInfo["start"]
		if RegenMobGroupList == nil
		then
			ErrorLog( "DoorMobRegenInfo[\"start\"] == nil" )
		end

		if RegenMobGroupList ~= nil
		then
			DebugLog("InitDungeon :: A 영역, B영역 몬스터 생성")

			for i = 1, #RegenMobGroupList
			do
				local MobGroupNum	= RegenMobGroupList[i]["MobGroupNum"]
				local MobGroupIdx	= Var["AreaMobGroup"][MobGroupNum]
				local RegenX		= RegenMobGroupList[i]["x"]
				local RegenY		= RegenMobGroupList[i]["y"]

				DebugLog( MobGroupNum..", Regen MobGroupIdx: \""..MobGroupIdx.."\" is Success" )

				if cGroupRegenInstance_XY( Var["MapIndex"], MobGroupIdx, RegenX, RegenY ) == nil
				then
					ErrorLog( "InitDungeon :: MobGroup Regen Fail"..MobGroupIdx )
				end
			end
		end


		-- 밀드윈 소환
		local MildWinInfo 			= RegenInfo["Mob"]["InitDungeon"]["MildWin"]
		local MildWinHandle 		= cMobRegen_XY( Var["MapIndex"], MildWinInfo["Index"], MildWinInfo["x"], MildWinInfo["y"] )
		if MildWinHandle == nil
		then
			ErrorLog( "InitDungeon :: MildWin Regen Fail" )
		else
			Var["Enemy"]["MildWin"]	= MildWinHandle
		end

	end


	-- 대기 후 다음 단계로
	if Var["InitDungeon"]["WaitSecDuringInit"] > Var["CurSec"]
	then
		return
	end


	Var["StepFunc"] 			= WayToBossRoom_FaceCut
	Var["InitDungeon"] 			= nil
	DebugLog( "End InitDungeon" )

end


--------------------------------------------------------------------------------
-- WayToBossRoom
--------------------------------------------------------------------------------

function WayToBossRoom_FaceCut( Var )
cExecCheck "WayToBossRoom_FaceCut"


	if Var == nil
	then
		ErrorLog( "WayToBossRoom_FaceCut :: Var == nil" )
		return
	end



	if Var["WayToBossRoom_FaceCut"] == nil
	then
		DebugLog( "Start WayToBossRoom_FaceCut" )

		Var["WayToBossRoom_FaceCut"] 				= {}
		Var["WayToBossRoom_FaceCut"]["DidFaceCut"] 	= { false, false, false, false, false }
		Var["WayToBossRoom_FaceCut"]["Info"]		= {}
	end



	local AStep 	= Var["RootManager"]["RootA"]
	local BStep 	= Var["RootManager"]["RootB"]
	local Step

	if AStep >= BStep
	then
		Step = AStep
	else
		Step = BStep
	end


	local CurStepDidFaceCut = Var["WayToBossRoom_FaceCut"]["DidFaceCut"][Step]
	if CurStepDidFaceCut == true
	then
		return
	end


	-- 대사 처리완료했다고 변수 세팅
	if Var["WayToBossRoom_FaceCut"]["Info"][Step] == nil
	then
		Var["WayToBossRoom_FaceCut"]["Info"][Step] = {}
		Var["WayToBossRoom_FaceCut"]["Info"][Step]["DialogTime"]	= Var["CurSec"]
		Var["WayToBossRoom_FaceCut"]["Info"][Step]["DialogStep"]	= 1
	end



	-- 대사처리
	if Var["WayToBossRoom_FaceCut"]["Info"][Step]["DialogTime"] ~= nil
	then

		if Var["WayToBossRoom_FaceCut"]["Info"][Step]["DialogTime"] > Var["CurSec"]
		then
			return
		else
			local CurMsg 			= ChatInfo["WayToBossRoom_FaceCut"][Step]
			local DialogStep		= Var["WayToBossRoom_FaceCut"]["Info"][Step]["DialogStep"]
			local MaxDialogStep		= #ChatInfo["WayToBossRoom_FaceCut"][Step]

			--[[
			DebugLog( "CurMsg[1] : " 		..CurMsg[1] )
			DebugLog( "DialogStep : " 		..DialogStep )
			DebugLog( "MaxDialogStep : " 	..MaxDialogStep )
			--]]

			if DialogStep <= MaxDialogStep
			then
				cScriptMessage( Var["MapIndex"], CurMsg[DialogStep] )
				Var["WayToBossRoom_FaceCut"]["Info"][Step]["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
				Var["WayToBossRoom_FaceCut"]["Info"][Step]["DialogStep"]	= DialogStep + 1
				return
			end

			if Var["WayToBossRoom_FaceCut"]["Info"][Step]["DialogStep"] > MaxDialogStep
			then
				Var["WayToBossRoom_FaceCut"]["Info"][Step] 			= nil
				Var["WayToBossRoom_FaceCut"]["DidFaceCut"][Step] 	= true
			end
		end
	end



	-- 1단계까지 페이스컷 출력완료시, 밀드윈은 삭제 처리
	if Var["WayToBossRoom_FaceCut"]["DidFaceCut"][1] == true
	then
		if Var["Enemy"]["MildWin"] ~= nil
		then
			cNPCVanish( Var["Enemy"]["MildWin"] )
			Var["Enemy"]["MildWin"]	= nil
		end
	end



	-- 4단계까지 모두 페이스컷 출력완료시, 다음 단계로 이동
	if Var["WayToBossRoom_FaceCut"]["DidFaceCut"][5] == true
	then
		Var["StepFunc"] 				= BossRoom_Stairway
		Var["WayToBossRoom_FaceCut"] 	= nil
		DebugLog( "End WayToBossRoom_FaceCut" )
	end

	return

end



--------------------------------------------------------------------------------
-- BossRoom_Stairway
--------------------------------------------------------------------------------
function BossRoom_Stairway( Var )
cExecCheck "BossRoom_Stairway"


	if Var == nil
	then
		ErrorLog( "BossRoom_Stairway :: Var == nil" )
		return
	end


	if Var["BossRoom_Stairway"] == nil
	then

		DebugLog( "Start BossRoom_Stairway" )
		Var["BossRoom_Stairway"] 					= {}

		-- 블라칸 소환 및 루틴함수 부착
		local BlakanInfo 		= RegenInfo["Mob"]["BossRoom_Stairway"]["Blakan"]
		local nBlakanHandle 	= cMobRegen_XY( Var["MapIndex"], BlakanInfo["Index"], BlakanInfo["x"], BlakanInfo["y"] )

		if nBlakanHandle == nil
		then
			ErrorLog( "BossRoom_Stairway :: Blakan was not created." )
		end

		if cSetAIScript ( MainLuaScriptPath, nBlakanHandle ) == nil
		then
			ErrorLog( "BossRoom_Blakan::cSetAIScript ( nBlakanHandle ) == nil" )
		else
			if  cAIScriptFunc( nBlakanHandle, "Entrance", "Routine_Blakan" ) == nil
			then
				ErrorLog( "BossRoom_Blakan::cAIScriptFunc ( Routine_Blakan ) == nil" )
			end
		end


		Var["Enemy"]["Blakan"] 					= nBlakanHandle
		Var["RoutineTime"]["Routine_Blakan"] 	= Var["CurSec"]

		DebugLog( "BossRoom_Stairway :: nBlakanHandle = "..Var["Enemy"]["Blakan"] )



		-- 봉인석 소환 및 루틴함수 부착
		local SealInfo 		= RegenInfo["Mob"]["BossRoom_Stairway"]["Seal"]

		for i = 1, #SealInfo
		do
			local CurRegenSeal 		= SealInfo[ i ]
			local nCurSealHandle 	= cMobRegen_XY( Var["MapIndex"], CurRegenSeal["Index"], CurRegenSeal["x"], CurRegenSeal["y"] )

			if nCurSealHandle == nil
			then
				ErrorLog( "BossRoom_Stairway :: Seal was not created. : "..i )
			else

				if Var["Enemy"]["Seal"] == nil
				then
					Var["Enemy"]["Seal"]	 		= {}
					Var["Enemy"]["Seal"]["SealNum"]	= 0
				end

				if Var["Enemy"]["Seal"] ~= nil
				then

					if cSetAIScript ( MainLuaScriptPath, nCurSealHandle ) == nil
					then
						ErrorLog( "BossRoom_Stairway::cSetAIScript ( nCurSealHandle ) == nil.."..i )
					else
						if  cAIScriptFunc( nCurSealHandle, "Entrance", "Routine_Seal" ) == nil
						then
							ErrorLog( "BossRoom_Stairway::cAIScriptFunc ( Routine_Seal ) == nil.."..i )
						end
					end


					if Var["RoutineTime"]["Routine_Seal"] == nil
					then
						DebugLog( "BossRoom_Stairway :: Routine_Seal 테이블 생성" )
						Var["RoutineTime"]["Routine_Seal"] = {}
					end

					Var["Enemy"]["Seal"][i] 							= nCurSealHandle
					Var["Enemy"]["Seal"]["SealNum"]						= Var["Enemy"]["Seal"]["SealNum"] + 1
					Var["RoutineTime"]["Routine_Seal"][nCurSealHandle] 	= Var["CurSec"]

					DebugLog( "BossRoom_Stairway :: nCurSealHandle ["..i.."] = "..nCurSealHandle )

				end
			end
		end

	end



	if Var["TimeList"]["FaceCutArea"] == nil
	then

		local FaceCutAreaInfo		= AreaInfo["Zone5_FaceCut"]

		local IsPlayerInArea_1 		= cIsMobTypeInArea( Var["MapIndex"], FaceCutAreaInfo[1], ObjectType["Player"] )
		local IsPlayerInArea_2 		= cIsMobTypeInArea( Var["MapIndex"], FaceCutAreaInfo[2], ObjectType["Player"] )

		if IsPlayerInArea_1 == 1 or IsPlayerInArea_2 == 1
		then

			DebugLog( "페이스컷 지역에 유저입장!" )

			Var["TimeList"]["FaceCutArea"]						= {}
			Var["TimeList"]["FaceCutArea"]["PlayerEntrance"]	= Var["CurSec"]
			Var["TimeList"]["FaceCutArea"]["Dialog_Blakan"]		= Var["CurSec"]


			Var["BossRoom_Stairway"]["DialogStep"]		= 1
			Var["BossRoom_Stairway"]["DialogTime"] 		= Var["TimeList"]["FaceCutArea"]["Dialog_Blakan"]

		else
			return
		end

	end



	if Var["BossRoom_Stairway"]["DialogTime"] ~= nil
	then

		if Var["BossRoom_Stairway"]["DialogTime"] > Var["CurSec"]
		then

			return

		end


		local CurMsg 			= ChatInfo["BossRoom_Stairway"]
		local DialogStep		= Var["BossRoom_Stairway"]["DialogStep"]
		local MaxDialogStep		= #ChatInfo["BossRoom_Stairway"]


		if DialogStep <= MaxDialogStep
		then

			cScriptMessage( Var["MapIndex"], CurMsg[DialogStep] )
			Var["BossRoom_Stairway"]["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
			Var["BossRoom_Stairway"]["DialogStep"]	= DialogStep + 1
			return

		end


		if Var["BossRoom_Stairway"]["DialogStep"] > MaxDialogStep
		then

			Var["BossRoom_Stairway"]["DialogStep"] 	= nil
			Var["BossRoom_Stairway"]["DialogTime"] 	= nil

		end


		Var["StepFunc"] 				= BossRoom_CenterHall
		Var["BossRoom_Stairway"] 		= nil
		DebugLog( "End BossRoom_Stairway" )

	end


	return
end

--------------------------------------------------------------------------------
-- BossRoom_CenterHall
--------------------------------------------------------------------------------
function BossRoom_CenterHall( Var )
cExecCheck "BossRoom_CenterHall"


	if Var == nil
	then
		ErrorLog( "BossRoom_CenterHall :: Var == nil" )
		return
	end


	if Var["TimeList"]["TeleportArea"] == nil
	then
		return
	end


	if Var["TimeList"]["TeleportArea"]["PlayerEntrance"] == nil
	then
		return
	end


	if Var["TimeList"]["TeleportArea"]["PlayerEntrance"] > Var["CurSec"]
	then
		return
	end


	if Var["BossRoom_CenterHall"] == nil
	then
		Var["BossRoom_CenterHall"] = {}

		DebugLog( "Start BossRoom_CenterHall" )

		Var["BossRoom_CenterHall"]["Dialog_Blakan"]	= {}
		Var["BossRoom_CenterHall"]["Dialog_Blakan"]["DialogStep"]	= 1
		Var["BossRoom_CenterHall"]["Dialog_Blakan"]["DialogTime"]	= Var["TimeList"]["TeleportArea"]["Dialog_Blakan"]

		Var["BossRoom_CenterHall"]["Stun"]				= {}
		Var["BossRoom_CenterHall"]["Stun"]["StartTime"]	= Var["BossRoom_CenterHall"]["Dialog_Blakan"]["DialogTime"]
		Var["BossRoom_CenterHall"]["Stun"]["EndTime"]	= Var["BossRoom_CenterHall"]["Dialog_Blakan"]["DialogTime"] + ( DelayTime["GapDialog"] * #ChatInfo["BossRoom_CenterHall"] )

		--[[
		Var["BossRoom_CenterHall"]["Dialog_Fagels"]	= {}
		Var["BossRoom_CenterHall"]["Dialog_Fagels"]["DialogStep"]	= 1
		Var["BossRoom_CenterHall"]["Dialog_Fagels"]["DialogTime"]	= Var["TimeList"]["TeleportArea"]["Dialog_Fagels"]
		--]]

	end



	-- 스턴 시간 확인
	local Stun_StartTime	= Var["BossRoom_CenterHall"]["Stun"]["StartTime"]
	local Stun_EndTime		= Var["BossRoom_CenterHall"]["Stun"]["EndTime"]

	local Stun_Area			= AreaInfo["Zone5_BossRoom"]
	local Stun_Idx			= AbStateInfo["Stun"]["Index"]
	local Stun_Strength		= AbStateInfo["Stun"]["Strength"]
	local Stun_KeepTime		= 1 * 1000

	if Stun_StartTime <= Var["CurSec"] and Var["CurSec"] < Stun_EndTime
	then

		local PlayerList 	= { cGetAreaObjectList( Var["MapIndex"], Stun_Area, ObjectType["Player"] ) }
		for i = 1, #PlayerList
		do
			cSetAbstate( PlayerList[i], Stun_Idx, Stun_Strength, Stun_KeepTime, PlayerList[i] )
			--DebugLog( "BossRoom_CenterHall :: SetAbState" .. PlayerList[i] )
		end

		local MobList 		= { cGetAreaObjectList( Var["MapIndex"], Stun_Area, ObjectType["Mob"] ) }
		for i = 1, #MobList
		do
			cSetAbstate( MobList[i], Stun_Idx, Stun_Strength, Stun_KeepTime, MobList[i] )
			--DebugLog( "BossRoom_CenterHall :: SetAbState" .. MobList[i] )
		end

		local ServantList 	= { cGetAreaObjectList( Var["MapIndex"], Stun_Area, ObjectType["Servant"] ) }
		for i = 1, #ServantList
		do
			cSetAbstate( ServantList[i], Stun_Idx, Stun_Strength, Stun_KeepTime, ServantList[i] )
			--DebugLog( "BossRoom_CenterHall :: SetAbState" .. ServantList[i] )
		end

	end



	-- 블라칸 대사 시간 확인
	local Dialog_Blakan 	= Var["BossRoom_CenterHall"]["Dialog_Blakan"]

	if Dialog_Blakan["DialogTime"] ~= nil
	then
		if Dialog_Blakan["DialogTime"] > Var["CurSec"]
		then
			return
		end

		local CurMsg 			= ChatInfo["BossRoom_CenterHall"]
		local DialogStep		= Dialog_Blakan["DialogStep"]
		local MaxDialogStep		= #ChatInfo["BossRoom_CenterHall"]

		--[[
		DebugLog( "CurMsg[1] : " 		..CurMsg[1] )
		DebugLog( "DialogStep : " 		..DialogStep )
		DebugLog( "MaxDialogStep : " 	..MaxDialogStep )
		--]]

		if DialogStep <= MaxDialogStep
		then
			cScriptMessage( Var["MapIndex"], CurMsg[DialogStep] )
			Dialog_Blakan["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
			Dialog_Blakan["DialogStep"]	= DialogStep + 1
			return
		end


		if Dialog_Blakan["DialogStep"] > MaxDialogStep
		then
			Dialog_Blakan["DialogStep"] 	= nil
			Dialog_Blakan["DialogTime"] 	= nil
		end

	end


	Var["StepFunc"] 				= BossRoom_Blakan
	Var["BossRoom_CenterHall"] 		= nil
	DebugLog( "End BossRoom_CenterHall" )

end


---[[
--------------------------------------------------------------------------------
-- BossRoom_Blakan
--------------------------------------------------------------------------------
function BossRoom_Blakan( Var )
cExecCheck "BossRoom_Blakan"

	if Var == nil
	then
		ErrorLog( "BossRoom_Blakan :: Var == nil" )
		return
	end

	if Var["BossRoom_Blakan"] == nil
	then

		DebugLog( "BossRoom_Blakan :: Start BossRoom_Blakan" )
		Var["BossRoom_Blakan"] = {}

		Var["BossRoom_Blakan"]["BlakanState"]			= "Sealed"	--"Free" 	--"Dead"
		Var["BossRoom_Blakan"]["FagelsDialogTime"]		= Var["TimeList"]["TeleportArea"]["Dialog_Fagels"]

		Var["BossRoom_Blakan"]["Summon1"]				= {}
		Var["BossRoom_Blakan"]["Summon1"]["StartTime"]	= Var["TimeList"]["TeleportArea"]["SummonStart"] + Blakan_Data_Info["WaitFirstSummon"]
		Var["BossRoom_Blakan"]["Summon1"]["EndTime"]	= Var["BossRoom_Blakan"]["Summon1"]["StartTime"] + Blakan_Data_Info["SummonInfo1"]["KeepTime"]
		Var["BossRoom_Blakan"]["Summon1"]["SummonTick"]	= Var["BossRoom_Blakan"]["Summon1"]["StartTime"]

	end

	----------------------------------------------------------------------------------------------
	-- [경우 1] 블라칸 죽었을 경우
	----------------------------------------------------------------------------------------------
	if Var["BossRoom_Blakan"]["BlakanState"] == "Dead"
	then

		if Var["BossRoom_Blakan"]["Dialog_BlakanDead"] == nil
		then
			DebugLog( "실패 : 블라칸 사망" )
			Var["BossRoom_Blakan"]["Dialog_BlakanDead"] 				= {}
			Var["BossRoom_Blakan"]["Dialog_BlakanDead"]["DialogTime"]	= Var["CurSec"]
			Var["BossRoom_Blakan"]["Dialog_BlakanDead"]["DialogStep"]	= 1
		end

		if Var["BossRoom_Blakan"]["Dialog_BlakanDead"] ~= nil
		then
			if Var["BossRoom_Blakan"]["Dialog_BlakanDead"]["DialogTime"] > Var["CurSec"]
			then
				return
			else
				local CurMsg 			= ChatInfo["Boss_Blakan_Dead"]
				local DialogStep		= Var["BossRoom_Blakan"]["Dialog_BlakanDead"]["DialogStep"]
				local MaxDialogStep		= #ChatInfo["Boss_Blakan_Dead"]

				--[[
				DebugLog( "CurMsg[1] : " 		..CurMsg[1] )
				DebugLog( "DialogStep : " 		..DialogStep )
				DebugLog( "MaxDialogStep : " 	..MaxDialogStep )
				--]]

				if DialogStep <= MaxDialogStep
				then
					cScriptMessage( Var["MapIndex"], CurMsg[DialogStep] )
					Var["BossRoom_Blakan"]["Dialog_BlakanDead"]["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
					Var["BossRoom_Blakan"]["Dialog_BlakanDead"]["DialogStep"]	= DialogStep + 1
					return
				end

				if Var["BossRoom_Blakan"]["Dialog_BlakanDead"]["DialogStep"] > MaxDialogStep
				then
					DebugLog( "대사 전부 함, Dialog_Dead 테이블 nil 처리" )
					Var["BossRoom_Blakan"]["Dialog_BlakanDead"] 	= nil
				end
			end
		end



		-- 몹과 캐릭터 죽이기
		local PlayerList		= { cGetPlayerList( Var["MapIndex"] ) }
		if PlayerList ~= nil
		then
			for i = 1, #PlayerList
			do
				cKillObject( PlayerList[i], Var["Enemy"]["Blakan"] )
			end
		end



		Var["StepFunc"] 				= ReturnToHome
		Var["BossRoom_Blakan"] 			= nil
		DebugLog( "End BossRoom_Blakan ... Fail : Blakan Dead .." )

		return
	end



	----------------------------------------------------------------------------------------------
	-- [경우 2] 모든 봉인석 파괴했을 경우
	----------------------------------------------------------------------------------------------
	if Var["BossRoom_Blakan"]["BlakanState"] == "Free"
	--if Var["BossRoom_Blakan"]["IsDead"] == false and Var["Enemy"]["Seal"]["SealNum"] == 0
	then

		if Var["BossRoom_Blakan"]["Dialog_BlakanSave"] == nil
		then

			DebugLog( "BossRoom_Blakan :: Blakan Freed! Good Job!" )

			Var["BossRoom_Blakan"]["Dialog_BlakanSave"] 				= {}
			Var["BossRoom_Blakan"]["Dialog_BlakanSave"]["DialogTime"]	= Var["CurSec"]
			Var["BossRoom_Blakan"]["Dialog_BlakanSave"]["DialogStep"]	= 1


			local nBlakanHandle		= Var["Enemy"]["Blakan"]
			local Stun_Idx			= AbStateInfo["Stun_ToBlakan_WhenSave"]["Index"]
			local Stun_Strength		= AbStateInfo["Stun_ToBlakan_WhenSave"]["Strength"]
			local Stun_KeepTime		= AbStateInfo["Stun_ToBlakan_WhenSave"]["KeepTime"]


			DebugLog( "nBlakanHandle" 	.. nBlakanHandle )
			DebugLog( "Stun_Idx" 		.. Stun_Idx )
			DebugLog( "Stun_Strength" 	.. Stun_Strength )
			DebugLog( "Stun_KeepTime" 	.. Stun_KeepTime )

			if cSetAbstate( nBlakanHandle, Stun_Idx, Stun_Strength, Stun_KeepTime, nBlakanHandle ) == nil
			then
				ErrorLog( "BossRoom_Blakan :: Fail Set Abstate To Blakan" .. Stun_Idx)
			end

		end


		if Var["BossRoom_Blakan"]["Dialog_BlakanSave"]["DialogTime"] ~= nil
		then
			if Var["BossRoom_Blakan"]["Dialog_BlakanSave"]["DialogTime"] > Var["CurSec"]
			then
				return
			else
				local CurMsg 			= ChatInfo["Boss_Blakan_Save"]
				local DialogStep		= Var["BossRoom_Blakan"]["Dialog_BlakanSave"]["DialogStep"]
				local MaxDialogStep		= #ChatInfo["Boss_Blakan_Save"]

				--[[
				DebugLog( "CurMsg[1] : " 		..CurMsg[1] )
				DebugLog( "DialogStep : " 		..DialogStep )
				DebugLog( "MaxDialogStep : " 	..MaxDialogStep )
				--]]

				if DialogStep <= MaxDialogStep
				then
					cScriptMessage( Var["MapIndex"], CurMsg[DialogStep] )
					Var["BossRoom_Blakan"]["Dialog_BlakanSave"]["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
					Var["BossRoom_Blakan"]["Dialog_BlakanSave"]["DialogStep"]	= DialogStep + 1
					return
				end

				if Var["BossRoom_Blakan"]["Dialog_BlakanSave"]["DialogStep"] > MaxDialogStep
				then
					-- 블라칸 삭제처리
					cAIScriptSet( Var["Enemy"]["Blakan"] )
					cNPCVanish( Var["Enemy"]["Blakan"] )
					Var["BossRoom_Blakan"]["Dialog_BlakanSave"]["DialogTime"]			= nil
					Var["BossRoom_Blakan"]["Dialog_BlakanSave"]["WaitNextStepFunc"]		= Var["CurSec"] + Blakan_Data_Info["WaitNextFagelsStep"]
				end
			end
		end



		if Var["BossRoom_Blakan"]["Dialog_BlakanSave"]["WaitNextStepFunc"] ~= nil
		then

			if Var["BossRoom_Blakan"]["Dialog_BlakanSave"]["WaitNextStepFunc"] > Var["CurSec"]
			then
				return
			end

			Var["StepFunc"] 							= BossRoom_Fagels
			Var["BossRoom_Blakan"]["Dialog_BlakanSave"]	= nil
			Var["BossRoom_Blakan"] 						= nil

			DebugLog( "End BossRoom_Blakan ... Success : All Seal Brake .." )

		end

		return
	end



	----------------------------------------------------------------------------------------------
	-- [경우 3] 전투진행중 ( 블라칸이 죽지 않았고, 봉인석도 다 파괴못한 상황 )
	----------------------------------------------------------------------------------------------
	if Var["BossRoom_Blakan"]["BlakanState"] == "Sealed"
	then

		-- 블라칸 상태 확인
		if cIsObjectDead( Var["Enemy"]["Blakan"] ) ~= nil
		then
			DebugLog("BossRoom_Blakan :: Blakan Dead....")
			Var["BossRoom_Blakan"]["BlakanState"]		= "Dead"
			return
		else
			if Var["Enemy"]["Seal"]["SealNum"] == 0
			then
				DebugLog("BossRoom_Blakan :: Blakan Free....")
				Var["BossRoom_Blakan"]["BlakanState"]	= "Free"
				return
			end
		end


		if Var["BossRoom_Blakan"]["FagelsDialogTime"] ~= nil
		then
			if Var["BossRoom_Blakan"]["FagelsDialogTime"] < Var["CurSec"]
			then
				cScriptMessage( Var["MapIndex"], ChatInfo["BossRoom_Fagels_Show"][1] )

				Var["BossRoom_Blakan"]["FagelsDialogTime"] = nil
			end
		end



		local Summon1DataInfo = Blakan_Data_Info["SummonInfo1"]
		local Summon2DataInfo = Blakan_Data_Info["SummonInfo2"]

		-- 3. 첫번째 소환 관련( 20초마다 소환 )
		if Var["BossRoom_Blakan"]["Summon1"] ~= nil
		then

			-- Summon1 끝낼 시간인 경우, 테이블 초기화 및 Summon2 테이블 생성
			if Var["BossRoom_Blakan"]["Summon1"]["EndTime"] < Var["CurSec"]
			then
				DebugLog( "BossRoom_Blakan :: Summon1 End Time" )
				Var["BossRoom_Blakan"]["Summon1"] = nil

				if Var["BossRoom_Blakan"]["Summon2"] == nil
				then
					Var["BossRoom_Blakan"]["Summon2"] = {}
					Var["BossRoom_Blakan"]["Summon2"]["StartTime"]	= Var["CurSec"]
					Var["BossRoom_Blakan"]["Summon2"]["EndTime"]	= Var["CurSec"] + Summon2DataInfo["KeepTime"]
					Var["BossRoom_Blakan"]["Summon2"]["SummonTick"]	= Var["BossRoom_Blakan"]["Summon2"]["StartTime"]
				end
			end


			-- Summon1 진행 시간일 경우, 틱 설정하고, 소환할 시간인지 확인한다.
			if Var["BossRoom_Blakan"]["Summon1"] ~= nil
			then

				if Var["BossRoom_Blakan"]["Summon1"]["SummonTick"] > Var["CurSec"]
				then
					return
				else
					DebugLog( "BossRoom_Blakan :: Summon1 몹 리젠" )

					Var["BossRoom_Blakan"]["Summon1"]["SummonTick"] = Var["BossRoom_Blakan"]["Summon1"]["SummonTick"] + Summon1DataInfo["SummonTick"]

					for i = 1, #Summon1DataInfo["Mob"]
					do
						local CurMobIdx 		= Summon1DataInfo["Mob"][i]["Index"]
						local CurMobRegenX		= Summon1DataInfo["Mob"][i]["x"]
						local CurMobRegenY		= Summon1DataInfo["Mob"][i]["y"]
						local CurMobRegenRadius	= Summon1DataInfo["Mob"][i]["radius"]

						--[[
						DebugLog( "====Summon1" )
						DebugLog( "CurMobIdx "		.. CurMobIdx )
						DebugLog( "CurMobRegenX "	.. CurMobRegenX )
						DebugLog( "CurMobRegenY "	.. CurMobRegenY )
						--]]

						if cMobRegen_Circle( Var["MapIndex"], CurMobIdx, CurMobRegenX, CurMobRegenY, CurMobRegenRadius ) == nil
						then
							ErrorLog( "BossRoom_Blakan :: Summon1 Mob Regen Fail.. "..i )
						end
					end
				end
			end
		end


		-- 3. 두번째 소환 관련( 60초마다 소환 )
		if Var["BossRoom_Blakan"]["Summon2"] ~= nil
		then
			-- Summon2 끝낼 시간인 경우, 테이블 초기화
			if Var["BossRoom_Blakan"]["Summon2"]["EndTime"] < Var["CurSec"]
			then
				DebugLog( "BossRoom_Blakan :: Summon2 End Time" )
				Var["BossRoom_Blakan"]["Summon2"] = nil
			end

			-- Summon2 진행 시간일 경우, 틱 설정하고, 소환할 시간인지 확인한다.
			if Var["BossRoom_Blakan"]["Summon2"] ~= nil
			then
				if Var["BossRoom_Blakan"]["Summon2"]["SummonTick"] > Var["CurSec"]
				then
					return
				else
					Var["BossRoom_Blakan"]["Summon2"]["SummonTick"] = Var["BossRoom_Blakan"]["Summon2"]["SummonTick"] + Summon2DataInfo["SummonTick"]

					DebugLog( "BossRoom_Blakan :: Summon2 몹 리젠" )

					for i = 1, #Summon2DataInfo["Mob"]
					do
						local CurMobIdx 		= Summon2DataInfo["Mob"][i]["Index"]
						local CurMobRegenX		= Summon2DataInfo["Mob"][i]["x"]
						local CurMobRegenY		= Summon2DataInfo["Mob"][i]["y"]
						local CurMobRegenRadius	= Summon2DataInfo["Mob"][i]["radius"]

						--[[
						DebugLog( "====Summon2" )
						DebugLog( "CurMobIdx "		.. CurMobIdx )
						DebugLog( "CurMobRegenX "	.. CurMobRegenX )
						DebugLog( "CurMobRegenY "	.. CurMobRegenY )
						--]]

						if cMobRegen_Circle( Var["MapIndex"], CurMobIdx, CurMobRegenX, CurMobRegenY, CurMobRegenRadius ) == nil
						then
							ErrorLog( "BossRoom_Blakan :: Summon2 Mob Regen Fail.. "..i )
						end
					end
				end
			end
		end

	end

	return

end
--]]

--------------------------------------------------------------------------------
-- BossRoom_Fagels
--------------------------------------------------------------------------------
function BossRoom_Fagels( Var )
cExecCheck "BossRoom_Fagels"


	if Var == nil
	then
		ErrorLog( "BossRoom_Fagels :: Var == nil" )
		return
	end


	if Var["BossRoom_Fagels"] == nil
	then
		Var["BossRoom_Fagels"] 					= {}
		Var["BossRoom_Fagels"]["DialogTime"]	= Var["CurSec"]
		Var["BossRoom_Fagels"]["DialogStep"]	= 1
	end


	if Var["Enemy"]["Fagels"] == nil
	then

		Var["Enemy"]["Fagels"] 				= {}
		Var["Enemy"]["Fagels"]["SkillList"] = {}


		for i = 1, #FARGELS_SKILL
		do

			local Object	= Var["Enemy"]["Fagels"]

			-- skill
			Object["SkillList"][i] 						= {}
			Object["SkillList"][i]["CheckTime"] 		= 0

			-- abstate
			Object["SkillList"][i]["AbstateList"]		= {}

			local AbstateData = FARGELS_SKILL[i]["ABSTATE"]

			if AbstateData ~= nil then

				for j = 1, #AbstateData do

					Object["SkillList"][i]["AbstateList"][j]						= { }
					Object["SkillList"][i]["AbstateList"][j]["CheckKeepTime"] 		= 0
					Object["SkillList"][i]["AbstateList"][j]["CheckPrepareTime"]	= 0
					Object["SkillList"][i]["AbstateList"][j]["CheckIntervalTime"]	= 0
					Object["SkillList"][i]["AbstateList"][j]["Enable"]				= false

				end

			end

			-- Summon Mob
			local SummonData	= FARGELS_SKILL[i]["SUMMON_MOBDATA"]

			if SummonData ~= nil then
				--Object["SkillList"][i]["Enable_Summon"]		= true
				Object["SkillList"][i]["Summon"]				= {}
				Object["SkillList"][i]["Summon"]["CheckTime"]	= 0
				Object["SkillList"][i]["Summon"]["Enable"]		= false
			end

		end


		local FagelsInfo 		= RegenInfo["Mob"]["BossRoom_Fagels"]["Fagels"]
		local nFagelsHandle 	= cMobRegen_XY( Var["MapIndex"], FagelsInfo["Index"], FagelsInfo["x"], FagelsInfo["y"] )

		if nFagelsHandle == nil
		then
			ErrorLog( "BossRoom_Fagels :: Fagels was not created." )
		end

		if cSetAIScript ( MainLuaScriptPath, nFagelsHandle ) == nil
		then
			ErrorLog( "BossRoom_Fagels::cSetAIScript ( nFagelsHandle ) == nil" )
		else
			if  cAIScriptFunc( nFagelsHandle, "Entrance", "Routine_Fagels" ) == nil
			then
				ErrorLog( "BossRoom_Fagels::cAIScriptFunc ( Routine_Fagels ) == nil" )
			end
		end

		Var["Enemy"]["Fagels"]["Handle"] 					= nFagelsHandle
		Var["RoutineTime"]["Routine_Fagels"] 				= Var["CurSec"]

		DebugLog( "BossRoom_Fagels :: nFagelsHandle = "..Var["Enemy"]["Fagels"]["Handle"] )

	end


	if cIsObjectDead( Var["Enemy"]["Fagels"]["Handle"] ) ~= nil
	then

		if Var["BossRoom_Fagels"]["DialogTime"] ~= nil
		then

			if Var["BossRoom_Fagels"]["DialogTime"] > Var["CurSec"]
			then

				return

			else

				local CurMsg 			= ChatInfo["Boss_Fagels_Dead"]
				local DialogStep		= Var["BossRoom_Fagels"]["DialogStep"]
				local MaxDialogStep		= #ChatInfo["Boss_Fagels_Dead"]

				--[[
				DebugLog( "CurMsg[1] : " 		..CurMsg[1] )
				DebugLog( "DialogStep : " 		..DialogStep )
				DebugLog( "MaxDialogStep : " 	..MaxDialogStep )
				--]]

				if DialogStep == 1
				then
					cMobSuicide( Var["MapIndex"] )
				end


				if DialogStep == 3
				then

					local MildWinInfo 		= RegenInfo["Mob"]["BossRoom_Fagels"]["MildWin"]
					local MildWinHandle 	= cMobRegen_XY( Var["MapIndex"], MildWinInfo["Index"], MildWinInfo["x"], MildWinInfo["y"] )
					if MildWinHandle == nil
					then
						ErrorLog( "InitDungeon :: MildWin Regen Fail" )
					end

					Var["Enemy"]["MildWin"]	= MildWinHandle

				end


				if DialogStep <= MaxDialogStep
				then
					cScriptMessage( Var["MapIndex"], CurMsg[DialogStep] )
					Var["BossRoom_Fagels"]["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
					Var["BossRoom_Fagels"]["DialogStep"]	= DialogStep + 1
					return
				end


				if Var["BossRoom_Fagels"]["DialogStep"] > MaxDialogStep
				then

					Var["BossRoom_Fagels"]["DialogStep"] 	= nil
					Var["BossRoom_Fagels"]["DialogTime"] 	= nil

				end

			end

		end

		Var["StepFunc"] 				= ReturnToHome
		Var["BossRoom_Fagels"] 			= nil

		DebugLog( "End BossRoom_Fagels" )
	end

	return

end




--------------------------------------------------------------------------------
-- 귀환
--------------------------------------------------------------------------------
function ReturnToHome( Var )
cExecCheck "ReturnToHome"

	if Var == nil
	then
		return
	end


	if Var["ReturnToHome"] == nil
	then
		DebugLog( "Start ReturnToHome" )
		Var["ReturnToHome"] 						= {}
		Var["ReturnToHome"]["ReturnStepSec"] 		= Var["CurSec"]
		Var["ReturnToHome"]["ReturnStepNo"] 		= 1
		Var["ReturnToHome"]["WaitSecReturnToHome"] 	= Var["CurSec"] + DelayTime["WaitReturnToHome"]

	end


	if Var["ReturnToHome"]["WaitSecReturnToHome"] > Var["CurSec"]
	then
		return
	end


	-- Return : return notice substep
	if Var["ReturnToHome"]["ReturnStepNo"] <= #NoticeInfo["IDReturn"]
	then

		if Var["ReturnToHome"]["ReturnStepSec"] <= Var["CurSec"]
		then

			-- Notice of Escape
			if NoticeInfo["IDReturn"][ Var["ReturnToHome"]["ReturnStepNo"] ]["Index"] ~= nil
			then
				cNotice( Var["MapIndex"], NoticeInfo["ScriptFileName"], NoticeInfo["IDReturn"][ Var["ReturnToHome"]["ReturnStepNo"] ]["Index"] )
			end

			-- Go To Next Notice
			Var["ReturnToHome"]["ReturnStepNo"]  = Var["ReturnToHome"]["ReturnStepNo"] + 1
			Var["ReturnToHome"]["ReturnStepSec"] = Var["CurSec"] + DelayTime["GapIDReturnNotice"]

		end

		return

	end


	-- Return : linkto substep
	if Var["ReturnToHome"]["ReturnStepNo"] > #NoticeInfo["IDReturn"]
	then

		if Var["ReturnToHome"]["ReturnStepSec"] <= Var["CurSec"]
		then
			--Finish_KQ
			cLinkToAll( Var["MapIndex"], LinkInfo["ReturnMap"]["MapIndex"], LinkInfo["ReturnMap"]["x"], LinkInfo["ReturnMap"]["y"] )

			cMobSuicide( Var["MapIndex"] )
			Var["StepFunc"] 		= DummyFunc
			Var["ReturnToHome"]		= nil


			if Var["TimeList"] ~= nil
			then
				Var["TimeList"] = nil
			end

			if Var["RootManager"] ~= nil
			then
				Var["RootManager"] = nil
			end

			if Var["Enemy"] ~= nil
			then
				Var["Enemy"] = nil
			end

			DebugLog( "End ReturnToHome" )

		end

		return

	end
end
