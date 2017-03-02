Netwerk = Netwerk or {Anna={}, GameJolt={}}

function FORM_main_Close(key)
    os.exit()
end

function KID_BUTTON_NewGame_Action(key)
   alert("Test - New Game: "..key)
end   

function KID_BUTTON_LoadGame_Action(key)
   alert("Test - Load Game: "..key)
end   

function KID_BUTTON_NET_Anna_Create_Action(key)
   alert("Thank you for putting your trust in Anna\n\nBefore we begin you may put in a name which you wish to be seen on the website\nAfter that you'll be led to the Anna website for instructions about account verification and then your Anna account is ready to be used.")
   local AnnaName = MAAN_Input("Please enter your name:",MAAN_SYS_UserName(),1)
   if AnnaName=="" then return end
   alert("Very well, "..AnnaName..";\n\nI will now try to create your account. If succesful you'll be led to the website for further instructions.")
end      