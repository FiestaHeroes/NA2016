--------------------------------------------------------------------------------
--                   Promote Job2_Gamb Sub Functions                          --
--------------------------------------------------------------------------------

function DummyFunc( Var )
cExecCheck "DummyFunc"
end


----------------------------------------------------------------------
-- DiceLightOff : ��� �ֻ��� �� ����
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
-- FindDiceNum : �ڵ鿡 �´� �ֻ�����ȣ ã���ִ� �Լ�
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
-- SetAnswerDice : �귿�� �ֻ��� ��� �������� ����ó���ϴ� �Լ�
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

	-- DebugLog("���� �귿 ���� Ƚ�� : "..Var["RouletteCount"] )

	-- �귿�� ���� ��ȣ�� ���� �������� ����(�õ�Ƚ���� 10�� �̻��� ���� 100% ��÷)
	if Var["RouletteCount"] >= ROULETTEGAME_PLAY_NUM
	then
		Var["PlayRouletteGame"]["AnswerDiceNum"]		= Var["PlayRouletteGame"]["SelectedDiceNum"]
		-- DebugLog( "ROULETTEGAME_PLAY_NUM ���� ���� �õ�, 100% ��÷")
	else
		Var["PlayRouletteGame"]["AnswerDiceNum"]		= cRandomInt( 1, 6 )
	end
	-- DebugLog( "�귿�� ���� �ֻ����� : "..Var["PlayRouletteGame"]["AnswerDiceNum"] )
end


----------------------------------------------------------------------
-- VanishMob : ������ ���� �ʿ��� ����(fadeout)�Ѵ�
----------------------------------------------------------------------

function VanishMob( Var )
cExecCheck( "VanishMob" )
	for i = 1, #RegenInfo["MobList"]
	do
		cVanishAll( Var["MapIndex"], RegenInfo["MobList"][i] )
	end
end


----------------------------------------------------------------------
-- IsTimeOver : Ÿ�̸� üũ
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
		-- DebugLog( "SubFunc _ IsTimeOver : ����Ʈ ����/���з�, ���ѽð� �ǹ̾�����" )
		return false
	elseif Var["LimitTime"] < Var["CurSec"]
	then
		-- DebugLog( "SubFunc _ IsTimeOver : �ð��ʰ�" )
		return true
	else
		return false
	end
end


----------------------------------------------------------------------
-- IsFail : Fail ���� üũ
----------------------------------------------------------------------

function IsFail( Var )
cExecCheck( "IsFail" )

	if Var == nil
	then
		ErrorLog( "IsFail::Var == nil" )
		return
	end

	-- Fail Case : �ʿ� ������ ����
	if cGetPlayerList( Var["MapIndex"] ) == nil
	then
		-- DebugLog( "IsFail : �ʿ� ���� ����" )
		Var["StepFunc"] 	= QuestFailed
		return true
	end

	-- Fail Case : ������ ���� ���
	if cIsObjectDead( Var["PlayerHandle"] ) == 1
	then
		-- DebugLog("IsFail : ������ ����")
		Var["StepFunc"] 	= QuestFailed
		return true
	end

	-- Fail Case : Ÿ�� ����
	if IsTimeOver( Var ) == true
	then
		-- DebugLog("IsFail : TimeOver")
		Var["StepFunc"] 	= QuestFailed
		return true
	end
end


------------------------------------------------------
-- Roulette_Click : �귿 Ŭ���Ǿ����� �۵��ϴ� �Լ�
------------------------------------------------------

function Roulette_Click( NPCHandle, PlyHandle )
cExecCheck ( "Roulette_Click" )

	-- DebugLog("�귿 ����!")

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
		ErrorLog( "Ŭ���� �귿�̶�, �������ѳ��� ���� �귿 �ڵ鰪�� �ٸ����" )
		return
	end

	local PlayRouletteGameInfo 	= Var["PlayRouletteGame"]

	if PlayRouletteGameInfo == nil
	then
		ErrorLog( "Roulette_Click::Var[\"PlayRouletteGame\"] == nil" )
		return
	end

	-- �ֻ���,�귿 ��� Ŭ���Ǿ��ٸ�, �߰����� �귿 Ŭ�� ����
	if PlayRouletteGameInfo["ReadyToGame"] == true
	then
		---- DebugLog("�̹� �� ���õǾ��⿡, Ŭ�� ����")
		return
	end

	PlayRouletteGameInfo["RouletteHandle"]	= NPCHandle

	-- �ֻ��� ���� Ŭ�������ʰ�, �귿 Ŭ���� ���
	if PlayRouletteGameInfo["SelectedDiceHandle"] == nil
	then
		cMobDialog( Var["MapIndex"], ChatInfo["Roulette_Click"]["SpeakerIndex"], ChatInfo["ScriptFileName"], ChatInfo["Roulette_Click"]["MsgIndex"] )
		return
	end

	if PlayRouletteGameInfo["SelectedDiceNum"] < 1 or PlayRouletteGameInfo["SelectedDiceNum"] > 6
	then
		ErrorLog( "1~6�� ��� �ֻ�����ȣ" )
		return
	end

	-- ��Ģ�� �°� �귿 Ŭ���� ���
	PlayRouletteGameInfo["ReadyToGame"] = true

	return
end


------------------------------------------------------
-- Dice_Click : �ֻ��� Ŭ���Ǿ����� �۵��ϴ� �Լ�
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

	-- �ֻ���,�귿 ��� Ŭ���Ǿ��ٸ�, �߰����� �ֻ��� Ŭ�� ����
	if PlayRouletteGameInfo["ReadyToGame"] == true
	then
		---- DebugLog("�̹� �� ���õǾ��⿡, Ŭ�� ����")
		return
	end

	-- ������ �ֻ��� �ڵ鰪 ����
	PlayRouletteGameInfo["SelectedDiceHandle"] 		= NPCHandle
	-- DebugLog( "Your Selected DiceHandle : "..PlayRouletteGameInfo["SelectedDiceHandle"] )

	-- ������ �ֻ��� �ڵ鰪 �޾�, ��� �ֻ������� �˻�
	FindDiceNum	( Var )

	-- ��� �ֻ��� �� ����
	DiceLightOff( Var )

	-- ������ �ֻ��� ��Ű��
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

	-- ��� ��ü ����
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
