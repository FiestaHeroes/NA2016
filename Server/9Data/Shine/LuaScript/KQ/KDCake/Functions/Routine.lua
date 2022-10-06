--------------------------------------------------------------------------------
--                             Routine                            		     --
--------------------------------------------------------------------------------



function DummyRoutineFunc()
cExecCheck "DummyRoutineFunc"

	return ReturnAI["END"]
end


----------------------------------------------------------------------
-- MapLogin Function
----------------------------------------------------------------------
function PlayerMapLogin( MapIndex, Handle )
cExecCheck "PlayerMapLogin"


	local CurSec	= cCurrentSecond()
	local TeamType	= cGetKQTeamType( Handle )
	local CharNo	= cGetCharNo( Handle )


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "PlayerMapLogin : Var nil" )
		return
	end

	if CurSec == nil
	then
		ErrorLog( "PlayerMapLogin : CurSec nil" )
		return
	end

	if TeamType == nil
	then
		ErrorLog( "PlayerMapLogin : TeamType nil" )
		return
	end

	if TeamType ~= KQ_TEAM["RED"] and TeamType ~= KQ_TEAM["BLUE"]
	then
		ErrorLog( "PlayerMapLogin : Invalid TeamType "..TeamType )
		return
	end

	if CharNo == nil
	then
		ErrorLog( "PlayerMapLogin : CharNo nil" )
		return
	end

	if Var["Team"] == nil
	then
		ErrorLog( "PlayerMapLogin : Var[\"Team\"] nil" )
		return
	end


	-- ���ӽ� ���� ������ �����̻�
	for i = 1, #LoginResetAbstate
	do
		cResetAbstate( Handle, LoginResetAbstate[ i ] )
	end


	-- �÷��̾� ���� �߰�, ����
	local PlayerInfo = Player_Get( Var, CharNo )
	if PlayerInfo == nil
	then

		-- �ű� �÷��̾� ���� �߰�
		Player_Insert( Var, CharNo, Handle, TeamType )

	else

		-- ���� �÷��̾� ���� ����
		PlayerInfo["Handle"] 	= Handle
		PlayerInfo["IsInMap"] 	= true

	end


	-- �� ������ ����, ����� ������ �Ӹ��� ȭ��ǥ �����̻� ����
	for i = 1, #TeamUniform[ TeamType ]
	do
		cViewSlotEquip( Handle, TeamUniform[ TeamType ][ i ] )
		cSetAbstate( Handle, TeamAbstate[ TeamType ]["Index"], TeamAbstate[ TeamType ]["Str"], TeamAbstate[ TeamType ]["KeepTime"], Handle )
	end


	-- �̵� �ӵ� ����
	cStaticWalkSpeed( Handle, true, 33 )
	cStaticRunSpeed( Handle, true, 127 )


	-- ���� ���� ���� �ƴϸ� �Լ� ����
	if Var["RoundEndTime"] <= 0
	then
		return
	end

	-- ����, Ÿ�̸� ���� ����
	local RedTeamInfo	= Var["Team"][ KQ_TEAM["RED"] ]
	local BlueTeamInfo	= Var["Team"][ KQ_TEAM["BLUE"] ]


	-- ���� ���� ��, �÷��̾� ������ ������
	if PlayerInfo ~= nil
	then
		if PlayerInfo["IsOut"] == false
		then
			Var["Team"][ TeamType ]["Score"] = Var["Team"][ TeamType ]["Score"] + 1
		end
	end


	-- ����, �ð� ���� �˸�
	cScoreBoard( Handle, true, Var["Round"], RedTeamInfo["RoundResultCount"]["Win"], RedTeamInfo["Score"], BlueTeamInfo["RoundResultCount"]["Win"], BlueTeamInfo["Score"] )
	cTimer_Obj( Handle, (Var["RoundEndTime"] - CurSec) )

end


----------------------------------------------------------------------
-- ServantSummon Function
----------------------------------------------------------------------
function ServantSummon( MapIndex, ServantHandle, ServantIndex, MasterHandle )
cExecCheck "ServantSummon"


	if ServantIndex == Cake["MobIndex"]
	then

		cSetAIScript ( MainLuaScriptPath, ServantHandle )
		cAIScriptFunc( ServantHandle, "Entrance",  "Cake_Entrance" )
		cAIScriptFunc( ServantHandle, "NPCAction", "Cake_NPCAction" )

	elseif ServantIndex == DrinkCannon["MobIndex"]
	then

		cSetAIScript ( MainLuaScriptPath, ServantHandle )
		cAIScriptFunc( ServantHandle, "Entrance",  "DrinkCannon_Entrance" )

	end

end


----------------------------------------------------------------------
-- Cake_Explosion Function
----------------------------------------------------------------------
function Cake_Explosion( Var, NPCHandle )
cExecCheck "Cake_Explosion"


	local CurSec = cCurrentSecond()
	local TeamType	= cGetKQTeamType( NPCHandle )


	if Var == nil
	then
		ErrorLog( "Cake_Explosion : Var nil" )
		return
	end

	if NPCHandle == nil
	then
		ErrorLog( "Cake_Explosion : Var nil" )
		return
	end

	if CurSec == nil
	then
		ErrorLog( "Cake_Explosion : CurSec nil" )
		return
	end

	if TeamType == nil
	then
		ErrorLog( "Cake_Explosion : TeamType nil" )
		return
	end

	if TeamType ~= KQ_TEAM["RED"] and TeamType ~= KQ_TEAM["BLUE"]
	then
		ErrorLog( "Cake_Explosion : Invalid TeamType "..TeamType )
		return
	end


	-- ���� ���� ���̸� �ƹ� ó���� ���� �ʴ´�
	if Var["RoundEndTime"] > 0
	then

		-- �÷��̾� ����Ʈ���� ���� �Ÿ��� Ȯ��
		local PlayerList = Var["Player"]
		if PlayerList == nil
		then
			ErrorLog( "Cake_Explosion : PlayerList nil" )
			return
		end


		for i = 1, #PlayerList
		do
			local PlayerInfo = PlayerList[ i ]


			-- ��� ���� Ȯ��
			if PlayerInfo["IsInMap"]  == true and															-- �ʿ� �����ϴ���
			   PlayerInfo["TeamType"] == OpposingTeamInfo[ TeamType ] and									-- �� ������
			   PlayerInfo["PrisonLinkToWaitTime"] == 0 and													-- ������ �� ��������
			   PlayerInfo["IsOut"] == false and																-- ������ �ۿ� �ִ���
			   cDistanceSquar( NPCHandle, PlayerInfo["Handle"] ) <= ( Cake["Dist"] * Cake["Dist"] )			-- ���� �ȿ� �����ϴ���
			then

				local Player_x, Player_y = cObjectLocate( PlayerInfo["Handle"] )

				if Player_x ~= nil and Player_y ~= nil
				then

					if cFindAttackBlockLocate( NPCHandle, Player_x, Player_y ) == true	-- ���� �� Ȯ��
					then

						PlayerInfo["CakeHandle"]			= NPCHandle
						PlayerInfo["CakeAbstateTime"]		= CurSec + Cake["SetAbstateWait"]
						PlayerInfo["PrisonLinkToWaitTime"]	= CurSec + Cake["LinktoWait"]
					end
				end
			end
		end

	end


	cSkillBlast( NPCHandle, NPCHandle, Cake["SkillIndex"] )
	cVanishReserv( NPCHandle, 3 )

end


----------------------------------------------------------------------
-- Cake_Entrance Function
----------------------------------------------------------------------
function Cake_Entrance( Handle, MapIndex )
cExecCheck "Cake_Entrance"


	-- �׾����� ��ũ��Ʈ ����
	if cIsObjectDead( Handle ) ~= nil
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	-- ���� ���� ��ũ��Ʈ ����
	if cIsObjectAlreadyDead( Handle ) == true
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end


	-- �̵��� ���߾����� ����
	--if cGetMoveState( Handle ) ~= 0
	local MoveState, MoveStateTime, MoveStateSetTime = cGetMoveState( Handle )
	if MoveState ~= 0 or MoveStateSetTime == 0
	then
		return ReturnAI["CPP"]
	end


	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		ErrorLog( "Cake_Entrance : Var nil" )
		return ReturnAI["END"]
	end


	Cake_Explosion( Var, Handle )


	return ReturnAI["END"]
end


----------------------------------------------------------------------
-- Cake_NPCAction Function
----------------------------------------------------------------------
function Cake_NPCAction( MapIndex, NPCHandle, PlyHandle, PlyCharNo )
cExecCheck "Cake_NPCAction"


	local TeamType		= cGetKQTeamType( NPCHandle )
	local Var			= InstanceField[ MapIndex ]
	local MasterHandle	= cGetMaster( NPCHandle )

	if Var == nil
	then
		ErrorLog( "Cake_NPCAction : Var nil" )
		return
	end

	if TeamType == nil
	then
		ErrorLog( "Cake_NPCAction : TeamType nil" )
		return
	end

	if TeamType ~= KQ_TEAM["RED"] and TeamType ~= KQ_TEAM["BLUE"]
	then
		ErrorLog( "Cake_NPCAction : Invalid TeamType "..TeamType )
		return
	end

	-- ��ȯ�� ������ Ȯ��
	if MasterHandle == PlyHandle
	then
		return
	end


	-- NPC�̵� ����
	cMoveStop( NPCHandle )

	-- ����
	Cake_Explosion( Var, NPCHandle )

end


----------------------------------------------------------------------
-- DrinkCannon_Entrance Function
----------------------------------------------------------------------
function DrinkCannon_Entrance( Handle, MapIndex )
cExecCheck "DrinkCannon_Entrance"

	local CurSec	= cCurrentSecond()
	local TeamType	= cGetKQTeamType( Handle )
	local Var		= InstanceField[ MapIndex ]


	if Var == nil
	then
		ErrorLog( "DrinkCannon_Entrance : Var nil" )
		return
	end

	-- ���� ���� ���̸� �ƹ� ó���� ���� �ʴ´�.
	if Var["RoundEndTime"] <= 0
	then
		return
	end


	if CurSec == nil
	then
		ErrorLog( "DrinkCannon_Entrance : CurSec nil" )
		return
	end

	if TeamType == nil
	then
		ErrorLog( "DrinkCannon_Entrance : TeamType nil" )
		return
	end

	if TeamType ~= KQ_TEAM["RED"] and TeamType ~= KQ_TEAM["BLUE"]
	then
		ErrorLog( "DrinkCannon_Entrance : Invalid TeamType "..TeamType )
		return
	end


	-- �÷��̾� ����Ʈ���� ���� �Ÿ��� Ȯ��
	local PlayerList = Var["Player"]
	if PlayerList == nil
	then
		ErrorLog( "DrinkCannon_Entrance : PlayerList nil" )
		return false
	end

	for i = 1, #PlayerList
	do
		local PlayerInfo = PlayerList[ i ]

		-- ��� ���� Ȯ��
		if PlayerInfo["IsInMap"]  == true and																-- �ʿ� �����ϴ���
		   PlayerInfo["TeamType"] == OpposingTeamInfo[ TeamType ] and										-- �� ������
		   PlayerInfo["PrisonLinkToWaitTime"] == 0 and														-- ������ �� ��������
		   PlayerInfo["IsOut"] == false and																	-- ������ �ۿ� �ִ���
		   cDistanceSquar( Handle, PlayerInfo["Handle"] ) <= ( DrinkCannon["Dist"] * DrinkCannon["Dist"] )	-- ���� �ȿ� �ִ���
		then

			local Player_x, Player_y = cObjectLocate( PlayerInfo["Handle"] )

			if Player_x ~= nil and Player_y ~= nil
			then

				if cFindAttackBlockLocate( Handle, Player_x, Player_y ) == true	-- ���� �� Ȯ��
				then

					cSetAbstate( PlayerInfo["Handle"], DrinkCannon["Abstate"]["Index"], 1, DrinkCannon["Abstate"]["KeepTime"], Handle )
					PlayerInfo["PrisonLinkToWaitTime"] = CurSec + DrinkCannon["LinktoWait"]
				end
			end
		end
	end


	cNPCVanish( Handle )


	return ReturnAI["END"]
end
