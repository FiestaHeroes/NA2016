--------------------------------------------------------------------------------
--                            Arena Main File                                 --
--------------------------------------------------------------------------------

require( "common" )

require( "KQ/KDArena/Data1/Name" ) 				-- 파일경로, 파일이름, 역참조를 위한 네임 테이블
require( "KQ/KDArena/CommonData/Process" )		-- 각종 딜레이타임과 링크 정보, 공지, 퀘스트 등의 진행 관련 데이터
require( "KQ/KDArena/CommonData/Monster" )		-- 몬스터 정보
require( "KQ/KDArena/CommonData/NPC" )			-- NPC 정보
require( "KQ/KDArena/Data1/Regen" )				-- 리젠 데이터(그룹, 몹, NPC, 문, 아이템 등의 리젠 종류, 위치 및 속성 관련)

require( "KQ/KDArena/Functions/SubFunc" )		-- 전체적인 진행에 필요한 각종 Sub Functions
require( "KQ/KDArena/Functions/Routine" )		-- 몹 등에 붙는 AI 관련 루틴들
require( "KQ/KDArena/Functions/Progress" )		-- 각 단계가 정의된 진행 함수들

require( "KQ/KDArena/KDArena" )					-- 아레나 메인
