--------------------------------------------------------------------------------
-- �� InitDungeon
--------------------------------------------------------------------------------
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
			return
		end

		return
	end


	if Var["InitDungeon"] == nil
	then
		DebugLog( "Start InitDungeon" )

		Var["InitDungeon"] = {}

		-- �� ����
		if Var["Door"] ~= nil
		then

			-- �� ����1)
			if Var["Door"]["GoToKingCrab"] == nil
			then
				Var["Door"]["GoToKingCrab"] 			= {}

				local CurRegenDoor = RegenInfo["Stuff"]["Door"]["GoToKingCrab"]

				if CurRegenDoor == nil
				then
					ErrorLog( "InitDungeon::Door CurRegenDoor == nil..GoToKingCrab" )
				end

				local nCurDoorHandle = cDoorBuild( Var["MapIndex"], CurRegenDoor["Index"], CurRegenDoor["x"], CurRegenDoor["y"], CurRegenDoor["dir"], CurRegenDoor["scale"] )

				if nCurDoorHandle == nil
				then
					ErrorLog( "InitDungeon::Door was not created. : GoToKingCrab" )
				else
					cDoorAction( nCurDoorHandle, CurRegenDoor["DoorBlock"], "close" )

					-- �� ���� ����
					Var["Door"]["GoToKingCrab"]["Handle"]		= nCurDoorHandle
					Var["Door"]["GoToKingCrab"]["DoorBlock"]	= CurRegenDoor["DoorBlock"]
					Var["Door"]["GoToKingCrab"]["IsOpen"]		= false
				end
			end


			-- �� ����2)
			if Var["Door"]["GoToLeviathan"] == nil
			then
				Var["Door"]["GoToLeviathan"] 			= {}

				local CurRegenDoor = RegenInfo["Stuff"]["Door"]["GoToLeviathan"]

				if CurRegenDoor == nil
				then
					ErrorLog( "InitDungeon::Door CurRegenDoor == nil..GoToLeviathan" )
				end

				local nCurDoorHandle = cDoorBuild( Var["MapIndex"], CurRegenDoor["Index"], CurRegenDoor["x"], CurRegenDoor["y"], CurRegenDoor["dir"], CurRegenDoor["scale"] )

				if nCurDoorHandle == nil
				then
					ErrorLog( "InitDungeon::Door was not created. : GoToLeviathan" )
				else
					cDoorAction( nCurDoorHandle, CurRegenDoor["DoorBlock"], "close" )

					-- �� ���� ����
					Var["Door"]["GoToLeviathan"]["Handle"]		= nCurDoorHandle
					Var["Door"]["GoToLeviathan"]["DoorBlock"]	= CurRegenDoor["DoorBlock"]
					Var["Door"]["GoToLeviathan"]["IsOpen"]		= false
				end
			end

		end


		-- ���� �׷캰 ����
		local RegenMobGroupList = RegenInfo["Mob"]["InitDungeon"]["NormalMobGroup"]

		if RegenMobGroupList ~= nil
		then
			for i = 1,#RegenMobGroupList
			do
				cGroupRegenInstance( Var["MapIndex"], RegenMobGroupList[ i ] )
			end
		end


		-- �Ա��� �ⱸ����Ʈ ����
		local RegenExitGate  	= RegenInfo["Stuff"]["StartExitGate"]
		local nExitGateHandle 	= cDoorBuild( Var["MapIndex"], RegenExitGate["Index"], RegenExitGate["x"], RegenExitGate["y"], RegenExitGate["dir"], RegenExitGate["scale"] )

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

	end


	if Var["InitDungeon"] ~= nil
	then

		Var["InitDungeon"] 	= nil
		Var["StepFunc"] 	= KingBoogyStep
		DebugLog( "End InitDungeon" )

		return
	end

end


--------------------------------------------------------------------------------
-- �� KingBoogyStep
--------------------------------------------------------------------------------
function KingBoogyStep( Var )
cExecCheck "KingBoogyStep"


	if Var == nil
	then
		return
	end


	if Var["KingBoogyStep"] == nil
	then
		Var["KingBoogyStep"] = {}

		DebugLog( "Start KingBoogyStep" )

		-- ���� ����
		local CurRegenInfo 		= RegenInfo["Mob"]["KingBoogyStep"]["Boss"]
		local CurHandle 		= cMobRegen_XY( Var["MapIndex"], CurRegenInfo["Index"], CurRegenInfo["x"], CurRegenInfo["y"], CurRegenInfo["dir"] )

		if CurHandle == nil
		then
			ErrorLog("KingBoogyStep::BossMob Regen Fail")
			return
		end

		if cSetAIScript ( MainLuaScriptPath, CurHandle ) == nil
		then
			ErrorLog( "KingBoogyStep::cSetAIScript ( MainLuaScriptPath, CurHandle ) == nil" )
		end

		if cAIScriptFunc( CurHandle, "Entrance", "Routine_BossLive" ) == nil
		then
			ErrorLog( "KingBoogyStep::cAIScriptFunc( CurHandle, \"Entrance\", \"Routine_BossLive\" ) == nil" )
		end

		if cAIScriptFunc( CurHandle, "ObjectDied", "Routine_BossDead" ) == nil
		then
			ErrorLog( "KingBoogyStep::cAIScriptFunc( CurHandle, \"ObjectDied\", \"Routine_BossDead\" ) == nil" )
		end

		Var["Boss"][CurHandle] 				= {}
		Var["Boss"][CurHandle]["Index"] 	= CurRegenInfo["Index"]
		Var["Boss"][CurHandle]["Door"]		= Var["Door"]["GoToKingCrab"]
		Var["RoutineTime"][CurHandle]		= Var["CurSec"]

		-- ���ð� ����
		Var["KingBoogyStep"]["DialogTime"] 				= Var["InitialSec"] + DelayTime["AfterInit"]
		Var["KingBoogyStep"]["DialogStep"]				= 1

	end


	if Var["KingBoogyStep"] ~= nil
	then

		-- ���ó��
		if Var["KingBoogyStep"]["DialogTime"] ~= nil
		then

			if Var["KingBoogyStep"]["DialogTime"] > Var["CurSec"]
			then
				return
			else
				local CurMsg 			= ChatInfo["KingBoogyStep"]["Start"]
				local DialogStep		= Var["KingBoogyStep"]["DialogStep"]
				local MaxDialogStep		= #ChatInfo["KingBoogyStep"]["Start"]

				if DialogStep <= MaxDialogStep
				then
					cScriptMessage( Var["MapIndex"], CurMsg[DialogStep]["Index"] )
					Var["KingBoogyStep"]["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
					Var["KingBoogyStep"]["DialogStep"]	= DialogStep + 1
					return
				end

				if Var["KingBoogyStep"]["DialogStep"] > MaxDialogStep
				then
					Var["KingBoogyStep"]["DialogTime"]		= nil
					Var["KingBoogyStep"]["DialogStep"]		= nil
				end
			end

		end

		-- ���� �ܰ�� �������� �� ���ȴ��� üũ
		if Var["Door"]["GoToKingCrab"] ~= nil
		then

			local CurDoor = Var["Door"]["GoToKingCrab"]

			if CurDoor["IsOpen"] == false
			then
				return
			end

			if CurDoor["IsOpen"] == true
			then
				cDoorAction( CurDoor["Handle"], CurDoor["DoorBlock"], "open" )

				Var["KingBoogyStep"] 	= nil
				Var["StepFunc"] 		= KingCrabStep
				DebugLog( "End KingBoogyStep" )

				return
			end
		end

	end



end


--------------------------------------------------------------------------------
-- �� KingCrabStep
--------------------------------------------------------------------------------
function KingCrabStep( Var )
cExecCheck "KingCrabStep"


	if Var["KingCrabStep"] == nil
	then
		Var["KingCrabStep"] = {}

		DebugLog( "Start KingCrabStep" )

		-- ���� ����
		local CurRegenInfo 		= RegenInfo["Mob"]["KingCrabStep"]["Boss"]
		local CurHandle 		= cMobRegen_XY( Var["MapIndex"], CurRegenInfo["Index"], CurRegenInfo["x"], CurRegenInfo["y"], CurRegenInfo["dir"] )

		if CurHandle == nil
		then
			ErrorLog("KingCrabStep::BossMob Regen Fail")
			return
		end

		if cSetAIScript ( MainLuaScriptPath, CurHandle ) == nil
		then
			ErrorLog( "KingCrabStep::cSetAIScript ( MainLuaScriptPath, CurHandle ) == nil" )
		end

		if cAIScriptFunc( CurHandle, "Entrance", "Routine_BossLive" ) == nil
		then
			ErrorLog( "KingCrabStep::cAIScriptFunc( CurHandle, \"Entrance\", \"Routine_BossLive\" ) == nil" )
		end

		if cAIScriptFunc( CurHandle, "ObjectDied", "Routine_BossDead" ) == nil
		then
			ErrorLog( "KingCrabStep::cAIScriptFunc( CurHandle, \"ObjectDied\", \"Routine_BossDead\" ) == nil" )
		end

		Var["Boss"][CurHandle] 				= {}
		Var["Boss"][CurHandle]["Index"] 	= CurRegenInfo["Index"]
		Var["Boss"][CurHandle]["Door"]		= Var["Door"]["GoToLeviathan"]
		Var["RoutineTime"][CurHandle]		= Var["CurSec"]

		-- ���ð� ����
		Var["KingCrabStep"]["DialogTime"] 	= Var["CurSec"]
		Var["KingCrabStep"]["DialogStep"]	= 1

	end


	if Var["KingCrabStep"] ~= nil
	then

		-- ���ó��
		if Var["KingCrabStep"]["DialogTime"] ~= nil
		then

			if Var["KingCrabStep"]["DialogTime"] > Var["CurSec"]
			then
				return
			else
				local CurMsg 			= ChatInfo["KingCrabStep"]["AfterKingBoogyDead"]
				local DialogStep		= Var["KingCrabStep"]["DialogStep"]
				local MaxDialogStep		= #ChatInfo["KingCrabStep"]["AfterKingBoogyDead"]

				if DialogStep <= MaxDialogStep
				then
					cScriptMessage( Var["MapIndex"], CurMsg[DialogStep]["Index"] )
					Var["KingCrabStep"]["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
					Var["KingCrabStep"]["DialogStep"]	= DialogStep + 1
					return
				end

				if Var["KingCrabStep"]["DialogStep"] > MaxDialogStep
				then
					Var["KingCrabStep"]["DialogTime"]		= nil
					Var["KingCrabStep"]["DialogStep"]		= nil
				end
			end

		end

		-- ���� �ܰ�� �������� �� ���ȴ��� üũ
		if Var["Door"]["GoToLeviathan"] ~= nil
		then

			local CurDoor = Var["Door"]["GoToLeviathan"]

			if CurDoor["IsOpen"] == false
			then
				return
			end

			if CurDoor["IsOpen"] == true
			then
				cDoorAction( CurDoor["Handle"], CurDoor["DoorBlock"], "open" )

				Var["KingCrabStep"] = nil
				Var["StepFunc"] 	= LeviathanStep
				DebugLog( "End KingCrabStep" )

				return
			end
		end

	end

end


--------------------------------------------------------------------------------
-- �� LeviathanStep
--------------------------------------------------------------------------------
function LeviathanStep( Var )
cExecCheck "LeviathanStep"


	if Var["LeviathanStep"] == nil
	then
		Var["LeviathanStep"] = {}

		DebugLog( "Start LeviathanStep" )

		-- �����ź ( BossMain )����
		local CurRegenInfo 		= RegenInfo["Mob"]["LeviathanStep"]["BossMain"]
		local CurHandle 		= cMobRegen_XY( Var["MapIndex"], CurRegenInfo["Index"], CurRegenInfo["x"], CurRegenInfo["y"], CurRegenInfo["dir"] )

		if CurHandle == nil
		then
			ErrorLog("LeviathanStep::BossMain Regen Fail")
			return
		end

		if cSetAIScript ( MainLuaScriptPath, CurHandle ) == nil
		then
			ErrorLog( "LeviathanStep::cSetAIScript ( MainLuaScriptPath, CurHandle ) == nil" )
		end

		if cAIScriptFunc( CurHandle, "Entrance", "Routine_Leviathan" ) == nil
		then
			ErrorLog( "LeviathanStep::cAIScriptFunc( CurHandle, \"Entrance\", \"Routine_Leviathan\" ) == nil" )
		end

		Var["LeviathanStep"]["BossMain"] 			= {}
		Var["LeviathanStep"]["BossMain"]["Handle"] 	= CurHandle
		Var["RoutineTime"][ CurHandle ]				= Var["CurSec"]

		-- �����ź ( BossHead )����
		local CurRegenInfo 		= RegenInfo["Mob"]["LeviathanStep"]["BossHead"]
		local CurHandle 		= cMobRegen_XY( Var["MapIndex"], CurRegenInfo["Index"], CurRegenInfo["x"], CurRegenInfo["y"], CurRegenInfo["dir"] )

		if CurHandle == nil
		then
			ErrorLog("LeviathanStep::BossHead Regen Fail")
			return
		end

		if cSetAIScript ( MainLuaScriptPath, CurHandle ) == nil
		then
			ErrorLog( "LeviathanStep::cSetAIScript ( MainLuaScriptPath, CurHandle ) == nil" )
		end

		if cAIScriptFunc( CurHandle, "Entrance", "Routine_Leviathan" ) == nil
		then
			ErrorLog( "LeviathanStep::cAIScriptFunc( CurHandle, \"Entrance\", \"Routine_Leviathan\" ) == nil" )
		end

		Var["LeviathanStep"]["BossHead"] 			= {}
		Var["LeviathanStep"]["BossHead"]["Handle"] 	= CurHandle
		Var["RoutineTime"][ CurHandle ]				= Var["CurSec"]

		-- ���ð� ����
		Var["LeviathanStep"]["DialogTime"] 	= Var["CurSec"]
		Var["LeviathanStep"]["DialogStep"]	= 1

	end


	if Var["LeviathanStep"] ~= nil
	then

		-- ���ó��
		if Var["LeviathanStep"]["DialogTime"] ~= nil
		then

			if Var["LeviathanStep"]["DialogTime"] > Var["CurSec"]
			then
				return
			else
				local CurMsg 			= ChatInfo["LeviathanStep"]["AfterKingCrabDead"]
				local DialogStep		= Var["LeviathanStep"]["DialogStep"]
				local MaxDialogStep		= #ChatInfo["LeviathanStep"]["AfterKingCrabDead"]

				if DialogStep <= MaxDialogStep
				then
					cScriptMessage( Var["MapIndex"], CurMsg[DialogStep]["Index"] )
					Var["LeviathanStep"]["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
					Var["LeviathanStep"]["DialogStep"]	= DialogStep + 1
					return
				end

				if Var["LeviathanStep"]["DialogStep"] > MaxDialogStep
				then
					Var["LeviathanStep"]["DialogTime"]		= nil
					Var["LeviathanStep"]["DialogStep"]		= nil
				end
			end
		end

		-- BossMain �����ź�� ��������� ����
		if cIsObjectDead( Var["LeviathanStep"]["BossMain"]["Handle"] ) == nil
		then
			return
		end

		-- BossMain �����ź�� �׾����� ReturnToHome
		if cIsObjectDead( Var["LeviathanStep"]["BossMain"]["Handle"] ) == 1
		then
			-- �����ź �Ӹ��� ���������, ���δ�.
			if cIsObjectDead( Var["LeviathanStep"]["BossHead"]["Handle"] ) == nil
			then
				DebugLog("LeviathanStep::BossMain Dead, So Kill BossHead Too...")
				cAIScriptSet( Var["LeviathanStep"]["BossHead"]["Handle"] )
				cMobSuicide( Var["MapIndex"], Var["LeviathanStep"]["BossHead"]["Handle"] )
			end

			Var["LeviathanStep"] 	= nil
			Var["StepFunc"] 		= ReturnToHome
			DebugLog( "End LeviathanStep" )
			return
		end

	end

end

--------------------------------------------------------------------------------
-- �� ReturnToHome
--------------------------------------------------------------------------------
function ReturnToHome( Var )
cExecCheck "ReturnToHome"


	if Var == nil
	then
		return
	end


	if Var["ReturnToHome"] == nil
	then
		Var["ReturnToHome"] = {}

		DebugLog( "Start ReturnToHome" )

		-- �ⱸ����Ʈ ����
		local RegenExitGate  	= RegenInfo["Stuff"]["EndExitGate"]

		local nExitGateHandle 	= cDoorBuild( Var["MapIndex"], RegenExitGate["Index"], RegenExitGate["x"], RegenExitGate["y"], RegenExitGate["dir"], RegenExitGate["scale"] )
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

		-- ��������Ʈ ó��
		cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )

		-- ���� ������ ����(���� ������ ��) ����
		local RewardBox 		= RegenInfo["Stuff"]["RewardBox"]
		local CurSummonHandle	= cMobRegen_XY( Var["MapIndex"], RewardBox["Index"], RewardBox["x"], RewardBox["y"], RewardBox["dir"] )

		if CurSummonHandle == nil
		then
			ErrorLog( "ReturnToHome::RewardBox Regen Fail" )
		end

		-- ��� ���̱�( ��, �� )
		local vanishMOb = LeviathanSkillInfo["Vanish_WhenLeviDead"]
		for i = 1, #vanishMOb
		do
			cVanishAll( Var["MapIndex"], vanishMOb[i] )
		end

		-- ���ð� ����
		Var["ReturnToHome"]["DialogTime"] 				= Var["CurSec"]
		Var["ReturnToHome"]["DialogStep"]				= 1

	end


	if Var["ReturnToHome"] ~= nil
	then

		-- ���ó��
		if Var["ReturnToHome"]["DialogTime"] ~= nil
		then

			if Var["ReturnToHome"]["DialogTime"] > Var["CurSec"]
			then
				return
			else
				local CurMsg 			= ChatInfo["ReturnToHome"]["AfterLeviDead"]
				local DialogStep		= Var["ReturnToHome"]["DialogStep"]
				local MaxDialogStep		= #ChatInfo["ReturnToHome"]["AfterLeviDead"]

				if DialogStep <= MaxDialogStep
				then
					cScriptMessage( Var["MapIndex"], CurMsg[DialogStep]["Index"] )
					Var["ReturnToHome"]["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
					Var["ReturnToHome"]["DialogStep"]	= DialogStep + 1
					return
				end

				if Var["ReturnToHome"]["DialogStep"] > MaxDialogStep
				then
					Var["ReturnToHome"]["DialogTime"]		= nil
					Var["ReturnToHome"]["DialogStep"]		= nil
				end
			end

		end

		Var["ReturnToHome"] = nil
		Var["StepFunc"] 	= DummyFunc
		DebugLog( "End ReturnToHome" )

		return

	end
end
