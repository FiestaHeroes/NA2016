--------------------------------------------------------------------------------
--                            KDArena Routine                                 --
--------------------------------------------------------------------------------


function DummyRoutineFunc( )
cExecCheck "DummyRoutineFunc"
end


----------------------------------------------------------------------
-- MapLogin Function
----------------------------------------------------------------------
function PlayerMapLogin( MapIndex, Handle )
cExecCheck "PlayerMapLogin"

	-- 사용할 데이터 : 킹덤 퀘스트 정보, 현재시간, 플레이어 팀 번호, 플레이어 캐릭 번호
	local Var 			= InstanceField[ MapIndex ]
	local CurSec		= cCurrentSecond()
	local TeamNumber 	= cGetKQTeamType( Handle ) + 1
	local CharNo		= cGetCharNo( Handle )


	DebugLog( "TeamNumer : "..TeamNumber )


	if Var == nil
	then

		return
	end

	if CurSec == nil
	then

		return
	end

	if TeamNumber == nil
	then

		return
	end

	if CharNo == nil
	then

		return
	end


	-- 플레이어 수, 핸들, 추가 여부,
	local PlayerCount 	= #Var[ "Player" ]
	local OldHandle		= 0
	local PlayerInsert	= true


	-- 플레이어 목록 찾기
	for i = 1, PlayerCount
	do

		if CharNo == Var[ "Player" ][ i ][ "CharNo" ]
		then

			-- 플레이어 추가 여부, 핸들 설정
			PlayerInsert 							= false
			OldHandle 								= Var[ "Player" ][ i ][ "Handle" ]
			Var[ "Player" ][ i ][ "Handle" ]		= Handle
			Var[ "Player" ][ i ][ "FlagPickSec" ]	= CurSec + ArenaFlag[ "PickDelay" ]
			Var[ "Player" ][ i ][ "InMap" ]			= true


			-- 플레이어 팀 번호가 다를 경우
			if TeamNumber ~= Var[ "Player" ][ i ][ "TeamNumber" ]
			then

				-- 팀 정보
				local DelTeamNumber 	= Var[ "Player" ][ i ][ "TeamNumber" ]
				local TeamMemberCount 	= #Var[ "Team" ][ DelTeamNumber ][ "Member" ]

				-- 팀 멤버 목록에서 삭제
				for DelMemberIndex = 1, TeamMemberCount
				do

					if Var[ "Team" ][ DelTeamNumber ][ "Member" ] == OldHandle
					then

						for MoveIndex = DelMemberIndex, ( TeamMemberCount - 1 )
						do
							Var[ "Team" ][ DelTeamNumber ][ "Member" ][ MoveIndex ] = Var[ "Team" ][ DelTeamNumber ][ "Member" ][ ( MoveIndex + 1 ) ]
						end

						Var[ "Team" ][ DelTeamNumber ][ "Member" ][ TeamMemberCount ] = nil
						break
					end
				end

				-- 플레이어 목록에서 삭제
				for MoveIndex = i, ( PlayerCount - 1 )
				do
					Var[ "Player" ][ MoveIndex ] = Var[ "Player" ][ ( MoveIndex + 1 ) ]
				end

				Var[ "Player" ][ PlayerCount ] = nil
				return
			end

			break
		end
	end


	if PlayerInsert == true
	then

		------------------------------------------------------------
		-- 플레이어 정보 추가
		------------------------------------------------------------
		if TeamNumber >= DEF_TEAM
		then
			return
		end


		local P_InsertIndex = ( PlayerCount + 1	)
		local T_InsertIndex = ( #Var[ "Team" ][ TeamNumber ][ "Member" ] + 1 )

		-- 플레이어 목록에 추가
		Var[ "Player" ][ P_InsertIndex ]						= {}
		Var[ "Player" ][ P_InsertIndex ][ "Handle" ]			= Handle
		Var[ "Player" ][ P_InsertIndex ][ "CharNo" ]			= CharNo
		Var[ "Player" ][ P_InsertIndex ][ "FlagPickSec" ]		= CurSec + ArenaFlag[ "PickDelay" ]
		Var[ "Player" ][ P_InsertIndex ][ "InMap" ]				= true
		Var[ "Player" ][ P_InsertIndex ][ "TeamNumber" ]		= TeamNumber

		-- 팀 멤버 목록에 추가
		Var["Team"][ TeamNumber ][ "Member" ][ T_InsertIndex ]	= Handle

	elseif OldHandle ~= Handle
	then

		------------------------------------------------------------
		-- 플레이어 정보 수정
		------------------------------------------------------------
		local MemberCount = #Var["Team"][ TeamNumber ][ "Member" ]

		-- 팀 멤버 정보 수정
		for i = 1, MemberCount
		do

			if OldHandle == Var["Team"][ TeamNumber ][ "Member" ][ i ]
			then

				Var["Team"][ TeamNumber ][ "Member" ][ i ] = Handle
				break
			end
		end
	end


	-- 팀 유니폼 착용
	for i = 1, #TeamUniform[ TeamNumber ]
	do
		cViewSlotEquip( Handle, TeamUniform[ TeamNumber ][ i ] )
	end


	-- 게임이 진행 중이 아니면 함수 종료
	if Var[ "KQLimitTime" ] <= 0
	then
		return
	end


	-- 아레나 점수, 시간 정보 전송
	cScoreInfo( Handle, #TeamNumberList, Var[ "Team" ][ RED_TEAM ][ "Score" ], Var[ "Team" ][ BLUE_TEAM ][ "Score" ] )
	cTimer_Obj( Handle, ( Var[ "KQLimitTime" ] - CurSec ) )

end


----------------------------------------------------------------------
-- Click Functions
----------------------------------------------------------------------
function ArenaGate_Click( NPCHandle, PlayerHandle, PlayerCharNo, Arg )
cExecCheck "ArenaGate_Click"


	-- 맵인덱스 가져오기
	local NPCMapIndex = cGetCurMapIndex( NPCHandle )
	if NPCMapIndex == nil
	then
		return
	end

	-- 사용할 데이터 : 킹덤 퀘스트 정보
	local Var = InstanceField[ NPCMapIndex ]
	if Var == nil
	then
		return
	end


	if Var[ "ArenaGate" ] == nil
	then
		return
	end


	-- 게이트 정보 찾기
	local WarpInfo	= nil
	for i = 1, Var[ "ArenaGate" ][ "Count" ]
	do

		if Var[ "ArenaGate" ][ i ] == NPCHandle
		then

			WarpInfo = WarpGate[ i ]

			if WarpInfo == nil
			then
				return
			end

			break
		end
	end

	-- 플레이어 팀 확인
	for i = 1, #Var[ "Player" ]
	do

		if Var[ "Player" ][ i ][ "CharNo" ] == PlayerCharNo
		then

			if Var[ "Player" ][ i ][ "TeamNumber" ] == WarpInfo[ "Team" ]
			then

				cCastTeleport( PlayerHandle, "SpecificCoord", WarpInfo[ "X" ], WarpInfo[ "Y" ] );
			end
		end
	end

end


----------------------------------------------------------------------
-- Entrance Functions
----------------------------------------------------------------------
function ArenaFlag_Entrance( Handle, MapIndex )
cExecCheck "ArenaFlag_Entrance"


	-- 사용할 데이터 : 킹덤 퀘스트 정보, 현재시간
	local Var 		= InstanceField[ MapIndex ]
	local CurSec 	= cCurrentSecond()


	if Var == nil
	then
		return ReturnAI[ "END" ]
	end

	if CurSec == nil
	then
		return ReturnAI[ "END" ]
	end

	if Var[ "KQLimitTime" ] == 0
	then
		return ReturnAI[ "END" ]
	end

	local ArenaFlagInfo = Var[ "ArenaFlag" ]
	if ArenaFlagInfo == nil
	then
		return ReturnAI[ "END" ]
	end


	-- 팀 번호 찾기
	local FlagTeamNumber = DEF_TEAM
	for i = 1, #TeamNumberList
	do

		if ArenaFlagInfo[ TeamNumberList[ i ] ][ "Handle" ] == Handle
		then

			FlagTeamNumber = TeamNumberList[ i ]
		end
	end

	if FlagTeamNumber == DEF_TEAM
	then
		return ReturnAI[ "END" ]
	end


	------------------------------------------------------------
	-- 드랍 30 초 후 이젠 위치로 이동
	------------------------------------------------------------
	if ArenaFlagInfo[ FlagTeamNumber ][ "Drop_LifeTime" ] ~= nil
	then

		if ArenaFlagInfo[ FlagTeamNumber ][ "Drop_LifeTime" ] <= CurSec
		then

			local Regen_Flag	= RegenInfo[ "NPC" ][ "ArenaFlag" ][ FlagTeamNumber ]
			local Regen_Handle	= nil

			-- 깃발 삭제
			cNPCVanish( Handle )
			ArenaFlagInfo[ FlagTeamNumber ][ "Handle" ] = nil

			-- 깃발 소환
			Regen_Handle = cMobRegen_XY( Var[ "MapIndex" ], Regen_Flag[ "Index" ], Regen_Flag[ "X" ], Regen_Flag[ "Y" ], Regen_Flag[ "Dir" ] )

			if Regen_Handle ~= nil
			then

				cSetAIScript ( MainLuaScriptPath, Regen_Handle )
				cAIScriptFunc( Regen_Handle, "Entrance", "ArenaFlag_Entrance" )

				ArenaFlagInfo[ FlagTeamNumber ][ "Handle" ]					= Regen_Handle
				ArenaFlagInfo[ FlagTeamNumber ][ "PlayerHandle" ]			= nil
				ArenaFlagInfo[ FlagTeamNumber ][ "PlayerTeam" ]				= nil
				ArenaFlagInfo[ FlagTeamNumber ][ "Drop_LifeTime" ]			= nil
				ArenaFlagInfo[ FlagTeamNumber ][ "X" ]						= Regen_Flag[ "X" ]
				ArenaFlagInfo[ FlagTeamNumber ][ "Y" ]						= Regen_Flag[ "Y" ]
				ArenaFlagInfo[ FlagTeamNumber ][ "GoalConditionNoticeTime"]	= nil
				ArenaFlagInfo[ FlagTeamNumber ][ "Penalty"]					= nil
			end

			-- 깃발 회수 알림
			cScriptMessage( Var[ "MapIndex" ], ArenaFlag[ FlagTeamNumber ][ "ScriptMsg" ][ "Return_Flag" ] )
			return ReturnAI[ "END" ]
		end
	end


	------------------------------------------------------------
	-- 근처에 플레이어가 있을 경우
	------------------------------------------------------------
	local PlayerList = { cNearObjectList( Handle, ArenaFlag[ "CheckDistance_Falg" ], ObjectType[ "Player" ] ) }
	for i = 1, #PlayerList
	do

		-- 아레나에 참여중인 플레이어 목록과 비교
		for PlayerIndex = 1, #Var[ "Player" ]
		do

			-- 핸들, 깃발 획득 가능 시간 비교
			if	Var[ "Player" ][ PlayerIndex ][ "Handle" ] 		== PlayerList[ i ]	and
				Var[ "Player" ][ PlayerIndex ][ "FlagPickSec" ] <= CurSec
			then

				-- 상태이상 확인( 은신, 폴리모프 )
				local bAbstateCheck = false
				for j = 1, #ArenaFlag[ "Drop_Abstate" ]
				do
					if cAbstateRestTime( PlayerList[ i ], ArenaFlag[ "Drop_Abstate" ][ j ] ) ~= nil
					then

						bAbstateCheck = true
						break
					end
				end

				if bAbstateCheck == false
				then
					if  Var[ "Player" ][ PlayerIndex ][ "TeamNumber" ]	== FlagTeamNumber
					then

						if ArenaFlagInfo[ FlagTeamNumber ][ "Drop_LifeTime" ] ~= nil
						then

							------------------------------------------------------------
							-- 아군 : 깃발 리젠 포인트에 소환
							------------------------------------------------------------
							local Regen_Flag	= RegenInfo[ "NPC" ][ "ArenaFlag" ][ FlagTeamNumber ]
							local Regen_Handle	= nil

							-- 깃발 삭제
							cNPCVanish( Handle )
							ArenaFlagInfo[ FlagTeamNumber ][ "Handle" ] = nil

							-- 깃발 소환
							Regen_Handle = cMobRegen_XY( Var[ "MapIndex" ], Regen_Flag[ "Index" ], Regen_Flag[ "X" ], Regen_Flag[ "Y" ], Regen_Flag[ "Dir" ] )

							if Regen_Handle ~= nil
							then

								cSetAIScript ( MainLuaScriptPath, Regen_Handle )
								cAIScriptFunc( Regen_Handle, "Entrance", "ArenaFlag_Entrance" )

								ArenaFlagInfo[ FlagTeamNumber ][ "Handle" ]						= Regen_Handle
								ArenaFlagInfo[ FlagTeamNumber ][ "PlayerHandle" ]				= nil
								ArenaFlagInfo[ FlagTeamNumber ][ "PlayerTeam" ]					= nil
								ArenaFlagInfo[ FlagTeamNumber ][ "Drop_LifeTime" ]				= nil
								ArenaFlagInfo[ FlagTeamNumber ][ "X" ]							= Regen_Flag[ "X" ]
								ArenaFlagInfo[ FlagTeamNumber ][ "Y" ]							= Regen_Flag[ "Y" ]
								ArenaFlagInfo[ FlagTeamNumber ][ "GoalConditionNoticeTime" ] 	= nil
								ArenaFlagInfo[ FlagTeamNumber ][ "Penalty"]						= nil
							end

							-- 깃발 회수 알림
							cScriptMessage( Var[ "MapIndex" ], ArenaFlag[ FlagTeamNumber ][ "ScriptMsg" ][ "Return_Flag" ] )

							return ReturnAI[ "END" ]
						end
					else
						------------------------------------------------------------
						-- 적군 : 깃발 획득
						------------------------------------------------------------

						--
						local FlagData    		 = ArenaFlag[ FlagTeamNumber ]
						local PenaltyData 		 = ArenaFlag["Penalty"]
						local Player_X, Player_Y = cObjectLocate( Handle )

						if X == nil or Y == nil
						then
							Player_X = 0
							Player_Y = 0
						end

						-- 깃발 정보 설정
						ArenaFlagInfo[ FlagTeamNumber ][ "Handle" ]						= nil
						ArenaFlagInfo[ FlagTeamNumber ][ "PlayerHandle" ]				= Var[ "Player" ][ PlayerIndex ][ "Handle" ]
						ArenaFlagInfo[ FlagTeamNumber ][ "PlayerTeam" ]					= Var[ "Player" ][ PlayerIndex ][ "TeamNumber" ]
						ArenaFlagInfo[ FlagTeamNumber ][ "Drop_LifeTime" ]				= nil
						ArenaFlagInfo[ FlagTeamNumber ][ "X" ] 							= Player_X
						ArenaFlagInfo[ FlagTeamNumber ][ "Y" ] 							= Player_Y
						ArenaFlagInfo[ FlagTeamNumber ][ "GoalConditionNoticeTime" ] 	= nil
						ArenaFlagInfo[ FlagTeamNumber ][ "Penalty"]						= {}
						ArenaFlagInfo[ FlagTeamNumber ][ "Penalty"]["Step"]				= 1
						ArenaFlagInfo[ FlagTeamNumber ][ "Penalty"]["CheckTime"]		= CurSec + PenaltyData["Step"][ 1 ]["CheckTick"]


						-- 깃발 획득자 상태이상 걸기
						cSetAbstate( PlayerList[i], FlagData["Abstate"]["Index"],
													FlagData["Abstate"]["Str"],
													FlagData["Abstate"]["KeepTime"] )

						-- 깃발 획득자 패널티 부여
						for PenaltyIndex = 1, #PenaltyData["Abstate"]
						do
							cSetAbstate( PlayerList[i], PenaltyData["Abstate"][PenaltyIndex]["Index"],
														PenaltyData["Abstate"][PenaltyIndex]["Str"],
														PenaltyData["Abstate"][PenaltyIndex]["KeepTime"] )
						end

						-- 목적지 방향 표시
						cDirectionalArrow( PlayerList[ i ], ArenaFlag[ FlagTeamNumber ][ "GoalPoint" ][ "X" ], ArenaFlag[ FlagTeamNumber ][ "GoalPoint" ][ "Y" ] )

						-- 깃발 획득 알리기
						local PlayerName = cGetPlayerName( PlayerList[ i ] )
						if PlayerName == nil
						then
							PlayerName = ""
						end

						cScriptMessage( Var[ "MapIndex" ], ArenaFlag[ FlagTeamNumber ][ "ScriptMsg" ][ "Have_Flag" ], PlayerName )
						cNPCVanish( Handle )

						return ReturnAI[ "END" ]
					end
				end

				break
			end
		end
	end

	return ReturnAI[ "END" ]

end


function ArenaStone_Entrance( Handle, MapIndex )
cExecCheck "ArenaStone_Entrance"


	-- 사용할 데이터 : 킹덤 퀘스트 정보, 현재시간
	local Var 		= InstanceField[ MapIndex ]
	local CurSec 	= cCurrentSecond()


	if Var == nil
	then
		return ReturnAI[ "END" ]
	end

	if CurSec == nil
	then
		return ReturnAI[ "END" ]
	end

	if Var[ "ArenaStone" ] == nil
	then
		return ReturnAI[ "END" ]
	end

	if Var[ "ArenaStone" ][ "SkillUseTime" ] == nil
	then
		return ReturnAI[ "END" ]
	end

	if Var[ "ArenaStone" ][ "SkillUseTime" ][ Handle ] == nil
	then

		-- 스킬 사용시간이 설정되어있지 않으면 설정해준다.
		Var[ "ArenaStone" ][ "SkillUseTime" ][ Handle ] = CurSec + ArenaStone[ "IntervalTime" ]
		return ReturnAI[ "END" ]

	end

	-- 스킬 사용시간 확인
	if Var[ "ArenaStone" ][ "SkillUseTime" ][ Handle ] <= CurSec
	then

		-- 스킬 사용
		cSkillBlast( Handle, Handle, ArenaStone[ "SkillIndex" ] )

		-- 다음 스킬 사용시간 설정
		Var[ "ArenaStone" ][ "SkillUseTime" ][ Handle ] = CurSec + ArenaStone[ "IntervalTime" ]
	end

	return ReturnAI[ "END" ]

end


function ArenaCrystal_Entrance( Handle, MapIndex )
cExecCheck "ArenaCrystal"


	-- 사용할 데이터 : 킹덤 퀘스트 정보, 현재시간, 크리스탈 HP 정보
	local Var			= InstanceField[ MapIndex ]
	local CurSec 		= cCurrentSecond()
	local CurHP, MaHP	= cObjectHP( Handle )


	if Var == nil
	then
		return ReturnAI[ "END" ]
	end

	if CurSec == nil
	then
		return ReturnAI[ "END" ]
	end

	if CurHP == nil
	then
		return returnAI[ "END" ]
	end

	if Var[ "ArenaCrystal" ] == nil
	then
		return ReturnAI[ "END" ]
	end


	-- 크리스탈 HP 에 따른 처리
	if CurHP > 1
	then

		------------------------------------------------------------
		-- 일정 간격으로 사용하는 스킬
		------------------------------------------------------------
		if Var[ "ArenaCrystal" ][ "SkillUseTime" ] == nil
		then

			-- 스킬 사용시간이 설정되어있지 않으면 설정해준다.
			Var[ "ArenaCrystal" ][ "SkillUseTime" ] = CurSec + ArenaCrystal[ "Routine" ][ "BlastTime" ]
			return ReturnAI[ "END" ]
		end


		-- 스킬 사용시간 확인
		if Var[ "ArenaCrystal" ][ "SkillUseTime" ] <= CurSec
		then

			-- 크리스탈 위치 가져오기
			local X, Y = cObjectLocate( Handle )
			if X == nil or Y == nil
			then
				return ReturnAI[ "END" ]
			end


			-- 스킬 사용
			--cMagicFieldSpread( Handle, X, Y, 0, ArenaCrystal[ "Routine" ][ "MagicField" ], 0 )
			cSkillBlast( Handle, Handle, ArenaCrystal[ "Routine" ][ "SkillIndex" ] )

			-- 다음 스킬 사용시간 설정
			Var[ "ArenaCrystal" ][ "SkillUseTime" ] = CurSec + ArenaCrystal[ "Routine" ][ "BlastTime" ]
		end
	else

		------------------------------------------------------------
		-- 죽을때 사용하는 스킬
		------------------------------------------------------------
		if Var[ "ArenaCrystal" ][ "SkillUseTime" ] ~= nil
		then

			if Var[ "ArenaCrystal" ][ "SkillUseTime" ] <= CurSec
			then

				-- 스킬사용
				cSkillBlast( Handle, Handle, ArenaCrystal[ "Dead" ][ "SkillIndex" ] )
				Var[ "ArenaCrystal" ][ "SkillUseTime" ]	= nil
				Var[ "ArenaCrystal" ][ "VanishTime" ] 	= CurSec + ArenaCrystal[ "Dead" ][ "BlastTime" ]
			end
		end

		-- 소멸시간 확인
		if Var[ "ArenaCrystal" ][ "VanishTime" ] ~= nil
		then

			if Var[ "ArenaCrystal" ][ "VanishTime" ] <= CurSec
			then

				-- 핸들 초기화
				Var[ "ArenaCrystal" ][ "Handle" ] = nil

				-- 스크립트 해제, 오브젝트 소멸
				cAIScriptSet( Handle )
				cKillObject( Handle )
			end
		end
	end

	return ReturnAI[ "END" ]

end
