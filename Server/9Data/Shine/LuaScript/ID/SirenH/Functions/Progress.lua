--------------------------------------------------------------------------------
--                      Seiren Castle Progress Func                           --
--------------------------------------------------------------------------------

-- ���� �ʱ�ȭ
function InitDungeon( Var )
cExecCheck "InitDungeon"

	if Var == nil
	then
		return
	end

	-- �ν��Ͻ� ���� ���� ���� �÷��̾��� ù �α����� ��ٸ���.
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


		-- �� ����
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

					-- ���������� ���� �� ����
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

					-- �� ���� ����
					Var["Door"][ nCurDoorHandle ]			= {}
					Var["Door"][ nCurDoorHandle ]["Info"]	= CurDoorInfo
					Var["Door"][ nCurDoorHandle ]["IsOpen"]	= false
					Var["Door"][ CurRegenDoor["Name"] ] 	= nCurDoorHandle
				end
			end
		end


		-- NPC ����
		for i = 1, #RegenInfo["NPC"]
		do
			cNPCRegen( Var["MapIndex"], RegenInfo["NPC"][ i ] )
		end


		-- �Ա��� �ⱸ����Ʈ ����
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


		-- ���ð� ����
		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"] + DelayTime["AfterInit"]

		-- ���̾�α� ��� ����
		Var[ "InitDungeon" ]["bAfterDialogEnd"]		= false
		Var[ "InitDungeon" ]["AfterDialogSec"]		= Var["CurSec"]
		Var[ "InitDungeon" ]["AfterDialogNo"]		= 1

	end


	-- ��� �� ���� �ܰ��
	if Var["InitDungeon"]["WaitSecDuringInit"] > Var["CurSec"]
	then
		return
	end


	local CurChat = ChatInfo["InitDungeon"]

	--------------------------------------------------
	-- �ܰ谡 ������ ���̾�α� ���
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

				-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
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


		-- ���� �׷캰 ����
		local RegenMobGroupList = RegenInfo["Mob"][ StepIndex ]["NormalMobGroup"]

		if RegenMobGroupList ~= nil
		then
			for i = 1,#RegenMobGroupList
			do
				cGroupRegenInstance( Var["MapIndex"], RegenMobGroupList[ i ] )
			end
		end

		-- ���� ����
		local RegenBossMobList = RegenInfo["Mob"][ StepIndex ]["Boss"]

		for i = 1, #RegenBossMobList
		do
			local CurRegenBoss	= RegenBossMobList[ i ]
			local nBossHandle 	= cMobRegen_XY( Var["MapIndex"], CurRegenBoss["Index"], CurRegenBoss["x"], CurRegenBoss["y"], CurRegenBoss["dir"] )

			if nBossHandle == nil
			then
				ErrorLog( StepIndex.."::Boss was not created. : "..i )
			else
				-- ���� AI ����
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

				-- ���� ���� ����
				Var["Enemy"][ CurRegenBoss["Index"] ]		= nBossHandle

				Var["Enemy"][ nBossHandle ]					= {}
				Var["Enemy"][ nBossHandle ]["Index"]		= CurRegenBoss["Index"]
				Var["Enemy"][ nBossHandle ]["Info"]			= CurRegenBossInfo
				Var["Enemy"][ nBossHandle ]["Phase"]		= 1

				Var["RoutineTime"][ nBossHandle ]			= cCurrentSecond()
			end
		end

		-- ���̾�α� ��� ����
		Var[ StepIndex ]["bBeforeDialogEnd"]	= false
		Var[ StepIndex ]["BeforeDialogSec"]		= Var["CurSec"]
		Var[ StepIndex ]["BeforeDialogNo"]		= 1

		Var[ StepIndex ]["bAfterDialogEnd"]		= false
		Var[ StepIndex ]["AfterDialogSec"]		= Var["CurSec"]
		Var[ StepIndex ]["AfterDialogNo"]		= 1

		-- �ܰ� �� Ȯ�� �� �ʿ��� ���
		Var[ StepIndex ]["bPortalUse"]			= false
		Var[ StepIndex ]["bBoossDead"]			= false
		Var[ StepIndex ]["bOpenDoor"]			= false
	end


	-- ������ ��Ż�� ����ߴ��� Ȯ��
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


	-- �ܰ� ���۽� ��µǴ� ���̾� �α�
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

					-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
					return
				else
					-- ���̽��� ����
					Var[ StepIndex ]["bBeforeDialogEnd"] = true
				end
			end
		else
			-- ���̽��� ��ü�� ���� ��
			Var[ StepIndex ]["bBeforeDialogEnd"] = true
		end
	end


	-- ������ ���� ���Ͱ� �׾����� Ȯ��
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


	-- ���� ���Ͱ� ���� �� ��µǴ� ���̾� �α�
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

					-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
					return
				else
					-- ���̽��� ����
					Var[ StepIndex ]["bAfterDialogEnd"] = true
				end
			end
		else
			-- ���̽��� ��ü�� ���� ��
			Var[ StepIndex ]["bAfterDialogEnd"] = true
		end
	end


	-- ���� �����ش�
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


	-- ��� �� ���� �ܰ��
	if GoToNextStep( Var ) == true
	then

		-- ���� AIScrip�� ������ �ش�
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
		Var["ReturnToHome"]["ReturnStepSec"] 		= Var["CurSec"]
		Var["ReturnToHome"]["ReturnStepNo"] 		= 1
		Var["ReturnToHome"]["WaitSecReturnToHome"] = Var["CurSec"] + DelayTime["WaitReturnToHome"]


		-- �ⱸ����Ʈ ����
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

		-- ��� ���� ����
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


-- ���� ������ ���� ���� ���� �Լ� ����Ʈ
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


