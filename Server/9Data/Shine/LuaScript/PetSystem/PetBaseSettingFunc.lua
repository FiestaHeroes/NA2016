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

	PetMem["PetInfo"]["PetMode"]["nIdleActionMode"]		= PIAM_INVALID	-- PetCommon 참조

	-- 스텝 밟기 관련
	PetMem["PetInfo"]["bCurIdleStepActionDone"]	= nil			-- true / false
	PetMem["PetInfo"]["nIdleStep"]				= 0	-- 1부터 유효 : 현재 스텝
	PetMem["PetInfo"]["nIdleEndStep"]			= 0	-- 1부터 유효 : 이 스텝까지 수행후 종료 후 초기화
	PetMem["PetInfo"]["nIdleStepActionType"]	= PISAT_INVALID -- PetCommon 참조
	PetMem["PetInfo"]["nNextIdleStepType"]		= PNIST_INVALID	-- PetCommon 참조
	PetMem["PetInfo"]["nNextIdleStepDistance"]	= 0
	PetMem["PetInfo"]["dNextIdleStepTime"]		= PetMem["InitialSec"]

	-- 댄스 모드 관련
	PetMem["PetInfo"]["nCurDanceNo"]			= 0
	PetMem["PetInfo"]["Time"]["DanceStartTime"]		= PetMem["InitialSec"]

	-- 액션 시작 시간 초기화
	PetMem["PetInfo"]["Time"]["EnterIdleAction"]	= PetMem["InitialSec"]

	-- 목표 좌표 초기화
	PetMem["PetInfo"]["Coord"]["Next"]["x"] = PetMem["PetInfo"]["Coord"]["Cur"]["x"]
	PetMem["PetInfo"]["Coord"]["Next"]["y"] = PetMem["PetInfo"]["Coord"]["Cur"]["y"]

	-- 아이들 상태에서 현재 선택된 테이블
	PetMem["PetInfo"]["tCurIdleActRecord"]	= nil

	return true

end


-- 펫 마스터 정보
-- 마스터 핸들 가져오기 개조(펫일때)ok
-- 마스터 캐릭번호 가져오는 함수 만들기(없으면)ok
-- 마스터 위치 가져오기 ( 핸들로)ok
-- 마스터 캐릭 모드 가져오기 함수 만들기( 없으면 )ok
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

	-- 최초 한번 셋팅
	PetMem["MasterInfo"]["nHandle"]			= nMasterHandle
	PetMem["MasterInfo"]["nRegNo"]			= nMasterRegNum

	-- 매번 셋팅
	if PetMem["MasterInfo"]["Coord"] == nil
	then
		PetMem["MasterInfo"]["Coord"] = {}
	end
	PetMem["MasterInfo"]["Coord"]["Last"]	= { x = nMasterX, y = nMasterY }	-- 최근 루틴에서의 마스터 좌표
	PetMem["MasterInfo"]["Coord"]["Cur"]	= { x = nMasterX, y = nMasterY }	-- 현재 루틴에서의 마스터 좌표

	return true

end


-- 펫 정보
-- 펫 행동에 따라 다른 펫들 마인드 변화값 셋팅하는 함수 만들기 ( 여기선 enum 값 모르고 서버에서만 알게끔 )ok
-- 펫 마인드와 스트레스를 가져오는 함수later
-- 펫 마인드와 스트레스로 행동할 것이 무엇인지를 받아오는 함수 ( 사운드, 헤어링크 포함 가능 )changedok
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

	-- 최초 한번 셋팅
	PetMem["PetInfo"]["nHandle"]			= nHandle
	PetMem["PetInfo"]["nRegNo"]				= nPetRegNum	-- 설정 안되어있을 땐 없을 수도 있음
	PetMem["PetInfo"]["nSpeedWalk"]			= nWalkSpeed	-- 루아함수 내부에 구현되어있어서 아직 사용 안함
	PetMem["PetInfo"]["nSpeedRun"]			= nRunSpeed		-- 루아함수 내부에 구현되어있어서 아직 사용 안함

	-- 매번 셋팅
	if PetMem["PetInfo"]["Coord"] == nil
	then
		PetMem["PetInfo"]["Coord"] = {}
	end
	PetMem["PetInfo"]["Coord"]["Last"]			= { x = nPetX, y = nPetY }	-- 최근 루틴에서의 펫 좌표
	PetMem["PetInfo"]["Coord"]["Cur"]			= { x = nPetX, y = nPetY }	-- 현재 루틴에서의 펫 좌표
	PetMem["PetInfo"]["Coord"]["Next"]			= { x = nPetX, y = nPetY }	-- 이동목표좌표
	PetMem["PetInfo"]["Coord"]["Center"]		= { x = nPetX, y = nPetY }	-- 특정행동의 중심 좌표

	-- 최초 셋팅
	if PetMem["PetInfo"]["Tendency"] == nil
	then
		PetMem["PetInfo"]["Tendency"] = {}
	end
	PetMem["PetInfo"]["Tendency"]["nMind"]		= 0		-- 현재는 존서버 코드에서만 사용함
	PetMem["PetInfo"]["Tendency"]["nStress"]	= 0		-- 현재는 존서버 코드에서만 사용함

	if PetMem["PetInfo"]["PetMode"] == nil
	then
		PetMem["PetInfo"]["PetMode"] = {}
	end
	PetMem["PetInfo"]["PetMode"]["nMasterMode"]			= PMM_NONE		-- PetCommon 참조
	PetMem["PetInfo"]["PetMode"]["nActionMode"]			= PAM_NONE		-- PetCommon 참조
	PetMem["PetInfo"]["PetMode"]["nIdleActionMode"]		= PIAM_INVALID	-- PetCommon 참조

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
	PetMem["PetInfo"]["Time"]["EnterIdleAction"]		= PetMem["InitialSec"]	-- Idle Action 진입 체크용도

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
	PetMem["TargetInfo"]["Coord"]["Last"]	= { x = nPetX, y = nPetY }	-- 아직 사용 안함
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


-- 펫 메모리 안의 모든 값 셋팅
function PetBaseInit( PetMem, nHandle, sMapIndex )
	cExecCheck( "PetBaseInit" )

	-- 기본 parameter 정보
	PetMem["nHandle"]		= nHandle
	PetMem["sMapIndex"]		= sMapIndex

	PetMem["Func"]			= DummyFunc

	-- 최초 시간 셋팅
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


-- 현재 시간을 제외한 펫 관련 정보 업데이트( 2013.11.20 현재 좌표만 업데이트함 )
function PetBaseUpdate( PetMem )
	cExecCheck( "PetBaseUpdate" )

	if PetMem == nil
	then
		ErrorLog( "PetBaseUpdate::PetMem == nil" )
		return false
	end

	-- 필수적 요소 ----------------------------------------
	-- 마스터 위치 정보 갱신
	local nMasterX, nMasterY = cObjectLocate( PetMem["MasterInfo"]["nHandle"] )
	if nMasterX == nil
	then
		return false
	end

	PetMem["MasterInfo"]["Coord"]["Last"]["x"]	= PetMem["MasterInfo"]["Coord"]["Cur"]["x"]
	PetMem["MasterInfo"]["Coord"]["Last"]["y"]	= PetMem["MasterInfo"]["Coord"]["Cur"]["y"]

	PetMem["MasterInfo"]["Coord"]["Cur"]["x"]	= nMasterX
	PetMem["MasterInfo"]["Coord"]["Cur"]["y"]	= nMasterY

	-- 필수적 요소 ----------------------------------------
	-- 펫 위치 정보 갱신
	local nPetX, nPetY = cObjectLocate( PetMem["PetInfo"]["nHandle"] )
	if nPetX == nil
	then
		return false
	end

	PetMem["PetInfo"]["Coord"]["Last"]["x"]	= PetMem["PetInfo"]["Coord"]["Cur"]["x"]
	PetMem["PetInfo"]["Coord"]["Last"]["y"]	= PetMem["PetInfo"]["Coord"]["Cur"]["y"]

	PetMem["PetInfo"]["Coord"]["Cur"]["x"]	= nPetX
	PetMem["PetInfo"]["Coord"]["Cur"]["y"]	= nPetY

	-- 선택적 요소 ----------------------------------------
	-- 타겟 펫 위치 정보 갱신
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

	-- 선택적 요소 ----------------------------------------
	-- 타겟 펫 마스터 위치 정보 갱신
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

