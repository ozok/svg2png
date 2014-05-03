program SVG2PNG;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Vcl.Forms,
  UnitMain in 'UnitMain.pas' {MainForm} ,
  UnitEncoder in 'UnitEncoder.pas',
  UnitAbout in 'UnitAbout.pas' {AboutForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'SVG2PNG';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;

end.
