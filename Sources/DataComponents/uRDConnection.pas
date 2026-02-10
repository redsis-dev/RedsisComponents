unit uRDConnection;

{$I Redsis.inc}

interface

uses
{$IFDEF FDC}
  uFDCConnection,
{$ENDIF}
{$IFDEF Firedac}
  uFiredacConnection,
{$ENDIF}
{$IFDEF IBX}
  uIBXConnection,
{$ENDIF}
//{$IFDEF RDW}
//  uRDWConnection,
//{$ENDIF}
  Classes, uLib;

type
  TRDConnection = class(TRDConnectionCustom)
  public
    constructor Create(AOwner: TComponent); override;
    procedure ExecuteDirect(SQL: string);
  end;

implementation

{ TRDConnection }

constructor TRDConnection.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TRDConnection.ExecuteDirect(SQL: string);
begin
  SQL := TRDLib.SQLAdapter(SQL, Self.DriverName, Self.DatabaseName);
  Self.ExecSQL(SQL);
end;

end.
