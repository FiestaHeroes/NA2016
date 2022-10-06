require( "common" )

gIsInit 	= false		-- 초기화 되었나? ㄴㄴ
------------------------------------------------------------------------------------------------------
--
-- FUNCTION : CPP -> LUA
--
------------------------------------------------------------------------------------------------------
function DummyFunction()
end


function ClassChangeMaster02( Handle, MapIndex )
cExecCheck( "ClassChangeMaster02" )


	-- 이벤트 초기화
	if gIsInit == false
	then

		-- AISctipt Function 설정
		cAIScriptFunc( Handle, "NPCClick", "ClassChangeMaster02_Click" )
		cAIScriptFunc( Handle, "NPCMenu",  "ClassChangeMaster02_Menu"  )

		gIsInit = true;

	end

end


function ClassChangeMaster02_Click( NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "ClassChangeMaster02_Click" )

	-- 다이얼로그 메뉴 출력
	cNPCMenuOpen( NPCHandle, PlyHandle )

end


function ClassChangeMaster02_Menu( NPCHandle, PlyHandle, PlyCharNo, Value )
cExecCheck( "ClassChangeMaster02_Menu" )

	-- 클래스 변경? ㅇㅇ
	if Value == 1
	then

		cClassChangeOpen( PlyHandle )

	end

end
