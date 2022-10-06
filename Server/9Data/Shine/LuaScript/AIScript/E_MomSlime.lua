require( "common" )




KING	= { Index = "E_DadSlime",	RegenX = 16298, RegenY = 13384, RegenD = 270 }
QUEEN	= { Index = "E_MomSlime", }
DANNY	= { Index = "E_DannySlime", RegenR = 300, }
MIKE	= { Index = "E_MikeSlime",	RegenR = 300, }
TREE	=
{
	{ Index = "E_HiveTree", RegenX = 13594, RegenY = 14599, RegenR = 70, RegenT = 2, },
	{ Index = "E_HiveTree", RegenX = 13704, RegenY = 14381, RegenR = 70, RegenT = 2, },
	{ Index = "E_HiveTree", RegenX = 13530, RegenY = 14584, RegenR = 70, RegenT = 2, },
	{ Index = "E_HiveTree", RegenX = 13653, RegenY = 14859, RegenR = 70, RegenT = 2, },
	{ Index = "E_HiveTree", RegenX = 13644, RegenY = 15093, RegenR = 70, RegenT = 2, },
	{ Index = "E_HiveTree", RegenX = 13515, RegenY = 15391, RegenR = 70, RegenT = 2, },
	{ Index = "E_HiveTree", RegenX = 13715, RegenY = 15532, RegenR = 70, RegenT = 2, },
	{ Index = "E_HiveTree", RegenX = 13705, RegenY = 15779, RegenR = 70, RegenT = 2, },
	{ Index = "E_HiveTree", RegenX = 13502, RegenY = 15813, RegenR = 70, RegenT = 2, },
	{ Index = "E_HiveTree", RegenX = 13539, RegenY = 15508, RegenR = 70, RegenT = 2, },
}


EVENT_START_NOTICE		= "ValenSlime_MobRegen"		-- 시작 공지1
EVENT_START_NOTICE2		= "ValenSlime_MobRegen2"	-- 시작 공지2
EVENT_START_NOTICE3		= "ValenSlime_MobRegen3"	-- 시작 공지3
EVENT_SUC_NOTICE		= "ValenSlime_Success"		-- 성공 공지
EVENT_REWARD_NOTICE		= "ValenSlime_Reward"		-- 보상 범위 공지
EVENT_SUC_INTERVAL		= (100 * 100)				-- 성공 슬라임 거리(제곱)
EVENT_REWARD_ABSTATE	= "StaValenReward"			-- 보상 상태이상
EVENT_REWARD_KEEPTIME	= (60 * 60 * 1000)			-- 보상 상태이상 시간
EVENT_REWARD_RANGE		= 800						-- 보상 범위
EVENT_NOMOVE_TIME_MAX	= 60						-- 퀸슬 안움직임 체크 시간
EVENT_MOB_CLEAR_DELAY	= 3							-- 클리어후 몹 지우기 딜레이
EVENT_SUC_EFFECT_INDEX	= "LoveFireworks"			-- 성공 이펙트

EVENT_DIALOG =
{
	KING 	= { FaceCut = "E_DadNPC", FileName = "Event", Index = "E_DadSlime_01" },
	QUEEN 	= { FaceCut = "E_MomNPC", FileName = "Event", Index = "E_MomSlime_01" },
}

EVENT_MOBCHAT =
{
	KING	= { ChatTick = 30, FileName = "Event", Index = "E_DadSlime_Chat01" },
	QUEEN 	= { ChatTick = 30, FileName = "Event", Index = "E_MomSlime01_Chat01" },
	DANNY	= { ChatTick = 10, FileName = "Event", Index = "E_DannySlime_Chat01" },
	MIKE 	= { ChatTick = 10, FileName = "Event", Index = "E_MikeSlime01_Chat01" },
}


MemBlock = {}


function Dummy( Handle, MapIndex )
cExecCheck( "Dummy" )
	return ReturnAI["END"]
end


function E_MomSlime( Handle, MapIndex )--
cExecCheck( "E_MomSlime" )


	if MapIndex ~= "Eld" then

		cAIScriptSet( Handle )
		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) == 1 then

		cAIScriptSet( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]

	end


	local Var = MemBlock[Handle]
	local CurSec = cCurrentSecond()

	if Var == nil then

		MemBlock[Handle]				= {}

		Var								= MemBlock[Handle]

		Var["MapIndex"] 				= MapIndex
		Var["Handle"]					= Handle

		Var["RegenX"], Var["RegenY"]	= cObjectLocate( Var["Handle"] )
		Var["CurX"],   Var["CurY"]		= Var["RegenX"], Var["RegenY"]
		Var["LastMoveTime"]				= CurSec
		Var["ChkTime"]					= CurSec + 1
		Var["EventStep"]				= 1

		if Var["RegenX"] == nil or Var["RegenY"] == nil then

			cAIScriptSet( Handle )
			cNPCVanish( Handle )
			MemBlock[Handle] = nil
			return ReturnAI["END"]

		end




		-- 킹, 새끼 슬라임들 리젠
		Var["King"]						= cMobRegen_XY( Var["MapIndex"], KING["Index"], KING["RegenX"], KING["RegenY"], KING["RegenD"] )
		Var["Danny"]					= cMobRegen_Circle( Var["MapIndex"], DANNY["Index"], KING["RegenX"], KING["RegenY"], DANNY["RegenR"] )
		Var["Mike"]						= cMobRegen_Circle( Var["MapIndex"],  MIKE["Index"],  Var["RegenX"],  Var["RegenY"],  MIKE["RegenR"] )

		if Var["King"] == nil or Var["Danny"] == nil or Var["Mike"] == nil then

			DeleteSubObject( Var )

			cAIScriptSet( Handle )
			cNPCVanish( Handle )
			MemBlock[Handle] = nil
			return ReturnAI["END"]

		end


		-- 킹슬라임에 붙는 스크립트는 그다지 중요하지 않기 때문에 실패 해도 상관 없음
		if cAIScriptSet( Var["King"], Var["Handle"] ) ~= nil then

			cAIScriptFunc( Var["King"], "Entrance", "Dummy" )

		end

		Var["TreeList"]					= {}
		Var["TreeRegenTList"]			= {}

		Var["KingChatTime"]				= CurSec + EVENT_MOBCHAT["KING"]["ChatTick"]
		Var["QueenChatTime"]			= CurSec + EVENT_MOBCHAT["QUEEN"]["ChatTick"]
		Var["DannyChatTime"]			= CurSec + EVENT_MOBCHAT["DANNY"]["ChatTick"]
		Var["MikeChatTime"]				= CurSec + EVENT_MOBCHAT["MIKE"]["ChatTick"]

	end


	-- 몬스터 채팅
	if Var["KingChatTime"] <= CurSec then

		cMobChat( Var["King"], EVENT_MOBCHAT["KING"]["FileName"], EVENT_MOBCHAT["KING"]["Index"] )
		Var["KingChatTime"]	= CurSec + EVENT_MOBCHAT["KING"]["ChatTick"]

	end

	if Var["QueenChatTime"] <= CurSec then

		cMobChat( Handle, EVENT_MOBCHAT["QUEEN"]["FileName"], EVENT_MOBCHAT["QUEEN"]["Index"] )
		Var["QueenChatTime"] = CurSec + EVENT_MOBCHAT["QUEEN"]["ChatTick"]

	end

	if Var["DannyChatTime"] <= CurSec then

		cMobChat( Var["Danny"], EVENT_MOBCHAT["DANNY"]["FileName"], EVENT_MOBCHAT["DANNY"]["Index"] )
		Var["DannyChatTime"] = CurSec + EVENT_MOBCHAT["DANNY"]["ChatTick"]

	end

	if Var["MikeChatTime"] <= CurSec then

		cMobChat( Var["Mike"], EVENT_MOBCHAT["MIKE"]["FileName"], EVENT_MOBCHAT["MIKE"]["Index"] )
		Var["MikeChatTime"]	= CurSec + EVENT_MOBCHAT["MIKE"]["ChatTick"]

	end


	-- 이벤트 진행
	if Var["EventStep"] == 1 then

		if Var["ChkTime"] <= CurSec then

			Var["ChkTime"] = CurSec + 1.5

			cScriptMessage( Var["MapIndex"], EVENT_START_NOTICE )
			Var["EventStep"] = Var["EventStep"] + 1

		end

	elseif Var["EventStep"] == 2 then

		if Var["ChkTime"] <= CurSec then

			Var["ChkTime"] = CurSec + 1.5

			cScriptMessage( Var["MapIndex"], EVENT_START_NOTICE2 )
			Var["EventStep"] = Var["EventStep"] + 1

		end

	elseif Var["EventStep"] == 3 then

		if Var["ChkTime"] <= CurSec then

			Var["ChkTime"] = CurSec + 1

			cScriptMessage( Var["MapIndex"], EVENT_START_NOTICE3 )
			Var["EventStep"] = Var["EventStep"] + 1

		end

	elseif Var["EventStep"] == 4 then

		if Var["ChkTime"] <= CurSec then

			Var["ChkTime"] = CurSec + 1


			-- 나무 10개 유지
			for i = 1, #TREE do

				if Var["TreeList"][i] == nil or cIsObjectDead( Var["TreeList"][i] ) == 1 then

					if Var["TreeRegenTList"][i] == nil then

						Var["TreeRegenTList"][i]	= CurSec + TREE[i]["RegenT"]
						Var["TreeList"][i]			= nil

					end

				end

				if Var["TreeRegenTList"][i] ~= nil and Var["TreeRegenTList"][i] <= CurSec then

					Var["TreeList"][i]			= cMobRegen_Circle( Var["MapIndex"], TREE[i]["Index"], TREE[i]["RegenX"], TREE[i]["RegenY"], TREE[i]["RegenR"] )
					Var["TreeRegenTList"][i]	= nil

				end

			end


			-- 좌표 체크 ( 1분간 안움직였는지 체크 )
			local CurX, CurY = cObjectLocate( Var["Handle"] )

			if CurX == nil or CurY == nil then

				DeleteSubObject( Var )

				cAIScriptSet( Handle )
				cNPCVanish( Handle )
				MemBlock[Handle] = nil
				return ReturnAI["END"]

			end


			-- 현재 좌표가 이전 좌표랑 다르면 체크 시간 갱신
			if Var["CurX"] ~= CurX or Var["CurY"] ~= CurY then

				Var["LastMoveTime"] = CurSec
				Var["CurX"]			= CurX
				Var["CurY"]			= CurY

			end

			-- 현재 좌표가 리젠 좌표랑 같으면 체크 시간 갱신
			if CurX == Var["RegenX"] and CurY == Var["RegenY"] then

				Var["LastMoveTime"] = CurSec

			end


			if Var["LastMoveTime"] + EVENT_NOMOVE_TIME_MAX <= CurSec then

				cRunTo( Var["Handle"], Var["RegenX"], Var["RegenY"], 3000 )

				Var["LastMoveTime"] = CurSec

				return ReturnAI["END"]

			end


			if cDistanceSquar( Var["Handle"], Var["King"] ) <= EVENT_SUC_INTERVAL then

				cEffectRegen_XY( Var["MapIndex"], EVENT_SUC_EFFECT_INDEX, KING["RegenX"], KING["RegenY"], 0, 4, 0, 1000 )
				cScriptMessage( Var["MapIndex"], EVENT_SUC_NOTICE )
				cSetAbstate_Range( Var["King"], EVENT_REWARD_RANGE, ObjectType["Player"], EVENT_REWARD_ABSTATE, 1, EVENT_REWARD_KEEPTIME )
				cScriptMessage_Range( Var["King"], EVENT_REWARD_RANGE, EVENT_REWARD_NOTICE )

				cMobDialog_Range( Var["King"], EVENT_DIALOG["KING"]["FaceCut"], EVENT_REWARD_RANGE, EVENT_DIALOG["KING"]["FileName"], EVENT_DIALOG["KING"]["Index"] )

				Var["EventStep"]	= Var["EventStep"] + 1
				Var["ChkTime"]		= CurSec + 4

			end

		end
	elseif Var["EventStep"] == 5 then

		if Var["ChkTime"] <= CurSec then

			cMobDialog_Range( Var["King"], EVENT_DIALOG["QUEEN"]["FaceCut"], EVENT_REWARD_RANGE, EVENT_DIALOG["QUEEN"]["FileName"], EVENT_DIALOG["QUEEN"]["Index"] )

			Var["EventStep"]	= Var["EventStep"] + 1
			Var["ChkTime"]		= CurSec + EVENT_MOB_CLEAR_DELAY

		end

	elseif Var["EventStep"] == 6 then

		if Var["ChkTime"] <= CurSec then

			DeleteSubObject( Var )

			cAIScriptSet( Handle )
			cNPCVanish( Handle )
			MemBlock[Handle] = nil

		end

	end


	return ReturnAI["END"]

end



function DeleteSubObject( Var )

	if Var == nil then

		return

	end

	if	Var["King"] ~= nil then

		cNPCVanish( Var["King"] )
		Var["King"] = nil

	end

	if	Var["Danny"] ~= nil then

		cNPCVanish( Var["Danny"] )
		Var["Danny"] = nil

	end

	if	Var["Mike"] ~= nil then

		cNPCVanish( Var["Mike"] )
		Var["Mike"] = nil

	end


	if Var["TreeList"] ~= nil then

		for i = 1, #TREE do

			if Var["TreeList"][i] ~= nil then

				cNPCVanish( Var["TreeList"][i] )
				Var["TreeList"][i] = nil

			end

		end

		Var["TreeList"] = nil

	end


end
