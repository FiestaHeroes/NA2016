--------------------------------------------------------------------------------
--                   Promote Job2_Gamb Sub Functions                          --
--------------------------------------------------------------------------------

function DummyFunc( Var )
cExecCheck "DummyFunc"
end


----------------------------------------------------------------------
-- DiceLightOff : 모든 주사위 불 끄기
----------------------------------------------------------------------

function DiceLightOff( Var )
cExecCheck( "DiceLightOff" )
	---- DebugLog( "SubFunc _ DiceLightOff Start" )

	if Var == nil or Var["Dice"]["Handle"] == nil
	then
		ErrorLog( "DiceLightOff::Var == nil" );
		return
	end

	for i =1, #Var["Dice"]["Handle"]
	do
		cAnimate( Var["Dice"]["Handle"][i], "start", AnimationInfo["Dice"]["AniOff"] )
	end
end


----------------------------------------------------------------------
-- FindDiceNum : 핸들에 맞는 주사위번호 찾아주는 함수
----------------------------------------------------------------------

function FindDiceNum( Var )
cExecCheck( "FindDiceNum" )

	-- DebugLog( "SubFunc _ FindDiceNum Start" )

	if Var == nil
	then
		ErrorLog( "FindDiceNum::Var == nil" );
		return
	end

	local PlayRouletteGameInfo 		= Var["PlayRouletteGame"]

	if PlayRouletteGameInfo == nil
	then
		ErrorLog( "FindDiceNum::PlayRouletteGameInfo == nil" );
		return
	end

	local FindCurDiceHandle			= PlayRouletteGameInfo["SelectedDiceHandle"]

	for i = 1, #Var["Dice"]["Handle"]
	do
		if FindCurDiceHandle == Var["Dice"]["Handle"][i]
		then
			PlayRouletteGameInfo["SelectedDiceNum"] 		= i
			-- DebugLog( "PlayRouletteGameInfo[\"SelectedDiceNum\"] : "..PlayRouletteGameInfo["SelectedDiceNum"] )
		end
	end
end


----------------------------------------------------------------------
-- SetAnswerDice : 룰렛이 주사위 몇번 선택할지 랜덤처리하는 함수
----------------------------------------------------------------------

function SetAnswerDice( Var )
cExecCheck( "SetAnswerDice" )

	-- DebugLog( "SubFunc _ SetAnswerDice Start" )

	if Var == nil
	then
		ErrorLog( "SetAnswerDice::Var == nil" );
		return
	end

	if Var["PlayRouletteGame"]["SelectedDiceNum"] == nil
	then
		ErrorLog( "SetAnswerDice::SelectedDiceNum == nil" );
		return
	end

	-- DebugLog("현재 룰렛 굴린 횟수 : "..Var["RouletteCount"] )

	-- 룰렛이 멈출 번호를 먼저 랜덤으로 고른다(시도횟수가 10번 이상인 경우는 100% 당첨)
	if Var["RouletteCount"] >= ROULETTEGAME_PLAY_NUM
	then
		Var["PlayRouletteGame"]["AnswerDiceNum"]		= Var["PlayRouletteGame"]["SelectedDiceNum"]
		-- DebugLog( "ROULETTEGAME_PLAY_NUM 보다 많이 시도, 100% 당첨")
	else
		Var["PlayRouletteGame"]["AnswerDiceNum"]		= cRandomInt( 1, 6 )
	end
	-- DebugLog( "룰렛이 택한 주사위는 : "..Var["PlayRouletteGame"]["AnswerDiceNum"] )
end


----------------------------------------------------------------------
-- VanishMob : 지정된 몹을 맵에서 삭제(fadeout)한다
----------------------------------------------------------------------

function VanishMob( Var )
cExecCheck( "VanishMob" )
	for i = 1, #RegenInfo["MobList"]
	do
		cVanishAll( Var["MapIndex"], RegenInfo["MobList"][i] )
	end
end


----------------------------------------------------------------------
-- IsTimeOver : 타이머 체크
----------------------------------------------------------------------

function IsTimeOver( Var )
cExecCheck( "IsTimeOver" )

	if Var == nil
	then
		ErrorLog( "IsTimeOver::Var == nil" )
		return
	end

	if Var["LimitTime"] == nil
	then
		ErrorLog( "IsTimeOver::Var[\"LimitTime\"] == nil" )
		return
	end

	if Var["CurSec"] == nil
	then
		ErrorLog( "IsTimeOver::Var[\"CurSec\"] == nil" )
		return
	end

	if Var["LimitTime"] == "NoLimit"
	then
		-- DebugLog( "SubFunc _ IsTimeOver : 퀘스트 성공/실패로, 제한시간 의미없어짐" )
		return false
	elseif Var["LimitTime"] < Var["CurSec"]
	then
		-- DebugLog( "SubFunc _ IsTimeOver : 시간초과" )
		return true
	else
		return false
	end
end


----------------------------------------------------------------------
-- IsFail : Fail 인지 체크
----------------------------------------------------------------------

function IsFail( Var )
cExecCheck( "IsFail" )

	if Var == nil
	then
		ErrorLog( "IsFail::Var == nil" )
		return
	end

	-- Fail Case : 맵에 유저가 없음
	if cGetPlayerList( Var["MapIndex"] ) == nil
	then
		-- DebugLog( "IsFail : 맵에 유저 없음" )
		Var["StepFunc"] 	= QuestFailed
		return true
	end

	-- Fail Case : 유저가 죽은 경우
	if cIsObjectDead( Var["PlayerHandle"] ) == 1
	then
		-- DebugLog("IsFail : 유저가 죽음")
		Var["StepFunc"] 	= QuestFailed
		return true
	end

	-- Fail Case : 타임 오버
	if IsTimeOver( Var ) == true
	then
		-- DebugLog("IsFail : TimeOver")
		Var["StepFunc"] 	= QuestFailed
		return true
	end
end


------------------------------------------------------
-- Roulette_Click : 룰렛 클릭되었을때 작동하는 함수
------------------------------------------------------

function Roulette_Click( NPCHandle, PlyHandle )
cExecCheck ( "Roulette_Click" )

	-- DebugLog("룰렛 선택!")

	if NPCHandle == nil
	then
		ErrorLog( "Roulette_Click::RouletteHandle == nil" )
		return
	end

	if PlyHandle == nil
	then
		ErrorLog( "Roulette_Click::RouletteHandle == nil" )
		return
	end

	local MapIndex = cGetCurMapIndex( NPCHandle )

	if MapIndex == nil
	then
		ErrorLog( "Roulette_Click::MapIndex == nil" )
		return
	end

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		ErrorLog( "Roulette_Click::Var == nil" )
		return
	end

	if Var["Roulette"] == nil
	then
		ErrorLog( "Roulette_Click::Var[\"Roulette\"] == nil" )
		return
	end

	if Var["Roulette"]["Handle"] == nil
	then
		ErrorLog( "Roulette_Click::Var[\"Roulette\"][Handle] == nil" )
		return
	end

	if NPCHandle ~= Var["Roulette"]["Handle"]
	then
		ErrorLog( "클릭한 룰렛이랑, 리젠시켜놓은 실제 룰렛 핸들값이 다른경우" )
		return
	end

	local PlayRouletteGameInfo 	= Var["PlayRouletteGame"]

	if PlayRouletteGameInfo == nil
	then
		ErrorLog( "Roulette_Click::Var[\"PlayRouletteGame\"] == nil" )
		return
	end

	-- 주사위,룰렛 모두 클릭되었다면, 추가적인 룰렛 클릭 무시
	if PlayRouletteGameInfo["ReadyToGame"] == true
	then
		---- DebugLog("이미 다 선택되었기에, 클릭 무시")
		return
	end

	PlayRouletteGameInfo["RouletteHandle"]	= NPCHandle

	-- 주사위 먼저 클릭하지않고, 룰렛 클릭한 경우
	if PlayRouletteGameInfo["SelectedDiceHandle"] == nil
	then
		cMobDialog( Var["MapIndex"], ChatInfo["Roulette_Click"]["SpeakerIndex"], ChatInfo["ScriptFileName"], ChatInfo["Roulette_Click"]["MsgIndex"] )
		return
	end

	if PlayRouletteGameInfo["SelectedDiceNum"] < 1 or PlayRouletteGameInfo["SelectedDiceNum"] > 6
	then
		ErrorLog( "1~6을 벗어난 주사위번호" )
		return
	end

	-- 규칙에 맞게 룰렛 클릭한 경우
	PlayRouletteGameInfo["ReadyToGame"] = true

	return
end


------------------------------------------------------
-- Dice_Click : 주사위 클릭되었을때 작동하는 함수
------------------------------------------------------

function Dice_Click( NPCHandle, PlyHandle )
cExecCheck ( "Dice_Click" )

	if NPCHandle == nil
	then
		ErrorLog( "Dice_Click::DiceHandle == nil" )
		return
	end

	if PlyHandle == nil
	then
		ErrorLog( "Dice_Click::PlyHandle == nil" )
		return
	end

	local MapIndex = cGetCurMapIndex( NPCHandle )

	if MapIndex == nil
	then
		ErrorLog( "Dice_Click::MapIndex == nil" )
		return
	end

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		ErrorLog( "Dice_Click::Var == nil" )
		return
	end

	if Var["Dice"] == nil
	then
		ErrorLog( "Dice_Click::Var[\"Dice\"] == nil" )
		return
	end

	if Var["Dice"]["Handle"] == nil
	then
		ErrorLog( "Dice_Click::Var[\"Dice\"][Handle] == nil" )
		return
	end

	local PlayRouletteGameInfo = Var["PlayRouletteGame"]

	if PlayRouletteGameInfo == nil
	then
		ErrorLog( "Dice_Click::Var[\"PlayRouletteGame\"] == nil" )
		return
	end

	-- 주사위,룰렛 모두 클릭되었다면, 추가적인 주사위 클릭 무시
	if PlayRouletteGameInfo["ReadyToGame"] == true
	then
		---- DebugLog("이미 다 선택되었기에, 클릭 무시")
		return
	end

	-- 선택한 주사위 핸들값 저장
	PlayRouletteGameInfo["SelectedDiceHandle"] 		= NPCHandle
	-- DebugLog( "Your Selected DiceHandle : "..PlayRouletteGameInfo["SelectedDiceHandle"] )

	-- 선택한 주사위 핸들값 받아, 몇번 주사위인지 검색
	FindDiceNum	( Var )

	-- 모든 주사위 불 끄기
	DiceLightOff( Var )

	-- 선택한 주사위 불키기
	cAnimate( PlayRouletteGameInfo["SelectedDiceHandle"], "start", AnimationInfo["Dice"]["AniOn"] )

	return
end


----------------------------------------------------------------------
-- Log Functions
----------------------------------------------------------------------

function GoToFail( Var, Msg )
cExecCheck( "GoToFail" )

	if Var == nil
	then
		ErrorLog( "GoToFail : Var nil" );
		return
	end

	ErrorLog( Msg )

	-- 모든 객체 삭제
	if Var["Door"]["Handle"]  ~= nil
	then
		for i = 1, #Var["Door"]["Handle"]
		do
			cNPCVanish( Var["Door"]["Handle"][i] )
		end
	end

	if Var["Roulette"]["Handle"] ~= nil
	then
		cNPCVanish( Var["Roulette"]["Handle"] )
	end

	if Var["Dice"]["Handle"] ~= nil
	then
		for i = 1, #Var["Dice"]["Handle"]
		do
			cNPCVanish( Var["Door"]["Handle"][i] )
		end
	end

	if Var["NPC"]["Handle"] ~= nil
	then
		cNPCVanish( Var["NPC"]["Handle"] )
	end

	Var["StepFunc"] = ReturnToHome
end


----------------------------------------------------------------------
-- Log Functions
----------------------------------------------------------------------

function DebugLog( String )
cExecCheck ( "-- DebugLog" )

	if String == nil
	then
		cAssertLog( "-- DebugLog::String == nil" )
		return
	end
	cAssertLog( "Debug - "..String )
end


function ErrorLog( String )
cExecCheck ( "ErrorLog" )

	if String == nil
	then
		cAssertLog( "ErrorLog::String == nil" )
		return
	end
	cAssertLog( "Error - "..String )
end
