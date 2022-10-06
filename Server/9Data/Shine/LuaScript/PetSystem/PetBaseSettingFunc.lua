--------------------------------------------------------------------------------
--                        Pet Setting Function File                           --
--------------------------------------------------------------------------------

function PetBaseInitIdleAction( PetMem )
	cExecCheck( "PetBaseInitIdleAction" )

	if PetMem == nil
	then
		ErrorLog( "PetBaseInitIdleAction::PetMem == nil" )
		return false
	end

	PetMem["PetInfo"]["PetMode"]["nIdleActionMode"]		= PIAM_INVALID	-- PetCommon ����

	-- ���� ��� ����
	PetMem["PetInfo"]["bCurIdleStepActionDone"]	= nil			-- true / false
	PetMem["PetInfo"]["nIdleStep"]				= 0	-- 1���� ��ȿ : ���� ����
	PetMem["PetInfo"]["nIdleEndStep"]			= 0	-- 1���� ��ȿ : �� ���ܱ��� ������ ���� �� �ʱ�ȭ
	PetMem["PetInfo"]["nIdleStepActionType"]	= PISAT_INVALID -- PetCommon ����
	PetMem["PetInfo"]["nNextIdleStepType"]		= PNIST_INVALID	-- PetCommon ����
	PetMem["PetInfo"]["nNextIdleStepDistance"]	= 0
	PetMem["PetInfo"]["dNextIdleStepTime"]		= PetMem["InitialSec"]

	-- �� ��� ����
	PetMem["PetInfo"]["nCurDanceNo"]			= 0
	PetMem["PetInfo"]["Time"]["DanceStartTime"]		= PetMem["InitialSec"]

	-- �׼� ���� �ð� �ʱ�ȭ
	PetMem["PetInfo"]["Time"]["EnterIdleAction"]	= PetMem["InitialSec"]

	-- ��ǥ ��ǥ �ʱ�ȭ
	PetMem["PetInfo"]["Coord"]["Next"]["x"] = PetMem["PetInfo"]["Coord"]["Cur"]["x"]
	PetMem["PetInfo"]["Coord"]["Next"]["y"] = PetMem["PetInfo"]["Coord"]["Cur"]["y"]

	-- ���̵� ���¿��� ���� ���õ� ���̺�
	PetMem["PetInfo"]["tCurIdleActRecord"]	= nil

	return true

end


-- �� ������ ����
-- ������ �ڵ� �������� ����(���϶�)ok
-- ������ ĳ����ȣ �������� �Լ� �����(������)ok
-- ������ ��ġ �������� ( �ڵ��)ok
-- ������ ĳ�� ��� �������� �Լ� �����( ������ )ok
function PetBaseInitMaster( PetMem )
	cExecCheck( "PetBaseInitMaster" )

	if PetMem == nil
	then
		ErrorLog( "PetBaseInitMaster::PetMem == nil" )
		return false
	end

	if PetMem["MasterInfo"] == nil
	then
		PetMem["MasterInfo"] = {}
	end

	local nMasterHandle = cGetMaster( PetMem["nHandle"] )
	if nMasterHandle == nil
	then
		return false
	end

	local nMasterRegNum = cGetRegistNumber( nMasterHandle )
	if nMasterRegNum == nil
	then
		return false
	end

	local nMasterX, nMasterY = cObjectLocate( nMasterHandle )
	if nMasterX == nil
	then
		return false
	end

	-- ���� �ѹ� ����
	PetMem["MasterInfo"]["nHandle"]			= nMasterHandle
	PetMem["MasterInfo"]["nRegNo"]			= nMasterRegNum

	-- �Ź� ����
	if PetMem["MasterInfo"]["Coord"] == nil
	then
		PetMem["MasterInfo"]["Coord"] = {}
	end
	PetMem["MasterInfo"]["Coord"]["Last"]	= { x = nMasterX, y = nMasterY }	-- �ֱ� ��ƾ������ ������ ��ǥ
	PetMem["MasterInfo"]["Coord"]["Cur"]	= { x = nMasterX, y = nMasterY }	-- ���� ��ƾ������ ������ ��ǥ

	return true

end


-- �� ����
-- �� �ൿ�� ���� �ٸ� ��� ���ε� ��ȭ�� �����ϴ� �Լ� ����� ( ���⼱ enum �� �𸣰� ���������� �˰Բ� )ok
-- �� ���ε�� ��Ʈ������ �������� �Լ�later
-- �� ���ε�� ��Ʈ������ �ൿ�� ���� ���������� �޾ƿ��� �Լ� ( ����, ��ũ ���� ���� )changedok
function PetBaseInitPet( PetMem )
	cExecCheck( "PetBaseInitPet" )

	if PetMem == nil
	then
		ErrorLog( "PetBaseInitPet::PetMem == nil" )
		return false
	end

	local nHandle = PetMem["nHandle"]


	if PetMem["PetInfo"] == nil
	then
		PetMem["PetInfo"] = {}
	end

	local nPetRegNum 	= cGetRegistNumber( nHandle )
	if nPetRegNum == nil
	then
		ErrorLog( "PetBaseInitPet::nPetRegNum == nil" )
		return false
	end

	local nPetX, nPetY 	= cObjectLocate( nHandle )
	if nPetX == nil
	then
		ErrorLog( "PetBaseInitPet::cObjectLocate failed" )
		return false
	end

	local nWalkSpeed 	= cPet_GetWalkSpeed( nHandle )
	local nRunSpeed 	= cPet_GetRunSpeed( nHandle )

	if nWalkSpeed == nil or nRunSpeed == nil
	then
		ErrorLog( "PetBaseInitPet::nWalkSpeed == nil or nRunSpeed == nil" )
		return false
	end

	-- ���� �ѹ� ����
	PetMem["PetInfo"]["nHandle"]			= nHandle
	PetMem["PetInfo"]["nRegNo"]				= nPetRegNum	-- ���� �ȵǾ����� �� ���� ���� ����
	PetMem["PetInfo"]["nSpeedWalk"]			= nWalkSpeed	-- ����Լ� ���ο� �����Ǿ��־ ���� ��� ����
	PetMem["PetInfo"]["nSpeedRun"]			= nRunSpeed		-- ����Լ� ���ο� �����Ǿ��־ ���� ��� ����

	-- �Ź� ����
	if PetMem["PetInfo"]["Coord"] == nil
	then
		PetMem["PetInfo"]["Coord"] = {}
	end
	PetMem["PetInfo"]["Coord"]["Last"]			= { x = nPetX, y = nPetY }	-- �ֱ� ��ƾ������ �� ��ǥ
	PetMem["PetInfo"]["Coord"]["Cur"]			= { x = nPetX, y = nPetY }	-- ���� ��ƾ������ �� ��ǥ
	PetMem["PetInfo"]["Coord"]["Next"]			= { x = nPetX, y = nPetY }	-- �̵���ǥ��ǥ
	PetMem["PetInfo"]["Coord"]["Center"]		= { x = nPetX, y = nPetY }	-- Ư���ൿ�� �߽� ��ǥ

	-- ���� ����
	if PetMem["PetInfo"]["Tendency"] == nil
	then
		PetMem["PetInfo"]["Tendency"] = {}
	end
	PetMem["PetInfo"]["Tendency"]["nMind"]		= 0		-- ����� ������ �ڵ忡���� �����
	PetMem["PetInfo"]["Tendency"]["nStress"]	= 0		-- ����� ������ �ڵ忡���� �����

	if PetMem["PetInfo"]["PetMode"] == nil
	then
		PetMem["PetInfo"]["PetMode"] = {}
	end
	PetMem["PetInfo"]["PetMode"]["nMasterMode"]			= PMM_NONE		-- PetCommon ����
	PetMem["PetInfo"]["PetMode"]["nActionMode"]			= PAM_NONE		-- PetCommon ����
	PetMem["PetInfo"]["PetMode"]["nIdleActionMode"]		= PIAM_INVALID	-- PetCommon ����

	if PetMem["PetInfo"]["Time"] == nil
	then
		PetMem["PetInfo"]["Time"] = {}
	end
	PetMem["PetInfo"]["Time"]["ExecSaveTendency"]		= PetMem["InitialSec"]

	PetMem["PetInfo"]["Time"]["LastEnterStayAtCallSee"]	= PetMem["InitialSec"]
	PetMem["PetInfo"]["Time"]["LastEnterStayAtDiedSad"]	= PetMem["InitialSec"]

	PetMem["PetInfo"]["Time"]["DanceStartTime"]			= PetMem["InitialSec"]

	PetMem["PetInfo"]["Time"]["ExecIdleActMode"]		= PetMem["InitialSec"]
	PetMem["PetInfo"]["Time"]["EnterFarIdle"]			= PetMem["InitialSec"]
	PetMem["PetInfo"]["Time"]["LastActIdleMode"]		= PetMem["InitialSec"]
	PetMem["PetInfo"]["Time"]["EnterIdleAction"]		= PetMem["InitialSec"]	-- Idle Action ���� üũ�뵵

	return true

end


function PetBaseInitTarget( PetMem )
	cExecCheck( "PetBaseInitTarget" )

	if PetMem == nil
	then
		ErrorLog( "PetBaseInitTarget::PetMem == nil" )
		return false
	end

	if PetMem["TargetInfo"] == nil
	then
		PetMem["TargetInfo"] = {}
	end

	-- Idle Action Info for Fix Target
	PetMem["TargetInfo"]["nHandle"]			= -1
	if PetMem["TargetInfo"]["Coord"] == nil
	then
		PetMem["TargetInfo"]["Coord"] = {}
	end
	PetMem["TargetInfo"]["Coord"]["Last"]	= { x = nPetX, y = nPetY }	-- ���� ��� ����
	PetMem["TargetInfo"]["Coord"]["Cur"]	= { x = nPetX, y = nPetY }

	return true

end


function PetBaseInitTargetMaster( PetMem )
	cExecCheck( "PetBaseInitTargetMaster" )

	if PetMem == nil
	then
		ErrorLog( "PetBaseInitTargetMaster::PetMem == nil" )
		return false
	end

	if PetMem["TargetMasterInfo"] == nil
	then
		PetMem["TargetMasterInfo"] = {}
	end

	PetMem["TargetMasterInfo"]["nHandle"] = -1
	if PetMem["TargetMasterInfo"]["Coord"] == nil
	then
		PetMem["TargetMasterInfo"]["Coord"] = {}
	end
	PetMem["TargetMasterInfo"]["Coord"]			= {}
	PetMem["TargetMasterInfo"]["Coord"]["Last"]	= { x = nPetX, y = nPetY }
	PetMem["TargetMasterInfo"]["Coord"]["Cur"]	= { x = nPetX, y = nPetY }

	return true

end


-- �� �޸� ���� ��� �� ����
function PetBaseInit( PetMem, nHandle, sMapIndex )
	cExecCheck( "PetBaseInit" )

	-- �⺻ parameter ����
	PetMem["nHandle"]		= nHandle
	PetMem["sMapIndex"]		= sMapIndex

	PetMem["Func"]			= DummyFunc

	-- ���� �ð� ����
	PetMem["InitialSec"]	= cCurrentSecond()
	PetMem["CurSec"]		= cCurrentSecond()


	if PetBaseInitMaster( PetMem ) ~= true
	then
		ErrorLog( "PetBaseInit::PetBaseInitMaster Failed" )
		return false
	end
	cExecCheck( "PetBaseInit" )


	if PetBaseInitPet( PetMem ) ~= true
	then
		ErrorLog( "PetBaseInit::PetBaseInitPet Failed" )
		return false
	end
	cExecCheck( "PetBaseInit" )


	if PetBaseInitTarget( PetMem ) ~= true
	then
		ErrorLog( "PetBaseInit::PetBaseInitTarget Failed" )
		return false
	end
	cExecCheck( "PetBaseInit" )


	if PetBaseInitTargetMaster( PetMem ) ~= true
	then
		ErrorLog( "PetBaseInit::PetBaseInitTargetMaster Failed" )
		return false
	end
	cExecCheck( "PetBaseInit" )


	if PetBaseInitIdleAction( PetMem ) ~= true
	then
		ErrorLog( "PetBaseInit::PetBaseInitIdleAction Failed" )
		return false
	end
	cExecCheck( "PetBaseInit" )

	return true
end


-- ���� �ð��� ������ �� ���� ���� ������Ʈ( 2013.11.20 ���� ��ǥ�� ������Ʈ�� )
function PetBaseUpdate( PetMem )
	cExecCheck( "PetBaseUpdate" )

	if PetMem == nil
	then
		ErrorLog( "PetBaseUpdate::PetMem == nil" )
		return false
	end

	-- �ʼ��� ��� ----------------------------------------
	-- ������ ��ġ ���� ����
	local nMasterX, nMasterY = cObjectLocate( PetMem["MasterInfo"]["nHandle"] )
	if nMasterX == nil
	then
		return false
	end

	PetMem["MasterInfo"]["Coord"]["Last"]["x"]	= PetMem["MasterInfo"]["Coord"]["Cur"]["x"]
	PetMem["MasterInfo"]["Coord"]["Last"]["y"]	= PetMem["MasterInfo"]["Coord"]["Cur"]["y"]

	PetMem["MasterInfo"]["Coord"]["Cur"]["x"]	= nMasterX
	PetMem["MasterInfo"]["Coord"]["Cur"]["y"]	= nMasterY

	-- �ʼ��� ��� ----------------------------------------
	-- �� ��ġ ���� ����
	local nPetX, nPetY = cObjectLocate( PetMem["PetInfo"]["nHandle"] )
	if nPetX == nil
	then
		return false
	end

	PetMem["PetInfo"]["Coord"]["Last"]["x"]	= PetMem["PetInfo"]["Coord"]["Cur"]["x"]
	PetMem["PetInfo"]["Coord"]["Last"]["y"]	= PetMem["PetInfo"]["Coord"]["Cur"]["y"]

	PetMem["PetInfo"]["Coord"]["Cur"]["x"]	= nPetX
	PetMem["PetInfo"]["Coord"]["Cur"]["y"]	= nPetY

	-- ������ ��� ----------------------------------------
	-- Ÿ�� �� ��ġ ���� ����
	if type( PetMem["TargetInfo"]["nHandle"] ) == "number"
	then
		if PetMem["TargetInfo"]["nHandle"] >= 0
		then
			local nTargetPetX, nTargetPetY = cObjectLocate( PetMem["TargetInfo"]["nHandle"] )
			if nTargetPetX == nil
			then
				Debug( "PetBaseUpdate::Target disappeared" )
				return true
			end

			PetMem["TargetInfo"]["Coord"]["Last"]["x"]	= PetMem["TargetInfo"]["Coord"]["Cur"]["x"]
			PetMem["TargetInfo"]["Coord"]["Last"]["y"]	= PetMem["TargetInfo"]["Coord"]["Cur"]["y"]

			PetMem["TargetInfo"]["Coord"]["Cur"]["x"]	= nTargetPetX
			PetMem["TargetInfo"]["Coord"]["Cur"]["y"]	= nTargetPetY

		end

	end

	-- ������ ��� ----------------------------------------
	-- Ÿ�� �� ������ ��ġ ���� ����
	if type( PetMem["TargetMasterInfo"]["nHandle"] ) == "number"
	then
		if PetMem["TargetMasterInfo"]["nHandle"] >= 0
		then
			local nTargetMasterX, nTargetMasterY = cObjectLocate( PetMem["TargetMasterInfo"]["nHandle"] )
			if nTargetMasterX == nil
			then
				Debug( "PetBaseUpdate::Target Pet Master disappeared" )
				return true
			end

			PetMem["TargetMasterInfo"]["Coord"]["Last"]["x"]	= PetMem["TargetMasterInfo"]["Coord"]["Cur"]["x"]
			PetMem["TargetMasterInfo"]["Coord"]["Last"]["y"]	= PetMem["TargetMasterInfo"]["Coord"]["Cur"]["y"]

			PetMem["TargetMasterInfo"]["Coord"]["Cur"]["x"]		= nTargetMasterX
			PetMem["TargetMasterInfo"]["Coord"]["Cur"]["y"]		= nTargetMasterY

		end

	end

	return true
end

