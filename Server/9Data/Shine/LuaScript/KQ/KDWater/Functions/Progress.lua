--------------------------------------------------------------------------------
--                           Water Progress Func                              --
--------------------------------------------------------------------------------

function KQInit( Var )
cExecCheck "KQInit"


	if Var == nil
	then
		ErrorLog( "InitSoccer : Var nil" )
		return
	end


	-- �÷��̾��� ù �α����� ��ٸ���.
	if #Var["Player"] < 1
	then
		if Var["InitialSec"] + WAIT_PLAYER_MAP_LOGIN_SEC_MAX <= cCurrentSecond()
		then
			cEndOfKingdomQuest( Var[ "MapIndex" ] )
			return
		end

		return
	end


	-- ����� ������ ���� ������ ���� ��ȯ
	local RegenDoor = RegenInfo["Door"]
	Var["Door"] = cDoorBuild( Var["MapIndex"], RegenDoor["Index"], RegenDoor["X"], RegenDoor["Y"], 0, 1000 )
	if Var["Door"] == nil
	then
		GoToFail( Var, "Invisible door regen fail" )
		return
	end

	cDoorAction( Var["Door"], RegenDoor["Block"], "close" )


	-- ��ǳ��, ������ �Ǹ� NPC ��ȯ
	local RegenNPC = RegenInfo["NPC"]
	for i = 1, #RegenNPC
	do
		cNPCRegen( Var["MapIndex"], RegenNPC[ i ] )
	end


	-- ���� �ܰ� ����
	Var["StepFunc"] = StartWait
end


function StartWait( Var )
cExecCheck "StartWait"

	if Var == nil
	then
		ErrorLog( "StartWait : Var nil" )
		return
	end


	-- ���� �ʱ�ȭ
	local StartWaitInfo = Var["StartWait"]
	if StartWaitInfo == nil
	then
		Var["StartWait"] = {}
		StartWaitInfo	 = Var["StartWait"]

		StartWaitInfo["NextSetpWaitTime"] 	= Var["CurSec"] + DelayTime["StartWait"]

		StartWaitInfo["DialogTime"]			= Var["CurSec"]
		StartWaitInfo["DialogStep"]			= 1
	end


	-- ������ ��ٸ��鼭 ���̾�α� ���
	if StartWaitInfo["DialogTime"] ~= nil
	then

		if StartWaitInfo["DialogTime"] <= Var["CurSec"]
		then

			local DialogStep 	= StartWaitInfo["DialogStep"]
			local MaxDialogStep	= #NoticeInfo["KDWater_Role"]

			if DialogStep <= MaxDialogStep
			then
				cScriptMsg( Var["MapIndex"], nil, NoticeInfo["KDWater_Role"][ DialogStep ] )

				StartWaitInfo["DialogTime"] = Var["CurSec"] + DelayTime["StartDialogInterval"]
				StartWaitInfo["DialogStep"] = DialogStep + 1
			end


			if DialogStep > MaxDialogStep
			then
				StartWaitInfo["DialogTime"] = nil
				StartWaitInfo["DialogStep"] = nil
			end

		end

	end


	-- ���� �ܰ� ����
	if StartWaitInfo["NextSetpWaitTime"] <= Var["CurSec"]
	then
		Var["StepFunc"]		= RoundWait
		Var["StartWait"]	= nil
		StartWaitInfo		= nil
	end

end


function RoundWait( Var )
cExecCheck "RoundWait"

	if Var == nil
	then
		ErrorLog( "RoundWait : Var nil" )
		return
	end


	-- ���� �ʱ�ȭ
	local RoundWaitInfo = Var["RoundWait"]
	if RoundWaitInfo == nil
	then
		Var["RoundWait"] = {}
		RoundWaitInfo	 = Var["RoundWait"]

		RoundWaitInfo["NextSetpWaitTime"] 	= Var["CurSec"] + DelayTime["RoundWait"]
		RoundWaitInfo["DialogTime"]			= Var["CurSec"] + DelayTime["RoundStartMessage"]

		cTimer( Var["MapIndex"], 0 )

		Var["RoundTimeOver"]				= false
	end



	if RoundWaitInfo["DialogTime"] ~= nil
	then

		if RoundWaitInfo["DialogTime"] <= Var["CurSec"]
		then
			cScriptMsg( Var["MapIndex"], nil, NoticeInfo["RoundStart_10SecondAgo"], tostring( Var["Round"] ) )

			RoundWaitInfo["DialogTime"] = nil
		end

	end


	-- ���� �ܰ� ����
	if RoundWaitInfo["NextSetpWaitTime"] <= Var["CurSec"]
	then
		Var["StepFunc"]		= RoundProcess
		Var["RoundWait"]	= nil
		RoundWaitInfo		= nil
	end

end


-- ���� ����
function RoundProcess( Var )
cExecCheck "RoundProcess"


	if Var == nil
	then
		ErrorLog( "RoundProcess : Var nil" )
		return
	end


	local RedTeamInfo	= Var["Team"][ KQ_TEAM["RED"] ]
	local BlueTeamInfo	= Var["Team"][ KQ_TEAM["BLUE"] ]

	if RedTeamInfo == nil
	then
		ErrorLog( "RoundProcess : RedTeamInfo nil" )
		return
	end

	if BlueTeamInfo == nil
	then
		ErrorLog( "RoundProcess : BlueTeamInfo nil" )
		return
	end


	-- ���� �ʱ�ȭ
	if Var["RoundEndTime"] == 0
	then

		-- ���� ���� �˸�
		cEffectMsg_AllInMap( Var["MapIndex"], EFFECT_MSG_TYPE["EMT_WATER_START"] )
		cScriptMsg( Var["MapIndex"], nil, NoticeInfo["RoundStart"], tostring( Var["Round"] ) )


		-- ���� �� ����
		cDoorAction( Var["Door"], RegenInfo["Door"]["Block"], "open" )


		-- ���� ���� �ð� ����
		Var["RoundEndTime"]		= Var["CurSec"] + DelayTime["RoundLimit"]

		cTimer( Var["MapIndex"], DelayTime["RoundLimit"] )


		-- �ʱ� ���� ����
		RedTeamInfo["Score"]	= Player_TeamMemberCount( Var, KQ_TEAM["RED"] )
		BlueTeamInfo["Score"]	= Player_TeamMemberCount( Var, KQ_TEAM["BLUE"] )

		cScoreBoard_AllInMap( Var["MapIndex"], true, Var["Round"], RedTeamInfo["Win"],  RedTeamInfo["Score"],
																   BlueTeamInfo["Win"], BlueTeamInfo["Score"] )


		-- �÷��̾�� ŷ�� ��� ����
		for i = 1, #Var["Player"]
		do
			Var["Player"][ i ]["IsOut"] = false
		end

	end


	-- �÷��̾� �Ŵ���
	if Player_Manager( Var ) == false
	then
		Var["StepFunc"]		= KQReward
		Var["RoundEndTime"]	= 0
		return
	end


	-- ���� Ȯ��, ���� �ܰ� ����
	-- ������ 0�̵Ǹ� ���� �ܰ�� �����ؾ��Ѵ�.
	if RedTeamInfo["Score"] == 0 or BlueTeamInfo["Score"] == 0
	then
		Var["StepFunc"]		= RoundEnd
		Var["RoundEndTime"]	= 0

		Var["RoundTimeOver"]= false
		return
	end


	-- �ð� Ȯ��, ���� �ܰ� ����
	if Var["RoundEndTime"] <= Var["CurSec"]
	then
		Var["StepFunc"]		= RoundEnd
		Var["RoundEndTime"]	= 0

		Var["RoundTimeOver"]= true
		return
	end

end


-- ���� ����
function RoundEnd( Var )
cExecCheck "RoundEnd"


	if Var == nil
	then
		ErrorLog( "RoundProcess : Var nil" )
		return
	end


	local RedTeamInfo	= Var["Team"][ KQ_TEAM["RED"] ]
	local BlueTeamInfo	= Var["Team"][ KQ_TEAM["BLUE"] ]

	if RedTeamInfo == nil
	then
		ErrorLog( "RoundProcess : RedTeamInfo nil" )
		return
	end

	if BlueTeamInfo == nil
	then
		ErrorLog( "RoundProcess : BlueTeamInfo nil" )
		return
	end



	-- ���� �ʱ�ȭ
	local RoundEndInfo = Var["RoundEnd"]
	if RoundEndInfo == nil
	then
		Var["RoundEnd"]	= {}
		RoundEndInfo	= Var["RoundEnd"]


		RoundEndInfo["NextSetpWaitTime"] = Var["CurSec"] + DelayTime["RoundEndWait"]


		-- Ÿ�̸� ����
		cTimer( Var["MapIndex"], 0 )


		-- ���� ���� ó��
		local Emotion = {}

		if RedTeamInfo["Score"] > BlueTeamInfo["Score"] and Var["RoundTimeOver"] == false
		then

			-- ���� ��� ���� : ������ �¸�
			RedTeamInfo["Win"]			= RedTeamInfo["Win"] + 1
			BlueTeamInfo["Lose"]		= BlueTeamInfo["Lose"] + 1

			Emotion[ KQ_TEAM["RED"] ]	= RoundInfo["Emotion"]["WIN"]
			Emotion[ KQ_TEAM["BLUE"] ]	= RoundInfo["Emotion"]["LOSE"]

			cScriptMsg( Var["MapIndex"], nil, NoticeInfo["RoundEnd"][ KQ_TEAM["RED"] ], tostring( Var["Round"] ) )

		elseif RedTeamInfo["Score"] < BlueTeamInfo["Score"] and Var["RoundTimeOver"] == false
		then

			-- ���� ��� ���� : ����� �¸�
			RedTeamInfo["Lose"]			= RedTeamInfo["Lose"] + 1
			BlueTeamInfo["Win"]			= BlueTeamInfo["Win"] + 1

			Emotion[ KQ_TEAM["RED"] ]	= RoundInfo["Emotion"]["LOSE"]
			Emotion[ KQ_TEAM["BLUE"] ]	= RoundInfo["Emotion"]["WIN"]

			cScriptMsg( Var["MapIndex"], nil, NoticeInfo["RoundEnd"][ KQ_TEAM["BLUE"] ], tostring( Var["Round"] ) )

		else

			-- ���� ��� ���� : ���º�
			RedTeamInfo["Draw"]			= RedTeamInfo["Draw"] + 1
			BlueTeamInfo["Draw"]		= BlueTeamInfo["Draw"] + 1

			Emotion[ KQ_TEAM["RED"] ]	= RoundInfo["Emotion"]["DRAW"]
			Emotion[ KQ_TEAM["BLUE"] ]	= RoundInfo["Emotion"]["DRAW"]

			cScriptMsg( Var["MapIndex"], nil, NoticeInfo["RoundEnd"]["DRAW"], tostring( Var["Round"] ) )

		end


		RedTeamInfo["Score"] 	= 0
		BlueTeamInfo["Score"] 	= 0


		-- ����� ���� ���� ���� �˸�
		cScoreBoard_AllInMap( Var["MapIndex"], true, Var["Round"], RedTeamInfo["Win"],  RedTeamInfo["Score"],
																   BlueTeamInfo["Win"], BlueTeamInfo["Score"] )

		-- �̸��
		for i = 1, #Var["Player"]
		do
			local PlayerInfo = Var["Player"][ i ]

			if PlayerInfo["IsInMap"] == true
			then

				cSetAbstate( PlayerInfo["Handle"], "StaAdlFStun", 1, (DelayTime["RoundEndWait"] * 1000) )
				cEmotion( PlayerInfo["Handle"], Emotion[ PlayerInfo["TeamType"] ] )

			end

			PlayerInfo["BalloonHandle"]			= nil
			PlayerInfo["BalloonAbstateTime"]	= 0
			PlayerInfo["PrisonLinkToWaitTime"]	= 0
			PlayerInfo["IsOut"]					= false
		end

	end


	-- ��� �ð� Ȯ��
	if RoundEndInfo["NextSetpWaitTime"] > Var["CurSec"]
	then
		return
	end


	-- ŷ�� ���� ���� Ȯ��
	if	Var["Round"] >= RoundInfo["LastRound"] or
		RedTeamInfo["Win"] >= RoundInfo["WinRound"] or
		BlueTeamInfo["Win"] >= RoundInfo["WinRound"]
	then

		Var["StepFunc"]	= KQReward

	else

		Var["Round"]	= Var["Round"] + 1
		Var["StepFunc"]	= RoundWait


		-- ���� �� ����
		cDoorAction( Var["Door"], RegenInfo["Door"]["Block"], "close" )


		-- �÷��̾� ���� ��ġ�� �Ű��ֱ�
		for i = 1, #Var["Player"]
		do
			local PlayerInfo	= Var["Player"][ i ]
			local RegenLocInfo	= TeamRegenLocation[ PlayerInfo["TeamType"] ]

			if PlayerInfo["IsInMap"] == true and RegenLocInfo ~= nil
			then

				cCastTeleport( PlayerInfo["Handle"], "SpecificCoord", RegenLocInfo["X"], RegenLocInfo["Y"] )
				--cLinkTo( PlayerInfo["Handle"], Var["MapIndex"], RegenLocInfo["X"], RegenLocInfo["Y"] )

			end

		end

	end


	Var["RoundEnd"]	= nil
	RoundEndInfo	= nil

end


function KQReward( Var )
cExecCheck "KQReward"


	if Var == nil
	then
		ErrorLog( "KQReward : Var nil" )
		return
	end


	-- Ÿ�̸� ����
	cTimer( Var["MapIndex"], 0 )


	local RedTeamInfo	= Var["Team"][ KQ_TEAM["RED"] ]
	local BlueTeamInfo	= Var["Team"][ KQ_TEAM["BLUE"] ]

	if RedTeamInfo == nil
	then
		ErrorLog( "KQReward : RedTeamInfo nil" )
		return
	end

	if BlueTeamInfo == nil
	then
		ErrorLog( "KQReward : BlueTeamInfo nil" )
		return
	end


	-- ŷ�� ����Ʈ ���
	local KQResult = {}

	-- ŷ�� ����Ʈ ���
	if RedTeamInfo["Win"] > BlueTeamInfo["Win"]
	then
		-- ������ �¸�
		KQResult[ KQ_TEAM["RED"] ]	= "WIN"
		KQResult[ KQ_TEAM["BLUE"] ]	= "LOSE"

		cScriptMsg( Var["MapIndex"], nil, NoticeInfo["KQEnd"][ KQ_TEAM["RED"] ] )

	elseif RedTeamInfo["Win"] < BlueTeamInfo["Win"]
	then
		-- ����� �¸�
		KQResult[ KQ_TEAM["RED"] ]	= "LOSE"
		KQResult[ KQ_TEAM["BLUE"] ]	= "WIN"

		cScriptMsg( Var["MapIndex"], nil, NoticeInfo["KQEnd"][ KQ_TEAM["BLUE"] ] )

	else
		-- ���º�
		KQResult[ KQ_TEAM["RED"] ]	= "DRAW"
		KQResult[ KQ_TEAM["BLUE"] ]	= "DRAW"

		cScriptMsg( Var["MapIndex"], nil, NoticeInfo["KQEnd"]["DRAW"] )

	end


	-- �÷��̾�� ŷ�� ��� ����
	local PlayerList = Var["Player"]
	if PlayerList == nil
	then
		ErrorLog( "KQReward : PlayerList nil" )
		return
	end

	for i = 1, #PlayerList
	do
		local PlayerInfo	= PlayerList[ i ]
		local RewardInfo	= WaterBalloonsWarResult[ KQResult[ PlayerInfo["TeamType"] ] ]

		if cIsInMap( PlayerInfo["Handle"], Var["MapIndex"] ) ~= nil
		then

			cEffectMsg( PlayerInfo["Handle"], RewardInfo["EffectMsg"] )
			cKQRewardIndex( PlayerInfo["Handle"], RewardInfo["RewardIndex"] )

		end

	end


	-- ���� ����
	Var["StepFunc"]	= ReturnToHome

end


-- ��ȯ
function ReturnToHome( Var )
cExecCheck "ReturnToHome"


	if Var == nil
	then
		ErrorLog( "ReturnToHome : Var nil" )
		return
	end


	-- ���� �ʱ�ȭ
	if Var["ReturnToHome"] == nil
	then
		DebugLog( "Start ReturnToHome" )
		Var["ReturnToHome"] = {}
		Var["ReturnToHome"]["ReturnStepSec"] = Var["CurSec"]
		Var["ReturnToHome"]["ReturnStepNo"]  = 1
	end


	-- Return : return notice substep
	if Var["ReturnToHome"]["ReturnStepNo"] <= #NoticeInfo["KQReturn"]
	then
		if Var["ReturnToHome"]["ReturnStepSec"] <= Var["CurSec"]
		then
			-- Notice of Escape
			if NoticeInfo["KQReturn"][ Var["ReturnToHome"]["ReturnStepNo"] ]["Index"] ~= nil
			then
				cNotice( Var["MapIndex"], NoticeInfo["KQReturn"]["ScriptFileName"], NoticeInfo["KQReturn"][ Var["ReturnToHome"]["ReturnStepNo"] ]["Index"] )
			end

			-- Go To Next Notice
			Var["ReturnToHome"]["ReturnStepNo"]  = Var["ReturnToHome"]["ReturnStepNo"] + 1
			Var["ReturnToHome"]["ReturnStepSec"] = Var["CurSec"] + DelayTime["GapKQReturnNotice"]
		end

		return
	end


	-- Return : linkto substep
	if Var["ReturnToHome"]["ReturnStepNo"] > #NoticeInfo["KQReturn"]
	then
		if Var["ReturnToHome"]["ReturnStepSec"] <= Var["CurSec"]
		then
			--Finish_KQ
			cLinkToAll( Var["MapIndex"], LinkInfo["ReturnMap"]["MapIndex"], LinkInfo["ReturnMap"]["x"], LinkInfo["ReturnMap"]["y"] )
			cVanishAll();

			Var["ReturnToHome"] = nil
			if cEndOfKingdomQuest( Var["MapIndex"] ) == nil
			then
				ErrorLog( "ReturnToHome::Function cEndOfKingdomQuest failed" )
			end
		end

		return
	end

end

