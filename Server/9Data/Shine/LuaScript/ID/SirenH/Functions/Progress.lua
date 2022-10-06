--------------------------------------------------------------------------------
--                      Seiren Castle Progress Func                           --
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


		-- 문 생성
		for i = 1, #RegenInfo["Stuff"]["Door"]
		do
			local CurRegenDoor 	= RegenInfo["Stuff"]["Door"][ i ]
			local CurDoorInfo 	= DoorInfo[ CurRegenDoor["Name"] ]

			if CurRegenDoor == nil
			then
				ErrorLog( "InitDungeon::Door CurRegenDoor == nil : "..i )
			else
				local nCurDoorHandle = cDoorBuild( Var["MapIndex"], CurRegenDoor["Index"], CurRegenDoor["x"], CurRegenDoor["y"], CurRegenDoor["dir"], CurRegenDoor["scale"] )

				if nCurDoorHandle == nil
				then
					ErrorLog( "InitDungeon::Door was not created. : "..i )
				else
					cDoorAction( nCurDoorHandle, CurDoorInfo["Block"], "close" )

					-- 아이템으로 여는 문 설정
					if CurDoorInfo["NeedItem"] ~= nil
					then
						if cSetAIScript ( MainLuaScriptPath, nCurDoorHandle ) == nil
						then
							ErrorLog( "InitDungeon::cSetAIScript ( MainLuaScriptPath, nCurDoorHandle ) == nil : "..i )
						end

						if  cAIScriptFunc( nCurDoorHandle, "NPCClick", "Click_Door" ) == nil
						then
							ErrorLog( "InitDungeon::cAIScriptFunc( nCurDoorHandle, \"NPCClick\", \"Click_Door\" ) : "..i )
						end

						if  cAIScriptFunc( nCurDoorHandle, "NPCMenu", "Menu_Door" ) == nil
						then
							ErrorLog( "InitDungeon::cAIScriptFunc( nCurDoorHandle, \"NPCMenu\", \"Menu_Door\" ) : "..i )
						end
					end

					-- 문 정보 보관
					Var["Door"][ nCurDoorHandle ]			= {}
					Var["Door"][ nCurDoorHandle ]["Info"]	= CurDoorInfo
					Var["Door"][ nCurDoorHandle ]["IsOpen"]	= false
					Var["Door"][ CurRegenDoor["Name"] ] 	= nCurDoorHandle
				end
			end
		end


		-- NPC 생성
		for i = 1, #RegenInfo["NPC"]
		do
			cNPCRegen( Var["MapIndex"], RegenInfo["NPC"][ i ] )
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

			if cAIScriptFunc( nExitGateHandle, "NPCClick", "Click_ExitGate" ) == nil
			then
				ErrorLog( "InitDungeon::cAIScriptFunc( nExitGateHandle, \"NPCClick\", \"Click_ExitGate\" ) == nil" )
			end
		end


		-- 대기시간 설정
		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"] + DelayTime["AfterInit"]

		-- 다이얼로그 출력 설정
		Var[ "InitDungeon" ]["bAfterDialogEnd"]		= false
		Var[ "InitDungeon" ]["AfterDialogSec"]		= Var["CurSec"]
		Var[ "InitDungeon" ]["AfterDialogNo"]		= 1

	end


	-- 대기 후 다음 단계로
	if Var["InitDungeon"]["WaitSecDuringInit"] > Var["CurSec"]
	then
		return
	end


	local CurChat = ChatInfo["InitDungeon"]

	--------------------------------------------------
	-- 단계가 끝날때 다이얼로그 출력
	--------------------------------------------------
	if CurChat ~= nil
	then
		if CurChat["AfterDialog"] ~= nil
		then
			local nCurDialogNo = Var[ "InitDungeon" ]["AfterDialogNo"]

			if nCurDialogNo <= #CurChat["AfterDialog"]
			then
				if Var[ "InitDungeon" ]["AfterDialogSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["AfterDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["AfterDialog"][ nCurDialogNo ]["Index"] )

					Var[ "InitDungeon" ]["AfterDialogNo"]	= Var[ "InitDungeon" ]["AfterDialogNo"] + 1
					Var[ "InitDungeon" ]["AfterDialogSec"]	= Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
				return
			end
		end
	end


	GoToNextStep( Var )
	Var["InitDungeon"] = nil
	DebugLog( "End InitDungeon" )
	return
end


function Step_Routine( Var )
cExecCheck "Step_Routine"

	if Var == nil
	then
		return
	end


	local StepIndex = Var["StepIndex"]

	if StepIndex == nil
	then
		return
	end


	if Var[ StepIndex ] == nil
	then
		DebugLog( "Start "..StepIndex )

		Var[ StepIndex ] = {}


		-- 몬스터 그룹별 생성
		local RegenMobGroupList = RegenInfo["Mob"][ StepIndex ]["NormalMobGroup"]

		if RegenMobGroupList ~= nil
		then
			for i = 1,#RegenMobGroupList
			do
				cGroupRegenInstance( Var["MapIndex"], RegenMobGroupList[ i ] )
			end
		end

		-- 보스 생성
		local RegenBossMobList = RegenInfo["Mob"][ StepIndex ]["Boss"]

		for i = 1, #RegenBossMobList
		do
			local CurRegenBoss	= RegenBossMobList[ i ]
			local nBossHandle 	= cMobRegen_XY( Var["MapIndex"], CurRegenBoss["Index"], CurRegenBoss["x"], CurRegenBoss["y"], CurRegenBoss["dir"] )

			if nBossHandle == nil
			then
				ErrorLog( StepIndex.."::Boss was not created. : "..i )
			else
				-- 보스 AI 설정
				local CurRegenBossInfo = BossInfo[ CurRegenBoss["Index"] ]

				if CurRegenBossInfo ~= nil
				then
					if cSetAIScript ( MainLuaScriptPath, nBossHandle ) == nil
					then
						ErrorLog( "InitDungeon::cSetAIScript ( MainLuaScriptPath, nCurDoorHandle ) == nil : "..i )
					end

					if  cAIScriptFunc( nBossHandle, "Entrance", CurRegenBossInfo["Lua_EntranceFunc"] ) == nil
					then
						ErrorLog( "InitDungeon::cAIScriptFunc( nExitGateHandle, \"Entrance\", "..CurRegenBossInfo["Lua_EntranceFunc"].." ) : "..i )
					end
				end

				-- 보스 정보 설정
				Var["Enemy"][ CurRegenBoss["Index"] ]		= nBossHandle

				Var["Enemy"][ nBossHandle ]					= {}
				Var["Enemy"][ nBossHandle ]["Index"]		= CurRegenBoss["Index"]
				Var["Enemy"][ nBossHandle ]["Info"]			= CurRegenBossInfo
				Var["Enemy"][ nBossHandle ]["Phase"]		= 1

				Var["RoutineTime"][ nBossHandle ]			= cCurrentSecond()
			end
		end

		-- 다이얼로그 출력 설정
		Var[ StepIndex ]["bBeforeDialogEnd"]	= false
		Var[ StepIndex ]["BeforeDialogSec"]		= Var["CurSec"]
		Var[ StepIndex ]["BeforeDialogNo"]		= 1

		Var[ StepIndex ]["bAfterDialogEnd"]		= false
		Var[ StepIndex ]["AfterDialogSec"]		= Var["CurSec"]
		Var[ StepIndex ]["AfterDialogNo"]		= 1

		-- 단계 별 확인 이 필요한 목록
		Var[ StepIndex ]["bPortalUse"]			= false
		Var[ StepIndex ]["bBoossDead"]			= false
		Var[ StepIndex ]["bOpenDoor"]			= false
	end


	-- 설정된 포탈을 사용했는지 확인
	if Var[ StepIndex ]["bPortalUse"] == false
	then
		local PortalIndex = Step_PortalUseCheckList[ StepIndex ]

		if PortalIndex ~= nil
		then
			Var[ StepIndex ]["bBeforeDialogEnd"] 	= true
			local PortalHandle 						= Var["Portal"][ PortalIndex ]

			if Var["Portal"][ PortalHandle ] ~= nil
			then
				if Var["Portal"][ PortalHandle ]["Use"] == true
				then
					Var[ StepIndex ]["bBeforeDialogEnd"] 	= false
					Var[ StepIndex ]["bPortalUse"]			= true
				end
			end
		end
	end


	-- 단계 시작시 출력되는 다이얼 로그
	local CurChat = ChatInfo[ StepIndex ]

	if CurChat ~= nil
	then
		if CurChat["BeforeDialog"] ~= nil
		then
			if Var[ StepIndex ]["bBeforeDialogEnd"] == false
			then
				local nCurDialogNo = Var[ StepIndex ]["BeforeDialogNo"]

				if nCurDialogNo <= #CurChat["BeforeDialog"]
				then
					if Var[ StepIndex ]["BeforeDialogSec"] <= Var["CurSec"]
					then
						cMobDialog( Var["MapIndex"], CurChat["BeforeDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["BeforeDialog"][ nCurDialogNo ]["Index"] )

						Var[ StepIndex ]["BeforeDialogNo"]	= Var[ StepIndex ]["BeforeDialogNo"] + 1
						Var[ StepIndex ]["BeforeDialogSec"]	= Var["CurSec"] + DelayTime["GapDialog"]
					end

					-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
					return
				else
					-- 페이스컷 종료
					Var[ StepIndex ]["bBeforeDialogEnd"] = true
				end
			end
		else
			-- 페이스컷 자체가 없을 때
			Var[ StepIndex ]["bBeforeDialogEnd"] = true
		end
	end


	-- 설정된 보스 몬스터가 죽었는지 확인
	if Var[ StepIndex ]["bBoossDead"] == false
	then
		local BossIndex = Step_BossDeadCheckList[ StepIndex ]

		if BossIndex ~= nil
		then
			if Var["Enemy"][ BossIndex ] ~= nil
			then
				if cIsObjectDead( Var["Enemy"][ BossIndex ] ) == nil
				then
					return
				end
			end
		end

		Var[ StepIndex ]["bBoossDead"] = true
	end


	-- 보스 몬스터가 죽은 후 출력되는 다이얼 로그
	if CurChat ~= nil
	then
		if CurChat["AfterDialog"] ~= nil
		then
			if Var[ StepIndex ]["bAfterDialogEnd"] == false
			then
				local nCurDialogNo = Var[ StepIndex ]["AfterDialogNo"]

				if nCurDialogNo <= #CurChat["AfterDialog"]
				then
					if Var[ StepIndex ]["AfterDialogSec"] <= Var["CurSec"]
					then
						cMobDialog( Var["MapIndex"], CurChat["AfterDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["AfterDialog"][ nCurDialogNo ]["Index"] )

						Var[ StepIndex ]["AfterDialogNo"]	= Var[ StepIndex ]["AfterDialogNo"] + 1
						Var[ StepIndex ]["AfterDialogSec"]	= Var["CurSec"] + DelayTime["GapDialog"]
					end

					-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
					return
				else
					-- 페이스컷 종료
					Var[ StepIndex ]["bAfterDialogEnd"] = true
				end
			end
		else
			-- 페이스컷 자체가 없을 때
			Var[ StepIndex ]["bAfterDialogEnd"] = true
		end
	end


	-- 문을 열어준다
	if Var[ StepIndex ]["bOpenDoor"] == false
	then
		local DoorOpenList = Step_DoorOpenList[ StepIndex ]

		if DoorOpenList ~= nil
		then
			for i = 1, #DoorOpenList
			do
				local DoorName		= DoorOpenList[ i ]
				local nDoorHandle 	= Var["Door"][ DoorName ]

				if nDoorHandle ~= nil
				then
					local DoorInfo = Var["Door"][ nDoorHandle ]["Info"]

					if DoorInfo ~= nil
					then
						if Var["Door"][ nDoorHandle ]["IsOpen"] == false
						then
							cDoorAction( nDoorHandle, DoorInfo["Block"], "open" )
						end
					end
				end
			end
		end

		Var[ StepIndex ]["bOpenDoor"] = true
	end


	-- 대기 후 다음 단계로
	if GoToNextStep( Var ) == true
	then

		-- 문의 AIScrip를 제거해 준다
		local DoorOpenCheckList	= Step_DoorOpenCheckList[ StepIndex ]
		if DoorOpenCheckList ~= nil
		then
			for i = 1, #DoorOpenCheckList
			do
				local DoorName		= DoorOpenCheckList[ i ]["DoorName"]
				local nDoorHandle 	= Var["Door"][ DoorName ]

				if nDoorHandle ~= nil
				then
					cAIScriptSet( nDoorHandle )
				end
			end
		end


		Var[ StepIndex ] = nil
		DebugLog( "End "..StepIndex )
	end
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
		Var["ReturnToHome"]["ReturnStepSec"] 		= Var["CurSec"]
		Var["ReturnToHome"]["ReturnStepNo"] 		= 1
		Var["ReturnToHome"]["WaitSecReturnToHome"] = Var["CurSec"] + DelayTime["WaitReturnToHome"]


		-- 출구게이트 생성
		local RegenExitGate		= RegenInfo["Stuff"]["EndExitGate"]
		local nExitGateHandle	= cDoorBuild( Var["MapIndex"], RegenExitGate["Index"], RegenExitGate["x"], RegenExitGate["y"], RegenExitGate["dir"], RegenExitGate["scale"] )

		if nExitGateHandle ~= nil
		then
			if cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil
			then
				ErrorLog( "ReturnToHome::cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil" )
			end

			if cAIScriptFunc( nExitGateHandle, "NPCClick", "Click_ExitGate" ) == nil
			then
				ErrorLog( "ReturnToHome::cAIScriptFunc( nExitGateHandle, \"NPCClick\", \"Click_ExitGate\" ) == nil" )
			end
		end

		-- 모든 몬스터 삭제
		cMobSuicide( Var["MapIndex"] )
	end


	--
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

			GoToNextStep( Var )
			Var["ReturnToHome"] = nil

			DebugLog( "End ReturnToHome" )
		end

		return

	end
end


-- 스텝 구분을 위한 던전 진행 함수 리스트
ID_StepsList =
{
	InitDungeon 		= { Function = InitDungeon,		NextStep = "EntranceGuardArea",	},
	EntranceGuardArea	= { Function = Step_Routine,	NextStep = "CenterGuardArea", 	},
	CenterGuardArea		= { Function = Step_Routine,	NextStep = nil,					},
	EastArea			= { Function = Step_Routine,	NextStep = "FallenCenterHall",	},
	WestArea			= { Function = Step_Routine,	NextStep = "FallenCenterHall",	},
	FallenCenterHall	= { Function = Step_Routine,	NextStep = "GuardianAltar", 	},
	GuardianAltar		= { Function = Step_Routine,	NextStep = "AbyssHall", 		},
	AbyssHall			= { Function = Step_Routine,	NextStep = "ReturnToHome",		},
	ReturnToHome		= { Function = ReturnToHome,	NextStep = nil,					},
}


