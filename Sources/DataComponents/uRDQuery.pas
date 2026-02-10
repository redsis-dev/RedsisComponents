unit uRDQuery;

{$I Redsis.inc}

interface

uses
{$IFDEF FDC}
  uFDCQuery,
{$ENDIF}
{$IFDEF Firedac}
  uFiredacQuery,
{$ENDIF}
{$IFDEF IBX}
  uIBXQuery,
{$ENDIF}
//{$IFDEF RDW}
//  uRDWQuery,
//{$ENDIF}
  Classes;

type
  TRDQuery = class(TRDQueryCustom)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TRDCustomQuery = TRDQuery;

implementation

{ TRDQuery }

constructor TRDQuery.Create(AOwner: TComponent);
begin
  inherited;
  ParamCheck := True;
end;

end.

