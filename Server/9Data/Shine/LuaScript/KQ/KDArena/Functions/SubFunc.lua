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


	-- 깃발 상태 확인
	for i = 1, #TeamNumberList
	do

		local TeamNumber = TeamNumberList[ i ]


		-- 소환된 깃발, 주자가 없을 경우 리젠위치에 깃발 소환
		if ArenaFlagInfo[ TeamNumber ][ "Handle" ] 		== nil and
		   ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ] == nil
		then

			local Regen_Flag	= RegenInfo[ "NPC" ][ "ArenaFlag" ][ TeamNumber ]
			local Regen_Handle	= nil

			-- 깃발 소환
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
		-- 깃발 드랍 조건 확인
		------------------------------------------------------------
		if ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ] ~= nil
		then

			local bDropFlag = false

			if cIsInMap( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ], Var[ "MapIndex" ] ) == nil
			then
				bDropFlag = true
				cScriptMessage( Var[ "MapIndex" ], ArenaFlag[ TeamNumber ][ "ScriptMsg" ][ "Drop_Logoff" ] )
			end

			-- 상태이상 확인( 은신, 폴리모프 )
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

			-- 상태이상 확인( 깃발 )
			if bDropFlag == false
			then

				if cAbstateRestTime( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ], ArenaFlag[ TeamNumber ][ "Abstate" ][ "Index" ] ) == nil
				then

					bDropFlag = true
					cScriptMessage( Var[ "MapIndex" ], ArenaFlag[ TeamNumber ][ "ScriptMsg" ][ "Drop_Dead" ] )
				end
			end

			-- 죽었는지 확인
			if bDropFlag == false
			then

				if cIsObjectDead( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ] ) ~= nil
				then

					bDropFlag = true
					cScriptMessage( Var[ "MapIndex" ], ArenaFlag[ TeamNumber ][ "ScriptMsg" ][ "Drop_Dead" ] )
				end
			end

			-- 깃발 드랍
			if bDropFlag == true
			then
				-- 데이터
				local FlagRegenData = RegenInfo["NPC"]["ArenaFlag"][ i ]
				local FlagData      = ArenaFlag[ TeamNumber ]
				local PenaltyData   = ArenaFlag["Penalty"]
				local Regen_Handle	= nil

				-- 화살표 삭제
				cDelDirectionalArrow( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ] )

				-- 깃발 상태이상 제거
				cResetAbstate( ArenaFlagInfo[ TeamNumber ]["PlayerHandle"], FlagData["Abstate"]["Index"] )

				-- 패널티 제거
				for PenaltyIndex = 1, #PenaltyData["Abstate"]
				do
					cResetAbstate( ArenaFlagInfo[ TeamNumber ]["PlayerHandle"], PenaltyData["Abstate"]["Index"] )
				end

				-- 플레이어 깃발 획득 가능 시간 설정
				for j = 1, #Var[ "Player" ]
				do

					if Var[ "Player" ][ j ][ "Handle" ] == ArenaFlagInfo[ TeamNumber ][ "Handle" ]
					then

						Var[ "Player" ][ j ][ "FlagPickSec" ] = Var[ "CurSec" ] + ArenaFlag[ "PickDelay" ]
						break
					end
				end

				-- 깃발 소환
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
		-- 득점 조건(주자 위치) 확인
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


				if CheckDistance <=  ArenaFlag[ "CheckDistance_Goal" ]				-- 골인 지점 확임
				then

					if ArenaFlagInfo[ PlayerTeamNo ][ "Handle" ]		~= nil and	-- 깃발 확인
					   ArenaFlagInfo[ PlayerTeamNo ][ "Drop_LifeTime" ]	== nil 		-- 드랍 깃발 확인
					then

						local FlagData     = ArenaFlag[ TeamNumber ]
						local PenaltyData  = ArenaFlag["Penalty"]

						-- 득점
						Var[ "Team" ][ PlayerTeamNo ][ "Score" ] = Var[ "Team" ][ PlayerTeamNo ][ "Score" ] + 1

						cScoreInfo_AllInMap( Var[ "MapIndex" ], #TeamNumberList, Var[ "Team" ][ RED_TEAM ][ "Score" ], Var[ "Team" ][ BLUE_TEAM ][ "Score" ] )
						cScriptMessage( Var[ "MapIndex" ], FlagData[ "ScriptMsg" ][ "GetPoint" ] )

						-- 화살표 삭제
						cDelDirectionalArrow( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ] )

						-- 깃발 상태이상 제거
						cResetAbstate( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ], FlagData["Abstate"]["Index"] )

						-- 패널티 제거
						for PenaltyIndex = 1, #PenaltyData["Abstate"]
						do
							cResetAbstate( ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ], PenaltyData["Abstate"][PenaltyIndex][ "Index" ] )
						end

						-- 원래 위치에 소환
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

						-- 골 지점에 팀 깃발이 없을 경우, 일정 간격으로 득점 관련 메시지 출력

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
			-- 주자 상태이상 관리
			------------------------------------------------------------
			if ArenaFlagInfo[ TeamNumber ]["Penalty"] ~= nil
			then
				-- 데이터
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

		-- 지도에 깃발 표시 조건 확인 : 주자 획득, 드랍
		if ArenaFlagInfo[ TeamNumber ][ "Handle" ] 		 ~= nil and
		   ArenaFlagInfo[ TeamNumber ][ "Drop_LifeTime" ] ~= nil
		then
			bMapMarking = true
		end

		if ArenaFlagInfo[ TeamNumber ][ "PlayerHandle" ] ~= nil
		then
			bMapMarking = true
		end

		-- 지도에 깃발 표시
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

			-- 깃발 마킹 정보 알림
			cMapMark_FieldSight( Var[ "MapIndex" ], ArenaFlagInfo[ TeamNumber ][ "X" ], ArenaFlagInfo[ TeamNumber ][ "Y" ], MapMarkTable )

			-- 깃발 주자의 팀 정보가 있을 경우, 해당팀 전원에게 깃발 위치를 알려준다.
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

	-- 존재하는지 확인
	if Var[ "ArenaCrystal" ][ "Handle" ] == nil
	then

		local bRegen 				= false
		local Regen_ArenaCrystal	= RegenInfo[ "Monster" ][ "ArenaCrystal" ]


		-- 소멸시간 확인
		if Var[ "ArenaCrystal" ][ "VanishTime" ] == nil
		then
			-- 존재하지 않고, 소멸시간이 설정되어 있지 않으면 리젠시킨다.
			bRegen = true
		else

			-- 소멸시간에서 일정 시간 후 리젠시킨다.
			if Var[ "ArenaCrystal" ][ "VanishTime" ] + Regen_ArenaCrystal[ "RegenInterval" ] <= Var[ "CurSec" ]
			then
				bRegen = true
			end
		end

		-- 리젠
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

	-- AncientArenaWarrior 리젠 정보
	local Regen_ArenaWarrior = RegenInfo[ "Monster" ][ "AncientArenaWarrior" ]

	for i = 1, Var[ "AncientArenaWarrior" ][ "Count" ]
	do

		-- 리젠시간이 설정되지 않은 몬스터들 확인
		if Var[ "AncientArenaWarrior" ][ i ][ "RegenTime" ] == nil
		then

			if Var[ "AncientArenaWarrior" ][ i ][ "Handle" ] 					== nil or		-- 핸들이 nil
			   cIsObjectDead( Var[ "AncientArenaWarrior" ][ i ][ "Handle" ] ) 	~= nil			-- 존재하지 않음
			then
				-- 리젠시간 설정
				Var[ "AncientArenaWarrior" ][ i ][ "RegenTime" ] = Var[ "CurSec" ] + Regen_ArenaWarrior[ i ][ "RegenInterval" ]
			end
		else

			-- 리젠시간 확인
			if Var[ "AncientArenaWarrior" ][ i ][ "RegenTime" ] <= Var[ "CurSec" ]
			then

				-- 리젠
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


	-- 플레이어 상태 확인
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
