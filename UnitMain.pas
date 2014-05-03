{ *
  * Copyright (C) 2012-2013 ozok <ozok26@gmail.com>
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
unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvExStdCtrls, JvListBox,
  Vcl.Mask, JvExMask, JvToolEdit, JvSpin, UnitEncoder, Vcl.ComCtrls,
  Vcl.ExtCtrls, IniFiles, JvComponentBase, JvComputerInfoEx, ShellAPI, Vcl.Menus,
  JvBaseDlg, JvBrowseFolder, JvSearchFiles, JvDragDrop, JvUrlListGrabber,
  JvUrlGrabbers, JvThread;

type
  TMainForm = class(TForm)
    AddBtn: TButton;
    OpenDialog: TOpenDialog;
    FileList: TJvListBox;
    OutputDirectory: TJvDirectoryEdit;
    Label1: TLabel;
    StartBtn: TButton;
    WidthEdit: TJvSpinEdit;
    HeightEdit: TJvSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    ProgressBar: TProgressBar;
    PosTimer: TTimer;
    Label4: TLabel;
    DensityEdit: TJvSpinEdit;
    ExtraEdit: TEdit;
    Label5: TLabel;
    SysInfo: TJvComputerInfoEx;
    StopBtn: TButton;
    OpenBtn: TButton;
    FileNameBtn: TCheckBox;
    AddMenu: TPopupMenu;
    A1: TMenuItem;
    A2: TMenuItem;
    A3: TMenuItem;
    RemoveBtn: TButton;
    ClearBtn: TButton;
    OpenFolderDialog: TJvBrowseForFolderDialog;
    SearchFiles: TJvSearchFiles;
    StructBtn: TCheckBox;
    WaitPanel: TPanel;
    DragDrop: TJvDragDrop;
    HelpBtn: TButton;
    HelpMenu: TPopupMenu;
    I1: TMenuItem;
    A4: TMenuItem;
    Label6: TLabel;
    ProcessEdit: TJvSpinEdit;
    UpdateThread: TJvThread;
    UpdateDownloader: TJvHttpUrlGrabber;
    procedure AddBtnClick(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PosTimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StopBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure A1Click(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure A2Click(Sender: TObject);
    procedure SearchFilesProgress(Sender: TObject);
    procedure SearchFilesFindFile(Sender: TObject; const AName: string);
    procedure A3Click(Sender: TObject);
    procedure DragDropDrop(Sender: TObject; Pos: TPoint; Value: TStrings);
    procedure I1Click(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure A4Click(Sender: TObject);
    procedure UpdateThreadExecute(Sender: TObject; Params: Pointer);
    procedure UpdateDownloaderDoneStream(Sender: TObject; Stream: TStream; StreamSize: Integer; Url: string);
  private
    { Private declarations }
    FAppData: string;
    FLastDir: string;
    FTotalCmd: integer;
    FImageMPath: string;
    FConverters: array [0 .. 63] of TEncoder;

    procedure LoadSettings;
    procedure SaveSettings;

    procedure NormalState;
    procedure ProgressState;
  public
    { Public declarations }
  end;

const
  BuildInt = 73;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses UnitAbout;

procedure TMainForm.A1Click(Sender: TObject);
begin
  if DirectoryExists(FLastDir) then
  begin
    OpenDialog.InitialDir := FLastDir;
  end;

  if OpenDialog.Execute then
  begin
    Self.Enabled := False;
    WaitPanel.Visible := True;
    WaitPanel.BringToFront;
    FileList.Items.BeginUpdate;
    try
      FileList.Items.AddStrings(OpenDialog.Files);
      FLastDir := ExtractFileDir(OpenDialog.Files[OpenDialog.Files.Count - 1]);
      SaveSettings;
    finally
      Self.Enabled := True;
      WaitPanel.Visible := False;
      FileList.Items.EndUpdate;
    end;
  end;
end;

procedure TMainForm.A2Click(Sender: TObject);
var
  Search: TSearchRec;
  FileName: String;
  Extension: String;
begin
  if DirectoryExists(FLastDir) then
  begin
    OpenFolderDialog.Directory := FLastDir;
  end;
  if OpenFolderDialog.Execute then
  begin
    FileList.Items.BeginUpdate;
    Self.Enabled := False;
    WaitPanel.Visible := True;
    WaitPanel.BringToFront;
    try
      if (FindFirst(OpenFolderDialog.Directory + '\*.*', faAnyFile, Search) = 0) then
      Begin
        repeat
          Application.ProcessMessages;

          if (Search.Name <> '.') and (Search.Name <> '..') then
          begin
            FileName := ExcludeTrailingPathDelimiter(OpenFolderDialog.Directory) + '\' + Search.Name;

            Extension := LowerCase(ExtractFileExt(FileName));
            if (Extension = '.svg') then
            begin
              FileList.Items.Add(FileName);
            end;
          end;

        until (FindNext(Search) <> 0);
        FindClose(Search);
      end;
    finally
      FLastDir := OpenFolderDialog.Directory;
      FileList.Items.EndUpdate;
      Self.Enabled := True;
      WaitPanel.Visible := False;
      Self.BringToFront;
    end;
  end;
end;

procedure TMainForm.A3Click(Sender: TObject);
begin
  if DirectoryExists(FLastDir) then
  begin
    OpenFolderDialog.Directory := FLastDir;
  end;
  if OpenFolderDialog.Execute then
  begin
    SearchFiles.RootDirectory := OpenFolderDialog.Directory;
    Self.Enabled := False;
    WaitPanel.Visible := True;
    WaitPanel.BringToFront;
    FileList.Items.BeginUpdate;
    try
      SearchFiles.Search;
    finally
      FLastDir := OpenFolderDialog.Directory;
      Self.Enabled := True;
      WaitPanel.Visible := False;
      FileList.Items.EndUpdate;
    end;
  end;
end;

procedure TMainForm.A4Click(Sender: TObject);
begin
  AboutForm.Show;
end;

procedure TMainForm.AddBtnClick(Sender: TObject);
var
  P: TPoint;
begin
  P := AddBtn.ClientToScreen(Point(0, 0));

  AddMenu.Popup(P.X, P.Y + AddBtn.Height)
end;

procedure TMainForm.ClearBtnClick(Sender: TObject);
begin
  if FileList.Items.Count = 0 then Exit;

  if ID_YES = Application.MessageBox('Remove all from file list?', 'Remove All', MB_ICONQUESTION or MB_YESNO) then
  begin
    FileList.Items.Clear;
  end;
end;

procedure TMainForm.DragDropDrop(Sender: TObject; Pos: TPoint; Value: TStrings);
var
  i: Integer;
  Extension: string;
  DirectoriesToSearch: TStringList;
begin
  Self.Enabled := False;
  FileList.Items.BeginUpdate;
  WaitPanel.Visible := True;
  WaitPanel.BringToFront;
  DirectoriesToSearch := TStringList.Create;
  try
    for i := 0 to Value.Count - 1 do
    begin
      Application.ProcessMessages;
      Extension := LowerCase(ExtractFileExt(Value[i]));
      // decide if file or directory
      if DirectoryExists(Value[i]) then
      begin
        DirectoriesToSearch.Add(Value[i]);
      end
      else
      begin
        if (Extension = '.svg') then
        begin
          FileList.Items.Add(Value[i])
        end
      end;
    end;
    FileList.Items.BeginUpdate;
    try
      // add directory content
      if DirectoriesToSearch.Count > 0 then
      begin
        for I := 0 to DirectoriesToSearch.Count - 1 do
        begin
          Application.ProcessMessages;
          SearchFiles.RootDirectory := DirectoriesToSearch[i];
          SearchFiles.Search;
          FLastDir := DirectoriesToSearch[i];
        end;
      end;
    finally
      FileList.Items.EndUpdate;
    end;
  finally
    Self.Enabled := True;
    FileList.Items.EndUpdate;
    WaitPanel.Visible := False;
    Self.BringToFront;
    FreeAndNil(DirectoriesToSearch);
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  for I := Low(FConverters) to High(FConverters) do
    FConverters[i] := TEncoder.Create;
  WidthEdit.MaxValue := MaxInt;
  HeightEdit.MaxValue := MaxInt;
  SearchFiles.RecurseDepth := MaxInt;
  ProcessEdit.MaxValue := CPUCount;
  ProcessEdit.MinValue := 1;

  FImageMPath := ExtractFileDir(Application.ExeName) + '\convert.exe';
  FAppData := SysInfo.Folders.AppData + '\SVG2PNG';
  if not DirectoryExists(FAppData) then
  begin
    CreateDir(FAppData);
  end;
  if not FileExists(FImageMPath) then
  begin
    Application.MessageBox('Cannot find convert.exe!', 'Fatal Error', MB_ICONERROR);
    Application.Terminate;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  for I := Low(FConverters) to High(FConverters) do
    FConverters[i].Free;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  LoadSettings;
  UpdateThread.Execute(nil);
end;

procedure TMainForm.HelpBtnClick(Sender: TObject);
var
  P: TPoint;
begin
  P := HelpBtn.ClientToScreen(Point(0, 0));

  HelpMenu.Popup(P.X, P.Y + HelpBtn.Height)
end;

procedure TMainForm.I1Click(Sender: TObject);
begin
  // http://www.imagemagick.org/script/convert.php
  shellexecute(Handle, 'open', 'http://www.imagemagick.org/script/convert.php', nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.LoadSettings;
var
  LSettings: TIniFile;
begin
  LSettings := TIniFile.Create(FAppData + '\set.ini');
  try
    with LSettings do
    begin
      OutputDirectory.Text := ReadString('settings', 'output', SysInfo.Folders.Personal + '\SVG2PNG');
      WidthEdit.Text := ReadString('settings', 'width', '48');
      HeightEdit.Text := ReadString('settings', 'height', '48');
      DensityEdit.Text := ReadString('settings', 'density', '72');
      ExtraEdit.Text := ReadString('settings', 'extra', '');
      FLastDir := ReadString('settings', 'lastdir', '');
      FileNameBtn.Checked := ReadBool('settings', 'fn', False);
      StructBtn.Checked := ReadBool('settings', 'strcut', True);
      ProcessEdit.Value := ReadInteger('settings', 'process', CPUCount);
    end;
  finally
    LSettings.Free;
  end;
end;

procedure TMainForm.NormalState;
begin
  PosTimer.Enabled := False;
  StartBtn.Enabled := True;
  StopBtn.Enabled := False;
  FileList.Enabled := True;
  AddBtn.Enabled := True;
  OutputDirectory.Enabled := True;
  WidthEdit.Enabled := True;
  HeightEdit.Enabled := True;
  ExtraEdit.Enabled := True;
  DensityEdit.Enabled := True;
  FileNameBtn.Enabled := True;
  StructBtn.Enabled := True;
  RemoveBtn.Enabled := True;
  ClearBtn.Enabled := True;
  ProcessEdit.Enabled := True;
  HelpBtn.Enabled := True;

  Self.Caption := 'SVG2PNG';
  ProgressBar.Position := 0;
end;

procedure TMainForm.OpenBtnClick(Sender: TObject);
begin
  if DirectoryExists(OutputDirectory.Text) then
  begin
    shellexecute(Handle, 'open', 'explorer', PWideChar(OutputDirectory.Text), nil, SW_SHOWNORMAL);
  end;
end;

procedure TMainForm.PosTimerTimer(Sender: TObject);
var
  LDoneCount: Integer;
  I: Integer;
begin
  for I := Low(FConverters) to High(FConverters) do
  begin
    if FConverters[i].CommandCount > 0 then
    begin
      Inc(LDoneCount, FConverters[i].FilesDone);
    end;
  end;

  if LDoneCount = FTotalCmd then
  begin
    PosTimer.Enabled := False;
    NormalState;
    // for I := Low(FConverters) to High(FConverters) do
    // begin
    // FConverters[i].CommandLines.SaveToFile(ExtractFileDir(Application.ExeName) + '\' + FloatToStr(i) + 'cmd.txt', TEncoding.UTF8);
    // FConverters[i].GetConsoleOutput.SaveToFile(ExtractFileDir(Application.ExeName) + '\' + FloatToStr(i) + 'console.txt', TEncoding.UTF8);
    // end;
  end
  else
  begin
    ProgressBar.Position := (100 * LDoneCount) div FTotalCmd;
    Self.Caption := FloatToStr(LDoneCount) + '/' + FloatToStr(FTotalCmd) + ' SVG2PNG';
  end;
end;

procedure TMainForm.ProgressState;
begin
  StartBtn.Enabled := False;
  StopBtn.Enabled := True;
  FileList.Enabled := False;
  AddBtn.Enabled := False;
  OutputDirectory.Enabled := False;
  WidthEdit.Enabled := False;
  HeightEdit.Enabled := False;
  ExtraEdit.Enabled := False;
  DensityEdit.Enabled := False;
  FileNameBtn.Enabled := False;
  StructBtn.Enabled := False;
  RemoveBtn.Enabled := False;
  ClearBtn.Enabled := False;
  ProcessEdit.Enabled := False;
  HelpBtn.Enabled := False;
end;

procedure TMainForm.RemoveBtnClick(Sender: TObject);
begin
  FileList.DeleteSelected;
end;

procedure TMainForm.SaveSettings;
var
  LSettings: TIniFile;
begin
  LSettings := TIniFile.Create(FAppData + '\set.ini');
  try
    with LSettings do
    begin
      WriteString('settings', 'output', OutputDirectory.Text);
      WriteString('settings', 'width', WidthEdit.Text);
      WriteString('settings', 'height', HeightEdit.Text);
      WriteString('settings', 'density', DensityEdit.Text);
      WriteString('settings', 'extra', ExtraEdit.Text);
      WriteString('settings', 'lastdir', FLastDir);
      WriteBool('settings', 'fn', FileNameBtn.Checked);
      WriteBool('settings', 'strcut', StructBtn.Checked);
      WriteInteger('settings', 'process', Round(ProcessEdit.Value));
    end;
  finally
    LSettings.Free;
  end;
end;

procedure TMainForm.SearchFilesFindFile(Sender: TObject; const AName: string);
begin
  FileList.Items.Add(AName);
end;

procedure TMainForm.SearchFilesProgress(Sender: TObject);
begin
  Application.ProcessMessages;
end;

procedure TMainForm.StartBtnClick(Sender: TObject);
var
  I: Integer;
  LProcessCount: Integer;
  LCurrProcess: Integer;
  LOutputFile: string;
  LFolderToCreate: string;
begin
  if FileList.Items.Count > 0 then
  begin
    if not DirectoryExists(OutputDirectory.Text) then
    begin
      if not CreateDir(OutputDirectory.Text) then
      begin
        Application.MessageBox('Cannot create output folder.', 'Error', MB_ICONERROR);
        exit;
      end;
    end;

    if Round(ProcessEdit.Value) > Length(FConverters) then
    begin
      LProcessCount := Length(FConverters);
    end
    else
    begin
      LProcessCount := Round(ProcessEdit.Value);
    end;

    FTotalCmd := 0;
    for I := Low(FConverters) to High(FConverters) do
      FConverters[i].ResetValues;

    WaitPanel.Visible := True;
    WaitPanel.BringToFront;
    try
      for I := 0 to FileList.Items.Count - 1 do
      begin
        Application.ProcessMessages;

        if not FileNameBtn.Checked then
        begin
          LOutputFile := ChangeFileExt(FileList.Items[i], '.png');
        end
        else
        begin
          LOutputFile := ChangeFileExt(FileList.Items[i], '_' + WidthEdit.Text + 'x' + HeightEdit.Text + '.png');
        end;

        if StructBtn.Checked then
        begin
          LFolderToCreate := ExtractFilePath(FileList.Items[i]);
          LFolderToCreate := Copy(LFolderToCreate, 3, MaxInt);
          LFolderToCreate := IncludeTrailingPathDelimiter(OutputDirectory.Text) + LFolderToCreate;
          if not DirectoryExists(LFolderToCreate) then
          begin
            ForceDirectories(LFolderToCreate);
          end;
          LOutputFile := IncludeTrailingPathDelimiter(LFolderToCreate) + ExtractFileName(LOutputFile);
        end
        else
        begin
          LOutputFile := IncludeTrailingPathDelimiter(OutputDirectory.Text) + ExtractFileName(LOutputFile);
        end;

        LCurrProcess := i mod LProcessCount;
        with FConverters[LCurrProcess] do
        begin
          CommandLines.Add(' ' + ExtraEdit.Text + ' -density ' + DensityEdit.Text + ' -resize ' + WidthEdit.Text + 'x' + HeightEdit.Text + ' -background none -antialias "' + FileList.Items[i] + '" "'
            + LOutputFile + '"');
          Paths.Add(FImageMPath);
        end;
      end;

      for I := Low(FConverters) to High(FConverters) do
      begin
        if FConverters[i].CommandCount > 0 then
        begin
          FTotalCmd := FTotalCmd + FConverters[i].CommandCount;
          FConverters[i].Start;
        end;
      end;
      if FTotalCmd > 0 then
      begin
        ProgressState;
        PosTimer.Enabled := True;
      end;
    finally
      WaitPanel.Visible := False;
    end;
  end;
end;

procedure TMainForm.StopBtnClick(Sender: TObject);
var
  I: Integer;
begin
  if ID_YES = Application.MessageBox('Stop converting?', 'Stop', MB_ICONQUESTION or MB_YESNO) then
  begin
    for I := Low(FConverters) to High(FConverters) do
      FConverters[i].Stop;
    NormalState;
  end;
end;

procedure TMainForm.UpdateDownloaderDoneStream(Sender: TObject; Stream: TStream; StreamSize: Integer; Url: string);
var
  VersionFile: TStringList;
  LatestVersion: Integer;
begin
  VersionFile := TStringList.Create;
  try
    if StreamSize > 0 then
    begin
      VersionFile.LoadFromStream(Stream);
      if VersionFile.Count = 1 then
      begin
        if TryStrToInt(VersionFile[0], LatestVersion) then
        begin
          if LatestVersion > BuildInt then
          begin
            if ID_YES = Application.MessageBox('There is a new version. Would you like to go homepage and download it?', 'New Version', MB_ICONQUESTION or MB_YESNO) then
            begin
              shellexecute(Application.Handle, 'open', 'https://sourceforge.net/projects/svg2png/', nil, nil, SW_SHOWNORMAL);
            end;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(VersionFile);
  end;
end;

procedure TMainForm.UpdateThreadExecute(Sender: TObject; Params: Pointer);
begin
  UpdateDownloader.Url := 'http://downloads.sourceforge.net/project/svg2png/version.txt?r=&ts=1399126159&use_mirror=master';
  UpdateDownloader.Start;

  UpdateThread.Terminate;
end;

end.
