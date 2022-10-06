
function PetBaseExecIdleAction( PetMem, nStepOffset, tStepInfo, nRunSpeedRate )
	cExecCheck( "PetBaseExecIdleAction" )

	if PetMem == nil
	then
		ErrorLog( "PetBaseExecIdleAction::PetMem is nil" )
		return false
	end

	if type( nStepOffset ) ~= "number"
	then
		ErrorLog( "PetBaseExecIdleAction::nStepOffset is not number" )
		return false
	end

	if type( tStepInfo ) ~= "table"
	then
		ErrorLog( "PetBaseExecIdleAction::tStepInfo is not table" )
		return false
	end

	if type( nRunSpeedRate ) ~= "number"
	then
		ErrorLog( "PetBaseExecIdleAction::nRunSpeedRate is not number" )
		return false
	end

	local nHandle		= PetMem["nHandle"]
	local tPetCoord 	= PetMem["PetInfo"]["Coord"]["Cur"]
	local tCenterCoord 	= PetMem["PetInfo"]["Coord"]["Center"]
	local tStepHeader 	= PetSystem_tIdleActionData["tHeader"]

	-- �ش� �ܰ谡 ��ȿ�ϸ� ����
	if PetMem["PetInfo"]["nIdleStep"] - nStepOffset <= #tStepInfo
	then
		local tCurStep = tStepInfo[ PetMem["PetInfo"]["nIdleStep"] - nStepOffset ]

		local nStepType 		= tCurStep[ tStepHeader["nStepType"] ]
		local nNextStepCondType = tCurStep[ tStepHeader["nNextStepCondType"] ]

		-- �� ���� Ÿ�Ժ� �ൿ ( �� �ܰ�� 1ȸ�� �����Ѵ� )
		if PetMem["PetInfo"]["bCurIdleStepActionDone"] ~= true
		then
			if nStepType == PISAT_MOVE	-----------------------------------------------------------------------------------------------------------PISAT_MOVE
			then
				local nTargetX = tCurStep[ tStepHeader["nX"] ] + tCenterCoord["x"]
				local nTargetY = tCurStep[ tStepHeader["nY"] ] + tCenterCoord["y"]

				cRunTo( nHandle, nTargetX, nTargetY, nRunSpeedRate )
				PetMem["PetInfo"]["Coord"]["Next"]["x"] = nTargetX
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = nTargetY
				PetMem["PetInfo"]["bCurIdleStepActionDone"] = true

				CheckLog( "PetBaseExecIdleAction::nStepType == PISAT_MOVE" )
				DebugLog( "PetBaseExecIdleAction::nStepType == PISAT_MOVE" )

			elseif nStepType == PISAT_ROTATION	-----------------------------------------------------------------------------------------------------------PISAT_ROTATION
			then
				local nCurDirect = cGetDirect( nHandle );
				if nCurDirect ~= nil
				then
					local nDirect360 = tCurStep[ tStepHeader["nDir"] ] + nCurDirect

					-- 0~359 ���߱�
					if nDirect360 >= 360
					then
						nDirect360 = nDirect360 - 360
					end

					if nDirect360 < 0
					then
						nDirect360 = nDirect360 + 360
					end

					-- 0~179 ���߱�
					local nDirect180 = nDirect360 / 2

					cSetObjectDirect( nHandle, nDirect180 )

				end

				PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
				PetMem["PetInfo"]["bCurIdleStepActionDone"] = true

				CheckLog( "PetBaseExecIdleAction::nStepType == PISAT_ROTATION" )
				DebugLog( "PetBaseExecIdleAction::nStepType == PISAT_ROTATION" )

			elseif nStepType == PISAT_ATTACK	-----------------------------------------------------------------------------------------------------------PISAT_ATTACK
			then
				-- �ִϸ��̼��� �� �������� �ٸ� ���� ����ؾ��ϴ� ������ �־ �̺�Ʈ �ڵ带 ���� ����ϱ�� ��
				if cActByEventCode( nHandle, PetSystem_ActionEventCode["Attack"] ) == nil
				then
					ErrorLog( "cActByEventCode failed ["..nHandle.."]'s Attack" )
				end
				PetMem["PetInfo"]["bCurIdleStepActionDone"] = true

				CheckLog( "PetBaseExecIdleAction::nStepType == PISAT_ATTACK" )
				DebugLog( "PetBaseExecIdleAction::nStepType == PISAT_ATTACK" )

			elseif nStepType == PISAT_DANCE
			then
				if cActByEventCode( nHandle, PetSystem_ActionEventCode["Dance"] ) == nil
				then
					ErrorLog( "cActByEventCode failed ["..nHandle.."]'s Dance" )
				end
				PetMem["PetInfo"]["bCurIdleStepActionDone"] = true

			else
				-- �߸��� ��� : ������ ���� ��û
				ErrorLog( "PetBaseExecIdleAction::Please Check PetBaseActionData : nStepType Column" )
			end
		end

		-- �� ���� ���� ���Ǻ� �ൿ
		if nNextStepCondType == PNIST_DISTANCE	-----------------------------------------------------------------------------------------------------------PNIST_DISTANCE
		then
			local nDistanceSquare = cDistanceSquar( tPetCoord["x"], tPetCoord["y"], PetMem["PetInfo"]["Coord"]["Next"]["x"], PetMem["PetInfo"]["Coord"]["Next"]["y"] )
			local nDistanceCond = tCurStep[ tStepHeader["nNextStepDistance"] ]
			local nDistanceSquareCond = GetSquare( nDistanceCond )

			-- �������� ������ �Ÿ� ������ ������ ���� ��������
			if ( nDistanceSquare <= nDistanceSquareCond )
			then
				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleStep"] + 1
				if PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"]
				then
					PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleStep"] - #tStepInfo
				end

				PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
				PetMem["PetInfo"]["bCurIdleStepActionDone"] = false
			end

			DebugLog( "PetBaseExecIdleAction::nNextStepCondType == PNIST_DISTANCE" )

		elseif nNextStepCondType == PNIST_TIME	-----------------------------------------------------------------------------------------------------------PNIST_TIME
		then
			local nTimeCond = tCurStep[ tStepHeader["dNextStepTime"] ]

			-- �� ���� ù ���Խ� �������� �ð� ����
			if PetMem["PetInfo"]["dNextIdleStepTime"] == PetMem["InitialSec"]
			then
				PetMem["PetInfo"]["dNextIdleStepTime"] = PetMem["CurSec"] + nTimeCond
			end

			-- �ð� �Ǹ� ���� ��������
			if PetMem["PetInfo"]["dNextIdleStepTime"] < PetMem["CurSec"]
			then
				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleStep"] + 1
				if PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"]
				then
					PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleStep"] - #tStepInfo
				end

				PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
				PetMem["PetInfo"]["bCurIdleStepActionDone"] = false

				-- üũ �ð� �ʱ�ȭ
				PetMem["PetInfo"]["dNextIdleStepTime"] = PetMem["InitialSec"]
			end

			DebugLog( "PetBaseExecIdleAction::nNextStepCondType == PNIST_TIME" )

		elseif nNextStepCondType == PNIST_END -- ���� ����-----------------------------------------------------------------------------------------------------------PNIST_END
		then
			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			DebugLog( "PetBaseExecIdleAction::nNextStepCondType == PNIST_END" )

		else
			-- �߸��� ���� : ������ ���� ��û
			ErrorLog( "PetBaseExecIdleAction::Please Check PetBaseActionData : nNextStepCondType Column" )
		end

		return true

	else
		ErrorLog( "PetBaseExecIdleAction::PetMem[\"PetInfo\"][\"nIdleStep\"] is too big" )
		return false

	end
end



function PetBaseIdleAction( PetMem, tPetIdleActRecord )
	cExecCheck( "PetBaseIdleAction" )

	if PetMem == nil
	then
		DebugLog( "PetBaseIdleAction::PetMem is nil" )
		return false
	end

	local nHandle 			= PetMem["PetInfo"]["nHandle"]
	local nMasterHandle		= PetMem["MasterInfo"]["nHandle"]
	local tPetCoord 		= PetMem["PetInfo"]["Coord"]["Cur"]
	local tMasterCoord 		= PetMem["MasterInfo"]["Coord"]["Cur"]
	local tMasterLastCoord 	= PetMem["MasterInfo"]["Coord"]["Last"]

	if tPetIdleActRecord == nil
	then
		ErrorLog( "PetBaseIdleAction::tPetIdleActRecord == nil" )
		return false
	end


	-- �׼� ���� ��������
	local sAIType = tPetIdleActRecord[ 1 ]

	if sAIType == "none"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_NONE
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_NONE:Selected - nHandle( "..nHandle.." )" )
	elseif sAIType == "follow"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_FOLLOW
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_FOLLOW:Selected - nHandle( "..nHandle.." )" )
	elseif sAIType == "revolution"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_REVOLUTION
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:Selected - nHandle( "..nHandle.." )" )
	elseif sAIType == "dance"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_DANCE
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DANCE:Selected - nHandle( "..nHandle.." )" )
	elseif sAIType == "attack"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_ATTACK
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ATTACK:Selected - nHandle( "..nHandle.." )" )
	elseif sAIType == "roaming"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_ROAMING
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROAMING:Selected - nHandle( "..nHandle.." )" )
	elseif sAIType == "rotation"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_ROTATION
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROTATION:Selected - nHandle( "..nHandle.." )" )
	elseif sAIType == "talk"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_TALK
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_TALK:Selected - nHandle( "..nHandle.." )" )
	elseif sAIType == "die"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_DIE
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DIE:Selected - nHandle( "..nHandle.." )" )
	else
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_INVALID
		ErrorLog( "PetBaseIdleAction::sAIType is invalid" )
		return false
	end

	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
--	PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_ROAMING
--	DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROAMING:Forced - nHandle( "..nHandle.." )" )
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------


	local nIdleActionMode 		= PetMem["PetInfo"]["PetMode"]["nIdleActionMode"]

	local sScriptMessageIndex 	= tPetIdleActRecord[ 2 ]
	local sHairEffect 			= tPetIdleActRecord[ 3 ]
	local sSoundFile 			= tPetIdleActRecord[ 4 ]

	if sScriptMessageIndex == nil
	then
		ErrorLog( "PetBaseIdleAction::sScriptMessageIndex is invalid" )
		return false
	end

	if sHairEffect == nil
	then
		ErrorLog( "PetBaseIdleAction::sHairEffect is invalid" )
		return false
	end

	if sSoundFile == nil
	then
		ErrorLog( "PetBaseIdleAction::sSoundFile is invalid" )
		return false
	end

	-- ���Ϻ� �ൿ
	if nIdleActionMode == PIAM_NONE	-----------------------------------------------------------------------------------------------------------PIAM_NONE
	then
		-- ����
		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- ���Լ���
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 1

			PetBaseScriptMessage( nHandle, sScriptMessageIndex )
			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end

	elseif nIdleActionMode == PIAM_FOLLOW	-----------------------------------------------------------------------------------------------------------PIAM_FOLLOW
	then
		-- 5�ʵ��� ����, ���ΰ��� �Ÿ� 500����
		-- �� ���� : 200�̳� �� ����, 30�Ÿ����� ��� ����, 80 �̻� �̵�����(���Ƿ� ����)

		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- ���Լ���
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 3

			-- �ֺ� �� Ž��
			local nTargetPetHandle = -1
			local tHandleList = { cNearObjectList( nHandle, PetSystem_nDistanceIdleFollowingPetSelectMax, ObjectType["Pet"] ) }
			if #tHandleList > 0
			then
				nTargetPetHandle = tHandleList[ cRandomInt( 1, #tHandleList ) ]

				-- �ֺ� �� ����ٴϱ� �׼��� �� ��� ���� �꿡�� ���� ��
				for i, nCurPetHandle in pairs( tHandleList )
				do
					-- �� �꿡�ٰ� ���ε� ��ȭ ��� ��� ���������
					if nCurPetHandle ~= nHandle
					then
						cPet_ChangeMind( nCurPetHandle, "follow" );
					end
				end
			end

			-- ���õ� �� ��ġ Ž��
			local tTargetPetCoord = {}
			tTargetPetCoord["x"], tTargetPetCoord["y"] = cObjectLocate( nTargetPetHandle )
			if tTargetPetCoord["x"] == nil
			then
				nTargetPetHandle = -1
			end

			PetMem["TargetInfo"]["nHandle"] = nTargetPetHandle
			PetMem["TargetInfo"]["Coord"]["Cur"]["x"] = tTargetPetCoord["x"]
			PetMem["TargetInfo"]["Coord"]["Cur"]["y"] = tTargetPetCoord["y"]

			PetBaseScriptMessage( nHandle, sScriptMessageIndex )
			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end


		-- �ش� ���� ��ȿ�ϸ� ����
		if PetMem["TargetInfo"]["nHandle"] >= 0
		then
			-- RubyFruit 2013.11.23 �ӽ� �α�
			DebugLog( "PetBaseIdleAction::PIAM_FOLLOW::nIdleStep = "..PetMem["PetInfo"]["nIdleStep"] )

			local nDistanceSquarePet	= cDistanceSquar( nHandle, PetMem["TargetInfo"]["nHandle"] )
			local nDistanceSquareMaster	= cDistanceSquar( nHandle, nMasterHandle )
			----------------------------------------------------------------------
			---------- //�Ÿ��� Pattern Decision ---------------------------------
			if nDistanceSquarePet < PS_nDS_IdleFollowingPetStop
			then
				-- �ƹ��͵� ����
				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_FOLLOW:STOP - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = 2

			elseif nDistanceSquareMaster < PS_nDS_IdleFollowingPetStayMax
			then
				-- �� ����
				--cRunTo( nHandle, PetMem["TargetInfo"]["Coord"]["Cur"]["x"], PetMem["TargetInfo"]["Coord"]["Cur"]["y"], PetSystem_nSpeedRateFollowingMil )
				cFollow( nHandle, PetMem["TargetInfo"]["nHandle"], PetFollowGap, PetFollowStop  )
				PetMem["PetInfo"]["Coord"]["Next"]["x"] = PetMem["TargetInfo"]["Coord"]["Cur"]["x"]
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = PetMem["TargetInfo"]["Coord"]["Cur"]["y"]

				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_FOLLOW:START - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = 2

			else
				-- ��� ���� : �Ÿ�
				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_FOLLOW:CANCEL by Distance - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
			end
			---------- �Ÿ��� Pattern Decision// ---------------------------------
			----------------------------------------------------------------------

			-- �ð����� üũ
			if PetMem["PetInfo"]["Time"]["EnterIdleAction"] + PetSystem_nSecStayAtIdleFollow <= PetMem["CurSec"]
			then
				-- ��� ���� : �ð�
				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_FOLLOW:CANCEL by Time - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
			end

		else
			-- ���� ��ȿ - �ൿ ���
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_FOLLOW:CANCEL by No Target Pet - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

		end

	elseif nIdleActionMode == PIAM_REVOLUTION	-----------------------------------------------------------------------------------------------------------PIAM_REVOLUTION
	then
		-- 10�ʵ��� ����, ���� ������������ ����, ��� �� ���� ������������ ����
		-- 200�̳� �� ����, 30�Ÿ����� ����, �� ������ ���� �� 30 ����������
		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- ���Լ���
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 3 + #PetSystem_tIdleActionData["tData"]["tRevolution"]

			-- �ֺ� �� Ž��
			local nTargetPetHandle = -1
			local tHandleList = { cNearObjectList( nHandle, PetSystem_nDistanceIdleRevolutionPetSelectMax, ObjectType["Pet"] ) }
			if #tHandleList > 0
			then
				nTargetPetHandle = tHandleList[ cRandomInt( 1, #tHandleList ) ]

				-- �ֺ� �� ���� �׼��� �� ��� ���� �꿡�� ���� ��
				for i, nCurPetHandle in pairs( tHandleList )
				do
					-- �� �꿡�ٰ� ���ε� ��ȭ ��� ��� ���������
					if nCurPetHandle ~= nHandle
					then
						cPet_ChangeMind( nCurPetHandle, "revolution" );
					end
				end
			end

			-- ���õ� �� ��ġ Ž��
			local tTargetPetCoord = {}
			tTargetPetCoord["x"], tTargetPetCoord["y"] = cObjectLocate( nTargetPetHandle )
			if tTargetPetCoord["x"] == nil
			then
				nTargetPetHandle = -1
			end

			PetMem["TargetInfo"]["nHandle"] = nTargetPetHandle
			PetMem["TargetInfo"]["Coord"]["Cur"]["x"] = tTargetPetCoord["x"]
			PetMem["TargetInfo"]["Coord"]["Cur"]["y"] = tTargetPetCoord["y"]

			-- ���� �߽� ��ǥ ����
			PetMem["PetInfo"]["Coord"]["Center"]["x"] = PetMem["TargetInfo"]["Coord"]["Cur"]["x"]
			PetMem["PetInfo"]["Coord"]["Center"]["y"] = PetMem["TargetInfo"]["Coord"]["Cur"]["y"]

			local nTargetPetMasterHandle = cGetMaster( PetMem["TargetInfo"]["nHandle"] )
			if nTargetPetMasterHandle == nil
			then
				nTargetPetMasterHandle = -1
			end

			PetMem["TargetMasterInfo"]["nHandle"] = nTargetPetMasterHandle

			local nTargetMasterX, nTargetMasterY = cObjectLocate( PetMem["TargetMasterInfo"]["nHandle"] )
			if nTargetMasterX == nil
			then
				nTargetPetMasterHandle = -1
			end

			PetMem["TargetMasterInfo"]["Coord"]["Cur"]["x"]		= nTargetMasterX
			PetMem["TargetMasterInfo"]["Coord"]["Cur"]["y"]		= nTargetMasterY
			PetMem["TargetMasterInfo"]["Coord"]["Last"]["x"]	= nTargetMasterX
			PetMem["TargetMasterInfo"]["Coord"]["Last"]["y"]	= nTargetMasterY


			PetBaseScriptMessage( nHandle, sScriptMessageIndex )
			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end

		-- �ش� ��� �ش� �� �����Ͱ� ��ȿ�ϸ� ����
		if PetMem["TargetInfo"]["nHandle"] >= 0 and PetMem["TargetMasterInfo"]["nHandle"] >= 0
		then

			-- RubyFruit 2013.11.23 �ӽ� �α�
			DebugLog( "PetBaseIdleAction::PIAM_REVOLUTION::nIdleStep = "..PetMem["PetInfo"]["nIdleStep"] )
			----------------------------------------------------------------------
			-- �ܰ躰 ����
			if PetMem["PetInfo"]["nIdleStep"] == 1
			then
				-- ù ����
				-- ó������ ������ ����
				local nDistanceSquare 	= cDistanceSquar( nHandle, PetMem["TargetInfo"]["nHandle"] )
				----------------------------------------------------------------------
				---------- //�Ÿ��� Pattern Decision ---------------------------------
				if nDistanceSquare > PS_nDS_IdleRevolutionPetStart
				then
					-- �� ����
					local tTargetCoord = {}
					tTargetCoord["x"], tTargetCoord["y"] = cGetCoord_Circle( PetMem["TargetInfo"]["Coord"]["Cur"]["x"], PetMem["TargetInfo"]["Coord"]["Cur"]["y"], PetSystem_nDistanceIdleRevolutionPetStop )
					cRunTo( nHandle, tTargetCoord["x"], tTargetCoord["y"], PetSystem_nSpeedRateFollowingMil )
					PetMem["PetInfo"]["Coord"]["Next"]["x"] = tTargetCoord["x"]
					PetMem["PetInfo"]["Coord"]["Next"]["y"] = tTargetCoord["y"]

					DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:START Follow - nHandle( "..nHandle.." )" )
				end
				---------- �Ÿ��� Pattern Decision// ---------------------------------
				----------------------------------------------------------------------

				PetMem["PetInfo"]["nIdleStep"] = 2

			elseif PetMem["PetInfo"]["nIdleStep"] == 2
			then
				-- �ι�° ����
				local nDistanceSquare = cDistanceSquar( PetMem["PetInfo"]["Coord"]["Cur"]["x"], PetMem["PetInfo"]["Coord"]["Cur"]["y"], PetMem["PetInfo"]["Coord"]["Next"]["x"], PetMem["PetInfo"]["Coord"]["Next"]["y"] )
				----------------------------------------------------------------------
				---------- //�Ÿ��� Pattern Decision ---------------------------------
				if nDistanceSquare <= PS_nDS_IdleRevolutionPetStop
				then

					PetMem["PetInfo"]["nIdleStep"] = 3

					DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:STOP Follow - nHandle( "..nHandle.." )" )
				end
				---------- �Ÿ��� Pattern Decision// ---------------------------------
				----------------------------------------------------------------------



			elseif PetMem["PetInfo"]["nIdleStep"] > 2 and PetMem["PetInfo"]["nIdleStep"] < PetMem["PetInfo"]["nIdleEndStep"]
			then
				-- �������� 3 ~ 10
				local nStepOffset 	= 2
				local tStepInfo 	= PetSystem_tIdleActionData["tData"]["tRevolution"]

				if PetBaseExecIdleAction( PetMem, nStepOffset, tStepInfo, PetSystem_nSpeedRateFollowingMil ) ~= true
				then
					ErrorLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:PetBaseExecIdleAction Failed - nHandle( "..nHandle.." )" )
				end
				cExecCheck( "PetBaseIdleAction" )
			else	-- PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"] �� ���
				-- ���̹Ƿ� �ƹ��͵� ���ϰ� �ڷ� �ѱ�
			end
			-- �ܰ躰 ���� ���� ����
			----------------------------------------------------------------------



			-- �ð����� üũ
			if PetMem["PetInfo"]["Time"]["EnterIdleAction"] + PetSystem_nSecStayAtIdleRevolution <= PetMem["CurSec"]
			then
				-- ��� ���� : �ð�
				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:CANCEL by Time - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
			end

			-- ������ ������ üũ
			if IsPetMasterMoved( PetMem ) == true
			then
				-- ��� ���� : ������ �̵�
				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:CANCEL by Master Move - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			end
			cExecCheck( "PetBaseIdleAction" )

			-- ���� �� ������ ������ üũ
			local tTargetPetMasterLastCoord	= PetMem["TargetMasterInfo"]["Coord"]["Last"]
			local tTargetPetMasterCurCoord	= PetMem["TargetMasterInfo"]["Coord"]["Cur"]

			tTargetPetMasterLastCoord["x"]	= tTargetPetMasterCurCoord["x"]
			tTargetPetMasterLastCoord["y"]	= tTargetPetMasterCurCoord["y"]

			tTargetPetMasterCurCoord["x"], tTargetPetMasterCurCoord["y"] = cObjectLocate( PetMem["TargetMasterInfo"]["nHandle"] )
			if tTargetPetMasterCurCoord["x"] == nil
			then
				-- ��� ���� : ��� �� ������ ����
				ErrorLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:CANCEL by Cannot Find Target Pet Master - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			end

			if tTargetPetMasterLastCoord["x"] ~= tTargetPetMasterCurCoord["x"] or tTargetPetMasterLastCoord["y"] ~= tTargetPetMasterCurCoord["y"]
			then
				-- ��� ���� : ��� �� ������ �̵�
				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:CANCEL by Target Pet Master Move - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			end

		else
			-- ���� ��ȿ - �ൿ ���
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:CANCEL by No Target Pet - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
		end

	elseif nIdleActionMode == PIAM_DANCE	-----------------------------------------------------------------------------------------------------------PIAM_DANCE
	then
		-- 10�ʵ��� ����, ���� ������������ ����
		-- ���ڸ� �µ� ��� ���� : ���� ����, ����, ����, �����ʺ���, ����, ����
		-- ���ڸ� 3������ : �ݹ����� 1�ʿ� ���� �ӵ���.. 0�� 15�� 30�� 45�� 60�� 75�� 90�� 105�� 120�� 135�� 150�� 165�� 0��... �ݺ�
		-- ��ǥ�׸��� : �Ÿ� 100 �̳� ��???????? ��ǥ 5�� ��� ��ó 30 �̳� �������� �̵� ��ġ ��ȯ
		-- ���ڸ����� ���׸��� ���̰� ���ۺ��� : �ݰ� 50 �̳� ���� ���� 1�ʿ� �ѹ��� ���� 1�ʿ� 20% ����
		-- ���׸��� �׳� ��������� �̵� : ���� 1�ʿ� 33.3% ����


		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- ���Լ���
			PetMem["PetInfo"]["nCurDanceNo"] = cRandomInt( 1, #PetSystem_tIdleActionData["tData"]["ttDance"] )
			DebugLog( "PetBaseIdleAction::PIAM_DANCE::nCurDanceNo = "..PetMem["PetInfo"]["nCurDanceNo"].." has been selected" )
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 2 + #PetSystem_tIdleActionData["tData"]["ttDance"][ PetMem["PetInfo"]["nCurDanceNo"] ]
			PetMem["PetInfo"]["Time"]["DanceStartTime"] = PetMem["CurSec"]

			-- �� �߽� ��ǥ ����
			PetMem["PetInfo"]["Coord"]["Center"]["x"] = PetMem["PetInfo"]["Coord"]["Cur"]["x"]
			PetMem["PetInfo"]["Coord"]["Center"]["y"] = PetMem["PetInfo"]["Coord"]["Cur"]["y"]

			PetBaseScriptMessage( nHandle, sScriptMessageIndex )
			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end

		-- RubyFruit 2013.11.23 �ӽ� �α�
		DebugLog( "PetBaseIdleAction::PIAM_DANCE::nIdleStep = "..PetMem["PetInfo"]["nIdleStep"] )
		----------------------------------------------------------------------
		-- �ܰ躰 ����
		if PetMem["PetInfo"]["nIdleStep"] == 1
		then
			-- ù ����

			PetMem["PetInfo"]["nIdleStep"] = 2
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DANCE:START Dance - nHandle( "..nHandle.." )" )

		elseif PetMem["PetInfo"]["nIdleStep"] > 1 and PetMem["PetInfo"]["nIdleStep"] < PetMem["PetInfo"]["nIdleEndStep"]
		then
			-- ������ : 2 ~

			local nStepOffset 	= 1
			local tStepInfo 	= PetSystem_tIdleActionData["tData"]["ttDance"][ PetMem["PetInfo"]["nCurDanceNo"] ]

			if PetBaseExecIdleAction( PetMem, nStepOffset, tStepInfo, PetSystem_nSpeedRateFollowingMil ) ~= true
			then
				ErrorLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DANCE:PetBaseExecIdleAction Failed - nHandle( "..nHandle.." )" )
			end
			cExecCheck( "PetBaseIdleAction" )

		else	-- PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"] �� ���
			-- ���̹Ƿ� �ƹ��͵� ���ϰ� �ڷ� �ѱ�
		end
		-- �ܰ躰 ���� ���� ����
		----------------------------------------------------------------------

		-- �ð����� üũ
		if PetMem["PetInfo"]["Time"]["EnterIdleAction"] + PetSystem_nSecStayAtIdleDance <= PetMem["CurSec"]
		then
			-- ��� ���� : �ð�
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DANCE:CANCEL by Time - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			-- ���ѽð����� �� ���� ��� ���� �꿡�� ���� ��
			local tHandleList = { cNearObjectList( nHandle, PetSystem_nDistanceIdleMindChangePetSelectMax, ObjectType["Pet"] ) }
			if #tHandleList > 0
			then
				for i, nCurPetHandle in pairs( tHandleList )
				do
					-- �� �꿡�ٰ� ���ε� ��ȭ ��� ��� ���������
					if nCurPetHandle ~= nHandle
					then
						cPet_ChangeMind( nCurPetHandle, "dance" );
					end

				end
			end

		end

		-- ������ ������ üũ
		if IsPetMasterMoved( PetMem ) == true
		then
			-- ��� ���� : ������ �̵�
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DANCE:CANCEL by Master Move - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

		end
		cExecCheck( "PetBaseIdleAction" )

	elseif nIdleActionMode == PIAM_ATTACK	-----------------------------------------------------------------------------------------------------------PIAM_ATTACK
	then
		-- 1��ƾ�� ����, ���� ������������ ����, ��� �� ���� ������������ ����
		-- �ֺ� �� ���� : 200�Ÿ� �̳� �� ����, ������ȯ, ����, ����, ����
		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- ���Լ���
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 3 + #PetSystem_tIdleActionData["tData"]["tAttack"]


			-- �ֺ� �� Ž��
			local nTargetPetHandle = -1
			local tHandleList = { cNearObjectList( nHandle, PetSystem_nDistanceIdleAttackPetSelectMax, ObjectType["Pet"] ) }
			if #tHandleList > 0
			then
				nTargetPetHandle = tHandleList[ cRandomInt( 1, #tHandleList ) ]

				-- �ֺ� �� ���� �׼��� �� ��� ���� �꿡�� ���� ��
				for i, nCurPetHandle in pairs( tHandleList )
				do
					-- �� �꿡�ٰ� ���ε� ��ȭ ��� ��� ���������
					if nCurPetHandle ~= nHandle
					then
						cPet_ChangeMind( nCurPetHandle, "attack" );
					end
				end
			end

			-- ���õ� �� ��ġ Ž��
			local tTargetPetCoord = {}
			tTargetPetCoord["x"], tTargetPetCoord["y"] = cObjectLocate( nTargetPetHandle )
			if tTargetPetCoord["x"] == nil
			then
				nTargetPetHandle = -1
			end

			PetMem["TargetInfo"]["nHandle"] = nTargetPetHandle
			PetMem["TargetInfo"]["Coord"]["Cur"]["x"] = tTargetPetCoord["x"]
			PetMem["TargetInfo"]["Coord"]["Cur"]["y"] = tTargetPetCoord["y"]

			-- ���� �߽� ��ǥ ����
			PetMem["PetInfo"]["Coord"]["Center"]["x"] = tTargetPetCoord["x"]
			PetMem["PetInfo"]["Coord"]["Center"]["y"] = tTargetPetCoord["y"]

			local nTargetPetMasterHandle = cGetMaster( PetMem["TargetInfo"]["nHandle"] )
			if nTargetPetMasterHandle == nil
			then
				nTargetPetMasterHandle = -1
			end

			PetMem["TargetMasterInfo"]["nHandle"] = nTargetPetMasterHandle

			local nTargetMasterX, nTargetMasterY = cObjectLocate( PetMem["TargetMasterInfo"]["nHandle"] )
			if nTargetMasterX == nil
			then
				nTargetPetMasterHandle = -1
			end

			PetMem["TargetMasterInfo"]["Coord"]["Cur"]["x"]		= nTargetMasterX
			PetMem["TargetMasterInfo"]["Coord"]["Cur"]["y"]		= nTargetMasterY
			PetMem["TargetMasterInfo"]["Coord"]["Last"]["x"]	= nTargetMasterX
			PetMem["TargetMasterInfo"]["Coord"]["Last"]["y"]	= nTargetMasterY

			PetBaseScriptMessage( nHandle, sScriptMessageIndex )
			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end

		-- �ش� ��� �ش� ���� �����Ͱ� ��ȿ�ϸ� ����
		if PetMem["TargetInfo"]["nHandle"] >= 0 and PetMem["TargetMasterInfo"]["nHandle"] >= 0
		then
			-- RubyFruit 2013.11.23 �ӽ� �α�
			DebugLog( "PetBaseIdleAction::PIAM_ATTACK::nIdleStep = "..PetMem["PetInfo"]["nIdleStep"] )
			----------------------------------------------------------------------
			-- �ܰ躰 ����
			if PetMem["PetInfo"]["nIdleStep"] == 1
			then

				local nDir4 = cRandomInt( 1, 90 )
				local nGoalX, nGoalY = cGetAroundCoord( PetMem["TargetInfo"]["nHandle"], nDir4*4, PetFollowGap )

				cRunTo( nHandle, nGoalX, nGoalY, PetSystem_nSpeedRateFollowingMil )

				PetMem["PetInfo"]["Coord"]["Next"]["x"] = PetMem["TargetInfo"]["Coord"]["Cur"]["x"]
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = PetMem["TargetInfo"]["Coord"]["Cur"]["y"]

				PetMem["PetInfo"]["nIdleStep"] = 2

			elseif PetMem["PetInfo"]["nIdleStep"] == 2
			then

				local nDistanceSquarePet	= cDistanceSquar( nHandle, PetMem["TargetInfo"]["nHandle"] )
				local nDistanceSquareMaster	= cDistanceSquar( nHandle, nMasterHandle )

				if nDistanceSquarePet < PS_nDS_IdleFollowingPetStop
				then

					-- �ٸ� �� ������ ���� ��ȯ
					local tTargetCoord = PetMem["TargetInfo"]["Coord"]["Cur"]
					cSetObjectDirect( nHandle, tTargetCoord["x"], tTargetCoord["y"] )
					PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
					PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]

					PetMem["PetInfo"]["nIdleStep"] = 3

				elseif nDistanceSquareMaster < PS_nDS_IdleFollowingPetStayMax
				then

					PetMem["PetInfo"]["Coord"]["Next"]["x"] = PetMem["TargetInfo"]["Coord"]["Cur"]["x"]
					PetMem["PetInfo"]["Coord"]["Next"]["y"] = PetMem["TargetInfo"]["Coord"]["Cur"]["y"]

				else

					PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

				end

			elseif PetMem["PetInfo"]["nIdleStep"] > 2 and PetMem["PetInfo"]["nIdleStep"] < PetMem["PetInfo"]["nIdleEndStep"]
			then
				-- ���ݽ��� 3 ~ 5
				local nStepOffset 	= 2
				local tStepInfo 	= PetSystem_tIdleActionData["tData"]["tAttack"]

				if PetBaseExecIdleAction( PetMem, nStepOffset, tStepInfo, 0 ) ~= true
				then
					ErrorLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ATTACK:PetBaseExecIdleAction Failed - nHandle( "..nHandle.." )" )
				end
				cExecCheck( "PetBaseIdleAction" )

			else	-- PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"] �� ���
				-- ���̹Ƿ� �ƹ��͵� ���ϰ� �ڷ� �ѱ�
			end
			-- �ܰ躰 ���� ���� ����
			----------------------------------------------------------------------

			----------------------------------------------------------------------
			-- ������ ������ üũ
			if IsPetMasterMoved( PetMem ) == true
			then
				-- ��� ���� : ������ �̵�
				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ATTACK:CANCEL by Master Move - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			end
			cExecCheck( "PetBaseIdleAction" )

			-- ���� �� ������ ������ üũ
			local tTargetPetMasterLastCoord	= PetMem["TargetMasterInfo"]["Coord"]["Last"]
			local tTargetPetMasterCurCoord	= PetMem["TargetMasterInfo"]["Coord"]["Cur"]

			tTargetPetMasterLastCoord["x"]	= tTargetPetMasterCurCoord["x"]
			tTargetPetMasterLastCoord["y"]	= tTargetPetMasterCurCoord["y"]

			tTargetPetMasterCurCoord["x"], tTargetPetMasterCurCoord["y"] = cObjectLocate( PetMem["TargetMasterInfo"]["nHandle"] )
			if tTargetPetMasterCurCoord["x"] == nil
			then
				-- ��� ���� : ��� �� ������ ���?
				ErrorLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ATTACK:CANCEL by Cannot Find Target Pet Master - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			end

			if tTargetPetMasterLastCoord["x"] ~= tTargetPetMasterCurCoord["x"] or tTargetPetMasterLastCoord["y"] ~= tTargetPetMasterCurCoord["y"]
			then
				-- ��� ���� : ��� �� ������ �̵�
				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ATTACK:CANCEL by Target Pet Master Move - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			end

		else
			-- ���� ��ȿ - �ൿ ���
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ATTACK:CANCEL by No Target Pet - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
		end

	elseif nIdleActionMode == PIAM_ROAMING	-----------------------------------------------------------------------------------------------------------PIAM_ROAMING
	then
		-- �׳� ó��
		-- 20�ʵ��� ����, ���� ������������ ����
		-- �׳� �� ������ ������������������
		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- ���Լ���
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 2

			PetBaseScriptMessage( nHandle, sScriptMessageIndex )
			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end


		-- RubyFruit 2013.11.23 �ӽ� �α�
		DebugLog( "PetBaseIdleAction::PIAM_ROAMING::nIdleStep = "..PetMem["PetInfo"]["nIdleStep"] )
		----------------------------------------------------------------------
		-- �ܰ躰 ����
		if PetMem["PetInfo"]["nIdleStep"] == 1
		then
			-- ù ����

			-- �ƹ����� ��� �̵�
			local tTargetCoord = {}

			tTargetCoord["x"], tTargetCoord["y"] = cGetCoord_Circle( tPetCoord["x"], tPetCoord["y"], PetSystem_nDistanceIdleRoamingMax )

			if tTargetCoord["x"] ~= nil
			then
				cRunTo( nHandle, tTargetCoord["x"], tTargetCoord["y"], PetSystem_nSpeedRateFollowingMil )
				PetMem["PetInfo"]["Coord"]["Next"]["x"] = tTargetCoord["x"]
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = tTargetCoord["y"]

				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROAMING:START Roaming - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = 1
			end

		else	-- PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"] �� ���
			-- ���̹Ƿ� �ƹ��͵� ���ϰ� �ڷ� �ѱ�
		end
		-- �ܰ躰 ���� ���� ����
		----------------------------------------------------------------------


		-- �ð����� üũ
		if PetMem["PetInfo"]["Time"]["EnterIdleAction"] + PetSystem_nSecStayAtIdleRoaming <= PetMem["CurSec"]
		then
			-- ��� ���� : �ð�
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROAMING:CANCEL by Time - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
		end

		-- ������ ������ üũ
		if IsPetMasterMoved( PetMem ) == true
		then
			-- ��� ���� : ������ �̵�
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROAMING:CANCEL by Master Move - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

		end
		cExecCheck( "PetBaseIdleAction" )

	elseif nIdleActionMode == PIAM_ROTATION	-----------------------------------------------------------------------------------------------------------PIAM_ROTATION
	then
		-- 10�ʵ��� ����, ���� ������������ ����
		-- ���� : 20%�� 1�ʿ� ���� �ӵ���.. 0��, 10��, 20��, 30��, 40��, ... , 350��, 0��... �ݺ�
		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- ���Լ���
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 2 + #PetSystem_tIdleActionData["tData"]["tRotation"]

			-- ȸ�� �߽� ��ǥ ����
			PetMem["PetInfo"]["Coord"]["Center"]["x"] = PetMem["PetInfo"]["Coord"]["Cur"]["x"]
			PetMem["PetInfo"]["Coord"]["Center"]["y"] = PetMem["PetInfo"]["Coord"]["Cur"]["y"]

			PetBaseScriptMessage( nHandle, sScriptMessageIndex )
			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end

		-- RubyFruit 2013.11.23 �ӽ� �α�
		DebugLog( "PetBaseIdleAction::PIAM_ROTATION::nIdleStep = "..PetMem["PetInfo"]["nIdleStep"] )
		----------------------------------------------------------------------
		-- �ܰ躰 ����
		if PetMem["PetInfo"]["nIdleStep"] == 1
		then
			-- ù ����
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROTATION:START Pattern- nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = 2

		elseif PetMem["PetInfo"]["nIdleStep"] > 1 and PetMem["PetInfo"]["nIdleStep"] < PetMem["PetInfo"]["nIdleEndStep"]
		then
			-- �������� 2 ~ 41
			local nStepOffset 	= 1
			local tStepInfo 	= PetSystem_tIdleActionData["tData"]["tRotation"]

			if PetBaseExecIdleAction( PetMem, nStepOffset, tStepInfo, PetSystem_nSpeedRateFollowingMil ) ~= true
			then
				ErrorLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROTATION:PetBaseExecIdleAction Failed - nHandle( "..nHandle.." )" )
			end
			cExecCheck( "PetBaseIdleAction" )

		else	-- PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"] �� ���
			-- ���̹Ƿ� �ƹ��͵� ���ϰ� �ڷ� �ѱ�
		end
		-- �ܰ躰 ���� ���� ����
		----------------------------------------------------------------------

		-- �ð����� üũ
		if PetMem["PetInfo"]["Time"]["EnterIdleAction"] + PetSystem_nSecStayAtIdleRotation <= PetMem["CurSec"]
		then
			-- ��� ���� : �ð�
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROTATION:CANCEL by Time - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
		end

		-- ������ ������ üũ
		if IsPetMasterMoved( PetMem ) == true
		then
			-- ��� ���� : ������ �̵�
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROTATION:CANCEL by Master Move - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

		end
		cExecCheck( "PetBaseIdleAction" )

	elseif nIdleActionMode == PIAM_TALK	-----------------------------------------------------------------------------------------------------------PIAM_TALK
	then
		-- �׳� ó��
		-- 1ȸ : ���ϴ� ������ ������ ���� �ϰ��� �ʱ�ȭ
		-- �ֺ� �� ���� �ٰ����� ���ϱ� : 200�Ÿ� �̳� �� ����, �꿡�� 30�Ÿ����� ����, ������ȯ �� ��, ���ϱ� ���ΰ� 300�̻�������� ��
		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- ���Լ���
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 5

			-- �ֺ� �� Ž��
			local nTargetPetHandle = -1
			local tHandleList = { cNearObjectList( nHandle, PetSystem_nDistanceIdleTalkPetSelectMax, ObjectType["Pet"] ) }
			if #tHandleList > 0
			then
				nTargetPetHandle = tHandleList[ cRandomInt( 1, #tHandleList ) ]

				-- �ֺ� �� ���� ���ϴ� �׼��� �� ��� ���� �꿡�� ���� ��
				for i, nCurPetHandle in pairs( tHandleList )
				do
					-- �� �꿡�ٰ� ���ε� ��ȭ ��� ��� ���������
					if nCurPetHandle ~= nHandle
					then
						cPet_ChangeMind( nCurPetHandle, "talk" );
					end
				end
			end

			-- ���õ� �� ��ġ Ž��
			local tTargetPetCoord = {}
			tTargetPetCoord["x"], tTargetPetCoord["y"] = cObjectLocate( nTargetPetHandle )
			if tTargetPetCoord["x"] == nil
			then
				nTargetPetHandle = -1
			end

			PetMem["TargetInfo"]["nHandle"] = nTargetPetHandle
			PetMem["TargetInfo"]["Coord"]["Cur"]["x"] = tTargetPetCoord["x"]
			PetMem["TargetInfo"]["Coord"]["Cur"]["y"] = tTargetPetCoord["y"]

			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end

		-- �ش� ���� ��ȿ�ϸ� ����
		if PetMem["TargetInfo"]["nHandle"] >= 0
		then

			-- RubyFruit 2013.11.23 �ӽ� �α�
			DebugLog( "PetBaseIdleAction::PIAM_TALK::nIdleStep = "..PetMem["PetInfo"]["nIdleStep"] )
			----------------------------------------------------------------------
			-- �ܰ躰 ����
			if PetMem["PetInfo"]["nIdleStep"] == 1
			then
				-- ù ����
				-- ó������ ������ ����
				local nDistanceSquare 		= cDistanceSquar( nHandle, PetMem["TargetInfo"]["nHandle"] )
				----------------------------------------------------------------------
				---------- //�Ÿ��� Pattern Decision ---------------------------------
				if nDistanceSquare > PS_nDS_IdleTalkPetStart
				then
					-- �� ����
					local tTargetCoord = {}
					tTargetCoord["x"], tTargetCoord["y"] = cGetCoord_Circle( PetMem["TargetInfo"]["Coord"]["Cur"]["x"], PetMem["TargetInfo"]["Coord"]["Cur"]["y"], PetSystem_nDistanceIdleRevolutionPetStop )
					cRunTo( nHandle, tTargetCoord["x"], tTargetCoord["y"], PetSystem_nSpeedRateFollowingMil )
					PetMem["PetInfo"]["Coord"]["Next"]["x"] = tTargetCoord["x"]
					PetMem["PetInfo"]["Coord"]["Next"]["y"] = tTargetCoord["y"]

					DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_TALK:START Follow - nHandle( "..nHandle.." )" )
				end
				---------- �Ÿ��� Pattern Decision// ---------------------------------
				----------------------------------------------------------------------

				PetMem["PetInfo"]["nIdleStep"] = 2

			elseif PetMem["PetInfo"]["nIdleStep"] == 2
			then
				-- �ι�° ���� : �����Ϳ��� �Ÿ��� üũ�ϸ� �ٸ��꿡�� �ٰ���
				local nDistanceSquare 		= cDistanceSquar( PetMem["PetInfo"]["Coord"]["Cur"]["x"], PetMem["PetInfo"]["Coord"]["Cur"]["y"], PetMem["PetInfo"]["Coord"]["Next"]["x"], PetMem["PetInfo"]["Coord"]["Next"]["y"] )
				local nDistanceSquareMaster	= cDistanceSquar( nHandle, nMasterHandle )
				----------------------------------------------------------------------
				---------- //�Ÿ��� Pattern Decision ---------------------------------
				if nDistanceSquare <= PS_nDS_IdleTalkPetStop
				then

					PetMem["PetInfo"]["nIdleStep"] = 3

					DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_TALK:STOP Follow - nHandle( "..nHandle.." )" )
				elseif nDistanceSquareMaster > PS_nDS_IdleTalkPetStayMax
				then
					-- ��� ���� : �����Ϳ��� �Ÿ�
					DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_TALK:CANCEL by Distance from Master - nHandle( "..nHandle.." )" )

					PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
				end
				---------- �Ÿ��� Pattern Decision// ---------------------------------
				----------------------------------------------------------------------

			elseif PetMem["PetInfo"]["nIdleStep"] == 3
			then
				-- ��� �� ������ ���� ��ȯ
				local tTargetCoord = PetMem["TargetInfo"]["Coord"]["Cur"]
				cSetObjectDirect( nHandle, tTargetCoord["x"], tTargetCoord["y"] )
				PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]

				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_TALK:START See - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = 4

			elseif PetMem["PetInfo"]["nIdleStep"] == 4
			then
				-- ���ϱ�

				PetBaseScriptMessage( nHandle, sScriptMessageIndex )
				cExecCheck( "PetBaseIdleAction" )

				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_TALK:START Talk - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			else	-- PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"] �� ���
				-- ���̹Ƿ� �ƹ��͵� ���ϰ� �ڷ� �ѱ�
			end
			-- �ܰ躰 ���� ���� ����
			----------------------------------------------------------------------

		else
			-- ���� ��ȿ - �ൿ ���
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_TALK:CANCEL by No Target Pet - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
		end

	elseif nIdleActionMode == PIAM_DIE	-----------------------------------------------------------------------------------------------------------PIAM_DIE
	then
		-- �׳� ó��
		-- 10�ʰ� ����ô
		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- ���Լ���
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 3

			PetBaseScriptMessage( nHandle, sScriptMessageIndex )
			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end

		-- RubyFruit 2013.11.23 �ӽ� �α�
		DebugLog( "PetBaseIdleAction::PIAM_DIE::nIdleStep = "..PetMem["PetInfo"]["nIdleStep"] )
		----------------------------------------------------------------------
		-- �ܰ躰 ����
		if PetMem["PetInfo"]["nIdleStep"] == 1
		then
			-- ù ����
			-- �ִϸ��̼��� �� �������� �ٸ� ���� ����ؾ��ϴ� ������ �־ �̺�Ʈ �ڵ带 ���� ����ϱ�� ��
			if cActByEventCode( nHandle, PetSystem_ActionEventCode["Die"] ) == nil
			then
				ErrorLog( "cActByEventCode failed ["..nHandle.."]'s Die" )
			end

			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DIE:START Die animation - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = 2

		elseif PetMem["PetInfo"]["nIdleStep"] == 2
		then

			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DIE:Not Do Anithing - nHandle( "..nHandle.." )" )

		else	-- PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"] �� ���
			-- ���̹Ƿ� �ƹ��͵� ���ϰ� �ڷ� �ѱ�
		end
		-- �ܰ躰 ���� ���� ����
		----------------------------------------------------------------------

		-- �ð����� üũ
		if PetMem["PetInfo"]["Time"]["EnterIdleAction"] + PetSystem_nSecStayAtIdleDie <= PetMem["CurSec"]
		then
			-- ��� ���� : �ð�
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DIE:CANCEL by Time - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			-- �׾��ִ� ������� ��� �ִ� ���� ������ Idle�� ����
			cActByEventCode( nHandle, PetSystem_ActionEventCode["Idle"] )
		end

	else
		-- logic error
		ErrorLog( "PetBaseIdleAction::nIdleActionMode is invalid - logic error" )
		return false
	end


	-- ������ ���� ó�� ���� �ʱ�ȭ : ���������� Idle �ൿ�� �ߴٰ� �ϴ� �ð� ������ �̶� �ѹ� �� �Ѵ�.(�ٸ� ������ �ϴ� �Ͱ��� ���� ���� �ѹ� �� ���ִ� ��)
	if PetMem["PetInfo"]["nIdleStep"] >= PetMem["PetInfo"]["nIdleEndStep"]
	then
		if PetBaseInitIdleAction( PetMem ) ~= true
		then
			return false
		end
		cExecCheck( "PetBaseIdleAction" )

		if PetBaseInitTarget( PetMem ) ~= true
		then
			return false
		end
		cExecCheck( "PetBaseIdleAction" )

		if PetBaseInitTargetMaster( PetMem ) ~= true
		then
			return false
		end
		cExecCheck( "PetBaseIdleAction" )

--		PetMem["PetInfo"]["PetMode"]["nMasterMode"] = PMM_NONE
		PetMem["PetInfo"]["PetMode"]["nActionMode"] = PAM_NONE
		PetMem["PetInfo"]["Time"]["LastActIdleMode"] = PetMem["CurSec"]
		local nWaitIdleActSec = cRandomInt( PetSystem_nSecMinWaitActAtIdle, PetSystem_nSecMaxWaitActAtIdle )
		PetMem["PetInfo"]["Time"]["ExecIdleActMode"]	= PetMem["CurSec"] + nWaitIdleActSec

		return true
	end

	--PetMem["PetInfo"]["PetMode"]["nIdleActionMode"]

end
