unit uIBXConnection;

{$I Redsis.inc}

interface

uses
  Classes{$IFDEF VER150}, IBDatabase {$ELSE}, IBX.IBDatabase{$ENDIF};

type
  TRDConnectionCustom = class(TIBDatabase)
  private
    {$IFDEF VER150}
    FServerType: String;
    {$ENDIF}
    FSQLDialect: integer;
    FDriverName: string;
    procedure SetDriverName(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ExecSQL(ASQL: string);
  published
    {$IFDEF VER150}
    property ServerType : String read FServerType write FServerType;
    {$ENDIF}
    property DriverName: string read FDriverName write SetDriverName;
  end;

implementation

uses
  IBX.IBQuery, System.SysUtils;

constructor TRDConnectionCustom.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF VER150}
    FServerType := 'IBServer';
  {$ENDIF}
  Self.DriverName := 'FB';
  Self.Params.Clear;
  Self.Params.Add('USER_NAME=SYSDBA');
  Self.Params.Add('PASSWORD=masterkey');
end;


destructor TRDConnectionCustom.Destroy;
begin
  inherited Destroy;
end;

procedure TRDConnectionCustom.ExecSQL(ASQL: string);
var
  IBQuery: TIBQuery;
begin
  try
    IBQuery := TIBQuery.Create(nil);
    IBQuery.Database := Self;
    IBQuery.SQL.Text := ASQL;
    IBQuery.ExecSQL;
  finally
    IBQuery.Free;
  end;
end;

procedure TRDConnectionCustom.SetDriverName(const Value: string);
begin
  FDriverName := Value;
end;

//

end.

