------------------------------------------------------
-- Promote Job2_Forest Main File
------------------------------------------------------

require( "common" )

--[[
require( "Data/Name" ) 										-- 파일경로, 파일이름, 역참조를 위한 네임 테이블
require( "Data/Process" )		    						-- 각종 딜레이타임과 링크 정보, 공지, 퀘스트 등의 진행 관련 데이터
require( "Data/Regen" )										-- 리젠 데이터(그룹, 몹, NPC, 문, 아이템 등의 리젠 종류, 위치 및 속성 관련)
require( "Data/Chat" )										-- 대사 데이터( NPCDlg, 공지 등 )

require( "Functions/SubFunc" )								-- 전체적인 진행에 필요한 각종 Sub Functions
require( "Functions/Routine" )								-- 몹 등에 붙는 AI 관련 루틴들
require( "Functions/Progress" )								-- 각 단계가 정의된 진행 함수들
--]]--

require( "Promote/Job2_Forest/Data/Name" ) 					-- 파일경로, 파일이름, 역참조를 위한 네임 테이블
require( "Promote/Job2_Forest/Data/Process" )		   		-- 각종 딜레이타임과 링크 정보, 공지, 퀘스트 등의 진행 관련 데이터
require( "Promote/Job2_Forest/Data/Regen" )					-- 리젠 데이터(그룹, 몹, NPC, 문, 아이템 등의 리젠 종류, 위치 및 속성 관련)
require( "Promote/Job2_Forest/Data/Chat" )					-- 대사 데이터( NPCDlg, 공지 등 )

require( "Promote/Job2_Forest/Functions/SubFunc" )			-- 전체적인 진행에 필요한 각종 Sub Functions
require( "Promote/Job2_Forest/Functions/Routine" )			-- 몹 등에 붙는 AI 관련 루틴들
require( "Promote/Job2_Forest/Functions/Progress" )			-- 각 단계가 정의된 진행 함수들
--]]--


----------------------------------------------------------------------
-- Main : 메인함수
----------------------------------------------------------------------

function Main( Field )
cExecCheck "Main"

	local Var						= InstanceField[Field]	-- 버퍼

	if Var == nil
	then

		InstanceField[Field]		= {}

		Var							= InstanceField[Field]
		Var["MapIndex"]				= Field
		Var["PlayerHandle"] 		= INVALID_HANDEL

		Var["InitialSec"] 			= cCurrentSecond()
		Var["CurSec"] 	  			= Var["InitialSec"]
		Var["LimitTime"]			= 0
		Var["FindHeroLimitTime"]	= 0

		Var["StepFunc"]				= InitDungeon

		Var["Elderin"]				= nil
		Var["Roumen"]				= nil

		-- 필드 스크립트 설정
		cSetFieldScript				( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc			( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )

	end

	-- 0.5초 마다 실행
	if Var["CurSec"] + 0.5 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end

	Var["StepFunc"] ( Var )
end
