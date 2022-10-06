--------------------------------------------------------------------------------
--                      Giant Honeying Sub Functions                          --
--------------------------------------------------------------------------------


function DummyFunc( Var )
cExecCheck "DummyFunc"
end


----------------------------------------------------------------------
-- Manager Functions
----------------------------------------------------------------------
function ArenaFlag_Manager( Var )
cExecCheck "ArenaFlag_Manager"


	if Var == nil
	then
		return
	end

	local ArenaFlagInfo = Var[ "ArenaFlag" ]
	if ArenaFlagInfo == nil
	then
		return
	end


	-- ��� ���� Ȯ��
	for i = 1, #TeamNumberList
	do

		local TeamNumber = TeamNumberList[ i ]


		-- ��ȯ�� ���, ���ڰ� ���� ��� ������ġ�� ��� ��ȯ
		if ArenaFlagInfo[ TeamNumber ][ "Handle" ] 		== nil and
		   ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ] == nil
		then

			local Regen_Flag	= RegenInfo[ "NPC" ][ "ArenaFlag" ][ TeamNumber ]
			local Regen_Handle	= nil

			-- ��� ��ȯ
			Regen_Handle = cMobRegen_XY( Var[ "MapIndex" ], Regen_Flag[ "Index" ], Regen_Flag[ "X" ], Regen_Flag[ "Y" ], Regen_Flag[ "Dir" ] )

			if Regen_Handle ~= nil
			then

				cSetAIScript ( MainLuaScriptPath, Regen_Handle )
				cAIScriptFunc( Regen_Handle, "Entrance", "ArenaFlag_Entrance" )

				ArenaFlagInfo[ TeamNumber ][ "Handle" ]						= Regen_Handle
				ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ]				= nil
				ArenaFlagInfo[ TeamNumber ][ "PlayerTeam" ]					= nil
				ArenaFlagInfo[ TeamNumber ][ "Drop_LifeTime" ]				= nil
				ArenaFlagInfo[ TeamNumber ][ "X" ]							= Regen_Flag[ "X" ]
				ArenaFlagInfo[ TeamNumber ][ "Y" ]							= Regen_Flag[ "Y" ]
				ArenaFlagInfo[ TeamNumber ][ "GoalConditionNoticeTime" ]	= nil
				ArenaFlagInfo[ TeamNumber ][ "Penalty"]						= nil
			end
		end


		------------------------------------------------------------
		-- ��� ��� ���� Ȯ��
		------------------------------------------------------------
		if ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ] ~= nil
		then

			local bDropFlag = false

			if cIsInMap( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ], Var[ "MapIndex" ] ) == nil
			then
				bDropFlag = true
				cScriptMessage( Var[ "MapIndex" ], ArenaFlag[ TeamNumber ][ "ScriptMsg" ][ "Drop_Logoff" ] )
			end

			-- �����̻� Ȯ��( ����, �������� )
			if bDropFlag == false
			then

				for j = 1, #ArenaFlag[ "Drop_Abstate" ]
				do

					if cAbstateRestTime( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ], ArenaFlag[ "Drop_Abstate" ][ j ] ) ~= nil
					then

						bDropFlag = true
						cScriptMessage( Var[ "MapIndex" ], ArenaFlag[ TeamNumber ][ "ScriptMsg" ][ "Drop_Hide" ] )
						break
					end
				end
			end

			-- �����̻� Ȯ��( ��� )
			if bDropFlag == false
			then

				if cAbstateRestTime( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ], ArenaFlag[ TeamNumber ][ "Abstate" ][ "Index" ] ) == nil
				then

					bDropFlag = true
					cScriptMessage( Var[ "MapIndex" ], ArenaFlag[ TeamNumber ][ "ScriptMsg" ][ "Drop_Dead" ] )
				end
			end

			-- �׾����� Ȯ��
			if bDropFlag == false
			then

				if cIsObjectDead( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ] ) ~= nil
				then

					bDropFlag = true
					cScriptMessage( Var[ "MapIndex" ], ArenaFlag[ TeamNumber ][ "ScriptMsg" ][ "Drop_Dead" ] )
				end
			end

			-- ��� ���
			if bDropFlag == true
			then
				-- ������
				local FlagRegenData = RegenInfo["NPC"]["ArenaFlag"][ i ]
				local FlagData      = ArenaFlag[ TeamNumber ]
				local PenaltyData   = ArenaFlag["Penalty"]
				local Regen_Handle	= nil

				-- ȭ��ǥ ����
				cDelDirectionalArrow( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ] )

				-- ��� �����̻� ����
				cResetAbstate( ArenaFlagInfo[ TeamNumber ]["PlayerHandle"], FlagData["Abstate"]["Index"] )

				-- �г�Ƽ ����
				for PenaltyIndex = 1, #PenaltyData["Abstate"]
				do
					cResetAbstate( ArenaFlagInfo[ TeamNumber ]["PlayerHandle"], PenaltyData["Abstate"]["Index"] )
				end

				-- �÷��̾� ��� ȹ�� ���� �ð� ����
				for j = 1, #Var[ "Player" ]
				do

					if Var[ "Player" ][ j ][ "Handle" ] == ArenaFlagInfo[ TeamNumber ][ "Handle" ]
					then

						Var[ "Player" ][ j ][ "FlagPickSec" ] = Var[ "CurSec" ] + ArenaFlag[ "PickDelay" ]
						break
					end
				end

				-- ��� ��ȯ
				Regen_Handle = cMobRegen_XY( Var[ "MapIndex" ], FlagRegenData[ "Index" ], ArenaFlagInfo[ TeamNumber ][ "X" ], ArenaFlagInfo[ TeamNumber ][ "Y" ], FlagRegenData[ "Dir" ] )

				if Regen_Handle ~= nil
				then

					cSetAIScript ( MainLuaScriptPath, Regen_Handle )
					cAIScriptFunc( Regen_Handle, "Entrance", "ArenaFlag_Entrance" )

					ArenaFlagInfo[ TeamNumber ][ "Handle" ]						= Regen_Handle
					ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ]				= nil
					ArenaFlagInfo[ TeamNumber ][ "PlayerTeam" ]					= nil
					ArenaFlagInfo[ TeamNumber ][ "Drop_LifeTime" ]				= Var[ "CurSec" ] + ArenaFlag[ "Drop_LifeTime" ]
					ArenaFlagInfo[ TeamNumber ][ "GoalConditionNoticeTime" ]	= nil
					ArenaFlagInfo[ TeamNumber ][ "Penalty"]						= nil
				end

				return
			end
		end

		------------------------------------------------------------
		-- ���� ����(���� ��ġ) Ȯ��
		------------------------------------------------------------
		if ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ] ~= nil
		then

			local Player_X, Player_Y = cObjectLocate( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ] )
			if Player_X == nil or Player_Y == nil
			then

				Player_X = 0
				Player_Y = 0
			end

			local PlayerTeamNo = ArenaFlagInfo[ TeamNumber ][ "PlayerTeam" ]
			if PlayerTeamNo ~= nil
			then

				local CheckDistance = cDistanceSquar( Player_X, Player_Y, ArenaFlag[ TeamNumber ][ "GoalPoint" ][ "X" ], ArenaFlag[ TeamNumber ][ "GoalPoint" ][ "Y" ]  )


				if CheckDistance <=  ArenaFlag[ "CheckDistance_Goal" ]				-- ���� ���� Ȯ��
				then

					if ArenaFlagInfo[ PlayerTeamNo ][ "Handle" ]		~= nil and	-- ��� Ȯ��
					   ArenaFlagInfo[ PlayerTeamNo ][ "Drop_LifeTime" ]	== nil 		-- ��� ��� Ȯ��
					then

						local FlagData     = ArenaFlag[ TeamNumber ]
						local PenaltyData  = ArenaFlag["Penalty"]

						-- ����
						Var[ "Team" ][ PlayerTeamNo ][ "Score" ] = Var[ "Team" ][ PlayerTeamNo ][ "Score" ] + 1

						cScoreInfo_AllInMap( Var[ "MapIndex" ], #TeamNumberList, Var[ "Team" ][ RED_TEAM ][ "Score" ], Var[ "Team" ][ BLUE_TEAM ][ "Score" ] )
						cScriptMessage( Var[ "MapIndex" ], FlagData[ "ScriptMsg" ][ "GetPoint" ] )

						-- ȭ��ǥ ����
						cDelDirectionalArrow( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ] )

						-- ��� �����̻� ����
						cResetAbstate( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ], FlagData["Abstate"]["Index"] )

						-- �г�Ƽ ����
						for PenaltyIndex = 1, #PenaltyData["Abstate"]
						do
							cResetAbstate( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ], PenaltyData["Abstate"][PenaltyIndex][ "Index" ] )
						end

						-- ���� ��ġ�� ��ȯ
						local Regen_Flag	= RegenInfo[ "NPC" ][ "ArenaFlag" ][ TeamNumber ]
						local Regen_Handle	= nil

						Regen_Handle = cMobRegen_XY( Var[ "MapIndex" ], Regen_Flag[ "Index" ], Regen_Flag[ "X" ], Regen_Flag[ "Y" ], Regen_Flag[ "Dir" ] )

						if Regen_Handle ~= nil
						then

							cSetAIScript ( MainLuaScriptPath, Regen_Handle )
							cAIScriptFunc( Regen_Handle, "Entrance", "ArenaFlag_Entrance" )

							ArenaFlagInfo[ TeamNumber ][ "Handle" ]						= Regen_Handle
							ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ]				= nil
							ArenaFlagInfo[ TeamNumber ][ "PlayerTeam" ]					= nil
							ArenaFlagInfo[ TeamNumber ][ "Drop_LifeTime" ]				= nil
							ArenaFlagInfo[ TeamNumber ][ "X" ]							= Regen_Flag[ "X" ]
							ArenaFlagInfo[ TeamNumber ][ "Y" ]							= Regen_Flag[ "Y" ]
							ArenaFlagInfo[ TeamNumber ][ "GoalConditionNoticeTime" ]	= nil
							ArenaFlagInfo[ TeamNumber ][ "Penalty"]						= nil
						end

						return
					else

						-- �� ������ �� ����� ���� ���, ���� �������� ���� ���� �޽��� ���

						if ArenaFlagInfo[ TeamNumber ][ "GoalConditionNoticeTime" ] == nil
						then
							ArenaFlagInfo[ TeamNumber ][ "GoalConditionNoticeTime" ] = Var[ "CurSec" ]
						end

						if ArenaFlagInfo[ TeamNumber ][ "GoalConditionNoticeTime" ] <= Var[ "CurSec" ]
						then

							for j = 1, #Var[ "Team" ][ PlayerTeamNo ][ "Member" ]
							do
								cScriptMessage_Obj( Var[ "Team" ][ PlayerTeamNo ][ "Member" ][ j ], ArenaFlag[ TeamNumber ][ "ScriptMsg" ][ "GoalCondition" ] )
							end

							ArenaFlagInfo[ TeamNumber ][ "GoalConditionNoticeTime" ] = Var[ "CurSec" ] + DelayTime[ "GoalConditionNoticeIntervalTime" ]
						end
					end
				end
			end


			------------------------------------------------------------
			-- ���� �����̻� ����
			------------------------------------------------------------
			if ArenaFlagInfo[ TeamNumber ]["Penalty"] ~= nil
			then
				-- ������
				local PenaltyData      = ArenaFlag["Penalty"]
				local PenaltyStep      = ArenaFlagInfo[ TeamNumber ]["Penalty"]["Step"]
				local PenaltyCheckTime = ArenaFlagInfo[ TeamNumber ]["Penalty"]["CheckTime"]

				if PenaltyStep <= #PenaltyData["Step"]
				then

					if PenaltyCheckTime <= Var[ "CurSec" ]
					then
						for PenaltyIndex = 1, #PenaltyData["Abstate"]
						do
							cSetAbstate( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ], PenaltyData["Abstate"][PenaltyIndex]["Index"],
																						PenaltyData["Step"][ PenaltyStep ]["AbstateStr"],
																						PenaltyData["Abstate"][PenaltyIndex]["KeepTime"] )
						end

						PenaltyStep = PenaltyStep + 1
						if PenaltyStep <= #PenaltyData["Step"]
						then
							ArenaFlagInfo[ TeamNumber ]["Penalty"]["Step"]		= PenaltyStep
							ArenaFlagInfo[ TeamNumber ]["Penalty"]["CheckTime"]	= Var["CurSec"] + PenaltyData["Step"][ PenaltyStep ]["CheckTick"]
						else
							ArenaFlagInfo[ TeamNumber ]["Penalty"] = nil
						end
					end
				end
			end

			ArenaFlagInfo[ TeamNumber ][ "X" ]	= Player_X
			ArenaFlagInfo[ TeamNumber ][ "Y" ]	= Player_Y
		end
	end

end


function ArenaFlagMarking_Manager( Var )
cExecCheck "ArenaFlagMarking_Manager"


	if Var == nil
	then
		return
	end

	local ArenaFlagInfo = Var[ "ArenaFlag" ]
	if ArenaFlagInfo == nil
	then
		return
	end


	for i = 1, #TeamNumberList
	do

		local TeamNumber	= TeamNumberList[ i ]
		local bMapMarking	= false

		-- ������ ��� ǥ�� ���� Ȯ�� : ���� ȹ��, ���
		if ArenaFlagInfo[ TeamNumber ][ "Handle" ] 		 ~= nil and
		   ArenaFlagInfo[ TeamNumber ][ "Drop_LifeTime" ] ~= nil
		then
			bMapMarking = true
		end

		if ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ] ~= nil
		then
			bMapMarking = true
		end

		-- ������ ��� ǥ��
		if bMapMarking == true
		then

			local MapMarkTable = {}
			local mmData = {}

			mmData[ "Group" ]     = 0
			mmData[ "x" ]         = ArenaFlagInfo[ TeamNumber ][ "X" ]
			mmData[ "y" ]         = ArenaFlagInfo[ TeamNumber ][ "Y" ]
			mmData[ "KeepTime" ]  = 1000
			mmData[ "IconIndex" ] = ArenaFlag[ TeamNumber ][ "IconIndex" ]

			MapMarkTable[ mmData["Group"] ] = mmData

			-- ��� ��ŷ ���� �˸�
			cMapMark_FieldSight( Var[ "MapIndex" ], ArenaFlagInfo[ TeamNumber ][ "X" ], ArenaFlagInfo[ TeamNumber ][ "Y" ], MapMarkTable )

			-- ��� ������ �� ������ ���� ���, �ش��� �������� ��� ��ġ�� �˷��ش�.
			if ArenaFlagInfo[ TeamNumber ][ "PlayerTeam" ] ~= nil
			then

				local PlayerTeamNo = ArenaFlagInfo[ TeamNumber ][ "PlayerTeam" ]
				for j = 1, #Var[ "Team" ][ PlayerTeamNo ][ "Member" ]
				do

					cMapMark_Obj( Var[ "Team" ][ PlayerTeamNo ][ "Member" ][ j ], MapMarkTable )
				end
			end
		end
	end

end


function ArenaMonster_Manager( Var )
cExecCheck "AranaMonster_Manager"


	if Var == nil
	then
		return
	end


	------------------------------------------------------------
	-- ArenaCrystal
	------------------------------------------------------------
	if Var[ "ArenaCrystal" ] == nil
	then
		return
	end

	-- �����ϴ��� Ȯ��
	if Var[ "ArenaCrystal" ][ "Handle" ] == nil
	then

		local bRegen 				= false
		local Regen_ArenaCrystal	= RegenInfo[ "Monster" ][ "ArenaCrystal" ]


		-- �Ҹ�ð� Ȯ��
		if Var[ "ArenaCrystal" ][ "VanishTime" ] == nil
		then
			-- �������� �ʰ�, �Ҹ�ð��� �����Ǿ� ���� ������ ������Ų��.
			bRegen = true
		else

			-- �Ҹ�ð����� ���� �ð� �� ������Ų��.
			if Var[ "ArenaCrystal" ][ "VanishTime" ] + Regen_ArenaCrystal[ "RegenInterval" ] <= Var[ "CurSec" ]
			then
				bRegen = true
			end
		end

		-- ����
		if bRegen == true
		then

			local Regen_Handle = cMobRegen_XY( Var[ "MapIndex" ], Regen_ArenaCrystal[ "Index" ], Regen_ArenaCrystal[ "X" ], Regen_ArenaCrystal[ "Y" ], Regen_ArenaCrystal[ "Dir" ] )
			if Regen_Handle ~= nil
			then


				cSetAbstate( Regen_Handle, ArenaCrystal[ "RegenAbsatate" ][ "Index" ], ArenaCrystal[ "RegenAbsatate" ][ "Str" ], ArenaCrystal[ "RegenAbsatate" ][ "KeepTime" ] )
				cSetAIScript ( MainLuaScriptPath, Regen_Handle )
				cAIScriptFunc( Regen_Handle, "Entrance", "ArenaCrystal_Entrance" )

				Var[ "ArenaCrystal" ][ "Handle" ]		= Regen_Handle
				Var[ "ArenaCrystal" ][ "VanishTime" ]	= nil
				Var[ "ArenaCrystal" ][ "SkillUseTime" ]	= Var[ "CurSec" ] + ArenaCrystal[ "Routine" ][ "BlastTime" ]
			end
		end
	end


	------------------------------------------------------------
	-- AncientArenaWarrior
	------------------------------------------------------------
	if Var[ "AncientArenaWarrior" ] == nil
	then
		return
	end

	-- AncientArenaWarrior ���� ����
	local Regen_ArenaWarrior = RegenInfo[ "Monster" ][ "AncientArenaWarrior" ]

	for i = 1, Var[ "AncientArenaWarrior" ][ "Count" ]
	do

		-- �����ð��� �������� ���� ���͵� Ȯ��
		if Var[ "AncientArenaWarrior" ][ i ][ "RegenTime" ] == nil
		then

			if Var[ "AncientArenaWarrior" ][ i ][ "Handle" ] 					== nil or		-- �ڵ��� nil
			   cIsObjectDead( Var[ "AncientArenaWarrior" ][ i ][ "Handle" ] ) 	~= nil			-- �������� ����
			then
				-- �����ð� ����
				Var[ "AncientArenaWarrior" ][ i ][ "RegenTime" ] = Var[ "CurSec" ] + Regen_ArenaWarrior[ i ][ "RegenInterval" ]
			end
		else

			-- �����ð� Ȯ��
			if Var[ "AncientArenaWarrior" ][ i ][ "RegenTime" ] <= Var[ "CurSec" ]
			then

				-- ����
				Var[ "AncientArenaWarrior" ][ i ][ "Handle" ] 		= cMobRegen_XY( Var[ "MapIndex" ], Regen_ArenaWarrior[ i ][ "Index" ], Regen_ArenaWarrior[ i ][ "X" ], Regen_ArenaWarrior[ i ][ "Y" ], Regen_ArenaWarrior[ i ][ "Dir" ] )
				Var[ "AncientArenaWarrior" ][ i ][ "RegenTime" ]	= nil
			end
		end
	end

end


function Player_Manager( Var )
cExecCheck "Player_Manager"

	if Var == nil
	then
		return
	end

	local PlayerInfo = Var[ "Player" ]
	if PlayerInfo == nil
	then
		return
	end


	-- �÷��̾� ���� Ȯ��
	for i = 1, #PlayerInfo
	do

		if PlayerInfo[ i ][ "InMap" ] == true
		then

			if cIsInMap( PlayerInfo[ i ][ "Handle" ], Var[ "MapIndex" ] ) == nil
			then
				PlayerInfo[ i ][ "InMap" ] = false
			end
		end
	end

end


----------------------------------------------------------------------
-- Log Functions
----------------------------------------------------------------------
function DebugLog( String )

	if String == nil
	then
		cAssertLog( "DebugLog::String == nil" )
		return
	end

	--cAssertLog( "Debug - "..String )

end


function ErrorLog( String )

	if String == nil
	then
		cAssertLog( "ErrorLog::String == nil" )
		return
	end

	cAssertLog( "Error - "..String )

end
