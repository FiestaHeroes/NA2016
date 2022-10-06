--------------------------------------------------------------------------------
--                      	Progress Func 			                          --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- InitDungeon
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

					-- �ֵ��� ����Ʈ ������, �� ������ ����
					if CurDoorInfo["TwinGate"] ~= nil
					then
						Var["Door"][ nCurDoorHandle ]["TwinGate"] = CurDoorInfo["TwinGate"]
					end
				end
			end
		end

		-- �Ա��� �ⱸ����Ʈ ����
		local RegenExitGate  	= RegenInfo["Stuff"]["StartExitGate"]
		local nExitGateHandle 	= cDoorBuild( Var["MapIndex"], RegenExitGate["Index"], RegenExitGate["x"], RegenExitGate["y"], RegenExitGate["dir"], RegenExitGate["scale"] )

		if nExitGateHandle ~= nil
		then
			DebugLog("InitDungeon::�Ա��� �ⱸ����Ʈ ����")

			if cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil
			then
				ErrorLog( "InitDungeon::cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil" )
			end

			if cAIScriptFunc( nExitGateHandle, "NPCClick", "Click_ExitGate" ) == nil
			then
				ErrorLog( "InitDungeon::cAIScriptFunc( nExitGateHandle, \"NPCClick\", \"Click_ExitGate\" ) == nil" )
			end
		end

		-- ���� �׷캰 ����
		local RegenMobGroupList = RegenInfo["Mob"]["InitDungeon"]["NormalMobGroup"]

		if RegenMobGroupList ~= nil
		then
			DebugLog("InitDungeon::���� ����")

			for i = 1, #RegenMobGroupList
			do
				cGroupRegenInstance( Var["MapIndex"], RegenMobGroupList[ i ] )
			end
		end

		-- ���ð� ����
		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"] + DelayTime["AfterInit"]
	end


	-- ��� �� ���� �ܰ��
	if Var["InitDungeon"]["WaitSecDuringInit"] > Var["CurSec"]
	then
		return
	end

	--GoToNextStep( Var )
	Var["StepFunc"]		= Step_Routine
	Var["InitDungeon"] 	= nil
	DebugLog( "End InitDungeon" )
	return
end

--------------------------------------------------------------------------------
-- Step_Routine ( �������� �ٿ��� ��ũ��Ʈ )
--------------------------------------------------------------------------------
function Step_Routine( Var )
cExecCheck "Step_Routine"

	if Var == nil
	then
		return
	end



	-- ���� ���� �ش��ϴ� �� ���� ó�����ش�.
	if Var["GateProcess"] ~= nil
	then
		for i, v in pairs( Var["GateProcess"] )
		do
			local StepIndex = tostring( i )

			if v["IsProceed"] == false
			then

				-- �Ϲ� �� �׷� ����
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
				-- ó���Ϸ������Ƿ� true�� ����
				v["IsProceed"] = true
			end
		end
	end



	-- ������ ���� ���ȴ��� üũ
	if Var["GateProcess"]["DoorBoss"] ~= nil
	then
		-- ������ ���� ���� ó���� �Ϸ�ƴ��� üũ
		if Var["GateProcess"]["DoorBoss"]["IsProceed"] == true
		then

			if Var["Step_Routine_Boss"] == nil
			then
				Var["Step_Routine_Boss"] = {}
				DebugLog("Step_Routine_Boss ���̺� ����")
			end

			if Var["Step_Routine_Boss"] ~= nil
			then
				-- ��� ó��
				if Var["Step_Routine_Boss"]["Chat"] == nil
				then
					local BossIndex 	= RegenInfo["Mob"]["DoorBoss"]["Boss"][1]["Index"]
					local BossHandle 	= Var["Enemy"][ BossIndex ]

					if cIsObjectDead( BossHandle ) == nil
					then
						return
					end

					Var["Step_Routine_Boss"]["Chat"] = {}
					DebugLog("Step_Routine_Boss :: Chat ���̺� ����")

					if ChatInfo[BossIndex] ~= nil
					then
						cMobChat( BossHandle, ChatInfo["ScriptFileName"], ChatInfo[BossIndex]["Index"], ChatInfo[BossIndex]["IsShowChatWindow"] )
					end
				end

				if Var["Step_Routine_Boss"]["IDEnd"] == nil
				then
					Var["Step_Routine_Boss"]["IDEnd"] = {}
					DebugLog("Step_Routine_Boss :: IDEnd ���̺� ����")

					-- ��������Ʈ ó��
					cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )

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
				end
			end
		end
	end

end

