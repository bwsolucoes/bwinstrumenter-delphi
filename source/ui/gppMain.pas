{$B-,H+,J+,Q-,T-,X+}

unit gppmain;

interface

uses
  Registry, Messages, Classes, Forms, Windows, SysUtils, Graphics, Controls,
  Dialogs, StdCtrls, Menus, ComCtrls, GpParser, ExtCtrls, gpMRU,
  ActnList, ImgList, Buttons, ToolWin, Grids,
  SynEdit,
  SynEditHighlighter, SynEditCodeFolding, SynHighlighterPas, System.ImageList,
  System.Actions,gppCurrentPrefs, VirtualTrees,
  virtualTree.tools.checkable,
  gppmain.FrameInstrumentation,
  gppmain.types, System.Win.TaskbarCore, Vcl.Taskbar, Vcl.JumpList;

type
  TAsyncExecuteProc = reference to procedure();
  TAsyncFinishedProc = reference to procedure();

  TfrmMain = class(TForm)
    StatusBar: TStatusBar;
    ActionList1: TActionList;
    actInstrument: TAction;
    actOpen: TAction;
    actExit: TAction;
    actPreferences: TAction;
    Exit1: TMenuItem;
    Preferences1: TMenuItem;
    actRemoveInstrumentation: TAction;
    popRecent: TPopupMenu;
    actRescanProject: TAction;
    MRU: TGPMRUFiles;
    MainMenu1: TMainMenu;
    popDelphiVer: TPopupMenu;
    popRecentPrf: TPopupMenu;
    MRUPrf: TGPMRUFiles;
    actHideNotExecuted: TAction;
    actProjectOptions: TAction;
    GpProfile1: TMenuItem;
    N1: TMenuItem;
    Panel0: TPanel;
    Panel1: TPanel;
    actRescanChanged: TAction;
    actChangeLayout: TAction;
    actAddLayout: TAction;
    actDelLayout: TAction;
    actRenameLayout: TAction;
    actLayoutManager: TAction;
    popLayout: TPopupMenu;
    pnlLayout: TPanel;
    inpLayoutName: TEdit;
    BtnDeleteLayout: TButton;
    btnActivateLayout: TButton;
    btnRenameLayout: TButton;
    btnAddLayout: TButton;
    SpeedButton1: TSpeedButton;
    imglListViews: TImageList;
    lvLayouts: TListView;
    Layout1: TMenuItem;
    LayoutManager1: TMenuItem;
    ImageListMedium: TImageList;
    imgListInstrumentationSmall: TImageList;
    imgListInstrumentationMedium: TImageList;
    ApplicationTaskbar: TTaskbar;
    JumpList1: TJumpList;
    popRecentGis: TPopupMenu;
    MRUGis: TGPMRUFiles;
    Action1: TAction;
    Action2: TAction;
    PageControl1: TPageControl;
    tabInstrumentation: TTabSheet;
    tbrInstrument: TToolBar;
    btnOpenProject: TToolButton;
    btnRescanProject: TToolButton;
    btnInstrumentDelimiter1: TToolButton;
    btnInstrument: TToolButton;
    btnRemoveInstrumentation: TToolButton;
    btnInstrumentDelimiter2: TToolButton;
    btnProjectOptions: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure MRUClick(Sender: TObject; LatestFile: String);
    procedure FormDestroy(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actPreferencesExecute(Sender: TObject);
    procedure cbProfileChange(Sender: TObject);
    procedure actInstrumentExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actRescanProjectExecute(Sender: TObject);
    procedure actRemoveInstrumentationExecute(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure actInstrumentRunExecute(Sender: TObject);
    procedure btnCancelLoadClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StatusBarResize(Sender: TObject);
    procedure actHideNotExecutedExecute(Sender: TObject);
    procedure actProjectOptionsExecute(Sender: TObject);
    procedure actRescanChangedExecute(Sender: TObject);
    procedure actChangeLayoutExecute(Sender: TObject);
    procedure actLayoutManagerExecute(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure lbLayoutsClick(Sender: TObject);
    procedure actAddLayoutUpdate(Sender: TObject);
    procedure actRenameLayoutUpdate(Sender: TObject);
    procedure actChangeLayoutUpdate(Sender: TObject);
    procedure actDelLayoutUpdate(Sender: TObject);
    procedure inpLayoutNameKeyPress(Sender: TObject; var Key: Char);
    procedure actDelLayoutExecute(Sender: TObject);
    procedure actAddLayoutExecute(Sender: TObject);
    procedure lbLayoutsDblClick(Sender: TObject);
    procedure lbLayoutsKeyPress(Sender: TObject; var Key: Char);
    procedure actRenameLayoutExecute(Sender: TObject);
    procedure lvLayoutsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure CMDialogKey( Var msg: TCMDialogKey ); message CM_DIALOGKEY;
    procedure clbUnitsKeyPress(Sender: TObject; var Key: Char);
    procedure clbClassesKeyPress(Sender: TObject; var Key: Char);
    procedure MRUGisClick(Sender: TObject; LatestFile: string);
  private
    openProject               : TProject;
    currentProject            : string;
    currentProfile            : string;
    cancelLoading             : boolean;
    loadCanceled              : boolean;
    storedPanel1Width         : integer;
    loadedSource              : string;
    undelProject              : string;
    activeLayout              : string;
    previewVisibleInstr       : boolean;
    previewVisibleAnalysis    : boolean;
    inLVResize                : boolean;
    FInstrumentationFrame     : TfrmMainInstrumentation;
    fNeededSeconds            : Double;
    procedure ReloadJumpList();

    procedure ExecuteAsync(const aProc: TAsyncExecuteProc;const aOnFinishedProc: TAsyncFinishedProc;const aActionName : string);
    procedure ParseProject(const aProject: string; const aJustRescan: boolean);
    procedure LoadProject(fileName: string; defaultDelphi: string = '');
    procedure NotifyParse(const aUnitName: string);
    procedure NotifyInstrument(const aFullName, aUnitName: string; aParse: Boolean);

    procedure DelphiVerClick(Sender: TObject);
    procedure LayoutClick(Sender: TObject);
    procedure RebuildDelphiVer;
    procedure DisablePC;
    procedure EnablePC;
    procedure SetCaption;
    procedure SetSource;
    procedure FillDelphiVer;
    procedure LoadSource(const fileName: String; focusOn: integer);
    procedure ClearSource;
    procedure StatusPanel0(const msg: string; const beep: boolean);
    procedure ShowError(const Msg : string);
    function  ShowErrorYesNo(const Msg : string): integer;

    procedure DoInstrument;
    procedure RescanProject;
    procedure LoadMetrics(layoutName: string);
    procedure SaveMetrics(layoutName: string);
    procedure RebuildLayoutPopup(changeActive: boolean);
    function  IsLayout(layout: string): boolean;
    procedure SetChangeLayout(setRestore: boolean);
    procedure LoadLayouts;
    procedure UseDelphiSettings(delphiVer: integer);
    procedure RebuildDefines;
    function  IsProjectConsole: boolean;
    procedure RestoreUIAfterParseProject;
    procedure WMDropFiles (var aMsg: TMessage); message WM_DROPFILES;
 end;

var
  frmMain: TfrmMain;

implementation

uses
  gpProf.bdsVersions,
  gpProf.ProjectAccessor,
  gpProf.Delphi.RegistryAccessor,
  IniFiles,
  GpString,
  GpIFF,
  GpRegistry,
  gppCommon,
  gpversion,
  gppPreferencesDlg,
  gppLoadProgress,
  SimpleReportUnit,
  UITypes,
  StrUtils,
  ioUtils,
  Diagnostics,
  Winapi.ActiveX,
  System.Threading, gppmain.dragNdrop;


{$R *.DFM}

{========================= TfrmMain =========================}

procedure TfrmMain.CMDialogKey(var msg: TCMDialogKey);
var
  control: TWinControl;
begin
  with Msg do begin
    if (charcode = VK_TAB) and (GetKeyState(VK_CONTROL) < 0) then begin
      control:= ActiveControl;
      while Assigned(control) do begin
        if control is TPageControl then begin
          control.Perform(CM_DIALOGKEY, charcode, keydata);
          Exit;
        end
        else control := Control.Parent;
      end;
    end;
  end;
  inherited;
end; { TfrmMain.CMDialogKey }



procedure TfrmMain.NotifyParse(const aUnitName: string);
begin
  TThread.Queue(nil,
    procedure
    begin
     StatusPanel0('Parsing ' + aUnitName, False);
     frmLoadProgress.Text := 'Parsing ' + aUnitName;
    end);
end; { TfrmMain.NotifyParse }

procedure TfrmMain.NotifyInstrument(const aFullName, aUnitName: string; aParse: Boolean);
begin
  TThread.Queue(nil,
  procedure
  begin
    if aParse then
      StatusPanel0('Parsing ' + aUnitName, False)
    else begin
      StatusPanel0('Instrumenting ' + aUnitName, False);
      frmLoadProgress.Text := 'Instrumenting ' + aUnitName;
    end;
  end);

end; { TfrmMain.NotifyInstrument }


procedure TfrmMain.DisablePC;
begin
  PageControl1.Font.Color            := clBtnShadow;
  FInstrumentationFrame.DisablePC;
end; { TfrmMain.DisablePC }

procedure TfrmMain.EnablePC;
begin
  PageControl1.Font.Color            := clWindowText;
  FInstrumentationFrame.EnablePC();
  SetSource;
end; { TfrmMain.EnablePC }

procedure TFrmMain.RestoreUIAfterParseProject();
begin
  TSessionData.ProjectOutputDir := openProject.OutputDir;
  StatusPanel0('Parsed', True);
  EnablePC;
  Enabled := true;

  actRescanProject.Enabled         := true;
  actRescanChanged.Enabled         := true;
  actInstrument.Enabled            := true;
  actRemoveInstrumentation.Enabled := true;
  actProjectOptions.Enabled        := true;

  FInstrumentationFrame.openProject := openProject;
  FInstrumentationFrame.FillUnitTree(not FInstrumentationFrame.chkShowAll.Checked, FInstrumentationFrame.chkShowDirStructure.Checked);
end;

procedure TfrmMain.ParseProject(const aProject: string; const aJustRescan: boolean);
var
  vErrList: TStringList;
  LDefines : string;
begin
  Enabled := False;
  DisablePC;
  if not aJustRescan then
  begin
    FInstrumentationFrame.openProject := nil;
    FreeAndNil(openProject);
    InitProgressBar(self,self.ApplicationTaskbar, 'Parsing units...', true, false);
    SetProgressBarOverlayHint('Parsing units...');
    FInstrumentationFrame.FillUnitTree(true, false); // clear all listboxes
    openProject := TProject.Create(aProject, TSessionData.selectedDelphi);
    TSessionData.CurrentProjectName := aProject;
    RebuildDefines;
    vErrList := TStringList.Create;
    LDefines := frmPreferences.ExtractAllDefines;
    ExecuteAsync(
      procedure
      begin
        openProject.Parse(
          TGlobalPreferences.GetProjectPref('ExcludedUnits',TGlobalPreferences.ExcludedUnits),
          LDefines, NotifyParse,
          TGlobalPreferences.GetProjectPref('MarkerStyle', TGlobalPreferences.MarkerStyle),
          TGlobalPreferences.GetProjectPref('InstrumentAssembler', TGlobalPreferences.InstrumentAssembler),
          vErrList);

      end,
      procedure()
      begin
        TThread.Synchronize(nil, procedure
        begin
          if vErrList.Count > 0 then
          begin
            SetProgressBarPause();
            TfmSimpleReport.Execute(TSessionData.CurrentProjectName + '- error list', vErrList);
          end;
          HideProgressBar;
          vErrList.Free;
          RestoreUIAfterParseProject();
          StatusPanel0('Parsing finished, it took '+fNeededSeconds.ToString+' seconds.',false);
        end);
      end,
      'parsing');
  end
  else
  begin
    InitProgressBar(self,self.ApplicationTaskbar,'Rescanning units...', true, false);
    SetProgressBarOverlayHint('Rescanning units...');
    RebuildDefines;
    LDefines := frmPreferences.ExtractAllDefines;
    ExecuteAsync(
      procedure
      begin
        openProject.Rescan(
          TGlobalPreferences.GetProjectPref('ExcludedUnits', TGlobalPreferences.ExcludedUnits),
          LDefines,
          TGlobalPreferences.GetProjectPref('MarkerStyle', TGlobalPreferences.MarkerStyle),
          TGlobalPreferences.GetProjectPref('InstrumentAssembler', TGlobalPreferences.InstrumentAssembler));
      end,
      procedure()
      begin
        TThread.Synchronize(nil, procedure
        begin
          HideProgressBar;
          RestoreUIAfterParseProject();
          StatusPanel0('Rescanning finished, it took '+fNeededSeconds.ToString+' seconds.',false);
        end);
      end,'rescanning');
  end;
  ShowProgressBar;
end; { TfrmMain.ParseProject }


function TfrmMain.IsProjectConsole: boolean;
begin
  Result := false;
  if assigned(openProject) then
  begin
    // Don't know why but ConsoleApp=1 means that app is NOT a console app!
    with TProjectAccessor.Create(TSessionData.CurrentProjectName) do
    begin
      Result := IsConsoleProject(true);
      Free;
    end;
    // Also, CONSOLE is defined only if Linker option is set, not if
    // {$APPTYPE CONSOLE} is specified in main program!
    // Stupid, but that's how Delphi works.
  end;
end;

procedure TfrmMain.RebuildDefines;
begin
  frmPreferences.ReselectCompilerVersion(TSessionData.selectedDelphi);
  frmPreferences.cbStandardDefines.Checked    := TGlobalPreferences.GetProjectPref('StandardDefines',TGlobalPreferences.StandardDefines);
  frmPreferences.cbConsoleDefines.Checked     := TGlobalPreferences.GetProjectPref('ConsoleDefines',IsProjectConsole);
  frmPreferences.cbProjectDefines.Checked     := TGlobalPreferences.GetProjectPref('ProjectDefines',TGlobalPreferences.ProjectDefines);
  frmPreferences.cbDisableUserDefines.Checked := TGlobalPreferences.GetProjectPref('DisableUserDefines',TGlobalPreferences.DisableUserDefines);
  frmPreferences.RebuildDefines(TGlobalPreferences.GetProjectPref('UserDefines',TGlobalPreferences.UserDefines));
end;

procedure TfrmMain.LoadProject(fileName: string; defaultDelphi: string = '');
begin
  try
    if not FileExists(fileName) then
      raise EFileNotFoundException.Create('File '+fileName+ ' not found.');
    MRU.LatestFile := fileName;
    currentProject := ExtractFileName(fileName);
    ParseProject(fileName,false);
    if defaultDelphi = '' then
      defaultDelphi := RemoveHotkeyAndDelphiPrefix(frmPreferences.cbxCompilerVersion.Items[TGlobalPreferences.CompilerVersion]);
    TSessionData.selectedDelphi := TGlobalPreferences.GetProjectPref('DelphiVersion',defaultDelphi);
    RebuildDelphiVer;
    FInstrumentationFrame.chkShowAll.Checked := TGlobalPreferences.GetProjectPref('ShowAllFolders',TGlobalPreferences.ShowAllFolders);
    PageControl1.ActivePage := tabInstrumentation;
    SetCaption;
    SetSource;
  except
    on e:Exception do
    if Assigned(MRU.FindItem(fileName)) then
    begin
      if ShowErrorYesNo(TUIStrings.ErrorLoadingMRUDeleteIt(fileName)) = mrYes then
      begin
        MRU.DeleteFromMenu(fileName);
        MRU.SaveToRegistry();
        MRU.LoadFromRegistry();
      end;
    end
    else
    begin
      ShowError(TUIStrings.ErrorLoading(fileName));
    end;

  end;
  ReloadJumpList();
end; { TfrmMain.LoadProject }

procedure TfrmMain.RebuildDelphiVer;
var
  i    : integer;
  found: boolean;
begin
  found := false;
  with popDelphiVer do begin
    for i := 0 to Items.Count-2 do Items[i].Checked := false;
    if Items.Count >= 1 then
      Items[Items.Count-1].Checked := true;
    for i := 0 to Items.Count-1 do begin
      if RemoveHotkeyAndDelphiPrefix(Items[i].Caption) = TSessionData.selectedDelphi then
      begin
        Items[Items.Count-1].Checked := false;
        Items[i].Checked := true;
        found := true;
        system.break;
      end;
    end;

    if (not found) and (Items.Count >= 1) then begin
      TSessionData.selectedDelphi := RemoveHotkeyAndDelphiPrefix(Items[Items.Count-1].Caption);
    end;
  end;
  Statusbar.Panels[1].Text := IFF(openProject = nil,'','Delphi '+TSessionData.selectedDelphi);
  if TSessionData.selectedDelphi <> '' then // <-- Added by Alisov A.
    UseDelphiSettings(Ord(TSessionData.selectedDelphi[1])-Ord(48));
end; { TfrmMain.RebuildDelphiVer }

procedure TfrmMain.DelphiVerClick(Sender: TObject);
begin
  TSessionData.selectedDelphi := RemoveHotkeyAndDelphiPrefix(TMenuItem(Sender).Caption);
  RebuildDelphiVer;
  TGlobalPreferences.SetProjectPref('DelphiVersion',TSessionData.selectedDelphi);
end;

procedure TfrmMain.LayoutClick(Sender: TObject);
begin
  SaveMetrics(activeLayout);
  inpLayoutName.Text := TMenuItem(Sender).Caption;
  RebuildLayoutPopup(true);
  inpLayoutName.Text := lvLayouts.Selected.Caption;
  LoadMetrics(inpLayoutName.Text);
end;

procedure TfrmMain.FillDelphiVer;
var
  mn: TMenuItem;
  i : integer;
  LAccessor : TRegistryAccessor;
  LRegEntryList : TDelphiRegistryEntryList;
  LProductName : string;
begin
  LAccessor := TRegistryAccessor.Create('');
  try
    LRegEntryList := LAccessor.RegistryEntries;
    for i := 0 to LRegEntryList.Count-1 do
    begin
      LProductName := ProductVersionToProductName(LRegEntryList[i].ProductVersion);
      mn := TMenuItem.Create(self);
      mn.Caption := 'Delphi &'+LProductName;
      mn.OnClick := DelphiVerClick;
      popDelphiVer.Items.Insert(popDelphiVer.Items.Count,mn);
      frmPreferences.cbxCompilerVersion.Items.Add('Delphi '+LProductName);
      frmPreferences.cbxDelphiDefines.Items.Add('Delphi '+LProductName);
    end;
    if LRegEntryList.Count >= 1 then
    begin
      if (TGlobalPreferences.CompilerVersion < 0) or (TGlobalPreferences.CompilerVersion >= LRegEntryList.Count) then
        TGlobalPreferences.CompilerVersion := LRegEntryList.Count-1;
      TSessionData.selectedDelphi := TGlobalPreferences.GetProjectPref('DelphiVersion', LRegEntryList[TGlobalPreferences.CompilerVersion].ProductName);
      RebuildDelphiVer;
    end;
  finally
    LAccessor.free;
  end;

end; { TfrmMain.FillDelphiVer }


procedure TfrmMain.RebuildLayoutPopup(changeActive: boolean);
var
  mn      : TMenuItem;
  i       : integer;
  found   : boolean;
  ucLayout: string;
  lastName: string;
begin
  while popLayout.Items.Count > 0 do popLayout.Items.Remove(popLayout.Items[0]);
  if changeActive then begin
    with lvLayouts do for i := 0 to Items.Count-1 do
      with Items[i] do if ImageIndex = 2 then ImageIndex := 0;
    ucLayout := UpperCase(inpLayoutName.Text);
    found := false;
    lastName := '';
    for i := 0 to lvLayouts.Items.Count-1 do begin
      if lvLayouts.Items[i].ImageIndex <> 1 then begin
        if UpperCase(lvLayouts.Items[i].Caption) = ucLayout then begin
          found := true;
          break;
        end
        else lastName := lvLayouts.Items[i].Caption;
      end;
    end;
    if not found then inpLayoutName.Text := lastName;
  end;
  for i := 0 to lvLayouts.Items.Count-1 do begin
    if lvLayouts.Items[i].ImageIndex <> 1 then begin
      mn := TMenuItem.Create(self);
      mn.Caption := lvLayouts.Items[i].Caption;
      mn.OnClick := LayoutClick;
      if changeActive
        then mn.Checked := UpperCase(lvLayouts.Items[i].Caption) = ucLayout
        else mn.Checked := lvLayouts.Items[i].ImageIndex = 2;
      if mn.Checked then begin
        lvLayouts.Selected := lvLayouts.Items[i];
        lvLayouts.Selected.ImageIndex := 2;
      end;
      popLayout.Items.Insert(popLayout.Items.Count,mn);
    end;
  end;
end;


{ TfrmMain.RebuildLayoutPopup }

function TfrmMain.IsLayout(layout: string): boolean;
var
  i: integer;
begin
  IsLayout := true;
  layout := UpperCase(layout);
  for i := 0 to lvLayouts.Items.Count-1 do
    if UpperCase(lvLayouts.Items[i].Caption) = layout then Exit;
  IsLayout := false;
end; { TfrmMain.IsLayout }

procedure TfrmMain.LoadLayouts;
var
  layout: string;
  vSL   : TStringList;
  i     : integer;
begin
  with TGpRegistry.Create do begin
    try
      RootKey := HKEY_CURRENT_USER;
      if OpenKey(cRegistryUI,true) then
      begin
        vSL := TStringList.Create;
        try
          GetKeyNames(vSL);
          for i := 0 to vSL.Count-1 do
            with lvLayouts.Items.Add do Caption := vSL[i];
        finally
          vSL.Free;
        end;

        if lvLayouts.Items.Count = 0 then
          with lvLayouts.Items.Add do
            Caption := cDefLayout;

        layout := TGpRegistryTools.GetPref(cRegistryUIsub, 'Layout', cDefLayout);
        if IsLayout(layout) then
          inpLayoutName.Text := layout
        else
          inpLayoutName.Text := lvLayouts.Items[0].Caption;
      end;
      RebuildLayoutPopup(true);
    finally
      Free;
    end;
  end;
end; { TfrmMain.LoadLayouts }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FInstrumentationFrame := TfrmMainInstrumentation.Create(self);
  FInstrumentationFrame.Parent := tabInstrumentation;
  FInstrumentationFrame.Align := alClient;
  FInstrumentationFrame.chkShowAll.OnClick := cbProfileChange;;
  FInstrumentationFrame.OnReloadSource := LoadSource;
  FInstrumentationFrame.OnShowStatusBarMessage := StatusPanel0;
  Application.DefaultFont.Name :=  'Segoe UI';
  Application.DefaultFont.Size :=  8;
  inLVResize := false;
  Application.HelpFile := ChangeFileExt(ParamStr(0),'.Chm');
  if not FileExists(Application.HelpFile) then Application.HelpFile := '';
  LoadLayouts;
  StatusBar.Font.Size := 10;
  ClearSource;
  TGlobalPreferences.LoadPreferences;
  PageControl1.ActivePage := tabInstrumentation;
  DisablePC;
  loadCanceled := false;
  TSessionData.CurrentProjectName := '';

  MRU.RegistryKey := cRegistryRoot+'\MRU\DPR';
  MRU.LoadFromRegistry;
  MRUPrf.RegistryKey := cRegistryRoot+'\MRU\PRF';
  MRUPrf.LoadFromRegistry;
  MRUGis.RegistryKey := cRegistryRoot+'\MRU\GIS';
  MRUGis.LoadFromRegistry;
  ReloadJumpList();
  undelProject := '';

  SetCaption();
  //LPercentage := Screen.PixelsPerInch * 100 / 96;

  if 1=0 then
  begin
    tbrInstrument.Images := imgListInstrumentationMedium;
  end;
  TDragNDropHandler.setDragNDropEnabled(self.Handle, true);
end;

procedure TfrmMain.ReloadJumpList();

  procedure AddMenu(const aMenu: TGPMRUFiles; const aCategory : string);
  var
    i : integer;
    LCategoryIndex : Integer;
    LPath : string;
  begin
    LCategoryIndex := JumpList1.AddCategory(aCategory);
    for i := 0 to aMenu.PopupMenu.Items.Count-1 do
    begin
      LPath := aMenu.PopupMenu.Items[i].Caption;
      if Length(LPath) < 4 then
        Continue;
      LPath := Copy(LPath,4, 256);
      JumpList1.AddItemToCategory(LCategoryIndex, ChangeFileExt(ExtractFileName(LPath),''),'',AnsiQuotedStr(LPath, '"'));
    end;
  end;

begin
  JumpList1.ApplicationID := 'BWInstrumenter2023';
  JumpList1.CustomCategories.Clear();
  AddMenu(MRU, 'Instrument');
  AddMenu(MRUPrf, 'Analyse');
  // GIS is excluded, as we need to load an instrument project for GIS
end;

procedure TfrmMain.MRUClick(Sender: TObject; LatestFile: String);
begin
  if (openProject = nil) or (openProject.Name <> LatestFile) then
  begin
    LoadProject(LatestFile);
  end;
end;

procedure TfrmMain.MRUGisClick(Sender: TObject; LatestFile: string);
begin
  try
    openProject.LoadInstrumentalizationSelection(LatestFile);
    // an auto-click is done... ignore instrumentation upon select
    FInstrumentationFrame.TriggerSelectionReload;
  except
    on e:Exception do
    begin
      if Assigned(MRUGis.FindItem(LatestFile)) then
      begin
        if ShowErrorYesNo(TUIStrings.ErrorLoadingMRUDeleteIt(LatestFile)) = mrYes then
        begin
          MRUGis.DeleteFromMenu(LatestFile);
          MRUGis.SaveToRegistry();
          MRUGis.LoadFromRegistry();
        end;
      end
      else
      begin
        ShowError(TUIStrings.ErrorLoading(LatestFile));
      end;
    end;
  end;

end;

procedure TfrmMain.SaveMetrics(layoutName: string);

  procedure PutHeader(reg: TGpRegistry; aVST: TVirtualStringTree; prefix: string);
  var
    i: integer;
  begin
    for i := 0 to aVST.Header.Columns.Count-1 do
      reg.WriteInteger(prefix+'Column'+IntToStr(i)+'Width',aVST.Header.Columns[i].Width);
  end; { PutColumns }


var
  reg: TGpRegistry;
  wp : TWindowPlacement;
begin
  reg := TGpRegistry.Create;
  try
    with reg do begin
      RootKey := HKEY_CURRENT_USER;
      OpenKey(cRegistryUI,true);
      WriteString('UIVer', cUIVersion);
      OpenKey(layoutName,true);
      WriteInteger('WindowState',Ord(WindowState));
      wp.Length := SizeOf(TWindowPlacement);
      if GetWindowPlacement(frmMain.Handle,@wp) then begin
        WriteInteger('FormLeft',wp.rcNormalPosition.Left);
        WriteInteger('FormTop',wp.rcNormalPosition.Top);
        WriteInteger('FormRight',wp.rcNormalPosition.Right);
        WriteInteger('FormBottom',wp.rcNormalPosition.Bottom);
      end;
      WriteInteger('pnlUnitsWidth',FInstrumentationFrame.pnlUnits.Width);
      WriteInteger('pnlClassesWidth',FInstrumentationFrame.pnlClasses.Width);
      WriteBool('previewVisibleInstr',previewVisibleInstr);
      WriteBool('previewVisibleAnalysis',previewVisibleAnalysis);
    end;
  finally reg.Free; end;
end; { TfrmMain.SaveMetrics }

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  with TGpRegistry.Create do
    try
      RootKey := HKEY_CURRENT_USER;
      for i := 0 to lvLayouts.Items.Count-1 do
        if lvLayouts.Items[i].ImageIndex = 1 then
          DeleteKey(cRegistryUI + '\' + lvLayouts.Items[i].Caption);
    finally
      Free;
    end;

  if activeLayout <> '' then begin
    SaveMetrics(activeLayout);
    TGpRegistryTools.SetPref(cRegistryUIsub,'Layout',activeLayout)
  end;
  MRU.SaveToRegistry;
  MRUPrf.SaveToRegistry;
  MRUGis.SaveToRegistry;
  FreeAndNil(openProject);
end;


procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.actPreferencesExecute(Sender: TObject);
var
  oldProject: TProject;
begin
  oldProject := openProject;
  openProject := nil;
  try
    with frmPreferences do begin
      if ExecuteGlobalSettings then
        RebuildDelphiVer;
    end;
  finally openProject := oldProject; end;
end;

procedure TfrmMain.cbProfileChange(Sender: TObject);
begin
  FInstrumentationFrame.FillUnitTree(not FInstrumentationFrame.chkShowAll.Checked, FInstrumentationFrame.chkShowDirStructure.Checked);
  TGlobalPreferences.SetProjectPref('ShowAllFolders',FInstrumentationFrame.chkShowAll.Checked);
end;


procedure TfrmMain.clbUnitsKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #32 then
    FInstrumentationFrame.clbUnitsClick();
  inherited;
end;

procedure TfrmMain.ExecuteAsync(const aProc: TAsyncExecuteProc;const aOnFinishedProc: TAsyncFinishedProc;const aActionName : string);
var
  LTask : ITask;
  LExceptionMsg : string;
begin
  LTask := tTask.Create(procedure
    var
      LStopwatch : TStopwatch;
    begin
      try
        Coinitialize(nil);
        try
          LStopwatch := TStopWatch.StartNew();
          aProc();
        finally
          LStopwatch.Stop;
          CoUninitialize
        end;
      except
        on E:Exception do
        begin
          LStopwatch.Reset;
          LExceptionMsg := e.Message;
          TThread.Synchronize(nil,procedure
            begin
              StatusPanel0('Error while '+aActionName+': '+LExceptionMsg,false);
              ShowError('Error while '+aActionName+':'+sLineBreak+sLineBreak+LExceptionMsg);
            end
          );
        end;
      end;
      if assigned(aOnFinishedProc) then
      begin
        fNeededSeconds := LStopwatch.Elapsed.TotalSeconds;
        aOnFinishedProc();
      end;
    end);
  LTask.Start;
end;


procedure TfrmMain.DoInstrument;
var
  fnm   : string;
  outDir: string;
  LShowAll : Boolean;
  LDefines : string;
begin
  InitProgressBar(self,self.ApplicationTaskbar,'Instrumenting units...',true, false);
  outDir := openProject.OutputDir;
  fnm := MakeSmartBackslash(outDir)+ChangeFileExt('bwIntegrator','.gpi');
  LShowAll := FInstrumentationFrame.chkShowAll.Checked;
  LDefines := frmPreferences.ExtractAllDefines;
  Enabled := false;
  ExecuteAsync(
    procedure
    begin
      openProject.Instrument(not LShowAll,
                         TGlobalPreferences.GetProjectPref('ExcludedUnits',TGlobalPreferences.ExcludedUnits),
                         NotifyInstrument,
                         TGlobalPreferences.GetProjectPref('MarkerStyle',TGlobalPreferences.MarkerStyle),
                         TGlobalPreferences.GetProjectPref('MakeBackupOfInstrumentedFile',TGlobalPreferences.MakeBackupOfInstrumentedFile),
                         fnm,LDefines,
                         TGlobalPreferences.GetProjectPref('InstrumentAssembler',TGlobalPreferences.InstrumentAssembler));

      if FileExists(fnm) then
        with TIniFile.Create(fnm) do
          try
            WriteBool('Performance','ProfilingAutostart',TGlobalPreferences.GetProjectPref('ProfilingAutostart',TGlobalPreferences.ProfilingAutostart));
            WriteBool('Performance','ProfilingMemSupport',TGlobalPreferences.GetProjectPref('ProfilingMemSupport',TGlobalPreferences.ProfilingMemSupport));
            WriteBool('Performance','CompressTicks',TGlobalPreferences.GetProjectPref('SpeedSize',TGlobalPreferences.SpeedSize)>1);
            WriteBool('Performance','CompressThreads',TGlobalPreferences.GetProjectPref('SpeedSize',TGlobalPreferences.SpeedSize)>2);
          finally
            Free;
          end;
    end,
    procedure()
    begin
      TThread.Synchronize(nil,
      procedure
        begin
          Enabled := true;
          HideProgressBar();
          FInstrumentationFrame.ReloadSource;
          StatusPanel0('Instrumentation finished, it took '+fNeededSeconds.ToString+' seconds.',false);
        end
      );
    end,
     'instrumenting');
  ShowProgressBar();

end; { TfrmMain.DoInstrument }

procedure TfrmMain.actInstrumentExecute(Sender: TObject);
begin
  DoInstrument;
end;

procedure TfrmMain.actOpenExecute(Sender: TObject);
var
  LSourceFilename: TFileName;
  LFilename : string;
  LOpenDialog : TOpenDialog;
begin
  LOpenDialog := TOpenDialog.Create(Self);
  LOpenDialog.DefaultExt := TUIStrings.DelphiProjectSourceDefaultExt;
  LFilename := MRU.LatestFile;
  LOpenDialog.InitialDir := ExtractFileDir(LFilename);
  LOpenDialog.Filter := TUIStrings.ProjectSelectionFilter();
  LOpenDialog.Title := TUIStrings.LoadProjectCaption();
  if LOpenDialog.Execute(Self.Handle) then
  begin
    LSourceFilename := LOpenDialog.FileName;
    if AnsiLowerCase(ExtractFileExt(LOpenDialog.FileName)) = TUIStrings.DelphiProjectExt then
    begin
      // convert to dpk if exists, else to dpr
      if FileExists(ChangeFileExt(LSourceFilename, TUIStrings.DelphiPackageSourceExt)) then
        LSourceFilename := ChangeFileExt(LSourceFilename, TUIStrings.DelphiPackageSourceExt)
      else
        LSourceFilename := ChangeFileExt(LSourceFilename, TUIStrings.DelphiProjectSourceExt);
    end;
    LoadProject(LSourceFilename);
  end;
  LOpenDialog.Free;
end;

procedure TfrmMain.actRescanProjectExecute(Sender: TObject);
begin
  LoadProject(openProject.Name);
end;



procedure TfrmMain.clbClassesKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #32 then
    FInstrumentationFrame.clbClassesClick(Sender);
  inherited;
end;

procedure TfrmMain.actRemoveInstrumentationExecute(Sender: TObject);
begin
  FInstrumentationFrame.RemoveInstrumentation(DoInstrument);
end;

procedure TfrmMain.PageControl1Change(Sender: TObject);
begin
  SetCaption;
  SetSource;
  if PageControl1.ActivePage = tabInstrumentation then
  begin
    FInstrumentationFrame.clbProcsClick(Sender);
  end;
end;


procedure TfrmMain.SetCaption;
begin
  Caption := 'BWInstrumenter 2025 - '+ GetVersion(verShort2to4)+' ';
  if PageControl1.ActivePage = tabInstrumentation then
    Caption := Caption+IFF(currentProject <> '',' - '+currentProject,'')
  else
    Caption := Caption+IFF(currentProfile <> '',' - '+currentProfile,'')+IFF(loadCanceled,' (incomplete)','');
  Application.Title := Caption;
end;

procedure TfrmMain.SetSource;
var
  enabled: boolean;
begin
  if PageControl1.ActivePage = tabInstrumentation
    then enabled := (currentProject <> '')
    else enabled := (currentProfile <> '');
  if not enabled then
    ClearSource;
end;

procedure TfrmMain.actInstrumentRunExecute(Sender: TObject);
begin
  DoInstrument;
end;

procedure TfrmMain.btnCancelLoadClick(Sender: TObject);
begin
  cancelLoading := true;
end;

procedure TfrmMain.LoadMetrics(layoutName: string);

  procedure GetHeaders(reg: TGpRegistry; aVST: TVirtualStringTree; prefix: string);
  var
    i: integer;
  begin
    for i := 0 to aVST.Header.Columns.Count-1 do begin
      aVST.Header.Columns[i].Width := reg.ReadInteger(prefix+'Column'+IntToStr(i)+'Width',aVST.Header.Columns[i].Width);
    end;
  end; { GetColumns }


  function CheckCorrectUIVer: boolean;
  begin
    with TGpRegistry.Create do
      try
        RootKey := HKEY_CURRENT_USER;
        OpenKey(cregistryUI, True);
        if ReadString('UIVer','') = cUIVersion then
          Result := True
        else begin
          CloseKey;
          DeleteKey(cRegistryUI);
          LoadLayouts;
          Result := False;
        end;
      finally
        Free;
      end;
  end; { CheckCorrectUIVer }

var
  reg: TGpRegistry;
  wp : TWindowPlacement;
begin
  DisableAlign;
  try
    CheckCorrectUIVer;
    reg := TGpRegistry.Create;
    try
      with reg do begin
        RootKey := HKEY_CURRENT_USER;
        OpenKey(cRegistryUI+'\'+layoutName,true);
        WindowState := TWindowState(ReadInteger('WindowState', 0));
        wp.Length := SizeOf(TWindowPlacement);
        if GetWindowPlacement(frmMain.Handle,@wp) then begin
          wp.rcNormalPosition.Left   := ReadInteger('FormLeft',wp.rcNormalPosition.Left);
          wp.rcNormalPosition.Top    := ReadInteger('FormTop',wp.rcNormalPosition.Top);
          wp.rcNormalPosition.Right  := ReadInteger('FormRight',wp.rcNormalPosition.Right);
          wp.rcNormalPosition.Bottom := ReadInteger('FormBottom',wp.rcNormalPosition.Bottom);
          SetWindowPlacement(frmMain.Handle,@wp);
        end;
        FInstrumentationFrame.pnlUnits.Width   := ReadInteger('pnlUnitsWidth',FInstrumentationFrame.pnlUnits.Width);
        FInstrumentationFrame.pnlClasses.Width := ReadInteger('pnlClassesWidth',FInstrumentationFrame.pnlClasses.Width);
        previewVisibleInstr     := ReadBool('previewVisibleInstr',true);
        previewVisibleAnalysis  := ReadBool('previewVisibleAnalysis',true);
      end;
    finally reg.Free; end;
  finally EnableAlign; end;
  Application.ProcessMessages;
  TGpRegistryTools.SetPref(cRegistryUIsub,'Layout',layoutName);
  activeLayout := layoutName;
end; { TfrmMain.LoadMetrics }

procedure TfrmMain.UseDelphiSettings(delphiVer: integer);
var
  s      : TStringList;
  setting: integer;
  i      : integer;
  verch  : char;
begin
  s := TStringList.Create;
  try
    verch := Chr(delphiVer+Ord('0'));
    setting := s.Count-1;
    for i := 0 to s.Count-2 do
      if s[i][1] = verch then begin
        setting := i;
        break;
      end;
    SetSource;
  finally s.Free; end;
end;

procedure TfrmMain.WMDropFiles(var aMsg: TMessage);
var
  LDragNDropHandler : TDragNDropHandler;
  LFilename : string;
begin
  LDragNDropHandler := TDragNDropHandler.Create(aMsg.WParam);
  try
    LDragNDropHandler.DetermineDroppedFiles();
    for LFilename in LDragNDropHandler.Filenames do
    begin
      if LFilename.EndsWith('.dpr', true) then
      begin
        LoadProject(LFilename);
        Break;
      end;
    end;
  finally
    LDragNDropHandler.free;
  end;
end;

{ TfrmMain.UseDelphiSettings }

procedure TfrmMain.FormShow(Sender: TObject);

const
  first: boolean = true;

  procedure ParseCommandLine;
  var
    defDelphi: string;
    ddel     : string;
    delphiVer: integer;
    dpkName  : string;
  begin
    if ParamCount <> 0 then begin
      defDelphi := '';
      delphiVer := 0;
      if ParamCount >= 1 then begin
        ddel := ParamStr(ParamCount);
        if UpperCase(Copy(ddel,1,8)) = '/DELPHI=' then begin
          ddel := ButFirst(ddel,8);
          if (Length(ddel) > 0) and (CharInSet(ddel[1],['2'..'9'])) then
          begin
            defDelphi := ddel;
            delphiVer := Ord(ddel[1])-Ord('0');
          end;
        end;
      end;
      UseDelphiSettings(delphiVer);
      if (ParamCount > 1) or (defDelphi = '') then
      begin
        dpkName := ChangeFileExt(ParamStr(1),'.dpk');
        if FileExists(dpkName) then
          LoadProject(dpkName,defDelphi)
        else
          LoadProject(ChangeFileExt(ParamStr(1),'.dpr'),defDelphi);
      end;
    end
    else begin
      UseDelphiSettings(0);
      SetSource;
    end;
  end; { ParseCommandLine }

begin
  if first then begin
    first := false;
    LoadMetrics(inpLayoutName.Text);
    FillDelphiVer;
    if (ParamCount = 1) and (UpperCase(ParamStr(1)) = '/FIRSTTIME') then begin
    end
    else ParseCommandLine;
    if HasParameter('/REMOVEINST') then begin
      actRemoveInstrumentation.Execute;
      Application.Terminate;
    end;
  end;
end;

procedure TfrmMain.StatusBarResize(Sender: TObject);
begin
  with StatusBar do begin
    if storedPanel1Width = 0
      then storedPanel1Width := Width-Panels[0].Width // first time
      else Panels[0].Width := Width-storedPanel1Width;
  end;
end;

procedure TfrmMain.actHideNotExecutedExecute(Sender: TObject);
begin
  actHideNotExecuted.Checked := not actHideNotExecuted.Checked;
  TGlobalPreferences.SetProfilePref('HideNotExecuted', actHideNotExecuted.Checked);
end;

procedure TfrmMain.actProjectOptionsExecute(Sender: TObject);
begin
  with frmPreferences do
  begin
    if ExecuteProjectSettings(FInstrumentationFrame.chkShowAll.Checked) then
    begin
      FInstrumentationFrame.chkShowAll.Checked := cbShowAllFolders.Checked;
      RebuildDelphiVer;
      if DefinesChanged then
        actRescanProject.Execute;
    end;
  end;
end;

procedure TfrmMain.LoadSource(const fileName: string; focusOn: integer);
begin
  try
    if fileName <> '' then
    begin
      if fileName <> loadedSource then
      begin
        loadedSource := fileName;
      end;
      if focusOn < 0 then focusOn := 0;
      StatusPanel0(fileName,false);
    end;
  except
  end;
end; { TfrmMain.LoadSource }

procedure TfrmMain.ClearSource;
begin
  loadedSource := '';
  StatusPanel0('',true);
end; { TfrmMain.ClearSource }

procedure TfrmMain.StatusPanel0(const msg: string; const beep: boolean);
begin
  if (msg <> '') then begin
    StatusBar.Panels[0].Text := msg;
    if beep then MessageBeep($FFFFFFFF);
  end;
end;

procedure TfrmMain.ShowError(const Msg : string);
begin
  StatusPanel0(msg,true);
  MessageDlg(msg,TMsgDlgType.mtError,[mbOK],0,mbOk);
end;


function TfrmMain.ShowErrorYesNo(const Msg : string): integer;
begin
  result := MessageDlg(msg,TMsgDlgType.mtConfirmation,[TMsgDlgBtn.mbYes ,TMsgDlgBtn.mbNo],0,mbYes);
end;

procedure TfrmMain.actRescanChangedExecute(Sender: TObject);
begin
  RescanProject;
end;

procedure TfrmMain.RescanProject;
begin
  if openProject = nil then
    Exit;

  if openProject.AnyChange(false) then
  begin
    FInstrumentationFrame.RescanProject(ParseProject);
    SetSource;
  end;
end;

procedure TfrmMain.actChangeLayoutExecute(Sender: TObject);
begin
  if (not pnlLayout.Visible) or
     (UpperCase(activeLayout) <> UpperCase(lvLayouts.Selected.Caption))
    then SaveMetrics(activeLayout);
  inpLayoutName.Text := lvLayouts.Selected.Caption;
  LoadMetrics(inpLayoutName.Text);
  RebuildLayoutPopup(true);
  SetChangeLayout(true);
end;

procedure TfrmMain.actLayoutManagerExecute(Sender: TObject);
begin
  pnlLayout.Visible := not pnlLayout.Visible;
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
begin
  pnlLayout.Hide;
end;

procedure TfrmMain.lbLayoutsClick(Sender: TObject);
begin
  if assigned(lvLayouts.Selected)
    then inpLayoutName.Text := lvLayouts.Selected.Caption;
end;

procedure TfrmMain.actAddLayoutUpdate(Sender: TObject);
begin
  actAddLayout.Enabled := ((inpLayoutName.Text <> '') and
                           (not IsLayout(inpLayoutName.Text)));
end;

procedure TfrmMain.actRenameLayoutUpdate(Sender: TObject);
begin
  actRenameLayout.Enabled := ((lvLayouts.Selected <> nil) and
                              (inpLayoutName.Text <> '') and
                              (not IsLayout(inpLayoutName.Text)) and
                              (lvLayouts.Selected.ImageIndex <> 1));
end;

procedure TfrmMain.actChangeLayoutUpdate(Sender: TObject);
begin
  actChangeLayout.Enabled := ((not pnlLayout.Visible) or
                              ((lvLayouts.Selected <> nil) and
                               (lvLayouts.Selected.ImageIndex <> 1)));
end;

procedure TfrmMain.actDelLayoutUpdate(Sender: TObject);
begin
  actDelLayout.Enabled := (lvLayouts.Selected <> nil);
end;

procedure TfrmMain.inpLayoutNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = '\' then Key := #0
  else if Key = #13 then begin
    actAddLayout.Execute;
    pnlLayout.Hide;
  end;
end;

procedure TfrmMain.actDelLayoutExecute(Sender: TObject);
var
  idx: integer;
begin
  if lvLayouts.Selected.ImageIndex = 1 then begin
    lvLayouts.Selected.ImageIndex := 0;
    RebuildLayoutPopup(false);
  end
  else begin
    activeLayout := '';
    lvLayouts.Selected.ImageIndex := 1;
    idx := lvLayouts.Items.IndexOf(lvLayouts.Selected);
    Inc(idx);
    if idx >= lvLayouts.Items.Count then idx := 0;
    if idx < lvLayouts.Items.Count then begin
      lvLayouts.Selected := lvLayouts.Items[idx];
      inpLayoutName.Text := lvLayouts.Items[idx].Caption;
    end
    else inpLayoutName.Text := '';
    RebuildLayoutPopup(true);
    if idx < lvLayouts.Items.Count then actChangeLayout.Execute;
  end;
  with actDelLayout do begin
    if lvLayouts.Selected.ImageIndex = 1 then begin
      Caption := 'Undelete';
      Hint    := 'Undelete layout';
    end
    else begin
      Caption := 'Delete';
      Hint    := 'Delete layout';
    end;
  end;
end;

procedure TfrmMain.actAddLayoutExecute(Sender: TObject);
begin
  SaveMetrics(activeLayout);
  lvLayouts.Selected := lvLayouts.Items.Add;
  lvLayouts.Selected.Caption := inpLayoutName.Text;
  activeLayout := inpLayoutName.Text;
  RebuildLayoutPopup(true);
end;

procedure TfrmMain.lbLayoutsDblClick(Sender: TObject);
begin
  if lvLayouts.Selected.ImageIndex <> 1 then begin
    inpLayoutName.Text := lvLayouts.Selected.Caption;
    actChangeLayout.Execute;
    pnlLayout.Hide;
  end;
end;

procedure TfrmMain.lbLayoutsKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    if lvLayouts.Selected <> nil then lbLayoutsDblClick(Sender);
end;

procedure TfrmMain.actRenameLayoutExecute(Sender: TObject);
begin
  with TGpRegistry.Create do
    try
      RootKey := HKEY_CURRENT_USER;
      MoveKey(cRegistryUI+'\'+lvLayouts.Selected.Caption, cRegistryUI+'\'+inpLayoutName.Text,true);
    finally
      Free;
    end;

  lvLayouts.Selected.Caption := inpLayoutName.Text;
  RebuildLayoutPopup(true);
end;

procedure TfrmMain.lvLayoutsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  with actDelLayout do begin
    if Item.ImageIndex = 1 then begin
      Caption := 'Undelete';
      Hint    := 'Undelete layout';
    end
    else begin
      Caption := 'Delete';
      Hint    := 'Delete layout';
    end;
  end;
  with actChangeLayout do begin
    SetChangeLayout(Item.ImageIndex = 2);
  end;
end;

procedure TfrmMain.SetChangeLayout(setRestore: boolean);
begin
  with actChangeLayout do begin
    if setRestore then begin
      Caption := 'Restore';
      Hint    := 'Restore layout';
    end
    else begin
      Caption := 'Activate';
      Hint    := 'Activate layout';
    end;
  end;
end; { TfrmMain.SetChangeLayout }

end.
