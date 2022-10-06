
function PetBaseRoutine( PetMem )
	cExecCheck( "PetBaseRoutine" )

	if PetMem == nil
	then
		DebugLog( "PetBaseRoutine::PetMem is nil" )
		return ReturnAI["END"]
	end

	local nHandle = PetMem["PetInfo"]["nHandle"]

	-- �� �����
	if cIsObjectDead( nHandle ) == 1
	then
		-- AI ��ũ��Ʈ ����
		cAIScriptSet( nHandle )

		-- �޸� ����
		gPetAIMemory["PetBase"][ nHandle ] = nil

		DebugLog( "PetBaseRoutine::Pet Has Died - nHandle( "..nHandle.." )" )
		return ReturnAI["END"]
	end

--	�� �����
-- 	���� �ִ��� üũ( �ʸ�ũ ������ )
--	���� �׾����� üũ ( ��� üũ )
--	������ �θ� �������� üũ ( ���� ���õ� ������ �ҷ��� üũ )
--	���ΰ��� �Ÿ� üũ( �־����� ���󰡶� )
--	�� ���� ����ð� üũ
--	�� ��� ���� �ð� üũ
	local nMasterHandle = PetMem["MasterInfo"]["nHandle"]

	if cIsObjectDead( nMasterHandle ) == 1
	then
		-- ���� ��ü�� ���ų� ��ü�����϶��� ������ ��.. ������ �ǹ� ����
	end

	local sMasterMode = cGetObjectMode( nMasterHandle );
	if sMasterMode == nil
	then
		-- ������ ��� ��ã�� : ���� �����Ƿ� �������ػڷ� ���ų� �� �׷��Ŵϱ�
		cAIScriptSet( nHandle )
		gPetAIMemory["PetBase"][ nHandle ] = nil

		DebugLog( "PetBaseRoutine::cGetObjectMode Fail - nHandle( "..nHandle.." )" )
		return ReturnAI["END"]
	end

DebugLog( "PetBaseRoutine:: Point 1 - ���� ������ ���¿� ����.." )
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
------ �������� ���¿� ���� ���� ������ �ൿ ��ȭ ���� : ��������ó��, Ư�����¿����� ��������ó��
	local tMode = PetMem["PetInfo"]["PetMode"]	-- ��� ������ ���ϰ� �ϱ� ����

	-- �׾��� ��Ƴ��� �켱������ ���� AI�� ���� AI �ʱ�ȭ
	if tMode["nMasterMode"] == PMM_DIE and sMasterMode ~= "corpse"
	then
		local tPetCoord = PetMem["PetInfo"]["Coord"]["Cur"]
		PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
		PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
		tMode["nMasterMode"] = PMM_NONE
		tMode["nActionMode"] = PAM_NONE
	end

	-- ���̵� �׼��� �ƴҶ� �� �� �׻� �ʱ�ȭ ���ֱ�
	if tMode["nMasterMode"] ~= PMM_IDLE or tMode["nActionMode"] ~= PAM_IDLE_ACT
	then
		PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["InitialSec"]
	end


	if sMasterMode == "linking"
	then
		tMode["nMasterMode"] = PMM_LINK
		DebugLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_LINK - nHandle( "..nHandle.." )" )
	elseif sMasterMode == "corpse"
	then
		if tMode["nMasterMode"] < PMM_DIE	-- �켱����üũ
		then
			-- Die ���� ����
			local tPetCoord = PetMem["PetInfo"]["Coord"]["Cur"]
			-- ���ڸ��� �̵��Ѱ�ó�� ǥ��
			PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
			PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
			tMode["nActionMode"] = PAM_NONE

			-- PupCaseDesc ���� �� �������� ����ؼ� ���ڵ� �����ͼ� PAI Ÿ���� Ȯ�� �� Valid �� �� ��ũ��Ʈ �޼����� �������Ʈ, ���带 �߻���Ų��.
			local tPetDieActRecord = { cPet_GetActionRecord( nHandle, "die" ) } -- { "PupAITypeString", "SM_Inx", "HairEffect", "SoundFile" }

			if tPetDieActRecord ~= nil
			then
				if tPetDieActRecord[ 1 ] == "script"
				then
					if tPetDieActRecord[ 2 ] ~= "-"
					then
						PetBaseScriptMessage( nHandle, tPetDieActRecord[ 2 ] )
					end

					if tPetDieActRecord[ 3 ] ~= "-"
					then
						PetBaseObjectEffect( nHandle, tPetDieActRecord[ 3 ] )
					end

					if tPetDieActRecord[ 4 ] ~= "-"
					then
						PetBaseObjectSound( nHandle, tPetDieActRecord[ 4 ] )
					end

					cExecCheck( "PetBaseRoutine" )

				else
					ErrorLog( "PetBaseRoutine::cPet_GetActionRecord Failed ["..nHandle.."]" );
				end

			else
				ErrorLog( "PetBaseRoutine::cPet_GetActionRecord Failed ["..nHandle.."]" );
			end



			CheckLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_DIE - nHandle( "..nHandle.." )" )
		end

		tMode["nMasterMode"] = PMM_DIE
		DebugLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_DIE - nHandle( "..nHandle.." )" )

	elseif sMasterMode == "normal" or sMasterMode == "fight" or sMasterMode == "riding" or sMasterMode == "house" or sMasterMode == "booth"
	then
		-- ������ �ҷ����� üũ
		if cPet_IsMasterCalling( nHandle ) == true
		then
			-- ������ �θ�
			if tMode["nMasterMode"] <= PMM_CALL	-- �켱����üũ
			then
				-- Call ���� ����

				-- PupCaseDesc ���� �� �������� ����ؼ� ���ڵ� �����ͼ� PAI Ÿ���� Ȯ�� �� Valid �� �� ��ũ��Ʈ �޼����� �������Ʈ, ���带 �߻���Ų��.
				local tPetCallActRecord = { cPet_GetActionRecord( nHandle, "call" ) } -- { "PupAITypeString", "SM_Inx", "HairEffect", "SoundFile" }

				if tPetCallActRecord ~= nil
				then
					if tPetCallActRecord[ 1 ] == "script"
					then
						if tPetCallActRecord[ 2 ] ~= "-"
						then
							PetBaseScriptMessage( nHandle, tPetCallActRecord[ 2 ] )
						end

						if tPetCallActRecord[ 3 ] ~= "-"
						then
							PetBaseObjectEffect( nHandle, tPetCallActRecord[ 3 ] )
						end

						if tPetCallActRecord[ 4 ] ~= "-"
						then
							PetBaseObjectSound( nHandle, tPetCallActRecord[ 4 ] )
						end

						cExecCheck( "PetBaseRoutine" )

					else
						ErrorLog( "PetBaseRoutine::cPet_GetActionRecord Failed ["..nHandle.."]" );
					end

				else
					ErrorLog( "PetBaseRoutine::cPet_GetActionRecord Failed ["..nHandle.."]" );
				end


				-- �ϴ� �ϴ��� ���߱� : ��Ȳ���� �������� �����ϱ�
				local tPetCoord = PetMem["PetInfo"]["Coord"]["Cur"]
-- ���ڸ� �̵� ��û��, ����ٱ⺸�� Ŭ��� ��ũ ���缭 �ణ �����̵��Ѱ�ó���Ǳ� ������ �׳� ��ǥ���� �޸𸮸� ǥ��.
--				cRunTo( nHandle, tPetCoord["x"], tPetCoord["y"], 1000 )
				-- ���ڸ��� �̵��Ѱ�ó�� ǥ��
				PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
				tMode["nActionMode"] = PAM_NONE
				CheckLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_CALL - nHandle( "..nHandle.." )" )
			end

			tMode["nMasterMode"] = PMM_CALL
			DebugLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_CALL - nHandle( "..nHandle.." )" )

		else
			-- ������ �θ��� ����
			if tMode["nActionMode"] <= PAM_FAR_MISSED	-- �� ���� �켱������ ���� �ൿ�ϴ°��� �ƴҶ��� ó���ϱ�.
			then

				if tMode["nActionMode"] <= PAM_FAR_MISSED	-- �� ���� �켱������ ���� �ൿ�ϴ°��� �ƴҶ��� ó���ϱ�.
				then
					local nDistanceSquare = cDistanceSquar( nHandle, nMasterHandle )

					----------------------------------------------------------------------
					---------- //�Ÿ��� Pattern Decision ---------------------------------
					if nDistanceSquare < PS_nDS_AwayStart
					then
						if tMode["nMasterMode"] == PMM_AWAY
						then
							-- ����� ����������� ����� ó��
							local tPetCoord = PetMem["PetInfo"]["Coord"]["Cur"]
--							cRunTo( nHandle, tPetCoord["x"], tPetCoord["y"], 1000 )
							PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
							PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
						end

						if tMode["nMasterMode"] ~= PMM_IDLE
						then
							local nWaitIdleActSec = cRandomInt( PetSystem_nSecMinWaitActAtIdle, PetSystem_nSecMaxWaitActAtIdle )

							-- Idle ���� ����
							PetMem["PetInfo"]["Time"]["ExecSaveTendency"]	= PetMem["CurSec"] + PetSystem_nSecWaitSaveTendencyAtIdle
							PetMem["PetInfo"]["Time"]["ExecIdleActMode"]	= PetMem["CurSec"] + nWaitIdleActSec
							CheckLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_IDLE - nHandle( "..nHandle.." )" )
						end

						tMode["nMasterMode"] = PMM_IDLE
						DebugLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_IDLE - nHandle( "..nHandle.." )" )

					elseif nDistanceSquare < PS_nDS_FarStart
					then
						if tMode["nMasterMode"] ~= PMM_AWAY
						then
							-- Away ���� ����

							-- PupCaseDesc ���� �� �������� ����ؼ� ���ڵ� �����ͼ� PAI Ÿ���� Ȯ�� �� Valid �� �� ��ũ��Ʈ �޼����� �������Ʈ, ���带 �߻���Ų��.
							local tPetFollowActRecord = { cPet_GetActionRecord( nHandle, "follow" ) } -- { "PupAITypeString", "SM_Inx", "HairEffect", "SoundFile" }

							if tPetFollowActRecord ~= nil
							then
								if tPetFollowActRecord[ 1 ] == "script"
								then
									if tPetFollowActRecord[ 2 ] ~= "-"
									then
										PetBaseScriptMessage( nHandle, tPetFollowActRecord[ 2 ] )
									end

									if tPetFollowActRecord[ 3 ] ~= "-"
									then
										PetBaseObjectEffect( nHandle, tPetFollowActRecord[ 3 ] )
									end

									if tPetFollowActRecord[ 4 ] ~= "-"
									then
										PetBaseObjectSound( nHandle, tPetFollowActRecord[ 4 ] )
									end

									cExecCheck( "PetBaseRoutine" )

								else
									ErrorLog( "PetBaseRoutine::cPet_GetActionRecord Failed ["..nHandle.."]" );
								end

							else
								ErrorLog( "PetBaseRoutine::cPet_GetActionRecord Failed ["..nHandle.."]" );
							end

							CheckLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_AWAY - nHandle( "..nHandle.." )" )
						end

						tMode["nMasterMode"] = PMM_AWAY
						DebugLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_AWAY - nHandle( "..nHandle.." )" )

					else
						if tMode["nMasterMode"] == PMM_AWAY or tMode["nMasterMode"] == PMM_IDLE
						then
							-- �ʹ� �־������� �����ó��
							local tPetCoord = PetMem["PetInfo"]["Coord"]["Cur"]
--							cRunTo( nHandle, tPetCoord["x"], tPetCoord["y"], 1000 )
							PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
							PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
						end

						if tMode["nMasterMode"] ~= PMM_FAR
						then
							-- Far ���� ����
							PetMem["PetInfo"]["Time"]["EnterFarIdle"]		= PetMem["CurSec"]
							CheckLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_FAR - nHandle( "..nHandle.." )" )
						end

						tMode["nMasterMode"] = PMM_FAR
						DebugLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_FAR - nHandle( "..nHandle.." )" )

					end
					---------- �Ÿ��� Pattern Decision// ---------------------------------
					----------------------------------------------------------------------
				end
			end

		end


	elseif sMasterMode == "logoutwait"
	then
		-- �α׾ƿ���� : �̰� ���� �˾ƺ���
	else
		-- �̻��� ���ϰ� : ���� �����Ƿ� ������
	end


DebugLog( "PetBaseRoutine:: Point 2 - �ൿ�ϰ� �ִ� �Ϳ� ����.." )
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
------ ������ ������ ��忡 ���� �ൿ ó��
	if tMode["nMasterMode"] == PMM_IDLE	-----------------------------------------------------------------------------------------------------------PMM_IDLE
	then
		-- ���̵� �ð� ī���� 2���� �ϱ�

		-- �ൿ Ÿ�ӿ� �ൿ ����
		if PetMem["PetInfo"]["Time"]["ExecIdleActMode"] < PetMem["CurSec"]
		then
			-- �ൿ�� �ð��� ����
			--local tPetIdleActRecord = { cPet_GetActionRecord( nHandle, "idle" ) } -- { "PupAITypeString", "SM_Inx", "HairEffect", "SoundFile" }

			if PetMem["PetInfo"]["tCurIdleActRecord"] == nil
			then
				PetMem["PetInfo"]["tCurIdleActRecord"] = { cPet_GetActionRecord( nHandle, "idle" ) }
			end

			--if tPetIdleActRecord ~= nil
			if PetMem["PetInfo"]["tCurIdleActRecord"] ~= nil
			then
				if PetBaseIdleAction( PetMem, PetMem["PetInfo"]["tCurIdleActRecord"] ) == false
				then
					ErrorLog( "PetBaseRoutine::PetBaseIdleAction Failed ["..nHandle.."]" );
				end
				cExecCheck( "PetBaseRoutine" )
			else
				ErrorLog( "PetBaseRoutine::cPet_GetActionRecord Failed ["..nHandle.."]" );
			end

			-- �ൿ���·� ����
			tMode["nActionMode"] = PAM_IDLE_ACT
			DebugLog( "PetBaseRoutine::PET_ACTION_MODE-PAM_IDLE_ACT - nHandle( "..nHandle.." )" )

		else
			tMode["nActionMode"] = PAM_IDLE_WAIT
			DebugLog( "PetBaseRoutine::PET_ACTION_MODE-PAM_IDLE_WAIT - nHandle( "..nHandle.." )" )

		end

		-- ���� Ÿ�ӿ� ���� ��û
		if PetMem["PetInfo"]["Time"]["ExecSaveTendency"] < PetMem["CurSec"]
		then
			-- ������ �ð��� ����
			if cPet_SaveTendency( nHandle ) == nil
			then
				ErrorLog( "PetBaseRoutine::cPet_SaveTendency Failed ["..nHandle.."]" )
			else
				CheckLog( "PetBaseRoutine::cPet_SaveTendency Failed ["..nHandle.."]" )
			end

			PetMem["PetInfo"]["Time"]["ExecSaveTendency"] = PetMem["CurSec"] + PetSystem_nSecWaitSaveTendencyAtIdle
		end

	elseif tMode["nMasterMode"] == PMM_AWAY	-----------------------------------------------------------------------------------------------------------PMM_AWAY
	then
		-- ������ ������ �̵�
		local tMasterCoord = PetMem["MasterInfo"]["Coord"]["Cur"]
		local tTargetCoord = {}
		tTargetCoord["x"], tTargetCoord["y"] = cGetCoord_Circle( tMasterCoord["x"], tMasterCoord["y"], PetSystem_nDistanceFollowingStop )

		if tTargetCoord["x"] ~= nil
		then
			cRunTo( nHandle, tTargetCoord["x"], tTargetCoord["y"], PetSystem_nSpeedRateFollowingMil )
			PetMem["PetInfo"]["Coord"]["Next"]["x"] = tTargetCoord["x"]
			PetMem["PetInfo"]["Coord"]["Next"]["y"] = tTargetCoord["y"]
		else
			ErrorLog( "Following Move Target Coord is not Found" )-- ���и޼���
		end
	elseif tMode["nMasterMode"] == PMM_FAR	-----------------------------------------------------------------------------------------------------------PMM_FAR
	then
		-- �̵� �ϴ��� ���߰� ���� ��(������ ó��) �ð� ī����

		-- �ʹ� �־����� �� �Ҿ� ������� �ð� üũ �� ��ȯ ���� ó��
		if PetMem["PetInfo"]["Time"]["EnterFarIdle"] + PetSystem_nSecWaitMissingAtFar < PetMem["CurSec"]
		then
			-- ��ȯ ���� ��û
			if cPet_Unsummon( nMasterHandle ) == nil
			then
				-- ��ȯ������ ���� ���� : �ɰ��� ���� ó��
			end

			-- AI ��ũ��Ʈ ����
			cAIScriptSet( nHandle )

			-- �޸� ����
			gPetAIMemory["PetBase"][ nHandle ] = nil

			DebugLog( "PetBaseRoutine::Pet Has Unsummoned - nHandle( "..nHandle.." )" )

			return ReturnAI["END"]

		end


	elseif tMode["nMasterMode"] == PMM_CALL	-----------------------------------------------------------------------------------------------------------PMM_CALL
	then
		-- ������ Ȥ�� ��ǥ ���� ������ �̵� �� �Ĵٺ���
		local tPetCoord 	= PetMem["PetInfo"]["Coord"]["Cur"]
		local tDestCoord 	= PetMem["PetInfo"]["Coord"]["Next"]
		local tMasterCoord 	= PetMem["MasterInfo"]["Coord"]["Cur"]

		local nCallingDistanceSquare 	= cDistanceSquar( tPetCoord["x"], tPetCoord["y"], tDestCoord["x"], tDestCoord["y"] )
		local nFollowingDistanceSquare 	= cDistanceSquar( nHandle, nMasterHandle )

		local nDistanceSquare

		-- �ҷ��� �����ִٸ� �� ��ǥ���������� �Ÿ��� ����
		-- �װ� �ƴ϶�� ���� �����Ϳ��� �Ÿ��� ����.
		if tMode["nActionMode"] == PAM_CALL_COME
		then
			nDistanceSquare = nCallingDistanceSquare
		else
			nDistanceSquare = nFollowingDistanceSquare
		end


		if tMode["nActionMode"] == PAM_CALL_SEE
		then
			-- ������ �ð���ŭ�� ������ �Ĵٺ���.
			if PetMem["PetInfo"]["Time"]["LastEnterStayAtCallSee"] + PetSystem_nSecStayAtCallSee < PetMem["CurSec"]
			then
				-- ��� ��� ���
				tMode["nMasterMode"] = PMM_NONE
				tMode["nActionMode"] = PAM_NONE
			end

			-- �Ĵٺ���
			cSetObjectDirect( nHandle, tMasterCoord["x"], tMasterCoord["y"] )
			-- ����ǥ��
			--?????????????????????????????????????????????????????

		else
			----------------------------------------------------------------------
			---------- //�Ÿ��� Pattern Decision ---------------------------------
			if nDistanceSquare < PS_nDS_CallingStop
			then
				-- ����������� �����Ѱ��̴�.
				if tMode["nActionMode"] == PAM_CALL_COME
				then
					-- ����� ����������� �����ó��
					local tPetCoord = PetMem["PetInfo"]["Coord"]["Cur"]
--					cRunTo( nHandle, tPetCoord["x"], tPetCoord["y"], 1000 )
					PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
					PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
				end

				if tMode["nActionMode"] ~= PAM_CALL_SEE
				then
					PetMem["PetInfo"]["Time"]["LastEnterStayAtCallSee"] = PetMem["CurSec"]

					-- ���� �Ĵٺ��� ���� ���� : ���ʳ� �Ĵٺ�??????????????????????????????????
					-- �� ��Ȳ�� ��� ó������ �߰� ���� �ʿ�
				end


				tMode["nActionMode"] = PAM_CALL_SEE
				DebugLog( "PetBaseRoutine::PET_ACTION_MODE-PAM_CALL_SEE - nHandle( "..nHandle.." )" )

			else

				if tMode["nActionMode"] ~= PAM_CALL_COME
				then
					-- ������ �θ��� �̵��ϱ� ���� ����
					-- ������ ������ �̵� : ������ �θ� ����, �� �ѹ��� üũ�Ͽ� �̵��Ѵ�. �θ���ġ�� �ƴ°��� ������ ��ġ�� �ƴ°� �ƴ�.
					local tMasterCoord = PetMem["MasterInfo"]["Coord"]["Cur"]
					local tTargetCoord = {}
					tTargetCoord["x"], tTargetCoord["y"] = cGetCoord_Circle( tMasterCoord["x"], tMasterCoord["y"], PetSystem_nDistanceCallingStop )

					if tTargetCoord["x"] ~= nil
					then
						cRunTo( nHandle, tTargetCoord["x"], tTargetCoord["y"], PetSystem_nSpeedRateCallingMil )
						PetMem["PetInfo"]["Coord"]["Next"]["x"] = tTargetCoord["x"]
						PetMem["PetInfo"]["Coord"]["Next"]["y"] = tTargetCoord["y"]
					else
						ErrorLog( "Calling Move Target Coord is not Found" )-- ���и޼���
					end

				end

				tMode["nActionMode"] = PAM_CALL_COME
				DebugLog( "PetBaseRoutine::PET_ACTION_MODE-PAM_CALL_COME - nHandle( "..nHandle.." )" )

			end
			---------- �Ÿ��� Pattern Decision// ---------------------------------
			----------------------------------------------------------------------
		end


	elseif tMode["nMasterMode"] == PMM_DIE	-----------------------------------------------------------------------------------------------------------PMM_DIE
	then
		-- ������ Ȥ�� ��ǥ ���� ������ �̵� �� �Ĵٺ���
		local tPetCoord 	= PetMem["PetInfo"]["Coord"]["Cur"]
		local tDestCoord 	= PetMem["PetInfo"]["Coord"]["Next"]
		local tMasterCoord 	= PetMem["MasterInfo"]["Coord"]["Cur"]

		local nDiedDistanceSquare 		= cDistanceSquar( tPetCoord["x"], tPetCoord["y"], tDestCoord["x"], tDestCoord["y"] )
		local nFollowingDistanceSquare 	= cDistanceSquar( nHandle, nMasterHandle )

		local nDistanceSquare

		-- �ҷ��� �����ִٸ� �� ��ǥ���������� �Ÿ��� ����
		-- �װ� �ƴ϶�� ���� �����Ϳ��� �Ÿ��� ����.
		if tMode["nActionMode"] == PAM_DIE_COME
		then
			nDistanceSquare = nDiedDistanceSquare
		else
			nDistanceSquare = nFollowingDistanceSquare
		end


		if tMode["nActionMode"] == PAM_DIE_SAD
		then
			-- ������ �ð���ŭ�� ���� ������ �Ĵٺ��� �����Ѵ�.
			if PetMem["PetInfo"]["Time"]["LastEnterStayAtDiedSad"] + PetSystem_nSecStayAtDiedSad < PetMem["CurSec"]
			then
				-- ��� ��� ���
				tMode["nMasterMode"] = PMM_NONE
				tMode["nActionMode"] = PAM_NONE
			end
			-- �Ĵٺ���
			cSetObjectDirect( nHandle, tMasterCoord["x"], tMasterCoord["y"] )
			-- �����ϱ�� ���μ� ǥ��

		else
			----------------------------------------------------------------------
			---------- //�Ÿ��� Pattern Decision ---------------------------------
			if nDistanceSquare < PS_nDS_DiedStop
			then
				-- ����������� �����Ѱ��̴�.
				if tMode["nActionMode"] == PAM_DIE_COME
				then
					-- ����� ����������� ���߱�
					local tPetCoord = PetMem["PetInfo"]["Coord"]["Cur"]
--					cRunTo( nHandle, tPetCoord["x"], tPetCoord["y"], 1000 )
					PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
					PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
				end

				if tMode["nActionMode"] ~= PAM_DIE_SAD
				then
					-- ���� ���� ���� : �Ұž��� ������ƾ���� ������
					PetMem["PetInfo"]["Time"]["LastEnterStayAtDiedSad"] = PetMem["CurSec"]
					CheckLog( "PetBaseRoutine::PET_ACTION_MODE-PAM_DIE_SAD - nHandle( "..nHandle.." )" )
				end


				tMode["nActionMode"] = PAM_DIE_SAD
				DebugLog( "PetBaseRoutine::PET_ACTION_MODE-PAM_DIE_SAD - nHandle( "..nHandle.." )" )

			else

				if tMode["nActionMode"] ~= PAM_DIE_COME
				then
					-- ������ �θ��� �̵��ϱ� ���� ����
					-- ������ ������ �̵� : ������ �θ� ����, �� �ѹ��� üũ�Ͽ� �̵��Ѵ�. �θ���ġ�� �ƴ°��� ������ ��ġ�� �ƴ°� �ƴ�.
					local tMasterCoord = PetMem["MasterInfo"]["Coord"]["Cur"]
					local tTargetCoord = {}
					tTargetCoord["x"], tTargetCoord["y"] = cGetCoord_Circle( tMasterCoord["x"], tMasterCoord["y"], PetSystem_nDistanceDiedStop )

					if tTargetCoord["x"] ~= nil
					then
						cRunTo( nHandle, tTargetCoord["x"], tTargetCoord["y"], PetSystem_nSpeedRateMasterDiedMil )
						PetMem["PetInfo"]["Coord"]["Next"]["x"] = tTargetCoord["x"]
						PetMem["PetInfo"]["Coord"]["Next"]["y"] = tTargetCoord["y"]
					else
						ErrorLog( "Master Died Move Target Coord is not Found" )-- ���и޼���
					end

					CheckLog( "PetBaseRoutine::PET_ACTION_MODE-PAM_DIE_COME - nHandle( "..nHandle.." )" )
				end

				tMode["nActionMode"] = PAM_DIE_COME
				DebugLog( "PetBaseRoutine::PET_ACTION_MODE-PAM_DIE_COME - nHandle( "..nHandle.." )" )

			end
			---------- �Ÿ��� Pattern Decision// ---------------------------------
			----------------------------------------------------------------------
		end

	elseif tMode["nMasterMode"] == PMM_LINK	-----------------------------------------------------------------------------------------------------------PMM_LINK
	then
		tMode["nActionMode"] = PAM_LINK

	else
		-- ���� �ȵ� ����̰ų� �ƹ��͵� �ƴϰų�..
	end

	-- ���� ���� AI �� ����
	return ReturnAI["CPP"]
end
