B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	
	Dim price As String ="0"
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.AppName="EurTry"
	
	'Version of the App
	App.AppVersion="2.0"
	
	'Description of the App. You can use HTML to format it
	App.AppDescription=$"
	Shows prices for EUR-TRY<br/>
	Powered by cryptonator.com<br/>
	<small>Created by huseyint</small>
	"$
		
	'SetupInstructions. You can use HTML to format it
	App.SetupInfos= $"
	<b>Nothing to do<br/>
	"$
	
	'How many downloadhandlers should be generated
	App.NeedDownloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(25)
	
	'Tickinterval in ms (should be 65 by default)
	App.TickInterval=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.LockApp=False
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.appSettings=CreateMap()
	
	App.MakeSettings
	Return "AWTRIX2"
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.AppName
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.AppControl(Tag,Params)
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.DownloadURL= "https://free.currencyconverterapi.com/api/v6/convert?q=EUR_TRY&compact=ultra&apiKey=368ebc0b167197fbad19"
	End Select
End Sub

'process the response from each download handler
'if youre working with JSONs you can use this online parser
'to generate the code automaticly
'https://json.blueforcer.de/ 
Sub App_evalJobResponse(Resp As JobResponse)
	Try
		If Resp.success Then
			Select Resp.jobNr
				Case 1
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					Dim pric As Double  = root.Get("EUR_TRY")
					'Dim change As Double  = ticker.Get("change")
					If pric < 100 Then
						price=NumberFormat2(pric,1,2,2,False)
					Else
						price=NumberFormat2(pric,1,0,0,False)
					End If
			End Select
		End If
	Catch
		Log("Error in: "& App.AppName & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub App_genFrame
	App.genText(price,True,1,Null)
	App.drawBMP(0,0,App.getIcon(25),8,8)
End Sub