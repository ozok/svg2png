{ *
  * Copyright (C) 2014 ozok <ozok26@gmail.com>
  *
  * This file is part of SVG2PNG.
  *
  * SVG2PNG is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 2 of the License, or
  * (at your option) any later version.
  *
  * SVG2PNG is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with SVG2PNG.  If not, see <http://www.gnu.org/licenses/>.
  *
  * }
unit UnitEncoder;

interface

uses Classes, Windows, SysUtils, JvCreateProcess, Messages, StrUtils, Psapi, tlhelp32, Generics.Collections;

type
  TEncoderStatus = (esEncoding, esStopped, esDone);

type
  TEncoder = class(TObject)
  private
    FProcess: TJvCreateProcess;
    FCommandLines: TStringList;
    FPaths: TStringList;
    FCommandIndex: integer;
    FConsoleOutput: string;
    FEncoderStatus: TEncoderStatus;
    FStoppedByUser: Boolean;

    procedure ProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
    procedure ProcessTerminate(Sender: TObject; ExitCode: Cardinal);

    function GetProcessID: integer;
    function GetCommandCount: integer;
    function GetExeName: string;
  public
    property ConsoleOutput: string read FConsoleOutput;
    property EncoderStatus: TEncoderStatus read FEncoderStatus;
    property CommandLines: TStringList read FCommandLines write FCommandLines;
    property Paths: TStringList read FPaths write FPaths;
    property FilesDone: integer read FCommandIndex;
    property ProcessID: integer read GetProcessID;
    property CommandCount: integer read GetCommandCount;
    property ExeName: string read GetExeName;

    constructor Create();
    destructor Destroy(); override;

    procedure Start();
    procedure Stop();
    procedure ResetValues();
    function GetConsoleOutput(): TStrings;
    procedure TerminateProcessTree(const ProcessID: Cardinal);
  end;

implementation

uses UnitMain;

{ TEncoder }

constructor TEncoder.Create;
begin
  inherited Create;

  // this the process that's run
  FProcess := TJvCreateProcess.Create(nil);
  with FProcess do
  begin
    OnRead := ProcessRead;
    OnTerminate := ProcessTerminate;
    ConsoleOptions := [coRedirect];
    CreationFlags := [cfUnicode];
    Priority := ppIdle;

    with StartupInfo do
    begin
      DefaultPosition := False;
      DefaultSize := False;
      DefaultWindowState := False;
      ShowWindow := swHide;
    end;

    WaitForTerminate := true;
  end;

  // create and assign default values
  FCommandLines := TStringList.Create;
  FPaths := TStringList.Create;
  FEncoderStatus := esStopped;
  FStoppedByUser := False;
  FCommandIndex := 0;
end;

destructor TEncoder.Destroy;
begin

  inherited Destroy;
  FreeAndNil(FCommandLines);
  FreeAndNil(FPaths);
  FProcess.Free;

end;

function TEncoder.GetCommandCount: integer;
begin
  Result := FCommandLines.Count;
end;

function TEncoder.GetConsoleOutput: TStrings;
begin
  Result := FProcess.ConsoleOutput;
end;

function TEncoder.GetExeName: string;
begin
  if FCommandIndex < Paths.Count then
    Result := Paths[FCommandIndex];
end;

function TEncoder.GetProcessID: integer;
begin
  Result := FProcess.ProcessInfo.hProcess;
end;

procedure TEncoder.ProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
begin
  // just return backend's output
  FConsoleOutput := Trim(S);
end;

procedure TEncoder.ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
var
  i: integer;
begin
  // status stopped
  FEncoderStatus := esStopped;
  // if not stopped by user,
  // run next command.
  if not FStoppedByUser then
  begin
    inc(FCommandIndex);
    if FCommandIndex < FCommandLines.Count then
    begin
      FProcess.CommandLine := FCommandLines[FCommandIndex];
      FProcess.ApplicationName := FPaths[FCommandIndex];
      FEncoderStatus := esEncoding;
      FConsoleOutput := '';
      FProcess.Run;
    end
    else
    begin
      FEncoderStatus := esDone;
    end;
  end;
end;

procedure TEncoder.ResetValues;
begin
  // reset all values so they can be used later
  FCommandLines.Clear;
  FPaths.Clear;
  FCommandIndex := 0;
  FConsoleOutput := '';
  FProcess.ConsoleOutput.Clear;
  FStoppedByUser := False;
end;

procedure TEncoder.Start;
begin
  if FProcess.ProcessInfo.hProcess = 0 then
  begin
    if FCommandLines.Count > 0 then
    begin
      if FileExists(FPaths[0]) then
      begin
        FProcess.ApplicationName := FPaths[0];
        FProcess.CommandLine := FCommandLines[0];
        FEncoderStatus := esEncoding;
        FProcess.Run;
      end
      else
        FConsoleOutput := 'encoder'
    end
    else
      FConsoleOutput := '0 cmd'
  end
  else
    FConsoleOutput := 'not 0'
end;

procedure TEncoder.Stop;
var
  FProcessIDTmp: DWORD;
begin
  if FProcess.ProcessInfo.hProcess > 0 then
  begin
    FProcessIDTmp := FProcess.ProcessInfo.dwProcessId;
    TerminateProcessTree(FProcessIDTmp);
    TerminateProcess(FProcess.ProcessInfo.hProcess, 0);

    FEncoderStatus := esStopped;
    FStoppedByUser := true;
  end;
end;

procedure TEncoder.TerminateProcessTree(const ProcessID: Cardinal);
var
  HandleSnapShot: THandle;
  EntryParentProc: TProcessEntry32;
  ParentProcessId: DWORD;
  ProcessHandles: TStringList;
  I: Integer;
  ProcessHndl: THandle;
begin
  HandleSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

  ProcessHandles := TStringList.Create;
  try
    // enumerate the process
    if HandleSnapShot <> INVALID_HANDLE_VALUE then
    begin
      EntryParentProc.dwSize := SizeOf(EntryParentProc);
      if Process32First(HandleSnapShot, EntryParentProc) then
      // find the first process
      begin
        repeat
          ParentProcessId := EntryParentProc.th32ParentProcessID;

          if ParentProcessId = ProcessID then
          begin
            ProcessHandles.Add(FloatToStr(EntryParentProc.th32ProcessID));
          end;

        until not Process32Next(HandleSnapShot, EntryParentProc);
      end;
      for I := 0 to ProcessHandles.Count - 1 do
      begin
        ProcessHndl := OpenProcess(PROCESS_ALL_ACCESS, true, StrToInt(ProcessHandles[i]));
        if TerminateProcess(ProcessHndl, 0) then
        begin
          FStoppedByUser := true;
        end;
        CloseHandle(ProcessHndl);
      end;
      CloseHandle(HandleSnapShot);
    end;
  finally

    FreeAndNil(ProcessHandles);
  end;

end;

end.
