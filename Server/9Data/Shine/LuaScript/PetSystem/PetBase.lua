--------------------------------------------------------------------------------
--                          Pet Routine Main File                             --
--------------------------------------------------------------------------------

require( "common" )

require( "PetSystem/SubFunc" )
require( "PetSystem/PetCommon" )	-- 사전에 SubFunc 포함 할 것
require( "PetSystem/PetBaseActionData" )

require( "PetSystem/PetBaseSubFunc" )
require( "PetSystem/PetBaseSettingFunc" )
require( "PetSystem/PetBaseIdleActionFunc" )
require( "PetSystem/PetBaseRoutineFunc" )


function PetBase( nHandle, sMapIndex )
	cExecCheck( "PetBase" )

	return PetBaseMain( nHandle, sMapIndex )
end


function PetBaseMain( nHandle, sMapIndex )
	cExecCheck( "PetBaseMain" )

	-- 메모리 확인 및 초기 설정
	if gPetAIMemory == nil
	then
		gPetAIMemory = {}
		DebugLog( "PetBaseMain::Initialized - gPetAIMemory" )
	end

	if gPetAIMemory["PetBase"] == nil
	then
		gPetAIMemory["PetBase"] = {}
		DebugLog( "PetBaseMain::Initialized - gPetAIMemory[\"PetBase\"]" )
	end

	local nInvalidHandle = 65535

	if nHandle == nil or nHandle == nInvalidHandle
	then
		DebugLog( "PetBaseMain::nHandle is nil or invalid" )
		return ReturnAI["END"]
	end

	if sMapIndex == nil
	then
		DebugLog( "PetBaseMain::sMapIndex is nil" )
		return ReturnAI["END"]
	end

	local PetMem = gPetAIMemory["PetBase"][ nHandle ]

	if PetMem == nil
	then
		DebugLog( "PetBaseMain::Initialized Start - gPetAIMemory[\"PetBase\"]["..nHandle.."]" )

		-- 메모리가 없는 경우이므로, 최초 설정을 한다.
		gPetAIMemory["PetBase"][ nHandle ] = {}

		PetMem = gPetAIMemory["PetBase"][ nHandle ]

		if PetBaseInit( PetMem, nHandle, sMapIndex ) == false
		then
			ErrorLog( "PetBaseMain::PetBaseInit Failed : "..nHandle.." "..sMapIndex  )
			gPetAIMemory["PetBase"][ nHandle ] = nil
			cAIScriptSet( nHandle )

			return ReturnAI["END"]
		end

		DebugLog( "PetBaseMain::Initialized End - gPetAIMemory[\"PetBase\"]["..nHandle.."]" )

		PetMem["Func"] = PetBaseRoutine
	else
		-- 루틴 빈도 조절
		if PetMem["CurSec"] + 0.2 > cCurrentSecond()
		then
			return
		else
			PetMem["CurSec"] = cCurrentSecond()
		end

--		DebugLog( "PetBaseMain::Check & Update Start - gPetAIMemory[\"PetBase\"]["..nHandle.."]" )

		-- 메모리가 있는 경우이므로, 마스터핸들 및 등록번호등을 확인한다.
		local bReset = false
		local sReason = ""

		local nMasterHandle = -1
		local nMasterRegNum = -1

		if bReset == false
		then
			nMasterHandle = cGetMaster( nHandle )
			if nMasterHandle == nil
			then
				bReset = true
				sReason = sReason.."nMasterHandle == nil; "
			else
				if PetMem["MasterInfo"]["nHandle"] ~= nMasterHandle
				then
					bReset = true
					sReason = sReason.."nMasterHandle ~= memValue; "
				end
			end
		end

		if bReset == false
		then
			nMasterRegNum = cGetRegistNumber( nMasterHandle )
			if nMasterRegNum == nil
			then
				bReset = true
				sReason = sReason.."nMasterRegNum == nil; "
			else
				if PetMem["MasterInfo"]["nRegNo"] ~= nMasterRegNum
				then
					bReset = true
					sReason = sReason.."nMasterRegNum == memValue; "
				end
			end
		end

		if bReset == false
		then
			if PetBaseUpdate( PetMem ) == false
			then
				ErrorLog( "PetBaseMain::PetBaseUpdate Failed : "..nHandle.." "..sMapIndex  )
				bReset = true
				sReason = sReason.."Update Failed; "
			end
		end

		if bReset == true
		then
			ErrorLog( "PetBaseMain::PetBaseReload Failed by "..sReason.." : "..nHandle.." "..sMapIndex  )
			gPetAIMemory["PetBase"][ nHandle ] = nil
			cAIScriptSet( nHandle )

			return ReturnAI["END"]
		end

--		DebugLog( "PetBaseMain::Check & Update End - gPetAIMemory[\"PetBase\"]["..nHandle.."]" )
		PetMem["Func"] = PetBaseRoutine
	end


	if PetMem["CurSec"] == nil
	then
		PetMem["CurSec"] = cCurrentSecond()
	end



	-- 해당 함수 실행
	PetMem["Func"]( PetMem )

end

