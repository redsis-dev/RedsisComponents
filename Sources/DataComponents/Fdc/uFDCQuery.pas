unit uFDCQuery;

interface

uses
  System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  uRDConnection, System.SysUtils;

type
  TRDQueryCustom = class(TFDQuery)
  private
    FParamCheck: Boolean;
    FBufferChunks: Integer;
    FExternalSQLAdapter: TFunc<string, string>;
    procedure SetParamCheck(const Value: Boolean);
    procedure SetBufferChunks(const Value: Integer);
    procedure SetDatabase(const Value: TRDConnection);
    function GetDatabase: TRDConnection;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoBeforeOpen; override;
    procedure SetFilterText(const Value: string); override;
  published
    property BufferChunks: Integer read FBufferChunks write SetBufferChunks default 0;
    property Database: TRDConnection read GetDatabase write SetDatabase;
    property ParamCheck: Boolean read FParamCheck write SetParamCheck;
    property ExternalSQLAdapter: TFunc<string, string> read FExternalSQLAdapter write FExternalSQLAdapter;
  end;

implementation

{ TRDQueryCustom }

uses uLib;

constructor TRDQueryCustom.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TRDQueryCustom.DoBeforeOpen;
begin
  inherited;
  Connection := TFDConnection(Database);
  SQL.Text := TRDLib.SQLAdapter(SQL.Text, Connection.DriverName, Connection.Params.Values['DataBase']);

  if Assigned(FExternalSQLAdapter) then
    SQL.Text := FExternalSQLAdapter(SQL.Text);
end;

function TRDQueryCustom.GetDatabase: TRDConnection;
begin
  Result := TRDConnection(Connection);
end;

procedure TRDQueryCustom.SetBufferChunks(const Value: Integer);
begin
  FBufferChunks := Value;
end;

procedure TRDQueryCustom.SetDatabase(const Value: TRDConnection);
begin
  Connection := TFDConnection(Value);
end;

procedure TRDQueryCustom.SetFilterText(const Value: string);
begin
  inherited SetFilterText(StringReplace(Value, '"', #39, [rfReplaceAll]));
end;

procedure TRDQueryCustom.SetParamCheck(const Value: Boolean);
begin
  FParamCheck := Value;
end;

end.
