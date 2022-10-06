require( "ID/WarBLH/WarBLHData" )

EVENT_ROOM_DEINIT_FUNC = { }


function EVENT_ROOM_ONE_DEINIT( RoomEvent )
cExecCheck( "EVENT_ROOM_ONE_DEINIT" )

	RoomEvent["Room"]["RE_State"]		= RE_STATE_1
	RoomEvent["MRE_State"]				= MRE_START

end


function EVENT_ROOM_TWO_DEINIT( RoomEvent )
cExecCheck( "EVENT_ROOM_TWO_DEINIT" )

	RoomEvent["Room"]["RE_State"]		= RE_STATE_1
	RoomEvent["MRE_State"]				= MRE_START

end


function EVENT_ROOM_THREE_DEINIT( RoomEvent )
cExecCheck( "EVENT_ROOM_THREE_DEINIT" )

	RoomEvent["Room"]["RE_State"]		= RE_STATE_1
	RoomEvent["MRE_State"]				= MRE_START

end


function EVENT_ROOM_FOUR_DEINIT( RoomEvent )
cExecCheck( "EVENT_ROOM_FOUR_DEINIT" )

	RoomEvent["Room"]["RE_State"]		= RE_STATE_1
	RoomEvent["MRE_State"]				= MRE_START

end


function EVENT_ROOM_FIVE_DEINIT( RoomEvent )
cExecCheck( "EVENT_ROOM_FIVE_DEINIT" )

	RoomEvent["Room"]["RE_State"]		= RE_STATE_1
	RoomEvent["MRE_State"]				= MRE_START

end


function EVENT_ROOM_ENDING_DEINIT( RoomEvent )
cExecCheck( "EVENT_ROOM_ENDING_DEINIT" )


end




EVENT_ROOM_DEINIT_FUNC[1] = EVENT_ROOM_ONE_DEINIT
EVENT_ROOM_DEINIT_FUNC[2] = EVENT_ROOM_TWO_DEINIT
EVENT_ROOM_DEINIT_FUNC[3] = EVENT_ROOM_THREE_DEINIT
EVENT_ROOM_DEINIT_FUNC[4] = EVENT_ROOM_FOUR_DEINIT
EVENT_ROOM_DEINIT_FUNC[5] = EVENT_ROOM_FIVE_DEINIT
EVENT_ROOM_DEINIT_FUNC[6] = EVENT_ROOM_ENDING_DEINIT
