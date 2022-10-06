
function IsPetMasterMoved( PetMem )
	cExecCheck( "IsPetMasterMoved" )

	if PetMem == nil
	then
		DebugLog( "IsPetMasterMoved::PetMem is nil" )
		return nil
	end

	local tMasterCoord 		= PetMem["MasterInfo"]["Coord"]["Cur"]
	local tMasterLastCoord 	= PetMem["MasterInfo"]["Coord"]["Last"]

	if tMasterLastCoord["x"] ~= tMasterCoord["x"]
	then
		return true
	end

	if tMasterLastCoord["y"] ~= tMasterCoord["y"]
	then
		return true
	end

	return false
end


function PetBaseScriptMessage( nHandle, sScriptMessageIndex )
	cExecCheck( "PetBaseScriptMessage" )

	-- 펫이 말을 한다.
	if sScriptMessageIndex ~= "-"
	then
		-- 말하는 행동을 빼고는 타이밍 관계 없이 첫 스텝에 말을 한다.
		cSimpleChatScriptMsg( nHandle, sScriptMessageIndex );	-- 아직 구현 안됨

	end

end


function PetBaseObjectEffect( nHandle, sObjectEffectFileName )
	cExecCheck( "PetBaseObjectEffect" )

	-- 펫에 헤어이펙트 떠
	if sObjectEffectFileName ~= "-"
	then
		-- 데이터 추가되면 구현할것
		cObjectEffect( nHandle, sObjectEffectFileName );
	end

end


function PetBaseObjectSound( nHandle, sObjectSoundFileName )
	cExecCheck( "PetBaseObjectSound" )

	-- 펫 행동에 사운드 붙여
	if sSoundFile ~= "-"
	then
		-- 데이터 추가되면 타이밍에 맞춰서 소리가 나오도록 테스트 하며 구현할 것
		cObjectSound( nHandle, sObjectSoundFileName );
	end
end
