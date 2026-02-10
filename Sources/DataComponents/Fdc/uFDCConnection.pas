unit uFDCConnection;

interface

uses
{$IFDEF VCL}
  FireDAC.VCLUI.Wait,
{$ELSE}
  FireDAC.FMXUI.Wait,
{$ENDIF}
  System.Classes, System.SysUtils, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  Data.DB, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FBDef, FireDAC.Comp.UI, FireDAC.Phys.IBBase,
  FireDAC.Phys.FB, FireDAC.Comp.Client;

type
  TRDConnectionCustom = class(TFDConnection)
  private
    FDatabaseName: string;
    FSQLDialect: Integer;
    FTimeOutConexao: Integer;
    function GetDatabaseName: string;
    procedure MyRecover(ASender, AInitiator: TObject; AException: Exception; var AAction: TFDPhysConnectionRecoverAction);
    procedure MyRestored(Sender: TObject);
    procedure SetDatabaseName(const Value: string);
    procedure SetSQLDialect(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoConnect; override;
  published
    property DatabaseName: string read GetDatabaseName write SetDatabaseName;
    property SQLDialect: Integer read FSQLDialect write SetSQLDialect default 1;
  end;

implementation

{ TRDConnectionCustom }

constructor TRDConnectionCustom.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LoginPrompt := False;
  OnRecover := MyRecover;
  OnRestored := MyRestored;
  FTimeOutConexao := 0;
  Params.Clear;
  Params.Add('User_Name=SYSDBA');
  Params.Add('Password=masterkey');
  SQLDialect := 1;
  DriverName := 'FB';
end;

procedure TRDConnectionCustom.DoConnect;
begin
  Params.Values['Database'] := DatabaseName;
  Params.Values['DriverID'] := DriverName;
  Params.Values['SQLDialect'] := IntToStr(SQLDialect);
  inherited;
end;

function TRDConnectionCustom.GetDatabaseName: string;
begin
  if FDatabaseName = '' then
    FDatabaseName := Params.Values['Database'];
  Result := FDatabaseName;
end;

procedure TRDConnectionCustom.MyRecover(ASender, AInitiator: TObject;
  AException: Exception; var AAction: TFDPhysConnectionRecoverAction);
begin
  FTimeOutConexao := FTimeOutConexao + 1;
  AAction := faRetry;
end;

procedure TRDConnectionCustom.MyRestored(Sender: TObject);
begin
  FTimeOutConexao := 0;
end;

procedure TRDConnectionCustom.SetDatabaseName(const Value: string);
begin
  FDatabaseName := Value;
end;

procedure TRDConnectionCustom.SetSQLDialect(const Value: Integer);
begin
  FSQLDialect := Value;
end;

end.
