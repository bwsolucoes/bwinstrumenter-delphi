{$B-,H+,J+,Q-,T-,X+}

program BWInstrumenter;

uses
  Forms,
  SysUtils,
  Windows,
  Vcl.HtmlHelpViewer,
  GpString,
  gppPreferencesDlg,
  gppMain,
  gpParser.TextReplacer in 'model\sourceCodeAnalysis\gpParser.TextReplacer.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmPreferences, frmPreferences);
  Application.Run;
end.
