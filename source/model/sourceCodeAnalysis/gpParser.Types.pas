unit gpParser.Types;

interface

uses
  System.SysUtils;

type
  // Do not change order
  TCommentType = (Ct_Arrow = 0, Ct_IfDef = 1);

  // class TBaseUnit is needed for decoupling unit references between TProject and TUnit
  TBaseUnit = class(tobject);
  EUnitInSearchPathNotFoundError = class(Exception);

const
  cProfUnitName = 'bwIntegrator';
  cProfUnitSysUtils = 'System.SysUtils';


implementation

end.
