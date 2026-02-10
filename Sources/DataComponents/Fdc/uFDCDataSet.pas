unit uFDCDataSet;

interface

uses
  Data.DB, uRDConnection, uRDTransaction, uFDCQuery, System.Classes,
  FireDAC.Comp.Client;

type
  TRDDataSetCustom = class(TRDQueryCustom)
  private
    FUpdateSQL: TFDUpdateSQL;
    FBufferChunks: Integer;
    FCachedUpdates: Boolean;
    FParamCheck: Boolean;
    FTransaction: TRDTransaction;
    FUnidirectional: Boolean;
    function GetSelectSQL: TStrings;
    procedure SetBufferChunks(const Value: Integer);
    procedure SetCachedUpdates(const Value: Boolean);
    procedure SetDatabase(const Value: TRDConnection);
    procedure SetDeleteSQL(const Value: TStrings);
    procedure SetInsertSQL(const Value: TStrings);
    procedure SetModifySQL(const Value: TStrings);
    procedure SetParamCheck(const Value: Boolean);
    procedure SetRefreshSQL(const Value: TStrings);
    procedure SetSelectSQL(const Value: TStrings);
    procedure SetTransaction(const Value: TRDTransaction);
    procedure SetUnidirectional(const Value: Boolean);
    function GetDatabase: TRDConnection;
    function GetInsertSQL: TStrings;
    function GetModifySQL: TStrings;
    function GetRefreshSQL: TStrings;
    function GetDeleteSQL: TStrings;
  protected
    procedure DoBeforeOpen; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property BufferChunks: Integer read FBufferChunks write SetBufferChunks;
    property CachedUpdates: Boolean read FCachedUpdates write SetCachedUpdates;
    property Database: TRDConnection read GetDatabase write SetDatabase;
    property DeleteSQL: TStrings read GetDeleteSQL write SetDeleteSQL;
    property InsertSQL: TStrings read GetInsertSQL write SetInsertSQL;
    property ModifySQL: TStrings read GetModifySQL write SetModifySQL;
    property ParamCheck: Boolean read FParamCheck write SetParamCheck;
    property RefreshSQL: TStrings read GetRefreshSQL write SetRefreshSQL;
    property SelectSQL: TStrings read GetSelectSQL write SetSelectSQL;
    property Transaction: TRDTransaction read FTransaction write SetTransaction;
    property Unidirectional: Boolean read FUnidirectional write SetUnidirectional;
  end;

implementation

{ TRDDataSetCustom }

uses uLib, System.SysUtils;

constructor TRDDataSetCustom.Create(AOwner: TComponent);
begin
  inherited;
  ParamCheck := True;
  FUpdateSQL := TFDUpdateSQL.Create(Self);
  UpdateObject := FUpdateSQL;
end;

destructor TRDDataSetCustom.Destroy;
begin
  FreeAndNil(FUpdateSQL);
  inherited;
end;

procedure TRDDataSetCustom.DoBeforeOpen;
begin
  SQL.Text := TRDLib.SQLAdapter(SQL.Text, Connection.DriverName, Connection.Params.Values['DataBase']);
  inherited;
  FUpdateSQL.Connection := Connection;
end;

function TRDDataSetCustom.GetDatabase: TRDConnection;
begin
  Result := TRDConnection(Connection);
end;

function TRDDataSetCustom.GetDeleteSQL: TStrings;
begin
  Result := FUpdateSQL.DeleteSQL;
end;

function TRDDataSetCustom.GetInsertSQL: TStrings;
begin
  Result := FUpdateSQL.InsertSQL;
end;

function TRDDataSetCustom.GetModifySQL: TStrings;
begin
  Result := FUpdateSQL.ModifySQL;
end;

function TRDDataSetCustom.GetRefreshSQL: TStrings;
begin
  Result := FUpdateSQL.FetchRowSQL;
end;

function TRDDataSetCustom.GetSelectSQL: TStrings;
begin
  Result := SQL;
end;

procedure TRDDataSetCustom.SetBufferChunks(const Value: Integer);
begin
  FBufferChunks := Value;
end;

procedure TRDDataSetCustom.SetCachedUpdates(const Value: Boolean);
begin
  FCachedUpdates := Value;
end;

procedure TRDDataSetCustom.SetDatabase(const Value: TRDConnection);
begin
  Connection := TFDConnection(Value);
end;

procedure TRDDataSetCustom.SetDeleteSQL(const Value: TStrings);
begin
  FUpdateSQL.DeleteSQL := Value;
end;

procedure TRDDataSetCustom.SetInsertSQL(const Value: TStrings);
begin
  FUpdateSQL.InsertSQL := Value;
end;

procedure TRDDataSetCustom.SetModifySQL(const Value: TStrings);
begin
  FUpdateSQL.ModifySQL := Value;
end;

procedure TRDDataSetCustom.SetParamCheck(const Value: Boolean);
begin
  FParamCheck := Value;
end;

procedure TRDDataSetCustom.SetRefreshSQL(const Value: TStrings);
begin
  FUpdateSQL.FetchRowSQL := Value;
end;

procedure TRDDataSetCustom.SetSelectSQL(const Value: TStrings);
begin
  SQL := Value;
end;

procedure TRDDataSetCustom.SetTransaction(const Value: TRDTransaction);
begin
  FTransaction := Value;
end;

procedure TRDDataSetCustom.SetUnidirectional(const Value: Boolean);
begin
  FUnidirectional := Value;
end;

end.
