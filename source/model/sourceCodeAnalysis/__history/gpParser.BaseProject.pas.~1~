unit gpParser.BaseProject;

interface

uses
  System.Classes, System.Generics.Collections, gpParser.Types, System.Types;

type
  TBaseProject = class
  protected
    fFullUnitName : string;
  private
    fAPIIntro: string;
    fConditStart: string;
    fConditStartUses: string;
    fConditStartAPI: string;
    fConditEnd: string;
    fConditEndUses: string;
    fConditEndAPI: string;
    fNameThreadForDebugging: string;
    fAppendUses: string;
    fCreateUses: string;
    // >> Modificado: 15/08/2023
    fAppendUsesSysUtils: string;
    fCreateUsesSysUtils: string;
    // << Modificado: 15/08/2023
    fIntegratorEnterProcess: string;
    fIntegratorExitProcess: string;
    fIntegratorEnterAsm: string;
    fIntegratorExitAsm: string;
    fIntegratorAPI: string;
    fProjectName: string;
    fSelectedDelphiVersion : string;
    fIsConsoleProject : Boolean;
    fOutputDir : string;
    fSearchPathes : TStringDynArray;
    fNamespaces : TStringDynArray;

    fMissingUnitNames : TDictionary<String, Cardinal>;
    fExcludedUnitDict : TDictionary<string, Byte>;
  protected
    procedure PrepareComments(const aCommentType: TCommentType);


  public
    constructor Create(const aProjectName,aSelectedDelphiVersion : string);
    destructor Destroy; override;
    function GetFullUnitName(): string;
    procedure StoreExcludedUnits(aExclUnits: String);
    function IsAnExcludedUnit(const aUnitName : string):boolean;
    property prAPIIntro: string read fAPIIntro;
    property prMissingUnitNames : TDictionary<String, Cardinal> read fMissingUnitNames;
    property prConditStart: string read fConditStart;
    property prConditStartUses: string read fConditStartUses;
    property prConditStartAPI: string read fConditStartAPI;
    property prConditEnd: string read fConditEnd;
    property prConditEndUses: string read fConditEndUses;
    property prConditEndAPI: string read fConditEndAPI;
    property prNameThreadForDebugging: string read fNameThreadForDebugging;
    property prAppendUses: string read fAppendUses;
    property prCreateUses: string read fCreateUses;
    // >> Modificado: 15/08/2023
    property prAppendUsesSysUtils: string read fAppendUsesSysUtils;
    property prCreateUsesSysUtils: string read fCreateUsesSysUtils;
    // << Modificado: 15/08/2023
    property prIntegratorEnterProcess: string read fIntegratorEnterProcess;
    property prIntegratorExitProcess: string read fIntegratorExitProcess;
    property prIntegratorEnterAsm: string read fIntegratorEnterAsm;
    property prIntegratorExitAsm: string read fIntegratorExitAsm;
    property prIntegratorAPI: string read fIntegratorAPI;
    property Name: string read fProjectName;
    property IsConsoleProject : boolean read fIsConsoleProject;
    property OutputDir : string read fOutputDir;
    property SearchPathes : TStringDynArray read fSearchPathes;
    property Namespaces : TStringDynArray read fNamespaces;

    function LocateOrCreateUnit(const unitName, unitLocation: string;const excluded: boolean): TBaseUnit; virtual; abstract;
  end;

implementation

uses
  System.SysUtils, System.StrUtils, GpString, gpProf.ProjectAccessor, gpProf.bdsVersions;

{ TBaseProject }

constructor TBaseProject.Create(const aProjectName, aSelectedDelphiVersion : string);
var
  LProjectAccessor : TProjectAccessor;
  i : Integer;
begin
  inherited Create();
  fProjectName := aProjectName;
  fSelectedDelphiVersion := aSelectedDelphiVersion;

  fMissingUnitNames := TDictionary<String, Cardinal>.Create;
  fExcludedUnitDict := TDictionary<string, Byte>.Create();
  LProjectAccessor := nil;
  try
    LProjectAccessor := TProjectAccessor.Create(fProjectName);
    fIsConsoleProject := LProjectAccessor.IsConsoleProject(true);
    fOutputDir := LProjectAccessor.GetOutputDir(ProductNameToProductVersion(aSelectedDelphiVersion));
    fSearchPathes := SplitString(LProjectAccessor.GetSearchPath(aSelectedDelphiVersion), ';');
    fNamespaces := SplitString(LProjectAccessor.GetNamespaces(aSelectedDelphiVersion), ';');
    for i := Low(fSearchPathes) to high(fSearchPathes) do
      fSearchPathes[i] := Trim(fSearchPathes[i]);
    for i := Low(fNamespaces) to high(fNamespaces) do
      fNamespaces[i] := Trim(fNamespaces[i]);
  finally
    LProjectAccessor.free;
  end;
end;

destructor TBaseProject.Destroy;
begin
  fMissingUnitNames.free;
  fExcludedUnitDict.Free;
  inherited;
end;

function TBaseProject.GetFullUnitName: string;
begin
  result := fFullUnitName;
end;

function TBaseProject.IsAnExcludedUnit(const aUnitName: string): boolean;
begin
  result := fExcludedUnitDict.ContainsKey(UpperCase(aUnitName));
end;

procedure TBaseProject.PrepareComments(const aCommentType: TCommentType);
begin
  case aCommentType of
    Ct_Arrow:
      begin
        fConditStart := '{>>BWIntegrator}';
        fConditStartUses := '{>>BWIntegrator U}';
        fConditStartAPI := '{>>BWIntegrator API}';
        // >> Modificado: 11/07/2024
        fConditEnd := '{BWIntegrator<<}';
        fConditEndUses := '{BWIntegrator U<<}';
        fConditEndAPI := '{BWIntegrator API<<}';
        // << Modificado: 11/07/2024
      end;
    Ct_IfDef:
      begin
        fConditStart := '{$IFDEF BWIntegrator}';
        fConditStartUses := '{$IFDEF BWIntegrator U}';
        fConditStartAPI := '{$IFDEF BWIntegrator API}';
        fConditEnd := '{$ENDIF BWIntegrator}';
        fConditEndUses := '{$ENDIF BWIntegrator U}';
        fConditEndAPI := '{$ENDIF BWIntegrator API}';
      end;
  end;
  fAppendUses := prConditStartUses + ' ' + cProfUnitName + ', ' + prConditEndUses;
  fCreateUses := prConditStartUses + ' uses ' + cProfUnitName + '; ' + prConditEndUses;
  // >> Modificado: 15/08/2023
  fAppendUsesSysUtils := prConditStartUses + ' ' + cProfUnitName + ', ' + cProfUnitSysUtils + ', ' + prConditEndUses;
  fCreateUsesSysUtils := prConditStartUses + ' uses ' + cProfUnitName + ', ' + cProfUnitSysUtils + '; ' + prConditEndUses;
  // << Modificado: 15/08/2023
  // >> Modificado: 07/07/2023
//  fProfileEnterProc := prConditStart + ' ' + 'ProfilerEnterProc(%d); try ' + prConditEnd;
  fIntegratorEnterProcess := prConditStart + ' ' + 'IntegratorEnterProcess(%d); try try ' + prConditEnd;
//  fProfileExitProc := prConditStart + ' finally ProfilerExitProc(%d); end; ' + prConditEnd;
//  fIntegratorExitProc := prConditStart + ' finally IntegratorExitProc(%d); end; except on e: Exception do begin IntegratorHandleException(%d, e); raise e; end; end; ' + prConditEnd;
  // << Modificado: 07/07/2023
  // >> Modificado: 08/08/2023
  fIntegratorExitProcess := prConditStart + ' finally IntegratorExitProcess(%d); end; except on e: Exception do begin IntegratorHandleException(%d, e); end; end; ' + prConditEnd;
  // << Modificado: 08/08/2023
  fIntegratorEnterAsm := prConditStart +
    ' pushad; mov eax, %d; call IntegratorEnterProcess; popad ' + prConditEnd;
  fIntegratorExitAsm := prConditStart +
    ' push eax; mov eax, %d; call IntegratorExitProcess; pop eax ' + prConditEnd;
  fIntegratorAPI := prConditStartAPI + '%s' + prConditEndAPI;
  fAPIIntro := 'GPP:';
  fNameThreadForDebugging := 'namethreadfordebugging';
end;

procedure TBaseProject.StoreExcludedUnits(aExclUnits: String);
var
  LExcludedList : TStringList;
  i : Integer;
begin
  if Last(aExclUnits, 2) <> #13#10 then
    aExclUnits := aExclUnits + #13#10;
  if First(aExclUnits, 2) <> #13#10 then
    aExclUnits := #13#10 + aExclUnits;
  LExcludedList := TStringList.Create();
  LExcludedList.Duplicates := TDuplicates.dupIgnore;
  LExcludedList.CaseSensitive := false;
  LExcludedList.SetText(PWideChar(aExclUnits));
  for i := 0 to LExcludedList.Count -1 do
  begin
    if Length(Trim(LExcludedList[i])) = 0 then
      Continue;
    fExcludedUnitDict.AddOrSetValue(UpperCase(LExcludedList[i]),0);
  end;
  LExcludedList.Free;
end;

{ TProject.PrepareComments }


end.
