unit UMain;
{******************************************************************************
 *
 *  LCD Smartie - LCD control software.
 *  Copyright (C) 2000-2003  BassieP
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 *  $Source: /cvsroot/lcdsmartie/lcdsmartie/UMain.pas,v $
 *  $Revision: 1.4 $ $Date: 2004/11/07 23:39:13 $
 *****************************************************************************}

interface

uses Messages, IdHTTP, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdMessageClient, IdPOP3, VaClasses, VaComm, CoolTrayIcon,
  Menus, WinampCtrl, ExtCtrls, Controls, StdCtrls, Buttons, Classes, Forms,
  parport, system2, UConfig, ULCD;

const
  WM_ICONTRAY = WM_USER + 1;   // User-defined message


type
  TBusType     = (btISA, btSMBus,btVIA686ABus, btDirectIO);
  TSMBType     = (smtSMBIntel, smtSMBAMD, smtSMBALi, smtSMBNForce, smtSMBSIS);
  TSensorType  = (stUnknown, stTemperature, stVoltage, stFan, stMhz, stPercentage);

  TSharedIndex = record
    iType : TSensorType;                          // type of sensor
    Count : integer;                              // number of sensor for that type
  end;

  TSharedSensor = record
    ssType    : TSensorType;                      // type of sensor
    ssName    : array [0..11] of AnsiChar;        // name of sensor
    sspadding1: array [0..2] of Char;             // padding of 3 byte
    ssCurrent : Double;                           // current value
    ssLow     : Double;                           // lowest readout
    ssHigh    : Double;                           // highest readout
    ssCount   : LongInt;                          // total number of readout
    sspadding2: array [0..3] of Char;             // padding of 4 byte
    ssTotal   : Extended;                         // total amout of all readouts
    sspadding3: array [0..5] of Char;             // padding of 6 byte
    ssAlarm1  : Double;                           // temp & fan: high alarm; voltage: % off;
    ssAlarm2  : Double;                           // temp: low alarm
  end;

  TSharedInfo = record
    siSMB_Base       : Word;                      // SMBus base address
    siSMB_Type       : TBusType;                  // SMBus/Isa bus used to access chip
    siSMB_Code       : TSMBType;                  // SMBus sub type, Intel, AMD or ALi
    siSMB_Addr       : Byte;                      // Address of sensor chip on SMBus
    siSMB_Name       : array [0..40] of AnsiChar; // Nice name for SMBus
    siISA_Base       : Word;                      // ISA base address of sensor chip on ISA
    siChipType       : Integer;                   // Chip nr, connects with Chipinfo.ini
    siVoltageSubType : Byte;                      // Subvoltage option selected
  end;

  TSharedData =  record
    sdVersion : Double;                           // version number (example: 51090)
    sdIndex   : array [0..9]   of TSharedIndex;   // Sensor index
    sdSensor  : array [0..99]  of TSharedSensor;  // sensor info
    sdInfo    : TSharedInfo;                      // misc. info
    sdStart   : array [0..40]  of AnsiChar;       // start time
    sdCurrent : array [0..40]  of AnsiChar;       // current time
    sdPath    : array [0..255] of AnsiChar;       // MBM path
  end;

  PSharedData   = ^TSharedData;

type
  TMyProc  = function(param1: pchar; param2: pchar): Pchar; stdcall;

type
  THTTPThread = class(TThread)
  private
  protected
    procedure Execute; override;
  end;

type
  Tpop3Thread = class(TThread)
  private
  protected
    procedure Execute; override;
  end;

  TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    Showwindow1: TMenuItem;
    Close1: TMenuItem;
    Button2: TButton;
    Image1: TImage;
    SpeedButton10: TSpeedButton;
    Button1: TButton;
    CoolTrayIcon1: TCoolTrayIcon;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Configure1: TMenuItem;
    BacklightOn1: TMenuItem;
    Commands1: TMenuItem;
    Freeze1: TMenuItem;
    NextTheme1: TMenuItem;
    LastTheme1: TMenuItem;
    N2: TMenuItem;
    Credits1: TMenuItem;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    SpeedButton1: TSpeedButton;
    Panel5: TPanel;
    IdPOP31: TIdPOP3;
    IdPOP32: TIdPOP3;
    IdPOP33: TIdPOP3;
    IdPOP34: TIdPOP3;
    IdPOP35: TIdPOP3;
    IdPOP36: TIdPOP3;
    IdPOP37: TIdPOP3;
    IdPOP38: TIdPOP3;
    IdPOP39: TIdPOP3;
    IdPOP310: TIdPOP3;
    IdHTTP1: TIdHTTP;
    IdHTTP2: TIdHTTP;
    IdHTTP3: TIdHTTP;
    IdHTTP4: TIdHTTP;
    IdHTTP5: TIdHTTP;
    IdHTTP6: TIdHTTP;
    IdHTTP7: TIdHTTP;
    IdHTTP8: TIdHTTP;
    IdHTTP9: TIdHTTP;
    Panel1: TPanel;
    Timertrans: TTimer;
    VaComm1: TVaComm;
    VaComm2: TVaComm;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    Timer4: TTimer;
    Timer5: TTimer;
    Timer6: TTimer;
    Timer7: TTimer;
    Timer8: TTimer;
    Timer9: TTimer;
    Timer10: TTimer;
    Timer11: TTimer;
    Timer12: TTimer;
    Timer13: TTimer;
    WinampCtrl1: TWinampCtrl;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Showwindow1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Configure1Click(Sender: TObject);
    procedure BacklightOn1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure Timer5Timer(Sender: TObject);
    procedure Timer6Timer(Sender: TObject);
    procedure Timer7Timer(Sender: TObject);
    procedure Timer8Timer(Sender: TObject);
    procedure Timer9Timer(Sender: TObject);
    procedure Timer10Timer(Sender: TObject);
    procedure Timer11Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Credits1Click(Sender: TObject);
    procedure NextTheme1Click(Sender: TObject);
    procedure LastTheme1Click(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure Freeze1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Image12MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image12MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image16MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image16MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image17MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image17MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image8MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image9MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image10MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image6MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image7MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image8MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image9MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image10MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image11MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image11MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image12Click(Sender: TObject);
    procedure Image11Click(Sender: TObject);
    procedure Image17Click(Sender: TObject);
    procedure Image16Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Timer13Timer(Sender: TObject);
    procedure TimertransTimer(Sender: TObject);
    procedure Timer12Timer(Sender: TObject);
    procedure WMQueryEndSession (var M: TWMQueryEndSession); message WM_QUERYENDSESSION;
    procedure refres(Sender: TObject);
  private
    function1:TmyProc;
    function2:TmyProc;
    function3:TmyProc;
    function4:TmyProc;
    function5:TmyProc;
    function6:TmyProc;
    function7:TmyProc;
    function8:TmyProc;
    function9:TmyProc;
    function10:TmyProc;
    aantregelsoud,foo2, gpoflash ,flash, backlight:integer;
    whatgpo:integer;
    didMOFan,didWAShuffle,didbltoggle,didgpotoggle,didbl,didwavolup,didwavoldown,didwaplay,didwastop, didwapause,
    didgotoscreen,didgototheme,didfreeze,didrefreshall,didnexttheme,didlasttheme,didnextscreen,didlastscreen,
    didgpo,didgpoflash,didwanexttrack,didwalasttrack,didflash,didsound,didexec:array [1..99] of boolean;
    System1:Tsystem;
    nextline1,nextline2,nextline3,nextline4:Boolean;
    parameter1, parameter2, parameter3, parameter4, file1,distributedlog:string;
    kleuren:Integer;
    koeregel2,koeregel1,uptimereg,uptimeregs:string;
    qstatreg1: array[1..20,1..4] of string;
    qstatreg2: array[1..20,1..4] of string;
    qstatreg3: array[1..20,1..4] of string;
    qstatreg4: array[1..20,1..4] of string;
    qstattemp: integer;
    srvr:string;
    koeregel,resoregel,winampregel,winampregel3,winampregel4:string;
    regelz: array [1..4] of string;
    scrollPos:array[1..4] of integer;
    regel2scroll:integer;
    tmpregel1, tmpregel2, tmpregel3, tmpregel4:string;
    forgroundcoloroff,forgroundcoloron,backgroundcoloroff,backgroundcoloron:integer;
    Oldline:array[1..4] of string;
    Newline:array[1..4] of string;
    oldnewline:array[1..8] of string;
    Gotnewlines:boolean;
    transActietemp,transActietemp2,counter,timertransIntervaltemp:integer;
    gokjesarray:array[1..4,1..40] of boolean;
    dllsarray:array[0..40] of string;
    totaldlls: integer;
    gpo: array [1..8] of boolean;
    doesgpoflash, doesflash: boolean;
    activetheme:integer;
    kar:char;
    STUsername, STComputername, STCPUType, STCPUSpeed: string;
    STPageFree,STPageTotal:Integer;
    STMemFree, STMemTotal: Integer;
    STHDFree,STHDTotal:array[67..90] of Integer;
    STHDBar:string;
    templib:string;
    hlib: cardinal;
    nlib: Integer;
    plib: string;
    tlib: string;
    canscroll,dllcancheck:boolean;
    mbmactive:boolean;
    netadaptername: array[0..9] of String;
    nettotaldown,nettotalup,netunicastdown,netunicastup,
    netnunicastDown,netnunicastUp,netDiscardsDown,netDiscardsUp,
    netErrorsDown,netErrorsUp,netSpeedDownK,netSpeedUpK, netSpeedDownM,
    netSpeedUpM,nettotaldownold,nettotalupold:array[0..9] of double;
    ipaddress:string;
    pop3Thread:Tpop3Thread;
    HTTPThread:THTTPThread;
    Temperature       : array [1..11]  of double;
    Voltage           : array [1..11]  of double;
    Fan               : array [1..11]  of double;
    CPU               : array [1..5]   of double;
    TempName          : array[1..11] of String;
    VoltName          : array[1..11] of String;
    FanName           : array[1..11] of String;
    SharedData   : PSharedData;
    CPUUsage: array [1..5] of Cardinal;
    CPUUsageCount: Cardinal;
    CPUUsagePos: Cardinal;
    STCPUUsage: Cardinal;
    lastCpuUpdate: LongWord;
    function ReadMBM5Data : Boolean;
    function doguess(regel:integer): integer;
    procedure checkIfNewsUpdatesRequired;
    procedure freeze();
    procedure doGPO(const ftemp1,ftemp2:integer);
    procedure kleur();
    procedure backlit();
    function scroll(scrollvar:string;line,speed:integer):string;
    function change(regel:string):string;
    function GetCpuSpeedRegistry(proc: Byte): string;
    procedure customchar(fregel:string);
end;

var
  Lcd: TLCD;
  Form1: TForm1;
  config: TConfig;
  poort1: TParPort;
  frozen: Boolean;
  setupbutton: Integer;
  setupscreen: Integer;
  tempscreen: Integer;
  welkescreen : Integer;
  serversarray:array[1..80] of string;
  actionsarray:array[1..99,1..4] of string;
  scrollline1,scrollline2,scrollline3,scrollline4, scrollline5:Boolean;
  aantalscreensheenweer: Integer;
  combobox8temp: Integer;
  totalactions: Integer;
  HTTPthreadisrunning: Boolean;
  DoNewsUpdate1,DoNewsUpdate2,DoNewsUpdate3,DoNewsUpdate4,DoNewsUpdate5,
  DoNewsUpdate6,DoNewsUpdate7,DoNewsUpdate8,DoNewsUpdate9:integer;
  CNNregel,aexregel,techregel,weerregel,tnetregel,timeregel: String;
  news1,news2,news3,news4,news5,news7,news8,news9: Integer;
  isconnected: Boolean;
  setireg1,setireg2,setireg3,setireg4,setireg5,setireg6,setireg7,setireg8,setireg9:string;
  foldreg1, foldreg2, foldreg3, foldreg4, foldreg5, foldreg6, foldreg7:string;
  weather2: String;
  locationnumber: String;
  pop3threadisrunning: Boolean;
  mailregel1, mailregel2, mailregel3, mailregel4, mailregel5, mailregel6,
  mailregel7, mailregel8, mailregel9, mailregel0:string;
  function stripspaces(Fstring: String): String;

implementation

uses
  Registry, Windows, SysUtils, Graphics,  Dialogs,
  ShellAPI, IpHlpApi,  IpIfConst, IpRtrMib,
  mmsystem, winsock, cxCpu40, USetup, UCredits,
  ULCD_MO, ULCD_CF, ULCD_HD, adCpuUsage;

function TForm1.doguess(regel:integer): integer;
var
  goedgokje:boolean;
  gokje:integer;

begin
  goedgokje:=false;
  gokje:=0;
  while goedgokje = false do begin
    gokje:=round(random(config.width)+1);
    if gokjesarray[regel,gokje]=false then begin
      gokjesarray[regel,gokje]:=true;
      goedgokje:=true;
    end;
  end;
  result:=gokje;
end;

procedure TForm1.customchar(fregel:string);
var
  character:integer;
  waarde:array[0..7] of Byte;
  i:integer;

begin
  character:=StrToInt(copy(fregel,1,pos(',',fregel)-1));
  fregel:=copy(fregel,pos(',',fregel)+1,length(fregel));
  for i:=0 to 6 do begin
    waarde[i]:=StrToInt(copy(fregel,1,pos(',',fregel)-1));
    fregel:=copy(fregel,pos(',',fregel)+1,length(fregel));
  end;
  waarde[7]:=StrToInt(copy(fregel,1,length(fregel)));

  Lcd.customChar(character, waarde);
end;


function stripspaces(Fstring:string): string;
begin
  while copy(fstring,1,1) = ' ' do begin
    fstring:=copy(fstring,2,length(fstring));
  end;
  while copy(fstring,length(fstring),1) = ' ' do begin
    fstring:=copy(fstring,1,length(fstring)-1);
  end;
  while copy(fstring,1,1) = chr(10) do begin
    fstring:=copy(fstring,2,length(fstring));
  end;
  while copy(fstring,length(fstring),1) = chr(10) do begin
    fstring:=copy(fstring,1,length(fstring)-1);
  end;
  while copy(fstring,1,1) = chr(13) do begin
    fstring:=copy(fstring,2,length(fstring));
  end;
  while copy(fstring,length(fstring),1) = chr(13) do begin
    fstring:=copy(fstring,1,length(fstring)-1);
  end;
  result:=fstring;
end;

function TForm1.ReadMBM5Data : Boolean;
  var     myHandle, B, TotalCount : Integer;
          temptemp,tempfan,tempmhz,tempvolt:integer;
begin
  myHandle :=  OpenFileMapping(FILE_MAP_READ, False, '$M$B$M$5$S$D$');
  if myHandle > 0 then begin
    SharedData := MapViewOfFile(myHandle, FILE_MAP_READ, 0, 0, 0);
    with SharedData^ do begin
      TotalCount := sdIndex[0].Count +
                    sdIndex[1].Count +
                    sdIndex[2].Count +
                    sdIndex[3].Count +
                    sdIndex[4].Count;
      temptemp:=0;
      tempfan:=0;
      tempvolt:=0;
      tempmhz:=0;
      for B := 0 to TotalCount - 1 do begin
        with sdSensor[B] do begin
          if ssType = stTemperature then begin
            temptemp:=temptemp+1;
            if temptemp > 11 then temptemp:= 11;
            Temperature[temptemp]:=ssCurrent;
            TempName[temptemp]:=ssName;
          end;
          if ssType = stVoltage then begin
            tempvolt:=tempvolt+1;
            if tempvolt > 11 then tempvolt:= 11;
            Voltage[tempvolt]:=round(ssCurrent*100)/100;
            VoltName[tempvolt]:=ssName;
          end;
          if ssType = stFan then begin
            tempfan:=tempfan+1;
            if tempfan > 11 then tempfan:= 11;
            Fan[tempfan]:=ssCurrent;
            FanName[tempfan]:=ssName;
          end;
          if ssType = stMhz then begin
            tempmhz:=tempmhz+1;
            if tempmhz > 5 then tempmhz:= 5;
            CPU[tempmhz]:=ssCurrent;
          end;
        end;
      end;
    end;
    UnMapViewOfFile(SharedData);
    Result := True;
  end else result := false;
  CloseHandle(myHandle);
end;

function TForm1.scroll(scrollvar:string;line,speed:integer):string;
var
  scrolltext:string;

begin
  if length(scrollvar) > config.width then begin
    if (scrollPos[line] < length(scrollvar)) and (scrollPos[line] <> 0) then
      scrollPos[line]:=scrollPos[line]+speed
    else
      scrollPos[line]:=1;
    scrolltext:=copy(scrollvar, scrollPos[line], config.width);

    if length(scrolltext) < config.width then begin
      scrolltext:=scrolltext+copy(scrollvar,1,config.width-length(scrolltext)+1);
    end;
    result:=scrolltext;
  end else result:=scrollvar;
end;

function TForm1.change(regel:string):string;
const
  ticksperweek    : integer = 3600000*24*7;
  ticksperdag     : integer = 3600000*24;
  ticksperhour    : integer = 3600000;
  ticksperminute  : integer = 60000;
  ticksperseconde : integer = 1000;

var
  FileStream: TFileStream;
  Lines: TStringList;
  t: longword;
  letter,spacecount,x,i,ii,w, d, h, m, s : integer;
  winamppositie, teller, teller2,teller3:integer;
  tempst,winamptimereg,fileline,fileloc,spaceline,winamptitle, ss,regel2,regel3:string;
  bestand,bestand3:textfile;
  ccount:double;
  templine:array[1..20] of string;
  hdteller:integer;
  td,ttD,ttF,tg,ttG,th,ttH,ti,ttI,
  tj,tl,tm,ttM,tn,ts,tw,ttY,ty: string;

begin
    hdteller:=0;
    while pos('$LogFile("',regel) <> 0 do begin
      hdteller:=hdteller+1;
      if hdteller>4 then regel:=StringReplace(regel,'$LogFile("','error', []);

      try
        spaceline:=copy(regel, pos('$LogFile("',regel)+10,length(regel));
        fileloc:=copy(spaceline, 1,pos('"',spaceline)-1);
        fileline:=copy(spaceline,pos('",',spaceline)+2,pos(')',spaceline)-pos('",',spaceline)-2);
        if fileline > '3' then fileline:='3';
        if fileline < '0' then fileline:='0';
        try
          SetLength(spaceline, 1024);
          FileStream:= TFileStream.Create(fileloc, fmOpenRead or fmShareDenyNone);
          FileStream.Seek(-1 * 1024, soFromEnd);
          FileStream.ReadBuffer(spaceline[1], 1024);
          FileStream.Free;

          Lines:= TStringList.Create;
          Lines.Text:= spaceline;
          spaceline:=stripspaces(lines[lines.count-1-strtoint(fileline)]);
          spaceline:=copy(spaceline, pos('] ',spaceline)+3,length(spaceline));
          for i:=0 to 7 do spaceline:=StringReplace(spaceline, chr(I),'',[rfReplaceAll]);
          Lines.Free;
          regel:=StringReplace(regel,'$LogFile("' + fileloc + '",' + fileline + ')',spaceline, []);
        except
          regel:=StringReplace(regel,'$LogFile("','error', []);
        end;
      except
        regel:=StringReplace(regel,'$LogFile("','error', []);
      end;
    end;

    while pos('$File("',regel) <> 0 do begin
      spaceline:=copy(regel, pos('$File("',regel)+7,length(regel));
      fileloc:=copy(spaceline, 1,pos('"',spaceline)-1);
      fileline:=copy(spaceline,pos('",',spaceline)+2,pos(')',spaceline)-pos('",',spaceline)-2);

      try
        assignfile(bestand3, fileloc);
        reset(bestand3);
        for teller3:= 1 to StrToInt(fileline) do
       readln(bestand3, regel3);
        closefile(bestand3);
        regel:=StringReplace(regel,'$File("' + fileloc + '",' + fileline + ')',regel3, []);
      except
        regel:=StringReplace(regel,fileloc,'', []);
        regel:=StringReplace(regel,'$File("','', []);
      end;
    end;

    if pos('$WinampTitle',regel) <> 0 then begin
      ss:=form1.winampctrl1.GetCurrSongTitle;
      regel:=StringReplace(regel,'$WinampTitle',copy(ss,pos('. ',ss)+2,length(ss)-pos('. ',ss)-2),[rfReplaceAll]);
    end;
    if pos('$WinampChannels',regel) <> 0 then begin
      if form1.winampctrl1.GetSongInfo(2)>1 then winampregel3:='stereo' else winampregel3:='mono';
      regel:=StringReplace(regel,'$WinampChannels',winampregel3,[rfReplaceAll]);
    end;
    if pos('$WinampKBPS',regel) <> 0 then begin
      regel:=StringReplace(regel,'$WinampKBPS',IntToStr(form1.winampctrl1.GetSongInfo(1)),[rfReplaceAll]);
    end;
    if pos('$WinampFreq',regel) <> 0 then begin
      regel:=StringReplace(regel,'$WinampFreq',IntToStr(form1.winampctrl1.GetSongInfo(0)),[rfReplaceAll]);
    end;
    if pos('$WinampStat',regel) <> 0 then begin
      if form1.winampctrl1.GetState = 1 then regel:=StringReplace(regel,'$WinampStat','playing',[rfReplaceAll]);
      if form1.winampctrl1.GetState = 0 then regel:=StringReplace(regel,'$WinampStat','stopped',[rfReplaceAll]);
      if form1.winampctrl1.GetState = 3 then regel:=StringReplace(regel,'$WinampStat','paused',[rfReplaceAll]);
    end;
    while pos('$WinampPosition(',regel) <> 0 do begin
      try
        letter:=pos('$WinampPosition(',regel)+16;
        winampregel4:=copy(regel,letter,length(regel));
        spacecount:=strtoint(copy(winampregel4,1,pos(')',winampregel4)-1));
        winampregel4:='';
        winamppositie:=round((form1.winampctrl1.TrackPosition / 1000 -0.4) /form1.winampctrl1.TrackLength * spacecount);
        for teller2:=1 to winamppositie -1 do winampregel4:=winampregel4+ '-';
        winampregel4:=winampregel4+ '+';
        for teller2:=winamppositie +1 to spacecount do winampregel4:=winampregel4+ '-';
        winampregel4:=copy(winampregel4,1,spacecount);
        regel:=StringReplace(regel,'$WinampPosition('+inttostr(spacecount)+')',winampregel4,[]);
      except
        regel:=StringReplace(regel,'$WinampPosition(','error',[]);
      end;
    end;

    if pos('$WinampPolo',regel) <> 0 then begin
      t:=form1.Winampctrl1.TrackPosition;
      if t/1000> form1.winampctrl1.TrackLength then t:=0;
      h := t div ticksperhour;
      t:=t -h * ticksperhour;
      m := t div ticksperminute;
      t:=t -m * ticksperminute;
      s := t div ticksperseconde;
      winamptimereg:='';
      if h>0 then begin
        winamptimereg:=winamptimereg+IntToStr(h)+ 'hrs ';
        winamptimereg:=winamptimereg+formatfloat('00', m)+ 'min ';
        winamptimereg:=winamptimereg+formatfloat('00', s)+ 'sec';
      end else begin
        if m>0 then begin
          winamptimereg:=winamptimereg+IntToStr(m)+ 'min ';
          winamptimereg:=winamptimereg+formatfloat('00', s)+ 'sec';
        end else begin
          winamptimereg:=winamptimereg+IntToStr(s)+ 'sec';
        end;
      end;
      regel:=StringReplace(regel,'$WinampPolo',winamptimereg,[rfReplaceAll]);
    end;
    if pos('$WinampRelo',regel) <> 0 then begin
      t:=form1.Winampctrl1.TrackLength*1000 - form1.WinampCtrl1.TrackPosition;
      if t/1000> form1.winampctrl1.TrackLength then t:=0;
      h := t div ticksperhour;
      t:=t -h * ticksperhour;
      m := t div ticksperminute;
      t:=t -m * ticksperminute;
      s := t div ticksperseconde;
      winamptimereg:='';
      if h>0 then begin
        winamptimereg:=winamptimereg+IntToStr(h)+ 'hrs ';
        winamptimereg:=winamptimereg+formatfloat('00', m)+ 'min ';
        winamptimereg:=winamptimereg+formatfloat('00', s)+ 'sec';
      end else begin
        if m>0 then begin
          winamptimereg:=winamptimereg+IntToStr(m)+ 'min ';
          winamptimereg:=winamptimereg+formatfloat('00', s)+ 'sec';
        end else begin
          winamptimereg:=winamptimereg+IntToStr(s)+ 'sec';
        end;
      end;
      regel:=StringReplace(regel,'$WinampRelo',winamptimereg,[rfReplaceAll]);
    end;
    if pos('$WinampPosh',regel) <> 0 then begin
      t:=form1.Winampctrl1.TrackPosition;
      if t/1000> form1.winampctrl1.TrackLength then t:=0;
      h := t div ticksperhour;
      t:=t -h * ticksperhour;
      m := t div ticksperminute;
      t:=t -m * ticksperminute;
      s := t div ticksperseconde;
      winamptimereg:='';
      if h>0 then begin
        winamptimereg:=winamptimereg+IntToStr(h)+ ':';
        winamptimereg:=winamptimereg+formatfloat('00', m)+ ':';
        winamptimereg:=winamptimereg+formatfloat('00', s);
      end else begin
        if m>0 then begin
          winamptimereg:=winamptimereg+IntToStr(m)+ ':';
          winamptimereg:=winamptimereg+formatfloat('00', s);
        end else begin
          winamptimereg:=winamptimereg+IntToStr(s);
        end;
      end;
      regel:=StringReplace(regel,'$WinampPosh',winamptimereg,[rfReplaceAll]);
    end;
    if pos('$WinampResh',regel) <> 0 then begin
      t:=form1.Winampctrl1.TrackLength*1000 - form1.WinampCtrl1.TrackPosition;
      if t /1000 > form1.winampctrl1.TrackLength then t:=0;
      h := t div ticksperhour;
      t:=t -h * ticksperhour;
      m := t div ticksperminute;
      t:=t -m * ticksperminute;
      s := t div ticksperseconde;
      winamptimereg:='';
      if h>0 then begin
        winamptimereg:=winamptimereg+IntToStr(h)+ ':';
        winamptimereg:=winamptimereg+formatfloat('00', m)+ ':';
        winamptimereg:=winamptimereg+formatfloat('00', s);
      end else begin
        if m>0 then begin
          winamptimereg:=winamptimereg+IntToStr(m)+ ':';
          winamptimereg:=winamptimereg+formatfloat('00', s);
        end else begin
          winamptimereg:=winamptimereg+IntToStr(s);
        end;
      end;
      regel:=StringReplace(regel,'$WinampResh',winamptimereg,[rfReplaceAll]);
    end;
    if pos('$Winamppos',regel) <> 0 then begin
      t:=round(form1.winampctrl1.TrackPosition / 1000-0.4);
      if t> form1.winampctrl1.TrackLength then t:=0;
      regel:=StringReplace(regel,'$Winamppos',IntToStr(t),[rfReplaceAll]);
    end;
    if pos('$WinampRem',regel) <> 0 then begin
      t:=round(form1.winampctrl1.tracklength-form1.winampctrl1.TrackPosition / 1000-0.4);
      if t> form1.winampctrl1.TrackLength then t:=0;
      regel:=StringReplace(regel,'$WinampRem',IntToStr(t),[rfReplaceAll]);
    end;
    if pos('$WinampLengtl',regel) <> 0 then begin
      t:=form1.Winampctrl1.TrackLength*1000;
      h := t div ticksperhour;
      t:=t -h * ticksperhour;
      m := t div ticksperminute;
      t:=t -m * ticksperminute;
      s := t div ticksperseconde;
      winamptimereg:='';
      if h>0 then begin
        winamptimereg:=winamptimereg+IntToStr(h)+ 'hrs ';
        winamptimereg:=winamptimereg+formatfloat('00', m)+ 'min ';
        winamptimereg:=winamptimereg+formatfloat('00', s)+ 'sec';
      end else begin
        if m>0 then begin
          winamptimereg:=winamptimereg+IntToStr(m)+ 'min ';
          winamptimereg:=winamptimereg+formatfloat('00', s)+ 'sec';
        end else begin
          winamptimereg:=winamptimereg+IntToStr(s)+ 'sec';
        end;
      end;
      regel:=StringReplace(regel,'$WinampLengtl',winamptimereg,[rfReplaceAll]);
    end;
    if pos('$WinampLengts',regel) <> 0 then begin
      t:=form1.Winampctrl1.TrackLength*1000;
      h := t div ticksperhour;
      t:=t -h * ticksperhour;
      m := t div ticksperminute;
      t:=t -m * ticksperminute;
      s := t div ticksperseconde;
      winamptimereg:='';
      if h>0 then begin
        winamptimereg:=winamptimereg+IntToStr(h)+ ':';
        winamptimereg:=winamptimereg+formatfloat('00', m)+ ':';
        winamptimereg:=winamptimereg+formatfloat('00', s);
      end else begin
        if m>0 then begin
          winamptimereg:=winamptimereg+IntToStr(m)+ ':';
          winamptimereg:=winamptimereg+formatfloat('00', s);
        end else begin
          winamptimereg:=winamptimereg+IntToStr(s);
        end;
      end;
      regel:=StringReplace(regel,'$WinampLengts',winamptimereg,[rfReplaceAll]);
    end;
    if pos('$WinampLength',regel) <> 0 then begin
      regel:=StringReplace(regel,'$WinampLength',IntToStr(form1.winampctrl1.TrackLength),[rfReplaceAll]);
    end;

    if pos('$WinampTracknr',regel) <> 0 then begin
      regel:=StringReplace(regel,'$WinampTracknr',IntToStr(form1.winampctrl1.GetListPos +1),[rfReplaceAll]);
    end;
    if pos('$WinampTotalTracks',regel) <> 0 then begin
      regel:=StringReplace(regel,'$WinampTotalTracks',IntToStr(form1.winampctrl1.GetListCount),[rfReplaceAll]);
    end;

    regel:=StringReplace(regel,'$UpTime',uptimereg,[rfReplaceAll]);
    regel:=StringReplace(regel,'$UpTims',uptimeregs,[rfReplaceAll]);

    regel:=StringReplace(regel,'$NetIPaddress',ipaddress,[rfReplaceAll]);

    regel:=StringReplace(regel,'$Username',STUsername,[rfReplaceAll]);
    regel:=StringReplace(regel,'$Computername',STcomputername,[rfReplaceAll]);
    regel:=StringReplace(regel,'$CPUType',STCPUType,[rfReplaceAll]);
    regel:=StringReplace(regel,'$CPUSpeed',STCPUSpeed,[rfReplaceAll]);
    regel:=StringReplace(regel,'$CPUUsage%',IntToStr(STCPUUsage),[rfReplaceAll]);
    regel:=StringReplace(regel,'$MemFree',IntToStr(STMemFree),[rfReplaceAll]);
    regel:=StringReplace(regel,'$MemUsed',IntToStr(STMemTotal-STMemFree),[rfReplaceAll]);
    regel:=StringReplace(regel,'$MemTotal',IntToStr(STMemTotal),[rfReplaceAll]);
    regel:=StringReplace(regel,'$PageFree',IntToStr(STPageFree),[rfReplaceAll]);
    regel:=StringReplace(regel,'$PageUsed',IntToStr(STPageTotal-STPageFree),[rfReplaceAll]);
    regel:=StringReplace(regel,'$PageTotal',IntToStr(STPageTotal),[rfReplaceAll]);
    regel:=StringReplace(regel,'$ScreenReso',ResoRegel,[rfReplaceAll]);

    regel:=StringReplace(regel,'$Tempname1',TempName[1],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Tempname2',TempName[2],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Tempname3',TempName[3],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Tempname4',TempName[4],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Tempname5',TempName[5],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Tempname6',TempName[6],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Tempname7',TempName[7],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Tempname8',TempName[8],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Tempname9',TempName[9],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Tempname10',TempName[10],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Fanname1',Fanname[1],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Fanname2',Fanname[2],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Fanname3',Fanname[3],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Fanname4',Fanname[4],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Fanname5',Fanname[5],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Fanname6',Fanname[6],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Fanname7',Fanname[7],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Fanname8',Fanname[8],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Fanname9',Fanname[9],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Fanname10',Fanname[10],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltname1',Voltname[1],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltname2',Voltname[2],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltname3',Voltname[3],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltname4',Voltname[4],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltname5',Voltname[5],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltname6',Voltname[6],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltname7',Voltname[7],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltname8',Voltname[8],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltname9',Voltname[9],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltname10',Voltname[10],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Temp1',FloatToStr(Temperature[1]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Temp2',FloatToStr(Temperature[2]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Temp3',FloatToStr(Temperature[3]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Temp4',FloatToStr(Temperature[4]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Temp5',FloatToStr(Temperature[5]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Temp6',FloatToStr(Temperature[6]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Temp7',FloatToStr(Temperature[7]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Temp8',FloatToStr(Temperature[8]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Temp9',FloatToStr(Temperature[9]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Temp10',FloatToStr(Temperature[10]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$FanS1',FloatToStr(Fan[1]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$FanS2',FloatToStr(Fan[2]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$FanS3',FloatToStr(Fan[3]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$FanS4',FloatToStr(Fan[4]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$FanS5',FloatToStr(Fan[5]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$FanS6',FloatToStr(Fan[6]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$FanS7',FloatToStr(Fan[7]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$FanS8',FloatToStr(Fan[8]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$FanS9',FloatToStr(Fan[9]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$FanS10',FloatToStr(Fan[10]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltage1',FloatToStr(Voltage[1]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltage2',FloatToStr(Voltage[2]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltage3',FloatToStr(Voltage[3]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltage4',FloatToStr(Voltage[4]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltage5',FloatToStr(Voltage[5]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltage6',FloatToStr(Voltage[6]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltage7',FloatToStr(Voltage[7]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltage8',FloatToStr(Voltage[8]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltage9',FloatToStr(Voltage[9]),[rfReplaceAll]);
    regel:=StringReplace(regel,'$Voltage10',FloatToStr(Voltage[10]),[rfReplaceAll]);

    regel:=StringReplace(regel,'$Half-life1',qstatreg1[welkescreen,qstattemp],[rfReplaceAll]);
    regel:=StringReplace(regel,'$QuakeII1',qstatreg1[welkescreen,qstattemp],[rfReplaceAll]);
    regel:=StringReplace(regel,'$QuakeIII1',qstatreg1[welkescreen,qstattemp],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Unreal1',qstatreg1[welkescreen,qstattemp],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Half-life2',qstatreg2[welkescreen,qstattemp],[rfReplaceAll]);
    regel:=StringReplace(regel,'$QuakeII2',qstatreg2[welkescreen,qstattemp],[rfReplaceAll]);
    regel:=StringReplace(regel,'$QuakeIII2',qstatreg2[welkescreen,qstattemp],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Unreal2',qstatreg2[welkescreen,qstattemp],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Half-life3',qstatreg3[welkescreen,qstattemp],[rfReplaceAll]);
    regel:=StringReplace(regel,'$QuakeII3',qstatreg3[welkescreen,qstattemp],[rfReplaceAll]);
    regel:=StringReplace(regel,'$QuakeIII3',qstatreg3[welkescreen,qstattemp],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Unreal3',qstatreg3[welkescreen,qstattemp],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Half-life4',qstatreg4[welkescreen,qstattemp],[rfReplaceAll]);
    regel:=StringReplace(regel,'$QuakeII4',qstatreg4[welkescreen,qstattemp],[rfReplaceAll]);
    regel:=StringReplace(regel,'$QuakeIII4',qstatreg4[welkescreen,qstattemp],[rfReplaceAll]);
    regel:=StringReplace(regel,'$Unreal4',qstatreg4[welkescreen,qstattemp],[rfReplaceAll]);

    regel:=StringReplace(regel,'$CNN',CNNregel,[rfReplaceAll]);
    regel:=StringReplace(regel,'$Stocks',aexregel,[rfReplaceAll]);
    regel:=StringReplace(regel,'$TomsHW',techregel,[rfReplaceAll]);
    regel:=StringReplace(regel,'$T.netHL',tnetregel,[rfReplaceAll]);
    regel:=StringReplace(regel,'$DutchWeather',weerregel,[rfReplaceAll]);
    regel:=StringReplace(regel,'$Weather.com('+locationnumber+')',weather2,[rfReplaceAll]);

    regel:=StringReplace(regel,'$Email1',mailregel1,[rfReplaceAll]);
    regel:=StringReplace(regel,'$Email2',mailregel2,[rfReplaceAll]);
    regel:=StringReplace(regel,'$Email3',mailregel3,[rfReplaceAll]);
    regel:=StringReplace(regel,'$Email4',mailregel4,[rfReplaceAll]);
    regel:=StringReplace(regel,'$Email5',mailregel5,[rfReplaceAll]);
    regel:=StringReplace(regel,'$Email6',mailregel6,[rfReplaceAll]);
    regel:=StringReplace(regel,'$Email7',mailregel7,[rfReplaceAll]);
    regel:=StringReplace(regel,'$Email8',mailregel8,[rfReplaceAll]);
    regel:=StringReplace(regel,'$Email9',mailregel9,[rfReplaceAll]);
    regel:=StringReplace(regel,'$Email0',mailregel0,[rfReplaceAll]);

    regel:=StringReplace(regel,'$DnetDone',koeregel2,[rfReplaceAll]);
    regel:=StringReplace(regel,'$DnetSpeed',koeregel1,[rfReplaceAll]);

    regel:=StringReplace(regel,'$SETIResults',setireg1,[rfReplaceAll]);
    regel:=StringReplace(regel,'$SETICPUTime',setireg2,[rfReplaceAll]);
    regel:=StringReplace(regel,'$SETIAverage',setireg3,[rfReplaceAll]);
    regel:=StringReplace(regel,'$SETILastresult',setireg4,[rfReplaceAll]);
    regel:=StringReplace(regel,'$SETIusertime',setireg5,[rfReplaceAll]);
    regel:=StringReplace(regel,'$SETItotalusers',setireg6,[rfReplaceAll]);
    regel:=StringReplace(regel,'$SETIrank',setireg7,[rfReplaceAll]);
    regel:=StringReplace(regel,'$SETIsharingrank',setireg8,[rfReplaceAll]);
    regel:=StringReplace(regel,'$SETImoreWU',setireg9,[rfReplaceAll]);

    regel:=StringReplace(regel,'$FOLDmemsince',foldreg1,[rfReplaceAll]);
    regel:=StringReplace(regel,'$FOLDlastwu',foldreg2,[rfReplaceAll]);
    regel:=StringReplace(regel,'$FOLDactproc',foldreg3,[rfReplaceAll]);
    regel:=StringReplace(regel,'$FOLDteam',foldreg4,[rfReplaceAll]);
    regel:=StringReplace(regel,'$FOLDscore',foldreg5,[rfReplaceAll]);
    regel:=StringReplace(regel,'$FOLDrank',foldreg6,[rfReplaceAll]);
    regel:=StringReplace(regel,'$FOLDwu',foldreg7,[rfReplaceAll]);


    while pos('$Time(',regel) <> 0 do begin
      try
        regel2:=copy(regel, pos('$Time(',regel)+6,length(regel));
        regel2:=copy(regel2, 1, pos(')',regel2)-1);
        timeregel:=formatdatetime(regel2,now);
        regel:=StringReplace(regel,'$Time('+regel2+')',timeregel,[]);
      except
        regel:=StringReplace(regel,'$Time(','error',[]);
      end;
    end;

    while pos('$NetAdapter(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetAdapter(',regel)+12,1));
        regel:=StringReplace(regel,'$NetAdapter('+intToStr(spacecount)+')',netadaptername[spacecount],[]);
      except
        regel:=StringReplace(regel,'$NetAdapter(','error',[]);
      end;
    end;
    while pos('$NetDownK(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetDownK(',regel)+10,1));
        regel:=StringReplace(regel,'$NetDownK('+intToStr(spacecount)+')',floatToStr(Round(nettotaldown[spacecount]/1024*10)/10),[]);
      except
        regel:=StringReplace(regel,'$NetDownK(','error',[]);
      end;
    end;
    while pos('$NetUpK(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetUpK(',regel)+8,1));
        regel:=StringReplace(regel,'$NetUpK('+intToStr(spacecount)+')',floatToStr(Round(nettotalup[spacecount]/1024*10)/10),[]);
      except
        regel:=StringReplace(regel,'$NetUpK(','error',[]);
      end;
    end;
    while pos('$NetDownM(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetDownM(',regel)+10,1));
        regel:=StringReplace(regel,'$NetDownM('+intToStr(spacecount)+')',floatToStr(Round(nettotaldown[spacecount]/1024/1024*10)/10),[]);
      except
        regel:=StringReplace(regel,'$NetDownM(','error',[]);
      end;
    end;
    while pos('$NetUpM(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetUpM(',regel)+8,1));
        regel:=StringReplace(regel,'$NetUpM('+intToStr(spacecount)+')',floatToStr(Round(nettotalup[spacecount]/1024/1024*10)/10),[]);
      except
        regel:=StringReplace(regel,'$NetUpM(','error',[]);
      end;
    end;
    while pos('$NetDownG(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetDownG(',regel)+10,1));
        regel:=StringReplace(regel,'$NetDownG('+intToStr(spacecount)+')',floatToStr(Round(nettotaldown[spacecount]/1024/1024/1024*10)/10),[]);
      except
        regel:=StringReplace(regel,'$NetDownG(','error',[]);
      end;
    end;
    while pos('$NetUpG(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetUpG(',regel)+8,1));
        regel:=StringReplace(regel,'$NetUpG('+intToStr(spacecount)+')',floatToStr(Round(nettotalup[spacecount]/1024/1024/1024*10)/10),[]);
      except
        regel:=StringReplace(regel,'$NetUpG(','error',[]);
      end;
    end;
    while pos('$NetErrDown(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetErrDown(',regel)+12,1));
        regel:=StringReplace(regel,'$NetErrDown('+intToStr(spacecount)+')',FloatToStr(netErrorsDown[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetErrDown(','error',[]);
      end;
    end;
    while pos('$NetErrUp(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetErrUp(',regel)+10,1));
        regel:=StringReplace(regel,'$NetErrUp('+intToStr(spacecount)+')',FloatToStr(netErrorsUp[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetErrUp(','error',[]);
      end;
    end;
    while pos('$NetErrTot(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetErrTot(',regel)+11,1));
        regel:=StringReplace(regel,'$NetErrTot('+intToStr(spacecount)+')',FloatToStr(netErrorsDown[spacecount]+netErrorsUp[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetErrTot(','error',[]);
      end;
    end;
    while pos('$NetUniDown(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetUniDown(',regel)+12,1));
        regel:=StringReplace(regel,'$NetUniDown('+intToStr(spacecount)+')',FloatToStr(netunicastdown[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetUniDown(','error',[]);
      end;
    end;
    while pos('$NetUniUp(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetUniUp(',regel)+10,1));
        regel:=StringReplace(regel,'$NetUniUp('+intToStr(spacecount)+')',FloatToStr(netunicastup[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetUniUp(','error',[]);
      end;
    end;
    while pos('$NetUniTot(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetUniTot(',regel)+11,1));
        regel:=StringReplace(regel,'$NetUniTot('+intToStr(spacecount)+')',FloatToStr(netunicastup[spacecount]+netunicastdown[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetUniTot(','error',[]);
      end;
    end;
    while pos('$NetNuniDown(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetNuniDown(',regel)+13,1));
        regel:=StringReplace(regel,'$NetNuniDown('+intToStr(spacecount)+')',FloatToStr(netnunicastdown[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetNuniDown(','error',[]);
      end;
    end;
    while pos('$NetNuniUp(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetNuniUp(',regel)+11,1));
        regel:=StringReplace(regel,'$NetNuniUp('+intToStr(spacecount)+')',FloatToStr(netnunicastup[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetNuniUp(','error',[]);
      end;
    end;
    while pos('$NetNuniTot(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetNuniTot(',regel)+12,1));
        regel:=StringReplace(regel,'$NetNuniTot('+intToStr(spacecount)+')',FloatToStr(netnunicastup[spacecount]+netnunicastdown[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetNuniTot(','error',[]);
      end;
    end;
    while pos('$NetPackTot(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetPackTot(',regel)+12,1));
        regel:=StringReplace(regel,'$NetPackTot('+intToStr(spacecount)+')',FloatToStr(netnunicastup[spacecount]+netnunicastdown[spacecount]+netunicastdown[spacecount]+netunicastup[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetPackTot(','error',[]);
      end;
    end;
    while pos('$NetDiscDown(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetDiscDown(',regel)+13,1));
        regel:=StringReplace(regel,'$NetDiscDown('+intToStr(spacecount)+')',FloatToStr(netDiscardsdown[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetDiscDown(','error',[]);
      end;
    end;
    while pos('$NetDiscUp(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetDiscUp(',regel)+11,1));
        regel:=StringReplace(regel,'$NetDiscUp('+intToStr(spacecount)+')',FloatToStr(netDiscardsup[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetDiscUp(','error',[]);
      end;
    end;
    while pos('$NetDiscTot(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetDiscTot(',regel)+12,1));
        regel:=StringReplace(regel,'$NetDiscTot('+intToStr(spacecount)+')',FloatToStr(netDiscardsup[spacecount]+netDiscardsdown[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetDiscTot(','error',[]);
      end;
    end;
    while pos('$NetSpDownK(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetSpDownK(',regel)+12,1));
        regel:=StringReplace(regel,'$NetSpDownK('+intToStr(spacecount)+')',FloatToStr(netSpeeddownK[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetSpDownK(','error',[]);
      end;
    end;
    while pos('$NetSpUpK(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetSpUpK(',regel)+10,1));
        regel:=StringReplace(regel,'$NetSpUpK('+intToStr(spacecount)+')',FloatToStr(netSpeedupK[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetSpUpK(','error',[]);
      end;
    end;
    while pos('$NetSpDownM(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetSpDownM(',regel)+12,1));
        regel:=StringReplace(regel,'$NetSpDownM('+intToStr(spacecount)+')',FloatToStr(netSpeeddownM[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetSpDownM(','error',[]);
      end;
    end;
    while pos('$NetSpUpM(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(regel,pos('$NetSpUpM(',regel)+10,1));
        regel:=StringReplace(regel,'$NetSpUpM('+intToStr(spacecount)+')',FloatToStr(netSpeedupM[spacecount]),[]);
      except
        regel:=StringReplace(regel,'$NetSpUpM(','error',[]);
      end;
    end;

    if pos('$MemF%',regel) <> 0 then regel:=StringReplace(regel,'$MemF%', IntToStr(round(100/STMemTotal*STMemfree)),[rfReplaceAll]);
    if pos('$MemU%',regel) <> 0 then regel:=StringReplace(regel,'$MemU%', IntToStr(round(100/STMemTotal*(STMemTotal-STMemfree))),[rfReplaceAll]);

    if pos('$PageF%',regel) <> 0 then regel:=StringReplace(regel,'$PageF%', IntToStr(round(100/STPageTotal*STPagefree)),[rfReplaceAll]);
    if pos('$PageU%',regel) <> 0 then regel:=StringReplace(regel,'$PageU%', IntToStr(round(100/STPageTotal*(STPageTotal-STPagefree))),[rfReplaceAll]);

    hdteller:=0;
    while pos('$HDFreg(',regel) <> 0 do begin
      try
        hdteller:=hdteller+1;
        if hdteller>10 then regel:=StringReplace(regel,'$HDFreg(','error',[rfReplaceAll]);
        letter:=ord(upcase(copy(regel,pos('$HDFreg(',regel)+8,1)[1]));
        regel:=StringReplace(regel,'$HDFreg('+copy(regel,pos('$HDFreg(',regel)+8,1)+')',IntToStr(round(STHDFree[letter]/1024)),[rfReplaceAll]);
      except
      end;
    end;
    hdteller:=0;
    while pos('$HDFree(',regel) <> 0 do begin
      try
        hdteller:=hdteller+1;
        if hdteller>10 then regel:=StringReplace(regel,'$HDFree(','error',[rfReplaceAll]);
        letter:=ord(upcase(copy(regel,pos('$HDFree(',regel)+8,1)[1]));
        regel:=StringReplace(regel,'$HDFree('+copy(regel,pos('$HDFree(',regel)+8,1)+')',IntToStr(STHDFree[letter]),[rfReplaceAll]);
      except
      end;
    end;
    hdteller:=0;
    while pos('$HDUseg(',regel) <> 0 do begin
      try
        hdteller:=hdteller+1;
        if hdteller>10 then regel:=StringReplace(regel,'$HDUseg(','error',[rfReplaceAll]);
        letter:=ord(upcase(copy(regel,pos('$HDUseg(',regel)+8,1)[1]));
        regel2:=IntToStr(round((STHDTotal[letter]-STHDFree[letter])/1024));
        regel:=StringReplace(regel,'$HDUseg('+copy(regel,pos('$HDUseg(',regel)+8,1)+')',regel2,[rfReplaceAll]);
      except
      end;
    end;
    hdteller:=0;
    while pos('$HDUsed(',regel) <> 0 do begin
      try
        hdteller:=hdteller+1;
        if hdteller>10 then regel:=StringReplace(regel,'$HDUsed(','error',[rfReplaceAll]);
        letter:=ord(upcase(copy(regel,pos('$HDUsed(',regel)+8,1)[1]));
        regel2:=IntToStr(round(STHDTotal[letter]-STHDFree[letter]));
        regel:=StringReplace(regel,'$HDUsed('+copy(regel,pos('$HDUsed(',regel)+8,1)+')',regel2,[rfReplaceAll]);
      except
      end;
    end;
    hdteller:=0;
    while pos('$HDF%(',regel) <> 0 do begin
      try
        hdteller:=hdteller+1;
        if hdteller>10 then regel:=StringReplace(regel,'$HDF%(','error',[rfReplaceAll]);
        letter:=ord(upcase(copy(regel,pos('$HDF%(',regel)+6,1)[1]));
        regel2:=intToStr(round(100/STHDTotal[letter]*STHDFree[letter]));
        regel:=StringReplace(regel,'$HDF%('+chr(letter)+')',regel2,[rfReplaceAll]);
      except
      end;
    end;
    hdteller:=0;
    while pos('$HDU%(',regel) <> 0 do begin
      try
        hdteller:=hdteller+1;
        if hdteller>10 then regel:=StringReplace(regel,'$HDU%(','error',[rfReplaceAll]);
        letter:=ord(upcase(copy(regel,pos('$HDU%(',regel)+6,1)[1]));
        regel2:=intToStr(round(100/STHDTotal[letter]*(STHDTotal[letter]-STHDFree[letter])));
        regel:=StringReplace(regel,'$HDU%('+chr(letter)+')',regel2,[rfReplaceAll]);
      except
      end;
    end;
    hdteller:=0;
    while pos('$HDTotag(',regel) <> 0 do begin
      try
        hdteller:=hdteller+1;
        if hdteller>10 then regel:=StringReplace(regel,'$HDTotag(','error',[rfReplaceAll]);
        letter:=ord(upcase(copy(regel,pos('$HDTotag(',regel)+9,1)[1]));
        regel:=StringReplace(regel,'$HDTotag('+copy(regel,pos('$HDTotag(',regel)+9,1)+')',IntToStr(round(STHDTotal[letter]/1024)),[rfReplaceAll]);
      except
      end;
    end;
    hdteller:=0;
    while pos('$HDTotal(',regel) <> 0 do begin
      try
        hdteller:=hdteller+1;
        if hdteller>10 then regel:=StringReplace(regel,'$HDUseg(','error',[rfReplaceAll]);
        letter:=ord(upcase(copy(regel,pos('$HDTotal(',regel)+9,1)[1]));
        regel:=StringReplace(regel,'$HDTotal('+copy(regel,pos('$HDTotal(',regel)+9,1)+')',IntToStr(STHDTotal[letter]),[rfReplaceAll]);
      except
      end;
    end;

    if pos('$MObutton(',regel) <> 0 then begin
      tempst:=copy(regel,pos('$MObutton(',regel)+10,1);
      if kar=tempst then spacecount:=1 else spacecount:=0;
      regel:=StringReplace(regel,'$MObutton('+tempst+')',intToStr(spacecount),[rfReplaceAll]);
    end;

    while pos('$Chr(',regel) <> 0 do begin
      try
        tempst:=copy(regel,pos('$Chr(',regel)+5,length(regel));
        tempst:=copy(tempst,1,pos(')',tempst)-1);
        regel:=StringReplace(regel,'$Chr('+tempst+')',Chr(StrToInt(tempst)),[]);
      except
        regel:=StringReplace(regel,'$Chr(','ERROR',[]);
      end;
    end;

    while pos('$dll(',regel) <> 0 do begin
      try
        totaldlls:=totaldlls+1;
        if dllcancheck=true then begin
          try
            tempst:=copy(regel, pos('$dll(',regel),length(regel));
            tempst:=copy(tempst, pos('$dll(',tempst)+5,pos(',',tempst)-pos('$dll(',tempst)-5);
            if templib <> tempst then hlib:=LoadLibrary(pchar(extractfilepath(application.exename)+'plugins\'+tempst));
            templib:=tempst;

            tempst:=copy(regel, pos('$dll(',regel)+5,length(regel));
            tempst:=copy(tempst,pos(',',tempst)+1,length(tempst));

            nlib:=StrToInt(copy(tempst,1,1));
            tempst:=copy(tempst,3,length(tempst));
            plib:=copy(tempst,1,pos(',',tempst)-1);
            tlib:=copy(tempst,pos(',',tempst)+1,pos(')',tempst)-pos(',',tempst)-1);
            tempst:=copy(regel,pos('$dll(',regel),length(regel));
            tempst:=copy(tempst,1,pos(')',tempst));
            if nlib = 1 then begin
              @function1:=getprocaddress(hlib,'function1');
              if @function1 <> nil then dllsarray[totaldlls]:=function1(pchar(plib), pchar(tlib));
            end;
            if nlib = 2 then begin
              @function2:=getprocaddress(hlib,'function2');
              if @function2 <> nil then dllsarray[totaldlls]:=function2(pchar(plib), pchar(tlib));
            end;
            if nlib = 3 then begin
              @function3:=getprocaddress(hlib,'function3');
              if @function3 <> nil then dllsarray[totaldlls]:=function3(pchar(plib), pchar(tlib));
            end;
            if nlib = 4 then begin
              @function4:=getprocaddress(hlib,'function4');
              if @function4 <> nil then dllsarray[totaldlls]:=function4(pchar(plib), pchar(tlib));
            end;
            if nlib = 5 then begin
              @function5:=getprocaddress(hlib,'function5');
              if @function5 <> nil then dllsarray[totaldlls]:=function5(pchar(plib), pchar(tlib));
            end;
            if nlib = 6 then begin
              @function6:=getprocaddress(hlib,'function6');
              if @function6 <> nil then dllsarray[totaldlls]:=function6(pchar(plib), pchar(tlib));
            end;
            if nlib = 7 then begin
              @function7:=getprocaddress(hlib,'function7');
              if @function7 <> nil then dllsarray[totaldlls]:=function7(pchar(plib), pchar(tlib));
            end;
            if nlib = 8 then begin
              @function8:=getprocaddress(hlib,'function8');
              if @function8 <> nil then dllsarray[totaldlls]:=function8(pchar(plib), pchar(tlib));
            end;
            if nlib = 9 then begin
              @function9:=getprocaddress(hlib,'function9');
              if @function9 <> nil then dllsarray[totaldlls]:=function9(pchar(plib), pchar(tlib));
            end;
            if nlib = 0 then begin
              @function10:=getprocaddress(hlib,'function10');
              if @function10 <> nil then dllsarray[totaldlls]:=function10(pchar(plib), pchar(tlib));
            end;
          except end;
        end;
      finally
        tempst:=copy(regel,pos('$dll(',regel),length(regel));
        tempst:=copy(tempst,1,pos(')',tempst));
        try
          if pos('$dll(',tempst)<>0 then begin
            regel:=StringReplace(regel,tempst,dllsarray[totaldlls],[]);
          end;
        except
          regel:=StringReplace(regel,'$dll(',dllsarray[totaldlls],[]);
        end;
      end;
    end;

    hdteller:=0;
    while pos('$Count(',regel) <> 0 do begin
      ccount:=0;
      try
        hdteller:=hdteller+1;
        if hdteller>10 then regel:=StringReplace(regel,'$Count(','error',[rfReplaceAll]);
        tempst:=copy(regel,pos('$Count(',regel)+7,length(regel));
        tempst:=copy(tempst,1,pos(')',tempst)-1);
        while pos('#',tempst) <> 0 do begin
          ccount:=ccount+StrToInt(copy(tempst,1,pos('#',tempst)-1));
          tempst:=copy(tempst,pos('#',tempst)+1,length(tempst));
        end;
        ccount:=ccount+StrToInt(copy(tempst,1,length(tempst)));
        tempst:=copy(regel,pos('$Count(',regel)+7,length(regel));
        tempst:=copy(tempst,1,pos(')',tempst)-1);
        regel:=StringReplace(regel,'$Count('+ tempst+')',FloatToStr(ccount),[]);
     except
        regel:=StringReplace(regel,'$Count(','error',[]);
      end;
    end;

    hdteller:=0;
    while pos('$Bar(',regel) <> 0 do begin
      try
        hdteller:=hdteller+1;
        if hdteller>10 then regel:=StringReplace(regel,'$Bar(','error',[rfReplaceAll]);
        ss:=copy(regel,pos('$Bar(',regel)+5,length(regel));
        tempst:=copy(ss,pos(',',ss)+1,length(ss));
        tempst:=copy(tempst,1,pos(',',tempst)-1);
        regel2:=copy(ss,pos(',',ss)+1,length(ss));
        regel2:=copy(regel2,pos(',',regel2)+1,length(regel2));
        regel2:=copy(regel2,1,pos(')',regel2)-1);
        ss:=copy(ss,1,pos(',',ss)-1);

        spacecount:=strtoint(regel2)*3;

        m:=round(1/StrToInt(tempst)*StrToInt(ss)*spacecount);

        if m>spacecount then m:=spacecount;
        STHDBar:='';
        for h:=1 to (m div 3) do STHDBar:=STHDBar+'�';
        if (m mod 3 = 1) then STHDBar:=STHDBar+chr(131);
        if (m mod 3 = 2) then STHDBar:=STHDBar+chr(132);
        for h:=1 to round(spacecount/3)-length(STHDBar) do STHDBar:=STHDBar+'_';

        regel:=StringReplace(regel,'$Bar('+ss+','+tempst+','+regel2+')',STHDBar,[]);
      except
        regel:=StringReplace(regel,'$Bar('+ss+','+tempst+','+regel2+')','error',[rfReplaceAll]);
        regel:=StringReplace(regel,'$Bar(','error',[rfReplaceAll]);
      end;
    end;

    while (pos('$Flash(',regel) <> 0) do begin
      try
        regel2:=copy(regel,pos('$Flash(',regel)+7, (pos('$)$',regel))-(pos('$Flash(',regel)+7));
        if (doesflash) then begin
          spaceline:='';
          for h:=1 to length(regel2) do begin
            spaceline:=spaceline+' ';
          end;
        end else begin
          spaceline:=regel2;
        end;
        if pos('$)$',regel)<>0 then
          regel:=StringReplace(regel,'$Flash('+regel2+'$)$',spaceline, [])
        else
          regel:=StringReplace(regel,'$Flash(','ERROR', []);
      except
        regel:=StringReplace(regel,'$Flash(','ERROR', []);
      end;
    end;

    while (pos('$CustomChar(',regel) <> 0) do begin
      try
        regel2:=copy(regel,pos('$CustomChar(',regel)+12, length(regel));
        regel2:=copy(regel2,1,pos(')',regel2)-1);
        customchar(regel2);
        regel:=StringReplace(regel,'$CustomChar('+regel2+')','', []);
      except
        regel:=StringReplace(regel,'$CustomChar(','ERROR', []);
      end;
    end;

    while pos('$Right(',regel) <> 0 do begin
      try
        regel2:=copy(regel,pos('$Right(',regel),length(regel));
        spacecount:=StrToInt(copy(regel2, pos(',$',regel2)+2,pos('%)',regel2)-pos(',$',regel2)-2));
        regel2:=copy(regel2,pos('$Right(',regel2)+7,pos(',$',regel2)-pos('$Right(',regel2)-7);

        spaceline:='';
        if spacecount > length(regel2) then begin
          for h:=1 to spacecount - length(regel2) do begin
            spaceline:=' '+spaceline;
          end;
        end;
        spaceline:=spaceline+regel2;
        regel:=StringReplace(regel,'$Right('+regel2+',$'+IntToStr(spacecount)+'%)',spaceline, []);
      except
        regel:=StringReplace(regel,'$Right(','error', []);
      end;
    end;

    while pos('$Fill(',regel) <> 0 do begin
      try
        spacecount:=StrToInt(copy(copy(regel,pos('$Fill(',regel)+6,StrToInt(IntToStr(length(regel)-(pos('$Fill(',regel)+5)))),1,pos(')',copy(regel,pos('$Fill(',regel)+6,StrToInt(IntToStr(length(regel)-(pos('$Fill(',regel)+5)))))-1));
      except
        regel:=StringReplace(regel,'$Fill(','ERROR', []);
        spacecount:=-1;
      end;
      if spacecount <>-1 then begin
        spaceline:='';
        if spacecount >= pos('$Fill(',regel) then begin
          for h:=0 to spacecount - pos('$Fill(',regel) do begin
            spaceline:=spaceline+' ';
          end;
        end;
        regel:=StringReplace(regel,'$Fill('+IntToStr(spacecount)+')',spaceline, []);
      end;
    end;
  result:=regel;
end;
{$R *.DFM}

function TForm1.GetCpuSpeedRegistry(proc: Byte): string;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('Hardware\Description\System\CentralProcessor\'+IntToStr(proc), False) then
    begin
      Result := IntToStr(Reg.ReadInteger('~MHz'));
      Reg.CloseKey;
    end else begin
      Result := '';
    end;
  finally
    Reg.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Reg: TRegistry;
  regel:string;
  initfile:textfile;

begin
  qstattemp:=1;
  CPUUsagePos:=1;
  Randomize;
//SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW );
  try
    regel:=extractfilepath(application.exename);
    image1.picture.LoadFromFile(regel+'images\logo.bmp');
    image3.picture.LoadFromFile(regel+'images\small_arrow_left_up1.bmp');
    image4.picture.LoadFromFile(regel+'images\small_arrow_left_up2.bmp');
    image5.picture.LoadFromFile(regel+'images\small_arrow_left_up3.bmp');
    image6.picture.LoadFromFile(regel+'images\small_arrow_left_up4.bmp');
    image7.picture.LoadFromFile(regel+'images\small_arrow_right_up1.bmp');
    image8.picture.LoadFromFile(regel+'images\small_arrow_right_up2.bmp');
    image9.picture.LoadFromFile(regel+'images\small_arrow_right_up3.bmp');
    image10.picture.LoadFromFile(regel+'images\small_arrow_right_up4.bmp');
    image11.picture.LoadFromFile(regel+'images\big_arrow_right_up.bmp');
    image12.picture.LoadFromFile(regel+'images\big_arrow_left_up.bmp');
    image13.picture.LoadFromFile(regel+'images\bar_left.bmp');
    image14.picture.LoadFromFile(regel+'images\bar_right.bmp');
    image15.picture.LoadFromFile(regel+'images\bar_middle.bmp');
    image16.picture.LoadFromFile(regel+'images\setup_up.bmp');
    image17.picture.LoadFromFile(regel+'images\hide_up.bmp');
    cooltrayicon1.Icon.LoadFromFile(regel+'images\smartie.ico');
    application.Icon.LoadFromFile(regel+'images\smartie.ico');
    cooltrayicon1.Refresh;
  except
    showmessage('Error: unable to access images subdirectory.');
    application.terminate;
  end;
  form1.color:=$00BFBFBF;
  isconnected:=false;
  totaldlls:=0;
  scrollline1:=False;
  scrollline2:=False;
  scrollline3:=False;
  scrollline4:=False;

  // Get CPU speed once:

  STCPUSpeed:=GetCpuSpeedRegistry(0);
  if (STCPUSpeed='') then STCPUSpeed:=cxCpu[0].Speed.Normalised.FormatMhz;

  parameter1:=lowercase(paramstr(1));
  parameter2:=lowercase(paramstr(2));
  parameter3:=lowercase(paramstr(3));
  parameter4:=lowercase(paramstr(4));
  aantalscreensheenweer:=1;
  if (parameter1 = '-register') or (parameter2 = '-register') or (parameter3 = '-register') or (parameter4 = '-register') then begin
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.OpenKey('\SOFTWARE\LCDSmartie\', True) then begin
        Reg.Writeinteger('backlight', 1);
      end;
    finally
      Reg.CloseKey;
      Reg.Free;
      inherited;
    end;
  end;

//register
  try
    assignfile(initfile, extractfilepath(application.exename)+'images\colors.cfg');
    reset(initfile);
    readln(initfile,regel);
    panel5.Color:=StrToInt('$00'+copy(regel,1,6));
    readln(initfile,regel);
    panel5.font.Color:=StrToInt('$00'+copy(regel,1,6));
    readln(initfile,regel);
    forgroundcoloron:=StrToInt('$00'+copy(regel,1,6));
    readln(initfile,regel);
    backgroundcoloron:=StrToInt('$00'+copy(regel,1,6));
    readln(initfile,regel);
    forgroundcoloroff:=StrToInt('$00'+copy(regel,1,6));
    readln(initfile,regel);
    backgroundcoloroff:=StrToInt('$00'+copy(regel,1,6));
    closefile(initfile);
  except
    showmessage('Fatal Error:  Can`t find images\colors.cfg');
    application.Terminate;
  end;

  config:=TConfig.Create();

  if (config.load() = false) then
  begin
    showmessage('Fatal Error:  Can`t load config.cfg');
    application.Terminate;
  end;

  form1.WinampCtrl1.WinampLocation:=config.winampLocation;
  file1:=config.distLog;
  IDHTTP1.ProxyParams.ProxyServer:=config.httpProxy;
  IDHTTP1.ProxyParams.ProxyPort:=config.httpProxyPort;
  IDHTTP2.ProxyParams.ProxyServer:=config.httpProxy;
  IDHTTP2.ProxyParams.ProxyPort:=config.httpProxyPort;
  IDHTTP3.ProxyParams.ProxyServer:=config.httpProxy;
  IDHTTP3.ProxyParams.ProxyPort:=config.httpProxyPort;
  IDHTTP4.ProxyParams.ProxyServer:=config.httpProxy;
  IDHTTP4.ProxyParams.ProxyPort:=config.httpProxyPort;
  IDHTTP5.ProxyParams.ProxyServer:=config.httpProxy;
  IDHTTP5.ProxyParams.ProxyPort:=config.httpProxyPort;
  IDHTTP6.ProxyParams.ProxyServer:=config.httpProxy;
  IDHTTP6.ProxyParams.ProxyPort:=config.httpProxyPort;
  IDHTTP7.ProxyParams.ProxyServer:=config.httpProxy;
  IDHTTP7.ProxyParams.ProxyPort:=config.httpProxyPort;
  IDHTTP8.ProxyParams.ProxyServer:=config.httpProxy;
  IDHTTP8.ProxyParams.ProxyPort:=config.httpProxyPort;
  IDHTTP9.ProxyParams.ProxyServer:=config.httpProxy;
  IDHTTP9.ProxyParams.ProxyPort:=config.httpProxyPort;


  welkescreen:=1;

  aantregelsoud:=config.height;

  panel2.visible:=false;
  panel3.visible:=false;
  panel4.visible:=false;
  image4.enabled:=false;
  image5.enabled:=false;
  image6.enabled:=false;
  image8.enabled:=false;
  image9.enabled:=false;
  image10.enabled:=false;
  if config.height>1 then begin
    panel2.visible:=true;
    image4.enabled:=true;
    image8.enabled:=true;
  end;
  if config.height>2 then begin
    panel3.visible:=true;
    image5.enabled:=true;
    image9.enabled:=true;
  end;
  if config.height>3 then begin
    panel4.visible:=true;
    image6.enabled:=true;
    image10.enabled:=true;
  end;

  checkIfNewsUpdatesRequired();
  kleuren:=config.colorOption;
  backlight:=1;
  distributedlog:=config.distLog;
  kleur();

  if (parameter1 <> '-nolcd') AND (parameter2 <> '-nolcd') AND (parameter3 <> '-nolcd') AND (parameter4 <> '-nolcd') then begin
    if (config.isMO) or (config.isCF) then begin
      if config.baudrate=0 then VaComm1.Baudrate:=br110;
      if config.baudrate=1 then VaComm1.Baudrate:=br300;
      if config.baudrate=2 then VaComm1.Baudrate:=br600;
      if config.baudrate=3 then VaComm1.Baudrate:=br1200;
      if config.baudrate=4 then VaComm1.Baudrate:=br2400;
      if config.baudrate=5 then VaComm1.Baudrate:=br4800;
      if config.baudrate=6 then VaComm1.Baudrate:=br9600;
      if config.baudrate=7 then VaComm1.Baudrate:=br14400;
      if config.baudrate=8 then VaComm1.Baudrate:=br19200;
      if config.baudrate=9 then VaComm1.Baudrate:=br38400;
      if config.baudrate=10 then VaComm1.Baudrate:=br56000;
      if config.baudrate=11 then VaComm1.Baudrate:=br57600;
      if config.baudrate=12 then VaComm1.Baudrate:=br115200;
      if config.baudrate=13 then VaComm1.Baudrate:=br128000;
      if config.baudrate=14 then VaComm1.Baudrate:=br256000;
      VaComm1.PortNum:=config.comPort;
      VaComm1.Close;
      try
        VaComm1.Open;
        if (config.isCF) then Lcd:=TLCD_CF.Create()
        else if (config.isMO) then Lcd:=TLCD_MO.Create();
      except
        Lcd:=TLCD.Create();
      end;
    end;

    if not (config.isCF or config.isMO or config.isHD) then Lcd:=TLCD.Create();

    if (config.isMO) or (config.isCF) then begin
      customchar('1,12,18,18,12,0,0,0,0');
      customchar('2,31,31,31,31,31,31,31,31');
      customchar('3,16,16,16,16,16,16,31,16');
      customchar('4,28,28,28,28,28,28,31,28');
    end;

    if (config.isMO) then begin
      Lcd.setContrast(config.contrast);
      Lcd.setBrightness(config.brightness);
    end;

    if (config.isCF) then begin
      customchar('7,4,4,4,4,4,4,4,0');
      customchar('8,14,17,1,13,21,21,14,0');

      Lcd.setContrast(config.CF_contrast);
      Lcd.setBrightness(config.CF_brightness);
    end;

    //
    // Enable the threads...
    //
    if (config.isMO) or (config.isCF) then begin
      timer1.enabled:=true;
      timer2.enabled:=true;
      timer3.enabled:=true;
      timer6.enabled:=true;
      timer7.enabled:=true;
      timer8.enabled:=true;
      timer9.enabled:=true;
      timer10.enabled:=true;
      timer12.enabled:=true;
      timer13.enabled:=true;
    end;

    if (config.isHD) or (config.isHD2) then begin
      if config.bootDriverDelay=0 then timer11.interval:=10
      else timer11.interval:=config.bootDriverDelay*1000;
      timer11.enabled:=true;
    end;

  end;
end;




procedure TForm1.refres(Sender: TObject);
const
  ticksperweek    : integer = 3600000*24*7;
  ticksperdag     : integer = 3600000*24;
  ticksperhour    : integer = 3600000;
  ticksperminute  : integer = 60000;
  ticksperseconde : integer = 1000;

var
  t: longword;
  w, d, h, m, s : integer;
  teller:integer;
  regel:string;
  total, y: Cardinal;
  rawcpu: Double;

begin
try
  if form1.left < 8 then form1.left:=0;
  if form1.top < 8 then form1.top:=0;
  if form1.left+form1.Width > screen.desktopwidth -8 then form1.left:= screen.desktopwidth-form1.width;
  if form1.top+form1.height > screen.desktopheight -34 then form1.top:= screen.desktopheight-form1.height-28;

if ((donewsupdate1 = 1) or
   (donewsupdate2 = 1) or
   (donewsupdate3 = 1) or
   (donewsupdate4 = 1) or
   (donewsupdate5 = 1) or
   (donewsupdate6 = 1) or
   (donewsupdate7 = 1) or
   (donewsupdate8 = 1) or
   (donewsupdate9 = 1)) and
   (HTTPthreadisrunning =false) then
      THTTPThread.Create(false);

  if (parameter1= '-hide') or (parameter2= '-hide') or (parameter3= '-hide') or (parameter4= '-hide') then begin
    if parameter1 = '-hide' then parameter1:= '';
    if parameter2 = '-hide' then parameter2:= '';
    if parameter3 = '-hide' then parameter3:= '';
    if parameter4 = '-hide' then parameter4:= '';
    application.minimize;
    hide;
  end;

  if (parameter1= '-totalhide') or (parameter2= '-totalhide') or (parameter3= '-totalhide') or (parameter4= '-totalhide') then begin
    if parameter1 = '-totalhide' then parameter1:= '';
    if parameter2 = '-totalhide' then parameter2:= '';
    if parameter3 = '-totalhide' then parameter3:= '';
    if parameter4 = '-totalhide' then parameter4:= '';
    cooltrayicon1.Destroy;
    application.minimize;
    hide;
  end;

//cpuusage!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//Application.ProcessMessages;
t:=GetTickCount;
if (t - lastCpuUpdate > (ticksperseconde div 4)) then begin
  lastCpuUpdate := t;
  try
  {  CPUUsage[CPUUsagePos]:=cxCpu[0].Usage.Value.AsNumber;}
    CollectCPUData;
    rawcpu:= adCpuUsage.GetCPUUsage(0);

    if (rawcpu <= 1.1) and (rawcpu >= -0.1) then begin
      CPUUsage[CPUUsagePos]:=Trunc(abs(rawcpu) * 100);
      Inc(CPUUsagePos);
      if (CPUUsagePos>5) then CPUUsagePos:=1;
      if (CPUUsageCount<5) then Inc(CPUUsageCount);
    end ;

  except
  end;
  total:=0;
  for y:=1 to CPUUsageCount do total:=total+CPUUsage[y];
  if (CPUUsageCount>0) then STCPUUsage:=total div CPUUsageCount;

end;


//time/uptime!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  t:=GetTickCount;
  w := t div ticksperweek;
  t:=t -w*ticksperweek;
  d := t div ticksperdag;
  t:=t -d * ticksperdag;
  h := t div ticksperhour;
  t:=t -h * ticksperhour;
  m := t div ticksperminute;
  t:=t -m * ticksperminute;
  s := t div ticksperseconde;
uptimereg:='';
uptimeregs:='';
if w>0 then uptimereg:=uptimereg+IntToStr(w)+ 'wks ';
if d>0 then uptimereg:=uptimereg+IntToStr(d)+ 'dys ';
if h>0 then uptimereg:=uptimereg+IntToStr(h)+ 'hrs ';
if m>0 then uptimereg:=uptimereg+IntToStr(m)+ 'min ';
uptimereg:=uptimereg+IntToStr(s);

uptimeregs:=uptimeregs+IntToStr(d)+ ':';
uptimeregs:=uptimeregs+IntToStr(h)+ ':';
uptimeregs:=uptimeregs+IntToStr(m);

winampregel:='';

  timer1.Interval:=config.refreshRate;

  if (config.width=40) then begin
    form1.Width:=389;
    image1.left:=356;
    image11.left:=368;
    image7.left:=352;
    image8.left:=352;
    image9.left:=352;
    image10.left:=352;
    image14.left:=266;
    image17.left:=323;
    panel1.width:=321;
    panel2.width:=321;
    panel3.width:=321;
    panel4.width:=321;
    image15.width:=220;
  end else begin
    if (config.width=24) then begin
      form1.Width:=261;
      image1.left:=228;
      image11.left:=240;
      image7.left:=224;
      image8.left:=224;
      image9.left:=224;
      image10.left:=224;
      image14.left:=140;
      image17.left:=197;
      panel1.width:=193;
      panel2.width:=193;
      panel3.width:=193;
      panel4.width:=193;
      image15.width:=70;
    end else begin
      form1.Width:=231;
      image1.left:=198;
      image11.left:=210;
      image7.left:=194;
      image8.left:=194;
      image9.left:=194;
      image10.left:=194;
      panel1.width:=162;
      panel2.width:=162;
      panel3.width:=162;
      panel4.width:=162;
      image14.left:=108;
      image17.left:=165;
      image15.width:=20;
    end;
  end;


  if config.height<>aantregelsoud then
  begin
    aantregelsoud:=config.height;
    panel2.visible:=false;
    panel3.visible:=false;
    panel4.visible:=false;
    image4.visible:=false;
    image5.visible:=false;
    image6.visible:=false;
    image8.visible:=false;
    image9.visible:=false;
    image10.visible:=false;
    if config.height>1 then begin
      panel2.visible:=true;
      image4.Visible:=true;
      image8.Visible:=true;
    end;
    if config.height>2 then begin
      panel3.visible:=true;
      image5.Visible:=true;
      image9.Visible:=true;
    end;
    if config.height>3 then begin
      panel4.visible:=true;
      image6.Visible:=true;
      image10.Visible:=true;
    end;
  end;

  totaldlls:=0;

  nextline1:=config.screen[welkescreen][1].contNextLine;
  nextline2:=config.screen[welkescreen][2].contNextLine;
  nextline3:=config.screen[welkescreen][3].contNextLine;
  nextline4:=config.screen[welkescreen][4].contNextLine;


  dllcancheck:=false;
  if (canscroll) then begin
    if (doesflash) then doesflash:=false else doesflash:=true;
    if (flash > 0) then begin
      flash := flash -1;
      backlit()
    end;
    if (doesgpoflash) then doesgpoflash:=false else doesgpoflash:=true;
    if (gpoflash > 0) then begin
      gpoflash := gpoflash -1;
      doGPO(whatgpo,2)
    end;
  end;

  if kleuren <> config.colorOption then
  begin
    kleuren:=config.colorOption;
    kleur();
  end;
  distributedlog:=config.distLog;
  if (config.alwaysOnTop) and (not form2.Visible) and (not form4.Visible) then begin
    form1.formStyle:=fsStayOnTop;
  end else begin
    form1.formStyle:=fsNormal;
  end;
except
end;

  for teller:= 1 to aantregelsoud do begin
    //Application.ProcessMessages;
    regel:=config.screen[welkescreen][teller].text;
    qstattemp:=teller;
    regel:=change(regel);

    if config.screen[welkescreen][teller].center then begin
      if length(regel) < config.width-1 then begin
        for h:=1 to round((config.width - length(regel))/2 - 0.4) do begin
          regel:=' '+regel+' ';
        end;
      end;
    end;

    regelz[teller]:=regel;
    newline[teller]:=regel;  // Used by screen change interaction.
  end;
  gotnewlines:=true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  Reg: TRegistry;
  foo,x:integer;
  gokje:integer;
  gokreg:array[1..4] of string;
begin
  if ((gotnewlines=false) OR (timertrans.enabled=false))then refres(self);
  //Application.ProcessMessages;

  if timertrans.Enabled=false then begin
    if not scrollline5 then begin
      Panel1.Caption:=StringReplace(copy(regelz[1],1,config.width),'&','&&',[rfReplaceAll]);
      panel2.Caption:=StringReplace(copy(regelz[2],1,config.width),'&','&&',[rfReplaceAll]);
      panel3.Caption:=StringReplace(copy(regelz[3],1,config.width),'&','&&',[rfReplaceAll]);
      panel4.Caption:=StringReplace(copy(regelz[4],1,config.width),'&','&&',[rfReplaceAll]);
      if nextline1 then begin
        panel2.Caption:=copy(regelz[1],1+config.width,2*config.width);
        regelz[2]:=copy(regelz[1],1+config.width,length(regelz[1]));
      end;
      if nextline2 then begin
        panel3.Caption:=copy(regelz[2],1+config.width,2*config.width);
        regelz[3]:=copy(regelz[2],1+config.width,length(regelz[2]));
      end;
      if nextline3 then begin
        panel4.Caption:=copy(regelz[3],1+config.width,2*config.width);
        regelz[4]:=copy(regelz[3],1+config.width,length(regelz[3]));
      end;
    end;

    if (canscroll) then begin
      canscroll:=false;
      if not scrollline1 then Panel1.Caption:=StringReplace(scroll(regelz[1],1,1),'&','&&',[rfReplaceAll]);
      if not scrollline2 then Panel2.Caption:=StringReplace(scroll(regelz[2],2,1),'&','&&',[rfReplaceAll]);
      if not scrollline3 then panel3.Caption:=StringReplace(scroll(regelz[3],3,1),'&','&&',[rfReplaceAll]);
      if not scrollline4 then panel4.Caption:=StringReplace(scroll(regelz[4],4,1),'&','&&',[rfReplaceAll]);
    end else begin
      if not scrollline1 then Panel1.Caption:=StringReplace(scroll(regelz[1],1,0),'&','&&',[rfReplaceAll]);
      if not scrollline2 then Panel2.Caption:=StringReplace(scroll(regelz[2],2,0),'&','&&',[rfReplaceAll]);
      if not scrollline3 then panel3.Caption:=StringReplace(scroll(regelz[3],3,0),'&','&&',[rfReplaceAll]);
      if not scrollline4 then panel4.Caption:=StringReplace(scroll(regelz[4],4,0),'&','&&',[rfReplaceAll]);
    end;

end else begin
  // Changing screen - do any interactions required.

  for x:=1 to 4 do begin
    oldline[x]:=copy(oldline[x]+'                                        ',1,config.width);
    newline[x]:=copy(newline[x]+'                                        ',1,config.width);
  end;
  if transActietemp=1 then begin  //left-->right
    counter:=counter+1;
    Panel1.Caption:=StringReplace(copy(newline[1]+oldline[1],config.width-round(counter*(config.width/(timertrans.interval/(timer1.interval*1.14)))),config.width),'&','&&',[rfReplaceAll]);
    Panel2.Caption:=StringReplace(copy(newline[2]+oldline[2],config.width-round(counter*(config.width/(timertrans.interval/(timer1.interval*1.14)))),config.width),'&','&&',[rfReplaceAll]);
    Panel3.Caption:=StringReplace(copy(newline[3]+oldline[3],config.width-round(counter*(config.width/(timertrans.interval/(timer1.interval*1.14)))),config.width),'&','&&',[rfReplaceAll]);
    Panel4.Caption:=StringReplace(copy(newline[4]+oldline[4],config.width-round(counter*(config.width/(timertrans.interval/(timer1.interval*1.14)))),config.width),'&','&&',[rfReplaceAll]);
  end;
  if transActietemp=2 then begin  //right-->left
    counter:=counter+1;
    Panel1.Caption:=StringReplace(copy(oldline[1]+newline[1],round(counter*(config.width/(timertrans.interval/(timer1.interval*1.13)))),config.width),'&','&&',[rfReplaceAll]);
    Panel2.Caption:=StringReplace(copy(oldline[2]+newline[2],round(counter*(config.width/(timertrans.interval/(timer1.interval*1.13)))),config.width),'&','&&',[rfReplaceAll]);
    Panel3.Caption:=StringReplace(copy(oldline[3]+newline[3],round(counter*(config.width/(timertrans.interval/(timer1.interval*1.13)))),config.width),'&','&&',[rfReplaceAll]);
    Panel4.Caption:=StringReplace(copy(oldline[4]+newline[4],round(counter*(config.width/(timertrans.interval/(timer1.interval*1.13)))),config.width),'&','&&',[rfReplaceAll]);
  end;
  if transActietemp=3 then begin  //top-->bottum
    counter:=counter+1;
    oldnewline[1]:=newline[1];
    oldnewline[2]:=newline[2];
    if aantregelsoud>2 then oldnewline[3]:=newline[3] else oldnewline[3]:=newline[2];
    if aantregelsoud>2 then oldnewline[4]:=newline[4] else oldnewline[4]:=newline[2];
    if aantregelsoud>3 then oldnewline[4]:=newline[4];
    oldnewline[5]:=oldline[1];
    oldnewline[6]:=oldline[2];
    if aantregelsoud>2 then oldnewline[7]:=oldline[3] else oldnewline[7]:=oldline[2];
    if aantregelsoud>2 then oldnewline[8]:=oldline[4] else oldnewline[8]:=oldline[2];
    if aantregelsoud>3 then oldnewline[8]:=oldline[4];

    Panel1.Caption:=StringReplace(oldnewline[5-round(counter*(aantregelsoud/(timertrans.interval/(timer1.interval*1.13))))],'&','&&',[rfReplaceAll]);
    Panel2.Caption:=StringReplace(oldnewline[6-round(counter*(aantregelsoud/(timertrans.interval/(timer1.interval*1.13))))],'&','&&',[rfReplaceAll]);
    Panel3.Caption:=StringReplace(oldnewline[7-round(counter*(aantregelsoud/(timertrans.interval/(timer1.interval*1.13))))],'&','&&',[rfReplaceAll]);
    Panel4.Caption:=StringReplace(oldnewline[8-round(counter*(aantregelsoud/(timertrans.interval/(timer1.interval*1.13))))],'&','&&',[rfReplaceAll]);
  end;
  if transActietemp=4 then begin  //bottom-->top
    counter:=counter+1;
    oldnewline[1]:=oldline[1];
    oldnewline[2]:=oldline[2];
    if aantregelsoud>2 then oldnewline[3]:=oldline[3] else oldnewline[3]:=oldline[2];
    if aantregelsoud>2 then oldnewline[4]:=oldline[4] else oldnewline[4]:=oldline[2];
    if aantregelsoud>3 then oldnewline[4]:=oldline[4];
    oldnewline[5]:=newline[1];
    oldnewline[6]:=newline[2];
    if aantregelsoud>2 then oldnewline[7]:=newline[3] else oldnewline[7]:=newline[2];
    if aantregelsoud>2 then oldnewline[8]:=newline[4] else oldnewline[8]:=newline[2];
    if aantregelsoud>3 then oldnewline[8]:=newline[4];

    Panel1.Caption:=StringReplace(oldnewline[1+round(counter*(aantregelsoud/(timertrans.interval/(timer1.interval*1.13))))],'&','&&',[rfReplaceAll]);
    Panel2.Caption:=StringReplace(oldnewline[2+round(counter*(aantregelsoud/(timertrans.interval/(timer1.interval*1.13))))],'&','&&',[rfReplaceAll]);
    Panel3.Caption:=StringReplace(oldnewline[3+round(counter*(aantregelsoud/(timertrans.interval/(timer1.interval*1.13))))],'&','&&',[rfReplaceAll]);
    Panel4.Caption:=StringReplace(oldnewline[4+round(counter*(aantregelsoud/(timertrans.interval/(timer1.interval*1.13))))],'&','&&',[rfReplaceAll]);
  end;
  if transActietemp=5 then begin  //random blocks
    gokreg[1]:=copy(Panel1.caption+'                                        ',1,config.width);
    gokreg[2]:=copy(Panel2.caption+'                                        ',1,config.width);
    gokreg[3]:=copy(Panel3.caption+'                                        ',1,config.width);
    gokreg[4]:=copy(Panel4.caption+'                                        ',1,config.width);

    for x:= 1 to round(config.width/(timertrans.interval/(timer1.interval))) do begin
      counter:=counter+1;
      if counter<=config.width then begin
        gokje:=doguess(1);
        gokreg[1]:=copy(gokreg[1],1,gokje-1)+copy(newline[1],gokje,1)+copy(gokreg[1],gokje+1,config.width-gokje);
        gokje:=doguess(2);
        gokreg[2]:=copy(gokreg[2],1,gokje-1)+copy(newline[2],gokje,1)+copy(gokreg[2],gokje+1,config.width-gokje);
        gokje:=doguess(3);
        gokreg[3]:=copy(gokreg[3],1,gokje-1)+copy(newline[3],gokje,1)+copy(gokreg[3],gokje+1,config.width-gokje);
        gokje:=doguess(4);
        gokreg[4]:=copy(gokreg[4],1,gokje-1)+copy(newline[4],gokje,1)+copy(gokreg[4],gokje+1,config.width-gokje);
      end;
    end;
    Panel1.caption:=StringReplace(gokreg[1],'&','&&',[rfReplaceAll]);
    Panel2.caption:=StringReplace(gokreg[2],'&','&&',[rfReplaceAll]);
    Panel3.caption:=StringReplace(gokreg[3],'&','&&',[rfReplaceAll]);
    Panel4.caption:=StringReplace(gokreg[4],'&','&&',[rfReplaceAll]);
  end;
  if transActietemp=6 then begin  //contrast fade off
    if (config.isMO) and (foo2<>1) then begin
      x:=config.contrast;
      counter:=counter+1;
      form1.VaComm1.WriteChar(Chr($0FE));
      form1.VaComm1.WriteChar('P');
      foo:=round(x-(counter*x/(timertrans.Interval/2.1/timer1.Interval)));
      if foo < 0 then foo:=0;
      form1.VaComm1.WriteChar(chr(foo));
      if foo < 25 then foo2:=1;
    end;
    if (config.isCF) and (foo2<>1) then begin
      x:=config.CF_contrast;
      counter:=counter+1;
      form1.VaComm1.WriteChar(Chr(15));
      foo:=round(x-(counter*x/(timertrans.Interval/2.1/timer1.Interval)));
      if foo < 0 then foo:=0;
      form1.VaComm1.WriteChar(chr(foo));
      if foo < 15 then foo2:=1;
    end;
    if foo2 = 1 then begin
      Panel1.Caption:=newline[1];
      Panel2.Caption:=newline[2];
      Panel3.Caption:=newline[3];
      Panel4.Caption:=newline[4];
    end;
    if (config.isMO) and (foo2=1) then begin
      x:=config.contrast;
      counter:=counter-1;
      form1.VaComm1.WriteChar(Chr($0FE));
      form1.VaComm1.WriteChar('P');
      foo:=round(x-(counter*x/(timertrans.Interval/1.8/timer1.Interval)));
      if foo > x then foo:=x;
      form1.VaComm1.WriteChar(chr(foo));
    end;
    if (config.isCF) and (foo2=1) then begin
      x:=config.CF_contrast;
      counter:=counter-1;
      form1.VaComm1.WriteChar(Chr(15));
      foo:=round(x-(counter*x/(timertrans.Interval/1.8/timer1.Interval)));
      if foo > x then foo:=x;
      form1.VaComm1.WriteChar(chr(foo));
    end;
  end;
end;

//register!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if (parameter1 = '-register') or (parameter2 = '-register') or (parameter3 = '-register') or (parameter4 = '-register') then begin
  Reg := TRegistry.Create;
  try
   Reg.RootKey := HKEY_LOCAL_MACHINE;
   if Reg.OpenKey('\SOFTWARE\LCDSmartie\', True) then begin
    Reg.Writeinteger('DoUpdate', 1);
    Reg.WriteString('Line1', StringReplace(panel1.Caption,'&&','&',[rfReplaceAll]));
    Reg.WriteString('Line2', StringReplace(panel2.Caption,'&&','&',[rfReplaceAll]));
    Reg.WriteString('Line3', StringReplace(panel3.Caption,'&&','&',[rfReplaceAll]));
    Reg.WriteString('Line4', StringReplace(panel4.Caption,'&&','&',[rfReplaceAll]));
   end;
  finally
   Reg.CloseKey;
   Reg.Free;
   inherited;
  end;
end;
//register


if (parameter1 <> '-nolcd') and (parameter2 <> '-nolcd') and (parameter3 <> '-nolcd') and (parameter4 <> '-nolcd') then begin
  if tmpregel1<>copy(panel1.Caption + '                                        ',1,config.width) then begin
    tmpregel1:=copy(StringReplace(panel1.Caption,'&&','&',[rfReplaceAll]) + '                                        ',1,config.width);
    //Application.ProcessMessages;

    Lcd.setPosition(1, 1);
    Lcd.write(tmpregel1);
  end;
  if aantregelsoud > 1 then begin
    if tmpregel2<>copy(panel2.Caption + '                                        ',1,config.width) then begin
      tmpregel2:=copy(StringReplace(panel2.Caption,'&&','&',[rfReplaceAll]) + '                                        ',1,config.width);
      //Application.ProcessMessages;

      Lcd.setPosition(1, 2);
      Lcd.write(tmpregel2);
    end;
  end;
  if aantregelsoud > 2 then begin
    if tmpregel3<>copy(panel3.Caption + '                                        ',1,config.width) then begin
      tmpregel3:=copy(StringReplace(panel3.Caption,'&&','&',[rfReplaceAll]) + '                                        ',1,config.width);
      //Application.ProcessMessages;
      Lcd.setPosition(1, 3);
      Lcd.write(tmpregel3);
    end;
  end;
  if aantregelsoud > 3 then begin
    if tmpregel4<>copy(panel4.Caption + '                                        ',1,config.width) then begin
      tmpregel4:=copy(StringReplace(panel4.Caption,'&&','&',[rfReplaceAll]) + '                                        ',1,config.width);

      Lcd.setPosition(1, 4);
      Lcd.write(tmpregel4);
    end;
  end;
end;

end;

procedure TForm1.backlit;
var
Reg: TRegistry;

begin
  if backlight=1 then begin
    Lcd.setbacklight(false);
    backlight:=0;
    popupmenu1.Items[0].Items[0].Caption:='&Backlight On';
   end else begin
    Lcd.setbacklight(true);
    backlight:=1;
    popupmenu1.Items[0].Items[0].Caption:='&Backlight Off';
   end;
if (parameter1 = '-register') or (parameter2 = '-register') or (parameter3 = '-register') or (parameter4 = '-register') then begin
  Reg := TRegistry.Create;
  try
   Reg.RootKey := HKEY_LOCAL_MACHINE;
   if Reg.OpenKey('\SOFTWARE\LCDSmartie\', True) then begin
    if backlight= 1 then Reg.Writeinteger('backlight', 1);
    if backlight= 0 then Reg.Writeinteger('backlight', 0);
   end;
  finally
   Reg.CloseKey;
   Reg.Free;
   inherited;
  end;
end;
kleur();
end;

procedure TForm1.FormShow(Sender: TObject);
var
  initfile:textfile;
  teller:integer;
  regel: String;

begin
  timer1.Interval:=config.refreshRate;

  if config.height<>aantregelsoud then begin
    aantregelsoud:=config.height;
    panel1.visible:=false;
    panel2.visible:=false;
    panel3.visible:=false;
    panel4.visible:=false;
    if config.height>0 then panel1.visible:=true;
    if config.height>1 then panel2.visible:=true;
    if config.height>2 then panel3.visible:=true;
    if config.height>3 then panel4.visible:=true;
  end;

  teller:=0;
  try
    assignfile(initfile,extractfilepath(application.exename)+'actions.cfg');
    reset (initfile);
    while not eof(initfile) do begin
      readln(initfile,regel);
      teller:=teller+1;
      actionsarray[teller,1]:=copy(regel,1,pos('�',regel)-1);
      actionsarray[teller,2]:=copy(regel,pos('�',regel)+1,1);
      actionsarray[teller,3]:=copy(regel,pos('��',regel)+2,pos('���',regel)-pos('��',regel)-2);
      actionsarray[teller,4]:=copy(regel,pos('���',regel)+3,length(regel));
    end;
    closefile(initfile);
  except
    try closefile(initfile); except end;
  end;
  totalactions:=teller;
end;

procedure TForm1.checkIfNewsUpdatesRequired;
var
  screenline:String;
  z,y: Integer;
begin
  news1:=0;
  news2:=0;
  news3:=0;
  news4:=0;
  news5:=0;
  news7:=0;
  news8:=0;

  timer2.Interval:=config.newsRefresh*60000;
  DoNewsUpdate6:=1;
  for z:= 1 to 20 do begin
    for y:= 1 to 4 do begin
      if (config.screen[z][y].enabled) then begin
        screenline:=config.screen[z][y].text;
        if (pos('$T.netHL',screenline) <> 0) then DoNewsUpdate1:=1;
        if (pos('$DutchWeather',screenline) <> 0) then DoNewsUpdate2:=1;
        if (pos('$TomsHW',screenline) <> 0) then DoNewsUpdate3:=1;
        if (pos('$Stocks',screenline) <> 0) then DoNewsUpdate4:=1;
        if (pos('$CNN',screenline) <> 0) then DoNewsUpdate5:=1;
        if (pos('$SETI',screenline) <> 0) then DoNewsUpdate7:=1;
        if (pos('$FOLD',screenline) <> 0) then DoNewsUpdate9:=1;
        if (pos('$Weather.com(',screenline) <> 0) then begin
          DoNewsUpdate8:=1;
          locationnumber:=copy(screenline,pos('(',screenline)+1,pos(')',screenline)-pos('(',screenline)-1);
        end;
      end;
    end;
  end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  checkIfNewsUpdatesRequired();
end;

procedure TForm1.kleur;
begin
if backlight=1 then
 begin
   if kleuren =0 then
   begin
     panel1.color:=$0001FFA8;
     panel2.color:=$0001FFA8;
     panel3.color:=$0001FFA8;
     panel4.color:=$0001FFA8;
     form1.Color:=$0001FFA8;
     panel1.Font.Color:=clBlack;
     panel2.Font.Color:=clBlack;
     panel3.Font.Color:=clBlack;
     panel4.Font.Color:=clBlack;
   end;
   if kleuren =1 then
   begin
     panel1.color:=$00FDF103;
     panel2.color:=$00FDF103;
     panel3.color:=$00FDF103;
     panel4.color:=$00FDF103;
     form1.Color:=$00FDF103;
     panel1.Font.Color:=clBlack;
     panel2.Font.Color:=clBlack;
     panel3.Font.Color:=clBlack;
     panel4.Font.Color:=clBlack;
   end;
   if kleuren =2 then
   begin
     panel1.color:=clyellow;
     panel2.color:=clyellow;
     panel3.color:=clyellow;
     panel4.color:=clyellow;
     form1.Color:=clyellow;
     panel1.Font.Color:=clBlack;
     panel2.Font.Color:=clBlack;
     panel3.Font.Color:=clBlack;
     panel4.Font.Color:=clBlack;
   end;
   if kleuren =3 then
   begin
     panel1.color:=clwhite;
     panel2.color:=clwhite;
     panel3.color:=clwhite;
     panel4.color:=clwhite;
     form1.Color:=clwhite;
     panel1.Font.Color:=clBlack;
     panel2.Font.Color:=clBlack;
     panel3.Font.Color:=clBlack;
     panel4.Font.Color:=clBlack;
   end;
   if kleuren =4 then
   begin
     panel1.color:=backgroundcoloron;
     panel2.color:=backgroundcoloron;
     panel3.color:=backgroundcoloron;
     panel4.color:=backgroundcoloron;
     form1.Color:=backgroundcoloron;
     panel1.Font.Color:=forgroundcoloron;
     panel2.Font.Color:=forgroundcoloron;
     panel3.Font.Color:=forgroundcoloron;
     panel4.Font.Color:=forgroundcoloron;
   end;
 end
else
 begin
   if kleuren =0 then
   begin
     panel1.color:=clgreen;
     panel2.color:=clgreen;
     panel3.color:=clgreen;
     panel4.color:=clgreen;
     form1.Color:=clgreen;
     panel1.Font.Color:=clBlack;
     panel2.Font.Color:=clBlack;
     panel3.Font.Color:=clBlack;
     panel4.Font.Color:=clBlack;
   end;
   if kleuren =1 then
   begin
     panel1.color:=$00C00000;
     panel2.color:=$00C00000;
     panel3.color:=$00C00000;
     panel4.color:=$00C00000;
     form1.Color:=$00C00000;
     panel1.Font.Color:=clWhite;
     panel2.Font.Color:=clWhite;
     panel3.Font.Color:=clWhite;
     panel4.Font.Color:=clWhite;
   end;
   if kleuren =2 then
   begin
     panel1.color:=clOlive;
     panel2.color:=clOlive;
     panel3.color:=clOlive;
     panel4.color:=clOlive;
     form1.Color:=clOlive;
     panel1.Font.Color:=clBlack;
     panel2.Font.Color:=clBlack;
     panel3.Font.Color:=clBlack;
     panel4.Font.Color:=clBlack;
   end;
   if kleuren =3 then
   begin
     panel1.color:=clsilver;
     panel2.color:=clsilver;
     panel3.color:=clsilver;
     panel4.color:=clsilver;
     form1.Color:=clsilver;
     panel1.Font.Color:=clBlack;
     panel2.Font.Color:=clBlack;
     panel3.Font.Color:=clBlack;
     panel4.Font.Color:=clBlack;
   end;
   if kleuren =4 then
   begin
     panel1.color:=backgroundcoloroff;
     panel2.color:=backgroundcoloroff;
     panel3.color:=backgroundcoloroff;
     panel4.color:=backgroundcoloroff;
     form1.Color:=backgroundcoloroff;
     panel1.Font.Color:=forgroundcoloroff;
     panel2.Font.Color:=forgroundcoloroff;
     panel3.Font.Color:=forgroundcoloroff;
     panel4.Font.Color:=forgroundcoloroff;
   end;
 end;
end;

procedure TForm1.Showwindow1Click(Sender: TObject);
begin
  if popupmenu1.Items[3].caption='&Minimize' then begin
    button1.Click;
  end else begin
    form1.Show;
    form1.BringToFront;
    form1.SetFocus;
    //Application.ProcessMessages;
  end;
end;

procedure TForm1.Close1Click(Sender: TObject);

begin
  form1.close();
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  popupmenu1.Items[3].caption:='Minimize';
  popupmenu1.Popup(form1.left+image1.left+round(image1.width/2),form1.top+image1.top+round(image1.height));
end;

procedure TForm1.Timer4Timer(Sender: TObject);
begin
if regel2scroll=1 then begin
  panel1.caption:=StringReplace(scroll(regelz[1],1,1),'&','&&',[rfReplaceAll]);
  if (parameter1 <> '-nolcd') and (parameter2 <> '-nolcd') and (parameter3 <> '-nolcd') then begin
    tmpregel1:=copy(panel1.caption + '                                        ',1,config.width-1);
    //Application.ProcessMessages;
    Lcd.setPosition(1,1);
    Lcd.write(tmpregel1);
  end;
end;
if regel2scroll=2 then begin
  panel2.caption:=StringReplace(scroll(regelz[2],2,1),'&','&&',[rfReplaceAll]);
  if (parameter1 <> '-nolcd') and (parameter2 <> '-nolcd') and (parameter3 <> '-nolcd') then begin
   tmpregel2:=copy(panel2.caption + '                                        ',1,config.width-1);
   //Application.ProcessMessages;
   Lcd.setPosition(1,2);
   Lcd.write(tmpregel2);
  end;
end;
if regel2scroll=3 then begin
  panel3.caption:=StringReplace(scroll(regelz[3],3,1),'&','&&',[rfReplaceAll]);
  if (parameter1 <> '-nolcd') and (parameter2 <> '-nolcd') and (parameter3 <> '-nolcd') then begin
    tmpregel3:=copy(panel3.caption + '                                        ',1,config.width-1);
    Lcd.setPosition(1,3);
    Lcd.write(tmpregel3);
  end;
end;
if regel2scroll=4 then begin
  panel4.caption:=StringReplace(scroll(regelz[4],4,1),'&','&&',[rfReplaceAll]);
  if (parameter1 <> '-nolcd') and (parameter2 <> '-nolcd') and (parameter3 <> '-nolcd') then begin
    tmpregel4:=copy(panel4.caption + '                                        ',1,config.width-1);
    Lcd.setPosition(1,4);
    Lcd.write(tmpregel4);
  end;
end;
end;

procedure TForm1.Timer5Timer(Sender: TObject);
begin
if regel2scroll=1 then begin
  panel1.caption:=StringReplace(scroll(regelz[1],1,-1),'&','&&',[rfReplaceAll]);
  if (parameter1 <> '-nolcd') and (parameter2 <> '-nolcd') and (parameter3 <> '-nolcd') then begin
    tmpregel1:=copy(panel1.caption + '                                        ',1,config.width-1);
    Lcd.setPosition(1,1);
    Lcd.write(tmpregel1);
  end;
end;
if regel2scroll=2 then begin
  panel2.caption:=StringReplace(scroll(regelz[2],2,-1),'&','&&',[rfReplaceAll]);
  if (parameter1 <> '-nolcd') and (parameter2 <> '-nolcd') and (parameter3 <> '-nolcd') then begin
    tmpregel2:=copy(panel2.caption + '                                        ',1,config.width-1);
    Lcd.setPosition(1,2);
    Lcd.write(tmpregel2);
  end;
end;
if regel2scroll=3 then begin
  panel3.caption:=StringReplace(scroll(regelz[3],3,-1),'&','&&',[rfReplaceAll]);
  if (parameter1 <> '-nolcd') and (parameter2 <> '-nolcd') and (parameter3 <> '-nolcd') then begin
    tmpregel3:=copy(panel3.caption + '                                        ',1,config.width-1);
    Lcd.setPosition(1,3);
    Lcd.write(tmpregel3);
  end;
end;
if regel2scroll=4 then begin
  panel4.caption:=StringReplace(scroll(regelz[4],4,-1),'&','&&',[rfReplaceAll]);
  if (parameter1 <> '-nolcd') and (parameter2 <> '-nolcd') and (parameter3 <> '-nolcd') then begin
    tmpregel4:=copy(panel4.caption + '                                        ',1,config.width-1);
    Lcd.setPosition(1,4);
    Lcd.write(tmpregel4);
  end;
end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  form1.formStyle:=fsNormal;
  form1.enabled:=false;
  form2.visible:=true;
  form2.SetFocus;
end;

procedure TForm1.Timer6Timer(Sender: TObject);
//HARDDISK MOTHERBOARD MONITOR AND DISTRIBUTED STATS!!!!!!!!!!!!!!!!!!!!!!!!!!!!
var
  letter:integer;
  letter2:array [67..90] of integer;
  x:integer;
  bestand:textfile;
  koez,hd,mbm,teller:integer;
  regel:string;
{  cpuinfo:tcpuinfo;    }
  z, y: Integer;
  screenline: String;

begin
  timer6.Interval:=config.mbmRefresh*1000;
  hd:=0;
  mbm:=0;
  koez:=0;

  for z:= 1 to 20 do begin
    for y:= 1 to 4 do begin
      if (config.screen[z][y].enabled) then begin
        screenline:=config.screen[z][y].text;
        if (pos('$Fan',screenline) <> 0) then mbm:=1;
        if (pos('$Volt',screenline) <> 0) then mbm:=1;
        if (pos('$Temp',screenline) <> 0) then mbm:=1;
        if (pos('$HD', screenline) <> 0) then hd:=1;
        if (pos('$Dnet', screenline) <> 0) then koez:=1;
      end;
    end;
  end;


  STComputername:=system1.Computername;
  STUsername:=system1.Username;

  STMemfree:=round(system1.availPhysmemory / 1024 / 1023.5);
  STMemTotal:=round(system1.totalPhysmemory / 1024 /1023);
  STPageTotal:=round(system1.totalPageFile / 1024 /1024);
  STPageFree:=round(system1.AvailPageFile / 1024 /1024);

// HD space!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if hd=1 then begin
  for letter:= 67 to 90 do
    letter2[letter]:=0;
  for z:= 1 to 20 do begin
    for y:= 1 to 4 do begin
      screenline:=config.screen[z][y].text;
      while pos('$HD',screenline) <> 0 do begin
        try
          screenline:=copy(screenline,pos('$HD',screenline),length(screenline));
          letter2[ord(upcase(copy(screenline,pos('(',screenline)+1,1)[1]))]:=1;
          screenline:=stringreplace(screenline,'$HD','',[]);
        except
          screenline:=stringreplace(screenline,'$HD','',[]);
        end;
      end;
    end;
  end;
  for letter:= 67 to 90 do begin
    try
      if letter2[letter]=1 then begin
//        if (system1.diskindrive(chr(letter),true)) then begin
          STHDFree[letter]:=system1.diskfreespace(chr(letter)) div (1024*1024);
          STHDTotal[letter]:=system1.disktotalspace(chr(letter)) div (1024*1024);
//        end;
      end;
    except
    end;
  end;
end;

//cputype!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
try
STCPUType:=cxCpu[0].Name.AsString;
except
end;

//SCREENRESO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
resoregel:=IntToStr(Screen.DesktopWidth)+'x'+IntToStr(Screen.DesktopHeight);

//MBM5!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

if mbm=1 then begin
  if (ReadMBM5Data) then mbmactive:=true
                    else mbmactive:=false;
end;

//koetje!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if koez=1 then begin
  x:=0;
  koeregel:='file not found';
  if FileExists(config.distLog)=true then begin
    assignfile(bestand,config.distLog);
    reset (bestand);
    while not eof(bestand) do begin
      readln (bestand);
      x:=x+1;
    end;
    reset(bestand);
    for teller:=1 to x-50 do begin
      readln(bestand);
    end;
    while not eof(bestand) do begin
      readln(bestand,regel);
      koeregel:=koeregel+' '+regel;
    end;
    closefile(bestand);
  end;
  koeregel:=copy(koeregel,pos('Completed',koeregel)-5,length(koeregel));
  for x:= 1 to 9 do begin
    if pos('Completed', koeregel) <> 0 then begin
      koeregel:=copy(koeregel,pos('Completed',koeregel)-5,length(koeregel));
      koeregel:=StringReplace(koeregel,'Completed','-',[]);
    end;
  end;

  if copy(koeregel,1,3) = 'RC5' then begin
    koeregel1:=copy(koeregel,pos('- [',koeregel)+3,pos(' keys',koeregel)-pos('- [',koeregel));
    if length(koeregel1) > 7 then begin
      koeregel1:=copy(koeregel1,1,pos(',',copy(koeregel1,3,length(koeregel1)))+1);
    end;
    koeregel:=copy(koeregel,pos('completion',koeregel)+30,200);
    koeregel2:=copy(koeregel,pos('(',koeregel)+1,pos('.',koeregel)-pos('(',koeregel)-1);
  end;

  if copy(koeregel,1,3) = 'OGR' then begin
    koeregel1:=copy(koeregel,pos('- [',koeregel)+3,pos(' nodes',koeregel)-pos('- [',koeregel));
    if length(koeregel1) > 7 then begin
      koeregel1:=copy(koeregel1,1,pos(',',copy(koeregel1,3,length(koeregel1)))+1);
    end;
    koeregel:=copy(koeregel,pos('remain',koeregel)+8,100);
    koeregel2:=copy(koeregel,pos('(',koeregel)+1, pos('stats',koeregel)-pos('(',koeregel)-3);
  end;
end;
end;

procedure TForm1.SpeedButton10Click(Sender: TObject);
begin
  aantalscreensheenweer:=1;
  frozen:=true;
  freeze();
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  popupmenu1.Items[3].caption:='Show Main';
  application.minimize;
  hide;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    while timer1.enabled=true do timer1.enabled:=false;
    while timer2.enabled=true do timer2.enabled:=false;
    while timer3.enabled=true do timer3.enabled:=false;
    while timer4.enabled=true do timer4.enabled:=false;
    while timer5.enabled=true do timer5.enabled:=false;
    while timer6.enabled=true do timer6.enabled:=false;
    while timer7.enabled=true do timer7.enabled:=false;
    while timer8.enabled=true do timer8.enabled:=false;
    while timer9.enabled=true do timer9.enabled:=false;
    while timer10.enabled=true do timer10.enabled:=false;
    while timer11.enabled=true do timer11.enabled:=false;

    if HTTPthreadisrunning=true then HTTPThread.Terminate;
    if pop3threadisrunning=true then pop3thread.Terminate;
  except
  end;

  if config.isHD then begin
    try
      poort1.clear;
    except end;
    try
      poort1.Free;
    except end;
  end;

  try
    if (Lcd <> nil) Then Lcd.Destory();
  except
  end;

  if config.isMO then begin
    sleep(500);
    try Vacomm1.close; except end;
  end;

  if config.isCF then begin
    Vacomm1.close;
  end;
end;



procedure TForm1.Timer8Timer(Sender: TObject);
//GAMESTATS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
var
  tempregel,tempregel2,tempregel4,regel:string;
  tempregel1:array [1..80] of String;
  tempregel3:array [1..20] of array [1..4] of string;
  teller,teller2:integer;
  bestand2,bestand:textfile;
  z, y:Integer;
  screenline: String;

begin
  timer8.Interval:=config.gameRefresh*60000;

  assignfile(bestand,extractfilepath(application.exename)+'servers.cfg');
  reset (bestand);
  for z:=1 to 20 do begin
    for y:=1 to 4 do begin
      readln(bestand, tempregel3[z,y]);
    end;
    //application.ProcessMessages;
  end;
  closefile(bestand);

  for z:=1 to 20 do begin
    for y:=1 to 4 do begin
      //application.ProcessMessages;
      screenline:=config.screen[z][y].text;
      if ((pos('$Unreal', screenline) <> 0) or (pos('$QuakeIII', screenline) <> 0) or (pos('$QuakeII', screenline) <> 0) or (pos('$Half-life', screenline) <> 0)) and (copy(screenline,pos('�',screenline)+1,1)='1') then begin
        teller:=1;
        try
          if pos('$Half-life', screenline) <> 0 then srvr:='-hls';
          if pos('$QuakeII', screenline) <> 0 then srvr:='-q2s';
          if pos('$QuakeIII', screenline) <> 0 then srvr:='-q3s';
          if pos('$Unreal', screenline) <> 0 then srvr:='-uns';
          //application.ProcessMessages;
          winexec(PChar(extractfilepath(application.exename) + 'qstat.exe -P -of txt'+intToStr(z)+'-'+intToStr(y)+'.txt -sort F '+ srvr +' '+ tempregel3[z,y]),sw_hide);

          tempregel:='';
          //application.ProcessMessages;
          sleep(1000);
          //application.ProcessMessages;

          assignfile (bestand2,extractfilepath(application.exename)+'txt'+IntToStr(z)+'-'+IntToStr(y)+'.txt');
          reset (bestand2);
          teller:=1;
          while (not eof(bestand2)) and (teller<80) do begin
            readln (bestand2, tempregel1[teller]);
            teller:=teller+1;
          end;
          closefile(bestand2);
        except
          try CloseFile(bestand2); except end;
        end;

        if (pos('$Unreal1', screenline) <> 0) or (pos('$QuakeIII1', screenline) <> 0) or (pos('$QuakeII1', screenline) <> 0) or (pos('$Half-life1', screenline) <> 0) then begin
          qstatreg1[z,y]:=copy(tempregel1[2],pos(' / ',tempregel1[2])+3,length(tempregel1[2]));
          qstatreg1[z,y]:=stripspaces(copy(qstatreg1[z,y],pos(' ',qstatreg1[z,y])+1,length(qstatreg1[z,y])));
        end;

        if (pos('$Unreal2', screenline) <> 0) or (pos('$QuakeIII2', screenline) <> 0) or (pos('$QuakeII2', screenline) <> 0) or (pos('$Half-life2', screenline) <> 0) then begin
          qstatreg2[z,y]:=copy(tempregel1[2],pos(':',tempregel1[2]),length(tempregel1[2]));
          qstatreg2[z,y]:=copy(qstatreg2[z,y],pos('/',qstatreg2[z,y])+4,length(qstatreg2[z,y]));
          qstatreg2[z,y]:=copy(qstatreg2[z,y],1,pos('/',qstatreg2[z,y])-5);
          qstatreg2[z,y]:=stripspaces(copy(qstatreg2[z,y],pos(' ',qstatreg2[z,y])+1,length(qstatreg2[z,y])));
        end;

        if (pos('$Unreal3', screenline) <> 0) or (pos('$QuakeIII3', screenline) <> 0) or (pos('$QuakeII3', screenline) <> 0) or (pos('$Half-life3', screenline) <> 0) then begin
          qstatreg3[z,y]:=stripspaces(copy(tempregel1[2],pos(' ',tempregel1[2]),length(tempregel1[2])));
          qstatreg3[z,y]:=stripspaces(copy(qstatreg3[z,y],1,pos('/',qstatreg3[z,y])+3));
        end;

        if (pos('$Unreal4', screenline) <> 0) or (pos('$QuakeIII4', screenline) <> 0) or (pos('$QuakeII4', screenline) <> 0) or (pos('$Half-life4', screenline) <> 0) then begin
          qstatreg4[z,y]:='';
          for teller2:=1 to teller-3 do begin
            regel:=stripspaces(tempregel1[teller2+2]);
            tempregel2:=stripspaces(copy(copy(regel,pos('s ', regel)+1,length(regel)),pos('s ', regel)+2,length(regel)));
            tempregel4:=stripspaces(copy(regel,2,pos(' frags ',regel)-1));
            regel:=tempregel2 + ': '+ tempregel4 + ', ';
            qstatreg4[z,y]:=qstatreg4[z,y]+regel;
            //application.ProcessMessages;
          end;
          //application.ProcessMessages;
        end;
      end;
    end;
  end;
end;

procedure TForm1.Configure1Click(Sender: TObject);
begin
Showwindow1.click();
button2.click();
end;

procedure TForm1.Timer3Timer(Sender: TObject);
//ACTIONS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
var
  teller:integer;
  todo: array[1..99] of string;
  temp1,temp2:string;

begin

  if (Lcd.readKey(kar)) then form2.Edit17.text:=kar;

if (form2<>nil) and (form2.Visible=false) then begin
  for teller := 1 to totalactions do begin
    if actionsarray[teller, 2] = '0' then begin
      try
        if StrToInt(change(actionsarray[teller, 1])) > StrToInt(actionsarray[teller, 3]) then todo[teller]:='1'+actionsarray[teller, 4] else todo[teller]:='2'+actionsarray[teller, 4];
      except
        try
          if change(actionsarray[teller, 1]) > actionsarray[teller, 3] then todo[teller]:='1'+actionsarray[teller, 4] else todo[teller]:='2'+actionsarray[teller, 4];
        except todo[teller]:=''; end;
      end;
    end;
    if actionsarray[teller, 2] = '1' then begin
      try
        if StrToInt(change(actionsarray[teller, 1])) < StrToInt(actionsarray[teller, 3]) then todo[teller]:='1'+actionsarray[teller, 4] else todo[teller]:='2'+actionsarray[teller, 4];
      except
        try
          if change(actionsarray[teller, 1]) < actionsarray[teller, 3] then todo[teller]:='1'+actionsarray[teller, 4] else todo[teller]:='2'+actionsarray[teller, 4];
        except todo[teller]:=''; end;
      end;
    end;
    if actionsarray[teller, 2] = '2' then begin
      try
        if StrToInt(change(actionsarray[teller, 1])) = StrToInt(actionsarray[teller, 3]) then todo[teller]:='1'+actionsarray[teller, 4] else todo[teller]:='2'+actionsarray[teller, 4];
      except
        try
          if change(actionsarray[teller, 1]) = actionsarray[teller, 3] then todo[teller]:='1'+actionsarray[teller, 4] else todo[teller]:='2'+actionsarray[teller, 4];
        except todo[teller]:=''; end;
      end;
    end;
    if actionsarray[teller, 2] = '3' then begin
      try
        if StrToInt(change(actionsarray[teller, 1])) <= StrToInt(actionsarray[teller, 3]) then todo[teller]:='1'+actionsarray[teller, 4] else todo[teller]:='2'+actionsarray[teller, 4];
      except
        try
          if change(actionsarray[teller, 1]) <= actionsarray[teller, 3] then todo[teller]:='1'+actionsarray[teller, 4] else todo[teller]:='2'+actionsarray[teller, 4];
        except todo[teller]:=''; end;
      end;
    end;
    if actionsarray[teller, 2] = '4' then begin
      try
        if StrToInt(change(actionsarray[teller, 1])) >= StrToInt(actionsarray[teller, 3]) then todo[teller]:='1'+actionsarray[teller, 4] else todo[teller]:='2'+actionsarray[teller, 4];
      except
        try
          if change(actionsarray[teller, 1]) >= actionsarray[teller, 3] then todo[teller]:='1'+actionsarray[teller, 4] else todo[teller]:='2'+actionsarray[teller, 4];
        except todo[teller]:=''; end;
      end;
    end;
    if actionsarray[teller, 2] = '5' then begin
      try
        if StrToInt(change(actionsarray[teller, 1])) <> StrToInt(actionsarray[teller, 3]) then todo[teller]:='1'+actionsarray[teller, 4] else todo[teller]:='2'+actionsarray[teller, 4];
      except
        try
          if change(actionsarray[teller, 1]) <> actionsarray[teller, 3] then todo[teller]:='1'+actionsarray[teller, 4] else todo[teller]:='2'+actionsarray[teller, 4];
        except todo[teller]:=''; end;
      end;
    end;
  end;

  for teller := 1 to totalactions do begin
    if pos('1NextTheme',todo[teller])<>0 then begin
      if didNextTheme[teller]=false then begin
        didNextTheme[teller]:=true;
        activetheme:=activetheme+1;
        if activetheme=10 then activetheme:= 0;
        frozen:=true;
        freeze();
      end;
    end;
    if pos('2NextTheme',todo[teller])<>0 then begin
      didNextTheme[teller]:=false;
    end;
    if pos('1LastTheme',todo[teller])<>0 then begin
      if didLastTheme[teller]=false then begin
        didLastTheme[teller]:=true;
        activetheme:=activetheme-1;
        if activetheme=-1 then activetheme:= 9;
        frozen:=true;
        freeze();
      end;
    end;
    if pos('2LastTheme',todo[teller])<>0 then begin
      didLastTheme[teller]:=false;
    end;
    if pos('1NextScreen',todo[teller])<>0 then begin
      if didNextScreen[teller]=false then begin
        didNextScreen[teller]:=true;
        aantalscreensheenweer:=1;
        frozen:=true;
        freeze();
      end;
    end;
    if pos('2NextScreen',todo[teller])<>0 then begin
      didNextScreen[teller]:=false;
    end;
    if pos('1LastScreen',todo[teller])<>0 then begin
      if didLastScreen[teller]=false then begin
        didLastScreen[teller]:=true;
        aantalscreensheenweer:=-1;
        frozen:=true;
        freeze();
      end;
    end;
    if pos('2LastScreen',todo[teller])<>0 then begin
      didLastScreen[teller]:=false;
    end;
    if pos('1GotoTheme(',todo[teller])<>0 then begin
      if didgototheme[teller]=false then begin
        didgototheme[teller]:=true;
        activetheme:=StrToInt(copy(todo[teller],pos('1GotoTheme(',todo[teller])+11,pos(')',todo[teller])-pos('1GotoTheme(',todo[teller])-11))-1;
      end;
    end;
    if pos('2GotoTheme',todo[teller])<>0 then begin
      didgototheme[teller]:=false;
    end;
    if pos('1GotoScreen(',todo[teller])<>0 then begin
      if didgotoscreen[teller]=false then begin
        didgotoscreen[teller]:=true;
        welkescreen:=StrToInt(copy(todo[teller],pos('1GotoScreen(',todo[teller])+12,pos(')',todo[teller])-pos('1GotoScreen(',todo[teller])-12))-1;
      end;
    end;
    if pos('2GotoScreen',todo[teller])<>0 then begin
      didGotoscreen[teller]:=false;
    end;
    if pos('1FreezeScreen',todo[teller])<>0 then begin
      if didFreeze[teller]=false then begin
        didFreeze[teller]:=true;
        freeze();
      end;
    end;
    if pos('2FreezeScreen',todo[teller])<>0 then begin
      didFreeze[teller]:=false;
    end;
    if pos('1RefreshAll',todo[teller])<>0 then begin
      if didRefreshAll[teller]=false then begin
        didRefreshAll[teller]:=true;
        timer2.interval:=10;
        timer6.interval:=10;
        timer8.interval:=10;
        timer9.interval:=10;
        timer10.interval:=10;
      end;
    end;
    if pos('2RefreshAll',todo[teller])<>0 then begin
      didRefreshAll[teller]:=false;
    end;
    if pos('1Backlight(',todo[teller])<>0 then begin
      if didbl[teller]=false then begin
        didbl[teller]:=true;
        temp1:=copy(todo[teller],pos('(',todo[teller])+1,1);
        if temp1 = '1' then backlight := 0;
        if temp1 = '0' then backlight := 1;
        if (temp1 = '1') or (temp1 = '0') then backlit();
      end;
    end;
    if pos('2Backlight(',todo[teller])<>0 then begin
      if didbl[teller]=true then begin
        didbl[teller]:=false;
        temp1:=copy(todo[teller],pos('(',todo[teller])+1,1);
        if temp1 = '0' then backlight := 0;
        if temp1 = '1' then backlight := 1;
        if (temp1 = '1') or (temp1 = '0') then backlit();
      end;
    end;
    if pos('1BacklightToggle',todo[teller])<>0 then begin
      if didbltoggle[teller]=false then begin
        didbltoggle[teller]:=true;
        backlit();
      end;
    end;
    if pos('2BacklightToggle',todo[teller])<>0 then begin
      didbltoggle[teller]:=false;
    end;
    if pos('1BLFlash(',todo[teller])<>0 then begin
      if didflash[teller]=false then begin
        temp1:=copy(todo[teller],pos('(',todo[teller])+1,pos(')',todo[teller])-pos('(',todo[teller])-1);
        flash:=StrToInt(temp1)*2;
        didflash[teller]:=true;
      end;
    end;
    if pos('2BLFlash(',todo[teller])<>0 then begin
      didflash[teller]:=false;
    end;
    if pos('1Wave[',todo[teller])<>0 then begin
      temp1:=copy(todo[teller],pos('1Wave[',todo[teller])+6,pos(']',todo[teller])-pos('1Wave[',todo[teller])-6);
      if didsound[teller]=false then begin
        didsound[teller]:=true;
        playsound(Pchar(temp1),0,SND_FILENAME);
      end;
    end;
    if pos('2Wave[',todo[teller])<>0 then begin
      didsound[teller]:=false;
    end;
    if pos('1Exec[',todo[teller])<>0 then begin
      temp1:=copy(todo[teller],pos('1Exec[',todo[teller])+6,pos(']',todo[teller])-pos('1Exec[',todo[teller])-6);
      if didexec[teller]=false then begin
        didexec[teller]:=true;
        shellexecute(0,'open',PChar(temp1),'','',SW_SHOW);
      end;
    end;
    if pos('2Exec[',todo[teller])<>0 then begin
      didexec[teller]:=false;
    end;
    if pos('1WANextTrack',todo[teller])<>0 then begin
      if didwanexttrack[teller]=false then begin
        didwanexttrack[teller]:=true;
        Winampctrl1.Next;
      end;
    end;
    if pos('2WANextTrack',todo[teller])<>0 then begin
      didwanexttrack[teller]:=false;
    end;
    if pos('1WALastTrack',todo[teller])<>0 then begin
      if didwalasttrack[teller]=false then begin
        didwalasttrack[teller]:=true;
        Winampctrl1.Previous;
      end;
    end;
    if pos('2WALastTrack',todo[teller])<>0 then begin
      didwalasttrack[teller]:=false;
    end;
    if pos('1WAPlay',todo[teller])<>0 then begin
      if didwaPlay[teller]=false then begin
        didwaPlay[teller]:=true;
        Winampctrl1.Play;
      end;
    end;
    if pos('2WAPlay',todo[teller])<>0 then begin
      didwaplay[teller]:=false;
    end;
    if pos('1WAStop',todo[teller])<>0 then begin
      if didwaStop[teller]=false then begin
        didwaStop[teller]:=true;
        Winampctrl1.Stop;
      end;
    end;
    if pos('2WAStop',todo[teller])<>0 then begin
      didwastop[teller]:=false;
    end;
    if pos('1WAPause',todo[teller])<>0 then begin
      if didwaPause[teller]=false then begin
        didwaPause[teller]:=true;
        Winampctrl1.Pause;
      end;
    end;
    if pos('2WAPause',todo[teller])<>0 then begin
      didwaPause[teller]:=false;
    end;
    if pos('1WAShuffle',todo[teller])<>0 then begin
      if didwaShuffle[teller]=false then begin
        didwashuffle[teller]:=true;
        Winampctrl1.ToggleShufflE;
      end;
    end;
    if pos('2WAShuffle',todo[teller])<>0 then begin
      didwaShuffle[teller]:=false;
    end;
    if pos('1WAVolDown',todo[teller])<>0 then begin
      if didWAVolDown[teller]=false then begin
        didWAVolDown[teller]:=true;
        WinampCtrl1.VolumeDown;
        WinampCtrl1.VolumeDown;
        WinampCtrl1.VolumeDown;
        WinampCtrl1.VolumeDown;
        WinampCtrl1.VolumeDown;
      end;
    end;
    if pos('2WAVolDown',todo[teller])<>0 then begin
      didWAVolDown[teller]:=false;
    end;
    if pos('1WAVolUp',todo[teller])<>0 then begin
      if didWAVolUp[teller]=false then begin
        didWAVolUp[teller]:=true;
        WinampCtrl1.VolumeUp;
        WinampCtrl1.VolumeUp;
        WinampCtrl1.VolumeUp;
        WinampCtrl1.VolumeUp;
        WinampCtrl1.VolumeUp;
      end;
    end;
    if pos('2WAVolUp',todo[teller])<>0 then begin
      didWAVolUp[teller]:=false;
    end;
    if pos('1GPO(',todo[teller])<>0 then begin
      if didgpo[teller]=false then begin
        didgpo[teller]:=true;
        if config.isMO then begin
          try
            temp1:=copy(todo[teller],pos('(',todo[teller])+1,pos(',',todo[teller])-pos('(',todo[teller])-1);
            temp2:=copy(todo[teller],pos(',',todo[teller])+1,pos(')',todo[teller])-pos(',',todo[teller])-1);
            if (temp2 = '1') or (temp2 = '0') then doGPO(StrToInt(temp1), StrToInt(temp2));
          except end;
        end;
      end;
    end;
    if pos('2GPO(',todo[teller])<>0 then begin
      if didgpo[teller]=true then begin
        didgpo[teller]:=false;
        if config.isMO then begin
          try
            temp1:=copy(todo[teller],pos('(',todo[teller])+1,pos(',',todo[teller])-pos('(',todo[teller])-1);
            temp2:=copy(todo[teller],pos(',',todo[teller])+1,pos(')',todo[teller])-pos(',',todo[teller])-1);
            if temp2='1' then temp2:='0' else temp2:='1';
            if (temp2 = '1') or (temp2 = '0') then doGPO(StrToInt(temp1), StrToInt(temp2));
          except end;
        end;
      end;
    end;
    if pos('1GPOFlash(',todo[teller])<>0 then begin
      if didGPOFlash[teller]=false then begin
        didGPOFlash[teller]:=true;
        if config.isMO then begin
          try
            whatgpo:=StrToInt(copy(todo[teller],pos('(',todo[teller])+1,pos(',',todo[teller])-pos('(',todo[teller])-1));
            temp2:=copy(todo[teller],pos(',',todo[teller])+1,pos(')',todo[teller])-pos(',',todo[teller])-1);
            gpoflash:=StrToInt(temp2)*2;
          except end;
        end;
      end;
    end;
    if pos('2GPOFlash(',todo[teller])<>0 then begin
      didGPOFlash[teller]:=false;
    end;
    if pos('1GPOToggle(',todo[teller])<>0 then begin
      if didgpotoggle[teller]=false then begin
        try
          didgpotoggle[teller]:=true;
          temp1:=copy(todo[teller],pos('(',todo[teller])+1,pos(')',todo[teller])-pos('(',todo[teller])-1);
          dogpo(StrToInt(temp1),2)
        except end;
      end;
    end;
    if pos('2GPOToggle(',todo[teller])<>0 then begin
      didgpotoggle[teller]:=false;
    end;
    if pos('1Fan(',todo[teller])<>0 then begin
      if didMOFan[teller]=false then begin
        try
          didMOFan[teller]:=true;
          temp1:=copy(todo[teller],pos('(',todo[teller])+1,pos(',',todo[teller])-pos('(',todo[teller])-1);
          temp2:=copy(todo[teller],pos(',',todo[teller])+1,pos(')',todo[teller])-pos(',',todo[teller])-1);

          Lcd.setFan(StrToInt(temp1), StrToInt(temp2));

        except end;
      end;
    end;
    if pos('2Fan(',todo[teller])<>0 then begin
      didMOFan[teller]:=false;
    end;
  end;
end;
end;


procedure TForm1.Timer9Timer(Sender: TObject);
//MAILS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
begin
  timer9.Interval:=config.emailPeriod*60000;
  if pop3threadisrunning=false then Tpop3Thread.Create(false);
end;

procedure TForm1.BacklightOn1Click(Sender: TObject);
begin
  backlit();
end;

procedure TForm1.Timer10Timer(Sender: TObject);
//NETWORKS STATS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
var
  netwerk:integer;
  Size: ULONG;
  IntfTable: PMibIfTable;
  I: Integer;
  z,y: Integer;
  MibRow: TMibIfRow;
  phoste: PHostEnt;
  Buffer: array [0..100] of char;
  WSAData: TWSADATA;

begin
  netwerk:=0;
  timer10.interval:=1000;

  for z:= 1 to 20 do begin
    for y:= 1 to 4 do begin
      if (config.screen[z][y].enabled) and (pos('$Net', config.screen[z][y].text) <> 0) then netwerk:=1;
    end;
  end;

if netwerk=1 then begin
  if WSAStartup($0101, WSAData) <> 0 then exit;
  GetHostName(Buffer,Sizeof(Buffer));
  phoste:=GetHostByName(buffer);
  if phoste = nil then ipaddress:='127.0.0.1'
  else ipaddress:=StrPas(inet_ntoa(PInAddr(phoste^.h_addr_list^)^));
  WSACleanup;

  Size := 0;
  if GetIfTable(nil, Size, True) <> ERROR_INSUFFICIENT_BUFFER then Exit;
  IntfTable := AllocMem(Size);
  try
    if GetIfTable(IntfTable, Size, True) = NO_ERROR then
    begin
      for I := 0 to IntfTable^.dwNumEntries - 1 do
      begin
        {$R-}MibRow := IntfTable.Table[I];{$R+}
        // Ignore everything except ethernet cards
        if MibRow.dwType <> MIB_IF_TYPE_ETHERNET then Continue;

        netadaptername[I]:=stripspaces(PChar(@MibRow.bDescr[0]));
        nettotaldown[I]:=MibRow.dwInOctets;
        nettotalup[I]:=MibRow.dwOutOctets;
        netunicastdown[I]:=MibRow.dwInUcastPkts;
        netunicastup[I]:=MibRow.dwOutUcastPkts;
        netnunicastDown[I]:=MibRow.dwInNUcastPkts;
        netnunicastUp[I]:=MibRow.dwOutNUcastPkts;
        netDiscardsDown[I]:=MibRow.dwInDiscards;
        netDiscardsUp[I]:=MibRow.dwOutDiscards;
        netErrorsDown[I]:=MibRow.dwInErrors;
        netErrorsUp[I]:=MibRow.dwOutErrors;
        netSpeedDownK[I]:=round((nettotaldown[I]-nettotaldownold[I])/1024*10)/10;
        netSpeedUpK[I]:=round((nettotalup[I]-nettotalupold[I])/1024*10)/10;
        netSpeedDownM[I]:=round((nettotaldown[I]-nettotaldownold[I])/1024/1024*10)/10;
        netSpeedUpM[I]:=round((nettotalup[I]-nettotalupold[I])/1024/1024*10)/10;
        nettotaldownold[I]:=nettotaldown[I];
        nettotalupold[I]:=nettotalup[I];
      end;
    end;
  finally
    FreeMem(IntfTable);
  end;
end;
end;

procedure TForm1.Timer7Timer(Sender: TObject);
//NEXT SCREEN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Label opnieuwscreen;
var
  xx, x:integer;
  welkescreenoud:integer;
  y: Integer;
  ascreen: TScreenLine;
  
begin
  totaldlls:=0;
  welkescreenoud:=welkescreen;
  x:=0;
  xx:=0;
opnieuwscreen:
  x:=x+1;
  xx:=xx+1;
  if config.randomScreens then begin
    welkescreen:=round(random(20)+1);
    if welkescreen>20 then welkescreen:=20;
    if welkescreen<1 then welkescreen:=1;
  end;
  if not config.randomScreens then begin
    welkescreen:=welkescreen+aantalscreensheenweer;
    if welkescreen>20 then welkescreen:=1;
    if welkescreen<1 then welkescreen:=20;
  end;

  if xx> 22 then begin
    activetheme:=activetheme+1;
    xx:=0;
  end;
  if (((x> 242) and (not config.randomScreens))
        or ((x> 1000) and (config.randomScreens))) then begin

    // It seems that we are in a endless loop because no screen is able to be
    // displayed.  Force screen 1 to be displayed.
    x:=0;

    for y:= 1 to 4 do begin
      config.screen[1][y].enabled:=True;
      config.screen[1][y].skip:=0;
      config.screen[1][y].noscroll:=False;
    end;

    welkescreen:=1;
    activetheme:=0;
  end;

  ascreen:= config.screen[welkescreen][1];

  if (ascreen.theme <> activetheme) then goto opnieuwscreen;
  if (not ascreen.enabled) then goto opnieuwscreen;
  if (ascreen.skip = 1) and (winampctrl1.GetSongInfo(1) = 0) then goto opnieuwscreen;
  if (ascreen.skip = 2) and (winampctrl1.GetSongInfo(1) <> 0) then goto opnieuwscreen;
  if (ascreen.skip = 3) and (not mbmactive) then goto opnieuwscreen;
  if (ascreen.skip = 4) and (mbmactive) then goto opnieuwscreen;
  if (ascreen.skip = 7) and (not isconnected) then goto opnieuwscreen;
  if (ascreen.skip = 8) and (isconnected) then goto opnieuwscreen;
  if (ascreen.skip = 5) then begin
    if ((mailregel1 = '') or (mailregel1 = '0')) and
       ((mailregel2 = '') or (mailregel2 = '0')) and
       ((mailregel3 = '') or (mailregel3 = '0')) and
       ((mailregel4 = '') or (mailregel4 = '0')) and
       ((mailregel5 = '') or (mailregel5 = '0')) and
       ((mailregel6 = '') or (mailregel6 = '0')) and
       ((mailregel7 = '') or (mailregel7 = '0')) and
       ((mailregel8 = '') or (mailregel8 = '0')) and
       ((mailregel9 = '') or (mailregel9 = '0')) and
       ((mailregel0 = '') or (mailregel0 = '0')) then
      goto opnieuwscreen;
  end;
  if (ascreen.skip = 6) then begin
    if ((mailregel1 <> '') and (StrToInt(mailregel1) > 0)) or
       ((mailregel2 <> '') and (StrToInt(mailregel2) > 0)) or
       ((mailregel3 <> '') and (StrToInt(mailregel3) > 0)) or
       ((mailregel4 <> '') and (StrToInt(mailregel4) > 0)) or
       ((mailregel5 <> '') and (StrToInt(mailregel5) > 0)) or
       ((mailregel6 <> '') and (StrToInt(mailregel6) > 0)) or
       ((mailregel7 <> '') and (StrToInt(mailregel7) > 0)) or
       ((mailregel8 <> '') and (StrToInt(mailregel8) > 0)) or
       ((mailregel9 <> '') and (StrToInt(mailregel9) > 0)) or
       ((mailregel0 <> '') and (StrToInt(mailregel0) > 0)) then
      goto opnieuwscreen;
  end;

  scrollline1:=config.screen[welkescreen][1].noscroll;
  scrollline2:=config.screen[welkescreen][2].noscroll;
  scrollline3:=config.screen[welkescreen][3].noscroll;
  scrollline4:=config.screen[welkescreen][4].noscroll;
  scrollline5:=false;

  if timertransIntervaltemp <> 0 then timertrans.Interval:=timertransIntervaltemp;
  if (welkescreenoud<>welkescreen) then begin
    timertrans.Enabled:=True;
    for y:= 1 to 4 do begin
      scrollPos[y]:=1; // Reset scroll postion.
    end;
  end;
  gotnewlines:=false;
  counter:=0;
  foo2:=0;

  oldline[1]:=panel1.Caption;
  oldline[2]:=panel2.Caption;
  oldline[3]:=panel3.Caption;
  oldline[4]:=panel4.Caption;
  for x:=1 to 40 do begin
    gokjesarray[1,x]:=false;
    gokjesarray[2,x]:=false;
    gokjesarray[3,x]:=false;
    gokjesarray[4,x]:=false;
  end;

  timer7.Interval:=ascreen.showTime*1000+timertransIntervaltemp;
  aantalscreensheenweer:=1;

  timertransIntervaltemp:=ascreen.interactionTime*100;
  transActietemp:=transActietemp2;
  transActietemp2:=ascreen.interaction;

  if not ascreen.enabled then transActietemp2:=0;
  if transActietemp2=0 then timertransIntervaltemp:=1;

  if (config.width=40) then begin
    panel5.left:=135;
    panel5.width:=100;
    Panel5.Caption:='Theme:' + IntToStr(activetheme+1) + ' Screen:' + IntToStr(welkescreen);
  end else begin
    panel5.left:=90;
    panel5.width:=23;
    Panel5.Caption:=IntToStr(activetheme+1) + ' | ' + IntToStr(welkescreen);
  end;
end;

procedure TForm1.Timer11Timer(Sender: TObject);
begin
  poort1 := TParPort.Create($+config.parallelPort,config.width, config.height); //hex waarde v/d poort
  Lcd:=TLCD_HD.Create();
  Lcd.setbacklight(true);

  customchar('1,12,18,18,12,0,0,0,0');
  customchar('2,31,31,31,31,31,31,31,31');
  customchar('3,16,16,16,16,16,16,31,16');
  customchar('4,28,28,28,28,28,28,31,28');
  customchar('1,12,18,18,12,0,0,0,0');
  customchar('2,31,31,31,31,31,31,31,31');
  customchar('3,16,16,16,16,16,16,31,16');
  customchar('4,28,28,28,28,28,28,31,28');

  timer1.enabled:=true;
  timer2.enabled:=true;
  timer3.enabled:=true;
  timer6.enabled:=true;
  timer7.enabled:=true;
  timer8.enabled:=true;
  timer9.enabled:=true;
  timer10.enabled:=true;
  timer11.Enabled:=false;
  timer12.enabled:=true;
  timer13.enabled:=true;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  canclose:=true;
end;

procedure TForm1.Credits1Click(Sender: TObject);
begin
  form1.formStyle:=fsNormal;
  form1.enabled:=false;
  form4.visible:=true;
  form4.BringToFront;
end;

procedure TForm1.NextTheme1Click(Sender: TObject);
begin
  activetheme:=activetheme+1;
  if activetheme=10 then activetheme:= 0;
  frozen:=true;
  freeze();
end;

procedure TForm1.LastTheme1Click(Sender: TObject);
begin
  activetheme:=activetheme-1;
  if activetheme=-1 then activetheme:= 9;
  frozen:=true;
  freeze();
end;

procedure TForm1.Image1DblClick(Sender: TObject);
begin
  form1.formStyle:=fsNormal;
  form1.enabled:=false;
  form4.visible:=true;
  form4.BringToFront;
end;

procedure TForm1.Freeze1Click(Sender: TObject);
begin
freeze();
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if upcase(key)='Z' then winampctrl1.Previous;
  if upcase(key)='X' then winampctrl1.Play;
  if upcase(key)='C' then winampctrl1.Pause;
  if upcase(key)='V' then winampctrl1.Stop;
  if upcase(key)='B' then winampctrl1.Next;
  if upcase(key)='N' then backlit();
  if upcase(key)='M' then freeze();
  if upcase(key)='K' then begin
    activetheme:=activetheme-1;
    if activetheme=-1 then activetheme:= 9;
    frozen:=true;
    freeze();
  end;
  if upcase(key)='L' then begin
    activetheme:=activetheme+1;
    if activetheme=10 then activetheme:= 0;
    frozen:=true;
    freeze();
  end;
  if upcase(key)=',' then speedbutton1.click();
  if upcase(key)='.' then speedbutton10.click();
  if (upcase(key)='?') or (upcase(key)='/') then begin
    form1.timer2.interval:=10;
    form1.timer8.interval:=10;
    form1.timer9.interval:=10;
    form1.timer6.interval:=10;
  end;
end;

procedure TForm1.freeze();
begin
  if frozen=false then begin
    frozen:=true;
    form1.timer7.enabled:=false;
    popupmenu1.Items[0].Items[1].Caption:='Unfreeze';
    form1.caption:=form1.caption + ' - frozen'
  end else begin
    frozen:=false;
    form1.timer7.enabled:=true;
    form1.timer7.interval:=5;
    popupmenu1.Items[0].Items[1].Caption:='Freeze';
    if pos('frozen', form1.caption) <> 0 then
      form1.caption:=copy(form1.caption,1, length(form1.caption)-length(' - frozen'));
  end;
end;

procedure TForm1.Image12MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image12.picture.LoadFromFile(extractfilepath(application.exename)+'images\big_arrow_left_up.bmp');
end;

procedure TForm1.Image12MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image12.picture.LoadFromFile(extractfilepath(application.exename)+'images\big_arrow_left_down.bmp');
end;

procedure TForm1.Image16MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image16.picture.LoadFromFile(extractfilepath(application.exename)+'images\setup_down.bmp');
end;

procedure TForm1.Image16MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image16.picture.LoadFromFile(extractfilepath(application.exename)+'images\setup_up.bmp');
end;

procedure TForm1.Image17MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image17.picture.LoadFromFile(extractfilepath(application.exename)+'images\hide_down.bmp');
end;

procedure TForm1.Image17MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image17.picture.LoadFromFile(extractfilepath(application.exename)+'images\hide_up.bmp');
end;

procedure TForm1.Image3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image3.picture.LoadFromFile(extractfilepath(application.exename)+'images\small_arrow_left_down1.bmp');
  regel2scroll:=1;
  timer5.enabled:=true;
  timer1.enabled:=false;
end;

procedure TForm1.Image3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image3.picture.LoadFromFile(extractfilepath(application.exename)+'images\small_arrow_left_up1.bmp');
  timer5.enabled:=false;
  timer1.enabled:=true;
end;

procedure TForm1.Image4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image4.picture.LoadFromFile(extractfilepath(application.exename)+'images\small_arrow_left_down2.bmp');
  regel2scroll:=2;
  timer5.enabled:=true;
  timer1.enabled:=false;
end;

procedure TForm1.Image5MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image5.picture.LoadFromFile(extractfilepath(application.exename)+'images\small_arrow_left_down3.bmp');
  regel2scroll:=3;
  timer5.enabled:=true;
  timer1.enabled:=false;
end;

procedure TForm1.Image6MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image6.picture.LoadFromFile(extractfilepath(application.exename)+'images\small_arrow_left_down4.bmp');
  regel2scroll:=4;
  timer5.enabled:=true;
  timer1.enabled:=false;
end;

procedure TForm1.Image7MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image7.picture.LoadFromFile(extractfilepath(application.exename)+'images\small_arrow_right_down1.bmp');
  regel2scroll:=1;
  timer4.enabled:=true;
end;

procedure TForm1.Image8MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image8.picture.LoadFromFile(extractfilepath(application.exename)+'images\small_arrow_right_down2.bmp');
  regel2scroll:=2;
  timer4.enabled:=true;
end;

procedure TForm1.Image9MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image9.picture.LoadFromFile(extractfilepath(application.exename)+'images\small_arrow_right_down3.bmp');
  regel2scroll:=3;
  timer4.enabled:=true;
end;

procedure TForm1.Image10MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image10.picture.LoadFromFile(extractfilepath(application.exename)+'images\small_arrow_right_down4.bmp');
  regel2scroll:=4;
  timer4.enabled:=true;
end;

procedure TForm1.Image4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image4.picture.LoadFromFile(extractfilepath(application.exename)+'images\small_arrow_left_up2.bmp');
  timer5.enabled:=false;
  timer1.enabled:=true;
end;

procedure TForm1.Image5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image5.picture.LoadFromFile(extractfilepath(application.exename)+'images\small_arrow_left_up3.bmp');
  timer5.enabled:=false;
  timer1.enabled:=true;
end;

procedure TForm1.Image6MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image6.picture.LoadFromFile(extractfilepath(application.exename)+'images\small_arrow_left_up4.bmp');
  timer5.enabled:=false;
  timer1.enabled:=true;
end;

procedure TForm1.Image7MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image7.picture.LoadFromFile(extractfilepath(application.exename)+'images\small_arrow_right_up1.bmp');
  timer4.enabled:=false;
end;

procedure TForm1.Image8MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image8.picture.LoadFromFile(extractfilepath(application.exename)+'images\small_arrow_right_up2.bmp');
  timer4.enabled:=false;
end;

procedure TForm1.Image9MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image9.picture.LoadFromFile(extractfilepath(application.exename)+'images\small_arrow_right_up3.bmp');
  timer4.enabled:=false;
end;

procedure TForm1.Image10MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image10.picture.LoadFromFile(extractfilepath(application.exename)+'images\small_arrow_right_up4.bmp');
  timer4.enabled:=false;
end;

procedure TForm1.Image11MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image11.picture.LoadFromFile(extractfilepath(application.exename)+'images\big_arrow_right_down.bmp');
end;

procedure TForm1.Image11MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image11.picture.LoadFromFile(extractfilepath(application.exename)+'images\big_arrow_right_up.bmp');
end;

procedure TForm1.Image12Click(Sender: TObject);
begin
speedbutton1.click;
end;

procedure TForm1.Image11Click(Sender: TObject);
begin
speedbutton10.click;
end;

procedure TForm1.Image17Click(Sender: TObject);
begin
button1.click;
end;

procedure TForm1.Image16Click(Sender: TObject);
begin
  if timer11.enabled = false then button2.click;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  aantalscreensheenweer:=-1;
  frozen:=true;
  freeze();
end;

procedure THTTPThread.execute();
var
  teller,teller2:integer;
  templine:array[1..20] of String;
  versionregel: String;

begin
  HTTPthreadisrunning:=true;
    if DoNewsUpdate1=1 then begin
    DoNewsUpdate1:=0;
    try
     //Application.ProcessMessages;
     tnetregel:=form1.IDHTTP4.Get('http://aphrodite.tweakers.net/turbotracker.dsp');
    except
      if news1<4 then begin
        news1:=news1+1;
        DoNewsUpdate1:=1
      end else tnetregel:= 'Connection Time-Out'
    end;

      tnetregel:=StringReplace(tnetregel,'&amp','&',[rfReplaceAll]);
      tnetregel:=StringReplace(tnetregel,chr(10),'',[rfReplaceAll]);
      tnetregel:=StringReplace(tnetregel,chr(13),'',[rfReplaceAll]);

     for teller:=1 to 12 do begin
       tnetregel:=copy(tnetregel,pos('<titel>',tnetregel)+length('<titel>'),length(tnetregel));
       templine[teller]:=copy(tnetregel,1,pos('</titel>',tnetregel)-1);
     end;
     tnetregel:=templine[1]+' | '+templine[2]+' | '+templine[3]+' | '+templine[4]+' | '+templine[5]+' | '+templine[6]+' | '+templine[7]+' | '+templine[8]+' | '+templine[9]+' | '+templine[10]+' | '+templine[11]+' | '+templine[12];
     if copy(tnetregel,1,6)=' |  | ' then begin
       if news1<4 then begin
         news1:=news1+1;
         DoNewsUpdate1:=1
       end else tnetregel:= 'Connection Time-Out'
     end;
  end;

  if DoNewsUpdate2<>0 then begin
   try
     //Application.ProcessMessages;
     if DoNewsUpdate2 = 1 then begin
       DoNewsUpdate2:=0;
       weerregel:=Form1.IDHTTP1.Get('http://www.knmi.nl/voorl/weer/weermain.html');
       weerregel:=copy(weerregel,pos('<p>',weerregel)+3,(700)-(pos('<p>',weerregel)+3));
       weerregel:=StringReplace(weerregel,'&amp','&',[rfReplaceAll]);
       for teller2:=1 to 10 do begin
        //Application.ProcessMessages;
        templine[teller2]:=copy(weerregel,1,pos(chr(10),weerregel)-1)+' ';
        weerregel:=copy(weerregel,pos(chr(10),weerregel)+1,length(weerregel)-pos(chr(10),weerregel)+1);
       end;
       weerregel:=templine[1]+templine[2]+templine[3]+templine[4]+templine[5]+templine[6]+templine[7]+templine[8]+templine[9]+templine[10];
       weerregel:=copy(weerregel,pos('<p>',weerregel)+3,(pos('<P>',weerregel)-6)-(pos('<p>',weerregel)+3));
     end;
     if copy(weerregel,1,6)='      ' then begin
       if news2<4 then begin
         news2:=news2+1;
         DoNewsUpdate2:=1
       end else weerregel:= 'Connection Time-Out';
     end;
   except
     if news2<4 then begin
       news2:=news2+1;
       DoNewsUpdate2:=1
       end else weerregel:= 'Connection Time-Out';
     end;
   end;

  if DoNewsUpdate3=1 then begin
    DoNewsUpdate3:=0;
      try
       //Application.ProcessMessages;
       techregel:=Form1.IDHTTP2.Get('http://www.tomshardware.com/technews/index.html');
      except
        if news3<4 then begin
          news3:=news3+1;
          DoNewsUpdate3:=1
        end else techregel:= 'Connection Time-Out';
      end;

      techregel:=StringReplace(techregel,chr(10),'',[rfReplaceAll]);
      techregel:=StringReplace(techregel,chr(13),'',[rfReplaceAll]);
      techregel:=copy(techregel,pos('<FONT FACE="Verdana,Arial,Helvetica" SIZE="1" COLOR="#000000"><B>',techregel)+length('<FONT FACE="Verdana,Arial,Helvetica" SIZE="1" COLOR="#000000"><B>'),length(techregel));
      for teller:= 1 to 10 do begin
        techregel:=copy(techregel,pos('TARGET="_top">',techregel)+length('TARGET="_top">'),length(techregel));
        templine[teller]:=copy(techregel,1,pos('<',techregel)-1)+' | ';
      end;
      techregel:=templine[1]+templine[2]+templine[3]+templine[4]+templine[5]+templine[6]+templine[7]+templine[8]+templine[9]+templine[10];
      if copy(techregel,1,6)=' |  | ' then begin
        if news3<4 then begin
          news3:=news3+1;
          DoNewsUpdate3:=1
        end else techregel:= 'Connection Time-Out';
      end;
  end;

  if DoNewsUpdate4=1 then begin
   DoNewsUpdate4:=0;
    try
     //Application.ProcessMessages;
     aexregel:=Form1.IDHTTP3.Get('http://www.aex.nl/scripts/home2.asp?taal=nl');
    except
       if news4<4 then begin
         news4:=news4+1;
         DoNewsUpdate4:=1
       end else aexregel:= 'Connection Time-Out';
    end;

      aexregel:=StringReplace(aexregel,'&nbsp;','',[rfReplaceAll]);
      aexregel:=StringReplace(aexregel,'&amp','&',[rfReplaceAll]);
      aexregel:=StringReplace(aexregel,'<!--*********************-->','',[rfReplaceAll]);
      aexregel:=StringReplace(aexregel,chr(10),'',[rfReplaceAll]);
      aexregel:=StringReplace(aexregel,chr(13),'',[rfReplaceAll]);

     aexregel:=copy(aexregel,pos('<TD ROWSPAN=5 BACKGROUND="/i/beurs.gif"><IMG SRC="/i/pixel.gif" WIDTH=357 HEIGHT=1><BR><IMG NAME="graph" SRC="/i/pixel.gif" WIDTH=250 HEIGHT=105 HSPACE=0 VSPACE=0></TD>',aexregel)+length('<TD ROWSPAN=5 BACKGROUND="/i/beurs.gif"><IMG SRC="/i/pixel.gif" WIDTH=357 HEIGHT=1><BR><IMG NAME="graph" SRC="/i/pixel.gif" WIDTH=250 HEIGHT=105 HSPACE=0 VSPACE=0></TD>'),length(aexregel));
     aexregel:=copy(aexregel,pos('<FONT FACE="Arial, Helvetica" SIZE=1><!-- VALUE #0 -->',aexregel)+length('<FONT FACE="Arial, Helvetica" SIZE=1><!-- VALUE #0 -->'),length(aexregel));

     for teller:=1 to 8 do begin
     aexregel:=copy(aexregel,pos(');return true">',aexregel)+length(');return true">'),length(aexregel));
       templine[teller]:=copy(aexregel,1,pos('</A>',aexregel)-1);
     end;
     aexregel:=templine[2]+':'+templine[1]+' | '+templine[4]+':'+templine[3]+' | '+templine[6]+':'+templine[5]+' | '+templine[8]+':'+templine[7];
     if copy(aexregel,1,6)=': | : ' then begin
       if news4<4 then begin
         news4:=news4+1;
         DoNewsUpdate4:=1
       end else aexregel:= 'Connection Time-Out';
     end;
  end;

  if DoNewsUpdate5=1 then begin
   DoNewsUpdate5:=0;
   try
     //Application.ProcessMessages;
     CNNregel:=Form1.IDHTTP5.Get('http://www.cnn.com/WORLD/');
    except
       if news5<4 then begin
         news5:=news5+1;
         DoNewsUpdate5:=1
       end else CNNregel:= 'Connection Time-Out';
    end;

    CNNregel:=StringReplace(CNNregel,'&amp','&',[rfReplaceAll]);
    CNNregel:=StringReplace(CNNregel,chr(10),'',[rfReplaceAll]);
    CNNregel:=StringReplace(CNNregel,chr(13),'',[rfReplaceAll]);

    CNNregel:=copy(CNNregel,pos('<!-- ================== content ================== -->',CNNregel)+length('<!-- ================== content ================== -->'),length(CNNregel));
    CNNregel:=copy(CNNregel,pos('<td width="170" valign="top">',CNNregel)+length('<td width="170" valign="top">'),length(CNNregel));
    CNNregel:=copy(CNNregel,pos('<span class="Text1">',CNNregel)+length('<span class="Text1">'),pos('<br clear="all">',CNNregel));

     for teller:=1 to 12 do templine[teller]:='';
     for teller:=1 to 10 do begin
         CNNregel:=copy(CNNregel,pos('html">',CNNregel)+length('html">'),length(CNNregel));
         templine[teller]:=copy(CNNregel,1,pos('</a>',CNNregel)-1)+' | ';
         CNNregel:=copy(CNNregel,pos('</a>',CNNregel)+length('</a>'),length(CNNregel));
         if templine[teller]=' | ' then templine[teller]:='';
     end;
     CNNregel:=templine[1]+templine[2]+templine[3]+templine[4]+templine[5]+templine[6]+templine[7]+templine[8]+templine[9]+templine[10];
     CNNregel:=copy(CNNregel,1,length(CNNregel)-3);
     if copy(CNNregel,1,6)='' then begin
       if news5<4 then begin
         news5:=news5+1;
         DoNewsUpdate5:=1
       end else CNNregel:= 'Connection Time-Out';
     end;
  end;

  if (config.checkUpdates) and (DoNewsUpdate6=1) then begin
    DoNewsUpdate6:=0;
    try
      //Application.ProcessMessages;
      versionregel:=Form1.IDHTTP6.Get('http://lcdsmartie.sourceforge.net/version.txt');
      //Application.ProcessMessages;
    except
      versionregel:='';
    end;
    versionregel:=StringReplace(versionregel,chr(10),'',[rfReplaceAll]);
    versionregel:=StringReplace(versionregel,chr(13),'',[rfReplaceAll]);
    if copy(versionregel,1,1) = '5' then
      isconnected:=true;
    if (length(versionregel) < 72) and (copy(versionregel,1,7) <> '5.3.0.0') and (versionregel <> '') then begin
      Form1.timer1.enabled:=false;
      Form1.timer2.enabled:=false;
      Form1.timer3.enabled:=false;
      Form1.timer4.enabled:=false;
      Form1.timer5.enabled:=false;
      Form1.timer6.enabled:=false;
      Form1.timer7.enabled:=false;
      Form1.timer8.enabled:=false;
      Form1.timer9.enabled:=false;
      if MessageDlg('A new version of LCD Smartie is detected. '+chr(13)+copy(versionregel,8,62)+chr(13)+'Go to download page?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
        ShellExecute(0, Nil, pchar('http://lcdsmartie.sourceforge.net/'), Nil, Nil, SW_NORMAL);
        Form1.close;
      end else begin
        Form1.timer1.enabled:=true;
        Form1.timer2.enabled:=true;
        Form1.timer3.enabled:=true;
        Form1.timer6.enabled:=true;
        Form1.timer7.enabled:=true;
        Form1.timer8.enabled:=true;
        Form1.timer9.enabled:=true;
      end;
    end;
  end;

  if DoNewsUpdate7=1 then begin
  DoNewsUpdate7:=0;
    try
      //Application.ProcessMessages;
      Setireg1:=Form1.IDHTTP7.Get('http://setiathome.ssl.berkeley.edu/fcgi-bin/fcgi?email=' + config.setiEmail + '&cmd=user_stats_new');
    except
      if news7<4 then begin
        news7:=news7+1;
        DoNewsUpdate7:=1;
      end else begin
        setireg1:='No connection';
        setireg2:='No connection';
        setireg3:='No connection';
        setireg4:='No connection';
        setireg5:='No connection';
        setireg6:='No connection';
        setireg7:='No connection';
        setireg8:='No connection';
        setireg9:='No connection';
      end;
    end;

    setireg1:=StringReplace(setireg1,'&amp','&',[rfReplaceAll]);
    setireg1:=StringReplace(setireg1,chr(10),'',[rfReplaceAll]);
    setireg1:=StringReplace(setireg1,chr(13),'',[rfReplaceAll]);

    setireg1:=copy(setireg1,pos('Results Received',setireg1)+25,length(setireg1));
    setireg2:=copy(setireg1,pos('Results Received',setireg1)+25,length(setireg1));
    setireg1:=copy(setireg1,1,pos('</td></tr>',setireg1)-1);

    setireg2:=copy(setireg2,pos('Total CPU Time',setireg2)+17,length(setireg2));
    setireg3:=copy(setireg2,pos('Total CPU Time',setireg2)+21,length(setireg2));
    setireg2:=copy(setireg2,pos('<td>',setireg2)+4,pos('</td>',setireg2)-pos('<td>',setireg2)-4);

    setireg2:=stripspaces(setireg2);

    setireg3:=copy(setireg3,pos('Average CPU Time per work unit',setireg3)+39,length(setireg3));
    setireg4:=copy(setireg3,pos('Average CPU Time per work unit',setireg3)+39,length(setireg3));
    setireg3:=copy(setireg3,1,pos('</td>',setireg3)-1);

    setireg4:=copy(setireg4,pos('Last result returned:',setireg3)+32,length(setireg4));
    setireg5:=copy(setireg4,pos('Last result returned:',setireg3)+32,length(setireg4));
    setireg4:=copy(setireg4,1,pos('</TD>',setireg4)-1);

    setireg5:=copy(setireg5,pos('SETI@home user for:',setireg5)+28,length(setireg5));
    setireg6:=copy(setireg5,pos('SETI@home user for:',setireg5)+28,length(setireg5));
    setireg5:=copy(setireg5,1,pos('</TD>',setireg5)-1);

    setireg6:=copy(setireg6,pos('Your rank out of',setireg6)+20,length(setireg6));
    setireg7:=copy(setireg6,pos('Your rank out of',setireg6)+20,length(setireg6));
    setireg6:=copy(setireg6,1,pos('</b>',setireg6)-1);

    setireg7:=copy(setireg7,pos('total users is:',setireg7)+21,length(setireg7));
    setireg8:=copy(setireg7,pos('total users is:',setireg7)+21,length(setireg7));
    setireg7:=copy(setireg7,1,pos('<sup>',setireg7)-1);

    setireg8:=copy(setireg8,pos('have this rank:',setireg8)+27,length(setireg8));
    setireg9:=copy(setireg8,pos('have this rank:',setireg8)+27,length(setireg8));
    setireg8:=copy(setireg8,1,pos('</b>',setireg8)-1);

    setireg9:=copy(setireg9,pos('work units than',setireg9)+27,length(setireg9));
    setireg9:=copy(setireg9,1,pos('%',setireg9)-1);
  end;

  if DoNewsUpdate9=1 then begin
    DoNewsUpdate9:=0;
    try
      //Application.ProcessMessages;
      foldreg7:=Form1.IDHTTP9.Get('http://folding.stanford.edu/cgi-bin/userpage.detailed?name='+config.foldUsername);
    except
      if news9<4 then begin
        news9:=news9+1;
        DoNewsUpdate9:=1;
      end else begin
        foldreg1:='Connection Time-Out';
        foldreg2:='Connection Time-Out';
        foldreg3:='Connection Time-Out';
        foldreg4:='Connection Time-Out';
        foldreg5:='Connection Time-Out';
        foldreg6:='Connection Time-Out';
        foldreg7:='Connection Time-Out';
      end;
    end;

    foldreg7:=StringReplace(foldreg7,'&amp','&',[rfReplaceAll]);
    foldreg7:=StringReplace(foldreg7,chr(10),'',[rfReplaceAll]);
    foldreg7:=StringReplace(foldreg7,chr(13),'',[rfReplaceAll]);

    foldreg1:=copy(foldreg7,pos('Member Since</B></TD><TD align=left><font size=4>', foldreg7), 100);
    foldreg1:=copy(foldreg1,pos('size=4>',foldreg1)+7,pos(' </font>', foldreg1)-pos('size=4>',foldreg1)-7);

    foldreg2:=copy(foldreg7,pos('Date of last work unit</b></TD><TD align=left><font size=4>', foldreg7), 100);
    foldreg2:=copy(foldreg2,pos('size=4>',foldreg2)+7,pos(' </font>', foldreg2)-pos('size=4>',foldreg2)-7);

    foldreg3:=copy(foldreg7,pos('Active processors (within a week)</b></TD><TD align=left><font size=4>', foldreg7), 100);
    foldreg3:=stripspaces(copy(foldreg3,pos('size=4>',foldreg3)+7,pos('</font>', foldreg3)-pos('size=4>',foldreg3)-7));

    foldreg4:=copy(foldreg7,pos('Team</TD><TD><b><a href=teampage?q=', foldreg7)+2, 100);
    foldreg4:=copy(foldreg4,pos('teampage?q=',foldreg4)+11,100);
    foldreg4:=copy(foldreg4,pos('>',foldreg4)+1, pos(' (id #', foldreg4)-pos('>',foldreg4)-1);

    foldreg5:=copy(foldreg7,pos('Score</TD><TD><font size=3><b>', foldreg7), 100);
    foldreg5:=copy(foldreg5,pos('<b>',foldreg5)+3,pos('</b>', foldreg5)-pos('<b>',foldreg5)-3);

    foldreg6:=copy(foldreg7,pos('User Rank</TD><TD><font size=3><b>', foldreg7), 100);
    foldreg6:=copy(foldreg6,pos('<b>',foldreg6)+3,pos('</b>', foldreg6)-pos('<b>',foldreg6)-3);

    foldreg7:=copy(foldreg7,pos('WU</TD><TD><font size=3><b>', foldreg7), 100);
    foldreg7:=copy(foldreg7,pos('<b>',foldreg7)+3,pos('</b>', foldreg7)-pos('<b>',foldreg7)-3);
  end;

  if DoNewsUpdate8=1 then begin
  DoNewsUpdate8:=0;
    try
      weather2:=Form1.IDHTTP8.Get('http://www.weather.com/weather/print/'+locationnumber);
      //Application.ProcessMessages;

      weather2:=StringReplace(weather2,chr(10),'',[rfReplaceAll]);
      weather2:=StringReplace(weather2,chr(13),'',[rfReplaceAll]);
      weather2:=StringReplace(weather2,chr(9),' ',[rfReplaceAll]);
      weather2:=StringReplace(weather2,'&amp','&',[rfReplaceAll]);
      weather2:=StringReplace(weather2,'&deg;','�',[rfReplaceAll]);
      weather2:=StringReplace(weather2,'&nbsp;',' ',[rfReplaceAll]);
      weather2:=StringReplace(weather2,' %<','%<',[rfReplaceAll]);

      weather2:=copy(weather2,pos('<!-- if printable page, use code below -->',weather2),length(weather2));
      //application.ProcessMessages;
      weather2:=copy(weather2,pos('<!-- insert forecast -->',weather2)+24,length(weather2));
      templine[1]:=copy(weather2,1,pos('</TD>',weather2)-1);
      weather2:=copy(weather2,pos('<!-- insert high -->',weather2)+20,length(weather2));
      templine[2]:=copy(weather2,1,pos('<!-- ',weather2)-1);
      weather2:=copy(weather2,pos('<!-- insert low -->',weather2)+19,length(weather2));
      templine[3]:=copy(weather2,1,pos('</B>',weather2)-1);
      weather2:=copy(weather2,pos('<!-- insert precip. chance -->',weather2)+30,length(weather2));
      templine[4]:=copy(weather2,1,pos('</DIV>',weather2)-1);
      weather2:=stripspaces(templine[1]+' '+templine[2]+templine[3]+' '+templine[4]);
    except
      if news8<4 then begin
        news8:=news8+1;
        DoNewsUpdate8:=1;
      end else begin
        weather2:='Connection Time-Out';
      end;
    end;
  end;
  HTTPthreadisrunning:=false;
end;

procedure Tpop3Thread.execute();
var
  mailz: array[1..10] of integer;
  z, y: Integer;
  screenline: String;

begin
  pop3threadisrunning:=true;
  mailz[1]:=0;
  mailz[2]:=0;
  mailz[3]:=0;
  mailz[4]:=0;
  mailz[5]:=0;
  mailz[6]:=0;
  mailz[7]:=0;
  mailz[8]:=0;
  mailz[9]:=0;
  mailz[10]:=0;

  for z:= 1 to 20 do begin
    for y:= 1 to 4 do begin
      if (config.screen[z][y].enabled) then begin
        screenline:=config.screen[z][y].text;
        if (pos('$Email1',screenline) <> 0) then mailz[1]:=1;
        if (pos('$Email2',screenline) <> 0) then mailz[2]:=1;
        if (pos('$Email3',screenline) <> 0) then mailz[3]:=1;
        if (pos('$Email4',screenline) <> 0) then mailz[4]:=1;
        if (pos('$Email5',screenline) <> 0) then mailz[5]:=1;
        if (pos('$Email6',screenline) <> 0) then mailz[6]:=1;
        if (pos('$Email7',screenline) <> 0) then mailz[7]:=1;
        if (pos('$Email8',screenline) <> 0) then mailz[8]:=1;
        if (pos('$Email9',screenline) <> 0) then mailz[9]:=1;
        if (pos('$Email0',screenline) <> 0) then mailz[10]:=1;
      end;
    end;
  end;

  if mailz[1]=1 then begin
    try
      form1.idpop31.host:=config.pop[1].server;
      form1.idpop31.UserName:=config.pop[1].user;
      form1.idpop31.Password:=config.pop[1].pword;
      form1.idpop31.Connect;
      mailregel1:=intToStr(form1.idpop31.CheckMessages);
      form1.idpop31.Disconnect;
      form1.IdPOP31.DisconnectSocket;
    except
      form1.IdPOP31.DisconnectSocket;
      mailregel1:='';
    end;
  end;

if mailz[2]=1 then begin
  try
    form1.idpop32.host:=config.pop[2].server;
    form1.idpop32.UserName:=config.pop[2].user;
    form1.idpop32.Password:=config.pop[2].pword;
    form1.idpop32.Connect;
    mailregel2:=intToStr(form1.idpop32.CheckMessages);
    form1.idpop32.Disconnect;
    form1.IdPOP32.DisconnectSocket;
  except
    form1.IdPOP32.DisconnectSocket;
    mailregel2:='';
  end;
end;

if mailz[3]=1 then begin
  try
    form1.idpop33.host:= config.pop[3].server;
    form1.idpop33.UserName:=config.pop[3].user;
    form1.idpop33.Password:=config.pop[3].pword;
    form1.idpop33.Connect;
     mailregel3:=intToStr(form1.idpop33.CheckMessages);
    form1.idpop33.Disconnect;
    form1.IdPOP33.DisconnectSocket;
  except
    form1.IdPOP33.DisconnectSocket;
    mailregel3:='';
  end;
end;

if mailz[4]=1 then begin
  try
    form1.idpop34.host:= config.pop[4].server;
    form1.idpop34.UserName:=config.pop[4].user;
    form1.idpop34.Password:=config.pop[4].pword;
    form1.idpop34.Connect;
     mailregel4:=intToStr(form1.idpop34.CheckMessages);
    form1.idpop34.Disconnect;
    form1.IdPOP34.DisconnectSocket;
  except
    form1.IdPOP34.DisconnectSocket;
    mailregel4:='';
  end;
end;

if mailz[5]=1 then begin
  try
    form1.idpop35.host:=config.pop[5].server;
    form1.idpop35.UserName:=config.pop[5].user;
    form1.idpop35.Password:=config.pop[5].pword;
    form1.idpop35.Connect;
     mailregel5:=intToStr(form1.idpop35.CheckMessages);
    form1.idpop35.Disconnect;
    form1.IdPOP35.DisconnectSocket;
  except
    form1.IdPOP35.DisconnectSocket;
    mailregel5:='';
  end;
end;

if mailz[6]=1 then begin
  try
    form1.idpop36.host:=config.pop[6].server;
    form1.idpop36.UserName:=config.pop[6].user;
    form1.idpop36.Password:=config.pop[6].pword;
    form1.idpop36.Connect;
     mailregel6:=intToStr(form1.idpop36.CheckMessages);
    form1.idpop36.Disconnect;
    form1.IdPOP36.DisconnectSocket;
  except
    form1.IdPOP36.DisconnectSocket;
    mailregel6:='';
  end;
end;

if mailz[7]=1 then begin
  try
    form1.idpop37.host:=config.pop[7].server;
    form1.idpop37.UserName:=config.pop[7].user;
    form1.idpop37.Password:=config.pop[7].pword;
    form1.idpop37.Connect;
     mailregel7:=intToStr(form1.idpop37.CheckMessages);
    form1.idpop37.Disconnect;
    form1.IdPOP37.DisconnectSocket;
  except
    form1.IdPOP37.DisconnectSocket;
    mailregel7:='';
  end;
end;

if mailz[8]=1 then begin
  try
    form1.idpop38.host:=config.pop[8].server;
    form1.idpop38.UserName:=config.pop[8].user;
    form1.idpop38.Password:=config.pop[8].pword;
    form1.idpop38.Connect;
     mailregel8:=intToStr(form1.idpop38.CheckMessages);
    form1.idpop38.Disconnect;
    form1.IdPOP38.DisconnectSocket;
  except
    form1.IdPOP38.DisconnectSocket;
    mailregel8:='';
  end;
end;

if mailz[9]=1 then begin
  try
    form1.idpop39.host:=config.pop[9].server;
    form1.idpop39.UserName:=config.pop[9].user;
    form1.idpop39.Password:=config.pop[9].pword;
    form1.idpop39.Connect;
     mailregel9:=intToStr(form1.idpop39.CheckMessages);
    form1.idpop39.Disconnect;
    form1.IdPOP39.DisconnectSocket;
  except
    form1.IdPOP39.DisconnectSocket;
    mailregel9:='';
  end;
end;

if mailz[10]=1 then begin
  try
    form1.idpop310.host:=config.pop[10].server;
    form1.idpop310.UserName:=config.pop[10].user;
    form1.idpop310.Password:=config.pop[10].pword;
    form1.idpop310.Connect;
    mailregel0:=intToStr(form1.idpop310.CheckMessages);
    form1.idpop310.Disconnect;
    form1.IdPOP310.DisconnectSocket;
  except
    form1.IdPOP310.DisconnectSocket;
    mailregel0:='';
  end;
end;

pop3threadisrunning:=false;
end;

procedure tform1.dogpo(const ftemp1,ftemp2:integer);
begin
  if ftemp1 < 9 then begin
    if ftemp2=0 then begin
      Lcd.setGPO(ftemp1, false);
      gpo[ftemp1]:=false;
    end;
    if ftemp2=1 then begin
      Lcd.setGPO(ftemp1, true);
      gpo[ftemp1]:=true;
    end;
    if ftemp2=2 then begin
      if (gpo[ftemp1]) then begin
        Lcd.setGPO(ftemp1, false);
        gpo[ftemp1]:=false;
      end else begin
        Lcd.setGPO(ftemp1, true);
        gpo[ftemp1]:=true;
      end;
    end;
  end;
end;

procedure TForm1.Timer13Timer(Sender: TObject);
begin
  timer13.Interval:=config.scrollPeriod;
  dllcancheck:=true;
end;

procedure TForm1.WMQueryEndSession (var M: TWMQueryEndSession);
begin
  inherited;
  form1.Close;
end;
procedure TForm1.TimertransTimer(Sender: TObject);
begin
  timertrans.Enabled:=false;
end;

procedure TForm1.Timer12Timer(Sender: TObject);
begin
  timer12.Interval:=config.scrollPeriod;
  canscroll:=true;
end;

end.
