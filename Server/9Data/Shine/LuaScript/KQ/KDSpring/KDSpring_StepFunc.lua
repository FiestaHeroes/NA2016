------------------------------------------------------------------------------------------
--                                  �� ������ ���                                      --
------------------------------------------------------------------------------------------
function SF_DIVIDE_TEAM_WAIT( KSMemory, nCurSec )
cExecCheck "SF_DIVIDE_TEAM_WAIT"

	if KSMemory == nil
	then	-- ŷ�� ����Ʈ ���� Ȯ��
		return false
	end

	if nCurSec == nil
	then	-- �ð� Ȯ��
		return false
	end


	if #KSMemory["PLAYER_LIST"] >= KQ_MAX_PLAYER
	then	-- ���� ���� �ο� Ȯ��
		KSMemory["STEP_NEXT_TIME"] = nCurSec	-- ���� �ܰ�(�� ������)�� �����ϱ� ���� �ð� ����
	end


	if KSMemory["STEP_NEXT_TIME"] <= nCurSec
	then	-- ���� �ܰ� ���� �ð� Ȯ��

		for i = 1, #KSMemory["PLAYER_LIST"]
		do	-- ��� �÷��̾� ��Ƽ ����
			cPartyLeave( KSMemory["PLAYER_LIST"][i]["PHND"] )
		end


		if #KQ_STEP >= (KSMemory["STEP_NO"] + 1)
		then	-- ���� �ܰ� Ȯ��

			-- �ܰ� ����
			KSMemory["STEP_NO"] 		= KSMemory["STEP_NO"] + 1									-- ���� �ܰ�
			KSMemory["STEP_NEXT_TIME"]	= nCurSec + KQ_STEP[KSMemory["STEP_NO"]]["KS_NEXT_TIME"]	-- ���� �ܰ� ���� �ð�


			local MsgIndex = KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"]	-- �޼��� ����

			if MsgIndex ~= nil
			then	-- �޼��� �ε��� Ȯ��

				local MsgData = KQ_MSG[MsgIndex]	--	�޼��� ����

				if MsgData ~= nil
				then	-- �޼��� ���� ����
					KSMemory["MSG_NO"] 			= 1									-- �޼��� �ܰ�
					KSMemory["MSG_NEXT_TIME"] 	= nCurSec + MsgData[1]["KM_TIME"]	-- �޼��� ��� �ð�
				end
			end
		end
	end


	-- �޽��� ���
	KF_MESSAGE( KSMemory, nCurSec )

	return true

end


------------------------------------------------------------------------------------------
--                                    �� ������                                         --
------------------------------------------------------------------------------------------
function SF_DIVIDE_TEAM( KSMemory, nCurSec )
cExecCheck "SF_DIVIDE_TEAM"

	if KSMemory == nil
	then	-- ŷ�� ����Ʈ ���� Ȯ��
		return false
	end

	if nCurSec == nil
	then	-- �ð� Ȯ��
		return false
	end


	if KSMemory["STEP_NEXT_TIME"] <= nCurSec
	then	-- ���� �ܰ� ���� �ð� Ȯ��

		local nConnectNum = #KSMemory["PLAYER_LIST"]	-- ŷ�� ����Ʈ �ʿ� �������ִ� �÷��̾� ��

		-- ���� ���� �÷��̾� Ȯ��
		for i = 1, nConnectNum
		do
			if cIsInMap( KSMemory["PLAYER_LIST"][i]["PHND"], KSMemory["FIELD_NAME"] ) == nil
			then	-- ŷ�� ����Ʈ �ʿ� �������ִ��� Ȯ��
				nConnectNum								= nConnectNum - 1
				KSMemory["PLAYER_LIST"][i]["PIS_MAP"]	= false
			end
		end

		if nConnectNum <= 1
		then	-- ŷ�� ����Ʈ�ʿ� �������ִ� �÷��̾� �� Ȯ��
			return false
		end


		-- �� �ݱ�
		for i = 1, #KSMemory["DOOR_LIST"]
		do
			cDoorAction( KSMemory["DOOR_LIST"][i], KQ_DOOR[i]["KD_BLOCK"], "close" )
		end


		for i = 1, #KQ_NPC
		do	-- NPC ��ȯ
			cNPCRegen( KSMemory["FIELD_NAME"], KQ_NPC[i] )
		end


		local TeamInfo 			= KSMemory["TEAM_LIST"]		-- �� ����
		local nTeamNo 			= KQ_TEAM_NO["KTN_DEFAULT"]	-- �� ��ȣ
		local nTeamMemberMaxNum = nConnectNum / 2			-- �� ��� �ִ�ɼ�

		if TeamInfo == nil
		then	-- �� ���� Ȯ��
			return false
		end

		-- ���� ���� �÷��̾� �� ������
		for i = 1, #KSMemory["PLAYER_LIST"]
		do
			if KSMemory["PLAYER_LIST"][i]["PIS_MAP"] == true
			then	-- ŷ�� ����Ʈ�ʿ� �������ִ� �÷��̾�

				-- 50% Ȯ���� �� ����
				if cPermileRate( 500 ) == 1
				then	-- ���� ��

					nTeamNo = KQ_TEAM_NO["KTN_RED"]

					if #TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TMEMBER_LIST"] >= nTeamMemberMaxNum
					then	-- ���� �� ��� �� Ȯ��
						if #TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TMEMBER_LIST"] < nTeamMemberMaxNum
						then	-- ��� �� ��� �� Ȯ��
							nTeamNo = KQ_TEAM_NO["KTN_BLUE"]
						end
					end
				else	-- ��� ��

					nTeamNo = KQ_TEAM_NO["KTN_BLUE"]

					if #TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TMEMBER_LIST"] >= nTeamMemberMaxNum
					then	-- ��� �� ��� �� Ȯ��
						if #TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TMEMBER_LIST"] < nTeamMemberMaxNum
						then	-- ���� �� ��� �� Ȯ��
							nTeamNo = KQ_TEAM_NO["KTN_RED"]
						end
					end
				end

				local nIndex = (#TeamInfo[nTeamNo]["TMEMBER_LIST"] + 1)	-- �� ��� ����Ʈ �ε���

				TeamInfo[nTeamNo]["TMEMBER_LIST"][nIndex] 	= KSMemory["PLAYER_LIST"][i]["PHND"]	-- �� ��� ����Ʈ
				KSMemory["PLAYER_LIST"][i]["PTEAM_NO"]		= nTeamNo								-- �÷��̾� �� ��ȣ

				if nIndex > 1
				then	-- ��Ƽ ����
					cPartyJoin( TeamInfo[nTeamNo]["TMEMBER_LIST"][1], TeamInfo[nTeamNo]["TMEMBER_LIST"][nIndex] )
				end

--				for j = 1, #KQ_TEAM[nTeamNo]["KT_UNIFORM"]
--				do		-- ������ ����
--					cViewSlotEquip( TeamInfo[nTeamNo]["TMEMBER_LIST"][nIndex], KQ_TEAM[nTeamNo]["KT_UNIFORM"][j] )
--				end
			end

		end


		-- ���� ������ �� ��ġ�� �̵�
		for i = 1, #KSMemory["PLAYER_LIST"]
		do
			nTeamNo = KSMemory["PLAYER_LIST"][i]["PTEAM_NO"]

			if nTeamNo ~= KQ_TEAM_NO["KTN_DEFAULT"]
			then	-- �� ��ȣ Ȯ��
				cLinkTo( KSMemory["PLAYER_LIST"][i]["PHND"], KSMemory["FIELD_NAME"], KQ_TEAM[nTeamNo]["KT_POINT_X"], KQ_TEAM[nTeamNo]["KT_POINT_Y"] )
			end
		end


		if #KQ_STEP >= (KSMemory["STEP_NO"] + 1)
		then	-- ���� �ܰ� Ȯ��

			-- �ܰ� ����
			KSMemory["STEP_NO"] 		= KSMemory["STEP_NO"] + 1									-- ���� �ܰ�
			KSMemory["STEP_NEXT_TIME"]	= nCurSec + KQ_STEP[KSMemory["STEP_NO"]]["KS_NEXT_TIME"]	-- ���� �ܰ� ���� �ð�


			local MsgIndex = KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"]	-- �޼��� ����

			if MsgIndex ~= nil
			then	-- �޼��� �ε��� Ȯ��

				local MsgData = KQ_MSG[MsgIndex]	--	�޼��� ����

				if MsgData ~= nil
				then	-- �޼��� ���� ����
					KSMemory["MSG_NO"] 			= 1									-- �޼��� �ܰ�
					KSMemory["MSG_NEXT_TIME"] 	= nCurSec + MsgData[1]["KM_TIME"]	-- �޼��� ��� �ð�
				end
			end
		end
	end


	-- �޽��� ���
	KF_MESSAGE( KSMemory, nCurSec )

	return true

end


------------------------------------------------------------------------------------------
--                                    ���� ���                                         --
------------------------------------------------------------------------------------------
function SF_START_WAIT( KSMemory, nCurSec )
cExecCheck "SF_START_WAIT"

	if KSMemory == nil
	then	-- ŷ�� ����Ʈ ���� Ȯ��
		return false
	end

	if nCurSec == nil
	then	-- �ð� Ȯ��
		return false
	end


	if KSMemory["STEP_NEXT_TIME"] <= nCurSec
	then	-- ���� �ܰ� ���� �ð� Ȯ��

		if KSMemory["FLAG_INFO"] == nil
		then	-- ��� ���� Ȯ��
			return false
		end


		cStartMsg_AllInMap( KSMemory["FIELD_NAME"] ) -- ŷ�� ���� ī��Ʈ �ٿ�


		-- ������ ���� ��ȯ
		for i = 1, #KQ_ITEM_MOB
		do
			KSMemory["MOB_LIST"][i] = {}
			KSMemory["MOB_LIST"][i]["MHND"] 		= cMobRegen_XY( KSMemory["FIELD_NAME"], KQ_ITEM_MOB[i]["KIM_INDEX"], KQ_ITEM_MOB[i]["KIM_X"], KQ_ITEM_MOB[i]["KIM_Y"], KQ_ITEM_MOB[i]["KIM_DIR"] )
			KSMemory["MOB_LIST"][i]["MREGEN_TIME"]	= 0
		end


		local nNextStep = KSMemory["STEP_NO"] + 1		-- ���� �ܰ�


		-- ��� ��ȯ
		KSMemory["FLAG_INFO"]["FHND"] 	= cMobRegen_XY( KSMemory["FIELD_NAME"], KQ_FLAG_POINT["KFP_INDEX"], KQ_FLAG_POINT["KFP_X"], KQ_FLAG_POINT["KFP_Y"], KQ_FLAG_POINT["KFP_DIR"] )
		if KSMemory["FLAG_INFO"]["FHND"] == nil then
			nNextStep = 10	-- SF_END_WAIT
		else

			KSMemory["FLAG_INFO"]["FINDEX"]	= KQ_FLAG_POINT["KFP_INDEX"]

			-- ��� ��� ��ũ��Ʈ ����
			cSetAIScript( KQ_SCRIPT_NAME, KSMemory["FLAG_INFO"]["FHND"] )
			cAIScriptFunc( KSMemory["FLAG_INFO"]["FHND"], "Entrance", "KF_FLGAG_OBJECT" )
		end

		if #KQ_STEP >= nNextStep
		then	-- ���� �ܰ� Ȯ��

			-- �ܰ� ����
			KSMemory["STEP_NO"] 		= nNextStep													-- ���� �ܰ�
			KSMemory["STEP_NEXT_TIME"]	= nCurSec + KQ_STEP[KSMemory["STEP_NO"]]["KS_NEXT_TIME"]	-- ���� �ܰ� ���� �ð�


			local MsgIndex = KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"]	-- �޼��� ����

			if MsgIndex ~= nil
			then	-- �޼��� �ε��� Ȯ��

				local MsgData = KQ_MSG[MsgIndex]	--	�޼��� ����

				if MsgData ~= nil
				then	-- �޼��� ���� ����
					KSMemory["MSG_NO"] 			= 1									-- �޼��� �ܰ�
					KSMemory["MSG_NEXT_TIME"] 	= nCurSec + MsgData[1]["KM_TIME"]	-- �޼��� ��� �ð�
				end
			end
		end
	end


	-- �޽��� ���
	KF_MESSAGE( KSMemory, nCurSec )

	return true

end


------------------------------------------------------------------------------------------
--                                       ����                                           --
------------------------------------------------------------------------------------------
function SF_START( KSMemory, nCurSec )
cExecCheck "SF_START"

	if KSMemory == nil
	then	-- ŷ�� ����Ʈ ���� Ȯ��
		return false
	end

	if nCurSec == nil
	then	-- �ð� Ȯ��
		return false
	end


	if KSMemory["STEP_NEXT_TIME"] <= nCurSec
	then	-- ���� �ܰ� ���� �ð� Ȯ��

		-- �� ����
		for i = 1, #KSMemory["DOOR_LIST"]
		do
			cDoorAction( KSMemory["DOOR_LIST"][i], KQ_DOOR[i]["KD_BLOCK"], "open" )
		end


		if #KQ_STEP >= (KSMemory["STEP_NO"] + 1)
		then	-- ���� �ܰ� Ȯ��

			-- �ܰ� ����
			KSMemory["STEP_NO"] 		= KSMemory["STEP_NO"] + 1									-- ���� �ܰ�
			KSMemory["STEP_NEXT_TIME"]	= nCurSec + KQ_STEP[KSMemory["STEP_NO"]]["KS_NEXT_TIME"]	-- ���� �ܰ� ���� �ð�


			-- Ÿ�̸� ǥ��
			cTimer( KSMemory["FIELD_NAME"], KQ_STEP[KSMemory["STEP_NO"]]["KS_NEXT_TIME"] )


			local MsgIndex = KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"]	-- �޼��� ����

			if MsgIndex ~= nil
			then	-- �޼��� �ε��� Ȯ��

				local MsgData = KQ_MSG[MsgIndex]	--	�޼��� ����

				if MsgData ~= nil
				then	-- �޼��� ���� ����
					KSMemory["MSG_NO"] 			= 1									-- �޼��� �ܰ�
					KSMemory["MSG_NEXT_TIME"] 	= nCurSec + MsgData[1]["KM_TIME"]	-- �޼��� ��� �ð�
				end
			end
		end
	end


	-- �޽��� ���
	KF_MESSAGE( KSMemory, nCurSec )

end


------------------------------------------------------------------------------------------
--                                       ����                                           --
------------------------------------------------------------------------------------------
function SF_ROUTINE( KSMemory, nCurSec )
cExecCheck "SF_ROUTINE"

	if KSMemory == nil
	then	-- ŷ�� ����Ʈ ���� Ȯ��
		return false
	end

	if nCurSec == nil
	then	-- �ð� Ȯ��
		return false
	end


	local TeamInfo = KSMemory["TEAM_LIST"]
	local FlagInfo = KSMemory["FLAG_INFO"]

	if TeamInfo == nil
	then
		return false
	end

	if FlagInfo == nil
	then
		return false
	end

	-- ��� ��� �ִ� �÷��̾� Ȯ��
	FLAG_PLAYER_CHECK( KSMemory, nCurSec )


	if FlagInfo["FREGEN_TIME"] ~= 0
	then	-- ��� ����Ʈ ���� ��� ��

		if nCurSec >= FlagInfo["FREGEN_TIME"]
		then	-- ��� ���� �ð� Ȯ��

			-- ��� ��ȯ
			FlagInfo["FHND"] = cMobRegen_XY( KSMemory["FIELD_NAME"], KQ_FLAG_POINT["KFP_INDEX"], KQ_FLAG_POINT["KFP_X"], KQ_FLAG_POINT["KFP_Y"], KQ_FLAG_POINT["KFP_DIR"] )

			if FlagInfo["FHND"] == nil then
				FlagInfo["FHND"] 			= KQ_INVALID_HANDLE
			else
				-- ��� ��� ��ũ��Ʈ ����
				cSetAIScript( KQ_SCRIPT_NAME, FlagInfo["FHND"] )
				cAIScriptFunc( FlagInfo["FHND"], "Entrance", "KF_FLGAG_OBJECT" )

				-- ��� ���� �ʱ�ȭ
				FlagInfo["FPHND"] 			= KQ_INVALID_HANDLE
				FlagInfo["FINDEX"]			= KQ_FLAG_POINT["KFP_INDEX"]
				FlagInfo["FPICK_TIME"]		= 0
				FlagInfo["FREGEN_TIME"]		= 0
				FlagInfo["FREGEN_X"] 		= KQ_FLAG_POINT["KFP_X"]
				FlagInfo["FREGEN_Y"] 		= KQ_FLAG_POINT["KFP_Y"]

				-- ��� ��ȯ �˸�
				cScriptMessage( KSMemory["FIELD_NAME"], KQ_FLAG_SCRIPT_MSG["KFSM_REGEN02"] )
			end
		end
	end


	if FlagInfo["FHND"]  == KQ_INVALID_HANDLE and	-- ��� �ڵ�
	   FlagInfo["FPHND"] == KQ_INVALID_HANDLE and	-- ��� ȹ�� �÷��̾� �ڵ�
	   FlagInfo["FREGEN_TIME"] == 0			-- ��� ���� Ÿ��
	then	-- ŷ�� ����Ʈ �ʿ� ����� ���������� Ȯ��
		FlagInfo["FREGEN_TIME"] = KQ_FLAG_POINT["KFP_REGEN_TIME"] + nCurSec
	end


	if KSMemory["WORK_TICK"] <= nCurSec
	then	-- ���� �ð����� ó���Ǵ� �۾�(1�ʿ� �ѹ�)

		if FlagInfo["FHND"]	 ~= KQ_INVALID_HANDLE 	or	-- ���
		   FlagInfo["FPHND"] ~= KQ_INVALID_HANDLE		-- ��� ȹ�� �÷��̾�
		then
			local MapMarkTable = {}
			local mmData = {}

			mmData["Group"]     = 0
			mmData["x"]         = FlagInfo["FREGEN_X"]
			mmData["y"]         = FlagInfo["FREGEN_Y"]
			mmData["KeepTime"]  = 1000
			mmData["IconIndex"] = KQ_FLAG_ICON

			MapMarkTable[mmData["Group"]] = mmData

			-- ��� ��ŷ ���� �˸�
			cMapMark( KSMemory["FIELD_NAME"], MapMarkTable )
		end

		-- ���� ���� �÷��̾� ŷ�� ����Ʈ�� ���� ���� Ȯ��
		local nLogOut_RedTeam	= 0		-- ���� �� �������� ���� ��� ��
		local nLogOut_BlueTeam	= 0		-- ��� �� �������� ���� ��� ��

		for i = 1, #KSMemory["PLAYER_LIST"]
		do
			if KSMemory["PLAYER_LIST"] [i]["PIS_MAP"] == true
			then	-- ŷ�� ����Ʈ�ʿ� �������ִ� �÷��̾�
				if cIsInMap( KSMemory["PLAYER_LIST"][i]["PHND"], KSMemory["FIELD_NAME"] ) == nil
				then	-- ŷ�� ����Ʈ�ʿ� �������ִ��� Ȯ��
					KSMemory["PLAYER_LIST"][i]["PIS_MAP"] = false
				end
			end

			if KSMemory["PLAYER_LIST"][i]["PIS_MAP"] == false
			then	-- ŷ�� ����Ʈ�ʿ� �������� ���� ����
				if KSMemory["PLAYER_LIST"][i]["PTEAM_NO"] == KQ_TEAM_NO["KTN_RED"]
				then
					nLogOut_RedTeam = nLogOut_RedTeam + 1
				elseif KSMemory["PLAYER_LIST"][i]["PTEAM_NO"] == KQ_TEAM_NO["KTN_BLUE"]
				then
					nLogOut_BlueTeam = nLogOut_BlueTeam + 1
				end
			end
		end

		if nLogOut_RedTeam  >= #TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TMEMBER_LIST"]		or	-- ���� ��
		   nLogOut_BlueTeam >= #TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TMEMBER_LIST"]		-- ��� ��
		then	-- ŷ�� ����Ʈ�ʿ� �������� ���� ��� �� Ȯ��
			TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TSCORE"]	= 0
			TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TSCORE"]	= 0

			KSMemory["GAME_TYPE"] 		= KQ_GAME_TYEP["KGT_EXTRATIME"]
			KSMemory["STEP_NEXT_TIME"]	= 0
		end


		-- ���� Ȯ��( ������ ���� )
		for i = 1, #KSMemory["MOB_LIST"]
		do
			if cIsObjectDead( KSMemory["MOB_LIST"][i]["MHND"] ) ~= nil
			then	-- ���� �׾����� Ȯ��

				if KSMemory["MOB_LIST"][i]["MREGEN_TIME"] == 0
				then	-- ���� �ð� ����
					KSMemory["MOB_LIST"][i]["MREGEN_TIME"] = KQ_ITEM_MOB[i]["KIM_REGEN_TICK"] + nCurSec
				else 	-- ���� �ð� Ȯ��
					if KSMemory["MOB_LIST"][i]["MREGEN_TIME"] <= nCurSec
					then	-- ���� ����
						KSMemory["MOB_LIST"][i]["KSMM_HND"]		= cMobRegen_XY( KSMemory["FIELD_NAME"], KQ_ITEM_MOB[i]["KIM_INDEX"], KQ_ITEM_MOB[i]["KIM_X"],
																				KQ_ITEM_MOB[i]["KIM_Y"], KQ_ITEM_MOB[i]["KIM_DIR"] )
						KSMemory["MOB_LIST"][i]["MREGEN_TIME"]	= 0
					end
				end
			end
		end


		-- ���� �ð� ����
		KSMemory["WORK_TICK"] = nCurSec + 1

	end


	if KSMemory["STEP_NEXT_TIME"] <= nCurSec
	then	-- ���� �ܰ� ���� �ð� Ȯ��

		if FlagInfo["FPHND"] ~= KQ_INVALID_HANDLE
		then	-- ��� �����̻� ����
			for k = 1, #KQ_FLAG_ABSTATE
			do
				cResetAbstate( FlagInfo["FPHND"], KQ_FLAG_ABSTATE[k]["KFA_INDEX"] )
			end
		end

		if FlagInfo["FHND"] ~= KQ_INVALID_HANDLE
		then	-- ��� ������Ʈ ����
			cNPCVanish( FlagInfo["FHND"] )
		end

		-- ��� ���� �ʱ�ȭ
		FlagInfo["FHND"]			= KQ_INVALID_HANDLE
		FlagInfo["FPHND"] 			= KQ_INVALID_HANDLE
		FlagInfo["FINDEX"]			= ""
		FlagInfo["FPICK_TIME"]		= 0
		FlagInfo["FREGEN_TIME"] 	= 0
		FlagInfo["FREGEN_X"] 		= KQ_FLAG_POINT["KFP_X"]
		FlagInfo["FREGEN_Y"] 		= KQ_FLAG_POINT["KFP_Y"]


		-- ���� ����( ������ ���� )
		for i = 1, #KSMemory["MOB_LIST"]
		do
			cNPCVanish( KSMemory["MOB_LIST"][i]["MHND"] )
			KSMemory["MOB_LIST"][i] = nil
		end


		-- ���� ���� ����Ʈ ����
		for i = 1, #TeamInfo
		do
			if TeamInfo[i]["TPOINT_HND"] ~= KQ_INVALID_HANDLE
			then	-- ���� ����Ʈ �ڵ� Ȯ��
				cNPCVanish( TeamInfo[i]["TPOINT_HND"] )
				TeamInfo[i]["TPOINT_HND"] = KQ_INVALID_HANDLE
			end
		end


		cTimer( KSMemory["FIELD_NAME"], 0 )


		local nNextStep = 10						-- SF_END_WAIT
		if KSMemory["GAME_TYPE"] == KQ_GAME_TYEP["KGT_NORMAL"] 										and -- �Ϲ� ���
		   TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TSCORE"] == TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TSCORE"]		-- ���º�
		then
			nNextStep = KSMemory["STEP_NO"] + 1		-- SF_EXTRATIME_INIT
		else
			for i = 1, #KSMemory["PLAYER_LIST"]
			do
				cSetAbstate( KSMemory["PLAYER_LIST"][i]["PHND"], KQ_STUN_ABSTATE["KSA_INDEX"], KQ_STUN_ABSTATE["KSA_STR"], KQ_STUN_ABSTATE["KSA_KEEPTIME"] )
			end
		end


		if KSMemory["STEP_NEXT_TIME"] ~= 0
		then
			cScriptMessage( KSMemory["FIELD_NAME"], KQ_MSG["KM_GAME_TIME"][1]["KM_INDEX"] )
		end


		if #KQ_STEP >= nNextStep
		then	-- ���� �ܰ� Ȯ��

			-- �ܰ� ����
			KSMemory["STEP_NO"] 		= nNextStep													-- ���� �ܰ�
			KSMemory["STEP_NEXT_TIME"]	= nCurSec + KQ_STEP[KSMemory["STEP_NO"]]["KS_NEXT_TIME"]	-- ���� �ܰ� ���� �ð�


			local MsgIndex = KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"]	-- �޼��� ����

			if MsgIndex ~= nil
			then	-- �޼��� �ε��� Ȯ��

				local MsgData = KQ_MSG[MsgIndex]	--	�޼��� ����

				if MsgData ~= nil
				then	-- �޼��� ���� ����
					KSMemory["MSG_NO"] 			= 1									-- �޼��� �ܰ�
					KSMemory["MSG_NEXT_TIME"] 	= nCurSec + MsgData[1]["KM_TIME"]	-- �޼��� ��� �ð�
				end
			end
		end
	end


	-- �޽��� ���
	KF_MESSAGE( KSMemory, nCurSec )

	return true

end

------------------------------------------------------------------------------------------
--                             ������ ������ ���� �ʱ�ȭ                                --
------------------------------------------------------------------------------------------
function SF_EXTRATIME_INIT( KSMemory, nCurSec )
cExecCheck "SF_EXTRATIME_INIT"

	if KSMemory == nil
	then	-- ŷ�� ����Ʈ ���� Ȯ��
		return false
	end

	if nCurSec == nil
	then	-- �ð� Ȯ��
		return false
	end


	if KSMemory["STEP_NEXT_TIME"] <= nCurSec
	then	-- ���� �ܰ� ���� �ð� Ȯ��

		-- �� �ݱ�
		for i = 1, #KSMemory["DOOR_LIST"]
		do
			cDoorAction( KSMemory["DOOR_LIST"][i], KQ_DOOR[i]["KD_BLOCK"], "close" )
		end

		-- ����ġ�� �̵�
		for i = 1, #KSMemory["PLAYER_LIST"]
		do
			local nTeamNo = KSMemory["PLAYER_LIST"][i]["PTEAM_NO"]	-- �� ��ȣ

			if KSMemory["PLAYER_LIST"][i]["PIS_MAP"] == true
			then	-- ŷ�� ����Ʈ�ʿ� �������ִ��� Ȯ��
				cLinkTo( KSMemory["PLAYER_LIST"][i]["PHND"], KSMemory["FIELD_NAME"], KQ_TEAM[nTeamNo]["KT_POINT_X"], KQ_TEAM[nTeamNo]["KT_POINT_Y"] )
			end
		end


		-- ������ ����
		KSMemory["GAME_TYPE"] = KQ_GAME_TYEP["KGT_EXTRATIME"]


		if #KQ_STEP >= (KSMemory["STEP_NO"] + 1)
		then	-- ���� �ܰ� Ȯ��

			-- �ܰ� ����
			KSMemory["STEP_NO"] 		= KSMemory["STEP_NO"] + 1									-- ���� �ܰ�
			KSMemory["STEP_NEXT_TIME"]	= nCurSec + KQ_STEP[KSMemory["STEP_NO"]]["KS_NEXT_TIME"]	-- ���� �ܰ� ���� �ð�


			local MsgIndex = KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"]	-- �޼��� ����

			if MsgIndex ~= nil
			then	-- �޼��� �ε��� Ȯ��

				local MsgData = KQ_MSG[MsgIndex]	--	�޼��� ����

				if MsgData ~= nil
				then	-- �޼��� ���� ����
					KSMemory["MSG_NO"] 			= 1									-- �޼��� �ܰ�
					KSMemory["MSG_NEXT_TIME"] 	= nCurSec + MsgData[1]["KM_TIME"]	-- �޼��� ��� �ð�
				end
			end
		end
	end


	-- �޽��� ���
	KF_MESSAGE( KSMemory, nCurSec )

	return true

end


------------------------------------------------------------------------------------------
--                                  ���� �� ���                                        --
------------------------------------------------------------------------------------------
function SF_END_WAIT( KSMemory, nCurSec )
cExecCheck "SF_END_WAIT"

	if KSMemory == nil
	then	-- ŷ�� ����Ʈ ���� Ȯ��
		return false
	end

	if nCurSec == nil
	then	-- �ð� Ȯ��
		return false
	end


	if KSMemory["STEP_NEXT_TIME"] <= nCurSec
	then	-- ���� �ܰ� ���� �ð� Ȯ��

		local TeamInfo			= KSMemory["TEAM_LIST"]	-- �� ����
		local RedTeamResult		= nil					-- ���� �� ���	����
		local BlueTeamResult	= nil					-- ��� �� ���	����
		local PlayerReward 		= nil					-- �÷��̾� ��� ����

		if TeamInfo == nil
		then	-- �� ���� Ȯ��
			return false
		end

		if TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TSCORE"] == TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TSCORE"]
		then	-- ���º�
			RedTeamResult 	= KQ_RESULT["KR_DRAW"]
			BlueTeamResult	= KQ_RESULT["KR_DRAW"]
		elseif TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TSCORE"] > TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TSCORE"]
		then	-- ������ �¸�
			RedTeamResult 	= KQ_RESULT["KR_WIN"]
			BlueTeamResult	= KQ_RESULT["KR_LOSE"]
		else	-- ����� �¸�
			RedTeamResult 	= KQ_RESULT["KR_LOSE"]
			BlueTeamResult	= KQ_RESULT["KR_WIN"]
		end


		-- ���� ��� ó��
		for i = 1, #KSMemory["PLAYER_LIST"]
		do
			if KSMemory["PLAYER_LIST"][i]["PIS_MAP"] == true
			then	-- ŷ�� ����Ʈ�ʿ� �������ִ��� Ȯ��

				if KSMemory["PLAYER_LIST"][i]["PTEAM_NO"] == KQ_TEAM_NO["KTN_RED"]
				then	-- ���� ��
					PlayerReward = RedTeamResult
				elseif KSMemory["PLAYER_LIST"][i]["PTEAM_NO"] == KQ_TEAM_NO["KTN_BLUE"]
				then	-- ��� ��
					PlayerReward = BlueTeamResult
				end

				cPartyLeave( KSMemory["PLAYER_LIST"][i]["PHND"] )										-- ��Ƽ ����
				cViewSlotUnEquipAll( KSMemory["PLAYER_LIST"][i]["PHND"] )								-- �ڽ�Ƭ ����
				cResetAbstate( KSMemory["PLAYER_LIST"][i]["PHND"], KQ_MAPLOGIN_ABSTATE["KMA_INDEX"] )	-- �̵� �ӵ� ���� �����̻� ����
				cKQRewardIndex( KSMemory["PLAYER_LIST"][i]["PHND"], PlayerReward["KRE_REWAED"] )		-- ����
				cEffectMsg( KSMemory["PLAYER_LIST"][i]["PHND"], PlayerReward["KRE_EFFECT_MSG"] )		-- ����Ʈ �޼���
				cEmoticon( KSMemory["PLAYER_LIST"][i]["PHND"], PlayerReward["KRE_EMOTICON"] )			-- �̸��
			end

			-- �� ��ȣ �ʱ�ȭ
			KSMemory["PLAYER_LIST"][i]["PTEAM_NO"] = KQ_TEAM_NO["KTN_DEFAULT"]
		end

		-- �� ���� �ʱ�ȭ
		for i = 1, #KSMemory["TEAM_LIST"]
		do
			KSMemory["TEAM_LIST"][i]["TSCORE"] 			= 0
			KSMemory["TEAM_LIST"][i]["TPOINT_HND"] 		= KQ_INVALID_HANDLE
			KSMemory["TEAM_LIST"][i]["TMEMBER_LIST"] 	= nil
			KSMemory["TEAM_LIST"][i]["TMEMBER_LIST"]	= {}
		end


		-- Ÿ�̸� �ʱ�ȭ
		cTimer( KSMemory["FIELD_NAME"], 0 )


		if #KQ_STEP >= (KSMemory["STEP_NO"] + 1)
		then	-- ���� �ܰ� Ȯ��

			-- �ܰ� ����
			KSMemory["STEP_NO"] 		= KSMemory["STEP_NO"] + 1									-- ���� �ܰ�
			KSMemory["STEP_NEXT_TIME"]	= nCurSec + KQ_STEP[KSMemory["STEP_NO"]]["KS_NEXT_TIME"]	-- ���� �ܰ� ���� �ð�


			local MsgIndex = KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"]	-- �޼��� ����

			if MsgIndex ~= nil
			then	-- �޼��� �ε��� Ȯ��

				local MsgData = KQ_MSG[MsgIndex]	--	�޼��� ����

				if MsgData ~= nil
				then	-- �޼��� ���� ����
					KSMemory["MSG_NO"] 			= 1									-- �޼��� �ܰ�
					KSMemory["MSG_NEXT_TIME"] 	= nCurSec + MsgData[1]["KM_TIME"]	-- �޼��� ��� �ð�
				end
			end
		end
	end


	-- �޽��� ���
	KF_MESSAGE( KSMemory, nCurSec )

end


------------------------------------------------------------------------------------------
--                                    ���� ��                                           --
------------------------------------------------------------------------------------------
function SF_END( KSMemory, nCurSec )
cExecCheck "SF_END"

	if KSMemory == nil
	then	-- ŷ�� ����Ʈ ���� Ȯ��
		return false
	end

	if nCurSec == nil
	then	-- �ð� Ȯ��
		return false
	end


	if KSMemory["STEP_NEXT_TIME"] <= nCurSec
	then	-- ���� �ܰ� ���� �ð� Ȯ��

		-- ������ �̵�
		cLinkToAll( KSMemory["FIELD_NAME"], KQ_RETURN_MAP["KRM_INDEX"], KQ_RETURN_MAP["KRM_X"], KQ_RETURN_MAP["KRM_Y"] )

		-- ŷ�� ����Ʈ ����
		cEndOfKingdomQuest( KSMemory["FIELD_NAME"] )


		-- ���� �ܰ� ����
		KSMemory["STEP_NO"] 		= nil
		KSMemory["STEP_NEXT_TIME"]	= nil
		return true
	end


	-- �޽��� ���
	KF_MESSAGE( KSMemory, nCurSec )

	return true

end


------------------------------------------------------------------------------------------
--                               �÷��̾� ��� Ȯ��                                     --
------------------------------------------------------------------------------------------
function FLAG_PLAYER_CHECK( KSMemory, nCurSec )
cExecCheck "FLAG_PLAYER_CHECK"

	if KSMemory == nil
	then	-- ŷ�� ����Ʈ ���� Ȯ��
		return false
	end

	if nCurSec == nil
	then	-- �ð� Ȯ��
		return false
	end


	local TeamInfo = KSMemory["TEAM_LIST"]
	local FlagInfo = KSMemory["FLAG_INFO"]

	if TeamInfo == nil
	then	-- �� ���� Ȯ��
		return
	end

	if FlagInfo == nil
	then	-- ��� ���� Ȯ��
		return
	end

	if FlagInfo["FREGEN_TIME"] ~= 0
	then	-- ��� ���� Ÿ�� Ȯ��
		return
	end

	if FlagInfo["FPHND"] == KQ_INVALID_HANDLE
	then	-- ��� ȹ�� �÷��̾� Ȯ��
		return
	end


	local PlayerInfo	= nil						-- �÷��̾� ����
	local PlayerMaxNum	= #KSMemory["PLAYER_LIST"]	-- ���� ���� �÷��̾� ��

	-- ��� ȹ�� �÷��̾� ã��
	for i = 1, PlayerMaxNum
	do
		if FlagInfo["FPHND"] == KSMemory["PLAYER_LIST"][i]["PHND"]
		then
			PlayerInfo = KSMemory["PLAYER_LIST"][i]
		end
	end

	if PlayerInfo == nil
	then	-- �÷��̾� ���� Ȯ��
		return
	end


	if cIsInMap( PlayerInfo["PHND"], KSMemory["FIELD_NAME"] ) == nil
	then	--  ŷ�� ����Ʈ�ʿ� ���������� ���� ���

		-- ������ ��ġ�� ��� ��ȯ
		FlagInfo["FHND"] = cMobRegen_XY( KSMemory["FIELD_NAME"], KQ_FLAG["KF_INDEX"], FlagInfo["FREGEN_X"], FlagInfo["FREGEN_Y"], 0 )

		if FlagInfo["FHND"] == nil then
			FlagInfo["FHND"] 			= KQ_INVALID_HANDLE
		else
			-- ��� ��� ��ũ��Ʈ ����
			cSetAIScript( KQ_SCRIPT_NAME, FlagInfo["FHND"] )
			cAIScriptFunc( FlagInfo["FHND"], "Entrance", "KF_FLGAG_OBJECT" )

			-- ��� ��� �˸�
			cScriptMessage( KSMemory["FIELD_NAME"], KQ_FLAG_SCRIPT_MSG["KFSM_DROP"], PlayerInfo["PNAME"] )

			-- ��� ���� ����
			FlagInfo["FPHND"] 			= KQ_INVALID_HANDLE
			FlagInfo["FINDEX"]			= KQ_FLAG["KF_INDEX"]
			FlagInfo["FPICK_TIME"]		= nCurSec + KQ_FLAG["KF_PICK_DELAY"]
			FlagInfo["FREGEN_TIME"] 	= 0

			-- ���� ����Ʈ ����
			if TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] ~= KQ_INVALID_HANDLE
			then
				cNPCVanish( TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] )
				TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] = KQ_INVALID_HANDLE
			end
		end
	else

		-- ��� �����̻� ���ӽð�
		local RestTime = cAbstateRestTime( PlayerInfo["PHND"], KQ_FLAG_ABSTATE[1]["KFA_INDEX"] )

		if RestTime == nil
		then -- ��� �����̻� ���ӽð� Ȯ��

			-- ��� ȭ��ǥ �����̻� ����
			cResetAbstate( FlagInfo["FPHND"], KQ_FLAG_ABSTATE[2]["KFA_INDEX"] )

			-- ��� ��ȯ
			FlagInfo["FHND"] = cMobRegen_Obj( KQ_FLAG["KF_INDEX"], PlayerInfo["PHND"] )

			if FlagInfo["FHND"] == nil then
				FlagInfo["FHND"] 			= KQ_INVALID_HANDLE
			else
				-- ��� ��� ��ũ��Ʈ ����
				cSetAIScript( KQ_SCRIPT_NAME, FlagInfo["FHND"] )
				cAIScriptFunc( FlagInfo["FHND"], "Entrance", "KF_FLGAG_OBJECT" )

				-- ��� ��� �˸�
				cScriptMessage( KSMemory["FIELD_NAME"], KQ_FLAG_SCRIPT_MSG["KFSM_DROP"], PlayerInfo["PNAME"] )

				-- ��� ���� ����
				FlagInfo["FPHND"] 			= KQ_INVALID_HANDLE
				FlagInfo["FINDEX"]			= KQ_FLAG["KF_INDEX"]
				FlagInfo["FPICK_TIME"]		= nCurSec + KQ_FLAG["KF_PICK_DELAY"]
				FlagInfo["FREGEN_TIME"] 	= 0

				-- ��� ��ġ ����
				FlagInfo["FREGEN_X"], FlagInfo["FREGEN_Y"] = cObjectLocate( PlayerInfo["PHND"] )

				if FlagInfo["FREGEN_X"] == nil or FlagInfo["FREGEN_Y"] == nil
				then	-- �÷��̾� ��ġ ���� Ȯ��
					FlagInfo["FREGEN_X"] = KQ_FLAG_POINT["KFP_X"]
					FlagInfo["FREGEN_X"] = KQ_FLAG_POINT["KFP_Y"]
				end

				-- ���� ����Ʈ ����
				if TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] ~= KQ_INVALID_HANDLE
				then
					cNPCVanish( TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] )
					TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] = KQ_INVALID_HANDLE
				end
			end
		else
			if TeamInfo[PlayerInfo["PTEAM_NO"]] ~= nil
			then	-- �÷��̾� ���� Ȯ��

				-- �÷��̾� ��ġ
				FlagInfo["FREGEN_X"], FlagInfo["FREGEN_Y"] = cObjectLocate( PlayerInfo["PHND"] )

				if FlagInfo["FREGEN_X"] == nil or FlagInfo["FREGEN_Y"] == nil
				then	-- �÷��̾� ��ġ ���� Ȯ��
					FlagInfo["FREGEN_X"] = KQ_FLAG_POINT["KFP_X"]
					FlagInfo["FREGEN_X"] = KQ_FLAG_POINT["KFP_Y"]
				end


				-- ���ھ� ����Ʈ �Ÿ�
				local Dist 		= cDistanceSquar( KQ_TEAM[PlayerInfo["PTEAM_NO"]]["KT_POINT_X"], KQ_TEAM[PlayerInfo["PTEAM_NO"]]["KT_POINT_Y"], FlagInfo["FREGEN_X"], FlagInfo["FREGEN_Y"] )
				local CheckDist	= ( KQ_TEAM_POINT_CHECK_DIST * KQ_TEAM_POINT_CHECK_DIST )

				if  Dist <= CheckDist
				then	-- ���ھ� ����Ʈ �Ÿ� Ȯ��

					-- ��� ����
					for k = 1, #KQ_FLAG_ABSTATE
					do
						cResetAbstate( PlayerInfo["PHND"], KQ_FLAG_ABSTATE[k]["KFA_INDEX"] )
					end

					-- ��� ���� �ʱ�ȭ �� ���� �ð� ����
					FlagInfo["FHND"]			= KQ_INVALID_HANDLE
					FlagInfo["FPHND"] 			= KQ_INVALID_HANDLE
					FlagInfo["FINDEX"]			= ""
					FlagInfo["FPICK_TIME"]		= 0
					FlagInfo["FREGEN_TIME"] 	= nCurSec + KQ_FLAG_POINT["KFP_REGEN_TIME"]
					FlagInfo["FREGEN_X"] 		= KQ_FLAG_POINT["KFP_X"]
					FlagInfo["FREGEN_Y"] 		= KQ_FLAG_POINT["KFP_Y"]

					-- ����
					TeamInfo[PlayerInfo["PTEAM_NO"]]["TSCORE"] = TeamInfo[PlayerInfo["PTEAM_NO"]]["TSCORE"] + 1

					-- �� ���� �˸�
					cScoreInfo_AllInMap( KSMemory["FIELD_NAME"],  #KQ_TEAM , TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TSCORE"],
																			 TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TSCORE"] )

					-- ���� ����Ʈ ����
					if TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] ~= KQ_INVALID_HANDLE
					then
						cNPCVanish( TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] )
						TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] = KQ_INVALID_HANDLE
					end

					-- ���������� ������, �ٷ� ��� ����
					if KSMemory["GAME_TYPE"] == KQ_GAME_TYEP["KGT_EXTRATIME"]
					then
						KSMemory["STEP_NEXT_TIME"] = 0
					else
						-- ���� �˸�
						if PlayerInfo["PTEAM_NO"] == KQ_TEAM_NO["KTN_RED"]
						then	-- ���� ��
							cScriptMessage( KSMemory["FIELD_NAME"], KQ_FLAG_SCRIPT_MSG["KFSM_POINT_RED"], PlayerInfo["PNAME"] )
						elseif PlayerInfo["PTEAM_NO"] == KQ_TEAM_NO["KTN_BLUE"]
						then	-- ��� ��
							cScriptMessage( KSMemory["FIELD_NAME"], KQ_FLAG_SCRIPT_MSG["KFSM_POINT_BLUE"], PlayerInfo["PNAME"] )
						end

						-- ��,���� ����
						for i = 1, #KSMemory["PLAYER_LIST"]
						do
							if KSMemory["PLAYER_LIST"][i]["PTEAM_NO"] == PlayerInfo["PTEAM_NO"]
							then
								cPlaySound( KSMemory["PLAYER_LIST"][i]["PHND"], KQ_SOUND["KS_GETPOINT"] );
							else
								cPlaySound( KSMemory["PLAYER_LIST"][i]["PHND"], KQ_SOUND["KS_LOSEPOINT"] );
							end
						end

						-- ��� ���� ���� �޼��� �˸�
						cScriptMessage( KSMemory["FIELD_NAME"], KQ_FLAG_SCRIPT_MSG["KFSM_REGEN01"] )
					end

				end
			end
		end
	end

end


-- ŷ�� ����Ʈ �ܰ躰 ������
KQ_STEP =
{
  --------------------------------------------------------------------------------------------
  --  ���� �Լ�,							���� ���� �ð�,		�޽��� ������( KDSpring_Data )
  --------------------------------------------------------------------------------------------
	{ KS_FUNC = SF_DIVIDE_TEAM_WAIT,	KS_TIMER = false,	KS_LINKTO_TEAM = false,	KS_NEXT_TIME = 30, 	KS_MSG = nil 					},		-- 1	�� ������ ���
	{ KS_FUNC = SF_DIVIDE_TEAM, 		KS_TIMER = false,	KS_LINKTO_TEAM = false,	KS_NEXT_TIME = 5, 	KS_MSG = "KM_DIVIDE_TEAM"		},		-- 2	�� ������
	{ KS_FUNC = SF_START_WAIT, 			KS_TIMER = false,	KS_LINKTO_TEAM = true,	KS_NEXT_TIME = 55, 	KS_MSG = "KM_START_WAIT" 		},		-- 3	���� ���� ���
	{ KS_FUNC = SF_START, 				KS_TIMER = false,	KS_LINKTO_TEAM = true,	KS_NEXT_TIME = 5, 	KS_MSG = nil					},		-- 4	���� ����
	{ KS_FUNC = SF_ROUTINE, 			KS_TIMER = true,	KS_LINKTO_TEAM = true,	KS_NEXT_TIME = 600, KS_MSG = nil					},		-- 5	���� ����

	-- ������
	{ KS_FUNC = SF_EXTRATIME_INIT, 		KS_TIMER = false,	KS_LINKTO_TEAM = true,	KS_NEXT_TIME = 10, 	KS_MSG = "KM_EXTRA_TIME_WAIT"	},		-- 6	������ ������ ���� �ʱ�ȭ
	{ KS_FUNC = SF_START_WAIT, 			KS_TIMER = false,	KS_LINKTO_TEAM = true,	KS_NEXT_TIME = 10,	KS_MSG = nil					},		-- 7	������ ���� ���� ���
	{ KS_FUNC = SF_START, 				KS_TIMER = false,	KS_LINKTO_TEAM = true,	KS_NEXT_TIME = 5, 	KS_MSG = nil					},		-- 8	������ ���� ����
	{ KS_FUNC = SF_ROUTINE, 			KS_TIMER = true,	KS_LINKTO_TEAM = true,	KS_NEXT_TIME = 180,	KS_MSG = nil					},		-- 9	������ ���� ����
	{ KS_FUNC = SF_END_WAIT, 			KS_TIMER = false,	KS_LINKTO_TEAM = false,	KS_NEXT_TIME = 2, 	KS_MSG = nil					},		-- 10	���� ���� ���
	{ KS_FUNC = SF_END,					KS_TIMER = false,	KS_LINKTO_TEAM = false,	KS_NEXT_TIME = 60, 	KS_MSG = "KM_END"				},		-- 11	���� ����
}
