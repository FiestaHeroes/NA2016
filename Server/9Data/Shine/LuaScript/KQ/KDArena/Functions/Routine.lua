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

	-- ����� ������ : ŷ�� ����Ʈ ����, ����ð�, �÷��̾� �� ��ȣ, �÷��̾� ĳ�� ��ȣ
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


	-- �÷��̾� ��, �ڵ�, �߰� ����,
	local PlayerCount 	= #Var[ "Player" ]
	local OldHandle		= 0
	local PlayerInsert	= true


	-- �÷��̾� ��� ã��
	for i = 1, PlayerCount
	do

		if CharNo == Var[ "Player" ][ i ][ "CharNo" ]
		then

			-- �÷��̾� �߰� ����, �ڵ� ����
			PlayerInsert 							= false
			OldHandle 								= Var[ "Player" ][ i ][ "Handle" ]
			Var[ "Player" ][ i ][ "Handle" ]		= Handle
			Var[ "Player" ][ i ][ "FlagPickSec" ]	= CurSec + ArenaFlag[ "PickDelay" ]
			Var[ "Player" ][ i ][ "InMap" ]			= true


			-- �÷��̾� �� ��ȣ�� �ٸ� ���
			if TeamNumber ~= Var[ "Player" ][ i ][ "TeamNumber" ]
			then

				-- �� ����
				local DelTeamNumber 	= Var[ "Player" ][ i ][ "TeamNumber" ]
				local TeamMemberCount 	= #Var[ "Team" ][ DelTeamNumber ][ "Member" ]

				-- �� ��� ��Ͽ��� ����
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

				-- �÷��̾� ��Ͽ��� ����
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
		-- �÷��̾� ���� �߰�
		------------------------------------------------------------
		if TeamNumber >= DEF_TEAM
		then
			return
		end


		local P_InsertIndex = ( PlayerCount + 1	)
		local T_InsertIndex = ( #Var[ "Team" ][ TeamNumber ][ "Member" ] + 1 )

		-- �÷��̾� ��Ͽ� �߰�
		Var[ "Player" ][ P_InsertIndex ]						= {}
		Var[ "Player" ][ P_InsertIndex ][ "Handle" ]			= Handle
		Var[ "Player" ][ P_InsertIndex ][ "CharNo" ]			= CharNo
		Var[ "Player" ][ P_InsertIndex ][ "FlagPickSec" ]		= CurSec + ArenaFlag[ "PickDelay" ]
		Var[ "Player" ][ P_InsertIndex ][ "InMap" ]				= true
		Var[ "Player" ][ P_InsertIndex ][ "TeamNumber" ]		= TeamNumber

		-- �� ��� ��Ͽ� �߰�
		Var["Team"][ TeamNumber ][ "Member" ][ T_InsertIndex ]	= Handle

	elseif OldHandle ~= Handle
	then

		------------------------------------------------------------
		-- �÷��̾� ���� ����
		------------------------------------------------------------
		local MemberCount = #Var["Team"][ TeamNumber ][ "Member" ]

		-- �� ��� ���� ����
		for i = 1, MemberCount
		do

			if OldHandle == Var["Team"][ TeamNumber ][ "Member" ][ i ]
			then

				Var["Team"][ TeamNumber ][ "Member" ][ i ] = Handle
				break
			end
		end
	end


	-- �� ������ ����
	for i = 1, #TeamUniform[ TeamNumber ]
	do
		cViewSlotEquip( Handle, TeamUniform[ TeamNumber ][ i ] )
	end


	-- ������ ���� ���� �ƴϸ� �Լ� ����
	if Var[ "KQLimitTime" ] <= 0
	then
		return
	end


	-- �Ʒ��� ����, �ð� ���� ����
	cScoreInfo( Handle, #TeamNumberList, Var[ "Team" ][ RED_TEAM ][ "Score" ], Var[ "Team" ][ BLUE_TEAM ][ "Score" ] )
	cTimer_Obj( Handle, ( Var[ "KQLimitTime" ] - CurSec ) )

end


----------------------------------------------------------------------
-- Click Functions
----------------------------------------------------------------------
function ArenaGate_Click( NPCHandle, PlayerHandle, PlayerCharNo, Arg )
cExecCheck "ArenaGate_Click"


	-- ���ε��� ��������
	local NPCMapIndex = cGetCurMapIndex( NPCHandle )
	if NPCMapIndex == nil
	then
		return
	end

	-- ����� ������ : ŷ�� ����Ʈ ����
	local Var = InstanceField[ NPCMapIndex ]
	if Var == nil
	then
		return
	end


	if Var[ "ArenaGate" ] == nil
	then
		return
	end


	-- ����Ʈ ���� ã��
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

	-- �÷��̾� �� Ȯ��
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


	-- ����� ������ : ŷ�� ����Ʈ ����, ����ð�
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


	-- �� ��ȣ ã��
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
	-- ��� 30 �� �� ���� ��ġ�� �̵�
	------------------------------------------------------------
	if ArenaFlagInfo[ FlagTeamNumber ][ "Drop_LifeTime" ] ~= nil
	then

		if ArenaFlagInfo[ FlagTeamNumber ][ "Drop_LifeTime" ] <= CurSec
		then

			local Regen_Flag	= RegenInfo[ "NPC" ][ "ArenaFlag" ][ FlagTeamNumber ]
			local Regen_Handle	= nil

			-- ��� ����
			cNPCVanish( Handle )
			ArenaFlagInfo[ FlagTeamNumber ][ "Handle" ] = nil

			-- ��� ��ȯ
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

			-- ��� ȸ�� �˸�
			cScriptMessage( Var[ "MapIndex" ], ArenaFlag[ FlagTeamNumber ][ "ScriptMsg" ][ "Return_Flag" ] )
			return ReturnAI[ "END" ]
		end
	end


	------------------------------------------------------------
	-- ��ó�� �÷��̾ ���� ���
	------------------------------------------------------------
	local PlayerList = { cNearObjectList( Handle, ArenaFlag[ "CheckDistance_Falg" ], ObjectType[ "Player" ] ) }
	for i = 1, #PlayerList
	do

		-- �Ʒ����� �������� �÷��̾� ��ϰ� ��
		for PlayerIndex = 1, #Var[ "Player" ]
		do

			-- �ڵ�, ��� ȹ�� ���� �ð� ��
			if	Var[ "Player" ][ PlayerIndex ][ "Handle" ] 		== PlayerList[ i ]	and
				Var[ "Player" ][ PlayerIndex ][ "FlagPickSec" ] <= CurSec
			then

				-- �����̻� Ȯ��( ����, �������� )
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
							-- �Ʊ� : ��� ���� ����Ʈ�� ��ȯ
							------------------------------------------------------------
							local Regen_Flag	= RegenInfo[ "NPC" ][ "ArenaFlag" ][ FlagTeamNumber ]
							local Regen_Handle	= nil

							-- ��� ����
							cNPCVanish( Handle )
							ArenaFlagInfo[ FlagTeamNumber ][ "Handle" ] = nil

							-- ��� ��ȯ
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

							-- ��� ȸ�� �˸�
							cScriptMessage( Var[ "MapIndex" ], ArenaFlag[ FlagTeamNumber ][ "ScriptMsg" ][ "Return_Flag" ] )

							return ReturnAI[ "END" ]
						end
					else
						------------------------------------------------------------
						-- ���� : ��� ȹ��
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

						-- ��� ���� ����
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


						-- ��� ȹ���� �����̻� �ɱ�
						cSetAbstate( PlayerList[i], FlagData["Abstate"]["Index"],
													FlagData["Abstate"]["Str"],
													FlagData["Abstate"]["KeepTime"] )

						-- ��� ȹ���� �г�Ƽ �ο�
						for PenaltyIndex = 1, #PenaltyData["Abstate"]
						do
							cSetAbstate( PlayerList[i], PenaltyData["Abstate"][PenaltyIndex]["Index"],
														PenaltyData["Abstate"][PenaltyIndex]["Str"],
														PenaltyData["Abstate"][PenaltyIndex]["KeepTime"] )
						end

						-- ������ ���� ǥ��
						cDirectionalArrow( PlayerList[ i ], ArenaFlag[ FlagTeamNumber ][ "GoalPoint" ][ "X" ], ArenaFlag[ FlagTeamNumber ][ "GoalPoint" ][ "Y" ] )

						-- ��� ȹ�� �˸���
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


	-- ����� ������ : ŷ�� ����Ʈ ����, ����ð�
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

		-- ��ų ���ð��� �����Ǿ����� ������ �������ش�.
		Var[ "ArenaStone" ][ "SkillUseTime" ][ Handle ] = CurSec + ArenaStone[ "IntervalTime" ]
		return ReturnAI[ "END" ]

	end

	-- ��ų ���ð� Ȯ��
	if Var[ "ArenaStone" ][ "SkillUseTime" ][ Handle ] <= CurSec
	then

		-- ��ų ���
		cSkillBlast( Handle, Handle, ArenaStone[ "SkillIndex" ] )

		-- ���� ��ų ���ð� ����
		Var[ "ArenaStone" ][ "SkillUseTime" ][ Handle ] = CurSec + ArenaStone[ "IntervalTime" ]
	end

	return ReturnAI[ "END" ]

end


function ArenaCrystal_Entrance( Handle, MapIndex )
cExecCheck "ArenaCrystal"


	-- ����� ������ : ŷ�� ����Ʈ ����, ����ð�, ũ����Ż HP ����
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


	-- ũ����Ż HP �� ���� ó��
	if CurHP > 1
	then

		------------------------------------------------------------
		-- ���� �������� ����ϴ� ��ų
		------------------------------------------------------------
		if Var[ "ArenaCrystal" ][ "SkillUseTime" ] == nil
		then

			-- ��ų ���ð��� �����Ǿ����� ������ �������ش�.
			Var[ "ArenaCrystal" ][ "SkillUseTime" ] = CurSec + ArenaCrystal[ "Routine" ][ "BlastTime" ]
			return ReturnAI[ "END" ]
		end


		-- ��ų ���ð� Ȯ��
		if Var[ "ArenaCrystal" ][ "SkillUseTime" ] <= CurSec
		then

			-- ũ����Ż ��ġ ��������
			local X, Y = cObjectLocate( Handle )
			if X == nil or Y == nil
			then
				return ReturnAI[ "END" ]
			end


			-- ��ų ���
			--cMagicFieldSpread( Handle, X, Y, 0, ArenaCrystal[ "Routine" ][ "MagicField" ], 0 )
			cSkillBlast( Handle, Handle, ArenaCrystal[ "Routine" ][ "SkillIndex" ] )

			-- ���� ��ų ���ð� ����
			Var[ "ArenaCrystal" ][ "SkillUseTime" ] = CurSec + ArenaCrystal[ "Routine" ][ "BlastTime" ]
		end
	else

		------------------------------------------------------------
		-- ������ ����ϴ� ��ų
		------------------------------------------------------------
		if Var[ "ArenaCrystal" ][ "SkillUseTime" ] ~= nil
		then

			if Var[ "ArenaCrystal" ][ "SkillUseTime" ] <= CurSec
			then

				-- ��ų���
				cSkillBlast( Handle, Handle, ArenaCrystal[ "Dead" ][ "SkillIndex" ] )
				Var[ "ArenaCrystal" ][ "SkillUseTime" ]	= nil
				Var[ "ArenaCrystal" ][ "VanishTime" ] 	= CurSec + ArenaCrystal[ "Dead" ][ "BlastTime" ]
			end
		end

		-- �Ҹ�ð� Ȯ��
		if Var[ "ArenaCrystal" ][ "VanishTime" ] ~= nil
		then

			if Var[ "ArenaCrystal" ][ "VanishTime" ] <= CurSec
			then

				-- �ڵ� �ʱ�ȭ
				Var[ "ArenaCrystal" ][ "Handle" ] = nil

				-- ��ũ��Ʈ ����, ������Ʈ �Ҹ�
				cAIScriptSet( Handle )
				cKillObject( Handle )
			end
		end
	end

	return ReturnAI[ "END" ]

end
