object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'SVG2PNG'
  ClientHeight = 552
  ClientWidth = 640
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    640
    552)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 519
    Width = 69
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Output folder:'
    ExplicitTop = 374
  end
  object Label2: TLabel
    Left = 20
    Top = 464
    Width = 57
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Dimensions:'
    ExplicitTop = 319
  end
  object Label3: TLabel
    Left = 139
    Top = 464
    Width = 10
    Height = 13
    Alignment = taCenter
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'X'
  end
  object Label4: TLabel
    Left = 350
    Top = 464
    Width = 40
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Density:'
  end
  object Label5: TLabel
    Left = 47
    Top = 491
    Width = 30
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Extra:'
  end
  object Label6: TLabel
    Left = 211
    Top = 464
    Width = 71
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Process count:'
  end
  object WaitPanel: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 542
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Please wait...'
    TabOrder = 15
    Visible = False
  end
  object AddBtn: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Hint = 'Add files and folders'
    Caption = 'Add'
    TabOrder = 0
    OnClick = AddBtnClick
  end
  object FileList: TJvListBox
    Left = 8
    Top = 39
    Width = 624
    Height = 416
    Hint = 'You can drag and drop files and folders'
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    Background.FillMode = bfmTile
    Background.Visible = False
    MultiSelect = True
    TabOrder = 1
  end
  object OutputDirectory: TJvDirectoryEdit
    Left = 83
    Top = 515
    Width = 468
    Height = 21
    Hint = 'Select output folder. Will be created if doesn'#39't exist'
    DialogKind = dkWin32
    ButtonFlat = True
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 2
    Text = 'C:\temp'
  end
  object StartBtn: TButton
    Left = 557
    Top = 8
    Width = 75
    Height = 25
    Hint = 'Start converting'
    Anchors = [akTop, akRight]
    Caption = 'Start'
    TabOrder = 3
    OnClick = StartBtnClick
  end
  object WidthEdit: TJvSpinEdit
    Left = 83
    Top = 461
    Width = 50
    Height = 21
    Hint = 'Width '
    CheckOptions = [coCheckOnExit, coCropBeyondLimit]
    Alignment = taCenter
    ButtonKind = bkClassic
    MaxValue = 125.000000000000000000
    Value = 75.000000000000000000
    Anchors = [akLeft, akBottom]
    TabOrder = 4
  end
  object HeightEdit: TJvSpinEdit
    Left = 155
    Top = 461
    Width = 50
    Height = 21
    Hint = 'Height'
    CheckOptions = [coCheckOnExit, coCropBeyondLimit]
    Alignment = taCenter
    ButtonKind = bkClassic
    MaxValue = 125.000000000000000000
    Value = 75.000000000000000000
    Anchors = [akLeft, akBottom]
    TabOrder = 5
  end
  object ProgressBar: TProgressBar
    Left = 0
    Top = 542
    Width = 640
    Height = 10
    Align = alBottom
    TabOrder = 6
  end
  object DensityEdit: TJvSpinEdit
    Left = 398
    Top = 461
    Width = 50
    Height = 21
    Hint = 'Density'
    CheckOptions = [coCheckOnExit, coCropBeyondLimit]
    CheckMinValue = True
    Alignment = taCenter
    ButtonKind = bkClassic
    Value = 72.000000000000000000
    Anchors = [akRight, akBottom]
    TabOrder = 7
  end
  object ExtraEdit: TEdit
    Left = 83
    Top = 488
    Width = 365
    Height = 21
    Hint = 'Imagemagick extra command lines. See help menu.'
    Anchors = [akLeft, akRight, akBottom]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
  end
  object StopBtn: TButton
    Left = 476
    Top = 8
    Width = 75
    Height = 25
    Hint = 'Stop convertion'
    Anchors = [akTop, akRight]
    Caption = 'Stop'
    Enabled = False
    TabOrder = 9
    OnClick = StopBtnClick
  end
  object OpenBtn: TButton
    Left = 557
    Top = 515
    Width = 75
    Height = 21
    Hint = 'Open output folder'
    Anchors = [akRight, akBottom]
    Caption = 'Open'
    TabOrder = 10
    OnClick = OpenBtnClick
  end
  object FileNameBtn: TCheckBox
    Left = 454
    Top = 463
    Width = 178
    Height = 17
    Hint = 'Filename_wxh'
    Anchors = [akRight, akBottom]
    Caption = 'Add width and height to file name'
    TabOrder = 11
  end
  object RemoveBtn: TButton
    Left = 89
    Top = 8
    Width = 75
    Height = 25
    Hint = 'Remove Selected'
    Caption = 'Remove'
    TabOrder = 12
    OnClick = RemoveBtnClick
  end
  object ClearBtn: TButton
    Left = 170
    Top = 8
    Width = 75
    Height = 25
    Hint = 'Remove all'
    Caption = 'Remove All'
    TabOrder = 13
    OnClick = ClearBtnClick
  end
  object StructBtn: TCheckBox
    Left = 454
    Top = 490
    Width = 178
    Height = 17
    Hint = 'Copy source files'#39' folders to output'
    Anchors = [akRight, akBottom]
    Caption = 'Create folder structure at output'
    TabOrder = 14
  end
  object HelpBtn: TButton
    Left = 395
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Help'
    TabOrder = 16
    OnClick = HelpBtnClick
  end
  object ProcessEdit: TJvSpinEdit
    Left = 288
    Top = 461
    Width = 50
    Height = 21
    Hint = 
      'Number of parallel processes. High numbers may slow your system ' +
      'down.'
    CheckOptions = [coCheckOnExit, coCropBeyondLimit]
    Alignment = taCenter
    ButtonKind = bkClassic
    MaxValue = 64.000000000000000000
    Value = 4.000000000000000000
    Anchors = [akLeft, akBottom]
    TabOrder = 17
  end
  object OpenDialog: TOpenDialog
    Filter = 'SVG|*.svg'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 40
    Top = 64
  end
  object PosTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = PosTimerTimer
    Left = 40
    Top = 152
  end
  object SysInfo: TJvComputerInfoEx
    Left = 32
    Top = 232
  end
  object AddMenu: TPopupMenu
    Left = 32
    Top = 296
    object A1: TMenuItem
      Caption = 'Add files'
      OnClick = A1Click
    end
    object A2: TMenuItem
      Caption = 'Add folder'
      OnClick = A2Click
    end
    object A3: TMenuItem
      Caption = 'Add folder tree'
      OnClick = A3Click
    end
  end
  object OpenFolderDialog: TJvBrowseForFolderDialog
    Left = 128
    Top = 72
  end
  object SearchFiles: TJvSearchFiles
    DirParams.MinSize = 0
    DirParams.MaxSize = 0
    FileParams.SearchTypes = [stFileMask]
    FileParams.MinSize = 0
    FileParams.MaxSize = 0
    FileParams.FileMasks.Strings = (
      '*.svg')
    OnFindFile = SearchFilesFindFile
    OnProgress = SearchFilesProgress
    Left = 224
    Top = 72
  end
  object DragDrop: TJvDragDrop
    DropTarget = Owner
    OnDrop = DragDropDrop
    Left = 304
    Top = 72
  end
  object HelpMenu: TPopupMenu
    Left = 96
    Top = 296
    object I1: TMenuItem
      Caption = 'Imagemagick Help'
      OnClick = I1Click
    end
    object A4: TMenuItem
      Caption = 'About'
      OnClick = A4Click
    end
  end
  object UpdateThread: TJvThread
    Exclusive = True
    MaxCount = 0
    RunOnCreate = True
    FreeOnTerminate = True
    OnExecute = UpdateThreadExecute
    Left = 32
    Top = 360
  end
  object UpdateDownloader: TJvHttpUrlGrabber
    FileName = 'output.txt'
    OutputMode = omStream
    Agent = 'JEDI-VCL'
    Port = 0
    ProxyAddresses = 'proxyserver'
    ProxyIgnoreList = '<local>'
    OnDoneStream = UpdateDownloaderDoneStream
    Left = 120
    Top = 360
  end
end
