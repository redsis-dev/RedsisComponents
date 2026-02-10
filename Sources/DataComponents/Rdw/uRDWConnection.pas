unit uRDWConnection;

interface

uses
  System.Classes, uRESTDWPoolerDB;

type
  TRDConnectionCustom = class(TRESTDWDataBase)
  strict protected
    procedure RESTDWBeforeConnect(Sender: TComponent); virtual;
  private
    FDatabaseName: string;
    FDriverName: string;
    FLoginPrompt: Boolean;
    FSQLDialect: Integer;
    function GetDatabaseName: string;
    procedure SetDatabaseName(const Value: string);
    procedure SetDriverName(const Value: string);
    procedure SetLoginPrompt(const Value: Boolean);
    procedure SetSQLDialect(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    procedure ExecSQL(ASQL: string);
  published
    property DatabaseName: string read GetDatabaseName write SetDatabaseName;
    property DriverName: string read FDriverName write SetDriverName;
    property LoginPrompt: Boolean read FLoginPrompt write SetLoginPrompt;
    property SQLDialect: Integer read FSQLDialect write SetSQLDialect;
  end;

implementation

uses
  ServerUtils, System.SysUtils, Data.DB, uDWJSONObject, uDWPoolerMethod;

{ TRDConnectionCustom }

constructor TRDConnectionCustom.Create(AOwner: TComponent);
begin
  inherited;
  OnBeforeConnect := RESTDWBeforeConnect;
end;

procedure TRDConnectionCustom.ExecSQL(ASQL: string);
var
  slSQL: TStringList;
  arrParams: TParams;
  bErro: Boolean;
  xErro: string;
  jsValue: TJSONValue;
  iRows: Integer;
  PoolerMethodClient: TDWPoolerMethodClient;
begin
  try
    slSQL := TStringList.Create;
    slSQL.Add(ASQL);
    Self.ExecuteCommand(PoolerMethodClient, slSQL, arrParams, bErro, xErro, jsValue, iRows);
  finally
    FreeAndNil(slSQL);
  end;
end;

function TRDConnectionCustom.GetDatabaseName: string;
begin
  if FDatabaseName = '' then
    FDatabaseName := PoolerService + ':' + IntToStr(PoolerPort);
  Result := FDatabaseName;
end;

procedure TRDConnectionCustom.RESTDWBeforeConnect(Sender: TComponent);
begin
  AuthenticationOptions.AuthorizationOption := rdwAOBasic;
  TRDWAuthOptionBasic(AuthenticationOptions.OptionParams).Username := 'redsis';
  TRDWAuthOptionBasic(AuthenticationOptions.OptionParams).Password := 'C9F4ACBC-6B6A-4CA5-95E2-83164BC91C09';
  Context := 'redsisdw';
  DriverName := 'FB';
  PoolerName := 'TDM_Server.RESTDWPoolerDBRedsis';
  PoolerService := Copy(DatabaseName, 0, Pos(':', DatabaseName) - 1);
  PoolerPort := StrToInt(Copy(DatabaseName, Pos(':', DatabaseName) + 1, Length(DatabaseName)));
end;

procedure TRDConnectionCustom.SetDatabaseName(const Value: string);
begin
  FDatabaseName := Value;
end;

procedure TRDConnectionCustom.SetDriverName(const Value: string);
begin
  FDriverName := Value;
end;

procedure TRDConnectionCustom.SetLoginPrompt(const Value: Boolean);
begin
  FLoginPrompt := Value;
end;

procedure TRDConnectionCustom.SetSQLDialect(const Value: Integer);
begin
  FSQLDialect := Value;
end;

end.
