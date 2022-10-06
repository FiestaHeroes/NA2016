require( "common" )
require( "KQ/KDSpring/KDSpring_Data" )
require( "KQ/KDSpring/KDSpring_StepFunc" )


------------------------------------------------------------------------------------------
--                            ŷ�� ����Ʈ ������ �ʱ�ȭ                                 --
------------------------------------------------------------------------------------------
function KF_INIT( Field, KSMemory, nCurSec )
cExecCheck "KF_INIT"

	if Field == nil
	then	-- �ʵ� �̸� Ȯ��
		return
	end

	if KSMemory == nil
	then	-- ŷ�� ����Ʈ ���� Ȯ��
		return
	end

	if nCurSec == nil
	then	-- �ð� Ȯ��
		return
	end


	-- ŷ�� ����Ʈ �ʵ� ��ũ��Ʈ ����
	cSetFieldScript( Field, KQ_SCRIPT_NAME )
	cFieldScriptFunc( Field, "MapLogin", "KF_MAP_LOGIN" )	-- ĳ���� �ʷα��ν� ȣ��Ǵ� �Լ� ����


	-- ���� ���� �ʱ�ȭ
	KSMemory["FIELD_NAME"] 		= Field
	KSMemory["WORK_TICK"]		= 0
	KSMemory["STEP_NO"] 		= 1
	KSMemory["STEP_NEXT_TIME"] 	= nCurSec + KQ_STEP[1]["KS_NEXT_TIME"]
	KSMemory["MSG_NO"] 			= 1
	KSMemory["MSG_NEXT_TIME"] 	= 1
	KSMemory["GAME_TYPE"] 		= KQ_GAME_TYEP["KGT_NORMAL"]

	-- ��� ���� �ʱ�ȭ
	KSMemory["FLAG_INFO"]						= {}
	KSMemory["FLAG_INFO"]["FHND"]				= KQ_INVALID_HANDLE
	KSMemory["FLAG_INFO"]["FINDEX"]				= ""
	KSMemory["FLAG_INFO"]["FPHND"]				= KQ_INVALID_HANDLE
	KSMemory["FLAG_INFO"]["FPICK_TIME"]			= 0
	KSMemory["FLAG_INFO"]["FREGEN_TIME"]		= 0
	KSMemory["FLAG_INFO"]["FREGEN_X"]			= KQ_FLAG_POINT["KFP_X"]
	KSMemory["FLAG_INFO"]["FREGEN_Y"]			= KQ_FLAG_POINT["KFP_Y"]

	-- �÷��̾� ����Ʈ �ʱ�ȭ
	KSMemory["PLAYER_LIST"]	= {}
--	KSMemory["PLAYER_LIST"][n]	= {}
--	KSMemory["PLAYER_LIST"][n]["PHND"]			= KQ_INVALID_HANDLE
--	KSMemory["PLAYER_LIST"][n]["PREG_NO"]		= KQ_INVALID_HANDLE
--	KSMemory["PLAYER_LIST"][n]["PNAME"]			= ""
--	KSMemory["PLAYER_LIST"][n]["PTEAM_NO"]		= 0
--	KSMemory["PLAYER_LIST"][n]["PIS_MAP"]		= false
--	KSMemory["PLAYER_LIST"][n]["PPICK_TIME"]	= 0


	-- �� ���� �ʱ�ȭ
	KSMemory["TEAM_LIST"] =
	{
		{	-- RED TEAM
			TSCORE			= 0,
			TPOINT_HND 		= KQ_INVALID_HANDLE,
			TMEMBER_LIST	= {},
		},

		{	-- BLUE TEAM
			TSCORE			= 0,
			TPOINT_HND 		= KQ_INVALID_HANDLE,
			TMEMBER_LIST 	= {},
		},
	}

	-- ���� ����
	KSMemory["MOB_LIST"] 	= {}
--	KSMemory["MOB_LIST"][n]	= {}
--	KSMemory["MOB_LIST"][n]["MHND"]			= KQ_INVALID_HANDLE
--	KSMemory["MOB_LIST"][n]["MREGEN_TIME"]	= 0

	-- �� ��ȯ
	KSMemory["DOOR_LIST"]	= {}
	for i = 1, #KQ_DOOR
	do
		KSMemory["DOOR_LIST"][i] = cDoorBuild( KSMemory["FIELD_NAME"], KQ_DOOR[i]["KD_INDEX"], KQ_DOOR[i]["KD_X"], KQ_DOOR[i]["KD_Y"], KQ_DOOR[i]["KD_DIR"], KQ_DOOR[i]["KD_SCALE"] )
		cDoorAction( KSMemory["DOOR_LIST"][i], KQ_DOOR[i]["KD_BLOCK"], "open" )
	end

end


------------------------------------------------------------------------------------------
--                                    �� �α���                                         --
------------------------------------------------------------------------------------------
function KF_MAP_LOGIN( Field, Handle )
cExecCheck "KF_MAP_LOGIN"

	local KSMemory	= InstanceField[Field]	-- ŷ�� ����Ʈ ����
	local nCurSec 	= cCurSec();			-- ���� �ð�(��)

	if KSMemory == nil
	then	-- ŷ�� ����Ʈ ���� Ȯ��
		return
	end

	if Handle == nil
	then	-- �÷��̾� �ڵ� Ȯ��
		return
	end

	if nCurSec == nil
	then	-- �ð� Ȯ��
		nCurSec = 0
	end


	local nAdminLevel	= cGetAdminLevel( Handle )	-- ��� ����
	local nCharNo		= cGetCharNo( Handle )		-- ĳ���� ��ȣ
	local TeamInfo 		= KSMemory["TEAM_LIST"]		-- ŷ�� ����Ʈ ���� : �� ����

	if nAdminLevel > 0
	then	-- ��� ���� Ȯ��
		if cAbstateRestTime( Handle, "StaGMHideMode" ) ~= nil
		then	-- Hide ���� Ȯ��
			return
		end
	end

	if nCharNo == nil
	then	-- ĳ���� ��ȣ Ȯ��
		return
	end

	if TeamInfo == nil
	then	-- �� ���� Ȯ��
		return
	end


	local bLinkto		= false							-- �� ��ġ�� �̵�
	local bNewPlayer 	= true							-- ���� ���� �÷��̾�
	local nPlayerNum 	= #KSMemory["PLAYER_LIST"]		-- ���� �÷��̾� ��
	local nPlayerIndex	= nPlayerNum + 1				-- �÷��̾� ��Ͽ� ���� �߰��� �ε���
	local nTeamNo 		= KQ_TEAM_NO["KTN_DEFAULT"]		-- �� ��ȣ

	for i = 1, nPlayerNum
	do	-- �÷��̾� ��� Ž��

		if KSMemory["PLAYER_LIST"][i]["PREG_NO"] == nCharNo
		then	-- �÷��̾� ��Ͽ� �����ϴ� �÷��̾�

			bNewPlayer		= false
			nPlayerIndex	= i
			nTeamNo 		= KSMemory["PLAYER_LIST"][i]["PTEAM_NO"]

			if KSMemory["PLAYER_LIST"][i]["PHND"] ~= Handle
			then	-- ���� ���������� �ڵ��� �ٲ� �÷��̾�

				cAssertLog( "Handle Change" )
				KSMemory["PLAYER_LIST"][i]["PHND"] = Handle

				for j = 1, #TeamInfo[nTeamNo]
				do	-- �� ��� Ž��

					if TeamInfo[nTeamNo]["TMEMBER_LIST"][j] == KSMemory["PLAYER_LIST"][i]["PHND"]
					then	-- �� ��� Ȯ��
						TeamInfo[nTeamNo]["TMEMBER_LIST"][j] = Handle
					end
				end
			end

			KSMemory["PLAYER_LIST"][i]["PPICK_TIME"]	= nCurSec + KQ_PLAYER_PICK_DELAY	-- ��� ȹ�� ���� �ð�

			if KSMemory["PLAYER_LIST"][i]["PIS_MAP"] == false
			then	-- ŷ�� �ۿ� �־����� Ȯ��
				bLinkto									= true
				KSMemory["PLAYER_LIST"][i]["PIS_MAP"] 	= true
			end

			break
		end
	end


	if bNewPlayer == true			and		-- ���� ���� �÷��̾�
	   nPlayerNum >= KQ_MAX_PLAYER			-- ���� �÷��̾��� ��
	then	-- ���� �÷��̾� �ִ� �� Ȯ��
		cLinkTo( Handle, KQ_RETURN_MAP["KRM_INDEX"], KQ_RETURN_MAP["KRM_X"],KQ_RETURN_MAP["KRM_Y"] )
		return
	end


	if bNewPlayer == true
	then	-- ���� ���� �÷��̾�
		KSMemory["PLAYER_LIST"][nPlayerIndex] = {}
		KSMemory["PLAYER_LIST"][nPlayerIndex]["PHND"]		= Handle							-- �ڵ�
		KSMemory["PLAYER_LIST"][nPlayerIndex]["PREG_NO"]	= nCharNo							-- ĳ���� ��ȣ
		KSMemory["PLAYER_LIST"][nPlayerIndex]["PNAME"]		= cGetPlayerName( Handle )			-- ĳ���� �̸�
		KSMemory["PLAYER_LIST"][nPlayerIndex]["PTEAM_NO"]	= KQ_TEAM_NO["KTN_DEFAULT"]			-- �� ��ȣ
		KSMemory["PLAYER_LIST"][nPlayerIndex]["PIS_MAP"]	= true								-- �ʿ� �����ϴ���
		KSMemory["PLAYER_LIST"][nPlayerIndex]["PPICK_TIME"]	= nCurSec + KQ_PLAYER_PICK_DELAY	-- ��� ȹ�� ���� �ð�

		-- ��Ƽ ����
		cPartyLeave( Handle )
	end

	-- ���� ���� ������
	cScoreInfo( Handle, #KQ_TEAM, TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TSCORE"], TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TSCORE"] )


	-- �� �α��ν� �����̻� �ɱ�
	cSetAbstate( Handle, KQ_MAPLOGIN_ABSTATE["KMA_INDEX"], KQ_MAPLOGIN_ABSTATE["KMA_STR"], KQ_MAPLOGIN_ABSTATE["KMA_KEEPTIME"] )


	if nTeamNo == KQ_TEAM_NO["KTN_DEFAULT"]
	then	-- �� ��ȣ Ȯ��

		local RedMemberNum	= #TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TMEMBER_LIST"]
		local BlueMemberNum	= #TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TMEMBER_LIST"]

		if RedMemberNum > 0 or BlueMemberNum > 0
		then	-- �� ���� ���� Ȯ��

			if cPermileRate( 500 ) == 1
			then	-- �����ϰ� �� ��ȣ ����
				nTeamNo = KQ_TEAM_NO["KTN_RED"]

				if RedMemberNum > BlueMemberNum
				then	-- ������ �ο��� ��������� ���� ���
					nTeamNo = KQ_TEAM_NO["KTN_BLUE"]
				end
			else
				nTeamNo = KQ_TEAM_NO["KTN_BLUE"]

				if BlueMemberNum > RedMemberNum
				then	-- ����� �ο��� ���������� ���� ���
					nTeamNo = KQ_TEAM_NO["KTN_RED"]
				end
			end

			local nIndex = (#TeamInfo[nTeamNo]["TMEMBER_LIST"] + 1)

			-- �� ����� �߰�
			TeamInfo[nTeamNo]["TMEMBER_LIST"][nIndex] 			= Handle
			KSMemory["PLAYER_LIST"][nPlayerIndex]["PTEAM_NO"]	= nTeamNo

			-- ��Ƽ ����
			cPartyJoin( TeamInfo[nTeamNo]["TMEMBER_LIST"][1], Handle )

			-- �� ���������� �̵�
			cLinkTo( Handle, KSMemory["FIELD_NAME"], KQ_TEAM[nTeamNo]["KT_POINT_X"], KQ_TEAM[nTeamNo]["KT_POINT_Y"] )
		end

		return
	end


	if bLinkto == true											and	-- �� ��ġ�� �̵�
	   KQ_STEP[KSMemory["STEP_NO"]]["KS_LINKTO_TEAM"] == true		-- ���� ���� : �� ��ġ�� �̵�
	then	-- �÷��̾� �� ��ġ�� �̵�
		cLinkTo( Handle, KSMemory["FIELD_NAME"], KQ_TEAM[nTeamNo]["KT_POINT_X"], KQ_TEAM[nTeamNo]["KT_POINT_Y"] )
		return
	end


	for j = 1, #KQ_TEAM[nTeamNo]["KT_UNIFORM"]
	do	-- �� ������ ������
		cViewSlotEquip( Handle, KQ_TEAM[nTeamNo]["KT_UNIFORM"][j] )
	end


	if KQ_STEP[KSMemory["STEP_NO"]]["KS_TIMER"] == true
	then	-- Ÿ�̸� ǥ�� ���� Ȯ��
		local nTime = (KSMemory["STEP_NEXT_TIME"] - nCurSec)
		cTimer_Obj( Handle, nTime )
	end

end


------------------------------------------------------------------------------------------
--                                    �޼��� ����                                       --
------------------------------------------------------------------------------------------
function KF_MESSAGE( KSMemory, nCurSec )
cExecCheck "KF_MESSAGE"

	if KSMemory == nil
	then	-- ŷ�� ����Ʈ ���� Ȯ��
		return false
	end

	if nCurSec == nil
	then	-- �ð� Ȯ��
		return false
	end

	if KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"] == nil
	then	-- �ش� ���� �޽��� ���� Ȯ��
		return true
	end

	if KSMemory["MSG_NEXT_TIME"] > nCurSec
	then	-- �޽��� ��� �ð� Ȯ��
		return true
	end


	local MsgData = KQ_MSG[KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"]]	-- �޽��� ����
	local MsgStep = KSMemory["MSG_NO"]								-- �޽��� �ܰ�

	if MsgData == nil
	then	-- �޽��� ���� Ȯ��
		return false
	end

	if MsgStep == nil
	then	-- �޽��� �ܰ� Ȯ��
		return false
	end

	if #MsgData < MsgStep
	then	--�޽��� �ܰ� �ִ�ġ Ȯ��
		return true
	end


	if MsgData[MsgStep]["KM_TYPE"] == KQ_MSG_TYPE["KMT_SHN"]
	then	-- ScriptMessage
		cScriptMessage( KSMemory["FIELD_NAME"], MsgData[MsgStep]["KM_INDEX"], MsgData[MsgStep]["KM_VAL"] )
	elseif MsgData[MsgStep]["KM_TYPE"] == KQ_MSG_TYPE["KMT_TXT"]
	then	-- Notice
		cNotice( KSMemory["FIELD_NAME"], MsgData[MsgStep]["KM_FILE_NAME"], MsgData[MsgStep]["KM_INDEX"] )
	end


	-- �޽��� ���� �ܰ� ����
	MsgStep = MsgStep + 1

	if #MsgData < MsgStep
	then	-- ��� �޽��� ó��
		KSMemory["MSG_NO"] 			= 1
		KSMemory["MSG_NEXT_TIME"]	= KSMemory["STEP_NEXT_TIME"]
	else	-- ���� �ܰ� ����
		KSMemory["MSG_NO"] 			= MsgStep
		KSMemory["MSG_NEXT_TIME"]	= nCurSec + MsgData[MsgStep]["KM_TIME"]
	end

end


------------------------------------------------------------------------------------------
--                               ��� ������Ʈ ��ƾ                                     --
------------------------------------------------------------------------------------------
function KF_FLGAG_OBJECT( Handle, Field )
cExecCheck "KF_FLGAG_OBJECT"

	local KSMemory	= InstanceField[Field]		-- ŷ�� ����Ʈ ����
	local nCurSec	= cCurSec()					-- ���� �ð�(��)

	if KSMemory == nil
	then	-- ŷ�� ����Ʈ ���� Ȯ��
		return ReturnAI.END
	end

	if KSMemory["FLAG_INFO"] == nil
	then	-- ŷ�� ����Ʈ ���� : ��� ���� Ȯ��
		return ReturnAI.END
	end

	if KSMemory["FLAG_INFO"]["FPHND"] ~= KQ_INVALID_HANDLE
	then	-- ŷ�� ����Ʈ ���� : ������ ����� ������ ���� ���
		cNPCVanish( Handle )
		return ReturnAI.END
	end

	if KSMemory["PLAYER_LIST"] == nil
	then	-- ŷ�� ����Ʈ ���� : �÷��̾� ���� Ȯ��
		return ReturnAI.END
	end

	if nCurSec == nil
	then	-- �ð� ���� Ȯ��
		return ReturnAI.END
	end

	if nCurSec < KSMemory["FLAG_INFO"]["FPICK_TIME"]
	then	-- �ð� Ȯ��
		return ReturnAI.END
	end


	local nCheckDist = KQ_FLAG["KF_CHECK_DIST"]	-- ��� üũ �Ÿ�(�⺻ ��� ������Ʈ �Ÿ�)
	if KSMemory["FLAG_INFO"]["FINDEX"] == KQ_FLAG_POINT["KFP_INDEX"]
	then	-- ��� ���� Ȯ�� ( ��� ������Ʈ, ��� ����Ʈ ������Ʈ )
		nCheckDist = KQ_FLAG_POINT["KFP_CHECK_DIST"]
	end


	-- ��� üũ �Ÿ� �ȿ� �ִ� �÷��̾� ����Ʈ ��������
	local PlayerList = { cNearObjectList( Handle, nCheckDist, ObjectType["Player"] ) }

	for i = 1, #PlayerList
	do
		for j = 1, #KSMemory["PLAYER_LIST"]
		do
			if KSMemory["PLAYER_LIST"][j]["PHND"] == PlayerList[i] 					and	-- �ڵ�
			   KSMemory["PLAYER_LIST"][j]["PTEAM_NO"] ~= KQ_TEAM_NO["KTN_DEFAULT"]	and	-- �� ��ȣ
			   KSMemory["PLAYER_LIST"][j]["PPICK_TIME"] <= nCurSec						-- ��� ȹ�氡�� �ð�
			then	-- ��� ȹ�� ���� �ʰ� Ȯ��

				-- ��� ���� ����
				KSMemory["FLAG_INFO"]["FHND"]	= KQ_INVALID_HANDLE	-- ��� �ڵ�
				KSMemory["FLAG_INFO"]["FPHND"]	= PlayerList[i]		-- ��� ȹ�� �÷��̾� �ڵ�

				-- ��� �����̻� �ɱ�
				for  k = 1, #KQ_FLAG_ABSTATE
				do
					cSetAbstate( KSMemory["FLAG_INFO"]["FPHND"], KQ_FLAG_ABSTATE[k]["KFA_INDEX"], KQ_FLAG_ABSTATE[k]["KFA_STR"], KQ_FLAG_ABSTATE[k]["KFA_KEEPTIME"] )
				end

				-- ��� ȹ�� �˸�
				cScriptMessage( KSMemory["FIELD_NAME"], KQ_FLAG_SCRIPT_MSG["KFSM_HAVE"], KSMemory["PLAYER_LIST"][j]["PNAME"] )

				-- ���� ����Ʈ ����
				local nTeamNo = KSMemory["PLAYER_LIST"][j]["PTEAM_NO"]

				if nTeamNo ~= nil
				then	-- �� ��ȣ Ȯ��
					if KSMemory["TEAM_LIST"][nTeamNo]["TPOINT_HND"] == KQ_INVALID_HANDLE
					then	-- ���� ����Ʈ �ڵ� Ȯ��
						KSMemory["TEAM_LIST"][nTeamNo]["TPOINT_HND"] = cMobRegen_XY( Field, KQ_TEAM[nTeamNo]["KT_POINT_INDEX"], KQ_TEAM[nTeamNo]["KT_POINT_X"], KQ_TEAM[nTeamNo]["KT_POINT_Y"], 0 )
					end

					for k = 1, #KSMemory["TEAM_LIST"][nTeamNo]["TMEMBER_LIST"]
					do
						cPlaySound( KSMemory["TEAM_LIST"][nTeamNo]["TMEMBER_LIST"][k], KQ_SOUND["KS_GETFLAG"] );
					end
				end

				-- ��� ����
				cNPCVanish( Handle )
				return ReturnAI.END
			end
		end
	end


	return ReturnAI.END

end


------------------------------------------------------------------------------------------
--                                    ���� �Լ�                                         --
------------------------------------------------------------------------------------------
function Main( Field )
cExecCheck "Main"

	local nCurSec	= cCurSec()				-- ���� �ð�(��)
	local KSMemory	= InstanceField[Field]	-- ŷ�� ����Ʈ ����

	if KSMemory == nil
	then	-- ŷ�� ����Ʈ ���� Ȯ��

		-- ŷ�� ����Ʈ ���� �ʱ�ȭ
		InstanceField[Field]	= {}
		KSMemory				= InstanceField[Field]

		KF_INIT( Field, KSMemory, nCurSec )
	end


	if KSMemory["STEP_NO"] == nil
	then	-- ó�� �ܰ� Ȯ��
		return
	end

	if KQ_STEP[KSMemory["STEP_NO"]]["KS_FUNC"]( KSMemory, nCurSec ) == false
	then	-- ���� �Լ� ���� ����
		cLinkToAll( KSMemory["FIELD_NAME"], KQ_RETURN_MAP["KRM_INDEX"], KQ_RETURN_MAP["KRM_X"], KQ_RETURN_MAP["KRM_Y"] )
		cEndOfKingdomQuest( KSMemory["FIELD_NAME"] )
	end

end
