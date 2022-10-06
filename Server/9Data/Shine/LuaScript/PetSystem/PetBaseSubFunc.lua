
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

	-- ���� ���� �Ѵ�.
	if sScriptMessageIndex ~= "-"
	then
		-- ���ϴ� �ൿ�� ����� Ÿ�̹� ���� ���� ù ���ܿ� ���� �Ѵ�.
		cSimpleChatScriptMsg( nHandle, sScriptMessageIndex );	-- ���� ���� �ȵ�

	end

end


function PetBaseObjectEffect( nHandle, sObjectEffectFileName )
	cExecCheck( "PetBaseObjectEffect" )

	-- �꿡 �������Ʈ ��
	if sObjectEffectFileName ~= "-"
	then
		-- ������ �߰��Ǹ� �����Ұ�
		cObjectEffect( nHandle, sObjectEffectFileName );
	end

end


function PetBaseObjectSound( nHandle, sObjectSoundFileName )
	cExecCheck( "PetBaseObjectSound" )

	-- �� �ൿ�� ���� �ٿ�
	if sSoundFile ~= "-"
	then
		-- ������ �߰��Ǹ� Ÿ�ֿ̹� ���缭 �Ҹ��� �������� �׽�Ʈ �ϸ� ������ ��
		cObjectSound( nHandle, sObjectSoundFileName );
	end
end
