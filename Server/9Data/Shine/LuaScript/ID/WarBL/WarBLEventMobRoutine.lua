require( "ID/WarBL/WarBLData" )
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 1							-- --
-- --														-- --
-- --				( 포라스 루틴 / 마계병사 )				-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


function ROOM_ONE_FORAS_ROUTINE( Handle, MapIndex )
cExecCheck( "ROOM_ONE_FORAS_ROUTINE" )

	if InstanceField[MapIndex] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	-- 1번방 상태인지 체크
	if InstanceField[MapIndex]["Room"]["RoomNumber"] ~= 1 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if InstanceField[MapIndex]["Room"]["Data"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end



	local Event_Foras_List	= { }
	local Event_Foras		= { }


	Event_Foras_List 	= InstanceField[MapIndex]["Room"]["Data"]["ForasList"]

	if Event_Foras_List == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	Event_Foras = InstanceField[MapIndex]["Room"]["Data"]["ForasList"]["List"][Handle]

	if Event_Foras == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		Event_Foras[Handle] = nil

		return ReturnAI["END"]

	end


	-- 주변 캐릭터 검색
	if Event_Foras_List["FL_State"] == FL_SEARCH then

		if Event_Foras["CheckTime"] > InstanceField[MapIndex]["CurrentTime"] then

			return ReturnAI["CPP"]

		end

		Event_Foras["CheckTime"] = Event_Foras["CheckTime"] + 1



		if Event_Foras["ChatCheckTime"] <  InstanceField[MapIndex]["CurrentTime"] then

			local RandInt


			Event_Foras["ChatCheckTime"] = Event_Foras["ChatCheckTime"] + Event_Foras["MobChatData"]["DELAY"]
			RandInt = cRandomInt( 1, 3 )
			cMobChat( Handle, "WarBL", Event_Foras["MobChatData"]["INDEX"][RandInt] )

		end


		local FindPlayer


		FindPlayer = cObjectFind( Event_Foras["Handle"], Event_Foras["SearchRange"], ObjectType["Player"], "so_ObjectType" )

		if FindPlayer ~= nil then

			-- 포라스 리스트에 검색 성공 알림 ( 이벤트 루틴에서 사용 )
			Event_Foras_List["FL_State"] 	= FL_SEARCH_SUCCESS
			Event_Foras_List["FindPlayer"]	= FindPlayer

		end

	-- 포라스 위 느낌표 출력 / 방향 전화
	elseif Event_Foras_List["FL_State"] == FL_SURPRISE then

		if Event_Foras["IsSurprise"] == 0 then

			local CurX, CurY


			CurX, CurY = cObjectLocate( Event_Foras_List["FindPlayer"] )
			cRunTo( Handle, CurX, CurY )

			cMobChat		( Handle, "WarBL", Event_Foras["MobChatData"]["INDEX"][4] )
			cSetAbstate		( Handle, STA_STUN, 1, 1000, Event_Foras_List["FindPlayer"] )
			cSetAbstate		( Handle, STA_SURPRISE, 1, 20000000 )
			Event_Foras["IsSurprise"] = 1

		end

	-- 목표지점을 패스를 따라 이동
	elseif Event_Foras_List["FL_State"] == FL_ESCAPE then

		local CurPos  = {}
		local GoalPos = {}


		CurPos["X"], CurPos["Y"]	= cObjectLocate( Event_Foras["Handle"] )
		GoalPos						= Event_Foras["Path"][Event_Foras["PathNumber"]]


		if cDistanceSquar( CurPos["X"], CurPos["Y"], GoalPos["X"], GoalPos["Y"] ) < ( MOVE_INTERVER * MOVE_INTERVER ) then

			Event_Foras["PathNumber"] = Event_Foras["PathNumber"] + 1

			if Event_Foras["PathNumber"] > #Event_Foras["Path"] then

				Event_Foras_List["FL_State"] = FL_REMOVE

				return

			end

			GoalPos						= Event_Foras["Path"][Event_Foras["PathNumber"]]

			cRunTo( Event_Foras["Handle"], GoalPos["X"], GoalPos["Y"] )

		end

	elseif Event_Foras_List["FL_State"] == FL_REMOVE then

		cAIScriptSet( Event_Foras["Handle"] )
		cNPCVanish( Event_Foras["Handle"] )
		Event_Foras = nil

	end

end




function ROOM_ONE_DAVILDOM_ROUTINE( Handle, MapIndex )
cExecCheck( "ROOM_ONE_DAVILDOM_ROUTINE" )

	if InstanceField[MapIndex] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	-- 1번방 상태인지 체크
	if InstanceField[MapIndex]["Room"]["RoomNumber"] ~= 1 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if InstanceField[MapIndex]["Room"]["Data"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local Event_Davildom_List	= { }
	local Davildom				= { }


	Event_Davildom_List = InstanceField[MapIndex]["Room"]["Data"]["Davildom"]["List"]
	Davildom			= Event_Davildom_List[Handle]


	if Event_Davildom_List == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		Event_Davildom_List[Handle] = nil

		return ReturnAI["END"]

	end


	if Davildom["CheckTime"] > InstanceField[MapIndex]["CurrentTime"] then

		return ReturnAI["CPP"]

	end

	Davildom["CheckTime"] = Davildom["CheckTime"] + 1


	if Davildom["D_State"]	 == D_Normal then

		local FindPlayer


		FindPlayer = cObjectFind( Handle, InstanceField[MapIndex]["Room"]["Data"]["Davildom"]["SearchRange"], ObjectType["Player"], "so_ObjectType" )

		if FindPlayer ~= nil then

			cSetAbstate		( Handle, STA_IMMORTAL, 1, 1, FindPlayer )

			cAggroSet		( Handle, FindPlayer )
			Davildom["D_State"]	 = D_Aggro

		end

	elseif Davildom["D_State"]	 == D_Aggro then

		cResetAbstate	( Handle, STA_IMMORTAL )

		Davildom["D_State"]	 = D_Aggro_SUCC

		return ReturnAI["CPP"]

	elseif Davildom["D_State"]	 == D_Aggro_SUCC then

		return ReturnAI["CPP"]

	end

	return ReturnAI["CPP"]

end







-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 2							-- --
-- --														-- --
-- --					  ( 시트리 )						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function ROOM_TWO_CITRIE_ROUTINE( Handle, MapIndex )
cExecCheck( "ROOM_TWO_CITRIE_ROUTINE" )

	if InstanceField[MapIndex] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local RoomEvent


	RoomEvent = InstanceField[MapIndex]

	if RoomEvent["Room"]["RoomNumber"] ~= 2 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if RoomEvent["Room"]["Data"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		RoomEvent["Room"]["Data"]["Citrie"] = nil

		return ReturnAI["END"]

	end


	return ReturnAI["CPP"]

end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 3							-- --
-- --														-- --
-- --		  	 ( 포라스 / 마계병사 루틴 )					-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function ROOM_THREE_FORAS_ROUTINE( Handle, MapIndex )
cExecCheck( "ROOM_THREE_FORAS_ROUTINE" )


	if InstanceField[MapIndex] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local RoomEvent
	local GroupNumber
	local ForasList
	local EventForas


	RoomEvent = InstanceField[MapIndex]

	if RoomEvent["Room"]["RoomNumber"] ~= 3 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if RoomEvent["Room"]["Data"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	GroupNumber 	= RoomEvent["Room"]["Data"]["ForasList"][Handle]

	if GroupNumber == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	ForasList 	= RoomEvent["Room"]["Data"]["ForasGroupList"][GroupNumber]

	if ForasList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	EventForas = ForasList["List"][Handle]

	if EventForas == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		RoomEvent["Room"]["Data"]["ForasList"][Handle] 								= nil
		RoomEvent["Room"]["Data"]["ForasGroupList"][GroupNumber]["List"][Handle]	= nil

		return ReturnAI["END"]

	end

	if EventForas["CheckTime"] > RoomEvent["CurrentTime"] then

		return ReturnAI["END"]

	end

	EventForas["CheckTime"]  = RoomEvent["CurrentTime"] + 1


	if ForasList["FG_State"] == FG_ESCAPE then

		local CurPos  = {}
		local GoalPos = {}


		CurPos["X"], CurPos["Y"]	= cObjectLocate( Handle )
		GoalPos						= EventForas["Path"][EventForas["PathNumber"]]


		if cDistanceSquar( CurPos["X"], CurPos["Y"], GoalPos["X"], GoalPos["Y"] ) < ( MOVE_INTERVER * MOVE_INTERVER ) then

			EventForas["PathNumber"] = EventForas["PathNumber"] + 1

			if EventForas["PathNumber"] > #EventForas["Path"] then

				ForasList["FG_State"] = FG_REMOVE

				return

			end

			GoalPos						= EventForas["Path"][EventForas["PathNumber"]]

			cRunTo( Handle, GoalPos["X"], GoalPos["Y"] )

		end

	elseif ForasList["FG_State"] == FG_REMOVE then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		RoomEvent["Room"]["Data"]["ForasList"][Handle] = nil
		RoomEvent["Room"]["Data"]["ForasGroupList"][GroupNumber]["List"][Handle] = nil

	end


	return ReturnAI["END"]

end



function ROOM_THREE_DAVILDOM_ROUTINE( Handle, MapIndex )
cExecCheck( "ROOM_THREE_DAVILDOM_ROUTINE" )

	if InstanceField[MapIndex] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	local RoomEvent
	local GroupNumber
	local DavildomList
	local EventDavildom
	local DavildomState


	RoomEvent = InstanceField[MapIndex]

	if RoomEvent["Room"]["RoomNumber"] ~= 3 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if RoomEvent["Room"]["Data"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	GroupNumber = RoomEvent["Room"]["Data"]["DavildomList"][Handle]

	if GroupNumber == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	DavildomList 	= RoomEvent["Room"]["Data"]["DavildomGroupList"][GroupNumber]["List"]

	if DavildomList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	EventDavildom = DavildomList[Handle]

	if EventDavildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		RoomEvent["Room"]["Data"]["DavildomList"][Handle] = nil
		DavildomList[Handle] = nil

		return ReturnAI["END"]

	end


	DavildomState = RoomEvent["Room"]["Data"]["DavildomGroupList"][GroupNumber]["DG_State"]


	if DavildomState == DG_NORMAL then


		if EventDavildom["CheckTime"] > RoomEvent["CurrentTime"] then

			return ReturnAI["END"]

		end

		EventDavildom["CheckTime"] = RoomEvent["CurrentTime"] + 1


		local FindPlayer


		FindPlayer = cObjectFind( Handle, 400, ObjectType["Player"], "so_ObjectType" )

		if FindPlayer ~= nil then

			RoomEvent["Room"]["Data"]["DavildomGroupList"][GroupNumber]["DG_State"] = DG_AGGRO

		end

	elseif DavildomState == DG_AGGRO_SUCC then

		if EventDavildom["D_State"] ~= D_NORMAL then

			return ReturnAI["CPP"]

		end


		local CurPos 		= { }



		CurPos["X"], CurPos["Y"]	= cObjectLocate( Handle )


		local PlayerList
		local PlayerAggroList	= { }
		local Count				= 1


		PlayerList 		= { cGetPlayerList( RoomEvent["MapIndex"] ) }

		for i = 1, #PlayerList do

			local CurPlayerPos		= { }


			CurPlayerPos["X"], CurPlayerPos["Y"] 	= cObjectLocate( PlayerList[i] )


			if cDistanceSquar( CurPos["X"], CurPos["Y"], CurPlayerPos["X"], CurPlayerPos["Y"] ) < ( EventDavildom["SearchRange"] * EventDavildom["SearchRange"] ) then

				PlayerAggroList[Count] = PlayerList[i]

				Count = Count + 1

			end

		end


		local PlayerHandle


		PlayerHandle 		= cRandomInt(1, #PlayerAggroList)

		cAggroSet( Handle, PlayerAggroList[PlayerHandle], EventDavildom["AggroPoint"])

		EventDavildom["D_State"] = D_AGGRO

	end

	return ReturnAI["CPP"]

end




function ROOM_THREE_REGEN_DAVILDOM_ROUTINE( Handle, MapIndex )
cExecCheck( "ROOM_THREE_REGEN_DAVILDOM_ROUTINE" )

	if InstanceField[MapIndex] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local RoomEvent

	RoomEvent = InstanceField[MapIndex]

	if RoomEvent["Room"]["RoomNumber"] ~= 3 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if RoomEvent["Room"]["Data"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if RoomEvent["Room"]["Data"]["RegenDavildomList"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local Davildom = RoomEvent["Room"]["Data"]["RegenDavildomList"][Handle]


	if Davildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		RoomEvent["Room"]["Data"]["RegenDavildomList"][Handle]	= nil

		return ReturnAI["END"]

	end


	if Davildom["D_State"] == D_AGGRO then

		if Davildom["CheckTime"] > RoomEvent["CurrentTime"] then

			return ReturnAI["END"]

		end

		Davildom["CheckTime"] = Davildom["CheckTime"] + 1


		if Davildom["AggroPlayer"] == nil then

			Davildom["D_State"] = D_Aggro_SUCC

		elseif Davildom["AggroPlayer"] ~= nil then

			local PlayerPos		= { }
			local DavildomPos	= { }


			PlayerPos["X"], PlayerPos["Y"]			= cObjectLocate( Davildom["AggroPlayer"] )
			DavildomPos["X"], DavildomPos["Y"]		= cObjectLocate( Handle )
			cRunTo( Handle, PlayerPos["X"], PlayerPos["Y"] )


			if cDistanceSquar( DavildomPos["X"], DavildomPos["Y"], PlayerPos["X"], PlayerPos["Y"] ) < ( Davildom["AggroDistance"] * Davildom["AggroDistance"] ) then

				cAggroSet( Handle, Davildom["AggroPlayer"], Davildom["AGGRO_POINT"] )
				Davildom["D_State"] 	= D_Aggro_SUCC
				Davildom["CheckTime"] 	= RoomEvent["CurrentTime"] + 10

			end

		end

	elseif Davildom["D_State"] == D_Aggro_SUCC then


	end


	return ReturnAI["CPP"]


end



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 4							-- --
-- --														-- --
-- --		  	 ( 포라스 족장 / 마계병사 루틴 )			-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


function ROOM_FOUR_FORAS_CHIEF_ROUTINE( Handle, MapIndex )
cExecCheck( "ROOM_FOUR_FORAS_CHIEF_ROUTINE" )

	if InstanceField[MapIndex] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local RoomEvent

	RoomEvent = InstanceField[MapIndex]

	if RoomEvent["Room"]["Data"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local ForasChief
	local DavildomList

	ForasChief 		= RoomEvent["Room"]["Data"]["ForasChief"]

	if ForasChief == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	DavildomList	= RoomEvent["Room"]["Data"]["DavildomList"]

	if DavildomList == nil then

		ForasChief["FC_State"] = FC_NORMAL

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		RoomEvent["Room"]["Data"]["ForasChief"]	= nil

		return ReturnAI["END"]

	end


	if ForasChief["CheckTime"] > RoomEvent["CurrentTime"] then

		return

	end

	ForasChief["CheckTime"] = RoomEvent["CurrentTime"] + 1


	if ForasChief["FC_State"] == FC_DAMAGE then

		for index, value in pairs(DavildomList) do

			return

		end


		ForasChief["FC_State"] = FC_NORMAL

		return ReturnAI["END"]

	elseif ForasChief["FC_State"] == FC_NORMAL then

		cAnimate( Handle, "stop" )
		ForasChief["FC_State"] = FC_IDLE

	elseif ForasChief["FC_State"] == FC_MOVE then

		cRunTo( ForasChief["Handle"], ForasChief["EndPosition"]["X"], ForasChief["EndPosition"]["Y"] )
		ForasChief["FC_State"] = FC_REMOVE

	elseif ForasChief["FC_State"] == FC_REMOVE then

		local CurPos  = {}
		local GoalPos = {}


		CurPos["X"], CurPos["Y"]	= cObjectLocate( Handle )
		GoalPos						= ForasChief["EndPosition"]


		if cDistanceSquar( CurPos["X"], CurPos["Y"], GoalPos["X"], GoalPos["Y"] ) < ( MOVE_INTERVER * MOVE_INTERVER ) then

			cAIScriptSet( Handle )
			cNPCVanish( Handle )
			RoomEvent["Room"]["Data"]["ForasChief"]	= nil

		end

	elseif ForasChief["FC_State"] == FC_FOLLOW then

		if ForasChief["MasterPlayer"] == nil then

			cAIScriptSet( Handle )
			cNPCVanish( Handle )

		end

		cFollow( Handle, ForasChief["MasterPlayer"], ForasChief["FollowData"]["RANGE"], 1000 )


		if ForasChief["HealCheckTime"] < RoomEvent["CurrentTime"] then

			local CurHP, MaxHP = cObjectHP( ForasChief["MasterPlayer"] )
			local Percent
			local HealAmount


			Percent 		= CurHP / MaxHP * 100
			HealAmount		= MaxHP * ( ForasChief["FollowData"]["HEALAMOUNT"] / 100 )


			if Percent < ForasChief["FollowData"]["MASTERHP"] then

				cHeal			( ForasChief["MasterPlayer"], HealAmount )
				cAnimate		( Handle, "start", ForasChief["FollowData"]["ANIMATION"] )

				ForasChief["HealCheckTime"] = RoomEvent["CurrentTime"] + ForasChief["FollowData"]["COOLTIME"]

			end

		end

	end


	return ReturnAI["CPP"]


end



function ROOM_FOUR_DEVILDOM_ROUTINE( Handle, MapIndex )
cExecCheck( "ROOM_FOUR_DEVILDOM_ROUTINE" )

	if InstanceField[MapIndex] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local RoomEvent
	local Davildom


	RoomEvent = InstanceField[MapIndex]

	if RoomEvent["Room"]["RoomNumber"] ~= 4 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if RoomEvent["Room"]["Data"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if RoomEvent["Room"]["Data"]["DavildomList"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	Davildom = RoomEvent["Room"]["Data"]["DavildomList"][Handle]

	if Davildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		RoomEvent["Room"]["Data"]["DavildomList"][Handle] = nil

		return ReturnAI["END"]

	end


	if Davildom["D_State"] == D_AnimateStart then

		if Davildom["AnimateStartTime"] > RoomEvent["CurrentTime"] then

			return ReturnAI["END"]

		end

		cAnimate( Handle, "start", EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["EVENT_DAVILDOM"]["ANIMATION"] )
		Davildom["D_State"] = D_NORMAL

	elseif Davildom["D_State"] == D_NORMAL then

		if Davildom["CheckTime"] > RoomEvent["CurrentTime"] then

			return ReturnAI["END"]

		end

		Davildom["CheckTime"] = RoomEvent["CurrentTime"] + 1


		local FindPlayer


		FindPlayer = cObjectFind( Handle, 500, ObjectType["Player"], "so_ObjectType" )

		if FindPlayer ~= nil then

			RoomEvent["Room"]["Data"]["DavildomList"][Handle]["D_State"] = D_AGGRO
			cAnimate		( Handle, "stop" )
			cAggroSet		( Handle, FindPlayer, 50 )

		end

	elseif Davildom["D_State"] == D_AGGRO then

		return ReturnAI["CPP"]

	end


	return ReturnAI["CPP"]


end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 5							-- --
-- --														-- --
-- --		  	 		( 시트리 루틴 )						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function ROOM_FIVE_SCITRIE_ROUTINE( Handle, MapIndex )
cExecCheck( "ROOM_FIVE_SCITRIE_ROUTINE" )

	if InstanceField[MapIndex] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local RoomEvent

	RoomEvent = InstanceField[MapIndex]

	if RoomEvent["Room"]["RoomNumber"] ~= 5 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if RoomEvent["Room"]["Data"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		RoomEvent["Room"]["Data"]["Citrie"]	= nil

		return ReturnAI["END"]

	end


	local Citrie
	local HPRate
	local HP
	local MAXHP
	local Davildom 		= { }
	local DavildomList	= { }
	local CurX, CurY
	local Davildom 		= { }
	local DavildomList	= { }


	Citrie 			= RoomEvent["Room"]["Data"]["Citrie"]
	HP, MAXHP 		= cObjectHP( Citrie["Handle"] )
	HPRate 			= HP / MAXHP * 100
	CurX, CurY 		= cObjectLocate( Citrie["Handle"] )


	if Citrie["C_State"] == C_HP_90_UNDER then

		if HPRate < Citrie["AI"][Citrie["C_State"]]["HP"] then

			for i = 1, Citrie["AI"][Citrie["C_State"]]["REGEN_NUM"] do

				Davildom["Handle"] = cMobRegen_Circle( RoomEvent["MapIndex"], Citrie["SUMMON"]["MOB_INDEX"],
															CurX, CurY,
															Citrie["SUMMON"]["RADIUS"] )


				if Davildom["Handle"] ~= nil then

					cSetAIScript	( SCRIPT_MAIN, Davildom["Handle"]  )
					cAIScriptFunc	( Davildom["Handle"], "Entrance", "ROOM_FIVE_DAVILDOM_ROUTINE" )

					DavildomList[Davildom["Handle"]] = Davildom

				end

			end

			RoomEvent["Room"]["Data"]["RegenDavildom"][C_HP_90_UNDER] = DavildomList

			Citrie["C_State"] = C_HP_60_UNDER

		end


	elseif Citrie["C_State"] == C_HP_60_UNDER then

		if HPRate < Citrie["AI"][Citrie["C_State"]]["HP"] then

			for i = 1, Citrie["AI"][Citrie["C_State"]]["REGEN_NUM"] do

				Davildom["Handle"] = cMobRegen_Circle( RoomEvent["MapIndex"], Citrie["SUMMON"]["MOB_INDEX"],
															CurX, CurY,
															Citrie["SUMMON"]["RADIUS"] )


				if Davildom["Handle"] ~= nil then

					cSetAIScript	( SCRIPT_MAIN, Davildom["Handle"]  )
					cAIScriptFunc	( Davildom["Handle"], "Entrance", "ROOM_FIVE_DAVILDOM_ROUTINE" )

					DavildomList[Davildom["Handle"]] = Davildom

				end

			end

			RoomEvent["Room"]["Data"]["RegenDavildom"][C_HP_60_UNDER] = DavildomList

			Citrie["C_State"] = C_HP_30_UNDER

		end

	elseif Citrie["C_State"] == C_HP_30_UNDER then

		if HPRate < Citrie["AI"][Citrie["C_State"]]["HP"] then

			for i = 1, Citrie["AI"][Citrie["C_State"]]["REGEN_NUM"] do

				Davildom["Handle"] = cMobRegen_Circle( RoomEvent["MapIndex"], Citrie["SUMMON"]["MOB_INDEX"],
															CurX, CurY,
															Citrie["SUMMON"]["RADIUS"] )


				if Davildom["Handle"] ~= nil then

					cSetAIScript	( SCRIPT_MAIN, Davildom["Handle"]  )
					cAIScriptFunc	( Davildom["Handle"], "Entrance", "ROOM_FIVE_DAVILDOM_ROUTINE" )

					DavildomList[Davildom["Handle"]] = Davildom

				end

			end

			RoomEvent["Room"]["Data"]["RegenDavildom"][C_HP_30_UNDER] = DavildomList

			Citrie["C_State"] = C_END

		end

	end

	return ReturnAI["CPP"]


end



function ROOM_FIVE_DAVILDOM_ROUTINE( Handle, MapIndex )
cExecCheck( "ROOM_FIVE_DAVILDOM_ROUTINE" )

	if InstanceField[MapIndex] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local RoomEvent

	RoomEvent = InstanceField[MapIndex]

	if RoomEvent["Room"]["RoomNumber"] ~= 5 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if RoomEvent["Room"]["Data"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if RoomEvent["Room"]["Data"]["RegenDavildom"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )

		return ReturnAI["END"]

	end


	return ReturnAI["CPP"]

end

function ROOM_FIVE_FORASCHEIF_ROUTINE( Handle, MapIndex )
cExecCheck( "ROOM_FIVE_FORASCHEIF_ROUTINE" )


	if InstanceField[MapIndex] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local RoomEvent

	RoomEvent = InstanceField[MapIndex]


	if RoomEvent["Room"]["Data"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local ForasChief


	ForasChief 		= RoomEvent["Room"]["Data"]["ForasChief"]

	if ForasChief == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		RoomEvent["Room"]["Data"]["ForasChief"]	= nil

		return ReturnAI["END"]

	end


	if ForasChief["FC_State"] == FC_MOVE then

		local ForasChiefData 	= { }


		ForasChiefData 	= EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["FORAS_CHIEF"]

		cRunTo( Handle, ForasChiefData["END_POSITION"]["X"], ForasChiefData["END_POSITION"]["Y"] )

		ForasChief["FC_State"] = FC_NORMAL

	elseif ForasChief["FC_State"] == FC_NORMAL then

		return ReturnAI["END"]

	end

	return ReturnAI["END"]

end
