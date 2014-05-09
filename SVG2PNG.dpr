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
  *}
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
